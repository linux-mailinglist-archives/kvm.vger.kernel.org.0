Return-Path: <kvm+bounces-28968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A2F499FEBE
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 04:24:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 00384B23287
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 02:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3542715C139;
	Wed, 16 Oct 2024 02:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="a8Keb95B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13E614D718
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 02:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729045444; cv=none; b=eHYpuYBRiQavm8+zmgK/4tNtgKh9iNtFyZEB9xFG7onAlXNzmk8oKCiul2lOajAYviKlQxGRnJagNDZ1u0iqF4QgrHwdGCvJ6lisLhXEtbMR01fkkve7210S391OQxGKQ/sOYNzVwopbJx+xfKBiJ2OT7xBure3zKgJSqP4BOmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729045444; c=relaxed/simple;
	bh=+GF1oCaa4XIdm2rCPBWvV+uTROdOd1KyxDhkbhawAvc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OeCO0FH3KwngCS4fK8StQ9qizt400EoxiQng93gfu7mlBvxaM+N7R5BL3/ZQrB61o9992Z/11Tz564/iw3L2s8RMgX+I3CfGBFaK/p5Ur5V/I/rcl9v6m4Lo/prsY64WITJMi63NtryK81q7N+CfG75ciAtJGroVHeQEKaTYC/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=a8Keb95B; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-539e59dadebso4813989e87.0
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 19:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729045441; x=1729650241; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qiWvrpKzeq83YnQqOE7ISPaRFxYtddrp60dv+zolb9U=;
        b=a8Keb95BB4+H22P3VAxGwn4pWfLSxCEJgdY1R6qATrJ3lUJKy8dPuet6llakvjkc8m
         xBdQTDau1nLF5+AflGAXSt9syeQl517ZcP36pwmz0ERuJgVdTUgneBEoV+IN8RrDG98r
         aGVJ1oteGbLIwFepCpviquLf4C8/rD3YaGt2wgtf/ayxBQ/OejHZWnlVRbloKQ4CzVMe
         VrwKlHpjRaMBbEsSx9evxozYix492Sa4C0bdBEESjCwFxQjrd2/71SROuJVDvul7DtVT
         CYsliKRfh8v9urSYEg4jiw4SvyFV7ekWKCfdYZv9huY1JuP0lITHGBY7fYuO6Zpbo5zS
         URIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729045441; x=1729650241;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qiWvrpKzeq83YnQqOE7ISPaRFxYtddrp60dv+zolb9U=;
        b=iNnzidWpaC3Fhlv9uW3SjR1RUF/kbg9VM8494oNe7HECtwuHDvIKFtizMyZzYVZ4Ja
         wsqAYVcHsXYkiB5y81M8bYDUTzjFE6zOkk95IJCvdkbdeF2F62EoZBMjnll/4HzTklfv
         BCYz3hFewxqqL7Uwm0Il1doyWOM37WMYl4w94bA/lL31MueS/6hczBNl731GimfrN3NS
         N0UQfvsHnEG0O9LR8Nch8FIgzhZqS47KryiXHCDOxSvuHe7cvYVIC1Gtz1MYlrJe+TBF
         0vK/HEsJ59iGAPp6BbMl7rfr8mD0A7E5CC9me5rcRgr9K44qy4Q0B2AV6+F4hFfuXoGD
         xCmQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUDRPDyi8RylfiTO81pwhvhbcy4lpkt/dU5XJVe5vgTLgtHZFZ12rVFaxDThDKaozU0H8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtxceZ2cXaY0wkguoio4rI4HM172zLe16LIDi6Sikrmo/Yg59F
	8wAhPPa9+3DuJJA5uKay+BF1FympDIVFxM5rVyh5p7vQ9DdcfubZi2Chl9i4n/w1/RbiMf4haCu
	XEc/OeWeZvaKCLAdDXnWUwINJ5PI2vYan30smeA==
X-Google-Smtp-Source: AGHT+IEV/byr5lu2UsUC2RRVM2gDVA1eLiMxNLS7gT854PVdY6PhxgM/HLAZnNXx36HxSizxkKPg933nd9PyJjzpqHw=
X-Received: by 2002:a05:6512:3094:b0:539:da76:c77e with SMTP id
 2adb3069b0e04-53a03f045ecmr1718387e87.5.1729045440632; Tue, 15 Oct 2024
 19:24:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Wed, 16 Oct 2024 10:23:49 +0800
Message-ID: <CABQgh9E32c5inrn=Q5HWThuJQ4xV=EFWLGwbyxVLHQVUZ_uYCA@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>, 
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>, 
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Robert Moore <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, 
	Alex Williamson <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, 
	Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi, Jason

On Tue, 27 Aug 2024 at 23:51, Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> This brings support for the IOMMFD ioctls:
>
>  - IOMMU_GET_HW_INFO
>  - IOMMU_HWPT_ALLOC_NEST_PARENT
>  - IOMMU_DOMAIN_NESTED
>  - ops->enforce_cache_coherency()
>
> This is quite straightforward as the nested STE can just be built in the
> special NESTED domain op and fed through the generic update machinery.
>
> The design allows the user provided STE fragment to control several
> aspects of the translation, including putting the STE into a "virtual
> bypass" or a aborting state. This duplicates functionality available by
> other means, but it allows trivially preserving the VMID in the STE as we
> eventually move towards the VIOMMU owning the VMID.
>
> Nesting support requires the system to either support S2FWB or the
> stronger CANWBS ACPI flag. This is to ensure the VM cannot bypass the
> cache and view incoherent data, currently VFIO lacks any cache flushing
> that would make this safe.

What if the system does not support S2FWB or CANWBS, any workaround to
passthrough?
Currently I am testing nesting by ignoring this check.

Thanks

