Return-Path: <kvm+bounces-65641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 98C4ACB1995
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 02:31:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 561A830ACE88
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 01:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5978313B584;
	Wed, 10 Dec 2025 01:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RDcQYWSf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46D621348
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 01:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765330270; cv=none; b=b7aG3P/8N4fW/t21e2wYdB6WKWBhayy8ObbR+A6IbMTIUlY/YVbzxDXnzlZgzYLGyacIrf0oIUDgubCMHkBnY5chVQwnVqjmVDE/rUZJJTwb9D8EGNIXgP8gtX4M7IxcYvV2Y+NmRxEMJXr6wcK2qrocoKIQInD0tp9SO+7jiL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765330270; c=relaxed/simple;
	bh=Mz4duiLLOCuTkZoXLIiKLsuzgdGwTO/UITCx+NF6Vks=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iFKsXyknO5r6+cHn1jdXKOYQLuRBbXQccy8RVgwoj+YCxqYfx5YwoZm5YEjsruvrDvLdlCsAgoOpMx5GQhbI1MDngao8FGNC9OfoUSRcx5qJlPGutJNgf8Yzyj9pOCCSPwavykhoBTR4peNugPrqqd/tfymoIR7SapYlCOscdN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RDcQYWSf; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2980343d9d1so63885ad.1
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 17:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765330268; x=1765935068; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Irk9fv4Q2mcS2kxJhDraOCY7fgGZVB2P6dCuM+yvEZM=;
        b=RDcQYWSfd+VRtNQW3vCvBUxJ2Ap2r7df2vk6l/owuFA7DEECNUbRHJr8zx+IY8bq1P
         nTEEtE2tD5j78cgKZuaJb6fOfqlUC38ms9clhvjravWzTj4mBscSNF1r8yttVWjU+iGg
         usD02Lya+XgClJT0Kh8CQuTtWGod5cys6ldIXafXZ6Dyd3oeB80Nj7hH8V/DFthoBy15
         hksFqhtIdK1ftFEKgChZ43dfqwqBM7W80d4hN+YCCaqzCG1QngflSN4oFFLlvhXLvKiU
         TUEiE1mcvMLb/HyzMp23ISOFj5menAcdX8kIzXrNq/xAhevXqYljjfEsyod3lVUP0n/I
         90Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765330268; x=1765935068;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Irk9fv4Q2mcS2kxJhDraOCY7fgGZVB2P6dCuM+yvEZM=;
        b=IE5w4oQbsMVnS07PxHEdFI7kL7ULsyWcxEUfpcYAIC9FUBn3FlawhQbch9/zVe5wnI
         0qubZBXDKe35ZYfmn5NBPnkFPWKW3OjRfHPYz00aySWtRsB+lr/ZvWn6BWBH0F1kZ+Kd
         g+7jpy9+TvD0efIcx2SHhGDk2KKBiUu9WrVDkmqDKeBe1ZYk+EusUEVUxte9A/TEMLGg
         BZX9GF2WN0EOxNAgeojRKUKN5h68jTcSKHKRD4rdicrjbvl4k/65/LGV6dIqg72cyjsx
         yIZ4+1qOnsnpGfYWYlKkouZ9M/c0yKxOKm9rysn5/WrM1Itr1v//Jm1ZOfJx7730mLlc
         y1AA==
X-Forwarded-Encrypted: i=1; AJvYcCWGdK07/AMjBFK/YqtG08tadBM+eweuGX/oM/FMNlOWcx73S/hp5JmBvSqXdyWtElgGlaA=@vger.kernel.org
X-Gm-Message-State: AOJu0YysiDAEa6bkfholjqcBWuR+cQOEMMBZvcD2SyZzKyUAWjFgBF2F
	UEOBWw2aE34GcuI6+PJgriU7QIlhCyTtL32iIP7MikOr27tZ/mcDCVj7fheIlhI/fJ25TOViNUa
	hckTAkNKNQA+6bnT9vcGGU+XXa3fx2mgizqbYZlx1
X-Gm-Gg: ASbGncvOMPE++zqVecHPXWnZRSW8H+Nwx62DXQ5GKYDEgoRRPR/n4qcUXneBr97afzA
	zCdHMK5xxCy5ak2ZGzlFvXHdJ5liPm3TIhcsvziakYWwu6uxAPYBsjfUlDsAGeQaFDfZPMU5jnH
	LTiSmTV5d8150u89/Y5LP6KqgogKcFALNnL4DDP1VsvllUUtqoH3POq9vduq/QEnrA4BLp2riu4
	u+uN9A9/yAgMP2wW8XQRzymjUj9fkWE9TvOvSSUclB5blLUMr11MAo1X2Q+YluqrcYq85UIOszI
	ABLZZsyKbQDd5tViSfWjQOFTew==
X-Google-Smtp-Source: AGHT+IEXSESfKg2H/d/T2jQGj1KKKqp/LxvlOlAwGVnAV3NhgtKbCFFCTKcDjo+wHeUD1zSJMEuloFAMt74Rnxr5ZAs=
X-Received: by 2002:a05:7022:305:b0:11a:2020:aca7 with SMTP id
 a92af1059eb24-11f28e640aamr79429c88.2.1765330267539; Tue, 09 Dec 2025
 17:31:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807093950.4395-1-yan.y.zhao@intel.com> <20250807094202.4481-1-yan.y.zhao@intel.com>
 <CAGtprH8zEKcyx_i7PRWd-fXWeuc+sDw7rMr1=zpgkbT-sfS6YA@mail.gmail.com> <aTjKV/hAEO4odtDQ@yzhao56-desk.sh.intel.com>
In-Reply-To: <aTjKV/hAEO4odtDQ@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 9 Dec 2025 17:30:54 -0800
X-Gm-Features: AQt7F2ot4bhp0JL5RYqg1dGnxsqrLSKG0y6jAFKGTRpr7eMWJGUda_-f-arqaR4
Message-ID: <CAGtprH9foQx=XLXXMqYnga27jWjCSkqj5QHVnAM_Akv7CLNmbw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 03/23] x86/tdx: Enhance tdh_phymem_page_wbinvd_hkid()
 to invalidate huge pages
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	dave.hansen@intel.com, kas@kernel.org, tabba@google.com, 
	ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, 
	david@redhat.com, vbabka@suse.cz, thomas.lendacky@amd.com, pgonda@google.com, 
	zhiquan1.li@intel.com, fan.du@intel.com, jun.miao@intel.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, xiaoyao.li@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 9, 2025 at 5:20=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
>
> On Tue, Dec 09, 2025 at 05:14:22PM -0800, Vishal Annapurve wrote:
> > On Thu, Aug 7, 2025 at 2:42=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> =
wrote:
> > >
> > > index 0a2b183899d8..8eaf8431c5f1 100644
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -1694,6 +1694,7 @@ static int tdx_sept_drop_private_spte(struct kv=
m *kvm, gfn_t gfn,
> > >  {
> > >         int tdx_level =3D pg_level_to_tdx_sept_level(level);
> > >         struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(kvm);
> > > +       struct folio *folio =3D page_folio(page);
> > >         gpa_t gpa =3D gfn_to_gpa(gfn);
> > >         u64 err, entry, level_state;
> > >
> > > @@ -1728,8 +1729,9 @@ static int tdx_sept_drop_private_spte(struct kv=
m *kvm, gfn_t gfn,
> > >                 return -EIO;
> > >         }
> > >
> > > -       err =3D tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page)=
;
> > > -
> > > +       err =3D tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, folio=
,
> > > +                                         folio_page_idx(folio, page)=
,
> > > +                                         KVM_PAGES_PER_HPAGE(level))=
;
> >
> > This code seems to assume that folio_order() always matches the level
> > at which it is mapped in the EPT entries.
> I don't think so.
> Please check the implemenation of tdh_phymem_page_wbinvd_hkid() [1].
> Only npages=3DKVM_PAGES_PER_HPAGE(level) will be invalidated, while npage=
s
> <=3D folio_nr_pages(folio).

Is the gfn passed to tdx_sept_drop_private_spte() always huge page
aligned if mapping is at huge page granularity?

If gfn/pfn is not aligned then when folio is split to 4K, page_folio()
will return the same page and folio_order and folio_page_idx() will be
zero. This can cause tdh_phymem_page_wbinvd_hkid() to return failure.

If the expectation is that page_folio() will always point to a head
page for given hugepage granularity mapping then that logic will not
work correctly IMO.

>
> [1] https://lore.kernel.org/all/20250807094202.4481-1-yan.y.zhao@intel.co=
m/
>
> > IIUC guest_memfd can decide
> > to split folios to 4K for the complete huge folio before zapping the
> > hugepage EPT mappings. I think it's better to just round the pfn to
> > the hugepage address based on the level they were mapped at instead of
> > relying on the folio order.

