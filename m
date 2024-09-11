Return-Path: <kvm+bounces-26539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B9549755AC
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 16:38:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A03431F2536E
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 14:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B2D71A3021;
	Wed, 11 Sep 2024 14:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2WADTme2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291AC19F47E
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 14:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726065390; cv=none; b=PyOoYu8CHyHovRN5VtBrXw4LTtTmAxm0EVi5iuzdTVu0W+xkKNkrsG6JAYB6rgnh4R6BxrpzAcXKl8+vEUoTfpYiOIv3cqSQ+uyQ0xa96pLz4K8BIzRRAeqnemJ08EGXNpQSHvB8mYwv8DAmR4P/HLlv9QObzrGumE9JlqJokyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726065390; c=relaxed/simple;
	bh=jmgy6ePhB7bLDBpTd81J0tiVbuti6trYQHnkM+1M0mE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JXdCrOPO62+dmp3uElLKb8pZkeqNd2OrqmDKM+XX5qcbuvSTk3VIXx4fAYApGFXz79sUpNXaGXjlVCahozYmiTCVH1GQ7C8/9fljV4+k1fuWDiwCDCNxDmavQ7pOIc9SfGeKyIZBx6qmFbEY2wTKo5P9JTZvD09vLgMe9E7PeJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2WADTme2; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7cf58491fe9so6552781a12.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 07:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726065388; x=1726670188; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6rTR8YGAn/aAtZT0hzqf25aT4TpKY7n5RE/q8NR1IC4=;
        b=2WADTme2a7B10jjNHTQZmMCG4anY4k7jNsFCvlqgqnnH8s6/qpsevn6GBkTkNAqfCf
         ped2DJPu492yZStQMuvGhrmaEkInKckFKDO8DU80tHinIJ1DpIkN84F1L/1NgdZNb8Jj
         8MZi7xqxjEYoFw/FbVVCFG1i8zVWo3KSNwEQ7Mw6yGcjhdMN+1gNibheX2WvV4F5ajeA
         BZmzWpLXl1V0hVZ5F1Cw+57+0NCEQNdxUB2ACfqSZyxY1k0m5Oh0bWcPB2GChWHI4g7L
         0+2oTD+bv/sj+e54ws0jQX9oBNE8ZvPH6KWfolzRvsFxSF1pxWBAJElkOarCG59hk2OH
         ymNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726065388; x=1726670188;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6rTR8YGAn/aAtZT0hzqf25aT4TpKY7n5RE/q8NR1IC4=;
        b=WJRAsl9R/aJXAylAs3ABTNquflfDRRQ6/yzJdB6Kl9a2CW0+BwuWBPEGh4norTnQmg
         kMNCl4PLf7Mh7gvuAbVxdkhnueuO5dWi7tPqLKOkIGOYV007gSK1eNeCtTKZfu29frcV
         wnflgq4+hEqeXAHOqbhysoaglqD7BzNNNpv3kDYgJ4PUl1NyEIYhgwgxEKYNv4MZuHeF
         f2D6SqTFG1Y2yMh/QuLQwXjn3RJGGGlu8MfK7HLJWsF8AW3i8rBHMgJfaWe191Q/5hAt
         HceCpjiLrc7/FnHnSWQ4Tey21Gn5Po3UEymmwToYxuN9r7VBwiXJbz0IdZz5/ktZsJ4R
         uWVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVobwOIbIQFOXMDU4bGuIIZF2V5nFz7HTagggLDGX50wqMsKaSVR6gx8xEhv75bdDS5XFA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcuUrEme1fblhdlOm9DayaFlvipUohtJ2x6ER97hyRhL2SCSuM
	YATk1p4P1S9GFFQ5e048+HTojkru3YMmpL4xxwldJEykDt4cYXM/esLYtgbrVBVVNkH1PPVVLme
	dgg==
X-Google-Smtp-Source: AGHT+IGHWdcYX1NkcVg1OQeMu4hjtViqzfIsCNlewZ9TUR7AJ+hEpfLh5HL5P11rsM9OQjoLPY9X/txlPPE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c405:b0:207:50e2:f54 with SMTP id
 d9443c01a7336-20750e20f6emr3336845ad.1.1726065388259; Wed, 11 Sep 2024
 07:36:28 -0700 (PDT)
Date: Wed, 11 Sep 2024 07:36:26 -0700
In-Reply-To: <07b0b475-9f45-4476-a63d-291f940f9b4d@amazon.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240509075423.156858-1-weijiang.yang@intel.com> <07b0b475-9f45-4476-a63d-291f940f9b4d@amazon.de>
Message-ID: <ZuGpJtEPv1NtdYwM@google.com>
Subject: Re: [RFC PATCH 1/2] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs support
From: Sean Christopherson <seanjc@google.com>
To: Nikolas Wipper <nikwip@amazon.de>
Cc: Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com, mlevitsk@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 11, 2024, Nikolas Wipper wrote:
> On Thu May  9, 2024 at 09:54 AM UTC+0200, Yang Weijiang wrote:
> > Enable KVM_{G,S}ET_ONE_REG uAPIs so that userspace can access HW MSR or
> > KVM synthetic MSR throught it.
> > 
> > In CET KVM series [*], KVM "steals" an MSR from PV MSR space and access
> > it via KVM_{G,S}ET_MSRs uAPIs, but the approach pollutes PV MSR space
> > and hides the difference of synthetic MSRs and normal HW defined MSRs.
> > 
> > Now carve out a separate room in KVM-customized MSR address space for
> > synthetic MSRs. The synthetic MSRs are not exposed to userspace via
> > KVM_GET_MSR_INDEX_LIST, instead userspace complies with KVM's setup and
> > composes the uAPI params. KVM synthetic MSR indices start from 0 and
> > increase linearly. Userspace caller should tag MSR type correctly in
> > order to access intended HW or synthetic MSR.
> > 
> > [*]:
> > https://lore.kernel.org/all/20240219074733.122080-18-weijiang.yang@intel.com/
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> 
> Having this API, and specifically having a definite kvm_one_reg structure 
> for x86 registers, would be interesting for register pinning/intercepts.
> With one_reg for x86 the API could be platform agnostic and possible even
> replace MSR filters for x86.

I don't follow.  MSR filters let userspace intercept accesses for a variety of
reasons, these APIs simply provide a way to read/write a register value that is
stored in KVM.  I don't see how this could replace MSR filters.  

> I do have a couple of questions about these patches.
> 
> > ---
> >  arch/x86/include/uapi/asm/kvm.h | 10 ++++++
> >  arch/x86/kvm/x86.c              | 62 +++++++++++++++++++++++++++++++++
> >  2 files changed, 72 insertions(+)
> > 
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index ef11aa4cab42..ca2a47a85fa1 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -410,6 +410,16 @@ struct kvm_xcrs {
> >  	__u64 padding[16];
> >  };
> >  
> > +#define KVM_X86_REG_MSR			(1 << 2)
> > +#define KVM_X86_REG_SYNTHETIC_MSR	(1 << 3)
> 
> Why is this a bitfield? As opposed to just counting up?

Hmm, good question.  This came from my initial sketch, and it would seem that I
something specific in mind since starting at (1 << 2) is oddly specific, but for
the life of me I can't remember what the plan was.  Best guest is that I was
leaving space for '0' and '1' to be regs and sregs?  But that still doesn't
explain/justify using a bitfield.

[*] https://lore.kernel.org/all/ZjLE7giCsEI4Sftp@google.com

> 
> #define KVM_X86_REG_MSR			2
> #define KVM_X86_REG_SYNTHETIC_MSR	3
> 
> > +
> > +struct kvm_x86_reg_id {
> > +	__u32 index;
> > +	__u8 type;
> > +	__u8 rsvd;
> > +	__u16 rsvd16;
> > +};
> 
> This struct is opposite to what other architectures do, where they have
> an architecture ID in the upper 32 bits, and the lower 32 bits actually
> identify the register. This would probably make sense for x86 too, to
> avoid conflicts with other IDs (I think MIPS core registers can have IDs
> with the lower 32 bits all zero) so that the IDs are actually unique,
> right?

It's not the opposite, it's just missing fields for the arch and the size.  Ugh,
the size is unaligned.  That's annoying.  Something like this?

struct kvm_x86_reg_id {
	__u32 index;
	__u8  type;
	__u8  rsvd;
	__u8  rsvd4:4;
	__u8  size:4;
	__u8  x86;
}

Though looking at this with fresh eyes, I don't think the above structure should
be exposed to userspace.  Userspace will only ever want to encode a register; the
exact register may not be hardcoded, but I would expect the type to always be
known ahead of time, if not outright hardcoded.  The struct is really only useful
for the kernel, e.g. to easily switch on the type, extract the index, etc.

As annoying as it can be for a human to decipher the final value, the arm64/riscv
approach of providing builders is probably the way to go, though I think x86 can
be much simpler (less stuff to encode).

Oh!  Another thing I think we should do is make KVM_{G,S}ET_ONE_REG 64-bit only
so that we don't have to deal with 32-bit vs. 64-bit GPRs.  32-bit userspace
would need to manually encode the register id, but I have no problem making life
difficult for such setups.  Or KVM could reject the ioctl for .compat_ioctl(),
but that seems unnecessary.

E.g. since IIUC switch() and if() statements are off-limits in uapi headers...

#define KVM_X86_REG_TYPE_MSR	2ull

#define KVM_x86_REG_TYPE_SIZE(type) 						\
{(										\
	__u64 type_size = type;							\
										\
	type_size |= type == KVM_X86_REG_TYPE_MSR ? KVM_REG_SIZE_U64 :		\
		     type == KVM_X86_REG_TYPE_SYNTHETIC_MSR ? KVM_REG_SIZE_U64 :\
		     0;								\
	type_size;								\
})

#define KVM_X86_REG_ENCODE(type, index)				\
	(KVM_REG_X86 | KVM_X86_REG_TYPE_SIZE(type) | index)

#define KVM_X86_REG_MSR(index) KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_MSR, index)

