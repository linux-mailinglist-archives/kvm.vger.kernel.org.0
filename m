Return-Path: <kvm+bounces-27553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A69CB986FEE
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 11:21:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D74231C238BF
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 09:21:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 895411AAE2A;
	Thu, 26 Sep 2024 09:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLfzfQWl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789EB1A7ADF
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 09:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727342505; cv=none; b=KQ8XqvrAAJCx7s7PnR7nnUuofS/GO/THTzkN5blvPPz6CwfMqDcDtF5b/vi2DVGqqQMtnZNI1LW53IH8J8cCyfdNtbSpUGhCxaEl4twB3ovKioem4pmJ8l4U5caAabrD9NWUFzvJYiBxj3BXOB77RnqtVHh6lXJ34XzxqCbdBEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727342505; c=relaxed/simple;
	bh=jsc+yal2wRsZ6ma4AV6jppyqJT421Ro1/Wl5XtY4xGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o6HvbVJvWH685UtbWGu2PCY64m0XGKGCtjPZDOv9cMCxb+P9McuTGkztsTvUE8Q5IXIr61z5DhIH1U36Ap+jrMhL1/MSS3KzoDlGDCVvZORVLCjig3JnaeZZT6YYKwdD+VB3JSvfqF59VW0nQQylRf9klQFnnI4phIDkIWoRp8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLfzfQWl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1E1C4CEC5;
	Thu, 26 Sep 2024 09:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727342505;
	bh=jsc+yal2wRsZ6ma4AV6jppyqJT421Ro1/Wl5XtY4xGo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oLfzfQWl9rlfHAxMWpQXsy7hg/Mq/q2RGEBcu3tUwylxTEeWgAGKtBNlAd0BsEd6L
	 F+tuRCK5IgjyWUKhjL6B7EyY6ciLv+4O4/4ocKk6GhdbloCZYlaHoDy5w0lpK1YCZU
	 z3jU4QjKrs28KR4KG6pT0oPtCHvGbT+zzDg7LiiQ=
Date: Thu, 26 Sep 2024 11:21:41 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Zhi Wang <zhiw@nvidia.com>
Cc: kvm@vger.kernel.org, nouveau@lists.freedesktop.org,
	alex.williamson@redhat.com, kevin.tian@intel.com, jgg@nvidia.com,
	airlied@gmail.com, daniel@ffwll.ch, acurrid@nvidia.com,
	cjia@nvidia.com, smitra@nvidia.com, ankita@nvidia.com,
	aniketa@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	zhiwang@kernel.org
Subject: Re: [RFC 02/29] nvkm/vgpu: attach to nvkm as a nvkm client
Message-ID: <2024092650-grant-pastime-713e@gregkh>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <20240922124951.1946072-3-zhiw@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240922124951.1946072-3-zhiw@nvidia.com>

On Sun, Sep 22, 2024 at 05:49:24AM -0700, Zhi Wang wrote:
> nvkm is a HW abstraction layer(HAL) that initializes the HW and
> allows its clients to manipulate the GPU functions regardless of the
> generations of GPU HW. On the top layer, it provides generic APIs for a
> client to connect to NVKM, enumerate the GPU functions, and manipulate
> the GPU HW.
> 
> To reach nvkm, the client needs to connect to NVKM layer by layer: driver
> layer, client layer, and eventually, the device layer, which provides all
> the access routines to GPU functions. After a client attaches to NVKM,
> it initializes the HW and is able to serve the clients.
> 
> Attach to nvkm as a nvkm client.
> 
> Cc: Neo Jia <cjia@nvidia.com>
> Signed-off-by: Zhi Wang <zhiw@nvidia.com>
> ---
>  .../nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h  |  8 ++++
>  .../gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c  | 48 ++++++++++++++++++-
>  2 files changed, 55 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h b/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
> index 3163fff1085b..9e10e18306b0 100644
> --- a/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
> +++ b/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
> @@ -7,6 +7,14 @@
>  struct nvkm_vgpu_mgr {
>  	bool enabled;
>  	struct nvkm_device *nvkm_dev;
> +
> +	const struct nvif_driver *driver;

Meta-comment, why is this attempting to act like a "driver" and yet not
tieing into the driver model code at all?  Please fix that up, it's not
ok to add more layers on top of a broken one like this.  We have
infrastructure for this type of thing, please don't route around it.

thanks,

greg k-h

