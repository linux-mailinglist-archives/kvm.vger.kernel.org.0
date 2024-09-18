Return-Path: <kvm+bounces-27080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB83597BD57
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 15:50:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC7361C21FFB
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 13:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BE2718B47F;
	Wed, 18 Sep 2024 13:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="YLI0UQKN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA02189B98
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 13:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726667388; cv=none; b=OfiWWsQYi+DULEejsvFXZ+zbDy/9sgrn3BdRN+Hg7GwyIj3KOEzJX0UMAZQhV18a30TopMzU5aQorZits7+GjUeR67HNxFLl4lNCKvzMxnjDMRg1jWcO27tk7A86gKAhB6fqcxL0p87kdmu4K5WJUMrzgahnYhegfMiSLw5Unus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726667388; c=relaxed/simple;
	bh=bbOAp5d+ehb8zo4ooCO/9tviCfPTLnOaPm0MT9ZE1jI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q7YaJNUGAAHjytP02An9UWBK5wUnEBwGRHiw0f3RF1bCYUvCpTlPhKc/zoeXrB30E5df8f8DbzuV4Dm4mJ3if6l94Rx3xNFO22Sk5/pu24oW6vTFc6PM+RMAp9cI1K90k4dI4IYyDVXE6m1Bpi7SJsIxY7i2scNfcqPdNrTXkzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=YLI0UQKN; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id C3BD83F5BD
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 13:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1726667382;
	bh=DRPOUgnzyEYA3nZ43EginjRlwFYjkpOPaT3U4/1W7+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=YLI0UQKNiJa/qfTntn0CBtmd+9YK/g075paVLKDNJiUvMHqs5o/HYFSC7y70BkEtQ
	 j6fb8M/XksFMQdbh+/537lb44Z4KxbOQwywFjuhvOANfSl3BSDeMxxVM+LD1sHIWDv
	 D3wDEYReUgTwL4nzsEPVM4mx7Dv2/iIXOse+dm2dxsXmMVglGSLvxKZlHs99OFdS8x
	 Lc/3+tInkdgVhI5ViGEvP4CwwHqHIYQnRkHB2l2YlYcqU6wlvmT2KNiv/JZ2B4GaXD
	 mtOouyzoBbp6HsCiJwMgirowJpXE+X1qyVZl91qr8/VQTcWsHh7CcccBT/f385rJlV
	 +X1PjL/FYl9xw==
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42cceb06940so48530175e9.0
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 06:49:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726667382; x=1727272182;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DRPOUgnzyEYA3nZ43EginjRlwFYjkpOPaT3U4/1W7+E=;
        b=qI7H8uU3CHyP9hjF6TCKeGAS6RWV7HAzxHtUv1+mNIDwNvSrS/zD7eFtFeGM1KjN9s
         Lh2MEoySqEKlryXUOgXCcHMC3eg+MRYVAWl1WefE1lC4z7uaIAWnhzVkzB+GIKjEC1Ll
         Hws7m8vxa3fyX1kfwzBysMmNtrIRRWs4wDGts+4T3D44W4djrSdw0ziUM7ab5ecoeFjg
         x+8vYMaxNDSLJuqZPUZcrkaDFGkh87RxqAVxh9Kam/7U6luAJZcA7NW1o24GsNlpAgiX
         RKdg7yh1E9b6TZMPibiqj/TZf3gX0aDigZpKa48W46ScSNWNH7fcyzlc29qKi7sX2w9L
         oaVA==
X-Forwarded-Encrypted: i=1; AJvYcCVy+mnNZBdqHyFfnghC3TQhVYaDKpcmHUDP0n93WW2CpnLRMdN0L9ug+3mW4PPh/FHFXLg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6YSv1X/Pr+TQtyUsPRmksgn8yS4/JKSEpBDTlqZgh9jtaf0sI
	nQw+LT6w4OGPMEDWgZRtyosHMLGu4JuodyFQQoOjDoCvMpExrA8fWiT7VexJqWOd4gwIPcA7v2n
	JECB61RarS/CTZ8Vmd9X9RGsYHSoSA5OE/jh2U8b9IKqoBDt7I1UpRspT6WoUyi0RFg==
X-Received: by 2002:a05:600c:251:b0:42c:b1f0:f67 with SMTP id 5b1f17b1804b1-42cdb66c968mr131499415e9.27.1726667382038;
        Wed, 18 Sep 2024 06:49:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBOsqcqK7DIjaRwTLHJ9k04jg0yeHQj80Lyu8/abqW0i9TY/peT/h53jDVVzNmlDEM5SNbxg==
X-Received: by 2002:a05:600c:251:b0:42c:b1f0:f67 with SMTP id 5b1f17b1804b1-42cdb66c968mr131499145e9.27.1726667381488;
        Wed, 18 Sep 2024 06:49:41 -0700 (PDT)
Received: from [192.168.103.101] (ip-005-147-080-091.um06.pools.vodafone-ip.de. [5.147.80.91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e7053856esm17475835e9.33.2024.09.18.06.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2024 06:49:41 -0700 (PDT)
Message-ID: <f1e41b95-c499-4e06-91cb-006dcd9d29e6@canonical.com>
Date: Wed, 18 Sep 2024 15:49:39 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] target/riscv: enable floating point unit
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
 Alistair Francis <alistair.francis@wdc.com>, Bin Meng <bmeng.cn@gmail.com>,
 Weiwei Li <liwei1518@gmail.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, qemu-riscv@nongnu.org,
 qemu-devel@nongnu.org, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 Andrew Jones <ajones@ventanamicro.com>
References: <20240916181633.366449-1-heinrich.schuchardt@canonical.com>
 <20240917-f45624310204491aede04703@orel>
 <15c359a4-b3c1-4cb0-be2e-d5ca5537bc5b@canonical.com>
 <20240917-b13c51d41030029c70aab785@orel>
 <8b24728f-8b6e-4c79-91f6-7cbb79494550@canonical.com>
 <20240918-039d1e3bebf2231bd452a5ad@orel>
 <CAFEAcA-Yg9=5naRVVCwma0Ug0vFZfikqc6_YiRQTrfBpoz9Bjw@mail.gmail.com>
 <bab7a5ce-74b6-49ae-b610-9a0f624addc0@canonical.com>
 <CAFEAcA-L7sQfK6MNt1ZbZqUMk+TJor=uD3Jj-Pc6Vy9j9JHhYQ@mail.gmail.com>
Content-Language: en-US
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
In-Reply-To: <CAFEAcA-L7sQfK6MNt1ZbZqUMk+TJor=uD3Jj-Pc6Vy9j9JHhYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.09.24 15:12, Peter Maydell wrote:
> On Wed, 18 Sept 2024 at 14:06, Heinrich Schuchardt
> <heinrich.schuchardt@canonical.com> wrote:
>> Thanks Peter for looking into this.
>>
>> QEMU's cpu_synchronize_all_post_init() and
>> do_kvm_cpu_synchronize_post_reset() both end up in
>> kvm_arch_put_registers() and that is long after Linux
>> kvm_arch_vcpu_create() has been setting some FPU state. See the output
>> below.
>>
>> kvm_arch_put_registers() copies the CSRs by calling
>> kvm_riscv_put_regs_csr(). Here we can find:
>>
>>       KVM_RISCV_SET_CSR(cs, env, sstatus, env->mstatus);
>>
>> This call enables or disables the FPU according to the value of
>> env->mstatus.
>>
>> So we need to set the desired state of the floating point unit in QEMU.
>> And this is what the current patch does both for TCG and KVM.
> 
> If it does this for both TCG and KVM then I don't understand
> this bit from the commit message:
> 
> # Without this patch EDK II with TLS enabled crashes when hitting the first
> # floating point instruction while running QEMU with --accel kvm and runs
> # fine with --accel tcg.
> 
> Shouldn't this guest crash the same way with both KVM and TCG without
> this patch, because the FPU state is the same for both?
> 
> -- PMM

By default `qemu-system-riscv64 --accel tcg` runs OpenSBI as firmware 
which enables the FPU.

If you would choose a different SBI implementation which does not enable 
the FPU you could experience the same crash.

Best regards

Heinrich

