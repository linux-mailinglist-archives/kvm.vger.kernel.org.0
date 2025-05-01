Return-Path: <kvm+bounces-45018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E82CAA59D7
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 05:01:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A27B3B578F
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 03:01:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E0DA230BD2;
	Thu,  1 May 2025 03:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eBlTkvzd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5328C70805
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 03:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746068481; cv=none; b=dP0F/L/dDmdAXQdT1WFG33Kc6qPq4Oq3DLBpT7F3cSdo+Xlq7b5k09drdgxso/ivXkHsC2xiMWnMfFL3wMGmSleDDAjJBVEoIv33ftfQsZZ1ESAeJvMeHa+wmPFQwf/qgZbhsLfXdiINdqBFHmFU+4+AgnitZ9cFghxTVTg+LAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746068481; c=relaxed/simple;
	bh=/ptZbSFI9sOT2FDVpzMMrJrZJtXi7a7ktLAYSxgGEAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EgnIFSXkVsKXsUfUPd6G2nFG0f7SRb2E/FREdl/FmAkQ/X+ewEnAwp30SFcYpUqixICTgZtcZcgUyqmmL7FX8F5GB/jjQWPpbfMIq27iMLfyLb0yNnlWWg+W+qGPsiHuUSSfUrvQQvIjlzyQbTXA1MKTjqscLH9CmDglg+9yDqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eBlTkvzd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746068479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=66PeGHTOpdnar+Qa0JWdL51yAJjG/0kQaEukyiMWp3k=;
	b=eBlTkvzd4fSvfJwoJjEQEP9T2PzYlrwC+OBQhRsKRVYoX9zbWOZJgzCaqNTuf4uSv/ZI8r
	yNOeX56lcYmqjAVZFPECdnjWvfkF9DJl368+j8S7ZkUhzrOKJ45m5ZPyE8pQ06MbkvlB6k
	qNoUJqjQ9Mxufvv2SwVji/+R9WeksoY=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-M88ssE_OMLSGNQ1MbrmUAg-1; Wed, 30 Apr 2025 23:01:17 -0400
X-MC-Unique: M88ssE_OMLSGNQ1MbrmUAg-1
X-Mimecast-MFC-AGG-ID: M88ssE_OMLSGNQ1MbrmUAg_1746068476
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b1f8d149911so216266a12.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 20:01:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746068475; x=1746673275;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=66PeGHTOpdnar+Qa0JWdL51yAJjG/0kQaEukyiMWp3k=;
        b=BMnpfp2xWpqKRiKURR28tmkWKTFeEwaeiIfAu6kDQ9C5BFXhx0DHtepMLaSP8YbDt/
         nC/8D7Ijnq1YWrxChs18ipam6/RLUTrrf6rsz2soezo7PUl6g38wJpz5vJDwnHFLkKk1
         jJSp9F1IPWN35dawgskUuBBZi4TCOyuAM/QYDauskU6eCMDdcIEXI5Y7EP+s5FxL9gXz
         fCr+TLF53UrcC48ZkPIHbsoInbUYAmVuENGUjSHS02UE8Hhv946yVeNVoC0k44WfDvh9
         VlTkSQU+cfq0JC1jj9X0QJJwtGUQ8ZSSydEQ1pN2ojQLs3HQAKz/GAg+ogKJqO7RDq+p
         Y3zg==
X-Forwarded-Encrypted: i=1; AJvYcCVWva+08lYxQWWQTA7akQ6Y1p0O5kmXMXQQomV8LSAE41mLbRU5xqiqXPk75KozUHOL9gU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxoekef5FqyLrxlSgiDKx1k9+quDRWILog4zWAAd8aUjFlpbMyB
	8JUOYjEJijjmzt4p7wOrnkN59ElHImWea+Dsr5mA6Mm8a7MFP4vr4XatppDAioY+OX5bu/I21oz
	J7sC4r+m4zVX00oYybLvZZTtO0nzlYBcZriBMPHg3RO1i1GafwYOducCBrA==
X-Gm-Gg: ASbGncsXeAhB5poJLy9U5/F7RqPoc1c7tspu6eu1wtihwyA5jgxxHZox/B0/1smQ1sR
	HhFhBZ7DmTEjVAZcr96WPD7KJUF28/NWhOYfmQ7ZAOhoi4lQXRzZbc4s8QWDMnePyiIbxXCkuqU
	uFWFJIrhT56u9PWfxG2eFO3mLW1t26v15/hAQ/FDxzFVD+k34JSdZJKa++VrXjvTQwCr4bgsGQR
	o6/azKih9Hm6rU7vddR/Tnz4qS998THAuhHX0epOlXrCRYQccG5MOQgZ40mHjexlIBb1WyRsg/F
	6tBhCFjYRw0L
X-Received: by 2002:a17:903:3c4c:b0:224:256e:5e3f with SMTP id d9443c01a7336-22e040c6e79mr22292945ad.25.1746068475342;
        Wed, 30 Apr 2025 20:01:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZAaGsqWilNG9nKIQwO6WjMhMxoDtCPFtqO+KYQXEgWxu5s0tu5Q6Ot3OxM8Xca9EYb2dyqQ==
X-Received: by 2002:a17:903:3c4c:b0:224:256e:5e3f with SMTP id d9443c01a7336-22e040c6e79mr22292615ad.25.1746068475064;
        Wed, 30 Apr 2025 20:01:15 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e0a243e82sm766515ad.2.2025.04.30.20.01.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 20:01:14 -0700 (PDT)
Message-ID: <fd1936c7-cc82-4dd9-9bc0-2b25a3bbbb91@redhat.com>
Date: Thu, 1 May 2025 13:01:06 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 33/43] arm64: RME: Hide KVM_CAP_READONLY_MEM for realm
 guests
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
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-34-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-34-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> For protected memory read only isn't supported by the RMM. While it may
> be possible to support read only for unprotected memory, this isn't
> supported at the present time.
> 
> Note that this does mean that ROM (or flash) data cannot be emulated
> correctly by the VMM as the stage 2 mappings are either always
> read/write or are trapped as MMIO (so don't support operations where the
> syndrome information doesn't allow emulation, e.g. load/store pair).
> 
> This restriction can be lifted in the future by allowing the stage 2
> mappings to be made read only.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v7:
>   * Updated commit message to spell out the impact on ROM/flash
>     emulation.
> ---
>   arch/arm64/kvm/arm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


