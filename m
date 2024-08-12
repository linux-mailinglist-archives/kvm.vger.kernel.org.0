Return-Path: <kvm+bounces-23836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 94E8294EA97
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 12:17:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E83E1B217FF
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 10:17:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16EE516EBE0;
	Mon, 12 Aug 2024 10:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BCSmfl3V"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35C416DEB2
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 10:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723457857; cv=none; b=b4DqfeBEqAcUcqPqjqWeYHZYLABhp+N2xTip2YLkd06mbl8BO1YArlkbkY0tEVD0+WrlFvHYdlb97e+ylOR2vnYSSjgYY5GgThQj3Nxczyb/SWDeO3COQPj8M2y7RUbNA24lksGRzQ8wEehxFy/il+hBKgIZVMSFLfLIWyN+HdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723457857; c=relaxed/simple;
	bh=wlf+NaXWaEQjELZ0vJCmPiLuJUBMSiiQIdYcl829RYA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b1UTIstiVAlpwhzZT6auTTs3bzg4rir2vIjCXMT1m5lDi9UKOTgAjIWOszdpFRgVZmrD2VMBPqf03oBg0C7+C2eATSSYUVO1xxCgGyA/KdbkLJOqJ96PzmbH64F14qtGMUaiCe1COoTPwTEIsvl/ugMhgGVuuGcBq4Gmype11x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BCSmfl3V; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723457854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lVcqCYPpo9W+fFj+K5rl8msH5Np6HFRkYMqj7Uwzb6g=;
	b=BCSmfl3V/gEhytK658XsX/BY4mnItmKtOCWZbOrtkiUrzWEWFF56FoP7uqPlQ2x6nuBDFL
	1h+s3QJ5tfZCRwp9yS7YoM2D3B1FdfUqEb7raV8lQ/7bqe/SNFwl928N3/ITAFtcrIBINs
	Bvuyhgj0U9AMdE6LqooctFw6UcfMjOU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-htUE0ArdPLCvzZad9sv_lA-1; Mon, 12 Aug 2024 06:17:31 -0400
X-MC-Unique: htUE0ArdPLCvzZad9sv_lA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-427b7a2052bso49410675e9.2
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 03:17:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723457850; x=1724062650;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lVcqCYPpo9W+fFj+K5rl8msH5Np6HFRkYMqj7Uwzb6g=;
        b=ouvtz57MvZFa7m5jPECNbtqcbWoXhAscEuAtmFeNdvEhD67pwCCJRuAuQlbWZ1+sLY
         2ahBXf70yMS9e2lqVnjvox12/t1ROvHtUzTJFnAu2cHm/gtN17rJsL/IzyktdzneE5vf
         hMr8B0dd6Q6f0IFXSVc7mJMZR0EyArbJseD5oxTYx1/qHvMnMhjWdL7sWdz/M6R+CO/F
         sezP98Dz15vqYjbNbnZjiE3LyAgnQbKn2dOaZflF3PntRHBS4LUY3ThN/GJbRTyLytRW
         3e//OGBn/3/CF8XbPgGRxsxUNgNEl7E6Vp3sXapXeVD7LwDpK+MUqvdvk0ssvPDUlvDy
         I1Jg==
X-Forwarded-Encrypted: i=1; AJvYcCXHEriLm6hxOpm56+/Ms+vvPtuiEZuSncU4h8jovQotUq61WmtmHP2JqZZgJ0FQyylIEekhkK9d5dKZl6d0k0+L/hR/
X-Gm-Message-State: AOJu0YyKQoDMcF/MVcUR9illoO7l2XBPQnE5bI6spJDHpz8K2I04/Mw+
	taHL8jYcH5jnpMeCWZXcjztgKJ0uVZMsjD57q4AAt2yTcfUZ6THYKHX9rKz1qxXpWNyhjGr7ivA
	vxgbeEErDLQjaDdQfwZaNAzfbVdKReDCiGSvCU5nzk51Yr7zZPg==
X-Received: by 2002:a05:600c:a48:b0:428:fcb:962 with SMTP id 5b1f17b1804b1-429c3a5c30fmr69153485e9.36.1723457850094;
        Mon, 12 Aug 2024 03:17:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH9KaVH/YQWzNv+camNIPrJrOZ2kXGpngJmHnV3vUr3/NqX5jpx3SkoLO+uMuWYwLmMrltXnQ==
X-Received: by 2002:a05:600c:a48:b0:428:fcb:962 with SMTP id 5b1f17b1804b1-429c3a5c30fmr69153255e9.36.1723457849535;
        Mon, 12 Aug 2024 03:17:29 -0700 (PDT)
Received: from [192.168.0.6] (ip-109-43-178-125.web.vodafone.de. [109.43.178.125])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429c751b021sm97414005e9.21.2024.08.12.03.17.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 03:17:29 -0700 (PDT)
Message-ID: <1f645137-c621-4fa3-ace0-415087267a7b@redhat.com>
Date: Mon, 12 Aug 2024 12:17:27 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 9/9] Avocado tests: allow for parallel execution of
 tests
To: Cleber Rosa <crosa@redhat.com>, qemu-devel@nongnu.org
Cc: Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
 Radoslaw Biernacki <rad@semihalf.com>, Troy Lee <leetroy@gmail.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>, Beraldo Leal <bleal@redhat.com>,
 kvm@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Aurelien Jarno <aurelien@aurel32.net>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, Paul Durrant
 <paul@xen.org>, Eric Auger <eric.auger@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>, qemu-arm@nongnu.org,
 Andrew Jeffery <andrew@codeconstruct.com.au>,
 Jamin Lin <jamin_lin@aspeedtech.com>, Steven Lee
 <steven_lee@aspeedtech.com>, Peter Maydell <peter.maydell@linaro.org>,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Leif Lindholm <quic_llindhol@quicinc.com>
References: <20240806173119.582857-1-crosa@redhat.com>
 <20240806173119.582857-10-crosa@redhat.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240806173119.582857-10-crosa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/08/2024 19.31, Cleber Rosa wrote:
> The updated Avocado version allows for the execution of tests in
> parallel.
> 
> While on a CI environment it may not be a good idea to increase the
> parallelization level in a single runner, developers may leverage that
> on specific CI runners or on their development environments.
> 
> This also multiplies the timeout for each test accordingly.  The
> reason is that more concurrency can lead to less resources, and less
> resources can lead to some specific tests taking longer to complete
> and then time out.  The timeout factor being used here is very
> conservative (being equal to the amount of parallel tasks).  The worst
> this possibly oversized timeout value can do is making users wait a
> bit longer for the job to finish if a test hangs.
> 
> Overall, users can expect a much quicker turnaround on most systems
> with a value such as 8 on a 12 core machine.
> 
> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
...
> diff --git a/tests/Makefile.include b/tests/Makefile.include
> index 537804d101..545b5155f9 100644
> --- a/tests/Makefile.include
> +++ b/tests/Makefile.include
> @@ -94,6 +94,9 @@ TESTS_RESULTS_DIR=$(BUILD_DIR)/tests/results
>   ifndef AVOCADO_TESTS
>   	AVOCADO_TESTS=tests/avocado
>   endif
> +ifndef AVOCADO_PARALLEL
> +	AVOCADO_PARALLEL=1
> +endif
>   # Controls the output generated by Avocado when running tests.
>   # Any number of command separated loggers are accepted.  For more
>   # information please refer to "avocado --help".
> @@ -141,7 +144,8 @@ check-avocado: check-venv $(TESTS_RESULTS_DIR) get-vm-images
>               --show=$(AVOCADO_SHOW) run --job-results-dir=$(TESTS_RESULTS_DIR) \
>               $(if $(AVOCADO_TAGS),, --filter-by-tags-include-empty \
>   			--filter-by-tags-include-empty-key) \
> -            $(AVOCADO_CMDLINE_TAGS) --max-parallel-tasks=1 \
> +            $(AVOCADO_CMDLINE_TAGS) --max-parallel-tasks=$(AVOCADO_PARALLEL) \
> +			-p timeout_factor=$(AVOCADO_PARALLEL) \
>               $(if $(GITLAB_CI),,--failfast) $(AVOCADO_TESTS), \
>               "AVOCADO", "tests/avocado")

I think it was nicer in the previous attempt to bump the avocado version:

https://gitlab.com/qemu-project/qemu/-/commit/ec5ffa0056389c3c10ea2de1e783

This re-used the "-j" option from "make", so you could do "make -j$(nproc) 
check-avocado" just like with the other "check" targets.

  Thomas


