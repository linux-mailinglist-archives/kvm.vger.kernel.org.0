Return-Path: <kvm+bounces-29862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 438009B35AA
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 17:03:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DB3C6B21DB5
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 16:03:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4F6E1DE896;
	Mon, 28 Oct 2024 16:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="iVkfrSkf"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA2921DE4D7;
	Mon, 28 Oct 2024 16:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730131395; cv=none; b=XvWeHvl42xk1L7vwI33WfIOKWDRdr8TlJV++edCexT5faw5LHYsfBByIj15tGWP18JnXzOhVXAnUFYj33TNeymO/+NNryknfoIxNMPzfoLGMMgmpc/H8qztzvTQAT3X8EBkt3VYH5x8pwANqnfSPww4pLON1ChrTpR/uNf6JrH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730131395; c=relaxed/simple;
	bh=7MvWDbRgReMb4oWxzviab7n1ngXsZ//x54ni3s1qKWM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VAQ+Ka//BE5YRqr4TMO6+sohMqEvV/QEmNc3bNzb1u+xs7Ja4awCWAA9iw5mwqPiUGgLayR2e6/E7ZyuNthno2WriR2kPHgFed+tEwS0WOxbJNDCo0BvyuTJLvBtNMwBj5qd+HEmrjtrqqUlS1kA8qNoEoRThuK119O/Fdo0kOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=iVkfrSkf; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from DESKTOP-0403QTC. (unknown [50.53.30.84])
	by linux.microsoft.com (Postfix) with ESMTPSA id A747A211F5E7;
	Mon, 28 Oct 2024 09:03:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A747A211F5E7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1730131393;
	bh=DWUL2mPdKe3I13p5z61gbW4T4xaOhjwZlnNHegTzwUg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Reply-To:From;
	b=iVkfrSkf95QZrzcYpwdyqMeWXi66DxVqoIHsp8moaRCpYdcVzQ1Ggi0sOBLYuDfbE
	 G37oMo2530z9U1RbMBmF2iZLTpFTz3B+1VgzYt9jiRmxYrd+sNkWmRs9592y6NSd+5
	 wrMr56ks+JwKFzYIGe9bYlSP2yfS5ysbvhkBpZ+A=
Date: Mon, 28 Oct 2024 09:03:11 -0700
From: Jacob Pan <jacob.pan@linux.microsoft.com>
To: James Gowans <jgowans@amazon.com>
Cc: jacob.pan@linux.microsoft.com, Saurabh Sengar
 <ssengar@linux.microsoft.com>, <linux-kernel@vger.kernel.org>, Jason
 Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel"
 <joro@8bytes.org>, Krzysztof =?UTF-8?B?V2lsY3p5xYRza2k=?= <kw@linux.com>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Mike
 Rapoport <rppt@kernel.org>, "Madhavan T. Venkataraman"
 <madvenka@linux.microsoft.com>, <iommu@lists.linux.dev>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 <kvm@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, Lu Baolu
 <baolu.lu@linux.intel.com>, Alexander Graf <graf@amazon.de>,
 <anthony.yznaga@oracle.com>, <steven.sistare@oracle.com>,
 <nh-open-source@amazon.com>, "Saenz Julienne, Nicolas" <nsaenz@amazon.es>
Subject: Re: [RFC PATCH 05/13] iommufd: Serialise persisted iommufds and
 ioas
Message-ID: <20241028090311.54bc537f@DESKTOP-0403QTC.>
In-Reply-To: <20241016152047.2a604f08@DESKTOP-0403QTC.>
References: <20240916113102.710522-1-jgowans@amazon.com>
	<20240916113102.710522-6-jgowans@amazon.com>
	<20241016152047.2a604f08@DESKTOP-0403QTC.>
Reply-To: jacob.pan@linux.microsoft.com, "yi.l.liu@intel.com"
 <yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi James,

Just a gentle reminder. Let me also explain the problem we are trying
to solve for the live update of OpenHCL paravisor[1]. OpenHCL has user
space drivers based on VFIO noiommu mode, we are in the process of
converting to iommufd cdev.

Similarly, running DMA continuously across updates is required, but
unlike your case, OpenHCL updates do not involve preserving the IO page
tables in that it is managed by the hypervisor which is not part of the
update.

It seems reasonable to share the device persistence code path
with the plan laid out in your cover letter. IOAS code path will be
different since noiommu option does not have IOAS.

If we were to revive noiommu support for iommufd cdev[2], can we use
the persistent iommufd context to allow device persistence? Perhaps
through IOMMUFD_OBJ_DEVICE and IOMMUFD_OBJ_ACCESS(used in [2])?

@David, @Jason, @Alex, @Yi, any comments or suggestions?


Thanks,

Jacob

1. (openvmm/Guide/src/reference/architecture/openhcl.md at main =C2=B7
microsoft/openvmm.=20
2. [PATCH v11 00/23] Add vfio_device cdev for
iommufd support - Yi Liu

On Wed, 16 Oct 2024 15:20:47 -0700 Jacob Pan
<jacob.pan@linux.microsoft.com> wrote:

> Hi James,
>=20
> On Mon, 16 Sep 2024 13:30:54 +0200
> James Gowans <jgowans@amazon.com> wrote:
>=20
> > +static int serialise_iommufd(void *fdt, struct iommufd_ctx *ictx)
> > +{
> > +	int err =3D 0;
> > +	char name[24];
> > +	struct iommufd_object *obj;
> > +	unsigned long obj_idx;
> > +
> > +	snprintf(name, sizeof(name), "%lu", ictx->persistent_id);
> > +	err |=3D fdt_begin_node(fdt, name);
> > +	err |=3D fdt_begin_node(fdt, "ioases");
> > +	xa_for_each(&ictx->objects, obj_idx, obj) {
> > +		struct iommufd_ioas *ioas;
> > +		struct iopt_area *area;
> > +		int area_idx =3D 0;
> > +
> > +		if (obj->type !=3D IOMMUFD_OBJ_IOAS)
> > +			continue; =20
> I was wondering how device state persistency is managed here. Is it
> correct to assume that all devices bound to an iommufd context should
> be persistent? If so, should we be serializing IOMMUFD_OBJ_DEVICE as
> well?
>=20
> I'm considering this from the perspective of user mode drivers,
> including those that use noiommu mode (need to be added to iommufd
> cdev). In this scenario, we only need to maintain the device states
> persistently without IOAS.


