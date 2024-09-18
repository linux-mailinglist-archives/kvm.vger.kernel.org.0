Return-Path: <kvm+bounces-27093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90C0A97BF1C
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 18:27:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52A37283999
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 16:27:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C78161C9874;
	Wed, 18 Sep 2024 16:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="UYyx+gTQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015001C9858
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 16:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726676841; cv=none; b=WHPV507GRhQww6XJpTzU6DwuZdoBNnajIE3VtZVpawdIpUGkPAsSwVbqw7mYxZRzMOJovAqQCg1njURzfu0p6BrEmMWjqzCIZZmuST3EORfAvR2uTqtp8880Zir0pNdmlNZyN7QhymkomKX86R3aEELEdG+tSq+sqmG+IGrU0IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726676841; c=relaxed/simple;
	bh=qaNX7vM2eu7o+Gsy14Z6mTRn8W4B/VlyO9csZeGxIJk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MpxXBK6v6lGEn3sZojRkJkTn5A1fd9MfukBJZ/wFb1DNSyYMr0RCoSOr+HleUSKlfpjrAp3uK3pQbI8gr/kIpa1q1KvdkBnwRWBb2b3hNwolRupR8YmJiTxWOGuFgS399pnRkaQwoW8oCwBy25RYCHOClneR3hQF2jpn9+OSwVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=UYyx+gTQ; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 388093F2B9
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 16:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1726676837;
	bh=iEkJdohtSWik4fNSGLkaPeBerSCz1v1hA1g/Oi9GQoQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=UYyx+gTQCLAkdDMwi+P+AG5lftwMLxLjZe9/ZyxzRxzoRH0V84EMx9KEzmo1t0D4Z
	 2AMEEZ2lL5eaz+M2uncEPXQt5gZo7FX2zWWHUMTQWVqjOHvrR7JGrLB1XhIuupldaW
	 u3y19hsfjHRQx18uj8zLfaXL1i95sMhxalk7TTRCFclm2/LYSe1J+bcK/+GI2KUUg3
	 W0v3n/s9buzg8q5Upd5w9yRM/KxRNtbiJhb44OZWgXH3foGSFAGGxuex6VfcqKkW2q
	 9YXWW9SBw2Cly091i5fzL1d/M0YL+Oqvqn+GNLRC9DFuQr6duM2WauREjPFnvLz8/d
	 lVEMxuic3gh4w==
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3771b6da3ceso2347817f8f.3
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 09:27:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726676836; x=1727281636;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iEkJdohtSWik4fNSGLkaPeBerSCz1v1hA1g/Oi9GQoQ=;
        b=i7xfazIWBYmaNDI6+qNXZkqCMYsS25AamyaOjKty5xvFwnEOjs3+xrFFxtipl2zXkm
         D2nKHvrxYyibQyX8w6Qxa28md00qC811fBtseivjCyqujTN1sUPaKaD6LwVcjCAqrXBw
         YaSo55/wAZUgQ2Q/XvYjevtWBnxcArIrgkm19cyG79efwEXQkmkORSE+4fNpBF/vdy72
         SWNyHJatUwLKasoPBy04f0A/s1m2j7WkYVMccxMbkt4rk109u/KmbJVrJIOEzIaYsCtn
         R2xNOJuBMSGO3/ESdjQDerlgkPsf7XYJgTHMR7nyw4KU5aGzuT5xF2zCXuQ1NnWB25Li
         OtNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQGWmt6PMf0QBaR4f/mcwJwwUX3rjT6ei6Siusoa1toOC67pJz7rmz4YHncjySsemkSCA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxqd/t0i8j5JN9LpKCE7lR9M/ncFJ3pa5+WI3iO2rz0GEzR5i5J
	CM/U6LjMsTQ4tkBB8nzJbNwrRq3oDl4kVYUoQ3C/XkIgjmGc9lG+7gCrGMzYd1qQBt0TthenNTz
	MD//PzpA56b3d4A8/g2IzvB2RSxjP5MIDQmJbwhSKHERK0J9kS5k7HRmDeE4J5+xTkQ==
X-Received: by 2002:a5d:66c4:0:b0:371:8845:a3af with SMTP id ffacd0b85a97d-378d623b7d4mr11461407f8f.39.1726676836338;
        Wed, 18 Sep 2024 09:27:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFq7GTsYYXDPhTkQjL35nwxJT/xKz4RyECHixjHF7LH26VDJ/F0Ct2Etb+lGYO2yRNM4mRfMA==
X-Received: by 2002:a5d:66c4:0:b0:371:8845:a3af with SMTP id ffacd0b85a97d-378d623b7d4mr11461375f8f.39.1726676835857;
        Wed, 18 Sep 2024 09:27:15 -0700 (PDT)
Received: from [192.168.103.101] (ip-005-147-080-091.um06.pools.vodafone-ip.de. [5.147.80.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-378e780519esm12698302f8f.103.2024.09.18.09.27.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2024 09:27:15 -0700 (PDT)
Message-ID: <ca16bb60-9745-478d-afba-1330b385027e@canonical.com>
Date: Wed, 18 Sep 2024 18:27:14 +0200
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
 <f1e41b95-c499-4e06-91cb-006dcd9d29e6@canonical.com>
 <CAFEAcA_ePVwnpVVWJSx8=-8v2h_z2imfSdyAZd62RhXaZUTojA@mail.gmail.com>
Content-Language: en-US
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
In-Reply-To: <CAFEAcA_ePVwnpVVWJSx8=-8v2h_z2imfSdyAZd62RhXaZUTojA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.09.24 17:32, Peter Maydell wrote:
> On Wed, 18 Sept 2024 at 14:49, Heinrich Schuchardt
> <heinrich.schuchardt@canonical.com> wrote:
>>
>> On 18.09.24 15:12, Peter Maydell wrote:
>>> On Wed, 18 Sept 2024 at 14:06, Heinrich Schuchardt
>>> <heinrich.schuchardt@canonical.com> wrote:
>>>> Thanks Peter for looking into this.
>>>>
>>>> QEMU's cpu_synchronize_all_post_init() and
>>>> do_kvm_cpu_synchronize_post_reset() both end up in
>>>> kvm_arch_put_registers() and that is long after Linux
>>>> kvm_arch_vcpu_create() has been setting some FPU state. See the output
>>>> below.
>>>>
>>>> kvm_arch_put_registers() copies the CSRs by calling
>>>> kvm_riscv_put_regs_csr(). Here we can find:
>>>>
>>>>        KVM_RISCV_SET_CSR(cs, env, sstatus, env->mstatus);
>>>>
>>>> This call enables or disables the FPU according to the value of
>>>> env->mstatus.
>>>>
>>>> So we need to set the desired state of the floating point unit in QEMU.
>>>> And this is what the current patch does both for TCG and KVM.
>>>
>>> If it does this for both TCG and KVM then I don't understand
>>> this bit from the commit message:
>>>
>>> # Without this patch EDK II with TLS enabled crashes when hitting the first
>>> # floating point instruction while running QEMU with --accel kvm and runs
>>> # fine with --accel tcg.
>>>
>>> Shouldn't this guest crash the same way with both KVM and TCG without
>>> this patch, because the FPU state is the same for both?
> 
>> By default `qemu-system-riscv64 --accel tcg` runs OpenSBI as firmware
>> which enables the FPU.
>>
>> If you would choose a different SBI implementation which does not enable
>> the FPU you could experience the same crash.
> 
> Ah, so KVM vs TCG is a red herring and it's actually "some guest
> firmware doesn't enable the FPU itself, and if you run that then it will
> fall over, whether you do it in KVM or TCG" ? That makes more sense.
> 
> I don't have an opinion on whether you want to do that or not,
> not knowing what the riscv architecture mandates. (On Arm this
> would be fairly clearly "the guest software is broken and
> should be fixed", but that's because the Arm architecture
> says you can't assume the FPU is enabled from reset.)
> 
> I do think the commit message could use clarification to
> explain this.
> 
> thanks
> -- PMM

I have not found a specification defining what the status of the FPU 
should be when M-Mode is stared and when moving from M-Mode to S-Mode.

OpenSBI (which is the dominating M-Mode firmware and invoked by default 
in TCG mode) enables the FPU before jumping to S-Mode. KVM should to the 
same for consistency.

Best regards

Heinrich

