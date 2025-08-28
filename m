Return-Path: <kvm+bounces-56198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22791B3AE5B
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 01:18:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE08E4678BD
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 23:18:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C55312D0C72;
	Thu, 28 Aug 2025 23:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nf5ZIxAI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876A920B22
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 23:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756423081; cv=none; b=C40d82BL2jkIMZCyumJX/LPf7gCd1xCr9SsDHf3+QtIRVB1WnbID6nKSojEOWEHSbf2Wp5oIaiZLPQKahNxCwJQhi5nO1xUjsCetqWLXARjF3+4iFdwch1ZGJSpIi5y2GrEcmQ6XSIN+X78WyY5N3qzLNp6MfLcDPNVqirbinlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756423081; c=relaxed/simple;
	bh=X7Ken+InegB0qILDbgF8NiZPpqKSTsqEr13i/oP+Ks8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KbDwmZ5BPtsGf/ssd+LZSrnxsV6MDlOY2xhYIzZ14rnx4vQQczK9Mw0TEp3wnrfV8EPbz/M2WCTsUd0AmuUu6rw9SiqZiHEVic/amlCnQygSXjvmeouMCDoI1yP4x5LegA8UVWbdAkVRLzdzcM2AsIbpT4Z3imVl+hvbEv6sCYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nf5ZIxAI; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24457f59889so15211795ad.0
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 16:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756423079; x=1757027879; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R6X/JtrPOH7Cglu+2PFvXS7nKL3G5XnWtAxuFvwp2Jg=;
        b=nf5ZIxAI5gvI/iFRQbt6BXLphA1t756pxK2K3h7JXEoORPPJxs9H3FO6yna/j8vIYE
         yfczzJj3ztnINGaxPAdj/N7MIuEbzK9uQ1zH1ZwB3qCxTRm0MiBleiTG72zvJTyERZ1a
         yybYNCNbmaka/8CFGwzeeFlQmAJE2uqzo3/njZD5rAc2n62dKIW5QGfq2zYRt0NFBkud
         /RbNtjZNGkONeWbwNFs6oB7ox7sJVUQzS0qcxTntXDC0q58FtzPBlSzxKgfrixDM+RNm
         Mbtcz4CDusnb+EmKVOh7oB9iK5te47jpewXBISw3xSYPV+FbpyC7lBC5UIGPcpLGtlui
         6WkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756423079; x=1757027879;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=R6X/JtrPOH7Cglu+2PFvXS7nKL3G5XnWtAxuFvwp2Jg=;
        b=KO8QL/VwjntBDCh3O/6Bfl1ZBSbkfxyf0GkRVhmr33XfVXVYmtrslyzf2VSy8oNNAB
         xKFhmVitNaL+JqxLKk+o8eAIo7lCHZamjokV1uZ+ruo+vaQg7GiwRL95q8fhM3jzsZqf
         VMZ+xItwSYrFBV3q7GMNqVPubM0JgD1vzXydh9kDxUI38O1Li7A+WQgzUhZ1bRHh9jBX
         D81dpcsOMg2u8/xIgfy1wm2jJevFoWImQnkkz9UGJoq94G7uu/QHmFpxJ+rweP7I9Lq3
         TtbOrIBkfTTXNiuYjWYctM6LTShlXtrtiGJeGxp41wXPLqk8pr7DvHEeClMtTgsKJ7KV
         tRIw==
X-Forwarded-Encrypted: i=1; AJvYcCW9stADsBjsUp09zjth8e3dxi9vFuXa5yfSJAP5bJWEnqfD2xsPl3gbF1Jr++lzMphVC9Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyP/WQdMLlqsTaWIAmfDCm7d8CTh2/fiMvMEdLr/yTureqhc8hj
	ofU3MNh5SKCAu2UID4I/fDFpSOIwjDJ6pCXevxxmJEb2jaymy/xLil2w0ZFQi6RWIf5h+R6Lb+O
	q7VUFUg==
X-Google-Smtp-Source: AGHT+IEd3cEL8zvyLYGSePsgTddgu0cYsK/gvxcZ3Wmsi3+H6tXT4tg+UPDJ4J37xI87gKw9JyyZaIy4xtA=
X-Received: from plpk16.prod.google.com ([2002:a17:903:3db0:b0:248:f2e1:d138])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ecc6:b0:243:12d5:db43
 with SMTP id d9443c01a7336-2462eb44c45mr353100025ad.0.1756423078866; Thu, 28
 Aug 2025 16:17:58 -0700 (PDT)
Date: Thu, 28 Aug 2025 16:17:57 -0700
In-Reply-To: <68b0d2fb207cc_27c6d294e1@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827000522.4022426-1-seanjc@google.com> <20250827000522.4022426-10-seanjc@google.com>
 <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com> <aK9Xqy0W1ghonWUL@google.com>
 <aK/sdr2OQqYv9DBZ@yzhao56-desk.sh.intel.com> <aLCJ0UfuuvedxCcU@google.com>
 <fcfafa17b29cd24018c3f18f075a9f83b7f2f6e6.camel@intel.com>
 <aLC7k65GpIL-2Hk5@google.com> <8670cd6065b428c891a7d008500934a57f09b99f.camel@intel.com>
 <68b0d2fb207cc_27c6d294e1@iweiny-mobl.notmuch>
Message-ID: <aLDjpe31-w6md-GV@google.com>
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold tdx_mem_page_record_premap_cnt()
 into its sole caller
From: Sean Christopherson <seanjc@google.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Vishal Annapurve <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2025, Ira Weiny wrote:
> Edgecombe, Rick P wrote:
> > On Thu, 2025-08-28 at 13:26 -0700, Sean Christopherson wrote:
> > > Me confused.=C2=A0 This is pre-boot, not the normal fault path, i.e. =
blocking other
> > > operations is not a concern.
> >=20
> > Just was my recollection of the discussion. I found it:
> > https://lore.kernel.org/lkml/Zbrj5WKVgMsUFDtb@google.com/
> >=20
> > >=20
> > > If tdh_mr_extend() is too heavy for a non-preemptible section, then t=
he current
> > > code is also broken in the sense that there are no cond_resched() cal=
ls.=C2=A0 The
> > > vast majority of TDX hosts will be using non-preemptible kernels, so =
without an
> > > explicit cond_resched(), there's no practical difference between exte=
nding the
> > > measurement under mmu_lock versus outside of mmu_lock.
> > >=20
> > > _If_ we need/want to do tdh_mr_extend() outside of mmu_lock, we can a=
nd should
> > > still do tdh_mem_page_add() under mmu_lock.
> >=20
> > I just did a quick test and we should be on the order of <1 ms per page=
 for the
> > full loop. I can try to get some more formal test data if it matters. B=
ut that
> > doesn't sound too horrible?
> >=20
> > tdh_mr_extend() outside MMU lock is tempting because it doesn't *need* =
to be
> > inside it.
>=20
> I'm probably not following this conversation, so stupid question:  It
> doesn't need to be in the lock because user space should not be setting u=
p
> memory and extending the measurement in an asynchronous way.  Is that
> correct?

No, from userspace's perspective ADD+MEASURE is fully serialized.  ADD "nee=
ds"
to be under mmu_lock to guarantee consistency between the mirror EPT and th=
e
"real" S-EPT entries.  E.g. if ADD is done after the fact, then KVM can end=
 up
with a PRESENT M-EPT entry but a corresponding S-EPT entry that is !PRESENT=
.
That causes a pile of problems because it breaks KVM's fundamental assumpti=
on
that M-EPT and S-EPT entries updated in lock-step.

TDH_MR_EXTEND doesn't have the same same consistency issue.  If it fails, t=
he
only thing that's left in a bad state is the measurement.  That's obviously=
 not
ideal either, but we can handle that by forcefully terminating the VM, with=
out
opening up KVM to edge cases that would otherwise be impossible.

> > But maybe a better reason is that we could better handle errors
> > outside the fault. (i.e. no 5 line comment about why not to return an e=
rror in
> > tdx_mem_page_add() due to code in another file).
> >=20
> > I wonder if Yan can give an analysis of any zapping races if we do that=
.
>=20
> When you say analysis, you mean detecting user space did something wrong
> and failing gracefully?  Is that correct?

More specifically, whether or not KVM can WARN without the WARN being user
triggerable.  Kernel policy is that WARNs must not be triggerable absent ke=
rnel,
hardware, or firmware bugs.  What we're trying to figure out is if there's =
a
flow that can be triggered by userspace (misbehving or not) that would trip=
 a
WARN even if KVM is operating as expected.  I'm pretty sure the answer is "=
no".

Oh, and WARNing here is desirable, because it improves the chances of detec=
ting
a fatal-to-the-VM bug, e.g. in KVM and/or in the TDX-Module.

