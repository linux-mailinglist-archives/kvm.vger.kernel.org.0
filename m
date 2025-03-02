Return-Path: <kvm+bounces-39833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 610C4A4B587
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 00:44:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B10B1890255
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 23:44:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F26C1EDA2E;
	Sun,  2 Mar 2025 23:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WC8iJQhE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF76E1DA61B
	for <kvm@vger.kernel.org>; Sun,  2 Mar 2025 23:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740959061; cv=none; b=fjx9r/qDyRUAHNKjGwHTQYmiucJOy7yC/ZtISkpLQjo1hI6ZEMgxvJ9Koy5oyiGcuvoB8G2o5oR9s37Dw908iaVN0W6ucc6EgeCnBkpTER33actraPPNSyO6O7cyfU2LuhrCdQ0MmEFFnRpbudn1ZdnQCCXHsx6uSSh85aq8C14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740959061; c=relaxed/simple;
	bh=sTCLWPm34augivVf+k+p8TpTc7zDld5RdFOwiFSrPQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BTNxAJ65SskeIL/VWTRa9i7R/VGxEnFroh0qpy9mkXE7302EDYskWvW883R4YW+yN+izLAJI929IMRBAjK23PWHVNzLjg3NLZ4v8/sjMN+6UqYFOfOx90J46qUz9ECbvSeVxU+ctEHVfOO0JTVBO62dHs/62cb1fz4j2ql75z2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WC8iJQhE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740959058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=apls3JT829ifJDsJne75u3rNFMkdEv5XlW99N9rTPso=;
	b=WC8iJQhEGeY8rqhh0TlIsfSiA16BxsN8IYJm5sZwdhbNYZ6sq22gd+v8pqRYR8qOqrX8Mr
	/zVjM2FvsnvlqFfiFtcCJtQXT7up31xtfNER/JZsauBEIplWD7Sm581rI/RlsehDX8BJP6
	ZRDcIL+R9vymhIrlyn0Cjp9J+yR3wqk=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-WaPdvWl4MYCkYp5fokH33Q-1; Sun, 02 Mar 2025 18:44:02 -0500
X-MC-Unique: WaPdvWl4MYCkYp5fokH33Q-1
X-Mimecast-MFC-AGG-ID: WaPdvWl4MYCkYp5fokH33Q_1740959042
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2236b6fb4a6so85970725ad.2
        for <kvm@vger.kernel.org>; Sun, 02 Mar 2025 15:44:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740959041; x=1741563841;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=apls3JT829ifJDsJne75u3rNFMkdEv5XlW99N9rTPso=;
        b=N2VQFsKOzI/Lx975KWXyHRtzbdZwnTCO8taPDRhDRwmNp9xjJYxEAIEu10APXuW0eI
         pkKvcC5n6wNWLwwAhVqqoiTZ5Ng2B8wst3153u2HM+4LKHK9OFy67fSrvJJYB4Uo36eb
         LOVbx1zN+YfKhn2D2qVcB9IB3fsNojQaEWgR6kjHKwY6zyH7HoZzcJzwFLh8DxOa7r84
         oUnebqMsJW/vFpj3fTgRQ4zxmaylT12Emf1m2CdEQLc0owxYR5fMaAQJYdsgP7ZVpcd5
         whzPR7rQ9R/08vrFNxbdpz8DKdfSZ1cd33VgsP1WIFty5gR/8Y0Oq54KEqGssBMANSqF
         ZTSg==
X-Forwarded-Encrypted: i=1; AJvYcCUHzLCgwwp3xeB1sV6dLQOV8QA/WiCEQiuaZYNavgMAsZ4Wv3vU7ASDohFpB565uKVvEEM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLZTkSkm7gffUxJ3hRn7qUbi2U/aHVChXMpLrrnGf94EGFsD+N
	Ve4tnvjkumZMR/Mmhk77d924gpe8yKQNFSXMI9tOzjGkLQcnLKnBWO0vV7PszySq/qqpQfnW1oo
	Blsc2TjXqaTIpcikTt23qpsQD8GYyM6t5d3H/RgIMhT0NdElKBQ==
X-Gm-Gg: ASbGncv6ZiYqU/d71OS0A+KSeubVNmSbcJlF+tJ3NEHpO9wH1PgAeEo2UXgmg8xLYVx
	sOV7MMNhCdVweWHPzV2xlWTW8ZGwLDd9EMlvEM2OqMYs4ONSQkMVfXiSDZItQbc31pkMIbYVVTJ
	zNQQygcbdewcPRlqAMwPCj/XjlJXafOYatEDZ8YwwVGSeelQwl4P3uMJxuQr1o6v+F4MO+vA9cV
	ivOn37cbLpsjCgZDNSYSdcpz8zEC23Hoou/N27yRegkkM8tiEbRjNd+qcoKv9K5wmQTYHjDSXv+
	sxHLcThfROpjtOcHLg==
X-Received: by 2002:a17:903:1252:b0:223:26da:4b6f with SMTP id d9443c01a7336-22368f74891mr183107395ad.14.1740959041707;
        Sun, 02 Mar 2025 15:44:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFYssys7UGoPXMBxe9bSswsi7jbUP9yKeJMmGxQGuBfHCIW8f2mxFgGu/EUcQbiuyd2gk6SQ==
X-Received: by 2002:a17:903:1252:b0:223:26da:4b6f with SMTP id d9443c01a7336-22368f74891mr183107165ad.14.1740959041447;
        Sun, 02 Mar 2025 15:44:01 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501fd28dsm65811695ad.94.2025.03.02.15.43.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 15:44:00 -0800 (PST)
Message-ID: <9dbebd7b-b441-405d-8c45-0dfa4d3df9e3@redhat.com>
Date: Mon, 3 Mar 2025 09:43:52 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 03/45] arm64: RME: Handle Granule Protection Faults
 (GPFs)
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-4-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-4-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:13 AM, Steven Price wrote:
> If the host attempts to access granules that have been delegated for use
> in a realm these accesses will be caught and will trigger a Granule
> Protection Fault (GPF).
> 
> A fault during a page walk signals a bug in the kernel and is handled by
> oopsing the kernel. A non-page walk fault could be caused by user space
> having access to a page which has been delegated to the kernel and will
> trigger a SIGBUS to allow debugging why user space is trying to access a
> delegated page.
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v2:
>   * Include missing "Granule Protection Fault at level -1"
> ---
>   arch/arm64/mm/fault.c | 31 +++++++++++++++++++++++++------
>   1 file changed, 25 insertions(+), 6 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


