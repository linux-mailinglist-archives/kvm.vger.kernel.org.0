Return-Path: <kvm+bounces-67955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E698D1A2AA
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 17:19:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8D5B7306347D
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 16:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E4D729B22F;
	Tue, 13 Jan 2026 16:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SIb24Ph5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC322609E3
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 16:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768321047; cv=none; b=SiG3wEfdh73CzvrOhrfPCGteGMbYSK9WUrfyh31/5slcmb27wpSbLElI7s0yfDEbtPOCmF6VEU66R+/8LkTYmULJ4Zhm1dXlBLQQUtmOsa+PClo2TuFQDsjJMbK9j6N4N6VEcZX8Pn3k0Gm6OLdrOcwr6hRE87Gd0Bq66616Qtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768321047; c=relaxed/simple;
	bh=WqJx9aUJA973Qr0mYXLofGYRCx1soCizR0tr6w6S8ss=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mte4YMRdyY1cP4CPILQJaRcyoxQLqdMaEzFHUCr+29PmQAXM0CrSFL/FsSEdDlK2VxPBmIfp9XVsn+nhmSVgaUATJ9nEBeT6qxWlDbG5FVQcQFaHn7aJy9/u6tQWAFYvrXB6csBC02H1g+fT9hn93VL3KjHeAqFC+ibN6+CprWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SIb24Ph5; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c52d37d346dso2927708a12.3
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 08:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768321045; x=1768925845; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hwcp4SES0NRzlCGplTTYOSpklg10HHGrYKPdipMVc2I=;
        b=SIb24Ph5ijYZXveVKjpSOI6yNiV1UwACqGOZfZGnCGTGrr1JsRXHMpeAQYx7u8sYii
         6YhSH/8uW8v2nEfdjzZxSJEyySq09cQ2d9nZbYXW4UX8sJ4yf4kM+lrsLV7MzMDVXDq5
         k3Gnnfp8AHcY7QoCPeuC8FQmimPclphT/QGKuLesfFGMeQltYgDC9BCqat9OLx/50VbZ
         zqV37dMudnO/nqnFWL0CsurY/XPuQeyb0prBfktPN4qAig+KjpEC37TLkW1fyqIa7VKF
         mnHFZlCQQMZ4lXzPmvovfgERccOS19QbuwJ2dJCK+0d4E7uPVsOHd3iCnow/ILIOML4T
         xo4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768321045; x=1768925845;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hwcp4SES0NRzlCGplTTYOSpklg10HHGrYKPdipMVc2I=;
        b=eGUj/wTtSc+MpOrdLu5bDR5vlcOUKHg2nvEzEEdd2Yj8ieYdyo1tApHILHfQNLKfZo
         OAkaDpitgWvd2vDNWB6smwo9ZRatRZDY1RAJBOZBf/pAFv2PVDBhmGJQfNvZABJoX7mz
         gjvsQXlOk1gu1GNlrXaOikFgwnb2WY1CQez0cegX3f1FkWHuI4DUP1imBCUZ/Jh6lW72
         3kFAjonGwBvl8K6XmtC+eAa5kUG/g4pq8YUgQI8hqdryWrPRyVB75cp0uKnSrJWXGWAb
         ivRhmLOa5Zj5kkJwh+1xNen/qcfXYekrqufvuRIpIkZdz9kowkmg3t4vde+qmQI2Nq/u
         PMkw==
X-Gm-Message-State: AOJu0Yx5GymgD4w8OGtjHO8Avg3VPho9f1QujUaN3QKZuniFgJAMktk8
	Ha0QbApEu9T1Wq2yV1kFvW/G2073VRYpiIhe+HaimSfBRzM3OIJgXSKkqmu4hIZxz4DdaacJrc5
	Bvbl6XQ==
X-Google-Smtp-Source: AGHT+IHHuf1dzkNquieV5NtMYk+yqTT4fKxwLlyt3w/6c3AuKQwgEafeAo9wRWbz75FBhqCTPUulPdWJdj8=
X-Received: from pgdk10.prod.google.com ([2002:a05:6a02:546a:b0:c1d:e051:4d17])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3387:b0:35f:5fc4:d886
 with SMTP id adf61e73a8af0-3898f9cf3d7mr20016358637.43.1768321045360; Tue, 13
 Jan 2026 08:17:25 -0800 (PST)
Date: Tue, 13 Jan 2026 08:17:23 -0800
In-Reply-To: <0ac6908b608cf80eab7437004334fedd0f5f5317.1768304590.git.houwenlong.hwl@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <0ac6908b608cf80eab7437004334fedd0f5f5317.1768304590.git.houwenlong.hwl@antgroup.com>
Message-ID: <aWZwE1QukfjYDB_Q@google.com>
Subject: Re: [PATCH] KVM: VMX: Don't register posted interrupt wakeup handler
 if alloc_kvm_area() fails
From: Sean Christopherson <seanjc@google.com>
To: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 13, 2026, Hou Wenlong wrote:
> Unregistering the posted interrupt wakeup handler only happens during
> hardware unsetup. Therefore, if alloc_kvm_area() fails and continue to
> register the posted interrupt wakeup handler, this will leave the global
> posted interrupt wakeup handler pointer in an incorrect state. Although
> it should not be an issue, it's still better to change it.

Ouch, yeah, that's ugly.  It's not entirely benign, as a failed allocation followed
by a spurious notification vector IRQ would trigger UAF.  So it's probably worth
adding:

  Fixes: ec5a4919fa7b ("KVM: VMX: Unregister posted interrupt wakeup handler on hardware unsetup")
  Cc: stable@vger.kernel.org

even though I agree it's extremely unlikely to be an issue in practice.

> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9b92f672ccfe..676f32aa72bb 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8829,8 +8829,11 @@ __init int vmx_hardware_setup(void)
>  	}
>  
>  	r = alloc_kvm_area();
> -	if (r && nested)
> -		nested_vmx_hardware_unsetup();
> +	if (r) {
> +		if (nested)
> +			nested_vmx_hardware_unsetup();
> +		return r;
> +	}

I'm leaning towards using a goto with an explicit "return 0" in the happy case,
to make it less likely that a similar bug is introduced in the future.  Any
preference on your end?

E.g. (untested)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9b92f672ccfe..cecaaeb3f82a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8829,8 +8829,8 @@ __init int vmx_hardware_setup(void)
        }
 
        r = alloc_kvm_area();
-       if (r && nested)
-               nested_vmx_hardware_unsetup();
+       if (r)
+               goto err_kvm_area;
 
        kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
 
@@ -8857,6 +8857,11 @@ __init int vmx_hardware_setup(void)
 
        kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
 
+       return 0;
+
+err_kvm_area:
+       if (nested)
+               nested_vmx_hardware_unsetup();
        return r;
 }

