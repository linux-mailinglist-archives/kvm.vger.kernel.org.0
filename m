Return-Path: <kvm+bounces-19653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A97DB90831F
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 07:01:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE6301C2149A
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 05:01:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC85A1474B7;
	Fri, 14 Jun 2024 05:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RSDsRTdp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298852F43
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 05:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718341263; cv=none; b=PUykEV4uH8D76e7AZbpbd94S5HeR/1ghC+gBXuM03cg9yhUGHKQdiE+SFF51Kn7NQPWn+XOvAezdNirsPTVs8umCImA/u5kivNB/5ClLaf0MKGofnW3L039cnnFd3z5dQL3DGpqvH9Ir+igNcgEk5swHniqXccwCBWRabBFfyUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718341263; c=relaxed/simple;
	bh=unI3L0rqP6h/sPw8j/2gQP67uQSqdIefSCxe/Ukecx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R1EVv1AthIMh4+t/6ypnV10qa+kBccG3t2veaaLDKJUbXDSyy0i4lM95OGBkhNdvrkPJiJM8cEubOWZVdRGReEP63mjOWDfDHzAFvrg2aDz0ANo33lCZ2RcXvqBIHg/tCFM5+V8frxa4WQmxQf9P4y7sXxv0Y7sBl1BmaISXaw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RSDsRTdp; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-35f2c9e23d3so1874351f8f.0
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 22:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718341260; x=1718946060; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v0HUgUlG9vEDCQkG97tpkj3YnGaT01iQTHtx0RmuTwc=;
        b=RSDsRTdpraAHdlblduBVTZ3l5XTrk+dkZzw4Hbep7eEcs7bo0VWeMM11YK2pIo31No
         B87c/Nr4dReiOGGnz7/mWZbZdF7jWuGbKS4Q/L0FcTqpx3kAioCp6CEYu9UJTkM1iTJp
         uED3KbETZMsn2f0QkItVuAf3aa+n46p5UYkSlg4tJYPziKXgKR6HMmWY8abVsZ9bjhvK
         HbB7ckrA1AdxJMndCA0hVVyDt9cxRMTEUbC7mRdASNOWC+oFF9Eex8BsASZSkyhERBCo
         MV8oBY4rYWaa8qDaw5ZTAV9KW6/wZ8G71lzGHZpQ8jCNIl1Cd2VtR2FnQSlKLd65Vqmq
         KZWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718341260; x=1718946060;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v0HUgUlG9vEDCQkG97tpkj3YnGaT01iQTHtx0RmuTwc=;
        b=Zd4U1viaOPFIzXA2knEEd71DeQwP0CTLlaCBPkJVaqdL2xAUOxMJ/ndtPleHmC7nBr
         h8HoUCyrSw0AkI5rUbfg4IGB5x7hYKHUq+yuuPL1sUdQGXnrTXHuzrEn9RWSCA8Q3CJA
         RzxhwwHv82lEHlXW0fWdcfKWUOnrAPJ2frsIhUUN3ikidcsNLmwA/SWxzP5PSD6twfga
         60J/xZhy0zHWsnXu4nfTpaEpbYlXL/5XfUVp0dS+a3Am9WRflp9n2IQsaXnJuY3T5Uqr
         S5/fg1lqZQJ2J/FkcaH3ZlrvdbJs07/ZJLi3B5Axg8CvuSbQP4yLenDYuSnw28w8wxAE
         ogcw==
X-Forwarded-Encrypted: i=1; AJvYcCUBt9XDK1pMnyPdvOB7IXlogrbjoQiwzZtn8dzX/oCwAOMpI6Z3N4lW4w15LZfZJvq2Grk0Tqu3FcZYAM6CP1UTI68A
X-Gm-Message-State: AOJu0YzDgGP4pf6nUt0Qdy9focdcztkkQ4oDXIBm7lOLQWMtgT8dvRaN
	E6h2hLoY2WvG9FrTLO1QZynzD0idxw5XWJNIlrv6j/nIQmlMu0xoah/qS1FffB4ftZZEqHlGVfc
	g
X-Google-Smtp-Source: AGHT+IGPB1MGLUnBZL8a7B9fGtRl0d/bVZarsDuhFdm934/bCtuNxQOG73AJASrw6TwdGPdoAQ405A==
X-Received: by 2002:a5d:6e10:0:b0:360:728d:8439 with SMTP id ffacd0b85a97d-3607a4c864fmr1464554f8f.2.1718341260141;
        Thu, 13 Jun 2024 22:01:00 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36075104954sm3274027f8f.99.2024.06.13.22.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 22:00:59 -0700 (PDT)
Date: Fri, 14 Jun 2024 08:00:54 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Yi Wang <foxywang@tencent.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] KVM: fix an error code in kvm_create_vm()
Message-ID: <29ed61a4-5f06-4c27-aed4-5ac3de3f45ae@moroto.mountain>
References: <02051e0a-09d8-49a2-917f-7c2f278a1ba1@moroto.mountain>
 <ZmuF2PsVot33fS1x@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmuF2PsVot33fS1x@google.com>

On Thu, Jun 13, 2024 at 04:50:48PM -0700, Sean Christopherson wrote:
> On Thu, Jun 13, 2024, Dan Carpenter wrote:
> > This error path used to return -ENOMEM from the where r is initialized
> > at the top of the function.  But a new "r = kvm_init_irq_routing(kvm);"
> > was introduced in the middle of the function so now the error code is
> > not set and it eventually leads to a NULL dereference.  Set the error
> > code back to -ENOMEM.
> > 
> > Fixes: fbe4a7e881d4 ("KVM: Setup empty IRQ routing when creating a VM")
> > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> > ---
> >  virt/kvm/kvm_main.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 07ec9b67a202..ea7e32d722c9 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1212,8 +1212,10 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
> >  	for (i = 0; i < KVM_NR_BUSES; i++) {
> >  		rcu_assign_pointer(kvm->buses[i],
> >  			kzalloc(sizeof(struct kvm_io_bus), GFP_KERNEL_ACCOUNT));
> > -		if (!kvm->buses[i])
> > +		if (!kvm->buses[i]) {
> > +			r = -ENOMEM;
> >  			goto out_err_no_arch_destroy_vm;
> > +		}
> >  	}
> 
> Drat.  Any objection to tweaking this slightly to guard against similar bugs in
> the future?  If not, I'll apply+push the below.

No objections from me.  :)

regards,
dan carpenter


