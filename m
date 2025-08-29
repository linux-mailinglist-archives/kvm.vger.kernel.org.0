Return-Path: <kvm+bounces-56273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FB78B3B854
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 12:11:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22DFC560B7D
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 10:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22CBE3081CA;
	Fri, 29 Aug 2025 10:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZRSLwtKG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE79283FD4;
	Fri, 29 Aug 2025 10:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756462305; cv=none; b=sptEQ4QGcSHGp2Q/BV4Gn2Q8MExrRRfzb204D+xPQTjZgfAIlpITkYUKHEPGcEqCF9BEA/iyswMgtgNLYflIXNCONhXTNPkyE89q9wewth/O2pXB7x8KDqxAa0n2/h60v62qY18gNxpQze28Dz30Tkn9mLDMnbzZuauJ6dEp/HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756462305; c=relaxed/simple;
	bh=FbHnT1pSAarBPsl/XNUda0xi/a2rwYH4RSBoQabCgLk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=npEEIjO32hYxtPa6Odp33Yk7q2eMb3yENkV00ijXp2MGfFAlRn1QmZ+WPnN3DYoUOVUBsg5PpfULjfrsMQbcWMZuFdW3zgyyofNM6H/NjtlE8OtdQcmbAobAdL0hgAIOYfqQFEoBIXoRGxPLdrzRuWq4Ur0/W1Gmbuy7Y/Suzkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZRSLwtKG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D30C4AF0B;
	Fri, 29 Aug 2025 10:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756462304;
	bh=FbHnT1pSAarBPsl/XNUda0xi/a2rwYH4RSBoQabCgLk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZRSLwtKGO9ClcpknRoRIahqDP933GHw0YbQD9S2nv8O0g5hlKfM9eWt/Vnbb6aWdF
	 1JRo45N2T1YuqvcXpI/nQGPBZr8R7DBJOcN4jjoN7e+3uj1MOjGJ2Mn6JlRjcn3i5P
	 NOeAvqlZIRCJ72qQI1YNXnvqeo9djWyLQPbJXFbn7C+Ho9OdeKK08X+Kj8OpV8C2DC
	 s6Ckoa59nPAYEqkFqILLfTwzwDIHnmzVKxtsBjJowDalr8YX0tJce0qocORyqyCfH/
	 8oAZwUzCX4P9LRWgrt2oDp8xXL++s9L3y/9/uOipG/F/83wAopPaxXNbMSJbc91WZq
	 lBMBoMJmoiKSw==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afeceee8bb1so280012966b.3;
        Fri, 29 Aug 2025 03:11:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWjH/HHNbzHlTPFTZMgHLKRiRQ+OQL9XYapqABZgeK5R6HJbAvgQT8b0RTiaFQZrIv9jHw=@vger.kernel.org, AJvYcCXolltN+TSQnIZEX4pB4vmkmQdd2xArcSYOdPw51dsZ84lTrm8U96XQL1KdsmfISZd9D1W0+59v/QTmDM2D@vger.kernel.org
X-Gm-Message-State: AOJu0YywXwPymEkkOd2GroKvoMKIWirepDd54HARKPZTvehMHbifmBFX
	L2CG5k16Lxw55kUegrI1n88OuTY1iJOp/ogsFZlRRVKUzyWywgXqNd0N6lnvLShyiNwEobG6UU2
	de6Sz7YTJxUeolYR69a2j4kwJlW3wHts=
X-Google-Smtp-Source: AGHT+IEuFBM+fnBwAq9cHUwyqSmBhaIa6eT1rK/PNNADm1oua3EpORtiyPFhiVibwBNqttI0n2E16ikqA+FTFiZq/UE=
X-Received: by 2002:a17:907:3c92:b0:af9:2e2a:64a8 with SMTP id
 a640c23a62f3a-afe28fefe4fmr2492394266b.25.1756462303488; Fri, 29 Aug 2025
 03:11:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250815022621.508174-1-maobibo@loongson.cn> <CAAhV-H4Sem=X7KUiO2vQgT_5KX-v4Xv3yB+UUrWHL4tmRnJkGQ@mail.gmail.com>
In-Reply-To: <CAAhV-H4Sem=X7KUiO2vQgT_5KX-v4Xv3yB+UUrWHL4tmRnJkGQ@mail.gmail.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 29 Aug 2025 18:11:31 +0800
X-Gmail-Original-Message-ID: <CAAhV-H50tbHigNGGt=zFSgDLvWLcPTOvN=s3mjquxfL9nLU5Eg@mail.gmail.com>
X-Gm-Features: Ac12FXzXsYWIn_ywhKBu7qnpjROgk2UkmU7zUdTYk4zrnqWGrCB-YgibSKIPmZ4
Message-ID: <CAAhV-H50tbHigNGGt=zFSgDLvWLcPTOvN=s3mjquxfL9nLU5Eg@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] LoongArch: KVM: Small enhancements about IPI and LBT
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 17, 2025 at 11:45=E2=80=AFAM Huacai Chen <chenhuacai@kernel.org=
> wrote:
>
> Patch-1 and Patch-4 are applied for loongarch-fixes.
The rest are applied for loongarch-kvm.


Huacai

>
> Huacai
>
> On Fri, Aug 15, 2025 at 10:26=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> w=
rote:
> >
> > Thre are some small enhancement about IPI emulation and LBT enabling in
> > LoongArch KVM. With IPI, it supports sending command to vCPU itself. An=
d
> > with LBT it adds flag checking int function kvm_own_lbt() and make it
> > robust.
> >
> > ---
> > v2 ... v3:
> >   1. Fix stack protector issue in send_ipi_data()
> >
> > v1 ... v2:
> >   1. Add sending IPI command to vCPU itself
> >   2. Avoid duplicated LBT enabling in kvm_own_lbt()
> > ---
> > Bibo Mao (4):
> >   LoongArch: KVM: Fix stack protector issue in send_ipi_data()
> >   LoongArch: KVM: Access mailbox directly in mail_send()
> >   LoongArch: KVM: Add implementation with IOCSR_IPI_SET
> >   LoongArch: KVM: Make function kvm_own_lbt() robust
> >
> >  arch/loongarch/kvm/intc/ipi.c | 57 ++++++++++++++++++++++-------------
> >  arch/loongarch/kvm/vcpu.c     |  8 +++--
> >  2 files changed, 41 insertions(+), 24 deletions(-)
> >
> >
> > base-commit: dfc0f6373094dd88e1eaf76c44f2ff01b65db851
> > --
> > 2.39.3
> >

