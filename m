Return-Path: <kvm+bounces-45026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07D3AAA5A0D
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 05:50:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFE2F984C10
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 03:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C03202309AF;
	Thu,  1 May 2025 03:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VvtVvuRn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBA51EB193
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 03:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746071425; cv=none; b=hMOASvIieZrV4n/l5UNmVmTYEY2PG4OaGXqEwEbs1hGxPDEHzH7yEPRshH6yKRnPaI9rpVBNJ4aaCsSWBYTkEDW0TzWePZ1QBb37ch2QF69pXSxFrLOmLT9UgaX9FTJ/UDe/F70opG8Ya26HV9URRSl4461aYgycXhYAVFDbEj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746071425; c=relaxed/simple;
	bh=PO+3BQsPIF+4e0+asMRXeh+QLcIUVpdmgRa7WCUfcr8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nlaxz6EqifEkYCt2pYEmiq44qugPwzlufBaYbMmabypbYa79USZ+kI+ioAL9GaxMww6T3zIGdNqwJP1QTlr5kv5H//+nN7s92vXZagSr8NIBR/bJuhBadXZaPcs9hlWNlK1FrCfaeuM2xBfxKGpvy7aIpY4U6CZjpcfT/Ytu52E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VvtVvuRn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746071422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eCg3VHmOtxCvew5eYi3QzhfJ1vb1uNXc4Xa6k7JPpko=;
	b=VvtVvuRnXUp04++ObLq/ENJatsQKtnlZsf/uo3WSQWZINGiYKUCRfKCGriOFtztSDo/Dfw
	QED4ZIDmRM4RRJ8nNoI3P73z1hUmjfC5TAPIXnimrxXVipznwMuXeeQxKMfAQMasxG2cj7
	tRzelyQ/5M+X095A+kBIwCEUJCnj904=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-Rk5o1aQMMze9Zx3wV1kI8Q-1; Wed, 30 Apr 2025 23:50:20 -0400
X-MC-Unique: Rk5o1aQMMze9Zx3wV1kI8Q-1
X-Mimecast-MFC-AGG-ID: Rk5o1aQMMze9Zx3wV1kI8Q_1746071420
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-af8f28f85a7so340502a12.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 20:50:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746071419; x=1746676219;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eCg3VHmOtxCvew5eYi3QzhfJ1vb1uNXc4Xa6k7JPpko=;
        b=YCCz9DMTNmFukTqcKpT7WY4NZ69tctKy3C6NgrFTUfxMJ1lY/fWxGvwHb4gZ2B7QL6
         woSXE5+T/0crjn4TtlmnruJexbCP++6FRC59x4QUZmUZSw+ft1wQ5RyeV3a0BzrbagA0
         6z1kChZivkHYwVeRXCxTkRRCUCsxJ5xMNx0YUgcjyH4FNzYfH+h6NMUuxtrQrYuhaCLF
         YlKv5LF/AIYUDJ9zzC0383pMICp+/pBy2ZWcwiAggKlmU2a/r+XLlGCei07JQItx9zmF
         hn+29BLQk3ikoMD/b1Xtgvi1pMlk5aOPG3MAu8+tKwU2hCAfUJ+sB9I754zmpjeKGrqW
         tpwQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9e1gwVC9xByA7fJzOhM6ZJNhwNUhc64ut85i6gjnCYmnw8ti5AA9zMtESZ92dKxTaG10=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5OIi0VtcaOD7ZKlPD6DMelcy8cmicGCx+z8wQRtf6MoO6RaRy
	VBGiz9waArl5aEJYOLMexQ/UVJpqNPMuPogX8gJi26H1DkfuNvXOD1UcnSIj9YSjeLUrerzxabO
	ohvTLj+DG3DbVG+vUNrB0GdwQtU4brNMd8u4QtpdXL9JalgOPJg==
X-Gm-Gg: ASbGncsDqdWmtfgMoHpjjbUWBiUssh89diEAxITlBKYSWB0r8v8TGawOs9FwjsMLi2g
	S37rb64W9XP5SawUIJLgJI4j/EJbHoTYUHJ38SiQl5FlxqmubzuJkHvR+Fmyj/md8YeuHREFyE8
	/UXLi9pd4jvL05Dc0YSIfCAkNbyB4y2dTt9KYb+T8K/2BaSWWArmeS+Bqepw+MSQvawNULrjiBD
	IEyQAP7ykM71r+TSixTb3zRw+sTlmZl08OJl+68wR5lsBfmieQb0sK3wPtfOVvYaq/6rMbgPEk+
	5JL40aYK+oZd
X-Received: by 2002:a17:902:ce82:b0:224:e33:889b with SMTP id d9443c01a7336-22e040bf632mr26267635ad.12.1746071419633;
        Wed, 30 Apr 2025 20:50:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHjGXYl1nbElt//Y7QO+1qgJyi9H/AWK7L3Z8v+0R5cqVKw1fIlymBvwS8voAmkMjppWWC63Q==
X-Received: by 2002:a17:902:ce82:b0:224:e33:889b with SMTP id d9443c01a7336-22e040bf632mr26267185ad.12.1746071419220;
        Wed, 30 Apr 2025 20:50:19 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5100c70sm130601505ad.166.2025.04.30.20.50.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 20:50:18 -0700 (PDT)
Message-ID: <b10f429b-7009-4399-966c-430ad1e02d05@redhat.com>
Date: Thu, 1 May 2025 13:50:10 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 37/43] arm64: RME: Propagate max SVE vector length from
 RMM
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-38-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-38-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> RMM provides the maximum vector length it supports for a guest in its
> feature register. Make it visible to the rest of KVM and to userspace
> via KVM_REG_ARM64_SVE_VLS.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_host.h |  2 +-
>   arch/arm64/include/asm/kvm_rme.h  |  1 +
>   arch/arm64/kvm/guest.c            |  2 +-
>   arch/arm64/kvm/reset.c            | 12 ++++++++++--
>   arch/arm64/kvm/rme.c              |  6 ++++++
>   5 files changed, 19 insertions(+), 4 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


