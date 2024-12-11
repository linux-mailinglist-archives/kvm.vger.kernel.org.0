Return-Path: <kvm+bounces-33471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C27BA9EC26B
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 03:43:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AA78281520
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 02:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66DAC1FCD0B;
	Wed, 11 Dec 2024 02:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="m2b95qcO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617CE1FC7FC
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 02:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733885031; cv=none; b=oNR7uSnT+nBAViHM1KEZfsLMOQbFBAI5AhmXIGEE7NGjeZw4KsSJ32qeVJ5qXZANgHaD77sZq18xLEoBAStLozoIg65CGPn8789wVwUOAt+D2hjq0CTqLs3LGRTr9a/X5XLnCuPCyVgXQTuH2goGphUwValhmb+MD4AiTtOsfJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733885031; c=relaxed/simple;
	bh=GHgSmtR9vTzTjcJ4EaBcwK+ynctZcjBW+h/7n4rakHM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HzcjFVsvq/Goe+2VnR05JcYQx8wsQ1zkV/MySkr4ekN45JyG5dEbrDVzVGSW/y70MMiF5z1c09+9tTEgbeztCEDpADQoPCknpk7rHrpoLnbonBeWvzgRiqUoBJJYIV6TdwPAYd86gga5oW4YfdxZWw3NJJPKrTI3l0kJiQwTvLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=m2b95qcO; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-53e389d8dc7so4476714e87.0
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 18:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733885027; x=1734489827; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GHgSmtR9vTzTjcJ4EaBcwK+ynctZcjBW+h/7n4rakHM=;
        b=m2b95qcOZ6GyePqandtj1wcTKfkDbA/fGY5TVpNVqeJJd7lSuMhCyyeAz+XrV+yE8L
         eADz4QInfkRZGN/NCQndXBmiri4FBt6r0+BeqxD0MxqsYD42+2WmN33VD0dzeQRjdQkr
         0dxc9XTVZb1WF0IFt9Dm12XTLSwdrEOXhWEoGXc2e1e7EmQSkFh1ERnm+ARiZIFuksWz
         0QZJBQYv9sMoq6jKUCUkWf+di522GaeqhzSUqCFSzc6vUBPxq/mcKYDyMoYLvNYkEWQS
         rSfqe0tuTQ2rlx1bfBouQHTEpJNrwAqrXmFEXcZQZSTeoL6ZKx9JL04Klw+Lzax8hTkL
         Qs/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733885027; x=1734489827;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GHgSmtR9vTzTjcJ4EaBcwK+ynctZcjBW+h/7n4rakHM=;
        b=tZl1NPWOeycwkksAJbztdXZSO8lushPekMPZTnl2wdhkPT6Nck5qMVNdmbgeA/7kOe
         DEFJ+2zopeK4Yaeq0dGgV2Dkgfkr7USEuKVXt7kZU/RWsmF9YIvWnqvDJIt36PvYXVUB
         PsXsDWZv5yGAS7Hz2GB9KuBokguqxFEfJvA13/cEeXe4PnvEjdBK8eYflhhPqLuuDYFq
         WLP9oAU5Sa1aV46xVl/FAdfDyfiAJy/E1Ly1icWjLuLsrFRHFOqoRC1jnZcVIOXuWbJ0
         Ah4v4TwIPf4YRG0YdGoZN2wU9Tx2Sn+Ez7lJdkWMst+y4ku/oBvnkq9wy13sO0OJQAkx
         7qvg==
X-Forwarded-Encrypted: i=1; AJvYcCW8iwyXcA3HqA8oyEXzg7LLO4QWTf/WszamvHmbopMNbRWalQSfUHCM/6G+BYTN/9TrZwU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzveT8L/XgpwbOr02p+NZmrdM1f66LY5UCyov9Rs6ui2fdvweKL
	0J2qGAp7hrfP0qUTi/kM+x7ECKzRuHBIR7AkbsqiakOQM4iv9E1Ai18wE2ThfxCZUZTDA9FyhWc
	uBjD8CVGvzZvt+nNPaj+DT1ZSIU4CY/vJP31sjw==
X-Gm-Gg: ASbGnctEFxUejXbvFsbBvQwfOpBE4mJs40C15piGxULsqJn7/8mhEQ3hnDxSe3Ole7z
	tYACGKbv8OFe71vHGfSfOP3NPYeX9HdSuDQ==
X-Google-Smtp-Source: AGHT+IHS5KkQGk8APo1eXi8Rt0VOlOnXgP9QSvrLJC3hb+d5Eq1x/2VIMDfLSd1xVwCVFBb915rne/FHPXP95gCc0hQ=
X-Received: by 2002:a05:6512:68b:b0:53e:3a7d:a1df with SMTP id
 2adb3069b0e04-5402a5fcc85mr299823e87.45.1733885027031; Tue, 10 Dec 2024
 18:43:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241108121742.18889-1-yi.l.liu@intel.com> <20241108121742.18889-6-yi.l.liu@intel.com>
In-Reply-To: <20241108121742.18889-6-yi.l.liu@intel.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Wed, 11 Dec 2024 10:43:35 +0800
Message-ID: <CABQgh9GgWVZ6onc7Tu5ARJ_bPrm1GB-5EaQuh4OCu+ywC1Ez_g@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] iommufd: Extend IOMMU_GET_HW_INFO to report PASID capability
To: Yi Liu <yi.l.liu@intel.com>
Cc: alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com, 
	baolu.lu@linux.intel.com, joro@8bytes.org, eric.auger@redhat.com, 
	nicolinc@nvidia.com, kvm@vger.kernel.org, chao.p.peng@linux.intel.com, 
	iommu@lists.linux.dev, zhenzhong.duan@intel.com, vasant.hegde@amd.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 8 Nov 2024 at 20:17, Yi Liu <yi.l.liu@intel.com> wrote:
>
> PASID usage requires PASID support in both device and IOMMU. Since the
> iommu drivers always enable the PASID capability for the device if it
> is supported, so it is reasonable to extend the IOMMU_GET_HW_INFO to
> report the PASID capability to userspace.
>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Zhangfei Gao <zhangfei.gao@linaro.org> #aarch64 platform
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Hi, Yi

Found this patch still not gets merged in 6.13-rc1
Any plan to respin.

Will this target to 6.14?

Thanks

