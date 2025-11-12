Return-Path: <kvm+bounces-62890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 77948C52E57
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 16:09:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 004D8502BD6
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 14:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEC90347FD3;
	Wed, 12 Nov 2025 14:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3YuHf5SR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799C9335544
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 14:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762958878; cv=none; b=DJiScCDl5n5P9gCwPHGIFJWqUjnlwNbOHC8cNYBSjNuLA/20U6K1ukMR2nFCxbnSnNDS6bf/kg6RPcRC+S7l5fb8cGEQgG2wItO2Hq4ukQBU4zpOinc4CFjrrpudyOXuh/Zacpf0o3FBsOk3Dp1z6hhSI6IIG0nUvudPsnJqVjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762958878; c=relaxed/simple;
	bh=YDzjPhwh/YmcA6SqNpLTKOVVeIo20EydY7pnz2FTKKA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=umNKayd6pxF9CKEC2+9N9ghxF7iJ2IGuBmDLWEe74JHBwrGXSRnbCdGjhSEPvvu0suedfzE2xOxRQllp5om94rbXT6TBxQaL3kyg8fTExBhO6MKVuLKPDISMyfY9D2R7Eev3ZCGFTpoqWsCRRz8udBbwwWMGiYFD7YaizbDwPAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3YuHf5SR; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b99f6516262so2372146a12.3
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 06:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762958876; x=1763563676; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mZN98J6jRf1XQ1vL4VVbjTVCscmeEznPH5HyoPAKAoA=;
        b=3YuHf5SR6raGLIp6G9cNF1ftMAWS3uUyODQP7QkY1TzWuNO2j1WCtjJ3fTp9Tbe+hy
         Bxqr1daq2HimDlJty5FZxN3m5uC3ocqfuEzbrvTFm6aF5Tci+cYHKTPO2/XUJ7cK4fyR
         8HLazX5U4DUogXVhtAaZ5MRtQXij0z+tct8SbVA4hA57YnMiIBK75cv8rKiOQGLNBbEg
         5BUqPHmCXJUUhJQZqYE2yOne+syJkkNj/JlXk4FXOO1EA0GLVnfR5qziZxUeksgUKrJI
         KwdVQ35aRWXIRnwpPyF56hS/cI2WkgphGZc3tBZZ/nyqM7X6hlBE20RqBUa1e95a43Ee
         31kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762958876; x=1763563676;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mZN98J6jRf1XQ1vL4VVbjTVCscmeEznPH5HyoPAKAoA=;
        b=fa6xD8+JI1ly2N+kyjIlE91I7FiHBKbdfy8UvcHuOF2jAvnN+Z72ygE5qU2S3b7T6v
         wD72u+y7fcXXGAe7LAjHTxzonQXFY20gbrT1/Uow/1LTYvoL1ccu6n9LPWkG/vvV0IyF
         KxkwfspEf4KTgmADkCn3UaeN8jNaVUR9d86T2Lfw96zoR7ctwlAKvp0QeOlq8hmcl1nv
         WGLk0S4pC0whL9n5H1wiYpu+HlzpFoj4RcWsqXKQv0MlQeK5gzc64RIiXTUJiITlntQ5
         jTWFNkiGThiqj2XBj+nz4HpiFMigzSa4VtYiws/t8RbFtPpu8qj8vbIpMLgCNmQHuxlF
         gwyw==
X-Gm-Message-State: AOJu0Yx8PohFNSpJ9FJu3d19iKii31aSUQiupxvME7V6Z9ezDayZhId9
	FQp+bNIvPGeFWFZ6crv0CbFFBYSXUzFSNg+WZk/9paoPatsa3pCSWqsOKUVdYSDcOkS19IHI9ai
	qkmrK/w==
X-Google-Smtp-Source: AGHT+IEJQY+2nepVgKrdsQRjbtkTvRt1EmAqv3YmsLcQnJsTwrWBXxD/UMCNxR4bYISKXGGAoW4cTuYzLhg=
X-Received: from pgve25.prod.google.com ([2002:a65:6499:0:b0:b55:6eb3:fd4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:99a0:b0:359:c3:c2ec
 with SMTP id adf61e73a8af0-3590ae34159mr4418503637.35.1762958875737; Wed, 12
 Nov 2025 06:47:55 -0800 (PST)
Date: Wed, 12 Nov 2025 06:47:54 -0800
In-Reply-To: <20251110063212.34902-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110063212.34902-1-dongli.zhang@oracle.com>
Message-ID: <aRScMffMkpsdi5vs@google.com>
Subject: Re: [PATCH v2 1/1] KVM: VMX: configure SVI during runtime APICv activation
From: Sean Christopherson <seanjc@google.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	chao.gao@intel.com, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, joe.jin@oracle.com, 
	alejandro.j.jimenez@oracle.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Nov 09, 2025, Dongli Zhang wrote:
> ---
> Changed since v2:
>   - Add support for guest mode (suggested by Chao Gao).
>   - Add comments in the code (suggested by Chao Gao).
>   - Remove WARN_ON_ONCE from vmx_hwapic_isr_update().
>   - Edit commit message "AMD SVM APICv" to "AMD SVM AVIC"
>     (suggested by Alejandro Jimenez).
> 
>  arch/x86/kvm/vmx/vmx.c | 9 ---------
>  arch/x86/kvm/x86.c     | 7 +++++++
>  2 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f87c216d976d..d263dbf0b917 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6878,15 +6878,6 @@ void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
>  	 * VM-Exit, otherwise L1 with run with a stale SVI.
>  	 */
>  	if (is_guest_mode(vcpu)) {
> -		/*
> -		 * KVM is supposed to forward intercepted L2 EOIs to L1 if VID
> -		 * is enabled in vmcs12; as above, the EOIs affect L2's vAPIC.
> -		 * Note, userspace can stuff state while L2 is active; assert
> -		 * that VID is disabled if and only if the vCPU is in KVM_RUN
> -		 * to avoid false positives if userspace is setting APIC state.
> -		 */
> -		WARN_ON_ONCE(vcpu->wants_to_run &&
> -			     nested_cpu_has_vid(get_vmcs12(vcpu)));
>  		to_vmx(vcpu)->nested.update_vmcs01_hwapic_isr = true;
>  		return;
>  	}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b4b5d2d09634..08b34431c187 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10878,9 +10878,16 @@ void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>  	 * pending. At the same time, KVM_REQ_EVENT may not be set as APICv was
>  	 * still active when the interrupt got accepted. Make sure
>  	 * kvm_check_and_inject_events() is called to check for that.
> +	 *
> +	 * When APICv gets enabled, updating SVI is necessary; otherwise,
> +	 * SVI won't reflect the highest bit in vISR and the next EOI from
> +	 * the guest won't be virtualized correctly, as the CPU will clear
> +	 * the SVI bit from vISR.
>  	 */
>  	if (!apic->apicv_active)
>  		kvm_make_request(KVM_REQ_EVENT, vcpu);
> +	else
> +		kvm_apic_update_hwapic_isr(vcpu);

Rather than trigger the update from x86.c, what if we let VMX make the call?
Then we don't need to drop the WARN, and in the unlikely scenario L2 is active,
we'll save a pointless scan of the vISR (VMX will defer the update until L1 is
active).

We could even have kvm_apic_update_hwapic_isr() WARN if L2 is active.  E.g. with
an opportunistic typo fix in vmx_hwapic_isr_update()'s comment (completely untested):

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0ae7f913d782..786ccfc24252 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -774,7 +774,8 @@ void kvm_apic_update_hwapic_isr(struct kvm_vcpu *vcpu)
 {
        struct kvm_lapic *apic = vcpu->arch.apic;
 
-       if (WARN_ON_ONCE(!lapic_in_kernel(vcpu)) || !apic->apicv_active)
+       if (WARN_ON_ONCE(!lapic_in_kernel(vcpu)) || !apic->apicv_active ||
+                        is_guest_mode(vcpu))
                return;
 
        kvm_x86_call(hwapic_isr_update)(vcpu, apic_find_highest_isr(apic));
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 91b6f2f3edc2..653b8b713547 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4430,6 +4430,14 @@ void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
                                                 kvm_vcpu_apicv_active(vcpu));
 
        vmx_update_msr_bitmap_x2apic(vcpu);
+
+       /*
+        * Refresh SVI if APICv is enabled, as any changes KVM made to vISR
+        * while APICv was disabled need to be reflected in SVI, e.g. so that
+        * the next accelerated EOI will clear the correct vector in vISR.
+        */
+       if (kvm_vcpu_apicv_active(vcpu))
+               kvm_apic_update_hwapic_isr(vcpu);
 }
 
 static u32 vmx_exec_control(struct vcpu_vmx *vmx)
@@ -6880,7 +6888,7 @@ void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
 
        /*
         * If L2 is active, defer the SVI update until vmcs01 is loaded, as SVI
-        * is only relevant for if and only if Virtual Interrupt Delivery is
+        * is only relevant for L2 if and only if Virtual Interrupt Delivery is
         * enabled in vmcs12, and if VID is enabled then L2 EOIs affect L2's
         * vAPIC, not L1's vAPIC.  KVM must update vmcs01 on the next nested
         * VM-Exit, otherwise L1 with run with a stale SVI.

