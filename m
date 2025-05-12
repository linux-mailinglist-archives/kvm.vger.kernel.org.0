Return-Path: <kvm+bounces-46259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 871C5AB44B0
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 21:16:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D44716D3FC
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 19:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1790C298CB8;
	Mon, 12 May 2025 19:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xnR/l2GV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849A72980BE
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 19:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747077226; cv=none; b=lU1ufEbuNLrHZd4g94luGAw/xbxmHaJDe+EEpZghUeGbR7TvQmjkanh5PkTWhMi0JhnCr0e+fWrJBmtgs0LKg/LYjSkmwG9HC1az7lgYz+dXw9C2Wf+oEhRWwc54o7T0xXtt8dKD7WU0ESuCS7QGIlZlVsKTeuBo30ZThfzNl0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747077226; c=relaxed/simple;
	bh=hOzShn0d1VpvoCf2Jm+K+rqtd4i4H7Bs81YA329/3dI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rx3SD3R9LnrFc7PQ8e0rPBJldhUn6pw6Tuoy55OqDBXgEsUY7OSPV2npGrmO/jbt7xu05FRrSUHHxWlhimXLkiy1VimNN1fO4ihCnO6zk3hvC6LfGgY54aiADq+Ct6pDNZ3eV98fK1aKabq6t4XyLE5SA876o2asIOMec+x+lTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xnR/l2GV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30c9b0aa4ccso1545065a91.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 12:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747077224; x=1747682024; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lJx9UOI4PMOst2OpE9us15li238FLNTl40Rp91/Ppb4=;
        b=xnR/l2GVbfn4Q4Bw3GkXCKLRsEMupj/lIDncUadw54fADY8++5K46SQ+vs3gGtD5/2
         fkRhCGMJucNuK6ixM/sg/IH150MKkwAw2H+nujd5XRvD61SWVfM3Gg0tI+aSlRvuZHym
         yiXVRZF3Yp78buxdXCn1EwiJw/pSJpBX1ry3HFPjLZOvHzMlvAnC3Gxbd4D8pGHuHLgM
         Xqn8Bu7S16RbtSuubmE3JusiR3USPhgYuIanDr6NJgt6vhwiJIanC6en2hGwHEfWqM3w
         H5f6QDWAr6IJTMj18ZgLt0EKW/UlUpmYzTOWLN1jPSxLLJPlVkbQu8OwTWGTpKfjs4E2
         21SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747077224; x=1747682024;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lJx9UOI4PMOst2OpE9us15li238FLNTl40Rp91/Ppb4=;
        b=IBMA1a7q0IGEV9wnigC5ZSaSw+pmqmF1lYVBjq5COG83/e7yyn9zgKrrrAU8NINhAs
         9fQMnrHKGg39VIrvzwE5azttFHCmtb16kxZAcTMx4kKh7QZ2zi7iQbN+94FIgGYwFoR4
         vvtgP+RCrTYtVCnJJB80k+0Z0qA32d5KP8Pas1llRGGAyErQx6j2yknlGo29N2rYJ98P
         cwEPxizZ44nmA1pHr5tms61HP9QzOHEwvtPF2AGDrPtPcOghL9dMZjm9EkEbKphAsnpa
         doHUbvGgj9jLaVc8+p/9nuQ+03qzEVRrEYNSydUO9UdLAIBeA9aHdxIunYIsg9R0o6aK
         k2oA==
X-Forwarded-Encrypted: i=1; AJvYcCXGaLt6TVmAKWko8EVk1bDAB6+rwxhEL9jILOkWLWivmjsyRgcHJZ+wchSpJLS4GPlsWWg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfMw8y/N2C0HtashYT5piy0kOA2nPk00qqRlRru7yUiwAfXMG3
	1rq5xQzqNQzFFolR7FH+O7U0vv+hQ6Wi3oq10FfsaLY0ibUwAy4XLceK74qE9qKHlGv5wtJ67Xw
	aYg==
X-Google-Smtp-Source: AGHT+IG/DheF6+DB5H/MuBZC30AE1eW2qEhr5QdZeTJGOjHWqmwrfunvk18P9rn5Ac2Y/Af/I9choRB0WCI=
X-Received: from pjbqx15.prod.google.com ([2002:a17:90b:3e4f:b0:309:da3b:15d1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b4b:b0:308:6d7a:5d30
 with SMTP id 98e67ed59e1d1-30c3d3e0a86mr24720902a91.18.1747077223739; Mon, 12
 May 2025 12:13:43 -0700 (PDT)
Date: Mon, 12 May 2025 12:13:42 -0700
In-Reply-To: <20250313203702.575156-13-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250313203702.575156-1-jon@nutanix.com> <20250313203702.575156-13-jon@nutanix.com>
Message-ID: <aCJIZgHi67_lze_v@google.com>
Subject: Re: [RFC PATCH 12/18] KVM: x86/mmu: Introduce shadow_ux_mask
From: Sean Christopherson <seanjc@google.com>
To: Jon Kohler <jon@nutanix.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sergey Dyasli <sergey.dyasli@nutanix.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2025, Jon Kohler wrote:
> @@ -28,6 +28,7 @@ u64 __read_mostly shadow_host_writable_mask;
>  u64 __read_mostly shadow_mmu_writable_mask;
>  u64 __read_mostly shadow_nx_mask;
>  u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
> +u64 __read_mostly shadow_ux_mask;
>  u64 __read_mostly shadow_user_mask;
>  u64 __read_mostly shadow_accessed_mask;
>  u64 __read_mostly shadow_dirty_mask;
> @@ -313,8 +314,14 @@ u64 make_huge_page_split_spte(struct kvm *kvm, u64 h=
uge_spte,
>  		 * the page executable as the NX hugepage mitigation no longer
>  		 * applies.
>  		 */
> -		if ((role.access & ACC_EXEC_MASK) && is_nx_huge_page_enabled(kvm))
> +		if ((role.access & ACC_EXEC_MASK) && is_nx_huge_page_enabled(kvm)) {

This is wrong, and probably so is every other chunk of KVM that looks at
ACC_EXEC_MASK.  E.g. if a guest hugepage is executable for user but not sup=
ervisor,
KVM will fail to make the small child user-executable.

The bug in make_spte() is even worse, because KVM would let an MBEC-aware g=
uest
trigger the iTLB multi-hit #MC.

>  			child_spte =3D make_spte_executable(child_spte);
> +			// TODO: For LKML: switch to vcpu->arch.pt_guest_exec_control? up
> +			// for suggestions on how best to toggle this.

No, it belongs in the role.

> +			if (enable_pt_guest_exec_control &&
> +			    role.access & ACC_USER_EXEC_MASK)
> +				child_spte |=3D shadow_ux_mask;
> +		}
>  	}
> =20
>  	return child_spte;
> @@ -326,7 +333,7 @@ u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled=
)
>  	u64 spte =3D SPTE_MMU_PRESENT_MASK;
> =20
>  	spte |=3D __pa(child_pt) | shadow_present_mask | PT_WRITABLE_MASK |
> -		shadow_user_mask | shadow_x_mask | shadow_me_value;
> +		shadow_user_mask | shadow_x_mask | shadow_ux_mask | shadow_me_value;
> =20
>  	if (ad_disabled)
>  		spte |=3D SPTE_TDP_AD_DISABLED;
> @@ -420,7 +427,8 @@ void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_ma=
sk)
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_set_me_spte_mask);
> =20
> -void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
> +void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only,
> +			   bool has_guest_exec_ctrl)
>  {
>  	shadow_user_mask	=3D VMX_EPT_READABLE_MASK;
>  	shadow_accessed_mask	=3D has_ad_bits ? VMX_EPT_ACCESS_BIT : 0ull;
> @@ -428,8 +436,14 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool ha=
s_exec_only)
>  	shadow_nx_mask		=3D 0ull;
>  	shadow_x_mask		=3D VMX_EPT_EXECUTABLE_MASK;
>  	/* VMX_EPT_SUPPRESS_VE_BIT is needed for W or X violation. */
> +	// For LKML Review:
> +	// Do we need to modify shadow_present_mask in the MBEC case?

No, because MBEC bifurcates X, it doesn't change whether or not an EPTE can=
 be
X without being R.  From the SDM:

  1. If the =E2=80=9Cmode-based execute control for EPT=E2=80=9D VM-executi=
on control is 1,
     setting bit 0 indicates also that software may also configure EPT
     paging-structure entries in which bits 1:0 are both clear and in which=
 bit 10
     is set (indicating a translation that can be used to fetch instruction=
s from a
     supervisor-mode linear address or a user-mode linear address).

>  	shadow_present_mask	=3D
>  		(has_exec_only ? 0ull : VMX_EPT_READABLE_MASK) | VMX_EPT_SUPPRESS_VE_B=
IT;
> +
> +	shadow_ux_mask		=3D
> +		has_guest_exec_ctrl ? VMX_EPT_USER_EXECUTABLE_MASK : 0ull;

This is EPT specific code, just call this what it is:

	shadow_ux_mask		=3D has_mbec ? VMX_EPT_USER_EXECUTABLE_MASK : 0ull;
> +
>  	/*
>  	 * EPT overrides the host MTRRs, and so KVM must program the desired
>  	 * memtype directly into the SPTEs.  Note, this mask is just the mask
> @@ -484,6 +498,7 @@ void kvm_mmu_reset_all_pte_masks(void)
>  	shadow_dirty_mask	=3D PT_DIRTY_MASK;
>  	shadow_nx_mask		=3D PT64_NX_MASK;
>  	shadow_x_mask		=3D 0;
> +	shadow_ux_mask		=3D 0;
>  	shadow_present_mask	=3D PT_PRESENT_MASK;
> =20
>  	/*
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index d9e22133b6d0..dc2f0dc9c46e 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -171,6 +171,7 @@ extern u64 __read_mostly shadow_mmu_writable_mask;
>  extern u64 __read_mostly shadow_nx_mask;
>  extern u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask=
 */
>  extern u64 __read_mostly shadow_user_mask;
> +extern u64 __read_mostly shadow_ux_mask;
>  extern u64 __read_mostly shadow_accessed_mask;
>  extern u64 __read_mostly shadow_dirty_mask;
>  extern u64 __read_mostly shadow_mmio_value;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0aadfa924045..d16e3f170258 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8544,7 +8544,8 @@ __init int vmx_hardware_setup(void)
> =20
>  	if (enable_ept)
>  		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
> -				      cpu_has_vmx_ept_execute_only());
> +				      cpu_has_vmx_ept_execute_only(),
> +				      enable_pt_guest_exec_control);

Without the module param, just cpu_has_vmx_mbec().

