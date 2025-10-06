Return-Path: <kvm+bounces-59536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EBF76BBEEE0
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 20:21:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5D6E34F0AF0
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 18:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED1FC2DF6FA;
	Mon,  6 Oct 2025 18:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tPk+qTHi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA2F27A12B
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 18:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759774898; cv=none; b=Oa8mO14F+zaFQ9EOKYnQCHuqFmkQDjtnEjEjf+YH+s27sQvKu+UPBVuzQExn3ho/3GbfQGfizws2V5G0pt6T3VoHskWBVL1091IumWxouDKViBsenz+OOOcULDac6yPK/vjjO3wO1olMZe8tBDkNKIFnRF7rMbsZxDUZU6C7GM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759774898; c=relaxed/simple;
	bh=vUNyMXLW555PbQjtFhHdeKypqLjRIGe+0r6N0aMxImQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eZb4tkORAG5TZz8ZqSKKqEdHt2sdVoJBuXXVZNFUoQfKZlbfC4sGoOJOkQWQirYTGKbHdQvB/AEp2yaBMwjVyR+vZwbAFnGqwP1L+vpL1uncHQTBd4+Ayc1OB4rY+ec/sTzHQrACCLDS291KCebl865YjPkqRV2NZ90Q8DJaZhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tPk+qTHi; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-334b0876195so5662811a91.1
        for <kvm@vger.kernel.org>; Mon, 06 Oct 2025 11:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759774896; x=1760379696; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dXVMuz/bVScWtirOeDxzOFNaCT5UWxBdmG0wX2KZTp4=;
        b=tPk+qTHijtEfnzIHW8iRHDxVTDoe6EoJbbqNU6o6793qvD5lQLC0SwqFBPCa5PICYL
         5iuruAYRGJSnJNYx3A37QIIuwUp4lgXeRKNHL61B9r9xBazeFsCF71E/LISi5E4qpbRt
         LDizj3NfXO+hqjOs5LBPxNSSsRU8LtatQkeQpCke8xUgD3bihBVVK54d7ZEKVxtxECNZ
         +8eNWeDkZUMilouNfWst6WbW5ukXTOV+bZFNac6vYHurW2Clxif6LDvVhF7hgrElgSyO
         PTLj9+vdmE98K+rl3Vf/cP3+uZWVn0PMyxgc61CjvW2wSHjfi559kMcExHrulpAVYwaF
         L+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759774896; x=1760379696;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dXVMuz/bVScWtirOeDxzOFNaCT5UWxBdmG0wX2KZTp4=;
        b=emVgO5kkXcOpttEIRV1nQfNkUGK85gvB5vz2mG7N73YolsJrO5veQHrJzdpELnLvOY
         AyEm2Tf+/m9KkVRviwYlrzWwBXTqNCBGU7dvoRvw+51ndMO3ZcCA5WIIKusDB7DRJsin
         j6WRDMYXubBchw0J26K43/4yIxI2jrfx2107XPss3Rn2lP99sZRNTroZY4aP51VMZSp+
         9jf3m8OrLsI7ycwf1TMSlsRmXhydp3YhWiPuh/BoawDkSXY8cayTpZzasOUecczf3aiy
         BOm24940xtxaAE7/0aGpGWHKRyKdMpW05kCBPuRUk0W18UyEIX3kgWbRRQtJbOES+51F
         Ny3A==
X-Gm-Message-State: AOJu0YzlbzxeGw7mK4SkhgmlowbJ4WTrflVZki5O3D1icBFsAk4eZtgM
	f7yGzX4RsBEFyQ2o7ZXAxDXpZROCHju+oyh2zulqRd35/sqDCdKaEHRTkOw9XAA8k4nUNJkW8W1
	fpv9v5WaTchgtNs1l3+wyPjUSzw==
X-Google-Smtp-Source: AGHT+IGdnZEEtOtcdma1gAEsWJl6MN7TNWFT8q5PwrIeW9ovMJjMQK/RyT5JOJyizFrhnD8maWtVkZ8sXrjGITphQA==
X-Received: from pjbnb17.prod.google.com ([2002:a17:90b:35d1:b0:330:6cf5:5f38])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1e05:b0:338:3e6f:2d63 with SMTP id 98e67ed59e1d1-339c276d90amr16922266a91.6.1759774895769;
 Mon, 06 Oct 2025 11:21:35 -0700 (PDT)
Date: Mon, 06 Oct 2025 11:21:33 -0700
In-Reply-To: <20251003232606.4070510-12-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com> <20251003232606.4070510-12-seanjc@google.com>
Message-ID: <diqz8qhngac2.fsf@google.com>
Subject: Re: [PATCH v2 11/13] KVM: selftests: Add wrapper macro to handle and
 assert on expected SIGBUS
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Extract the guest_memfd test's SIGBUS handling functionality into a common
> TEST_EXPECT_SIGBUS() macro in anticipation of adding more SIGBUS testcases.
> Eating a SIGBUS isn't terrible difficult, but it requires a non-trivial

terrible => terribly

> amount of boilerplate code, and using a macro allows selftests to print
> out the exact action that failed to generate a SIGBUS without the developer
> needing to remember to add a useful error message.
>

Adding TEST_FAIL() after action on behalf of the developer (easily
forgotten/left out) helps ensure that test runs don't falsely pass if
there was no SIGBUS.

> Explicitly mark the SIGBUS handler as "used", as gcc-14 at least likes to
> discard the function before linking.
>

I think you also meant to talk about opportunistically using TEST_FAIL()
instead of TEST_ASSERT(false, ...) here.

> Suggested-by: Ackerley Tng <ackerleytng@google.com>

Not sure if these still apply after the Suggested-by tag, but anyway:

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../testing/selftests/kvm/guest_memfd_test.c  | 18 +-----------------
>  .../testing/selftests/kvm/include/test_util.h | 19 +++++++++++++++++++
>  tools/testing/selftests/kvm/lib/test_util.c   |  7 +++++++
>  3 files changed, 27 insertions(+), 17 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 640636c76eb9..73c2e54e7297 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -14,8 +14,6 @@
>  #include <linux/bitmap.h>
>  #include <linux/falloc.h>
>  #include <linux/sizes.h>
> -#include <setjmp.h>
> -#include <signal.h>
>  #include <sys/mman.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
> @@ -77,17 +75,8 @@ static void test_mmap_supported(int fd, size_t total_size)
>  	kvm_munmap(mem, total_size);
>  }
>  
> -static sigjmp_buf jmpbuf;
> -void fault_sigbus_handler(int signum)
> -{
> -	siglongjmp(jmpbuf, 1);
> -}
> -
>  static void test_fault_overflow(int fd, size_t total_size)
>  {
> -	struct sigaction sa_old, sa_new = {
> -		.sa_handler = fault_sigbus_handler,
> -	};
>  	size_t map_size = total_size * 4;
>  	const char val = 0xaa;
>  	char *mem;
> @@ -95,12 +84,7 @@ static void test_fault_overflow(int fd, size_t total_size)
>  
>  	mem = kvm_mmap(map_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
>  
> -	sigaction(SIGBUS, &sa_new, &sa_old);
> -	if (sigsetjmp(jmpbuf, 1) == 0) {
> -		memset(mem, 0xaa, map_size);
> -		TEST_ASSERT(false, "memset() should have triggered SIGBUS.");
> -	}
> -	sigaction(SIGBUS, &sa_old, NULL);
> +	TEST_EXPECT_SIGBUS(memset(mem, val, map_size));
>  
>  	for (i = 0; i < total_size; i++)
>  		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index c6ef895fbd9a..b4872ba8ed12 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -8,6 +8,8 @@
>  #ifndef SELFTEST_KVM_TEST_UTIL_H
>  #define SELFTEST_KVM_TEST_UTIL_H
>  
> +#include <setjmp.h>
> +#include <signal.h>
>  #include <stdlib.h>
>  #include <stdarg.h>
>  #include <stdbool.h>
> @@ -78,6 +80,23 @@ do {									\
>  	__builtin_unreachable(); \
>  } while (0)
>  
> +extern sigjmp_buf expect_sigbus_jmpbuf;
> +void expect_sigbus_handler(int signum);
> +
> +#define TEST_EXPECT_SIGBUS(action)						\
> +do {										\
> +	struct sigaction sa_old, sa_new = {					\
> +		.sa_handler = expect_sigbus_handler,				\
> +	};									\
> +										\
> +	sigaction(SIGBUS, &sa_new, &sa_old);					\
> +	if (sigsetjmp(expect_sigbus_jmpbuf, 1) == 0) {				\
> +		action;								\
> +		TEST_FAIL("'%s' should have triggered SIGBUS", #action);	\
> +	}									\
> +	sigaction(SIGBUS, &sa_old, NULL);					\
> +} while (0)
> +
>  size_t parse_size(const char *size);
>  
>  int64_t timespec_to_ns(struct timespec ts);
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index 03eb99af9b8d..8a1848586a85 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -18,6 +18,13 @@
>  
>  #include "test_util.h"
>  
> +sigjmp_buf expect_sigbus_jmpbuf;
> +
> +void __attribute__((used)) expect_sigbus_handler(int signum)
> +{
> +	siglongjmp(expect_sigbus_jmpbuf, 1);
> +}
> +
>  /*
>   * Random number generator that is usable from guest code. This is the
>   * Park-Miller LCG using standard constants.
> -- 
> 2.51.0.618.g983fd99d29-goog

