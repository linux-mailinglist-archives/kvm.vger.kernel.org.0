Return-Path: <kvm+bounces-69288-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SMtyKQgkeWnmvgEAu9opvQ
	(envelope-from <kvm+bounces-69288-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 21:46:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 65DE69A704
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 21:46:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 61F583025E44
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 20:45:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD5D9288C08;
	Tue, 27 Jan 2026 20:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B23TEVsJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F084AEAC7;
	Tue, 27 Jan 2026 20:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769546735; cv=none; b=unKvMGuU3EH+E8DmBgqgFW8i/H7L77PYtKfXl6BQ2GTdchIHBPQcSDKWbjtwHpWdDJbM2OpMqtBnNd8e0HVUyZcXk8GmY3T2JUnXg669Xod6x73A9bNbCsLPtEGnseRK34MG2d2ZFwyxsoWMxjhryqa3E431D+6zeuIQUz147qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769546735; c=relaxed/simple;
	bh=kWJnczCRjQfP3+mri2axksFFudA/BEKhqvdeAp2MhAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=edsSGT7EuxKAHQQWZZpRvL0oOtGLpo4tDc1gFhwINb1FYHG/Fh2sKyYqrCnNzUwzvCLR5CjuJndJOkVJP5SIeZ7e/WNc+fwf/OB2CN9VbF7q+Shs6F6th4kWjtjTY/NCxB2gkLwDgQpNK4jD6LCnJwVUdSvev3UHbE9H/wtXl/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B23TEVsJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B6BC116C6;
	Tue, 27 Jan 2026 20:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769546734;
	bh=kWJnczCRjQfP3+mri2axksFFudA/BEKhqvdeAp2MhAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B23TEVsJccWQDX9Mjx22xVlETkMrrPsVBBGPzr1/qClDRQwwIBUEpOC/B3atxGcBl
	 s1GNk7zvmuHc8Ak8BzI57RVpONP9viPDQ9AUq4FK45Mh9JRYYIuCMLbbwyCrKLuUy2
	 3aLWXhw79ygY0VefybeyuREyCYmCj2aKCHAwuwZhODd1oUQnKU0/D5zUmNMPWwzGhS
	 VccjJRVDi7QyNxVnNABics3aPJZgWOd2TGAtA390Bkrtkg6RWzFHRZfK9zJpPGzack
	 wBItE/Q3nIcFifOKrFXt7u9v+WwsoBkT+i0QyYk4WRkirXYn1QmRecC+jpiFNhqN5u
	 ri0eOMMXGeg9w==
Date: Tue, 27 Jan 2026 22:45:30 +0200
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
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v5 3/8] dma-buf: Always build with DMABUF_MOVE_NOTIFY
Message-ID: <20260127204530.GX13967@unreal>
References: <20260124-dmabuf-revoke-v5-0-f98fca917e96@nvidia.com>
 <20260124-dmabuf-revoke-v5-3-f98fca917e96@nvidia.com>
 <0d2ec2d6-c999-45d8-a2bd-b5b21883db47@amd.com>
 <20260127095831.GR13967@unreal>
 <83cd911c-99ea-4fab-821e-fcf703209731@amd.com>
 <20260127114243.GS13967@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260127114243.GS13967@unreal>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69288-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[34];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leon@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:email,amd.com:email]
X-Rspamd-Queue-Id: 65DE69A704
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 01:42:43PM +0200, Leon Romanovsky wrote:
> On Tue, Jan 27, 2026 at 11:02:03AM +0100, Christian König wrote:
> > On 1/27/26 10:58, Leon Romanovsky wrote:
> > > On Tue, Jan 27, 2026 at 10:26:26AM +0100, Christian König wrote:
> > >> On 1/24/26 20:14, Leon Romanovsky wrote:
> > >>> From: Leon Romanovsky <leonro@nvidia.com>
> > >>>
> > >>> DMABUF_MOVE_NOTIFY was introduced in 2018 and has been marked as
> > >>> experimental and disabled by default ever since. Six years later,
> > >>> all new importers implement this callback.
> > >>>
> > >>> It is therefore reasonable to drop CONFIG_DMABUF_MOVE_NOTIFY and
> > >>> always build DMABUF with support for it enabled.
> > >>>
> > >>> Suggested-by: Christian König <christian.koenig@amd.com>
> > >>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > >>
> > >> Reviewed-by: Christian König <christian.koenig@amd.com>
> > >>
> > >> As long as nobody starts screaming in the last second or I encounter some other problem I'm going to push the first three patches to drm-misc-next now.
> > > 
> > > How do you see progress of other patches?
> > > Can they be queued for that tree as well?
> > 
> > I was hoping to get through them by the end of the week.
> > 
> > Just wanted to make sure that CI systems start to see the first three patches (who affect everybody), so that we get early feedback should we have missed something.
> 
> Perfect, I based my patches on these two commits:
> 61ceaf236115 (vfio/for-linus) vfio: Prevent from pinned DMABUF importers to attach to VFIO DMABUF
> 24d479d26b25 (tag: v6.19-rc6) Linux 6.19-rc6

The fix was merged https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1f97d9dcf53649c41c33227b345a36902cbb08ad

Thanks

> 
> Thanks
> 
> > 
> > Regards,
> > Christian.
> > 
> > > 
> > > Thanks
> > > 
> > >>
> > >> They are basically just cleanups we should have done a long time ago.
> > >>
> > >> Regards,
> > >> Christian.
> > >>
> > 
> 

