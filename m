Return-Path: <kvm+bounces-53946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26A14B1AB46
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 01:10:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54D7D170BC6
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 23:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE4EC291C2E;
	Mon,  4 Aug 2025 23:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="emQpYAhD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179C5291C0F
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 23:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754349009; cv=none; b=eR6Ls32En5CvKFKGyrnzsALtCMOuW9R0ioQgzkrh6O3WsrbF6ZIVFF/5D2gf/cXLefDXvKtsO1yRGYzqJwdixkVaVocF+IPaVGKjfaUK3cTRyM8i/BWTE2k6VwmbtAy13nLIUceekfFg5Y4gIgPH8g04Y/nWOdoNt1urUVjE798=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754349009; c=relaxed/simple;
	bh=OqU7HKlaaB+/yr85e8O0qFFV2mhIIMzXHyes2/pyXiM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hYPv9/e8o7N5rvT2Un3nrzSFWalIqhA4GAtZm2VoZUVEk+2XoivQ4L4Rmiq6ygk8juwtBsSnzOoj11JXU5a4PEyiWHBtoHVA9stmgreo3fMBRPSBg/IJkiLzBQ7rLtqw/AP6kMR65sACBGsgbyJpYOn7bwx3bJF1F9UT6pnpQfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=emQpYAhD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA146C4CEFA
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 23:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754349008;
	bh=OqU7HKlaaB+/yr85e8O0qFFV2mhIIMzXHyes2/pyXiM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=emQpYAhD7UcEV34gva/+Tj2Gk9HQNqUdMMzPJsgGAVXqLM/GSpEW0RmrusIHZTWSQ
	 mEV05f0QR6bajRjLIlWSa4IZkibAVyg4gSoG1hESJs7QfWJCgW+96Fhmr1oQfTfwpl
	 nIHxlfFJvZrseS1hYf6Q3mjx8ENyoaIVdtOIGJqNpVL1n4lK0bFMm8V4jnzkU3vH/b
	 tLPlNK/xDGtMOmbSsd4E8WBwGr4Ke0RfftUuh7rvJZlwnP4K1Ju/4GTwr2NXN4YQri
	 iuNdj9ZHC2K+Angv3b50xnFEgKLlXyjSAR/TYKmgNbMrw2C3xzIYlYhcs3/lPMPl6x
	 gBj8HPi9LxthA==
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-458bf57a4e7so20255e9.1
        for <kvm@vger.kernel.org>; Mon, 04 Aug 2025 16:10:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXXzMsl6Kh6KNdSOxnGDOuOdgl6hafvSM5Wt9ewBeKdGhGAVtCHgU0WPV/Pzzqpy1ov0ag=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmDyuhphTyMvGs2w5deA8YVn+Efz/9Fp4BgwF5U7vBQLzLJYdy
	KBsPpAk4MAlU0kRoUz5vMvm+QEzDmB40x9S+XOue4z7qCenbJe16JLB4Vtb/BGmmyCDLtRU4mLM
	KGFymSk3UjIYO5B6v7bCQ6W9KxVCKPEBVEdntnQ1R
X-Google-Smtp-Source: AGHT+IHKpk+HdsX+UkmoGsNTrjTyAvv+GZeP3pJG7v7GzWXQDB8HcuYU8JvYjjZGY3fLVdxWGYKFXeKl60hxqHiBoUI=
X-Received: by 2002:a05:600c:3b8c:b0:43d:409c:6142 with SMTP id
 5b1f17b1804b1-459e13212bamr553835e9.0.1754349006808; Mon, 04 Aug 2025
 16:10:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALzav=d_Bjfy=6if+rPmxgGJfUV8ijnQ5hf40HoH6Yozg_H6Ew@mail.gmail.com>
In-Reply-To: <CALzav=d_Bjfy=6if+rPmxgGJfUV8ijnQ5hf40HoH6Yozg_H6Ew@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 4 Aug 2025 16:09:54 -0700
X-Gmail-Original-Message-ID: <CAF8kJuP09jvpB--fLy6Ju6rRuKFS5r8vyq1ne7ragbv0suWzLQ@mail.gmail.com>
X-Gm-Features: Ac12FXy7avNazRoYmbC_NeBMrj_2tPBaCG8ggpo_BqxQQnqN6_SKMsJk-VIeXn4
Message-ID: <CAF8kJuP09jvpB--fLy6Ju6rRuKFS5r8vyq1ne7ragbv0suWzLQ@mail.gmail.com>
Subject: Re: Live Update MC (LPC): Call for Presentations
To: David Matlack <dmatlack@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>, kexec@lists.infradead.org, 
	Linux MM Mailing List <linux-mm@kvack.org>, linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>, 
	"pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>, David Rientjes <rientjes@google.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Vipin Sharma <vipinsh@google.com>, Josh Hilke <jrhilke@google.com>, 
	Changyuan Lyu <changyuanl@google.com>, "graf@amazon.com" <graf@amazon.com>, 
	"dwmw2@infradead.org" <dwmw2@infradead.org>, "jgowans@amazon.com" <jgowans@amazon.com>, 
	"ptyadav@amazon.de" <ptyadav@amazon.de>, "jgg@nvidia.com" <jgg@nvidia.com>, "rppt@kernel.org" <rppt@kernel.org>, 
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
	Leon Romanovsky <leonro@nvidia.com>, William Tu US <witu@nvidia.com>, 
	"anthony.yznaga@oracle.com" <anthony.yznaga@oracle.com>, dave.hansen@intel.com, 
	David Hildenbrand <david@redhat.com>, Frank van der Linden <fvdl@google.com>, jork.loeser@microsoft.com, 
	Junaid Shahid <junaids@google.com>, pankaj.gupta.linux@gmail.com, 
	Pratyush Yadav <pratyush@kernel.org>, kpraveen.lkml@gmail.com, 
	Vishal Annapurve <vannapurve@google.com>, Steve Sistare <steven.sistare@oracle.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David,

Thanks for organizing this.

On Fri, Aug 1, 2025 at 8:33=E2=80=AFAM David Matlack <dmatlack@google.com> =
wrote:
> Topics to be discussed at the microconference include:
>   - Live Update Orchestrator (state machine, userspace API, implementatio=
n)
>   - Generic infrastructure for preserving file descriptors across Live Up=
dates
>   - Live Update support for specific files (memfd, iommufd, VFIO cdev, et=
c.)
>   - Integration of Live Update with the PCI subsystem and Linux device mo=
del

I will submit a topic proposal for the Live Update with PCI subsystems.
The PCI RFC V1 discussion thread is here:
https://lore.kernel.org/lkml/20250728-luo-pci-v1-0-955b078dd653@kernel.org

Thanks

Chris

