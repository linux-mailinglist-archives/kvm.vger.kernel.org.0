Return-Path: <kvm+bounces-40680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3E6EA599E2
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:24:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4166D3A8464
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 15:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34E6A22D7A5;
	Mon, 10 Mar 2025 15:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jQSY3rl6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7A622D4FB
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 15:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741620221; cv=none; b=fYXPRP2FmFDAGt6G3TiRAr63QdN1lX4YNA6J4U6mybyM/pwqrleiEL423L90+hSoyzu/VnS2UoFnHz3ve24vj25egCLPVEwr30Xy4W813kmi4a/AGqPqxsqP+Lm5unldlaRCpeLstNsSyToD/56gUYr5Op+G1eBWK8VarYjLu+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741620221; c=relaxed/simple;
	bh=S51klFXzfa8/MgXTS68BlT/U3NNG1Mmz1Pv81XkhDMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t/b1ImwKYjaHX7kKL64dnkRx7ko8gN0PnC1SLayxwosuTu5Mp+P7TYpcyuGx2kvrTNQnNJ0tHZjZhnWt9bQ3mejz3FazTikVXiN3KJc+Sv4sbGt0+n13j1DYcJfUedyHVqv51p5RVKYmyLQ8kJcL3NSImzg4i58ueJY4iB8BLgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jQSY3rl6; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43cfb6e9031so10743335e9.0
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741620218; x=1742225018; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IBr75c6ytYUhwEvF7FkBd0CgtESgZ7S9ZWDGt+QgV04=;
        b=jQSY3rl6gQ7mC/YzHOnAVvBaO9RJu1rW6Ynrd/7Yef3Bh7ZfONQN5JwxQNAGdjCayZ
         KgMEOhgHqNfVnSzBgfci4cqqrBPn4m//FX1n+0E2y3AHMZFoJzwt/tjo3WGvuwwnqj9f
         azKoWu9eiALaU57Kn+O2fu6wr2D7j0QHV26vk97N4QZe2dcsVU5yM7Ezqffw/3eJsN1a
         GEzDz/g4k3bEVFqgHDOBw0wkz5gOrvovM2rOEgAsd4z3NdWp4v+xQG8KjfIFxfPHAzJG
         FMgF9agKWP1QLvSwPbZRBCifQq+SQeiS3OMMQqn5MATbPAqwmlRQuDo1ymfgaRAMvVgD
         LmoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741620218; x=1742225018;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IBr75c6ytYUhwEvF7FkBd0CgtESgZ7S9ZWDGt+QgV04=;
        b=q1v9tNuA469vsSI3GE40XEFkpsvTvx0nxL0LLY1/OBi8OQQZTllaKTPnCZLcjIJqyl
         Wmh2h/ndP9jrAmbwktdmdmjQmPx0v1d8gfwZ1zX4qp0h7iar7yst2X6AJJ7aLyST4QfM
         keKvmu3Qgz5Df27873b/yW/Ld6ksQZLjYqC50ru8OmT/eA7Qy+85pijnAuev2PzCuXY1
         czCmZkMWHF4t0Tp3tXAKqHvlbxdiQI/RVMOd66AFAUSY/PhccSAFMsUrUrDpc7xZqOGE
         S//jzKU0TizU5eWl5bjuZssnbR1omEw/RAOzAVZKHodkd2CY0LKzxRXJgo2/tHm+frKe
         7MGg==
X-Forwarded-Encrypted: i=1; AJvYcCUMTm63YHBWeOLkQzs046sygALFTxlz0WNZgOfvyQg2+b0vjLtScukiqLdQy/jX7GXaUyk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyllhkO9ce3m8oQquXoY41mYgopKHwMiivwI4X8RBSdppAMYCNn
	A1DHFxeVsEA99SOHS9mACf4zp+M7mK4biyrMl5XXr69KR6ifodKcWtkuuFwuZps=
X-Gm-Gg: ASbGnctV2iAM7AfVtQJCWU6+pj5/g2Vlhm6GvNLrPlPragSz8XQM8cRzN3vZ/wwf7bQ
	P0RG3l/Gkn4moET7ngW6M2bjgq89ReZhLd0HGLoycDx5fT/GhxCDn2JZgCr4/vGrXL6T2dhUf5k
	0+xQ7I29605uP368fmbv7KjW3zl+taDA0r/6GERUhE0Ppi8TwSF8ZHlLgKzGGOpp1Ipp1s9Vh3M
	8LaH6A9VhSEV1m2txoN6G3P3ZzAPBF+FzwmUmbYyqA9vsHjnS3XtLYr5P31584EmmLXCQjSE+rO
	lhtycm/mqRrQRBEHg6pNUlfvhOZ51YJUmypXB2epG2jon52ikLM+MPfSErcBesk32PkasPpBnK8
	DRsFlgUVVh5rSDHFR6GCDFEA=
X-Google-Smtp-Source: AGHT+IHAV10499kmP8yqAIvnYFZpY+88ERj2RcF7X5uZrwnaq9soz6c1PpTRcxcyvgnk2ZNi6F0Kyw==
X-Received: by 2002:a05:600c:1c1e:b0:43c:fc00:f94f with SMTP id 5b1f17b1804b1-43cfc00fb6dmr26978915e9.23.1741620217533;
        Mon, 10 Mar 2025 08:23:37 -0700 (PDT)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c0e2bb7sm15441920f8f.63.2025.03.10.08.23.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 08:23:36 -0700 (PDT)
Message-ID: <13c7e4c3-d5d6-4b56-9d6e-cec50727d3a7@linaro.org>
Date: Mon, 10 Mar 2025 16:23:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/21] hw/vfio/igd: Check CONFIG_VFIO_IGD at runtime
 using vfio_igd_builtin()
To: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>, qemu-devel@nongnu.org
Cc: Yi Liu <yi.l.liu@intel.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Halil Pasic <pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Tomita Moeko
 <tomitamoeko@gmail.com>, qemu-ppc@nongnu.org,
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
 <8f62d7ac-7109-4975-84a2-4a7fa345dd74@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <8f62d7ac-7109-4975-84a2-4a7fa345dd74@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/3/25 14:51, Cédric Le Goater wrote:
> On 3/10/25 14:43, Philippe Mathieu-Daudé wrote:
>> On 10/3/25 08:37, Cédric Le Goater wrote:
>>> On 3/9/25 00:09, Philippe Mathieu-Daudé wrote:
>>>> Convert the compile time check on the CONFIG_VFIO_IGD definition
>>>> by a runtime one by calling vfio_igd_builtin(), which check
>>>> whether VFIO_IGD is built in a qemu-system binary.
>>>>
>>>> Add stubs to avoid when VFIO_IGD is not built in:
>>>
>>> I thought we were trying to avoid stubs in QEMU build. Did that change ?
>>
>> Hmm so you want remove the VFIO_IGD Kconfig symbol and have it always
>> builtin with VFIO. It might make sense for quirks, since vfio_realize()
>> already checks for the VFIO_FEATURE_ENABLE_IGD_OPREGION feature.
> 
> I have explored this option in the past and it's much more work.
> Stubs are fine IMO, if we can have them, but I remember someone
> telling me (you ?) that we were trying to remove them.

We shouldn't have target-specific stubs.
(currently CONFIG_DEVICES::VFIO_IGD is target specific).

I don't think we can avoid host-specific stubs.

In unified binary, CONFIG_DEVICES disappears, VFIO_IGD
will be handled like host configuration. Although if possible I'd
rather remove VFIO_IGD, unconditionally including all quirks.

