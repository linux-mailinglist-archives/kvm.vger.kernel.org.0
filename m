Return-Path: <kvm+bounces-48293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E042ACC59A
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 13:40:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 570B11892D3E
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 11:41:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B8CE22F16F;
	Tue,  3 Jun 2025 11:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="S0VL5U2+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6464DC2F2
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 11:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748950835; cv=none; b=af9CcEJWaF+mLD0OX/ks636xFfqUV2S5w0Q/LFmmXNvrn/pPfHYZ+CawKAutbuOSfS2Dw9fothGoDRn2lhWcZbmQPpaBMp81t5VX/otQuhEuYj4FHpm/PSzVJ5mImZyEnzrSU3R84xOuNBsXvL7ezIoP3ydinqT8ODk1IyAIx/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748950835; c=relaxed/simple;
	bh=L0vHIc+oMzlkJ8aajqE45z0niL4axMzyxGK6cJQLgOU=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Subject:Cc:To:
	 References:In-Reply-To; b=Zaxj5AFYvSoZfcdQCsNZs4/l0DmOvjEp2CKoNL0PnURZwBty/FXOYC3PLPBtLRqVXSlsjWKkvyaJZH/gYOGouvWY9V/G+RmxTJddbQSSumUGaaq8upmV710olpvRX58g9uibxfLP0/dyImBfwWZzxOpl1OH6KQiRxhssXXA/7Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=S0VL5U2+; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a4eb4acf29so900371f8f.0
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 04:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1748950832; x=1749555632; darn=vger.kernel.org;
        h=in-reply-to:references:to:cc:subject:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MqVabgXFstwYrAYyfsH8IvHqrVwku7JGFF8O9u+W/Po=;
        b=S0VL5U2+r0LZzontIsEdrnrcmTtRWhfLjDEAZ/MA2OqH/qTLDK0B0ZDc3ldpp1PSEC
         FJusZAzQLzug1SUUY+HDLsuGArCOE99MUyQk7JVTlwzafT65WxoZZOJo6wTOiABvTOGs
         p775BbozQ+1vOsI2vfxurGrGNR3ZS19XK5R4ilkQtUcidn9s1XpxJmK9y3GmP+bIhd4f
         boJjxjgHLLcCMZvDQEd+Vs28SVJSHrOiRzxF80nYln9/2frugIiTKl7hcm5mnqhBxDJ6
         F6kjrtzi9xfL0qpZ4w80DuNGfkrdLF8M5eD9tpye2RAMf0gqxGq5759Cpu0Mq/Nd1bVM
         mFTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748950832; x=1749555632;
        h=in-reply-to:references:to:cc:subject:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MqVabgXFstwYrAYyfsH8IvHqrVwku7JGFF8O9u+W/Po=;
        b=PThi/84XCRI+Pa5S5ek4350fWj+4OBwrE6WuSYU0/t8AXu0Jw0E9zz71F0n+1RJ8sU
         OMWzF8yUXaPwQ080fox/9AzknnRT9/JGROe4S9uVHDitOi+c1ARGpTTalMaOmOYCL8jQ
         hOWJLAXeUkMMtixgOuhH4+rd39P9/NWM6cCzzDPwzwTqEOucvPMizPfYV+/6D4ieBqPv
         E88ipBg83z815k5zUGUbZZ0UC+sq/kAbD6jrohA5Iodt+HXacWfyHiMcmlhjJvyza9TM
         L61J951Yk0D5MRJIH2OFvGQbhkycs6X37/Ucb7bjaR5cUblEBRM4tE1CcsatC+1POhMk
         1D9A==
X-Forwarded-Encrypted: i=1; AJvYcCV6TZ7cUYdZnqCVIZOgKavz5SVBDRHbdC1u32EaLkmjq6G7Xc54fo6ZSZdHT6eqCJjKfPM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9Aw062k9AJkyztIbKQoNlY9X9gpjMXGFildCvdnZof+//L6pL
	PlZ8c6hFfC4/6bn8vQ2lEwTq3Nko4U/Q+QeE7+JlHvGbFYfeBcfnjLcKceY/PUpVnm0=
X-Gm-Gg: ASbGncssUCFSIwJEq1DRQ+axuhxujt20v7m81oU1sTeJgaZbtZcZ4adJPL/TbDdVaQ8
	54nitdujjOoY8LrnqJZ4HsMGikAVmuNlA4isuZAeCBWv1AMVi7MGLZvvvGIK5EtF2Nak822+9px
	B4u8SiDst8Xqfnm6P9nGKzf4LwvaVlE5pXwW7QVR9Xmm3ZVrKUkdUXqyjEe2/vuzq4NpfYvT6T6
	wmgvQAhUrNAi2c4U68cqMCshezU9igk5NvAcOcWU7oMkJYyMMh2jFPB61xXlUiy3ibAX29945NE
	05P4SblNCsGBTkGa8+6WhK70DBcRdsl2ZUHsFb/Mt+GTBkAbPzdMDwWZ38E=
X-Google-Smtp-Source: AGHT+IGFDhiWKgjK9Y+TCcxKDa8nUqu/n2RN/MNtIHJIhQEdhoO4uixfNqx5KKNaUAuRzy9bZilwyQ==
X-Received: by 2002:a05:6000:230d:b0:3a0:782e:9185 with SMTP id ffacd0b85a97d-3a4f895f857mr4292350f8f.2.1748950831495;
        Tue, 03 Jun 2025 04:40:31 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:37e0:4ec0:b6ec:ef2a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4f0097210sm17962177f8f.73.2025.06.03.04.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 04:40:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 03 Jun 2025 13:40:30 +0200
Message-Id: <DACVBRLJ5MMV.1COZ83HBMUD6A@ventanamicro.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
Subject: Re: [PATCH v3 9/9] RISC-V: KVM: Upgrade the supported SBI version
 to 3.0
Cc: "Anup Patel" <anup@brainfault.org>, "Will Deacon" <will@kernel.org>,
 "Mark Rutland" <mark.rutland@arm.com>, "Paul Walmsley"
 <paul.walmsley@sifive.com>, "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Mayuresh Chitale" <mchitale@ventanamicro.com>,
 <linux-riscv@lists.infradead.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
 <kvm-riscv@lists.infradead.org>, "linux-riscv"
 <linux-riscv-bounces@lists.infradead.org>
To: "Atish Patra" <atish.patra@linux.dev>, "Andrew Jones"
 <ajones@ventanamicro.com>
References: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com>
 <20250522-pmu_event_info-v3-9-f7bba7fd9cfe@rivosinc.com>
 <DA3KSSN3MJW5.2CM40VEWBWDHQ@ventanamicro.com>
 <61627296-6f94-45ea-9410-ed0ea2251870@linux.dev>
 <DA5YWWPPVCQW.22VHONAQHOCHE@ventanamicro.com>
 <20250526-224478e15ee50987124a47ac@orel>
 <ace8be22-3dba-41b0-81f0-bf6d661b4343@linux.dev>
 <20250528-ff9f6120de39c3e4eefc5365@orel>
 <1169138f-8445-4522-94dd-ad008524c600@linux.dev>
 <DA8KL716NTCA.2QJX4EW2OI6AL@ventanamicro.com>
 <2bac252c-883c-4f8a-9ae1-283660991520@linux.dev>
 <DA9G60UI0ZLC.1KIWBXCTX0427@ventanamicro.com>
 <0dcd01cd-419f-4225-b22c-cbaf82718235@linux.dev>
In-Reply-To: <0dcd01cd-419f-4225-b22c-cbaf82718235@linux.dev>

2025-05-30T12:29:30-07:00, Atish Patra <atish.patra@linux.dev>:
> On 5/30/25 4:09 AM, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
>> 2025-05-29T11:44:38-07:00, Atish Patra <atish.patra@linux.dev>:
>>> On 5/29/25 3:24 AM, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
>>>> I originally gave up on the idea, but I feel kinda bad for Drew now, s=
o
>>>> trying again:
>>> I am sorry if some of my replies came across in the wrong way. That was
>>> never
>>> the intention.
>> I didn't mean to accuse you, my apologies.  I agree with Drew's
>> positions, so to expand on a question that wasn't touched in his mail:
>>
>>>> Even if userspace wants SBI for the M-mode interface, security minded
>>> This is probably a 3rd one ? Why we want M-mode interface in the user
>>> space ?
>> It is about turning KVM into an ISA accelerator.
>>
>> A guest thinks it is running in S/HS-mode.
>> The ecall instruction traps to M-mode.  RISC-V H extension doesn't
>> accelerate M-mode, so we have to emulate the trap in software.
> We don't need to accelerate M-mode. That's the beauty of the RISC-V H=20
> extension.

(It is a gap to me. :])

> The ISA is designed in such a way that the SBI is the interface between=
=20
> the supervisor environment (VS/HS)
> and the supervisor execution environment (HS/M).

The ISA says nothing about the implementation of said interface.

Returning 42 in x21 as a response to an ecall with 0x10 in a7 and 0x3 in
a6 is perfectly valid RISC-V implementation that KVM currently cannot
virtualize.

>> The ISA doesn't say that M-mode means SBI.  We try really hard to have
>> SBI on all RISC-V, but I think KVM is taking it a bit too far.
>>
>> We can discuss how best to describe SBI, so userspace can choose to
>> accelerate the M-mode in KVM, but I think that the ability to emulate
>> M-mode in userspace should be provided.
> I am still trying to understand the advantages of emulating the M-mode=20
> in the user space.
> Can you please elaborate ?

This thread already has a lot of them, so to avoid repeating them, I
have to go into quite niche use-cases:
When developing M-mode software on RISC-V (when RISC-V has more useful
implementations than QEMU), a developer might want to accelerate the
S/U-modes in KVM.
It is also simpler to implement an old SBI interface (especially with
bugs/quirks) if virtualization just executes the old M-mode binary.

Why must KVM prevent userspace from virtualizing RISC-V?

> I am assuming you are not hinting Nested virtualization which can be=20
> achieved with existing
> ISA provided mechanisms and accelerated by SBI NACL.

Right, I am talking about virtualization of RISC-V, because I don't have
a crystal ball to figure out what users will want.

