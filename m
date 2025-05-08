Return-Path: <kvm+bounces-45885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18EA2AAFBE1
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:46:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BCE53AF823
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDC701DFE0B;
	Thu,  8 May 2025 13:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="cQW7GM1Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2CA1553AA
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711909; cv=none; b=JA6pq2zBbdZi4DSiBMXw38Y2eHgF/jOzhmQlwAIkkyWGuBEHaUL/BsLWkrOh6t3F9uZ4rRKNQno093AAHTrgOCG71f2K4NE21frlqZejFGzXIPcPp/QJ/bJ1hSLRP1X3mEhdDDwNjpxUS1djXC9L8baF5IkjqKPSuevrGucchas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711909; c=relaxed/simple;
	bh=cKhpRuz/zY+9ViDO4LOnidnYyRBeKNH9aRjFZDkFw4Y=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=qDCMTegHSjefqgvwPoCx3tRiyOeCt5eM85q9ISK9xXEk4HohBEYqUKzarmrp+KHfzV5uwGcCL4A1r2tC0iJ9meQCTnI4Y/KPWo1QqQ7C11oNUzykTS9gOV+EJY/TorpI3bEWRvASZ+dTuF2aZ7xfHeLY56FqBWgcXKhCng4MV68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=cQW7GM1Q; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3a0b28d9251so154522f8f.0
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1746711905; x=1747316705; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ddvWwlvmJ56gF3G0LSGRAILthDv6fgZpldIeC6gbgK4=;
        b=cQW7GM1Q1aLe9GFL/jvzN8UjzwtNrxFbWiRuNkeZgtYsISYnFMiXgL9bhL0zlTR+9+
         WR5RoL/uIeDYoFbZamLlHsFVCtHx1IbJ5GvF78YAr6iA7jsD8CMY6md99og6KD2fl7Ro
         uDCr5FDIfmsNk6rut4sqMW4LhPNLYl0P3/rToa9L//0Z1v2a/X9coj8j1f6lvCIvftMG
         J1Jx4b0SW92ZZEMpfkf70NwCyr4gLZeCQS4Wb9x88hmpvjlgHgg3ZpOg7TF4d3vN65RH
         7d4zgkanVSOUqgCvd/+jox8ygS6BDEdfLVNUd2rfRQpKPLaNRcKxzRPILPILTR+JSGtq
         Fm3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711905; x=1747316705;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ddvWwlvmJ56gF3G0LSGRAILthDv6fgZpldIeC6gbgK4=;
        b=u1HmN1YW11GkuMkUFd78bB+F6nMf+ZEr7JzFIZn3Y1/JI+w8IG4IfryipOAPPx7Y6C
         i1i6WJb5J6hXvStrOzjYsTG6Ptd58dq8RxFXkjAC6grANSXCy58x34s61/cKMasXj/C0
         x/NGRexy3qOhZnnru/AZV2TaBJj0FNFVkP3/C9ws6v9Gn0C59ulFSlEQ+ZzG1GvBu3EY
         KvaolK9sxSojByLCI+37FDO1o2R8F08ZXXw4h4mYZsGI8lnvaOMyNm/4BiaxTgKDsTSh
         VM4Mm2YVmK+lEhWRFbT4WnbuQOg4Ebl2+m7YxvmDatoTjyFXZAdlkkhLTelv1fE4QWyK
         6h0g==
X-Gm-Message-State: AOJu0YwS1OfvKaA2og5/BzCPXE4fxQqvY6BbIKak4SMdoPrO9fXGqesC
	ByQUzsIjCweDtTj/iyxMaG/tsAXk/61y9jOF65vPfK/2BPp+XAZKuCIaQAP/foQ=
X-Gm-Gg: ASbGnctmUIyWIH/88Q7Xej/V/xD31ACJ10OLpTV+VaYna5tD9ugnsz810rWEouVmmwO
	O+l8ezyhXDlyzUQUPZeInz96gGZCuPVMfoFpNsaWnBEuuMECQbcQ3NwiY7o1X8P6ZcIdFfbJCti
	O4fVjRpQEzFMt876vgwCUBvpf84+Iu/3Ox5BflgrHPsz+YRA1irF7IwZ6b1EPQDjkseWhBO3JuI
	8Zw6oi8E8nME15FL+xgICbOp5B1KpzWTCDUWm4qIk3TRLlD2TtS8tPLgTfbRXRsxB2O56J2e4Oo
	u6fyqcJugPI2eSSd5AkHRFBRJQcY6aYHHs4RlbaJfdaOt+8P69fgzaKwrxg=
X-Google-Smtp-Source: AGHT+IFF1lCrGjkOjvYLS8FuS71T+NJYPZUDl1ROqgtA2qAAckMb6oaYDMoD6JX8fEG+cSaT0+BVjg==
X-Received: by 2002:a05:6000:178e:b0:3a1:3543:a74a with SMTP id ffacd0b85a97d-3a13543abcdmr434102f8f.7.1746711905310;
        Thu, 08 May 2025 06:45:05 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:a451:a252:64ea:9a0e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58ebe00sm26063f8f.38.2025.05.08.06.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 06:45:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 08 May 2025 15:45:03 +0200
Message-Id: <D9QTOYMN362W.398FE9SQB0S4X@ventanamicro.com>
Subject: Re: [PATCH 0/5] Enable hstateen bits lazily for the KVM RISC-V
 Guests
Cc: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
 <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 "linux-riscv" <linux-riscv-bounces@lists.infradead.org>
To: "Atish Patra" <atish.patra@linux.dev>, "Anup Patel"
 <anup@brainfault.org>, "Atish Patra" <atishp@atishpatra.org>, "Paul
 Walmsley" <paul.walmsley@sifive.com>, "Palmer Dabbelt"
 <palmer@dabbelt.com>, "Alexandre Ghiti" <alex@ghiti.fr>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20250505-kvm_lazy_enable_stateen-v1-0-3bfc4008373c@rivosinc.com> <D9OYWFEXSA55.OUUXFPIGGBZV@ventanamicro.com> <bc0f1273-d596-47dd-bcc6-be9894157828@linux.dev> <D9Q05T702L8Y.3UTLG7VXIFXOK@ventanamicro.com> <ec73105c-f359-4156-8285-b471e3521378@linux.dev>
In-Reply-To: <ec73105c-f359-4156-8285-b471e3521378@linux.dev>

2025-05-07T17:34:38-07:00, Atish Patra <atish.patra@linux.dev>:
> On 5/7/25 7:36 AM, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
>> 2025-05-06T11:24:41-07:00, Atish Patra <atish.patra@linux.dev>:
>>> On 5/6/25 2:24 AM, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
>>>> 2025-05-05T14:39:25-07:00, Atish Patra <atishp@rivosinc.com>:
>>>>>                                                      This series exte=
nds
>>>>> those to enable to correpsonding hstateen bits in PATCH1. The remaini=
ng
>>>>> patches adds lazy enabling support of the other bits.
>>>> The ISA has a peculiar design for hstateen/sstateen interaction:
>>>>
>>>>     For every bit in an hstateen CSR that is zero (whether read-only z=
ero
>>>>     or set to zero), the same bit appears as read-only zero in sstatee=
n
>>>>     when accessed in VS-mode.
>>> Correct.
>>>
>>>> This means we must clear bit 63 in hstateen and trap on sstateen
>>>> accesses if any of the sstateen bits are not supposed to be read-only =
0
>>>> to the guest while the hypervisor wants to have them as 0.
>>> Currently, there are two bits in sstateen. FCSR and ZVT which are not
>>> used anywhere in opensbi/Linux/KVM stack.
>> True, I guess we can just make sure the current code can't by mistake
>> lazily enable any of the bottom 32 hstateen bits and handle the case
>> properly later.
>
> I can update the cover letter and leave a comment about that.
>
> Do you want a additional check in sstateen=20
> trap(kvm_riscv_vcpu_hstateen_enable_stateen)
> to make sure that the new value doesn't have any bits set that is not=20
> permitted by the hypervisor ?

I wanted to prevent kvm_riscv_vcpu_hstateen_lazy_enable() from being
able to modify the bottom 32 bits, because they are guest-visible and
KVM does not handle them correctly -- it's an internal KVM error that
should be made obvious to future programmers.

>>> In case, we need to enable one of the bits in the future, does hypeviso=
r
>>> need to trap every sstateen access ?
>> We need to trap sstateen accesses if the guest is supposed to be able to
>> control a bit in sstateen, but the hypervisor wants to lazily enable
>> that feature and sets 0 in hstateen until the first trap.
> Yes. That's what PATCH 4 in this series does.

I was thinking about the correct emulation.

e.g. guest sets sstateen bit X to 1, but KVM wants to handle the feature
X lazily, which means that hstateen bit X is 0.
hstateen bit SE0 must be 0 in that case, because KVM must trap the guest
access to bit X and properly emulate it.
When the guest accesses a feature controlled by sstateen bit X, KVM will
lazily enable the feature and then set sstateen and hstateen bit X.

