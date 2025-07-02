Return-Path: <kvm+bounces-51293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 46ECBAF583C
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 15:13:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A13581C436D8
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 13:13:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DE68277013;
	Wed,  2 Jul 2025 13:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GvhrY1t7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E5126658A
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 13:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751461994; cv=none; b=fkIiLe7pWyQnp+1jXqBXCfcoCWBwbEXdVOXnYAbTgb8ARx8byoedvBYFKWkQM/9pNkgTxY/AwU+ZS0w2eZeE8pI540zr3tFFzzZcFfFKo7k2dRr3ushDyCs6FN12BHXI9ZFGUFNAdKx8D2TXlZhRXSS/h2Lc5tMZFx0ukT0OF1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751461994; c=relaxed/simple;
	bh=dAOlhPBz2wPebLfmNnzHJOLRL03SgOBd++Mx+Znx8bM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C/sSDMz3ugBs+WRyiSoXl80g2uMui4juovqJHJkr4gs49qvFMCxDcL7OPbEPRF1WtJcB9IrgxqhicaWWmNpQO2Us/hxPZ/v4fbgddydOhEcnwLUORifPYVmHTEJTzmcy3qJaBFvhIssNXEsEwm5rkqD9rK6ucvPiJnS3UJJsXG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GvhrY1t7; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-237f270513bso368315ad.1
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 06:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751461992; x=1752066792; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dAOlhPBz2wPebLfmNnzHJOLRL03SgOBd++Mx+Znx8bM=;
        b=GvhrY1t7pThXp9CFIEGDuKshpVUek1wzBsiGqii1XC+dlPyPpQ5G/aOIt1TbKijJ2Q
         VwbtO0F8U3zDqPTcWQaYvDPcreVfHMCx8JcnS8RzpuExeEHkR/ldvqal5MEQQDo55oZs
         lsLsO767BNe2JT59YmCL18woySQGzowrPnhO4W7NA1mpx31FjnHx/jPgWTRdvqQmTg/y
         iSKuHj6cd2pq4X3ID/d40cjlDliQKLVwCxWrDKrbftPE7X+YnIIv4csdPFCIR7Jy+d3s
         OVmTh/bwHH8GZf9dTs95UOdpm0+1X8akHVbtgmBcSvx3rsZtbv6ss7aT5GMfWs7oS6jC
         jj/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751461992; x=1752066792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dAOlhPBz2wPebLfmNnzHJOLRL03SgOBd++Mx+Znx8bM=;
        b=o0da+aMWJCfNdIAUVrIHN8c6KyH02VHXbKCsTuvbDO6rOpxHHAZA3dCrvRimSxFPrW
         TDjEaW2ppICIsCTiRMiRBcIpAPLOJGzs3WCMOv3GSSPSc+mSdo2huFIbmdcH5SzstLEF
         GVhHcUMyHLrdPpiyfFCytZgC3uoP0aUHaR6gbDmFcRnGA5EnAK2piMYAYnwANqhXr/XJ
         /51U5cs9Hnl1MELd9OqNlGFA86PTH1R5H4DI/G3SlmQaOum2VuHJz1ajkqFoQcjnrmiW
         b7cinIgNm0Rof8AA0GAnp6i6disWTW2EhVobKshzoA3vfEfa6/xQfV+qVqCKFCctjZ/o
         QnJA==
X-Forwarded-Encrypted: i=1; AJvYcCVZzX1kYiy+viwmRAW5zn9mljDH7m9XlmKv3w3Ly2/3KIA89UBMf1lCRXqv7dexNGf+Ic0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCO0zBFnfck9E6VNC3M9Eh9htgesc9y+oW0lC/HltJUZYKLE8w
	NQqxDH9yGu/9ocyVT9PqJf96yBie1Ad/FXFw+HERiaS0rpSfUa/Uov3ZLsG+x7mzBdolTILxn4+
	JuLRyDPd1Ro1Z/6lV2w+wZMHEwFINiORZsEoMaKGw
X-Gm-Gg: ASbGncvD+r7ceZ+tZwcFX0ujikWbN/BKwvMXJTS8ijae6K2ufnkKjmyM4K72iQNSM3J
	TzG2VmpkNcmV9LlLm5NPdSuzsJULqZPWs94PBzZmIYBqMTTEHaqesPVtbphPxiG2qhsd/ISu09p
	bchmOHsJmeEtxaNKL1ci/OHiO9ztYYPHd0oX1umM15+9jXvsrlxfzCBRUS6/HMQRsyRebLH0r2Q
	KWQ
X-Google-Smtp-Source: AGHT+IGiNo0qmiuCOrbiLb3P3KkQpm+pgszYXHUjNQwhUsop38fqkh0XgzhxCVLlVitPDgUOFept+dx2nbky8QWC7fI=
X-Received: by 2002:a17:902:e74c:b0:231:ddc9:7b82 with SMTP id
 d9443c01a7336-23c5ffbdd1bmr5968075ad.13.1751461991553; Wed, 02 Jul 2025
 06:13:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com> <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com> <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
 <aGOr90RZDLEJhieE@yzhao56-desk.sh.intel.com> <CAGtprH86-HkfnTMmwdPsKgXxjTomvMWWAeCuZKSieb5o6MvRPQ@mail.gmail.com>
 <aGTzqyIYE4K+cR0M@yzhao56-desk.sh.intel.com>
In-Reply-To: <aGTzqyIYE4K+cR0M@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 2 Jul 2025 06:12:59 -0700
X-Gm-Features: Ac12FXwol7XJ4YZIuCvFuAN3sjH-MLaRmSIA8AZV3-FI8kv1fXw9cYuf0FKXr0I
Message-ID: <CAGtprH9zqKwhTuWV4WtGrvrbQ-0FmM1DA1PkE-LO59UKP_wAig@mail.gmail.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>, 
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"Peng, Chao P" <chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	"Li, Zhiquan1" <zhiquan1.li@intel.com>, "jroedel@suse.de" <jroedel@suse.de>, 
	"Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 2, 2025 at 1:56=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
>
> On Tue, Jul 01, 2025 at 06:32:38AM -0700, Vishal Annapurve wrote:
> > On Tue, Jul 1, 2025 at 2:38=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> =
wrote:
> > >
> > > On Tue, Jul 01, 2025 at 01:55:43AM +0800, Edgecombe, Rick P wrote:
> > > > So for this we can do something similar. Have the arch/x86 side of =
TDX grow a
> > > > new tdx_buggy_shutdown(). Have it do an all-cpu IPI to kick CPUs ou=
t of
> > > > SEAMMODE, wbivnd, and set a "no more seamcalls" bool. Then any SEAM=
CALLs after
> > > > that will return a TDX_BUGGY_SHUTDOWN error, or similar. All TDs in=
 the system
> > > > die. Zap/cleanup paths return success in the buggy shutdown case.
> > > All TDs in the system die could be too severe for unmap errors due to=
 KVM bugs.
> >
> > At this point, I don't see a way to quantify how bad a KVM bug can get
> > unless you have explicit ideas about the severity. We should work on
> > minimizing KVM side bugs too and assuming it would be a rare
> > occurrence I think it's ok to take this intrusive measure.
> >
> > >
> > > > Does it fit? Or, can you guys argue that the failures here are actu=
ally non-
> > > > special cases that are worth more complex recovery? I remember we t=
alked about
> > > > IOMMU patterns that are similar, but it seems like the remaining ca=
ses under
> > > > discussion are about TDX bugs.
> > > I didn't mention TDX connect previously to avoid introducing unnecess=
ary
> > > complexity.
> > >
> > > For TDX connect, S-EPT is used for private mappings in IOMMU. Unmap c=
ould
> > > therefore fail due to pages being pinned for DMA.
> >
> > We are discussing this scenario already[1], where the host will not
> > pin the pages used by secure DMA for the same reasons why we can't
> > have KVM pin the guest_memfd pages mapped in SEPT. Is there some other
> > kind of pinning you are referring to?
> >
> > If there is an ordering in which pages should be unmapped e.g. first
> > in secure IOMMU and then KVM SEPT, then we can ensure the right
> > ordering between invalidation callbacks from guest_memfd.
> It's pinning from a different perspective.
> Please check
> https://lore.kernel.org/all/aGTvTbPHuXbvj59t@yzhao56-desk.sh.intel.com.
>
> > [1] https://lore.kernel.org/lkml/CAGtprH_qh8sEY3s-JucW3n1Wvoq7jdVZDDokv=
G5HzPf0HV2=3Dpg@mail.gmail.com/#t
> >
> > >
> > > So, my thinking was that if that happens, KVM could set a special fla=
g to folios
> > > pinned for private DMA.
> > >
> > > Then guest_memfd could check the special flag before allowing private=
-to-shared
> > > conversion, or punch hole.
> > > guest_memfd could check this special flag and choose to poison or lea=
k the
> > > folio.
> > >
> > > Otherwise, if we choose tdx_buggy_shutdown() to "do an all-cpu IPI to=
 kick CPUs
> > > out of SEAMMODE, wbivnd, and set a "no more seamcalls" bool", DMAs ma=
y still
> > > have access to the private pages mapped in S-EPT.
> >
> > guest_memfd will have to ensure that pages are unmapped from secure
> > IOMMU pagetables before allowing them to be used by the host.
> >
> > If secure IOMMU pagetables unmapping fails, I would assume it fails in
> > the similar category of rare "KVM/TDX module/IOMMUFD" bug and I think
> > it makes sense to do the same tdx_buggy_shutdown() with such failures
> > as well.
> tdx_buggy_shutdown() should then
> do an all-cpu IPI to kick CPU out of SEAMMODE, wbivnd, and set a "no more
> seamcalls" bool" and informing IOMMUF/VFIO to stop devices.
>
> BTW, is the "no more seamcall" set by KVM at the per-VM level?

No more seamcall here would be the host level.

> If it's per-VM, other TDs could still entering SEAMMODE. So, potential
> corruption is still possible.
> Besides, with "no more seamcalls" upon unmapping failure of a GFN, how to
> reclaim other pages which might succeed otherwise?

I would think that with no more seamcall on the host, KVM TDX logic
could safely reclaim all the pages using the WBINVD method.

>
> This approach seems very complex.

With "informing IOMMUF/VFIO to stop devices" specially only for secure
devices, I agree this could become hard to orchestrate unless Dan
Williams or somebody else has better insights here.

