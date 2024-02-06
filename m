Return-Path: <kvm+bounces-8144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E620484BE68
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 21:06:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14B0D1C22A95
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 20:06:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E38BF17744;
	Tue,  6 Feb 2024 20:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U8/nwTvK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8F71AADA
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 20:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707249997; cv=none; b=MhpvR7hTJ2lmiCCTae+HRgJVQOpgqtRjbU6hrMJLA7iZVijg/vwM2Mz3dJvkxD2SmzzyadiTX2XqggRSCupuxai9b1Kt/rfuwzwSeCZtc9teC6gSweftoAc8VvCVGhLnDg+nIqSbaHLOL7THehfaZ03zWgEOLKVz2fTbi06qRHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707249997; c=relaxed/simple;
	bh=PlwzN8x3eCddfNLwl0tQFZUsWaNW3CGdFeSD9FE45xU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hE53Lf2UNFbDRPZoEJjbJtxyg5aQLPs8G3fimY7z3Awi+vAh2tqXiEzEcXzw7871mYI+6pjYUEbR4/xwyRhN5NGqwjh3VmFeEDSbYyG5BXkXROJzIj09+W4vfs3DBfdtuVVRZvqxguXt2aFRCXX/igdkK/PbnsHLEq5svE+zLEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U8/nwTvK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707249993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i/cd++jXszRXmfjXBwbNRqBwPxegiEkXzkrYtiCv0c8=;
	b=U8/nwTvKJsfMtqE9DdVM4mDRtMuivNQg2jfo2G/cHpK1RbI1COhuvw/RxuuqPFex5P6eFv
	vv/X9pdbysl+OBi18aXTPVEjjOjBcA97JyPUdiWTIVUzZRDwHWIk1qnVgW2IJWaDKCXBj4
	IKaota8H0uM5CBErSTBQ59JJ32ITGTc=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-Xk6O1A7mPMufbhbYrYJX4g-1; Tue, 06 Feb 2024 15:06:31 -0500
X-MC-Unique: Xk6O1A7mPMufbhbYrYJX4g-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-59922b09256so5865884eaf.2
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 12:06:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707249991; x=1707854791;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i/cd++jXszRXmfjXBwbNRqBwPxegiEkXzkrYtiCv0c8=;
        b=QTr7w0qjuedrQ3bjMrIjq/jZ9905nWYQT0eXnheGNIReizKV4kI3o6YV1TF0yI5PZP
         ul7heyQiVwfQezKShnr8k/oHEXeHlhK5FIapRDqNWHQPZcrgNcgRulj4MsU3yIynQH3n
         cMYM/VBV7Wi5c7vu6rwNzwTqCo4KiItGqs98VvRXFhIh6DC7tHiiWk0KZnEqISpc7mUj
         yC1lSRAE7S6EXIZPT6yujxhWTqNI1w5bJZF0skbxApQP8YNbEc0vHsy1cx5nr+VvU7PQ
         UR6crei+EirImEcafQzOWL3Hwho/+FhmnHjSUfqO2h+jxx7dgD6/SKGT4d9GqYLoJE5n
         YTGg==
X-Gm-Message-State: AOJu0YzEtzU54ggqeE+sj1d/yxbZ0HiuUxyLmvrrRVAFwawSc2eVk3ps
	ve0u/xUlm8+7CxKVowxVHkDQCit9IWcPGoJeCaT1U9SH+o5A825P30fFW4ZdaiLNV3kDyQYHdx7
	/qLywn5ZmzJMI5A9uHxzQzOQoA4E+z74WieJ9YeTL6R9wKtnbGw==
X-Received: by 2002:a4a:8112:0:b0:59c:8b80:fe3e with SMTP id b18-20020a4a8112000000b0059c8b80fe3emr3080588oog.7.1707249991154;
        Tue, 06 Feb 2024 12:06:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFJwnWL1LGz3lFyVKe1dlWAr2U11D5Zjkj6P8Frn4x+0vRY5zeaZeq+tu6iHoegpEk7pc/9Bg==
X-Received: by 2002:a4a:8112:0:b0:59c:8b80:fe3e with SMTP id b18-20020a4a8112000000b0059c8b80fe3emr3080568oog.7.1707249990851;
        Tue, 06 Feb 2024 12:06:30 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXTlxv9RzqLCQNh9HJ7dSEM6u9dfW+aPvwY4ta3GiTxq7u4+IR4p/bnaJcGc57IteapASuaQESeyIaa2RM2mFIzrI/znQlTiv6yqgA2ckgbIoRE98/kvZAK5X3Rt9+nXNOjaN4IzNMNTzulBSnALH/JACVxliCZLGNHU9vphCiIsWNRmKyFOFkv83DwTzOsxnD5JdtO8NnVAn5ThS61u6+jU2pzf0aFR3EP/pFLOCckE7lbI2CZdG69P13Byh78UP5WRUa4cze+bTeQXp436I+w7qHOdPcAN6TtjPZIVmvdtq9bl1DL6y0U/4pcUifCDS5AxdynY5yGWWC3zmt3Ex8NSyhauqfLa/BuEd38oeI=
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id h1-20020a4a6f01000000b0059a975f3b8esm433475ooc.33.2024.02.06.12.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 12:06:30 -0800 (PST)
Date: Tue, 6 Feb 2024 13:06:27 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: "Liu, Monk" <Monk.Liu@amd.com>
Cc: Leon Romanovsky <leon@kernel.org>, "Deng, Emily" <Emily.Deng@amd.com>,
 "bhelgaas@google.com" <bhelgaas@google.com>, "linux-pci@vger.kernel.org"
 <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "Jiang, Jerry (SW)" <Jerry.Jiang@amd.com>, "Zhang,
 Andy" <Andy.Zhang@amd.com>, "Chang, HaiJun" <HaiJun.Chang@amd.com>, "Chen,
 Horace" <Horace.Chen@amd.com>, "Yin, ZhenGuo (Chris)" <ZhenGuo.Yin@amd.com>
Subject: Re: [PATCH 1/2] PCI: Add VF reset notification to PF's VFIO user
 mode driver
Message-ID: <20240206130627.5c10fec7.alex.williamson@redhat.com>
In-Reply-To: <BL1PR12MB526972B4E7CF6B2C993A2E6984462@BL1PR12MB5269.namprd12.prod.outlook.com>
References: <20240205071538.2665628-1-Emily.Deng@amd.com>
	<20240205090438.GB6294@unreal>
	<BL1PR12MB526972B4E7CF6B2C993A2E6984462@BL1PR12MB5269.namprd12.prod.outlook.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Feb 2024 04:08:18 +0000
"Liu, Monk" <Monk.Liu@amd.com> wrote:

> [AMD Official Use Only - General]
>=20
> Hi Leon
>=20
> The thing is when qemu reset a VM it calls vfio=E2=80=99s reset ioctl to =
the
> given VF device, and in kernel the VFIO-pci module will do the reset
> to that VF device via its PCI config space register, but
> unfortunately our VF GPU isnot designed to support those
> =E2=80=9Creset=E2=80=9D/=E2=80=9Dflr=E2=80=9D commands =E2=80=A6 not supp=
orted by the VF, (and even many PF
> cannot handle those commands well)

PFs are not required to implement FLR, VFs are.

SR-IOV spec, rev. 1.1:

	2.2.2. FLR That Targets a VF

	VFs must support Function Level Reset (FLR).

>=20
> So the idea we can cook up is to move those Vf=E2=80=99s reset notificati=
on
> to our PF driver (which is a user mode driver running on PF=E2=80=99s VFIO
> arch), and our user mode driver can program HW and do the reset for
> that VF.

The PF driver being able to arbitrarily reset a VF device provided to
another userspace process doesn't sound like separate, isolated
devices.  What else can the PF access?

As noted in my other reply, vf-tokens should not be normalized and
users of VFs provided by third party userspace PF drivers should
consider the device no less tainted than if it were provided by an
out-of-tree kernel driver.

The idea to virtualize FLR on the VF to resolve the hardware defect is a
good one, but it should be done in the context of a vfio-pci variant
driver.  Thanks,

Alex


> From: Leon Romanovsky <leon@kernel.org>
> Date: Monday, February 5, 2024 at 17:04
> To: Deng, Emily <Emily.Deng@amd.com>
> Cc: bhelgaas@google.com <bhelgaas@google.com>,
> alex.williamson@redhat.com <alex.williamson@redhat.com>,
> linux-pci@vger.kernel.org <linux-pci@vger.kernel.org>,
> linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>,
> kvm@vger.kernel.org <kvm@vger.kernel.org>, Jiang, Jerry (SW)
> <Jerry.Jiang@amd.com>, Zhang, Andy <Andy.Zhang@amd.com>, Chang,
> HaiJun <HaiJun.Chang@amd.com>, Liu, Monk <Monk.Liu@amd.com>, Chen,
> Horace <Horace.Chen@amd.com>, Yin, ZhenGuo (Chris)
> <ZhenGuo.Yin@amd.com> Subject: Re: [PATCH 1/2] PCI: Add VF reset
> notification to PF's VFIO user mode driver On Mon, Feb 05, 2024 at
> 03:15:37PM +0800, Emily Deng wrote:
> > VF doesn't have the ability to reset itself completely which will
> > cause the hardware in unstable state. So notify PF driver when the
> > VF has been reset to let the PF resets the VF completely, and
> > remove the VF out of schedule. =20
>=20
>=20
> I'm sorry but this explanation is not different from the previous
> version. Please provide a better explanation of the problem, why it is
> needed, which VFs need and can't reset themselves, how and why it
> worked before e.t.c.
>=20
> In addition, please follow kernel submission guidelines, write
> changelong, add versions, cover letter e.t.c.
>=20
> Thanks
>=20
> >
> > How to implement this?
> > Add the reset callback function in pci_driver
> >
> > Implement the callback functin in VFIO_PCI driver.
> >
> > Add the VF RESET IRQ for user mode driver to let the user mode
> > driver know the VF has been reset.
> >
> > Signed-off-by: Emily Deng <Emily.Deng@amd.com>
> > ---
> >  drivers/pci/pci.c   | 8 ++++++++
> >  include/linux/pci.h | 1 +
> >  2 files changed, 9 insertions(+)
> >
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index 60230da957e0..aca937b05531 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -4780,6 +4780,14 @@ EXPORT_SYMBOL_GPL(pcie_flr);
> >   */
> >  int pcie_reset_flr(struct pci_dev *dev, bool probe)
> >  {
> > +     struct pci_dev *pf_dev;
> > +
> > +     if (dev->is_virtfn) {
> > +             pf_dev =3D dev->physfn;
> > +             if (pf_dev->driver->sriov_vf_reset_notification)
> > +
> > pf_dev->driver->sriov_vf_reset_notification(pf_dev, dev);
> > +     }
> > +
> >        if (dev->dev_flags & PCI_DEV_FLAGS_NO_FLR_RESET)
> >                return -ENOTTY;
> >
> > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > index c69a2cc1f412..4fa31d9b0aa7 100644
> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -926,6 +926,7 @@ struct pci_driver {
> >        int  (*sriov_configure)(struct pci_dev *dev, int num_vfs);
> > /* On PF */ int  (*sriov_set_msix_vec_count)(struct pci_dev *vf,
> > int msix_vec_count); /* On PF */ u32
> > (*sriov_get_vf_total_msix)(struct pci_dev *pf);
> > +     void  (*sriov_vf_reset_notification)(struct pci_dev *pf,
> > struct pci_dev *vf); const struct pci_error_handlers *err_handler;
> >        const struct attribute_group **groups;
> >        const struct attribute_group **dev_groups;
> > --
> > 2.36.1
> >
> > =20


