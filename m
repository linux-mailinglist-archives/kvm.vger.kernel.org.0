Return-Path: <kvm+bounces-23893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63C7D94F9CE
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:48:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 220B628269E
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:48:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72C68199EBB;
	Mon, 12 Aug 2024 22:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B3e9Otvq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374271684A6
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 22:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502891; cv=none; b=musVuOp4vd2tWMQwL1PFVOMBR9jiKIb7Nase9HRzsqGNqPyHyDwkvAo+aYP0VTGAh+lrlIjQgjnqBfWiBOAq6lWhovmhIIES6B6dusvSj2cOoCNFKQr9fTi1TFBnsaQg3TdTxovbg18FTd0EDwQSzMMuszl/LBx4UHKWbiVKy2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502891; c=relaxed/simple;
	bh=R/SzWoRe45bI0KnM666t5204D4AGqvGVrG5MhvDeytE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=any64W/v/zM/hgHS/SkX2cx3kri/BlWY1LNjp04+nGxL71tCg/MuLnJBamb3fBLmNQB2ItsUs2jOpfA3GE1ZzsFNC50wzxze2hEsM66fAZ5dSKmOjXRBQAeh76LHDC5/2xevhifonkMy7mNtEH2U3FZXBEl6BkxDKRzGfJ1sfI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B3e9Otvq; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-823227e7572so3592330241.1
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 15:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723502889; x=1724107689; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iqzIydDvM83GWgkkK53ycdV9UVExKvfGUU1et7okzOc=;
        b=B3e9Otvq78SRxi+BgJy/5uOGKIfd/5icUnpirWGhMpNBLtqJNk5vTeIZ7E3PAW9Ncg
         Che633g9KTiM7Isd2nG2thFKrs7UClCm2EsPbBkXialfz3H2IvrQv210qzDdpXREthzP
         a8bJc5ySW2rmGIgbZtbxyggCci9geYXE/lRRHC1NX/nUGbmvd3jGJrkZZMiMW/d8gUaM
         3TjutlxR19AZ1e1DHsT4jnvU+zzJjuzENL0daoWRCGyum7RD91WOMjalxwQb5WuPb8ja
         V6ovOHGYww0SyxW7QGpHoBO8qUMeD348gtM6/DsmI96FPVteC2dWMNb6cZj3thDLD/77
         IRPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723502889; x=1724107689;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iqzIydDvM83GWgkkK53ycdV9UVExKvfGUU1et7okzOc=;
        b=OwCuXWlPYRs2nJtRQqMxJTua56LZDXmV79Y3e5z8zGUbgVE9/e72oGZWife+7u9pN7
         o1SZwbEK6CEnEU0fxdWg23uL6wmkpFcbpSmvlulyEUP/96vhn678xRoDCYLBImwCckKD
         9tJf3Tgrd287hn6qfdadtaz6P4hSSAdQ97ylm/asfrVdmV6nh9WxPbhTfpwH06UMUqqO
         csXS9eXpEizpEQdTev+gTXWWPgVCO72d7jHmG33zjwPuZPmn6sQD4o0g62j3Fyz/K3QR
         XCNubq8aipbjNUQKEFtrj+H9fAYGHYIfkFvXk9CJ5uZJwz1pktPfoctkfXWu7iuUWLQP
         PAAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXZcvhnPL9w3tTRP6bXYSU/0gnDMNN2HtEeNb28khE+56ujeGO5PYqvg1sHYHwsk4CCC0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7tIFtzN+IgXBRsxtFe49eeSkWvz2zUduJry5ez2Up+Vxt87FS
	JDDO/wRsQHAJUv5nGToiT5/RDG4G8y6wZi7g8uUAo73Xs+TD/unbrrGxlGfxG0wCPmWAJzcUFgE
	jUIg3zTZkzt9nI1md3nBlvjL8659fWD341qLA
X-Google-Smtp-Source: AGHT+IH1ieRG4WsuTUYg5Y6Zh8hdQ8R2Ck4XKoO4go5pHVzLgtexTSUHK7iSce0042CDI9++0CPCZrUohxRDky7+UQw=
X-Received: by 2002:a05:6102:32c6:b0:492:9e70:ef2b with SMTP id
 ada2fe7eead31-49746d0d86cmr800646137.1.1723502888923; Mon, 12 Aug 2024
 15:48:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809160909.1023470-1-peterx@redhat.com> <20240809160909.1023470-11-peterx@redhat.com>
 <CAJHvVciF4riGPQBhyBwNeSWHq8m+7Zag7ewEWgLJk=VsaqKNPQ@mail.gmail.com> <ZrpbP9Ow9EcpQtCF@x1n>
In-Reply-To: <ZrpbP9Ow9EcpQtCF@x1n>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Mon, 12 Aug 2024 15:47:29 -0700
Message-ID: <CAJHvVchObsUVW2QFroA8pexyXUgKR178knLoaEacMTL6iLoHNQ@mail.gmail.com>
Subject: Re: [PATCH 10/19] KVM: Use follow_pfnmap API
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Oscar Salvador <osalvador@suse.de>, Jason Gunthorpe <jgg@nvidia.com>, 
	linux-arm-kernel@lists.infradead.org, x86@kernel.org, 
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>, 
	Alistair Popple <apopple@nvidia.com>, Borislav Petkov <bp@alien8.de>, David Hildenbrand <david@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 12, 2024 at 11:58=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote=
:
>
> On Fri, Aug 09, 2024 at 10:23:20AM -0700, Axel Rasmussen wrote:
> > On Fri, Aug 9, 2024 at 9:09=E2=80=AFAM Peter Xu <peterx@redhat.com> wro=
te:
> > >
> > > Use the new pfnmap API to allow huge MMIO mappings for VMs.  The rest=
 work
> > > is done perfectly on the other side (host_pfn_mapping_level()).
> >
> > I don't think it has to be done in this series, but a future
> > optimization to consider is having follow_pfnmap just tell the caller
> > about the mapping level directly. It already found this information as
> > part of its walk. I think there's a possibility to simplify KVM /
> > avoid it having to do its own walk again later.
>
> AFAIU pfnmap isn't special in this case, as we do the "walk pgtable twice=
"
> idea also to a generic page here, so probably not directly relevant to th=
is
> patch alone.
>
> But I agree with you, sounds like something we can consider trying.  I
> would be curious on whether the perf difference would be measurable in th=
is
> specific case, though.  I mean, this first walk will heat up all the
> things, so I'd expect the 2nd walk (which is lockless) later be pretty fa=
st
> normally.

Agreed, the main benefit is probably just code simplification.

>
> Thanks,
>
> --
> Peter Xu
>

