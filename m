Return-Path: <kvm+bounces-52167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D2D1CB01E7E
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 16:00:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E8DEB7BF2A1
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 149E02DD5EF;
	Fri, 11 Jul 2025 13:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iZP7FOZx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBEA2D839A
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 13:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752242360; cv=none; b=f/sCvw2l6DaDIW15aNtvncT3Canfhvs8EoiHQXfBjoPeubygJkgpdv7c2MOTzDKheRFpdLqVh+BI+1Vr+PZSLzqZ5FPTAEIOv46TGoqwBOai7U8QRq2HiP0485tE3MfbUhYgvXsZCqHbjYopR37HoIKJII+g2i7n/gG8b3yurnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752242360; c=relaxed/simple;
	bh=Dt4qn9phenTKjNb8Z3vhHvDiiEzvHwV7n7x/RITTuLI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sp7ZPb4xYQndTrLEhwlYwtF0yyaNgoNhHnZ85cxTrfjhicV7/HLYG5uuqww2AvBEK9A3NhjHy5fDLi7GKKW7LpZQnyu4xXHNvXtwqVnY9IR2Dagmj++N4Xr6R/EeamIVelMPksiClaasw0t9BltodjyHkUNh9ZFQFtisRUeN96o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iZP7FOZx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-315b60c19d4so1887540a91.0
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 06:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752242358; x=1752847158; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7a5a3fErkgge97zEu8ffiiTzf/WljRZ6mWF9WxIyy9g=;
        b=iZP7FOZx8qqvbNx1xFzx6UE5GcuXPXfAnu1h+TS0PJviqT6mFoZjAOoERSKKbtHq5Z
         cFclZJ2W3ZGB2d9lcfohbbHDwqAIvAybA02IgWoYrluC19BvM/EeY1Jpi1MCrlx4afRS
         asibHUFiDfEpAMND1TRNfwSN0Hm9UMeFd1QFoykyhE4zmu221UkCV17y7AlfqpzSlyOA
         OhCinI1CZqL5oq7CUQip61KPzu+w4GD88pitQOb9GnV5yGPOSK18j/jIKUyyhzfylxIO
         EKW2+jW1lARXDEio1+6Z7yKPkB8/PmjtFH20hjIhSEoVTDYACtsk1lECK9KxGlsnLdq1
         jtTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752242358; x=1752847158;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7a5a3fErkgge97zEu8ffiiTzf/WljRZ6mWF9WxIyy9g=;
        b=aS6F3cHfeoZ+MZOPTLhMrqt0YKI5jh6z1hTy0f8xk/leck5mJ1vnh1/vFmZeYPX923
         PgkZaDIZ5D91X/IbFyfbj+qoUn1CIdS4xmgzFurJ5tFuNFTf6m9NoCxLSSnlmM9DzhhM
         wIbxSOjx4ApMgihotbNC8u2vvd4yRIjhUgVhEMUkpTpmF0GCT2CUbY4N9cO9K4E4cP/u
         tGgcd1FJgViGIvpZk1FcFAuJJGtM4CZwFVNz7iEmbX0LyBLt/5LSgkcHvscTIudNvf6L
         P+07ZBlLIG+sz27tHOO4RLFjKmuFwVOujRUJ1jnPn8xzDm9B6+0GiTzQx/YaybF2FHbB
         jQhA==
X-Forwarded-Encrypted: i=1; AJvYcCVFDDtPKgbcRNUiz6gMmoMXWON18LIMDkVM23MhpIpGDtrM+eENL42mJ0hsuv+9j6g5shU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwErFeDECUNWEse5VPvh07/8HfY3PJnMwAIGxJaPLDH3+mpHj6/
	CqwKJjtuZxyTcnRNtRKoNXAxlrDuu1Nr160LgERvZyGO61IW8oK4PX/whGQjLLHLkns7FP99s/L
	yGqOLyg==
X-Google-Smtp-Source: AGHT+IGraauLonvEm6JYMaaX15jKkM3IWDCaMsfevV3/3SZnj3Sw/6tDdfnBW1eWZbmSwzgbxYHhyST7ug0=
X-Received: from pjxx11.prod.google.com ([2002:a17:90b:58cb:b0:308:6685:55e6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5645:b0:312:26d9:d5b2
 with SMTP id 98e67ed59e1d1-31c4c972577mr5840590a91.0.1752242358156; Fri, 11
 Jul 2025 06:59:18 -0700 (PDT)
Date: Fri, 11 Jul 2025 06:59:16 -0700
In-Reply-To: <20250523095322.88774-4-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523095322.88774-1-chao.gao@intel.com> <20250523095322.88774-4-chao.gao@intel.com>
Message-ID: <aHEYtGgA3aIQ7A3y@google.com>
Subject: Re: [RFC PATCH 03/20] x86/virt/seamldr: Introduce a wrapper for
 P-SEAMLDR SEAMCALLs
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, x86@kernel.org, kvm@vger.kernel.org, 
	pbonzini@redhat.com, eddie.dong@intel.com, kirill.shutemov@intel.com, 
	dave.hansen@intel.com, dan.j.williams@intel.com, kai.huang@intel.com, 
	isaku.yamahata@intel.com, elena.reshetova@intel.com, 
	rick.p.edgecombe@intel.com, Farrah Chen <farrah.chen@intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, May 23, 2025, Chao Gao wrote:
> +static __maybe_unused int seamldr_call(u64 fn, struct tdx_module_args *args)
> +{
> +	u64 vmcs;
> +	int ret;
> +
> +	if (!is_seamldr_call(fn))
> +		return -EINVAL;
> +
> +	/*
> +	 * SEAMRET from P-SEAMLDR invalidates the current-VMCS pointer.

I'd rather this use human-friendly language as opposed to the SDM's pedantic
terminology, e.g. just "current VMCS".

> +	 * Save/restore current-VMCS pointer across P-SEAMLDR SEAMCALLs so
> +	 * that VMX instructions won't fail due to an invalid current-VMCS.
> +	 *
> +	 * Disable interrupt to prevent SMP call functions from seeing the

I would rather we establish a rule that KVM is allowed to do VMREAD/VMWRITE in
IRQ context, i.e. don't single out SMP function calls.

> +	 * invalid current-VMCS.
> +	 */
> +	guard(irqsave)();
> +
> +	ret = cpu_vmcs_store(&vmcs);
> +	if (ret)
> +		return ret;
> +
> +	ret = seamldr_prerr(fn, args);
> +
> +	/* Restore current-VMCS pointer */
> +#define INVALID_VMCS   -1ULL
> +	if (vmcs != INVALID_VMCS)
> +	       WARN_ON_ONCE(cpu_vmcs_load(vmcs));
> +
> +	return ret;
> +}
> diff --git a/arch/x86/virt/vmx/vmx.h b/arch/x86/virt/vmx/vmx.h
> new file mode 100644
> index 000000000000..51e6460fd1fd
> --- /dev/null
> +++ b/arch/x86/virt/vmx/vmx.h
> @@ -0,0 +1,40 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef ARCH_X86_VIRT_VMX_H
> +#define ARCH_X86_VIRT_VMX_H
> +
> +#include <linux/printk.h>
> +
> +static inline int cpu_vmcs_load(u64 vmcs_pa)
> +{
> +	asm goto("1: vmptrld %0\n\t"
> +			  ".byte 0x2e\n\t" /* branch not taken hint */


Heh, don't copy paste the crappy indentation, that was a result of Linus' tree-wide
changes from 4356e9f841f7 ("work around gcc bugs with 'asm goto' with outputs"),
i.e. not intentional.

Regarding question #3 from the cover letter:

  3. Two helpers, cpu_vmcs_load() and cpu_vmcs_store(), are added in patch 3
     to save and restore the current VMCS. KVM has a variant of cpu_vmcs_load(),
     i.e., vmcs_load(). Extracting KVM's version would cause a lot of code
     churn, and I don't think that can be justified for reducing ~16 LoC
     duplication. Please let me know if you disagree.

I'm fine with the SEAMLDR code having its own code, because I agree it's not worth
extracting KVM's macro maze just to get at VMPTRLD.  But I'm not fine with creating
a new, inferior framework.  So if we elect to leave KVM alone for the time being,
I would prefer to simply open code VMPTRST and VMPTRLD in seamldr.c, e.g.

static inline int seamldr_call(u64 fn, struct tdx_module_args *args)
{
	u64 vmcs;
	int ret;

	if (!is_seamldr_call(fn))
		return -EINVAL;

	/*
	 * SEAMRET from P-SEAMLDR invalidates the current VMCS.  Save/restore
	 * the VMCS across P-SEAMLDR SEAMCALLs to avoid clobbering KVM state.
	 * Disable interrupts as KVM is allowed to do VMREAD/VMWRITE in IRQ
	 * context (but not NMI context).
	 */
	guard(irqsave)();

	asm goto("1: vmptrst %0\n\t"
		 _ASM_EXTABLE(1b, %l[error])
		 : "=m" (&vmcs) : "cc" : error);

	ret = seamldr_prerr(fn, args);

	/*
	 * Restore the current VMCS pointer.  VMPTSTR "returns" all ones if the
	 * current VMCS is invalid.
	 */
	if (vmcs != -1ULL) {
		asm goto("1: vmptrld %0\n\t"
			 "jna %l[error]\n\t"
			 _ASM_EXTABLE(1b, %l[error])
			 : : "m" (&vmcs) : "cc" : error);
	}

	return ret;

error:
	WARN_ONCE(1, "Failed to save/restore the current VMCS");
	return -EIO;
}

