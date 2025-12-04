Return-Path: <kvm+bounces-65254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D2E04CA21C6
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 02:33:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CAED7302A3B0
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 01:33:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 998B7243951;
	Thu,  4 Dec 2025 01:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nrfLeL/c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685F0A945
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 01:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764812012; cv=none; b=fOcJo6Jzt6vh1MYiXSUJMspXiSljS6KtE+tfBsGYsTWQ+LvD984Q8IZJJxw59JyEnxEsgDMe2hG2UC8MTh+GwdDGkFUKoW+m/tsNShp3A/s8Cz/s43zU98gm0bWkAdwWcqUOePAWXO+eaFxQHahtJyWiE89QQ3NFQAsbsTtVeZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764812012; c=relaxed/simple;
	bh=xQEchCyS/SDzra4Ea9JG9KXn1RKa+px7wYeOBNUrWJA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=feKMDNgrn38CCOHtMHj27BEJeTI6CUWX+eyjrVe/DocQg+AwtbDVfhFhWnB4p0x+2sgAg8CAppjnfNEQaLDyvTHErV/MT3O2YvbpkTqJZX3QSr0x+eM+wOQxWfcki9it3cLgGnVubRqXp4345H9mpPQ6ICqO3wmEyeApmyGR/Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nrfLeL/c; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-29555415c5fso5167925ad.1
        for <kvm@vger.kernel.org>; Wed, 03 Dec 2025 17:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764812011; x=1765416811; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1OLjEC1FU02v8o2+aL765z3ax4u9Wn8i4cyPIqv2NWg=;
        b=nrfLeL/c5wd6vYAIBlU6lisqNesZ540v0bB2z1KeCVkIxGmUMJ9TpGlNFRfroGO6rJ
         0Fdka5I4+upGA+rQ5sChFYZPTEYghHO+FfIUrAL4NvkB5NuaAKz13pND6Kbl7Y8joLpF
         fSKIpaXr5Jkx6ehB3t+F8qY8tRVRm1lZ2ADCrTujFBd9YZJyFo3tv4QfEZ+DEUmZy6a7
         deBFyQR0UySwbz04yuncepGpMcQGNk8HEBLuRADAE040zGUJmixIyZv0sKEP/QsQ5WAO
         ZAUEJzlt05SWYAzkfhAlG43Wvab9b+euDue30ccbE4EUnEfxEHc3iQ82yO1pFFgRnxDT
         Xiuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764812011; x=1765416811;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1OLjEC1FU02v8o2+aL765z3ax4u9Wn8i4cyPIqv2NWg=;
        b=eqAyZT2uWedpHMdJ9XTfGZhIbp+on8PE88UaU/4Hq6DAzKUMVuDiawheEgYEdEhX4k
         jUrll/q9yoLq0BE885EqY9rgyR9c47dF9+0U/Vcp4iktlvjh72TmFCc5FTut0tqmH/0a
         zrI5y9Beu1IlxMMxx3L3DEH7X0GDlCGW2a+kM6TUilsPIsGWfVlcCjHecgIEuXuglWOc
         TKG2i4kuFa4reL6Z1WBKCgOMqnNTmQT/TMBDZ4L2CM2MlFpZn009PS8dR/VUC1AzZmti
         1G7dVYgBRjSWh+HOeelEtAknwDff85w+L2or4xV0rpkvCwtV+TAQJVtUhlDosfhrwQcd
         DPng==
X-Forwarded-Encrypted: i=1; AJvYcCXjM9vOgNIFX1GZHB7DAQveLYqbuZf5u9PrWZeu/Aqcpd+5SrdixpsgFMvNf0sd9PP5kIo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzD3GDnwdF03tzPyojJgbcILjd4hzLwsT4clOrjRkTKbFwWT+lB
	atLwoYtb7H1UfDL54utKqHxIhJrhxDichlwC5wRKx3S8z+4613PdNOex
X-Gm-Gg: ASbGncugzXbnznv9laYhuhgtIn1SlhWyHu7Hljm7aN8a8xZ01kCX1EAB6DbSmaRlvEb
	E/tTjVTPtlNUFcG3rPomY+RtLS2xtDS0AdbRGBQOucfoXoTpqu6hSbSBi8BqZnZ49TL14UwPoNf
	ekF5sDNANk3KITW78mJ1izZc6LLpA0E8JDwxFQ8H8QXqx3eCAuLssZKCHU8qlYCoLnFd0n3eF5I
	Z8nJ6SRto/mWaW1oOhJZjb93eOymTPt1aDi5u1uj9R1vNq5ERpXmAJ2X+pl7Apr+l+BJrP97yjC
	G30/RlUZHoBS9UlM6AGbnqbID7JWYkbv8X0ACSiw+9mM6ajeOv1ivYl1x8e8/GnK+c6kUePO5Wn
	bfPnsBAaVsG19ayaY222oMRF7dno3ukj5kopjhhX0xu83OkGOn2gpihcwx15vgdxvFAR9PGXiwQ
	5gA5kdabjLeWfo0luSpvvpl5ks3I26xD9i76QBt8xaHnNAhA==
X-Google-Smtp-Source: AGHT+IE8Rvg94sCmcdZ3rOlKWQaPxgdUe5bYjXp+akgFFnSeqWM9ehkwCxofj9csZW166RntHbw50g==
X-Received: by 2002:a17:903:19e4:b0:295:8c80:fb94 with SMTP id d9443c01a7336-29d683e1cacmr50148045ad.59.1764812010639;
        Wed, 03 Dec 2025 17:33:30 -0800 (PST)
Received: from ?IPV6:2601:1c0:5102:8330:1273:9a5a:e6fa:1903? ([2601:1c0:5102:8330:1273:9a5a:e6fa:1903])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29dae4cf98bsm1860585ad.36.2025.12.03.17.33.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 17:33:30 -0800 (PST)
Message-ID: <d37d6ca4-9b95-44ab-9147-5c0dff4bedc9@gmail.com>
Date: Wed, 3 Dec 2025 17:33:26 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/4] vfio/xe: Add device specific vfio_pci driver
 variant for Intel graphics
To: =?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>,
 Alex Williamson <alex@shazbot.org>,
 Lucas De Marchi <lucas.demarchi@intel.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Yishai Hadas <yishaih@nvidia.com>, Kevin Tian <kevin.tian@intel.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>, intel-xe@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Matthew Brost <matthew.brost@intel.com>,
 Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: dri-devel@lists.freedesktop.org, Jani Nikula
 <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Lukasz Laguna <lukasz.laguna@intel.com>,
 Christoph Hellwig <hch@infradead.org>
References: <20251127093934.1462188-1-michal.winiarski@intel.com>
 <20251127093934.1462188-5-michal.winiarski@intel.com>
Content-Language: en-US
From: Angela <angelagbtt1@gmail.com>
In-Reply-To: <20251127093934.1462188-5-michal.winiarski@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/27/25 01:39, Michał Winiarski wrote:
[snip]
> +static void xe_vfio_pci_reset_done(struct pci_dev *pdev)
> +{
> +	struct xe_vfio_pci_core_device *xe_vdev = pci_get_drvdata(pdev);
> +	int ret;
> +
> +	if (!pdev->is_virtfn)
> +		return;
> +
> +	/*
> +	 * VF FLR requires additional processing done by PF driver.
> +	 * The processing is done after FLR is already finished from PCIe
> +	 * perspective.
> +	 * In order to avoid a scenario where VF is used while PF processing
> +	 * is still in progress, additional synchronization point is needed.
> +	 */
> +	ret = xe_sriov_vfio_wait_flr_done(xe_vdev->xe, xe_vdev->vfid);
> +	if (ret)
> +		dev_err(&pdev->dev, "Failed to wait for FLR: %d\n", ret);
> +
> +	if (!xe_vdev->vfid)
> +		return;
> +
> +	/*
> +	 * As the higher VFIO layers are holding locks across reset and using
> +	 * those same locks with the mm_lock we need to prevent ABBA deadlock
> +	 * with the state_mutex and mm_lock.
> +	 * In case the state_mutex was taken already we defer the cleanup work
> +	 * to the unlock flow of the other running context.
> +	 */
> +	spin_lock(&xe_vdev->reset_lock);
> +	xe_vdev->deferred_reset = true;
> +	if (!mutex_trylock(&xe_vdev->state_mutex)) {
> +		spin_unlock(&xe_vdev->reset_lock);
> +		return;
> +	}
> +	spin_unlock(&xe_vdev->reset_lock);
> +	xe_vfio_pci_state_mutex_unlock(xe_vdev);
> +
> +	xe_vfio_pci_reset(xe_vdev);
> +}
[snip]

My first KVM review :)

I think xe_vfio_pci_reset(xe_vdev) need be protected by state_mutex. So,
we should move xe_vfio_pci_state_mutex_unlock(xe_vdev) after
xe_vfio_pci_reset(xe_vdev). Thoughts?

Thanks,
Angela

