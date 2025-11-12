Return-Path: <kvm+bounces-62912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8800AC53D24
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 19:00:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0D333AC3FD
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 17:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 407FA34889A;
	Wed, 12 Nov 2025 17:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2zJEQyMI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE05329E57
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 17:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762969927; cv=none; b=FWR0UgjC/KP/1Z5Zhdsd9puJCPpYvv4j6sar/vXYIpFfFH6AKmELIVdOneeoxSzSk+2T0eq0WMZ2l9Wrw0ukGgt8WR/3MFxU9x0LssQkXDqXH1OMo/VvOWAkSZVaeapnLAcpz1V1zbGjAlQMCY64jE46X8w7iwDRWgd6c67Y4ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762969927; c=relaxed/simple;
	bh=1nPIUcHHQkGuDuEReWgowmjbEJHx+aY1oV5caXaVwD0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N74LHzEb0kfI6yfXxv3YzH1096XhZwwKXFURpnofAaOD5MFLE7RSLEAo7RLS/1WubmfiuPeY6oeKSTAM/lNjZaqKo7dH3FRdwjiK3yl5kNjJK6wqiIH7bKArlTelPz6HR7ynHQB7VdiceSryUZYHI+fjGi455cBQhLNYuW+1E6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2zJEQyMI; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-59469969bfeso1133227e87.1
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 09:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762969923; x=1763574723; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BWA7RPE90uWMLfiUEvRQf9rnUzfEKRuTRKW0waWBvtU=;
        b=2zJEQyMIAJAdo9vqhXORUdvc6P0MXQ2oFmtoja0cFdQyb7HSGB1spfO54Zk5aVNIp3
         Gcdybo19o/ICsOGjKjdxVO5k9jZ+jwnMI2+InMjLwY7oenJ5sUruyunwAYiS2STC9Cy5
         CJ5nftQvk8rk0a3GKe+VUdmivOf1rQI+gA/I+Fkkd0XfVJodhOphTpiti10SdT+Iy2kP
         6b7/RxcxdrcLHAeIeDrcp3WAaJfm8Pwely8gpVa6iDXmL8noCEmT4dxCdf+eiKC0jhA3
         ocCcldVMAfN9jbIIRBvKCaWSi8zyP3Ah3FAPCVBS64FHGEy+yWAiWVWJ1Nj5MfBR6nTV
         299w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762969923; x=1763574723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BWA7RPE90uWMLfiUEvRQf9rnUzfEKRuTRKW0waWBvtU=;
        b=bmkGJc2HcWb4ZwRNGK+fGd5xCDt/kE2qmpr2g6HEArOzN334BHwXhSUXBB9aFMIirA
         lcMBImj5FpNjzUbHazvM1ued9S7DdZSm1kRJEZIgTqlg+RIyxRybRICCSrjQSMoFRLr0
         xpD569rhIaI4i6dp0bBSK/vnU09g1+HoxiI7XhGHyLYAbuF4CiSgI1kcHjfXGx2xqIKC
         t6Yo4+6xjpqoIcpGdTKgBzDt/cdMvcfxEW+JMy0xB37EdcSvoPkYIBt2JA91QlOJrVgQ
         RaWhJL0Osn++zJ9nFTwnamEkZSI5SGiVtoP/4407y+zKt1UreQiMyf+iSJ5RcvbCOcGj
         nbeA==
X-Forwarded-Encrypted: i=1; AJvYcCX4seEDPW3RjMJsA9bT+0xH9CIfyGRqcJHQirPhYtAoxmCP3RNgrp3Ybu/eXFaNMQ5PakM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8XQo01pgjwYsg8/xC3nBqqVhqZdqsC6BxMdub7vkgfyWrlqPG
	gOO62LW9ISOpWOGk2KxcWqiIX8yO/b9ehsV0HDY/ceonuoiYi9e86KfbPk0KhhfCntvtJQlUJOt
	hgf18yOhRb6UCjw0MEIpCJY7cV22wNcFatzRLzqiL
X-Gm-Gg: ASbGncsJDvkcCRe8G3pk04hv+IzID3rG+ckzTL8rLP0JIJNBXCwyM3AHoR4WSjYtWOs
	cZD6LNUULDwUiB/7IK/6mYMKl9GdmOi+Ou3qyR+EJdJ/vgcJgD4qSnQ33SWk1eTDb4x+JAqEP/z
	H7ECoXM2oL6NrPXq7lv+CIc6Fl5x1DjaFkKihoFN/SRUXE9mhkMBU8ctNZXwKAy3dY2Xjjh8/gB
	C8WyjRi7QOQ+zdv84GMt0XCGf/b9ptp8auHhM6eP+XN1eqngS16Px18+o8jgihW7Ld/nU4=
X-Google-Smtp-Source: AGHT+IGZlui+q5RWh2nUGIJx37r549PQ7MH8JxhyuFkGiNy9V2zSJZ657BZLVXRVqOqTvVTllHIpqyOu4vKlX8Ljo0M=
X-Received: by 2002:a05:6512:1318:b0:591:ec0f:fa92 with SMTP id
 2adb3069b0e04-59576df34f9mr1398580e87.3.1762969923158; Wed, 12 Nov 2025
 09:52:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251111-iova-ranges-v3-0-7960244642c5@fb.com>
 <CALzav=cmkiFUjENpYk3TT7czAeoh8jzp4WX_+diERu7JhyGCpA@mail.gmail.com> <aRTGbXB6gtkKVnLo@devgpu015.cco6.facebook.com>
In-Reply-To: <aRTGbXB6gtkKVnLo@devgpu015.cco6.facebook.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 12 Nov 2025 09:51:35 -0800
X-Gm-Features: AWmQ_bnMhC8vCEPOclLuVLWYsWBnpTFPjnWiWBSvozOncRXWquyM5KNqmbyfacg
Message-ID: <CALzav=fwE2kPqJUiB2J20pK5bH_-1XvONQXz1DpsMSOCKa=X+g@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] vfio: selftests: update DMA mapping tests to use
 queried IOVA ranges
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2025 at 9:40=E2=80=AFAM Alex Mastro <amastro@fb.com> wrote:
>
> Hey David, is vfio_pci_driver_test known to be in good shape? Both on the=
 base
> commit and after my series, I am seeing below, which results in a KSFT_SK=
IP.
> Invoking other tests in a similar way actually runs things with expected
> results (my devices are already bound to vfio-pci before running anything=
).
>
> base commit: 0ed3a30fd996cb0cac872432cf25185fda7e5316
>
> $ vfio_pci_driver_test -f 0000:05:00.0
> No driver found for device 0000:05:00.0
>
> Same thing using the run.sh wrapper
>
> $ sudo ./run.sh -d 0000:05:00.0 ./vfio_pci_driver_test
> + echo "0000:05:00.0" > /sys/bus/pci/drivers/vfio-pci/unbind
> + echo "vfio-pci" > /sys/bus/pci/devices/0000:05:00.0/driver_override
> + echo "0000:05:00.0" > /sys/bus/pci/drivers/vfio-pci/bind
>
> No driver found for device 0000:05:00.0
> + echo "0000:05:00.0" > /sys/bus/pci/drivers/vfio-pci/unbind
> + echo "" > /sys/bus/pci/devices/0000:05:00.0/driver_override
> + echo "0000:05:00.0" > /sys/bus/pci/drivers/vfio-pci/bind
>
> device =3D vfio_pci_device_init(device_bdf, default_iommu_mode);
> if (!device->driver.ops) {
>         fprintf(stderr, "No driver found for device %s\n", device_bdf);
>         return KSFT_SKIP;
> }
>
> Is this meant to be a placeholder for some future testing, or am I holdin=
g
> things wrong?

What kind of device are you using?

This test uses the selftests driver framework, so it requires a driver
in tools/testing/selftests/vfio/lib/drivers to function. The driver
framework allows tests to trigger real DMA and MSIs from the device in
a controlled, generic, way.

We currently only have drivers for Intel DSA and Intel CBDMA
devices.So if you're not using one of those devices,
vfio_pci_driver_test exiting with KSFT_SKIP is entirely expected.

I would love to add support for more devices. Jason Gunthrope
suggested supporting a driver for mlx5 class hardware, since it's
broadly available. I've also had some discussions about adding a
simple emulated PCIe device to QEMU for running VFIO selftests within
VMs.

