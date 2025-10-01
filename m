Return-Path: <kvm+bounces-59268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 87209BAF9B2
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:25:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32C86164B0B
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C991280024;
	Wed,  1 Oct 2025 08:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fPXaNXyb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCAA25771
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759307129; cv=none; b=V712JsTUkz1L1/CzaPfZZgqorn6PlccP7KFTDQX14HWmy2Z2+5b8TvzIpgglm790RlzVQ9aANxwcdjn+52/tGqxDd6buDgy1uznUosfsQADl4GCNCkLvN65EvKmjTimaptOqQf7S1USKgxGaMzE+cIjaDoik/oWXa7YuXF5w7LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759307129; c=relaxed/simple;
	bh=pno8Y4ggsbUeVVXqp1ylUTrLLkK4sRS1P00tmgxSBbY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rGta0clCsub0rKXvDGO7cOCF9NSBZtZbXmh7ABG2HJvixC8G1r6xPK/by1kbSkWe5z2lqFTbA1iWvvv1EMdNvwy0jccFVuf9gqUpDe1oju2dBdsCKcdOsPS4blZcHMpGH9GfAjQ8R79jWYJBzDgCSO7cS4sa+Eo252jWPNnjYj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fPXaNXyb; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45b4d89217aso45583005e9.2
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759307126; x=1759911926; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3q5iaS9tln87d74VeEF3Gfdu85ykgDy7G0fLQJRBnqE=;
        b=fPXaNXybIkynrwnY0S8X6ydIQqTbjNfagm4CF5pHR1iiluLA586KI3rWJth18iUVJS
         qMtidhSu4tsS+iDNyAeN01zBn6XjpqeslAprGNKkEcKNGUWe2ZSb9uBt+heVDiXMqF9o
         +QVZBso7yNCGiXD+aKNzqBawqNeijYwOoqIlvoNcvXqlulqZ2rze5vZZIpn2LAmNbc3W
         O3cnLuI0EBTfGmlorj89MHL7lrz0dZ2kIeO1ghfiHsVca3SyORpBtyPebn8o+JZOHB2W
         7O0sErGMOEAJe4lRFRvYVNnKnxc3OpZXjbW9Av5cz7+Yj2Hg2doilgb9bBPS6vax2r/Z
         1/3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759307126; x=1759911926;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3q5iaS9tln87d74VeEF3Gfdu85ykgDy7G0fLQJRBnqE=;
        b=qs4PlKsSp6ncAQiI0NNOXkmvG6gFH/uk5wvcoSjctoJoKEpeeqegkKCnYAgYb4Jp9o
         u1kzUngUtgASd2ioRebBWjngRyPkwtax4XTubjUzr0tgmHwyT6iTIi4Ya62iYOqgiI8H
         LjKOnYX6HYl02Vlv5AxL0KCUGd5IwQD22QL1MSxJ0ppoGFu3+IjhpJcwENtDkUjBlKeR
         VO4YhFQENzHo7GmhTFNgHuTqYjZAin6/ZUkc4Vq/E5WY2N57ZiXR7yM6ATnRD8+nfa3S
         KfXfjYkg//XtSJKPdiXbO346DFkmv7nT44obCAYHTPa/y/RGoWv2d+0/wyeb+4AKzkyP
         +jpw==
X-Forwarded-Encrypted: i=1; AJvYcCXOv9yQUU0N1N0MEfkil6G4U6gSyFXnuN1vOGNAkUJ9fhw4UKZraQgFkXLFWwNKcy9Pb9k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsHISb6K6ZRvKDfnUlaR+aOS+g7ze5gsKAInbTB7LYO7hbTAWo
	Hqrd8qHB8N1QzJXH9pwhXJ+q2Y5jARw1g7Oyyzwmey3Iq1Adoas3L5ZQJ8ytaNFjKxc=
X-Gm-Gg: ASbGncvmAuAAQdLNXp36Ys5OSSuSIPXU6OkpJ0+gfgyNEYtMtT05WW3KL/ZVixfIp1O
	7tKuBtra8yf3ivlvjbB0w+dW0UOySnv7BOo6c+go/DWyG0fgN4uMcWXFlwVvQ6xKzag7nY5LIj1
	NhQ9T1F8BKIEny12tgnASpc3TeL8AeTqTq4Gt4ihzFSvg7p6WWO2MsG6uxr2BrMS7OYt40TUxQ6
	LgVd3ptILMOYDfTy1NP5mt345p7hGqRug5aHEBgs/p9JW2nzDeBhEoU80/wko3saRp8lVWruQva
	QU3w2T7ZmWYOFCX1sNynMerLUg0ZIbabqJbc59w9h+dQHbqwIL2zQOvaaKpnzbaqFL/pivbeayv
	WFIDHE7i94Y9whTOK5CKevcSetb5UbepwAEHkVkw61HL8YKGhbewNQByEjFAvHjjdfY2mcpMB07
	zuxrQjXKXgOwyukg==
X-Google-Smtp-Source: AGHT+IEZAHf/wHARZpDbZ993bwutM8qvOrkRXrkInJUiDKq1+IE0zn6/NvpDfqgLgXAg/Kd3uTTtKA==
X-Received: by 2002:a05:600c:8b84:b0:46e:53cb:9e7f with SMTP id 5b1f17b1804b1-46e6126a722mr20289285e9.18.1759307125709;
        Wed, 01 Oct 2025 01:25:25 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e6199fc34sm31732475e9.8.2025.10.01.01.25.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 01:25:25 -0700 (PDT)
Message-ID: <ef4baceb-671f-4afe-8a41-cafb89ea1707@linaro.org>
Date: Wed, 1 Oct 2025 10:25:23 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/25] system/physmem: Extract API out of
 'system/ram_addr.h' header
Content-Language: en-US
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Nicholas Piggin
 <npiggin@gmail.com>, Elena Ufimtseva <elena.ufimtseva@oracle.com>,
 qemu-arm@nongnu.org, Jagannathan Raman <jag.raman@oracle.com>,
 David Hildenbrand <david@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Jason Herne
 <jjherne@linux.ibm.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
 kvm@vger.kernel.org, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>,
 Peter Maydell <peter.maydell@linaro.org>, qemu-ppc@nongnu.org,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, Fabiano Rosas <farosas@suse.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-s390x@nongnu.org,
 Peter Xu <peterx@redhat.com>
References: <20251001082127.65741-1-philmd@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251001082127.65741-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/10/25 10:21, Philippe Mathieu-Daudé wrote:
> Following a previous comment from Richard in [*],
> reduce "system/ram_addr.h" size by un-inlining a
> lot of huge functions that aren't really justified,
> and extract the API to the hew "system/physmem.h"
> header, after renaming the functions (removing the
> confusing 'cpu_' prefix).

Based-on: <20250930082126.28618-1-philmd@linaro.org>
"system/physmem: Remove cpu_physical_memory _is_io() and _rw()"

> Philippe Mathieu-Daudé (25):
>    system/ram_addr: Remove unnecessary 'exec/cpu-common.h' header
>    accel/kvm: Include missing 'exec/target_page.h' header
>    hw/s390x/s390-stattrib: Include missing 'exec/target_page.h' header
>    hw/vfio/listener: Include missing 'exec/target_page.h' header
>    target/arm/tcg/mte: Include missing 'exec/target_page.h' header
>    hw: Remove unnecessary 'system/ram_addr.h' header
>    accel/tcg: Document rcu_read_lock is held when calling
>      tlb_reset_dirty()
>    accel/tcg: Rename @start argument of tlb_reset_dirty*()
>    system/physmem: Rename @start argument of physical_memory_get_dirty()
>    system/physmem: Un-inline cpu_physical_memory_get_dirty_flag()
>    system/physmem: Un-inline cpu_physical_memory_is_clean()
>    system/physmem: Rename @start argument of physical_memory_all_dirty()
>    system/physmem: Rename @start argument of physical_memory_range*()
>    system/physmem: Un-inline cpu_physical_memory_range_includes_clean()
>    system/physmem: Un-inline cpu_physical_memory_set_dirty_flag()
>    system/physmem: Rename @start argument of physical_memory_*range()
>    system/physmem: Un-inline cpu_physical_memory_set_dirty_range()
>    system/physmem: Un-inline cpu_physical_memory_set_dirty_lebitmap()
>    system/physmem: Rename @start argument of physmem_dirty_bits_cleared()
>    system/physmem: Un-inline cpu_physical_memory_dirty_bits_cleared()
>    system/physmem: Rename @start argument of
>      physmem_test_and_clear_dirty()
>    system/physmem: Reduce cpu_physical_memory_clear_dirty_range() scope
>    system/physmem: Reduce cpu_physical_memory_sync_dirty_bitmap() scope
>    system/physmem: Drop 'cpu_' prefix in Physical Memory API
>    system/physmem: Extract API out of 'system/ram_addr.h' header

>   include/system/physmem.h          |  56 ++++
>   include/system/ram_addr.h         | 413 ------------------------------
>   system/physmem.c                  | 342 +++++++++++++++++++++++--
(highlight on diff-stat)

