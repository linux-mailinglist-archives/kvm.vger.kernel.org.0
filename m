Return-Path: <kvm+bounces-27910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E12509902BC
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 14:11:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBF1D1C21763
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 12:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C006715C121;
	Fri,  4 Oct 2024 12:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bvTainF3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3183A15A84D
	for <kvm@vger.kernel.org>; Fri,  4 Oct 2024 12:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728043864; cv=none; b=W3Wy77suJEnxGbGQN99wggtQRTZZe6uyqJT+bbapQcfDLuETt3pJDnSQ3M96ZqEYap0BabO6Vw41cWqAJ+c2LvgHROiJ6jTvU0kwU57FnStlIuoVBJbJFcqNV/cc6yGnruyvxFblg+T88Admritqt5bjOk9c4RSaWgroDYFW4wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728043864; c=relaxed/simple;
	bh=98x+DS7oU+wIiN6bcto2bvBmsfMEBT/Omef5cOzT0d4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iWMzgI/GohX2vfRrDNKhYToQw2fs7VVv+MDoik8lYdGTT5BlVdaunIIk93pSXZtFuLSJJ97U2XiiUjlpgpZ5CDAbURVqGhy/Vo+L2+YQgqhmW+H6QC2pwSorR9SkYIF2N6VhpM7QrWaMYMT9m1KYZLsmWbajZereNKqWfjloenU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bvTainF3; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5c89668464cso2613450a12.1
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2024 05:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728043860; x=1728648660; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nLRWxfYoK6Cafgt/qUAdxdQ9UmXyz/QoFGn6MQbA2BY=;
        b=bvTainF3tWs5FEcYEWo3awx79xdZ6VWXjufjU7G2h/gVNLjxSKfEfiPBHObIRY9nma
         o3JdkyZORkuncougHNNwpgO8tCPHyTN1lfszYO81nROLK50Kxxe3KBjA0J6k7ghDTkhA
         SU2vj4yPUjj2/tOJwHKYADO2QrctUPkjleSdsYIQPBwoom9fhR/O4tGt75tN8UDHOMH5
         Abygufr+badQcSVZh/ydz7kRozUPw4cF1F0BK9beA/g6r1jhtxg26M0FfSzCb+F9kd1B
         z9d8Hb69lT9vEL35Cw8qWFxIVyXCvNyR+9ApXH26yljegOTHE29QbhBlcb7x5dKm0rAm
         o/Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728043860; x=1728648660;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nLRWxfYoK6Cafgt/qUAdxdQ9UmXyz/QoFGn6MQbA2BY=;
        b=UAD1ftCVN1f1RrwaUCZbe+P3aSXYIM0EvYh8EpPK20hc9qwVz8THYImnHpQVoqNbjY
         D7GtZpAl8F5gVe3zVk8khLFVkv0MS9X/2O9kOQ3CrIdhlEwkcSMZ4b76L2yXbe0xUTBm
         aGLrGz2ixZVHURwPzkguxRU0q/EJpKw8OLvjkymZsM/wS1KcIgNN7cuw12YR2GPG+F9t
         n2bjH8waZTEqfCAdz/5rmRw52Js9EZGuKwcmVemLoiYSEDLuLFGrISSf/dj7tEdCAyEI
         unvfXVjKSDe+P2N51/i0NfcH1t+ETdtUKT1EfoWETzKNR1dOS7ggDBdcqmKWxAlgf3+5
         ZbBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUj5puPg7ZnNclpY6tT9At1k7i4ya4mj0a+GdPDBQ3GaqCbtS1Lu+nLqE80AIITZSqHe30=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYf94vJfEZQJBigsBfE9hHqIrjge7Hhcwtb3TKmDRzNEHP1IZg
	FXSTBQiHu1wZCJrGrmE1mJWkq8URc3IeBAw2FwWIvbyp9yiXfiKBx7zcX8GekOIzRnT0XX/kEQC
	W8rVuG6XYBihg70zQLNHLoBhlIt3ieb0ktL6Q6EWWJ5ILT9HV
X-Google-Smtp-Source: AGHT+IHMRD9ZbIfy5bdEm2JLsi5cSDroxj58zllMuaymeta2yhL1+Kk1fvT9teC49Lco6qfh+Pen4M9kMGDH3ABd5E8=
X-Received: by 2002:a05:6402:26c8:b0:5c8:ae9e:baba with SMTP id
 4fb4d7f45d1cf-5c8d2dfcf50mr1510339a12.2.1728043860273; Fri, 04 Oct 2024
 05:11:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <89f184d6-5b61-4c77-9f3b-c0a8f6a75d60@pengutronix.de>
 <CAFEAcA_Yv2a=XCKw80y9iyBRoC27UL6Sfzgy4KwFDkC1gbzK7w@mail.gmail.com> <a4c06f55-28ec-4620-b594-b7ff0bb1e162@pengutronix.de>
In-Reply-To: <a4c06f55-28ec-4620-b594-b7ff0bb1e162@pengutronix.de>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 4 Oct 2024 13:10:48 +0100
Message-ID: <CAFEAcA9F3AR-0OCKDy__eVBJRMi80G7bWNfANGZRR2W8iMhfJA@mail.gmail.com>
Subject: Re: [BUG] ARM64 KVM: Data abort executing post-indexed LDR on MMIO address
To: Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc: qemu-arm@nongnu.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	Pengutronix Kernel Team <kernel@pengutronix.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Enrico Joerns <ejo@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"

On Fri, 4 Oct 2024 at 12:51, Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
>
> Hello Peter,
>
> Thanks for your quick response.
>
> On 04.10.24 12:40, Peter Maydell wrote:
> > On Fri, 4 Oct 2024 at 10:47, Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
> >> I am investigating a data abort affecting the barebox bootloader built for aarch64
> >> that only manifests with qemu-system-aarch64 -enable-kvm.
> >>
> >> The issue happens when using the post-indexed form of LDR on a MMIO address:
> >>
> >>         ldr     x0, =0x9000fe0           // MMIO address
> >>         ldr     w1, [x0], #4             // data abort, but only with -enable-kvm
> >
> > Don't do this -- KVM doesn't support it. For access to MMIO,
> > stick to instructions which will set the ISV bit in ESR_EL1.
> >
> > That is:
> >
> >  * AArch64 loads and stores of a single general-purpose register
> >    (including the register specified with 0b11111, including those
> >    with Acquire/Release semantics, but excluding Load Exclusive
> >    or Store Exclusive and excluding those with writeback).
> >  * AArch32 instructions where the instruction:
> >     - Is an LDR, LDA, LDRT, LDRSH, LDRSHT, LDRH, LDAH, LDRHT,
> >       LDRSB, LDRSBT, LDRB, LDAB, LDRBT, STR, STL, STRT, STRH,
> >       STLH, STRHT, STRB, STLB, or STRBT instruction.
> >     - Is not performing register writeback.
> >     - Is not using R15 as a source or destination register.
> >
> > Your instruction is doing writeback. Do the address update
> > as a separate instruction.
>
> This was enlightening, thanks. I will prepare patches to implement
> readl/writel in barebox in ARM assembly, like Linux does
> instead of the current fallback to the generic C version
> that just does volatile accesses.
>
> > Strictly speaking this is a missing feature in KVM (in an
> > ideal world it would let you do MMIO with any instruction
> > that you could use on real hardware).
>
> I assume that's because KVM doesn't want to handle interruptions
> in the middle of such "composite" instructions?

It's because with the ISV=1 information in the ESR_EL2,
KVM has everything it needs to emulate the load/store:
it has the affected register number, the data width, etc. When
ISV is 0, simulating the load/store would require KVM
to load the actual instruction word, decode it to figure
out what kind of load/store it was, and then emulate
its behaviour. The instruction decode would be complicated
and if done in the kernel would increase the attack surface
exposed to the guest. (In practice KVM will these days
bounce the ISV=0 failure out to the userspace VMM, but
no VMM that I know of implements the decode of load/store
instructions in userspace either, so that just changes which
part prints the failure message.)

> > In practice it is not
> > a major issue because you don't typically want to do odd
> > things when you're doing MMIO, you just want to load or
> > store a single data item. If you're running into this then
> > your guest software is usually doing something a bit strange.
>
> The AMBA Peripheral ID consists of 4 bytes with some padding
> in-between. The barebox code to read it out looks is this:
>
> static inline u32 amba_device_get_pid(void *base, u32 size)
> {
>         int i;
>         u32 pid;
>
>         for (pid = 0, i = 0; i < 4; i++)
>                 pid |= (readl(base + size - 0x20 + 4 * i) & 255) <<
>                         (i * 8);
>
>         return pid;
> }
>
> static inline u32 __raw_readl(const volatile void __iomem *addr)
> {
>         return *(const volatile u32 __force *)addr;
> }
>
> I wouldn't necessarily characterize this as strange, we just erroneously
> assumed that with strongly ordered memory for MMIO regions and volatile
> accesses we had our bases covered and indeed we did until the bases
> shifted to include hardware-assisted virtualization. :-)

I'm not a fan of doing MMIO access via 'volatile' in C code,
personally -- I think the compiler has a tendency to do more
clever recombination than you might actually want, because
it doesn't know that the thing you're accessing isn't RAM-like.

thanks
-- PMM

