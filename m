Return-Path: <kvm+bounces-36895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B0613A227A6
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 03:17:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 207D91886097
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 02:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAEDC38DD3;
	Thu, 30 Jan 2025 02:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wMZKFrvm"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753C58F58
	for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 02:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738203442; cv=none; b=TK86U2a2T5sVJ1Asmx82nGktcf/dRCIGej1X40z6Yy6AR0+59bSKU/lVeuQmdiITiwTAy3R5GsYguNTTZE7ZAgVcRy1uF5/4iOwAPO8fMKTBvwk6m6FrxXUWKS2jmhhAOP5iK326LduclUV/cwnlU6clu8dO1j70/l5NofvhShA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738203442; c=relaxed/simple;
	bh=k2ahaWMNxAJi1RUyuz7HG+Pjbs9YD0No7Dbet9o5ZXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fmial4F7dMZyk4TAE0+vBDvx0w/676WiDRDYKWOf7hOjPhx/V67ZTnDCa7u7Ggvy6hvlfR+Qt5UZpSL7Z608Drrl9OUz1GVnZgBhRlUGAc/uN0U77W47abbgLNgAw7NsuTvwyxHHLU45EMWIMXvRkhxpmt4lCJ0E9Cj22qE4mhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wMZKFrvm; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 30 Jan 2025 02:17:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738203427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MBlX82d4STzokLElvffOzFUNWqH0dO46wN3C2YfIhZM=;
	b=wMZKFrvmjNWbdkHkKBOb8mvK6r9f1d6/5nRLHfeEj81JksHeLTC/Ksb68EK5qDG1o+huh5
	CvRMoq2IIbYXrSZxmfygG0LQA9Nw3T/iBkl1h/JuyAp7GFukOdl3C+kCH1V1lEjyhruPFc
	ge5ano2M6wnAtSgseRg3SUcFsfuzKos=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nSVM: Enter guest mode before initializing nested
 NPT MMU
Message-ID: <Z5rhH342Jghl2tgL@google.com>
References: <20250130010825.220346-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250130010825.220346-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 29, 2025 at 05:08:25PM -0800, Sean Christopherson wrote:
> When preparing vmcb02 for nested VMRUN (or state restore), "enter" guest
> mode prior to initializing the MMU for nested NPT so that guest_mode is
> set in the MMU's role.  KVM's model is that all L2 MMUs are tagged with
> guest_mode, as the behavior of hypervisor MMUs tends to be significantly
> different than kernel MMUs.
> 
> Practically speaking, the bug is relatively benign, as KVM only directly
> queries role.guest_mode in kvm_mmu_free_guest_mode_roots(), which SVM
> doesn't use, and in paths that are optimizations (mmu_page_zap_pte() and
> shadow_mmu_try_split_huge_pages()).

Just curious, what about kvm_mmu_page_ad_need_write_protect()? Is it
also bengin?

> 
> And while the role is incorprated into shadow page usage, because nested
> NPT requires KVM to be using NPT for L1, reusing shadow pages across L1
> and L2 is impossible as L1 MMUs will always have direct=1, while L2 MMUs
> will have direct=0.
> 
> Hoist the TLB processing and setting of HF_GUEST_MASK to the beginning
> of the flow instead of forcing guest_mode in the MMU, as nothing in
> nested_vmcb02_prepare_control() between the old and new locations touches
> TLB flush requests or HF_GUEST_MASK, i.e. there's no reason to present
> inconsistent vCPU state to the MMU.
> 
> Fixes: 69cb877487de ("KVM: nSVM: move MMU setup to nested_prepare_vmcb_control")
> Cc: stable@vger.kernel.org
> Reported-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

FWIW:

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  arch/x86/kvm/mmu/mmu.c    |  2 +-
>  arch/x86/kvm/svm/nested.c | 10 +++++-----
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 74fa38ebddbf..3ff55a18347d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5524,7 +5524,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
>  	union kvm_mmu_page_role root_role;
>  
>  	/* NPT requires CR0.PG=1. */
> -	WARN_ON_ONCE(cpu_role.base.direct);
> +	WARN_ON_ONCE(cpu_role.base.direct || !cpu_role.base.guest_mode);
>  
>  	root_role = cpu_role.base;
>  	root_role.level = kvm_mmu_get_tdp_level(vcpu);
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index d77b094d9a4d..04c375bf1ac2 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -646,6 +646,11 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  	u32 pause_count12;
>  	u32 pause_thresh12;
>  
> +	nested_svm_transition_tlb_flush(vcpu);
> +
> +	/* Enter Guest-Mode */
> +	enter_guest_mode(vcpu);
> +
>  	/*
>  	 * Filled at exit: exit_code, exit_code_hi, exit_info_1, exit_info_2,
>  	 * exit_int_info, exit_int_info_err, next_rip, insn_len, insn_bytes.
> @@ -762,11 +767,6 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  		}
>  	}
>  
> -	nested_svm_transition_tlb_flush(vcpu);
> -
> -	/* Enter Guest-Mode */
> -	enter_guest_mode(vcpu);
> -
>  	/*
>  	 * Merge guest and host intercepts - must be called with vcpu in
>  	 * guest-mode to take effect.
> 
> base-commit: eb723766b1030a23c38adf2348b7c3d1409d11f0
> -- 
> 2.48.1.262.g85cc9f2d1e-goog
> 

