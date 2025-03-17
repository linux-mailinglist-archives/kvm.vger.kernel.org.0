Return-Path: <kvm+bounces-41181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4A70A646FA
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 10:21:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56A5F3A7451
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 09:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E790B221736;
	Mon, 17 Mar 2025 09:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="niEYRIMF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F5121D3DF
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 09:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742203268; cv=none; b=Yx8iigB2YdJ17+zUJkW2EXYgtSddvpNQkocE1P/o6771Dh7y2V7QCuEpcVC2WuyGnN55rJOakCa8Sq1OqnAkEo4aDZ6lo/st4NyUbNU4HAOaL4BpPUDJF1FXW18oukrLfZy9UCtAeisrznS/5Fitiy+ZQaKHjNLtAVCh3uqNkaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742203268; c=relaxed/simple;
	bh=hT2o20j48U7iT9WtdHtZ2HfDPq/OJH+nN/XsbDypwOE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XZ4bthkY7aZwH8PAzQrJpPsXcXH73dd+xRUFeBwJc7+euhNhDDWvrr+dJW9OUO4LCTVtFkdKsEY6/umtVIJ90V9qTGVqgyQiLqe9LKdQTiCMcEgQRTxWSFUZcGP/8PPOauYVvevQ14V5mGO1oSb22B9pMr0BtvUVnC/Whbv/vZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=niEYRIMF; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-39130ee05b0so4069167f8f.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 02:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742203264; x=1742808064; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YpUsKKtqVCRGopEBPreIzxle1j3+eqS8AQYhEVEoDhg=;
        b=niEYRIMFGGE+2tDs6rarS6X5rJwWGof4DTSrVDstXTn+sud4tIq4bBtZmQOya6WKEz
         opwmI70GSngg/bqLOOqNUr1njIVLi8nHQZQlE/RRCGF73DIsv7UGbPiSs4cD07taJFac
         0xU1aaEIqXHCMEIRATJgsJD4K2aGG3317iatOsIJl58qZCkdphUvZDdBmDltHgKkUAnN
         Im3oO3du1rulbE8fiWOh/c3fFZ8r4BdN95T5ID/YiBP0GZZZtAoQZynITD9oIxoYpdeI
         V6UXkmvQD9TGaBWId03R9FgEt7WEH4TYa4IBothuQu1vmHsieOGPRL598OCdX7/jmKMV
         6OZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742203264; x=1742808064;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YpUsKKtqVCRGopEBPreIzxle1j3+eqS8AQYhEVEoDhg=;
        b=lQrTGJJfjk4rJ3rYJYtiyxJ0I5q7LcHmT5LqKcWLWACYjdjV0W0Dp0WCiOuFmqkUbH
         hLWuAzsp7+uC3JlUd7lsylK0MQg9g1ZcJnFuURXw+ZyWY7zcAQZc2j+HT5B9z8HhExOc
         vxbS+iL6i0Fb3J4xsItSNUVo75YQ/NiHIe/LSaR+7pN6EuNNyXaDUTw9WI8+RSbyXgNA
         Vx7C8QNaoeEbcWUmIluUH2R+pyUrZGfN1K9G+qbnsANcOY9wmyV1hIe5u7H0faO+BEuO
         +Ds0gncM8Bwt26xZwSBms+sW6MzVIxE6jYVsK+5KXEjVNdNMrF3orJ0tY1YzOZqZRYYR
         +9zw==
X-Forwarded-Encrypted: i=1; AJvYcCVqOeD5MGJv5KG3vGLtt6hLKsj1b2JNrZdqeAKVQHzuqnUtAqpBdHTiDXLHYwod4LFZic0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYSF7TklPT7STHQzV+6YMcCcrsaprJyT89M+uKcoa7JN4ui2iV
	O2KHWVKFi0EPNvJu0ruVdOEiOYGkh86hXNYoY0wASd8jyI9QlATRVdzDNRFropU=
X-Gm-Gg: ASbGncuOo8gqUbqwg14AM0+l8LtvNl4oiFbnC8AcjkBP/Fklhcf5pgpzUvB7d2c7Iwv
	yiMQT58r8xDAQVxE3/4mYzsPoaJr/BD1Ogdu2jQm+uZQKrSM6qzwA+c1krznv1301qZACU6s35a
	e8YBX9MpzhDLdA5G2eNX/Sc20Lu3WtsXrQZrIpF0WECotUXgbYcLgQrhRrKWIhHhQmsUZiULRZH
	bm+eig60Z/CSDxgjDgLUNrocCc5wimb79upkUjaIO6AqzGdEGJDe+viGXydtgO1m5rjV6JcgWdJ
	wBRCxTEXLAuXBd3tlD7+PKR5SQs0dt2GzDX9ms3WiBBoT85/NvJPgIcwOLrHfFGn+2A3K20NtrT
	KAOxBEFkHhPo=
X-Google-Smtp-Source: AGHT+IGWnfmu1vxKt8DfVr5Wh5yIJXe0q4pEomCwp6mUHJGY4TnJ5r3CTWvfyQ4vsQ6wNtdAUg6E4w==
X-Received: by 2002:adf:a456:0:b0:390:df83:1f5d with SMTP id ffacd0b85a97d-3971f4116ecmr10959222f8f.35.1742203263878;
        Mon, 17 Mar 2025 02:21:03 -0700 (PDT)
Received: from [10.223.46.213] (109.21.205.77.rev.sfr.net. [77.205.21.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c888152dsm14131479f8f.48.2025.03.17.02.21.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 02:21:03 -0700 (PDT)
Message-ID: <3ce90214-a080-4ae8-86ff-9f8fd20f1733@linaro.org>
Date: Mon, 17 Mar 2025 10:21:00 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/17] make system memory API available for common code
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Anthony PERARD <anthony.perard@vates.tech>
Cc: qemu-devel@nongnu.org, qemu-ppc@nongnu.org,
 Yoshinori Sato <ysato@users.sourceforge.jp>, Paul Durrant <paul@xen.org>,
 Peter Xu <peterx@redhat.com>, alex.bennee@linaro.org,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>, qemu-riscv@nongnu.org,
 manos.pitsidianakis@linaro.org, Palmer Dabbelt <palmer@dabbelt.com>,
 kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
 Stefano Stabellini <sstabellini@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Weiwei Li <liwei1518@gmail.com>,
 Markus Armbruster <armbru@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
 <5951f731-b936-42eb-b3ff-bc66ef9c9414@linaro.org> <Z9R2mjfaNcsSuQWq@l14>
 <ee814e2f-c461-4cc2-889d-16bb2df44fdf@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <ee814e2f-c461-4cc2-889d-16bb2df44fdf@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 14/3/25 19:39, Pierrick Bouvier wrote:
> On 3/14/25 11:34, Anthony PERARD wrote:
>> On Fri, Mar 14, 2025 at 10:33:08AM -0700, Pierrick Bouvier wrote:
>>> Hi,
>>>
>>> one patch is missing review:
>>> [PATCH v5 12/17] hw/xen: add stubs for various functions.
>>
>> My "Acked-by" wasn't enough? Feel free try change it to "Reviewed-by"
>> instead.
>>
> 
> Those are differents. From what I understand, Reviewed implies Acked, 
> but the opposite is not true. If it was, they would be equivalent.
> Thanks.

IIUC on QEMU Acked-by means "as a maintainer of files modified by
this patch, I don't have objection on my area, as long as someone
else takes the patch". It doesn't mean the patch has been reviewed.

Please correct me if I'm wrong.

Thanks,

Phil.

