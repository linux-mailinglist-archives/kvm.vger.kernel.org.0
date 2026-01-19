Return-Path: <kvm+bounces-68525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AE52D3B396
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 18:14:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0F0C8305C963
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 16:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9673D32ABEC;
	Mon, 19 Jan 2026 16:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="LnhuTqCS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f196.google.com (mail-qt1-f196.google.com [209.85.160.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521822C3252
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 16:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768841183; cv=none; b=HoypamwZTtidLK2uSEu8bjH6rzubachyAXp6u34dem3q+5NSHO4zPSNOgaYvSS9BTe0Nhth6E9gVL/hMX3F1GIItOcEH89/kIBsi4XQbzp/8E38Kp5JsKCWUR4brjAS/Avoz8bEcWY/wgCk/sHnmYI/yKXvNs7I5aHptx7iWXco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768841183; c=relaxed/simple;
	bh=QIsc13zuNMkL3drL8s77g4pkAR1CgvBQvDpaSTaFqoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LRFExAX5iowaHp78QZh7P/DNy2s58OOjq3eg2lFNNvsOcKtQQpLHUO7VZxh0CXnrTSsZYY/jAQdXVA7+TbdeFBQ0eFcb7PhBOg+MTewnirJB8Tqg0YQZWsKv+UpJEOvf5iuFlNtZqxFwnhYWoFIwZbWOK4owy9Rfy5+hSE9o/oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=LnhuTqCS; arc=none smtp.client-ip=209.85.160.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f196.google.com with SMTP id d75a77b69052e-4ffbea7fdf1so37390231cf.1
        for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 08:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768841181; x=1769445981; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zfC54g6ZC0VxR+dcM7NfRz1NWoEdvriN2xR6YNn2bfs=;
        b=LnhuTqCSYYu7TcIbAnYPkvI5sikLjgegupyFhj1AkXSeAQEmNvPoDaURBqTkmDOPh4
         9GWTZ0kFXrwpgj0slJxOpserr7lLZzMuwjd2hvDRnBSj9KJIme4IAmQFNGuNnZvl1UN0
         LWBNVR8hhShW3s/fLXz19OYkJWPh7AVfn/IPLAWFlP/sjIxzWBkHk7Hc+CNoTzYO9t8T
         xS1LHAME5Pm2HQiPYUi68XNkGQNKO/B6HHRnDw9Hvet08fcq51PMU8dHXmil/AYj/eU8
         YE2UB0nI5fUTsSGNWuQJlXh74grFC/zO0Nmd8137CiMr0RRY+lmD2B7GUFcAMeHMCVBA
         naDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768841181; x=1769445981;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zfC54g6ZC0VxR+dcM7NfRz1NWoEdvriN2xR6YNn2bfs=;
        b=OTbFrpfe7jiNvpim49BnNbjKmxLE+4ybyftyf0m8iqcVJ8QZE1tdgdgJRcs2yvP7AQ
         wV7ErwM/v1MtzyhbY4pvOOmOyiBtESmutiV+KK0wj1eBYkWOHFr61DcCNHgwdA7J4ifl
         wNF/hT/CUbdUTEY1Gfk/plDCAsj6Sb5QBdPp/zGDw1Py9ADQfIXdFoMIgpUMr27UWDgG
         zgdDLE92daFLZ2nf319lHkHNPDd+5qj3unTcULoes0fa2eAYibQN41Lh+bLggFY6iuJR
         K9AokM4yfWzd53ffVm5kqoFye3UhbUgxvVIban+lILUEVLOp6w5Xgw9s+Ja9WUw2P8Dk
         Y5pA==
X-Forwarded-Encrypted: i=1; AJvYcCXLik117FaK1PUPPBMGNvJgIagNSLpXLnxVoZPzk0+XxbVYIpaFmwNsaCqJprdBtaLvSI0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaLDnTmf1oaKwz1HpVYXbaodHGE21HEd12XnLzfYR4lbyoOtM6
	KDzUOfTCWHZXEprtNyxwo0XAEmTqRqOrRxwn6HCN0gcVn16eqEP3p9HQjPAt4Qobxl4=
X-Gm-Gg: AY/fxX55oreWhpRmC9qdn/GLQIQI9I97vdIdnRE11IY1mQlFnVLddYDeXWXntlZ1bsd
	mPtDafnSKARMyW/Icbss8ir4ga3wrDJam8fr/lAdQSd8GwPyCcfnuDp+I4ZlkzOB1wH3TQ6H4S8
	JmHQUyn0j6Jwtnsdk327sB5pQBxvtelpL4+P1pKR5YPepZCmzJc+zyqjh/poYZz/58sOHWmZp83
	l17A+YJXsLe+rGaKXqWa2obCLrENn2voruLvOd1j9f5a5im25Gtqlx9CcH3fA1+r/WBg2/kKjK/
	Oo21aMcBdNcgkX4jDE23daC+ge7iESrRVuYOlg3l4iGZ4AzEU5bvXWOIVFuOlpMVxecjwXPPEDK
	+eTlp0gGnnxMk4R65rxRj8+i9SRNYmCmv5uMpFgtI85rviFvuIqm+MTQSQgSyBRUqtpDUeBvyZJ
	DASitEeLanhiM2a9k9khcEPuBochRGSgVOdsKaF4W9epTSfsrtfEeoC+bW917PJ51JYDw=
X-Received: by 2002:a05:622a:58e:b0:4ee:17e9:999a with SMTP id d75a77b69052e-502a1e551b4mr166978451cf.33.1768841180580;
        Mon, 19 Jan 2026 08:46:20 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-502a1d9ee19sm71855641cf.14.2026.01.19.08.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 08:46:20 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vhsOR-00000005IML-2VzR;
	Mon, 19 Jan 2026 12:46:19 -0400
Date: Mon, 19 Jan 2026 12:46:19 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
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
Message-ID: <20260119164619.GG961572@ziepe.ca>
References: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>
 <20260118-dmabuf-revoke-v2-2-a03bb27c0875@nvidia.com>
 <8bc75706c18c410f9564805c487907aba0aab627.camel@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bc75706c18c410f9564805c487907aba0aab627.camel@linux.intel.com>

On Sun, Jan 18, 2026 at 03:29:02PM +0100, Thomas Hellström wrote:
> Why would the importer want to verify the exporter's support for
> revocation? If the exporter doesn't support it, the only consequence
> would be that invalidate_mappings() would never be called, and that
> dma_buf_pin() is a NOP. Besides, dma_buf_pin() would not return an
> error if the exporter doesn't implement the pin() callback?

I think the comment and commit message should be clarified that 
dma_buf_attachment_is_revoke() is called by the exporter.

The purpose is for the exporter that wants to call move_notify() on a
pinned DMABUF to determine if the importer is going to support it.

Jason

