Return-Path: <kvm+bounces-58106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CE325B87967
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 03:25:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A93A41CC0A79
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 01:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8116C23535E;
	Fri, 19 Sep 2025 01:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kPcRkQ2P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4426034BA53
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 01:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758245118; cv=none; b=htIhSf9yFhGTrC6iGU/hVlTc2KS+ohwmEYLHYRuja0Lm/lEzgwpabmDQnYGzgaJ1lF8Je3fOWswdAvF5Flmif7RUcaJhcOLtVPj48BqE1w0B1ZhTrUmzzjFz/5TBXQnFfYTOtMS1/IrGdyC94N5WAfXh0T055hwJ5pXLDxYfE54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758245118; c=relaxed/simple;
	bh=F10w7GXnYqZuQcuUvgsOrtm6lx27oGjAGWiuy7aAZNU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f/1EkznYbxW/UJ9jv2cIzaMggkr+tc1QW3qtebL6SECt8UikLmCjB6zIhNNxMSzAwT5ORxgK89xXLkj3/DRoVaO/HD94mN33G+MLoCvshmRhugt3qNtFhHJWmq0ONcvPDHdphOrhA1OD3oSfYs+rugdtWxb6b3yEXqrsqU3yra4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kPcRkQ2P; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b54c46337c9so2073453a12.1
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 18:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758245115; x=1758849915; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=syjk1JDzzXtimoUVNldbIF3qBbB16eg6JuA8ggdhqSQ=;
        b=kPcRkQ2Pp4Wx0VrOUhaNvizr2PHOoqb5bAp/SLOSl9Hq73KrC5x7pbtdo0nWmeoPh/
         H/M95wyeaofNBamGbnFioeF6WpntzKSjSovhlMf8oZIKWEFEGBn2u+18TG4rrCRJqWOB
         UMKgtrpuAtmsVT5WsANnv5m1/4z7/2teU7N2Tr3/SzefrNtfstcvR+Hqax8nSS6REWGK
         WuO0QKAIrVvnE9HqxQRqawCkFYn1ACrp8tfAqxE26mVAgrQ6+/ZUjiYfpB9AzxRItN9v
         e9WXSl+uspjmX0A2+EGaEgb1zrWPEy/kUptvdWB3mIN0E2oEFXguhUklPmm/r+CFXlie
         pqAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758245115; x=1758849915;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=syjk1JDzzXtimoUVNldbIF3qBbB16eg6JuA8ggdhqSQ=;
        b=qAlkRTYqV36gnRsWkp1e+tWgXhu4IdjrSa/KCOHoYsx41ylZvzHtbPR9WjpqzmN4Bs
         yG6CawwajIPt79UB2Sn239FnPgAuZ9ZQwM5SK+PmCtNMS6pYCS9WuLTPfNLWxD7lquGv
         OadyfkMzuU82CiSlF/Ae2iMAjLml/AvdXtU3t2mfmJXptKGPfAFnhKATGdErpJ3JUiko
         QasS1zneUGg9CCjH6a+n1bQ5vvSHk4ub5n7qoK+cV/jbVIyOTIHEt4syp3hzc2WZMrbI
         bisU+oD0bVVxSiL42ZDoxFsvAzQBmmtruH0X7N0Umzs2PW/h4LJIJxeQZ3rjGpqIqjMC
         a9aw==
X-Forwarded-Encrypted: i=1; AJvYcCUaUyuu/QzGva2GII4dZwOE0frS/FcEmdxiB/xkd9kXA4jiRaeNbicAvaJkhId5C7tLKcw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQEARmK/HzK1fqubvDmDYhh+IekLEfgcPbMIuunNaOVP0s6A8l
	w6VeeM5k6VHIiym2uDLBc57yN/2BHz/zegYCjyZh6zPfMolhXBuf7Hf1yzBVzS1XuB3R3wlmmGc
	jElY/GQ==
X-Google-Smtp-Source: AGHT+IGTd+vEjpomX02lg40sIK070BEa7zAMmWaWfSxkGdN0a6rntlPdVM/Flldu5zvnn8HY9gT5KwIkR3I=
X-Received: from pjbpl3.prod.google.com ([2002:a17:90b:2683:b0:330:7ff5:e413])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f84:b0:32d:f352:f75c
 with SMTP id 98e67ed59e1d1-33097ff63f6mr1575094a91.13.1758245115597; Thu, 18
 Sep 2025 18:25:15 -0700 (PDT)
Date: Thu, 18 Sep 2025 18:25:14 -0700
In-Reply-To: <aMwT5nfXEFLJvvrP@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com> <20250912232319.429659-19-seanjc@google.com>
 <55ab5774-0fcc-469a-8edc-59512def2bae@intel.com> <aMwT5nfXEFLJvvrP@intel.com>
Message-ID: <aMyw-jYNEQl4g8Jk@google.com>
Subject: Re: [PATCH v15 18/41] KVM: x86: Don't emulate instructions affected
 by CET features
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 18, 2025, Chao Gao wrote:
> >> 
> >> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> >> index 542d3664afa3..e4be54a677b0 100644
> >> --- a/arch/x86/kvm/emulate.c
> >> +++ b/arch/x86/kvm/emulate.c
> >> @@ -178,6 +178,8 @@
> >>   #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
> >>   #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
> >>   #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
> >> +#define ShadowStack ((u64)1 << 57)  /* Instruction protected by Shadow Stack. */
> >> +#define IndirBrnTrk ((u64)1 << 58)  /* Instruction protected by IBT. */
> >>   #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
> >> @@ -4068,9 +4070,9 @@ static const struct opcode group4[] = {
> >>   static const struct opcode group5[] = {
> >>   	F(DstMem | SrcNone | Lock,		em_inc),
> >>   	F(DstMem | SrcNone | Lock,		em_dec),
> >> -	I(SrcMem | NearBranch | IsBranch,       em_call_near_abs),
> >> -	I(SrcMemFAddr | ImplicitOps | IsBranch, em_call_far),
> >> -	I(SrcMem | NearBranch | IsBranch,       em_jmp_abs),
> >> +	I(SrcMem | NearBranch | IsBranch | ShadowStack | IndirBrnTrk, em_call_near_abs),
> >> +	I(SrcMemFAddr | ImplicitOps | IsBranch | ShadowStack | IndirBrnTrk, em_call_far),
> >> +	I(SrcMem | NearBranch | IsBranch | IndirBrnTrk, em_jmp_abs),
> >
> >>   	I(SrcMemFAddr | ImplicitOps | IsBranch, em_jmp_far),
> >
> >It seems this entry for 'FF 05' (Jump far, absolute indirect) needs to set
> >ShadowStack and IndirBrnTrk as well?
> 
> Yes. I just checked the pseudo code of the JMP instruction in SDM vol2. A far
> jump to a CONFORMING-CODE-SEGMENT or NONCONFORMING-CODE-SEGMENT is affected by
> both shadow stack and IBT, and a far jump to a call gate is affected by IBT.

The SHSTK interaction is only a #GP condition though, and it's not _that_ awful
to emulation.  While somewhat silly, I think it makes sense to reject FAR JMP if
its IBT, but implement the SHSTK check.  Rejecting a JMP instruction for SHSTK
is weird/confusing (though definitely easier).

