Return-Path: <kvm+bounces-8139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF86084BE2E
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 20:38:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1DC08B22E4F
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 19:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C68117745;
	Tue,  6 Feb 2024 19:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Slrs2rNJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00E8175B6
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 19:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707248319; cv=none; b=oW4uVFGqN3tZUH28NGLKA2qtNmc0dwAyIAlJ9cX7fZYY85umo7vR1nbSn//mXLbQFJSWUenBMUnmcqg9dYpMS/z18VXx72E9OlefNvg+KXMbDfUUQgryU37N+IHWFWgp9CUEh4tf53qG5970qL2vnw1RXzKKIsVAyhlkPzW4tgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707248319; c=relaxed/simple;
	bh=1RKHX581Bljkl+OsLAv6WNsHz+SuqRDwBI74iH/Yddw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ICHE9a0mNyxl0X9nmMHrKZW9zmz+2jN9dG5/cCzBC8/cEnaAWsFdYlgAm0lJChx22lGFMQUI2bMGLF7a3kTHsWH8LMfLTEDwSSF9TiC2Q+VJYA8nmnoV6S85qu8VWw2dAB6BO130whaXXpWDKbws7oSfHL1BCmy7Xxx71JsqD94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Slrs2rNJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707248315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MqPXh+3PVtuj68WUVgRk8x+eLMW85S8wemYEFlZX5vA=;
	b=Slrs2rNJRTLpWiYR0+gkEOhBtO6mBnMCXJpULDLcvdNicgFGElaDAVBuD7nklj1sCMPwHs
	NOO5761Gkk4dMW1FTcDGFGjdHmLW7g6kMkrBLtZu74RIn9aKmk3fJebnOahR55FP1NZuh6
	WhuVrbMdWqCvZ3Z6+zk5hvvTflhriok=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-89w2Gvm1M5Ce3GZ3v5fv8g-1; Tue, 06 Feb 2024 14:38:34 -0500
X-MC-Unique: 89w2Gvm1M5Ce3GZ3v5fv8g-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7c0257e507cso503940339f.1
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 11:38:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707248313; x=1707853113;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MqPXh+3PVtuj68WUVgRk8x+eLMW85S8wemYEFlZX5vA=;
        b=HvseX/NNWPxmW3IrWZOAzClUv3Ph7dwZ30u9Hh5BcvtDiBXdbRewJig94tFmqstP6F
         6TUvbhOGieNxJmwkKE5M4CMYyTKsPmL6suFPka0VsDWAG1nJGKPtDhqrwYmPyBWFdmJe
         9F86EUE+grEMmr5BT6NaH5uD57f+D6G9lg/LiYdMbVqlLs7TX8vs1CdhiGBr8P09vLDK
         gYAWc4ti1hIe+QKj6YEr5DDT0TieTCaTNXtUHbbR96lVKz+/ba7Q/ihYiyjI82eBZgFX
         vvQWei2HhLNz80/7ANv7AS5SmYEKGmyRId9pWpZdvSH+3DR+VG8hsXPNcyKfPksHR44C
         axwg==
X-Gm-Message-State: AOJu0YxY9pKL997wMaVOWFkmuLT0zyq0UHebA2v7Itfd4xnWgdXEZjDO
	YL7e+cutbLNqbGYxqZ/eV4X9annpjFzqVvfFmcKfTKhd0OmN80g3tYk00qTMet6XPWwfNaYHpL0
	XxfeEMQCmd7gO+3n4oWJ7Bwok5xFAlGytW8acMgIolbfEbpLBAA==
X-Received: by 2002:a05:6602:1782:b0:7c3:e96a:5fcb with SMTP id y2-20020a056602178200b007c3e96a5fcbmr4047134iox.7.1707248313342;
        Tue, 06 Feb 2024 11:38:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFlhGLNkgIbQ9dckMCyrfmJqyyWAklye7zcr32FHH/y11OzO2y7kU7slaCk9m5h8YvLHpWZNg==
X-Received: by 2002:a05:6602:1782:b0:7c3:e96a:5fcb with SMTP id y2-20020a056602178200b007c3e96a5fcbmr4047115iox.7.1707248313038;
        Tue, 06 Feb 2024 11:38:33 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUklQHg+GFkFMMkX7zIASOCS4WYlYMt6/OK8XEGCMIThxt3GltvUMryfQmnZUfTVugZhONPd0bEifL7tGGwxsrTNjU6UIh8MVllqIbOtyA52qdTjpT24DJjpmQF0dyQIf0sa7mrxRrugORtqAWgjzTZQ56Z2F0+erf99ZilkdIANeFU9Hqf7KrAmsybt9+maJ3A67zNYaNRWu+wpkKVEDrzDoCMdKUHEHPaSf/xCo9j0xCRGsneC7bkpMExZERTqjNd2TKfdbylC/GEjr0AEUZscdZVFByWBYRw5v/P+tSQkw7nX1aWOppish53pwsy9Gx8e1eUjUIiiKlc
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id bs14-20020a056e02240e00b0036381100013sm720530ilb.67.2024.02.06.11.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 11:38:32 -0800 (PST)
Date: Tue, 6 Feb 2024 12:38:30 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: "Liu, Monk" <Monk.Liu@amd.com>
Cc: "Deng, Emily" <Emily.Deng@amd.com>, "bhelgaas@google.com"
 <bhelgaas@google.com>, "linux-pci@vger.kernel.org"
 <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "Jiang, Jerry (SW)" <Jerry.Jiang@amd.com>, "Zhang,
 Andy" <Andy.Zhang@amd.com>, "Chang, HaiJun" <HaiJun.Chang@amd.com>, "Chen,
 Horace" <Horace.Chen@amd.com>, "Yin, ZhenGuo (Chris)" <ZhenGuo.Yin@amd.com>
Subject: Re: [PATCH 1/2] PCI: Add VF reset notification to PF's VFIO user
 mode driver
Message-ID: <20240206123830.7b330790.alex.williamson@redhat.com>
In-Reply-To: <BL1PR12MB52695A24DBFFDB9809444D2284462@BL1PR12MB5269.namprd12.prod.outlook.com>
References: <20240205071538.2665628-1-Emily.Deng@amd.com>
	<20240205094330.59ca4c0a.alex.williamson@redhat.com>
	<BL1PR12MB52695A24DBFFDB9809444D2284462@BL1PR12MB5269.namprd12.prod.outlook.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Feb 2024 04:03:46 +0000
"Liu, Monk" <Monk.Liu@amd.com> wrote:

> [AMD Official Use Only - General]
>=20
> Hi Alex
>=20
> Thanks for your comment, I=E2=80=99m still not quite following you.
>=20
> >>This can be done by intercepting the userspace access to the VF FLR con=
fig space region. =20
>=20
> Would you mind let us know to do that ?

See basically any of the vfio-pci variant drivers in drivers/vfio/pci/*/

For instance the virtio-vfio-pci driver is emulating a PCI IO BAR in
config space and accesses through that BAR interact with the in-kernel
PF driver.

> our scenario is that:
> 1, vf already pass-throughed to qemu
> 2, a user mode driver on PF=E2=80=99s vfio arch is running there, and it =
want
> to receive VF=E2=80=99s reset request (by Qemu through vfio interface), a=
nd
> do some hw/fw sequences to achieve the real Vf reset goal
>=20
> >>.  I don't see that facilitating vendors to implement their PF
> >>drivers in userspace to avoid upstreaming =20
> is a compelling reason to extend the vfio-pci interface.
>=20
> Some background here (our user mode PF driver is not given the
> purpose to avoid upstream): We don=E2=80=99t see value to upstream a user
> mode pf driver that only benefit AMD device, as it must be out of
> kernel-tree so we don=E2=80=99t see where the appropriate repo for it is =
to
> upstream to =E2=80=A6 (we cannot make it in Qemu right ? otherwise Qemu w=
ill
> be over designed if it knows hw/fw details of vendors)

An in-kernel driver within the mainline kernel is the right place for
it.  I'm not asking to upstream a user mode driver, you're right that
there is no repo for that, I'm questioning the motivation for making it
a user mode PF driver in the first place.

All device drivers are essentially meant to benefit the device vendor,
but in-kernel drivers also offer a benefit to the community and users of
those devices for ongoing support and development.

Let me turn the question around, what benefit does it provide this
PF driver to exist in userspace?

Without having seen it, I'd venture that there's nothing this userspace
PF driver could do that couldn't also be done via a kernel driver,
either in-tree or out-of-tree, but the userspace driver avoids the
upstreaming work of an in-tree driver and the tainting of an
out-of-tree driver.
=20
> Isn=E2=80=99t VFIO arch intentionally to give user mode driver freedom and
> ability to manipulate the HW ?

VFIO is not intended to provide an alternative means to implement
kernel drivers.  VFIO is intended to provide secure, isolated access to
devices for userspace drivers.

What's the isolation relative to the VF if this PF driver needs to be
involved in reset?  How much VF data does the PF device have access to?

This is the reason that vfio-pci introduced the vf-token barrier with
SR-IOV support.  The intention of this vf-token is to indicate a gap in
trust.  Only another userspace process knowing the vf-token configured
by the PF userspace driver can access the device.  We should not
normalize vf-tokens.

The requirement of a vf-token for a driver not strictly developed
alongside the PF userspace driver should effectively be considered a
tainted device.

Therefore, what does this userspace PF driver offer that isn't better
reflected using the existing vfio-pci-core code split to implement a
vfio-pci variant driver, which has no need for the extension proposed
here?  Thanks,

Alex

> From: Alex Williamson <alex.williamson@redhat.com>
> Date: Tuesday, February 6, 2024 at 00:43
> To: Deng, Emily <Emily.Deng@amd.com>
> Cc: bhelgaas@google.com <bhelgaas@google.com>,
> linux-pci@vger.kernel.org <linux-pci@vger.kernel.org>,
> linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>,
> kvm@vger.kernel.org <kvm@vger.kernel.org>, Jiang, Jerry (SW)
> <Jerry.Jiang@amd.com>, Zhang, Andy <Andy.Zhang@amd.com>, Chang,
> HaiJun <HaiJun.Chang@amd.com>, Liu, Monk <Monk.Liu@amd.com>, Chen,
> Horace <Horace.Chen@amd.com>, Yin, ZhenGuo (Chris)
> <ZhenGuo.Yin@amd.com> Subject: Re: [PATCH 1/2] PCI: Add VF reset
> notification to PF's VFIO user mode driver On Mon, 5 Feb 2024
> 15:15:37 +0800 Emily Deng <Emily.Deng@amd.com> wrote:
>=20
> > VF doesn't have the ability to reset itself completely which will
> > cause the hardware in unstable state. So notify PF driver when the
> > VF has been reset to let the PF resets the VF completely, and
> > remove the VF out of schedule.
> >
> > How to implement this?
> > Add the reset callback function in pci_driver
> >
> > Implement the callback functin in VFIO_PCI driver.
> >
> > Add the VF RESET IRQ for user mode driver to let the user mode
> > driver know the VF has been reset. =20
>=20
> The solution that already exists for this sort of issue is a vfio-pci
> variant driver for the VF which communicates with an in-kernel PF
> driver to coordinate the VF FLR with the PF driver.  This can be done
> by intercepting the userspace access to the VF FLR config space
> region.
>=20
> This solution of involving PCI-core and extending the vfio-pci
> interface only exists for userspace PF drivers.  I don't see that
> facilitating vendors to implement their PF drivers in userspace to
> avoid upstreaming is a compelling reason to extend the vfio-pci
> interface.  Thanks,
>=20
> Alex
>=20
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
> >        const struct attribute_group **dev_groups; =20


