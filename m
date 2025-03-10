Return-Path: <kvm+bounces-40652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F29E0A59696
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 14:43:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BC74188B1CE
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D084922A4F2;
	Mon, 10 Mar 2025 13:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="chkQAjJ2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC2922154C
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 13:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741614230; cv=none; b=Buf91Tn80W9NAzCNgMlKHxp/2keiY1FtXBc/Nhipzp+kvS71xjYqiRZfqut4N2ZqZbaRVmkfrQdlpr2fayhZkMzLrWRchVSZ5CbDWBrjmlID9w+1JAHVrQIKNLR1BOBEwNMXoX4s4vdY3x0y84yrEXLRGRh3rG4VXCJMYvxdd7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741614230; c=relaxed/simple;
	bh=IYwsy7PNm1m4/LtI8SYyDfFGu19jl0HWjv33WIfeH4s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jfz5PLaHri7ZK0SfeGWepGWWO0RImF0UqRyx80uKGg29VB3nSXsN/mab3IWJUVPk7CqPCyUcnOKjumZ7+wMPO578NDOgYHos4dOT5AevIviJp2H6OaKG/wnKT8Yb8Z45oyPN/L/RXOxASpSO8CJEi6SZZNe3vxHL9sxRVm5Dxrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=chkQAjJ2; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-390effd3e85so3737024f8f.0
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 06:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741614226; x=1742219026; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MNR7wcPrwyvdBBuSvZmLG0ZR7REyKuHiEVhgbsBRi+w=;
        b=chkQAjJ2yqzr6KnyTIG75hmmJbSCnJRLZzZipVsXl1PPjv0m36qbNtOUV/vDWRkejZ
         5HnFzHCbxwrmGndRuuec+B47adaj07vS7QyAVrYYBioQ1aaf9ACDLmMXn9euRdexKxdg
         JbE3FKq1jPSalBhFJnAkY7z+NaFXzVzjaUTkJVbVecwRywTV/HwPRAioAIdxrJ+m/UY0
         Mh79q22IvLXR+OELPkwz6N/JToccukgxoIy1+q7CRzlCrmICnEkl9wj+/70LEPw+tfWj
         4VSDhHVnGFqLhtPcjAZf6M0te++nRV2N/mVEFB6jBkbsS4hJL9d+7sbzGquZcdZMmPVQ
         YmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741614226; x=1742219026;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MNR7wcPrwyvdBBuSvZmLG0ZR7REyKuHiEVhgbsBRi+w=;
        b=ivo9Y5E0mffPguvD4lI70Qw14vg9ewt9JKcweRKT9CtV1qhHrf1KvpFOBU19b3AmO4
         CqXTneMcj5LlOishH0KhwCzwSkV0ySSsKYKn4rA0toyJHLsiUK+nUf1yll/svtw9noiB
         zK+Lr2rDu/BUyGCWgN3ZSCMxysUNqhh6LzGkgQlayzRh+4e7RLbgUzCGA0M/WCvhNAQ/
         L9GrnvX1JpMLkcdJMaSynW0lToQoIrAGiPiwsls0JG3N7oWUrNHzacMkkFlHYg6/u3YA
         3GXHIW4YESVJ5n+wyos1T+9RLNwpTBinagop/QKbrSWbcvNfLodqJJ5JBEwIjEDjIflq
         DepQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7a41AzeBI9N5k7qBnraHcjpKjO6R5hldSkHqPV6+OSpGc6KYnDO0LwJDt0XiOMqmWgXA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy6i6m9IFdGfK9QIBssNGxwtJteNPJFK1YgEYNYVHLmCn+DOWB
	zU/xopmTUzUOGKhcyULyVCWdFwMDov9+C3Lg7bQklWyEFLEkOe3H5G7VaoWkRtA=
X-Gm-Gg: ASbGncuL8C01At9kLHUZPuKs6maYHNYuYmd7HQP+fOyzp/+hRU2yt2p39FIUjke8oua
	QjruOWTN819abBUhyKCpTPfd29iOXUqDSo3IQayacKPcxspaDoI7jpPUm8BaItgxm+qF2/kJEHG
	lmExJHhfYqu922T0NV8UdaIaHqTLBB0s3lKWSWoGI0WoYWIvvyFyGpw77JUC8KvBG+Qf4MIIlVe
	NhApI/0MAKviAftla0YhNyWmC37h04HkhqcVHu8k1zocgYfMtcfi64sWr7vxzECjPuFryfHcDvi
	sjoHS8T48g7ydUTR6iXIzlz2+qS4u/09smZmGbh3ZTyXVOs4GaultOQTuriPWGhy6NDmjBlrzSa
	bOXwsRYE/flhzMAAGfhUTGd8=
X-Google-Smtp-Source: AGHT+IETxtWh9+nGuL2rdW3CBll9hDxY+TIi4rYLu6DazLOckmHQ14u6JozsOGGS/8bBsZmzIesPCA==
X-Received: by 2002:adf:a3cd:0:b0:391:46a6:f0db with SMTP id ffacd0b85a97d-39146a6f2ddmr2433098f8f.37.1741614226389;
        Mon, 10 Mar 2025 06:43:46 -0700 (PDT)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c0e2f10sm15089474f8f.65.2025.03.10.06.43.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 06:43:45 -0700 (PDT)
Message-ID: <7fc9e684-d677-4ae6-addb-9983f74166b3@linaro.org>
Date: Mon, 10 Mar 2025 14:43:44 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/21] hw/vfio/igd: Check CONFIG_VFIO_IGD at runtime
 using vfio_igd_builtin()
To: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>, qemu-devel@nongnu.org
Cc: Yi Liu <yi.l.liu@intel.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Halil Pasic <pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Tomita Moeko
 <tomitamoeko@gmail.com>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Eric Farman <farman@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>,
 Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
 Zhenzhong Duan <zhenzhong.duan@intel.com>, qemu-s390x@nongnu.org,
 Eric Auger <eric.auger@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
 <20250308230917.18907-13-philmd@linaro.org>
 <415339c1-8f83-4059-949e-63ef0c28b4b9@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <415339c1-8f83-4059-949e-63ef0c28b4b9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/3/25 08:37, Cédric Le Goater wrote:
> On 3/9/25 00:09, Philippe Mathieu-Daudé wrote:
>> Convert the compile time check on the CONFIG_VFIO_IGD definition
>> by a runtime one by calling vfio_igd_builtin(), which check
>> whether VFIO_IGD is built in a qemu-system binary.
>>
>> Add stubs to avoid when VFIO_IGD is not built in:
> 
> I thought we were trying to avoid stubs in QEMU build. Did that change ?

Hmm so you want remove the VFIO_IGD Kconfig symbol and have it always
builtin with VFIO. It might make sense for quirks, since vfio_realize()
already checks for the VFIO_FEATURE_ENABLE_IGD_OPREGION feature.

I'll see if there aren't other implications I missed.

Thanks,

Phil.

