Return-Path: <kvm+bounces-47601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72056AC27A1
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 18:28:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0972E1C0568F
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 16:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 309E9298244;
	Fri, 23 May 2025 16:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="YWVho5t0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A335E198E9B
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 16:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748017632; cv=none; b=BLfcV6zpZgVBi86Mkg13TssZEmfuzgQ3SvS6a3VLuvV+2rCW9eneKCQPF5eVBvE0FK/FeJMpeof8p7tPtIwh6ujhVyhZkvd38Vjx5yPfoDuNKwfA9knD46txikSgnu7GXW3GviWF07ip9WEO++RSyLSgxfmy73rujU4wq8ULtUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748017632; c=relaxed/simple;
	bh=xoy2iHNo1joT7Vza5E4ulrB5ALTkKGuwFJzZh05QFXY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=kbSWUqbXIk/zRD0czkaPBNqfspH7AT+JIIcMFHyZQIAYndA2+RWgs9GNQKNL9hAHCvqFmncgD54sXeV1UsNGspo6jcR96S8zqSp+m1WpHAejvlwx/6GJ6suBmJctovU+R21Cv8+JqhN7/BOt6fs6Us86QUfaDYFLxv/gtKb2g7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=YWVho5t0; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3a367226ad2so16173f8f.0
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 09:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1748017628; x=1748622428; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ia6puvfZPG5fMJM1ZRtmeD9phh8ksFStnHEcrbqR9QM=;
        b=YWVho5t00wvenZuAzoFsjd+SDYyEJKBKLddYH1sizwOm6UT4z3PLA+rgnyNaTcoNWY
         ivS2MCzrHRq9yzMIG4GiOV5tfNJrpVcRRNU3uFKdvwid2zy0LRznIFvCMYlMXSsya+r+
         G2H1sQ+6JiML5gGBxo6avtIDrJc+xO0KuS5aJaJ52FslLlHm2YGRZftDYhgDOzvERsEB
         FlI5XrWoq0+HDRHs7wvgWSt8geb5p0uUl/ntjExeO5ZUwG/JB+T/zPVsjf5VsDde1z7i
         AbnfTu8soC+Eb2DMd18QwSUKo8DbVYnIdhiugDfbf9O6Qg9NEUAW4F1FhHsHRPvgil8U
         IWJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748017628; x=1748622428;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ia6puvfZPG5fMJM1ZRtmeD9phh8ksFStnHEcrbqR9QM=;
        b=V3jNCNuOOECIF8gYfRlvvuYgZZfJ8bK+yc8iyoCkIUUEPH6+/zjtD3+IWLYkrFdYq6
         61SgmkXApKqaMVTWMA7P9B9JoGC9wd4zHkqIqup/Td9A73B0/K5dA5EV/UYod4qNfxhG
         5I0zTTLcrKpI2clqZ4Gn9w0I6IzJ4HzhFDYNwJ2G2+HGoA6E3Nmc4Cu8NHgvMe8jphc6
         PWCVd7ms61gei2qq1A2khbqa78nPEP5TcRc9yoV884WBgcTdoVs5jdRdXTZc/tINAzwJ
         Igtso/kHsI6nD7CXIRIiL/A+hP4KbPwwUzIwi5mhct+UADcxn6MMLOczBMtPBK28r9MR
         BtYw==
X-Forwarded-Encrypted: i=1; AJvYcCVp98axyrIRj7wA2McOOIF9/XanWX/tIakFKOPety5u7rJkfeFZDnYlir0pdhv8Rv4J7Rc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzK+cfiOP2mXKlLVrhjQ33gZPeFaZu/g3Z89cjT1CTfLHCqWbb6
	5qwYHj5IHyyaHBPUm4k51Dk6EzaI7XggGIMAjv6mNUORKIWkNrGrimL6SUdjVrCE+So=
X-Gm-Gg: ASbGnctG309CUepLODezuGgFYZ+xTKsDsQRyPoMEIK15KUWuBL4V1yF/8Fvjv/D2aip
	BoKbHMAZWl3Uq7P8kg6enOqFqdfo+4MzI4osbmV9gY4Q0Z3PHuGjHBOXy49TLYwLeCBrzwOzgrX
	Ofo1dfyMQBwQpfu2+5EL3RKTJ2snXpdS+Pd8HkrVFEeZSo712AwlX2vyt5sOjLPiJmGg1pb/1jF
	RP4jDeD4B7rwibF7P5W12joyia8B6+wExXEyo7SSGNgvNGKQvWea6mZP/fig6lLGHTdqHU7znzK
	To4INDaPQTeKLBFekKLFApkEUquVSNF1nL+RviWH0hSPXF3nlAtYNh5zb/YCI/+kND3YoQ==
X-Google-Smtp-Source: AGHT+IGu5SqOXXJDnZhsvGxzP9Q90JnNNFmT1bVPxtvjIRaUq9pqy0zhm7LZZhwBJv3AkH7nFc+56w==
X-Received: by 2002:a05:6000:230e:b0:3a4:bafb:adaa with SMTP id ffacd0b85a97d-3a4c2b3b3d4mr1273822f8f.3.1748017627898;
        Fri, 23 May 2025 09:27:07 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:be84:d9ad:e5e6:f60b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a368250dbbsm22377027f8f.47.2025.05.23.09.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 09:27:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 23 May 2025 18:27:07 +0200
Message-Id: <DA3OJ7WWUGLT.35AVP0QQDJRZV@ventanamicro.com>
Subject: Re: [PATCH v8 13/14] RISC-V: KVM: add support for FWFT SBI
 extension
Cc: "Samuel Holland" <samuel.holland@sifive.com>, "Andrew Jones"
 <ajones@ventanamicro.com>, "Deepak Gupta" <debug@rivosinc.com>, "Charlie
 Jenkins" <charlie@rivosinc.com>, "Atish Patra" <atishp@rivosinc.com>,
 "linux-riscv" <linux-riscv-bounces@lists.infradead.org>
To: =?utf-8?q?Cl=C3=A9ment_L=C3=A9ger?= <cleger@rivosinc.com>, "Paul
 Walmsley" <paul.walmsley@sifive.com>, "Palmer Dabbelt"
 <palmer@dabbelt.com>, "Anup Patel" <anup@brainfault.org>, "Atish Patra"
 <atishp@atishpatra.org>, "Shuah Khan" <shuah@kernel.org>, "Jonathan Corbet"
 <corbet@lwn.net>, <linux-riscv@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
 <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
 <linux-kselftest@vger.kernel.org>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20250523101932.1594077-1-cleger@rivosinc.com>
 <20250523101932.1594077-14-cleger@rivosinc.com>
 <DA3K95ZYJ52S.1K6O3LN6WEI0N@ventanamicro.com>
 <9f9e2869-725d-4590-887a-9b0ef091472e@rivosinc.com>
In-Reply-To: <9f9e2869-725d-4590-887a-9b0ef091472e@rivosinc.com>

2025-05-23T17:29:49+02:00, Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>:
> On 23/05/2025 15:05, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
>> 2025-05-23T12:19:30+02:00, Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>=
:
>>> +++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
>>> +static const enum sbi_fwft_feature_t kvm_fwft_defined_features[] =3D {
>>> +	SBI_FWFT_MISALIGNED_EXC_DELEG,
>>> +	SBI_FWFT_LANDING_PAD,
>>> +	SBI_FWFT_SHADOW_STACK,
>>> +	SBI_FWFT_DOUBLE_TRAP,
>>> +	SBI_FWFT_PTE_AD_HW_UPDATING,
>>> +	SBI_FWFT_POINTER_MASKING_PMLEN,
>>> +};
>>=20
>> How will userspace control which subset of these features is allowed in
>> the guest?
>>=20
>> (We can reuse the KVM SBI extension interface if we don't want to add a
>>  FWFT specific ONE_REG.)
>
> Hi Radim,
>
> I didn't looked at that part. But most likely using the kvm one reg
> interface seems ok like what is done for STA ? We could have per feature
> override with one reg per feature.

Sounds fine.

> Is this something blocking though ? We'd like to merge FWFT once SBI 3.0
> is ratified so that would be nice not delaying it too much. I'll take a
> look at it to see if it isn't too long to implement.

Not blocking, but I would at least default FWFT to disabled, because
current userspace cannot handle [14/14].  (Well... save/restore was
probably broken even before, but let's try to not make it worse. :])

Thanks.

