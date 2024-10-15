Return-Path: <kvm+bounces-28835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F265399DCB0
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 05:22:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7C711F238B1
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 03:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 825FF16EB7C;
	Tue, 15 Oct 2024 03:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C4qhQKCO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2094516A92C
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 03:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728962529; cv=none; b=mhBYc0BH+YHVOVlMrQ674pz+W7tAIZDy01Vyc/mqUY6ESxUrU0Y1A7abqwo+wTOwTsAXP3OZIofRmjLI5v0Xj8vfc1NUt1ymYftuAEZu74ZFLiSLp5t5G0bJ2SzMeUXmOYMmYCqGvFgZ5agSbLhkUO3m8WCoIIhC21g05mtAxW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728962529; c=relaxed/simple;
	bh=DjLX5fBkgJU8CT8xqfpFI/dbFLVg02xVhUhJ9U952wA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dhc0w3coXqNrkV73bZc5wex+fuoaQj4dOzVs7+hoUoJyOzPbN+EtI5Ad8sg3hljzHSryWwFclOfyJhISziDtVfmU0xByyQO/4xofPVdxcLzBjttgPs9UcbC7gT+znhL5VSu5rA9lUzrXL5ZCw0ToTeQ5T5bnnxu59exgvrbJFes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=C4qhQKCO; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-539f72c8fc1so1680234e87.1
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 20:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728962526; x=1729567326; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Jgc3X3B5k3iTM1+4K9yayTFXC9bD3mynK1laekJ4N5Y=;
        b=C4qhQKCOdgVXvuod1YVGZKNB8iHYFxt96g7BOZNAlu9ldstoT25kT+a9iXvhX1MmEA
         G7U34PRIPL5uYror8Hhz7XslumxaVLaCYxFDKg1W4rBZjVPUfOQxfgjyiWzqTg5zneLW
         zEfU8AKqZNc2vHysSa1flNR0ghK8aIrK7o7/6CU8FQ68LEUAUEScDJR34Q3FESzBmGLj
         GBXVBsU1GvhJ8DxlLBrwz+IxGE++bkatfRyskvsBxZriLMIJdf4WitAsr6w0LwyAkECL
         HtV7gTotqlF3t6CkmBHmshZwoTUjOggBsPWbavY+skPeRnyab7eD+exJWVDsB+R/ETqh
         mp0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728962526; x=1729567326;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jgc3X3B5k3iTM1+4K9yayTFXC9bD3mynK1laekJ4N5Y=;
        b=Af3dW6m7o5PIxA0AQu1iQO3prXmvkmgFDqa1PxkUJfp2+8mFNoXiW5CCcqmbCLddWZ
         lEK40/SLfQJ646eNBPhb7cDGkdlto3z6SWyFL8EZwQKEtfYILCx++sf97HLxmNswIi4M
         e9vkjYnJAuFpf9530jyCAyIHOb+i9okR2BdsIZrXMdZWSdL8VpC32cjF9VavUl0mGB6L
         xKpWP+3hGPgl9ZqzhmIHWnw3uiQdUN95uXghlKS+0rPOy/g3m+O3YbYePRNOUxrz1pjT
         tVpHpn/W+U13tBFWf7QQRZntm7VAwb582IAOQWPwJqwIMf3o5BjZpTwYdFKoGLIA2q91
         cAMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUH8VPnLHhA92r1OCtLT7cH8z6UdmIVYmLWkeRqQa5cJ7CqTkW2aTZ9alic4uglT72DM9k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcZnTmIZomBGSY2E7KIyAI2MH7BEvYAmVCtyhn9LIkpH9fr6qo
	ZFxFy7+OzpHmLqqrB1PF6YqaQTHWgdowMBLeetlce7GgalPu+mTYY+a9yRVCBbZHYM1T+Ez1Hv1
	20L1PNF7AqHO+LHjbeYI0kc75dvvm7T0pF1mWiw==
X-Google-Smtp-Source: AGHT+IF5KKFkOMyYhkCoT9zofFw4RA3mLNEAwadNBcjduiYPc6MyoAx/qz66sum4SmIdy3qH5oAV2Lmd2pGB9QF/oXw=
X-Received: by 2002:a05:6512:2581:b0:539:e1ea:c298 with SMTP id
 2adb3069b0e04-539e1eac668mr5428955e87.22.1728962526175; Mon, 14 Oct 2024
 20:22:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs5Fom+JFZimFpeS@Asurada-Nvidia> <CABQgh9HChfeD-H-ghntqBxA3xHrySShy+3xJCNzHB74FuncFNw@mail.gmail.com>
 <ee50c648-3fb5-4cb4-bc59-2283489be10e@linux.intel.com>
In-Reply-To: <ee50c648-3fb5-4cb4-bc59-2283489be10e@linux.intel.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Tue, 15 Oct 2024 11:21:54 +0800
Message-ID: <CABQgh9ESU51ReMa1JXRanPr4AugKM6gJDGDPz9=2TfQ3BaAUyw@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, acpica-devel@lists.linux.dev, 
	Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev, 
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Robert Moore <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, 
	Alex Williamson <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, 
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Sept 2024 at 12:29, Baolu Lu <baolu.lu@linux.intel.com> wrote:

> > Have you tested the user page fault?
> >
> > I got an issue, when a user page fault happens,
> >   group->attach_handle = iommu_attach_handle_get(pasid)
> > return NULL.
> >
> > A bit confused here, only find IOMMU_NO_PASID is used when attaching
> >
> >   __fault_domain_replace_dev
> > ret = iommu_replace_group_handle(idev->igroup->group, hwpt->domain,
> > &handle->handle);
> > curr = xa_store(&group->pasid_array, IOMMU_NO_PASID, handle, GFP_KERNEL);
> >
> > not find where the code attach user pasid with the attach_handle.
>
> Have you set iommu_ops::user_pasid_table for SMMUv3 driver?

Thanks Baolu

Can we send a patch to make it as default?

+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3570,6 +3570,7 @@ static struct iommu_ops arm_smmu_ops = {
        .viommu_alloc           = arm_vsmmu_alloc,
        .pgsize_bitmap          = -1UL, /* Restricted during device attach */
        .owner                  = THIS_MODULE,
+       .user_pasid_table       = 1,


Thanks

