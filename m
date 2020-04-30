Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463251BF2DB
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 10:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgD3Ibo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 04:31:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28100 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726127AbgD3Ibn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 04:31:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588235501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mYow4zaXwK1lpPM86H19mSz/v8Kj/lT4XY0f047Q4K8=;
        b=ZTy6M37ZtKEtAg037/pt2FmdMJ/d1/lEBFpqbZYWC78d7H9YV1NQ3RbV72VqaK6V0f6DCV
        v+llRFfxd7/wud7f8iEZulEctHgUCuaYJVxg6tUka7WjKqKu5mUftRlvT6sAzwJpbo0Odj
        90J8Z7aYkWVO2HsWnUGQZfCNajm4zf8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-TO4b_SFoNYaxyMwspFzUxw-1; Thu, 30 Apr 2020 04:31:38 -0400
X-MC-Unique: TO4b_SFoNYaxyMwspFzUxw-1
Received: by mail-wr1-f70.google.com with SMTP id y12so895698wrl.14
        for <kvm@vger.kernel.org>; Thu, 30 Apr 2020 01:31:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=mYow4zaXwK1lpPM86H19mSz/v8Kj/lT4XY0f047Q4K8=;
        b=Y0pqkguno/2FHEaV/jgG5uEPEPE6ABKv/6ZP1nvwgQ3ZNzmDDIAXo/zFjNexm7CfE6
         jab4UvfoxtFr+Mo7TRmLgl9PS2OwMzMvknVHSQbRf4KafrkJHUxJ+iAVdiqIS+hTgYK0
         8hLQUeFIYzGZz3+fmT7N4/dmrWJx+9BLURx3K9EJGTBvEEHJgslwiJIZ258vtJpZzMpk
         xwVO3grJ8pnC7dF9lpyR8rxfSzhT5aqx0Cd41Tb9TQlDR2Ip5HRKkFOrxp1zMymDl3Rk
         2FjmZ+GASWunkEv5Uz2EBKZYNtgdf2mPOtgHM9L9j1lGOK38GcyK3SRigqq6pKIoR66x
         IcFA==
X-Gm-Message-State: AGi0PuZBNCRRw0J+g6pUHUTTKpxINJcexWVQ9Mznbt0NKfDjg6P2AVw7
        p5uJv6AVIhWjeTm/f4eco3DPqOAY89EXdfCrp1SBROplrotNd5OpLK16vwJ400Ws2/Sub9gv7xA
        nCVUP5Q0zVYSi
X-Received: by 2002:a05:600c:22d3:: with SMTP id 19mr1756725wmg.110.1588235494732;
        Thu, 30 Apr 2020 01:31:34 -0700 (PDT)
X-Google-Smtp-Source: APiQypL1OapL/7HxSBhD/1PWoVO3LKBacZMwJu5zGKbmXSQzI/EWQuD7rvMeL+TneMgMKlIb2CX24w==
X-Received: by 2002:a05:600c:22d3:: with SMTP id 19mr1756693wmg.110.1588235494381;
        Thu, 30 Apr 2020 01:31:34 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t17sm2624275wro.2.2020.04.30.01.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 01:31:33 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 3/6] KVM: x86: interrupt based APF page-ready event delivery
In-Reply-To: <20200429212708.GA40678@xz-x1>
References: <20200429093634.1514902-1-vkuznets@redhat.com> <20200429093634.1514902-4-vkuznets@redhat.com> <20200429212708.GA40678@xz-x1>
Date:   Thu, 30 Apr 2020 10:31:32 +0200
Message-ID: <87v9lhfk7v.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Xu <peterx@redhat.com> writes:

> Hi, Vitaly,
>
> On Wed, Apr 29, 2020 at 11:36:31AM +0200, Vitaly Kuznetsov wrote:
>> +	Type 1 page (page missing) events are currently always delivered as
>> +	synthetic #PF exception. Type 2 (page ready) are either delivered
>> +	by #PF exception (when bit 3 of MSR_KVM_ASYNC_PF_EN is clear) or
>> +	via an APIC interrupt (when bit 3 set). APIC interrupt delivery is
>> +	controlled by MSR_KVM_ASYNC_PF2.
>
> How about MSR_KVM_ASYNC_PF_INT instead of MSR_KVM_ASYNC_PF2 (to match
> MSR_KVM_ASYNC_EN and MSR_KVM_ASYNC_ACK where they're all MSR_KVM_ASYNC_* with a
> meaningful ending word)?
>

Sure.

>> +
>> +	For #PF delivery, disabling interrupt inhibits APFs. Guest must
>> +	not enable interrupt before the reason is read, or it may be
>> +	overwritten by another APF. Since APF uses the same exception
>> +	vector as regular page fault guest must reset the reason to 0
>> +	before it does something that can generate normal page fault.
>> +	If during pagefault APF reason is 0 it means that this is regular
>> +	page fault.
>>  
>>  	During delivery of type 1 APF cr2 contains a token that will
>>  	be used to notify a guest when missing page becomes
>> @@ -319,3 +326,18 @@ data:
>>  
>>  	KVM guests can request the host not to poll on HLT, for example if
>>  	they are performing polling themselves.
>> +
>> +MSR_KVM_ASYNC_PF2:
>> +	0x4b564d06
>> +
>> +data:
>> +	Second asynchronous page fault control MSR.
>> +
>> +	Bits 0-7: APIC vector for interrupt based delivery of type 2 APF
>> +	events (page ready notification).
>> +        Bit 8: Interrupt based delivery of type 2 APF events is enabled
>> +        Bits 9-63: Reserved
>
> (may need to fix up the indents)
>
>> +
>> +	To switch to interrupt based delivery of type 2 APF events guests
>> +	are supposed to enable asynchronous page faults and set bit 3 in
>> +	MSR_KVM_ASYNC_PF_EN first.
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 42a2d0d3984a..6215f61450cb 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -763,12 +763,15 @@ struct kvm_vcpu_arch {
>>  		bool halted;
>>  		gfn_t gfns[roundup_pow_of_two(ASYNC_PF_PER_VCPU)];
>>  		struct gfn_to_hva_cache data;
>> -		u64 msr_val;
>> +		u64 msr_val; /* MSR_KVM_ASYNC_PF_EN */
>> +		u64 msr2_val; /* MSR_KVM_ASYNC_PF2 */
>> +		u16 vec;
>>  		u32 id;
>>  		bool send_user_only;
>>  		u32 host_apf_reason;
>>  		unsigned long nested_apf_token;
>>  		bool delivery_as_pf_vmexit;
>> +		bool delivery_as_int;
>>  	} apf;
>>  
>>  	/* OSVW MSRs (AMD only) */
>> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
>> index df2ba34037a2..1bbb0b7e062f 100644
>> --- a/arch/x86/include/uapi/asm/kvm_para.h
>> +++ b/arch/x86/include/uapi/asm/kvm_para.h
>> @@ -50,6 +50,7 @@
>>  #define MSR_KVM_STEAL_TIME  0x4b564d03
>>  #define MSR_KVM_PV_EOI_EN      0x4b564d04
>>  #define MSR_KVM_POLL_CONTROL	0x4b564d05
>> +#define MSR_KVM_ASYNC_PF2	0x4b564d06
>>  
>>  struct kvm_steal_time {
>>  	__u64 steal;
>> @@ -81,6 +82,11 @@ struct kvm_clock_pairing {
>>  #define KVM_ASYNC_PF_ENABLED			(1 << 0)
>>  #define KVM_ASYNC_PF_SEND_ALWAYS		(1 << 1)
>>  #define KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT	(1 << 2)
>> +#define KVM_ASYNC_PF_DELIVERY_AS_INT		(1 << 3)
>> +
>> +#define KVM_ASYNC_PF2_VEC_MASK			GENMASK(7, 0)
>> +#define KVM_ASYNC_PF2_ENABLED			BIT(8)
>
> There are two enable bits, this one in ASYNC_PF_EN and the other old one in
> ASYNC_PF2.  Could it work with only one knob (e.g., set bit 0 of ASYNC_PF_EN
> always to enable apf)?  After all we have had bit 3 of ASYNC_PF_EN to show
> whether interrupt is enabled, which seems to be the real switch for whether to
> enable interrupt for apf.
>
> If we can keep the only knob in ASYNC_PF_EN (bit 0), iiuc we can also keep the
> below kvm_async_pf_wakeup_all() untouched (so we only set bit 0 of ASYNC_PF_EN
> after configure everything).

Yes,

as we need to write to two MSRs to configure the new mechanism ordering
becomes important. If the guest writes to ASYNC_PF_EN first to establish
the shared memory stucture the interrupt in ASYNC_PF2 is not yet set
(and AFAIR '0' is a valid interrupt!) so if an async pf happens
immediately after that we'll be forced to inject INT0 in the guest and
it'll get confused and linkely miss the event.

We can probably mandate the reverse sequence: guest has to set up
interrupt in ASYNC_PF2 first and then write to ASYNC_PF_EN (with both
bit 0 and bit 3). In that case the additional 'enable' bit in ASYNC_PF2
seems redundant. This protocol doesn't look too complex for guests to
follow.

>
> Thanks,
>
>> +
>>  
>>  /* Operations for KVM_HC_MMU_OP */
>>  #define KVM_MMU_OP_WRITE_PTE            1
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 7c21c0cf0a33..861dce1e7cf5 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1243,7 +1243,7 @@ static const u32 emulated_msrs_all[] = {
>>  	HV_X64_MSR_TSC_EMULATION_STATUS,
>>  
>>  	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
>> -	MSR_KVM_PV_EOI_EN,
>> +	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF2,
>>  
>>  	MSR_IA32_TSC_ADJUST,
>>  	MSR_IA32_TSCDEADLINE,
>> @@ -2649,8 +2649,8 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
>>  {
>>  	gpa_t gpa = data & ~0x3f;
>>  
>> -	/* Bits 3:5 are reserved, Should be zero */
>> -	if (data & 0x38)
>> +	/* Bits 4:5 are reserved, Should be zero */
>> +	if (data & 0x30)
>>  		return 1;
>>  
>>  	vcpu->arch.apf.msr_val = data;
>> @@ -2667,7 +2667,35 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
>>  
>>  	vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
>>  	vcpu->arch.apf.delivery_as_pf_vmexit = data & KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT;
>> -	kvm_async_pf_wakeup_all(vcpu);
>> +	vcpu->arch.apf.delivery_as_int = data & KVM_ASYNC_PF_DELIVERY_AS_INT;
>> +
>> +	/*
>> +	 * If delivery via interrupt is configured make sure MSR_KVM_ASYNC_PF2
>> +	 * was written to before sending 'wakeup all'.
>> +	 */
>> +	if (!vcpu->arch.apf.delivery_as_int ||
>> +	    vcpu->arch.apf.msr2_val & KVM_ASYNC_PF2_ENABLED)
>> +		kvm_async_pf_wakeup_all(vcpu);
>> +
>> +	return 0;
>> +}
>> +
>> +static int kvm_pv_enable_async_pf2(struct kvm_vcpu *vcpu, u64 data)
>> +{
>> +	/* Bits 9-63 are reserved */
>> +	if (data & ~0x1ff)
>> +		return 1;
>> +
>> +	if (!lapic_in_kernel(vcpu))
>> +		return 1;
>> +
>> +	vcpu->arch.apf.msr2_val = data;
>> +
>> +	vcpu->arch.apf.vec = data & KVM_ASYNC_PF2_VEC_MASK;
>> +
>> +	if (data & KVM_ASYNC_PF2_ENABLED)
>> +		kvm_async_pf_wakeup_all(vcpu);
>> +
>>  	return 0;
>>  }
>>  
>> @@ -2883,6 +2911,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>  		if (kvm_pv_enable_async_pf(vcpu, data))
>>  			return 1;
>>  		break;
>> +	case MSR_KVM_ASYNC_PF2:
>> +		if (kvm_pv_enable_async_pf2(vcpu, data))
>> +			return 1;
>> +		break;
>>  	case MSR_KVM_STEAL_TIME:
>>  
>>  		if (unlikely(!sched_info_on()))
>> @@ -3159,6 +3191,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>  	case MSR_KVM_ASYNC_PF_EN:
>>  		msr_info->data = vcpu->arch.apf.msr_val;
>>  		break;
>> +	case MSR_KVM_ASYNC_PF2:
>> +		msr_info->data = vcpu->arch.apf.msr2_val;
>> +		break;
>>  	case MSR_KVM_STEAL_TIME:
>>  		msr_info->data = vcpu->arch.st.msr_val;
>>  		break;
>> @@ -10367,6 +10402,16 @@ static int apf_get_user(struct kvm_vcpu *vcpu, u32 *val)
>>  				      sizeof(u32));
>>  }
>>  
>> +static bool apf_slot_free(struct kvm_vcpu *vcpu)
>> +{
>> +	u32 val;
>> +
>> +	if (apf_get_user(vcpu, &val))
>> +		return false;
>> +
>> +	return !val;
>> +}
>> +
>>  static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
>>  {
>>  	if (!vcpu->arch.apf.delivery_as_pf_vmexit && is_guest_mode(vcpu))
>> @@ -10382,11 +10427,23 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
>>  
>>  bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
>>  {
>> +	/*
>> +	 * TODO: when we are injecting a 'page present' event with an interrupt
>> +	 * we may ignore pending exceptions.
>> +	 */
>>  	if (unlikely(!lapic_in_kernel(vcpu) ||
>>  		     kvm_event_needs_reinjection(vcpu) ||
>>  		     vcpu->arch.exception.pending))
>>  		return false;
>>  
>> +	/*'
>> +	 * Regardless of the type of event we're trying to deliver, we need to
>> +	 * check that the previous even was already consumed, this may not be
>> +	 * the case with interrupt based delivery.
>> +	 */
>> +	if (vcpu->arch.apf.delivery_as_int && !apf_slot_free(vcpu))
>> +		return false;
>> +
>>  	if (kvm_hlt_in_guest(vcpu->kvm) && !kvm_can_deliver_async_pf(vcpu))
>>  		return false;

-- 
Vitaly

