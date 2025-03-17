Return-Path: <kvm+bounces-41239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 414EFA656B8
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:56:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D4BD017934B
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 15:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8374C18C03F;
	Mon, 17 Mar 2025 15:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mWDqe2rB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0401A315F
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 15:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742226653; cv=none; b=hAMcqwXbjX9HkMBI4ynEK3uoxCTul4hNcSbH9pN8HHpiW9r6vCG2feJpPTPK89389U0DpfOIOPGjbgRmCkA71/Sk0STlLcaj6MdBUxPywlgXWnsJ5xMilW3/IUz747nNO2jdFV2Ky70i34+mKp+1rCqHqoqChrKCeaa337Qh0oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742226653; c=relaxed/simple;
	bh=Q/MTIgcP+WvRWcZrxfFuC5nDKu8QMFOvhiY2BJeeeF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o92cbnuzhI1EYl8WYfclm1VlZVfXYbFkx3PnVbyitFm+p2nLLKuwMlk0RvljUh8KdZAoyU2NFfEs+JYBk8buxd8PcVVw2ZkJmFzzqhro0oNesORB5FdYLNkXsOHJp/pioMXJ5q694BKUSolslAtxdgMWYNDx+TExcYN085DgOR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mWDqe2rB; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43cf0d787eeso24967455e9.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 08:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742226650; x=1742831450; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l0kvYVh3QIIhVSteww7rz6e6dOUJeoxVvK2zu9yWA2A=;
        b=mWDqe2rBT0PoK1+WQmwHLw+mv08o5TO3GgC8X/RfDbZuDHwUq0GAaPq6j2nspGAgKB
         ygsAMaZx07pJFmp9L7GtNHZXjB1ACubc5KlxU0UKEjMSfFQXwiubqeVvwePkFFr5ip+U
         kzr4GL4C/LhPc5ipxHK3TecDZMmYPHHbLw0nHVkXtGqdp7d9UEmdhppRQqQN0gtpl3mN
         +keLKY0OCWr3yi+hPFgUH/vaXkjqPhwlrrfLrZe8ClbC9BwACKy8CeqLxU3CLXJzjQW7
         L0+1OcQOmxc2iW+H0BHh/oTFoe/GYAZ6Xr/Xjn7p8FB836236nSgab1/XQEtF6nxjh4V
         G1tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742226650; x=1742831450;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l0kvYVh3QIIhVSteww7rz6e6dOUJeoxVvK2zu9yWA2A=;
        b=CMbpetYfHsMHgUx8B+dquyBK9wbFE1uucqGP9dx8HObwhJvQZKRBoyqYZlQYx/vvFr
         TGr3+5FApTt+O7Y06ZJ4Y6L0Zg8ntA4wsemMRCcXUURqvqkXnfqnAZBiK9FE4SmiG1tz
         RnhHhfVd8LlxW5Mw9rdTKQ03ViJQ4CjDpfPRyAf1U4FsBJSl8L1TUzvJycXbe0eWrbc9
         RjphXSZAvMXJxT0VjpwY2qwopyPiHBH07IaW5BGS9q6cmq7AaJmHVOKsArbogel6iXeL
         DJnTcTmwjwc4pc9YE4CwuGF2PfLwElWCES1dJAcxSzsyzvZT47USq9J0tmQOevZ1IDQS
         h2GA==
X-Forwarded-Encrypted: i=1; AJvYcCWU31HnGiljuiFIF4VX45GHmlMAcbPZA8EGiocCfF2PxfWVDjuMG75D9CoJhWroeEwpkvA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzbi1DR8tulyxY2/lWBSWsp9t3i6Hi6W8B8KiQJAcjpY/dfoZU0
	yBCAcOctxcJzjHAYK7UxVrjABsPqejrgSrY3I4dy4hrBj/MF+FrWdQW+xpjYw6s=
X-Gm-Gg: ASbGncvml0+9W7dVJPaloscS/lhcNO2atWiBmM2rwQGUhFuSXNJ3dMNANm6l7lZ+7Wa
	B8Gx75Eu7njG/fvEFF/PKYvI+N6vPfRbTIk85MaURuwbjQYhaXte7x9cksBtSgJgYj4Bar95cBj
	ziu4boFOEFNgbT4KNlD89Th87nmtTrRgPlO/ewNnz7Q1J61Bhkpgg+VE3BfINfl1zsFQvx5jb1g
	3GHGlJpFYojBugErbeevgxxcEk1RfmfeGPmShZGwebGrC0F76aKzGgL842VmnzbFU2QFjx5N3TR
	HuGywk7EQgcSAz0VNvJljIFQuAgenWnvvJiEAYtFHmAu5cGgZ7P3EiXCx/4Qmfs7WqXhkXaSRGP
	cXTLJ0FyKSDCuw4LCAarK
X-Google-Smtp-Source: AGHT+IHEeSmQycdcPRPilEPN46M2KLx0DgnGBUIOfvhqo+t3Qgdzg2qlN331n14zj9svwQlA5J6N9Q==
X-Received: by 2002:a5d:5e0d:0:b0:390:ebae:6c18 with SMTP id ffacd0b85a97d-3971d237919mr9793052f8f.12.1742226650139;
        Mon, 17 Mar 2025 08:50:50 -0700 (PDT)
Received: from [192.168.1.74] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb7eb93csm15132825f8f.86.2025.03.17.08.50.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 08:50:49 -0700 (PDT)
Message-ID: <ad7cdcaf-46d6-460f-8593-a9b74c600784@linaro.org>
Date: Mon, 17 Mar 2025 16:50:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/17] exec/ram_addr: call xen_hvm_modified_memory only
 if xen is enabled
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org, Yoshinori Sato <ysato@users.sourceforge.jp>,
 Paul Durrant <paul@xen.org>, Peter Xu <peterx@redhat.com>,
 alex.bennee@linaro.org, Harsh Prateek Bora <harshpb@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>, qemu-riscv@nongnu.org,
 manos.pitsidianakis@linaro.org, Palmer Dabbelt <palmer@dabbelt.com>,
 Anthony PERARD <anthony@xenproject.org>, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org, Stefano Stabellini <sstabellini@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Weiwei Li <liwei1518@gmail.com>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
 <20250314173139.2122904-12-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250314173139.2122904-12-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/3/25 18:31, Pierrick Bouvier wrote:
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/exec/ram_addr.h | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
> index f5d574261a3..92e8708af76 100644
> --- a/include/exec/ram_addr.h
> +++ b/include/exec/ram_addr.h
> @@ -339,7 +339,9 @@ static inline void cpu_physical_memory_set_dirty_range(ram_addr_t start,
>           }
>       }
>   
> -    xen_hvm_modified_memory(start, length);
> +    if (xen_enabled()) {
> +        xen_hvm_modified_memory(start, length);

Please remove the stub altogether.

> +    }
>   }

