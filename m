Return-Path: <kvm+bounces-40678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 986D6A599B6
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:20:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCB9F3AB499
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 15:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36DE822D7A8;
	Mon, 10 Mar 2025 15:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZyaYNf4w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E11E22B584
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 15:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741619832; cv=none; b=B32uSSNlq0sNQ9/DkbLYTO2aFvJC7VpwQVBsqlDV8gKpyuRKqdB+g6NFoFuhuKYN07VqCc5SDBl/7/qs98pM3qzecsIhQ+wfUPYRmr7e3Pg16ytVUiY7R9hqIr/GCgDcnpveBPzF7z9WJfu9okWo47SWAsolY/dNMZ1SwWdfpcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741619832; c=relaxed/simple;
	bh=fYz1a4PjX7SP8UGBh/6PKCi0p5uGjpFD7+PkVtYlRE4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pbOLmh85yaKq/tiNoE/A1VxsojtengLBhEYmerJZmmVxzIpcW40Qxuu2+SiyvvtO3ygbjROCgMCGmaMWj5W9pvwjJonKlJ45buuqkmx/vyKNVWvBqE7JGyJOCighHlrhF4P2Fhv8WwS5fcI7edrqXJ+YZ2BezhZGXf+C2J72efs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZyaYNf4w; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2239c066347so75014135ad.2
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741619829; x=1742224629; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9hRR9eFzKTibA6SanHS7Z7NacsATBx5TBcKCL5oIsCc=;
        b=ZyaYNf4wZivXeOAiR1u//d5fWMgZDlSZhY9GK0w5oznr5H/HnyBAkczWra4nGfWSwa
         Qxz4gnwG/ZIaWy+FL3ZENAidauS27UiOS4kVw8FOimuiszTPHAMHUAGNo8bEUOPdildq
         yAOsxviBg9LTCUF2wFee9TqP+eXR7CcLHH/9j2WjAIg+TTMBZRKILi9T9bcponsMDehN
         W4QP901GkphXvnkAAlWY1MFR/a5o91K3YoENIBUxzZrGP33pjcdK4TxvhPJLnCEH4Vc9
         k9pfj/UbumQtbBrXuX+dOPG9MemP+EmDRsdP8upXTxypEbJDady70C2zYZhswktGq+S0
         5Fgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741619829; x=1742224629;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9hRR9eFzKTibA6SanHS7Z7NacsATBx5TBcKCL5oIsCc=;
        b=WwUmM6Z6wB5Ai/WvwSoBH60swYi0QZP8h9rzwk0PJx/zcHRboNxqT3Uw0qxAmAgEF9
         lLDWKKHJuzW/eD4eKJ3NOTE4jcwmDXB9Eb0GEZ1qUTnomWx1Ff50kEC0wZYVMAEu8Qq4
         Hq+hMHxYVLIx4pqN+7ncRm28IAE5mCPlCjkRjRSbJCulgz8RYFzdq3+xwsEy8i39jwLY
         k/ot1fhgjCAOa6TeZlAiXL63Yc7SDEs3nFav2NVwOe4rV9lFLugDkJVDCkIkhI98qyV5
         mly6XqfOVz94VqIo33+c5XbOX84YZQfLpSNOrRdczNwkDZRf/Lvlsnkrh7VvJYY/ojhY
         KTHg==
X-Forwarded-Encrypted: i=1; AJvYcCWWrNktIi45UF5nTmKkSiDc8oe5v7kv4x5K6hJyyRjDVoHZ9o2Z+dv+QQAYSG3hyJnYaiU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVo6EQDf1V7J0bd/imzW62P54GH349xiUY9HNCD4VO5chy8ETN
	R4O0GhhVYyUnulEVNJKc3pFkNQs5ZOBd84Z2hX99PCtbATCOYJw=
X-Gm-Gg: ASbGncs1iE773rEqg/p57fnvG364X5jcSmZa8/uR2Yp6HRQ1XpFtpney14pU55jEw7n
	AfmBYPVmio4A7krjRiLytvT6J5mPPAUqIBkVz9m3ZMmn9b10ES9NLaO7cFLmnu3InaSdV0szGWV
	sXYzhIEzmMLlliXDYedun9SbpG6Jb05AKswBa+t6zbsEyAN0TJSfOes4k1IurSkZu8Lttz5V1Do
	L8d0LsjptCpCmGmD4hU2UPYsdSlw7oHh6D4+521Vp5JRf3vzVVYsIuo1skmUsVb4wkIlMD61VXQ
	fJTdbTDQ9BjzvxoJnFXcHaHVLd2SOe/RmBz1sPGWdATBK2eR
X-Google-Smtp-Source: AGHT+IGoPEqYRu6kEb6iHvvB5lodkJM7ycEzmRHAEsrCpUaTNhIDOTfpdN//UjZ7KzKlSQrUCMm6Wg==
X-Received: by 2002:a17:902:e80a:b0:223:f408:c3f8 with SMTP id d9443c01a7336-22428897491mr261740075ad.14.1741619829297;
        Mon, 10 Mar 2025 08:17:09 -0700 (PDT)
Received: from [192.168.0.113] ([58.38.42.149])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410ac0794sm79129765ad.259.2025.03.10.08.17.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 08:17:08 -0700 (PDT)
Message-ID: <324d8b90-198b-40df-bd91-02cda9443e94@gmail.com>
Date: Mon, 10 Mar 2025 23:16:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/21] hw/vfio/igd: Check CONFIG_VFIO_IGD at runtime
 using vfio_igd_builtin()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>, qemu-devel@nongnu.org
Cc: Yi Liu <yi.l.liu@intel.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Halil Pasic <pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Eric Farman <farman@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>,
 Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
 Zhenzhong Duan <zhenzhong.duan@intel.com>, qemu-s390x@nongnu.org,
 Eric Auger <eric.auger@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
 <20250308230917.18907-13-philmd@linaro.org>
 <415339c1-8f83-4059-949e-63ef0c28b4b9@redhat.com>
 <7fc9e684-d677-4ae6-addb-9983f74166b3@linaro.org>
Content-Language: en-US
From: Tomita Moeko <tomitamoeko@gmail.com>
In-Reply-To: <7fc9e684-d677-4ae6-addb-9983f74166b3@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/10/25 21:43, Philippe Mathieu-Daudé wrote:
> On 10/3/25 08:37, Cédric Le Goater wrote:
>> On 3/9/25 00:09, Philippe Mathieu-Daudé wrote:
>>> Convert the compile time check on the CONFIG_VFIO_IGD definition
>>> by a runtime one by calling vfio_igd_builtin(), which check
>>> whether VFIO_IGD is built in a qemu-system binary.
>>>
>>> Add stubs to avoid when VFIO_IGD is not built in:
>>
>> I thought we were trying to avoid stubs in QEMU build. Did that change ?
> 
> Hmm so you want remove the VFIO_IGD Kconfig symbol and have it always
> builtin with VFIO. It might make sense for quirks, since vfio_realize()
> already checks for the VFIO_FEATURE_ENABLE_IGD_OPREGION feature.
> 
> I'll see if there aren't other implications I missed.
> 
> Thanks,
> 
> Phil.

I personally suggest keeping the VFIO_IGD Kconfig symbol to prevent
building IGD-specific code into non x86 target. The change Cedric
mentioned in another reply [1] moves VFIO_FEATURE_ENABLE_IGD_OPREGION
from vfio_realize() to igd.c.

[1] https://lore.kernel.org/qemu-devel/20250306180131.32970-1-tomitamoeko@gmail.com/

Thanks,
Moeko

