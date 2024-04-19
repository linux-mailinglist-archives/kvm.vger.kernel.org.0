Return-Path: <kvm+bounces-15378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34B698AB74A
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 00:34:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5366281F65
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 22:34:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FF8613D889;
	Fri, 19 Apr 2024 22:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NCkMY6iL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC2884FCE;
	Fri, 19 Apr 2024 22:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713566031; cv=none; b=G+JpwCBvFW/BW4ciiglFpiCA20fL7fENB0Bv/z9Wa8igiy/wcSKLQVv7ikrmBKnR3O+OwUg7xjDvnpRJlVh+E4XYK3wz6wFcptn5f3JV3gl/lGCGurDrk9RRjo04H4l1e+Kg65XUIKZmBuolYu5GcepjAld62FYS/+1QtUzgJSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713566031; c=relaxed/simple;
	bh=xGwEhGJ3/O7MuoC3DWoEHmTJl0/fQhja8kxeNtaw8rY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nCnymFzRfrVM9xU1vd3HE3JYvoTKAdytSK0NHaJp/1u6H5XfG0FA03olWuSlhhuST2rW+gw2HpVDINvC8eHiTjLkUl/kMugiw2yoghQtumtKflon+17SaYo9oJI969Q4tSpdw6rPPLWu3NTI4xJA9rQWf8DNZ6FjyFunJpX4eG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NCkMY6iL; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1e5c7d087e1so23207325ad.0;
        Fri, 19 Apr 2024 15:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713566029; x=1714170829; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TO5By6VnNS1IaJWTkgMBtokxedo0r6Z5DxfCvgc5tPg=;
        b=NCkMY6iLpub/8UpUOubUZurTD3u/ZIPMqKlS96sKrmX/s47KtTeBaCtXEWzCJb6/fT
         a18VjKYZ2oF+qiU8DOA+n6RZ+NO3YA30jOAgWIkmuiz89CMahEK3oTQ7WCH7JxvyDGuj
         Vxv8merS9xJCM5TW7vElgY7ptw+avBNUKN58LA8rGj5nEuuGeCQuM0qawzyXjYedLiOI
         mPzIkP3LwouGOd2NcFDN4TUvMxuc++4U4Gwg10jCdv9EkBuE1hm1c5lxKs76hGay4aTC
         PTt3ty35nprnw7GdlhOTzhWu1Be7NpkXmS2mdbL5cu+TT65fho1YkEIc8vLUuxcieM7T
         WY3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713566029; x=1714170829;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TO5By6VnNS1IaJWTkgMBtokxedo0r6Z5DxfCvgc5tPg=;
        b=N/3NP9T8jeJDaHTiEnlbOWfc5aL85SC8YraR0IUkkzlwtJnU0XMc0miPyDFVBz1+Zd
         yh8qgSYounJ8es86NT4CpRO9a6pqP1sCPX7FxXiG2dxV/uJA5qAT6nXnEqZTYxdxLEnf
         F7u2a+Jk7uewxbkaMJrPTN5Iz5cN5QWrsz1JdGkB6102EtDCXnbIx66EiznYdNTacmuJ
         eXy2qcc6sWNYfHLwasPnTUUf/C3Nq9yMQRJizCMay5MPC61/S3S2eTKywevd7tDzLxht
         JipuTPleO308KnkRKa1AWzdqt1yu8RGFvpW7monlTJRps7fSG9naNsVoULauEXVLtmnl
         Q4jw==
X-Forwarded-Encrypted: i=1; AJvYcCVTeSKNNfDk/3CA8djVur058udizXXq1epX2Hclg7SraKWGlUYM1oXMUtesbW/LT2o096ITjk9WYTlZQpXolD81UWvhslHi7H482ZWUdSxHG40X3f0jwx5ZH6N8CguuBxcVz0u/qNfJyWOAFx6vRN3WzQUOq4LV+/EBbluhGFSWGyxnDePX9fvOq9Y5fvVgE7vDYDMkPbEbIQIyl+mlXVSMAMVTc/jIbSYe4TptU0WOwxoLRYcwpl9aVH8vhB2C+BaKi8RP0wdg
X-Gm-Message-State: AOJu0Yypl4e7YehDfQxO5JLM93agQPE2reeHfuYAOCXcuHYEtOwQ5RzD
	ZKrKJmkY8sBiSujHQ1PkC85H4sM0LBZb1nOJCaYax5NUiM81dgtb
X-Google-Smtp-Source: AGHT+IG3CF+k9p5pj5EbJuozYcjKdiyPH05OIZbYUOjlkQ2/OvmQOXy9/eTRwDRZ+3SD1f2/CoqXMQ==
X-Received: by 2002:a17:902:ea05:b0:1e8:9054:1019 with SMTP id s5-20020a170902ea0500b001e890541019mr4551953plg.54.1713566029186;
        Fri, 19 Apr 2024 15:33:49 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ba5-20020a170902720500b001e2b4f513e1sm3867179plb.106.2024.04.19.15.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 15:33:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 19 Apr 2024 15:33:46 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Brendan Higgins <brendanhiggins@google.com>,
	David Gow <davidgow@google.com>, Rae Moar <rmoar@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Alan Maguire <alan.maguire@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	James Morris <jamorris@linux.microsoft.com>,
	Kees Cook <keescook@chromium.org>,
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
Subject: Re: [PATCH v3 7/7] kunit: Add tests for fault
Message-ID: <928249cc-e027-4f7f-b43f-502f99a1ea63@roeck-us.net>
References: <20240319104857.70783-1-mic@digikod.net>
 <20240319104857.70783-8-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240319104857.70783-8-mic@digikod.net>

Hi,

On Tue, Mar 19, 2024 at 11:48:57AM +0100, Mickaël Salaün wrote:
> Add a test case to check NULL pointer dereference and make sure it would
> result as a failed test.
> 
> The full kunit_fault test suite is marked as skipped when run on UML
> because it would result to a kernel panic.
> 
> Tested with:
> ./tools/testing/kunit/kunit.py run --arch x86_64 kunit_fault
> ./tools/testing/kunit/kunit.py run --arch arm64 \
>   --cross_compile=aarch64-linux-gnu- kunit_fault
> 

What is the rationale for adding those tests unconditionally whenever
CONFIG_KUNIT_TEST is enabled ? This completely messes up my test system
because it concludes that it is pointless to continue testing
after the "Unable to handle kernel NULL pointer dereference" backtrace.
At the same time, it is all or nothing, meaning I can not disable
it but still run other kunit tests.

Guenter

