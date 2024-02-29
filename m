Return-Path: <kvm+bounces-10542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CEAE186D247
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 19:29:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EEE131C23777
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 18:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53483134406;
	Thu, 29 Feb 2024 18:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Ft0sFR8H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A347A15C
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 18:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709231303; cv=none; b=Cvz+XyMpTD19hU6IvgfktqIO3e/6YAhUnjM/I8hk87RteWfeuoebJmnvTp/y8Ve/ueo/vrHKAkFg7bF6nd6+i9XU7mXFto8Jsk0r6YRvcHtBOb/gNGBxuucOIJSUHeo8ViqCeOaVxCLllCPMrvS5RZCNS39e5732c0j9ZzBNYn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709231303; c=relaxed/simple;
	bh=TsNS9H9GnTpwvcccMLUCGH9dbY20A+4uTVdeOoyOT04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nFbF7utSlF/vcI6hxsF6A3a8WeooTRCjRtYKZ59vE/Dov62YSYs5PMRN/4jyFLgY/AYtHWe/0ITPfPTT9N2mHh4lUhVvrO0f0rOw+1xr3LtBXF0C+LMdfOg30UT3I64G493L68+8iNL6vF1uMsKxGAVihSLVFKahcbwa4V2tbHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Ft0sFR8H; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1dc96f64c10so12414615ad.1
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 10:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709231299; x=1709836099; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=S7hpS9VpNEze5H4aDuNsMr11UTcGSJ5cm/3AR7/T5Hc=;
        b=Ft0sFR8H+zbuiyIAKexQ970Fx7JhlQ21wk125e53FUT7WAKC0Kv6b32aFjCXt31Cdw
         YwYLEbkFU1Po8mGu8gHM0AYQkev29ajaqmVNJ4DBrDOwUjH4EJ7hpCS/vvFEMnYKoku/
         +7G7W9Sd+q+dG+9hp6MIjgFNMao++iFBvT/iM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709231299; x=1709836099;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S7hpS9VpNEze5H4aDuNsMr11UTcGSJ5cm/3AR7/T5Hc=;
        b=kZQdpXm5WfTPW3z+mDJn1Zy187OfRNyx/L+kYf3PvlRW7+KMhiprp83sX3nMH7GsA+
         ygzSX8IUHUftiKX81xukhc69EoaOkt2C7m3a6sJOCdyh0SwNpRwbHhQes1zGHfP3Ye06
         o2ronce9i/SeXreVXh1ENxJuh+OPPhuBwqq0lTUj8rGuzN8e4NDDokY/y2PMqbbxaJb3
         NsvLZd06Q44QMKFp6IYx8JejeiwE8MmU1mfIyJa9vRtkKKJWNIHiuM7HPdIXe78eHBWU
         e3xEQ+l4g2w9jKl95NvzGNbqWdKeMBrgtgxZEb7wMV/cAZVD/dYX9uiRf/8y7oOsqZYH
         +25A==
X-Forwarded-Encrypted: i=1; AJvYcCWL2PgxXJIHN+vdVC5ZDG1Rj2DsQfD8USwNQI+xdWubQt7+nS4+SNY7qtAfcA5P5tm2ozu5cSdwJvIOGKx/4OSJGg6f
X-Gm-Message-State: AOJu0Ywa80q13c4p447AZaPqgPXGTcLaR3NfGkzxrpTpOpsvrG3Zk9wZ
	+KPqVhX7cjKmEZatvx2rCgihRZYpGAjv6hZf+PzkN9FWTySMguah/x21qeR8iQ==
X-Google-Smtp-Source: AGHT+IFv6v7GCq84bRF/XSbui043ytODMyWUS4Rfqf+IDs54+SrN6ooF1PL5gcE4I2rCfOz2B9orlw==
X-Received: by 2002:a17:902:c394:b0:1dc:1831:8ede with SMTP id g20-20020a170902c39400b001dc18318edemr3025429plg.53.1709231299355;
        Thu, 29 Feb 2024 10:28:19 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id n4-20020a170903110400b001dc391cc28fsm1798569plh.121.2024.02.29.10.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 10:28:18 -0800 (PST)
Date: Thu, 29 Feb 2024 10:28:18 -0800
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Brendan Higgins <brendanhiggins@google.com>,
	David Gow <davidgow@google.com>, Rae Moar <rmoar@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Alan Maguire <alan.maguire@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	James Morris <jamorris@linux.microsoft.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Marco Pagani <marpagan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Thara Gopinath <tgopinath@microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Zahra Tarkhani <ztarkhani@microsoft.com>, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-um@lists.infradead.org, x86@kernel.org
Subject: Re: [PATCH v1 8/8] kunit: Add tests for faults
Message-ID: <202402291027.6F0E4994@keescook>
References: <20240229170409.365386-1-mic@digikod.net>
 <20240229170409.365386-9-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240229170409.365386-9-mic@digikod.net>

On Thu, Feb 29, 2024 at 06:04:09PM +0100, Mickaël Salaün wrote:
> The first test checks NULL pointer dereference and make sure it would
> result as a failed test.
> 
> The second and third tests check that read-only data is indeed read-only
> and trying to modify it would result as a failed test.
> 
> This kunit_x86_fault test suite is marked as skipped when run on a
> non-x86 native architecture.  It is then skipped on UML because such
> test would result to a kernel panic.
> 
> Tested with:
> ./tools/testing/kunit/kunit.py run --arch x86_64 kunit_x86_fault
> 
> Cc: Brendan Higgins <brendanhiggins@google.com>
> Cc: David Gow <davidgow@google.com>
> Cc: Rae Moar <rmoar@google.com>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Mickaël Salaün <mic@digikod.net>

If we can add some way to collect WARN/BUG output for examination, I
could rewrite most of LKDTM in KUnit! I really like this!

> ---
>  lib/kunit/kunit-test.c | 115 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 114 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/kunit/kunit-test.c b/lib/kunit/kunit-test.c
> index f7980ef236a3..57d8eff00c66 100644
> --- a/lib/kunit/kunit-test.c
> +++ b/lib/kunit/kunit-test.c
> @@ -10,6 +10,7 @@
>  #include <kunit/test-bug.h>
>  
>  #include <linux/device.h>
> +#include <linux/init.h>
>  #include <kunit/device.h>
>  
>  #include "string-stream.h"
> @@ -109,6 +110,117 @@ static struct kunit_suite kunit_try_catch_test_suite = {
>  	.test_cases = kunit_try_catch_test_cases,
>  };
>  
> +#ifdef CONFIG_X86

Why is this x86 specific?

-- 
Kees Cook

