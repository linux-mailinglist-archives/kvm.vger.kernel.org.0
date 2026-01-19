Return-Path: <kvm+bounces-68509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 65E61D3A9DB
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 14:03:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 65F6930B30B4
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 13:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E4536404E;
	Mon, 19 Jan 2026 13:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="scELuI2G"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2513A2D1911;
	Mon, 19 Jan 2026 13:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768827769; cv=none; b=s0Y/7nYn/seoOic9UacZgbnI7CFrrJoPJh33Z/lmhrh/h4hwpXM8qNCuOG8EyQPcMPUiMGCOWzjwOHgTnaiK5Z/rFCNOl0/XityeBdCs8qNgdOfxdJCpkd+Bk13PJzzVmaklVYBKU7HoCgjNy7C70UjlJeTHwQ+SshPi0F7strI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768827769; c=relaxed/simple;
	bh=cCxg8035viPJsz2XBq1ifbK2lrZlRG1OCR5jkwA4Q7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c81fhG4ygYH+vT7YVCEqQcKyv0CP5uvWX3X7FcxshvXsWmsNiyWaILvKH79sv9TQK+U+23BEnfqdg043p5X5GZXNcYQcRFncGRCy0oMs/l8EhGf1sTGgy24DRgiLP43pgm+wVWn0H70pN6ZDVM+WCvYIaY5Qt+WvBRd4GlBhyyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=scELuI2G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F21C116C6;
	Mon, 19 Jan 2026 13:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768827768;
	bh=cCxg8035viPJsz2XBq1ifbK2lrZlRG1OCR5jkwA4Q7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=scELuI2GW3wYYW2ZENuAuFSaCJYKTwxSRnj2LRAqiwezAEBgiUivhNWu7wR7lsvrp
	 JMiPt96eHalhzJp6zdj/VOztYexbL9CNdValyZad3QIoRwUqy2SNCBXDS5ZUmr2r5B
	 3Q2LYZFjRo+TpYc7rFstqRHfbtMAFjLvRsXdqreX7yo2gyOr+diw1+LoloRIJTcEFf
	 H3YM1NaUjV02Jdtuy+J3LR9/YjENpaZ6LVp9bzMZphF9Lehv4mUuhwTkRGGGpb2kcJ
	 Ej14CRJRVv6csc6KuHzgzAe+xhdGGLSRvHHCsaiwAmERVJ+yIM5atMLB3FZRNKxX/w
	 fRLM6YcjAxsPA==
Date: Mon, 19 Jan 2026 15:02:44 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex@shazbot.org>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	virtualization@lists.linux.dev, intel-xe@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/4] vfio: Add pinned interface to perform revoke
 semantics
Message-ID: <20260119130244.GN13201@unreal>
References: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>
 <20260118-dmabuf-revoke-v2-4-a03bb27c0875@nvidia.com>
 <bd37adf0-afd0-49c4-b608-7f9aa5994f7b@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bd37adf0-afd0-49c4-b608-7f9aa5994f7b@amd.com>

On Mon, Jan 19, 2026 at 01:12:45PM +0100, Christian König wrote:
> On 1/18/26 13:08, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > DMABUF ->pin() interface is called when the DMABUF importer perform
> > its DMA mapping, so let's use this opportunity to check if DMABUF
> > exporter revoked its buffer or not.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_dmabuf.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
> > index d4d0f7d08c53..af9c315ddf71 100644
> > --- a/drivers/vfio/pci/vfio_pci_dmabuf.c
> > +++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
> > @@ -20,6 +20,20 @@ struct vfio_pci_dma_buf {
> >  	u8 revoked : 1;
> >  };
> >  
> > +static int vfio_pci_dma_buf_pin(struct dma_buf_attachment *attachment)
> > +{
> > +	struct vfio_pci_dma_buf *priv = attachment->dmabuf->priv;
> > +
> > +	dma_resv_assert_held(priv->dmabuf->resv);
> > +
> > +	return dma_buf_attachment_is_revoke(attachment) ? 0 : -EOPNOTSUPP;
> 
> It's probably better to do that check in vfio_pci_dma_buf_attach.

I assume you are proposing to add this check in both
vfio_pci_dma_buf_attach() and vfio_pci_dma_buf_pin(). Otherwise,
importers that lack .invalidate_mapping() will invoke dma_buf_pin()
and will not fail.

> 
> And BTW the function vfio_pci_dma_buf_move() seems to be broken:
> 
> void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev, bool revoked)
> {
>         struct vfio_pci_dma_buf *priv;
>         struct vfio_pci_dma_buf *tmp;
> 
>         lockdep_assert_held_write(&vdev->memory_lock);
> 
>         list_for_each_entry_safe(priv, tmp, &vdev->dmabufs, dmabufs_elm) {
>                 if (!get_file_active(&priv->dmabuf->file))
>                         continue;
> 
>                 if (priv->revoked != revoked) {
>                         dma_resv_lock(priv->dmabuf->resv, NULL);
>                         priv->revoked = revoked;
>                         dma_buf_move_notify(priv->dmabuf);
> 
> A dma_buf_move_notify() just triggers asynchronous invalidation of the mapping!
> 
> You need to use dma_resv_wait() to wait for that to finish.

We (VFIO and IOMMUFD) followed the same pattern used in  
amdgpu_bo_move_notify(), which also does not wait.

I'll add wait here.

Thanks

> 
>                         dma_resv_unlock(priv->dmabuf->resv);
>                 }
>                 fput(priv->dmabuf->file);
>         }
> }
> 
> Regards,
> Christian.
> 
> 
> > +}
> > +
> > +static void vfio_pci_dma_buf_unpin(struct dma_buf_attachment *attachment)
> > +{
> > +	/* Do nothing */
> > +}
> > +
> >  static int vfio_pci_dma_buf_attach(struct dma_buf *dmabuf,
> >  				   struct dma_buf_attachment *attachment)
> >  {
> > @@ -76,6 +90,8 @@ static void vfio_pci_dma_buf_release(struct dma_buf *dmabuf)
> >  }
> >  
> >  static const struct dma_buf_ops vfio_pci_dmabuf_ops = {
> > +	.pin = vfio_pci_dma_buf_pin,
> > +	.unpin = vfio_pci_dma_buf_unpin,
> >  	.attach = vfio_pci_dma_buf_attach,
> >  	.map_dma_buf = vfio_pci_dma_buf_map,
> >  	.unmap_dma_buf = vfio_pci_dma_buf_unmap,
> > 
> 

