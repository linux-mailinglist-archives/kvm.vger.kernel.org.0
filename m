Return-Path: <kvm+bounces-27076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE27797BCDC
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 15:13:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 461B0B22EAA
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 13:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2237918A936;
	Wed, 18 Sep 2024 13:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lMrdCGKy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A7B189F42
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 13:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726665184; cv=none; b=r7riBH28NIOKgPbjtN3b7o8V2iMo+0iccH5W9Y21VZQMvKuORiiFrdnsKRzyTo90TSswEj8oZSG4BcZHzCsfOgeTDXqI8r8B90pZXUgBtZ6TpgNUgqpUBWN1FvFRf9tYryc4QzbOzhWZzJcNwecctBRGpysZPaliA+3OOUxnSFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726665184; c=relaxed/simple;
	bh=t1BTgFJSuELqW46e+hZA6MBoAE+CKlGmnWti3rAyLDk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i5b+wY95bhR86FjWcY4keDNNDj4EMhf69jdOncuv6Gv4423Z71HMIogN3Yc5cz+yxCFHT3yUrK74UeP3emyeYamwird16uSbo5qVZT1yk0gvzXmN+lcMPf1iIDOLKDfYFhbXRUzzojyDfBMc2kMxMIIqxcFaav0ENf4Uh3guE5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lMrdCGKy; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2f75f116d11so60694251fa.1
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 06:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726665180; x=1727269980; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1UIao/Jz5H8HMYQFxpoEYcHdlz/BHFAG+1NToY/M7y4=;
        b=lMrdCGKy0SRwCTaB5zekixs48dnTZwasXy36Cv4MRBwh1P/ekOaQXyU1MhHedUfYhu
         JoB2K2G3hBkQjNyfFeiofaqF3XvVP9dlpq1lrhGY/ar9LnHXwo/P/5lQFPvr0YnJXxyp
         V/GGh9sMRY6r7ZxB4EDib/h3bG4bGpGOsrMfzTznUJBFLGzHRniloGGbPncod1PCtTB0
         9tVUP3cB48cH/oHq57s+n8nFJRQuCBms+gjWYvSK6C6UkEluiBY7PnUCukXSujsmU4Pc
         2ptDVKG8D1IHwOa8vtG1mt8dQ5sNttkVMd56sxG1Qx1M9SbmlAGKDrseCI45tMcImdWx
         x3XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726665180; x=1727269980;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1UIao/Jz5H8HMYQFxpoEYcHdlz/BHFAG+1NToY/M7y4=;
        b=mOFjLkvpoMhPotr08wsQh44+2ln6+6mQllNI6IDxnO5WtOI8x3ZFwAMU3DWmgU1m86
         OarpMJqYzEf2NWpXXzv4FTvo+t9CTa02QbZrA81BCFGX4y/I9kExZ/r3zG1OpWXL1+pt
         7D0n/t/tnOqAnuO5zca+fJmp2DKQlFCYJFS0bA8dQjDmPpDS5mUexS3nOzadM/eXtqu8
         70TifDI1jVyJuTSUiwFy/pSd7Gfga2xbKIm/7OQTT8cG1RM4IilkD8ZE8fBowVTNGC65
         f/OfExBVqAogW3m4/5fZp8EEhZCm4T1sJhH9MxFfeiR8yJnICsT+cliviQ2ek84+zmst
         T2JQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCz8v4/2wSmBdJXofAM8JaZzHcjjZ4F3io/LIQP7kVtKxk1MZoxEqlhsDgX5sLH6TIowM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxk/WleCZkHbip3bRvgy6I4YCfmq7faRbOmR5il3emNxoaqoC4q
	w5bEkiE7mN6IYKoQ6OpHmOAt+tPn1gPTIoNNZtVSPOPozLRoT9Fb59MJqJi5/uUv3xuTl/gnGLC
	IKfKcfvDjKCo4eUStthkqPh4kDokHZ36LlxayFg==
X-Google-Smtp-Source: AGHT+IF5izfJa+xhgK0mjYVqlKJIK89IcU1cb1NpZfcXm0pryp2o/BMT6N8z0wfXVAWqfUbW+2JjG7UdxmVTGR7xheE=
X-Received: by 2002:a05:651c:509:b0:2f3:fd4a:eac6 with SMTP id
 38308e7fff4ca-2f7919fe8d6mr81760011fa.18.1726665180209; Wed, 18 Sep 2024
 06:13:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240916181633.366449-1-heinrich.schuchardt@canonical.com>
 <20240917-f45624310204491aede04703@orel> <15c359a4-b3c1-4cb0-be2e-d5ca5537bc5b@canonical.com>
 <20240917-b13c51d41030029c70aab785@orel> <8b24728f-8b6e-4c79-91f6-7cbb79494550@canonical.com>
 <20240918-039d1e3bebf2231bd452a5ad@orel> <CAFEAcA-Yg9=5naRVVCwma0Ug0vFZfikqc6_YiRQTrfBpoz9Bjw@mail.gmail.com>
 <bab7a5ce-74b6-49ae-b610-9a0f624addc0@canonical.com>
In-Reply-To: <bab7a5ce-74b6-49ae-b610-9a0f624addc0@canonical.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 18 Sep 2024 14:12:48 +0100
Message-ID: <CAFEAcA-L7sQfK6MNt1ZbZqUMk+TJor=uD3Jj-Pc6Vy9j9JHhYQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] target/riscv: enable floating point unit
To: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Alistair Francis <alistair.francis@wdc.com>, 
	Bin Meng <bmeng.cn@gmail.com>, Weiwei Li <liwei1518@gmail.com>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, 
	qemu-riscv@nongnu.org, qemu-devel@nongnu.org, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 18 Sept 2024 at 14:06, Heinrich Schuchardt
<heinrich.schuchardt@canonical.com> wrote:
> Thanks Peter for looking into this.
>
> QEMU's cpu_synchronize_all_post_init() and
> do_kvm_cpu_synchronize_post_reset() both end up in
> kvm_arch_put_registers() and that is long after Linux
> kvm_arch_vcpu_create() has been setting some FPU state. See the output
> below.
>
> kvm_arch_put_registers() copies the CSRs by calling
> kvm_riscv_put_regs_csr(). Here we can find:
>
>      KVM_RISCV_SET_CSR(cs, env, sstatus, env->mstatus);
>
> This call enables or disables the FPU according to the value of
> env->mstatus.
>
> So we need to set the desired state of the floating point unit in QEMU.
> And this is what the current patch does both for TCG and KVM.

If it does this for both TCG and KVM then I don't understand
this bit from the commit message:

# Without this patch EDK II with TLS enabled crashes when hitting the first
# floating point instruction while running QEMU with --accel kvm and runs
# fine with --accel tcg.

Shouldn't this guest crash the same way with both KVM and TCG without
this patch, because the FPU state is the same for both?

-- PMM

