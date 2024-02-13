Return-Path: <kvm+bounces-8589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44E1A8527D0
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 04:40:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B627B223DA
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 03:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA0C1C8CE;
	Tue, 13 Feb 2024 03:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iqHm2blK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0A4BE4E
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 03:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707795593; cv=none; b=b3mpDSauglFUgPvMBpEmKpGUYbbRGuGKEphpoTv1TACIEvdpzXq6E447GvtzfzyXubz37YbBmm7JCCQRdi3ewBj6C3uPIbgn/0Zqf1P7WjcsABK91EnRouhpqeDeOIS/RMcZGx4Ey0w2rZjve7xGmrAXRlxnlrNz5ExjW8FVu/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707795593; c=relaxed/simple;
	bh=5+qYZYJemzYwmTCaksNFbQuIKvJDzxrLlD2bZz/R0H8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cVDxj2mAm0EptzbKumj1iFAPWV4My0WsU34lx7RKbhGjbuGxmc8NJPBTNjQ8cii4obmLGBUeZlCxbEdyZdssB+iccPPpV/jvdr5JBimWBllprb0yalYAqYJ2W68lI5ZFIBdQhNV0XzUv8p5iNL3hif7qTQg97me7CDFTxyUPRMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iqHm2blK; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e0a461e125so1934996b3a.3
        for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 19:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707795591; x=1708400391; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RA6zNvnSFSM19FK25XmCjdxkJlEdzHYrL47jTvjMoZg=;
        b=iqHm2blKCbxI+zmJl7oaUHywzfPRoyciVuywnPzNHJ7b60FonHTeDx+NQ3x94SdoxO
         S0MhGe9SPTYqfiIlF1uK0eh/m3pK0yT+GVp3GxaU9S3opnPCxxwIM43B9kf3eXnccFOG
         ZXi3AmiH2OQRhw4nEaD2WoxrUBE0Pq2ULPrcaUz/15aR2JrDVmwLl9j9GGIILHiRCbv1
         Rp68CqKu5VLa15wnYcqAqjxm1fwjYFmFqT30WnKUz23spVWuYclFM73jwyGA9O/b+uy3
         v/kUKTz4SQrxVOmPZ14pehFFp37ajFEA//nXtlePAsN/vxUmjVfw2h417pyvczIO1W5F
         CvzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707795591; x=1708400391;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RA6zNvnSFSM19FK25XmCjdxkJlEdzHYrL47jTvjMoZg=;
        b=QV/FMmsMHbD4cB4RAmmVmLDja7F9pSpISlFTFLgTyWDynRsNn9mcbh8D2wQkUGUDQ5
         XX8UqCQ3Ar3npKC3m3os/XifQjdGSx7hzY36K2s11E03ATxZ0dEboeC/kSIrMWRp9wM+
         /qpdL6SUUlsBZeoyFv6SBIcqWz393qNrXh2PW8fMES6HDuE6WGepl5Cn0OaodSSV1rks
         KEkRcxuuvJ0G73vFeTcj4DWrmx4JRgTQ5nEpzfMDKLmJcLl3JiNWALzUXxKIMTM+zGXV
         lHmooQLM8OEnJiqOnTEGEVTOAIa1KFm4hknmO6WoSgu5uZ1ZxXBRqLbtckULSoQVW/Xh
         xD5w==
X-Forwarded-Encrypted: i=1; AJvYcCWKUaHJCqzlVf0oOfofGWRTf3GeoMCyjU8u0YP2kgFu30BAFyEDbNCaj5aUgtCDeWzuhIo1BJWlVAs7Cw3qGxTDYT/8
X-Gm-Message-State: AOJu0YxwDpL/K+V8OghnVUEhGCdbs6U5Zohks8/srgyF7TT0M4grG8bL
	7/v5WK4DWUsI3Oumh8xb2Ypr8KiiHJayQbxSTniXqKJ5qnS/K6NBki/4/4/1psQi7vYdNql8jsA
	XMA==
X-Google-Smtp-Source: AGHT+IEVp/50JegG3InAOxeb5TGvnesSNFGJiZW76v1yp1CrU8i9BBgmf4sz3sT9bQH82+Mrt5/Bh9zaKk0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d2a:b0:6e0:e2f8:cf40 with SMTP id
 fa42-20020a056a002d2a00b006e0e2f8cf40mr175477pfb.0.1707795591087; Mon, 12 Feb
 2024 19:39:51 -0800 (PST)
Date: Mon, 12 Feb 2024 19:39:49 -0800
In-Reply-To: <ZcGn0t3l8OCL5mv6@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <CAD=HUj5733eL9momi=V53njm85BQv_QkVrX92xReiq0_9JhqxQ@mail.gmail.com>
 <ZUEPn_nIoE-gLspp@google.com> <CAD=HUj5g9BoziHT5SbbZ1oFKv75UuXoo32x8DC3TYgLGZ6G_Bw@mail.gmail.com>
 <ZYJFPoFYkp4xajRO@google.com> <ZcGn0t3l8OCL5mv6@google.com>
Message-ID: <ZcrkhTn1Da5-vND2@google.com>
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 05, 2024, Sean Christopherson wrote:
> On Tue, Dec 19, 2023, Sean Christopherson wrote:
> > On Tue, Dec 12, 2023, David Stevens wrote:
> > > On Tue, Oct 31, 2023 at 11:30=E2=80=AFPM Sean Christopherson <seanjc@=
google.com> wrote:
> > > >
> > > > On Tue, Oct 31, 2023, David Stevens wrote:
> > > > > Sean, have you been waiting for a new patch series with responses=
 to
> > > > > Maxim's comments? I'm not really familiar with kernel contributio=
n
> > > > > etiquette, but I was hoping to get your feedback before spending =
the
> > > > > time to put together another patch series.
> > > >
> > > > No, I'm working my way back toward it.  The guest_memfd series took=
 precedence
> > > > over everything that I wasn't confident would land in 6.7, i.e. lar=
ger series
> > > > effectively got put on the back burner.  Sorry :-(
> > >=20
> > > Is this series something that may be able to make it into 6.8 or 6.9?
> >=20
> > 6.8 isn't realistic.  Between LPC, vacation, and non-upstream stuff, I'=
ve done
> > frustratingly little code review since early November.  Sorry :-(
> >=20
> > I haven't paged this series back into memory, so take this with a grain=
 of salt,
> > but IIRC there was nothing that would block this from landing in 6.9.  =
Timing will
> > likely be tight though, especially for getting testing on all architect=
ures.
>=20
> I did a quick-ish pass today.  If you can hold off on v10 until later thi=
s week,
> I'll try to take a more in-depth look by EOD Thursday.

So I took a "deeper" look, but honestly it wasn't really any more in-depth =
than
the previous look.  I think I was somewhat surprised at the relatively smal=
l amount
of churn this ended up requiring.

Anywho, no major complaints.  This might be fodder for 6.9?  Maybe.  It'll =
be
tight.  At the very least though, I expect to shove v10 in a branch and sta=
rt
beating on it in anticipation of landing it no later than 6.10.

One question though: what happened to the !FOLL_GET logic in kvm_follow_ref=
counted_pfn()?

In a previous version, I suggested:

  static kvm_pfn_t kvm_follow_refcounted_pfn(struct kvm_follow_pfn *foll,
                                             struct page *page)
  {
       kvm_pfn_t pfn =3D page_to_pfn(page);

       foll->is_refcounted_page =3D true;

       /*
        * FIXME: Ideally, KVM wouldn't pass FOLL_GET to gup() when the call=
er
        * doesn't want to grab a reference, but gup() doesn't support getti=
ng
        * just the pfn, i.e. FOLL_GET is effectively mandatory.  If that ev=
er
        * changes, drop this and simply don't pass FOLL_GET to gup().
        */
       if (!(foll->flags & FOLL_GET))
               put_page(page);

       return pfn;
  }

but in v9 it's simply:

  static kvm_pfn_t kvm_follow_refcounted_pfn(struct kvm_follow_pfn *foll,
					     struct page *page)
  {
	kvm_pfn_t pfn =3D page_to_pfn(page);

	foll->is_refcounted_page =3D true;
	return pfn;
  }

And instead the x86 page fault handlers manually drop the reference.  Why i=
s that?

