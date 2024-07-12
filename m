Return-Path: <kvm+bounces-21514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C27B492FCEB
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 16:52:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AEAC284556
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 14:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 513DE1741F4;
	Fri, 12 Jul 2024 14:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="17cE/U8l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1956B172BC9
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 14:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720795897; cv=none; b=dwxHRO+9RlhFONDVcCDix6xe248ptUvNLSkiimADYH0msjaOeMZ9l7KJ9qSV6/jA8OjLqMsvgC6G1BtMkQW5pTlruKgt5g1CZGKO7enoCOqqntkHI2hLJAEX8428ObBtXnAPttM91M/V1gMIarZXOu2jreYhy7EbEkI6UvNb6dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720795897; c=relaxed/simple;
	bh=JKBHNcGmp0QwZ0rhgoF+eHPuXWJI/+gx9RGechJ17gc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C4rLZXJDTDy146wzelP0uyuOnCFbaGdZ/msNIGmUTieCWU55Q+qP1nVNUdrpbm0vIIZM2wCwqD3uP59Vnq08YwG1HHrvqmgMXT+IQV2ibkBIcpgss4yVdp84lasL6ehxObsv+qSGpgBYE/rw2FD5i5+ZVjD0SR0xNea4PiqyCqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=17cE/U8l; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e036440617fso3938403276.1
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 07:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720795895; x=1721400695; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u0HrA2oBJYdeTPlzzSEveTT2iaGeIebcrdS2ZlqIhh0=;
        b=17cE/U8lXt7lmUD1+JcJvSyYyqoVg7bTxQlcBmd9C2FezQW35oCGbynofueuefZWgy
         O2pSDrcn0nJKy4m0qtjZVpwRnvNZQKkiwA+zKcDrpgJwPobKhGSsSMJQZiFL95WCq1d0
         b2hxXvmecBS1oqeOEGiFIEUEXd8GjJXDycVhoSFZ7R2pK9gelNEdj1N5U+KgnbncbukG
         nf4MP51B+Xqdh49ysynQ1X4Evbv4moArgcMFmW5ZpQT7Q2FF/R97Mo1PkgahtiKqX8qC
         Wzc7PR9nPP4vMjCxFT7m6+PshOk8Hv5LdjipbWAJATfKvHp6eMx0Ty0dxGDRuzl4NENw
         ikVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720795895; x=1721400695;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u0HrA2oBJYdeTPlzzSEveTT2iaGeIebcrdS2ZlqIhh0=;
        b=tn/+8e4x5Sr+rbCm56Gc7qc8RNyopupU0RASZRC/d2xsoEPgN+8GQmuaHBJ3WVfB0t
         8Pk+ivAMwXCLFQdQvTA9BZbrIePGPWv3FH7+ZNaxSr1PPDYCAnlL4VpT74nE2uLstpWS
         lbbBnzOdFbTtDlDBCEysyrLLg3Sagct5Nb2wVDEj+dE1rPCBKDfDnRLPm6EasDs3TO7+
         iqWbQERvnG3FiBE69PWNFIHbxZ1m0Lri8w7WVIlTGdYtriuIDjeqM34ttgPDih2TdS0X
         CjaRihrLwaN4GMOup/JTKXqhNbLlziQbONRBp54JA4bT3ZIDhWCskEqKuTM6nSpWKvfV
         568Q==
X-Forwarded-Encrypted: i=1; AJvYcCXFLCANUVMuJ96145BPOW6jkMDGAWXV6Ok49UjhTksS6g5iktfBDY7hdzLwJCIg4DYtYrlWg0I7Q1AczDOsBgddFnXc
X-Gm-Message-State: AOJu0Yyhr301qVfM/QM2FcXLdFZPsxWUmnzDdpo3Il3BaduZwDDOZReg
	BpBOU2VLpGrZvYg+zysMkc8m4aNaT2PH/NHezEgit81NSk8LuO4zEMY33hmqYthUH18DJT6baPz
	iCw==
X-Google-Smtp-Source: AGHT+IHs3WxROK8B3MEoajMFN2LkNLJRwhW9tOF7pTAf7Ssn5e1+uILjWrs/+upZBAn3zXJ5dKbg12DuyII=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2586:b0:e02:c619:73d with SMTP id
 3f1490d57ef6-e041b070201mr523017276.5.1720795895128; Fri, 12 Jul 2024
 07:51:35 -0700 (PDT)
Date: Fri, 12 Jul 2024 07:51:33 -0700
In-Reply-To: <20240712075022.48276-1-flyingpeng@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712075022.48276-1-flyingpeng@tencent.com>
Message-ID: <ZpFC9Q6Sccy6mjRN@google.com>
Subject: Re: [PATCH v2]   KVM/x86: make function emulator_do_task_switch as noinline_for_stack
From: Sean Christopherson <seanjc@google.com>
To: flyingpenghao@gmail.com
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, 
	Peng Hao <flyingpeng@tencent.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 12, 2024, flyingpenghao@gmail.com wrote:
> From: Peng Hao <flyingpeng@tencent.com>
> 
> When KASAN is enabled and built with clang:
> clang report
> arch/x86/kvm/emulate.c:3022:5: error: stack frame size (2488) exceeds limit (2048) in 'emulator_task_switch' [-Werror,-Wframe-larger-than]
> int emulator_task_switch(struct x86_emulate_ctxt *ctxt,
>     ^
> 
> since emulator_do_task_switch() consumes a lot of stack space, mark it as
> noinline_for_stack to prevent it from blowing up emulator_task_switch()'s
> stack size.

No, sprinkling noinline to combat KASAN stack frame sizes is not a maintainable
approach.  Practically speaking, KASAN + -Werror + FRAME_WARN=2048 is not a sane
config.

> Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> ---
>  arch/x86/kvm/emulate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 5d4c86133453..bbc185b9725d 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -2918,7 +2918,7 @@ static int task_switch_32(struct x86_emulate_ctxt *ctxt, u16 old_tss_sel,
>  	return load_state_from_tss32(ctxt, &tss_seg);
>  }
>  
> -static int emulator_do_task_switch(struct x86_emulate_ctxt *ctxt,
> +static noinline_for_stack int emulator_do_task_switch(struct x86_emulate_ctxt *ctxt,
>  				   u16 tss_selector, int idt_index, int reason,
>  				   bool has_error_code, u32 error_code)
>  {
> -- 
> 2.27.0
> 

