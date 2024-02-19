Return-Path: <kvm+bounces-9111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0627785AE78
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 23:34:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B5D41C22A5B
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 22:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C725155E77;
	Mon, 19 Feb 2024 22:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fSWzBEZG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7150754F88
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 22:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708382033; cv=none; b=hA2IUaGS/Nkbvse5Y+QJ0+8wToNu0NyEMuL22JsSEf60AJg0VpzSQTUK8IAwP7+OIdxxpKdT/Fxl5i+kJFrmw8eq2iwMFYBay1WPL01/GYmPdvpzygvOE5xDy7FwqW+9SKaEiTh/LJDklW9kPKSjjUD1v5rsjgyr49X4KMgYwy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708382033; c=relaxed/simple;
	bh=cB2Qe3sL4F5K56WhslZkEo6DrttREefN+0eSWkobVVw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a6J8KacvtTGS6JWUt4k4LLguTs+IFTIt/OOdXZ1AtClFPnHuPisGXVkUYgXS5//dBOmxXf6XE+ydxcdnF/5FZJXjTg5A4jCIsKJfS6DQ933OS5TgoI3jW+aFrJLJ4omarl9TF9u16YUsSL/C6Chv0zN4O8LG/9EsYQNRId1IoJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fSWzBEZG; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6047fed0132so72569597b3.1
        for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 14:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708382030; x=1708986830; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L2F2d370iBT4NDo692GMhX9HUMYxc26yEy5510rVGDs=;
        b=fSWzBEZGOfzNUt3XfCfob2ue7dYG3o4eyz005gCo3AXMO3p53jFRsWpK2Kud+520RF
         aTj0hLrYJCktHtDxCB/71KqgkPS5mIP0VLxlLNQt5ZcHI4l1ASxPpzObQWCIRsK5CaVZ
         MfGtGIrMkmdnVI1zb4Yp5tZ1gPUd8dVN4uTCUQhMmrgQcFaw7WwGo1NFgYu+EBfh4W3g
         6+qmByU+H+8voYIe+aQubTzSmMZjUT1pZiqRgvgUqsfBblLFENLL7vZ2FbIJXPak2tqT
         pz9h9jvAydMnN35QtgLvwMRNAD/N1T9MtBZUXGLfjunL8S43rejlBLDUswoebLQB1dNt
         mKpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708382030; x=1708986830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L2F2d370iBT4NDo692GMhX9HUMYxc26yEy5510rVGDs=;
        b=iEuF3GPzevIVdm8aSSPAFDz2cAfSkMeqF7qPKXt9hiG7zuAB7ZpyDmFnZcb5saHS/l
         FHXgct8M7mZ8lg9GVI+qICVynduFTJXDEC1KuueSdrHCALxYxMM6d4uqVFX11TgOzS39
         o3L2oCu61geVfl2J5VAObC7ew6CiJRJONYY+Jao8/INY+GLHgDI5Ml3aa/0VqCxwiM3V
         89zYlXe63SOgRkjruhCylRvHO9EkprHym7uE6AFEZHQHUKFC39DQ6QNncAP+rdXqnElq
         rK01NvSNfkHkKo9rZF+mqWO/7Pcwhh4K8qsJ1AluzJqoXTq7kR8QVeVtYyOXnihkdYZ+
         UnIw==
X-Gm-Message-State: AOJu0YxrvSoZ5iaCvew2Kr6/64EhpM2IRNXfGpYbbsnqVs3nRcVqgG+9
	pQTfUaObDxFi4wk/UmYlTFLLIPQdk/dKRU4apt0y7ih06FXt3b3bvO5VCCl6KgnGCOPL6wXAXUj
	MLg==
X-Google-Smtp-Source: AGHT+IFgBn1pwmA80Xr6878qTRqEsY9mDc5ekWPCTg7S48ErOOV5LQyFL19mN0vMOiwUx0LfthTm8jOltuw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:7949:0:b0:608:5535:9bff with SMTP id
 u70-20020a817949000000b0060855359bffmr297616ywc.7.1708382030474; Mon, 19 Feb
 2024 14:33:50 -0800 (PST)
Date: Mon, 19 Feb 2024 14:33:49 -0800
In-Reply-To: <20240217014513.7853-4-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240217014513.7853-1-dongli.zhang@oracle.com> <20240217014513.7853-4-dongli.zhang@oracle.com>
Message-ID: <ZdPXTfHj4uxfe0Ay@google.com>
Subject: Re: [PATCH 3/3] KVM: VMX: simplify MSR interception enable/disable
From: Sean Christopherson <seanjc@google.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 16, 2024, Dongli Zhang wrote:
> ---
>  arch/x86/kvm/vmx/vmx.c | 55 +++++++++++++++++++++---------------------
>  1 file changed, 28 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5a866d3c2bc8..76dff0e7d8bd 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -669,14 +669,18 @@ static int possible_passthrough_msr_slot(u32 msr)
>  	return -ENOENT;
>  }
>  
> -static bool is_valid_passthrough_msr(u32 msr)
> +#define VMX_POSSIBLE_PASSTHROUGH	1
> +#define VMX_OTHER_PASSTHROUGH		2
> +/*
> + * Vefify if the msr is the passthrough MSRs.
> + * Return the index in *possible_idx if it is a possible passthrough MSR.
> + */
> +static int validate_passthrough_msr(u32 msr, int *possible_idx)

There's no need for a custom tri-state return value or an out-param, just return
the slot/-ENOENT.  Not fully tested yet, but this should do the trick.

From: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 Feb 2024 07:58:10 -0800
Subject: [PATCH] KVM: VMX: Combine "check" and "get" APIs for passthrough MSR
 lookups

Combine possible_passthrough_msr_slot() and is_valid_passthrough_msr()
into a single function, vmx_get_passthrough_msr_slot(), and have the
combined helper return the slot on success, using a negative value to
indiciate "failure".

Combining the operations avoids iterating over the array of passthrough
MSRs twice for relevant MSRs.

Suggested-by: Dongli Zhang <dongli.zhang@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 63 +++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 014cf47dc66b..969fd3aa0da3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -658,25 +658,14 @@ static inline bool cpu_need_virtualize_apic_accesses(struct kvm_vcpu *vcpu)
 	return flexpriority_enabled && lapic_in_kernel(vcpu);
 }
 
-static int possible_passthrough_msr_slot(u32 msr)
+static int vmx_get_passthrough_msr_slot(u32 msr)
 {
-	u32 i;
-
-	for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++)
-		if (vmx_possible_passthrough_msrs[i] == msr)
-			return i;
-
-	return -ENOENT;
-}
-
-static bool is_valid_passthrough_msr(u32 msr)
-{
-	bool r;
+	int i;
 
 	switch (msr) {
 	case 0x800 ... 0x8ff:
 		/* x2APIC MSRs. These are handled in vmx_update_msr_bitmap_x2apic() */
-		return true;
+		return -ENOENT;
 	case MSR_IA32_RTIT_STATUS:
 	case MSR_IA32_RTIT_OUTPUT_BASE:
 	case MSR_IA32_RTIT_OUTPUT_MASK:
@@ -691,14 +680,16 @@ static bool is_valid_passthrough_msr(u32 msr)
 	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
 	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
 		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
-		return true;
+		return -ENOENT;
 	}
 
-	r = possible_passthrough_msr_slot(msr) != -ENOENT;
-
-	WARN(!r, "Invalid MSR %x, please adapt vmx_possible_passthrough_msrs[]", msr);
+	for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++) {
+		if (vmx_possible_passthrough_msrs[i] == msr)
+			return i;
+	}
 
-	return r;
+	WARN(1, "Invalid MSR %x, please adapt vmx_possible_passthrough_msrs[]", msr);
+	return -ENOENT;
 }
 
 struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
@@ -3954,6 +3945,7 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
+	int idx;
 
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
@@ -3963,16 +3955,13 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	/*
 	 * Mark the desired intercept state in shadow bitmap, this is needed
 	 * for resync when the MSR filters change.
-	*/
-	if (is_valid_passthrough_msr(msr)) {
-		int idx = possible_passthrough_msr_slot(msr);
-
-		if (idx != -ENOENT) {
-			if (type & MSR_TYPE_R)
-				clear_bit(idx, vmx->shadow_msr_intercept.read);
-			if (type & MSR_TYPE_W)
-				clear_bit(idx, vmx->shadow_msr_intercept.write);
-		}
+	 */
+	idx = vmx_get_passthrough_msr_slot(msr);
+	if (idx >= 0) {
+		if (type & MSR_TYPE_R)
+			clear_bit(idx, vmx->shadow_msr_intercept.read);
+		if (type & MSR_TYPE_W)
+			clear_bit(idx, vmx->shadow_msr_intercept.write);
 	}
 
 	if ((type & MSR_TYPE_R) &&
@@ -3998,6 +3987,7 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
+	int idx;
 
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
@@ -4008,15 +3998,12 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	 * Mark the desired intercept state in shadow bitmap, this is needed
 	 * for resync when the MSR filter changes.
 	*/
-	if (is_valid_passthrough_msr(msr)) {
-		int idx = possible_passthrough_msr_slot(msr);
-
-		if (idx != -ENOENT) {
-			if (type & MSR_TYPE_R)
-				set_bit(idx, vmx->shadow_msr_intercept.read);
-			if (type & MSR_TYPE_W)
-				set_bit(idx, vmx->shadow_msr_intercept.write);
-		}
+	idx = vmx_get_passthrough_msr_slot(msr);
+	if (idx >= 0) {
+		if (type & MSR_TYPE_R)
+			set_bit(idx, vmx->shadow_msr_intercept.read);
+		if (type & MSR_TYPE_W)
+			set_bit(idx, vmx->shadow_msr_intercept.write);
 	}
 
 	if (type & MSR_TYPE_R)

base-commit: 342c6dfc2a0ae893394a6f894acd1d1728c009f2
-- 

