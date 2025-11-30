Return-Path: <kvm+bounces-64962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8059CC94A1E
	for <lists+kvm@lfdr.de>; Sun, 30 Nov 2025 02:21:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 64099346A63
	for <lists+kvm@lfdr.de>; Sun, 30 Nov 2025 01:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA652223702;
	Sun, 30 Nov 2025 01:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="VqWJ3r3O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBE21E5B95
	for <kvm@vger.kernel.org>; Sun, 30 Nov 2025 01:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764465674; cv=none; b=iPfDMZ3AZs2w4rnWJTA89d/52Bzhj60rt3JLFfX+jtyxBdwoUlkicHDJyJMbRrF5C3krtm4OK+DtGgerP9r1+biBoaOM11AyXUISOKM+JgPfp6YtlwTBT2EIqa4EG+T+tAAv+pxVfbkG/vN6NDgzsBpMDwj9VIWDjpK5eIRjagc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764465674; c=relaxed/simple;
	bh=jAhYjdaKuYSZjBr3rUm2bCg6GZ1D33HJLbxkB+qPEuk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gR45Mukot/F/BKweqsNH8L56d6YrdSo4deLkqp5HW2SUjhw2PIPE3L0/U2HQXM0TMOsNhgdnjr91r9iYnaflGbq0uJd25GhUyU4045U96OyxeAGG7xnkb1kqzD7GTkcEhMC0yRcIqbKEgLnpFA1EkaMMgOHXa93S3mav85bJiV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=VqWJ3r3O; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-640c6577120so5473342a12.1
        for <kvm@vger.kernel.org>; Sat, 29 Nov 2025 17:21:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764465671; x=1765070471; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7E6fYjyrHrj8FHDr7BSv9EzmTP9fSPz38dXVeQSmbss=;
        b=VqWJ3r3OV199kgmWWd4B68VywP+BhnnLiCdocCvjXG/gnMFSD1bFiG9jS8tN2BbW9h
         THrqDBGcJM9nMdqoLNvq93kNR2dLFXodP7TjzVU8p9fTvWnnirrJVk5/UWwwFNNr8NNV
         FUvsTCSuTi4WvObu+0T60al3CGnp72BoAcH7r75sxqYhYkcp9CDj59Avb9B/j6NqiZXv
         H4igEIDZGOK55pCcFF5DdXe0ZzGKZov9SnCru8TRent00f++6DyDBB/IYwgFc6lYispX
         cacaasgXhnR1GkCFZpWbC8w/YItucwEw3qeYBtel1nsAxs2h1mZbiMb3KB7hov90GvHL
         sdCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764465671; x=1765070471;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7E6fYjyrHrj8FHDr7BSv9EzmTP9fSPz38dXVeQSmbss=;
        b=gBOPta2do0YOzsCzbjiZP/ifEKT2M2+TY8Shkk3gyRrKhnPVdRC8v0Bapm0PW2iMga
         1tbFElhJ+kB5tusAtuYFcvNu3KjTGNxudcj1wjspC1AT8HOeDJUo2jL40NAirx8hsEy4
         SFpgX14E4mLEAHn785QbCjQ3+Piy4APGMH+XyPbgqO1bnLXoFozn9VXhw5eeTH1wLUV9
         Dy01fGGg9GkwGQ+6T6cAigQzUtxb5jRSumRLDVXGJ/UgOg1b0yXQejGw4T6Cn3vwhp3A
         Mp0PBXQp+DdlpVoUeDL+Z+Zvr94pKSFvaDg+Av+PINbcq4EMdNzRNqMxJ/pZfuvp2zN6
         Hm1g==
X-Forwarded-Encrypted: i=1; AJvYcCXV7WtAEUEHrzF5TiiBjVN5c/S/iu3G8T0nFNwyuF52makKNqWdwIfnmtGF9Dyo2EvnjVA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxM48aidWAz1iXHj9sfjavv6dEST+zpQNHxAy2ihHX+CJf2eh5P
	OUZfWmNJBRB+RnPi1e6cgWHKpKct39iOmENuTKTejs6QLXLJWra5EhWLgvw5rF9xwxMvrHGootU
	dsE1h47tcvXCNjvGlerbto6/WaHDe0UC1Fio5tz8yng==
X-Gm-Gg: ASbGncu/f4yAhbi33xNx9Gd9wsMbmgckPx7iM7auZ8St3IT/ftIrEyVRkoyl1N3dnPk
	Dosbg6NIFP/OyCH5kdwcenFOigaFe922l7TgOWXjAKtQNzhX0DSkuG1MrYnTIRgAUmyIp4/Q7kP
	vuMqj7y5UzpgtDOj0Aq7A//cPI9hW+NtzRiAfj1NCCF9huBtFKKsnRqUwa+GL18owrjpHOIUOCQ
	AZw3y+zoZGwriv6FzxHyM9XeKQ92KwMNns45qcfhVyc1G7RFGRdILBCVhdEzLcr3xvL
X-Google-Smtp-Source: AGHT+IEVrWVW0MSDEofN7HKOGJ5FYge7stDIhKBoTb11CcnSv0VSQnPuBhKj+NsQY8Xozbru60feKYwF32lJK34nCfo=
X-Received: by 2002:a05:6402:1ed6:b0:640:9aed:6ab6 with SMTP id
 4fb4d7f45d1cf-6455468d38amr27395965a12.24.1764465671412; Sat, 29 Nov 2025
 17:21:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251126193608.2678510-1-dmatlack@google.com> <20251126193608.2678510-3-dmatlack@google.com>
 <aSrMSRd8RJn2IKF4@wunner.de> <20251130005113.GB760268@nvidia.com>
In-Reply-To: <20251130005113.GB760268@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 29 Nov 2025 20:20:34 -0500
X-Gm-Features: AWmQ_bn87weFbkyc-Mkm1TN7PwvGfMaEQTTGstPfXUIJUeSyXtPiICJqz9kg5cs
Message-ID: <CA+CK2bB0V9jdmrcNjgsmWHmSFQpSpxdVahf1pb3Bz2WA3rKcng@mail.gmail.com>
Subject: Re: [PATCH 02/21] PCI: Add API to track PCI devices preserved across
 Live Update
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Lukas Wunner <lukas@wunner.de>, David Matlack <dmatlack@google.com>, 
	Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Philipp Stanner <pstanner@redhat.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>, Yunxiang Li <Yunxiang.Li@amd.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 29, 2025 at 7:51=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Sat, Nov 29, 2025 at 11:34:49AM +0100, Lukas Wunner wrote:
> > On Wed, Nov 26, 2025 at 07:35:49PM +0000, David Matlack wrote:
> > > Add an API to enable the PCI subsystem to track all devices that are
> > > preserved across a Live Update, including both incoming devices (pass=
ed
> > > from the previous kernel) and outgoing devices (passed to the next
> > > kernel).
> > >
> > > Use PCI segment number and BDF to keep track of devices across Live
> > > Update. This means the kernel must keep both identifiers constant acr=
oss
> > > a Live Update for any preserved device.
> >
> > While bus numbers will *usually* stay the same across next and previous
> > kernel, there are exceptions.  E.g. if "pci=3Dassign-busses" is specifi=
ed
> > on the command line, the kernel will re-assign bus numbers on every boo=
t.
>
> Stuff like this has to be disabled for this live update stuff, if the
> bus numbers are changed it will break the active use of the iommu
> across the kexec.
>
> So while what you say is all technically true, I'm not sure this is
> necessary.

I agree. However, Lukas's comment made me wonder about the future: if
we eventually need to preserve non-PCI devices (like a TPM), should we
be designing a common identification mechanism for all buses now? Or
should we settle on BDF for PCI and invent stable identifiers for
other bus types as they become necessary?

Pasha

>
> Jason

