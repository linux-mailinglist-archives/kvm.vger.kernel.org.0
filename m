Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A9B1BE9DB
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 23:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgD2V1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 17:27:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58073 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726775AbgD2V1P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 17:27:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588195633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HoD2nHcDH26n/muu6HahHBzJtT5REhgOGlaAWfH/9F0=;
        b=GTE6JM4oWCZJVF0Z2hNCtNsllZZVNCWx/6KDaARHKpkVLI/ZQm6fy2+3f1g8OhSANoWcLH
        qTmsToRBb6oo229XdGTFP7veUzniXqxpdWcbgkvf8uJRjOfjLbvY3QLI8HxdtMXfLO4YuI
        Pq5MjAtld/5SiS/p+tkiR/5lF5d46L0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-YdkkUsU3OwGS26U1oK9ndg-1; Wed, 29 Apr 2020 17:27:11 -0400
X-MC-Unique: YdkkUsU3OwGS26U1oK9ndg-1
Received: by mail-qv1-f72.google.com with SMTP id ce16so2632128qvb.15
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 14:27:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HoD2nHcDH26n/muu6HahHBzJtT5REhgOGlaAWfH/9F0=;
        b=uQ2I+N/IyUq2avnmTJTjHn/ii/nWAasE7y+Ly2BlpXVt6wakj6ZdHaZyVKLK7dXo1l
         subYNs4Eqy08ucHY9n7D+Njsp5wrPTdtJZb7r+vZ2VBPJQxZpla6iC0Af7m4U9HZli/i
         YsSFDdLn6Jz4f7oUhzaLisLYcrdVfnM9hXO+Yk8R8/DyTpKipBDgvKSRtGhhkhpcguo3
         vjbYYTVP8/S9hOQuV6wm2LkaWb5Y4IFf4p6UAM5K3Thlb+9t5CMw1LwWX6nvooPxb+Ff
         o9zwIIyv59hhfRBDeta3oV4EPdeU7KBg7U74kE5/NQ57aqutNW10z5zpObOsi01vzVVz
         07Sw==
X-Gm-Message-State: AGi0PuaU+2Lh9jOOPrPwz6T0eVT+dEXOLF5n1RQ/g+h6pfvorhcF/s+N
        x4msQhAOrdG1u3Vl3qwcoDMx2RWAF4zT8JErTtuh8AtSNpvPwZtFBlJFyzsKxFyGzwg8gcZnixF
        dV18WsC2dJo9J
X-Received: by 2002:ac8:1c04:: with SMTP id a4mr358160qtk.90.1588195630910;
        Wed, 29 Apr 2020 14:27:10 -0700 (PDT)
X-Google-Smtp-Source: APiQypL+VMgtBdoEsKYufs76uj8kQnrQvWVxJhOKzrvhIIc7cBkrB1AV2mdzZ8s3zlMd/kPiXrhAXg==
X-Received: by 2002:ac8:1c04:: with SMTP id a4mr358127qtk.90.1588195630497;
        Wed, 29 Apr 2020 14:27:10 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id i129sm307291qke.28.2020.04.29.14.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 14:27:09 -0700 (PDT)
Date:   Wed, 29 Apr 2020 17:27:08 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 3/6] KVM: x86: interrupt based APF page-ready event
 delivery
Message-ID: <20200429212708.GA40678@xz-x1>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
 <20200429093634.1514902-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200429093634.1514902-4-vkuznets@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Vitaly,

On Wed, Apr 29, 2020 at 11:36:31AM +0200, Vitaly Kuznetsov wrote:
> +	Type 1 page (page missing) events are currently always delivered as
> +	synthetic #PF exception. Type 2 (page ready) are either delivered
> +	by #PF exception (when bit 3 of MSR_KVM_ASYNC_PF_EN is clear) or
> +	via an APIC interrupt (when bit 3 set). APIC interrupt delivery is
> +	controlled by MSR_KVM_ASYNC_PF2.

How about MSR_KVM_ASYNC_PF_INT instead of MSR_KVM_ASYNC_PF2 (to match
MSR_KVM_ASYNC_EN and MSR_KVM_ASYNC_ACK where they're all MSR_KVM_ASYNC_* with a
meaningful ending word)?

> +
> +	For #PF delivery, disabling interrupt inhibits APFs. Guest must
> +	not enable interrupt before the reason is read, or it may be
> +	overwritten by another APF. Since APF uses the same exception
> +	vector as regular page fault guest must reset the reason to 0
> +	before it does something that can generate normal page fault.
> +	If during pagefault APF reason is 0 it means that this is regular
> +	page fault.
>  
>  	During delivery of type 1 APF cr2 contains a token that will
>  	be used to notify a guest when missing page becomes
> @@ -319,3 +326,18 @@ data:
>  
>  	KVM guests can request the host not to poll on HLT, for example if
>  	they are performing polling themselves.
> +
> +MSR_KVM_ASYNC_PF2:
> +	0x4b564d06
> +
> +data:
> +	Second asynchronous page fault control MSR.
> +
> +	Bits 0-7: APIC vector for interrupt based delivery of type 2 APF
> +	events (page ready notification).
> +        Bit 8: Interrupt based delivery of type 2 APF events is enabled
> +        Bits 9-63: Reserved

(may need to fix up the indents)

> +
> +	To switch to interrupt based delivery of type 2 APF events guests
> +	are supposed to enable asynchronous page faults and set bit 3 in
> +	MSR_KVM_ASYNC_PF_EN first.
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 42a2d0d3984a..6215f61450cb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -763,12 +763,15 @@ struct kvm_vcpu_arch {
>  		bool halted;
>  		gfn_t gfns[roundup_pow_of_two(ASYNC_PF_PER_VCPU)];
>  		struct gfn_to_hva_cache data;
> -		u64 msr_val;
> +		u64 msr_val; /* MSR_KVM_ASYNC_PF_EN */
> +		u64 msr2_val; /* MSR_KVM_ASYNC_PF2 */
> +		u16 vec;
>  		u32 id;
>  		bool send_user_only;
>  		u32 host_apf_reason;
>  		unsigned long nested_apf_token;
>  		bool delivery_as_pf_vmexit;
> +		bool delivery_as_int;
>  	} apf;
>  
>  	/* OSVW MSRs (AMD only) */
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index df2ba34037a2..1bbb0b7e062f 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -50,6 +50,7 @@
>  #define MSR_KVM_STEAL_TIME  0x4b564d03
>  #define MSR_KVM_PV_EOI_EN      0x4b564d04
>  #define MSR_KVM_POLL_CONTROL	0x4b564d05
> +#define MSR_KVM_ASYNC_PF2	0x4b564d06
>  
>  struct kvm_steal_time {
>  	__u64 steal;
> @@ -81,6 +82,11 @@ struct kvm_clock_pairing {
>  #define KVM_ASYNC_PF_ENABLED			(1 << 0)
>  #define KVM_ASYNC_PF_SEND_ALWAYS		(1 << 1)
>  #define KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT	(1 << 2)
> +#define KVM_ASYNC_PF_DELIVERY_AS_INT		(1 << 3)
> +
> +#define KVM_ASYNC_PF2_VEC_MASK			GENMASK(7, 0)
> +#define KVM_ASYNC_PF2_ENABLED			BIT(8)

There are two enable bits, this one in ASYNC_PF_EN and the other old one in
ASYNC_PF2.  Could it work with only one knob (e.g., set bit 0 of ASYNC_PF_EN
always to enable apf)?  After all we have had bit 3 of ASYNC_PF_EN to show
whether interrupt is enabled, which seems to be the real switch for whether to
enable interrupt for apf.

If we can keep the only knob in ASYNC_PF_EN (bit 0), iiuc we can also keep the
below kvm_async_pf_wakeup_all() untouched (so we only set bit 0 of ASYNC_PF_EN
after configure everything).

Thanks,

> +
>  
>  /* Operations for KVM_HC_MMU_OP */
>  #define KVM_MMU_OP_WRITE_PTE            1
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7c21c0cf0a33..861dce1e7cf5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1243,7 +1243,7 @@ static const u32 emulated_msrs_all[] = {
>  	HV_X64_MSR_TSC_EMULATION_STATUS,
>  
>  	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
> -	MSR_KVM_PV_EOI_EN,
> +	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF2,
>  
>  	MSR_IA32_TSC_ADJUST,
>  	MSR_IA32_TSCDEADLINE,
> @@ -2649,8 +2649,8 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
>  {
>  	gpa_t gpa = data & ~0x3f;
>  
> -	/* Bits 3:5 are reserved, Should be zero */
> -	if (data & 0x38)
> +	/* Bits 4:5 are reserved, Should be zero */
> +	if (data & 0x30)
>  		return 1;
>  
>  	vcpu->arch.apf.msr_val = data;
> @@ -2667,7 +2667,35 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
>  
>  	vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
>  	vcpu->arch.apf.delivery_as_pf_vmexit = data & KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT;
> -	kvm_async_pf_wakeup_all(vcpu);
> +	vcpu->arch.apf.delivery_as_int = data & KVM_ASYNC_PF_DELIVERY_AS_INT;
> +
> +	/*
> +	 * If delivery via interrupt is configured make sure MSR_KVM_ASYNC_PF2
> +	 * was written to before sending 'wakeup all'.
> +	 */
> +	if (!vcpu->arch.apf.delivery_as_int ||
> +	    vcpu->arch.apf.msr2_val & KVM_ASYNC_PF2_ENABLED)
> +		kvm_async_pf_wakeup_all(vcpu);
> +
> +	return 0;
> +}
> +
> +static int kvm_pv_enable_async_pf2(struct kvm_vcpu *vcpu, u64 data)
> +{
> +	/* Bits 9-63 are reserved */
> +	if (data & ~0x1ff)
> +		return 1;
> +
> +	if (!lapic_in_kernel(vcpu))
> +		return 1;
> +
> +	vcpu->arch.apf.msr2_val = data;
> +
> +	vcpu->arch.apf.vec = data & KVM_ASYNC_PF2_VEC_MASK;
> +
> +	if (data & KVM_ASYNC_PF2_ENABLED)
> +		kvm_async_pf_wakeup_all(vcpu);
> +
>  	return 0;
>  }
>  
> @@ -2883,6 +2911,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (kvm_pv_enable_async_pf(vcpu, data))
>  			return 1;
>  		break;
> +	case MSR_KVM_ASYNC_PF2:
> +		if (kvm_pv_enable_async_pf2(vcpu, data))
> +			return 1;
> +		break;
>  	case MSR_KVM_STEAL_TIME:
>  
>  		if (unlikely(!sched_info_on()))
> @@ -3159,6 +3191,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_KVM_ASYNC_PF_EN:
>  		msr_info->data = vcpu->arch.apf.msr_val;
>  		break;
> +	case MSR_KVM_ASYNC_PF2:
> +		msr_info->data = vcpu->arch.apf.msr2_val;
> +		break;
>  	case MSR_KVM_STEAL_TIME:
>  		msr_info->data = vcpu->arch.st.msr_val;
>  		break;
> @@ -10367,6 +10402,16 @@ static int apf_get_user(struct kvm_vcpu *vcpu, u32 *val)
>  				      sizeof(u32));
>  }
>  
> +static bool apf_slot_free(struct kvm_vcpu *vcpu)
> +{
> +	u32 val;
> +
> +	if (apf_get_user(vcpu, &val))
> +		return false;
> +
> +	return !val;
> +}
> +
>  static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
>  {
>  	if (!vcpu->arch.apf.delivery_as_pf_vmexit && is_guest_mode(vcpu))
> @@ -10382,11 +10427,23 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
>  
>  bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
>  {
> +	/*
> +	 * TODO: when we are injecting a 'page present' event with an interrupt
> +	 * we may ignore pending exceptions.
> +	 */
>  	if (unlikely(!lapic_in_kernel(vcpu) ||
>  		     kvm_event_needs_reinjection(vcpu) ||
>  		     vcpu->arch.exception.pending))
>  		return false;
>  
> +	/*'
> +	 * Regardless of the type of event we're trying to deliver, we need to
> +	 * check that the previous even was already consumed, this may not be
> +	 * the case with interrupt based delivery.
> +	 */
> +	if (vcpu->arch.apf.delivery_as_int && !apf_slot_free(vcpu))
> +		return false;
> +
>  	if (kvm_hlt_in_guest(vcpu->kvm) && !kvm_can_deliver_async_pf(vcpu))
>  		return false;

-- 
Peter Xu

