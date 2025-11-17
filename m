Return-Path: <kvm+bounces-63386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DBF5DC64E32
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 16:34:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BE6DE4EB8C7
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 15:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FB1B26FA50;
	Mon, 17 Nov 2025 15:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GviMYg7O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9ED26A1A7
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 15:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763393596; cv=none; b=tTJoPLi+DtjDwooCjMnOOR7kQgg7KF7Cz1rH+yk2T56TuQvCujry8mVVT84mMAKPqBo56pQ4s5927LPQLZmYEcRoREhNaAEm1KNmiXM5XyQKDKy9e/xCWECEu796vEnJEgi6tl1+2fiNQ5WFKCxqT42lwjZJmzdbMKonpvaoEdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763393596; c=relaxed/simple;
	bh=vfPBrJeS2zy3Pr5qUbo3c9/th+wmOm9aNfjfH1EDVuo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z2bQi/Xu4nF4+5W65sq9Fn0S0SYMpFPFGmcgziQdjkyNdlcB00z85VnwX0EE3xMRzzvLl07tD83x6HTtiVAd4OcHxVa0c37ihm+KNiCgTUSbtdCXtYCULmLv/txnScBNBdkDA2ymYkHOgTX0dKA/wNItMN9NWfYQPjrAoF0II/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GviMYg7O; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-297e1cf9aedso112292355ad.2
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 07:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763393594; x=1763998394; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jZVnU6sEl/ZvXIBOWZZgUqq535OZa3/OaAIZTP1Sqpg=;
        b=GviMYg7OvxWvhlRXZz2gGXVOw6B0wEblGw6H6b1QSS2pp5TvljiW0cPEdUTCj47UVP
         U0PTx4Wsnak721/b5EaSmPUy38p5smrGnXDOVlOqUtEZJw7iHPu1It7tw0W21N3Bar/d
         J22e0WBzl85jKFGLkfAJQcBbUcfg/bYZpUr+zzbgSUSaVcALmXkOL/JAru75CEdF0FHm
         D1sYK5FU4vLBbNtX0Q1nM7ysqluBPJgwGPBwyu2dj7ZsYKaoGcN+FQCl7YRi5PCQVYCR
         adJKW3NS3dAE3eSjp5lVwFvxt4pvi4C+nrHYE78x7sUB/sbn5ziJTrt55EOTJR4gR8pM
         A7cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763393594; x=1763998394;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jZVnU6sEl/ZvXIBOWZZgUqq535OZa3/OaAIZTP1Sqpg=;
        b=lhraVXLkpee2CbuwkrIMGa1NHUtWjohhog9uuDFUEgFx0O4Mo+XdSh5+ytpkZ+9pp6
         Gx6KYt/Cl4kba09veEypb508WIXL8Nxeo4+1mqKvOSxu5YpWvgLsPN0vxiSyCAsd01zl
         oBm1MqX0oVkftbQPNjjL0k5mZIrwFZ9bKPt42D7LjP0B7wYUASp08hJcxibgWtl3gocY
         EklIsHT7Uba8KZPyGsufwz72bw1ZSsmYzwIuI9U8qxVDlIPcxwty/WHT2wzfbqH6i2EY
         L6XoL9E/7PXH2T5tFcospgsCnxqu7ZpgYy9kmNQQrfVqxSQWbDwqU4mbVDLeRasihJfP
         UKyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKu42yZiU5i7LDjznd5Zj6slhDSG02vIJO5vD9n+yU92mbyrPC3uQaLHs3FSR3ZRnR2OM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjHC3vgZ98izi8MtHIOUOGdtEu0W41uTy2to04boBIh4ShkTtp
	TIpWICMqufxVg20hScbyLEGpu6EqaFx/TLKSKRMJ3qGC3Za0ssM+bocojQ8LAtq/TJ61hiNX6YF
	vMi/h5A==
X-Google-Smtp-Source: AGHT+IFcgfANbxH+X/dUGfVq/aeS1cRKeejyd5VPubS9BUqqZdUmhH8BQp318t3RcHruJkyP4bWYEAY+/cc=
X-Received: from plblv16.prod.google.com ([2002:a17:903:2a90:b0:297:eb04:dff7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec83:b0:297:fec4:1557
 with SMTP id d9443c01a7336-2986a7598abmr139975895ad.60.1763393594305; Mon, 17
 Nov 2025 07:33:14 -0800 (PST)
Date: Mon, 17 Nov 2025 07:33:12 -0800
In-Reply-To: <20251117101129.GGaRr00XgEln3XzR5N@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113233746.1703361-1-seanjc@google.com> <20251113233746.1703361-4-seanjc@google.com>
 <20251117101129.GGaRr00XgEln3XzR5N@fat_crate.local>
Message-ID: <aRtAOM040vM9RGfK@google.com>
Subject: Re: [PATCH v5 3/9] x86/bugs: Decouple ALTERNATIVE usage from VERW
 macro definition
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 17, 2025, Borislav Petkov wrote:
> On Thu, Nov 13, 2025 at 03:37:40PM -0800, Sean Christopherson wrote:
> > +#define __CLEAR_CPU_BUFFERS	__stringify(VERW)
> 
> Let's get rid of one indirection level pls:
> 
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index 8b4885a1b2ef..59945cb5e5f9 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -309,23 +309,21 @@
>   * Note: Only the memory operand variant of VERW clears the CPU buffers.
>   */
>  #ifdef CONFIG_X86_64
> -#define VERW	verw x86_verw_sel(%rip)
> +#define VERW	__stringify(verw x86_verw_sel(%rip))
>  #else
>  /*
>   * In 32bit mode, the memory operand must be a %cs reference. The data segments
>   * may not be usable (vm86 mode), and the stack segment may not be flat (ESPFIX32).
>   */
> -#define VERW	verw %cs:x86_verw_sel
> +#define VERW	__stringify(verw %cs:x86_verw_sel)
>  #endif

Brendan also brought this up in v4[*].  Unless there's a way to coerce ALTERNATIVE_2
into working with multiple strings, the layer of indirection is needed so that KVM
can emit __stringify() for the entire sequence.

  : Heh, I tried that, and AFAICT it simply can't work with the way ALTERNATIVE and
  : friends are implemented, as each paramater needs to be a single unbroken string.
  : 
  : E.g. this 
  : 
  : diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
  : index 61a809790a58..ffa6bc2345e3 100644
  : --- a/arch/x86/kvm/vmx/vmenter.S
  : +++ b/arch/x86/kvm/vmx/vmenter.S
  : @@ -63,6 +63,8 @@
  :         RET
  :  .endm
  :  
  : +#define CLEAR_CPU_BUFFERS_SEQ_STRING  "verw x86_verw_sel(%rip)"
  : +
  :  .section .noinstr.text, "ax"
  :  
  :  /**
  : @@ -169,9 +171,9 @@ SYM_FUNC_START(__vmx_vcpu_run)
  :  
  :         /* Clobbers EFLAGS.ZF */
  :         ALTERNATIVE_2 "",                                                       \
  : -                     __stringify(jz .Lskip_clear_cpu_buffers;                  \
  : -                                 CLEAR_CPU_BUFFERS_SEQ;                        \
  : -                                 .Lskip_clear_cpu_buffers:),                   \
  : +                     "jz .Lskip_clear_cpu_buffers; "                           \
  : +                     CLEAR_CPU_BUFFERS_SEQ_STRING;                             \
  : +                     ".Lskip_clear_cpu_buffers:",                              \
  :                       X86_FEATURE_CLEAR_CPU_BUF_MMIO,                           \
  :                       __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF_VM
  :  
  : yields wonderfully helpful error messages like so:
  : 
  :   arch/x86/kvm/vmx/vmenter.S: Assembler messages:
  :   arch/x86/kvm/vmx/vmenter.S:173: Error: too many positional arguments
  : 
  : If there's a magic incanation to get things to work, it's unknown to me.

[*] https://lore.kernel.org/all/aQT1JgdgiNae3Ybl@google.com

