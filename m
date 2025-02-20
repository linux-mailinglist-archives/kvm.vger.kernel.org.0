Return-Path: <kvm+bounces-38675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E4A1A3D90C
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 12:42:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9913B17F838
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 11:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0CEC1F460B;
	Thu, 20 Feb 2025 11:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xphv2V5n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827121F3FC0
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 11:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740051626; cv=none; b=MnAg8Ykxb4Rk3x9qkyXxa/1/OYCloHhyS4hLOFV/6LqWsrX2XAmg2FjldpTr2sfAQHNOZzuuTMdJfyAG/a5+8XmZ2DDO5rfvqe9Z47eXP2cMQD//sSbZWAIigrZN8WjP2A7DNCuxX9Rnjov+WvykJXiUwHT/v12PNbZr/zd6LqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740051626; c=relaxed/simple;
	bh=d0U8XoOvA+acBIBzoHF+G0yUNFsQLkpIOuFLs0ject0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NznqVcc/7wMNhh8LItVqOxd8QjDgVP9me1ZpqTPZCxQSCQ5bCIkOSgL0GSauuSNXNxi1BKwGShJPgtwJsKkLPTWcT9Jshg+amwaKjSQmPZaONy4gUJrFdOTdi9BAk2rAOI6Jfwl3bQ7URt3weeIux8FCl4gUOEogcPhN2FwVHx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xphv2V5n; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-471f1dd5b80so144541cf.1
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 03:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740051623; x=1740656423; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=d0U8XoOvA+acBIBzoHF+G0yUNFsQLkpIOuFLs0ject0=;
        b=xphv2V5nWTMOUO4H6giPrqrCn2b4fQz9OlmbQDVexlrt9oSVw8rL9VehmNbfhdKwsv
         ADfgKgVVvZmo47ZGmUgfrmQv42tW5LcjI+puvJwPtyfn1le3nlQOKL6f0kl8exo40+Fm
         WAOptwO2GIdCsIoV3B1UTOf+4lW5MwvY5N1ssoJzbi2QO3u1SPp3IRNa2eup4mIywtmO
         dq53otBUwhBoNfu3lx/IGiXPOYJ1ssKULfaH9VZI8RCW9UlnTkiSk4+9qZq8SgWzRnq0
         /0oKaP5lclfLbyx7MFPMTIJSbWBhir3ryjPUiV2UKDt3euEkHZ5pLLOJEZogeUQwYBdK
         kpjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740051623; x=1740656423;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d0U8XoOvA+acBIBzoHF+G0yUNFsQLkpIOuFLs0ject0=;
        b=u39jLOGdzwx2xwROqOUHZQUD13NhmoDT2ggnEBnVyVRcLOULtU1EzNNzXCqv0na4Ql
         QcpQZejo9CrFW/a+7nYh1cDDGW5OPO3beQ6qvEAtViIhnzbLMVxdZ5KfquTqGQMHVjRy
         nY8hrREYoSSYDk1dKfYyyfDHoH+A6CdRR0YwXzbxaaYLwNBfCz3i3+4q8QfSGR9M+GjZ
         iKsjaYn/JpA4AHRty1mmBXJdQLgBFpbPhnH4qJKgAaPpayl0Vku+RvKGZBg5z0kly8Tm
         rI+fhhxrjthCBnmyVw15/2gdSCU6eeBkpTWp7RiNPizGJcfMFA1xFjWazvEcJeU1fH2f
         Dhmw==
X-Gm-Message-State: AOJu0YyeE5V3AYN6h0xSVuiyKA48KgzLohNV8Kmbca0bt2eBp6SElLoW
	fxlL4AyHB+mmu5NfreSBRtMDJw36tTtPQ51B+yG8nRMOQ632jktJ64dE889/nko07slEWtY/F4N
	9u88FBWhKDwOCfJrBifpyKcqRiyHSjMdC/pn+
X-Gm-Gg: ASbGncvHppnI8/6k5mcodAiyu5l7tCW6EPVBpfpM4/fa5eukvOlpvSr0II9/GGTHHUY
	/bgLxF6+Y+JKh4c5EY3FDjYYvrApy43imPIqJlKj4ORQkIzAhkMXjnchU8LYBCyRv+cYflYo=
X-Google-Smtp-Source: AGHT+IHVjp4mzaDClwod31WBM2FUbWAgy5/QUs/Ub7sQAFiHuslFBDQqqSMVTxhXABFXwQMa8EyBZi1SpyQD6tKdjag=
X-Received: by 2002:ac8:7d48:0:b0:466:8c23:823a with SMTP id
 d75a77b69052e-4721710da0bmr2627361cf.17.1740051622999; Thu, 20 Feb 2025
 03:40:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211121128.703390-1-tabba@google.com> <20250211121128.703390-5-tabba@google.com>
 <9abf6dd8-919d-44a4-8352-ee350fec8ad3@redhat.com> <9751bcb1-bbbe-4586-b4bc-2b8f2ca98cc8@redhat.com>
In-Reply-To: <9751bcb1-bbbe-4586-b4bc-2b8f2ca98cc8@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 20 Feb 2025 11:39:46 +0000
X-Gm-Features: AWEUYZmeYQEXSt992JFhlio0eX3h96LGKbrmRYJuQPrU7OUEfBrJxrKHgNAJWDw
Message-ID: <CA+EHjTwFnarOEDBSsZmdt=8yAAQiKp1=2sA-oOKQxLqs0wTGNw@mail.gmail.com>
Subject: Re: [PATCH v3 04/11] KVM: guest_memfd: Add KVM capability to check if
 guest_memfd is shared
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 20 Feb 2025 at 11:39, David Hildenbrand <david@redhat.com> wrote:
>
> On 20.02.25 12:37, David Hildenbrand wrote:
> > On 11.02.25 13:11, Fuad Tabba wrote:
> >> Add the KVM capability KVM_CAP_GMEM_SHARED_MEM, which indicates
> >> that the VM supports shared memory in guest_memfd, or that the
> >> host can create VMs that support shared memory. Supporting shared
> >> memory implies that memory can be mapped when shared with the
> >> host.
> >
> > Was there a good reason to not squash this into the next patch?
>
> Sorry, I was confused, I meant the previous commit, where we essentially
> add the mmap option in the first place.

Will do.

Thanks,
/fuad

> --
> Cheers,
>
> David / dhildenb
>

