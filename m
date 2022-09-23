Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB575E780A
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 12:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbiIWKQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 06:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiIWKQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 06:16:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88049DF399
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 03:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663928169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=u3PYvENyt8HxfyNNUDBeATDqucO/QCptsiVKIzXO4TY=;
        b=TT9o2+jVVSGjIGR93xXwyLhXXwhObq4v791SQcPF4zZeh+QtlsQ+iGS1omeSOPqMjO0WfU
        yos/dc8lhhomUft7Mk1LxTN5YYPcppSSsZYDOtmb7SFbK2+dbme82qu1aTC5q3XC7GnCBh
        D+RSgqQe1CgHSAc0N1NwCzzHUICN5h8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-ZUvhy9NCN2OSO6uHDsQXFg-1; Fri, 23 Sep 2022 06:16:07 -0400
X-MC-Unique: ZUvhy9NCN2OSO6uHDsQXFg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AADED29324AD;
        Fri, 23 Sep 2022 10:16:06 +0000 (UTC)
Received: from starship (unknown [10.40.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31ACF492CA2;
        Fri, 23 Sep 2022 10:16:05 +0000 (UTC)
Message-ID: <50dfe81bf95db91e6148b421740490c35c33233e.camel@redhat.com>
Subject: The root cause of failure of access_tracking_perf_test in a nested
 guest
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org,
        Sean Christopherson <seanjc@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Date:   Fri, 23 Sep 2022 13:16:04 +0300
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!

Me and Emanuele Giuseppe Esposito were working on trying to understand why the access_tracking_perf_test
fails when run in a nested guest on Intel, and I finally was able to find the root casue.

So the access_tracking_perf_test tests the following:

- It opens /sys/kernel/mm/page_idle/bitmap which is a special root read/writiable
file which allows a process to set/clear the accessed bit in its page tables.
the interface of this file is inverted, it is a bitmap of 'idle' bits
Idle bit set === dirty bit is clear.

- It then runs a KVM guest, and checks that when the guest accesses its memory
(through EPT/NPT), the accessed bits are still updated normally as seen from /sys/kernel/mm/page_idle/bitmap.

In particular it first clears the accesssed bit using /sys/kernel/mm/page_idle/bitmap,
and then runs a guest which reads/writes all its memory, and then
it checks that the accessed bit is set again by reading the /sys/kernel/mm/page_idle/bitmap.



Now since KVM uses its own paging (aka secondary MMU), mmu notifiers are used, and in particular
- kvm_mmu_notifier_clear_flush_young
- kvm_mmu_notifier_clear_young
- kvm_mmu_notifier_test_young

First two clear the accessed bit from NPT/EPT, and the 3rd only checks its value.

The difference between the first two notifiers is that the first one flushes EPT/NPT,
and the second one doesn't, and apparently the /sys/kernel/mm/page_idle/bitmap uses the second one.

This means that on the bare metal, the tlb might still have the accessed bit set, and thus
it might not set it again in the PTE when a memory access is done through it.

There is a comment in kvm_mmu_notifier_clear_young about this inaccuracy, so this seems to be
done on purpose.

I would like to hear your opinion on why it was done this way, and if the original reasons for
not doing the tlb flush are still valid.

Now why the access_tracking_perf_test fails in a nested guest?
It is because kvm shadow paging which is used to shadow the nested EPT, and it has a "TLB" which
is not bounded by size, because it is stored in the unsync sptes in memory.

Because of this, when the guest clears the accessed bit in its nested EPT entries, KVM doesn't
notice/intercept it and corresponding EPT sptes remain the same, thus later the guest access to
the memory is not intercepted and because of this doesn't turn back
the accessed bit in the guest EPT tables.

(If TLB flush were to happen, we would 'sync' the unsync sptes, by zapping them because we don't
keep sptes for gptes with no accessed bit)


Any comments are welcome!

If you think that the lack of the EPT flush is still the right thing to do,
I vote again to have at least some form of a blacklist of selftests which
are expected to fail, when run under KVM (fix_hypercall_test is the other test
I already know that fails in a KVM guest, also without a practical way to fix it).


Best regards,
	Maxim Levitsky


PS: the test doesn't fail on AMD because we sync the nested NPT on each nested VM entry, which
means that L0 syncs all the page tables.

Also the test sometimes passes on Intel when an unrelated TLB flush syncs the nested EPT.

Not using the new tdp_mmu also 'helps' by letting the test pass much more often but it still
fails once in a while, likely because of timing and/or different implementation.



