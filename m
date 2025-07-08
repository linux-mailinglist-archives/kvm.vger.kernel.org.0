Return-Path: <kvm+bounces-51787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B05EFAFCF3B
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 17:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F503189FCEF
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 15:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 707322DAFCE;
	Tue,  8 Jul 2025 15:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sN9xODmI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006B92BE042
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 15:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751988602; cv=none; b=s/aq6OZEsJ2GggUtzBhCE3EmlLZvlII6aUqgGhLnx3YQuJKNag8Q9FDJ55YCKALSwMOgY9LHUq2ZAvWKa6yeqQ1li8Kt6G1u1dSpqUhWt/xefmgI+TrrrzalEy4Naw6iLhvVIq2+Rpiv0OBdmb09sS3TUUNBx3+JmPcAPof+scQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751988602; c=relaxed/simple;
	bh=W20IpdUqaSMFfqjx2L2Ny1gFO89fIMTICQ4AEt3CJAs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LNe6XeQfRYga+GijWhohcpoVIpTEphYiixXsfPfPnyP+7LrHJaTgciDQOU8u5FqMK3Sv552/hJ28Zve33bet/br0s7uInAuKqKHIfaWXRKKNYr/oXklmq8ZEtpBZ30Nr2YOwtBFGKl+vQr0y7rV8qRAgK0UJUlgJfjZgPv6675M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sN9xODmI; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2357c61cda7so150425ad.1
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 08:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751988600; x=1752593400; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W20IpdUqaSMFfqjx2L2Ny1gFO89fIMTICQ4AEt3CJAs=;
        b=sN9xODmICCJvB5jyTC95ezx7jCQFrd7yYxKKK9UgRD/855Bk0Wi7q+FDEbdxcX+2Wr
         CG3xLryKNmtjYL4L3jMoUEg3SJ7CKtjf7zEfNAgc0EKoggzXreUF7lzD+Vy8G2DIXMWp
         1AAhY7lrUjnR6q69rFHtEy5U6gWDKi26adua5tT667pvwfokGb52ipYhpLXorsfIXiKr
         JvmwzAlT+a/oet6q4DUu5TuvBJFBWu/iVFxcW4u+/pJfxoIeD6s/+/xPQI72QRR1FfOc
         YLxkbJrFsJXLkqOcOmzfT6Uc2NG1hd82gHdQyik3PEnMLV5Fh4yFIX+v5VfwJ4QWbSj/
         IRlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751988600; x=1752593400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W20IpdUqaSMFfqjx2L2Ny1gFO89fIMTICQ4AEt3CJAs=;
        b=nkDrUGzR9rJHNGCRxL0OGoaxosENNJjc0E6NdAZgr/4Zeqxu8pdFXvMqNiYpNjrHHJ
         LHhlewDMdhjDMxUVuSQnc0PMEkDFAuxijeADVftBXNPZIIYy4iZrNPUNO5luv/2Z/e6X
         31kC4zFllmqmnv9eOc4qzRhmb2LaXntaj8ySCPIx8b3OiphBu+VAPNL0qrcCP7MTAbWQ
         4yr75j9/eq/EQg2GpgJu3mvVlcsykLJ7RwjotZ9YU2OkHYDtnvy/yPvr9R/tfbVBkPpq
         kDl3F/3XKmK2EVhHkBRp9g8vCa5qg7Ofp5XBMaIzbViatmMCs6y9uNj5Zv/BKkmK+4g3
         Unvg==
X-Forwarded-Encrypted: i=1; AJvYcCUXh5FpCBYUUyrHU/3DjP2flPaUIE5Ml3XmSZrncVsVb8n7OWHbNOK5J6A3WvAo06g80os=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUYLiq1yR6aYB2SpqfNe0tN+BB63dW7ZljHmy8HakABU6CIMw6
	Q3mdedboEnGAplmyj71W9ICO8FHOapZhxHJn2O8LAAt3xhP2FcRhSI7Pl7ocUCFFYx7s5e/XGXP
	8mA9VyCpKdR2O50aIeGC1KQ8eugqMDi12ZY7i0hGYIPs3CSsH4dxr9eWGeBw=
X-Gm-Gg: ASbGnctKqm5NijfHJsBP2ipzcjME7oIC7oSegUWJ7FBy9mkOAObvlGokGp63FcYONYr
	dm7a6si9rLt3aWiE2Zvmd/m0wCMzR8sbL/0Lyj+3SEJUFY4EhaJtSDDYUOIzZZHf1OeZBMfCCim
	cQS5s2168apcaxPaFDoDVohVHcZJQu3I7Amz2f8+bpIRdTGmuFsr1sFYXs/210JgR1Dg7U1q6CC
	Kw=
X-Google-Smtp-Source: AGHT+IEbueMtdZ7P7DVLD9IsOQJGWr2YS7GEmv0nYcCVJ3yPPKlvkRMQcqvX8868Bmie/u5PpihMlk2cin26g91m4B0=
X-Received: by 2002:a17:903:2352:b0:22e:4509:cb86 with SMTP id
 d9443c01a7336-23dd45084c0mr1802835ad.19.1751988599914; Tue, 08 Jul 2025
 08:29:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250424030033.32635-1-yan.y.zhao@intel.com> <20250424030428.32687-1-yan.y.zhao@intel.com>
 <aGzbWhEPhL/NjyQW@yzhao56-desk.sh.intel.com> <9259fbcd6db7853d8bf3e1e0b70efdbb8ce258f8.camel@intel.com>
In-Reply-To: <9259fbcd6db7853d8bf3e1e0b70efdbb8ce258f8.camel@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 8 Jul 2025 08:29:47 -0700
X-Gm-Features: Ac12FXypl7Scf6RWCNjAT4MByjBKf_ryu8CagQeiYBwMWTSEjMKcoIQHKLZocH8
Message-ID: <CAGtprH8jTnuHtx1cMOT541r3igNA6=LbguXeJJOzzChYU_099Q@mail.gmail.com>
Subject: Re: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, 
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"tabba@google.com" <tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan" <fan.du@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"Peng, Chao P" <chao.p.peng@intel.com>, "jroedel@suse.de" <jroedel@suse.de>, 
	"Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 8, 2025 at 6:56=E2=80=AFAM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Tue, 2025-07-08 at 16:48 +0800, Yan Zhao wrote:
> > On Thu, Apr 24, 2025 at 11:04:28AM +0800, Yan Zhao wrote:
> > > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.=
c
> > > index f5e2a937c1e7..a66d501b5677 100644
> > > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > > @@ -1595,9 +1595,18 @@ u64 tdh_mem_page_aug(struct tdx_td *td, u64 gp=
a, int level, struct page *page, u
> > According to the discussion in DPAMT [*],
> > "hpa here points to a 2M region that pamt_pages covers. We don't have
> > struct page that represents it. Passing 4k struct page would be
> > misleading IMO."
> >
> > Should we update tdh_mem_page_aug() accordingly to use hpa?
> > Or use struct folio instead?
> >
> > [*] https://lore.kernel.org/all/3coaqkcfp7xtpvh2x4kph55qlopupknm7dmzqox=
6fakzaedhem@a2oysbvbshpm/
>
> The original seamcall wrapper patches used "u64 hpa", etc everywhere. The
> feedback was that it was too error prone to not have types. We looked at =
using
> kvm types (hpa_t, etc), but the type checking was still just surface leve=
l [0].
>
> So the goal is to reduce errors and improve code readability. We can cons=
ider
> breaking symmetry if it is better that way. In this case though, why not =
use
> struct folio?

My vote would be to prefer using "hpa" and not rely on folio/page
structs for guest_memfd allocated memory wherever possible.

>
> [0] https://lore.kernel.org/kvm/30d0cef5-82d5-4325-b149-0e99833b8785@inte=
l.com/

