Return-Path: <kvm+bounces-47964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DCE09AC7BB0
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 12:25:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92F961BC63E4
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 10:25:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B5AC226CF4;
	Thu, 29 May 2025 10:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="nteKiO55"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F44021C176
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 10:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748514302; cv=none; b=amBvU+OwU5pxLM1zXg7AMjdlA5GYet5vYWP8mEOBsN2YkWmW9mqyjzyOuVH/o/7UQN4Ym6WDaeaCcW6/3KtP31f1GP4XJ3/flPAE10ixebJcmMt3FS0tAvbnaLuCW8w2T9k2357rskKiYvmuy5P9yfVqsoYPBbLJZvykwe1fMqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748514302; c=relaxed/simple;
	bh=ijK9RmqfsG2yNDQvjoza033ZQX6u/cC2iUM8d10DIIA=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:To:From:Subject:
	 References:In-Reply-To; b=DsIb19Zruf20GivAwKDzpvdmY+fM2sg5lrSNo8nx6vtNPg8SalzBAPectxzu0wBwViwU2C5FHJlAPhMn7EX2wvk8eWOVNHpAosoSEW2lwR5EXuKRyg+lfKwhPLMpzEeIR9MVARDnuBao1erarszCo4iRHiAmUPc5nIsxcXCYFks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=nteKiO55; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a4eb4acf29so121956f8f.0
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 03:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1748514298; x=1749119098; darn=vger.kernel.org;
        h=in-reply-to:references:subject:from:to:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bkPmfDr8qV4AFwb/7zNDmYiDn/SPJXtSs6w3iYw5HaE=;
        b=nteKiO55BoaRZ3PQyPwqUWpmXIK8PKChqexrQo/TYUCYuQ0jeriKNKs6iugsISanEB
         LuucSnjVajNDv3prf/4/lGtfxByfWecBBSj288qGmC4WPbQZnfs3OClzxm/mRL71ZiKD
         V4OmR6/H4T69BDEqLUKqaSK0rHZ3Y6mVu1c0nL1hOuRE0lhnSkXG7Dp4X+weya0zqXML
         vcW5nX66H+Ghdihhdo99H1eCmjbTyJQZsHJ7zf0bDeK96K8XjVlMA1tl67aaoUFrRrdn
         kvvtiMMZVeNxlqdJef7BfBNEkfsTZOzNrwNzWYaFA2djKMa/RLvMJNokFHqNl+XTNiz4
         p0Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748514298; x=1749119098;
        h=in-reply-to:references:subject:from:to:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bkPmfDr8qV4AFwb/7zNDmYiDn/SPJXtSs6w3iYw5HaE=;
        b=pGQrulfvjvJK3m19BmYgqIgZ0ptlooHsXQQwOYYGvVAdSqPUVOvr8H/Jpl/G3RKN/h
         6qSOxX+LEvBudvcClz/7V7hASWB7mFYrEeJ1McvGOhHlVM1RU4JaWhva/w13U4YHk2rt
         SyD7ZK/Dy/YZRYfAzGrLDT7jcmVa2V4NpRlxtg/69SCHX/u5qmtm0TbMmdRhZRVkn7Is
         uqFLTLDoMT8tL9t7x/2SEuzF9aRyhyc9KhrsSbvlcpC4bEC/hkMcCc2gy39OOscMTOr9
         TfhTa7k7vXIBi1/A8YJj4SKuObs4yFWAlkN6MF96GJLWAQn20xo2oFlvZt5pR8MDcYRz
         Uzug==
X-Forwarded-Encrypted: i=1; AJvYcCVWTIjp4CM+yecji0Z7OMYOHh0SOLl0I+UCSkQQepLEjKKZ24NXqQj4j/8bXzLoDM6Gsus=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjG7QKuVfm96zsvMlppOWGyAMH5eXeJN6+2qyC9CCXuWMnedt/
	IhQn4AHnRdQdIuTY/pPRQ1yoT8KrpuJ/zQtsBNoUlYNOrFAOtCtRu2cwwJ81GGLBAQY=
X-Gm-Gg: ASbGnct1ouFCnuWg+JxGgGylYXI8lHptRlysu41AaLI0Bv7+UmjnY6tFZaHQgBGTO1V
	2+506Z1Kg6qMD+tN0yrpaatyEqKISsoDhPD6wDpoWZVErDzz/Eu/DaX4pS/ZvRktkvwNO5HU1bL
	qL78W+NrAnBvllthlaYzZ83WYA/fC6xzsOpmC/S4YICjv1R8Q3wkZpj4ZHP78WMVnNWs1l5dL5+
	DIgsvs2PsxrNJzSmtVxg7MSI66s+dP9qeVawycNAP5e7cERDzBGxR1Ts0CxgggY4yg4GN6+13Oi
	VyJQOh/tX22pM8C0EZdjStWeyW84B5NDe+n17Yh7DH1p5jicpabFdr6goPE=
X-Google-Smtp-Source: AGHT+IHTjhkw8mY9U5Lw6amMsITMkGfFMYsq7IkB3jEfobdCq2XVznCgFv/wQTr+NkDTK2KFhJhB5w==
X-Received: by 2002:a05:6000:1885:b0:3a4:e672:df0c with SMTP id ffacd0b85a97d-3a4e672e083mr2365564f8f.13.1748514298394;
        Thu, 29 May 2025 03:24:58 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:f5e7:eb4d:155d:d79e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4efe73fbcsm1558329f8f.48.2025.05.29.03.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 May 2025 03:24:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 29 May 2025 12:24:57 +0200
Message-Id: <DA8KL716NTCA.2QJX4EW2OI6AL@ventanamicro.com>
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
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
Subject: Re: [PATCH v3 9/9] RISC-V: KVM: Upgrade the supported SBI version
 to 3.0
References: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com>
 <20250522-pmu_event_info-v3-9-f7bba7fd9cfe@rivosinc.com>
 <DA3KSSN3MJW5.2CM40VEWBWDHQ@ventanamicro.com>
 <61627296-6f94-45ea-9410-ed0ea2251870@linux.dev>
 <DA5YWWPPVCQW.22VHONAQHOCHE@ventanamicro.com>
 <20250526-224478e15ee50987124a47ac@orel>
 <ace8be22-3dba-41b0-81f0-bf6d661b4343@linux.dev>
 <20250528-ff9f6120de39c3e4eefc5365@orel>
 <1169138f-8445-4522-94dd-ad008524c600@linux.dev>
In-Reply-To: <1169138f-8445-4522-94dd-ad008524c600@linux.dev>

I originally gave up on the idea, but I feel kinda bad for Drew now, so
trying again:

2025-05-28T12:21:59-07:00, Atish Patra <atish.patra@linux.dev>:
> On 5/28/25 8:09 AM, Andrew Jones wrote:
>> On Wed, May 28, 2025 at 07:16:11AM -0700, Atish Patra wrote:
>>> On 5/26/25 4:13 AM, Andrew Jones wrote:
>>>> On Mon, May 26, 2025 at 11:00:30AM +0200, Radim Kr=C4=8Dm=C3=A1=C5=99 =
wrote:
>>>>> 2025-05-23T10:16:11-07:00, Atish Patra <atish.patra@linux.dev>:
>>>>>> On 5/23/25 6:31 AM, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
>>>>>>> 2025-05-22T12:03:43-07:00, Atish Patra <atishp@rivosinc.com>:
>>>>>>>> Upgrade the SBI version to v3.0 so that corresponding features
>>>>>>>> can be enabled in the guest.
>>>>>>>>
>>>>>>>> Signed-off-by: Atish Patra <atishp@rivosinc.com>
>>>>>>>> ---
>>>>>>>> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/in=
clude/asm/kvm_vcpu_sbi.h
>>>>>>>> -#define KVM_SBI_VERSION_MAJOR 2
>>>>>>>> +#define KVM_SBI_VERSION_MAJOR 3
>>>>>>> I think it's time to add versioning to KVM SBI implementation.
>>>>>>> Userspace should be able to select the desired SBI version and KVM =
would
>>>>>>> tell the guest that newer features are not supported.
>>>> We need new code for this, but it's a good idea.
>>>>
>>>>>> We can achieve that through onereg interface by disabling individual=
 SBI
>>>>>> extensions.
>>>>>> We can extend the existing onereg interface to disable a specific SB=
I
>>>>>> version directly
>>>>>> instead of individual ones to save those IOCTL as well.
>>>>> Yes, I am all in favor of letting userspace provide all values in the
>>>>> BASE extension.
>>> We already support vendorid/archid/impid through one reg. I think we ju=
st
>>> need to add the SBI version support to that so that user space can set =
it.
>>>
>>>> This is covered by your recent patch that provides userspace_sbi.
>>> Why do we need to invent new IOCTL for this ? Once the user space sets =
the
>>> SBI version, KVM can enforce it.
>> If an SBI spec version provides an extension that can be emulated by
>> userspace, then userspace could choose to advertise that spec version,
>> implement a BASE probe function that advertises the extension, and
>> implement the extension, even if the KVM version running is older
>> and unaware of it. But, in order to do that, we need KVM to exit to
>> userspace for all unknown SBI calls and to allow BASE to be overridden
> You mean only the version field in BASE - Correct ?

No, "BASE probe function" is the sbi_probe_extension() ecall.

>> by userspace. The new KVM CAP ioctl allows opting into that new behavior=
.
>
> But why we need a new IOCTL for that ? We can achieve that with existing
> one reg interface with improvements.

It's an existing IOCTL with a new data payload, but I can easily use
ONE_REG if you want to do everything through that.

KVM doesn't really need any other IOCTL than ONE_REGs, it's just
sometimes more reasonable to use a different IOCTL, like ENABLE_CAP.

>> The old KVM with new VMM configuration isn't totally far-fetched. While
>> host kernels tend to get updated regularly to include security fixes,
>> enterprise kernels tend to stop adding features at some point in order
>> to maximize stability. While enterprise VMMs would also eventually stop
>> adding features, enterprise consumers are always free to use their own
>> VMMs (at their own risk). So, there's a real chance we could have
>
> I think we are years away from that happening (if it happens). My=20
> suggestion was not to
> try to build a world where no body lives ;). When we get to that=20
> scenario, the default KVM
> shipped will have many extension implemented. So there won't be much=20
> advantage to
> reimplement them in the user space. We can also take an informed=20
> decision at that time
> if the current selective forwarding approach is better

Please don't repeat the design of SUSP/SRST/DBCN.
Seeing them is one of the reasons why I proposed the new interface.

"Blindly" forwarding DBCN to userspace is even a minor optimization. :)

>                                                        or we need to=20
> blindly forward any
> unknown SBI calls to the user space.

Yes, KVM has to do what userpace configures it to do.

I don't think that implementing unsupported SBI extensions in KVM is
important -- they should not be a hot path.

>> deployments with older, stable KVM where users want to enable later SBI
>> extensions, and, in some cases, that should be possible by just updating
>> the VMM -- but only if KVM is only acting as an SBI implementation
>> accelerator and not as a userspace SBI implementation gatekeeper.
>
> But some of the SBI extensions are so fundamental that it must be=20
> implemented in KVM
> for various reasons pointed by Anup on other thread.

No, SBI does not have to be implemented in KVM at all.

We do have a deep disagreement on what is virtualization and the role of
KVM in it.  I think that userspace wants a generic ISA accelerator.

Even if userspace wants SBI for the M-mode interface, security minded
userspace aims for as little kernel code as possible.
Userspace might want to accelerate some SBI extension in KVM, but it
should not be KVM who decides what userspace wants.

