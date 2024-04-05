Return-Path: <kvm+bounces-13770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D1EC89A792
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 01:20:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7B2B1F23AD2
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 23:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1151E374DD;
	Fri,  5 Apr 2024 23:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pfB410vd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E4B5672
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 23:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712359245; cv=none; b=DJn+Zl5rwbRsflfEElvp25Ng1KZjMXn7hgMcX3ceS1rkNAXyjCvq4RhIhqkyz27eXIo2XIsCRhQDFGxTZUhGvmYzvTYwzfil24sDUelVKsNXwDO3Wj5vN0RCHcDL3zcEcB3vOWozPauuRcy+DzTh5dmc+dfnxLe55IrEz/C3FpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712359245; c=relaxed/simple;
	bh=6JYCjL9C4AfaDryXf5XSZhrO2zWHCuIkX8eHeXELHqU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a6Y4Xr9NK0nrOFLQd3yQtEZTMoM7Px03QAMsqe09LD6MiZcS9JTprsZqEBbnTkO5moqcVxFar2dUOqDY1aluRKMhBIpJVcUXrGS1KPcwX8Eho+DUffIbIpM+ffrdrs8sOemesofWtuPc6qHmyZ+gMUHiI1XlPfXpdZY7lIFhEbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pfB410vd; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5d8bcf739e5so2345517a12.1
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 16:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712359243; x=1712964043; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=12i/1U6e69lGZbnks+aFjU43EdHvF/EYY258ON1Z+QY=;
        b=pfB410vdjh/TM3n9ksMNXrl7zddiS1npxNi0FlxrlJ+4I8UZH6S/cnIEdSpZ1LiJAL
         4WHMwlvY4lOHClZz2FUQxxVes3/dYRH7mXqcqUApf3WZfZvPOdeV/+9hOJXd38EY/xsn
         zD5l4RgUxVjuSeUejen4ULbnOSPfnxh19ACcnzvl7XsxsLNV29XNMIIrp9LK7mXgsPDe
         eArJO7kPEWqr52JX+ajKqX5KpVcnW1s0jGXDwdgxBd+IPNyUJRPxFOFuKPcuR1+PnQhy
         PWJ/GsmT2SZHWIp+jnkjEEYbbZ4muBuXe01OxGsjCOBbx9p9uKkNb1fZE3vwzFJ8BbYd
         ntQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712359243; x=1712964043;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=12i/1U6e69lGZbnks+aFjU43EdHvF/EYY258ON1Z+QY=;
        b=sqrzgC0DL0yJnC6EfmK6FG+hNnIE5Xp9jf5MGhcgJXfFjypXuNzmZUWoAadqJ8UPFb
         4Pnmv6uxbtMX3lzigGklKrhCuMvGLGJ/mBsBaJtLwXz72/a/dNDQXXGMLzhDyDQw8yM3
         lKdJj/aQFayrHHeCe868yPiPvaaNq8FkvsMSxE7qg4e7w/m100Aqokoxsjbl+7h7ArVJ
         lLJoFoUYd+cifQTx0ttxTcnz3pocifdbcuNwFFxXoXtfIKY2qF8/fhmHi8dpfukN6Epm
         PTratfaqhtVPKdWaZRk6BrD42pYZBODuQ2XSS/nsC8aB7FvszmrajAAfQFCcDcMTsTTA
         8oFg==
X-Forwarded-Encrypted: i=1; AJvYcCWpZoGsKwYW4mcD7RYA5NXlPRetnfbLPS/Z74S06nHcrefANiePjjIWzGiDqYjHRWmOpBZujtpNIx9QjUkPJVFLGCpI
X-Gm-Message-State: AOJu0YyVEUWqd7NWaiN/e2zPRtU1uyfFcL7C8BqmADNBcco/efbLnHNy
	9cu890I+FPu2s2MpUkYSNl0NMi0Q+iWv4AKjtlgpnF5PylQelHAX/lYwCJ1+BM5k6+V8lHbe2/3
	qaA==
X-Google-Smtp-Source: AGHT+IEUYFveyLiskfYb2sLUp535rDaaKamTXvVef0iSV4YFA3At2jAAYj0djH4lUTfne66XFXNLoy2e1Dc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1115:0:b0:5f3:fddf:e819 with SMTP id
 g21-20020a631115000000b005f3fddfe819mr4204pgl.10.1712359243207; Fri, 05 Apr
 2024 16:20:43 -0700 (PDT)
Date: Fri, 5 Apr 2024 16:20:41 -0700
In-Reply-To: <20240323080541.10047-2-pmenzel@molgen.mpg.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240323080541.10047-2-pmenzel@molgen.mpg.de>
Message-ID: <ZhCHSYwS5_o-OKs0@google.com>
Subject: Re: [PATCH] KVM: VMX: make vmx_init a late init call to get to init
 process faster
From: Sean Christopherson <seanjc@google.com>
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Colin Ian King <colin.i.king@intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sat, Mar 23, 2024, Paul Menzel wrote:
> From: Colin Ian King <colin.i.king@intel.com>
> 
> Making vmx_init a late initcall improves QEMU kernel boot times to
> get to the init process. Average of 100 boots, QEMU boot average
> reduced from 0.776 seconds to 0.622 seconds (~19.8% faster) on
> Alder Lake i9-12900 and ~0.5% faster for non-QEMU UEFI boots.

The changelog needs to better explain what "QEMU kernel boot times" means.  I
assume the test is a QEMU VM running a kernel KVM_INTEL built-in?  This should
also call out that late_initcall is #defined to module_init() when KVM is built
as a module.

> Signed-off-by: Colin Ian King <colin.i.king@intel.com>
> [Take patch
> https://github.com/clearlinux-pkgs/linux/commit/797db35496031b19ba37b1639ac5fa5db9159a06
> and fix spelling of Alder Lake.]
> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c37a89eda90f..0a9f4b20fbda 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8783,4 +8783,4 @@ static int __init vmx_init(void)
>  	kvm_x86_vendor_exit();
>  	return r;
>  }
> -module_init(vmx_init);
> +late_initcall(vmx_init);

_If_ we do this, then we should also give svm_init() and kvm_x86_init() the same
treatment.  I see no reason for vmx_init() to be special.

I'm not opposed to this, but I also have zero idea if this could have a negative
impact userspace.  E.g. what happens if some setup's init process expects /dev/kvm
to exist?  Will this break that?

