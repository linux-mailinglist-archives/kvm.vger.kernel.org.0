Return-Path: <kvm+bounces-35870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B1E7A1583D
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 20:40:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38F101688B1
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 429911AA1DA;
	Fri, 17 Jan 2025 19:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C0dJnm38"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483A51A255C
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 19:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737142790; cv=none; b=TzHrBn3JwwLJZpkGhTsdtYw9swhkP1lglybw76QaLnKYReirVASMS6xMjEMzw7+bTQA4fpadank9d2Nb7Z6DrZ2YXS519NuPYeHiZfcBgYgM0MkPogGUs0OcHkblewUJkQg1AlN3ND5951XM8QJRSIlB505skeFCtdnE3aDj6Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737142790; c=relaxed/simple;
	bh=+NaeP7GVnPCxrd1310AzmfZTsRXB4TI9L8n8gh6ZR8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zr9KpmHYZLn5Y5eZ2XI58Doysc8Dw18W1vifJ84G85HPqkRpdJIwncv88t1xJdMYNIbdARekjDj9gKuof1B+yBcawU27fpaS+ixM0/m0QfvrvHU4FsLBGHu4pXPX2w6z3n15P4rV4YPttooKiS4V8MgH79Za4OSylp7INvFg2nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C0dJnm38; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737142787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RhFaS26ZX3er7z2oL2KGkvKw+0jM0A4abyRAVN7hf/Y=;
	b=C0dJnm38wdthy+cVctsdB5nFsXRJhkklKgOQKLvuajrlOe6eWKEulQF1vgZ7UAnv/wp+wZ
	SKDl8fuBWQeTcEhzemk6xSAB8JrZDWSw1vZBNuYmV2w/LbbLLdDOq2X99HDJhSF5zQhXkk
	8FHsDeHnNVaTsJTNuoeEiPCTu/rbssc=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-KYhf_QzLMDCiUfc7qRK24w-1; Fri, 17 Jan 2025 14:39:46 -0500
X-MC-Unique: KYhf_QzLMDCiUfc7qRK24w-1
X-Mimecast-MFC-AGG-ID: KYhf_QzLMDCiUfc7qRK24w
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-849cc81984eso11631339f.1
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 11:39:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737142785; x=1737747585;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RhFaS26ZX3er7z2oL2KGkvKw+0jM0A4abyRAVN7hf/Y=;
        b=Oivx4s1A+6MuA1JhNGrlbNKnrAJ8mBvS0V56fRJYpEggJmurOl64yOY8LgP3vZNBEW
         xt3CxF0kBZRBfs65+PKrhb4Uk9udTX10mLnq6/4vtIrs2jgB+zU3COFpLFgKFXyFqyfY
         YiB+UaScJmV+EL5drHkyAXuxvfiX+GnxXVXSo1bR7sreZNMGQdMT5OyrEBu8GO7snrNe
         zWchR1w9PigH/rz0jlv541igalwcTEdHFPfrNH9ULyh2dKcvHXy5KmzElvWjs5T0Mmtf
         8Io5hXz9JlTwwZxklEfuNFsRdxpc8pbmP7VPXVsb+uCbCFjXCp/mEvFfcaMBZoC2BCln
         r7kA==
X-Forwarded-Encrypted: i=1; AJvYcCWv1hPRQ9cBSePVOuKlTSfWXtRdkSMS3BL6aN7iYkbiq90HE137gcixPsLxrhrpIA7ajSE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI0/lBdghHe504NHbWzHuThGD4YvOJtB1K89YuX+0Sx9x6Ymlt
	dzTfOuqX3wLc8kqfo1Ecza5VrsAXjYQqwx8NDT4vHPv6ijojo0cVqI8fxEjxuwy4tLXkfvJ1CWt
	aDX/qhf87euz007a7L+CEH2OB0rE4om+IigXIdiHaJvZEfOONkQ==
X-Gm-Gg: ASbGncsqD9cRZtSssxODXv7bTEPdUOrzVpVgjva+2vMiGq+neRI4WTjxBjRLnD+GXP1
	xOLj/xO8/zrtEi1VZ2bEpKOYihihgy9LQiZgQ+zrxjCsEDvn59w8Jl3LHUPsotlMI8Zkugt+PBQ
	3Zq7lOxXz7TBV3vWzIN1J+Lq1GLYr57oQGpvQM5EbxtDqHEZ+N8oTiqhzHuQmP71L7yBmn3twgI
	+rvBuQ1kcx5HxDuLdGIo04R01g68K5vkisxb+3V3K708bjnKuI6Zy+bIo4t
X-Received: by 2002:a92:cdac:0:b0:3ce:67f2:a98b with SMTP id e9e14a558f8ab-3cf7449705cmr9464745ab.3.1737142785321;
        Fri, 17 Jan 2025 11:39:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE1KTPUbjnbifY0k6s2to3F0S4DF9lrhTcf/98kcmU2Kcr/pNHddL7xKY8ycvVucn0YtorgbQ==
X-Received: by 2002:a92:cdac:0:b0:3ce:67f2:a98b with SMTP id e9e14a558f8ab-3cf7449705cmr9464635ab.3.1737142784978;
        Fri, 17 Jan 2025 11:39:44 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3cf71a758a8sm7272445ab.13.2025.01.17.11.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 11:39:44 -0800 (PST)
Date: Fri, 17 Jan 2025 14:39:28 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 "shameerali.kolothum.thodi@huawei.com"
 <shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
 <kevin.tian@intel.com>, Zhi Wang <zhiw@nvidia.com>, Aniket Agashe
 <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
 <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
 Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>,
 Dan Williams <danw@nvidia.com>, "Anuj Aggarwal (SW-GPU)"
 <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Message-ID: <20250117143928.13edc014.alex.williamson@redhat.com>
In-Reply-To: <SA1PR12MB7199C77BE13F375ACFE4377EB01B2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250117152334.2786-1-ankita@nvidia.com>
	<20250117152334.2786-4-ankita@nvidia.com>
	<20250117132736.408954ac.alex.williamson@redhat.com>
	<SA1PR12MB7199C77BE13F375ACFE4377EB01B2@SA1PR12MB7199.namprd12.prod.outlook.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Jan 2025 19:19:42 +0000
Ankit Agrawal <ankita@nvidia.com> wrote:

> >> +/*
> >> + * To reduce the system bootup time, the HBM training has
> >> + * been moved out of the UEFI on the Grace-Blackwell systems.
> >> + *
> >> + * The onus of checking whether the HBM training has completed
> >> + * thus falls on the module. The HBM training status can be
> >> + * determined from a BAR0 register.
> >> + *
> >> + * Similarly, another BAR0 register exposes the status of the
> >> + * CPU-GPU chip-to-chip (C2C) cache coherent interconnect.
> >> + *
> >> + * Poll these register and check for 30s. If the HBM training is
> >> + * not complete or if the C2C link is not ready, fail the probe.
> >> + *
> >> + * While the wait is not required on Grace Hopper systems, it
> >> + * is beneficial to make the check to ensure the device is in an
> >> + * expected state.
> >> + */
> >> +static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long timeout =3D jiffies + msecs_to=
_jiffies(POLL_TIMEOUT_MS);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 void __iomem *io;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 int ret =3D -ETIME;
> >> +
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 io =3D pci_iomap(pdev, 0, 0);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 if (!io)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 return -ENOMEM;
> >> +
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 do {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 if ((ioread32(io + C2C_LINK_BAR0_OFFSET) =3D=3D STATUS_READY) &&
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 (ioread32(io + HBM_TRAINING_BAR0_OFFSET) =3D=3D=
 STATUS_READY)) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D 0;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto reg_check_exit;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 }
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 msleep(POLL_QUANTUM_MS);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 } while (!time_after(jiffies, timeout));
> >> +
> >> +reg_check_exit:
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 pci_iounmap(pdev, io);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 return ret; =20
> >
> > We're accessing device memory here but afaict the memory enable bit of
> > the command register is in an indeterminate state.=C2=A0 What happens i=
f you
> > use setpci to clear the memory enable bit or 'echo 0 > enable' before
> > binding the driver?=C2=A0 Thanks,
> >
> > Alex =20
>=20
> Hi Alex, sorry I didn't understand how we are accessing device memory her=
e if
> the C2C_LINK_BAR0_OFFSET and HBM_TRAINING_BAR0_OFFSET are BAR0 regs.
> But anyways, I tried 'echo 0 > <sysfs_path>/enable' before device bind. I=
 am not
> observing any issue and the bind goes through.
>=20
> Or am I missing something?=20

BAR0 is what I'm referring to as device memory.  We cannot access
registers in BAR0 unless the memory space enable bit of the command
register is set.  The nvgrace-gpu driver makes no effort to enable this
and I don't think the PCI core does before probe either.  Disabling
through sysfs will only disable if it was previously enabled, so
possibly that test was invalid.  Please try with setpci:

# Read command register
$ setpci -s xxxx:xx:xx.x COMMAND
# Clear memory enable
$ setpci -s xxxx:xx:xx.x COMMAND=3D0:2
# Re-read command register
$ setpci -s xxxx:xx:xx.x COMMAND

Probe driver here now that the memory enable bit should re--back as
unset.  Thanks,

Alex


