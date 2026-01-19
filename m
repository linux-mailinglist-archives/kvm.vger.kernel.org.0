Return-Path: <kvm+bounces-68528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A1A50D3B32A
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 18:04:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6057E300FEDA
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 17:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD4FB2BF001;
	Mon, 19 Jan 2026 17:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="njIjwbMY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D255217F2E
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 17:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768842216; cv=none; b=qZlMxW0TArT1ZLl2wbKglAB+6n97uEWL35wnHP8pzmqXrGPNDpmge6RId5JzNxJMCHvzX87WhBV3XdgGuY1OLyHHNvpdESN4B6nqN93c51TwW+hAKYf8xvAf4JZ2XZ8HqHhQcDt55NrRemCSi6mOwSOgxurH6v/DbioIH/QX3vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768842216; c=relaxed/simple;
	bh=rf6zLo4HMSx3jjTOpNOmyUHF2Og5rRAkebiZTxcDcUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EHC8cEyOj1S8hwziAEQGFwd6cUSpR+O69kScrBBp3++5QTXrIitgFPigHYdBT9hsNoRXBz2OjnVhTInLM3lL3mPxBsEHIAtjMdk+C3oNLdANoljqc4bb45fEaa77FDex5VT9ttW7EwgHiDnQFhWdwtoofe3RIF/SAaB+RoL7HPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=njIjwbMY; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-93f5905e60eso2568457241.0
        for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 09:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768842214; x=1769447014; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xPF37M4OZRPT3BtJHYXM5EEOm0b3fHdtNnzMGWb7xcQ=;
        b=njIjwbMYYxpN/nZjTfqw0ZlvGqNzdiD7cVaRqtfNiIwzowDBE111KsGg/eJ979Nj1E
         cBb6K0t6GSbh/cKrI78GNEE+cil+xIFTz6Bogo42/gfzuuiNyCHyIcCmrjadpmPZAWIm
         kwDUJwv5qC0xfLWc6zjCmoumBSj/GAsFWJkJ3nFyyPXbmM7lRx8U1iLnxC1vOn5pBruQ
         5o4ghFmRoZHj9vmtufocfIY6JuWdIKBlDW8L/DdizF/Jtand/HzZprHoECeqnzmfxd+Q
         zP0eMBCvnqeeSZZcx2prjHK3OoqUDn4pDSL4rj1kPkbUcteYON83SDaBxaqLpwWkzxUD
         Qqig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768842214; x=1769447014;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xPF37M4OZRPT3BtJHYXM5EEOm0b3fHdtNnzMGWb7xcQ=;
        b=tgFe0b40LxU6IKuta0NbNhsSCNIH6uSZ5DdRZhU6e+zHT9Ug14Jf7s1eK+6ncE0JHq
         XNRYQXRzMG9ukfquECvYD62nKz0DsajPDrrrx9YG6ciszGBQsL5Ihp1UvlroGeVZSYWG
         Zl9PvRLFzSRQMuU7MO2cX2xHGUcOkSRCOLQeEW5Pi1CIfISkOUa2vLZCf7aLAqiKbMvI
         e4nVKJuzPLQxZeziscZHIRtswI573O+vFnzx0iMv2vIkNP10Ct0ZYEd5XdGwSYrTTSlj
         XZwwvNZikxCH2+35tLrikHqbxctFdvBG4ExlMOdJv6PihtuIHBgroj/0d2y5KbypdiCx
         +fXA==
X-Forwarded-Encrypted: i=1; AJvYcCULmLynGw7J7siWTQ2LqYStZWhCTdmJZ0W40sNgFwNoTSGTf13kW4xwDw4GcnCk/e9Up+Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/u+yST8pTA0+0vq15gOtupGaxpVJCyfkOOvjMmWYl9JzInvc3
	WpnHMgp4+jFu9Jx1BsM7mJV2Plm+565oh6s90O82qblXxuFdJwiYeZJ80uVIVP/oggM=
X-Gm-Gg: AY/fxX50typzcinHEqLtwpuqm6ZqLFVxL4+Z6iuFP4sFTwezoM6MZxw3B08wueExZBr
	A0aGqegtBtQxKvaoWj2vJ5B9eSScq6mm4M/htHq/LuSss9GtrefG6lVM+LUP6JENc2r1nDmIygY
	G/zuN2WJu1SZResfyZH/OjDfpcYYxwCTb+KRSKk0qEc+Q8MueH7tFuLfNgo7O2C54DY6kQtHOwd
	fp9nywhgSiLNxkMqdTkoRJtpUGyiKucqvNpeJLxrJsll8lufiHiaJyT3x+3LMr9596dqdCr6LBi
	I2la7KkrT6jAjl46mrDt/y0el6sEp3hgrJdlq+seqtw1Ppyk0/bhHqSwG70LEv+AzBgt5oD4rG1
	aUcy93AI4CMK1pa3tjEJptOFLK2j1W60NoloJvSJ4F2iUeyMeiiwcQlqq3nUBUIERCnR0FEhMaj
	6fl+N+3bNbRx+hh6nYVW+mbMEbPKqJyiFejGguFg/cj4MdJuq3pwnu7s1ts8GU0/qHd9M=
X-Received: by 2002:a05:6102:2ac9:b0:5db:d07c:218f with SMTP id ada2fe7eead31-5f1a55dacc2mr3505780137.40.1768842212920;
        Mon, 19 Jan 2026 09:03:32 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e6027c9sm90833946d6.13.2026.01.19.09.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 09:03:32 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vhsf5-00000005ITl-3vB3;
	Mon, 19 Jan 2026 13:03:31 -0400
Date: Mon, 19 Jan 2026 13:03:31 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
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
	Alex Williamson <alex@shazbot.org>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	virtualization@lists.linux.dev, intel-xe@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/4] vfio: Add pinned interface to perform revoke
 semantics
Message-ID: <20260119170331.GJ961572@ziepe.ca>
References: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>
 <20260118-dmabuf-revoke-v2-4-a03bb27c0875@nvidia.com>
 <bd37adf0-afd0-49c4-b608-7f9aa5994f7b@amd.com>
 <20260119130244.GN13201@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119130244.GN13201@unreal>

On Mon, Jan 19, 2026 at 03:02:44PM +0200, Leon Romanovsky wrote:

> We (VFIO and IOMMUFD) followed the same pattern used in  
> amdgpu_bo_move_notify(), which also does not wait.

You have to be really careful copying anything from the GPU drivers as
they have these waits hidden and batched in other parts of their
operations..

Jason

