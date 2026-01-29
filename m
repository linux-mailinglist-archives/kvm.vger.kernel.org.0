Return-Path: <kvm+bounces-69522-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gLMwFHEde2msBQIAu9opvQ
	(envelope-from <kvm+bounces-69522-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 09:42:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CA17BADA1A
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 09:42:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9F25930157DB
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 08:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B4F2FFF8C;
	Thu, 29 Jan 2026 08:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sJecCk3f"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5322231ED6B;
	Thu, 29 Jan 2026 08:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769676123; cv=none; b=SpE3L3w6WeWB0f1ytjorFjai8o1aeddEWb8N78SWJbCVf32f45d5hmpQzqofCLbaM0WdDJVbJRcCWlgxwXJatEzLDH24gcgyuzT2lsgD286Ki4m/t9JXu5JiLmIXIp/+5KaxPzct5N53KS13kFzzaRv/aWHXUIoW3bvnm0xV8wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769676123; c=relaxed/simple;
	bh=ULqTXXRRvOEaToOQufqn0DT2Uq0Y5ZhV8wPvD5kiy38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jjknwjcx18IAXWZ1myxRPqGNfgBCm71CRMPykdNn8kd3x30e/rXIMAAKVXwuaQp4wCfC+27M++AgbSrf6kwV+sfqDZX4v8p+4voFPX3S6AjmHse/y3OwkRyzzrla5AiGXK9gbY9m4fnyZo5g/AWT07hKU5dN1U73bZdkFeoxUbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sJecCk3f; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8E8C4CEF7;
	Thu, 29 Jan 2026 08:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769676122;
	bh=ULqTXXRRvOEaToOQufqn0DT2Uq0Y5ZhV8wPvD5kiy38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sJecCk3fd142pV7aGXECoVLIDzOZhUWnnhJKlTwcp9G4EN9Cuwi1JPzmHE7fiMuyf
	 e/hYZk7b68M92QyJpAGFzHgWPoWU4Wv7Yc4Pss8RlXgDoH8Z3zICPvVfVfnUVRD32G
	 Ja9IvIO/38norewAYFYG4VPRhHkXMjp05wW4imftl2jLLNJZbuWAtXZxRFaOPiW5qe
	 /apGZQxhSLlXRP7POJu5VImlUrKlNTUavJQSDI4NJJ23U9yj4JOx9ldP/dQ+uCrERk
	 vTmo7fG/G4U1Lw+wkQ7q9YMCGCnnKeD3CrfFgxtQgSnLVANjTikelLazKIOJKQQ9Ca
	 XUPt3aSNkmxwg==
Date: Thu, 29 Jan 2026 10:41:56 +0200
From: Leon Romanovsky <leon@kernel.org>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Pranjal Shrivastava <praan@google.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
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
	"Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	"Kasireddy, Vivek" <vivek.kasireddy@intel.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"intel-xe@lists.freedesktop.org" <intel-xe@lists.freedesktop.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 4/8] vfio: Wait for dma-buf invalidation to complete
Message-ID: <20260129084156.GC10992@unreal>
References: <20260124-dmabuf-revoke-v5-0-f98fca917e96@nvidia.com>
 <20260124-dmabuf-revoke-v5-4-f98fca917e96@nvidia.com>
 <aXfUZcSEr9N18o6w@google.com>
 <20260127085835.GQ13967@unreal>
 <20260127162754.GH1641016@ziepe.ca>
 <BN9PR11MB5276B99D4E8C6496B0C447888C9EA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20260129073331.GB10992@unreal>
 <BN9PR11MB52766EA91FEB08876DA474888C9EA@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN9PR11MB52766EA91FEB08876DA474888C9EA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69522-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_CC(0.00)[ziepe.ca,google.com,linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,8bytes.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[35];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leon@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,ziepe.ca:email,intel.com:email]
X-Rspamd-Queue-Id: CA17BADA1A
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 08:13:18AM +0000, Tian, Kevin wrote:
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Thursday, January 29, 2026 3:34 PM
> > 
> > On Thu, Jan 29, 2026 at 07:06:37AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@ziepe.ca>
> > > > Sent: Wednesday, January 28, 2026 12:28 AM
> > > >
> > > > On Tue, Jan 27, 2026 at 10:58:35AM +0200, Leon Romanovsky wrote:
> > > > > > > @@ -333,7 +359,37 @@ void vfio_pci_dma_buf_move(struct
> > > > vfio_pci_core_device *vdev, bool revoked)
> > > > > > >  			dma_resv_lock(priv->dmabuf->resv, NULL);
> > > > > > >  			priv->revoked = revoked;
> > > > > > >  			dma_buf_invalidate_mappings(priv-
> > >dmabuf);
> > > > > > > +			dma_resv_wait_timeout(priv->dmabuf->resv,
> > > > > > > +
> > DMA_RESV_USAGE_BOOKKEEP,
> > > > false,
> > > > > > > +
> > MAX_SCHEDULE_TIMEOUT);
> > > > > > >  			dma_resv_unlock(priv->dmabuf->resv);
> > > > > > > +			if (revoked) {
> > > > > > > +				kref_put(&priv->kref,
> > > > vfio_pci_dma_buf_done);
> > > > > > > +				/* Let's wait till all DMA unmap are
> > > > completed. */
> > > > > > > +				wait = wait_for_completion_timeout(
> > > > > > > +					&priv->comp,
> > secs_to_jiffies(1));
> > > > > >
> > > > > > Is the 1-second constant sufficient for all hardware, or should the
> > > > > > invalidate_mappings() contract require the callback to block until
> > > > > > speculative reads are strictly fenced? I'm wondering about a case
> > where
> > > > > > a device's firmware has a high response latency, perhaps due to
> > internal
> > > > > > management tasks like error recovery or thermal and it exceeds the
> > 1s
> > > > > > timeout.
> > > > > >
> > > > > > If the device is in the middle of a large DMA burst and the firmware is
> > > > > > slow to flush the internal pipelines to a fully "quiesced"
> > > > > > read-and-discard state, reclaiming the memory at exactly 1.001
> > seconds
> > > > > > risks triggering platform-level faults..
> > > > > >
> > > > > > Since the wen explicitly permit these speculative reads until unmap is
> > > > > > complete, relying on a hardcoded timeout in the exporter seems to
> > > > > > introduce a hardware-dependent race condition that could
> > compromise
> > > > > > system stability via IOMMU errors or AER faults.
> > > > > >
> > > > > > Should the importer instead be required to guarantee that all
> > > > > > speculative access has ceased before the invalidation call returns?
> > > > >
> > > > > It is guaranteed by the dma_resv_wait_timeout() call above. That call
> > > > ensures
> > > > > that the hardware has completed all pending operations. The 1‑second
> > > > delay is
> > > > > meant to catch cases where an in-kernel DMA unmap call is missing,
> > which
> > > > should
> > > > > not trigger any DMA activity at that point.
> > > >
> > > > Christian may know actual examples, but my general feeling is he was
> > > > worrying about drivers that have pushed the DMABUF to visibility on
> > > > the GPU and the move notify & fences only shoot down some access. So
> > > > it has to wait until the DMABUF is finally unmapped.
> > > >
> > > > Pranjal's example should be covered by the driver adding a fence and
> > > > then the unbounded fence wait will complete it.
> > > >
> > >
> > > Bear me if it's an ignorant question.
> > >
> > > The commit msg of patch6 says that VFIO doesn't tolerate unbounded
> > > wait, which is the reason behind the 2nd timeout wait here.
> > 
> > It is not accurate. A second timeout is present both in the
> > description of patch 6 and in VFIO implementation. The difference is
> > that the timeout is enforced within VFIO.
> > 
> > >
> > > Then why is "the unbounded fence wait" not a problem in the same
> > > code path? the use of MAX_SCHEDULE_TIMEOUT imply a worst-case
> > > timeout in hundreds of years...
> > 
> > "An unbounded fence wait" is a different class of wait. It indicates broken
> > hardware that continues to issue DMA transactions even after it has been
> > told to
> > stop.
> > 
> > The second wait exists to catch software bugs or misuse, where the dma-buf
> > importer has misrepresented its capabilities.
> > 
> 
> Okay I see.
> 
> > >
> > > and it'd be helpful to put some words in the code based on what's
> > > discussed here.
> > 
> > We've documented as much as we can in dma_buf_attach_revocable() and
> > dma_buf_invalidate_mappings(). Do you have any suggestions on what else
> > should be added here?
> > 
> 
> the selection of 1s?

It is indirectly written in description of WARN_ON(), but let's add
more. What about the following?

diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index 93795ad2e025..948ba75288c6 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -357,7 +357,13 @@ void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev, bool revoked)
                        dma_resv_unlock(priv->dmabuf->resv);
                        if (revoked) {
                                kref_put(&priv->kref, vfio_pci_dma_buf_done);
-                               /* Let's wait till all DMA unmap are completed. */
+                               /*
+                                * Let's wait for 1 second till all DMA unmap
+                                * are completed. It is supposed to catch dma-buf
+                                * importers which lied about their support
+                                * of dmabuf revoke. See dma_buf_invalidate_mappings()
+                                * for the expected behaviour,
+                                */
                                wait = wait_for_completion_timeout(
                                        &priv->comp, secs_to_jiffies(1));
                                /*

> 
> then,
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Thanks

