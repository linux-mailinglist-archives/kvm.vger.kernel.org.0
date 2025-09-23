Return-Path: <kvm+bounces-58566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14E96B96C79
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 18:16:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB6063B0390
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B3432E092A;
	Tue, 23 Sep 2025 16:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g/3rpUID"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4174B26E146
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 16:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758644128; cv=none; b=f/Q6tMnB779sYQzunWrX3s9940LlX8OZrLbnBNnm8Do1sXiWiWefvn2nnbsMiNx62Yzz0Y7a9IsumFutvTFtgE6UCnCVo7pypBJgbDRPjUtPTeAhYUno3W5Gl/E/ejdnISO/Mhg6sHRdeps8p/owBuJ1lkJNBc3eY1CGkV36nSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758644128; c=relaxed/simple;
	bh=VIVjToBX2NpxaBGjbh8Fl3Ao604u/kZy8Gn/XoRUIB8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=chlSPaGQItWZU+QISRDGHgTtJYYXYoCwLIe1c7Ggo090V4IsSc8aL+9l6mHaKCN98jmIuvrwpXFCnc1Eeuj/75nny9H7NpyJ4HdclQf+JJOmE9AZSubBNmIfcvnBRLB2r0SNJlFJYGJ8l9ZS48ikubvLj0y5tqtVBGxLBzC5fOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g/3rpUID; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ea7fcddd8so10647018a91.3
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 09:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758644126; x=1759248926; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A8czW792+oj2KV1AnZ6HhEEejmDnfjOIbzMwTe8ybUE=;
        b=g/3rpUIDClSIwUfkhHaJDL32lOAoouSyLRXj2iHKl7MVR51sZQQuYu3vg/17LuTnsf
         1n84OhdpVdQyG/jrGDigKS/ZF1yxUIkpCwNaffH5zugUy3i6Q8yyOlmN4t7aizdMpG/D
         nWtmSg8K4JFmvuXNkna9198M2GClcyaRE7oj3nlPPz5h4L6WodrsUk3kUsk6ceFlCQBw
         Ngh4MbmcALjBi5K+TDC52X3Azu5F0s6wU8ZdKc9eBs0RuVonVt7xQ/OJRclKDdWjhkw/
         kt2uBa+7xroOH29ZE9Pe0hvra8ZDYxopSK2n8HXnYPjoKcrxMw/IRapCMyeMSFav8i6E
         X3hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758644126; x=1759248926;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A8czW792+oj2KV1AnZ6HhEEejmDnfjOIbzMwTe8ybUE=;
        b=sg2lnANga+B8n4Brf1INkA/Q48hDeh0ZSSdDLNP2ANjeezSCsMsN6vC8gammtCqikp
         hSgyIN+Hd6ngyGpp3xfCjZnRdHqNMzM3p+c1eKiQdv/ZtiyWNBKEDzdxTehnYL/tS6eN
         R+IpwdiEgZBJDArG5p+H3dBb5G1fibmq2hLHsDGmMRD226y2kll/r3/9KDobucqlVQWh
         6EBIOcKn+fuE0C6oz7Rsw0uKg9+qup7zdtvd98igB9PlFMsVNoJXRak130PVjoCX4ZgF
         WV35qywb6R7fT9GAyTk6RZe5GL6j46d/8nmENKBkSu0pKZYgts9o/operbUHwxGKqq6a
         gk0w==
X-Forwarded-Encrypted: i=1; AJvYcCUrrHgVi2+UNLFaUJIcRfAOkEW0C6W22IsY/DJPDzrjwIy6hS8rgMdpyy/3KehLokw6YKc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkZITKSFhwOvOTQibJyAGmWozGfOLWH3Kyr9pLfwUJH7Tztwuk
	qfEosT2KkpPe+iiGFEfuf4FAERuuIHlX+qDCeF9nbZhgIPd6fUied3PTyOtdF7w2yI2j3sqCaYG
	hVenxZQ==
X-Google-Smtp-Source: AGHT+IHHjTqKCVgw6SgsPYwqUOioEQpweKo/z/+paeQ7pN85Ant9Y+niIgm2LIEStVcV5YpSdV1Mjgyvn/A=
X-Received: from plbkf5.prod.google.com ([2002:a17:903:5c5:b0:269:b2a5:8823])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f985:b0:270:4964:ad7c
 with SMTP id d9443c01a7336-27cc28bc31cmr31931065ad.2.1758644126442; Tue, 23
 Sep 2025 09:15:26 -0700 (PDT)
Date: Tue, 23 Sep 2025 09:15:24 -0700
In-Reply-To: <287c2195-740c-4f2e-a545-c886962fc542@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com> <20250919223258.1604852-19-seanjc@google.com>
 <aNEkrlv1bdoRitoU@intel.com> <aNGrwzoYRC_a6d5D@google.com> <287c2195-740c-4f2e-a545-c886962fc542@intel.com>
Message-ID: <aNLHnFa4mD3mA8Gd@google.com>
Subject: Re: [PATCH v16 18/51] KVM: x86: Don't emulate instructions affected
 by CET features
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 23, 2025, Xiaoyao Li wrote:
> On 9/23/2025 4:04 AM, Sean Christopherson wrote:
> Two nits besides,
> > Link:https://lore.kernel.org/r/20250919223258.1604852-19-seanjc@google.com
> > Signed-off-by: Sean Christopherson<seanjc@google.com>
> > ---
> >   arch/x86/kvm/emulate.c | 117 ++++++++++++++++++++++++++++++++++++-----
> >   1 file changed, 103 insertions(+), 14 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > index 23929151a5b8..a7683dc18405 100644
> > --- a/arch/x86/kvm/emulate.c
> > +++ b/arch/x86/kvm/emulate.c
> > @@ -178,6 +178,7 @@
> >   #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
> >   #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
> >   #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
> > +#define ShadowStack ((u64)1 << 57)  /* Instruction affects Shadow Stacks. */
> >   #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
> > @@ -4068,9 +4069,9 @@ static const struct opcode group4[] = {
> >   static const struct opcode group5[] = {
> >   	F(DstMem | SrcNone | Lock,		em_inc),
> >   	F(DstMem | SrcNone | Lock,		em_dec),
> > -	I(SrcMem | NearBranch | IsBranch,       em_call_near_abs),
> > -	I(SrcMemFAddr | ImplicitOps | IsBranch, em_call_far),
> > -	I(SrcMem | NearBranch | IsBranch,       em_jmp_abs),
> > +	I(SrcMem | NearBranch | IsBranch | ShadowStack, em_call_near_abs),
> > +	I(SrcMemFAddr | ImplicitOps | IsBranch | ShadowStack, em_call_far),
> > +	I(SrcMem | NearBranch | IsBranch, em_jmp_abs),
> 
> The change of this line is unexpected, since it only changes the indentation
> of 'em_jmp_abs'
> >   static unsigned imm_size(struct x86_emulate_ctxt *ctxt)
> >   {
> >   	unsigned size;
> > @@ -4943,6 +4998,40 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
> >   	ctxt->execute = opcode.u.execute;
> > +	/*
> > +	 * Reject emulation if KVM might need to emulate shadow stack updates
> > +	 * and/or indirect branch tracking enforcement, which the emulator
> > +	 * doesn't support.
> > +	 */
> > +	if ((is_ibt_instruction(ctxt) || is_shstk_instruction(ctxt)) &&
> > +	    ctxt->ops->get_cr(ctxt, 4) & X86_CR4_CET) {
> > +		u64 u_cet = 0, s_cet = 0;
> > +
> > +		/*
> > +		 * Check both User and Supervisor on far transfers as inter-
> > +		 * privilege level transfers are impacted by CET at the target
> > +		 * privilege level, and that is not known at this time.  The
> > +		 * the expectation is that the guest will not require emulation
> 
> Dobule 'the'

Squashed fixes for both, thanks!

