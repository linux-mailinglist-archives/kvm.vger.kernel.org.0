Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E115B6B31
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 11:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiIMJwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 05:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbiIMJwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 05:52:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256B457E01
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 02:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663062721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fvX1Ad0aFss8WtTAorRVKsGlaleLlVad8DpC+c+Z++w=;
        b=GP6bsqPtDmDzGsi8HBto2/VryX+3q6F0hd4gZLEofQLqmGArEwBVqAdWo6tCisHI8+3UZX
        J8+CyVgfrSg6mIZJV23HxPIHUFH3VvyRKWf3s/7UNEblI/awdmLXJ9RkIbpHA4h01tluy4
        CFCOvLcj2ZGPECKHZzN6L2UTcyk3mZk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-75-bSkX6YQ1MAWjuzCM0Xxh4g-1; Tue, 13 Sep 2022 05:51:59 -0400
X-MC-Unique: bSkX6YQ1MAWjuzCM0Xxh4g-1
Received: by mail-wm1-f71.google.com with SMTP id c3-20020a7bc843000000b003b486fc6a40so2438345wml.7
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 02:51:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=fvX1Ad0aFss8WtTAorRVKsGlaleLlVad8DpC+c+Z++w=;
        b=18+kUNPcxUYNwX3V3wK6wgO3cHbJmARgVWPl+uREiO82FejBt8Xu4UMnyJyNoGO9B+
         DANl0zD9Ejhn4PYuy+OIv63YAg792fQBKnPka5u012CFJFH7OsjAj12jkEGWcEYD+J5B
         inaQ9P+fTDk6ThxhVAHObRyPVKoAQen13XE95HIvKx2kmZQXSdRABFtUHMKdHc6nwE16
         m8vQClGhDDFCmZavGKNfFTopwY6DjJzdqENpECjmMOcCEpQ2xwBLLcpDRigQfc9QDd68
         LKjflsRftNpu2iC/DtNU+EAMnLRZACDBF63l7qD9+ieLug+Nvb45LpZVbdmad5/uFX5C
         1Wjg==
X-Gm-Message-State: ACgBeo1ytl9YUAoUsKF9OK0SKe8sUd9u62kWnJ3U+bhwIQllMPXLJHFF
        iPNDRPtGfCq569KKlgeKnLEZgRiLXotf0m23KVpiZufryB2EcYxtOJYZzh0wu4QrSBCKMzEeJwx
        rYAk7/wNVZt1s
X-Received: by 2002:a05:600c:3c84:b0:3a6:9596:fa1f with SMTP id bg4-20020a05600c3c8400b003a69596fa1fmr1752980wmb.162.1663062718802;
        Tue, 13 Sep 2022 02:51:58 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4pUJl0K4ydJWD418ZMcXynGlGLzD07Rux8b/Ted5XZFG8IYhMtAG78OaOM9tokqNZ9f+rufw==
X-Received: by 2002:a05:600c:3c84:b0:3a6:9596:fa1f with SMTP id bg4-20020a05600c3c8400b003a69596fa1fmr1752960wmb.162.1663062718477;
        Tue, 13 Sep 2022 02:51:58 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id bg14-20020a05600c3c8e00b003a840690609sm16846733wmb.36.2022.09.13.02.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 02:51:57 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] KVM: x86: Hyper-V invariant TSC control
In-Reply-To: <Yx85fuFWR/X097SL@google.com>
References: <20220831085009.1627523-1-vkuznets@redhat.com>
 <20220831085009.1627523-2-vkuznets@redhat.com>
 <Yx85fuFWR/X097SL@google.com>
Date:   Tue, 13 Sep 2022 11:51:56 +0200
Message-ID: <877d27r48z.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Aug 31, 2022, Vitaly Kuznetsov wrote:
>> Normally, genuine Hyper-V doesn't expose architectural invariant TSC
>> (CPUID.80000007H:EDX[8]) to its guests by default. A special PV MSR
>> (HV_X64_MSR_TSC_INVARIANT_CONTROL, 0x40000118) and corresponding CPUID
>> feature bit (CPUID.0x40000003.EAX[15]) were introduced. When bit 0 of the
>> PV MSR is set, invariant TSC bit starts to show up in CPUID. When the
>> feature is exposed to Hyper-V guests, reenlightenment becomes unneeded.
>> 
>> Add the feature to KVM. Keep CPUID output intact when the feature
>> wasn't exposed to L1 and implement the required logic for hiding
>> invariant TSC when the feature was exposed and invariant TSC control
>> MSR wasn't written to. Copy genuine Hyper-V behavior and forbid to
>> disable the feature once it was enabled.
>> 
>> For the reference, for linux guests, support for the feature was added
>> in commit dce7cd62754b ("x86/hyperv: Allow guests to enable InvariantTSC").
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |  1 +
>>  arch/x86/kvm/cpuid.c            |  7 +++++++
>>  arch/x86/kvm/hyperv.c           | 19 +++++++++++++++++++
>>  arch/x86/kvm/hyperv.h           | 15 +++++++++++++++
>>  arch/x86/kvm/x86.c              |  4 +++-
>>  5 files changed, 45 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 2c96c43c313a..9098187e13aa 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1021,6 +1021,7 @@ struct kvm_hv {
>>  	u64 hv_reenlightenment_control;
>>  	u64 hv_tsc_emulation_control;
>>  	u64 hv_tsc_emulation_status;
>> +	u64 hv_invtsc;
>
> For consistency with the other fields, should this be hv_tsc_invariant_control?

Yep.

>>  
>>  	/* How many vCPUs have VP index != vCPU index */
>>  	atomic_t num_mismatched_vp_indexes;
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 75dcf7a72605..8ccd45fd66a9 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -1444,6 +1444,13 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>>  			    (data & TSX_CTRL_CPUID_CLEAR))
>>  				*ebx &= ~(F(RTM) | F(HLE));
>>  		}
>> +		/*
>> +		 * Filter out invariant TSC (CPUID.80000007H:EDX[8]) for Hyper-V
>> +		 * guests if needed.
>> +		 */
>> +		if (function == 0x80000007 && kvm_hv_invtsc_filtered(vcpu))
>
> This can be an else-if.  Kinda weird, but it could be written as
>
> 		else if (function = 0x80000007) {
> 			if (kvm_hv_invtsc_filtered(vcpu))
> 				*edx &= ~SF(CONSTANT_TSC)
> 		}
>
> to make it a pure function+index check.
>
>> +			*edx &= ~(1 << 8);
>
> Ugh, scattered.  Can you add a kvm_only_cpuid_leafs entry so that the bit doesn't
> have to be open coded?

Sure.

>
>> +
>>  	} else {
>>  		*eax = *ebx = *ecx = *edx = 0;
>>  		/*
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index ed804447589c..df90cd7501b9 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -991,6 +991,7 @@ static bool kvm_hv_msr_partition_wide(u32 msr)
>>  	case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
>>  	case HV_X64_MSR_TSC_EMULATION_CONTROL:
>>  	case HV_X64_MSR_TSC_EMULATION_STATUS:
>> +	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
>>  	case HV_X64_MSR_SYNDBG_OPTIONS:
>>  	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>>  		r = true;
>> @@ -1275,6 +1276,9 @@ static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
>>  	case HV_X64_MSR_TSC_EMULATION_STATUS:
>>  		return hv_vcpu->cpuid_cache.features_eax &
>>  			HV_ACCESS_REENLIGHTENMENT;
>> +	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
>> +		return hv_vcpu->cpuid_cache.features_eax &
>> +			HV_ACCESS_TSC_INVARIANT;
>>  	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
>>  	case HV_X64_MSR_CRASH_CTL:
>>  		return hv_vcpu->cpuid_cache.features_edx &
>> @@ -1402,6 +1406,17 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
>>  		if (!host)
>>  			return 1;
>>  		break;
>> +	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
>> +		/* Only bit 0 is supported */
>> +		if (data & ~BIT_ULL(0))
>
> Can a #define be added instead of open coding bit 0?
>

Yes, and then we can avoid open coding it in Linux-on-Hyper-V code too
as it looks like

arch/x86/kernel/cpu/mshyperv.c:         wrmsrl(HV_X64_MSR_TSC_INVARIANT_CONTROL, 0x1);

today.


>> +			return 1;
>> +
>
> Doesn't the host CPUID need to be honored on writes from the guest?
>

You mean INVTSC itself (CPUID.80000007H:EDX[8])? That's a good
question. Genuine Hyper-V will never expose HV_ACCESS_TSC_INVARIANT
without it but a misbehaving KVM VMM can. In case we treat the feature
as a 'filter' only, we don't need to check for the architectural bit.

>> +		/* The feature can't be disabled from the guest */
>> +		if (!host && hv->hv_invtsc && !data)
>> +			return 1;
>> +
>> +		hv->hv_invtsc = data;
>> +		break;
>>  	case HV_X64_MSR_SYNDBG_OPTIONS:
>>  	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>>  		return syndbg_set_msr(vcpu, msr, data, host);
>> @@ -1577,6 +1592,9 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
>>  	case HV_X64_MSR_TSC_EMULATION_STATUS:
>>  		data = hv->hv_tsc_emulation_status;
>>  		break;
>> +	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
>> +		data = hv->hv_invtsc;
>> +		break;
>>  	case HV_X64_MSR_SYNDBG_OPTIONS:
>>  	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>>  		return syndbg_get_msr(vcpu, msr, pdata, host);
>> @@ -2497,6 +2515,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>>  			ent->eax |= HV_MSR_REFERENCE_TSC_AVAILABLE;
>>  			ent->eax |= HV_ACCESS_FREQUENCY_MSRS;
>>  			ent->eax |= HV_ACCESS_REENLIGHTENMENT;
>> +			ent->eax |= HV_ACCESS_TSC_INVARIANT;
>>  
>>  			ent->ebx |= HV_POST_MESSAGES;
>>  			ent->ebx |= HV_SIGNAL_EVENTS;
>> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
>> index da2737f2a956..1a6316ab55eb 100644
>> --- a/arch/x86/kvm/hyperv.h
>> +++ b/arch/x86/kvm/hyperv.h
>> @@ -133,6 +133,21 @@ static inline bool kvm_hv_has_stimer_pending(struct kvm_vcpu *vcpu)
>>  			     HV_SYNIC_STIMER_COUNT);
>>  }
>>  
>> +/*
>> + * With HV_ACCESS_TSC_INVARIANT feature, invariant TSC (CPUID.80000007H:EDX[8])
>> + * is only observed after HV_X64_MSR_TSC_INVARIANT_CONTROL was written to.
>> + */
>> +static inline bool kvm_hv_invtsc_filtered(struct kvm_vcpu *vcpu)
>
> Can this be more strongly worded, e.g. maybe kvm_hv_is_invtsc_disabled()?  "Filtered"
> doesn't strictly mean disabled and makes it sound like there's something else that
> needs to act on the "filtering"
>

"Hidden"? :-) I'm OK with kvm_hv_is_invtsc_disabled() too.

>> +{
>> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>> +	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
>> +
>> +	if (hv_vcpu && hv_vcpu->cpuid_cache.features_eax & HV_ACCESS_TSC_INVARIANT)
>
> Ah, I almost missed the inner check.  Can you write this as:
>
> 	if (!hv_vcpu)
> 		return false;
>
> so that the potentially postive/happy path is at the end?  I.e. follow the common
> pattern of:
>
> 	if (!something)
> 		return -ERRNO;
>
> 	return 0;
>

Sure.

>> +		return !hv->hv_invtsc;
>
> Kinda silly, but I think it's worth checking the exact bit here.  I don't see how
> the TSC can get more invariant, but if another bit is added, this could silently
> break.  And probably no need to grab to_kvm_v() locally.
>
> 	return to_kvm_hv(vcpu->kvm)->hv_invtsc;
>

Sure.

>
>> +
>> +	return false;
>
> Shouldn't this be "return true" if HyperV is enabled but doesn't have the CPUID
> bit set?  I assume the expectation is that host userspace won't set the common
> INVTSC flag without also setting HV_ACCESS_TSC_INVARIANT, but it's confusing logic
> as is.
>
> All in all, I think this?
>
> 	if (!hv_vcpu)
> 		return false;
>
> 	return hv_vcpu->cpuid_cache.features_eax & HV_ACCESS_TSC_INVARIANT &&
> 	       to_kvm_hv(vcpu->kvm)->hv_invtsc & BIT(0);
>

Actually yes, there might be some configurations out there which expose
INVTSC to Hyper-V guests without this new PV feature, no need to break them.

>> +}
>> +
>>  void kvm_hv_process_stimers(struct kvm_vcpu *vcpu);
>>  
>>  void kvm_hv_setup_tsc_page(struct kvm *kvm,
>

-- 
Vitaly

