Return-Path: <kvm+bounces-28755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CA0199C953
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 13:50:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C3DB293B63
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 11:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C86019E971;
	Mon, 14 Oct 2024 11:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTdDcgEG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4862119E7E2
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 11:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728906593; cv=none; b=UEgy/ORbLrupVHg3P8Pqw941VZ/FdbHTeJ3i7lnFU5dn43lmVXTBUDsOLWvUiwZR74zJ0U/RF0RlGj0xu1NjG3N/F3dF8WJofwYu3rBMVoPGbV3X75BFwWlVnKF6VrPFVzZcoIu1eFyUC7X/YcNqogKxS4Sz+f7LeoKgaNCy8GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728906593; c=relaxed/simple;
	bh=byGmoWsDsJVtJZriQoxlniSXF4au4XS47Jh2jDNWpf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C3d9aFpmQz9S3JgdVJpPZUCByUpvMaJmMi+9lgU6KpAyo5jOvOpZiW3NqNGdhvox2/sCzW5Qmv5IFepJIVfk3VxhoXurzCJiA+OMePkkELuTdJBkrf1GyDDd2nuGHCsbVLPStpJoLgJBdZHAx4G8YvgDtZH1c5LDGd/19aSlv1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTdDcgEG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2ECC4CEC3;
	Mon, 14 Oct 2024 11:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728906592;
	bh=byGmoWsDsJVtJZriQoxlniSXF4au4XS47Jh2jDNWpf0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CTdDcgEGYxn7w38wM/LgcuFGvpn8RPU+oH+M4HkMk1qo4YuMXNSBPIbXOhJ1LBhzL
	 bF3Xo2zACkoQaBuIsKCrxmJBSt9RU9F9wa/NKxgXupJ1P1hsFMzH+Ai7W3JlRVajem
	 twqdTFWYSj2297miTF0MenLbJqWwuTjRn7PhbfUk=
Date: Mon, 14 Oct 2024 13:33:05 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Zhi Wang <zhiw@nvidia.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	"airlied@gmail.com" <airlied@gmail.com>,
	"daniel@ffwll.ch" <daniel@ffwll.ch>,
	Andy Currid <ACurrid@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Surath Mitra <smitra@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>,
	Aniket Agashe <aniketa@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	"zhiwang@kernel.org" <zhiwang@kernel.org>,
	Ben Skeggs <bskeggs@nvidia.com>
Subject: Re: [RFC 02/29] nvkm/vgpu: attach to nvkm as a nvkm client
Message-ID: <2024101436-marxism-sporting-27eb@gregkh>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <20240922124951.1946072-3-zhiw@nvidia.com>
 <2024092650-grant-pastime-713e@gregkh>
 <200b246e-6add-41bc-b8b6-440b3c9b62f0@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200b246e-6add-41bc-b8b6-440b3c9b62f0@nvidia.com>

On Mon, Oct 14, 2024 at 10:16:21AM +0000, Zhi Wang wrote:
> On 26/09/2024 12.21, Greg KH wrote:
> > External email: Use caution opening links or attachments
> > 
> > 
> > On Sun, Sep 22, 2024 at 05:49:24AM -0700, Zhi Wang wrote:
> >> nvkm is a HW abstraction layer(HAL) that initializes the HW and
> >> allows its clients to manipulate the GPU functions regardless of the
> >> generations of GPU HW. On the top layer, it provides generic APIs for a
> >> client to connect to NVKM, enumerate the GPU functions, and manipulate
> >> the GPU HW.
> >>
> >> To reach nvkm, the client needs to connect to NVKM layer by layer: driver
> >> layer, client layer, and eventually, the device layer, which provides all
> >> the access routines to GPU functions. After a client attaches to NVKM,
> >> it initializes the HW and is able to serve the clients.
> >>
> >> Attach to nvkm as a nvkm client.
> >>
> >> Cc: Neo Jia <cjia@nvidia.com>
> >> Signed-off-by: Zhi Wang <zhiw@nvidia.com>
> >> ---
> >>   .../nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h  |  8 ++++
> >>   .../gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c  | 48 ++++++++++++++++++-
> >>   2 files changed, 55 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h b/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
> >> index 3163fff1085b..9e10e18306b0 100644
> >> --- a/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
> >> +++ b/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
> >> @@ -7,6 +7,14 @@
> >>   struct nvkm_vgpu_mgr {
> >>        bool enabled;
> >>        struct nvkm_device *nvkm_dev;
> >> +
> >> +     const struct nvif_driver *driver;
> > 
> > Meta-comment, why is this attempting to act like a "driver" and yet not
> > tieing into the driver model code at all?  Please fix that up, it's not
> > ok to add more layers on top of a broken one like this.  We have
> > infrastructure for this type of thing, please don't route around it.
> > 
> 
> Thanks for the guidelines. Will try to work with folks and figure out a 
> solution.
> 
> Ben is doing quite some clean-ups of nouveau driver[1], they had been 
> reviewed and merged by Danilo. Also, the split driver patchset he is 
> working on seems a meaningful pre-step to fix this, as it also includes 
> the re-factor of the interface between the nvkm and the nvif stuff.

What we need is the auxbus code changes that are pointed to somewhere in
those long threads, that needs to land first and this series rebased
before it can be reviewed properly as that is going to change your
device lifetime rules a lot.

Please do that and then move this "nvif_driver" to be the proper driver
core type to tie into the kernel correctly.

thanks,

greg k-h

