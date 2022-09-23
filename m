Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD255E7A0C
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 13:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbiIWL5J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 07:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbiIWL5H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 07:57:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D040FEE1D
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 04:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663934225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4miBri3bJhR5OaFoUxgYoX/ss5biL8QmMasfztYCuX4=;
        b=bWCG5IBbamND2+1UlP1Qe7gI5d3LEyazkG5BN0dSIFaAe9nLVcFjFn+zjHYJ/gZfoUT/aE
        WEgQ+qTxfOktUyuLJBYlBdGbvfFRm68WtOT3NldGXQ4LKKEqTYaDH5GDbHav6sAaLTFdy7
        c/WO7z4p0MltZLhs1M0DO+gO6dciYo4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-118-gnesH1DcP0G33xwCnnjwIw-1; Fri, 23 Sep 2022 07:57:04 -0400
X-MC-Unique: gnesH1DcP0G33xwCnnjwIw-1
Received: by mail-wm1-f70.google.com with SMTP id p9-20020a05600c23c900b003b48dc0cef1so1723484wmb.1
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 04:57:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=4miBri3bJhR5OaFoUxgYoX/ss5biL8QmMasfztYCuX4=;
        b=3EXWnN1mvhHBRRvw1Mv7OqzLu66UfeUU2MK1b+aKIZceKzEQDNoVym9am8gWB56RVs
         ba4Gs1MHA4PVldQWhozmszM1byA0UaiHVox47KcOggGLKwg5+olDsSB9flYcUjITT1r8
         Nv1y5t2EE+i2p5kngzgy/gVZWIKYAWp468rv/ufkiJnuKHaOhs8Pcf6HsyD1ehZnfshv
         FaeA+GjiZYSlZrqzwr0i8pwQNzIKN4X6+1CPNW6NLF9hTfpiJW/gg2o6NhsL4xSAHMMT
         ASJyWUnhkZSfc+PHg2usRPeUYSc7C2ZfclLRhazOuzSBQ+Owf2Kaz0SF6FyGetDt3Lcw
         OijA==
X-Gm-Message-State: ACrzQf02hpo3fkU1kdi/SaKjWP0qnWE9vnppD6YjqTtXmG41irXsq1DT
        uA7zykxDaRdnodVx/yJ43fs96xjSG8nWKh4lSlNMh14T9K1EVfBPhtd7KJiTv7UGrR9PuCYy4/H
        DghIldzEyQNHp
X-Received: by 2002:a5d:5887:0:b0:22b:107e:7e39 with SMTP id n7-20020a5d5887000000b0022b107e7e39mr5155811wrf.694.1663934223058;
        Fri, 23 Sep 2022 04:57:03 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM47KtCY7OjlZi09YuqBLhLlMCLGbOE3dNReWbGbXGp3ENh5S0EFb/Vag6XNY3kRQj/zHsGi+A==
X-Received: by 2002:a5d:5887:0:b0:22b:107e:7e39 with SMTP id n7-20020a5d5887000000b0022b107e7e39mr5155795wrf.694.1663934222736;
        Fri, 23 Sep 2022 04:57:02 -0700 (PDT)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id q16-20020a1cf310000000b003a5fa79007fsm2345707wmq.7.2022.09.23.04.57.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 04:57:02 -0700 (PDT)
Message-ID: <da71648e-b501-dba2-a7f8-93d16ce6d833@redhat.com>
Date:   Fri, 23 Sep 2022 13:57:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: The root cause of failure of access_tracking_perf_test in a
 nested guest
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org,
        Sean Christopherson <seanjc@google.com>
References: <50dfe81bf95db91e6148b421740490c35c33233e.camel@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <50dfe81bf95db91e6148b421740490c35c33233e.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 23/09/2022 um 12:16 schrieb Maxim Levitsky:
> Hi!
> 
> Me and Emanuele Giuseppe Esposito were working on trying to understand why the access_tracking_perf_test
> fails when run in a nested guest on Intel, and I finally was able to find the root casue.
> 
> So the access_tracking_perf_test tests the following:
> 
> - It opens /sys/kernel/mm/page_idle/bitmap which is a special root read/writiable
> file which allows a process to set/clear the accessed bit in its page tables.
> the interface of this file is inverted, it is a bitmap of 'idle' bits
> Idle bit set === dirty bit is clear.
> 
> - It then runs a KVM guest, and checks that when the guest accesses its memory
> (through EPT/NPT), the accessed bits are still updated normally as seen from /sys/kernel/mm/page_idle/bitmap.
> 
> In particular it first clears the accesssed bit using /sys/kernel/mm/page_idle/bitmap,
> and then runs a guest which reads/writes all its memory, and then
> it checks that the accessed bit is set again by reading the /sys/kernel/mm/page_idle/bitmap.
> 
> 
> 
> Now since KVM uses its own paging (aka secondary MMU), mmu notifiers are used, and in particular
> - kvm_mmu_notifier_clear_flush_young
> - kvm_mmu_notifier_clear_young
> - kvm_mmu_notifier_test_young
> 
> First two clear the accessed bit from NPT/EPT, and the 3rd only checks its value.
> 
> The difference between the first two notifiers is that the first one flushes EPT/NPT,
> and the second one doesn't, and apparently the /sys/kernel/mm/page_idle/bitmap uses the second one.
> 
> This means that on the bare metal, the tlb might still have the accessed bit set, and thus
> it might not set it again in the PTE when a memory access is done through it.
> 
> There is a comment in kvm_mmu_notifier_clear_young about this inaccuracy, so this seems to be
> done on purpose.
> 
> I would like to hear your opinion on why it was done this way, and if the original reasons for
> not doing the tlb flush are still valid.
> 
> Now why the access_tracking_perf_test fails in a nested guest?
> It is because kvm shadow paging which is used to shadow the nested EPT, and it has a "TLB" which
> is not bounded by size, because it is stored in the unsync sptes in memory.
> 
> Because of this, when the guest clears the accessed bit in its nested EPT entries, KVM doesn't
> notice/intercept it and corresponding EPT sptes remain the same, thus later the guest access to
> the memory is not intercepted and because of this doesn't turn back
> the accessed bit in the guest EPT tables.
> 
> (If TLB flush were to happen, we would 'sync' the unsync sptes, by zapping them because we don't
> keep sptes for gptes with no accessed bit)

As suggested by Paolo, I also tried changing page_idle.c implementation so that it would call kvm_mmu_notifier_clear_flush_young instead of its non-flush counterpart: 

diff --git a/mm/page_idle.c b/mm/page_idle.c
index edead6a8a5f9..ffc1b0182534 100644
--- a/mm/page_idle.c
+++ b/mm/page_idle.c
@@ -62,10 +62,10 @@ static bool page_idle_clear_pte_refs_one(struct page *page,
                         * For PTE-mapped THP, one sub page is referenced,
                         * the whole THP is referenced.
                         */
-                       if (ptep_clear_young_notify(vma, addr, pvmw.pte))
+                       if (ptep_clear_flush_young_notify(vma, addr, pvmw.pte))
                                referenced = true;
                } else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
-                       if (pmdp_clear_young_notify(vma, addr, pvmw.pmd))
+                       if (pmdp_clear_flush_young_notify(vma, addr, pvmw.pmd))
                                referenced = true;
                } else {
                        /* unexpected pmd-mapped page? */

As expected, with the above patch the test does not fail anymore, proving Maxim's point.
As I understand an alternative was to get rid of the test? Or at least move it outside from kvm?

Thank you,
Emanuele

> 
> 
> Any comments are welcome!
> 
> If you think that the lack of the EPT flush is still the right thing to do,
> I vote again to have at least some form of a blacklist of selftests which
> are expected to fail, when run under KVM (fix_hypercall_test is the other test
> I already know that fails in a KVM guest, also without a practical way to fix it).
> 
> 
> Best regards,
> 	Maxim Levitsky
> 
> 
> PS: the test doesn't fail on AMD because we sync the nested NPT on each nested VM entry, which
> means that L0 syncs all the page tables.
> 
> Also the test sometimes passes on Intel when an unrelated TLB flush syncs the nested EPT.
> 
> Not using the new tdp_mmu also 'helps' by letting the test pass much more often but it still
> fails once in a while, likely because of timing and/or different implementation.
> 
> 
> 

