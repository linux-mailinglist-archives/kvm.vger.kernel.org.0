Return-Path: <kvm+bounces-59547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C85CBBF1FC
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 21:47:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C3CC034B72E
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 19:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E8D52D8DA6;
	Mon,  6 Oct 2025 19:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BDs2mMop"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67BC1F03FB
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 19:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759780011; cv=none; b=tvlu7Q7LXWXsxtWkzNiUjD1+dL++oizE45a3Pj2wGXfCDv1FUqoq92ma8dGeXKSiWjVdxnxn4FhRldIl9GFahlZANxMf1/gIQMW0PE0oaGp4iVA+lGEeLIIpkL636Qv46+HhD5UC5zjEmdJQIbReVcqCQAkPctYnJ1qslBO+f+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759780011; c=relaxed/simple;
	bh=RpzZsSQdr0hQNB60BVgDeuxT0TDaqlGHirWXIco0GKU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AajhnBEn/nYfawqKV2tzZeDvUU8IPTOEe/2kVCjzDZXGF7KINzty4PYxNp8WTMChoRb/oIC3LFPFxvL/04wTBta4aIRbE9Nw09D49fZqP4XCzHYur2ths1Uk6mnfVu5qGEpWSO2CW4j3bzEyAQLeHJeCOThf0CsMQTulwEEAYRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BDs2mMop; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759780008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dEP4bvQgSEfzGRmi8Yd/uqvmJgEkoYKfsq3TYxXDi7E=;
	b=BDs2mMopFO4Kh+DHbnKsgDpNfbaytAISXHogmPfPA02eInO/XpruidUz5PgXiNEH41EH62
	/S+VwKXdEzFuy8TcVUe7tM2BLWMTOR2rvVEk7l/6TSwlq6Ue4PuoqPNcf1kOSOLOSfuOH7
	M2hgZI07hET7Frc2tQlB9zZhcz+XvOQ=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-286-QEnzgo5BMfGU1bBzAR_69w-1; Mon, 06 Oct 2025 15:46:47 -0400
X-MC-Unique: QEnzgo5BMfGU1bBzAR_69w-1
X-Mimecast-MFC-AGG-ID: QEnzgo5BMfGU1bBzAR_69w_1759780006
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-4257fce57faso3489015ab.1
        for <kvm@vger.kernel.org>; Mon, 06 Oct 2025 12:46:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759780005; x=1760384805;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dEP4bvQgSEfzGRmi8Yd/uqvmJgEkoYKfsq3TYxXDi7E=;
        b=G7N9sfQ6aMuwlAeRIC6yTAH/RhwMVGhDG5p8bo6DBd4c9ELO4sdqEF6FVT74OBLUYC
         wLe+vt6e+7qJNI0wEivGmAEjanfxS/iptacZlDU6MKyqjnH12mE7GhFbPksGEfFgjWev
         iHDpfRaaGw5HJa8Njy2Wbskkd5DU1WMXBTVYAA60i0IP6CFePsewaLw9R5CVbZQKMndI
         zusG0Pk8aCHagDyqyYIpJFnGKdJpocoR9FJDt1PZsxyf5/KeDLVhA4lAnT8FRi70Ywjs
         xsoxRvDTOc4IDljsWQXHVhwiAwp01Muc9hEoDOEjBoqyCDIoELM4ubbOmeX8pGP/Sq8f
         mzzw==
X-Gm-Message-State: AOJu0YxxfYbtTaCCeVs4r+aBJVQi28XInV7L1CtQW/3kx569x0uDrOLh
	TiPuQdO8HMUiOaA5NwEF4P8C6FoL1jip08AGzM2A0uIqLSd5i9PvVoF3o55m/XUmeQYz5vteigD
	FwZtYcG8VkYPORN/Tu8cr6S5Mq+RQBB7sBPeY4MDAvUYzUyEvcb2spav4/H20Sw==
X-Gm-Gg: ASbGncv+lsg3admQROyjO6oJNJtLaaH2NpgEX7zxH+J2nWhnFIiBenXxmW8ueGOQax8
	hXnGfP1LdckQ+WRUX6inQe9iYeaS0bQdPdB992+DGGwi4/1oEFnt4Y+UpemAsnPmVentN9pmejA
	xkhZVIKMUSB2Gqhywy3g6uKaOV19doSKuWSeHmg1G67q2VDaruOfhk2v4MmC9xhkrBbvclXlQ6Y
	JUYJv6t7/nH08wlci0zdwgIFt5Jn710Uh4EKdTP7525ZrP8MumQVV52owH0dNgYJE+g0nHZ8/WX
	ioBJJBR0k5WSOGxbeH9d7krxhVuBx7nsD+aTkq3f1gAFnmWa
X-Received: by 2002:a05:6e02:1a81:b0:42d:89d2:bb with SMTP id e9e14a558f8ab-42e7ad894ebmr73562595ab.6.1759780005299;
        Mon, 06 Oct 2025 12:46:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEifc22XtdKCJ76WuLXjkG/CH7GbrgaM1lNvaHoU49PuB2rEVRz9xNuIY1xjj+apJYv7FEpWA==
X-Received: by 2002:a05:6e02:1a81:b0:42d:89d2:bb with SMTP id e9e14a558f8ab-42e7ad894ebmr73562395ab.6.1759780004792;
        Mon, 06 Oct 2025 12:46:44 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57b5e9ec393sm5228654173.14.2025.10.06.12.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 12:46:44 -0700 (PDT)
Date: Mon, 6 Oct 2025 13:46:42 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: Dump migration features under debugfs
Message-ID: <20251006134642.4aee649a.alex.williamson@redhat.com>
In-Reply-To: <20250918121928.1921871-1-clg@redhat.com>
References: <20250918121928.1921871-1-clg@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Sep 2025 14:19:28 +0200
C=C3=A9dric Le Goater <clg@redhat.com> wrote:

> A debugfs directory was recently added for VFIO devices. Add a new
> "features" file under the migration sub-directory to expose which
> features the device supports.
>=20
> Signed-off-by: C=C3=A9dric Le Goater <clg@redhat.com>
> ---
>  drivers/vfio/debugfs.c                 | 19 +++++++++++++++++++
>  Documentation/ABI/testing/debugfs-vfio |  6 ++++++
>  2 files changed, 25 insertions(+)

I think this was overlooked, but should have been considered for the
v6.18 merge window.  Given the plan to get the DMA mapping
optimizations in this merge window, I think we should pull this in too.
Applied to the vfio next branch.  Thanks,

Alex
=20
> diff --git a/drivers/vfio/debugfs.c b/drivers/vfio/debugfs.c
> index 298bd866f15766b50e342511d8a83f0621cb4f55..8b0ca7a09064072b3d489dab8=
072dbb1a2871d10 100644
> --- a/drivers/vfio/debugfs.c
> +++ b/drivers/vfio/debugfs.c
> @@ -58,6 +58,23 @@ static int vfio_device_state_read(struct seq_file *seq=
, void *data)
>  	return 0;
>  }
> =20
> +static int vfio_device_features_read(struct seq_file *seq, void *data)
> +{
> +	struct device *vf_dev =3D seq->private;
> +	struct vfio_device *vdev =3D container_of(vf_dev, struct vfio_device, d=
evice);
> +
> +	if (vdev->migration_flags & VFIO_MIGRATION_STOP_COPY)
> +		seq_puts(seq, "stop-copy\n");
> +	if (vdev->migration_flags & VFIO_MIGRATION_P2P)
> +		seq_puts(seq, "p2p\n");
> +	if (vdev->migration_flags & VFIO_MIGRATION_PRE_COPY)
> +		seq_puts(seq, "pre-copy\n");
> +	if (vdev->log_ops)
> +		seq_puts(seq, "dirty-tracking\n");
> +
> +	return 0;
> +}
> +
>  void vfio_device_debugfs_init(struct vfio_device *vdev)
>  {
>  	struct device *dev =3D &vdev->device;
> @@ -72,6 +89,8 @@ void vfio_device_debugfs_init(struct vfio_device *vdev)
>  							vdev->debug_root);
>  		debugfs_create_devm_seqfile(dev, "state", vfio_dev_migration,
>  					    vfio_device_state_read);
> +		debugfs_create_devm_seqfile(dev, "features", vfio_dev_migration,
> +					    vfio_device_features_read);
>  	}
>  }
> =20
> diff --git a/Documentation/ABI/testing/debugfs-vfio b/Documentation/ABI/t=
esting/debugfs-vfio
> index 90f7c262f591306bdb99295ab4e857ca0e0b537a..70ec2d454686290e13380340d=
fd6a5a67a642533 100644
> --- a/Documentation/ABI/testing/debugfs-vfio
> +++ b/Documentation/ABI/testing/debugfs-vfio
> @@ -23,3 +23,9 @@ Contact:	Longfang Liu <liulongfang@huawei.com>
>  Description:	Read the live migration status of the vfio device.
>  		The contents of the state file reflects the migration state
>  		relative to those defined in the vfio_device_mig_state enum
> +
> +What:		/sys/kernel/debug/vfio/<device>/migration/features
> +Date:		Oct 2025
> +KernelVersion:	6.18
> +Contact:	C=C3=A9dric Le Goater <clg@redhat.com>
> +Description:	Read the migration features of the vfio device.


