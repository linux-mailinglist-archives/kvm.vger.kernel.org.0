Return-Path: <kvm+bounces-69680-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QER5EQ9XfGn6LwIAu9opvQ
	(envelope-from <kvm+bounces-69680-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 08:00:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E40EAB7BAC
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 08:00:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1751230098AF
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 07:00:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB5372FC00D;
	Fri, 30 Jan 2026 07:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XgFgDh/B"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E8B18E1F;
	Fri, 30 Jan 2026 07:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769756426; cv=none; b=OllqJ5tLolwZlIZSO8cbc4rtZRbvIrBto/lSB+P0UYZtC1tQhYrAFi27sQ0HcHY6is2CegqUZ+lEaDONmqVH+HrbhXsF/J4FxK9HpHA44CPBQpmvBa5G+FSPNCqczaDAvTjRd+TtAe834tw3Wnp6xcK1wLJG2mrCWWgtlvKHIi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769756426; c=relaxed/simple;
	bh=SwKC4Xj637CvF1FqfD2Ffqfuyi88P+/KMhUf6nGE4LM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VDbsPrfMOs6VI7Fo/dL7mE51N5gt6Y4teTFcJZgilkiK0fu7ZB8qyCzBKbrWEV0+mILuPPfa/NpdxHdztOSjBPLJbwzDnU29kBCJV1WHymmc8+0rNqQYscxxuvWeRlPZjxZ0mhszgVvNa50D/w87E6ayT5zsXQqHp9WKzknUBlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XgFgDh/B; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D936C4CEF7;
	Fri, 30 Jan 2026 07:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769756425;
	bh=SwKC4Xj637CvF1FqfD2Ffqfuyi88P+/KMhUf6nGE4LM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XgFgDh/B2YishN2dcZMkY4CYAevPBkIu68baPIcKz/BgbT6K1tAsL2PyN3wiTtTdC
	 jo/kJAT5trQs3MZIEI2HGW5+AMnkxt5iV0ImdQgQsoTCoQBNrmrR0NYasy+oABNKse
	 2506cQYBt7VCpgmNR0NGwk8KJuGzVDxaTxLm5zv3CFufoJRLo+BJmBbclqkeysqioP
	 G9FDslcvaLNN+jr1zhicNXavcYV8aWXwLQJxJl1mt6q9n8l+XfSHeCoa1t8NTjNH4p
	 +u5KQMWBIITybzgApJ5DlFVUHQvpdI2Ck7QaRsJjuRp1K7FbNEEVLaxkSmNyiD2Fm/
	 rdwqK8S3ocnHQ==
Date: Fri, 30 Jan 2026 09:00:20 +0200
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
Message-ID: <20260130070020.GM10992@unreal>
References: <20260124-dmabuf-revoke-v5-0-f98fca917e96@nvidia.com>
 <20260124-dmabuf-revoke-v5-3-f98fca917e96@nvidia.com>
 <0d2ec2d6-c999-45d8-a2bd-b5b21883db47@amd.com>
 <20260127095831.GR13967@unreal>
 <83cd911c-99ea-4fab-821e-fcf703209731@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <83cd911c-99ea-4fab-821e-fcf703209731@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69680-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,nvidia.com:email,amd.com:email]
X-Rspamd-Queue-Id: E40EAB7BAC
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 11:02:03AM +0100, Christian König wrote:
> On 1/27/26 10:58, Leon Romanovsky wrote:
> > On Tue, Jan 27, 2026 at 10:26:26AM +0100, Christian König wrote:
> >> On 1/24/26 20:14, Leon Romanovsky wrote:
> >>> From: Leon Romanovsky <leonro@nvidia.com>
> >>>
> >>> DMABUF_MOVE_NOTIFY was introduced in 2018 and has been marked as
> >>> experimental and disabled by default ever since. Six years later,
> >>> all new importers implement this callback.
> >>>
> >>> It is therefore reasonable to drop CONFIG_DMABUF_MOVE_NOTIFY and
> >>> always build DMABUF with support for it enabled.
> >>>
> >>> Suggested-by: Christian König <christian.koenig@amd.com>
> >>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> >>
> >> Reviewed-by: Christian König <christian.koenig@amd.com>
> >>
> >> As long as nobody starts screaming in the last second or I encounter some other problem I'm going to push the first three patches to drm-misc-next now.
> > 
> > How do you see progress of other patches?
> > Can they be queued for that tree as well?
> 
> I was hoping to get through them by the end of the week.

Christian,

Can we please merge the whole series now?

Thanks

