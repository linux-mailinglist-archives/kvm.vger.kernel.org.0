Return-Path: <kvm+bounces-38557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE0BAA3B6E9
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 10:11:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA98B3BE5E6
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 08:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1282F1DF972;
	Wed, 19 Feb 2025 08:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="bgN1B5LU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5F41DF256
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 08:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955074; cv=none; b=sNCQIPjL4QWA3q21ZNQiNI/uiiJtB5TCqFUP50dCUSF9qEwrhNr9OjRXA59eeUeGVMkbyRkqAZ5Y3xl8PWvFAPIddQi9mkAeJ9eGugrYbjoyMRPu0l5gvxuXu/hkN1JVLjnulRba4L2ep3q5DINk20VUXZ5ps/WGWIdByjbR5yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955074; c=relaxed/simple;
	bh=aB7wbo6LJoP8fuqHyehR1qLit5d+ohfBtEaefLRZGSs=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:From:Subject:Cc:
	 References:In-Reply-To; b=hHX34D50Rmxlz3irsk+nhPQdDGNHyew36KAtb7iE1dmdJ8J2Py01+k9JC06mWNJJ5+NzK1MXqtCFRaLMvLm3l2NE+fDEWtkJy4UlEaR58S3Ln7kQdLNgXIyueojV9AM/S2Xgj64CJb82+h/nS+Ya7be4ENhQ+ytvBWaGCqWSQWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=bgN1B5LU; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43987d046caso3836705e9.0
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 00:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1739955067; x=1740559867; darn=vger.kernel.org;
        h=in-reply-to:references:cc:subject:from:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cyOr3ZD32WYQ578+kdBxZIoR9hORXh2QvsH9UB3Wz3E=;
        b=bgN1B5LU3P2E5gi+YoAnACHUGWg5tz6LQ4wQXKu7ycAUC/E0YPPd4Bh7y+ofcrefz2
         4wQmOOmxSYtbakVZnUBgmrF0+Kqc8WwHDmEejlWp5r8v3mB92JYibBIWCMuCl9KkatS2
         xSLHsJZsdQ6JBz5v1WNZAocsi0onG35oXx+mPIChBvh8jzQKPVw6+ZXrjWTIarkF54vI
         hJ437QoKXXP9stCkAFPcMiiDg7xVYHGAOO95o0RpZ9I+G3xUjVqCu3rSbd2hLpjgh0Hz
         vo9ayxF+bW8uU2xardh+S7h7OF4XYdmVT13evYfYBTnPgZsLD5/zrT5VVlz52ALDyO/G
         SPsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739955067; x=1740559867;
        h=in-reply-to:references:cc:subject:from:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cyOr3ZD32WYQ578+kdBxZIoR9hORXh2QvsH9UB3Wz3E=;
        b=U2cbkPdudXaTy5KUW0F8bLDwUXwK2ZtIaHjuQ2jYLEEn9Ts5olxmEiCCC8s5Nh14oK
         ojP1EJ7uu5bUJYXgz+0HFsLQtAbXRB6BIXKqCk6N9u0Fzj0X4RSdq2r0snMBmVq9jxOG
         B1uFNpBW++XOOUsYbOvwplw0S22tQBRjEFia0IzN7+uD+4NRHXPhR+ljpK+uOapt2EwW
         UGvmnTIjkKxvWM5qPsfN9ZN2FPE5AlffzSJWu/thUCjmO9qC0K1pW1/5nltLBSufiGZP
         PqihimEI/S1C62+j8MGqsXy2HbbiE122BRvMbKcRvNu7d+VIT5E+bqyCSsUEFQ6X3f6B
         iQ2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUufa1ZcD8tInMSQHWHPvfYuCGTol8hSXKv6aFbWk7gVIYbGzAcUCWqSmBYHHucSx8+zvw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5M1cFBTkQH3JjBTPJlTsFmw1FsarFfv5/80gxqDkUmAp/MqaR
	rH9/xwSqYjsqthZQt98kCyEJ0iH1qmzOSB/UdEQlQR0bGuqZ/3pa2RmQLYoDgao=
X-Gm-Gg: ASbGnctxy0OSc9Y0mxbQfKSF1vEia3JcLAz++y0BhdokqCaDuniNGG9OMRbhfLWqY9b
	+OSTm8Eo0DUIf8f1gOcW5Rwj8qacsd24Mt6b7D4VRrv211L970l4FIUFyXmTpZ8mzMWWD3AxHNv
	cG+CFwKmMmVw1HNDP1Fw7QacTS39XsjYSClVshVkaiOrlVSsXmV3ib8C0yFKc/tO5SRwU4WJyeH
	SN79PtWwDfTIlVdD7EFLxmFzr2+djGnYGZAngbEWnI16Yk/fZt69SKsSJtzUhq4S+jU3h6Z3Ou4
	EJ4Tz4MMoB2YnjK8s6TlfUt/sxH3+Jzy95yIu5Gk4j2hE0wdr00=
X-Google-Smtp-Source: AGHT+IH6D4plZNYfuEYjbGdATaVAlFztkIrp/rClPpYzS5dL67Gt7zhXEE8RN1q+8mV+NLcuY45v6A==
X-Received: by 2002:a05:600c:524a:b0:439:4d1c:bf72 with SMTP id 5b1f17b1804b1-4396e77b89dmr62388815e9.6.1739955066877;
        Wed, 19 Feb 2025 00:51:06 -0800 (PST)
Received: from localhost (ip-89-103-73-235.bb.vodafone.cz. [89.103.73.235])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259f8730sm17632219f8f.93.2025.02.19.00.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 00:51:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 19 Feb 2025 09:51:05 +0100
Message-Id: <D7WALEFMK28X.13HQ0UL1S3NM5@ventanamicro.com>
To: "BillXiang" <xiangwencheng@lanxincomputing.com>, <anup@brainfault.org>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
Subject: Re: [PATCH] riscv: KVM: Remove unnecessary vcpu kick
Cc: <ajones@ventanamicro.com>, <kvm-riscv@lists.infradead.org>,
 <kvm@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>, <atishp@atishpatra.org>,
 <paul.walmsley@sifive.com>, <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>,
 "linux-riscv" <linux-riscv-bounces@lists.infradead.org>
References: <20250219015426.1939-1-xiangwencheng@lanxincomputing.com>
In-Reply-To: <20250219015426.1939-1-xiangwencheng@lanxincomputing.com>

2025-02-19T09:54:26+08:00, BillXiang <xiangwencheng@lanxincomputing.com>:
> Thank you Andrew Jones, forgive my errors in the last email.
> I'm wondering whether it's necessary to kick the virtual hart
> after writing to the vsfile of IMSIC.
> From my understanding, writing to the vsfile should directly
> forward the interrupt as MSI to the virtual hart. This means that
> an additional kick should not be necessary, as it would cause the
> vCPU to exit unnecessarily and potentially degrade performance.

Andrew proposed to avoid the exit overhead, but do a wakeup if the VCPU
is "sleeping".  I talked with Andrew and thought so as well, but now I
agree with you that we shouldn't have anything extra here.

Direct MSIs from IOMMU or other harts won't perform anything afterwards,
so what you want to do correct and KVM has to properly handle the memory
write alone.

> I've tested this behavior in QEMU, and it seems to work perfectly
> fine without the extra kick.

If the rest of KVM behaves correctly is a different question.
A mistake might result in a very rare race condition, so it's better to
do verification rather than generic testing.

For example, is `vsfile_cpu >=3D 0` the right condition for using direct
interrupts?

I don't see KVM setting vsfile_cpu to -1 before descheduling after
emulating WFI, which could cause a bug as a MSI would never cause a wake
up.  It might still look like it works, because something else could be
waking the VCPU up and then the VCPU would notice this MSI as well.

Please note that I didn't actualy verify the KVM code, so it can be
correct, I just used this to give you an example of what can go wrong
without being able to see it in testing.

I would like to know if KVM needs fixing before this change is accepted.
(It could make bad things worse.)

> Would appreciate any insights or confirmation on this!

Your patch is not acceptable because of its commit message, though.
Please look again at the document that Andrew posted and always reply
the previous thread if you do not send a new patch version.

The commit message should be on point.
Please avoid extraneous information that won't help anyone reading the
commit.  Greeting and commentary can go below the "---" line.
(And possibly above a "---8<---" line, although that is not official and
 may cause issues with some maintainers.)

Thanks.

