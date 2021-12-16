Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD7247762A
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 16:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235466AbhLPPmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 10:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbhLPPmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 10:42:40 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DD5C061574
        for <kvm@vger.kernel.org>; Thu, 16 Dec 2021 07:42:40 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id oa5-20020a17090b1bc500b001b0f8a5e6b7so7508594pjb.0
        for <kvm@vger.kernel.org>; Thu, 16 Dec 2021 07:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/HgC/51puoTDP7Sz4M6t3CwJhJDN9anfOwtdGH1jt60=;
        b=EZEwxVEb8Hl/hFm+bSg8gRmOe175UalkvX4GD1zqhytcHdk9px8OhlWAzGQZ+NF+3k
         ChjNCvM3FzBBHR5tzKdff7nufYeelHSAgD7lBcbNQrEpax+1sRXiFpN9mSqQ6KZ7URCF
         Q6ZNmgiGKlEM5NksnqZSChRpaznoaiVv79IfPvRcnJOHInPZjZX6FrL7SfC+5oGnjfiR
         18UrdSGGd+Ck+EZPLPa7bwshBcgoK/mNo021VTtUwemg1GCNX/pJfxqvDZG3D3M0JUtF
         tVCiDu9OQEvQeZFsqSgAXfqCs31HD6EkAVCjWO48Zplx0pj04AmZXTZkx+2KnBBq4vlB
         NWPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/HgC/51puoTDP7Sz4M6t3CwJhJDN9anfOwtdGH1jt60=;
        b=3VbE4Po5ib0aKBy19kr5IfIRIthngRGG+LvWS8YLLhXuLSBQfYDdCx5f0BGBO8DrET
         TLOGDc5JBY5w16ZzF4aNMx1FKefrxdeT5Q0p3nCWJzzRjfQkChghlHKRHFst704YbNWV
         /Qz0HL2aVw9tcvIsUa3b8jtr3/jqm90SeefK9HX/98zbQT3XU17Gm2aRNVQ3tlQJ6X6a
         EfbGuU26mUWVU7TiJK/cbCtzrkI0HFwoifV/G9ZKGO00BLieEx68N26BdCkvIBZCSgKO
         lWoR8dFrdxuZrfBA7C1yMdnCPIcsX5r43KVbCoevZN3zR4pCV142dZvG1Y88EX5278cN
         8g1Q==
X-Gm-Message-State: AOAM530q6JsjnN2uVaM0iFvZTRCrzfsYDHoE8iXXZzDoM/vljarZr+Kk
        WkoNYCznhKHweVfYBE8U6c30CQ==
X-Google-Smtp-Source: ABdhPJxb8j4O8CektzK4fHnZSpK4WpQQ9oZfAlyqSw/6OzoEoWaaDSfGs/zUXrUxZcY+RB8uCvxEkw==
X-Received: by 2002:a17:902:7089:b0:148:b897:daef with SMTP id z9-20020a170902708900b00148b897daefmr5711702plk.61.1639669359554;
        Thu, 16 Dec 2021 07:42:39 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p30sm2371272pfq.119.2021.12.16.07.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 07:42:38 -0800 (PST)
Date:   Thu, 16 Dec 2021 15:42:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Huangzhichao <huangzhichao@huawei.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: The vcpu won't be wakened for a long time
Message-ID: <Ybtea42RxZ9aVzCh@google.com>
References: <73d46f3cc46a499c8e39fdf704b2deaf@huawei.com>
 <YbjWFTtNo9Ap7kDp@google.com>
 <9e5aef1ae0c141e49c2b1d19692b9295@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e5aef1ae0c141e49c2b1d19692b9295@huawei.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 16, 2021, Longpeng (Mike, Cloud Infrastructure Service Product Dept.) wrote:
> > What kernel version?  There have been a variety of fixes/changes in the
> > area in recent kernels.
> 
> The kernel version is 4.18, and it seems the latest kernel also has this problem.
> 
> The following code can fixes this bug, I've tested it on 4.18.
> 
> (4.18)
> 
> @@ -3944,6 +3944,11 @@ static void vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
>         if (pi_test_and_set_on(&vmx->pi_desc))
>                 return;
>  
> +       if (swq_has_sleeper(kvm_arch_vcpu_wq(vcpu))) {
> +               kvm_vcpu_kick(vcpu);
> +               return;
> +       }
> +
>         if (vcpu != kvm_get_running_vcpu() &&
>                 !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
>                 kvm_vcpu_kick(vcpu);
> 
> 
> (latest)
> 
> @@ -3959,6 +3959,11 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
>         if (pi_test_and_set_on(&vmx->pi_desc))
>                 return 0;
>  
> +       if (rcuwait_active(&vcpu->wait)) {
> +               kvm_vcpu_kick(vcpu);
> +               return 0;
> +       }
> +
>         if (vcpu != kvm_get_running_vcpu() &&
>             !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
>                 kvm_vcpu_kick(vcpu);
> 
> Do you have any suggestions ?

Hmm, that strongly suggests the "vcpu != kvm_get_running_vcpu()" is at fault.
Can you try running with the below commit?  It's currently sitting in kvm/queue,
but not marked for stable because I didn't think it was possible for the check
to a cause a missed wake event in KVM's current code base.

commit 6a8110fea2c1b19711ac1ef718680dfd940363c6
Author: Sean Christopherson <seanjc@google.com>
Date:   Wed Dec 8 01:52:27 2021 +0000

    KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this vCPU

    Drop a check that guards triggering a posted interrupt on the currently
    running vCPU, and more importantly guards waking the target vCPU if
    triggering a posted interrupt fails because the vCPU isn't IN_GUEST_MODE.
    The "do nothing" logic when "vcpu == running_vcpu" works only because KVM
    doesn't have a path to ->deliver_posted_interrupt() from asynchronous
    context, e.g. if apic_timer_expired() were changed to always go down the
    posted interrupt path for APICv, or if the IN_GUEST_MODE check in
    kvm_use_posted_timer_interrupt() were dropped, and the hrtimer fired in
    kvm_vcpu_block() after the final kvm_vcpu_check_block() check, the vCPU
    would be scheduled() out without being awakened, i.e. would "miss" the
    timer interrupt.

    One could argue that invoking kvm_apic_local_deliver() from (soft) IRQ
    context for the current running vCPU should be illegal, but nothing in
    KVM actually enforces that rules.  There's also no strong obvious benefit
    to making such behavior illegal, e.g. checking IN_GUEST_MODE and calling
    kvm_vcpu_wake_up() is at worst marginally more costly than querying the
    current running vCPU.

    Lastly, this aligns the non-nested and nested usage of triggering posted
    interrupts, and will allow for additional cleanups.

    Signed-off-by: Sean Christopherson <seanjc@google.com>
    Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
    Message-Id: <20211208015236.1616697-18-seanjc@google.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 38749063da0e..f61a6348cffd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3995,8 +3995,7 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
         * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
         * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
         */
-       if (vcpu != kvm_get_running_vcpu() &&
-           !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
+       if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
                kvm_vcpu_wake_up(vcpu);

        return 0;
