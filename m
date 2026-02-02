Return-Path: <kvm+bounces-69866-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iGaVEkjBgGl3AgMAu9opvQ
	(envelope-from <kvm+bounces-69866-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 16:22:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BA1A2CE225
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 16:22:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6FB6630AE364
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 15:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CDDB3793D7;
	Mon,  2 Feb 2026 15:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="miQCLY1+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F71B378D64
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 15:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770045146; cv=none; b=EwZr8zpl+fWJzft/+XqR5NmAbWvqnvfwydgVVSIiBx766+o958yxbuMuEK1rtCqJdLiK3HyrtIr7/5DjDAjWzCYA2WG6HvaCJfgEd6SJxeMZhsjKSzfVLbE/VDY2s9EATjj285uyOGO/gFkruN2LkK3zxmc1O2cdK67XCyFHkuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770045146; c=relaxed/simple;
	bh=rQqYEXSh+ob8KxdPcyhxAvs4tWXZTKZFQO51kRUI59c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NE8/D4aAd6rFVYcx7KqKZP7E3WF4KVYlqRqujMWxcPncL+Ytfw7mNyuucSJYlHj0a8vOowYGEeJCETIxhIyZQnbJiP8uGT6WVIkKbq/GUtMn7l4MNrd/7P09HjPcbWMU+SXxeHr5btg6p4eT2VvTPoPxnBEXinq6ZaDyXuhvn9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=miQCLY1+; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-505a1789a27so21659621cf.3
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 07:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1770045143; x=1770649943; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xO0aL+oRN74yVSsHQO79QNqtu9/dj8jxjzC/60StG/Q=;
        b=miQCLY1+i0kzm9WHu9ZXCe3lsby8ZnJNjVamX+cRUMDmZ5pwrNDNnRobJc/A13/S/H
         tUFNwf5GJ1myqwSL73s3bRBfHSa9KIJNBOh3lAFBig4niv7DBaBVBlaUvtc6f+5TuUDv
         i4o11P+ONa8pi9KrG0z41tne/85T78p8UC6t1Ub1j6S4F0MoECA/5aOGuyDRBPGnOTKO
         Yd53SYfqvyXGZuft/+O3HF4qPgVp6rvb34Xjy1Gtqm7Ut8FyR/RqOsfm3+zppSd1mrVx
         KL12YLX7/BziWc3R7aq0ROVcXdH1cuITbCuON665DyqvcIYBzI8kVqU9FKjgf5A52+6A
         8bpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770045143; x=1770649943;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xO0aL+oRN74yVSsHQO79QNqtu9/dj8jxjzC/60StG/Q=;
        b=Cx0dwD9EaW5j64eyRjK3QiwNlpbGJNZvOqe9mOlU11uxGDtKEq1oRiux0BJPEriBHD
         F6IiXOTXdaFOoZH1omFqm1AH32aJWwFVzdxCQbrXa8CNfB4RsetqknmSV0HIklnVwPwv
         YhpSHvSgvEpKIx36CEtoMYa7qDonxAc2Pcp9m3vgcVuLTFLzz5uPNjn1teyGVjC6/6KM
         dw8h9Bs1ZcEeRxkdX2jepNh1tYUoSGTkzI9qagYgOARWCwnmds5h8SoFuMRFgSw7L3Bw
         NVWkigFj1SC3jt5ryLJOAn/FMcPKFg6FYo0pGeIFyAp0smAtsn+m1shgdHWWuQWzgBuT
         BlNA==
X-Forwarded-Encrypted: i=1; AJvYcCV5ME0lmlETrRdkcLZTnkJSFGml26KB6a0+A4v9xlPDzMhYzC4/8GRuZ6i0/DyLQTFg7jU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8mRwOLja5ghp8pJjfvRi/9PY/RskvhduanXFe7BoEzvutnaFL
	X9dlLezo1pOfABzWDRPDptQQmhJPkpDdfmLjrnQNr/d3wnvbWF898N0AqdMug2f9yF4=
X-Gm-Gg: AZuq6aID+A+E+HIJok0tLWDzE4/tZzIJPqTOPWtly1UWa3gOWbn20J0S5PJCL4M6+cK
	qPQfme2bLkSdo9/uQ7A54uwwvdfnR6XtmcjHr8ieVSoM82IxiCJr7YuxpvFLZc5cP4NkZkSoVmB
	uuDl6GgU6mKUMnx76oCHnY+Vejavu23qp0YE56+33lRaFWzJKqyWPeKCzChkp1bHvVFpd1v7QWq
	c/b66VYhkcBw/7k3ZkwLX0PZU3khGRf/UM+xl+HRmQ2rNAF23KMVjf4KBl6W4Zlyy7HpBX3Xadb
	/uB8LXy7s6r1xu0XV4hrZaHoSb2ZaUYxO25ml+JYc7WarUAjGAMd8OiewRGtU9G4Hw6slmV9dFk
	p37XsXuTYgWVQhGRjhRLQlk2hkyrPu4Gs9TFVdXMqlcITOTIParbVPiAYATW//mJPs2C6Z5zlWQ
	dNvsp+mUpp8BxbUXfjReqEiR2sq4dFWVhymejF23Bl70xeaVfBpJQDwXcNzowNtTKT1kI=
X-Received: by 2002:a05:622a:1993:b0:4ee:1903:367b with SMTP id d75a77b69052e-505d214ba65mr150834861cf.5.1770045143271;
        Mon, 02 Feb 2026 07:12:23 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50337bb9d21sm106856261cf.26.2026.02.02.07.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 07:12:22 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vmvbB-0000000FJuI-3Zxp;
	Mon, 02 Feb 2026 11:12:21 -0400
Date: Mon, 2 Feb 2026 11:12:21 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
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
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v5 4/8] vfio: Wait for dma-buf invalidation to complete
Message-ID: <20260202151221.GH2328995@ziepe.ca>
References: <20260124-dmabuf-revoke-v5-0-f98fca917e96@nvidia.com>
 <20260124-dmabuf-revoke-v5-4-f98fca917e96@nvidia.com>
 <31872c87-5cba-4081-8196-72cc839c6122@amd.com>
 <20260130130131.GO10992@unreal>
 <d25bead8-8372-4791-a741-3371342f4698@amd.com>
 <20260130135618.GC2328995@ziepe.ca>
 <d1dce6c1-9a89-4ae4-90eb-7b6d8cdcdd91@amd.com>
 <20260130144415.GE2328995@ziepe.ca>
 <c976c33c-4fa7-4350-8dcc-a5c218d1b0d6@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c976c33c-4fa7-4350-8dcc-a5c218d1b0d6@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[ziepe.ca:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,suse.de,intel.com,8bytes.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	TAGGED_FROM(0.00)[bounces-69866-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[ziepe.ca];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[ziepe.ca:+];
	RCPT_COUNT_TWELVE(0.00)[34];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@ziepe.ca,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,ziepe.ca:mid,ziepe.ca:dkim]
X-Rspamd-Queue-Id: BA1A2CE225
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 09:42:22AM +0100, Christian König wrote:
> On 1/30/26 15:44, Jason Gunthorpe wrote:
> > On Fri, Jan 30, 2026 at 03:11:48PM +0100, Christian König wrote:
> >> On 1/30/26 14:56, Jason Gunthorpe wrote:
> >>> On Fri, Jan 30, 2026 at 02:21:08PM +0100, Christian König wrote:
> >>>
> >>>> That would work for me.
> >>>>
> >>>> Question is if you really want to do it this way? See usually
> >>>> exporters try to avoid blocking such functions.
> >>>
> >>> Yes, it has to be this way, revoke is a synchronous user space
> >>> triggered operation around things like FLR or device close. We can't
> >>> defer it into some background operation like pm.
> >>
> >> Yeah, but you only need that in a couple of use cases and not all.
> > 
> > Not all, that is why the dma_buf_attach_revocable() is there to
> > distinguish this case from others.
> 
> No, no that's not what I mean.
> 
> See on the one hand you have runtime PM which automatically shuts
> down your device after some time when the last user stops using it.
> 
> Then on the other hand you have an intentional revoke triggered by
> userspace.
> 
> As far as I've read up on the code currently both are handled the
> same way, and that doesn't sound correct to me.
> 
> Runtime PM should *not* trigger automatically when there are still
> mappings or even DMA-bufs in existence for the VFIO device.

I'm a little confused why we are talking about runtime PM - are you
pointing out an issue in VFIO today where it's PM support is not good?

I admit I don't know a lot about VFIO PM support.. Though I thought in
the VFIO case PM was actually under userspace control as generally the
PM control is delegated to the VM.

Through that lens, what is happening here is correct. If the VM
requests to shut down VFIO PM (through a hypervisor vfio ioctl) then
we do want to revoke the DMABUF so that the VM can't trigger a AER/etc
by trying to access the sleeping PCI device.

I don't think VFIO uses automatic PM on a timer, that doesn't make
sense for it's programming model.

Jason

