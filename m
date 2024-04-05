Return-Path: <kvm+bounces-13712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 865DE899D7F
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 14:48:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD82E2821CF
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 12:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1584E16D330;
	Fri,  5 Apr 2024 12:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="LygshMJa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6931116C872
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 12:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712321300; cv=none; b=kdTWyohMHm4KOpl7aeMBgivhuiBbp1q4RXOLX28agH2y/RwHbq2QIAfLeoBA7FMBlz+xitw+W8L1p3ZC0Pgk2jGAZsxmGzjknp40jjyN2Te64sv2BsHHgwEfICYY/VYAMDr5K3pRtm386qPn41zwcxDh+UHw+yPDbNnycjzLqWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712321300; c=relaxed/simple;
	bh=BONgaXjClX5aEfbEB3Q+2CYsd4fxx1TEbZSRiK4eotQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IvoAZFPtfgKKAEQL84f6WkJDYPprUwnJCtu1x46GE+p6jcTimuGv6N0TzbNLVEe1SuVLi7i8DSnmIFzWxqFRaMj8cDke9wPfBynvKUC4YM0/XjsY/wT6FF4mMRCBjyJy+NX1InyhlnwtkT/8QZAOS/xaUbObSSHsrfIcSNeHZMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=LygshMJa; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-516d0162fa1so2152266e87.3
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 05:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1712321296; x=1712926096; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1gqJXCFhYHxuGeDzQHXUm6mF/uMGESwP7Rig2uzwTrg=;
        b=LygshMJaABTCZqCx6+P+EmHvxM1yc6UNRUC35sQIxhDLEK/gGW6rcPXZ5InNIIx3Np
         jC/H9uymGWyvnBTFyB8R0++8ryBQTNLNWC8lqG30PBaVSTY87HgfH6m5O+87MVxjPljP
         UefsPmHYAnaf8gUlgS0eb9cVbhV6aOi7xnjUOPIFpHmesGHunlIBrIeEmZgX6mh/irAK
         r2UWBke4zqMLOyBrYxa2RPTJp09A1V61NL8skX9o/VGlbyN9pcFqg+dxP4q85K338sDr
         geyJZAre8QylqwSQG22OIRtAHQGfpgADRGuNYid6Nep76eSn5T3nlaNvjSRwqf/2gtoo
         wcgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712321296; x=1712926096;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1gqJXCFhYHxuGeDzQHXUm6mF/uMGESwP7Rig2uzwTrg=;
        b=GeY75g1s3EuGN7XJBmG2VdXqajQyl8abRXU4Ej1v6LunFDMMA1Inpx6SxxLU9i8BL5
         QIjEmfAIAigHYf5omtVtzxK/UK296n1YzDSQL0eLfbWlnK1qoZQI9EDqqf3BHcOkkd26
         g8yk7qZWRPdh832uucSJKhAn9tLl6XrTps32Q8G8pFcuJV9t1YMVeVMjjbse1eAUek1+
         gbNxfJY01RC83kx2Mpv7vXU0DX/tj6Be+t9E4VN81Ra+zpZQckOrAyEqODvlSrH8nGgI
         t3fDaC8qojQvhlMyjG5rgFAmkko0hKT1IrLgrAu286835dGmMP4XcqnwCgcpH0fVAZZX
         5YFA==
X-Forwarded-Encrypted: i=1; AJvYcCWX8pgPpU/9kNxU0bpKrJSyamSxlJBIBafACVa5b22NMu1V0i1AA9J5U0eZ9Z4v/V8Ljk8wjUFgNIwLks3cse3cKr5Z
X-Gm-Message-State: AOJu0YwInJpq5Pa2k7LvQgCoVJySbvZd4YM060PiZCAMgY0Hko2tCuQU
	oWYT4LjPu9FUoRMDhLOf9MVnXBKHdDHDfR7XxS6aQ0becOJyGzAL9YHEPQ4VUJUV1jXqSk95HFn
	C
X-Google-Smtp-Source: AGHT+IFEgm+u9cR3VSBSNQtYk5knjRxPrUMvf+kSAsf2mgyfdrQjMfXWeVpxY5HnY8fvu518V/oPuQ==
X-Received: by 2002:ac2:446d:0:b0:513:eeaa:8f1f with SMTP id y13-20020ac2446d000000b00513eeaa8f1fmr1128144lfl.47.1712321296604;
        Fri, 05 Apr 2024 05:48:16 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id n20-20020aa7c694000000b0056c56d18d07sm761088edq.48.2024.04.05.05.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 05:48:16 -0700 (PDT)
Date: Fri, 5 Apr 2024 14:48:15 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@atishpatra.org>
Cc: Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Anup Patel <anup@brainfault.org>, Conor Dooley <conor.dooley@microchip.com>, 
	Guo Ren <guoren@kernel.org>, Icenowy Zheng <uwu@icenowy.me>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Shuah Khan <shuah@kernel.org>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 13/15] KVM: riscv: selftests: Add SBI PMU selftest
Message-ID: <20240405-3242460b23ce1daf905242df@orel>
References: <20240229010130.1380926-1-atishp@rivosinc.com>
 <20240229010130.1380926-14-atishp@rivosinc.com>
 <20240302-ed6c516829dc0ed616f39a45@orel>
 <CAOnJCUK2D6-zP4=DiXRMeFQsMc9iG5nWY-yYHMhg83h_q+OtnQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOnJCUK2D6-zP4=DiXRMeFQsMc9iG5nWY-yYHMhg83h_q+OtnQ@mail.gmail.com>

On Tue, Apr 02, 2024 at 01:34:54AM -0700, Atish Patra wrote:
...
> > > +static void guest_illegal_exception_handler(struct ex_regs *regs)
> > > +{
> > > +     __GUEST_ASSERT(regs->cause == EXC_INST_ILLEGAL,
> > > +                    "Unexpected exception handler %lx\n", regs->cause);
> >
> > Shouldn't we be reporting somehow that we were here? We seem to be using
> > this handler to skip instructions which don't work, which is fine, if
> > we have some knowledge we skipped them and then do something else.
> > Otherwise I don't understand.
> >
> 
> This is only used in test_vm_basic_test to validate that the guest
> will get an illegal
> exception if they try to access without configuring first.

Yeah, that's good. I just don't see how we know we were ever here. We
either got the exception and then stepped over the CSR read or we did
the CSR read. Either way, the test progresses the same. Shouldn't this
induce a test skip or something instead?

> > > +
> > > +     counter_value_post = read_counter(counter, ctrinfo_arr[counter]);
> > > +     __GUEST_ASSERT(counter_value_post > counter_value_pre,
> > > +                    "counter_value_post %lx counter_value_pre %lx\n",
> > > +                    counter_value_post, counter_value_pre);
> > > +
> > > +     /* Now set the initial value and compare */
> > > +     start_counter(counter, SBI_PMU_START_FLAG_SET_INIT_VALUE, counter_init_value);
> >
> > We should try to confirm that we reset the counter, otherwise the check
> > below only proves that the value we read is greater than 100, which it
> > is possible even if the reset doesn't work.
> >
> 
> Hmm. There is no way to just update the counter value without starting
> it. Reading it without stopping is not reliable.
> Maybe we can do this.
> 
> 1. Reset it to 100. Stop it immediately after and read it. Let's say
> the value is X
> 2. Now reset it to counter  X + 1000.
> 3. Do the validation with the above reset value in #2.
> 
> Wdyt ?

OK

Thanks,
drew

