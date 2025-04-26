Return-Path: <kvm+bounces-44411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97AB7A9DA79
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:00:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE0DC927BAE
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:00:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB34D77111;
	Sat, 26 Apr 2025 12:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="mAMyN+89"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0881AAC4
	for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745668813; cv=none; b=pDD1R6J7azAFUNfrOgLj+LkrjW3Sqv/+4Wi2L5sqEKKE8oWyeiwiEMdLRxNFBpN8mfwILUthBxwaanoTbkEGqoHCoGtTl9ZD5BJtSbB/0+sJXFwahboiqbYVxlR0tSPwJmPMK4f3pRKRHgD1kPv9MBShqaKKvMbBy5ikatXJSdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745668813; c=relaxed/simple;
	bh=y2UzcmFgXugz7sN37JRnEYfgybMcwHD39Unx5ijSVAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lmjE5hE6evgUojijEJf5nkvFF2yyL9Rv5qAnnBCnxpXxhYrs+dPPL7nyn+a21+7g2CyD+nU/osOWmvwTYLchEJMJCpF9JqIYtBa9y3QGYQ2duMQ+zrtkl+c54hXsZZx2a4SSl80SHPSddiqzPZ9sT13Vt8GSjknWPUDlfhkoUwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=mAMyN+89; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5f4d28d9fd8so3890058a12.3
        for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 05:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745668810; x=1746273610; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RTzu1xS98tjw8hnNc1PSCW4inmOV0Uf2KGI05g8CT5s=;
        b=mAMyN+89vom/DjtWMzfVy6ca7OGZvXcT+IY6ZW/i2mFg580XPM6Uiku2ipi615/ioh
         Wr1QMkZG8lT3PrLURa9ENYD3MQ5aiVDAKOPr+oES6wHmebRy2MqlcKpIWbYSCa5l2VVl
         gr/ELF0Qt0A/WiPyTf2j80TXmvcI0qE14fxdz3OhSAkqWfh5N12mYFqXd5RUGPz7MyoG
         g2koLOX2XfMd7xPUiw8dIwgxeqN7Z2gEq8ZuI9aqATX6h6aoLei+naTrOIEv6XxJB8DB
         nxEwHnamYdZMZ63+FD5dWdAxYhz74e7mu0NyHa6V+ep6vlV+RtrV7WHOLfmgysDQY341
         m6tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745668810; x=1746273610;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RTzu1xS98tjw8hnNc1PSCW4inmOV0Uf2KGI05g8CT5s=;
        b=ODh5zwa0QF4a2+kZaBjlc/WWOHrDvgOt78kLUJKFl+10iQ0pfSDU+rHXFOnzDX/hyV
         PZcx5Z4NcrXPL2WdxchPjKhsbqI/ldzEttW7ecOZ7zIToUHHwmftXP4U6IpdCMJI3wzT
         p4mF3XBFSeYLZDE8r/6nq6iCaaNI4x4d9JPAoZmufb9A0gUDH9D159l7xQFLxogjSMNc
         RmLsbyz+6QPzD9d8vvuW3fLuZM6dWuPBxBTjHBvlBylxcPKkpKvF1O5RdOaibO1WoHkJ
         wmMdiJZAI10Ormpev6s6MD7u/flSaINUD5AbJxTYPAaiK8VmgrnOFvyLD7a1UDdbAg58
         ViNg==
X-Forwarded-Encrypted: i=1; AJvYcCWMDtUvfZMVRgnWJCNyYg8aXfXeBwwClwZi3V7TR2wMsaJvsk77WD4gIPlltxJrCVDj8iI=@vger.kernel.org
X-Gm-Message-State: AOJu0YylE8d/o83gud8qNFSMukFB5+hMufpr7ucPBv/ApXpAXJ3It7y7
	dx3a44msTHucNfx3KRKxVLJRQGDXwIV21iDvTlzfzu4iNf3l3Xdvw4UUcFXOsjc=
X-Gm-Gg: ASbGncs9KDHK+6f/QPzIL/qKhmEjeUu7i0QLcONa9C+G5j241X2bJbQSMWIK8VpGCyw
	2pGCDdn2r9SxnpqO2UxYX1i2LA/q1qNLAqEesvTENXHKbWoldLbp28oWaZ31oCpnK/tOI48BiW3
	CuZWp+dz6aAwF7SR3MjNlPonua0t6R2U1UFi1rkyOcn9uuIEg8YLFUIoC1JtiGu+S/XM+KGM1gd
	/1k+Wp79cJcbkGO+N9fh4yLxSS/tZSrDRT7sX9FIowW+jcfAV1unxef2F+qChM9DH+OMWQVl74b
	a8BG58d58auF1mSZscbYb+oLMflUgevOQdPKyPDw855Vokqt6iEVbThxcDpfMs8bFXCBzw==
X-Google-Smtp-Source: AGHT+IHECmUh4ym77b/66FP4tRpCNVowAee/FmuOM9vRtlM64uQJIMP3F9x6/UbiyebOtviYFMRgAQ==
X-Received: by 2002:a17:907:3f14:b0:ace:8144:1649 with SMTP id a640c23a62f3a-ace848f779amr230479966b.20.1745668809520;
        Sat, 26 Apr 2025 05:00:09 -0700 (PDT)
Received: from localhost (cst2-173-28.cust.vodafone.cz. [31.30.173.28])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6ecf73a2sm275320366b.114.2025.04.26.05.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Apr 2025 05:00:09 -0700 (PDT)
Date: Sat, 26 Apr 2025 14:00:07 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Huth <thuth@redhat.com>, Andrew Jones <andrew.jones@linux.dev>, 
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] scripts: Search the entire string for the
 correct accelerator
Message-ID: <20250426-8f1b81cc50c34db23f34110b@orel>
References: <20250425220557.989650-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250425220557.989650-1-seanjc@google.com>

On Fri, Apr 25, 2025 at 03:05:57PM -0700, Sean Christopherson wrote:
> Search the entire ACCEL string for the required accelerator as searching
> for an exact match incorrectly rejects ACCEL when additional accelerator
> specific options are provided, e.g.
> 
>   SKIP pmu (kvm only, but ACCEL=kvm,kernel_irqchip=on)
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  scripts/runtime.bash | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 4b9c7d6b..59d1727c 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -126,7 +126,7 @@ function run()
>          machine="$MACHINE"
>      fi
>  
> -    if [ -n "$accel" ] && [ -n "$ACCEL" ] && [ "$accel" != "$ACCEL" ]; then
> +    if [ -n "$accel" ] && [ -n "$ACCEL" ] && [[ ! "$ACCEL" =~ $accel ]]; then

Let's use

 [[ ! $ACCEL =~ ^$accel(,.*|$) ]]

to be a bit more precise.

Thanks,
drew

>          print_result "SKIP" $testname "" "$accel only, but ACCEL=$ACCEL"
>          return 2
>      elif [ -n "$ACCEL" ]; then
> 
> base-commit: 0d3cb7dd56ec255a71af867c2d76c8f4b22cd420
> -- 
> 2.49.0.850.g28803427d3-goog
> 

