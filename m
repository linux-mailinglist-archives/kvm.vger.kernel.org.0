Return-Path: <kvm+bounces-18934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB2F28FD273
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 18:05:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D95E61C23C04
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 16:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC9D0153BF8;
	Wed,  5 Jun 2024 16:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="swYpeCr0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A3814EC59
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 16:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717603533; cv=none; b=Mv94QH9IwWvr2pO3TaJenPtA2XljaAQXvOVyCklVHmorzobmCktsMlcd7q+YUbA+q0YhSI72gRtmmEn/iv/+h6aMFoIwbQnmi1Lnqvhv1yeCvIYE6e4GsdCY27JENWcmHmTgm/HdtaLW6yV83sTqLBlhyCImpmXFaBUH3ieWGGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717603533; c=relaxed/simple;
	bh=tV/bPXMd3PKTzv0fgS5veLrLr9Fg+hLG3+ZKI8bMWko=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=opO+DfGoSxfQOcRypwDiCnxBGJdvor8cvgH5u359jWhLF3PEaYzDwwc1D8KkIctm6iasB1OqWptu8Uaczt1haQAbdiVaPHoWKMkwn8TWkQTRVa1m26B/BeOOGpr2E6L5HT/AR9zbj1FDSCraacNzxbIa8i5pwg2WCEqfYqtpxfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=swYpeCr0; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-68196e85d64so5043814a12.3
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 09:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717603531; x=1718208331; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4vvU+EWkUAFoLim6pU7QlgZlMA4snbzHpZa85f87N9k=;
        b=swYpeCr0BtFC2/6y08mGTJyPg0S6iMcaUP1Uvn8YU0gxajOgUbOwfHBrZHRTELSIBZ
         FNz/i7FCuuaPhg7vjTJ0twcBaqMw+3qgV8xNjz8F+LhAoZB7Ld3VApa2QwjpGH02Oz8E
         jsj2jM/NWx8nS34L7HGSyZhEjBmJWz+lEyIfmYL0P2QdPmrP1H2OV0oGyk/pD9Z08S5N
         BqIV5zHNtB1pIvn6tWi+A1ZRQB3s0X/L5ihsMvpsGBHP4kCKDyR9lvaZjC/idCziEBMJ
         AMSKHhRaxZvBZTprm+TY9T18rehk9WGevYK2vHwX2s6pxyhLw1PEwp06T+/mOvtVlYYX
         rKNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717603531; x=1718208331;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4vvU+EWkUAFoLim6pU7QlgZlMA4snbzHpZa85f87N9k=;
        b=T+Qh+Ps15RD7XUL5TY6+uKFcY6n3SwWCi2i5/nxzGfq9F2xEWddfmG/jsA5czG7yKj
         iFdikvYC4Us1R9Fo8mbcW8J66fmRIPISNhBSnf8c3snu0dJH6EZlH2dXKiXhr0FfVrOZ
         rs4IpQJAz1B7D82DtxIPyMF20Y2LxSNA53t9gDVT218DikB4CyO4hp6opmRpA9E5tqhb
         bHAAv+q5L4atjJuYF8WeWKfFNkQ4dSLkeomC8kO5Oyx5kxDZTjIybwBkvH3LvA/yIIKn
         iMCTiBf1//DBmtFW1JfsYfsHWgnYcc0cg3GZ2RdPS7AwGN1IKzO/Ujm+Hs12tMeAwIxf
         WAbw==
X-Gm-Message-State: AOJu0YwINAfNyXoSyW2a00830TyC7bkY64JaS53VwgUg0ywRBbTGozOQ
	Dv/8rnBxLE9Pn3EC7fErIbI0xJtJS/YPNMoQjkfkOjlgptUzWt3zg07BQzXmdiqJbcJMEZBneyx
	EXQ==
X-Google-Smtp-Source: AGHT+IGwzXF0/+Y1nOjMnU7Kdv4eioESJ5VFMgfGw01KzM3XRj2c3Sk2BH84NuU58r3e4PvtkWp+OAkdxBk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:33c4:0:b0:5dc:8af0:ca81 with SMTP id
 41be03b00d2f7-6d951d8076amr7145a12.7.1717603530493; Wed, 05 Jun 2024 09:05:30
 -0700 (PDT)
Date: Wed, 5 Jun 2024 09:05:28 -0700
In-Reply-To: <20240419161623.45842-3-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240419161623.45842-1-vsntk18@gmail.com> <20240419161623.45842-3-vsntk18@gmail.com>
Message-ID: <ZmCMyL3zzg9CtFHU@google.com>
Subject: Re: [kvm-unit-tests PATCH v7 02/11] x86: Move svm.h to lib/x86/
From: Sean Christopherson <seanjc@google.com>
To: vsntk18@gmail.com
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, jroedel@suse.de, 
	papaluri@amd.com, andrew.jones@linux.dev, 
	Vasant Karasulli <vkarasulli@suse.de>, Varad Gautam <varad.gautam@suse.com>, 
	Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 19, 2024, vsntk18@gmail.com wrote:
> From: Vasant Karasulli <vkarasulli@suse.de>
> 
> This enables sharing common definitions across testcases and lib/.
> 
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
> Reviewed-by: Marc Orr <marcorr@google.com>
> ---
>  {x86 => lib/x86}/svm.h | 0

No, there is far, far more crud in svm.h than belongs in lib/.  The architectural
definitions and whatnot belong in lib/, but all of the nSVM support code does not.

>  x86/svm.c              | 2 +-
>  x86/svm_tests.c        | 2 +-
>  3 files changed, 2 insertions(+), 2 deletions(-)
>  rename {x86 => lib/x86}/svm.h (100%)
> 
> diff --git a/x86/svm.h b/lib/x86/svm.h
> similarity index 100%
> rename from x86/svm.h
> rename to lib/x86/svm.h
> diff --git a/x86/svm.c b/x86/svm.c
> index e715e270..252d5301 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -2,7 +2,7 @@
>   * Framework for testing nested virtualization
>   */
> 
> -#include "svm.h"
> +#include "x86/svm.h"
>  #include "libcflat.h"
>  #include "processor.h"
>  #include "desc.h"
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index c81b7465..a180939f 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -1,4 +1,4 @@
> -#include "svm.h"
> +#include "x86/svm.h"
>  #include "libcflat.h"
>  #include "processor.h"
>  #include "desc.h"
> --
> 2.34.1
> 

