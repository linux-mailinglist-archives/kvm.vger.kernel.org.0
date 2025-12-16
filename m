Return-Path: <kvm+bounces-66054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 37810CC0549
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 01:19:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 223773019878
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 00:19:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6E1A21D5B0;
	Tue, 16 Dec 2025 00:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U9b96hE+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E97F35965
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 00:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765844339; cv=none; b=C66Y2OkVMN+1xXghbqyGftKeSKuCJKYhbO10WOkNWrNZhMECAI/jZ03PpeIcOUltyMmsKdZ3bfrOmDL752YTTG18vd3loEoZpAhMVP9zsRRChSHXCCj+NdhR4taodsA3qXoh/LaOBfJaiVHS94zCneRRDXNWx8fGTK/nQI4cgnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765844339; c=relaxed/simple;
	bh=xAEupN+yDQbfPOLx8WCP0Fm3k7XcdSjkfHRAm0nXpYk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lz+dSshy0hicKq5gE5fdSCiz0ONyJGVUunhlhg1kMMlz4fkxX7B7ZtQWVs2TqxvmhVKgpnIfv3Cq7bCxMXyM1FUtcrjrYTeBs7pYnGRHKUV1qNKmOGeKN/G73FOVgYw2iyxfxI8fIESCYXy3hI+5TpAMFY92aC/ntUSAixF1Qe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U9b96hE+; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29e6b269686so94684165ad.1
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 16:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765844338; x=1766449138; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x2oerIBUWdoiR/iDg/DmDggDlh+UQ2iDCVQ3m0zhhek=;
        b=U9b96hE+eWOjSxPOOnR6aDGxjUor3zSrLrh0R+3QGBn+RDVmRBacpVO7OEnVZt79TT
         ikJyZ219vnXIyQuSKquwLrkOn9fKAnCesauKEIE31ev5kEdNbMxFco6/lmWJ6u9DI83f
         6J2olCO2c/G5zhjG3djAotqXHOl4J9NhYUOZPRUe/EVhwOGNH4rbuC/9wPxiD3xDtiDg
         5Vm+h/zv1BX56z/CFfVLowMxHt6tPc9vS2TTAnmUqa/jZytIyQqft9LhYHhXmln+xa19
         AgPpLKjCCmBuIHxDx1BLD49zVc9DWE258UEKFonZ2Dfs66OfIHJlzQ8z6D+97W9e64aB
         WTlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765844338; x=1766449138;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=x2oerIBUWdoiR/iDg/DmDggDlh+UQ2iDCVQ3m0zhhek=;
        b=DLg6WX7njx+5bkFjnbUFI8nfTxecGyGGNEDJkLwhuzxL6MYYluPUhFXRg35gdw80tb
         oeqtZ7m53ynI3HnxcaxICpzuKqzNGjU4xvbVsKscT22OO8pApJuWawuvIv0qIqI0VP2y
         2WUbVria+i3F2X+H9oThXB0H5sfWhAf8pKOYSr7UOWCnjj06uUwpToceRj2N8wsLVFXT
         bDG65LEHCdCUinDv+Fm42lm1QMGOfEuSSblCJZYEinCzRbbAUhUl0VMZPcTr6rfXmAFm
         iT8a/me0jTvV3sxjMMuyzSIqkIsVxLSRush7q4Bi1sfjUlBsF0ALTwrwessoawMHDsMH
         /cZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVH4L3rv8hwgN2YeGBPvtdkRYPGeUBFNBlcF3B6cFzvnqepofKevIofIH3jh5EPIwXUaMk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQ1bIiLhQGDsXivDA05ubmGux2hOiknvR+kpaV2a6K9HseRyPi
	hrb6f5CR5uo8MV5thNVtdNryJ9iPTk5YTPAYIbcN2yx54lFZrh00o+ZRfqv7TcsJ054CjfVxaNK
	M6/9FOg==
X-Google-Smtp-Source: AGHT+IEWAD5o+jOHDqlEeD5qpWYrl9uWEbLiDfCND9UBUiVYMl3ijPuTAanLZR/4J50fvr/IM5bDgbUTjCY=
X-Received: from ploo12.prod.google.com ([2002:a17:902:e00c:b0:29f:b21:b1c3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cecf:b0:2a0:8df5:2f6f
 with SMTP id d9443c01a7336-2a08df53433mr95353555ad.15.1765844337858; Mon, 15
 Dec 2025 16:18:57 -0800 (PST)
Date: Mon, 15 Dec 2025 16:18:56 -0800
In-Reply-To: <CAGtprH95s5wL1=rSSpG7Cmj5HhJOftwJY7CP27WE-qmq7hr+XA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251215153411.3613928-1-michael.roth@amd.com>
 <20251215153411.3613928-2-michael.roth@amd.com> <CAGtprH95s5wL1=rSSpG7Cmj5HhJOftwJY7CP27WE-qmq7hr+XA@mail.gmail.com>
Message-ID: <aUClcGHzJK7PyutH@google.com>
Subject: Re: [PATCH v2 1/5] KVM: guest_memfd: Remove partial hugepage handling
 from kvm_gmem_populate()
From: Sean Christopherson <seanjc@google.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, 
	pbonzini@redhat.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	liam.merwick@oracle.com, david@redhat.com, ackerleytng@google.com, 
	aik@amd.com, ira.weiny@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 15, 2025, Vishal Annapurve wrote:
> On Mon, Dec 15, 2025 at 7:35=E2=80=AFAM Michael Roth <michael.roth@amd.co=
m> wrote:
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index fdaea3422c30..9dafa44838fe 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -151,6 +151,15 @@ static struct folio *kvm_gmem_get_folio(struct ino=
de *inode, pgoff_t index)
> >                                          mapping_gfp_mask(inode->i_mapp=
ing), policy);
> >         mpol_cond_put(policy);
> >
> > +       /*
> > +        * External interfaces like kvm_gmem_get_pfn() support dealing
> > +        * with hugepages to a degree, but internally, guest_memfd curr=
ently
> > +        * assumes that all folios are order-0 and handling would need
> > +        * to be updated for anything otherwise (e.g. page-clearing
> > +        * operations).
> > +        */
> > +       WARN_ON_ONCE(folio_order(folio));
>=20
> I am not sure if this WARN_ON adds any value. i.e. The current code
> can't hit it.

The current code _shouldn't_ hit it.

> This note concerns future efforts to add hugepage support and could be
> omitted altogether from the current implementation.

IMO, this is a good use of WARN_ON_ONCE().  It documents guest_memfd's assu=
mptions
and/or limitations, which is extremely helpful to readers/contributors that=
 aren't
familiar with guest_memfd and/or its history of hugepage support.

