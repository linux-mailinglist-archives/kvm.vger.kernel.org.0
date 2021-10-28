Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E43943E331
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 16:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhJ1OOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 10:14:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45190 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230195AbhJ1OOE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 10:14:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635430297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h0GXefhhJUnCgkq2ZwFnKAvVnlC9+rx+kpkxo0P4nEo=;
        b=YFOeY6gwpyj5rpsPBcIFaZmJ/5eovnjY4lErn3kip+AbyTcmORdkWOOhvan9Yotsh0X3cX
        kaARnz+9u6VnfFVDzl5e6oIaSxXBB2otvfRHlqyqMVakh5VSCpvpnYDQv1pSbZ5IblNW4R
        GzflLo1U/nuvtO0EQ4dxxpLSuX6mWQI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-T90TH1O_PxWw9BBoBuzXmA-1; Thu, 28 Oct 2021 10:11:35 -0400
X-MC-Unique: T90TH1O_PxWw9BBoBuzXmA-1
Received: by mail-ed1-f71.google.com with SMTP id h16-20020a05640250d000b003dd8167857aso5786511edb.0
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 07:11:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=h0GXefhhJUnCgkq2ZwFnKAvVnlC9+rx+kpkxo0P4nEo=;
        b=tMk1y7yIfRUiwKBOvO++uGVN/162bGFEt9SUSsM28auGsDVt6lTyQycmqVZuQIbDzR
         ooy2+cMU7HcVv7EqR+RGxC66Ttv+ww3ExxXzPlROqsNj2FUifoszni6GH0+RD0xPdmEP
         adszxMK5X73JCdfJCdaIuDHFTtGvE504c3WmxuxwUjh1STZ0BCGhNoto03ZF714GEMB5
         n9brFsZk6NIQY80N48gVgH3Wh75yGwqJI/p6MgWm+7A7tX6kTrr03ioTGICkgvmvws1P
         oWPczZcMSDIBkGBbDY0PbhrLWoBuFi+9x3rSFLcZjd5aBsn3Z3xo2avKCqYCfthilp+O
         abtA==
X-Gm-Message-State: AOAM533BzMkjhKsXF0GIWKKXakCdWYHvKhS8Qm6BEpIWDejgMbc23ATR
        NawjUAlXOGe1FsSVrndRNo/OPSbmvR/MGuP8zUePxJTnzp730h7ehxQnNdrUS8FJvcBDPisro/I
        pXXKWPKg2gPgO
X-Received: by 2002:a17:906:1601:: with SMTP id m1mr5764404ejd.117.1635430294604;
        Thu, 28 Oct 2021 07:11:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9QBEnfbezC1HH0O2eDnjTu+hAznbu7Jj/itP3lJegZREZqKxX186pW2BSBakd5XZ3mAoPbA==
X-Received: by 2002:a17:906:1601:: with SMTP id m1mr5764368ejd.117.1635430294347;
        Thu, 28 Oct 2021 07:11:34 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id go16sm1443205ejc.23.2021.10.28.07.11.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 07:11:33 -0700 (PDT)
Message-ID: <15750c83-5698-02dd-58f9-784aadde36b9@redhat.com>
Date:   Thu, 28 Oct 2021 16:11:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: x86: Take srcu lock in post_kvm_run_save()
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, mtosatti <mtosatti@redhat.com>
References: <606aaaf29fca3850a63aa4499826104e77a72346.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <606aaaf29fca3850a63aa4499826104e77a72346.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/10/21 05:12, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The Xen interrupt injection for event channels relies on accessing the
> guest's vcpu_info structure in __kvm_xen_has_interrupt(), through a
> gfn_to_hva_cache.
> 
> This requires the srcu lock to be held, which is mostly the case except
> for this code path:
> 
> [   11.822877] WARNING: suspicious RCU usage
> [   11.822965] -----------------------------
> [   11.823013] include/linux/kvm_host.h:664 suspicious rcu_dereference_check() usage!
> [   11.823131]
> [   11.823131] other info that might help us debug this:
> [   11.823131]
> [   11.823196]
> [   11.823196] rcu_scheduler_active = 2, debug_locks = 1
> [   11.823253] 1 lock held by dom:0/90:
> [   11.823292]  #0: ffff998956ec8118 (&vcpu->mutex){+.+.}, at: kvm_vcpu_ioctl+0x85/0x680
> [   11.823379]
> [   11.823379] stack backtrace:
> [   11.823428] CPU: 2 PID: 90 Comm: dom:0 Kdump: loaded Not tainted 5.4.34+ #5
> [   11.823496] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
> [   11.823612] Call Trace:
> [   11.823645]  dump_stack+0x7a/0xa5
> [   11.823681]  lockdep_rcu_suspicious+0xc5/0x100
> [   11.823726]  __kvm_xen_has_interrupt+0x179/0x190
> [   11.823773]  kvm_cpu_has_extint+0x6d/0x90
> [   11.823813]  kvm_cpu_accept_dm_intr+0xd/0x40
> [   11.823853]  kvm_vcpu_ready_for_interrupt_injection+0x20/0x30
>                < post_kvm_run_save() inlined here >
> [   11.823906]  kvm_arch_vcpu_ioctl_run+0x135/0x6a0
> [   11.823947]  kvm_vcpu_ioctl+0x263/0x680
> 
> Fixes: 40da8ccd724f ("KVM: x86/xen: Add event channel interrupt vector upcall")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
> 
> There are potentially other ways of doing this, by shuffling the tail
> of kvm_arch_vcpu_ioctl_run() around a little and holding the lock once
> there instead of taking it within vcpu_run(). But the call to
> post_kvm_run_save() occurs even on the error paths, and it gets complex
> to untangle. This is the simple approach.
> 
> This doesn't show up when I enable event channel delivery in
> xen_shinfo_test because we have pic_in_kernel() there. I'll fix the
> tests not to hardcode that, as I expand the event channel support and
> add more testing of it.

Queued for 5.15, thanks.

Paolo

>   arch/x86/kvm/x86.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f0874c3d12ce..cd42d58008f7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8783,9 +8783,17 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
>   
>   	kvm_run->cr8 = kvm_get_cr8(vcpu);
>   	kvm_run->apic_base = kvm_get_apic_base(vcpu);
> +
> +	/*
> +	 * The call to kvm_ready_for_interrupt_injection() may end up in
> +	 * kvm_xen_has_interrupt() which may require the srcu lock to be
> +	 * held to protect against changes in the vcpu_info address.
> +	 */
> +	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
>   	kvm_run->ready_for_interrupt_injection =
>   		pic_in_kernel(vcpu->kvm) ||
>   		kvm_vcpu_ready_for_interrupt_injection(vcpu);
> +	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
>   
>   	if (is_smm(vcpu))
>   		kvm_run->flags |= KVM_RUN_X86_SMM;
> 

