Return-Path: <kvm+bounces-69648-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YABEEA38e2n4JgIAu9opvQ
	(envelope-from <kvm+bounces-69648-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 01:32:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 00C56B5EE9
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 01:32:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D1F97302B51B
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 00:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1891D296BBF;
	Fri, 30 Jan 2026 00:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="eEaDTQq+"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DD1DD27E;
	Fri, 30 Jan 2026 00:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769733116; cv=none; b=Ku1jTlPE9hz4bJCP0t6gzwYjFwvjHd7g/oVY/IOUaBWpojhHWgUTW6dFhf2wh0EcgR7/UOKrqTekBCrBynqTwg1Ul4X3JHuU1VbBnCs6fyfunqbKBY1EO2oltAQx3Acdvadoc8UbbLnRxL37FmJu9NtNvuFuIAWyIYiMGD4bGQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769733116; c=relaxed/simple;
	bh=iKHyY2AgpsoE57kanXCC6ExkTSdYkPtSVMy6708F8GM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q+5swqGJfwKwXxHaVCNinYXLUbOgXNujYI5bMkxpZh5rsWDUmwC8W2aS6ION9MTJHIcXmLm08QwPqB7iTmjlg3PzLUYfCrFMQ9/AxOFFi/g3LM1Yc3ZIoainHxHDOkh3rsFqxDcskPBkBs+8JXB2kGkVgGSV5rPSjaYCP8XpfIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=eEaDTQq+; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from localhost (unknown [52.148.140.42])
	by linux.microsoft.com (Postfix) with ESMTPSA id 02ED820B7167;
	Thu, 29 Jan 2026 16:31:52 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 02ED820B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1769733114;
	bh=5QTLnbHZvfOsZm6P1XTvKuZKL+X4Zqmm8W+hY1sTkg8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eEaDTQq+Esr/RUhilvTOCceWy537iSweTVrOCQF87LN7ewfzzEyzyd4RUlTpzT2bW
	 kg7uIcbs9tYpacoilvpa5mW4vUKyQ+xSa6CjgGAzcB47rSlnza3XRXVmL0xeyblupb
	 26ODqz1MAroYBEfMeqzG7EalDwPpbFYk2tLsdDZs=
Date: Thu, 29 Jan 2026 16:31:50 -0800
From: Jacob Pan <jacob.pan@linux.microsoft.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran
 <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro
 <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, Bjorn
 Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, David Rientjes
 <rientjes@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke
 <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>,
 kexec@lists.infradead.org, kvm@vger.kernel.org, Leon Romanovsky
 <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, =?utf-8?Q?Mich?=
 =?utf-8?Q?a=C5=82?= Winiarski <michal.winiarski@intel.com>, Mike Rapoport
 <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta
 <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, Shuah Khan
 <skhan@linuxfoundation.org>, Thomas =?utf-8?Q?Hellstr=C3=B6m?=
 <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>,
 Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy
 <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu
 <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
Message-ID: <20260129163150.000059a2@linux.microsoft.com>
In-Reply-To: <aXvgKRrbfymW5NKb@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-11-dmatlack@google.com>
	<20260129142158.00004cdc@linux.microsoft.com>
	<aXvgKRrbfymW5NKb@google.com>
Organization: LSG
X-Mailer: Claws Mail 3.21.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.microsoft.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.microsoft.com:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69648-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_CC(0.00)[shazbot.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	RCPT_COUNT_TWELVE(0.00)[44];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	HAS_ORG_HEADER(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jacob.pan@linux.microsoft.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.microsoft.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.microsoft.com:mid,linux.microsoft.com:dkim]
X-Rspamd-Queue-Id: 00C56B5EE9
X-Rspamd-Action: no action

Hi David,

On Thu, 29 Jan 2026 22:33:13 +0000
David Matlack <dmatlack@google.com> wrote:

> On 2026-01-29 02:21 PM, Jacob Pan wrote:
> > On Thu, 29 Jan 2026 21:24:57 +0000 David Matlack
> > <dmatlack@google.com> wrote: =20
>=20
> > > diff --git a/drivers/vfio/pci/vfio_pci_core.c
> > > b/drivers/vfio/pci/vfio_pci_core.c index
> > > b01b94d81e28..c9f73f597797 100644 ---
> > > a/drivers/vfio/pci/vfio_pci_core.c +++
> > > b/drivers/vfio/pci/vfio_pci_core.c @@ -515,12 +515,24 @@ int
> > > vfio_pci_core_enable(struct vfio_pci_core_device *vdev) if (ret)
> > >  		goto out_power;
> > > =20
> > > -	/* If reset fails because of the device lock, fail this
> > > path entirely */
> > > -	ret =3D pci_try_reset_function(pdev);
> > > -	if (ret =3D=3D -EAGAIN)
> > > -		goto out_disable_device;
> > > +	if (vdev->liveupdate_incoming_state) {
> > > +		/*
> > > +		 * This device was preserved by the previous
> > > kernel across a
> > > +		 * Live Update, so it does not need to be reset.
> > > +		 */
> > > +		vdev->reset_works =3D
> > > vdev->liveupdate_incoming_state->reset_works; =20
> >
> > Just wondering what happened to skipping the bus master clearing. I
> > understand this version does not preserve the device itself yet; I=E2=
=80=99m
> > just curious whether there were specific difficulties that led to
> > dropping the earlier patch which skipped clearing bus master. =20
>=20
> Hi Jacob,
>=20
> There's several places where bus master gets cleared that we need to
> eventually eliminate to fully preserve the device.
>=20
>  1. vfio_pci_liveupdate_freeze() clears it during shutdown when it
>     restores vdev->pci_saved_state.
>  2. pci_device_shutdown() clears it during shutdown.
>  3. vfio_pci_core_enable() clears it when the preserved device file
>     is bound to an iommufd after the Live Update (in
>     vfio_pci_core_enable()).
>=20
> I think it would be safe to skip (3) in this series, since that's very
> similar to how this series skips resets during vfio_pci_core_enable()
> for preserved devices.
>=20
> But I don't think it would be safe to skip (1) or (2) until the
> attached iommufd is fully preserved.
>=20
> If you are just asking about (3) then I agree it could be skipped and
> I can include that in the next version.

I was just asking about (3) and trying to understand the asymmetric
handling compared to reset. I don=E2=80=99t have a strong preference since =
this
is temporary=E2=80=94thanks for the explanation.

I=E2=80=99ve been testing my noiommu cdev patches on top of yours, and so f=
ar
they behave the same as with a real IOMMU. As you noted, however, final
device preservation still depends on iommufd.


