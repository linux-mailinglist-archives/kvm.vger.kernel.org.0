Return-Path: <kvm+bounces-56175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A501B3AB09
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 21:40:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5DBA44E2B10
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 19:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03CF4271450;
	Thu, 28 Aug 2025 19:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t6CpH4J3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E9926AA93
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 19:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756410024; cv=none; b=DqkChoUWmX90GsBfd8GMvrzYjh+1f565kdA2HqHL7IekZ029RjgyZbgkl6V2yygp8QIyNk161ecd00k59OlOVo/DPoQ89SWxnukv8M8qEHwH2hNeNRHlS6U2dOVdfQE2n57oKywB6I5uzF5ZXZLZrL5RRE6vvPH/mfTAsD7c2rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756410024; c=relaxed/simple;
	bh=sOweL7MC1afeJEVQ1CAY29hh8rwCDAUVRUF14Il1LA4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=piSXpxvJR5NOhnVl8uxzN5WSjjqUMWnrOb3hEvH3xtfD5ZfeFcEA0GIQ0vXwqpkGSbf0NgTll686XSXZmAWosIEnmy7GCQr9XmPaXHxRD94WB6tZQtv1FfDo8FVRHFemrzCqcm5jl2hP0vU3VovlzazJ/RCGL2Cc4ILdZ57h5TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t6CpH4J3; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4c746c020cso396573a12.1
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 12:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756410022; x=1757014822; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fq5jKUl0c1/qCP5zM9srpRStKM40NBvkFf/O/1jAlyY=;
        b=t6CpH4J3sj6zwJ7oH5fy9ATEgMymQrTG+k71c9VG/xiF+hGCEezGpWOvi851q6mIrB
         xmcnB2MidZcoJpFEBYW8oEbcxFNy/vUNpaATOqCEGKwy2U5gBEWtjbOv44+SgjbzKVka
         Cnhg97dsU74fZ1c+AVebuqdOlTSI4xdiUwsfxdgE1BCKavIRV65SwyIYOMlk3+Qy8M+y
         z24bds+r44+iBnOX9puxUTn85TkKVFacS/Nag7FeyjlN80Ehe6ZP23rdSJV6h7H2XViC
         NIWMtPuQSmUindJO1wfAOZ2gsw/uaXSxj/CJz4tBE0jLimkjjDNrYxYJOhTsbvFJt6/o
         0XlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756410022; x=1757014822;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fq5jKUl0c1/qCP5zM9srpRStKM40NBvkFf/O/1jAlyY=;
        b=d7rtEM950GSbw6Xng825atsPd9bCrxqlcqGWNXvA7fVCGQpis6xbXq1PBv0drfWHmz
         6oQ0ZMVtePoHiv0qtCNc2FIOguiuCk11OTlZKfeM6/5GUY2ao9oyPDHWCtUncnlOhOrq
         hoavy4J6UMb98q4SSv8iZwEg+ArCSZsxPYAGSrau64Q77Bh06UU2Vd7MVOrf0WdlGBM9
         11ObmjwUFeuW2DQt24iUBfT5hK4TZ2gvft0e8EEO6rpifamJlvWTWMGvSpjVpNSL7x+G
         eAye/lvGsyZ9RlLrPBkqDO8gxRC33ymjnfivgnvBGd85t3KA5biFlOTohapxFMD9Zcms
         g65g==
X-Forwarded-Encrypted: i=1; AJvYcCWBnyTEyKk9R+rrJgi2Tehx4e9fJqHTeTGIMpKVj1d2+ygK9WAbHupDAJoTaftC/R+vWUw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxN9IB719eHPzt3f+7Z303TJaT8Wn8ESq0AOKLR3HaEugugDhVw
	9CeqYaBpRbRBth4Tu8i5OLqLZ1zZh8dY7TSir6++5Pf9w0d81qr/TBd8aq5D3iMma0jahgHwmnN
	Yve5jCg==
X-Google-Smtp-Source: AGHT+IGgX7CXXMdV/d7Hx1tAtW4pSPXY7GO3K/pyEZYQikr1kxkeTskIwgkgfd0X3N4nMikwbaNNINqN5pg=
X-Received: from pgnm20.prod.google.com ([2002:a63:7d54:0:b0:b4c:1c02:2564])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3947:b0:220:4750:133a
 with SMTP id adf61e73a8af0-24340bc7f40mr36103172637.25.1756410022083; Thu, 28
 Aug 2025 12:40:22 -0700 (PDT)
Date: Thu, 28 Aug 2025 12:40:20 -0700
In-Reply-To: <aK/1+Al99CoTKzKH@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827000522.4022426-1-seanjc@google.com> <20250827000522.4022426-3-seanjc@google.com>
 <aK7BBen/EGnSY1ub@yzhao56-desk.sh.intel.com> <4c292519bf58d503c561063d4c139ab918ed3304.camel@intel.com>
 <6bb76ce318651fcae796be57b77e10857eb73879.camel@intel.com> <aK/1+Al99CoTKzKH@yzhao56-desk.sh.intel.com>
Message-ID: <aLCwpNygeC64Bkra@google.com>
Subject: Re: [RFC PATCH 02/12] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Vishal Annapurve <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2025, Yan Zhao wrote:
> On Thu, Aug 28, 2025 at 09:26:50AM +0800, Edgecombe, Rick P wrote:
> > On Wed, 2025-08-27 at 17:54 -0700, Rick Edgecombe wrote:
> > > >=20
> > > > Then, what about setting
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 .max_level =3D PG_LEVEL_4K,
> > > > directly?
> > > >=20
> > > > Otherwise, the "(KVM_BUG_ON(level !=3D PG_LEVEL_4K, kvm)" would be =
triggered
> > > > in
> > > > tdx_sept_set_private_spte().
> > >=20
> > > Yes this fails to boot a TD. With max_level =3D PG_LEVEL_4K it passes=
 the full
> > > tests. I don't think it's ideal to encode PAGE.ADD details here thoug=
h.
> > >=20
> > > But I'm not immediately clear what is going wrong. The old struct
> > > kvm_page_fault
> > > looks pretty similar. Did you root cause it?
> >
> > Oh, duh. Because we are passing in the PFN now so it can't know the siz=
e.=C2=A0So
> > it's not about PAGE.ADD actually.
> Right, it's because the previous kvm_tdp_map_page() updates fault->max_le=
vel in
> kvm_mmu_faultin_pfn_private() by checking the private_max_mapping_level h=
ook.
>=20
> However, private_max_mapping_level() skips the faultin step and goes stra=
ight
> to kvm_tdp_mmu_map().
>=20
> > Sill, how about calling the function kvm_tdp_mmu_map_private_pfn_4k(), =
or
> > passing in the level?
> Looks [1] can also address this issue. Not sure which one Sean prefers.
>=20
> [1] https://lore.kernel.org/all/20250729225455.670324-15-seanjc@google.co=
m

That won't fix this issue though, becuase @fault will be valid and so max_l=
evel
will still be KVM_MAX_HUGEPAGE_LEVEL.  Which is by design, the intent in th=
at
flow is that KVM should have gotten the level when getting the pfn from gme=
m.

IIUC, this particular flow _must_ map at 4KiB, so I think forcing PG_LEVEL_=
4k is
the right solution.

