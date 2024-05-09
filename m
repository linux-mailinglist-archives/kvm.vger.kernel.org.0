Return-Path: <kvm+bounces-17104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BF6D8C0C97
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 10:31:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A09B11F21D57
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 08:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BF3714A09B;
	Thu,  9 May 2024 08:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TI/I403D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF4F149DF1
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 08:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715243478; cv=none; b=I0D+tyGBXpaYoFV+BedaTScc/hiSdmRahb7uSPDulPDGuN0VoApo+u9W2SSxkQN9nBm31jQTbUE7kwm5BR1Fg7Ts6Dg5RBKb/NJ+I4vZB8YDZRh81HmcyCzpAjPWmw5gGKv5llP0D0IfSCT6ty1ZcMMlRwaoLsI+OHMP5a/Eaq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715243478; c=relaxed/simple;
	bh=7ID1rToGO6FV8Ko6jC9I6odtMEZUtKX4UtvAihm9EJg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Buw/ZalAwxv5egQ4YBnCfMqinkIK5Kp4Ty+f01AtfcmBZrqOUskMPCobA0/4hYVVlLmaAw5pvzIjMOpEG7Pg/sndeto/BNuXlP80vn1+F7uCYao26FN1F3c9fR/zVyg3eTxCE5zKqcumFS3Err3gpf4gLVaDam4Xo05aE8GR+6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TI/I403D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715243475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qyLoEsP3k6nAZoTuZVbKVL9pP/BQ583fGCs2TBzayoY=;
	b=TI/I403Da1rED5cIi1oGuZqEYrexRb3XnOJMj1a53WkEIIlR2YFI+xrLhYLBN4Z/Yct9uC
	UlWm6Wk0sfG9/WkKqz5ZLAR5u6bu00Pth8F75vXoIeZBMq8ejtXYEgZIh1gdjCLn05sCau
	+U8KHmp2tR5j4TKWYwKI6iwC2PiCQbk=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-IqTdnYIFNiOmWbyc5XTIag-1; Thu, 09 May 2024 04:31:14 -0400
X-MC-Unique: IqTdnYIFNiOmWbyc5XTIag-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1ec7cb6942cso1781765ad.1
        for <kvm@vger.kernel.org>; Thu, 09 May 2024 01:31:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715243473; x=1715848273;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qyLoEsP3k6nAZoTuZVbKVL9pP/BQ583fGCs2TBzayoY=;
        b=PTB3+B8hw7Cf/WQmgCJ3izZmQR/QTtBdTWOJQqT8dBOdsCfqXjtlsrju3EaGKr/qH9
         q0U7ZMus5PKR6SpdvFgv22pMMGuFbr14GZXo8CqGl6O92UrW3QbHxTI5MJn9KcND0Qpu
         gDJCaRBR+4deHJHWvJUWpo1wfRKUpZiltHx/aJIAHImm1PnSSL+yV4qo3vWacfAAYeSi
         ytb5q/neGzI0ahkKA1N5Js8dCQ4uA3guZoxLheFuwx43SPgB+scv/YIARvMjU+q9X52y
         2lZLJ4lsKskCmnYyHL1I1c5/RT8Hqab+I/MyPek0QoDfqwdEcXlyGQ8+47cv8Uu90ggK
         LqLg==
X-Forwarded-Encrypted: i=1; AJvYcCVd0iSQjVTLUIAYKxdnlx58W/k4U6C5HDWM1O6LZhwlxIETZCs8C3PJahV3HUz8qSjV4bbBmhOaYCam6En0CC75y0TM
X-Gm-Message-State: AOJu0YyhTitKNIERGXJxeMk75xIgQw6YZIu6ZHnvaQKsuuvldWYxO7M/
	F+P2uCPNDgDcjI2qymDCGrSptQqzahdcIOJGQ6z3V77znA9iiZ8JvnhloYM0W+mv5gKqcoYaSlw
	aKM9z6xIKIWq9/Cr/TF0U+BMjE47tuxCCJhuF1z+mVqu1UjFLhV3Hr+CdDQ==
X-Received: by 2002:a17:903:32ca:b0:1e0:c91b:b950 with SMTP id d9443c01a7336-1eeb0991088mr55435995ad.5.1715243473456;
        Thu, 09 May 2024 01:31:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHy88S+twFySdt2w58Zlcx8S84DyRgcz60dnvWnGkTIvs8eX96Nen1CTdXmNnwgxjimggZ+9w==
X-Received: by 2002:a17:903:32ca:b0:1e0:c91b:b950 with SMTP id d9443c01a7336-1eeb0991088mr55435805ad.5.1715243473059;
        Thu, 09 May 2024 01:31:13 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0bad5f0esm8687155ad.67.2024.05.09.01.31.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 May 2024 01:31:12 -0700 (PDT)
Message-ID: <201ee016-9b0f-4d4a-ab85-722c3e6a1743@redhat.com>
Date: Thu, 9 May 2024 16:31:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/3] KVM: selftests: aarch64: Introduce
 pmu_event_filter_test
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>, Eric Auger <eauger@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20240409030320.182591-1-shahuang@redhat.com>
 <20240409030320.182591-3-shahuang@redhat.com>
 <acbc717e-5f7b-405b-9674-e03d315726cb@redhat.com>
 <Zjo_Yj9_dkZiQIBT@linux.dev>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <Zjo_Yj9_dkZiQIBT@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 5/7/24 22:49, Oliver Upton wrote:
> Hi,
> 
> On Tue, May 07, 2024 at 10:45:24AM +0200, Eric Auger wrote:
>> On 4/9/24 05:03, Shaoqin Huang wrote:
>>> +#define GICD_BASE_GPA	0x8000000ULL
>>> +#define GICR_BASE_GPA	0x80A0000ULL
>> in v4 Oliver suggested "Shouldn't a standardized layout of the GIC
>> frames go with the rest of the GIC stuff?"
>>
> 
> Just a heads up, commit 1505bc70f80d ("KVM: selftests: Standardise layout
> of GIC frames") will do exactly this, which is currently on /next.

Thanks for pointing this out. After this commit being merged, I can 
remove those GIC layout staff from my code.

Thanks,
Shaoqin

> 

-- 
Shaoqin


