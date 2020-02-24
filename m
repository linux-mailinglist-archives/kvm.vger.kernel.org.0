Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 610CC16A9D1
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 16:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgBXPT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 10:19:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31061 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727581AbgBXPT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 10:19:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582557594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L5S2YkOJ+YGT8KtcQp0VwIkOlKilyj5rI/cUT2U2NV8=;
        b=E2bia/Jaf71Rsv5KQxpUUJ0ZhCJQos1sR5kNodkKyyCnJddKpEa/mIpYSjn+j8B5jt/Dnw
        i5rT6gZ5LEHWI6PgdinXRC/77KenHeRfmkEv07SYPR1HXRFBgv5KdMCAqAgNV9pvxFec54
        B0a0Mjs32fnmwqzcUphAVeviF05F8zc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-5PJgm56CNs-ukgWfwhRzKQ-1; Mon, 24 Feb 2020 10:19:52 -0500
X-MC-Unique: 5PJgm56CNs-ukgWfwhRzKQ-1
Received: by mail-wr1-f72.google.com with SMTP id d9so2529302wrv.21
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 07:19:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=L5S2YkOJ+YGT8KtcQp0VwIkOlKilyj5rI/cUT2U2NV8=;
        b=ncvnipDj4Aju7dBv3iQ1F7Iq2Ol95waEiNX0lpW7wuVn9OPXn66hD8xVFUQJO9bdeG
         g9uef0/XEw94waFp23bwxgjE1u/mPNY5BPxYfpAZweKkwXRuVXEmJbUC6QLpL3MfT48c
         1FR8maxoAN7M/Rz9wKtjs7Nx/0bzCOr/uWcoGF0uJTKmR/+OSkg4rMAvBjYQsRmD5NjV
         qpgfmIZr7FUD8JkUcVjrz92rRtD0SpPdV6313spHiOcfpwZiITz9/oCyVYf5eZwR/UpI
         HGak2dluS2kPFyY+dgqyTQCPqaEGBj96cmVZLryNi+hFQ9b72HW6sWdKOHWVbpkatW/v
         9nLQ==
X-Gm-Message-State: APjAAAWD0yXq3Dd35CZADbq3p847xMHCRavtZ1cutOJfAMd20MronJ5o
        ctlEauG1+xMxQdVBdGRw5E15H8l1S1StVA0i5HJH5w0vZ4gvPvqIirE4mQ1U8KxISWFV0kv+Lwa
        tt0yWUfw9weRY
X-Received: by 2002:a1c:f21a:: with SMTP id s26mr22757896wmc.39.1582557591020;
        Mon, 24 Feb 2020 07:19:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqyZ0xq73pUXOC2yZODFFxqdsdkZNnMc/g/QtJ2RejQB4yqvqtClPsF80RhNK+Pnn4IaECxe5Q==
X-Received: by 2002:a1c:f21a:: with SMTP id s26mr22757869wmc.39.1582557590783;
        Mon, 24 Feb 2020 07:19:50 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id s22sm17868322wmh.4.2020.02.24.07.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 07:19:50 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 31/61] KVM: x86: Handle INVPCID CPUID adjustment in VMX code
In-Reply-To: <20200201185218.24473-32-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-32-sean.j.christopherson@intel.com>
Date:   Mon, 24 Feb 2020 16:19:49 +0100
Message-ID: <871rqkovvu.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Move the INVPCID CPUID adjustments into VMX to eliminate an instance of
> the undesirable "unsigned f_* = *_supported ? F(*) : 0" pattern in the
> common CPUID handling code.  Drop ->invpcid_supported(), CPUID
> adjustment was the only user.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 -
>  arch/x86/kvm/cpuid.c            |  3 +--
>  arch/x86/kvm/svm.c              |  6 ------
>  arch/x86/kvm/vmx/vmx.c          | 10 +++-------
>  4 files changed, 4 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a61928d5435b..9baff70ad419 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1144,7 +1144,6 @@ struct kvm_x86_ops {
>  	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
>  	int (*get_lpage_level)(void);
>  	bool (*rdtscp_supported)(void);
> -	bool (*invpcid_supported)(void);
>  
>  	void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
>  
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 09e24d1d731c..a5f150204d73 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -339,7 +339,6 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
>  
>  static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
>  {
> -	unsigned f_invpcid = kvm_x86_ops->invpcid_supported() ? F(INVPCID) : 0;
>  	unsigned f_umip = kvm_x86_ops->umip_emulated() ? F(UMIP) : 0;
>  	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
>  	unsigned f_la57;
> @@ -348,7 +347,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
>  	/* cpuid 7.0.ebx */
>  	const u32 kvm_cpuid_7_0_ebx_x86_features =
>  		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
> -		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | 0 /*MPX*/ | F(RDSEED) |
> +		F(BMI2) | F(ERMS) | 0 /*INVPCID*/ | F(RTM) | 0 /*MPX*/ | F(RDSEED) |
>  		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
>  		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
>  		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt;
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 7bb5d81f0f11..c0f8c09f3b04 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -6074,11 +6074,6 @@ static bool svm_rdtscp_supported(void)
>  	return boot_cpu_has(X86_FEATURE_RDTSCP);
>  }
>  
> -static bool svm_invpcid_supported(void)
> -{
> -	return false;
> -}
> -
>  static bool svm_xsaves_supported(void)
>  {
>  	return boot_cpu_has(X86_FEATURE_XSAVES);
> @@ -7459,7 +7454,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>  	.cpuid_update = svm_cpuid_update,
>  
>  	.rdtscp_supported = svm_rdtscp_supported,
> -	.invpcid_supported = svm_invpcid_supported,
>  	.xsaves_supported = svm_xsaves_supported,
>  	.umip_emulated = svm_umip_emulated,
>  	.pt_supported = svm_pt_supported,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 143193fc178e..49ee4c600934 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1656,11 +1656,6 @@ static bool vmx_rdtscp_supported(void)
>  	return cpu_has_vmx_rdtscp();
>  }
>  
> -static bool vmx_invpcid_supported(void)
> -{
> -	return cpu_has_vmx_invpcid();
> -}
> -
>  /*
>   * Swap MSR entry in host/guest MSR entry array.
>   */
> @@ -4071,7 +4066,7 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>  		}
>  	}
>  
> -	if (vmx_invpcid_supported()) {
> +	if (cpu_has_vmx_invpcid()) {
>  		/* Exposing INVPCID only when PCID is exposed */
>  		bool invpcid_enabled =
>  			guest_cpuid_has(vcpu, X86_FEATURE_INVPCID) &&
> @@ -7114,6 +7109,8 @@ static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
>  	case 0x7:
>  		if (boot_cpu_has(X86_FEATURE_MPX) && kvm_mpx_supported())
>  			cpuid_entry_set(entry, X86_FEATURE_MPX);
> +		if (boot_cpu_has(X86_FEATURE_INVPCID) && cpu_has_vmx_invpcid())
> +			cpuid_entry_set(entry, X86_FEATURE_INVPCID);
>  		break;
>  	default:
>  		break;
> @@ -7854,7 +7851,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>  	.cpuid_update = vmx_cpuid_update,
>  
>  	.rdtscp_supported = vmx_rdtscp_supported,
> -	.invpcid_supported = vmx_invpcid_supported,
>  
>  	.set_supported_cpuid = vmx_set_supported_cpuid,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

