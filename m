Return-Path: <kvm+bounces-46164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6F24AB34DA
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 12:25:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E90B3BEA7F
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 10:25:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D110E265613;
	Mon, 12 May 2025 10:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="DmD+fuzo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37792264F9A
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 10:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747045541; cv=none; b=LjInN4e8XM121DfXYZ24W3dF51GF1I6Ikb4V807JIZMlDfHUNgDDBBvAeXXNWeqc6R4JIXiFpIo/D5IbxA0aReJIt0NsM36AnXDU41IPP095nZV86eN4/74U0ecM1dvNRj1/uKwsLrTiIWAmR83EvgH9hI8w4ZKdJCeMKu0s7iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747045541; c=relaxed/simple;
	bh=8Hfs24IMPIMD+rfu+wmgpuAN32C2jG/+yYit3T83DYk=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Subject:Cc:To:
	 References:In-Reply-To; b=GaHeZ8EnK7Z8s5y8a6vco+l/+xCzwsCVDgjuswV6ZlbOTPc77XQtZ5t4C5Ls3g4wk/AeeCP7dSoM4a71tsQLBQ0EDpL/1EbT5DyB8jVfCmtUUXHdnJ5Fd3Y9iStSyaWG3iq+Ydj4eLL9wStoK7iu1AtQIoBSURNeNYmzxYjnbM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=DmD+fuzo; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43d4ff56136so5087775e9.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 03:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1747045537; x=1747650337; darn=vger.kernel.org;
        h=in-reply-to:references:to:cc:subject:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fVYDNzGl1HhtRbOLlZqbNyW/2ZNd9jQ043iVsCWK1J0=;
        b=DmD+fuzoYUA8DWqIkG4vt7cMfY7uOVpqN1FmAnvGz1RGHFoHRZ/sutTWGs2yzKd9On
         hF/a/ZZEGrKPQ5PmO51+bGDwlDVZNGcMJwI0QQCJU1cvDujkIGY9Zi2spcKGocvqf63O
         4CJ4uCt4bM0dxLcQG2b6D7e2rfzqHt0PgO0T5hfeibkHivKrwy3DxgSJXAhFiZpr722I
         Z4TcW3qMMgsOZ9HPDbMWBKfSISVm1Fcn5YkjBlM0MA/3XN/Qd4KWcc4AojMFAcsNwMyY
         teKQhlqirUCn5DUXwiU4EIvJtK695e3GRiyo2FLaINFRy+g8YqVcb6xq8sOdfa95CRPn
         WcUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747045537; x=1747650337;
        h=in-reply-to:references:to:cc:subject:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fVYDNzGl1HhtRbOLlZqbNyW/2ZNd9jQ043iVsCWK1J0=;
        b=oCTCnh2Tlkv905Pn5mntiNod5M0zO1bL5sU1VKUqVSqK3MO2aATJMW1yJ4ut56BaDo
         3HY0A8s7uvBetvGGr4fAb13IuifVSUB8EzCxrRjY2axUMyKVAl4tUwPFvXgbMtoGsYK2
         u6pIjweWPPzEw7vEKvX0+5Nd/zrcY/63gg8fCQrHqCurYM0IU0HiZumuehSJPqMmaCEn
         eoeSQkk9h9hmoMvMiGY1Uh11aWBmeiX2y0NHn0mFrn/iYH0ZgP9xxyu0ktaCl5BoWxLy
         7/Ca1DOyiEfnUdM7ZgfvxxVe9fiktSRTW6VdwYP3kjwKgFg97eP86denq2mV13jgVY13
         yArQ==
X-Gm-Message-State: AOJu0YyldPr8WfDx4xDocs6+5NQ/fzU0yg3OS7Q6ya8kTE0DaFBnejOl
	zJJYk7awPA6HkWei9mn629ejDqw25bwuqXuj4c+EE2UJ3omLO/NO9zbksrC11+g=
X-Gm-Gg: ASbGncu0DiRXchIGvqKYzinDjM7B9Ssww01BQ9zvT9kh/REmSg/CFUOvvz24DWrATrZ
	ZJXCl6yjjF78GE6kIQArQARQmo4pO8yb69KOj9HGTLsN33w7Ay2gESNWCPgIre2f7NO6h89b3Ae
	AKfzU3n8nJwzEdgAJ5UztL5S36yC/Pipr7aZTmNr/IlnRwL9eeEqD8Yh5t/cCeHIBX8M9G4MhHU
	SHVI1keOH5NxUMaYwlDC/7bS60w+m4VXGxB21xoAOEQsE4DyEbd9XWx2oTPDKKBJd7slwHOjWtQ
	k7Z+wntgPJiQLsJn8CWOdMD6Xecll7/BWFkK/3ivioAm/xgh1Zjt2Eguayk=
X-Google-Smtp-Source: AGHT+IGcTuM+dMRNAzDc5kg0U48s/ErTHPCpW1AeG6d0g+VQ2rWI9+vdhUQrqpzvxyWDNYPzIqhOmg==
X-Received: by 2002:a05:600c:4ec7:b0:439:9fde:da76 with SMTP id 5b1f17b1804b1-442d6c39b14mr38970815e9.0.1747045537283;
        Mon, 12 May 2025 03:25:37 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:6b5b:8def:fde9:86fe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d76b7fd6sm74327145e9.0.2025.05.12.03.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 03:25:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 12 May 2025 12:25:36 +0200
Message-Id: <D9U3YFOPMSEF.15BJIA8CET3RT@ventanamicro.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
Subject: Re: [PATCH 4/5] RISC-V: KVM: Enable envcfg and sstateen bits lazily
Cc: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
 <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 "linux-riscv" <linux-riscv-bounces@lists.infradead.org>
To: "Atish Patra" <atish.patra@linux.dev>, "Anup Patel"
 <anup@brainfault.org>, "Atish Patra" <atishp@atishpatra.org>, "Paul
 Walmsley" <paul.walmsley@sifive.com>, "Palmer Dabbelt"
 <palmer@dabbelt.com>, "Alexandre Ghiti" <alex@ghiti.fr>
References: <20250505-kvm_lazy_enable_stateen-v1-0-3bfc4008373c@rivosinc.com> <20250505-kvm_lazy_enable_stateen-v1-4-3bfc4008373c@rivosinc.com> <D9QTFAE7R84D.2V08QTHORJTAH@ventanamicro.com> <1da6648a-251b-456b-9ddd-a7ffa95a5125@linux.dev>
In-Reply-To: <1da6648a-251b-456b-9ddd-a7ffa95a5125@linux.dev>

2025-05-09T15:38:55-07:00, Atish Patra <atish.patra@linux.dev>:
> On 5/8/25 6:32 AM, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
>> 2025-05-05T14:39:29-07:00, Atish Patra <atishp@rivosinc.com>:
>>> SENVCFG and SSTATEEN CSRs are controlled by HSENVCFG(62) and
>>> SSTATEEN0(63) bits in hstateen. Enable them lazily at runtime
>>> instead of bootime.
>>>
>>> Signed-off-by: Atish Patra <atishp@rivosinc.com>
>>> ---
>>> diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
>>> @@ -256,9 +256,37 @@ int kvm_riscv_vcpu_hstateen_lazy_enable(struct kvm=
_vcpu *vcpu, unsigned int csr_
>>>   	return KVM_INSN_CONTINUE_SAME_SEPC;
>>>   }
>>>  =20
>>> +static int kvm_riscv_vcpu_hstateen_enable_senvcfg(struct kvm_vcpu *vcp=
u,
>>> +						  unsigned int csr_num,
>>> +						  unsigned long *val,
>>> +						  unsigned long new_val,
>>> +						  unsigned long wr_mask)
>>> +{
>>> +	return kvm_riscv_vcpu_hstateen_lazy_enable(vcpu, csr_num, SMSTATEEN0_=
HSENVCFG);
>>> +}
>> Basically the same comments as for [1/5]:
>>
>> Why don't we want to set the ENVCFG bit (62) unconditionally?
>>
>> It would save us the trap on first access.  We don't get anything from
>> the trap, so it looks like a net negative to me.
>
> We want to lazy enablement is to make sure that hypervisor is aware of=20
> the what features
> guest is using. We don't want to necessarily enable the architecture=20
> states for the guest if guest doesn't need it.
>
> We need lazy enablement for CTR like features anyways. This will align=20
> all the the features controlled
> by stateen in the same manner. The cost is just a single trap at the=20
> boot time.
>
> IMO, it's fair trade off.

Yeah, as long as we are doing something with the information from the
trap.

