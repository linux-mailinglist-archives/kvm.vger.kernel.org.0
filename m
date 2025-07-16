Return-Path: <kvm+bounces-52588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 903C9B07061
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 10:23:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB67A1C2363E
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 08:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B62D62EACF1;
	Wed, 16 Jul 2025 08:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ju9r0yge"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A462EAB82;
	Wed, 16 Jul 2025 08:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752654150; cv=none; b=PyPUsYMqow+KZfdNQOsWdxtx3WKjxudlI6j8orbfBw3v9n4Eb72CTN71UP/JcQT4YoAyWV5nUf+OXaOoMcizHMyyb28PlwkDgjIfLPnoCayPZutso7aRPnTcJME21WgxNIUcLyR6xVVQAaoDezFVYqd7xoK3MPRPUpm7x1OXU1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752654150; c=relaxed/simple;
	bh=V4D522z6UUEGIW4Wg6YSnm8NKzfzikRtghcHIDH2hWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QF994wi8pWN/2UI8sVYPhp326qGNHhCZql9NoN0jeXXYI0F28X0M0SJxvs2CmkQ5uGc/8r/3HmXzRsGhb1kUxcSyBLhVGAZZLAmJRXKnHywrdyRnrnS7UhqbdcKwnsxHLVJhI3aD9m5ZVN3IL4hjxf/0dciZ57udGGTAvPmAmaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ju9r0yge; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AC8C4CEF9;
	Wed, 16 Jul 2025 08:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752654150;
	bh=V4D522z6UUEGIW4Wg6YSnm8NKzfzikRtghcHIDH2hWc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ju9r0ygeIoehctwwAmdbT/gnfDwO9Wx9CcOiz8KdX+fbbUUW44D3fiXaJL6ORkQll
	 NStAgkyukkjf0jmlnc+7NmUNmVnsxXJtXtjpIEZfICw+MgHB6EukkgT+gI0GlE0ymn
	 0sB/lbzBlumLdjrsptDrl/3BbpnNY4NxBxXo79i7geNfD4Ip4W7E7vNPGo6MQ+HL3s
	 XNk3X9dbyeUezh1dNqRL+ALj9ijiDE+UH1Ko4if/JVXnV6dkA0fqgeaxcUjfplQznk
	 hmsDIryCvejDyEO1edOecCZ/ea1g5mxVBovVrHfR3gaLjaG7eJTDw3g71cPoAdDVUf
	 HMZZxthoAuLpg==
Date: Wed, 16 Jul 2025 10:22:27 +0200
From: Maxime Ripard <mripard@kernel.org>
To: Mario Limonciello <superm1@kernel.org>
Cc: David Airlie <airlied@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Alex Deucher <alexander.deucher@amd.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Simona Vetter <simona@ffwll.ch>, Lukas Wunner <lukas@wunner.de>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	"open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:INTEL IOMMU (VT-d)" <iommu@lists.linux.dev>, "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>, 
	"open list:VFIO DRIVER" <kvm@vger.kernel.org>, "open list:SOUND" <linux-sound@vger.kernel.org>, 
	Daniel Dadap <ddadap@nvidia.com>, Mario Limonciello <mario.limonciello@amd.com>
Subject: Re: [PATCH v8 9/9] PCI: Add a new 'boot_display' attribute
Message-ID: <20250716-upbeat-tody-of-psychology-93e2a2@houat>
References: <20250714212147.2248039-1-superm1@kernel.org>
 <20250714212147.2248039-10-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="k6j22jwrkd2tjfpl"
Content-Disposition: inline
In-Reply-To: <20250714212147.2248039-10-superm1@kernel.org>


--k6j22jwrkd2tjfpl
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v8 9/9] PCI: Add a new 'boot_display' attribute
MIME-Version: 1.0

Hi Mario,

On Mon, Jul 14, 2025 at 04:21:46PM -0500, Mario Limonciello wrote:
> From: Mario Limonciello <mario.limonciello@amd.com>
>=20
> On systems with multiple GPUs there can be uncertainty which GPU is the
> primary one used to drive the display at bootup. In order to disambiguate
> this add a new sysfs attribute 'boot_display' that uses the output of
> video_is_primary_device() to populate whether a PCI device was used for
> driving the display.
>=20
> Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
> v7:
>  * fix lkp failure
>  * Add tag
> v6:
>  * Only show for the device that is boot display
>  * Only create after PCI device sysfs files are initialized to ensure
>    that resources are ready.
> v4:
>  * new patch
> ---
>  Documentation/ABI/testing/sysfs-bus-pci |  8 +++++
>  drivers/pci/pci-sysfs.c                 | 46 +++++++++++++++++++++++++
>  2 files changed, 54 insertions(+)
>=20
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/=
testing/sysfs-bus-pci
> index 69f952fffec72..8b455b1a58852 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -612,3 +612,11 @@ Description:
> =20
>  		  # ls doe_features
>  		  0001:01        0001:02        doe_discovery
> +
> +What:		/sys/bus/pci/devices/.../boot_display
> +Date:		October 2025
> +Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
> +Description:
> +		This file indicates the device was used as a boot
> +		display. If the device was used as the boot display, the file
> +		will be present and contain "1".

It would probably be a good idea to define what a "boot display" here
is. I get what you mean, but it's pretty vague and could easily be
misunderstood.

Maxime

--k6j22jwrkd2tjfpl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaHdhQwAKCRAnX84Zoj2+
dmq9AYDxe/0Z5T43z0PYAkTEFn17IfyWd5PSFPwPt5sbAZu5sPFpkiTIYzsW8zQO
FdVNAZgBgMbsfM0ASem/uZk2LHVlbNAmBeJms8JHF/ENscuRsyCN5ltCZOVlNZM0
tOdrKjIKvw==
=zc9C
-----END PGP SIGNATURE-----

--k6j22jwrkd2tjfpl--

