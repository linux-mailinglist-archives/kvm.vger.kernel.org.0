Return-Path: <kvm+bounces-25283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B6D50962E7B
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 19:28:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60FCF1F21AB7
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 17:28:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF2FD1A76BC;
	Wed, 28 Aug 2024 17:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b="YrieHuyL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467221A7043
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 17:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724866094; cv=none; b=UVMnuo8XGhLyaeeDFPz5FJFyNXLaix3Ytj6dFdpG/E1nQFISoHLBk1ltV87vG/Ix/iwbW1/j3QX0uTEZvo+ETcigcjnSMFCMO/r0EqwrtOKKe3EzF3X1KYttJphq0A6UWhsrQxYNxlIQdOX+BFVtZxYfGZF2PKfLrkkNRhEnD6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724866094; c=relaxed/simple;
	bh=HypgDgtB4ct/OuJkz4CzqDuTTpFOG82yJbB3Gp9Nl3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gYWjZQpPBtqVAAGviRqftWlVoRI4+8UDcKS040qRqPrnI/cHNgWQoAOXAw4S94EOpR12HBge07mv7weGbQ2PG7l+Hep7TYFbDWoM1Az7K3X6Hne5KEUMEOadE3iUaOqchOMzlNpNvpHwrao2l9CH10sp7ZsF/Y5UqlEVLIwdssg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=digitalocean.com; spf=pass smtp.mailfrom=digitalocean.com; dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b=YrieHuyL; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=digitalocean.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digitalocean.com
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e05f25fb96eso6995140276.1
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 10:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google; t=1724866092; x=1725470892; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zCPXRj4O3bcsketV9hnxl4fQbKxvadzaMLv4xTGbmvw=;
        b=YrieHuyLcaRqzVQYQoFYLCTswDKpIhgqW+kiyQ4rLa3Xa5DyiG5ftqU35tnxwzWHqV
         zl1BAx2Gv8ZgHhewgd14S5s1wtRw4q/H15nm/Y1mRq0Wt8eT5qG09aYYBwTjtuF8Rd9T
         EXMGNqv8w7Y+M36LSZJxoaNng7qxlLKZ6n5N0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724866092; x=1725470892;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zCPXRj4O3bcsketV9hnxl4fQbKxvadzaMLv4xTGbmvw=;
        b=JwNVmfpsvZXC/cGG7izpUOVT/fjBwhQg3s+Hu5nVbEZ4wkZOqcZZ8V7g+SlVIHgDx4
         a797Xlj1jwxFsjSDsBS//ElyZvXilK+7YmgZxxMghyHSltBigTdbIArhiYzZgj1mE97M
         E01afcHUlubG0ywHALwr5ps7KkFqbcH7f+aZxxS0boMClCD8+QXOl4bV/2V/r+D/cktF
         4WId4vbdgtjB4q8hsv3oUt/76Z7Lxp+YOqY99h6KZhMQScA8MrgGIumdJA9CWZivDV2A
         4TU2bUCw1/4C+nlgowx4JEJKqVTsTxe/EJNqsSriXF+crvYQGSHDJjrtXtw2qZp8vjOw
         1YgA==
X-Forwarded-Encrypted: i=1; AJvYcCV4BaWuwLXK3D9Fr6Wm46kk4XzzPBTF45La2JZexxOunDv5uqN+0cNADINLCPySoOLkZ40=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ78wrnG/JRNNSz/1mCTtTgMgTzZJohxLL5mqxyk2iSNHmhrp9
	PM2rn8uL/nZav9W9/kUnjVCJdXuE7i5U6Y8fNNkd5T59KVEQR9vk55Mf8vQjcrQ=
X-Google-Smtp-Source: AGHT+IFPC41Qak2gZ0YGJ2D7BiYZJ3IUJn9Ef3OAyW792KU6hAe4yKyakK/6d00Omzjp9FW2G84t4Q==
X-Received: by 2002:a05:690c:6512:b0:64a:4728:ef8 with SMTP id 00721157ae682-6d277f51e62mr651667b3.44.1724866092130;
        Wed, 28 Aug 2024 10:28:12 -0700 (PDT)
Received: from ?IPV6:2603:8080:7400:36da:b4f6:16b8:9118:2c1a? ([2603:8080:7400:36da:b4f6:16b8:9118:2c1a])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6c39de41cb8sm24217897b3.116.2024.08.28.10.28.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Aug 2024 10:28:11 -0700 (PDT)
Message-ID: <41a2a533-549e-4f45-9d8d-68b5ef484b05@digitalocean.com>
Date: Wed, 28 Aug 2024 12:28:09 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Why is set_config not supported in mlx5_vnet?
To: Dragos Tatulea <dtatulea@nvidia.com>, Jason Wang <jasowang@redhat.com>
Cc: Andrew Lunn <andrew@lunn.ch>, mst@redhat.com,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, eperezma@redhat.com,
 sashal@kernel.org, yuehaibing@huawei.com, steven.sistare@oracle.com
References: <33feec1a-2c5d-46eb-8d66-baa802130d7f@digitalocean.com>
 <afcbf041-7613-48e6-8088-9d52edd907ff@nvidia.com>
 <fd8ad1d9-81a0-4155-abf5-627ef08afa9e@lunn.ch>
 <24dbecec-d114-4150-87df-33dfbacaec54@nvidia.com>
 <CACGkMEsKSUs77biUTF14vENM+AfrLUOHMVe4nitd9CQ-obXuCA@mail.gmail.com>
 <f7479a55-9eee-4dec-8e09-ca01fa933112@nvidia.com>
Content-Language: en-US
From: Carlos Bilbao <cbilbao@digitalocean.com>
In-Reply-To: <f7479a55-9eee-4dec-8e09-ca01fa933112@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello,

On 8/27/24 11:54 AM, Dragos Tatulea wrote:
>
> On 27.08.24 04:03, Jason Wang wrote:
>> On Tue, Aug 27, 2024 at 12:11 AM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>>
>>> On 26.08.24 16:24, Andrew Lunn wrote:
>>>> On Mon, Aug 26, 2024 at 11:06:09AM +0200, Dragos Tatulea wrote:
>>>>>
>>>>> On 23.08.24 18:54, Carlos Bilbao wrote:
>>>>>> Hello,
>>>>>>
>>>>>> I'm debugging my vDPA setup, and when using ioctl to retrieve the
>>>>>> configuration, I noticed that it's running in half duplex mode:
>>>>>>
>>>>>> Configuration data (24 bytes):
>>>>>>   MAC address: (Mac address)
>>>>>>   Status: 0x0001
>>>>>>   Max virtqueue pairs: 8
>>>>>>   MTU: 1500
>>>>>>   Speed: 0 Mb
>>>>>>   Duplex: Half Duplex
>>>>>>   RSS max key size: 0
>>>>>>   RSS max indirection table length: 0
>>>>>>   Supported hash types: 0x00000000
>>>>>>
>>>>>> I believe this might be contributing to the underperformance of vDPA.
>>>>> mlx5_vdpa vDPA devicess currently do not support the VIRTIO_NET_F_SPEED_DUPLEX
>>>>> feature which reports speed and duplex. You can check the state on the
>>>>> PF.
>>>> Then it should probably report DUPLEX_UNKNOWN.
>>>>
>>>> The speed of 0 also suggests SPEED_UNKNOWN is not being returned. So
>>>> this just looks buggy in general.
>>>>
>>> The virtio spec doesn't mention what those values should be when
>>> VIRTIO_NET_F_SPEED_DUPLEX is not supported.
>>>
>>> Jason, should vdpa_dev_net_config_fill() initialize the speed/duplex
>>> fields to SPEED/DUPLEX_UNKNOWN instead of 0?
>> Spec said
>>
>> """
>> The following two fields, speed and duplex, only exist if
>> VIRTIO_NET_F_SPEED_DUPLEX is set.
>> """
>>
>> So my understanding is that it is undefined behaviour, and those
>> fields seems useless before feature negotiation. For safety, it might
>> be better to initialize them as UNKOWN.
>>
> After a closer look my statement doesn't make sense: the device will copy
> the virtio_net_config bytes on top.
>
> The solution is to initialize these fields to UNKNOWN in the driver. Will send
> a patch to fix this.


With Dragos' permission, I'm sending a first draft of this now.


>
> Thanks,
> Dragos


Thanks, Carlos


