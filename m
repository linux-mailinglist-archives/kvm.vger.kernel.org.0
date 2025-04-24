Return-Path: <kvm+bounces-44125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 24E0AA9ACDC
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:07:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9CB3194327C
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 12:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B55AF22F743;
	Thu, 24 Apr 2025 12:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="f7cJVsfp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE7322ACEE
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 12:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745496426; cv=none; b=tptQJCp+X3jKXnZRhA8dJpKhoaX7LFXOGopK5wq3DJZPJgfbqq4TJUj+CFCVcMAfD76G1yTdmwrco0o/Mrbu1ly1OZusz9y+b0ypp1ndurml0vQU6F4csIXWM9iodGRZaxmdufthTCdG/mphcV5u+AVLB0WcYGqxpiGCrmNzp/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745496426; c=relaxed/simple;
	bh=nEDDMXWDWQ8vbMZ4RzV5iFaKUbMAXslQJ0AI2qRKz1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nEQxKjJkp0B33Dl8Wkkqn4kNvnUlBQdgsgFgybzUQsA5LwbKbk8nzMZy150oITUhZrRu2khhUh+uhQpZAy53euOjOKmg59KeliKOZnEtsYqPDqqQvCN/F75VPKmH2hK1Ac9BoerASUK5A7FqaT+r/Rf/XdVG4Hs1o/j6OlnG8wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=f7cJVsfp; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6e8f7019422so9374666d6.1
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 05:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1745496424; x=1746101224; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R6hXpeFv17Go1fQZO2l00KUq0djvqX4j0LhOJE1RpTI=;
        b=f7cJVsfp4HZOCBfgkFOjS8VB5UTPsgQN5/v4PKJJdeYmvMHpeUUjyFBtxq625zmmXj
         k3EsNWrVm4OjvneO9B/ZGxtL/rpaonVPAAjjGFX+l5BRWixEkwxmCTZhWGhVjWXavZvy
         SR/X9vSe8/xbMouYwZ0dwG5aRWBzfCS3VEs2YuNNu7WhqNoJC87NmU1ITldY/q5keuFB
         UocYb0O5T6DZQQAxBy2eHshKKb6ic/dU+u02pKYO63/pAn9VmdibNn0xnBEaWsAUreBJ
         Z1PzPeTOw4bJhhuyXLg188k6/2/iJ0jeryJvUMqbo4ULLvgDt2S3svr6dQXCb60ytHgh
         QMuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745496424; x=1746101224;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R6hXpeFv17Go1fQZO2l00KUq0djvqX4j0LhOJE1RpTI=;
        b=mILjGCJzqbkJPYCZtVln+Z0lbX+ADMGnufiXphOWarphC4JChJgt+MOelmmWuOtN6I
         sfI3VDsg2QJiKH3h+PimMGLIVMfWxJ0ynhxgkU1SAthobCrzVPXYA4vl+79v/KPKpyfI
         VZL4+HxFR9GPRhnCHGLtItuaJwhaTi5Tl/nJmsG8GgQG8KX+DpCYxHf1dOIAfYn3QNiN
         JLLImUWzSw2u8p41q87a6S8sXGD6llL2E334jatIy6PW/YHkDfaLt//KvHkoKPKDGO6R
         i4xs+gAm62S8pakuUsUTK+1U4sI4tabcAnXn14pcYAtdAgZFhD7I2xIumI8FDTOIPQj3
         KCQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWP+VHAeb+HadvM9KdCvfuUhacM4R+fY02dQ6uNldugk3m5BMIcIAiSmQubQsneBCQ6q8A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2/GRszOChj9DrXW0CYZDNT8KoorPZ33gdMxCM7U49+NA1PvU8
	/WSr8NJTaXgFnT4VXFkgxMvEvLuPo/mClJzNYn+I1FuIvor7CPq+aK8yXm5+1CE=
X-Gm-Gg: ASbGncv2fMpVx+jc355iAI+1mK4yPXZd22HvbrxGJug4KqpzDPcII1vprdYjseVigJu
	yZawGln/NITs6NSrL9BVbCjEjmaGAqPn30KycITVKnrWAqvipDvtrxZf+pFvR1DvyeFfMgX93pF
	Vt0aDiz7I9F4kKmp9LQEIqOeoqngXnZzYKEbi1yNzuy44mCHSYHhYCk7HXwjy/jKFgxnIacIJtw
	uLHzg8FAnP3gRNYywGUqz0A08GYji5RwqdCMkLGQrFDUXeK148bNA/0lBI8guwxyH4EntRD3mPr
	iRAwu/5Lq1MkkZzoglKZZoAAu3l/oGUdenQ3/ZMRWnazMxEO19Qi4+ukkB6LDsSyvjrpL0V+Edn
	kALeHf9+HEj8p0VxW/4c=
X-Google-Smtp-Source: AGHT+IHFhKOxhA0o2WRAa+GJNDxvcX1iIXnEJwZa2QwM9rbiZA2VutZzFm82YY72gKJwza388e3Bog==
X-Received: by 2002:a05:6214:518c:b0:6e6:65a6:79a4 with SMTP id 6a1803df08f44-6f4bfc85415mr35084026d6.44.1745496424198;
        Thu, 24 Apr 2025 05:07:04 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-219-86.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.219.86])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f4c0aae668sm8460536d6.113.2025.04.24.05.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 05:07:03 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1u7vM7-00000007TSP-0PWP;
	Thu, 24 Apr 2025 09:07:03 -0300
Date: Thu, 24 Apr 2025 09:07:03 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v9 10/24] mm/hmm: let users to tag specific PFN with DMA
 mapped bit
Message-ID: <20250424120703.GY1213339@ziepe.ca>
References: <cover.1745394536.git.leon@kernel.org>
 <0a7c1e06269eee12ff8912fe0da4b7692081fcde.1745394536.git.leon@kernel.org>
 <7185c055-fc9e-4510-a9bf-6245673f2f92@redhat.com>
 <20250423181706.GT1213339@ziepe.ca>
 <36891b0e-d5fa-4cf8-a181-599a20af1da3@redhat.com>
 <20250423233335.GW1213339@ziepe.ca>
 <20250424080744.GP48485@unreal>
 <20250424081101.GA22989@lst.de>
 <20250424084626.GQ48485@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424084626.GQ48485@unreal>

On Thu, Apr 24, 2025 at 11:46:26AM +0300, Leon Romanovsky wrote:
> On Thu, Apr 24, 2025 at 10:11:01AM +0200, Christoph Hellwig wrote:
> > On Thu, Apr 24, 2025 at 11:07:44AM +0300, Leon Romanovsky wrote:
> > > > I see, so yes order occupies 5 bits [-4,-5,-6,-7,-8] and the
> > > > DMA_MAPPED overlaps, it should be 9 not 7 because of the backwardness.
> > > 
> > > Thanks for the fix.
> > 
> > Maybe we can use the chance to make the scheme less fragile?  i.e.
> > put flags in the high bits and derive the first valid bit from the
> > pfn order?
>
> It can be done too. This is what I got:

Use genmask:

enum hmm_pfn_flags {
	HMM_FLAGS_START = BITS_PER_LONG - PAGE_SHIFT,
	HMM_PFN_FLAGS = GENMASK(BITS_PER_LONG - 1, HMM_FLAGS_START),

	/* Output fields and flags */
	HMM_PFN_VALID = 1UL << HMM_FLAGS_START + 0,
	HMM_PFN_WRITE = 1UL << HMM_FLAGS_START + 1,
	HMM_PFN_ERROR = 1UL << HMM_FLAGS_START + 2,
	HMM_PFN_ORDER_MASK = GENMASK(HMM_FLAGS_START + 7, HMM_FLAGS_START + 3),

	/* Input flags */
	HMM_PFN_REQ_FAULT = HMM_PFN_VALID,
	HMM_PFN_REQ_WRITE = HMM_PFN_WRITE,
};

Jason

