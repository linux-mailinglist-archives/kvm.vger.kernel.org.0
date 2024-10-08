Return-Path: <kvm+bounces-28093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BDE9993D13
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 04:52:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 675401C23FB9
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 02:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A3E2D05E;
	Tue,  8 Oct 2024 02:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SjfzL0cf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160EC224FA
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 02:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728355942; cv=none; b=k2lq0Fk4GsatjV6uX22QPnlfsDt4V4oRKG4jVcYjlEVXf36WZlWu85kMXdkUeUL2T3FUOfNcIu72deeerClykVJ2pc1wre9UW3AkQH1z59l3OyqSuB44YLUvsy9I+w1gewi1aPRVIAd//OOGwy4yPpj/aHXbQcoPmWnzf6grQO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728355942; c=relaxed/simple;
	bh=tSvTHzhJ7hY0Co3waacqVaZp8uierrT18ii5XkgbO2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DRpYv/MuVczMSpW6HjZdsckBeQHVap0AfDDIw3L/XNxj/xqM7ntdXOCgt7O+7ZKZeY4oGGM0v/gT3XvuCqs/VmyM8HRUgfpqHzKA6jDctDKbvJJ5khNPwloFmRM4Ajtx3p+rkNa4JkpEn20EDZ9zf2OqgYEQMCuwsN31kY9m4ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SjfzL0cf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728355940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=411PCtmrgkUidrOIqeQapBevB2yXfvIcGC2vMMOYdOE=;
	b=SjfzL0cfXp8iufKgalliKm4hQvb2MI+ledmJgi4rlRyP7K46+sx/jMzWW8WCLCvbEmQoUx
	TWa8FpDe7oszxSl8tXbeFp6Fd8O0+l4noMTNRghp7cTA9R21M4MYD4uEGPKuZ4wF4wjECl
	0l/LAVh43NdTcIj/ZWezWYlmEre3tyA=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-EQyU4oDuPnO4kS86wMpdHg-1; Mon, 07 Oct 2024 22:52:18 -0400
X-MC-Unique: EQyU4oDuPnO4kS86wMpdHg-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-7ea00becea0so2858014a12.2
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2024 19:52:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728355937; x=1728960737;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=411PCtmrgkUidrOIqeQapBevB2yXfvIcGC2vMMOYdOE=;
        b=cV+SPdCAK81H34MG4wzXABzXmnNiN1KtVo9y6VkfSURCtRiLXMDuFNe+oysaWDfDic
         j3e9M4iOcBZBMI+SgMVITaqN614EhyKUd3+XwyEpa6TBHhELiXwGJJSjoVoyX8LJQgMh
         9yIIp4hqf+wgp7kXCHYyIUadsyH+6GvdeY392VtB1rAUYzHqtsG0mjy6c+M13viP528V
         +ZrLKN18zt0PaO0IDhxU+A0j87+uPCfFT3DTSHPwPBTYOHxMwpNURcpA2/KG3y5JQeaR
         xv6xnJrC9AE2Y2byfm3qCFw1+xp5H3297Y0NlKkdiTlFQ6dtYf0gIQyjOf98YPvQKQ6Z
         RSzA==
X-Forwarded-Encrypted: i=1; AJvYcCUYFj9YANOlPgZmX3UpOsOgfI4zgG1ym7yC11RTcAtbIdEUPL9gBZi1dvqucjgmgmqpSeU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw3D1vU3XOE4yO+VLhCg/sV0/eQ/URaLumFk00ovrO4vpKHwaz
	EkIzN/KM2ndHsf/6i+3CHiEiXoYdBze6dTWa3KWDo/PiFnqjYf+gIh14eboYMVyGcjcYMqQ9ysO
	L2uI438E9HM6mwcQeXLBrPUZuN9MW1dff2F8n/ZxKX7X5JKEPag==
X-Received: by 2002:a05:6a21:a24c:b0:1cf:3d14:6921 with SMTP id adf61e73a8af0-1d6dfabc386mr1247887637.35.1728355937668;
        Mon, 07 Oct 2024 19:52:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENsa/q7SoMe551s0e4cZsDtqunjGqFm6PflV4U0LuYkndGEcrIqyHC1aiUGs/dtevm0SUCUA==
X-Received: by 2002:a05:6a21:a24c:b0:1cf:3d14:6921 with SMTP id adf61e73a8af0-1d6dfabc386mr1247865637.35.1728355937364;
        Mon, 07 Oct 2024 19:52:17 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0cd2a1bsm5112671b3a.85.2024.10.07.19.52.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 19:52:16 -0700 (PDT)
Message-ID: <85192743-4bb0-41bb-8ac6-6965cb149307@redhat.com>
Date: Tue, 8 Oct 2024 12:52:08 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/11] arm64: mm: Avoid TLBI when marking pages as
 valid
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
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-9-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004144307.66199-9-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/24 12:43 AM, Steven Price wrote:
> When __change_memory_common() is purely setting the valid bit on a PTE
> (e.g. via the set_memory_valid() call) there is no need for a TLBI as
> either the entry isn't changing (the valid bit was already set) or the
> entry was invalid and so should not have been cached in the TLB.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> v4: New patch
> ---
>   arch/arm64/mm/pageattr.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


