Return-Path: <kvm+bounces-39860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D432A4B7E8
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 07:26:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D43AB3AB7DB
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 06:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EDD31E5B6B;
	Mon,  3 Mar 2025 06:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XjwU5P4B"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA401E47BA
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 06:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740983162; cv=none; b=UNjsUn6AwiNoYZzhmdy6IfOv/O9Eb5BJCy/bSBhaYa0BIPsQLQLQ/SRSAmkDd/IRREMhqIk85yUUgguAhHrOczowJmjdcistD0RFHwJ9K41bpn9so5nz1PMMLFwHTp2zuxEcafE0a7P6RrZ8KW/SOKJankyid0ol1664DSbamOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740983162; c=relaxed/simple;
	bh=7M+DRz2hm03rBgj2x3UrNt6vpeHXng5+xitohQvfcAY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NqI5b6VVVRURlsIXnjhDVIpCRuMC2BG2Kk9w+/ZwQlgxUzzmvnPEdl/rZHAM2cBMKfLdQxFB+/XcHhTDsoNSjV18llj8EbkZhPO1fxIb7uIIosoblVHjX7KCvtmlxj3FwQz2LmqzKxnUnGixbtAzyRB+nLil1I1D+Afqf0f9I5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XjwU5P4B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740983159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N+ANXerGfs05Qx5JuBBnd1YtOYkq281duKe5pNwiLBs=;
	b=XjwU5P4BipKFB3PnMww7FkDxuhqtkJ4RXL1JGHDmcWkz79M00BeiAJ2E+HGPhuTUMpVa5G
	N0VhTQcZJCYkyflHU2iiPL8gEyKtRpFhItRtYWqyzFWyYKimVj5zNvfDVs9K4sJ9fhg7n2
	puDDYCeYZ7O6wpkdPMjrzZAgMhZ/7Vo=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-MV7uPczROkS0WUP5s5Q3Bg-1; Mon, 03 Mar 2025 01:25:58 -0500
X-MC-Unique: MV7uPczROkS0WUP5s5Q3Bg-1
X-Mimecast-MFC-AGG-ID: MV7uPczROkS0WUP5s5Q3Bg_1740983157
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-22107b29ac3so65953445ad.1
        for <kvm@vger.kernel.org>; Sun, 02 Mar 2025 22:25:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740983157; x=1741587957;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N+ANXerGfs05Qx5JuBBnd1YtOYkq281duKe5pNwiLBs=;
        b=L+AXcI6OkV8JYj1L8tLFV3vSBzrRxCvYyt6+Fz3Ii3QqugbyoZRz2ihvgCVcla+4+b
         2HxBlb6/5dWSQeZt1NW9hxnWb9McD7c+D3GUVhJV3vH0p0ZWwhaWG5LCx55wRFXGcD7B
         93X5WeD5VuxN1gXpD3kmpUK6ugVGbFvU/gqA8QijAn3DEu3VDlfY+XZBrpWaUTABeeAP
         Zu+Ud0urV6cNgfqH3L71a47TQfTvdChgOBozQoVsosRthoPe16EHDOtcrHY0oWrdKRtZ
         +5hidf94rkEkJmSDR9jxWNtNLRyhkI7UYdVYy/DdwU9U4dq3EFxIwsoWBkSTFC9/9yo1
         owow==
X-Forwarded-Encrypted: i=1; AJvYcCXj2Jv48FJY47hSTOnISGOTALoNtduEFMBHzol0Su2JAupDjFUDP5oXoLslL1NQQwzm8Lc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4eD27hdvKak4jn5eVPQuxdcZHaNWXquXYt34LfOTp+5NPm02z
	iTfOP4Iw2zQu+WCFET+5WuVbmI3st1VHfTjuaiEIXUxNeK6ynduIfAv2TrC9YRDDCdjz6yDww7h
	MwJFvv3tsNp9Xd6ISudH5g9IEeW5SX40tIt/4PJiuZMUyNUNXSw==
X-Gm-Gg: ASbGncsVEg8FT3BlFN0ynsEUP78VocTIoDabzchDct9TGW5tebvCprdWAWjXtx/WZeJ
	iW/Nc2Yj2L6xLuyDS3lWcAjvPoGRruY3t8y0OgoSSDmPSJUTO/b1bURnA/+IvjM4/gwvmPpVaTS
	sxR9aJK1WWDIgvLxXjAoAcICs24lWF7+gpR3x/FVoqX6pstlUQdW6U/9oGwrYrZYwHRwJbX+xyW
	uaFqVuaIsp5U8o8x+ZKvHO1hY/fgbySBRssGT1ERBTTBsLI8UY77XgqSWHe5O2KoYZwNdZwMki+
	cvPPnAHNS58DTMfRig==
X-Received: by 2002:a17:902:e5cf:b0:220:ff82:1c60 with SMTP id d9443c01a7336-2234a4891c5mr239752415ad.14.1740983157575;
        Sun, 02 Mar 2025 22:25:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFpXtcArHUqT2hI5ax8evJjGCyGJEtPHCAmH1OVzs9dnw0tbzauezRsGnlG5Grz1mEDveiZtg==
X-Received: by 2002:a17:902:e5cf:b0:220:ff82:1c60 with SMTP id d9443c01a7336-2234a4891c5mr239752075ad.14.1740983157279;
        Sun, 02 Mar 2025 22:25:57 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223504c59e1sm70112765ad.158.2025.03.02.22.25.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 22:25:56 -0800 (PST)
Message-ID: <e432ee67-6afb-40c8-9542-48770834ee40@redhat.com>
Date: Mon, 3 Mar 2025 16:25:48 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/45] arm64: RME: RTT tear down
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
 <20250213161426.102987-12-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-12-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:13 AM, Steven Price wrote:
> The RMM owns the stage 2 page tables for a realm, and KVM must request
> that the RMM creates/destroys entries as necessary. The physical pages
> to store the page tables are delegated to the realm as required, and can
> be undelegated when no longer used.
> 
> Creating new RTTs is the easy part, tearing down is a little more
> tricky. The result of realm_rtt_destroy() can be used to effectively
> walk the tree and destroy the entries (undelegating pages that were
> given to the realm).
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v6:
>   * Move rme_rtt_level_mapsize() and supporting defines from kvm_rme.h
>     into rme.c as they are only used in that file.
> Changes since v5:
>   * Rename some RME_xxx defines to do with page sizes as RMM_xxx - they are
>     a property of the RMM specification not the RME architecture.
> Changes since v2:
>   * Moved {alloc,free}_delegated_page() and ensure_spare_page() to a
>     later patch when they are actually used.
>   * Some simplifications now rmi_xxx() functions allow NULL as an output
>     parameter.
>   * Improved comments and code layout.
> ---
>   arch/arm64/include/asm/kvm_rme.h |   7 ++
>   arch/arm64/kvm/mmu.c             |   6 +-
>   arch/arm64/kvm/rme.c             | 128 +++++++++++++++++++++++++++++++
>   3 files changed, 138 insertions(+), 3 deletions(-)

Reviewed-by: Gavin Shan <gshan@redhat.com>


