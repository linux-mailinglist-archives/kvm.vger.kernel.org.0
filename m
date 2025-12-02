Return-Path: <kvm+bounces-65157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 06832C9C3C4
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 17:37:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8BB843488B7
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 16:37:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C4E92BD5BF;
	Tue,  2 Dec 2025 16:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LzvHQtrI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2D8287508
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 16:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764693425; cv=none; b=LtEBXjslR/MCoP6695KSCFPsV9N6aQOXKhl4lHwLtgfAliMUlNWNaqOA0Lp9lkzBzeQmkedZx8K7pOiNdyLnR7GRAVN6BPuierGkKMv1I6+2NS4bSA6CTm/F4kMXp2Orb/XVgn2YceMMiZGGpGYJ6io+M9vVK8gBmubCLL0o1qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764693425; c=relaxed/simple;
	bh=137moXo8s/LmN37PzrzHz3oClS2z0BOI660OGTmkq9M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lgWa4xlUC5B57B4sjiGysP41h02//dWsFG6Kvx62dXiWxAk/lME0pAw0L/uYVMEIdVW8YJlFP342VoaEl1ZUFG/YyPEjFmrSMWr3d4zrVHXYtBnO22v5ss4Ooa/fCto1hOINgS3uaTDsEkbvWPKoywcnOgRU3b/Z9q1Hjjuu1kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LzvHQtrI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B949C2BCB3
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 16:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764693425;
	bh=137moXo8s/LmN37PzrzHz3oClS2z0BOI660OGTmkq9M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LzvHQtrIyyQfQV/Iz3CjgyT9gqMZbEwDW/p2zvN92TmwugOpF/UP/oCUx+BIz0x8M
	 AcKdqicqIDA+6DF9PkwOZq/79oBW9osyNJg74lj6W8XtHToYS1yk9EYLwP6hmEvoz9
	 qIc99FiYIcLiMj7Yp0ONQICl9DJ3JUm0JrdVAe9QxMIna4rtPNU2S1800YJcoo1z83
	 EilHSPemzCQOgxNj1wvUgzdin8qQIZ6dLqQCd9U5BSokzKTP9I2+f78+GzM5HRI9Ke
	 /bt1PydAxkPqKhSmR212BcdFhdFVU2pwzbHCuuumYp1gqJD4PyvLMpKBm2b2Qs8mdM
	 GOtmtlm8SjisQ==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-787eb2d8663so186447b3.0
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 08:37:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXRodVP/VGQYUkD/ITHzwvhhM8Kysg5K4jPWr5jXUhdChNQWMyL5RGMbpR6KW1xpJKZaCc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yysc6F9ug/ga0QV7GvtvcTl6ESYpTlzUc2j7ddAFElCtZ6F1jcM
	02J+2DTZgVnJv7BlUQUImbPJ4GprSXyiOqMKi0c3586+wOyCRORKfX+urk9D6rz9PyfLR49FPmg
	myeuWl5zxc6bcPMNJAg4D9O1FOrgESONpwuskF7iOMw==
X-Google-Smtp-Source: AGHT+IGBjNPjFljsTlPxo4WA2SJdBNwTPxDeLBltGjpOxyikR+XugUL9DT8xEhxT2+IgiyRotcSK36cErNv3/7fdio8=
X-Received: by 2002:a05:690e:1349:b0:63c:f5a6:f308 with SMTP id
 956f58d0204a3-6442f1af559mr2807207d50.31.1764693424538; Tue, 02 Dec 2025
 08:37:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251126193608.2678510-1-dmatlack@google.com> <20251126193608.2678510-3-dmatlack@google.com>
 <aSrMSRd8RJn2IKF4@wunner.de> <20251130005113.GB760268@nvidia.com>
 <CA+CK2bB0V9jdmrcNjgsmWHmSFQpSpxdVahf1pb3Bz2WA3rKcng@mail.gmail.com>
 <20251201132934.GA1075897@nvidia.com> <aS3kUwlVV_WGT66w@google.com>
 <aS6FJz0725VRLF00@wunner.de> <20251202145925.GC1075897@nvidia.com>
In-Reply-To: <20251202145925.GC1075897@nvidia.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 2 Dec 2025 20:36:53 +0400
X-Gmail-Original-Message-ID: <CACePvbVDqc+DN+=9m1qScw6vYEMYbLvfBPwFVsZwMhd71Db2=A@mail.gmail.com>
X-Gm-Features: AWmQ_bnbbe-i2loCjPCRmFKkZMkrwcLJ0pPNoTuT2OJK0ymAFbAsS-FLNs74Umc
Message-ID: <CACePvbVDqc+DN+=9m1qScw6vYEMYbLvfBPwFVsZwMhd71Db2=A@mail.gmail.com>
Subject: Re: [PATCH 02/21] PCI: Add API to track PCI devices preserved across
 Live Update
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Lukas Wunner <lukas@wunner.de>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alex Williamson <alex@shazbot.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Philipp Stanner <pstanner@redhat.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>, Yunxiang Li <Yunxiang.Li@amd.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Lukas,

Sorry I am late to the party.

On Tue, Dec 2, 2025 at 6:59=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> On Tue, Dec 02, 2025 at 07:20:23AM +0100, Lukas Wunner wrote:
>
> > But you do gain a bit of reliability if you don't assume bus numbers
> > to stay the same and instead use the "path from root" approach to
> > identify devices.
>
> Again, that's not reliability it is subtle bugs. The device is active
> during KHO, you CAN NOT do any resource reassignment, not bus numbers,
> not mmio. It must be fully disabled.

I agree with Jason. The bus number is used in the low level hardware
to do the DMA transfer. The bus number can not change for a device
during livedupate with pending DMA transfer. The BDF MUST remain the
same as the liveupdate with DMA transfer requirement. Given the BDF
remains the same. Using the path from root doesn't buy you more
protections. It just makes the patch more complicated but achieves the
same thing. That is why I chose the BDF approach for the PCI
liveupdate subsystem in the first place. To keep it simple.

Jason, please correct me if I am wrong. My understanding is that not
only the device that is actively doing the DMA requires the bus number
to stay the same, I think all the parent bridge, all the way to the
root PCI host bridge, bus number must remain the same. After all, the
DMA will need to route through the parent bridges.

Another point is that, on the same machine it can have multiple PCI
host bridges. Each PCI host bridge bus number is acquired from the
ACPI table walk. I am not aware of any way to get the slot number of
the PCI host bridge. Lukas, do you know how to get the PCI host bridge
slot number to form a path?

Chris

