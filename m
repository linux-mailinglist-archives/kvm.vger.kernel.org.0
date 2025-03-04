Return-Path: <kvm+bounces-40097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CEFCA4F1BE
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 00:47:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 576197A49BA
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 23:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08CCA2780FD;
	Tue,  4 Mar 2025 23:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QLlzSB8r"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA3C1F3FC6
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 23:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741132016; cv=none; b=AEHiIE5C72Uv+8dX1w3ClxyyqTWTfjbqcGaebE+CpA6IeQqmv6BgFlSxHawE5Ahce9+xjqF4eNvNLmhX8MbVKNbmotVAahqXNXTpB7vvkaRJZFirl361z62V8PalCbQRWuB32OMhionRAsiQbAJQ1eCuJp7+Yao5vJTVeD13NZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741132016; c=relaxed/simple;
	bh=0vaMK1EzqAclihJeDZxRkFMmTm4waXR3LR9AN19QWDg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DIMwfIfyFjlRXFpfxS8xWPsXh3v5VJCP+OfWGzwTbhTeQ3Yj+5t7i4EJ1XRh3+oqz+7T6zL4+2mpSUMq8wIyExLyiV9ePmeI4Ue5wJab6/xd+i/LJmhKWWqHjFYZqX4qAOS52crFw+NcWD5di8Z7OCRK/QGQIVV5rqHJcTJbMtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QLlzSB8r; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741132013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g6FYqCr6QwRqz7j744DqHTGMlLhF5qSIjaDfjqoangk=;
	b=QLlzSB8rgXR0/UpCMdkAimuZLuVx1q8B8dAu5zp/zvV6xHXNQl9CNGjQtNOJROJQKDop/s
	hUBL89VP5hS+nNBt+zY0aa8Wmf94sXOcz0W4bJFOLIH5GVLr7Vrkcua6ih13LIIUoF6UBy
	tgpnfeoa+v18rzNPQ69R2UhxcK7Td38=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-g1KwAtnAPca8vXhI68A2BQ-1; Tue, 04 Mar 2025 18:46:42 -0500
X-MC-Unique: g1KwAtnAPca8vXhI68A2BQ-1
X-Mimecast-MFC-AGG-ID: g1KwAtnAPca8vXhI68A2BQ_1741132001
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-22366901375so5959545ad.0
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 15:46:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741132001; x=1741736801;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g6FYqCr6QwRqz7j744DqHTGMlLhF5qSIjaDfjqoangk=;
        b=NEzARFDYl1L+sP1YstZLIRwx/EcRJoBGzQUDKC20xfhvKK3rY9EZ7PpKB4OL3gQzqw
         EZaIw/bSXlHWwRIE/BlVnTM/HVPoNZLvV8SKKAwZSoz/bKIJNCus8eeZbphPTZfs/EmM
         AlzkGY0FVcSrG0mSBT0AzKh1aWyF9h3OFmAf3KFsXIWz0AOWmSpjy3+i7xQvuk/5jP80
         ruwfzuC+96BAPRh5yvUpG72GjdAyZEUODqcuGK7BSTtxxHmOGCJe7cR2OK3qvBHyFa0l
         /uLfO5aU/QYA3nWs+OyXCXgGB7H5MY50Tmn0tb32QfNlVZfA1TBiobhAd94CxQCqWZoJ
         63Cw==
X-Forwarded-Encrypted: i=1; AJvYcCXAAtqffjKFLbyZryrvCvkfW7dvX+l5ZU+ApP/BpHT10LQptsnYp7o/d3CIh4MAenJOKLg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3n97olbSmgaBDfyMt8KMXgKcma58g2odw1n5pipKwE0eBTcqc
	KxTWugL+DLOLMD7QnNprjV3iFbiTbcWZQfPsqOHqFeNkqmKvha3AQYwFDQtIYqqMnYj11Jv/nNt
	JHyEZbLud+rNsD24J6vJ/J902O8gN761x7kGVR+T7a3/D9PKvAQ==
X-Gm-Gg: ASbGnct1B7S/3JlIx13ZQzlpwIrLyoTog57XSC+5fGgRB5QjZymvTebbV5YE88NEnmb
	5dB37quHb0ZUghJTyCGe9RDT4j2/dqvDhBl9n3HjW82isZSCxbfJY/AtqcZVbgx8MujFjCUM+2x
	jSAuQYOeLDtnc8Zj0e819RLKoGOr8jaSlC3DE9WP5GbmuvYA9c25xOylGvQwKxCTpnd+y2OVkGX
	XjOAx+MLv27BcAaHjn93DPsAisy9o26xZzZLj2S8bTsFGPW5DqWsOYQbVEYKsrq3xuaNePv15O2
	lIBuaa0pndatz74=
X-Received: by 2002:a05:6a00:139c:b0:730:9637:b2ff with SMTP id d2e1a72fcca58-73681ea12f8mr1622601b3a.7.1741132001106;
        Tue, 04 Mar 2025 15:46:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEi8JMyb0mWMUpD1PTtuv+YTTWcm/STeWKBdnRr6BiZi8G3Jvspyz2BgiTf4N+sfAjC+o/22Q==
X-Received: by 2002:a05:6a00:139c:b0:730:9637:b2ff with SMTP id d2e1a72fcca58-73681ea12f8mr1622559b3a.7.1741132000737;
        Tue, 04 Mar 2025 15:46:40 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7363f2e8a34sm6324254b3a.168.2025.03.04.15.46.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 15:46:40 -0800 (PST)
Message-ID: <f331382f-5747-4837-ae60-42e9cb37ecd4@redhat.com>
Date: Wed, 5 Mar 2025 09:46:31 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 36/45] arm64: RME: Set breakpoint parameters through
 SET_ONE_REG
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
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-37-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-37-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Allow userspace to configure the number of breakpoints and watchpoints
> of a Realm VM through KVM_SET_ONE_REG ID_AA64DFR0_EL1.
> 
> The KVM sys_reg handler checks the user value against the maximum value
> given by RMM (arm64_check_features() gets it from the
> read_sanitised_id_aa64dfr0_el1() reset handler).
> 
> Userspace discovers that it can write these fields by issuing a
> KVM_ARM_GET_REG_WRITABLE_MASKS ioctl.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/guest.c    |  2 ++
>   arch/arm64/kvm/rme.c      |  3 +++
>   arch/arm64/kvm/sys_regs.c | 17 +++++++++++------
>   3 files changed, 16 insertions(+), 6 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


