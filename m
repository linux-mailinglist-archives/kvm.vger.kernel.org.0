Return-Path: <kvm+bounces-15177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B4188AA58A
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 00:54:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8911AB22B1E
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 22:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE85E4AED6;
	Thu, 18 Apr 2024 22:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WD/or5iL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592CF4A20
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 22:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713480882; cv=none; b=Hzw+1zYtb49oZ/Evnh2dnNA7sia2rlu0HyvY686hV8DeB90kT3+aTIUbVLr21hbpgEExHSZWTV1znOpulSRyS7O866cXrkLqWcFOEDFVjolRBi3MkDbfs4LHJlhJ6vqZRcGBWvVsXauV22Hi87Ss/c7HFg4YeJTVwL001OH5Kpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713480882; c=relaxed/simple;
	bh=YhdtaVfh4088buH+XZg/IkImHaxqcTSecceCrXaDNTA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j/H+Yu75UxihZRzaVYfpPO3kOGFTnUAdfcGupEnErem8Q8UWOy6bplAAEPGaVQxPqILly79071pcUPaTwQDsj2GXfKWOvhaAXFeFC2JryrlbuzdmBciG3LatCklSwdGNsN5WX+gCNJvfBrSmkV1Y18s7reXzMxdamwlfl9l4Aqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WD/or5iL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713480879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0Qa3hR1GgJrmWTXgAvlGxLrVho0/A5qeW+iYF0awOyc=;
	b=WD/or5iLokdv12x7J6kufpcpOgNr6YTZ2zDrCIa2R+8h5YOOsb9EelWHmxY4ZoXPKNw4p3
	H9ixZTGXGTiXg442oLNKNOO0bI2f9MILVRlRjLDlWxaYEPXYpX0v05Z3G18yK9gPAeWqaQ
	kPv0O+/uJVX1XZOPey5s3hjGh9WmTrg=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-y9ahBIBRMWGVGNvX2V5swg-1; Thu, 18 Apr 2024 18:54:38 -0400
X-MC-Unique: y9ahBIBRMWGVGNvX2V5swg-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-36b36e64789so23586735ab.0
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 15:54:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713480877; x=1714085677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Qa3hR1GgJrmWTXgAvlGxLrVho0/A5qeW+iYF0awOyc=;
        b=mxCr0nlbFi3RMLDq4yO3qJmYCxtmihlMzmDp0R3yUs5e0BqKvwsFbQwYaz5trRlten
         BG9KH1PLxCVwT28mo80OIwF24mD8TwxyOjLTrqkrULkh4oG7tjP85IJxvU4k9fXaZU7K
         757igmtSr9v9egSO5zH9LHWrgDR+MVyUJxnq0cnKNuQKEJ3RfibMFBM2SI9vEovmalN4
         MVpIA6UJRe4+Mcp3bbhrkfHhL1LAkRXocUSmq7x1NzmsGwIxc08jXPZJiy9fO+3XM+xY
         hao/ewL37wHnBPfrf70+eiGi1YC+1nXvMWIoHZF6Hhi4hcT2dHvyzLG5Xs/BPqi/wGXm
         e8iw==
X-Forwarded-Encrypted: i=1; AJvYcCXhfzEYxHyXCTXHO3s/TSXQaVmJZoKU5Xjc+Sf5PCUVuDJ9+IZD4JxU/pgNMoNK740zpw01khgASoO6s1cbFkuP+P4B
X-Gm-Message-State: AOJu0YyKLXbzqiByDOGS876h5WY6D9U4IqaX3KaTeMf7h/JNUv/KJfDe
	WfF3ZxCYSj+/J5RQBzGta37gwizIm0RBXldYrkZ++8nH0K/jf4nMnvDiMhv3dzamynq0VGqxBmc
	t0zOTzpV1McZ4JbDCKAYHD7hfAySVNv/gs3PQo9EOjQOsjgkDCg==
X-Received: by 2002:a05:6e02:1688:b0:36b:36b:1115 with SMTP id f8-20020a056e02168800b0036b036b1115mr5408052ila.1.1713480877276;
        Thu, 18 Apr 2024 15:54:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IElkIPKIuNl9ph1Phq9PzvzzBElJf7MnvsKrZ/DLV6aq5UhFYH+VCNTGKZAYpXsg0QJpGLyAg==
X-Received: by 2002:a05:6e02:1688:b0:36b:36b:1115 with SMTP id f8-20020a056e02168800b0036b036b1115mr5408028ila.1.1713480876877;
        Thu, 18 Apr 2024 15:54:36 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id i3-20020a05663813c300b00482f19f6d4csm650381jaj.110.2024.04.18.15.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 15:54:36 -0700 (PDT)
Date: Thu, 18 Apr 2024 16:54:34 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Xin Zeng <xin.zeng@intel.com>
Cc: herbert@gondor.apana.org.au, jgg@nvidia.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, qat-linux@intel.com,
 Yahui Cao <yahui.cao@intel.com>
Subject: Re: [PATCH v6 1/1] vfio/qat: Add vfio_pci driver for Intel QAT
 SR-IOV VF devices
Message-ID: <20240418165434.1da52cf0.alex.williamson@redhat.com>
In-Reply-To: <20240417143141.1909824-2-xin.zeng@intel.com>
References: <20240417143141.1909824-1-xin.zeng@intel.com>
	<20240417143141.1909824-2-xin.zeng@intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Apr 2024 22:31:41 +0800
Xin Zeng <xin.zeng@intel.com> wrote:

> Add vfio pci variant driver for Intel QAT SR-IOV VF devices. This driver
> registers to the vfio subsystem through the interfaces exposed by the
> susbsystem. It follows the live migration protocol v2 defined in
> uapi/linux/vfio.h and interacts with Intel QAT PF driver through a set
> of interfaces defined in qat/qat_mig_dev.h to support live migration of
> Intel QAT VF devices.

=46rom here down could actually just be a comment towards the top of the
driver.

> The migration data of each Intel QAT GEN4 VF device is encapsulated into
> a 4096 bytes block. The data consists of two parts.
>=20
> The first is a pre-configured set of attributes of the VF being migrated,
> which are only set when it is created. This can be migrated during pre-co=
py
> stage and used for a device compatibility check.
>=20
> The second is the VF state. This includes the required MMIO regions and
> the shadow states maintained by the QAT PF driver. This part can only be
> saved when the VF is fully quiesced and be migrated during stop-copy stag=
e.
>=20
> Both these 2 parts of data are saved in hierarchical structures including
> a preamble section and several raw state sections.
>=20
> When the pre-configured part of the migration data is fully retrieved from
> user space, the preamble section are used to validate the correctness of
> the data blocks and check the version compatibility. The raw state
> sections are then used to do a device compatibility check.
>=20
> When the device transits from RESUMING state, the VF states are extracted
> from the raw state sections of the VF state part of the migration data and
> then loaded into the device.
>=20
> This version only covers migration for Intel QAT GEN4 VF devices.
>=20
> Co-developed-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Xin Zeng <xin.zeng@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  MAINTAINERS                   |   8 +
>  drivers/vfio/pci/Kconfig      |   2 +
>  drivers/vfio/pci/Makefile     |   2 +
>  drivers/vfio/pci/qat/Kconfig  |  12 +
>  drivers/vfio/pci/qat/Makefile |   3 +
>  drivers/vfio/pci/qat/main.c   | 679 ++++++++++++++++++++++++++++++++++
>  6 files changed, 706 insertions(+)
>  create mode 100644 drivers/vfio/pci/qat/Kconfig
>  create mode 100644 drivers/vfio/pci/qat/Makefile
>  create mode 100644 drivers/vfio/pci/qat/main.c
...
> +static struct file *qat_vf_pci_step_device_state(struct qat_vf_core_devi=
ce *qat_vdev, u32 new)
> +{
> +	u32 cur =3D qat_vdev->mig_state;
> +	int ret;
> +
> +	/*
> +	 * As the device is not capable of just stopping P2P DMAs, suspend the
> +	 * device completely once any of the P2P states are reached.
> +	 * On the opposite direction, resume the device after transiting from
> +	 * the P2P state.
> +	 */
> +	if ((cur =3D=3D VFIO_DEVICE_STATE_RUNNING && new =3D=3D VFIO_DEVICE_STA=
TE_RUNNING_P2P) ||
> +	    (cur =3D=3D VFIO_DEVICE_STATE_PRE_COPY && new =3D=3D VFIO_DEVICE_ST=
ATE_PRE_COPY_P2P)) {
> +		ret =3D qat_vfmig_suspend(qat_vdev->mdev);
> +		if (ret)
> +			return ERR_PTR(ret);
> +		return NULL;
> +	}

This doesn't appear to be a valid way to support P2P, the P2P states
are defined as running states.  The guest driver may legitimately
access and modify the device state during P2P states.  Should this
device be advertising support for P2P?  Thanks,

Alex


