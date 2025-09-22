Return-Path: <kvm+bounces-58394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 73A1FB924B6
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 18:48:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75B0719057E4
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 16:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 929D930C625;
	Mon, 22 Sep 2025 16:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jP+SkGLC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FB6192B66
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 16:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758559681; cv=none; b=K1VBsyvqxi0XEVnspovuZlkr+alV/jna9dHkED91YZnUsl+nBKgZ8nD2VFP9ukcLzH35hFG/StFvdelawo1gjHLN0fcAjpb8wMALv0JQRbS4YWXYo4dk5OjP4ov9gIjCHg9148wqBpGxLPR1N1mtmaJFo7gW1g9z2VOYcV9OMoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758559681; c=relaxed/simple;
	bh=oBsuLu2JKLUCe613+lzwlMJIhrh+NP73BJEi31jJDSg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fXCgaa5jzmLZYGnSv43wrbnMc0hrTfJT+Rlya6VWhk3BkB+b37ru4fX2E357nXQ4DAs6o+G4fOaR9A1EQ+n6p40aUcVUoCS6/3LzTh6RWohGMqPDPB9x54g4jgoeBEcnA7FVeZYMTi5t9ikeDY8j0llx2P5Y00IjgRpVgelPNZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jP+SkGLC; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eddb7e714so4408171a91.1
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 09:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758559680; x=1759164480; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nZxssYmv2P9XlWR/CvEwa1BjM+msCoDFVwURRmwcEDI=;
        b=jP+SkGLC60/9s1E5ZY3XRbrOlOjUNQEvMW/UMFO9O9U3Q0he/Zu3I2jR+PmhNJJj62
         UZ40WDLFO28Kbn1qWDXZ2ihGqRZXxDz1liTYnqSebmEVTjFmzXiyLIxhZgp/obsZyO6Y
         hOKFoks79TWchvya99JfnagBAtAVBxg3gj7/8qdGvXuPOBKHWiKToIAaYgQKLWP0tvNc
         NInzhOQE3nBy221rfzCtpX9M//D25lhcELDXg+JWeaO/xnnofEqKJrLiY9OdznmF5qu7
         wbeC0fx/tEWpjPEVkbGa4vN8H1+cUakIX4NIO67H2fxN9MfXJJAHop8TA5HtPYNE7hxt
         Hv0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758559680; x=1759164480;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nZxssYmv2P9XlWR/CvEwa1BjM+msCoDFVwURRmwcEDI=;
        b=Hdj1fvZ0xMOZM8g/rbo4UuaB22yldrs3qSAcfwN04Czr3IH+J/2/KzLeKTcEyVOEFx
         tF8xFKlWMipGJzYd20fCMdThozlKoTtBLh7fv2eWbufJ7GTSnIIA20uGiJdN3hinm0oW
         yYFqi7QYKYBLqk93NtXpGeiHugBPdT4M9Psg4g0ZP5r2hHAJh2Lge8zNt+mO5je/Sd8N
         CSeroI4I4jvLodvJbtX9hoW5GriXd5bLc41y4vJft1Rgpg0U5fa9P7j+8OK6jbGjUuBZ
         ASi1k92Fbr48B1zE+oNKIOx57Z7/Z21A5sfkk5zH5NnO6i/L/PUkzidlkYZm3ySpfjHW
         E37A==
X-Forwarded-Encrypted: i=1; AJvYcCUBuBaAKkd2atbJBTfp9Afr5RokLgq0MB8n7IrKzKCN1FvZCi3g5a7E53c86eIutrKdbL0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbM6t4vjVGdgXTPIBATy+o9iHT8UdEvYJt+AsB27EK4qpif96I
	NBDS/3OIwOFzkyGNG/afUGi5ac7dyoucIm2KPOL1YgA76rTZ657Nmr6OgLxvfst6s8y/MKLXre2
	bjMoJHA==
X-Google-Smtp-Source: AGHT+IGojpc09mO4sS5IQtH1pMKr5UDq6eS+hvNvRxsB51ymoZmpeQBnjx9Nm2euJcyPrtndPO4XVevFu9c=
X-Received: from pjf16.prod.google.com ([2002:a17:90b:3f10:b0:32e:c813:df48])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d07:b0:32d:d5f1:fe7f
 with SMTP id 98e67ed59e1d1-3309810d081mr19272382a91.15.1758559679712; Mon, 22
 Sep 2025 09:47:59 -0700 (PDT)
Date: Mon, 22 Sep 2025 09:47:58 -0700
In-Reply-To: <fd8ebddd-adfc-4eef-bf30-20139574d0dd@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com> <20250919223258.1604852-19-seanjc@google.com>
 <fd8ebddd-adfc-4eef-bf30-20139574d0dd@linux.intel.com>
Message-ID: <aNF9vnXrRnKjC1DD@google.com>
Subject: Re: [PATCH v16 18/51] KVM: x86: Don't emulate instructions affected
 by CET features
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 22, 2025, Binbin Wu wrote:
> > +static bool is_ibt_instruction(u64 flags)
> > +{
> > +	if (!(flags & IsBranch))
> > +		return false;
> > +
> > +	/*
> > +	 * Far transfers can affect IBT state even if the branch itself is
> > +	 * direct, e.g. when changing privilege levels and loading a conforming
> > +	 * code segment.  For simplicity, treat all far branches as affecting
> > +	 * IBT.  False positives are acceptable (emulating far branches on an
> > +	 * IBT-capable CPU won't happen in practice), while false negatives
> > +	 * could impact guest security.
> > +	 *
> > +	 * Note, this also handles SYCALL and SYSENTER.
> 
> SYCALL -> SYSCALL

Fixed.

> > +	 */
> > +	if (!(flags & NearBranch))
> > +		return true;
> > +
> > +	switch (flags & (OpMask << SrcShift)) {
> > +	case SrcReg:
> > +	case SrcMem:
> > +	case SrcMem16:
> > +	case SrcMem32:
> > +		return true;
> > +	case SrcMemFAddr:
> > +	case SrcImmFAddr:
> > +		/* Far branches should be handled above. */
> > +		WARN_ON_ONCE(1);
> > +		return true;
> > +	case SrcNone:
> > +	case SrcImm:
> > +	case SrcImmByte:
> > +	/*
> > +	 * Note, ImmU16 is used only for the stack adjustment operand on ENTER
> > +	 * and RET instructions.  ENTER isn't a branch and RET FAR is handled
> > +	 * by the NearBranch check above.  RET itself isn't an indirect branch.
> > +	 */
> > +	case SrcImmU16:
> > +		return false;
> > +	default:
> > +		WARN_ONCE(1, "Unexpected Src operand '%llx' on branch",
> > +			  (flags & (OpMask << SrcShift)));
> > +		return false;
> 
> Is it safer to reject the emulation if it has unexpected src operand?

Not really?  Maybe?  Honestly, we've failed miserably if this escapes initial
development and testing, to the point where I don't think there's a "good"
answer as to whether KVM should treat the instruction as affecting IBT.  I think
I'd prefer to let the guest limp along and hope for the best?

