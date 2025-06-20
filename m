Return-Path: <kvm+bounces-50170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F4008AE23F0
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 23:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 971164A69AA
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 21:22:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B378A237165;
	Fri, 20 Jun 2025 21:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j7P5cShV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869BB1DF97D
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 21:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750454526; cv=none; b=eKPfT5n2nqXI6nFsOxgIBBOzZju9/aO9T+tl+4dJZxHgtJvZxXoYb6V2NuzzxxzM3bAjG6N/zYGbYdCYlIao80NTM1Hh0AjGNJPNkuQDc96rLMczw5+vYG+tPgORVTF5K8Hmk1ushf5t5yeQn9hYLm9nAcdwZBphFA8lM4233Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750454526; c=relaxed/simple;
	bh=L1ecn8Y9NOV83HEMfX3X19e8U2tPunQpsGM2rhiinNs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GWTTgb47IwqQa+z2tH09FSBIWsmsnoy4yaarCWgN6eOp/17+FHPjmJyMuikPinJSQr1yLSCX/z3oJV4XrlHyfnxZVnHouk/WgneA+o5/QfoHjpCBwhuKsuIHuof9LQaeMv+Zz++KfJxkmR3hAyX7KgVu7xdspMmujbVT1HZVCl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j7P5cShV; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2357c61cda7so14655ad.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 14:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750454525; x=1751059325; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kZ6fyBYRwb8NLMCE1iyqV7/OmIfJzXWHP/9vAp5jm8A=;
        b=j7P5cShVvbivwBQtDRjcF1ouVUI0aA9BFqEc6PkFGCRRVKJ2l+ChIE7b0gcrEPGrZs
         lAKSQvJlrwk7Xc/zSPvev0/vd0xas9zgVJdAX2+rCedtGMRsNnRVXyAAJtlq/wdTdmUd
         iZMduikgX0cXsa4+JTT2qkufzmk1xq1bXlStvjGKQTC9tjoElZz4rvXiqGa7xB27kzea
         yZxfM2c0VRcKJk/CGORJ66ey7uPUYuLHrW6d5+AEGLViF37MI5SrSbMp56P4zC7IZxEH
         +K07ArIarng3o73yMYqvis0ws9MnuuQVuLPX7IZPgboGkr0ppv6EbyjvNf1BThMyuSSM
         m2pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750454525; x=1751059325;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kZ6fyBYRwb8NLMCE1iyqV7/OmIfJzXWHP/9vAp5jm8A=;
        b=BOuX0wOI/NjmIZx8D+ou+UZ72SCOyjGukLUe29PT2Dq7liWd5f982+DTgrS1UUpINv
         mU1i+FGg/P0BHQud9oQmyrpWRAV97GKUhAQcgtSc83jSO0IInEWPLs1WFH/ZV39c8R2P
         1ZDOaKGoCNeNJGgJFwLBV8aztQoL6EbSduGAIMSB2bUS2AYdx3St+d2J0Z/EBL7JlgCn
         14RbnlFa5nYXEHHm9XkvCsDRAvmP0xVcWO9dLj/maMNgAhCGRX2ZCKQe4RFTaBHIb/0u
         PZTvuQQ09eMsNucN+tcLx6E28CxzP/fV1kV8xcfYqmlYn9fWJI6MX0uoUSTOMJr3cU/c
         YCKw==
X-Forwarded-Encrypted: i=1; AJvYcCWEW9PYcHY6KqTEuCbX8abTJYQ1pcCg/YlLNQ1uPYcmwDmPHEBIlL3vXVqRD6i39pXvl0Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0xqdr8A/xkknRBvHijsZxeBfpY6dNn+FP9tINcb+AvgbUuuYd
	x6wL33MfiWbfp1qNReWlS/YgqRqWUcgA5v5UZg1O12ooCxwzDKMW6j/rm8YGWekK0FOvIId2BOT
	wroOhMjAk+kxmc9oWJOPngnyTRIavXvQ14kcB+KbI
X-Gm-Gg: ASbGncvsajKC4CNRJ4A8ICOmfEZz8IROyTCuNHPsS/fM+YlYhVA5ABFtCazbCxPG24F
	Uv4TV3sFpBb1DWSr67JHi0JH4183ssFsswF9o+oGgi8KQo2CqvkIkiUHoM/cq5Qc0L/xRJ7R9mO
	np6jaDD6SwTasmS6sXcaNcTZcwQ+ZDSK8qzkAz8TC0C5VLYwZ5zC4VVa1Bo4HY2dJwagkHHW4H5
	Q==
X-Google-Smtp-Source: AGHT+IEhAijABev1ooBQkfRNbIkjNR/9RBhG89GC15CaC3tPY3bPJX4Y4pXZGCjBMtcu+SC/ixfrv8JPQEVVGpYgLC8=
X-Received: by 2002:a17:902:d4c2:b0:235:e8da:8e1 with SMTP id
 d9443c01a7336-237e481577amr762195ad.18.1750454524367; Fri, 20 Jun 2025
 14:22:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <20250611095158.19398-2-adrian.hunter@intel.com> <CAGtprH_cpbPLvW2rSc2o7BsYWYZKNR6QAEsA4X-X77=2A7s=yg@mail.gmail.com>
 <e86aa631-bedd-44b4-b95a-9e941d14b059@intel.com> <CAGtprH_PwNkZUUx5+SoZcCmXAqcgfFkzprfNRH8HY3wcOm+1eg@mail.gmail.com>
 <0df27aaf-51be-4003-b8a7-8e623075709e@intel.com> <aFNa7L74tjztduT-@google.com>
 <4b6918e4-adba-48b2-931c-4d428a2775fc@intel.com> <aFVvDh7tTTXhX13f@google.com>
 <1cbf706a7daa837bb755188cf42869c5424f4a18.camel@intel.com>
In-Reply-To: <1cbf706a7daa837bb755188cf42869c5424f4a18.camel@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 20 Jun 2025 14:21:52 -0700
X-Gm-Features: AX0GCFs9meOMY9_1Q9V3C3CdaLDIJcvn3mSwJRL8K7bYt2CzMsxYXXjpAvfDbXE
Message-ID: <CAGtprH8+iz1GqgPhH3g8jGA3yqjJXUF7qu6W6TOhv0stsa5Ohg@mail.gmail.com>
Subject: Re: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Hunter, Adrian" <adrian.hunter@intel.com>, "seanjc@google.com" <seanjc@google.com>, 
	"Gao, Chao" <chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>, 
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2025 at 11:59=E2=80=AFAM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Fri, 2025-06-20 at 07:24 -0700, Sean Christopherson wrote:
> > > The patch was tested with QEMU which AFAICT does not touch  memslots =
when
> > > shutting down.  Is there a reason to?
> >
> > In this case, the VMM process is not shutting down.  To emulate a reboo=
t, the
> > VMM destroys the VM, but reuses the guest_memfd files for the "new" VM.
> > Because guest_memfd takes a reference to "struct kvm", through memslot
> > bindings, memslots need to be manually destroyed so that all references=
 are
> > put and the VM is freed by the kernel.
>
> Sorry if I'm being dumb, but why does it do this? It saves freeing/alloca=
ting
> the guestmemfd pages? Or the in-place data gets reused somehow?

The goal is just to be able to reuse the same physical memory for the
next boot of the guest. Freeing and faulting-in the same amount of
memory is redundant and time-consuming for large VM sizes.

>
> The series Vishal linked has some kind of SEV state transfer thing. How i=
s it
> intended to work for TDX?

The series[1] unblocks intrahost-migration [2] and reboot usecases.

[1] https://lore.kernel.org/lkml/cover.1747368092.git.afranji@google.com/#t
[2] https://lore.kernel.org/lkml/cover.1749672978.git.afranji@google.com/#t

>
> >   E.g. otherwise multiple reboots would manifest as memory leakds and
> > eventually OOM the host.
>
> This is in the case of future guestmemfd functionality? Or today?

Intrahost-migration and guest reboot are important usecases for Google
to support guest VM lifecycles.

