Return-Path: <kvm+bounces-52927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 548A5B0AA7D
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 21:00:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08F8BAA1AEC
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 18:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80AAC2E8893;
	Fri, 18 Jul 2025 18:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AhLtfNvx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D6218E20
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 18:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752865193; cv=none; b=oytxNB3YM4GPT2uwTz9ty18hB7GJePajBo8QT52UKwZhGMIY1hP69X9QehJgohnWBoS/h7+HxszV9emGZg/AsE1aJIYxOYlpA5MwjltEl0AI8ePr3KYqnhWPa3lZUGFIx/MbmSPeQ1sZ6/5RLGa2BYpL1k6/M8KvDgqC63Z8HPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752865193; c=relaxed/simple;
	bh=taE+/ctRGOPew3+5bSYl2Hv+oOd5K+FCRxlMfgVgMuY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S/KlWS3PhoUOPoj2VO52GLcR2m1ZH2B++5UxfhAV4royQSx2MOUFYZFi2YtqPfzRksL0BhdB9vZh514sJ4pzRCMJK2SWe+336K2l+v4xITkyKXyJjX6JbAOgZlGBb2hZd799WzsnS5+WS68/9AZI9l+ZRyfN5iaJbIfpSuJVg04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AhLtfNvx; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-235e389599fso32925ad.0
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 11:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752865191; x=1753469991; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KrROO4+eR6/+Z0KaNlJ044e8PDoospst2QAllWf9w8w=;
        b=AhLtfNvxtK7cG3XM6ELKoBABQrTllPNpcu94ubGXIu0to9ZZffmzQX8BARS6F0Pu2L
         5kzg7/oqbbIl4TdCO4vaU2K2DzQrGU3VC6FxP9YkgT54z8Ptto+d4XbTmBYp5tjVnwvP
         HPkNHnzajZ8+M9f0cbWjEfoTQrVFQGKJb136fqRVg7f982sHAgTUF+p/t0M7nbRQMKcD
         el25i2iHwSd1VRWCNMOmDmZD7M91ryx4IgCHVO3dlSXm9SrUorqp8jnDzacawm5GZVR6
         v3615r6CJGuoO/kS+3EQFGtmoauPcwI0Csmss+GVG4EwYLQLviLWsafeLpLwgHzzbKbS
         6zxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752865191; x=1753469991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KrROO4+eR6/+Z0KaNlJ044e8PDoospst2QAllWf9w8w=;
        b=fMpzmjfsG1RU3DA7/EoofJwJ+D6gDnHkRSoGRVzTKtmAcr1gkgewBtX0V0iFAJoc4l
         1Q+I5MDGevApFSIfdbWSm+zC1wuklfHqVcEMTE+lTR4WzJPXaS7vT8mAyUn/+soivGYL
         DHx1tDEPLxM0v+SGYu0C01VwRl2ZGWYOR8ZjsnN/6F+4pbwt7xQ1nBT36PcFix9oMVfp
         USLEeJPs3bFz2CKl1Yq3pqHwiIQksKyqzcJ5PyXJJ7nD8CM+C25ZIQSw2A0WQMwicXWI
         RhmLBdhNy+795NfExWvp6goIX7hZ+YlDQyvyhVZYIjI61CoDusSqnqI1U86AGeQX3qJq
         3L/w==
X-Forwarded-Encrypted: i=1; AJvYcCV5OOyND3DXS/v7bPHw/zuTc91nKrg2Arnv641Wh0OAxSShwFMJg1ubA5YDpXr2X3zlvmY=@vger.kernel.org
X-Gm-Message-State: AOJu0YybW4aEoLrqhhbKlF1A3jmwSrCRmADC+tLMqDdBFcmx4F74pP4A
	WaSnH4nTxVPO+3w4RnM+urQvhqP8UKvaJVKWAOEdNKWGk3bdLutczVXdYY57A309QGjhq3/K6Oh
	l0j4cB41hKO1aUdNvdXFkqE2/k/cVPM0T762hI5Hf
X-Gm-Gg: ASbGncsotKvy4HOVKyrO/TNAoQDwGmdYq4B9xFeZ9VM5uS+k25sXodtWMqB1TZN4xBe
	/0OxnOMxd9JKYPyhouhcjnrFSxKRs01TAo7hW8VSKiMMyBQx59/93CoX+1Kv3gmHqadusaCbUiT
	HsLm8h/OMoNEHrls+pKzpR4+wYcmo9+yTcbCFnK7fMo5OLbbPfVAGLlcbo8OjGbbM2aGFqoBF3b
	USQJeo1JcmY71Zb00A9E4nbKtxlG3JRQuPpVToN
X-Google-Smtp-Source: AGHT+IFpf5quYC1vdY93qwtkt519zsw+ML1HvqAXK+aPQMdz4ELJvbogdmOIVNoHWEPpznqkON8Fny73GNCipKvP1Ig=
X-Received: by 2002:a17:902:f78c:b0:235:e1d6:5339 with SMTP id
 d9443c01a7336-23f71db7bbdmr323975ad.26.1752865191118; Fri, 18 Jul 2025
 11:59:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709232103.zwmufocd3l7sqk7y@amd.com> <aG_pLUlHdYIZ2luh@google.com>
 <aHCUyKJ4I4BQnfFP@yzhao56-desk> <20250711151719.goee7eqti4xyhsqr@amd.com>
 <aHEwT4X0RcfZzHlt@google.com> <aHSgdEJpY/JF+a1f@yzhao56-desk>
 <aHUmcxuh0a6WfiVr@google.com> <aHWqkodwIDZZOtX8@yzhao56-desk>
 <aHoQa4dBSi877f1a@yzhao56-desk.sh.intel.com> <CAGtprH9kwV1RCu9j6LqToa5M97_aidGN2Lc2XveQdeR799SK6A@mail.gmail.com>
 <687a959ad915e_3c99a32942b@iweiny-mobl.notmuch>
In-Reply-To: <687a959ad915e_3c99a32942b@iweiny-mobl.notmuch>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 18 Jul 2025 11:59:39 -0700
X-Gm-Features: Ac12FXxYJMxLN5HPBgnNv0VYOyT__JVaniVIs9JK603HrHK22vQiSEL3DYC88P4
Message-ID: <CAGtprH-DprCYLCYK3T7fQ23xAkTb9HdMbbp3TJ=-QgenNz8=mg@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from kvm_gmem_populate()
To: Ira Weiny <ira.weiny@intel.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, Sean Christopherson <seanjc@google.com>, 
	Michael Roth <michael.roth@amd.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	adrian.hunter@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@intel.com, binbin.wu@linux.intel.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, david@redhat.com, ackerleytng@google.com, 
	tabba@google.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2025 at 11:41=E2=80=AFAM Ira Weiny <ira.weiny@intel.com> wr=
ote:
>
> Vishal Annapurve wrote:
> > On Fri, Jul 18, 2025 at 2:15=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com>=
 wrote:
> > >
> > > On Tue, Jul 15, 2025 at 09:10:42AM +0800, Yan Zhao wrote:
> > > > On Mon, Jul 14, 2025 at 08:46:59AM -0700, Sean Christopherson wrote=
:
> > > > > > >         folio =3D __kvm_gmem_get_pfn(file, slot, index, &pfn,=
 &is_prepared, &max_order);
> > > > > > If max_order > 0 is returned, the next invocation of __kvm_gmem=
_populate() for
> > > > > > GFN+1 will return is_prepared =3D=3D true.
> > > > >
> > > > > I don't see any reason to try and make the current code truly wor=
k with hugepages.
> > > > > Unless I've misundertood where we stand, the correctness of hugep=
age support is
> > > > Hmm. I thought your stand was to address the AB-BA lock issue which=
 will be
> > > > introduced by huge pages, so you moved the get_user_pages() from ve=
ndor code to
> > > > the common code in guest_memfd :)
> > > >
> > > > > going to depend heavily on the implementation for preparedness.  =
I.e. trying to
> > > > > make this all work with per-folio granulartiy just isn't possible=
, no?
> > > > Ah. I understand now. You mean the right implementation of __kvm_gm=
em_get_pfn()
> > > > should return is_prepared at 4KB granularity rather than per-folio =
granularity.
> > > >
> > > > So, huge pages still has dependency on the implementation for prepa=
redness.
> > > Looks with [3], is_prepared will not be checked in kvm_gmem_populate(=
).
> > >
> > > > Will you post code [1][2] to fix non-hugepages first? Or can I pull=
 them to use
> > > > as prerequisites for TDX huge page v2?
> > > So, maybe I can use [1][2][3] as the base.
> > >
> > > > [1] https://lore.kernel.org/all/aG_pLUlHdYIZ2luh@google.com/
> > > > [2] https://lore.kernel.org/all/aHEwT4X0RcfZzHlt@google.com/
> >
> > IMO, unless there is any objection to [1], it's un-necessary to
> > maintain kvm_gmem_populate for any arch (even for SNP). All the
> > initial memory population logic needs is the stable pfn for a given
> > gfn, which ideally should be available using the standard mechanisms
> > such as EPT/NPT page table walk within a read KVM mmu lock (This patch
> > already demonstrates it to be working).
> >
> > It will be hard to clean-up this logic once we have all the
> > architectures using this path.
>
> Did you mean to say 'not hard'?

Let me rephrase my sentence:
It will be harder to remove kvm_gmem_populate if we punt it to the future.

