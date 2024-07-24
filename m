Return-Path: <kvm+bounces-22171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A1B3093B3C2
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 17:34:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D96D28158C
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 15:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 735FE15B14E;
	Wed, 24 Jul 2024 15:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KMkS8yO7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EDC54759
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 15:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721835232; cv=none; b=NuaCxUMFB3lbYtJC/CjOqCutPx6TlunpTypyg1hs6aK+vIOEPwQbRGh33o6Kc6HaUYOVmYPBP9btS5TQRoF6DKaTUq2fwkS+b1bqP9XrZNyYhtue1QDmMyqbELBUVp/Cum8GNtjzwfmfAMyyuLgnh8JiMBGVKj/aOoNdoIlpJSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721835232; c=relaxed/simple;
	bh=xhOdgAqvk5uhhER6kBCJpBnfwQCOjsRK4KYXS9TeMME=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dAfkCcVmUh+/taCSPReVvWgmTQqBP2bBfToJkJiS5ydRQh1BO8fgOz4Wl2c/St5HsrhbBtLdYbHBSJ/x1J14ECnGCak5jTjVGGwfL/x4SK/xwu0b1MNLe3TZiIVkJ6RSj8bYZ0F+JbbtTlm6CFb/xjJTT9l5b0ml53X/wolXHkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KMkS8yO7; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fd8a1a75e7so16359005ad.3
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 08:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721835230; x=1722440030; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t5d22O2U1HZXGOIITw2LqK05yPy/MHAa8i4PSfFe0l0=;
        b=KMkS8yO76NCcGASjZ4h22H/HSPOS3vQY+v/OJIy/FXcvFs1GkWx3frI7UYl56jSrLy
         9nSkbBjFxIdgLMXWjOPPIpFxz6hBBFbl4Lr+s7CUtPSHwk8YXgN8PcLHy9AITh1zNUo8
         okB7LG3pJqBjWmdJPIgj2QMg9B9o3NnsHTNXCrpihRpK8kLZ6/IUAq+8tWDD9xNZjQjG
         gAoYtSznVOCMGfPH4K5X5Dd6LUOa3bvU4p6BbZ2mICVopkgKOCtKwWDDitWRQdDuvXhL
         B2BUKmiIrvrO1CsCTOBAB8HmQ4x5vIieGxbo7xhYFz6JvmbwNLGCvmnIYsNSOy5KzNuO
         2m2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721835230; x=1722440030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t5d22O2U1HZXGOIITw2LqK05yPy/MHAa8i4PSfFe0l0=;
        b=TglmktjjhYhSUbV5RRG/5/A4DEV66VD3JCrtx6lZxQgx6IKYo7xo5BG1YMBzOSTQkK
         DyqJCA7s42S7VjONownRRJ7zhaGxaQGd6gyJ3eiVNuan8u1iMLi5abxmkkCmjAFLFeUQ
         SeEO4NxQU1DMhaWYG5rSO8sNMNfw4E0zRhFpi891RzAkxhHIcTaBCV+WmFRJaOdCFiS2
         dmTnVGhM2ypvP4BcvvtZzGFpNgiVFh+K7XgdKsE8KxTYUFauuDdJZOOJi2UcHO81Hhll
         uV64OA009jYFLCt7i6QDuv2ti1NfQfj0N0pQLFnYJeo9CeIOQtZjil9UOuVnE5/tA9Mn
         dALA==
X-Gm-Message-State: AOJu0Yxn79TCCAhazG2DG6lA+MOLOzZEhj2YBzzmel00jotbhbvbAqvZ
	yIIDt1geXDW3n5Gq5S+AGAjt4K2cKCk73Ppkaau2W4/h8BdZjPLvizX39lTYS27fumQT9/VSETk
	fbg==
X-Google-Smtp-Source: AGHT+IFp8AI6gbmRyLzTJee5VbDdw2EnFi+qwFiv0O7eEIxkRJjpimCPtbFrYNlngAgcIlHr4t2Bc5XovWg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:22cd:b0:1fb:78ce:cefa with SMTP id
 d9443c01a7336-1fdd220c647mr67955ad.12.1721835230388; Wed, 24 Jul 2024
 08:33:50 -0700 (PDT)
Date: Wed, 24 Jul 2024 08:33:48 -0700
In-Reply-To: <20240724044529.3837492-1-tao1.su@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240724044529.3837492-1-tao1.su@linux.intel.com>
Message-ID: <ZqEPrE429UQi9duo@google.com>
Subject: Re: [PATCH] KVM: x86: Reset RSP before exiting to userspace when
 emulating POPA
From: Sean Christopherson <seanjc@google.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com, 
	xiaoyao.li@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 24, 2024, Tao Su wrote:
> When emulating POPA and exiting to userspace for MMIO, reset modified RSP
> as emulation context may not be reset. POPA may generate more multiple
> reads, i.e. multiple POPs from the stack, but if stack points to MMIO,
> KVM needs to emulate multiple MMIO reads.
> 
> When one MMIO done, POPA may be re-emulated with EMULTYPE_NO_DECODE set,
> i.e. ctxt will not be reset, but RSP is modified by previous emulation of
> current POPA instruction, which eventually leads to emulation error.
> 
> The commit 0dc902267cb3 ("KVM: x86: Suppress pending MMIO write exits if
> emulator detects exception") provides a detailed analysis of how KVM
> emulates multiple MMIO reads, and its correctness can be verified in the
> POPA instruction with this patch.

I don't see how this can work.  If POPA is reading from MMIO, it will need to
do 8 distinct emulated MMIO accesses.  Unwinding to the original RSP will allow
the first MMIO (store to EDI) to succeed, but then the second MMIO (store to ESI)
will exit back to userspace.  And the second restart will load EDI with the
result of the MMIO, not ESI.  It will also re-trigger the second MMIO indefinitely.

To make this work, KVM would need to allow precisely resuming execution where
it left off.  We can't use MMIO fragments, because unlike MMIO accesses that
split pages, each memory load is an individual access.

I don't see any reason to try to make this work.  It's a ridiculously convoluted
scenario that, AFAIK, has no real world application.

> Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> ---
> For testing, we can add POPA to the emulator case in kvm-unit-test.
> ---
>  arch/x86/kvm/emulate.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index e72aed25d721..3746fef6ca60 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1999,6 +1999,7 @@ static int em_pushf(struct x86_emulate_ctxt *ctxt)
>  
>  static int em_popa(struct x86_emulate_ctxt *ctxt)
>  {
> +	unsigned long old_esp = reg_read(ctxt, VCPU_REGS_RSP);
>  	int rc = X86EMUL_CONTINUE;
>  	int reg = VCPU_REGS_RDI;
>  	u32 val = 0;
> @@ -2010,8 +2011,11 @@ static int em_popa(struct x86_emulate_ctxt *ctxt)
>  		}
>  
>  		rc = emulate_pop(ctxt, &val, ctxt->op_bytes);
> -		if (rc != X86EMUL_CONTINUE)
> +		if (rc != X86EMUL_CONTINUE) {
> +			assign_register(reg_rmw(ctxt, VCPU_REGS_RSP),
> +					old_esp, ctxt->op_bytes);
>  			break;
> +		}
>  		assign_register(reg_rmw(ctxt, reg), val, ctxt->op_bytes);
>  		--reg;
>  	}
> 
> base-commit: 786c8248dbd33a5a7a07f7c6e55a7bfc68d2ca48
> -- 
> 2.34.1
> 

