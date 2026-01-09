Return-Path: <kvm+bounces-67580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 52540D0B3D0
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 17:29:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A535B302BC1D
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 16:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA95D35CB82;
	Fri,  9 Jan 2026 16:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I5VODPgd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE106272803
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 16:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767975687; cv=pass; b=AjRKyxXiSUFNZUw34FqN89sVUaAcWheOxSGA4nKwIMdZKzCmvRNp1bOt+LxJAxuLzkZeIl7zTegFVedZanaMdnjSDo3izA/1HHnsf1koWfPtYWgEUWDlq2UbhZblChALfA2riGcYDF8lTC4DqVCz+59jow8Oo3jZODwHstIXXBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767975687; c=relaxed/simple;
	bh=fspkAq4ALA6YsZ6RVqvaT0vlg1zkShpF6B9N5C3H28k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rZCYX/rR5YU7eJdKO9jIKbuZnC9UwXZOY2PAHJQnibhpNEZ8Wdyg/L1SzeRaEJGMZyNO++khh2JL0CJxbn0vxOdzPH0eHLTF9zb3GADX4rKSkxbnBrxz9obMayqHeclq4aZQ7YQf1atd61P7aY8ZlGtTP9VicAqOQOAK8IHozPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I5VODPgd; arc=pass smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-11a247de834so7821c88.0
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 08:21:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767975685; cv=none;
        d=google.com; s=arc-20240605;
        b=JAaMd3IKnX+bwvSDuNl/gEVy7FxdQCsgJUvD8m4nZAb/EYgd6qy2JOBoV9cTgb37iD
         lLWQriCRH8IsZSmf82qTTRjYGmWi0B8/r/5W4dshLdCyXk+Yk3DwLOFMETburbE8Yyxt
         LTtRObB8KmqP7VcPbTrNx/9aQS7tQ2XD5Gtcns8lhvoLKbOOvbnATHBsXiNqn4YETKbx
         dUxANRQfprp6+7Ge66T7ell0ad/ZGxsaEZbj9zTOz+9mM6BMkT1eB1F/65EhBc+F+reX
         3MmK0P+6TM3n5Y2dXRjG9/sOQHQZcSsjClxSPguveirSelmGOd5t1Bdl5t+T3JI4iQ09
         R7Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fspkAq4ALA6YsZ6RVqvaT0vlg1zkShpF6B9N5C3H28k=;
        fh=b0JdQUTT+BuVP0g7JqED0oGWdZWlEzNyoNamiZSYsCU=;
        b=DDgLN5WUnurNO/cnSgz5BKjlBaDrSLa4wOI3Lq272wwAzQUU8Zuy3njVpXi1BE1I8O
         QQswZ3uVal29Wgv5LzPaDT8ldzyJqFEnvzff9YxYnZ2BXtPUTRVYSxZ63tSMRa9a4Jj4
         Z+Pq+XTbWdJdANgCVRQxFmFF+Zd0JtoSqnxYqbOONzl8rO/YtHrMKlmRjSkZiLkUgjXT
         +UmlxGV4X5blu8nZ2aPeR6vNXBGGXp4KM+AD1pWvOcdh33jWUNJsmcdV6i0/bNFlrMq/
         hLwE1taJOYrcQ/aUqakRiWklAKV9xnsxQhLUrwLsuiQKMNVO34xup0JYahwsnOSfJJWS
         TGPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767975685; x=1768580485; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fspkAq4ALA6YsZ6RVqvaT0vlg1zkShpF6B9N5C3H28k=;
        b=I5VODPgdrC37BQ3TiaaPdajUmcQel67xdmhO1VWAvhLWfyobFb9DboVnq5lGwdrhfJ
         64f/wB3cOBDQWifZqjBFFDQehWrgzb+oEtQi2YztsaZuyLF2tNX2bAeCeMVZavwIg3QZ
         4Y2Xh+CtiXRg72WHmJceHp8NmhsO2x7Cb/l17eSxWuKyEGbDbuGO8p1EQkxVAlzjArXp
         j/+bFi6bR+ImUtAUDv6ABsyj0CkcSVFksC3D0xQlWYnrSA+JZ1PGVBZkx+mFOTgp9vYY
         WosKNlXYPGbSpkJSMGq/ZHyNDCuoZXJdjFaxbNEA2yej6aMiN8eFEsjxpmMfeVPvjmeC
         GBUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767975685; x=1768580485;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fspkAq4ALA6YsZ6RVqvaT0vlg1zkShpF6B9N5C3H28k=;
        b=HjwTT2MLCG1RHb7da2agYQMqkWAo7Ur/Gpcb5txTRpNAgRKMpuCmsDBv4crv1ySmUw
         2gEhmCv3IsJCkH0HEXDfu71WRDAUVKoUyHMCFUHK/wCJXAOFRXZQTu0Fn+1xZu/FIIes
         CXJZRbK84vUVfJDaT1oUOjL4i20gtV2qrfrH9ZrVppiwXq8U84qYmiOmgtQjvTUNuj8L
         YBh68ceebw4jPnymaC62P8IVUYFeEqsvgriu5FXpI2BR014oUbdH46QQIlnz3CrhCJ8I
         4c4h54wBjd6b05s1UysC/n4IiIj8MOVDL09QRZW+yTU30nDtjVWeDqgEQxqUoD1crTFx
         Gutg==
X-Forwarded-Encrypted: i=1; AJvYcCVZ2IoAaHPnBPv4oiIxvfDYNTiFruU1UMkZ/0mBhFIsN0XvqDTdNZpVt4PNdh7GKkfHsGM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwTJtKdHWHo1xhpl6E2JTFUCYCQizfzJjjMDmG3SCDF06bIywj
	fE+YdkV3fOkO4V/VvHdls/crASOLEYM5OAQ8j0YCV24MyNUi7PyXz8+r3MkHttKGjGxgTjtJFyT
	ScWRlk14PKTAVkijPSusnSdv2EsTgY8U7stXh8ngK
X-Gm-Gg: AY/fxX5mH/XSTY2TbUfhrl2nuRgIIbnlwGO5r1MqJyeWbceTxw9k8UcuhOXSskNgjTK
	0kLmD3G9Z5nBOqIqvPiSVGaX8grwRXGNB+BSPE0LqBpWyayVmeRNatGMEABknjHJk1qTaVSC14m
	9pBF5G1hrlneYlKzMLogmA5+kArbLRRwVWfh+islJ07QUDUCKCyAgM6ah9qtDxxVJD4MCJfAgt0
	ur7ikk8kVBuvNXEQlEMhGPbkqDfucwPPc2wj+rg0g4F8XsvCL/LiuNolIUllKtVXnXGZDqqyLWS
	+kjkmgK+KgF5h004WARhgM2qMRF6
X-Received: by 2002:a05:7022:220e:b0:11a:b4dc:7773 with SMTP id
 a92af1059eb24-122053c4d05mr128806c88.12.1767975684129; Fri, 09 Jan 2026
 08:21:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <20260106101826.24870-1-yan.y.zhao@intel.com>
 <c79e4667-6312-486e-9d55-0894b5e7dc68@intel.com> <aV4jihx/MHOl0+v6@yzhao56-desk.sh.intel.com>
 <17a3a087-bcf2-491f-8a9a-1cd98989b471@intel.com> <CAEvNRgEA69UL_=T+vE6z0wxNf59ie9neSbpyrp58_784C8vL9w@mail.gmail.com>
 <305c16d7-803e-42fa-b540-025e8571452b@intel.com>
In-Reply-To: <305c16d7-803e-42fa-b540-025e8571452b@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 9 Jan 2026 08:21:11 -0800
X-Gm-Features: AQt7F2p_8rwcFoFcVENDDkCd5vjHeYpXMhyfVfk26g3NpQOXlD8-5KwwpvkdS8g
Message-ID: <CAGtprH_4MyZxQ9y=MB7cR-Kzots2=H5Cp4hf_GnH9-CTw+gO1Q@mail.gmail.com>
Subject: Re: [PATCH v3 01/24] x86/tdx: Enhance tdh_mem_page_aug() to support
 huge pages
To: Dave Hansen <dave.hansen@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, 
	seanjc@google.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	x86@kernel.org, rick.p.edgecombe@intel.com, kas@kernel.org, tabba@google.com, 
	michael.roth@amd.com, david@kernel.org, sagis@google.com, vbabka@suse.cz, 
	thomas.lendacky@amd.com, nik.borisov@suse.com, pgonda@google.com, 
	fan.du@intel.com, jun.miao@intel.com, francescolavra.fl@gmail.com, 
	jgross@suse.com, ira.weiny@intel.com, isaku.yamahata@intel.com, 
	xiaoyao.li@intel.com, kai.huang@intel.com, binbin.wu@linux.intel.com, 
	chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 11:24=E2=80=AFAM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 1/8/26 11:05, Ackerley Tng wrote:
> ...
> >> All of those properties are important and they're *GONE* if you use a
> >> pfn. It's even worse if you use a raw physical address.
> >
> > We were thinking through what it would take to have TDs use VM_PFNMAP
> > memory, where the memory may not actually have associated struct
> > pages. Without further work, having struct pages in the TDX interface
> > would kind of lock out those sources of memory. Is TDX open to using
> > non-kernel managed memory?
>
> I was afraid someone was going to bring that up. I'm not open to such a
> beast today. I'd certainly look at the patches, but it would be a hard
> sell and it would need an awfully strong justification.

Yeah, I will punt this discussion to later when we have something
working on the guest_memfd side. I expect that discussion will carry a
strong justification, backed by all the complexity in guest_memfd.

>
> > For type safety, would phyrs help? [1] Perhaps starting with pfn/paddrs
> > + nr_pages would allow transitioning to phyrs later. Using pages would
> > be okay for now, but I would rather not use folios.
>
> I don't have any first-hand experience with phyrs. It seems interesting,
> but might be unwieldy to use in practice, kinda how the proposed code
> got messy when folios got thrown in.

