Return-Path: <kvm+bounces-27922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66E5599060A
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 16:28:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93FA71C2155C
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 14:28:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 030FB21733A;
	Fri,  4 Oct 2024 14:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SIJRMp6i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC12969D2B
	for <kvm@vger.kernel.org>; Fri,  4 Oct 2024 14:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728052073; cv=none; b=MH4UMpIyzhJh9VG42IDGLCJbd85KFXN4ywhomOveGcMF6LBeF10+dI/bS7R+nIlUCRM9BJ83imfxDq3D1NbVqfxnnnB88ydnHeiAkfrv3tmzP9Uipd8CoNjg+bqWRlB+vo3fjehx35dUzMT+G7lG9rlm8TbdfUOtaY2DXM1r2gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728052073; c=relaxed/simple;
	bh=jNaRSN4lfwD9Y7dsEmPIHxFmOPd1ozcTRFWPbbj42Fw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uvarhQZt+fETD1D89LPd+FHDT/OOl/6gt5gDYC0uHMotbSzTbjbHaDQoEWd7RqtQlMZdnFC/QvYUjm9JNYOuDmDK/myDfQNtNU7BPOWQ8JTdo4WYYW3YSJHQRBN3ZU9FA/BFU3GX4LMGQFvZYKbW1ns8O6vxnH1ZnpQuI90kTgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SIJRMp6i; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e25cef43f5aso2578371276.3
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2024 07:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728052071; x=1728656871; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fs/WqP0RMB3E5hV2bwyTtiNtyEoT7gsNPUDlAFSWfQs=;
        b=SIJRMp6iZ4vS1ezpaVTF15WSIi6Bg7Cc3ajIhGYoDjwKtWwdf9l+4nj478G5/w6AL8
         o0vUNcNjf/kWTxqzpE+kRz3x3ukWLQxXRhbpbhtIINTkQzMdD6pe1Dc6pS6ViyJv7dUW
         9Mxxm0GpFtHnKKhtUmYmWxc+zKcuKo5XOpCHxogtNEkrmCzbBbjZS9a9s25fx0nmy5oo
         zRTSLUpNnJAi9PnHSEJU3X0lksctSfmFEmHEDYRx6xdw2ryh63+8jXsZ7fb0jdH3XGF3
         hNGN6ZHtK53EgC9YL4oeFBLgKYcVaQ1K9NJPSGnkeRPIo2DG9nuZCs12zzW0hnmHZHkR
         9vew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728052071; x=1728656871;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fs/WqP0RMB3E5hV2bwyTtiNtyEoT7gsNPUDlAFSWfQs=;
        b=tDaXgsKYp8ugtrWOOnKI8Cz5IKai82tFWSBXfnh3BlmRrOfoYvjR9SGLTGgPDI2pOs
         23+uyBDvw8e+OtNqFhLgekwAMW2nZWPwkY6Zgn4j2K8ALyjLxGSNHi9lArhdphOYt8O9
         X/ZvtV5VA5179a7c+mKBJRErMjzqcprnADZim5SYoVefBueoM6w0sAeck6YVQK9ifj+i
         kuHmA+FeOuZ5iAbwPwRuK2yUwUkVHmZI7ZuDwdySzUDJXYMlFde/7GwYnOe9/wwRf+Ux
         ajOD9oRtXAvIiNdKBmHPWaWBWAtrDs+eTwNYn+0U1pvVsq2aIahNEJgwoBQpe0910wZl
         wpNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsr7yeaF+YkIO9aCxnxg3ceLRaNTylG98A5MtL2O6Zwrdg8CLdYd0b0t6f5stfkIEnsLI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRjeiO2Fo2SH3Hutx/OmuUMDqJkKiOxjBux/iwY6cb5RTHQaaH
	Nv7cplGG0hQsO2Q+AhBkknSMsycnkVy/U6xF1d5rznVGte6zztYKNjQj3AmxX7NdDH+Xr/Tt6Qu
	Uww==
X-Google-Smtp-Source: AGHT+IF/3JwwL+JA6ZaGXNANpUIsMpJrYFnMBSFbgNBEKo6bK1QMK0DNXl9g4EtHgHDg397Ca4b+MIr/cEU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a5b:6c6:0:b0:e22:5f73:1701 with SMTP id
 3f1490d57ef6-e28934fdfc5mr5059276.0.1728052070882; Fri, 04 Oct 2024 07:27:50
 -0700 (PDT)
Date: Fri, 4 Oct 2024 07:27:49 -0700
In-Reply-To: <20241003230806.229001-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241003230806.229001-1-pbonzini@redhat.com> <20241003230806.229001-2-pbonzini@redhat.com>
Message-ID: <Zv_0GzOkrPVCRfP1@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: leave kvm.ko out of the build if no vendor
 module is requested
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	torvalds@linux-foundation.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 03, 2024, Paolo Bonzini wrote:
> kvm.ko is nothing but library code shared by kvm-intel.ko and kvm-amd.ko.
> It provides no functionality on its own and it is unnecessary unless one
> of the vendor-specific module is compiled.  In particular, /dev/kvm is
> not created until one of kvm-intel.ko or kvm-amd.ko is loaded.
> 
> Use CONFIG_KVM to decide if it is built-in or a module, but use the
> vendor-specific modules for the actual decision on whether to build it.
> 
> This also fixes a build failure when CONFIG_KVM_INTEL and CONFIG_KVM_AMD
> are both disabled.  The cpu_emergency_register_virt_callback() function
> is called from kvm.ko, but it is only defined if at least one of
> CONFIG_KVM_INTEL and CONFIG_KVM_AMD is provided.
> 
> Fixes: 590b09b1d88e ("KVM: x86: Register "emergency disable" callbacks when virt is enabled")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/Kconfig  | 7 +++++--
>  arch/x86/kvm/Makefile | 2 +-
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 730c2f34d347..81bce9dd9331 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -17,8 +17,8 @@ menuconfig VIRTUALIZATION
>  
>  if VIRTUALIZATION
>  
> -config KVM
> -	tristate "Kernel-based Virtual Machine (KVM) support"
> +config KVM_X86_COMMON

Maybe just KVM_X86?  I doubt anyone in KVM will care too much, and for the rest
of the kernel, CONFIG_KVM_X86 is likely more intuitive than CONFIG_KVM_X86_COMMON.

