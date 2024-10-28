Return-Path: <kvm+bounces-29819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02E719B26A7
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 07:41:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BF7E1C21427
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 06:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A556118E779;
	Mon, 28 Oct 2024 06:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kG3/Gsv5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06B018E36D
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 06:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097688; cv=none; b=S4+i6AF2zqYog7uVgp7CnaoYyBRz7bMWFjAzmyTeFBr1Ltm8vYPT4GB7YMoOBdadDjnY0bsc720Ii4PEwln74DZF5b6vHZSUjzJQ3fj6WJAnyMaicNOFQQUhlSaSTkH2Q6Y0aeODV3qWzdolLweqzdfwsEhJI3ER2w9p1OoB+Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097688; c=relaxed/simple;
	bh=NS+Tuf100NVa1bY+369mrzPv7GRrI/vVftNytsJXNYU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U+iuht5foqx+J/Ukaw5fePCBQQfWpGkmuWT8iufLVgtWvhPRPGabMXMy0+VgSX9pKFzLOHOAk4Qjqd15jxJrdBB8JLVcbziqpEYBEEi18NF+jKuhZL7uhupCsPZ9f9t6rECm+zzJquYLx4sVfWnsABNwU3L3Tne9LsVb6XDamDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kG3/Gsv5; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-539ebb5a20aso3875444e87.2
        for <kvm@vger.kernel.org>; Sun, 27 Oct 2024 23:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730097684; x=1730702484; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NS+Tuf100NVa1bY+369mrzPv7GRrI/vVftNytsJXNYU=;
        b=kG3/Gsv5K4JJHq8dpeTQ/s4O5B5HoKB8WD52ygd4YkwV3iniipVxHtWN5npoBdtOdy
         yX6ZLUagY8ZBZXc6QcXGVDLP0518bU/fHNDoiQQ2hWzq2nSOA4/LxrXpGZDa1zNSxp2g
         +Ja6x3uFSpeWCO63hKUmKQ1dbRW9OS3QXqFfGTFqNpuii/rmw8bT16oDl4U/EI9ptuXZ
         7u3Iu2w17Zv+e0VjPhKzAp7WLXNOutU+ByZt0FraH2NQn6SVFL/YUp/jOBT0wqrZmBPd
         M39//XZB/Qcy5YrYVYQPDHnPzcJQ/rhaPT/5lKp3KcVQ1XEJahVdw4pkEcrofrJFy7Lo
         nAsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730097684; x=1730702484;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NS+Tuf100NVa1bY+369mrzPv7GRrI/vVftNytsJXNYU=;
        b=achyIrnPbqViaNKkAhO0O4luCxDF1c7s4IdvfUNemHyIw6u4kyRD9I9SyB49R9eGp5
         V/A9JSB0HRrMU3hXrZaPk9/xKWprJhYqdTOsA/7XlUoqiVm3Ru9BD+ehgdrfgnWkVZK/
         LmJv0N8LVLIJROw5RdqP8j+9npeu6G8a+tv1cKsPQdhKBNDufCuTLb0thJkUsoOcmJ5+
         Yr7YkUz6tuzcZbF5B7dmkhbsO6deOPhtnaX9EI9dSdYuBYTu1jp/IyQJUIMlbrwikXtw
         10lX/7NHiMWww+iWamadeGQRbmpBdjsov8clZgVBKnkD9xiC2lrUi8Oyiflb3Opb9uY8
         jloA==
X-Forwarded-Encrypted: i=1; AJvYcCVECmIOJ0oU6TBwk97X8uxZfEAtGWCaAn5jybIKnTwlsrla0joyAEY+Ggppw/P52FBjaTc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxkq3ARssf5ucJybm0yt4RmpndB7sHl9uCjUHfHQvt9gHk3Pht2
	7Fuorjc31fvATK5cuuOMOnRuME1rbGTbeuISjYKTXcyKiFWGZQ9aqzlqW/wEG+uBOnBFLJROjjs
	UVpXTWHPU9Km6viQ20QXw/bFUGBjQ0w+cAwRGyQ==
X-Google-Smtp-Source: AGHT+IFgFEA9LsVMQUWWo/dM/XVqyt5Trns048cVWzUxR/mKJTkgDk+3ErfamKRGebF05Z9nNEe+Ai1eCzQr3FLp3x4=
X-Received: by 2002:a05:6512:3d93:b0:539:8bc6:694a with SMTP id
 2adb3069b0e04-53b3491e22cmr2604980e87.43.1730097684106; Sun, 27 Oct 2024
 23:41:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912131729.14951-1-yi.l.liu@intel.com> <20240912131729.14951-5-yi.l.liu@intel.com>
In-Reply-To: <20240912131729.14951-5-yi.l.liu@intel.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Mon, 28 Oct 2024 14:41:12 +0800
Message-ID: <CABQgh9HvJLJ9Zsa69oHiNSPaRr+NGhrbY4n-80kNWA+DA5W_ug@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] iommufd: Extend IOMMU_GET_HW_INFO to report PASID capability
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, jgg@nvidia.com, kevin.tian@intel.com, 
	baolu.lu@linux.intel.com, alex.williamson@redhat.com, eric.auger@redhat.com, 
	nicolinc@nvidia.com, kvm@vger.kernel.org, chao.p.peng@linux.intel.com, 
	iommu@lists.linux.dev, zhenzhong.duan@intel.com, 
	linux-kselftest@vger.kernel.org, vasant.hegde@amd.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Sept 2024 at 21:18, Yi Liu <yi.l.liu@intel.com> wrote:
>
> PASID usage requires PASID support in both device and IOMMU. Since the
> iommu drivers always enable the PASID capability for the device if it
> is supported, so it is reasonable to extend the IOMMU_GET_HW_INFO to
> report the PASID capability to userspace.
>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Thanks Yi

Have verified on aarch64 platform.

Tested-by: Zhangfei Gao <zhangfei.gao@linaro.org>

