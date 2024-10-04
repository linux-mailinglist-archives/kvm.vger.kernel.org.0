Return-Path: <kvm+bounces-27905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D9BBC990180
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 12:41:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6232AB2276C
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 10:41:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22CAA155C9E;
	Fri,  4 Oct 2024 10:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iPdCJHwR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F741369BB
	for <kvm@vger.kernel.org>; Fri,  4 Oct 2024 10:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728038459; cv=none; b=I8vBN65NaFPewOni15hwBqEKJg/jisTZZC+o9NgxiiXW8rTCOGvC8yMBwv9HkxRG06nRl3lV0/MqFZT2ZRtj/Kp5J+b1rX+YYYO1jhs+nb6hU9dRiqsU4EltMdYiHc4uN1q6bLsfALubYky6dtXHPbylKMEHUGyYQXlSt7zc8no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728038459; c=relaxed/simple;
	bh=lu6Ci95X3ixh416Hp8eWMyA2WcZFrjpot9w6voMZyBY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HMyXoTQo7Vgbb2xxai4cNR5y5A6935bHEPe6FoUuUvvhe9hOKCe8nMRvGV2LXTbNABzOT1Bc0FEIVxzAWr5/hZFgFIts8SxdolVBwtdm4WzBtI8Qv7slxoiJugPAXGT0ye0lyCBfjE74jxCCiUgpbFV2xaclAqCu6SCL8xJZPVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iPdCJHwR; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2fac3f20f1dso22640811fa.3
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2024 03:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728038455; x=1728643255; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vPl3qITF2ywrXWkVItFCsKUU6jByCU7uvcVLmVgL0Vg=;
        b=iPdCJHwRVMgP3WCCBNhjC+0vBfcOJaa9Zywst+qdiKM93a4Yhq6n9kgjKGVw5+Lagc
         elXimcndlYTBxZsfY2HT4qvs1yS9c6UzVYRa/DaUrSz4EKXLTrShViOE0pjIXpMz4f/N
         z2MHMPPfszsbLxKr+jc/0PW4hj5Q0LAPFzZCqptjPzKLsC4NCXCpYDxZE8eZ0/ASaRL7
         Qcs7Q0FEq+zfKIDPpt9ne/o00RDQiemwxQMUvGNJchogLHxo0bqo9IcZtkQO79vIuGih
         VH+Ge8+Mqh2V8tWP8jZ9Zq2nRqH2iuTy/WvwIQfNLjFaQeRP56UmxnQvqpWEb2uR349D
         Mn7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728038455; x=1728643255;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vPl3qITF2ywrXWkVItFCsKUU6jByCU7uvcVLmVgL0Vg=;
        b=cxq4Fafc4U2ZkBNy+kfdSuTtaC4ey0oB5BRD4FNJH5CYOpMxTf8R7zYRsLdekS491c
         cvCB3XyV61NhpneMqLbz2x9xhF26KyIuEKBGsEnJO0XEs51rWm7qjvtw4MVGsdYPx4Vc
         n4KJU1qelsvvgPIZiM6FZS+U74mrDh4Q//KhdR7w3p2lQR1Cu0QECO91kyYZVLODKhy1
         y43J21Y7dJjPDNGjWaVjW9Wx6Z/oZ3QwsGuJIOQ/1gmqfHfhbtln1NHQWiN2nRkFPFx4
         /TX7uXETdoCq3UDrbFnziA/nRdX/iD4Np3LebXgY7YFQX2HH8cfIOI7KGMbWnNjV/QzC
         F9hA==
X-Forwarded-Encrypted: i=1; AJvYcCVSLIIg3LpgrjEYTwLp31iQCQq55U01FfEditM7vGqQAXkk6N7CCahPUTO5P3Jb7ph8zqM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJXSpSoy6AQwHwbSZHrWK12cOAvlfuaFvHfUha3atG4RczIopU
	Jgt8fJz4AcNdvDdoh6eEX0d7xDqiA/G8qmWAXmDJhse0uJLHMxjc6LjFsv8xfXchwk7Bf/0u5p8
	3P43A+EfqdwVeJKYtFwJUkMtj9pDmth9JTabG9A==
X-Google-Smtp-Source: AGHT+IGyX8sJve6KuRoZVubMXfXMSG/8RucVj3x3PQo8hA72yHvToyC+q/FEh2ZXeQHdHLakNHyPv/O/fqOogsK6RDg=
X-Received: by 2002:a2e:d01:0:b0:2f7:4c9d:7a83 with SMTP id
 38308e7fff4ca-2faf3d70157mr9230261fa.40.1728038455301; Fri, 04 Oct 2024
 03:40:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <89f184d6-5b61-4c77-9f3b-c0a8f6a75d60@pengutronix.de>
In-Reply-To: <89f184d6-5b61-4c77-9f3b-c0a8f6a75d60@pengutronix.de>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 4 Oct 2024 11:40:44 +0100
Message-ID: <CAFEAcA_Yv2a=XCKw80y9iyBRoC27UL6Sfzgy4KwFDkC1gbzK7w@mail.gmail.com>
Subject: Re: [BUG] ARM64 KVM: Data abort executing post-indexed LDR on MMIO address
To: Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc: qemu-arm@nongnu.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	Pengutronix Kernel Team <kernel@pengutronix.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Enrico Joerns <ejo@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"

On Fri, 4 Oct 2024 at 10:47, Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
> I am investigating a data abort affecting the barebox bootloader built for aarch64
> that only manifests with qemu-system-aarch64 -enable-kvm.
>
> The issue happens when using the post-indexed form of LDR on a MMIO address:
>
>         ldr     x0, =0x9000fe0           // MMIO address
>         ldr     w1, [x0], #4             // data abort, but only with -enable-kvm

Don't do this -- KVM doesn't support it. For access to MMIO,
stick to instructions which will set the ISV bit in ESR_EL1.
That is:

 * AArch64 loads and stores of a single general-purpose register
   (including the register specified with 0b11111, including those
   with Acquire/Release semantics, but excluding Load Exclusive
   or Store Exclusive and excluding those with writeback).
 * AArch32 instructions where the instruction:
    - Is an LDR, LDA, LDRT, LDRSH, LDRSHT, LDRH, LDAH, LDRHT,
      LDRSB, LDRSBT, LDRB, LDAB, LDRBT, STR, STL, STRT, STRH,
      STLH, STRHT, STRB, STLB, or STRBT instruction.
    - Is not performing register writeback.
    - Is not using R15 as a source or destination register.

Your instruction is doing writeback. Do the address update
as a separate instruction.

Strictly speaking this is a missing feature in KVM (in an
ideal world it would let you do MMIO with any instruction
that you could use on real hardware). In practice it is not
a major issue because you don't typically want to do odd
things when you're doing MMIO, you just want to load or
store a single data item. If you're running into this then
your guest software is usually doing something a bit strange.

thanks
-- PMM

