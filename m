Return-Path: <kvm+bounces-68520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B1587D3B11C
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 17:33:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BFDB83066E13
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 16:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9197131197E;
	Mon, 19 Jan 2026 16:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="k0MwFnzh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f195.google.com (mail-qk1-f195.google.com [209.85.222.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F76311C3D
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 16:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768839868; cv=none; b=o5V6H1r4JnIzn1gILtml8+IGYUXqzTGmi2MqY9zdemA+upil69p41eYhx+P3kyj51rGC0zDFcSlz0Am0cmdt5ljqXvd40WiKBWhH18x1B3PwK9WMeATTXZEcmeO2vspUc5uR+SZf7UfQwPwV59+ChY/mGnowjUHzqTM4/4tiOb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768839868; c=relaxed/simple;
	bh=y4swwYbPI6raB2hvkPRsghll5RR/RHHzFup3OVrjU1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tFnL5xfCr7MY4xdRV/xyLsmzxzG0B4nDkdCkwH538LWo7R4Tv6eAgdpfJ56lr6ufjtGkpZ6pk6Qo0BRJMTLWPZXU7/SrgRvpaGQ1rKgKL+0Sd/9ffmJWvBWNVGlXGp42tsDAP9ucn5076nwIONQlasn+8PAkBAnxcecJxWKIJqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=k0MwFnzh; arc=none smtp.client-ip=209.85.222.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f195.google.com with SMTP id af79cd13be357-8c537a42b53so697780485a.0
        for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 08:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768839866; x=1769444666; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zCRrpohPCspJo8o5qWVDG1aTKo63AMTSXJRpwyKl02I=;
        b=k0MwFnzhJYQ0FsSCLpzstcTbAPrdHFDOT6N9tTcMow05R5wGoAlhaAT+qQ/XnhKfVn
         +s7cNsxfcUJSJFOrOQByvL8gkjK2pLC88AE3eofHjhr+p490ONx1UjwTz8XFYQeUpvQI
         vkQvbBBEDeQBKcKJue1qLYssmqPS9RO7UhjbaV5WGJfuQrTdviABGjrt++VXzLkWBDsm
         TKofxL6f/hmoYRC8NXavZreJjPGd8PHi/HePCtBfYNQC6EnFmmPqcsLsK46YRJfxIT6f
         4t2JMXUziCtW/6m/+CukzJZ+lc5/HkrMW6LCcpAqDvA/fG+u0q4RWZK2ri43fEoNnknD
         jtzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768839866; x=1769444666;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zCRrpohPCspJo8o5qWVDG1aTKo63AMTSXJRpwyKl02I=;
        b=RsnekePSlBbzQ5yadla5ul5OYKR4zcM5RPRzQDImZfa6Ljy+i3yidObStR5zIdI6JF
         vWa09w/4cItJRFS6V0KBFTJqajVZYBMELoYsuvh+RL1ptp8XInYdrcwOpK0fBtFGUpyp
         UR6Dbeup7aE5YUwye75cV0oy08lgTKNwRuJO1GxwQ0rk6VDJWreOuDZaOel0SymqrZeL
         vtCSdd7Gk3gmbJUkj5C5UoTNJG0fxg693/2R68qqtPPRLjDxlhVVNQXq8LqJ3gKIi0Ur
         Huu+NNrIYaM0x9iYyTCf484l3iXeFumsU9+fZem66I3TRAHo49UfamEMiHWds4pH5Kbs
         KcwQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0chwlFx7jJK6H1z8EwacpTDHo417ZgfR36tlMhuxRmLmJdeF/3LXLDqBeimTn5IqnWzQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhnRLt3lBDsgIqMaxNmCUkd+nX4e0iEFiOVMrLl3dR9yDbxTcG
	ZN50prRvPR+OIv/sIY3E9E9xcY/JXclmDoJMSCvSokmNwAA+28e0qumWVuNpbl7RsKg=
X-Gm-Gg: AY/fxX4O1ngr7qHYzYWqLf6N4O5RbgcHC0cDmz3iavkSESfs2Zg/73AepOBylymcdi+
	xOgCNLe4ZfV+E/bO8rGrH+pWOFP+yY6GvprpcariV5Kv1U2im/eDru/CYkvYYHZ9OWDAmn7PONi
	ekNJllKkivHiwKccPW5taIw2fTqwiYgyjNwOrDtXOFn868ap0TGo2iNB1f23npXMFm9AmPXGLmy
	YHReAb1Cb/xSUHuElCJJvl6+soCy1ruv+ewAYJK0ThlNf4TS7dTSv/hBOdhE/LtCtlL8sonbQ5a
	PFlG3NYTfSYPNM4nYFlsI+85zTdDZiB4p3Gelo2Tfy8KjCXLgEdlbkhOrhlRVp1k5uu7VFA5Isc
	r9UqGth2u2AH5A2KQKhOeZ1DRaTGMcDkfQ7Vgw3BBSnpkn/kFr1qwFgq3XHS+XaujoyYM92AWQ5
	YuuoRiA8cn0fCnHD1jDUD9AIPpS27NdLshWvjHicMU6x4DYG8+Ymm+g801vI4UeVw0OSM=
X-Received: by 2002:a05:620a:2a02:b0:8c5:33bf:5252 with SMTP id af79cd13be357-8c6a6963403mr1445548485a.70.1768839865634;
        Mon, 19 Jan 2026 08:24:25 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c6a724a484sm800372485a.33.2026.01.19.08.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 08:24:25 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vhs3E-00000005I0S-2Krj;
	Mon, 19 Jan 2026 12:24:24 -0400
Date: Mon, 19 Jan 2026 12:24:24 -0400
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
Subject: Re: [PATCH v2 0/4] dma-buf: document revoke mechanism to invalidate
 shared buffers
Message-ID: <20260119162424.GE961572@ziepe.ca>
References: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>
 <f115c91bbc9c6087d8b32917b9e24e3363a91f33.camel@linux.intel.com>
 <20260119075229.GE13201@unreal>
 <9112a605d2ee382e83b84b50c052dd9e4a79a364.camel@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9112a605d2ee382e83b84b50c052dd9e4a79a364.camel@linux.intel.com>

On Mon, Jan 19, 2026 at 10:27:00AM +0100, Thomas Hellström wrote:
> this sounds like it's not just undocumented but also in some cases
> unimplemented. The xe driver for one doesn't expect move_notify() to be
> called on pinned buffers, so if that is indeed going to be part of the
> dma-buf protocol,  wouldn't support for that need to be advertised by
> the importer?

Can you clarify this?

I don't see xe's importer calling dma_buf_pin() or dma_buf_attach()
outside of tests? It's importer implements a fully functional looking
dynamic attach with move_notify()?

I see the exporer is checking for pinned and then not calling
move_notify - is that what you mean?

When I looked through all the importers only RDMA obviously didn't
support move_notify on pinned buffers.

Jason

