Return-Path: <kvm+bounces-27711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F8B598AFA3
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 00:09:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B49991F2337A
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 22:09:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 785B418859F;
	Mon, 30 Sep 2024 22:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FvBQqhwX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B334170A22
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 22:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727734133; cv=none; b=SY+pPVJ0rKKujj52O1RuC30kWShIt23IwOAXfx1KZQE3cK0CdCF7W4ooTRxZ80SS0EA1q5ZQ3uvd9sKsNH1k8AN0K3gzV3+Qhk3LxNPwLWzIAXaCM4ABd4GtCQNIQTCRdIdmEABHm+Yz4EfUAfh/zmMgYRTPFlZGbieFCgggmgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727734133; c=relaxed/simple;
	bh=yGabaZGA61WHta98Mf6SxRHsQT6REk+WJWHbJdDtGEA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XPsNHncCGdcAGv9rqSs2GdfMdA55XNm0YYB31xV0AF3gWMBK2lagoTabJHVMtPTWmDAozeZB8eNskvBGm19dhxjd9KzUqcj14yQ2QUw+lmIkfw0fTqWPIUCbv18qlj6E/tgjUaNnaJPjzriIFlJGAN/RLqoIKg4lErxxG9/XU40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FvBQqhwX; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a8d43657255so751806166b.0
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 15:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727734130; x=1728338930; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=DcHrOmwJysYApwk1+f8ZfCw/rdA3DV8VJVNmvlMGQ8Q=;
        b=FvBQqhwXn06bDkp82EUZOjSS74RcR1XqjfqhuoD1sVn93+/rqvfTu4+YPMRtBvZc56
         BiGOmcK+XdDO/K6MwHwyi5iWr6j25hOwcQNZaQEoKQMaJENPF30byg6Uvu07GBNRsVKQ
         KPCqmTIdQtdOy7ZjRTx8VTH66J98ReYm4fyAXrSueNEt8X7S4ay440PxGamgVmRc+l1J
         uR6fZK4x4IXQmIVcb1VO1CQysxCe5W27pJP2nnplORLWc78ls3gXPETHBkP4sOZsBlI6
         NlAqEGRwoGiADpsXSqHJ6KCrLCxTAwM1wRESad+gYsFGC45T68uNU1HZItHMaOUnlyb4
         mJ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727734130; x=1728338930;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DcHrOmwJysYApwk1+f8ZfCw/rdA3DV8VJVNmvlMGQ8Q=;
        b=DwR8icAEg08mAJBvEBpUO2TMwX4L6wRCR8HuyjyeqPSepfJXsWsJALIhjChPuUw/lJ
         Bk69UlekkMLdMDdhQt8VcHNvSEfVX5F0OD0ADcWQBAXGiOidAqVMUmejPcMcD9YOm6ez
         G9o1rBcs7UBOrFDO948DP95AAhsWOHaW5+FiUtao6h58a+qug41msWGDDNpJ8EZv2F8v
         Q62A+BYR9cTmBAilVXm1roT0+jlXSG+ZELfiIA4IzCkLu/qtNqx9gzMZCdO5CHbYZ+wW
         TupvNnwpsP4Cj6QyY4Wi9gO4XKv6983Yt5bL+uZJXtYw64JKI7qkTBoQfciSbEbJBX/S
         A9gA==
X-Gm-Message-State: AOJu0Yz38eXBxoHrl/bjOCv2nZruz+G+V7V+Lp+VzoA8IQCOECUylLfk
	Eamfm2BLFJzWHm25yCGnT7bNBuXLZz8g8B5xz2kquX/arQaZtkiT
X-Google-Smtp-Source: AGHT+IGcXbtwYpcI/ujgsYNY6NsmKefbP2CDOtlfm3xpsCPRDqYsw8mK3Cgi4bv6aW6BHP5n6EwO8w==
X-Received: by 2002:a17:907:3cb:b0:a93:d271:52aa with SMTP id a640c23a62f3a-a93d2715d83mr812471166b.52.1727734130077;
        Mon, 30 Sep 2024 15:08:50 -0700 (PDT)
Received: from ?IPV6:2a02:3100:a43d:aa00:48d1:a208:911:c128? (dynamic-2a02-3100-a43d-aa00-48d1-a208-0911-c128.310.pool.telefonica.de. [2a02:3100:a43d:aa00:48d1:a208:911:c128])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a93c27cafc8sm593988666b.84.2024.09.30.15.08.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2024 15:08:48 -0700 (PDT)
Message-ID: <11a5c0ec-c213-4873-8ea4-b5c9a367458f@gmail.com>
Date: Tue, 1 Oct 2024 00:08:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Can class_compat usage in vfio/mdev be removed?
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, Laine Stump <laine@redhat.com>,
 Kirti Wankhede <kwankhede@nvidia.com>
References: <8c55ce81-6b0a-42f5-8e05-5557933ca3b8@gmail.com>
 <20240930142038.11e428cb.alex.williamson@redhat.com>
Content-Language: en-US
From: Heiner Kallweit <hkallweit1@gmail.com>
Autocrypt: addr=hkallweit1@gmail.com; keydata=
 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
In-Reply-To: <20240930142038.11e428cb.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 30.09.2024 22:20, Alex Williamson wrote:
> On Tue, 17 Sep 2024 09:57:23 +0200
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>> After 7e722083fcc3 ("i2c: Remove I2C_COMPAT config symbol and related code")
>> vfio/mdev is that last user of class_compat. This compatibility functionality
>> is meant to be used temporarily, and it has been in vfio/mdev since 2016.
>> Can it be removed? Or is there any userspace tool which hasn't been updated
>> to use the bus interface instead?
>> If class_compat can be removed in vfio/mdev, then we may be able to remove
>> this functionality completely.
>>
> 
> Hi Heiner,
> 
> I'm afraid we have active userspace tools dependent on
> /sys/class/mdev_bus currently, libvirt for one.  We link mdev parent
> devices here and I believe it's the only way for userspace to find
> those parent devices registered for creating mdev devices.  If there's a
> desire to remove class_compat, we might need to add some mdev
> infrastructure to register the class ourselves to maintain the parent
> links.  Thanks,
> 
I see, thanks for the explanation. So class_compat isn't used here with
the original intention in mind, but just as a convenient method to create
a container for the mdev parent links (which wouldn't necessarily have
to reside under /sys/class).

> Alex
> 
Heiner

