Return-Path: <kvm+bounces-52216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E52F4B0275A
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 01:05:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44C247ABC1D
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 23:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F165224225;
	Fri, 11 Jul 2025 23:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y2wEzcns"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650EF2236E1
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 23:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752275101; cv=none; b=NjHyivxAf3c2gFAZcqDNyrrlOV707paQfNJFH2ehTyY/MAoY5d4GEwLYKDjDxesARppYTDrtrNHvgR8Qh5Q2h9ma2eTRBdYwhhaCtMVxPqbNs9Zt6ZDeKmxUWM96rIUUW0YDyNQ5yHZCov/DqwCp6xCKDXSYXpwU4eZ9EhyHkVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752275101; c=relaxed/simple;
	bh=nnIOfDA/IHDzCc1ICgQILjechAoW55OWkyKQz0wmAqg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EkCSDRhFUmm/tlAPIpdr6u+A9O3U0jtYPiNdaBc5rgJcr2mDBND4ghthpAOHZtKufvyVRMr1rJ79Lkwl4dezUQN+izELyD4k4K5vmMxS1otOirrwxNdACWKJdX6eT38sg19Y/SBA4K9POs6+Ufz0IdTixWmFPttYyWOhrgrXyKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y2wEzcns; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-237f18108d2so65595ad.0
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 16:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752275099; x=1752879899; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tIRp4nuNG0MkOmILiokqVBZt7BZxwtFgO4R23+cjxTY=;
        b=Y2wEzcnsMqasj78uorWQ4hkczpVVM85zRCSFlV3nAEsX+wWQgT6oesYW1ldVFvouJD
         ouV4ws21uCsRWhX2jkrcOvglMsE49w319ERFoh2JxmWS6k1EzFqASMG1cc04TDOakZG8
         YvQF6kkj4EQ7Io9oMntkhYGuz0u3p+NlJOIexc0PhUZBtVof032WJVUfspVKiFafgO1C
         LMvehmlBoKcZZ7Y9wT3m4wBan5vsYif/niwdWOwrqhgwNPvuxxm7jey07LRzbIu3XKFS
         VqqMDNv8+cHXRRlBd4GfGaBPBVGquTrI2IvIMjzUI8ST8rcuFKHQ6+uFIqT1wQ31ItGO
         Al9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752275099; x=1752879899;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tIRp4nuNG0MkOmILiokqVBZt7BZxwtFgO4R23+cjxTY=;
        b=f7A+VUO/A7z/EPiFOyZng7Y1bUq2MY7HEm2POQZTMDXfcE66leZKa+eZEOhOl5w2DL
         rPDflYHJDI3AdYh+tecLbvRwCXLeLdGrkDFeppVWs1+6nDVvZmah1M+S7o3kRYRtRl1Z
         fS/4Wu2csvjIBX6bjwLDl/zXihe09IXbZFf8shAhvEgPCOCE0ZYYuwtXFWBke1B1Ea6K
         77NybRAQxKsCkYXq/lQ3ImiDMjr0WehawnxlqkH6B+nB5sLHdnsxjDHS6spo1Nfhjqtj
         Zgf/QNW54zBnqiX6afvrdKZn3DCwBRMgQC5//GZPAAMukiOiT6SD6NKYjqCeflrT633N
         ZtNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrt1MUfa+8lqp31QXz5vwUEwSWxadB5cVR/RbkrunV+99vjdl/qKknioWavXKYRt1ERtM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6tDcszNaAjBNpLGqAE2VlDeBvXX+0fW6p/88uauJPFTmEeDqJ
	VwewfoehyDEYfqb/Gpti1nz7ZGpwB6ejod2aDfryrCbNV/XzZpOp+pGJviS4rYkQ6lVV8N8AfTl
	5GVtoATx58TwiGKy9/JFk1t04cM//4sItyNVQ6O8z
X-Gm-Gg: ASbGncsJm7/EVW5gUGHWGufFkqwjE16MYvgpKXNqEawZgmw10Q7ZIfPh0vyhoQCWq8v
	Q2bxF+nEoZQytRKeTi+pPLbp7EM1DLf0Pulc+bxHy3jEKtaIpHy0Rv+U0Eb/tNb879MgG/NDmbS
	Z/aNI30gwWIFhn5TJtv+Z9A5EqutIRWN9VHsBL57DZjLCR27lKL9hpGHItnrA5Qd9OoEKUpI6cg
	i3x3ih72SnsfJUpdlArf3QEj8Vl3wp3oR8g6w==
X-Google-Smtp-Source: AGHT+IFJLvFxh6Cj1EDVhy5GEJi7jwQTmD7bIFZI5RL+Eu8jhB1itNhMZdfzi4fnCqB1Sk/SsjQhxXaIpf58qI+KDks=
X-Received: by 2002:a17:903:f87:b0:235:e1fa:1fbc with SMTP id
 d9443c01a7336-23df69c05b2mr1076015ad.0.1752275099063; Fri, 11 Jul 2025
 16:04:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250703062641.3247-1-yan.y.zhao@intel.com> <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com> <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com> <aHEwT4X0RcfZzHlt@google.com>
 <20250711163440.kwjebnzd7zeb4bxt@amd.com> <68717342cfafc_37c14b294a6@iweiny-mobl.notmuch>
 <aHGWtsqr8c403nIj@google.com>
In-Reply-To: <aHGWtsqr8c403nIj@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 11 Jul 2025 16:04:46 -0700
X-Gm-Features: Ac12FXyee47OthrUwA6ohIyisIic2g-mdZCcRA0a9PdY6GqJGMDKM9zNg7Zgiy0
Message-ID: <CAGtprH8trSVcES50p6dFCMQ+2aY2YSDMOPW0C03iBN4tfvgaWQ@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from kvm_gmem_populate()
To: Sean Christopherson <seanjc@google.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	adrian.hunter@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@intel.com, binbin.wu@linux.intel.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, david@redhat.com, ackerleytng@google.com, 
	tabba@google.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2025 at 3:56=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Jul 11, 2025, Ira Weiny wrote:
> > Michael Roth wrote:
> > > For in-place conversion: the idea is that userspace will convert
> > > private->shared to update in-place, then immediately convert back
> > > shared->private;
> >
> > Why convert from private to shared and back to private?  Userspace whic=
h
> > knows about mmap and supports it should create shared pages, mmap, writ=
e
> > data, then convert to private.
>
> Dunno if there's a strong usecase for converting to shared *and* populati=
ng the
> data, but I also don't know that it's worth going out of our way to preve=
nt such
> behavior, at least not without a strong reason to do so.  E.g. if it allo=
wed for
> a cleaner implementation or better semantics, then by all means.  But I d=
on't
> think that's true here?  Though I haven't thought hard about this, so don=
't
> quote me on that. :-)

If this is a huge page backing, starting as shared will split all the
pages to 4K granularity upon allocation. To avoid splitting, userspace
can start with everything as private when working with hugepages and
then follow convert to shared -> populate -> convert to private as
needed.

>
> > Old userspace will create private and pass in a source pointer for the
> > initial data as it does today.
> >
> > Internally, the post_populate() callback only needs to know if the data=
 is
> > in place or coming from somewhere else (ie src !=3D NULL).
>
> I think there will be a third option: data needs to be zeroed, i.e. the !=
src &&
> !PRESERVED case.

