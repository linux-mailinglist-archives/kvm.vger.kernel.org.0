Return-Path: <kvm+bounces-67627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D5743D0B930
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:17:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CF374301C813
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:17:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9FBB3659E6;
	Fri,  9 Jan 2026 17:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WlbW2/Qn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89324200110
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767979023; cv=pass; b=eE+TgSEJIFMXzkBDjHZrVJ5dHG6Hb0b7FgOVBFTOfnwZg3G5gRImSrXvyYhb6NbawH0vxDJR1yACa2dbiQzYrmkqaits99EcA2eFMexuuPBwJ/s0cJPrdo7Pg13P764d8PgmjhP/2UscGaPl0b+UMRBaxvJYLOfVq1j00y3LmPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767979023; c=relaxed/simple;
	bh=fRnUiUat3Qv+t9aWDZnp6MEBH4U3zbztXaUSwSLjQsY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FaXz8qcly//C5imK4BoIvQNQXoT+9IJPQ2nqCocFskJzgcsTKwC19d15zRulEEQSkiStfhdJZ2naAUPxtMarwaPs4dx8Btyaa5EwVMnfcUDf6KpFVStmBHwxwSKxroG+TNllI1tri0Tw2c0g4b7G1yJcnABPczWECRFu0wJqpIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WlbW2/Qn; arc=pass smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-121adc0f1e5so290c88.0
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 09:17:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767979022; cv=none;
        d=google.com; s=arc-20240605;
        b=UVIlNimtQFJM8K1bY3eimtqtQDIFL5wX5RrouAmOz6b2Nhaank84i6bRmAIjp2N+mD
         hBbHOaXB493531Vt4xBlNsv3nwbxvKOg/gxI540mJdWUrGqU9Cd8D3OoRnRC9zMeqmaL
         24hRLq4Lc0yn7NUknDHlh6JGo5QV5Ztm/zba/i2mn1qBb6kIvmtXLEBg805fzmOMPkFA
         37/FAlbLLM3z/uxpWLtUCrpM3qSbUzPTm2yTISRWBge8888OLtYJiUFR57vKnjYGRrcS
         w7gDklHWlrTFnhQEeTi2mSJGXHbaUKmq/uZVstn+swc+ywKoPZjiNCj2MRlr3H5vPAZI
         TIfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fRnUiUat3Qv+t9aWDZnp6MEBH4U3zbztXaUSwSLjQsY=;
        fh=tnux0M/1+tKnn3Gf4+QbVPt19OW0dzJLsFS3g6fI2lY=;
        b=WzIHYDzQWay+jNRkK6/8hmV/zZFNg5QyDJ6VCayUBU67zZoKgmlx1Bdja/PN06rlsf
         15TMOyavwivq1SiQkMmWjIWT/NbDIQCU5HCVVMmAygttylCyoHUeUiLje4p7FL46UBs8
         t+xjrkKEIE+QzrXaBVW1brh4oPNCIBFnUQZenmsKcFux954lTNyTTzS//vM9qDmQuA8N
         Nl0HxonswfbXhHfgSg6A1Qo1mVU8pBw8B4u1udZWp9uMvW0Q8P5aZX0xmg958j2okFK2
         hGwmzJDRZnNm/fhnSibiOUmOoNo9Bdq5RtV6ROc5ng34zc/Jq+UUJIf7M6zjGoCT8cUa
         +x6A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767979022; x=1768583822; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fRnUiUat3Qv+t9aWDZnp6MEBH4U3zbztXaUSwSLjQsY=;
        b=WlbW2/Qnd95zcHTbgHKf4KrwboEiz0JHknOpWlxWqoiSQS7+JKl4VmLYStpzL5b6vi
         WIRIN2RSDtjMfSx7Y1WDU50kOSBqWMrWBUAmCuF3UJIUXlXKKMLohV2+4DpjLPeJ0l7U
         Dgn4RrSsOgy3gVAIZmZT5EihxPBqfVqj4XxVXwWONBDXMHezBh5i0IUJ/uUDAa6XQC7l
         kpLIlwcNdIJZhhAa9ThayAx/eQIfbT67zDPIQF5hvq9EobydnvevQDxGDggh5+ZfvESR
         QZ+EEUS1y6smubfAvO4vHMs8SLEcEThH0Imj0z21V0YCLmAUpcC7AYoo3urvNIxKWfjB
         P9Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767979022; x=1768583822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fRnUiUat3Qv+t9aWDZnp6MEBH4U3zbztXaUSwSLjQsY=;
        b=VE+Ktsb42gf5Zh2CjCbApWo8R41XXVXO9GmL+p3KFXtVd0mbL4u2PfMXe7jenL50hI
         PQNg7/hpxAhdodbfmkbu9nMiPXm12591DKIcR8jMiIMkygn0j77v5BU+ro+zrjw2yB/E
         vnWKZka8bCAJ0TSWRwkBEjyaOndZ83g8oddI6y/hxrVYDfBTJtjPYeb8LBRM8MCyfVz5
         V57tORfjG9B4rzDQsAuaZ4NL0fXxF+vJ0U8PbwVHvpyWDO4pSjOaL+YrXA0wwIk44dnA
         ou1GtlwzhBogl5cOPpUdZALwq5tL69/uHE7c6UqLlg3RmFR2k/rOrjOkJF3eMjcsD2tD
         qefA==
X-Forwarded-Encrypted: i=1; AJvYcCUrvrCVQPUDD6rMWBbyOn85mhm33C7QEt0sT+SdJZRDu1PFvO4uVxLA5PJgoa6+h2Va25k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYLX14348Bn+e3uVZYIrATJw8MJ/y4fUIzqM5QsBGfZEso3fgg
	Ni0l93gGqBBRkp0dMxfneLnsMLUVWEZpk80RBqa6Y9pJso+WuhkhQJr04cpqkmBNaEwbBPx1bYp
	X4h39+wpwdd/z0d/mJ6JpJK08HOqpRHYl2qkiv22G
X-Gm-Gg: AY/fxX4u7t4oWSt5UBmql/8MrK+JtUcH8YeYD8CRf5HvMmVQFmYxP+zZQrwlZqkIN9L
	5WHkZN3tyHxbousVLeHDeZXshFyDr3HPSBq92auIGfCShph51SbP+zGW4naCui+OvMS5E8e64Dv
	dbUzfYvAMuGvrxHo71AgsEHUmrdCVmqveYkC9J5g6XFOCG9crhJQz32/EgOZFkzQGLXQLiHXfVY
	7xI6efHx8TiS4+1uy3QR5pEZrWjpWij07gUb7BTakCVxbAvlI//xmSjr6uDQAZJfkaQOA/rbeN9
	Thr4OoyT9KRK5gqDQKfb0L4M4MD7
X-Received: by 2002:a05:7022:3846:b0:122:8d:4740 with SMTP id
 a92af1059eb24-12313209a64mr1956c88.16.1767979020971; Fri, 09 Jan 2026
 09:17:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
 <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com> <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com> <aV4hAfPZXfKKB+7i@yzhao56-desk.sh.intel.com>
 <diqzqzrzdfvh.fsf@google.com> <aWDH3Z/bjA9unACB@yzhao56-desk.sh.intel.com> <CAGtprH-E1iizdDE5PD9E3UHXJHNiiu2H4du9NkVt6vNAhV=O4g@mail.gmail.com>
In-Reply-To: <CAGtprH-E1iizdDE5PD9E3UHXJHNiiu2H4du9NkVt6vNAhV=O4g@mail.gmail.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 9 Jan 2026 09:16:48 -0800
X-Gm-Features: AQt7F2o6JjeiewcJCZ6NpA9pVHqWCFiOQ4x8xE0_nl18mtYV-bndvd9SSUx3JEo
Message-ID: <CAGtprH88FAYhZdEP94wS9=swMX=CxpMKZs8+jxdrXsf0dv-tZQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	rick.p.edgecombe@intel.com, dave.hansen@intel.com, kas@kernel.org, 
	tabba@google.com, michael.roth@amd.com, david@kernel.org, sagis@google.com, 
	vbabka@suse.cz, thomas.lendacky@amd.com, nik.borisov@suse.com, 
	pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 9, 2026 at 8:12=E2=80=AFAM Vishal Annapurve <vannapurve@google.=
com> wrote:
>
> > > >
> > >
> > > I think the central question I have among all the above is what TDX
> > > needs to actually care about (putting aside what KVM's folio size/mem=
ory
> > > contiguity vs mapping level rule for a while).
> > >
> > > I think TDX code can check what it cares about (if required to aid
> > > debugging, as Dave suggested). Does TDX actually care about folio siz=
es,
> > > or does it actually care about memory contiguity and alignment?
> > TDX cares about memory contiguity. A single folio ensures memory contig=
uity.
>
> In this slightly unusual case, I think the guarantee needed here is
> that as long as a range is mapped into SEPT entries, guest_memfd
> ensures that the complete range stays private.
>
> i.e. I think it should be safe to rely on guest_memfd here,
> irrespective of the folio sizes:
> 1) KVM TDX stack should be able to reclaim the complete range when unmapp=
ing.
> 2) KVM TDX stack can assume that as long as memory is mapped in SEPT
> entries, guest_memfd will not let host userspace mappings to access
> guest private memory.
>
> >
> > Allowing one S-EPT mapping to cover multiple folios may also mean it's =
no longer
> > reasonable to pass "struct page" to tdh_phymem_page_wbinvd_hkid() for a
> > contiguous range larger than the page's folio range.
>
> What's the issue with passing the (struct page*, unsigned long nr_pages) =
pair?
>
> >
> > Additionally, we don't split private mappings in kvm_gmem_error_folio()=
.
> > If smaller folios are allowed, splitting private mapping is required th=
ere.
>
> Yes, I believe splitting private mappings will be invoked to ensure
> that the whole huge folio is not unmapped from KVM due to an error on
> just a 4K page. Is that a problem?
>
> If splitting fails, the implementation can fall back to completely
> zapping the folio range.

I forgot to mention that this is a future improvement that will
introduce hugetlb memory failure handling and is not covered by
Ackerley's current set of patches.

>
> > (e.g., after splitting a 1GB folio to 4KB folios with 2MB mappings. Als=
o, is it
> > possible for splitting a huge folio to fail partially, without merging =
the huge
> > folio back or further zapping?).
>
> Yes, splitting can fail partially, but guest_memfd will not make the
> ranges available to host userspace and derivatives until:
> 1) The complete range to be converted is split to 4K granularity.
> 2) The complete range to be converted is zapped from KVM EPT mappings.
>
> > Not sure if there're other edge cases we're still missing.

