Return-Path: <kvm+bounces-39983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 46E06A4D3D7
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 07:28:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D54051888D8B
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:28:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D24CF1F542A;
	Tue,  4 Mar 2025 06:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KkgPXfci"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860ED1F4E49
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 06:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741069692; cv=none; b=m0ERVdsuemgRAIA53RjX78HtknaqkMtyHVCQZkFTNhFBjosJw3VJOwxxqwUeFGJKCMpu5llBE3z9GLXTX8cGoY9V/aM+jAQGLI+x2rYGKlyU4hqYoViCg3Gwb9HvzqE5z1axhhDWH/qSdMFqcmI9qEeQxTZLQh6DYeAAN0se8cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741069692; c=relaxed/simple;
	bh=sANxphPEpJhSoJRv2v+wz0k0ncvT/idn6pMCGmv7Dyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PAExK9GEGkLime8DL3fgqUvz5VeAHWd+6DY3H0oCWJDToZ62UGnJ4gCtpzERG6vv+76KoRsJMkNf4iFIrcvm4J+FaRCaqjz7tb9VEtZvpttTWZ3wMd5P2YNMXpUvrc9QH737sEi1pwL3Unh300Uzgx85KJ/mP++B7ZxoUErJdn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KkgPXfci; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741069689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iAefvd9tbj7LNYMHtdDRot9Yl7dRO2WNDbwoA2ZpIZQ=;
	b=KkgPXfcit6DXjysEa72fQwOscSGvZHewWFl7gK0oHZ+JvjeXoxoRdorI6vMJ1Vgdz7nju1
	SM6R+jdptkqWh0I86MpB2rcG314p2TgAhBvlCwADAvrzti9cKafOwuLaGQ6qxErYbsbPde
	sSg+2Du5xWak3v7gCY7AjTL+gEoOsyQ=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-e5oC8DimOruHjHsA9K8esw-1; Tue, 04 Mar 2025 01:27:58 -0500
X-MC-Unique: e5oC8DimOruHjHsA9K8esw-1
X-Mimecast-MFC-AGG-ID: e5oC8DimOruHjHsA9K8esw_1741069678
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2233b764fc8so94755115ad.3
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 22:27:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741069677; x=1741674477;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iAefvd9tbj7LNYMHtdDRot9Yl7dRO2WNDbwoA2ZpIZQ=;
        b=I25IuVgkuAkHtu/qY25LEMKTzwZ31J5vn2ZhzXCFzFuaBhUPseGwmSplDwgIofNHfC
         pb3o1G4pE7kohGccO5gPWJZIS6dTQvuFs95+AgHDUx3eJloTzXBbUW6P7X0lnuBt8gU3
         cb8O3oKelxoQRWh0JTt2zhHFAL2ncAxDJ4yJ21GiCfy2LBacsCyA/Wlpn9u/qQtAr2IG
         dnauQLXfN6wIvqBwxzBdFhFPjJkRDUoc+acr6C31CIcQ6SV3avnUGooXfFyvT9905UqH
         Ep3bD/yCdGVmp+WBiIQHUWqzUUFZWtU4s0d1YrTHNi7PIa8Hzl15KgmBCh3zyxMXn7X2
         fbUg==
X-Forwarded-Encrypted: i=1; AJvYcCWjg9HqHzj9DOUjRZz38yBd9Kjwn/jCB4yvVL0R3Z4dkj2lPxwXiX30G12W8kWrZnk5Ds0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSYn5VLelpJ94HdUjkq+Suks6D2Oc6DzyAU2bX/wn1uPIKsoAB
	XJT780lGdEI9xQY6p1EOVi9Sv1attSf566xs0Oq5R+VzaWQIa+xJttZPllP8cRa5R6UKLMBjinP
	3e1cwhUL7C5fEqJoEnORakYs63FfETNxG5XNUCxOoR6Ie5f4DYw==
X-Gm-Gg: ASbGnctgXup9i4O4MEJoa9Jv2tv60mrajCsczi6d7rMfhC3Jov3WNKpNHIKK/BOvEnQ
	8uUAGUC//7F5eVyvD7OnQ+Hv1fjdTbR8V/ghRNmreFBCEdOA6WYNynZEwS8Q4PWcKqsKC0SCUEV
	iTYUlmRrC5cEyzyRYfcV+WISExOrNlDJ+VxpA56hwSt3MplMMB+f3RgC/VnvPUEaX7BPCHOq8mR
	ecg3B+9/USDLF0duR13TVWum+ZlBqYjzPMwt0f8zvfO/ChtIijnCY6/kksaOMRA9F69/HQySev4
	vIYdhWZSXmvisGZ9Jw==
X-Received: by 2002:a05:6a00:230c:b0:736:7270:4d18 with SMTP id d2e1a72fcca58-73672704d81mr1945039b3a.14.1741069677577;
        Mon, 03 Mar 2025 22:27:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGMjQLRj3AUSUbMsClYXUXqxqJWhk5KrbeXBQgXSoViyrHJ8djjcdkYHY0nBVtVH5e57rXWYg==
X-Received: by 2002:a05:6a00:230c:b0:736:7270:4d18 with SMTP id d2e1a72fcca58-73672704d81mr1945005b3a.14.1741069677191;
        Mon, 03 Mar 2025 22:27:57 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7363986010asm5850843b3a.52.2025.03.03.22.27.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 22:27:56 -0800 (PST)
Message-ID: <780f593c-81cd-495c-8ca6-38ecd64ddb35@redhat.com>
Date: Tue, 4 Mar 2025 16:27:48 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 31/45] arm64: rme: Prevent Device mappings for Realms
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
 <20250213161426.102987-32-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-32-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> Physical device assignment is not yet supported by the RMM, so it
> doesn't make much sense to allow device mappings within the realm.
> Prevent them when the guest is a realm.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v6:
>   * Fix the check in user_mem_abort() to prevent all pages that are not
>     guest_memfd() from being mapped into the protected half of the IPA.
> Changes from v5:
>   * Also prevent accesses in user_mem_abort()
> ---
>   arch/arm64/kvm/mmu.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


