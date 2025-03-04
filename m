Return-Path: <kvm+bounces-39970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36B15A4D320
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:48:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E5293AE42F
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 05:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 868801F463B;
	Tue,  4 Mar 2025 05:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cDYZOCKS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B175A26AD9
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 05:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741067284; cv=none; b=aj1QHjoIWbdQTyzS1cJw6RN/2eKkaj1avnY7A736Fp8EQR4gqFpXuhFIwc/5/IJ20XmMixrjeXM4IKTBIWr8I4vhXC8IxvfccgvN17afyx1Fp6wAM1lK6U3EpT/MhpL24+P8NpBs05ylcRu8JHi42LVacVHGYUvrIPLnCML0+1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741067284; c=relaxed/simple;
	bh=uIUop+r/l6xH3Ly39qJ0Hh+UtGOGfUCQ1Gk41ZgJy6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eWB7UYsHygq/f8c2eNtI/AWJ9TYGIzjhv7HzmFRPXE8r1ZdGGofT4lfycms0kBa/hu7ckcKm6OSQhPUM0HzEZ5e1e+hZN2xIfXVuENahZVeAo/FubMjXacu4FZDDGkaDV+jDQerOOaUhdr4T7X1mqLXL8gT2hN6wC6HF8PBP3Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cDYZOCKS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741067281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ALe8gaqPx0ivwZMUhNjC7kbkgwdK+iS+cXrLOMiOcsg=;
	b=cDYZOCKSbxHn4yVmmzNX4T1//MQ5xNEZvrJzW90+cf/xSm2FDmRY2QpwhTNhsxjFZqyQkl
	L/0KOZNWERGgROCSkRYyWgtY07SXmrTeqdFJsvBzZGoN6FH6zL4oVO5fm+cLOY9BO3or31
	bHB5CiXiVg0ux4H0lOQS2UWKusD6jK4=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-pMPUm67FOtSBlxxHDr4Vlg-1; Tue, 04 Mar 2025 00:48:00 -0500
X-MC-Unique: pMPUm67FOtSBlxxHDr4Vlg-1
X-Mimecast-MFC-AGG-ID: pMPUm67FOtSBlxxHDr4Vlg_1741067279
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-22379af38e0so51901575ad.2
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 21:48:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741067279; x=1741672079;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ALe8gaqPx0ivwZMUhNjC7kbkgwdK+iS+cXrLOMiOcsg=;
        b=rxydEAB8x0HnS23F1blnv9Qw02nBJfxl7OksHHzm+j3f6q3sdrrL91OOUxPTSkYEud
         IiUnOqemfgMTTGzFsuu6rqlisa39U3v5ihh7Cn2BqhxOks/dchAc/MqXh4QoQygo4gxJ
         PviIrXlLQ7EMageti0WHajMSPOUub8jzUIxw4MaVg5yS4s9LkFZaCPcdTiLGT2RnXyGL
         ho6+y+BB/f13WcsLm27lbXTSEszagn31LR/6eBR2M8dHm8xrIn25x3VFHfvXiw1jc1Be
         0x5gVmug52W2kqF1z9Rk17F1rY1vQ0HHAD6bh+dZ/j4E6qtBBChGSuUfEpGXKIaxh45L
         IdaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAg/yJ08BTkB9/22vLKK62d3C90c6YgwHlWccIvLHTAZO+4tg0wJ3s1Gaf4VhdO9TXjBI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAKYy45+URdCpFr2pwCehQcTGB1JRXBH9brdWZl96F1emgcnFv
	wiWvXTai6AIAaRsXp4+Hd6APbHwEuFuUhtkdVu0rGo5NNZ8jUZ0fWqaD8NCUU3bDD7eUal4go6E
	wuqz6QsQrtbkhxdeUZt0P/YVHPg/xhUBxxiDw0r8awTVAm3Wguw==
X-Gm-Gg: ASbGncvlJZTCMHvC9Vfv8BQu0n0Xuj8WjVcDkwaJlvS4HAOUgCxCl5oaUgObMnSKGpR
	tnxXb6IXSynnPI48G6g2vNSPWBBc4KdIPT7r40T452LV5K/fxQ43BDcftT2mi4GVm+GxyWVs2SF
	lM9dfo2OeNqbeky/2bDUGzhSwrPTrFtTxX4nsh9X74H+voD1hqrK92Y210cJbFTYWHEKcUQVgfv
	+jYoIHbFCQpgH+nqPmj3KQxSNOctn3Hu9m/nfw59IH6gb/XXyVefjs52vSzNp7i6kB/eXZSFT+z
	2U7Sy3T04No8D+yXZQ==
X-Received: by 2002:a17:903:1988:b0:220:eade:d77e with SMTP id d9443c01a7336-22369255615mr277878155ad.40.1741067279408;
        Mon, 03 Mar 2025 21:47:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFx0Lhe2HGT1KmpDnS5ZyyAdNkSfy6p9uQW7gR79fCGqriIN6Hj8entskHLAJfXfbmV6sWD4Q==
X-Received: by 2002:a17:903:1988:b0:220:eade:d77e with SMTP id d9443c01a7336-22369255615mr277877915ad.40.1741067279165;
        Mon, 03 Mar 2025 21:47:59 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501fae0esm87110695ad.93.2025.03.03.21.47.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 21:47:58 -0800 (PST)
Message-ID: <2505ead3-64a6-4135-a96c-85c5dfef26d0@redhat.com>
Date: Tue, 4 Mar 2025 15:47:50 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 27/45] arm64: rme: allow userspace to inject aborts
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-28-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-28-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> From: Joey Gouly <joey.gouly@arm.com>
> 
> Extend KVM_SET_VCPU_EVENTS to support realms, where KVM cannot set the
> system registers, and the RMM must perform it on next REC entry.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   Documentation/virt/kvm/api.rst |  2 ++
>   arch/arm64/kvm/guest.c         | 24 ++++++++++++++++++++++++
>   2 files changed, 26 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


