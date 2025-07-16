Return-Path: <kvm+bounces-52662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D244B07ED1
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 22:23:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C88EA42EDD
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 20:23:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AF192BFC7B;
	Wed, 16 Jul 2025 20:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DP/AWZ3Y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED9727EFEF
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 20:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752697426; cv=none; b=QJddsCpEBeM9UZlkYXkfzfv/fvD5cbnYBuuGf1XOxvWlR3BP1odywRgG1RtjlLYZx/mQe3JTItwAp4pNQ8Ptval50eGYt8Cu5MpY8P08j2IEM9LyTfAztIXt/AK3Hg6Aj4NPEuEoVyacYHJ/sSXEMwZBsZ6+3T6OB8xN9kZdKnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752697426; c=relaxed/simple;
	bh=9y5dIKyKcHriMVF+KPx9heA9eZVH1cEEVWtkW4af3I4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L3xGAZ3JAB8b5S1dzDeQsFZVJpawzWOCC5mJsCyvmiyYvdDsY6iRRl/hekjfRYlwsze/VXZcB9xTgpico+WxpcJvvdarNDSq8pYg/frcFSRXY8Rlvxh0XuLIyWJ8rl1pdgOL58T/ZHsoUwiSz57GcrfIw/3cP+ukb+vy7kelM4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DP/AWZ3Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752697422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=My5jpWLBkASAD4KArmdY125PUanYXYQ2hsJPAgTrsRo=;
	b=DP/AWZ3Y9mwrhVjCcSBQFhSCNveiLVYIGozaJD78LWtDPrZOhAxIIVBK/HzE25RUJY9yK2
	QVpZS6Apjgk09aFKGcRvk8MFNDsKgE7KsElHNYhL54uZDCO7XQmMj7IY6dd5yJMpOhBj5m
	mxc2tu8IUnJYkgCZR5cwngdQusFAbH0=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-210-oCbPWmZqPL2XQ6sIXLMh5Q-1; Wed, 16 Jul 2025 16:23:40 -0400
X-MC-Unique: oCbPWmZqPL2XQ6sIXLMh5Q-1
X-Mimecast-MFC-AGG-ID: oCbPWmZqPL2XQ6sIXLMh5Q_1752697420
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3df410b6753so404935ab.2
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 13:23:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752697419; x=1753302219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=My5jpWLBkASAD4KArmdY125PUanYXYQ2hsJPAgTrsRo=;
        b=cTPDWdJIJowuo3dFTVXJ76ChhaZl+7c3yZF+kpCJPLrlq62d0n6j4+t0MOFCVuTfYK
         EyXvD97SoqIaO8ELbjbmbr0GJ9ezyDLlLDKAiDuNbarB6FQXHYM+5Jt5Za5Tq+xzX9dm
         ww9KadiEHpDLuk7P8nEORQ6QVkeltCU9ckQ2Puu0RP1V6zOD9xq9LnkJp/QHfHwI3qNf
         b3MF9AHKjA0aPL1Feeu2dpVaUmsA4OlSdXhy7EVGyWvgyBUgwf2XbEYtE4QANDmJeUbO
         ZjVqxilVxqL2YjLwglHKZ3PqSWiEtqVtUP0oyAD7KcNO+XAIl9Ha+keQEgfq1zgAr+f1
         Iv6g==
X-Forwarded-Encrypted: i=1; AJvYcCWn3pGh7NdnZLWRLj1fi1UArH0DuTHF8FE5Q6NCVmnHaY/TDCqR+ucTpcWB3OnGDOdlXmQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyzgab9hy/ncpcKcOuwIb94Px0E7ULsxRwyagYNRAUH595/uYDj
	EkkM5jh3JI66LraUI2iy2xKwEa8G5zP/IO6jKJ/z2eC3A+fCAGSpHFNjF0MUyuiZZFepw/RLipB
	hi4Rz5PpZAzS1mnTdyNfAILiXLLEh8N+Nwq+mpFnZGSSX7CJ2io0/3a1W9o4Acw==
X-Gm-Gg: ASbGncsFP1bxA5b4NxFIzsEXP5FPJBdELZLxl6UKwcG38ryVtNNAPn73o1J3438ftzS
	8zi05OMFdvBqhq15dM955GI3GsAO9gqbY4OqAd0ojPWLGvzTe4SSRYLOiPvBkclraz+uoRtJ9zi
	/N5oVSKRFzKsmTQqa+5Mgs6+BLHn2QZz3UGbFVOKOBsxQ2T4yta5I7rmSUFPkVi3ORVfZv4vHsq
	mKz8KnYim660Nt3B7YuVgXATgT6lc8zk3ynY8VziIkTe8twFZv3U6kSYGGiTQtbLnaAHeBXe90y
	/y1EqMtF/QAuFFnCs6vgvn7P7DUe/kojsntKs/j3ER8=
X-Received: by 2002:a05:6e02:19c7:b0:3dd:c947:b3a7 with SMTP id e9e14a558f8ab-3e28248636amr13309475ab.5.1752697419360;
        Wed, 16 Jul 2025 13:23:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMl6y7UqY2FBdwuRnrCWvwt+QUeVsLSVmif96lmdg75vZtFWDA98rR4kL8WbkV9VEitm+gsw==
X-Received: by 2002:a05:6e02:19c7:b0:3dd:c947:b3a7 with SMTP id e9e14a558f8ab-3e28248636amr13309375ab.5.1752697418882;
        Wed, 16 Jul 2025 13:23:38 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e246134e8fsm48302815ab.22.2025.07.16.13.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 13:23:38 -0700 (PDT)
Date: Wed, 16 Jul 2025 14:23:37 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: jgg@ziepe.ca, yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 kevin.tian@intel.com, linux-crypto@vger.kernel.org, qat-linux@intel.com,
 kvm@vger.kernel.org, herbert@gondor.apana.org.au,
 giovanni.cabiddu@intel.com
Subject: Re: [PATCH] vfio/qat: add support for intel QAT 6xxx virtual
 functions
Message-ID: <20250716142337.64ba908d.alex.williamson@redhat.com>
In-Reply-To: <20250715081150.1244466-1-suman.kumar.chakraborty@intel.com>
References: <20250715081150.1244466-1-suman.kumar.chakraborty@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 15 Jul 2025 09:11:50 +0100
Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com> wrote:

> From: Ma=C5=82gorzata Mielnik <malgorzata.mielnik@intel.com>
>=20
> Extend the qat_vfio_pci variant driver to support QAT 6xxx Virtual
> Functions (VFs). Add the relevant QAT 6xxx VF device IDs to the driver's
> probe table, enabling proper detection and initialization of these device=
s.
>=20
> Update the module description to reflect that the driver now supports all
> QAT generations.
>=20
> Signed-off-by: Ma=C5=82gorzata Mielnik <malgorzata.mielnik@intel.com>
> Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/vfio/pci/qat/main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/vfio/pci/qat/main.c b/drivers/vfio/pci/qat/main.c
> index 845ed15b6771..499c9e1d67ee 100644
> --- a/drivers/vfio/pci/qat/main.c
> +++ b/drivers/vfio/pci/qat/main.c
> @@ -675,6 +675,8 @@ static const struct pci_device_id qat_vf_vfio_pci_tab=
le[] =3D {
>  	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0x4941) },
>  	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0x4943) },
>  	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0x4945) },
> +	/* Intel QAT GEN6 6xxx VF device */
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0x4949) },
>  	{}
>  };
>  MODULE_DEVICE_TABLE(pci, qat_vf_vfio_pci_table);
> @@ -696,5 +698,5 @@ module_pci_driver(qat_vf_vfio_pci_driver);
> =20
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Xin Zeng <xin.zeng@intel.com>");
> -MODULE_DESCRIPTION("QAT VFIO PCI - VFIO PCI driver with live migration s=
upport for Intel(R) QAT GEN4 device family");
> +MODULE_DESCRIPTION("QAT VFIO PCI - VFIO PCI driver with live migration s=
upport for Intel(R) QAT device family");
>  MODULE_IMPORT_NS("CRYPTO_QAT");
>=20
> base-commit: bfeda8f971d01d0c1d0e3f4cf9d4e2b0a2b09d89

Applied to vfio next branch for v6.17.  Thanks,

Alex


