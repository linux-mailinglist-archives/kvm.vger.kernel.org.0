Return-Path: <kvm+bounces-58401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EFBF5B927B4
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 19:51:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA355444502
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 17:51:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 542BD316910;
	Mon, 22 Sep 2025 17:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="O+3Sqe3C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B212314D34
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 17:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758563485; cv=none; b=m5EhrQL0orRJYiciI6ExUbmL/q+fiLNpSXpjHvB0CqCH43phhw5lfHwOmVR0xvWrvrBiFcOiciUUzVTYBThTQVekxApaRBRA2VeNUVVIbuzLmofgK65CSW9+0KFsRmy08YziJvIW6Fi1qC2mOaropotYNOdC4ZPj8BXF9X+iEsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758563485; c=relaxed/simple;
	bh=3VGwOwFOdv4ZHiKqvtBCgZGw+M/cK4AH2km8xsUcbZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tifvlyalh7tDhRBaFYn7x2dlicMFO3FTMonoiSP7LwchAYU0UX1HrF88QqC0D5KnLEbPZdHjJqoPsOV9j0NweaouAe06VkTdgw6ZmLfdVWpX/vpXf7i4E5jaRGe4NF2VUFF7w+MFSy4GI2jwy1oqq/bI/Or9UWMRQ2AvxrRCk4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=O+3Sqe3C; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-789c9c12c11so664518a34.1
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 10:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1758563482; x=1759168282; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3VGwOwFOdv4ZHiKqvtBCgZGw+M/cK4AH2km8xsUcbZE=;
        b=O+3Sqe3CXuot+9uODJjyfKBTy9kYDZmGibSFPkMWjZOi5v/tm3dDMDcp113RgqGklB
         uf7vCDy/XOS6pHoT0XwUC2/gLMp2MbxPKtVBq85Q+kpUfOOtqBcrDZG6vFwdKf5/LJHg
         v62gAwgGz0gZfWG/HkcJG8/PVC5TQ7gGk5BgQlMq8IKgmOzI1kHVdwvI24/abFqluAsl
         sGtA/qUt+mfn4YQgOw86yAXv5EPoixNv0neavDoZ9bYhZJHz6blQkeqmAW/lqrRRZe/i
         mx9W3fy6tu3OfwJi8zhxtjbinQ9E10lsGUheE0jOAw4fSOmHEP6BO1CqRxM95qk4rEu7
         wx7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758563482; x=1759168282;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3VGwOwFOdv4ZHiKqvtBCgZGw+M/cK4AH2km8xsUcbZE=;
        b=PaoU5jGiw98Cq72eKEMv4M0Ttrcq8kv6qz0pzEzdyFnnqQL0noTYoqi0mYSV0cJNSR
         rbuQtWpnLREdZhsxrGOLugGmge9qmO43760ZuUTZXdWBN+VqeSC7jUKrsziMvCHrTyby
         +pUALc3BRdXFQ8Gzyb1oyYqK11xZHH8gL0XKY0Fvrvsmu1Ot8yEWo4+TfaNsPAV1lgH3
         uQEc1+Xf9nUS3qPaFdOdaiKEuDcIM0OljhzEMmrCrSUTAGCToolI/IurSTjymQQt4qSU
         31zA/Zd+XMTwmOpuEsKdA9+m7ofiouyS1oqf3s/b2d5LHiSGxynLZE3PcJ1ErAxZtv3+
         DZaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqfT34GLGvuuTwhV2I+Ub1XJCL0zNheqShGmLGpWSEG8J0+jiLj95nEyEZMrmUGTD3bY4=@vger.kernel.org
X-Gm-Message-State: AOJu0YznJPv+Y/zZVVJj2p5+I+u8mQbq4V+Nm4/zYToX4M4vO4hrLxEX
	+I4V8r15V7D92U1IEZaxMjl+E6qJFb7uCOsvuQSBSYIzKXh/vfNbIPJS6TvidmU+Ubk=
X-Gm-Gg: ASbGncsJW25nuBsEpoe9TRupOHFAAUk0LnVg1A8nrxAj3IeK0vrjHffR+aKyisxqRXN
	efsNIx2egASeoRZCA4MiNXZQnlHkJ807T98U4uKNrK74MJhmxmBLHtZ8IRQT5e076Y7idf1qGzd
	6y0YCr/aWATz1iyq3ErnXfJgjuxVe9QfBXcTK3iy3NNGhf9CIMqXf9FePmnqfzf+Y4AyYkHutdB
	+cgopDGJEmtrCmguv5KguzCa5pYoVFJV0XFluPLLngvYm5R099NC7shS1F49W8Cq++bK91VKown
	cDexPKnRpO5kXCfuxTx3n3SUFzC63W6PdF+aqAEHFcEmBtpVihzP6hnIcH0UMdAwusTy6dpj
X-Google-Smtp-Source: AGHT+IHoHwbeHyipS7ya2jIOwlHRG1IiqAe3uqF6PSNYBEMqz7YnlEdpM+nslTojj0nGh1U+2X+yyQ==
X-Received: by 2002:a05:6830:82d4:b0:746:d682:c986 with SMTP id 46e09a7af769-76f7b5e0cd4mr7967212a34.17.1758563482035;
        Mon, 22 Sep 2025 10:51:22 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-77ee58e54c3sm2020597a34.2.2025.09.22.10.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 10:51:21 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1v0kh6-0000000AlpO-2Gtc;
	Mon, 22 Sep 2025 14:51:20 -0300
Date: Mon, 22 Sep 2025 14:51:20 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Mastro <amastro@fb.com>
Cc: Mostafa Saleh <smostafa@google.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	Keith Busch <kbusch@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>, David Reiss <dreiss@meta.com>,
	Joerg Roedel <joro@8bytes.org>, Leon Romanovsky <leon@kernel.org>,
	Li Zhe <lizhe.67@bytedance.com>, Mahmoud Adam <mngyadam@amazon.de>,
	Philipp Stanner <pstanner@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Kasireddy, Vivek" <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>, Yunxiang Li <Yunxiang.Li@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [TECH TOPIC] vfio, iommufd: Enabling user space drivers to vend
 more granular access to client processes
Message-ID: <20250922175120.GA2547959@ziepe.ca>
References: <aNETcPELm72zlkwR@google.com>
 <20250922174630.3123741-1-amastro@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922174630.3123741-1-amastro@fb.com>

On Mon, Sep 22, 2025 at 10:46:23AM -0700, Alex Mastro wrote:

> Following a dma_buf_ops.mmap, I suppose that revocation would mean:

I'd investigate adding some ioctl to the dmabuf fd to permanently
revoke it. The zapping/etc already has to be done just to get mmap in
the first place. The vending process would retain a FD on the dmabuf
and when it is time to revoke it then it can call the ioctl directly
on the fd to revoke.

Jason

