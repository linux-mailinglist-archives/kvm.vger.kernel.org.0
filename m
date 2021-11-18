Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859494561ED
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 19:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhKRSHr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 13:07:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:56953 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229997AbhKRSHr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 13:07:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637258686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o1StevES6LFcxzq9JDjfXql1NL6xb4MMT2aPM+84e4g=;
        b=ONmuSn7Zu/jEiwSqNXJ8vLn5yF2+dLLDaN9XHayKNQx01NjJUR9LcwZtaSJkOMkkkDNzDK
        pC2mRDL8dlWDeNdwv4yU4THXJzz67CKetWp+A5MqzJPmPQ95Q+a4i+9TGZwgH38bfXoZpu
        G40SD8FmYm0J9JPvHb6kXSQ+TaNOwjc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-UDZOTr8sOcmcdfUFsHXRwA-1; Thu, 18 Nov 2021 13:04:43 -0500
X-MC-Unique: UDZOTr8sOcmcdfUFsHXRwA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00533804143;
        Thu, 18 Nov 2021 18:04:41 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D92384ABA3;
        Thu, 18 Nov 2021 18:04:37 +0000 (UTC)
Message-ID: <c09eaa85-21c8-eb67-fe2f-9ea028e846f2@redhat.com>
Date:   Thu, 18 Nov 2021 19:04:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC 07/19] KVM: x86/mmu: Factor wrprot for nested PML out of
 make_spte
Content-Language: en-US
To:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
References: <20211110223010.1392399-1-bgardon@google.com>
 <20211110223010.1392399-8-bgardon@google.com> <YZW2i7GnORD+X5NT@google.com>
 <CANgfPd-f+VXQJnz-LPuiy+rTDkSdw3zjUfozaqzgb8n0rv9STA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CANgfPd-f+VXQJnz-LPuiy+rTDkSdw3zjUfozaqzgb8n0rv9STA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/18/21 18:43, Ben Gardon wrote:
>> Aha!  The dependency on @vcpu can be avoided without having to take a flag from
>> the caller.  The shadow page has everything we need.  The check is really "is this
>> a page for L2 EPT".  The kvm_x86_ops.cpu_dirty_log_size gets us the EPT part, and
>> kvm_mmu_page.guest_mode gets us the L2 part.
>
> Haha that's way cleaner than what I was doing! Seems like an obvious
> solution in retrospect. I'll include this in the next version of the
> series I send out unless Paolo beats me and just merges it directly.
> Happy to give this my reviewed-by.

Yeah, I am including the early cleanup parts because it makes no sense
to hold off on them; and Sean's patch qualifies as well.

I can't blame you for not remembering role.guest_mode.  Jim added it for
a decidedly niche reason:

     commit 1313cc2bd8f6568dd8801feef446afbe43e6d313
     Author: Jim Mattson <jmattson@google.com>
     Date:   Wed May 9 17:02:04 2018 -0400

     kvm: mmu: Add guest_mode to kvm_mmu_page_role
     
     L1 and L2 need to have disjoint mappings, so that L1's APIC access
     page (under VMX) can be omitted from L2's mappings.
     
     Signed-off-by: Jim Mattson <jmattson@google.com>
     Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

though it's actually gotten a lot more important than just that:

     commit 992edeaefed682511bd173dabd2f54b1ce5387df
     Author: Liran Alon <liran.alon@oracle.com>
     Date:   Wed Nov 20 14:24:52 2019 +0200

     KVM: nVMX: Assume TLB entries of L1 and L2 are tagged differently if L0 use EPT
     
     Since commit 1313cc2bd8f6 ("kvm: mmu: Add guest_mode to kvm_mmu_page_role"),
     guest_mode was added to mmu-role and therefore if L0 use EPT, it will
     always run L1 and L2 with different EPTP. i.e. EPTP01!=EPTP02.
     
     Because TLB entries are tagged with EP4TA, KVM can assume
     TLB entries populated while running L2 are tagged differently
     than TLB entries populated while running L1.

Paolo

