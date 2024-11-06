Return-Path: <kvm+bounces-31044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18D2A9BF94C
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 23:30:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A0051C21E4D
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 22:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DC671DCB0D;
	Wed,  6 Nov 2024 22:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XjHTSFg2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07B41DDC33
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 22:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730932209; cv=none; b=mlKWcLBT6TBHMlusFgSWcsFrU8OLPHoGCi6G/ahpXNQygc6nyq50Gcq1xj6fSzsC8s31zyRYrjl9Mx2T6OF6KiZkGVX7v0m8MO3piq4a+Z2bUbSTnsg1Od1rHcwbiJgu0H6SLp0dC41SAf0adMXcBC+vzYqX526XjztNHS8fj9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730932209; c=relaxed/simple;
	bh=qMFl8siVLf8ZliUAyYypPgNolZx+V2jCSqlwv5m0hm0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YpsfzDz/thz/n3OvCvltUQpUiKQTiuox5j7orGtcYbyWcXA3hqe9/sCDvAaRdtFNd4vflmNYZEWtnMDdWNGIu6HaxXYDSGWdR3wQdJVF4kkUZfPbmMoTdJUVwCUuxkHeS1NeLDuMe/45RMOTTI0mSU/f2kbHcnLqoFdtWFR8+8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XjHTSFg2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730932206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7NKBJFGsUjRQk1GB5bl4dJj7QuShLoyvXNieDqLMkMY=;
	b=XjHTSFg2dlWxYb+J0nn1O/tTAfM58i8KHKEQLhyLrIUZ+Vm7lLJbaISeCZerS4lojhZiLS
	78gYBpXAAm9/DeVi7+Bcule2paCetMLwOlk1z9L5Qi3F9uBDhCu5vF2CA6L+erWv3Tx9Sl
	mDltS2+ew8+b/R2YgFHECaswt/kQNyw=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-dQ573pfrMgOFrTIUA8DMOw-1; Wed, 06 Nov 2024 17:30:05 -0500
X-MC-Unique: dQ573pfrMgOFrTIUA8DMOw-1
X-Mimecast-MFC-AGG-ID: dQ573pfrMgOFrTIUA8DMOw
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-83ba5dcee51so8347139f.1
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 14:30:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730932205; x=1731537005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7NKBJFGsUjRQk1GB5bl4dJj7QuShLoyvXNieDqLMkMY=;
        b=luwCzEX6AFsjOjGKbv/GN99E+Tt672gHHLV5KSrmSFayAZpzIBoKk247ogMqAnKvAh
         XCH1j5PSKXRhQ5ClXKvUjccbqKwT+D2mRAd4KVS9YCrIVaEOa3H+NtenRC6fLp++A0q6
         sEx2NHW78beKxra4dd0i+cuGhq0KX9+sMuDEhXcJIhIG0R4UpdY2Qe5QnMi0ox0Do2vo
         T2IoiW+qe83B8FCtXMvUhd2FO9ej8sgzeqbS2e55TnxKDLEo4WtjmJC0Qi8PqrJiis5L
         mc38VhurddbQHYW8myubBZTjSH2aHu2oDZxwozLECFpYFfvqcBp1a2jI6HSZxoq4hwU+
         clVw==
X-Forwarded-Encrypted: i=1; AJvYcCWHaWvriaqh9K9slbaJVqcwBUY4TvIZXlTpyUvD0tezfNF/GfXwag7l5HiqLZ/h5M9gxV4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyarSjUnrxODXfvLTMXJAzH8LMOwGKhGeuGDn1qIMJtuGnjtRW+
	nLoml2Lk/DwXJSNJeFIxfrZ6b7p7f5DnqEvk+92CK6Njf3snvL5yhcEmhfDCx1qK66z6HDANJP6
	tZ8QH58vovI7RIIg34Q6fLqUerG01HMTP/cgW56YREH1QJbODmg==
X-Received: by 2002:a05:6e02:1a83:b0:3a2:57d2:3489 with SMTP id e9e14a558f8ab-3a6e84cad16mr3997455ab.3.1730932205014;
        Wed, 06 Nov 2024 14:30:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEAI/Zl/vMrMnohgNpLsPUTqLN9PL2prn9a7pI4Vl9z0PshTb81NnGi+aEkQHdikGP4ZBpX9w==
X-Received: by 2002:a05:6e02:1a83:b0:3a2:57d2:3489 with SMTP id e9e14a558f8ab-3a6e84cad16mr3997395ab.3.1730932204529;
        Wed, 06 Nov 2024 14:30:04 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de5f82e828sm20015173.71.2024.11.06.14.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 14:30:04 -0800 (PST)
Date: Wed, 6 Nov 2024 15:30:03 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Yishai Hadas <yishaih@nvidia.com>, jasowang@redhat.com, jgg@nvidia.com,
 kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
 parav@nvidia.com, feliu@nvidia.com, kevin.tian@intel.com,
 joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 vfio 0/7] Enhance the vfio-virtio driver to support
 live migration
Message-ID: <20241106153003.09c501bd.alex.williamson@redhat.com>
In-Reply-To: <20241106043151-mutt-send-email-mst@kernel.org>
References: <20241104102131.184193-1-yishaih@nvidia.com>
	<20241106043151-mutt-send-email-mst@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 6 Nov 2024 04:32:31 -0500
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Mon, Nov 04, 2024 at 12:21:24PM +0200, Yishai Hadas wrote:
> > This series enhances the vfio-virtio driver to support live migration
> > for virtio-net Virtual Functions (VFs) that are migration-capable.
> > =20
> > This series follows the Virtio 1.4 specification to implement the
> > necessary device parts commands, enabling a device to participate in the
> > live migration process.
> >=20
> > The key VFIO features implemented include: VFIO_MIGRATION_STOP_COPY,
> > VFIO_MIGRATION_P2P, VFIO_MIGRATION_PRE_COPY.
> > =20
> > The implementation integrates with the VFIO subsystem via vfio_pci_core
> > and incorporates Virtio-specific logic to handle the migration process.
> > =20
> > Migration functionality follows the definitions in uapi/vfio.h and uses
> > the Virtio VF-to-PF admin queue command channel for executing the device
> > parts related commands. =20
>=20
>=20
> virtio things here:
>=20
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>=20
> Alex, your tree I presume? I hope the virtio changes do not
> cause conflicts.

Sure, I can ultimately take it through my tree once we have consensus.

Yishai, please add Michael's ack to 1-4 on the next round.  Thanks,

Alex

> > Patch Overview:
> > The first four patches focus on the Virtio layer and address the
> > following:
> > - Define the layout of the device parts commands required as part of the
> >   migration process.
> > - Provide APIs to enable upper layers (e.g., VFIO, net) to execute the
> >   related device parts commands.
> > =20
> > The last three patches focus on the VFIO layer:
> > - Extend the vfio-virtio driver to support live migration for Virtio-net
> >   VFs.
> > - Move legacy I/O operations to a separate file, which is compiled only
> >   when VIRTIO_PCI_ADMIN_LEGACY is configured, ensuring that live
> >   migration depends solely on VIRTIO_PCI.
> > =20
> > Additional Notes:
> > - The kernel protocol between the source and target devices includes a
> >   header containing metadata such as record size, tag, and flags.
> >   The record size allows the target to read a complete image from the
> >   source before passing device part data. This follows the Virtio
> >   specification, which mandates that partial device parts are not
> >   supplied. The tag and flags serve as placeholders for future extensio=
ns
> >   to the kernel protocol between the source and target, ensuring backwa=
rd
> >   and forward compatibility.
> > =20
> > - Both the source and target comply with the Virtio specification by
> >   using a device part object with a unique ID during the migration
> >   process. As this resource is limited to a maximum of 255, its lifecyc=
le
> >   is confined to periods when live migration is active.
> >=20
> > - According to the Virtio specification, a device has only two states:
> >   RUNNING and STOPPED. Consequently, certain VFIO transitions (e.g.,
> >   RUNNING_P2P->STOP, STOP->RUNNING_P2P) are treated as no-ops. When
> >   transitioning to RUNNING_P2P, the device state is set to STOP and
> >   remains STOPPED until it transitions back from RUNNING_P2P->RUNNING, =
at
> >   which point it resumes its RUNNING state. During transition to STOP,
> >   the virtio device only stops initiating outgoing requests(e.g. DMA,
> >   MSIx, etc.) but still must accept incoming operations.
> >=20
> > - Furthermore, the Virtio specification does not support reading partial
> >   or incremental device contexts. This means that during the PRE_COPY
> >   state, the vfio-virtio driver reads the full device state. This step =
is
> >   beneficial because it allows the device to send some "initial data"
> >   before moving to the STOP_COPY state, thus reducing downtime by
> >   preparing early and warming-up. As the device state can be changed and
> >   the benefit is highest when the pre copy data closely matches the fin=
al
> >   data we read it in a rate limiter mode and reporting no data available
> >   for some time interval after the previous call. With PRE_COPY enabled,
> >   we observed a downtime reduction of approximately 70-75% in various
> >   scenarios compared to when PRE_COPY was disabled, while keeping the
> >   total migration time nearly the same.
> >=20
> > - Support for dirty page tracking during migration will be provided via
> >   the IOMMUFD framework.
> > =20
> > - This series has been successfully tested on Virtio-net VF devices.
> >=20
> > Changes from V0:
> > https://lore.kernel.org/kvm/20241101102518.1bf2c6e6.alex.williamson@red=
hat.com/T/
> >=20
> > Vfio:
> > Patch #5:
> > - Enhance the commit log to provide a clearer explanation of P2P
> >   behavior over Virtio devices, as discussed on the mailing list.
> > Patch #6:
> > - Implement the rate limiter mechanism as part of the PRE_COPY state,
> >   following Alex=E2=80=99s suggestion.
> > - Update the commit log to include actual data demonstrating the impact=
 of
> >   PRE_COPY, as requested by Alex.
> > Patch #7:
> > - Update the default driver operations (i.e., vfio_device_ops) to use
> >   the live migration set, and expand it to include the legacy I/O
> >   operations if they are compiled and supported.
> >=20
> > Yishai
> >=20
> > Yishai Hadas (7):
> >   virtio_pci: Introduce device parts access commands
> >   virtio: Extend the admin command to include the result size
> >   virtio: Manage device and driver capabilities via the admin commands
> >   virtio-pci: Introduce APIs to execute device parts admin commands
> >   vfio/virtio: Add support for the basic live migration functionality
> >   vfio/virtio: Add PRE_COPY support for live migration
> >   vfio/virtio: Enable live migration once VIRTIO_PCI was configured
> >=20
> >  drivers/vfio/pci/virtio/Kconfig     |    4 +-
> >  drivers/vfio/pci/virtio/Makefile    |    3 +-
> >  drivers/vfio/pci/virtio/common.h    |  127 +++
> >  drivers/vfio/pci/virtio/legacy_io.c |  420 +++++++++
> >  drivers/vfio/pci/virtio/main.c      |  500 ++--------
> >  drivers/vfio/pci/virtio/migrate.c   | 1336 +++++++++++++++++++++++++++
> >  drivers/virtio/virtio_pci_common.h  |   19 +-
> >  drivers/virtio/virtio_pci_modern.c  |  457 ++++++++-
> >  include/linux/virtio.h              |    1 +
> >  include/linux/virtio_pci_admin.h    |   11 +
> >  include/uapi/linux/virtio_pci.h     |  131 +++
> >  11 files changed, 2594 insertions(+), 415 deletions(-)
> >  create mode 100644 drivers/vfio/pci/virtio/common.h
> >  create mode 100644 drivers/vfio/pci/virtio/legacy_io.c
> >  create mode 100644 drivers/vfio/pci/virtio/migrate.c
> >=20
> > --=20
> > 2.27.0 =20
>=20


