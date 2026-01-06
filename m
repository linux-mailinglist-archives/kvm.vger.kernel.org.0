Return-Path: <kvm+bounces-67086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 89402CF611B
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 01:20:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5CF593051AD4
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 00:20:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9916F19E99F;
	Tue,  6 Jan 2026 00:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LZMkMUcv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC512A92E
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 00:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767658827; cv=none; b=L/qaOF3w+U8j/sZowLGOur46GPFX60RTnjhLFYBTjm6RY1G1Tk1+W53ucTABIk6Y8IOWd6MppZKBXFGxd7q5AaBBfEXdurHv4/r+TDcMGtEm5mR4WfOKTIZt1VIq9mMhV6C10u4z+Gw0u8Z41rnebVd8JiZHrelkOb7GtObF5Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767658827; c=relaxed/simple;
	bh=MRUlSzIlu0yCi9v9X+L6K/SPUeN5X4HBatQrXbmsoNo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qydZn6J13fBJzvI5YyGtiC3VqKBIvvVfiz/Qxxam+d4HzB3PPHFF11q4nUVw6KJE0GOXYHWGoBHtMkEPaBGzamQz8OyPn3Xz6DgieSL+35CtTmmo8Hs1zHZuu2aE4zQHCtvuOtS2t/xCDl3fW8lVPFmDMIhgw71v/iFUeOmYgI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LZMkMUcv; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-594285c6509so487119e87.0
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 16:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767658823; x=1768263623; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ao9G2tm5rq8JriKrggBN6pUBzceguMNi3YbflNISZIM=;
        b=LZMkMUcvAvgHKQNzUZ7Fbj0z3lKIKmf4Gxb/rPbw1+ZvJxY8x0YMB6NaxPha3fKCvy
         lnpwLxqxHhI6H26s/0qtuYMfYrurs3a4fcFM2p9+LeM0PngYRAP7Q0lsDgwvsLo+nrBw
         ZZaGR5rNLWbmm9bD+0aOGxTc4mfVO7iR6ZXh8GmjNkCk82m47GGi6mZPJJfOe5gUvShF
         rtOFQQeh80W9UmJ42awq/OY3pSIqnSLe0hCgpOv/pyFzgZjYtPTX0vICcPXb5TDDaXQc
         mjjuyvfhSIgzxRPxsOvTnOu+EsZFxWUbfkHEKoDhUNcKjoaM9luxleYL85JQBIDLXmgG
         Thhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767658823; x=1768263623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ao9G2tm5rq8JriKrggBN6pUBzceguMNi3YbflNISZIM=;
        b=PQ7RFHjBt6U/ir9HzH3xOGMFYU8Q2muceFhBYgEKxRiCe9nbUJa7a1wVwhltpiy9iW
         wlp20H3fXw8l4i1RJZZO8kxe/QWIyxYh/KXXpOeSc8GCKOcr2YAbcwaKDDw6vGeQx6tu
         3UhtiKcsrPxpdo6WKr8wH7N39lINQqpJHJeTRnqshhP2r98U5w5GepScVJUvu69hwTsc
         IBW8sKz9xW/iew8Ph0cgQhZUVzYD1b/55Yfc7j2hn1zyOYH518NatN/Bz4SV+/PyOLi1
         tHm7MYb9cpBODRymjlQ+pqStF5GxElfRzDx/OAIXhKMv1rrtybzsPig9xCwFQPYm0Xgm
         sOqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVuJfmZOn6/SJkAjtnnxy508PfuJj9eLvE57tZbtARAYR5CP7/Q4FHuAc42IyfrOzkTr4o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRT0TFM1j7dPZrU0OUpZcsxEKmO5krT3r35uUy2j4g4oSn7+B4
	WuSBLiiFf7rKnoL+WngVmWCmfIsI3GYoQd0tLbljUdM7r9N2LVqPDtNOckzIKki5axi2hx/w4mC
	scAjc4nQfHIxkLWnUMpctNDU/74aoNG7n3uHIwJMj
X-Gm-Gg: AY/fxX6WEIr3u8AoiVm9c0lC7VmFcTOTAMKS/5b/xcRdU3ix/K11jrQJBXJgjZjQrVb
	S2oCiGL9+8TiJd71vLaFutUFE6upMibmxnZ9qxNLp6lQOlLQn55X8fVA4sOrZ8T54PyHrLldPUR
	sXdohxz17GVAmyRkoLEPLwYuTWChjt0KdNhinjLcZbb0R/9EtDVF6NftDSAaTxksHFeRwOyUI1J
	OSFdrPW5dUtHA9fxqMP4r9njdGltELh0IvBPHaHAqYUYe/bY5ipavHMRrxgn1fwvccFhKQ2
X-Google-Smtp-Source: AGHT+IHb+AObIa8Xpi5KrmBllTV6a796WAN4T+3NWWccFiSvRWXKvYgmkKUjKvZYKPMGu7V/b+Y+kIuARsuoKdYKTCo=
X-Received: by 2002:a05:6512:b90:b0:59b:1d24:7dcd with SMTP id
 2adb3069b0e04-59b6521549emr381820e87.12.1767658822753; Mon, 05 Jan 2026
 16:20:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251126193608.2678510-1-dmatlack@google.com> <20251126193608.2678510-20-dmatlack@google.com>
 <f0439348-dca7-4f1b-9d96-b5a596c9407d@linux.dev> <CALzav=duUuUaFLmTnRR41ZiWZKxbRAcb9LGvA5S8g2b5_Liv4g@mail.gmail.com>
 <2779d6a2-d734-4334-befc-99f958e1d1ef@linux.dev>
In-Reply-To: <2779d6a2-d734-4334-befc-99f958e1d1ef@linux.dev>
From: David Matlack <dmatlack@google.com>
Date: Mon, 5 Jan 2026 16:19:55 -0800
X-Gm-Features: AQt7F2ooQV8QHcMMN8oMqlI2XNP9S0NGm7FbnT15j4rY2pjwAwVxgbJOfVYkhMc
Message-ID: <CALzav=dbvQ67Mb=ayjPmgTtL9GQvusRe=PzBjcLMJrh4sii-0Q@mail.gmail.com>
Subject: Re: [PATCH 19/21] vfio: selftests: Expose low-level helper routines
 for setting up struct vfio_pci_device
To: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, 
	kvm@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Philipp Stanner <pstanner@redhat.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>, Yunxiang Li <Yunxiang.Li@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 5, 2026 at 4:08=E2=80=AFPM Yanjun.Zhu <yanjun.zhu@linux.dev> wr=
ote:
>
>
> On 1/5/26 9:54 AM, David Matlack wrote:
> > On Sat, Dec 27, 2025 at 8:04=E2=80=AFPM Zhu Yanjun <yanjun.zhu@linux.de=
v> wrote:
> >> =E5=9C=A8 2025/11/26 11:36, David Matlack =E5=86=99=E9=81=93:
> >>> @@ -349,9 +351,20 @@ struct vfio_pci_device *__vfio_pci_device_init(c=
onst char *bdf,
> >>>        device->bdf =3D bdf;
> >>>        device->iommu =3D iommu;
> >>>
> >>> +     return device;
> >>> +}
> >>> +
> >> In the latest kernel, this part changes too much.
> > Can you clarify what you mean by "changes too much"? What is the issue?
>
> I tried to apply this commit to the linux and linux-next repositories
> and run tests.
>
> However, I=E2=80=99m unable to apply [PATCH 19/21] vfio: selftests: Expos=
e
> low-level helper routines for setting up struct vfio_pci_device, because
> the related source code has changed significantly in both linux and
> linux-next.

Ahhh. This series depends on several in-flight series, so I'm not
surprised it doesn't apply cleanly. There is this blurb in the cover
letter:
---
This series was constructed on top of several in-flight series and on
top of mm-nonmm-unstable [2].

  +-- This series
  |
  +-- [PATCH v2 00/18] vfio: selftests: Support for multi-device tests
  |    https://lore.kernel.org/kvm/20251112192232.442761-1-dmatlack@google.=
com/
  |
  +-- [PATCH v3 0/4] vfio: selftests: update DMA mapping tests to use
queried IOVA ranges
  |   https://lore.kernel.org/kvm/20251111-iova-ranges-v3-0-7960244642c5@fb=
.com/
  |
  +-- [PATCH v8 0/2] Live Update: File-Lifecycle-Bound (FLB) State
  |   https://lore.kernel.org/linux-mm/20251125225006.3722394-1-pasha.tatas=
hin@soleen.com/
  |
  +-- [PATCH v8 00/18] Live Update Orchestrator
  |   https://lore.kernel.org/linux-mm/20251125165850.3389713-1-pasha.tatas=
hin@soleen.com/
  |

To simplify checking out the code, this series can be found on GitHub:

  https://github.com/dmatlack/linux/tree/liveupdate/vfio/cdev/v1
---

Cloning the GitHub repo is probably your simplest option if you want
to check out the code and run some tests.

>
> If you plan to resend this patch series based on the latest linux or
> linux-next, please feel free to ignore this comment.
>
> I look forward to testing the updated patch series once it is available.

I will send out an updated patch set hopefully within the next 2 weeks.

Thanks for taking a look!

