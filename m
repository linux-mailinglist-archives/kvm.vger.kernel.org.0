Return-Path: <kvm+bounces-14075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EBCF89EBBB
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 09:20:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9083281C3C
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 07:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C12213CA94;
	Wed, 10 Apr 2024 07:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="E+7HpyAs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCF713C9A3
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 07:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712733648; cv=none; b=D8vzRIjmue+rWRxxy06IerL5j+urhUwVROjoZQVk+1ZuuDBzNaNo3BrqfQ8x4NCG+A+pXnlXmF1f+DZl/oHZGgMmrSankvIFpoT6sDBqkDfUF496f3eIJd9jU7iOLHBGR3LG84ADbGbF5fXbIBf7BkFCQsMtffZmUYpxt4mXshw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712733648; c=relaxed/simple;
	bh=rx19adIEtRfFuy8+v22L05S/+p5rIRJ/JcnvLnEFh7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lAsTKnmBsTJ+2lqgSQCnp1bOd0E/Dx6pxpc3I2TbkyZKDqWbL45SHY8IZe74sA6u30vrWD/vbonJLV6O3DNSjfA4F8MvEHsmPR4Eb9zZdOnHwFoASnRfV4JkPuPWJO2SThmuBMKvXQdxVTzHWAhwVFnbC5NicjQgT3d9kvave6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=E+7HpyAs; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-56e509baddaso3265015a12.1
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 00:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1712733645; x=1713338445; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uLhNuIrSaoYe/9NO2TgswlnfBaBCyzfaiiheEplZdqE=;
        b=E+7HpyAscsvxzlxlbX2LdRHPXl2tyDpBbOoYQdqJqRB1lt/ibuAQaxU69TFWBkz+Ek
         oUFYbBWYjSFLkh6agnL1JbQD5tdToy83+q5LwEMYxCpA3J2axwWWiC2GD5oEobqa/Oo5
         9EK8GHhn/U15sXVJcqnHlDG+22FQFYCRm4ETn6nkyQOrXNA5VpRit4mTKw7+YoXUvyk2
         ZSgcj4RXPUbkV5Ug6B9t2KAUirmQNUJDePxb7MZw+vIxEJChx2UJZlAiww9iEenSxobX
         ronns2mXYGlYWCBo/8s13bmENjrC0aMtZslS0SCX9wJP/mgy6Ak4k70Svorjv2QkI3Zu
         WkkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712733645; x=1713338445;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uLhNuIrSaoYe/9NO2TgswlnfBaBCyzfaiiheEplZdqE=;
        b=MtFE0nwRaJs1hs8XBL0YTm9bni62cl4G9OUHAg4AdMS5q70+1Ohvh+hNQf+z0wl3u3
         G7x/6QcGSl70WFBvi1nnQSVrgqpOK0hPOvEcwOdazyssb0xvYO6LrnNC6w0x4XahSGGW
         Hnw9ELXkISKsxFw8uWKJIgzDM8ojUKomTx2Pl8uGbdUWI3tG8H42FqlpBrfNUGRvVWNQ
         P+5Ozj84SfAxWhcQn2FQ//veNqJQgSr1y/Q5hx2t9cPuF/bIoNbolAd7uDuuDre5vGuR
         ax65JS5V6zqUuW9GtuZflb59p7DOY33e64LdXQ+L6UiQoCBpa5h3qRTzEmJGwVksk9b4
         4UhA==
X-Forwarded-Encrypted: i=1; AJvYcCX7tcM3hF07nrVnVYIpHm8IcUO74Cd/UhiNScAmuoJyKbk7ZGUUKrB0HBx1Ts9tU4prL3F7HWWHEFdTjPH0RlE47PtS
X-Gm-Message-State: AOJu0YyqDzc/06Bkdlb+VMsCP1V4QDqSkhi5z544vtGdTaBm5n/myKIM
	VJjY7u9BLC+MHhXJRYQI4XdmOmMoIL5LHZg6hqmZWHcGlKOg3FR1WqMalR/t7/4=
X-Google-Smtp-Source: AGHT+IFblqSFRNSt8LD4P6llFistdn4FvvuYpArYI85OkCLQGw80eVNjwPfQ65XS4eljatieTXAaFA==
X-Received: by 2002:a17:906:c215:b0:a51:d7f3:324b with SMTP id d21-20020a170906c21500b00a51d7f3324bmr969037ejz.66.1712733644958;
        Wed, 10 Apr 2024 00:20:44 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id jz8-20020a17090775e800b00a4672fb2a03sm6720040ejc.10.2024.04.10.00.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 00:20:44 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:20:43 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Conor Dooley <conor.dooley@microchip.com>, 
	Guo Ren <guoren@kernel.org>, Icenowy Zheng <uwu@icenowy.me>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Shuah Khan <shuah@kernel.org>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 09/15] RISC-V: KVM: Add perf sampling support for
 guests
Message-ID: <20240410-f1a4303dc73789aa6adbe730@orel>
References: <20240229010130.1380926-1-atishp@rivosinc.com>
 <20240229010130.1380926-10-atishp@rivosinc.com>
 <20240302-f9732d962e5f7c7760059f2e@orel>
 <c46c57c2-95bc-4289-ac99-efd5bad093b5@rivosinc.com>
 <20240405-de92b25fdc1ecf53770c49d9@orel>
 <388ef032-7030-47b5-bba5-852b00de7382@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <388ef032-7030-47b5-bba5-852b00de7382@rivosinc.com>

On Tue, Apr 09, 2024 at 05:11:31PM -0700, Atish Patra wrote:
> On 4/5/24 05:05, Andrew Jones wrote:
> > On Tue, Apr 02, 2024 at 01:33:10AM -0700, Atish Patra wrote:
> > ...
> > > > but it should be possible for the VMM to disable this extension in the
> > > > guest. We just need to change all the checks in KVM of the host's ISA
> > > > for RISCV_ISA_EXT_SSCOFPMF to checking the guest's ISA instead. Maybe
> > > > it's not worth it, though, if the guest PMU isn't useful without overflow.
> > > > But, sometimes it's nice to be able to disable stuff for debug and
> > > > workarounds.
> > > > 
> > > 
> > > As per my understanding, kvm_riscv_vcpu_isa_disable_allowed only returns
> > > true for those extensions which can be disabled architecturally.
> > 
> > I think kvm_riscv_vcpu_isa_disable_allowed can return true for any
> > extensions that KVM can guarantee won't be exposed in any way to the
> > guest. Extensions that cannot be disabled architecturally must return
> > false, since their instructions will still be present in the guest, even
> > if KVM doesn't want to expose them, but extensions which KVM emulates
> > can return true because KVM can choose not to emulate them. IIUC, sscofpmf
> > falls in this latter category.
> > 
> 
> hmm. The Sscofpmf is dependent on interrupt filtering via hvien and SBI PMU.
> So you are suggesting to toggle off the CSR_HVIEN bit for overflow interrupt

Yeah, this is what I was thinking.

> or do more granular disabling for privilege mode filtering in SBI PMU as
> well.
> 
> Beyond that we can't disable SBI PMU. Is that okay ? A guest can still cause
> counter overflow and interrupt the host. However, the guest won't get any
> interrupt as hvien is not set.
> 
> It can also still filter the events as that is tied with SBI PMU.
> 
> We can put more granular checks in SBI pmu but I am just wondering if it
> provides anything additional beyond just disabling the sscofpmf in device
> tree.

If it's too much of a code burden for something we're unlikely going to
want to do for anything other than debug (where removing the extension
from the device tree is likely sufficient), then that's another reason to
not allow disabling. Maybe we should write a comment above
kvm_riscv_vcpu_isa_disable_allowed which points how extensions end up
there, i.e. either KVM is powerless to completely hide it or we don't
want to maintain KVM code to completely hide it.

Thanks,
drew

