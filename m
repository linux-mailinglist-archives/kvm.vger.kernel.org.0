Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201B567ADE1
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 10:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbjAYJan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 04:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235280AbjAYJaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 04:30:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CD71A968
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 01:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674638987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1C+0FjPfVRei4W8vyOzxXVXejQSTWzMmOkH8GQ0Kzi0=;
        b=Fmrx3nHMR7yDnozs7JPze+4lx3QALD/nzVy4EsSSxCNOsxRi07D104Yn6+bZ7ZxWkziLPq
        jvW2O41H26S1+d7jNQp88DtgydlFTYih/hydDz5hBD8WYRcketBb57QL6rYdN3IaYQUhl5
        lVoWmKG6fsaYEeyBJFf1/Q5nte+OxLI=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-344-FYCzjQhuMxm_M_NGcpo68w-1; Wed, 25 Jan 2023 04:29:45 -0500
X-MC-Unique: FYCzjQhuMxm_M_NGcpo68w-1
Received: by mail-qv1-f70.google.com with SMTP id x6-20020a0cc506000000b005349c8b39d6so8942286qvi.2
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 01:29:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1C+0FjPfVRei4W8vyOzxXVXejQSTWzMmOkH8GQ0Kzi0=;
        b=i7ieO+RpIpMmv4eb1Ml41DjyWH9N1X5Dq1D5FQL3YtYYQQZ3rX4E/Uz3LYE77lhay1
         CjvcFqY7wbNzMpDcp1l5j3Ol412sRzv9lKaapR7KYVaFpv8c3o0ra7eNN/BSlsRp8QLc
         GgYg/zGHPOMkrMkdiFFNc3Bxq2N+sD4XnlGTFxv2PgIUHnIQb3RpJUMqg869Gr4YXttY
         uTTnCA2Ot9YA9vWF4BjKGWA+3BOmnGrVChD91FS9w4VeBGQSAyqvV5erkxWDXopIkAMc
         y0VJpaFoWeQkXZ4TfhCLTogd3bOwJq0zP5uo2eSQTgpq1fFOsFfEghIhHd42IEH58IsF
         9f3A==
X-Gm-Message-State: AO0yUKUjfG5/qbCoGetYla/qg8K7smwRlFLYcXTZHacGBNHs4KDqbmDH
        c4S4NnyxKER4AYGm7Y/bYf7J7+h5S/Ioars9Rrl9EIlCGlh1fTFpfN7Ss3r6BCSGWSJ/BxTO4RC
        nt61LPnupAWgZ
X-Received: by 2002:a05:622a:1443:b0:3b6:3697:63fa with SMTP id v3-20020a05622a144300b003b6369763famr2710954qtx.28.1674638984655;
        Wed, 25 Jan 2023 01:29:44 -0800 (PST)
X-Google-Smtp-Source: AK7set/miymPmji0URXPaMfKsdTTs4TjY5AMNfwyDVYyvLKm3Pkt4hwn5ydXGIOn6SOEOGveS+o4mQ==
X-Received: by 2002:a05:622a:1443:b0:3b6:3697:63fa with SMTP id v3-20020a05622a144300b003b6369763famr2710937qtx.28.1674638984343;
        Wed, 25 Jan 2023 01:29:44 -0800 (PST)
Received: from ovpn-194-126.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r2-20020ac83b42000000b003b6464eda40sm3003461qtf.25.2023.01.25.01.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 01:29:43 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Like Xu <likexu@tencent.com>
Subject: Re: [PATCH 2/6] KVM: x86/pmu: Gate all "unimplemented MSR" prints
 on report_ignored_msrs
In-Reply-To: <20230124234905.3774678-3-seanjc@google.com>
References: <20230124234905.3774678-1-seanjc@google.com>
 <20230124234905.3774678-3-seanjc@google.com>
Date:   Wed, 25 Jan 2023 10:29:40 +0100
Message-ID: <87bkmn55dn.fsf@ovpn-194-126.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Add helpers to print unimplemented MSR accesses and condition all such
> prints on report_ignored_msrs, i.e. honor userspace's request to not
> print unimplemented MSRs.  Even though vcpu_unimpl() is ratelimited,
> printing can still be problematic, e.g. if a print gets stalled when host
> userspace is writing MSRs during live migration, an effective stall can
> result in very noticeable disruption in the guest.
>
> E.g. the profile below was taken while calling KVM_SET_MSRS on the PMU
> counters while the PMU was disabled in KVM.
>
>   -   99.75%     0.00%  [.] __ioctl
>    - __ioctl
>       - 99.74% entry_SYSCALL_64_after_hwframe
>            do_syscall_64
>            sys_ioctl
>          - do_vfs_ioctl
>             - 92.48% kvm_vcpu_ioctl
>                - kvm_arch_vcpu_ioctl
>                   - 85.12% kvm_set_msr_ignored_check
>                        svm_set_msr
>                        kvm_set_msr_common
>                        printk
>                        vprintk_func
>                        vprintk_default
>                        vprintk_emit
>                        console_unlock
>                        call_console_drivers
>                        univ8250_console_write
>                        serial8250_console_write
>                        uart_console_write
>
> Reported-by: Aaron Lewis <aaronlewis@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/hyperv.c  | 10 ++++------
>  arch/x86/kvm/svm/svm.c |  5 ++---
>  arch/x86/kvm/vmx/vmx.c |  4 +---
>  arch/x86/kvm/x86.c     | 18 +++++-------------
>  arch/x86/kvm/x86.h     | 12 ++++++++++++
>  5 files changed, 24 insertions(+), 25 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 71aff0edc0ed..3eb8caf87ee4 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1430,8 +1430,7 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
>  	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>  		return syndbg_set_msr(vcpu, msr, data, host);
>  	default:
> -		vcpu_unimpl(vcpu, "Hyper-V unhandled wrmsr: 0x%x data 0x%llx\n",
> -			    msr, data);
> +		kvm_pr_unimpl_wrmsr(vcpu, msr, data);
>  		return 1;
>  	}
>  	return 0;
> @@ -1552,8 +1551,7 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
>  			return 1;
>  		break;
>  	default:
> -		vcpu_unimpl(vcpu, "Hyper-V unhandled wrmsr: 0x%x data 0x%llx\n",
> -			    msr, data);
> +		kvm_pr_unimpl_wrmsr(vcpu, msr, data);
>  		return 1;
>  	}
>  
> @@ -1608,7 +1606,7 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
>  	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>  		return syndbg_get_msr(vcpu, msr, pdata, host);
>  	default:
> -		vcpu_unimpl(vcpu, "Hyper-V unhandled rdmsr: 0x%x\n", msr);
> +		kvm_pr_unimpl_rdmsr(vcpu, msr);
>  		return 1;
>  	}
>  
> @@ -1673,7 +1671,7 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
>  		data = APIC_BUS_FREQUENCY;
>  		break;
>  	default:
> -		vcpu_unimpl(vcpu, "Hyper-V unhandled rdmsr: 0x%x\n", msr);
> +		kvm_pr_unimpl_rdmsr(vcpu, msr);
>  		return 1;
>  	}
>  	*pdata = data;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d13cf53e7390..dd21e8b1a259 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3015,8 +3015,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		break;
>  	case MSR_IA32_DEBUGCTLMSR:
>  		if (!lbrv) {
> -			vcpu_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTL 0x%llx, nop\n",
> -				    __func__, data);
> +			kvm_pr_unimpl_wrmsr(vcpu, ecx, data);
>  			break;
>  		}
>  		if (data & DEBUGCTL_RESERVED_BITS)
> @@ -3045,7 +3044,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  	case MSR_VM_CR:
>  		return svm_set_vm_cr(vcpu, data);
>  	case MSR_VM_IGNNE:
> -		vcpu_unimpl(vcpu, "unimplemented wrmsr: 0x%x data 0x%llx\n", ecx, data);
> +		kvm_pr_unimpl_wrmsr(vcpu, ecx, data);
>  		break;
>  	case MSR_AMD64_DE_CFG: {
>  		struct kvm_msr_entry msr_entry;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c788aa382611..8f0f67c75f35 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2206,9 +2206,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  
>  		invalid = data & ~vmx_get_supported_debugctl(vcpu, msr_info->host_initiated);
>  		if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
> -			if (report_ignored_msrs)
> -				vcpu_unimpl(vcpu, "%s: BTF|LBR in IA32_DEBUGCTLMSR 0x%llx, nop\n",
> -					    __func__, data);
> +			kvm_pr_unimpl_wrmsr(vcpu, msr_index, data);
>  			data &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
>  			invalid &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
>  		}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ad95ce92a154..d4a610ffe2b8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3560,7 +3560,6 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>  
>  int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  {
> -	bool pr = false;
>  	u32 msr = msr_info->index;
>  	u64 data = msr_info->data;
>  
> @@ -3606,15 +3605,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (data == BIT_ULL(18)) {
>  			vcpu->arch.msr_hwcr = data;
>  		} else if (data != 0) {
> -			vcpu_unimpl(vcpu, "unimplemented HWCR wrmsr: 0x%llx\n",
> -				    data);
> +			kvm_pr_unimpl_wrmsr(vcpu, msr, data);
>  			return 1;
>  		}
>  		break;
>  	case MSR_FAM10H_MMIO_CONF_BASE:
>  		if (data != 0) {
> -			vcpu_unimpl(vcpu, "unimplemented MMIO_CONF_BASE wrmsr: "
> -				    "0x%llx\n", data);
> +			kvm_pr_unimpl_wrmsr(vcpu, msr, data);
>  			return 1;
>  		}
>  		break;
> @@ -3794,16 +3791,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  
>  	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
>  	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
> -		pr = true;
> -		fallthrough;
>  	case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
>  	case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
>  		if (kvm_pmu_is_valid_msr(vcpu, msr))
>  			return kvm_pmu_set_msr(vcpu, msr_info);
>  
> -		if (pr || data != 0)
> -			vcpu_unimpl(vcpu, "disabled perfctr wrmsr: "
> -				    "0x%x data 0x%llx\n", msr, data);
> +		if (data)
> +			kvm_pr_unimpl_wrmsr(vcpu, msr, data);

The logic here was that "*_PERFCTR*" MSRs are reported even when 'data
== 0' but looking at the commit 5753785fa977 ("KVM: do not #GP on perf
MSR writes when vPMU is disabled") I can't really say why it was needed.

>  		break;
>  	case MSR_K7_CLK_CTL:
>  		/*
> @@ -3831,9 +3825,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		/* Drop writes to this legacy MSR -- see rdmsr
>  		 * counterpart for further detail.
>  		 */
> -		if (report_ignored_msrs)
> -			vcpu_unimpl(vcpu, "ignored wrmsr: 0x%x data 0x%llx\n",
> -				msr, data);
> +		kvm_pr_unimpl_wrmsr(vcpu, msr, data);
>  		break;
>  	case MSR_AMD64_OSVW_ID_LENGTH:
>  		if (!guest_cpuid_has(vcpu, X86_FEATURE_OSVW))
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 9de72586f406..f3554bf05201 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -331,6 +331,18 @@ extern bool report_ignored_msrs;
>  
>  extern bool eager_page_split;
>  
> +static inline void kvm_pr_unimpl_wrmsr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
> +{
> +	if (report_ignored_msrs)
> +		vcpu_unimpl(vcpu, "Unhandled WRMSR(0x%x) = 0x%llx\n", msr, data);
> +}
> +
> +static inline void kvm_pr_unimpl_rdmsr(struct kvm_vcpu *vcpu, u32 msr)
> +{
> +	if (report_ignored_msrs)
> +		vcpu_unimpl(vcpu, "Unhandled RDMSR(0x%x)\n", msr);
> +}
> +
>  static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
>  {
>  	return pvclock_scale_delta(nsec, vcpu->arch.virtual_tsc_mult,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

