Return-Path: <kvm+bounces-44720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B446FAA069B
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 11:06:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 187921883A4D
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 09:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEB8A29DB85;
	Tue, 29 Apr 2025 09:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="M15X/Gvq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3722327F75A
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 09:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745917564; cv=none; b=SQ9AqOfRIJ9i7CxojNTLQ+h3mdVuoCIRh4gAYI7KQv1dmVWlXy3IM4Kwvbr78xtF0IAV+lETNwcIWTN9yXqe/ecyrAHKr+9WXVV39xT9jTvXJ8Yg4q7FLJdHfPnm1hC8DtGAbRbeT9z4hnkvxTN9q/i0RmNxPi1s0jvFFklCDjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745917564; c=relaxed/simple;
	bh=M2PUNSlDRsRs/DFNkJvrrRwh6F5RSdQsCwiq8JtjP0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MjoOEAhSobQomNooCdCbBKv9m1SasQVa2krZhOhIld8+k/Y1BKAE+xeMes0RnANbPldsE8TwlyclVQbIobgIZzghRlEbJFib1PMRaoJWcBTPdFU+k2UeLC8BBJd4OJI/eMHeGwn63Tf5Ogbc3iBTv7LWmNWMXYiIVc5i2gFUFWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=M15X/Gvq; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-39c13fa05ebso3756726f8f.0
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 02:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745917560; x=1746522360; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KatqGhsrZH+ZioIyyPM0GHZkF6RidX+RSSACu/Ebkcw=;
        b=M15X/GvqMo0dU6v3IhyX/0PWlPXLLI/oAcaQBj/gmuyvwjs5e+OEjVGcNwFkYvmyLG
         d2tbAh1q/V7sM8bWnjyEI114pK8SpSDXRNjAtmZ9O7lNWXYs3A9n1kJ73j/sM3Fk+kyr
         HE6eEDFfsOFY35PS+1SRPneogoR067UXTHjxeQGgqtKvAcJcdq9DLRbQxUyKgrxZrBRP
         SXLGAfXyCVoLD/ZFutUfFULB0jW+MRjqriLM9/J80A1pkpE1vhLAB6faQuZSRa7+s6qH
         ixCfTsyeJC6iif90PcmKRjGcZnrv+8Haov/MsjyqiN2qCIyGpRRnSdpmTORsLvngLjDj
         zduA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745917560; x=1746522360;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KatqGhsrZH+ZioIyyPM0GHZkF6RidX+RSSACu/Ebkcw=;
        b=vJ+jQOpbdO3c5RdjxCBAoTYc435wU+YcC5w+cXVnz1zkSwsfG7TUt6YYEcEmdpJEca
         d7qw4wpmki/eiJSAQtjfPyrYv8MIkdAllG4R8qfNSmIBPEj04KZDkS3InkLRc1LXx/pG
         repy2frueyBsH+tQMgZMoqoZB0bhkGKSa5pooxe/9M0K+/EEfMES2njEq8jMRuAQGXxX
         dw/qW57A1o5Ove6HXqjwgqgsHAuZmmyp3LoJg/6yBr9XSd/fx2NrmvMU5vchZP1B8uXN
         MMSvjTlfuUg4j+Mvg2H9XleyF44NLujtn0hhh0g++k89jmr7OY2bh/l9DKrVYOt8cMMq
         tITQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIUqrc2B68GIx7aPVwDJWxm/YnQBIHh/P4VDVV83c/8mcGPZ25mnkjq1XookNbs0YRje0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMgxERWpfFlYzh5uHVnZsmmxrCiRNAyO7ldgrHl+EDxsC5Isco
	YbzwlrCTggxyAlO59TyU+ACD6uRn0zVZkITr8pgwBNU+bPC9FsoRCsNM2dNuISE=
X-Gm-Gg: ASbGncvHgJVbD6Ppazfu07ZN3wVvohfUavwwcls/QsEf/AXqHDslomDJ4OnhEWcI5TP
	DI/5MsELyPnyfQexGwXJeAWcFblMZHTWRxz7AK+Mtx1NuKg7PKMtM5jpaVZM/5JPkn4iHDcT1Bb
	Tvw2MpLfCCOII58h2augKyOcttpW0V3h5VUPXM2bfBpQXxB9jrvcl8hi8vnB23CBG39BPWElHzJ
	YnQyMyDfoi+2b/pE7y5QABzaKJ3qT0uYGWR8nlDvSbnOufybM75PjokkJOgR91KlO4SaGStSYsb
	y56dClokdXJqE49KZAE6Es2XVUl7
X-Google-Smtp-Source: AGHT+IGkl5qjiabpogb2jkKx++DcNwNz6kC3SVaUoXxULD2fuawYRLha0X61n1NZ+hz8YxEyViubjg==
X-Received: by 2002:a5d:6903:0:b0:390:eacd:7009 with SMTP id ffacd0b85a97d-3a07ab9be44mr6194393f8f.42.1745917560430;
        Tue, 29 Apr 2025 02:06:00 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f716])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073e5da02sm13462185f8f.93.2025.04.29.02.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 02:06:00 -0700 (PDT)
Date: Tue, 29 Apr 2025 11:05:59 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: riscv: selftests: Add stval to exception
 handling
Message-ID: <20250429-683f10a791d9ec41b060ec4a@orel>
References: <20250324-kvm_selftest_improve-v1-0-583620219d4f@rivosinc.com>
 <20250324-kvm_selftest_improve-v1-1-583620219d4f@rivosinc.com>
 <20250425-dc44cb547ab5e2f994c94e80@orel>
 <3b05d1a0-c873-4e61-b98c-b725d0dbb350@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3b05d1a0-c873-4e61-b98c-b725d0dbb350@linux.dev>

On Mon, Apr 28, 2025 at 03:47:47PM -0700, Atish Patra wrote:
> 
> On 4/25/25 6:50 AM, Andrew Jones wrote:
> > On Mon, Mar 24, 2025 at 05:40:29PM -0700, Atish Patra wrote:
> > > Save stval during exception handling so that it can be decoded to
> > > figure out the details of exception type.
> > > 
> > > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > > ---
> > >   tools/testing/selftests/kvm/include/riscv/processor.h | 1 +
> > >   tools/testing/selftests/kvm/lib/riscv/handlers.S      | 2 ++
> > >   2 files changed, 3 insertions(+)
> > > 
> > > diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tools/testing/selftests/kvm/include/riscv/processor.h
> > > index 5f389166338c..f4a7d64fbe9a 100644
> > > --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> > > +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> > > @@ -95,6 +95,7 @@ struct ex_regs {
> > >   	unsigned long epc;
> > >   	unsigned long status;
> > >   	unsigned long cause;
> > > +	unsigned long stval;
> > >   };
> > >   #define NR_VECTORS  2
> > > diff --git a/tools/testing/selftests/kvm/lib/riscv/handlers.S b/tools/testing/selftests/kvm/lib/riscv/handlers.S
> > > index aa0abd3f35bb..2884c1e8939b 100644
> > > --- a/tools/testing/selftests/kvm/lib/riscv/handlers.S
> > > +++ b/tools/testing/selftests/kvm/lib/riscv/handlers.S
> > > @@ -45,9 +45,11 @@
> > >   	csrr  s0, CSR_SEPC
> > >   	csrr  s1, CSR_SSTATUS
> > >   	csrr  s2, CSR_SCAUSE
> > > +	csrr  s3, CSR_STVAL
> > >   	sd    s0, 248(sp)
> > >   	sd    s1, 256(sp)
> > >   	sd    s2, 264(sp)
> > > +	sd    s3, 272(sp)
> > We can't add stval without also changing how much stack we allocate at the
> > top of this macro, but since we need to keep sp 16-byte aligned in order
> > to call C code (route_exception()) we'll need to decrement -8*36, not
> 
> Yes. Thanks for catching that.
> 
> > -8*35. Or, we could just switch struct ex_regs to be the kernel's struct
> > pt_regs which has 36 unsigned longs. The 'badaddr' member is for stval and
> > the additional long is orig_a0.
> 
> I think switching to pt_regs is better in terms of maintainability in the
> future.
> I will do that.
> 
> > >   .endm
> > >   .macro restore_context
> > I guess we should restore stval too.
> 
> Do we ?  stval is written by hardware and doesn't contain any state of the
> interrupted program.
> Once, the trap handler processes the trap using stval information, there is
> no need to restore it.

True. It just felt unbalanced.

Thanks,
drew

> 
> Am I missing something ?
> 
> > Thanks,
> > drew
> > 
> > > -- 
> > > 2.43.0
> > > 
> > > 
> > > -- 
> > > kvm-riscv mailing list
> > > kvm-riscv@lists.infradead.org
> > > http://lists.infradead.org/mailman/listinfo/kvm-riscv

