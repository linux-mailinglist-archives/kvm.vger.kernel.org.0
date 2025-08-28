Return-Path: <kvm+bounces-56193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 85B7AB3AD1E
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 23:57:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4ED11C83160
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 21:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F2512C08BD;
	Thu, 28 Aug 2025 21:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AsZoGYAn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E320B2676E9
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 21:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756418263; cv=none; b=UtoBJ/eZpLOJxd3/i1znayUWyGIDLY6FWDw6wYWhAC12NCUKglHaxQsYbUDJZ/iKRr+Gk2OxBHaV0MYlpf1dC23Yo0HLXO2sDpi6T8mwllZbij8YXSEXBTN8GMY7VsU9FjaNO3VqKaMZUmoR7UNrdq4f0FSBfO8rbxgZqCJ8m6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756418263; c=relaxed/simple;
	bh=KuU7MFe5Hw5QT5mDGOLPcE1wLuXANA35URR6cOm+gn0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j8Va60x0QBq1VpqKICtUitZBiLz91B8t/6pVJq9sO/UHx5hN+/Gdz9FHbRhFa6A/QVWxVaa7EiDFvcpwYwvtTdrtN7i4wPUsG+S1V+lhb+6FZXxrOc58f+6nXSlih5oy+4FrBQWstabTkRK8/U3soPVV8Ihigmr9ajBFpc/LHaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AsZoGYAn; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-771ed4a81beso1182352b3a.3
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 14:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756418261; x=1757023061; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pA5ZuDq4s4O/Y5U45tkQ/giHeKUQA670rdBBu3hbsJ8=;
        b=AsZoGYAny6y1J1Ig3KddAw7gl7UkSlsUgM6huN0gHHSand+jHzYok9CO1cnhP9Nu2P
         G+H26MK4ZHnIHUhXmlbLxl4GdVTkyYLdStjsnMvNjuM+q1C6cqhiJaGBcURiQebVQ47n
         mFVVsJ5NABA72Xd29SuBllV3ftOD5B03kLLEL5VSkR3GRnZtzKkkM2pu9MtRzIcypZK1
         qRhTNFw9628Op2C3wdBdKD07+J9tFm0WftfXza+fD0BOtUQLgKyOMhFNFA7G0UxMD7gU
         Ckzvy8hKiKHxcDiVABK9ZsCoWOzp7QXNfShcxaTNRIAwYg/OTLfny0WiFTA8UQxlhNAq
         MQ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756418261; x=1757023061;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pA5ZuDq4s4O/Y5U45tkQ/giHeKUQA670rdBBu3hbsJ8=;
        b=PpoOCwtFgcGGMyimEa+bQy9AB5iUqHIXTz5gnyLEpKaVdlEcFngQX3zEq9S6wLKeFr
         QJWJ9Or5zNRqLzFtxxCALvccIq8do5QwfzEtqfuHpoRO3JIDbl6x2nBDogqKLI1dDdRf
         IShufUW69l4yEAg3TQeK6SoTkSwUug0+SWNHdX6dugYhfLXofCei+6Qt/UJaetfsS+XZ
         Yzsg6foLFnMwS23BlXOB49r1nC092nM2PPYxzGiVon38+6vYr+li5a5pWijyOmntR9Lu
         prLsr1UkXyWLtEhL2IFAszVMCGEIatv1naFSTM45i5AzBtIEMDoUIoIqUv8atd1PcqDh
         zO6w==
X-Gm-Message-State: AOJu0Yyo4oWg0klt6L6jofg+WtRlRflCdEUaRDwDvKvBfOvJoiDY+O3E
	/1l/4YCWOz+dF3OmrEf9NjugrWMgtn/nFvGrG0+wHEs92MAQBzoh9IOFJUEP4078DWPvKmVvDwP
	UMCf2qQ==
X-Google-Smtp-Source: AGHT+IGR4HgnkA6BfHSXpSOoKMmxI4GjoYygF5OD856UeGSX0+bSquBGLl8NC2kp/VPYi+fp1g9EGOg3trU=
X-Received: from pfwz26.prod.google.com ([2002:a05:6a00:1d9a:b0:772:13b2:f328])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:99d:b0:771:58e:5b10
 with SMTP id d2e1a72fcca58-771058e5ff3mr21388814b3a.8.1756418261101; Thu, 28
 Aug 2025 14:57:41 -0700 (PDT)
Date: Thu, 28 Aug 2025 14:57:39 -0700
In-Reply-To: <8670cd6065b428c891a7d008500934a57f09b99f.camel@intel.com>
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
Message-ID: <aLDQ09FP0uX3eJvC@google.com>
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold tdx_mem_page_record_premap_cnt()
 into its sole caller
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Vishal Annapurve <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2025, Rick P Edgecombe wrote:
> On Thu, 2025-08-28 at 13:26 -0700, Sean Christopherson wrote:
> > Me confused.=C2=A0 This is pre-boot, not the normal fault path, i.e. bl=
ocking other
> > operations is not a concern.
>=20
> Just was my recollection of the discussion. I found it:
> https://lore.kernel.org/lkml/Zbrj5WKVgMsUFDtb@google.com/

Ugh, another case where an honest question gets interpreted as "do it this =
way". :-(

> > If tdh_mr_extend() is too heavy for a non-preemptible section, then the=
 current
> > code is also broken in the sense that there are no cond_resched() calls=
.=C2=A0 The
> > vast majority of TDX hosts will be using non-preemptible kernels, so wi=
thout an
> > explicit cond_resched(), there's no practical difference between extend=
ing the
> > measurement under mmu_lock versus outside of mmu_lock.
> >=20
> > _If_ we need/want to do tdh_mr_extend() outside of mmu_lock, we can and=
 should
> > still do tdh_mem_page_add() under mmu_lock.
>=20
> I just did a quick test and we should be on the order of <1 ms per page f=
or the
> full loop. I can try to get some more formal test data if it matters. But=
 that
> doesn't sound too horrible?

1ms is totally reasonable.  I wouldn't bother with any more testing.

> tdh_mr_extend() outside MMU lock is tempting because it doesn't *need* to=
 be
> inside it.

Agreed, and it would eliminate the need for a "flags" argument.  But keepin=
g it
in the mmu_lock critical section means KVM can WARN on failures.  If it's m=
oved
out, then zapping S-EPT entries could induce failure, and I don't think it'=
s
worth going through the effort to ensure it's impossible to trigger S-EPT r=
emoval.

Note, temoving S-EPT entries during initialization of the image isn't somet=
hing
I want to official support, rather it's an endless stream of whack-a-mole d=
ue to
obsurce edge cases

Hmm, actually, maybe I take that back.  slots_lock prevents memslot updates=
,
filemap_invalidate_lock() prevents guest_memfd updates, and mmu_notifier ev=
ents
shouldn't ever hit S-EPT.  I was worried about kvm_zap_gfn_range(), but the=
 call
from sev.c is obviously mutually exclusive, TDX disallows KVM_X86_QUIRK_IGN=
ORE_GUEST_PAT
so same goes for kvm_noncoherent_dma_assignment_start_or_stop, and while I'=
m 99%
certain there's a way to trip __kvm_set_or_clear_apicv_inhibit(), the APIC =
page
has its own non-guest_memfd memslot and so can't be used for the initial im=
age,
which means that too is mutually exclusive.

So yeah, let's give it a shot.  Worst case scenario we're wrong and TDH_MR_=
EXTEND
errors can be triggered by userspace.

> But maybe a better reason is that we could better handle errors
> outside the fault. (i.e. no 5 line comment about why not to return an err=
or in
> tdx_mem_page_add() due to code in another file).
>=20
> I wonder if Yan can give an analysis of any zapping races if we do that.

As above, I think we're good?

