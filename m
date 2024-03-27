Return-Path: <kvm+bounces-12905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6805D88F07D
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 21:52:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E38481F2D1AD
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 20:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D755152537;
	Wed, 27 Mar 2024 20:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hCPZUZwS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148C713E3E4
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 20:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711572763; cv=none; b=oHubOAEGAhLcJeYfc+gkHrxmC41pjOe4aoCR7UQ93RxsU8ZQmsrNp6UEBzcywKK7gWXMwc6ySN/gYJjic1KOkRNfudEPbjM1UGjasupiUbzDZmsk8u5BRZ8ipffNASqazW/k3bqi6YHrK8tS9jE3qdr2sCT3Y+34ckrqcoqWSk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711572763; c=relaxed/simple;
	bh=5PmCKUVdsmkCjqsV3enm2twifuJuzG1ECYa7HKjUOfc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X5QJCu5QDMeigcswQWWN/D4oCnr0CORXvvEGoiYqZ7FHm3NWKR3TVVitOFbVyesdE07vx9kr7itINwDLKPPFFsseTir0C38O1ddzFF7XIfjM2iQlmGmbMjd25S4QAauE40sV+sOmKF/4Gsonk1RHRMdfzypwOWT0Z71eBQNy0k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hCPZUZwS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711572760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/pW0ojG3ndwgE/v4rM89IHsDuWEEg/21ioV3l/R79FY=;
	b=hCPZUZwSOa7uxvBV6O6ikoovCwpWXETeOSM0/+t/cBG8/GKg5h/WUFqfOkypc/neMXI89+
	QdA50ZrF37z/z1gx2VUgmyaNKw2eIs/OZJLvgggQXNmh31Sp0xzelJ06aUmGGl0lM/c/OL
	UyGX7HtCqfUtjXRlQotzfKRP1SM8XAU=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-iJlbD_FvPyy7Ak5gHIqDnw-1; Wed, 27 Mar 2024 16:52:39 -0400
X-MC-Unique: iJlbD_FvPyy7Ak5gHIqDnw-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7cc764c885bso23063039f.3
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 13:52:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711572758; x=1712177558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/pW0ojG3ndwgE/v4rM89IHsDuWEEg/21ioV3l/R79FY=;
        b=TIPtgKQsHdk45Qe2abf29FdtFifOn1iLtLMnNdrWmjGLXYM5KXpqASQ2JDRhABqF/v
         Ry2E70QrITBY4ezUn1N404w4pooVPvxlqYmw44lep2e29btkJfuj/2lN4csz0gDRxSLH
         O8n7I1an01WfFXGL97/4V1GFftNJsS7qz/Jq8VfEG/X2ieD19JehU/JtDNtBPYN/eybM
         yihiIutZPxWcJlJpYv2dO3gfqhmu0gfGt968mobjzKali0ZVMrDyqd+UJSLL7Hsd7mQt
         S29Fmac/NZ11WwLR8jneEsedQD1l5WrS2IR9rsraIu9Ht5ti194jaEEsE1e/5L2lliyi
         fXrA==
X-Forwarded-Encrypted: i=1; AJvYcCX9KOP8Zl9kyQHTOSzxg1N/G8eMgOeFoGfzgq+pFU1s/Tyl0/VE5C3dSg6piLN5NPnrvL4ZxoK4hcdXNwrd/G/o3hwi
X-Gm-Message-State: AOJu0YzonbDddyQrJ0oWPrzLn+EtHwpskD/4XLCvedP0QMVrOc0K9721
	aSepDfvYH/4yguO0G9P+g7NibHFTbHeiuyLm9MZQdx6scXaAYIA4O/5EzflKijuLJ2s6NKqvIqi
	RX4SHOYYhq1fY9tiyxht1se0PfWQdchOgIUgmq08TUFJdqDlg3A==
X-Received: by 2002:a05:6e02:1049:b0:366:4967:d932 with SMTP id p9-20020a056e02104900b003664967d932mr1106723ilj.7.1711572758768;
        Wed, 27 Mar 2024 13:52:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE14A/bVgCYGg+01T0SI2mboM+uA0nIttgSzsyNCcRhYDWKZAjKcBE2LWekEf2+X3szOtVyXg==
X-Received: by 2002:a05:6e02:1049:b0:366:4967:d932 with SMTP id p9-20020a056e02104900b003664967d932mr1106711ilj.7.1711572758504;
        Wed, 27 Mar 2024 13:52:38 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id t4-20020a92dc04000000b00366a7ec00f3sm1358370iln.40.2024.03.27.13.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 13:52:38 -0700 (PDT)
Date: Wed, 27 Mar 2024 14:52:35 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Vinayak Kale <vkale@nvidia.com>, qemu-devel@nongnu.org,
 marcel.apfelbaum@gmail.com, avihaih@nvidia.com, acurrid@nvidia.com,
 cjia@nvidia.com, zhiw@nvidia.com, targupta@nvidia.com, kvm@vger.kernel.org,
 =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@redhat.com>
Subject: Re: [PATCH v3] vfio/pci: migration: Skip config space check for
 Vendor Specific Information in VSC during restore/load
Message-ID: <20240327145235.47338c2b.alex.williamson@redhat.com>
In-Reply-To: <20240327161108-mutt-send-email-mst@kernel.org>
References: <20240322064210.1520394-1-vkale@nvidia.com>
	<20240327113915.19f6256c.alex.williamson@redhat.com>
	<20240327161108-mutt-send-email-mst@kernel.org>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Mar 2024 16:11:37 -0400
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Wed, Mar 27, 2024 at 11:39:15AM -0600, Alex Williamson wrote:
> > On Fri, 22 Mar 2024 12:12:10 +0530
> > Vinayak Kale <vkale@nvidia.com> wrote:
> >  =20
> > > In case of migration, during restore operation, qemu checks config sp=
ace of the
> > > pci device with the config space in the migration stream captured dur=
ing save
> > > operation. In case of config space data mismatch, restore operation i=
s failed.
> > >=20
> > > config space check is done in function get_pci_config_device(). By de=
fault VSC
> > > (vendor-specific-capability) in config space is checked.
> > >=20
> > > Due to qemu's config space check for VSC, live migration is broken ac=
ross NVIDIA
> > > vGPU devices in situation where source and destination host driver is=
 different.
> > > In this situation, Vendor Specific Information in VSC varies on the d=
estination
> > > to ensure vGPU feature capabilities exposed to the guest driver are c=
ompatible
> > > with destination host.
> > >=20
> > > If a vfio-pci device is migration capable and vfio-pci vendor driver =
is OK with
> > > volatile Vendor Specific Info in VSC then qemu should exempt config s=
pace check
> > > for Vendor Specific Info. It is vendor driver's responsibility to ens=
ure that
> > > VSC is consistent across migration. Here consistency could mean that =
VSC format
> > > should be same on source and destination, however actual Vendor Speci=
fic Info
> > > may not be byte-to-byte identical.
> > >=20
> > > This patch skips the check for Vendor Specific Information in VSC for=
 VFIO-PCI
> > > device by clearing pdev->cmask[] offsets. Config space check is still=
 enforced
> > > for 3 byte VSC header. If cmask[] is not set for an offset, then qemu=
 skips
> > > config space check for that offset.
> > >=20
> > > Signed-off-by: Vinayak Kale <vkale@nvidia.com>
> > > ---
> > > Version History
> > > v2->v3:
> > >     - Config space check skipped only for Vendor Specific Info in VSC=
, check is
> > >       still enforced for 3 byte VSC header.
> > >     - Updated commit description with live migration failure scenario.
> > > v1->v2:
> > >     - Limited scope of change to vfio-pci devices instead of all pci =
devices.
> > >=20
> > >  hw/vfio/pci.c | 24 ++++++++++++++++++++++++
> > >  1 file changed, 24 insertions(+) =20
> >=20
> >=20
> > Acked-by: Alex Williamson <alex.williamson@redhat.com> =20
>=20
>=20
> A very reasonable way to do it.
>=20
> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
>=20
> Merge through the VFIO tree I presume?

Yep, C=C3=A9dric said he=C2=B4d grab it for 9.1.  Thanks,

Alex
=20
> > > diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> > > index d7fe06715c..1026cdba18 100644
> > > --- a/hw/vfio/pci.c
> > > +++ b/hw/vfio/pci.c
> > > @@ -2132,6 +2132,27 @@ static void vfio_check_af_flr(VFIOPCIDevice *v=
dev, uint8_t pos)
> > >      }
> > >  }
> > > =20
> > > +static int vfio_add_vendor_specific_cap(VFIOPCIDevice *vdev, int pos,
> > > +                                        uint8_t size, Error **errp)
> > > +{
> > > +    PCIDevice *pdev =3D &vdev->pdev;
> > > +
> > > +    pos =3D pci_add_capability(pdev, PCI_CAP_ID_VNDR, pos, size, err=
p);
> > > +    if (pos < 0) {
> > > +        return pos;
> > > +    }
> > > +
> > > +    /*
> > > +     * Exempt config space check for Vendor Specific Information dur=
ing restore/load.
> > > +     * Config space check is still enforced for 3 byte VSC header.
> > > +     */
> > > +    if (size > 3) {
> > > +        memset(pdev->cmask + pos + 3, 0, size - 3);
> > > +    }
> > > +
> > > +    return pos;
> > > +}
> > > +
> > >  static int vfio_add_std_cap(VFIOPCIDevice *vdev, uint8_t pos, Error =
**errp)
> > >  {
> > >      PCIDevice *pdev =3D &vdev->pdev;
> > > @@ -2199,6 +2220,9 @@ static int vfio_add_std_cap(VFIOPCIDevice *vdev=
, uint8_t pos, Error **errp)
> > >          vfio_check_af_flr(vdev, pos);
> > >          ret =3D pci_add_capability(pdev, cap_id, pos, size, errp);
> > >          break;
> > > +    case PCI_CAP_ID_VNDR:
> > > +        ret =3D vfio_add_vendor_specific_cap(vdev, pos, size, errp);
> > > +        break;
> > >      default:
> > >          ret =3D pci_add_capability(pdev, cap_id, pos, size, errp);
> > >          break; =20
>=20


