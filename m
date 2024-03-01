Return-Path: <kvm+bounces-10645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 41DAD86E2A8
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 14:45:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C61A7B23B2F
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 13:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4585F6D1C8;
	Fri,  1 Mar 2024 13:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="OfLa6Njb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EEC6D1A4
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 13:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709300746; cv=none; b=Z0vxnDqM6bIC09NMKqMPAMv4PBpu3QUlYu8bzECAgJvAMlXTZwCep5IqVJghKg3/NARKYeVSueWzwNqnpQpCnb/nm17gD0FyJ8bKk1DlPavUsE3T9NsqsjZkRbcMiTjKfyvA4bUDOtt+qeFc7/xecmIoKsldrSV1v4FjbR1LFog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709300746; c=relaxed/simple;
	bh=wpL4ltZWaXYI2Sx4HOhz+whfpsMIHIYkKd3J//8TyTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HW6VIW25wGNweeTO3eNq5j2I4mwOu31kbDV9RzduHfijU6fkEV60nnLqSGX1B8lJlOu/Or/NL2XvzRLSXUSq3PFU/PUCvdT9botEt+eSVpPvDI1QRvtdCxL8tC3lKDt3NNQErSheXh4gMEGNL99QYHn0K+VFFxj6BYY731mXd3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=OfLa6Njb; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a445587b796so230244966b.1
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 05:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709300742; x=1709905542; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tVgbEQ4kyQbtblCUPkOlRv+wZVI/qCCBeziGpPNTTHM=;
        b=OfLa6NjbAmvOSBAgCQ1PP0V3pkj6hhrMWacPr/QL1Nzlhhr2BnzzIxeMgxXK8l0wPo
         LHfYA9V+uPR6LY0pcHMCSIT34Jax3UvliDHOij3rtaUzZWYqJr/CU31P6tGJ7li3erQY
         Hifld1uSC2Rg/Lbhy0QFuIaCcS0xUBcYX4lMhomexcAgEjD32ZFtgxgV4hhv01AKQZrj
         oMmHZuWJVSQMXGa/0yK675d4oSKDTyfL1pOfArVAubqdZPonMETIGmKra0WO6rKUfkWp
         vXZDOYaM536q4ICdX9X2SbsyKwwf2Nhjo2SxuOhwMCS0Thh/TQuldiOK6Fybn/Dt+JCT
         fKFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709300742; x=1709905542;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tVgbEQ4kyQbtblCUPkOlRv+wZVI/qCCBeziGpPNTTHM=;
        b=E62iGCQf/8ZnOQwI8nbgB9feSE70ejM2dfyKlBcFYY4PRDWJGPbD8E9BJGdDcBiWf4
         rkUzwMy2YrpJe5jvE8BMXkFnrnsQY78wCZSSAxhQBenU4i+OAZYpWNDWM5tYquN3ZZX1
         BE3oKY6dZFfOWdcBl5x54PMmcIs7ygaIuBXyWbbdc+bkPhUx/fm3AhOYrJ27AeAVRS0T
         /6rJsO6YKhQaN9C5cKjPaeAlkMvlAvVgmqeOTdvAcWCnxRz4r2HSncGBTy0ils5AXfrF
         2nX34lUeeRlXPlDnq4VA3ui9GyRUKtFYo+wDBE9aLvxNpMsorvvmseOb2xmjT/BXoa4u
         gMXw==
X-Forwarded-Encrypted: i=1; AJvYcCUHalff9lw0PCN/u5AMiUTh0GFHkGbLXCm3ab0/OaIJir9LXJ6T0+IqMtO9iivmJRvY4fHRz4A9pnvr3ai6kj8WI1Vx
X-Gm-Message-State: AOJu0Yx6HS/VWIUwNgqeWIHPax0X+4UnXojhAH2pSvwFtLxHL1gxAkz9
	1mzDovI6jHgG/CZYg/BARG1P6xyzBfRAc46VbiTMFSpSrha0k00MEzB2YNXdlD4=
X-Google-Smtp-Source: AGHT+IEUmgSAurOUDe9d1ZRfnCdJozDY6XtBUZXROZY7Us5XumAjIbS9btAdtfpRWlh4RA5xIiOf/g==
X-Received: by 2002:a17:906:b84e:b0:a43:292c:7c38 with SMTP id ga14-20020a170906b84e00b00a43292c7c38mr1231239ejb.14.1709300742389;
        Fri, 01 Mar 2024 05:45:42 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id lb24-20020a170906add800b00a4131367204sm1704722ejb.80.2024.03.01.05.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 05:45:42 -0800 (PST)
Date: Fri, 1 Mar 2024 14:45:41 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, 
	Laurent Vivier <lvivier@redhat.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 14/32] powerpc: general interrupt tests
Message-ID: <20240301-65a02dd1ea0bc25377fb248f@orel>
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-15-npiggin@gmail.com>
 <1b89e399-1160-4fca-a9d7-89d60fc9a710@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b89e399-1160-4fca-a9d7-89d60fc9a710@redhat.com>

On Fri, Mar 01, 2024 at 01:41:22PM +0100, Thomas Huth wrote:
> On 26/02/2024 11.12, Nicholas Piggin wrote:
> > Add basic testing of various kinds of interrupts, machine check,
> > page fault, illegal, decrementer, trace, syscall, etc.
> > 
> > This has a known failure on QEMU TCG pseries machines where MSR[ME]
> > can be incorrectly set to 0.
> 
> Two questions out of curiosity:
> 
> Any chance that this could be fixed easily in QEMU?
> 
> Or is there a way to detect TCG from within the test? (for example, we have
> a host_is_tcg() function for s390x so we can e.g. use report_xfail() for
> tests that are known to fail on TCG there)

If there's nothing better, then it should be possible to check the
QEMU_ACCEL environment variable which will be there with the default
environ.

> 
> > @@ -0,0 +1,415 @@
> > +/*
> > + * Test interrupts
> > + *
> > + * Copyright 2024 Nicholas Piggin, IBM Corp.
> > + *
> > + * This work is licensed under the terms of the GNU LGPL, version 2.
> 
> I know, we're using this line in a lot of source files ... but maybe we
> should do better for new files at least: "LGPL, version 2" is a little bit
> ambiguous: Does it mean the "Library GPL version 2.0" or the "Lesser GPL
> version 2.1"? Maybe you could clarify by additionally providing a SPDX
> identifier here, or by explicitly writing 2.0 or 2.1.

Let's only add SPDX identifiers to new files.

Thanks,
drew

