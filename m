Return-Path: <kvm+bounces-40837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21ADDA5E323
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 18:53:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63F90178345
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 17:53:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C0732512E4;
	Wed, 12 Mar 2025 17:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="kDFYZDhI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9531920ED
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 17:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741802013; cv=none; b=Euzpm8d2+RdfF6F8HQTdrCpdtfjQ3fhfd/UIeMmSJibLIObWjsttbPp3Yb9L2ABh+edA+MgRoa4TJCrfDY6GkVUyLz/8CDIoty+kJD2/ho/58AQ386qcohNo7ye73hYhv6xjrH1XKu92etpRgN+WJ9OuT+q+3cbfynx1A5Gvyfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741802013; c=relaxed/simple;
	bh=tEaKpCNO2sNewf2xAkeU+gfCRoxKRBbc2rcN+dSapjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WPkHUq4yuBVRLb9J5HomTvSw3knpZFQJZKJyxUF8I6rwbbVARenHXY1GlQo9hx1bhFTXZx59C2RaTdad7w4qyEEWJ9Ya77Gc3q8dXJjoBlj8G3z09dSdiyls/Aj32ItfBzKz1MIpu1r8fVpdnuNQObLs8IlmmmCdZk5ItPM5LU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=kDFYZDhI; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3912e96c8e8so80613f8f.2
        for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 10:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1741802010; x=1742406810; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2GVnA/UnZGLh6c1UKOgcldWecF4fsN0zEAZXlhhR3U8=;
        b=kDFYZDhIowZ2W859IGSpkZ7Ae8ZXjlejbYUL2URl0P28lJ9g4UdOhWbst/UkoWTDDt
         MVueRuokQuI7SuMAMugp0Q4lVN+1uaAR3xxrJ4gzp1AMQRgNkpWAa0zA0X4E73r/ciUt
         y08lXlr/vGliS+x8xpSmt54nGF3wHykMxshW7N+HtlnDs2Lfz35tqZoH8Hv1jPs6BAOC
         zhXoSkN+V8AYPPb308u0avFeSePMr3DHv3T2jxilumy+5fUQEIXqnRfAfPif5sMIO7JL
         M8AWYrP33WO7E4/a0roSO7eCue3zICvXUc/TS/Tm0RMpC3eUjcngBTpDWF5qpIsdzueN
         xVhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741802010; x=1742406810;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2GVnA/UnZGLh6c1UKOgcldWecF4fsN0zEAZXlhhR3U8=;
        b=WFKtxijFrAFpvV+tGexo/kBTBfj1wQDYPIIijpm17nYjwItZPRp2AQNx3DWrmwEF0Z
         nVZL/F09yOCqEGFlj6LoGgQktHFoK20p/NAzHgGAKWaH3o2T5arjKeCzDuFcPD9ozPxP
         N2STSBg8rnxMzlqCVPRxdHTuUjHIGlpv/82O4o/XX/wlV8M+0BozM8XFV5TYME4jDUVH
         OlHWTqJ4QjzovseYZqhnO5bZGkU2LTHpc41pi5ce5ho2DK2d4eX0P1F3SncdU4p+JQWF
         lj6/XydrOKRJmsk2G+KqrbViCvwdKmApTSpCdEF5J4IH0iERxaUudwlPjJpzoAX1GOkK
         N0tQ==
X-Gm-Message-State: AOJu0YxAPpEy8aIEqMlvbK1OqdZKXJ1ThXShopMmqytnYeo28GyV4z1K
	HcIwd/VAR1awrcU1M9aAz/BqXXc93bzDl12ugAUzBcUphNe+lpIbtToaTPCSHFw=
X-Gm-Gg: ASbGnct8dsPelxb1aCGuJiGdG+4Vh9L6wEVVkT1oCLNrau618e4yjPomnt8Aa2s5Exz
	zMvJyot7l8KTe2yZ2DQdYNoILbDMsEIu0lZHtPNTxI30hh0VLfw0KSm6oi1Vc6Ej/YY6DbAjqBd
	BQWTIJOoPjilC5jRWtm8J/ugxK9MJbHxLAUFJhBObOelTK+JYGjhZZCP1liAFIfvsd5qbO0sIVS
	d6QUWz406T+pn3w0PHXsDqcMuRzVw1x4nbrZyEyFvUjqxvs+miSTDyBOZQWbtykrTr5/gwlF9Qo
	XgXnuGmXnGu2Pp10SBslaBRiwHvLHrU6
X-Google-Smtp-Source: AGHT+IGJD54WmeJhWmLuIg6K2eLaR6Nu3KOFJvfRzzPSdn1jrQ2yHrF7W3nXWrIi6nSfDAAnfx+3aQ==
X-Received: by 2002:a5d:6d8c:0:b0:38f:3224:65ff with SMTP id ffacd0b85a97d-39132d16d69mr16559838f8f.5.1741802009907;
        Wed, 12 Mar 2025 10:53:29 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::59a5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfdfde7sm22153857f8f.32.2025.03.12.10.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 10:53:29 -0700 (PDT)
Date: Wed, 12 Mar 2025 18:53:28 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Anup Patel <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v8 2/6] riscv: Set .aux.o files as
 .PRECIOUS
Message-ID: <20250312-70978d5a25e382c2b36935f4@orel>
References: <20250307161549.1873770-1-cleger@rivosinc.com>
 <20250307161549.1873770-3-cleger@rivosinc.com>
 <20250312-c9b8ee98ed38271ed7422550@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250312-c9b8ee98ed38271ed7422550@orel>

On Wed, Mar 12, 2025 at 05:30:09PM +0100, Andrew Jones wrote:
> On Fri, Mar 07, 2025 at 05:15:44PM +0100, Clément Léger wrote:
> > When compiling, we need to keep .aux.o file or they will be removed
> > after the compilation which leads to dependent files to be recompiled.
> > Set these files as .PRECIOUS to keep them.
> > 
> > Signed-off-by: Clément Léger <cleger@rivosinc.com>
> > ---
> >  riscv/Makefile | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/riscv/Makefile b/riscv/Makefile
> > index 52718f3f..ae9cf02a 100644
> > --- a/riscv/Makefile
> > +++ b/riscv/Makefile
> > @@ -90,6 +90,7 @@ CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib -I $(SRCDIR)/riscv
> >  asm-offsets = lib/riscv/asm-offsets.h
> >  include $(SRCDIR)/scripts/asm-offsets.mak
> >  
> > +.PRECIOUS: %.aux.o
> >  %.aux.o: $(SRCDIR)/lib/auxinfo.c
> >  	$(CC) $(CFLAGS) -c -o $@ $< \
> >  		-DPROGNAME=\"$(notdir $(@:.aux.o=.$(exe)))\" -DAUXFLAGS=$(AUXFLAGS)
> > -- 
> > 2.47.2
> >
> 
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

I meant to give this a

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

but I'm using the wrong mutt config right now...

drew

