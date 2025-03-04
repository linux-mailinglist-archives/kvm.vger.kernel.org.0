Return-Path: <kvm+bounces-39967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 750F3A4D313
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:40:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFD083AE219
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 05:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1CC61F4299;
	Tue,  4 Mar 2025 05:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hy+UZgVc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8ED1EE7AD
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 05:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741066805; cv=none; b=UDd6VEmCcQLeLbUe8zlC8vPMR8/n4iPabx8sTwyW0yU3j+uixoA8uct/dpKoK86g4R0J4fKgFtgBIhzqn5KaaePQWbocCueQrB0YWqo1LsPP7VNE+eTGdTmoIHMqwE6Q3JM5jD3lvGLmPcSWn5Jh4mJoYbtVXm9a63jxNZn7f6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741066805; c=relaxed/simple;
	bh=m1IRZ6JWrGXWz0hUht2VZ4u/oJafs19LSlUBPTVVrj0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bcbCgIT7zdxhanq2kdkvL9B2XtL5ZyILseNNO3dmCAVM6reljPvPm+4ZDsr50yfrUW3JVNZqQU9kvA/meF2Ur6wzZBGvCBuKc2ueB2bNBdNlXWTyKCv889jH5Mxb2sGv9rZyPm8gBK7EAeCMITC/LYmewPA/tKYIlOJTSWxkBtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hy+UZgVc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741066802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lnsiIq7MCp7MkWvaBWDURZ2QmGy76WgJakR0X9oQlAA=;
	b=hy+UZgVc1BMScDpsXuijbGHNQvgWfL+9rgDN92iPJrB9cHa3kvvbGCYGN3ldivyi4TSgC0
	SIIAY2J2PwGDFBMo1pcaVQuE09jxHb93yXOT8bY8/D4Bd4sfgFojm9vXa90rwhvbepQKEF
	JX0Oi9pQ8rZRf0g71OCjdiPdHM4xYVE=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-hj1S69VPPnGwKAcMp9bG2g-1; Tue, 04 Mar 2025 00:40:01 -0500
X-MC-Unique: hj1S69VPPnGwKAcMp9bG2g-1
X-Mimecast-MFC-AGG-ID: hj1S69VPPnGwKAcMp9bG2g_1741066800
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2233b154004so98885625ad.0
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 21:40:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741066800; x=1741671600;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lnsiIq7MCp7MkWvaBWDURZ2QmGy76WgJakR0X9oQlAA=;
        b=pA32LCJHWtejEsTXBRlOkJEITEboOSbVk/1s7z02T7U2I/iz1/slxp7TEf9bt8nLxE
         mX2PfooVkbaTFyZWtWgZK24SG9sfPTScqBKa6DQJNg8Bd79yXB+PzoahZkfetxlL6I+9
         YI/xKvoAupeDROiRo76t3J8XCmmjNNpFOqhwTLboi48PSqmJeqYkrqSvj9q1s4FUQwgx
         bF9cX6iHiZvaiii+mKhn39gZUG7JqzeiLor/TvblO9V+29wM0mvQF55YGITlKAs/ptgJ
         aczpPao2HTxumLXNUrSW3rYFk/0pLgG9tu/kjCUrY6vk5Q3H+GOriv8FZ8t8ICq7cYNa
         AToQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlkkR2kwalwRKmsedNKqaiPA2H5cnMU+sFId4cz4e4V/nAzendJ7Jw8RlHia0EPnVsock=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBo2LFUhaLk75Sx7IfzkWyaZ6MTW+JcWkpFGxVDKxuGj0PT/Oh
	706E6eijOu+f13wCZnGM8eioSmxo/keUPyR9nCx/pKNKQz61vUldnUCWy7/gka3R4/hTr1Od/UE
	BLOpjwEso29G87Z0H431K4/XjckJti2JnEKcWJcLuwQQ/yYTzKQ==
X-Gm-Gg: ASbGnctKWsttFGbItHJyC2SVCsf8k82iZeLzmf8jXpMAnT9yTdbKbVXJDUo+7S2/1gu
	Mos9o+bj95vD6WxTLL0/4mkfgm3HtFFOTaAhxMlq0UM4Ggs7QQjCF9HBSwSUe4qxdJWTMBGyWJ9
	Clzxik6Heo+0lx9O3uHnnNd4bUl+nV96+ggoz0kW9FakJuOJapKCpttft41dhGa39WlJ7EFVcXT
	UgCFANViWgW5QMeLbaI8K7JOQ7pXQIaT4dnYwYdanKVPkBtYNr3z1aNsFXdwFKZnwsdBOJjmIQ4
	ltHob9fsCI4b+qsZCA==
X-Received: by 2002:a05:6a00:1e0f:b0:736:41ec:aaad with SMTP id d2e1a72fcca58-73641ecaf3cmr9917205b3a.14.1741066800342;
        Mon, 03 Mar 2025 21:40:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGLv+2IvaT9lpwd7y3NyeB6C4SRMHYy3586SBjSpdbcGPeX0DUdvbJ57X14h7Gm8kD4TRZ84g==
X-Received: by 2002:a05:6a00:1e0f:b0:736:41ec:aaad with SMTP id d2e1a72fcca58-73641ecaf3cmr9917181b3a.14.1741066799979;
        Mon, 03 Mar 2025 21:39:59 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7365bb4090csm2607097b3a.35.2025.03.03.21.39.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 21:39:59 -0800 (PST)
Message-ID: <bf568862-5435-4c88-9364-0190f30a3d9a@redhat.com>
Date: Tue, 4 Mar 2025 15:39:51 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 25/45] KVM: arm64: WARN on injected undef exceptions
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
 <20250213161426.102987-26-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-26-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> The RMM doesn't allow injection of a undefined exception into a realm
> guest. Add a WARN to catch if this ever happens.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v6:
>   * if (x) WARN(1, ...) makes no sense, just WARN(x, ...)!
> ---
>   arch/arm64/kvm/inject_fault.c | 1 +
>   1 file changed, 1 insertion(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


