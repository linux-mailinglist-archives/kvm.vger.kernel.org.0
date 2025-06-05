Return-Path: <kvm+bounces-48559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B7E5ACF3F3
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 18:17:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24CB11660CE
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 16:17:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4713F211713;
	Thu,  5 Jun 2025 16:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RETF9+Fi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F3813D521;
	Thu,  5 Jun 2025 16:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749140236; cv=none; b=qK5rzNF18w+p1z7HesnExjKyBuro/mLPXyDs8oQ1GNJPDxT5JbYdDMN1ydQQG/aFennPykyT3dZSGB+1D4j5Fz/4XjcRr43VNdpKzdF/r4xfdPd5AVzYcZgRV5IDTDDWkW/j7xMmkJproxNz12THO/bZE+FUq/hH4q6qQ9ADaRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749140236; c=relaxed/simple;
	bh=R2kAT8sgTVzEg0Z9dPF3UmifglniI93iuJxDsKCUq4E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FDFlcGiu2DbyDIH2TwWaJgHGXbS9fJ5sszrFo9zLCMovKYCzC+en5WNWiTD1iCmBIyAolcVz+y21tjOfJ1Q5+srV/ds8t0qUUpyLXtTF9lrMShKMVST8/4ZaaVcw9GrskvYXUGXkf6xgq1KlIFluCHkpNX0OGRo/AYZnJv+aM30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RETF9+Fi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC90C4CEE7;
	Thu,  5 Jun 2025 16:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749140234;
	bh=R2kAT8sgTVzEg0Z9dPF3UmifglniI93iuJxDsKCUq4E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=RETF9+Fi566neb4lJUpVLBOnK1Q0DHWFqA422TSAoXhbf7GHEODVktjFPnGcb07Ta
	 kOlF0aK90BS+b+AiPwJxUZiKLwsNJSzbqIMH42/smRXUEP0vOXRwuknlk5wdLLeW0X
	 jIbGv8yAN7a3R2ZoA88CWDALpE4x2Hc1YB0rjkJFARh1FZeoVrNpwlGikvihjETTSP
	 KXwkqG5+CDCEtGNNOBQc0ZvWP+VDLDFfEFVXV33nSylK2zNa8UhKAWecCyrrk7YCml
	 vfFtmhR4/MsoPIJvEBUXUVHFKjeoo5YlWkVygaoZdiWeYvBMVE4qpU22KNIjjoPy8f
	 eFQS4zumEsmpw==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>, kvm@vger.kernel.org,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	dan.j.williams@intel.com, aik@amd.com, linux-coco@lists.linux.dev,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, vivek.kasireddy@intel.com,
	yilun.xu@intel.com, linux-kernel@vger.kernel.org, lukas@wunner.de,
	yan.y.zhao@intel.com, daniel.vetter@ffwll.ch, leon@kernel.org,
	baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com, linux-pci@vger.kernel.org, zhiw@nvidia.com,
	simona.vetter@ffwll.ch, shameerali.kolothum.thodi@huawei.com,
	iommu@lists.linux.dev, kevin.tian@intel.com
Subject: Re: [RFC PATCH 19/30] vfio/pci: Add TSM TDI bind/unbind IOCTLs for
 TEE-IO support
In-Reply-To: <20250605151029.GC19710@nvidia.com>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
 <20250529053513.1592088-20-yilun.xu@linux.intel.com>
 <yq5ah60u8kev.fsf@kernel.org> <20250605151029.GC19710@nvidia.com>
Date: Thu, 05 Jun 2025 21:47:01 +0530
Message-ID: <yq5a7c1q88oy.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Jason Gunthorpe <jgg@nvidia.com> writes:

> On Thu, Jun 05, 2025 at 05:33:52PM +0530, Aneesh Kumar K.V wrote:
>
>> > +
>> > +	/* To ensure no host side MMIO access is possible */
>> > +	ret =3D pci_request_regions_exclusive(pdev, "vfio-pci-tsm");
>> > +	if (ret)
>> > +		goto out_unlock;
>> > +
>> >
>>=20
>> I am hitting failures here with similar changes. Can you share the Qemu
>> changes needed to make this pci_request_regions_exclusive successful.
>> Also after the TDI is unbound, we want the region ownership backto
>> "vfio-pci" so that things continue to work as non-secure device. I don't
>> see we doing that. I could add a pci_bar_deactivate/pci_bar_activate in
>> userspace which will result in vfio_unmap()/vfio_map(). But that doesn't
>> release the region ownership.
>
> Again, IMHO, we should not be doing this dynamically. VFIO should do
> pci_request_regions_exclusive() once at the very start and it should
> stay that way.
>
> There is no reason to change it dynamically.
>
> The only decision to make is if all vfio should switch to exclusive
> mode or if we need to make it optional for userspace.

We only need the exclusive mode when the device is operating in secure
mode, correct? That suggests we=E2=80=99ll need to dynamically toggle this
setting based on the device=E2=80=99s security state.

-aneesh

