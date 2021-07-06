Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A1A3BD8E2
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhGFOur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:50:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232160AbhGFOuo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:50:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DC4qArPASg9VKe/un6fGGrjiEAFkjhgzz208Ggs2Zt8=;
        b=K/LjYp/QslPw2BYEzxo/Px+QjqiOfldDuX0Hvn0DeuXzFddeG1M8NUFGApPhe2VXHPuiXE
        aWi46D05ZnW55LxKuLEaiTDuTfGbke5kCMJG2JjhGm5LA2ndoN4YNpeJc5GA6xFdPDd7BH
        ZOKuhFcB0pO/ktzm2JXete9FwRKzoSc=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-QzmVW20SMaa0hmtO9UGkwA-1; Tue, 06 Jul 2021 09:59:51 -0400
X-MC-Unique: QzmVW20SMaa0hmtO9UGkwA-1
Received: by mail-ej1-f71.google.com with SMTP id my13-20020a1709065a4db02904dca50901ebso1560260ejc.12
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 06:59:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DC4qArPASg9VKe/un6fGGrjiEAFkjhgzz208Ggs2Zt8=;
        b=fC0G5TXY4VDpm2sUcOw31KCf+saRXwVWqX51ylMWOvLJSN2527ofcJTkIUKmujxiXD
         +CiBYsiEpCOCR6CNkTk8y+W7W8d14Zm/T89sszwyNvdQ5M1pWjkTSGytNKoeW99UTYBy
         lTGTIcemKCjeFxxU2YFGrN21KCA0r/VDo7Iu6yK3UJRgXKHorzUvjxbIposVgXtF5p0X
         wTtjwfMsxCU72379daw7xm09A3pt2ZATM12FM6AQSKOpdlRxDqk8rXjxkvaZzBr5Li2D
         HIi245tT697KziUb6Xr8cFz6oGmqucwAaL50irL1kY2vDKvtvgh8dF9Jglcca7RcMe7q
         r7HQ==
X-Gm-Message-State: AOAM532gVjama4mxVookolTvbF77pVbgNN9ejEZLvjb96agawhXTLaKf
        POQZJkhshsnb3WXfHh2QjcFBBtXxnnMRKEgEmEZRhkSIg6dVjm159F1LRuz/GgLMfeO4gih3BE6
        Qe06Fac6V4o+o
X-Received: by 2002:aa7:c352:: with SMTP id j18mr23100563edr.67.1625579990485;
        Tue, 06 Jul 2021 06:59:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIj6sUllk9u6M/SAYOyBw7nitq/5JOxZVLumgjOJCSGZY9J4l2m5goh4vbsDX1jaJ5QffMUg==
X-Received: by 2002:aa7:c352:: with SMTP id j18mr23100534edr.67.1625579990306;
        Tue, 06 Jul 2021 06:59:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id qp2sm5748027ejb.91.2021.07.06.06.59.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 06:59:49 -0700 (PDT)
Subject: Re: [RFC PATCH v2 24/69] KVM: x86: Introduce "protected guest"
 concept and block disallowed ioctls
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <482264f17fa0652faad9bd5364d652d11cb2ecb8.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <02ca73b2-7f04-813d-5bb7-649c0edafa06@redhat.com>
Date:   Tue, 6 Jul 2021 15:59:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <482264f17fa0652faad9bd5364d652d11cb2ecb8.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add 'guest_state_protected' to mark a VM's state as being protected by
> hardware/firmware, e.g. SEV-ES or TDX-SEAM.  Use the flag to disallow
> ioctls() and/or flows that attempt to access protected state.
> 
> Return an error if userspace attempts to get/set register state for a
> protected VM, e.g. a non-debug TDX guest.  KVM can't provide sane data,
> it's userspace's responsibility to avoid attempting to read guest state
> when it's known to be inaccessible.
> 
> Retrieving vCPU events is the one exception, as the userspace VMM is
> allowed to inject NMIs.
> 
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/x86.c | 104 +++++++++++++++++++++++++++++++++++++--------
>   1 file changed, 86 insertions(+), 18 deletions(-)

Looks good, but it should be checked whether it breaks QEMU for SEV-ES. 
  Tom, can you help?

Paolo

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 271245ffc67c..b89845dfb679 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4297,6 +4297,10 @@ static int kvm_vcpu_ioctl_nmi(struct kvm_vcpu *vcpu)
>   
>   static int kvm_vcpu_ioctl_smi(struct kvm_vcpu *vcpu)
>   {
> +	/* TODO: use more precise flag */
> +	if (vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>   	kvm_make_request(KVM_REQ_SMI, vcpu);
>   
>   	return 0;
> @@ -4343,6 +4347,10 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
>   	unsigned bank_num = mcg_cap & 0xff;
>   	u64 *banks = vcpu->arch.mce_banks;
>   
> +	/* TODO: use more precise flag */
> +	if (vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>   	if (mce->bank >= bank_num || !(mce->status & MCI_STATUS_VAL))
>   		return -EINVAL;
>   	/*
> @@ -4438,7 +4446,8 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
>   		vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
>   	events->interrupt.nr = vcpu->arch.interrupt.nr;
>   	events->interrupt.soft = 0;
> -	events->interrupt.shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
> +	if (!vcpu->arch.guest_state_protected)
> +		events->interrupt.shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
>   
>   	events->nmi.injected = vcpu->arch.nmi_injected;
>   	events->nmi.pending = vcpu->arch.nmi_pending != 0;
> @@ -4467,11 +4476,17 @@ static void kvm_smm_changed(struct kvm_vcpu *vcpu);
>   static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>   					      struct kvm_vcpu_events *events)
>   {
> -	if (events->flags & ~(KVM_VCPUEVENT_VALID_NMI_PENDING
> -			      | KVM_VCPUEVENT_VALID_SIPI_VECTOR
> -			      | KVM_VCPUEVENT_VALID_SHADOW
> -			      | KVM_VCPUEVENT_VALID_SMM
> -			      | KVM_VCPUEVENT_VALID_PAYLOAD))
> +	u32 allowed_flags = KVM_VCPUEVENT_VALID_NMI_PENDING |
> +			    KVM_VCPUEVENT_VALID_SIPI_VECTOR |
> +			    KVM_VCPUEVENT_VALID_SHADOW |
> +			    KVM_VCPUEVENT_VALID_SMM |
> +			    KVM_VCPUEVENT_VALID_PAYLOAD;
> +
> +	/* TODO: introduce more precise flag */
> +	if (vcpu->arch.guest_state_protected)
> +		allowed_flags = KVM_VCPUEVENT_VALID_NMI_PENDING;
> +
> +	if (events->flags & ~allowed_flags)
>   		return -EINVAL;
>   
>   	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
> @@ -4552,17 +4567,22 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>   	return 0;
>   }
>   
> -static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
> -					     struct kvm_debugregs *dbgregs)
> +static int kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
> +					    struct kvm_debugregs *dbgregs)
>   {
>   	unsigned long val;
>   
> +	if (vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>   	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
>   	kvm_get_dr(vcpu, 6, &val);
>   	dbgregs->dr6 = val;
>   	dbgregs->dr7 = vcpu->arch.dr7;
>   	dbgregs->flags = 0;
>   	memset(&dbgregs->reserved, 0, sizeof(dbgregs->reserved));
> +
> +	return 0;
>   }
>   
>   static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
> @@ -4576,6 +4596,9 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
>   	if (!kvm_dr7_valid(dbgregs->dr7))
>   		return -EINVAL;
>   
> +	if (vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>   	memcpy(vcpu->arch.db, dbgregs->db, sizeof(vcpu->arch.db));
>   	kvm_update_dr0123(vcpu);
>   	vcpu->arch.dr6 = dbgregs->dr6;
> @@ -4671,11 +4694,14 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
>   	}
>   }
>   
> -static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
> -					 struct kvm_xsave *guest_xsave)
> +static int kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
> +					struct kvm_xsave *guest_xsave)
>   {
> +	if (vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>   	if (!vcpu->arch.guest_fpu)
> -		return;
> +		return 0;
>   
>   	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
>   		memset(guest_xsave, 0, sizeof(struct kvm_xsave));
> @@ -4687,6 +4713,8 @@ static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
>   		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)] =
>   			XFEATURE_MASK_FPSSE;
>   	}
> +
> +	return 0;
>   }
>   
>   #define XSAVE_MXCSR_OFFSET 24
> @@ -4697,6 +4725,9 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
>   	u64 xstate_bv;
>   	u32 mxcsr;
>   
> +	if (vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>   	if (!vcpu->arch.guest_fpu)
>   		return 0;
>   
> @@ -4722,18 +4753,22 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
>   	return 0;
>   }
>   
> -static void kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
> -					struct kvm_xcrs *guest_xcrs)
> +static int kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
> +				       struct kvm_xcrs *guest_xcrs)
>   {
> +	if (vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>   	if (!boot_cpu_has(X86_FEATURE_XSAVE)) {
>   		guest_xcrs->nr_xcrs = 0;
> -		return;
> +		return 0;
>   	}
>   
>   	guest_xcrs->nr_xcrs = 1;
>   	guest_xcrs->flags = 0;
>   	guest_xcrs->xcrs[0].xcr = XCR_XFEATURE_ENABLED_MASK;
>   	guest_xcrs->xcrs[0].value = vcpu->arch.xcr0;
> +	return 0;
>   }
>   
>   static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
> @@ -4741,6 +4776,9 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
>   {
>   	int i, r = 0;
>   
> +	if (vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>   	if (!boot_cpu_has(X86_FEATURE_XSAVE))
>   		return -EINVAL;
>   
> @@ -5011,7 +5049,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   	case KVM_GET_DEBUGREGS: {
>   		struct kvm_debugregs dbgregs;
>   
> -		kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
> +		r = kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
> +		if (r)
> +			break;
>   
>   		r = -EFAULT;
>   		if (copy_to_user(argp, &dbgregs,
> @@ -5037,7 +5077,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   		if (!u.xsave)
>   			break;
>   
> -		kvm_vcpu_ioctl_x86_get_xsave(vcpu, u.xsave);
> +		r = kvm_vcpu_ioctl_x86_get_xsave(vcpu, u.xsave);
> +		if (r)
> +			break;
>   
>   		r = -EFAULT;
>   		if (copy_to_user(argp, u.xsave, sizeof(struct kvm_xsave)))
> @@ -5061,7 +5103,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   		if (!u.xcrs)
>   			break;
>   
> -		kvm_vcpu_ioctl_x86_get_xcrs(vcpu, u.xcrs);
> +		r = kvm_vcpu_ioctl_x86_get_xcrs(vcpu, u.xcrs);
> +		if (r)
> +			break;
>   
>   		r = -EFAULT;
>   		if (copy_to_user(argp, u.xcrs,
> @@ -9735,6 +9779,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   		goto out;
>   	}
>   
> +	if (vcpu->arch.guest_state_protected &&
> +	    (kvm_run->kvm_valid_regs || kvm_run->kvm_dirty_regs)) {
> +		r = -EINVAL;
> +		goto out;
> +	}
> +
>   	if (kvm_run->kvm_dirty_regs) {
>   		r = sync_regs(vcpu);
>   		if (r != 0)
> @@ -9765,7 +9815,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   
>   out:
>   	kvm_put_guest_fpu(vcpu);
> -	if (kvm_run->kvm_valid_regs)
> +	if (kvm_run->kvm_valid_regs && !vcpu->arch.guest_state_protected)
>   		store_regs(vcpu);
>   	post_kvm_run_save(vcpu);
>   	kvm_sigset_deactivate(vcpu);
> @@ -9812,6 +9862,9 @@ static void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>   
>   int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>   {
> +	if (vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>   	vcpu_load(vcpu);
>   	__get_regs(vcpu, regs);
>   	vcpu_put(vcpu);
> @@ -9852,6 +9905,9 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>   
>   int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>   {
> +	if (vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>   	vcpu_load(vcpu);
>   	__set_regs(vcpu, regs);
>   	vcpu_put(vcpu);
> @@ -9912,6 +9968,9 @@ static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>   int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
>   				  struct kvm_sregs *sregs)
>   {
> +	if (vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>   	vcpu_load(vcpu);
>   	__get_sregs(vcpu, sregs);
>   	vcpu_put(vcpu);
> @@ -10112,6 +10171,9 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
>   {
>   	int ret;
>   
> +	if (vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>   	vcpu_load(vcpu);
>   	ret = __set_sregs(vcpu, sregs);
>   	vcpu_put(vcpu);
> @@ -10205,6 +10267,9 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
>   {
>   	struct fxregs_state *fxsave;
>   
> +	if (vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>   	if (!vcpu->arch.guest_fpu)
>   		return 0;
>   
> @@ -10228,6 +10293,9 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
>   {
>   	struct fxregs_state *fxsave;
>   
> +	if (vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>   	if (!vcpu->arch.guest_fpu)
>   		return 0;
>   
> 

