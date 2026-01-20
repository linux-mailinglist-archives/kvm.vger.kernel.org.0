Return-Path: <kvm+bounces-68604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id DFA58D3C498
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 11:07:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A30685644AE
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 09:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D26AA3BF305;
	Tue, 20 Jan 2026 09:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dLp9ReyQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8DA1DF736;
	Tue, 20 Jan 2026 09:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768902365; cv=none; b=Os9wYKzHfRYTuiE1aP5Yp3GgBe6gRfJw7U8qeP1p48DvEfSXNlCED4SAjWMUhJhaqT6mgh9yO32lyZE1yssJRqgOymqqYvevaMPMB+xlcgqd84I6AdjO4sQW2P0RPHIFS7jA/0gRuOQHkgHMTIiAjeD96tzs2WFdUIwkcOrHUgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768902365; c=relaxed/simple;
	bh=xwqfvmhHmuW9plUqJwJFOo0A9JPdncx7ymGaNl95+yo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nroogO/3HRp/VoyM6bgFdytpivsnGKdcxq8MANBBr4bGVUHuRZ37UzyVehhMOZoM4LNItHR12e3l1RuLiEaS2YoZtL9CPx3R1dJMyu4peRxjjrRg7u80fHjtUKai21lnUpnXJ2u9jQ/uJkFSVDoh6d+FCygKdEny8/0hV7DiDG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dLp9ReyQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B94BC16AAE;
	Tue, 20 Jan 2026 09:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768902365;
	bh=xwqfvmhHmuW9plUqJwJFOo0A9JPdncx7ymGaNl95+yo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dLp9ReyQRpZBQ1HsP4UfwVvklS8InFrF5hZROHOsUQf2ANERezVMKk+6yLg6Ao4g3
	 bLcG3imT0sMt+H8fCaljcj6H6q3C49oKM5UFuq9mCGfKKoc58e7IfUyEjHp9yyDWly
	 YIKTxAK65ASJJqdGUsUzRrjLdUxxrZkSb5a45Yin99EzC3KcC/KU54U44uAJoCTHCk
	 /GXbSQK/AWWMtHtI6tfkHgvO0RI0YfUByVjh5FRuPknr3l7QRpVrbBG7WUGy8+TysZ
	 sOw9jD1XrRQTSSUqXvrM/yMlG1kzWM8fP+8vKPFCkbcyIu4rYCttJvTje8CuUxTa6t
	 RL0gf/JISbozw==
Date: Tue, 20 Jan 2026 11:45:59 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
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
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex@shazbot.org>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	virtualization@lists.linux.dev, intel-xe@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/4] dma-buf: Document revoke semantics
Message-ID: <20260120094559.GR13201@unreal>
References: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>
 <20260118-dmabuf-revoke-v2-2-a03bb27c0875@nvidia.com>
 <20260119164421.GF961572@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260119164421.GF961572@ziepe.ca>

On Mon, Jan 19, 2026 at 12:44:21PM -0400, Jason Gunthorpe wrote:
> On Sun, Jan 18, 2026 at 02:08:46PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Document a DMA-buf revoke mechanism that allows an exporter to explicitly
> > invalidate ("kill") a shared buffer after it has been handed out to
> > importers. Once revoked, all further CPU and device access is blocked, and
> > importers consistently observe failure.
> > 
> > This requires both importers and exporters to honor the revoke contract.
> > 
> > For importers, this means implementing .invalidate_mappings() and calling
> > dma_buf_pin() after the DMA‑buf is attached to verify the exporter’s support
> > for revocation.
> > 
> > For exporters, this means implementing the .pin() callback, which checks
> > the DMA‑buf attachment for a valid revoke implementation.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  include/linux/dma-buf.h | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> > 
> > diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> > index 1b397635c793..e0bc0b7119f5 100644
> > --- a/include/linux/dma-buf.h
> > +++ b/include/linux/dma-buf.h
> > @@ -579,6 +579,25 @@ static inline bool dma_buf_is_dynamic(struct dma_buf *dmabuf)
> >  	return !!dmabuf->ops->pin;
> >  }
> >  
> > +/**
> > + * dma_buf_attachment_is_revoke - check if a DMA-buf importer implements
> > + * revoke semantics.
> > + * @attach: the DMA-buf attachment to check
> > + *
> > + * Returns true if DMA-buf importer honors revoke semantics, which is
> > + * negotiated with the exporter, by making sure that importer implements
> > + * .invalidate_mappings() callback and calls to dma_buf_pin() after
> > + * DMA-buf attach.
> > + */
> 
> I think this clarification should also have comment to
> dma_buf_move_notify(). Maybe like this:
> 
> @@ -1324,7 +1324,18 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_sgt_unmap_attachment_unlocked, "DMA_BUF");
>   * @dmabuf:    [in]    buffer which is moving
>   *
>   * Informs all attachments that they need to destroy and recreate all their
> - * mappings.
> + * mappings. If the attachment is dynamic then the dynamic importer is expected
> + * to invalidate any caches it has of the mapping result and perform a new
> + * mapping request before allowing HW to do any further DMA.
> + *
> + * If the attachment is pinned then this informs the pinned importer that
> + * the underlying mapping is no longer available. Pinned importers may take
> + * this is as a permanent revocation so exporters should not trigger it
> + * lightly.
> + *
> + * For legacy pinned importers that cannot support invalidation this is a NOP.
> + * Drivers can call dma_buf_attachment_is_revoke() to determine if the
> + * importer supports this.
>   */
> 
> Also it would be nice to document what Christian pointed out regarding
> fences after move_notify.

I added this comment too:
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 6dd70f7b992d..478127dc63e9 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1253,6 +1253,10 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_unmap_attachment_unlocked, "DMA_BUF");
  * For legacy pinned importers that cannot support invalidation this is a NOP.
  * Drivers can call dma_buf_attach_revocable() to determine if the importer
  * supports this.
+ *
+ * NOTE: The invalidation triggers asynchronous HW operation and the callers
+ * need to wait for this operation to complete by calling
+ * to dma_resv_wait_timeout().
  */
 void dma_buf_move_notify(struct dma_buf *dmabuf)
 {

> 
> > +static inline bool
> > +dma_buf_attachment_is_revoke(struct dma_buf_attachment *attach)
> > +{
> > +	return IS_ENABLED(CONFIG_DMABUF_MOVE_NOTIFY) &&
> > +	       dma_buf_is_dynamic(attach->dmabuf) &&
> > +	       (attach->importer_ops &&
> > +		attach->importer_ops->invalidate_mappings);
> > +}
> 
> And I don't think we should use a NULL invalidate_mappings function
> pointer to signal this.
> 
> It sounds like the direction is to require importers to support
> move_notify, so we should not make it easy to just drop a NULL in the
> ops struct to get out of the desired configuration.
> 
> I suggest defining a function
> "dma_buf_unsupported_invalidate_mappings" and use
> EXPORT_SYMBOL_FOR_MODULES so only RDMA can use it. Then check for that
> along with NULL importer_ops to cover the two cases where it is not
> allowed.
> 
> The only reason RDMA has to use dma_buf_dynamic_attach() is to set the
> allow_p2p=true ..

Will do.

> 
> Jason

