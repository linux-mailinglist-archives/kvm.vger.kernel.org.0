Return-Path: <kvm+bounces-65039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B5FFBC9929C
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 22:24:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 382CF4E252D
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 21:24:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A7052857C1;
	Mon,  1 Dec 2025 21:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="g0Yxkxxs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB7E26ED3C
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 21:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764624251; cv=none; b=tDYzAnfhEShPJvkStpyzfkKSTjx/5oVsgH9thGbJ1+VZDcsHAQfvwTXNFbfEUCgNbcBIEwokTetnTVejPC4sedlrf3IO0pZuy7YKUPlaSgmrPhzFMDiqDRiBsnFpcjSXOGas/kJRHIGgWh4I5jKHLqSNRv22o49QSTdZmdogGbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764624251; c=relaxed/simple;
	bh=ln5wNWpHTn3H9RwBkqx9ySDRrrsIdw5euLJlNNUsTlI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RbdokEOgHk9hED3qTrDgybnMvQlrUdh7DQjTXNG0teHJKkbpbHUMtJvxj/t+yliEt3HLTc4bORZ+7GJUiF00pPIkfGgEwSg/Brjgo5+P2Zmfogxm//zAm7lxZilWdcj1llq1Rzf1uzUQLjcZ5uRmYpJBzz3laSeWktco2jABrPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=g0Yxkxxs; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-640d0ec9651so8530409a12.3
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 13:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764624247; x=1765229047; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ETxYZOaz/IzhpPshEhME5tTv05ds127GQfjyQ3ieK7Q=;
        b=g0YxkxxsPGFg7HTxz60AuOtxMPQk4L88I1KfFMDQhbR9o9zf3bWVNRPVmhzxln5IB6
         pWn7TO3MYfFXYociE/xOmmubSOZqU6P/NbN+t0iUDI9CTrfHKYvFq/T6gfcGfUZOMjWC
         xMq6D2b2X6luKMDpSA0msEHq4XeDj/1MoBD7MVPsIGHmiLgloDYom0GUmyd1SRFYq2r9
         PuZoLnCpxoofL3KyFWagEpMqBnmpgYn2GS++SKTpnLne0BsucuWkinkg8BkJ537Y/qb9
         dz8BjX0ObVNQAifJc/E+0X9oS75dKwVOIH3dQT1sN25zgPcqcetVIYYwBN5f20R0QneP
         Hqtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764624247; x=1765229047;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ETxYZOaz/IzhpPshEhME5tTv05ds127GQfjyQ3ieK7Q=;
        b=V+TB5Xx58zokpfNn0zVzgtdtBH2nYDEvbwcCg3gueAln5c0F39mtrYBi7BThshkwah
         mOdnqLgG4gZyqOXHZsMs1ozXABzZ3VCMi6ipu9cRruG/DxhDb7fomTBu+hryVXIQBmyk
         OutwSof7Kd0B780gCb3vZV5ETvpyZRgHnOZubxu+31SSx17fU5YpR+7G3wNqeyLa20Au
         Ome2am2JlJVjjN+Gixs/lx5jay4hWyqt4rR9n5gY79p026sjj83qrn0FBbkyRvOOIGP+
         +GO+Kz5tZMGQv+0csyuWXS68Lf5qVrPgQCm/Hw0ad4P6X0/1sO2TshmfBVBtlWtP9RIr
         mqog==
X-Forwarded-Encrypted: i=1; AJvYcCWlXNeDrN/JxDIcxFV6vJ3EX/vomozlevv+O01mVvEvFofn7CYL8vSpBS53RTsGSBS2jgY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfmsxRgt7WgL7yGbtW+KRXBwiuLyzf4FILdxBPE/GK26AfI15H
	IPu4s7yPsezwXUgSDthFFygGNNhe2In5mZ0PuSjFz5PYINFKJOykMr5YSvKlV0aw3hQ76SxNezs
	kNxU8cnZRO6+wLGR+ZYr8ZuHrfKV15EwfIOKEogW8YQ==
X-Gm-Gg: ASbGncvbPNRnitsszmU/FgNk1nNW60c9sokTKYDkYAmGVKSu/hReHttAyJT1jwVeBor
	mTxqJ4jscdZzJyKTynfUQY3UD8OuL78g64swt3dVSw4rLIyQFanRqBPxOFWgnh7Qb2K7q1DZb+q
	QoA9bodsViKgTlegK+d1eyQvDt4Dffg1bYuh02bXeq5fIRpYECsE31GEZfb5Anhh9vn4ffP56sB
	OORZ0neHN6Pxha6RxPjslZmVnI97rdK4bKgv8bMyU7jlEZSQCa5dZQIQSmn/1QEfb1I
X-Google-Smtp-Source: AGHT+IGFmD8UGhvwVz/ALKYl2Vqr8MMf5LymJb8h0gfktk5aDUx02efW3ArSDon17TXEAazw7a0Mll9J5TqwU2EM+ws=
X-Received: by 2002:a05:6402:534c:10b0:645:d47e:8f7a with SMTP id
 4fb4d7f45d1cf-645d47e8fe8mr23465913a12.22.1764624246579; Mon, 01 Dec 2025
 13:24:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251126193608.2678510-1-dmatlack@google.com> <20251126193608.2678510-3-dmatlack@google.com>
 <aSrMSRd8RJn2IKF4@wunner.de> <20251130005113.GB760268@nvidia.com>
 <CA+CK2bB0V9jdmrcNjgsmWHmSFQpSpxdVahf1pb3Bz2WA3rKcng@mail.gmail.com> <20251201132934.GA1075897@nvidia.com>
In-Reply-To: <20251201132934.GA1075897@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 1 Dec 2025 16:23:30 -0500
X-Gm-Features: AWmQ_bmxHnCVLo33sDnTMLxEXgIDkbIKoIGuYD5rhu8r0H_vMp9ExFTf2cbCTP8
Message-ID: <CA+CK2bAMTwxGLK4_ayvkgEMEmr2WmqPe7KSjhZzdz7fuTp2naA@mail.gmail.com>
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

> > > So while what you say is all technically true, I'm not sure this is
> > > necessary.
> >
> > I agree. However, Lukas's comment made me wonder about the future: if
> > we eventually need to preserve non-PCI devices (like a TPM), should we
> > be designing a common identification mechanism for all buses now? Or
> > should we settle on BDF for PCI and invent stable identifiers for
> > other bus types as they become necessary?
>
> Well, at least PCI subsystem should use BDF..

BDF must be stable for PCI live update to work correctly.

> You are probably right that the matching of preserved data to a struct
> device should be more general though.

Right, we need a mechanism to ensure early in boot that any preserved
device does not auto-bind to a driver later in boot.

Using the UEFI Device Path format seems like a good way not to
re-invent something that already exists.  For example, while a
preserved PCI device looks like this:
Acpi(PNP0A03,0)/Pci(1E|0)/Pci(0|0) (Luka's example)

We can seamlessly support other device types later using their native
paths without changing the identification schema:

TPM: Acpi(PNP0C31,0)
IPMI/BMC: Acpi(PNP0A03,0)/Pci(1F|0)/BMC(1,0xCA2)
NVMe (PCI-attached): Acpi(PNP0A03,0)/Pci(1C|0)/Pci(0|0)/NVMe(1,00-00-...)
etc...

Pasha

