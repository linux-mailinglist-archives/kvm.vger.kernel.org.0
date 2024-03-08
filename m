Return-Path: <kvm+bounces-11362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 468AC875EDD
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 08:53:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB2621F23608
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 07:53:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AE614F8A9;
	Fri,  8 Mar 2024 07:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="nWC6iOOI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAC84F5FC
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 07:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709884390; cv=none; b=hUEzOZ9RNlSeCqtU7Q7dXMM2KrLJ6Jr1UeGKG2etA64PfY2tNVRyUiNld8m0gOm2PZdQhIVfo+FZOa4myxSGhFb46G784d310x3m2NtlwwSdKqzap2dHB/GRnsT9lQm5Fg+OSWqUowpcnoORNbDTrZbRqc/D//4Av481eRLWg1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709884390; c=relaxed/simple;
	bh=/JCwJPffdIEDQLzjTwDXYjywLsFs5AnpuWxe1WBILHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KsepFOIH8NZJmD+N8TeJTHJKC4AInNNjn+lKt4s2TH1XLbD2tzB18osqRIzLb5b6IbRohfo+HVl2ULJY0y8/h5Tgn1fz0Hw96JQuHEKFPD89FtIOzf4GQ7V1l3CmaB8y6LRjKoelzAPtFk8Fjfo428r1ngKn0i88PrjFZdH0K/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=nWC6iOOI; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4131bbb7fbcso36315e9.2
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 23:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709884387; x=1710489187; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YMX300WmqP7OPP0k2s8oRpai64z6fg6Nih1X4pJ5ZrY=;
        b=nWC6iOOIcUsQvyXOhYPCj1hQLZjHRe8drWpKKbcmSsGYFH/oQOij2YoqMKqT8JYXXJ
         IdD/vVHgMUZWp6QhTmhpmjuAI9am03noQdKafgzynR5snulSuOydqkuX3B/EbmqxBfs1
         jEPBZaQSqqRAezTPHvbLXEx7x6q9Od9pKoG5tpDCIQUkuPtNF86xt/4jhOt0uTLYCE2C
         lOAfe3No32RpStAJ8og9xVteDOBF+49cRQcAVk83tRsdd8yge/MOLknOOvsFAzqj9hRE
         rpExLWNsYkGQtC1WtTQyyOTULZWrgGkIxYDLbod8rGvx8VQPbcTR/ZKfke7shca94xXi
         sy2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709884387; x=1710489187;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YMX300WmqP7OPP0k2s8oRpai64z6fg6Nih1X4pJ5ZrY=;
        b=s271MmySzjT29O1NQQEr8S4Pg3G8yK2aUjKNc7mh8AIMxk+ZW9IRK2BpvvdOf6SNq0
         uX63MpI2z1r5cjQTBMDKbNsMpRURwVAsL8EuKsrxIg7SzXW8hnseX4yO9J5YwAHvkh6l
         +j58MDzF+UeKHvF8KJFXvgvo0qsdQ0FQt2SXwGuB40OD96va3QR0ffcwqm1wFcv78+iL
         hrTuwWI3MaCFitMi90sFGhC0/9Silg7vShu8P4EQQiWQhmYQ4ZE+YtM5NmtMVTzwGsCQ
         LW5j2HWsvEheC6noPVAB1Xacu2tI4YBsLjZEFwU9DFu397OAsvsxCUDOQXAogxz3wOI7
         Ae3Q==
X-Forwarded-Encrypted: i=1; AJvYcCW2FPIjAYNnpz5tab0+aqhfNSJq2u0MAvuPxmaW4gKWaXIuUOVVGExazevqrKA4Kb27GIOlK5Lb6+8ZsyBVWrJnXI5c
X-Gm-Message-State: AOJu0YyeT4xsZZoEhGa6DJXYml+vAoZ22METaw7A6C9+IFKYiQwa6ofo
	0hEiT8JCEDvxbEgX1Pxdlj86fvMYOJFXN51xFJw7FFFAknnCBeT2POc4C0KMdnU=
X-Google-Smtp-Source: AGHT+IFRvPfPH7sazFwQQwkcYiePuHoemGv4c5hK5Fr4v1LmmXzLFkOofwB/Xfp3tyRgkLrI76lnvQ==
X-Received: by 2002:a05:600c:468a:b0:412:b0d3:62f4 with SMTP id p10-20020a05600c468a00b00412b0d362f4mr15571185wmo.26.1709884386947;
        Thu, 07 Mar 2024 23:53:06 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id w11-20020a05600c474b00b004130fef5134sm4546585wmo.11.2024.03.07.23.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 23:53:06 -0800 (PST)
Date: Fri, 8 Mar 2024 08:53:05 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, linux-riscv <linux-riscv@lists.infradead.org>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.9
Message-ID: <20240308-5d406beb72ee7f30f894c45d@orel>
References: <CAAhSdy1rYFoYjCRWTPouiT=tiN26Z_v3Y36K2MyDrcCkRs1Luw@mail.gmail.com>
 <Zen8qGzVpaOB_vKa@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zen8qGzVpaOB_vKa@google.com>

On Thu, Mar 07, 2024 at 09:43:04AM -0800, Sean Christopherson wrote:
...
> But the prototype of guest_get_vcpuid() is in common code.  Which isn't a huge
> deal, but it's rather undesirable because there's no indication that its
> implementation is arch-specific, and trying to use it in code built for s390 or
> x86 (or MIPS or PPC, which are on the horizon), would fail.  I'm all for making
> code common where possible, but going halfway and leaving a trap for other
> architectures makes for a poor experience for developers.
>

I've got a few other riscv kvm selftests cleanup patches locally queued.
I'll add another one which moves the prototype to include/riscv/processor.h
and include/aarch64/processor.h. Making guest_get_vcpuid() common (for
which I think I'm to blame) was premature and, as you point out, it should
have at least been named arch_guest_get_vcpuid(). I could do the rename
instead, but since I'm not sure if it'll ever get adopted outside riscv
and aarch64, I'll just move for now.

Thanks,
drew

