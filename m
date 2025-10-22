Return-Path: <kvm+bounces-60821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 909A2BFC19E
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 15:22:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C9EFA56125F
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 13:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C58D347BDC;
	Wed, 22 Oct 2025 13:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="OTdjX9Ip"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38A8346E7B
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 13:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761138139; cv=none; b=asyCujjOMTTNAR2lBYNwdg5Mu4eT0lkXrblen8EdXVzzUjrsoQlvPdjBuFadaVPsZJgg9Qygg7dPFdiaAxLuLHflueAUg2lWabd5jUO+1wf+hVWQ8+rmwiTK8EP4yoJ8Qdv/IWRKc+8jAx5YpBQ0a9XURfx4mD5sOmS9/mf8Drw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761138139; c=relaxed/simple;
	bh=lancp4F+gIJloseWretT9AZMSRcc8xPslAj7fQu0OfI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cr/2U3LrGNGVFrSyc8/x4cs64SwlMF5ZENLOr9pCuFWFCcuTp03oiHxsP52HT7G+7lZu2SL62+m4QGE43yTMJ8qvI3ag+yw3aXBP3XZcRPXeuJQ+4E/oABzUZ9Hu24Ns4jyTX9+y80tE355uOavmrKUkPsE6B+RwgIhePNNJQ4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=OTdjX9Ip; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-88f27b67744so900689185a.0
        for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 06:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761138136; x=1761742936; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q4+nptwg+b4cKjk/7eopK4TdMQlKGxJAx/ff9A8jy1A=;
        b=OTdjX9IpeyqrtY5NsIXVyy4/NNMoO/15SGkB752CL6RNiFDilySoKOcM5vP85qeP7j
         ePVY4fnMskzqfRw4fitQdPlkdyaNgdwjNQAhclLxkifNcnjogOWHcVwhXEegWCSE5PHA
         n1wnpmDiDS8c6GXosTGn6Lj97fgX+ApDH1sI60Qo2N/9ZpahbJMSSG9CIdJlbo+xve4z
         xSdoYi4r0B8ML4PDpZIMWVcXp0FewP64bILtLS4vIuCaKWT+sOfCufjhJkvCBKiEufxg
         GHfu/9na6a4qdkuwXzRLXVsm/025iLO130PWeP/+OXndbzrBNVt4dUOJ02Mzp1QkIhQz
         crpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761138136; x=1761742936;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q4+nptwg+b4cKjk/7eopK4TdMQlKGxJAx/ff9A8jy1A=;
        b=OYrglH+Ykcj4EM4SNSkf91U7KMPEm1J7CKQ2RyP4LfcGdHaqOCuPRQteQkYRZtrZG4
         T4UKIP87Umaual60+9c/c7LTuIINQl4N67VdbZh7v9iKn9Fm+BJSZa49/QWKoPTTYh/o
         0BjrH3Ghg0RFkHJ3d2Sa0EUHOou+T6ht1G3faCToxYwjJiORxLXBMB7iT1j+e/rbPQtJ
         5CFTx4NBT8KwbGcGEMcy8pqckFAOLueBPdAxXvv2QzvmT9kcqhgTqBwgluyvEnmXdaVU
         ZZQc3wCm7+wcVZtU/MvsdZZxROn6pkFxri2o05HFxsDzOkVRbO4mkuZJtc+z261ALy6E
         cLyg==
X-Forwarded-Encrypted: i=1; AJvYcCVXBz9rH6g1sRKsc7nxwFNd7SgWdP3ud7cvzzwYuRRQSq1hJ1pOJQ8nY6x1BRRYgC14TBE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQj6R9L72HJ4shFTsGsjpwN4WQ9FexOjbJU4wbwWOZ24t3y7Te
	ag2xcIYmziE8DNfl1hCVGEN8sKqY2BrJ2JSfVjhoeqmcXwqYeLe7wl/PPo35aax+Qy0=
X-Gm-Gg: ASbGncuoh1aAUAQbp+YR4RGuI13lmKl0m22/ga4v/U/EyyjcNFfQVC/bMBQzAhRVCvK
	gcCVEZbtQaXj7wC6OGRO4Dtgq9EgEdP2ku7bNp779Jc86m8amZW8mPaVFONAqtGLdaHNf83yjA2
	OilCvSM8gHQAzHm3aOZQOjtIzkgXoyNF+cZecyq+kWoSt2I2VUp5/wcpPyFpPnApIiT4ZeN6l/i
	O3NysJp1t8mEsOWeGUMkF2ygccLyCNJeutuOMrti2mygFw+cQoDkUoVlpPC4zHdQ/8CgO2tQ48Q
	NddkwPDsNE9FmDLgvcYpUod+1QcNh3ekd8husAggJqxhzjo8kRqTuRg43uzwMfi47Wev77GfIqH
	t7fXld1LXR2F8CEwZoUInf3cZunGARkv7Des/2U9vMnxX8nH0lFobqM0gkl6yAD/DIfgcxmhUGM
	KyJZ+psFOldNHhRvXPdX9kVeNcgqJdkosgAWvF93/P2DEdsw==
X-Google-Smtp-Source: AGHT+IE1fp7nysFYiIihX3mwCtCavGTxjXwNOEmPOD6TCnzoLGlT2YOfHP4QDFq10IqJKetGapnVeA==
X-Received: by 2002:a05:620a:171e:b0:891:bde8:8120 with SMTP id af79cd13be357-891bde882e8mr2006535485a.85.1761138126706;
        Wed, 22 Oct 2025 06:02:06 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87d028a9a48sm87209396d6.43.2025.10.22.06.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 06:02:05 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vBYTc-00000001288-0pdQ;
	Wed, 22 Oct 2025 10:02:04 -0300
Date: Wed, 22 Oct 2025 10:02:04 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Matthew Brost <matthew.brost@intel.com>
Cc: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Lukasz Laguna <lukasz.laguna@intel.com>
Subject: Re: [PATCH 26/26] vfio/xe: Add vendor-specific vfio_pci driver for
 Intel graphics
Message-ID: <20251022130204.GD21554@ziepe.ca>
References: <20251011193847.1836454-1-michal.winiarski@intel.com>
 <20251011193847.1836454-27-michal.winiarski@intel.com>
 <20251021230328.GA21554@ziepe.ca>
 <aPgT1u1YO3C3YozC@lstrano-desk.jf.intel.com>
 <20251021233811.GB21554@ziepe.ca>
 <aPgwJ8DHhqCfAdpk@lstrano-desk.jf.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPgwJ8DHhqCfAdpk@lstrano-desk.jf.intel.com>

On Tue, Oct 21, 2025 at 06:15:19PM -0700, Matthew Brost wrote:

> Ok, I think I see what you're getting at. The idea is to call
> dev_set_drvdata on the Xe side, then use pci_iov_get_pf_drvdata on the
> VFIO side to retrieve that data. This allows passing whatever Xe sets
> via dev_set_drvdata between the module interfaces, while only
> forward-declaring the interface struct in the shared header.

Yes. The other email looks good:

  struct xe_device *xe_sriov_vfio_get_xe_device(struct pci_dev *pdev);

Should call pci_iov_get_pf_drvdata() internally.

And 'struct xe_device' can be a forward declared type that cannot be
dereferenced by VFIO to enforce some code modularity.

Using strong types is obviously better than passing around pci_dev and
hoping for the best :)

Jason

