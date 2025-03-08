Return-Path: <kvm+bounces-40479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DEAEA57C6E
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 18:39:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5725F16D23C
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 17:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 503F61E5B8C;
	Sat,  8 Mar 2025 17:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LzPw9Vml"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D7A2A8C1
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 17:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741455571; cv=none; b=mp4OqeNIAGDolVtXIz1R7cHL/KYTYB8zns0JiPeMuPnSaL4cjNMlIjmzDX9H1cZXcOYsqPTk2pNwjLE1hSGb9lKfzWjClKEodNN4/2VH88Xg6+tv7CStoTTGsz+UF8yEvhcNdfXfqYgnNyR5S5K58r8Tr7AEirCdY+vqXHaYmoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741455571; c=relaxed/simple;
	bh=Vyzes6yPodgWtepYJ0kysN1gu/bASh45vII0uVUqWg4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sd5CfIfXAwBBa9Kni+RbTUypuy20r2ziVFgjvnIdi4cTHUC1I6yjooX5KWYKnxQ1V6qRiWRjys+gRuMH6Hf3ljgApXpwvVsiiDE4dLqcuEs2Zp/Lvopoo4XtyU5kY3rOyUoWWWmQoHUXeEW+3UinYkMOCmjgLaCA5l6/UwWwbgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LzPw9Vml; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741455568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qamZfm5imeWTmF4koOCO+jppYPG1NjS3ToLxXEEU9RU=;
	b=LzPw9Vmlii7eg133US9LSgnxSK4ARffaXhw8lRigUHRaw7kTAARCa6m2SvC+rzFPDflvNC
	yfj1XbfXKaCOZFjD0s499g++61EN8nhFv0FgSoM1Cr0xZ+byGdaW6bFXcQ4fgpVz8bVknN
	8fDK9/p2VZy3wjwTmg+3eMfa/jbetQs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-wWc91Q1gP0uh4iuQ3Himcw-1; Sat, 08 Mar 2025 12:39:25 -0500
X-MC-Unique: wWc91Q1gP0uh4iuQ3Himcw-1
X-Mimecast-MFC-AGG-ID: wWc91Q1gP0uh4iuQ3Himcw_1741455564
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-39130f02631so940999f8f.2
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 09:39:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741455564; x=1742060364;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qamZfm5imeWTmF4koOCO+jppYPG1NjS3ToLxXEEU9RU=;
        b=MEo/knrcZ0ZLz5MIyIYT9sS309izoKXVh3znVf/evuEXeNWQAxBgIclEqy5M8noQQa
         3hxiAdTmp+EhIzP/wh86lYyLefix6c3i5pj5+hEEPoTUvf8+dzlo/AZvPa1Y9yhfs/oN
         TFWCRz20nVr6eVEZOcwptTOMZOMJr00WsqqcO7V0D6Fur4ZBMrGlXjSPGTAK1gB34cYi
         VqcsvkRFvVGfg0a2mB3y8rM0Pj8LhBXzBYuxvtI8oUP7cKPexEb9RJ8h5VltR2sjccF0
         ZevA25WxTyJR/iw9JlLjyL5web/p7gHu06Fx8rrwxTza3O4MhOLpIbJi/HBFjTFwo3J0
         WI2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVNSu8hk50Fq/rF5yupiwvCpIHkmSwPkzpnWOF4dFUcKaL5PlfLX8TZvaZnLML3eC8mNws=@vger.kernel.org
X-Gm-Message-State: AOJu0YxY6ETfbvdXWqTtimtPdEHh6lFf5RhyGvpiH5qSSOks3brPDmVW
	HN4FjFY6vnNDD9K4Vfc3bj0dOq7u/U8kboNo2Yt3i+gi/4yOwqLQ5jvByAyJKz5cYixBtmbv2ly
	MYZR50jRrfuSgJJU8dc0Ys7bTNbWlipZao3YYKopiRi880v2hUw==
X-Gm-Gg: ASbGncvNgGUM6Pcr7WLk7suEtZ7dt9akESLqKEmYol5uKg/H3F0g7HwvmxOCmvCcB09
	iGxT6QG+oOCvCZ7iv2UkbMwcgNfRwu4XdfWiMWasv+6a68+kEZZZt96+lqDXO+ojaRssfgMtsB9
	GqsCnEDCClxajhy/4RGdcTzjji5uCvXyJKQ3ZHFRuAdlOUUt8Je5kAOk+x830BhEnl03vNPqk5y
	SbV1h68sZBpM1QvbDjFEgRbaJGJRasgwMEIq272DHjvtoOCsKommPenGketFUJ1SGzGaYMBRsRj
	KITgv9Ffpx4FUnP2oHhcavn/f5Knv9hCEFdJMlzMAzVZ40hJ53ZGCA==
X-Received: by 2002:a05:6000:2ac:b0:390:fdba:ac7 with SMTP id ffacd0b85a97d-39132de18d6mr4678680f8f.51.1741455564363;
        Sat, 08 Mar 2025 09:39:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEuqOYO3CExg8l7ldlVJ+3eQiEPeO4WHsxPTQMi7nK/ov7zzIVSdYDkHv+lUMQxcS7ZwXMgWQ==
X-Received: by 2002:a05:6000:2ac:b0:390:fdba:ac7 with SMTP id ffacd0b85a97d-39132de18d6mr4678654f8f.51.1741455563988;
        Sat, 08 Mar 2025 09:39:23 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfba679sm9273720f8f.8.2025.03.08.09.39.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Mar 2025 09:39:22 -0800 (PST)
Message-ID: <822daee8-72b4-4012-a3b4-75543e43f847@redhat.com>
Date: Sat, 8 Mar 2025 18:39:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/14] hw/vfio/spapr: Do not include <linux/kvm.h>
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, qemu-ppc@nongnu.org,
 Thomas Huth <thuth@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 kvm@vger.kernel.org, Yi Liu <yi.l.liu@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Zhenzhong Duan <zhenzhong.duan@intel.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Peter Xu <peterx@redhat.com>, Pierrick Bouvier
 <pierrick.bouvier@linaro.org>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Eric Auger <eric.auger@redhat.com>, qemu-s390x@nongnu.org,
 Jason Herne <jjherne@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20250307180337.14811-1-philmd@linaro.org>
 <20250307180337.14811-3-philmd@linaro.org>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20250307180337.14811-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/7/25 19:03, Philippe Mathieu-Daudé wrote:
> <linux/kvm.h> is already include by "system/kvm.h" in the next line.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> ---
>   hw/vfio/spapr.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/hw/vfio/spapr.c b/hw/vfio/spapr.c
> index ad4c499eafe..9b5ad05bb1c 100644
> --- a/hw/vfio/spapr.c
> +++ b/hw/vfio/spapr.c
> @@ -11,9 +11,6 @@
>   #include "qemu/osdep.h"
>   #include <sys/ioctl.h>
>   #include <linux/vfio.h>
> -#ifdef CONFIG_KVM
> -#include <linux/kvm.h>
> -#endif
>   #include "system/kvm.h"
>   #include "exec/address-spaces.h"
>   


