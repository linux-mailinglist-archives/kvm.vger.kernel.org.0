Return-Path: <kvm+bounces-19702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B527890907C
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 18:37:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E481283CED
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 16:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D928119CD17;
	Fri, 14 Jun 2024 16:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B2RNc26j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA3719B3D2
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 16:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718382955; cv=none; b=kMikbucug5J34/hzXwTQ0jj3a/hY1t/jMqGSbz6H0Bqmvr9WuBK4yzug3a93exm/JK/d2JD4GW/Z8Vo7BYwTgMpjUGcaa9aagr71lfwGGdgfsZ/g98hZadBNeOA7RfZrkeMP+gB+bxRTRHNWZ+oLuArmCsuC3FOayX2wnOec0MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718382955; c=relaxed/simple;
	bh=zC1pfIw4KUdtsnICL7y+mNlHTg2ZeEtAhtxk+tqxLbU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NRuTlC1Cd3fI+rXYlSekBhNcOyPzUU5KL73YW6NdPN1mjqkfkTuyV25i9uxvWoKnF8APsl/aFfoXYd2NWTe3kA3ntmHt1hdmzIbUcKGeAUq02qTph5ZvxfQgOdivjuGHIWiHQ/JeFJu0ruKiQ+s3iJ6sgdkUtxWNGxXJN9nwsaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B2RNc26j; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7059fdcf005so1843218b3a.1
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 09:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718382953; x=1718987753; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=63hQ6wwNa5aRz/J6WyiOlJHFI9RSzwFYSiksAovgJwg=;
        b=B2RNc26j435jTyZJ5JrksZSX+oSTArK0BGISNqWJcyaL2tziWNJASdu8M2GXrh1vcv
         q8bqF7T2s1YP9rShd2maz77zFKX0jzm+100edWbX8Mw+RVHBFQZFZLk/orVaCIMYUMMa
         nNol5QzrYBEsXrCW0gz08R5oIu0R0q/Ntc/zen25ywJGgUkfrpLa+2Knj+Daaavu/MuL
         oZzgnsyyg2U0nb38n7q77PK4iDrD8H5nQrUYGFWCKH2ptPUFkaIyVmoxGX5eTq8UTdcH
         tlie8+XO3/p8aQIZBs95nBragpBrC1dnXTKkZhIE6hPvZd/rEh1lwimmLDK/6y9sBGc/
         Wlyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718382953; x=1718987753;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=63hQ6wwNa5aRz/J6WyiOlJHFI9RSzwFYSiksAovgJwg=;
        b=LtTodXaAoc2IVI2RIY6qfEv8icvkWyMc/f7AXWhZZJGvQB4cBHEBl0LVXIZ5cCNzrG
         ekAM90t5afZz30k5JpAD7aK8LWL/usnEekOofOClgnX4Ynrj8GrHat5u1V0sNbhNtj6I
         MzGWRBIavZRZwpulK7x7GMB93S1XCXkfwf/RJqyK4XIVCGfnz354QUgQO58KU7OA5DYg
         I1ABUJ/77UWx3LEWtom+P5sVoo6eCMtDgivsoz1ebf6lGShIC3HQfIERxpuvDJBjD3FB
         sCX+Olqt+OwhvqyO98F/C5pLgpfBZEfdiXTpbEn9MsCMZW07QK/2VrJc7X6iV++aOSTw
         nQWg==
X-Forwarded-Encrypted: i=1; AJvYcCV1XQlaK+YLa7AS9uMGLO3i3i2q0HOHNlMkqlIgceW1dqOQPyFJjwG4mdsbzvpUnbf35yHNp248GQ00Agk38A7E/7ZJ
X-Gm-Message-State: AOJu0Ywl4mFBVUfCLzjopQpXNAYKITiFjzVE8pRFPEzcFVNafnM4PxfF
	WwN9xUGdbKVRBgWchrvE/6Y8P/Qb+1oGqA439/8+s1cBXCgJjIcAg9nbXH1ONHdKfuWSjgBq3oD
	VJg==
X-Google-Smtp-Source: AGHT+IGKQhQOcPc8JE0i3Tinaszg/3v++YeEmzZeRI0lS0leOgR6Mq+qaW+78fLP3cywWYVw7doowMod9xU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:418b:b0:705:bd9d:a7c2 with SMTP id
 d2e1a72fcca58-705d7221599mr29020b3a.5.1718382951676; Fri, 14 Jun 2024
 09:35:51 -0700 (PDT)
Date: Fri, 14 Jun 2024 09:35:50 -0700
In-Reply-To: <20240612215415.3450952-4-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240612215415.3450952-1-minipli@grsecurity.net> <20240612215415.3450952-4-minipli@grsecurity.net>
Message-ID: <ZmxxZo0Y-UBb9Ztq@google.com>
Subject: Re: [PATCH v2 3/4] KVM: Limit check IDs for KVM_SET_BOOT_CPU_ID
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 12, 2024, Mathias Krause wrote:
> Do not accept IDs which are definitely invalid by limit checking the
> passed value against KVM_MAX_VCPU_IDS.
> 
> This ensures invalid values, especially on 64-bit systems, don't go
> unnoticed and lead to a valid id by chance when truncated by the final
> assignment.
> 
> Fixes: 73880c80aa9c ("KVM: Break dependency between vcpu index in vcpus array and vcpu_id.")
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
>  arch/x86/kvm/x86.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 082ac6d95a3a..8bc7b8b2dfc5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7220,10 +7220,16 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  	case KVM_SET_BOOT_CPU_ID:
>  		r = 0;
>  		mutex_lock(&kvm->lock);
> -		if (kvm->created_vcpus)
> +		if (kvm->created_vcpus) {
>  			r = -EBUSY;
> -		else
> -			kvm->arch.bsp_vcpu_id = arg;
> +			goto set_boot_cpu_id_out;
> +		}
> +		if (arg > KVM_MAX_VCPU_IDS) {
> +			r = -EINVAL;
> +			goto set_boot_cpu_id_out;
> +		}
> +		kvm->arch.bsp_vcpu_id = arg;
> +set_boot_cpu_id_out:

Any reason not to check kvm->arch.max_vcpu_ids?  It's not super pretty, but it's
also not super hard.

And rather than use gotos, this can be done with if-elif-else, e.g. with the
below delta get to:

		r = 0;
		mutex_lock(&kvm->lock);
		if (kvm->created_vcpus)
			r = -EBUSY;
		else if (arg > KVM_MAX_VCPU_IDS ||
			 (kvm->arch.max_vcpu_ids && arg > kvm->arch.max_vcpu_ids))
			r = -EINVAL;
		else
			kvm->arch.bsp_vcpu_id = arg;
		mutex_unlock(&kvm->lock);
		break;


diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6e6f3d31cff0..994aa281b07d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6707,7 +6707,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
                        break;
 
                mutex_lock(&kvm->lock);
-               if (kvm->arch.max_vcpu_ids == cap->args[0]) {
+               if (kvm->arch.bsp_vcpu_id > cap->args[0]) {
+                       ;
+               } else if (kvm->arch.max_vcpu_ids == cap->args[0]) {
                        r = 0;
                } else if (!kvm->arch.max_vcpu_ids) {
                        kvm->arch.max_vcpu_ids = cap->args[0];
@@ -7226,16 +7228,13 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
        case KVM_SET_BOOT_CPU_ID:
                r = 0;
                mutex_lock(&kvm->lock);
-               if (kvm->created_vcpus) {
+               if (kvm->created_vcpus)
                        r = -EBUSY;
-                       goto set_boot_cpu_id_out;
-               }
-               if (arg > KVM_MAX_VCPU_IDS) {
+               else if (arg > KVM_MAX_VCPU_IDS ||
+                        (kvm->arch.max_vcpu_ids && arg > kvm->arch.max_vcpu_ids))
                        r = -EINVAL;
-                       goto set_boot_cpu_id_out;
-               }
-               kvm->arch.bsp_vcpu_id = arg;
-set_boot_cpu_id_out:
+               else
+                       kvm->arch.bsp_vcpu_id = arg;
                mutex_unlock(&kvm->lock);
                break;
 #ifdef CONFIG_KVM_XEN

