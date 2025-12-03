Return-Path: <kvm+bounces-65232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EEACFCA105C
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 19:35:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9C55B353CA66
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 17:34:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D2B314B89;
	Wed,  3 Dec 2025 17:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e05Yi1Na"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824EE280014
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 17:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764783001; cv=none; b=I8ZMVlqEu2wE+Qw0Du0Ia3ittiJ1l8VdJIuidk0fgRNxMMdzjjTMlUgt7xke7BGF4dat+J2MA3IG2iOw2iciL9WMbXVMfq6djMtR4uTs0+DDzzH6d3cQECAIbDDdG3tjg8OcXjpcVRUSp5OLtCn7ahchCLoXEKNr8Vn9R70O0Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764783001; c=relaxed/simple;
	bh=yhp8ueLBj5nMHyuDgH/VoEo8DFq7np5eB5KjSi/CnnE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IWwnaC6H2aCft/nF/ZRStQ8UFUSvP5oXcsnfhC34Id7ZyBGChkn4bEyE06q46hANDIPiKaBSKVA68ixRSkTVEEFkN232o1uyglv+oAdS7e0EUPVue2Pcm+nvVuN5a30p5SgY0qHrJsUOof7zHFc4GAt7akap1qIZfb+mJeRaHGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e05Yi1Na; arc=none smtp.client-ip=209.85.217.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-5de23ddba5eso28344137.3
        for <kvm@vger.kernel.org>; Wed, 03 Dec 2025 09:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764782998; x=1765387798; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ymOu3D/5TCeHMIJLeG6oQI7EFVuJhBKpf9gV9hN/6k=;
        b=e05Yi1NaNRV8feWkf1J/QH59rCYoZQ6JkcAy9gnt899o6YqCHo5nSZelPOvenVle9X
         UIsyKuPLD+6BQkm1vr2+9GH3MooHpBxU+avgmntqcW/XZqF1KBFjvkGTts7mQqEwZT8Y
         QZQfx8rTTAM9ZJwbXpSNjt2pgocSxD29eG83aKeappBCinu50F2x3L5nzhK33JfQ0JKh
         dWtAn6t6o0RKDdmDUkYtpJI9xO69c892LrgsCFI3oJKgTLTQ9pXauxKpzbnt4uozrzOu
         EMML3pzMNu9unwBx7P4KfxAZeRhrjA/xMAEbImSWDPuBoYBr0PipXWXD8iOievzLFFBp
         5JXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764782998; x=1765387798;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0ymOu3D/5TCeHMIJLeG6oQI7EFVuJhBKpf9gV9hN/6k=;
        b=mWwgLD35sz/OBBE7n4kg6o1VZ2+tAp3S2uF4Lndd9aGjnH2FgJAnrwjN7VyGqksmXQ
         bVk7uQwXgFTmEI8kcR3QYEN3gdBT6wGHCYfbf+drTzZG5o/ia7nIFivRefgC/Fav+0Bj
         Luc+Mw5YyZpNkCUEHqEfAq1WV2Fw+awC6//Cdj4N3L0sC9ofpoXyMH9kXrFkXyzA245S
         YWVH+KYYij1u2CilGO2K9U6F5lP4u2vy6qu0HoPgHQPzMXwsSeMyZzBl/SZoYLeDyTZ0
         bxhZbK0BHSxaZS7QGeUA/u6jyrZXBf/vJyh2h2Eqe6PyqmAmerT6L2WCysf19cb0bfeR
         gJmw==
X-Forwarded-Encrypted: i=1; AJvYcCW2xHB4tHXKOcp7SFwn3jT0VLN/wHd35QraprDG25/72BRJNzxn8WSlOnbf9le/CU+sC10=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+PQS4bYRUyGNbl/iSHIxoCvyT34m/qym+iUe2rwU6A7hPWgV1
	/XW4WRFYhkLIMrsmXh/YyaJEhE7cu1h/3AIOLfuLZxkspquwtNNyRSexqWzZlqpNFJDXX+rZRGw
	3my3KK7jz8f08Pc7dQgvUNnG5SfTTeu3G1IX9hibV
X-Gm-Gg: ASbGncuxH7e1dMtyGlmqMnPUDcYThJ4SMgG0PC2UORPQPwcuHg8P/CpKxzPhZCkOYNI
	CFAoEGkxBzw8l6y40/9U6kQx0BmhaRzGxaRVYpijcbPI0i40q3XmarAAJMirvrfgJVDjAVVA/vi
	bG8Xi6LW7ABb46plCh9iWsG1AwZomOGnSkXyCRqJrntHVlh0AbmF90QE97jYom3PSyJ77wTeiPb
	lkYSc/b2z/0UVgdfGA3BKgXoPfVjSntYOVR4OFwk0M8sybNQs5Lteuf9+3aDAEJCuitUCY7
X-Google-Smtp-Source: AGHT+IEKqmK3kDwhNospqoV4M7zNXECVKB1pEuoEfSUxYUNClHBKew01QVDNB+pfOa2oWX8T4XdL5cKkx6qlappJfPQ=
X-Received: by 2002:a05:6102:162a:b0:5db:f5d1:5799 with SMTP id
 ada2fe7eead31-5e48e36e069mr1205132137.33.1764782998176; Wed, 03 Dec 2025
 09:29:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251126193608.2678510-1-dmatlack@google.com> <20251126193608.2678510-7-dmatlack@google.com>
 <aTAzMUa7Gcm+7j9D@devgpu015.cco6.facebook.com> <CA+CK2bDbOQ=aGPZVP4L-eYobUyR0bQA0Ro6Q7pwQ_84UxVHnEw@mail.gmail.com>
In-Reply-To: <CA+CK2bDbOQ=aGPZVP4L-eYobUyR0bQA0Ro6Q7pwQ_84UxVHnEw@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 3 Dec 2025 09:29:27 -0800
X-Gm-Features: AWmQ_blKPsDeMnCOujpZmsX70hbna-86oi6Hxpla3VI0D7Ue5d4-IEmochk7nSM
Message-ID: <CALzav=ciz4kV+u3B5bMzZzVY+cMs-G=q9c5O-jKPz+E4LUdx7g@mail.gmail.com>
Subject: Re: [PATCH 06/21] vfio/pci: Retrieve preserved device files after
 Live Update
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alex Mastro <amastro@fb.com>, Alex Williamson <alex@shazbot.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, 
	kvm@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Philipp Stanner <pstanner@redhat.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>, Yunxiang Li <Yunxiang.Li@amd.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 3, 2025 at 7:46=E2=80=AFAM Pasha Tatashin <pasha.tatashin@solee=
n.com> wrote:
>
> On Wed, Dec 3, 2025 at 7:55=E2=80=AFAM Alex Mastro <amastro@fb.com> wrote=
:
> >
> > On Wed, Nov 26, 2025 at 07:35:53PM +0000, David Matlack wrote:
> > > From: Vipin Sharma <vipinsh@google.com>
> > >  static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_ar=
gs *args)
> > >  {
> > > -     return -EOPNOTSUPP;
> > > +     struct vfio_pci_core_device_ser *ser;
> > > +     struct vfio_device *device;
> > > +     struct folio *folio;
> > > +     struct file *file;
> > > +     int ret;
> > > +
> > > +     folio =3D kho_restore_folio(args->serialized_data);
> > > +     if (!folio)
> > > +             return -ENOENT;
> >
> > Should this be consistent with the behavior of pci_flb_retrieve() which=
 panics
> > on failure? The short circuit failure paths which follow leak the folio=
,

Thanks for catching the leaked folio. I'll fix that in the next version.

> > which seems like a hygiene issue, but the practical significance is moo=
t if
> > vfio_pci_liveupdate_retrieve() failure is catastrophic anyways?
>
> pci_flb_retrieve() is used during boot. If it fails, we risk DMA
> corrupting any memory region, so a panic makes sense. In contrast,
> this retrieval happens once we are already in userspace, allowing the
> user to decide how to handle the failure to recover the preserved
> cdev.

This is what I was thinking as well. vfio_pci_liveupdate_retrieve()
runs in the context of the ioctl LIVEUPDATE_SESSION_RETRIEVE_FD, so we
can just return an error up to userspace if anything goes wrong and
let userspace initiate the reboot to recover the device if/when it's
ready.

OTOH, pci_flb_retrieve() gets called by the kernel during early boot
to determine what devices the previous kernel preserved. If the kernel
can't determine which devices were preserved by the previous kernel
and once the kernel starts preserving I/O page tables, that could lead
to corruption, so panicking is warranted.

