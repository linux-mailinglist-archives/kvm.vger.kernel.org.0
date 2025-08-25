Return-Path: <kvm+bounces-55641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78CBBB346D2
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 18:16:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F08A5E2810
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 16:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9365E2FF144;
	Mon, 25 Aug 2025 16:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H21oKGXH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8199219066B
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 16:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756138554; cv=none; b=qLyHKH5XZApFGp6mpTxrZp4nXmRRVxaxn1Gs21oIHwjMKn5MNUAT7zi4Ge/5x58TSE13Xed6XIKZGteQSdzTHl1HXDmhAe/rQ4YvYYSYfAR/+13spv0orHgf5K38pcTJdMMgz881nIVOKFXpklD9gPfdalHiN9wZYF4VM/N9ues=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756138554; c=relaxed/simple;
	bh=WmG8fGf+hrklVze/8yeI11jUl7FVUGvUhs3t26LIvDM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=caclv8od7R7r39l0gcNnEKjF6Vos3tJm8o9m6JXVW3g0vExAK2sEWsTZk6i488Zl/q+VSZO6/Dm1gNSqhhVelPxUJb3dFs8OnXDxiXMjRVn+6PTuUy/SLKC28DaAVJoe80z7AIUS6PQkq4NdB1griXd25uua+m8bRgQU5qKMoKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H21oKGXH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756138551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YMaJB2IXg6JARlHyI5Qrr9yqrGhr4CvbdQejqcYgmds=;
	b=H21oKGXHr5fC29ME5IFXe5EVJXh2zlgQBESEa1Wt/7vru3pQjMrityt3ZaKyF/9YTGU7up
	ncG9WF13UumISj6/sNh9Cf9LRRhfW82Rqv1+3ql2fgz+woVWH50e6VnOFKQ6Irj8k1V58A
	6W8rpNpApqcrAoeg6ZcvSPt1Ye6tLxc=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-eslrh1YVORad8txLCNgJDw-1; Mon, 25 Aug 2025 12:15:49 -0400
X-MC-Unique: eslrh1YVORad8txLCNgJDw-1
X-Mimecast-MFC-AGG-ID: eslrh1YVORad8txLCNgJDw_1756138548
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3ee5c3c9938so133775ab.2
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 09:15:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756138548; x=1756743348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YMaJB2IXg6JARlHyI5Qrr9yqrGhr4CvbdQejqcYgmds=;
        b=RwYRA14vR93SqYlub01+uuZ61FucZ3KXGzhYY6nIXHRxIHAv8RgcUKZU+aDFWOgM4I
         WeRHIkhuwYuwwYlMeDjGgfhwwGhZ3bMnLb8c9vkLhYceKRo3wY1z6FMNPoL1kukMAq7O
         QmBaxFPRusACgRzyL8FrvvnwJxiTbMBiRUvjXMZvW12vsDhSmbZGdr9f4H+sCRCgYuTq
         gqqVCrRuDPUNDDOUsW16DcM0EUxMNO/cl4CdtA4iARluVf8gC5r2ssEE6qpdeBYArmJO
         70lmt6QPbXtNnpd1kotRLf8g24ZCV0vhya+zwjrZmZ9O6R1SnNBIGun4rx3/pT3PHgTJ
         yUrA==
X-Forwarded-Encrypted: i=1; AJvYcCVGH4a5idl2AMFbC5iyt8tmHJAjtQ4F3JtJEkbP2cPJI07KJSLkkA7R38h4jbQGRtw5w3w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgZaLVnk5AVj4/RuYTlv/NYSWMwMDV2lObct8bXnzAX2WKMyR7
	i652fPJ6BPe7cm4zKUzMMTTf465KZQPjblLMcEtWQKkWSGoaMlPcz1x/AIFaBYCfQMk8WbbHhP2
	LPnFEwWBWXobIJ+WmPPbeCTcSjgf6Db/XMbrlkaTAptv+RnDTeL6x+g==
X-Gm-Gg: ASbGncvWb6v+8iGxd0g26huhjIEwCrQsRuMWwLGDqmSxOh0UfN70VDzcYtAffqdJxi5
	J2o2yz6k6x00MKNWgIXU6QDI1+mhov5q9xPFmPdGiVSmo0bcEWr9doIDKk1b8ulUndewNUZYcSh
	4Hz8mbnFxjEtLgFpF851VeP2dKFDDe+EbSw/KnLfHw81JyEOcKO16Dv4evJuSxPyL+EijYULVeT
	nouVXIZB2FMHilD6HPSOBaKI+nSoB83xR0LvwvuJZSZHVFAfa9HKvEQkS0XqYm6locbD6DMV9cm
	qmyLBPO/cm1LD99Se+t7a7GiOWXiXSmazJCwxdn1TTI=
X-Received: by 2002:a05:6602:15d0:b0:881:57fd:a0a with SMTP id ca18e2360f4ac-886bd0eb71emr644985739f.1.1756138548138;
        Mon, 25 Aug 2025 09:15:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGjIFlPV78o9TXSSWQebg06K1/LC7xVQcpmBd6uMXwUe6ewPe7WxqyEGoRJnkmgOkrtCyL2Ig==
X-Received: by 2002:a05:6602:15d0:b0:881:57fd:a0a with SMTP id ca18e2360f4ac-886bd0eb71emr644984139f.1.1756138547600;
        Mon, 25 Aug 2025 09:15:47 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-886c8ef3378sm524963139f.2.2025.08.25.09.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 09:15:46 -0700 (PDT)
Date: Mon, 25 Aug 2025 10:15:44 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: Mostafa Saleh <smostafa@google.com>, Eric Auger <eric.auger@redhat.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, clg@redhat.com
Subject: Re: [PATCH 2/2] vfio/platform: Mark for removal
Message-ID: <20250825101544.3b3413c6.alex.williamson@redhat.com>
In-Reply-To: <aKxpyyKvYcd84Ayi@google.com>
References: <20250806170314.3768750-1-alex.williamson@redhat.com>
	<20250806170314.3768750-3-alex.williamson@redhat.com>
	<aJ9neYocl8sSjpOG@google.com>
	<20250818105242.4e6b96ed.alex.williamson@redhat.com>
	<aKNj4EUgHYCZ9Q4f@google.com>
	<00001486-b43d-4c2b-a41c-35ab5e823f21@redhat.com>
	<aKXnzqmz-_eR_bHF@google.com>
	<43f198b5-60f8-40f5-a2cd-ff21b31a91d4@redhat.com>
	<aKYvS3qgV_dW1woo@google.com>
	<aKxpyyKvYcd84Ayi@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Aug 2025 13:48:59 +0000
Pranjal Shrivastava <praan@google.com> wrote:

> On Wed, Aug 20, 2025 at 08:25:47PM +0000, Mostafa Saleh wrote:
> > Hi Eric,
> >=20
> > On Wed, Aug 20, 2025 at 06:29:27PM +0200, Eric Auger wrote: =20
> > > Hi Mostafa,
> > >=20
> > > On 8/20/25 5:20 PM, Mostafa Saleh wrote: =20
> > > > Hi Eric,
> > > >
> > > > On Tue, Aug 19, 2025 at 11:58:32AM +0200, Eric Auger wrote: =20
> > > >> Hi Mostafa,
> > > >>
> > > >> On 8/18/25 7:33 PM, Mostafa Saleh wrote: =20
> > > >>> On Mon, Aug 18, 2025 at 10:52:42AM -0600, Alex Williamson wrote: =
=20
> > > >>>> On Fri, 15 Aug 2025 16:59:37 +0000
> > > >>>> Mostafa Saleh <smostafa@google.com> wrote:
> > > >>>> =20
> > > >>>>> Hi Alex,
> > > >>>>>
> > > >>>>> On Wed, Aug 06, 2025 at 11:03:12AM -0600, Alex Williamson wrote=
: =20
> > > >>>>>> vfio-platform hasn't had a meaningful contribution in years.  =
In-tree
> > > >>>>>> hardware support is predominantly only for devices which are l=
ong since
> > > >>>>>> e-waste.  QEMU support for platform devices is slated for remo=
val in
> > > >>>>>> QEMU-10.2.  Eric Auger presented on the future of the vfio-pla=
tform
> > > >>>>>> driver and difficulties supporting new devices at KVM Forum 20=
24,
> > > >>>>>> gaining some support for removal, some disagreement, but garne=
ring no
> > > >>>>>> new hardware support, leaving the driver in a state where it c=
annot
> > > >>>>>> be tested.
> > > >>>>>>
> > > >>>>>> Mark as obsolete and subject to removal.   =20
> > > >>>>> Recently(this year) in Android, we enabled VFIO-platform for pr=
otected KVM,
> > > >>>>> and it=E2=80=99s supported in our VMM (CrosVM) [1].
> > > >>>>> CrosVM support is different from Qemu, as it doesn't require an=
y device
> > > >>>>> specific logic in the VMM, however, it relies on loading a devi=
ce tree
> > > >>>>> template in runtime (with =E2=80=9Ccompatiable=E2=80=9D string.=
..) and it will just
> > > >>>>> override regs, irqs.. So it doesn=E2=80=99t need device knowled=
ge (at least for now)
> > > >>>>> Similarly, the kernel doesn=E2=80=99t need reset drivers as the=
 hypervisor handles that. =20
> > > >>>> I think what we attempt to achieve in vfio is repeatability and =
data
> > > >>>> integrity independent of the hypervisor.  IOW, if we 'kill -9' t=
he
> > > >>>> hypervisor process, the kernel can bring the device back to a de=
fault
> > > >>>> state where the device isn't wedged or leaking information throu=
gh the
> > > >>>> device to the next use case.  If the hypervisor wants to support
> > > >>>> enhanced resets on top of that, that's great, but I think it bec=
omes
> > > >>>> difficult to argue that vfio-platform itself holds up its end of=
 the
> > > >>>> bargain if we're really trusting the hypervisor to handle these =
aspects. =20
> > > >>> Sorry I was not clear, we only use that in Android for ARM64 and =
pKVM,
> > > >>> where the hypervisor in this context means the code running in EL=
2 which
> > > >>> is more privileged than the kernel, so it should be trusted.
> > > >>> However, as I mentioned that code is not upstream yet, so it's a =
valid
> > > >>> concern that the kernel still needs a reset driver.
> > > >>> =20
> > > >>>>> Unfortunately, there is no upstream support at the moment, we a=
re making
> > > >>>>> some -slow- progress on that [2][3]
> > > >>>>>
> > > >>>>> If it helps, I have access to HW that can run that and I can re=
view/test
> > > >>>>> changes, until upstream support lands; if you are open to keepi=
ng VFIO-platform.
> > > >>>>> Or I can look into adding support for existing upstream HW(with=
 platforms I am
> > > >>>>> familiar with as Pixel-6) =20
> > > >>>> Ultimately I'll lean on Eric to make the call.  I know he's conc=
erned
> > > >>>> about testing, but he raised that and various other concerns whe=
ther
> > > >>>> platform device really have a future with vfio nearly a year ago=
 and
> > > >>>> nothing has changed.  Currently it requires a module option opt-=
in to
> > > >>>> enable devices that the kernel doesn't know how to reset.  Is th=
at
> > > >>>> sufficient or should use of such a device taint the kernel?  If =
any
> > > >>>> device beyond the few e-waste devices that we know how to reset =
taint
> > > >>>> the kernel, should this support really even be in the kernel?  T=
hanks, =20
> > > >>> I think with the way it=E2=80=99s supported at the moment we need=
 the kernel
> > > >>> to ensure that reset happens. =20
> > > >> Effectively my main concern is I cannot test vfio-platform anymore=
. We
> > > >> had some CVEs also impacting the vfio platform code base and it is=
 a
> > > >> major issue not being able to test. That's why I was obliged, last=
 year,
> > > >> to resume the integration of a new device (the tegra234 mgbe), nob=
ody
> > > >> seemed to be really interested in and this work could not be upstr=
eamed
> > > >> due to lack of traction and its hacky nature.
> > > >>
> > > >> You did not really comment on which kind of devices were currently
> > > >> integrated. Are they within the original scope of vfio (with DMA
> > > >> capabilities and protected by an IOMMU)? Last discussion we had in
> > > >> https://lore.kernel.org/all/ZvvLpLUZnj-Z_tEs@google.com/ led to the
> > > >> conclusion that maybe VFIO was not the best suited framework. =20
> > > > At the moment, Android device assignement only supports DMA capable
> > > > devices which are behind an IOMMU, and we use VFIO-platform for tha=
t,
> > > > most of our use cases are accelerators.
> > > >
> > > > In that thread, I was looking into adding support for simpler devic=
es
> > > > (such as sensors) but as discussed that won=E2=80=99t be done throu=
gh
> > > > VFIO-platform.
> > > >
> > > > Ignoring Android, as I mentioned, I can work on adding support for
> > > > existing upstream platforms (preferably ARM64, that I can get acces=
s to)
> > > > such as Pixel-6, which should make it easier to test.
> > > >
> > > > Also, we have some interest on adding new features such as run-time
> > > > power management. =20
> > >=20
> > > OK fair enough. If Alex agrees then we can wait for those efforts. Al=
so
> > > I think it would make sense to formalize the way you reset the devices
> > > (I understand the hyp does that under the hood). =20
> >=20
> > I think currently - with some help from the platform bus- we can rely on
> > the existing shutdown method, instead of specific hooks.
> > As the hypervisor logic will only be for ARM64 (at least for now), I can
> > look more into this.
> >=20
> > But I think the top priority would be to establish a decent platform to
> > test with, I will start looking into Pixel-6 (although that would need
> > to land IOMMU support for it upstream first). I also have a morello
> > board with SMMUv3, but I think it's all PCI.
> >  =20
> > > > =20
> > > >> In case we keep the driver in, I think we need to get a garantee t=
hat
> > > >> you or someone else at Google commits to review and test potential
> > > >> changes with a perspective to take over its maintenance. =20
> > > > I can=E2=80=99t make guarantees on behalf of Google, but I can cont=
ribute in
> > > > reviewing/testing/maintenance of the driver as far as I am able to.
> > > > If you want, you can add me as reviewer to the driver. =20
> > >=20
> > > I understand. I think the usual way then is for you to send a patch to
> > > update the Maintainers file. =20
> >=20
> > I see, I will send one shortly.
> >  =20
>=20
> I could contribute time to help with the maintenance effort here, if
> needed. Please let me know if you'd like that.

You can join Mostafa and post a patch to be added as a designated
reviewer.

If we're not going to deprecate vfio-platform overall for now, what
about vfio-amba and all the reset drivers?  It seems that even if
Google cares about vfio-platform, these still fall outside of what's
being used or tested.  Should we drive something like below to see what
comes out of the woodwork?:

diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
index 88fcde51f024..c6be29b2c24b 100644
--- a/drivers/vfio/platform/Kconfig
+++ b/drivers/vfio/platform/Kconfig
@@ -17,10 +17,13 @@ config VFIO_PLATFORM
 	  If you don't know what to do here, say N.
=20
 config VFIO_AMBA
-	tristate "VFIO support for AMBA devices"
+	tristate "VFIO support for AMBA devices (DEPRECATED)"
 	depends on ARM_AMBA || COMPILE_TEST
 	select VFIO_PLATFORM_BASE
 	help
+	  The vfio-amba driver is deprecated and will be removed in a
+	  future kernel release.
+
 	  Support for ARM AMBA devices with VFIO. This is required to make
 	  use of ARM AMBA devices present on the system using the VFIO
 	  framework.
diff --git a/drivers/vfio/platform/reset/Kconfig b/drivers/vfio/platform/re=
set/Kconfig
index dcc08dc145a5..70af0dbe293b 100644
--- a/drivers/vfio/platform/reset/Kconfig
+++ b/drivers/vfio/platform/reset/Kconfig
@@ -1,21 +1,21 @@
 # SPDX-License-Identifier: GPL-2.0-only
 if VFIO_PLATFORM
 config VFIO_PLATFORM_CALXEDAXGMAC_RESET
-	tristate "VFIO support for calxeda xgmac reset"
+	tristate "VFIO support for calxeda xgmac reset (DEPRECATED)"
 	help
 	  Enables the VFIO platform driver to handle reset for Calxeda xgmac
=20
 	  If you don't know what to do here, say N.
=20
 config VFIO_PLATFORM_AMDXGBE_RESET
-	tristate "VFIO support for AMD XGBE reset"
+	tristate "VFIO support for AMD XGBE reset (DEPRECATED)"
 	help
 	  Enables the VFIO platform driver to handle reset for AMD XGBE
=20
 	  If you don't know what to do here, say N.
=20
 config VFIO_PLATFORM_BCMFLEXRM_RESET
-	tristate "VFIO support for Broadcom FlexRM reset"
+	tristate "VFIO support for Broadcom FlexRM reset (DEPRECATED)"
 	depends on ARCH_BCM_IPROC || COMPILE_TEST
 	default ARCH_BCM_IPROC
 	help
diff --git a/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c b/drivers/=
vfio/platform/reset/vfio_platform_amdxgbe.c
index abdca900802d..45f386a042a9 100644
--- a/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
+++ b/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
@@ -52,6 +52,8 @@ static int vfio_platform_amdxgbe_reset(struct vfio_platfo=
rm_device *vdev)
 	u32 dma_mr_value, pcs_value, value;
 	unsigned int count;
=20
+	dev_err_once(vdev->device, "DEPRECATION: VFIO AMD XGBE platform reset is =
deprecated and will be removed in a future kernel release\n");
+
 	if (!xgmac_regs->ioaddr) {
 		xgmac_regs->ioaddr =3D
 			ioremap(xgmac_regs->addr, xgmac_regs->size);
diff --git a/drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c b/driver=
s/vfio/platform/reset/vfio_platform_bcmflexrm.c
index 1131ebe4837d..51c9d156f307 100644
--- a/drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c
+++ b/drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c
@@ -72,6 +72,8 @@ static int vfio_platform_bcmflexrm_reset(struct vfio_plat=
form_device *vdev)
 	int rc =3D 0, ret =3D 0, ring_num =3D 0;
 	struct vfio_platform_region *reg =3D &vdev->regions[0];
=20
+	dev_err_once(vdev->device, "DEPRECATION: VFIO Broadcom FlexRM platform re=
set is deprecated and will be removed in a future kernel release\n");
+
 	/* Map FlexRM ring registers if not mapped */
 	if (!reg->ioaddr) {
 		reg->ioaddr =3D ioremap(reg->addr, reg->size);
diff --git a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c b/dri=
vers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
index 63cc7f0b2e4a..a298045a8e19 100644
--- a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
+++ b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
@@ -50,6 +50,8 @@ static int vfio_platform_calxedaxgmac_reset(struct vfio_p=
latform_device *vdev)
 {
 	struct vfio_platform_region *reg =3D &vdev->regions[0];
=20
+	dev_err_once(vdev->device, "DEPRECATION: VFIO Calxeda xgmac platform rese=
t is deprecated and will be removed in a future kernel release\n");
+
 	if (!reg->ioaddr) {
 		reg->ioaddr =3D
 			ioremap(reg->addr, reg->size);
diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio=
_amba.c
index ff8ff8480968..9f5c527baa8a 100644
--- a/drivers/vfio/platform/vfio_amba.c
+++ b/drivers/vfio/platform/vfio_amba.c
@@ -70,6 +70,8 @@ static int vfio_amba_probe(struct amba_device *adev, cons=
t struct amba_id *id)
 	struct vfio_platform_device *vdev;
 	int ret;
=20
+	dev_err_once(&adev->dev, "DEPRECATION: vfio-amba is deprecated and will b=
e removed in a future kernel release\n");
+
 	vdev =3D vfio_alloc_device(vfio_platform_device, vdev, &adev->dev,
 				 &vfio_amba_ops);
 	if (IS_ERR(vdev))


