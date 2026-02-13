Return-Path: <kvm+bounces-71029-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2D97CMlwjmmLCQEAu9opvQ
	(envelope-from <kvm+bounces-71029-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 01:31:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D70C132116
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 01:31:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1585F304438C
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 00:31:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F39C1C84A2;
	Fri, 13 Feb 2026 00:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e0m6iYq1"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF44310E3
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 00:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770942657; cv=none; b=dIZsEQwV22lpc6Blc4RTEAUFDXMAASBpu9neXtqj32Kd9J7NTOFcbWBF45OuK3uLuBRVWwB7B/cnPNapX1yXVz9ObpajGqR74k6ZGY6Oo8l2AUiwMzbmTRo2lDGTdEs1qV88x9L2Vq7+QXkYBhlSUzcFmfv7aQJCVHdZaRgyY9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770942657; c=relaxed/simple;
	bh=TXogOU8zXhxRTse9pwSh4fo0BA30PE26ms2OzcX7FS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O0IoK6aE/UELhjMXSXavBQJZ2eBjZnjJhx46M0x+KsdVF0b3mJJjYLlMQAZSr+njS2GOXmNKMLKp3568345tqGYMydwRRUneDQ19kjtq8w/JQTV4vfgX43iW+XPqFt3Dt4gtzgxLQ8FtxshycrpX/QRZv4v32rzp2E/ENogV/MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e0m6iYq1; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 13 Feb 2026 00:30:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770942653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ffFkfOgLGVPPMsTLCIISqoDKpdT8cD9bfGdBJAoo0hs=;
	b=e0m6iYq1f/E6pKLgFgZK1/9mSRfy/9zwFNZFgwWRzWZxuVeWeX25GBra2hRnjZnbvM/F/u
	+DRYNZvXLCcDMBMdN4ovd/tJspUcdH9pLdIwzoy/oahjOO4tuLjhftjSaiM61gFVojuyj2
	Nt+MtF1r51P6w/yG2ttUdFu7RtieiEI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 4/8] KVM: x86: nSVM: Redirect IA32_PAT accesses to
 either hPAT or gPAT
Message-ID: <gqj4y6awen5dfxy32lbskcxw6xdv4xiiouycyftjacndjinhvp@7p4dtgdh6tjw>
References: <20260212155905.3448571-1-jmattson@google.com>
 <20260212155905.3448571-5-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212155905.3448571-5-jmattson@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-71029-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.dev:dkim]
X-Rspamd-Queue-Id: 8D70C132116
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 07:58:52AM -0800, Jim Mattson wrote:
> When the vCPU is in guest mode with nested NPT enabled, guest accesses to
> IA32_PAT are redirected to the gPAT register, which is stored in
> svm->nested.save.g_pat.
> 
> Non-guest accesses (e.g. from userspace) to IA32_PAT are always redirected
> to hPAT, which is stored in vcpu->arch.pat.
> 
> This is architected behavior. It also makes it possible to restore a new
> checkpoint on an old kernel with reasonable semantics. After the restore,
> gPAT will be lost, and L2 will run on L1's PAT. Note that the old kernel
> would have always run L2 on L1's PAT.
> 
> Add WARN_ON_ONCE to both svm_get_msr() and svm_set_msr() to flag any
> host-initiated accesses originating from KVM itself rather than userspace.
> 
> Fixes: 15038e147247 ("KVM: SVM: obey guest PAT")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/svm/nested.c |  9 ---------
>  arch/x86/kvm/svm/svm.c    | 37 ++++++++++++++++++++++++++++++-------
>  arch/x86/kvm/svm/svm.h    | 17 ++++++++++++++++-
>  3 files changed, 46 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index dc8275837120..69b577a4915c 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -706,15 +706,6 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
>  	return 0;
>  }
>  
> -void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
> -{
> -	if (!svm->nested.vmcb02.ptr)
> -		return;
> -
> -	/* FIXME: merge g_pat from vmcb01 and vmcb12.  */
> -	vmcb_set_gpat(svm->nested.vmcb02.ptr, svm->vmcb01.ptr->save.g_pat);
> -}
> -
>  static void nested_vmcb02_prepare_save(struct vcpu_svm *svm)
>  {
>  	struct vmcb_ctrl_area_cached *control = &svm->nested.ctl;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 529cbac57814..205bf07896ad 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2837,6 +2837,21 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_AMD64_DE_CFG:
>  		msr_info->data = svm->msr_decfg;
>  		break;
> +	case MSR_IA32_CR_PAT:
> +		/*
> +		 * When nested NPT is enabled, L2 has a separate PAT from
> +		 * L1.  Guest accesses to IA32_PAT while running L2 target
> +		 * L2's gPAT; host-initiated accesses always target L1's
> +		 * hPAT for backward and forward KVM_GET_MSRS compatibility
> +		 * with older kernels.
> +		 */
> +		WARN_ON_ONCE(msr_info->host_initiated && vcpu->wants_to_run);
> +		if (!msr_info->host_initiated && is_guest_mode(vcpu) &&
> +		    nested_npt_enabled(svm))
> +			msr_info->data = svm->nested.save.g_pat;
> +		else
> +			msr_info->data = vcpu->arch.pat;
> +		break;
>  	default:
>  		return kvm_get_msr_common(vcpu, msr_info);
>  	}
> @@ -2920,13 +2935,21 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  
>  		break;
>  	case MSR_IA32_CR_PAT:
> -		ret = kvm_set_msr_common(vcpu, msr);
> -		if (ret)
> -			break;
> -
> -		vmcb_set_gpat(svm->vmcb01.ptr, data);
> -		if (is_guest_mode(vcpu))
> -			nested_vmcb02_compute_g_pat(svm);
> +		if (!kvm_pat_valid(data))
> +			return 1;
> +		/*
> +		 * When nested NPT is enabled, L2 has a separate PAT from
> +		 * L1.  Guest accesses to IA32_PAT while running L2 target
> +		 * L2's gPAT; host-initiated accesses always target L1's
> +		 * hPAT for backward and forward KVM_SET_MSRS compatibility
> +		 * with older kernels.
> +		 */
> +		WARN_ON_ONCE(msr->host_initiated && vcpu->wants_to_run);
> +		if (!msr->host_initiated && is_guest_mode(vcpu) &&
> +		    nested_npt_enabled(svm))
> +			svm_set_gpat(svm, data);
> +		else
> +			svm_set_hpat(svm, data);
>  		break;
>  	case MSR_IA32_SPEC_CTRL:
>  		if (!msr->host_initiated &&
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index a49c48459e0b..88549705133f 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -607,6 +607,22 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
>  	return svm->nested.ctl.misc_ctl & SVM_MISC_ENABLE_NP;
>  }
>  
> +static inline void svm_set_gpat(struct vcpu_svm *svm, u64 data)
> +{
> +	svm->nested.save.g_pat = data;
> +	vmcb_set_gpat(svm->nested.vmcb02.ptr, data);
> +}
> +
> +static inline void svm_set_hpat(struct vcpu_svm *svm, u64 data)
> +{
> +	svm->vcpu.arch.pat = data;
> +	if (npt_enabled) {
> +		vmcb_set_gpat(svm->vmcb01.ptr, data);
> +		if (is_guest_mode(&svm->vcpu) && !nested_npt_enabled(svm))
> +			vmcb_set_gpat(svm->nested.vmcb02.ptr, data);
> +	}
> +}

Is it me, or is it a bit confusing that svm_set_gpat() sets L2's gPAT
not L1's, and svm_set_hpat() calls vmcb_set_gpat()?

"gpat" means different things in the context of the VMCB or otherwise,
which kinda makes sense but is also not super clear. Maybe
svm_set_l1_gpat() and svm_set_l2_gpat() is more clear?

Will leave it up to Sean to decide if the naming is good enough, but
honestly I don't want to stall this series, so hopefully any renames can
be done as a follow up or when the series is applied.

> +
>  static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
>  {
>  	return guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_VNMI) &&
> @@ -840,7 +856,6 @@ void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
>  void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
>  				    struct vmcb_save_area *save);
>  void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
> -void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
>  void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
>  
>  extern struct kvm_x86_nested_ops svm_nested_ops;
> -- 
> 2.53.0.239.g8d8fc8a987-goog
> 

