Return-Path: <kvm+bounces-18297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DBEF8D365A
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:26:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 098FE1F22FE7
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B07C181301;
	Wed, 29 May 2024 12:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mRhZOhf9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B813B295
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 12:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716985599; cv=none; b=cbckEpXoRXMGz7CL0WtU4Ux8h8cw0VOoLQcLYAJuaxPu5fZRomQXkx2RjIcG9ekich9j1HbRcygaymfwZBMLsk3qLSkw6ALuKxp9rf6AAupAXdvti+KhMKtE8DZb8qYGEUKaDDaJM6ZPBUbCmfiSCrEV7bimIyMWRcjGZhsMH+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716985599; c=relaxed/simple;
	bh=kZQZy3UXOQtFDUQs6mTBRIk0y6wOsa82ETCziHZRuAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eem/vlit16cXvagOoDtkYpFLcUNmH+LZza3vEc87wfen0Ytdp2V8XBZc0dMipTdYFZ45HfZBDtYGen2Wbdi1e6FtTgvvfhgru7k4+zImNdHjm+T7f3gSA+zmXYq/BXrWXdseWAhwpH669DOqOdB7C+sdfN1w0RAZd490zdjxDTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mRhZOhf9; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5751bcb3139so2208476a12.1
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 05:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716985596; x=1717590396; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nnfvDp8Ca+cO5mfydJDgPxJYtD8QE7kVqh+o+Vt+wto=;
        b=mRhZOhf9b9BYhLU1ARAQvXw4gd1UadC/K/w7D1KlGFd00RGra8SzKqVE9ZQYxIhEgY
         FvyuTagRAP/a/fKSJOLqLOdAlvxkne4NT7sO9ENPozkh2hEw+CgqDUT/V9F8UNk7VqNH
         4/1oEIGOYiGK+UTEZr4K76fHyOifNqmQ0HNtftnwDMVbtCSoDlUwWUjiCe58SXxKf76i
         QZ/fELMpI0AfvYeV4+YO/JqdGXCpA+EM4WZKnyTqiqnWwQU/0sw1Y+nO6b7CIpelzBGv
         3qCI92TllDCDLSkiFCFiGvrycuwc7NryOM8RXOidrewEMKlWRWXFqaEXVCl1xCypY6bi
         HcJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716985596; x=1717590396;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nnfvDp8Ca+cO5mfydJDgPxJYtD8QE7kVqh+o+Vt+wto=;
        b=Jnb2dzI6WXwAIgkqxqmh7Ns98xj2VNYi2n2sC11a0D91Z/77Y9zekNCMgWOvYKWk1v
         TvvejYFv8hauyZEn5ypv7dOQeNcHhME0elqs3KtRLvnm/Q3kezgSMUPMycZFRpN7n52D
         GMiVPxb2TCN7ixbXqSEjUE8Hqlk118ZQl5vSpA447Bqig8ZkyR8LAfWSNllZk82/FHNd
         zYJlObAh/nvgvEHBVKCpwXgSK9zwjbwNnM2QMC2HIzyPReei5aKSncDCWcNKhRviL1jj
         BHzTlNUJfQVar1GMIFj2wjo/1+W4ndOaePIZ6EWIpp6giCqvGvd5IE4nm5Lw43vYWjCn
         NbdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWU9Axg97U7xw4EDR9W3oyJxnddR9vVQQ6/FsnT6Ax0wWyc5DmV+JB/dwcRaIDOrylur5aI2UYzIfbCbWtnhc5ySXG1
X-Gm-Message-State: AOJu0Yw+mUsiOewnCsbXmO6aML8TmImu7YAaKn1++sNsk0ovqanhUGAz
	YGDtT2hn9WZna7Y2ulnTa/wQ+xFTMlbfdZ9fcb2THE9d803jPd/Yp2d7m2PPhw==
X-Google-Smtp-Source: AGHT+IEIhgoMvjQtqWRqs5ft4wQaxQbE3US+pusOZbtpO2oOEwEyMTcvFFPNr7mWOSx9p/0KOE2IiQ==
X-Received: by 2002:a17:907:6d07:b0:a62:e281:4e4c with SMTP id a640c23a62f3a-a62e2814f08mr809481266b.50.1716985596108;
        Wed, 29 May 2024 05:26:36 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a626c93a83esm714768966b.58.2024.05.29.05.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 05:26:35 -0700 (PDT)
Date: Wed, 29 May 2024 13:26:31 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v3 09/12] KVM: arm64: VHE: Add test module for hyp kCFI
Message-ID: <lsb5l4ee4unh76r25x6lx5lgncoxsjfy3q6xeuncv3efhs7jzm@bzdwf6j274et>
References: <20240510112645.3625702-1-ptosi@google.com>
 <20240510112645.3625702-10-ptosi@google.com>
 <20240513172120.GA29051@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240513172120.GA29051@willie-the-truck>

Hi Will,

Thanks for the review!

I've addressed all your comments in v4, except for the one below.

On Mon, May 13, 2024 at 06:21:21PM +0100, Will Deacon wrote:
> On Fri, May 10, 2024 at 12:26:38PM +0100, Pierre-Clément Tosi wrote:
> > In order to easily periodically (and potentially automatically) validate
> > that the hypervisor kCFI feature doesn't bitrot, introduce a way to
> > trigger hypervisor kCFI faults from userspace on test builds of KVM.
> > 
> > Add hooks in the hypervisor code to call registered callbacks (intended
> > to trigger kCFI faults either for the callback call itself of from
> > within the callback function) when running with guest or host VBAR_EL2.
> > As the calls are issued from the KVM_RUN ioctl handling path, userspace
> > gains control over when the actual triggering of the fault happens
> > without needing to modify the KVM uAPI.
> > 
> > Export kernel functions to register these callbacks from modules and
> > introduce a kernel module intended to contain any testing logic. By
> > limiting the changes to the core kernel to a strict minimum, this
> > architectural split allows tests to be updated (within the module)
> > without the need to redeploy (or recompile) the kernel (hyp) under test.
> > 
> > Use the module parameters as the uAPI for configuring the fault
> > condition being tested (i.e. either at insertion or post-insertion
> > using /sys/module/.../parameters), which naturally makes it impossible
> > for userspace to test kCFI without the module (and, inversely, makes
> > the module only - not KVM - responsible for exposing said uAPI).
> > 
> > As kCFI is implemented with a caller-side check of a callee-side value,
> > make the module support 4 tests based on the location of the caller and
> > callee (built-in or in-module), for each of the 2 hypervisor contexts
> > (host & guest), selected by userspace using the 'guest' or 'host' module
> > parameter. For this purpose, export symbols which the module can use to
> > configure the callbacks for in-kernel and module-to-built-in kCFI
> > faulting calls.
> > 
> > Define the module-to-kernel API to allow the module to detect that it
> > was loaded on a kernel built with support for it but which is running
> > without a hypervisor (-ENXIO) or with one that doesn't use the VHE CPU
> > feature (-EOPNOTSUPP), which is currently the only mode for which KVM
> > supports hypervisor kCFI.
> > 
> > Allow kernel build configs to set CONFIG_HYP_CFI_TEST to only support
> > the in-kernel hooks (=y) or also build the test module (=m). Use
> > intermediate internal Kconfig flags (CONFIG_HYP_SUPPORTS_CFI_TEST and
> > CONFIG_HYP_CFI_TEST_MODULE) to simplify the Makefiles and #ifdefs. As
> > the symbols for callback registration are only exported to modules when
> > CONFIG_HYP_CFI_TEST != n, it is impossible for the test module to be
> > non-forcefully inserted on a kernel that doesn't support it.
> > 
> > Note that this feature must NOT result in any noticeable change
> > (behavioral or binary size) when HYP_CFI_TEST_MODULE = n.
> > 
> > CONFIG_HYP_CFI_TEST is intentionally independent of CONFIG_CFI_CLANG, to
> > avoid arbitrarily limiting the number of flag combinations that can be
> > tested with the module.
> > 
> > Also note that, as VHE aliases VBAR_EL1 to VBAR_EL2 for the host,
> > testing hypervisor kCFI in VHE and in host context is equivalent to
> > testing kCFI support of the kernel itself i.e. EL1 in non-VHE and/or in
> > non-virtualized environments. For this reason, CONFIG_CFI_PERMISSIVE
> > **will** prevent the test module from triggering a hyp panic (although a
> > warning still gets printed) in that context.
> > 
> > Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_cfi.h     |  36 ++++++++
> >  arch/arm64/kvm/Kconfig               |  22 +++++
> >  arch/arm64/kvm/Makefile              |   3 +
> >  arch/arm64/kvm/hyp/include/hyp/cfi.h |  47 ++++++++++
> >  arch/arm64/kvm/hyp/vhe/Makefile      |   1 +
> >  arch/arm64/kvm/hyp/vhe/cfi.c         |  37 ++++++++
> >  arch/arm64/kvm/hyp/vhe/switch.c      |   7 ++
> >  arch/arm64/kvm/hyp_cfi_test.c        |  43 +++++++++
> >  arch/arm64/kvm/hyp_cfi_test_module.c | 133 +++++++++++++++++++++++++++
> >  9 files changed, 329 insertions(+)
> >  create mode 100644 arch/arm64/include/asm/kvm_cfi.h
> >  create mode 100644 arch/arm64/kvm/hyp/include/hyp/cfi.h
> >  create mode 100644 arch/arm64/kvm/hyp/vhe/cfi.c
> >  create mode 100644 arch/arm64/kvm/hyp_cfi_test.c
> >  create mode 100644 arch/arm64/kvm/hyp_cfi_test_module.c
> > 
> > diff --git a/arch/arm64/include/asm/kvm_cfi.h b/arch/arm64/include/asm/kvm_cfi.h
> > new file mode 100644
> > index 000000000000..13cc7b19d838
> > --- /dev/null
> > +++ b/arch/arm64/include/asm/kvm_cfi.h
> > @@ -0,0 +1,36 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Copyright (C) 2024 - Google Inc
> > + * Author: Pierre-Clément Tosi <ptosi@google.com>
> > + */
> > +
> > +#ifndef __ARM64_KVM_CFI_H__
> > +#define __ARM64_KVM_CFI_H__
> > +
> > +#include <asm/kvm_asm.h>
> > +#include <linux/errno.h>
> > +
> > +#ifdef CONFIG_HYP_SUPPORTS_CFI_TEST
> > +
> > +int kvm_cfi_test_register_host_ctxt_cb(void (*cb)(void));
> > +int kvm_cfi_test_register_guest_ctxt_cb(void (*cb)(void));
> 
> Hmm, I tend to think this indirection is a little over the top for a test
> module that only registers a small handful of handlers:
> 
> > +static int set_param_mode(const char *val, const struct kernel_param *kp,
> > +			 int (*register_cb)(void (*)(void)))
> > +{
> > +	unsigned int *mode = kp->arg;
> > +	int err;
> > +
> > +	err = param_set_uint(val, kp);
> > +	if (err)
> > +		return err;
> > +
> > +	switch (*mode) {
> > +	case 0:
> > +		return register_cb(NULL);
> > +	case 1:
> > +		return register_cb(hyp_trigger_builtin_cfi_fault);
> > +	case 2:
> > +		return register_cb((void *)hyp_cfi_builtin2module_test_target);
> > +	case 3:
> > +		return register_cb(trigger_module2builtin_cfi_fault);
> > +	case 4:
> > +		return register_cb(trigger_module2module_cfi_fault);
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +}
> 
> Why not just have a hyp selftest that runs through all of this behind a
> static key? I think it would simplify the code quite a bit, and you could
> move the registration and indirection logic.

I agree that the code would be simpler but note that the resulting tests would
have a more limited coverage compared to what this currently implements. In
particular, they would likely miss issues with the failure path itself (e.g.
[1]) as the synchronous exception would need to be "handled" to let the selftest
complete. OTOH, that would have the benefit of not triggering a kernel panic,
making the test easier to integrate into existing CI suites.

However, as the original request for those tests [2] was specifically about
testing the failure path, I've held off from modifying the test module (in v4)
until I get confirmation that Marc would be happy with your suggestion.

[1]: https://lore.kernel.org/kvmarm/20240529121251.1993135-2-ptosi@google.com/
[2]: https://lore.kernel.org/kvmarm/867ci10zv6.wl-maz@kernel.org/

Thanks,

Pierre

> 
> Will

