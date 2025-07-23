Return-Path: <kvm+bounces-53317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6098CB0FBE4
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 22:50:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A3573B2571
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 20:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D7A234984;
	Wed, 23 Jul 2025 20:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tXj3xhIW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E7422D786
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 20:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753303825; cv=none; b=ISExaG+7L7CyzSgKxOBfWEQVUoYlLnJOM8B7AI5aXy9nQQxgATFP5mmbH5EsKnd/1LgyZz4pXvdpJyMlPLLuCFZ55gNHyBwoVg0bPt/QIXtj9q2lKbX344joBTkgkmZGNum31M4KalbJAwbcFwIbVXttjkVheBt+bjJIJhnislM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753303825; c=relaxed/simple;
	bh=YH06wXGtTvzaDYbBmuqlUbsbVqODWlFF0DqbtJSF2zA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pgVpag1i+7lVXPNJ5NlzZ5GBQMCYEbpqn/jd4+UI1PitxKAodULbv3/DLTOFGsbJm+6beNd4nhp1Ozs9XDfvzcpJs6qpbqyxTn4Jjpilx8Ac0ngHQjlQYkvqwq2bFichU+f6aIq3ILmfkZvgfkcUR3VXkMhvi6qQkYOlapljQys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tXj3xhIW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31315427249so205441a91.1
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 13:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753303823; x=1753908623; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LIZ5gqIBt3RgHwOUnzQDN1KHOkEVUY7HJUBO+K6N2bw=;
        b=tXj3xhIWVIYKgwdhxqOcdP7brBKDF+2JDSHge2zMfGdzvFnWtegau0weoNW1E35vmn
         agihZoqjBqvaDIUSNebSiyqaOUiHisHpVuahJsKct4dgpB/fAN6kiJo5wznTEQOz8i8I
         0e2xkHoM3R9oNBK6fYSOBRSJOvRRsF9fIK7YGKnBoDD1XCaGFOxGvecxcC6+2KleeK5L
         pcT7GltvpUSoGdncgrW/+3oey8zJMRfpBznsEsOA64OL80HggAFb9TBnXDgbs4DK2NHj
         pdoI/v/jEhIV4plB7Sm3TotvVd2h1lRMN3AH+a6Nmr1VWxA6IMbvqFGrdmwPUnsSXCY4
         dwvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753303823; x=1753908623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LIZ5gqIBt3RgHwOUnzQDN1KHOkEVUY7HJUBO+K6N2bw=;
        b=oUgyNVPwsFF408vp7kl6h7NMFrHOqjjoqfOoV1C+Vhp7uoVfjy3nyfZM0vtZKRB93n
         ZH2mZiMMLvj0K57yDFYXe5UIqcU5FpvWVe152H+wjndOBzG/uL54figeZDU9OfcGW/go
         2FYWCJ9vo6ATatfaweteiQWyU9xHXYk6KJNFHn0we5Ua8uB7LynVXMdMOk3HoH0/SIat
         a9OUTyBUQfPq6/cjCZNXnPttiwRhgoV1YzD4KxJwYSDwABm7A6LoVKRqfGT79u9Lw6g0
         4eHe0epDs/MlL/4yYRgHDqD/Kh7GdBby1jCdM9PKafFcAz1eYb7rSYj5rKIohxvH8a1i
         60fQ==
X-Forwarded-Encrypted: i=1; AJvYcCVltQ77sIKev+rJ7Z4+OKCJRCri3yaj1QgUb7uz6EDfyz+eWq5Zq0DWd747fgS0Bwggpa4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqlCos5ZV0drY4IhRBcncbxbsVmSw5aietKgbjaNWXFQLvTiAI
	cO2LTf5XllDVXCoi+Sv3rqPfXczH8AGxOthq6Zql5SnZ+FHazeCo7pNZTPDLHO1KBQAmLmYSGU1
	QAbO2yw==
X-Google-Smtp-Source: AGHT+IFPuHXSftrSHb4VI+WOwzXrEmG2KrWRGFotrBQsdbwxLbepnTjvfNJf6xyG/bBCvEk3pdzNZ+IHvCo=
X-Received: from pjyp3.prod.google.com ([2002:a17:90a:e703:b0:312:4b0b:a94])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b4c:b0:31c:15d9:8a8
 with SMTP id 98e67ed59e1d1-31e5073f3a9mr5315218a91.1.1753303823393; Wed, 23
 Jul 2025 13:50:23 -0700 (PDT)
Date: Wed, 23 Jul 2025 13:50:21 -0700
In-Reply-To: <20250707224720.4016504-6-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com> <20250707224720.4016504-6-jthoughton@google.com>
Message-ID: <aIFLDTa7F7EmhOSR@google.com>
Subject: Re: [PATCH v5 5/7] KVM: selftests: Introduce a selftest to measure
 execution performance
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 07, 2025, James Houghton wrote:
> From: David Matlack <dmatlack@google.com>
> 
> Introduce a new selftest, execute_perf_test, that uses the
> perf_test_util framework to measure the performance of executing code
> within a VM. This test is similar to the other perf_test_util-based
> tests in that it spins up a variable number of vCPUs and runs them
> concurrently, accessing memory.
> 
> In order to support execution, extend perf_test_util to populate guest
> memory with return instructions rather than random garbage. This way
> memory can be execute simply by calling it.
> 
> Currently only x86_64 supports execution, but other architectures can be
> easily added by providing their return code instruction.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>  .../testing/selftests/kvm/execute_perf_test.c | 199 ++++++++++++++++++

Honest question, is there really no way to dedup memstress tests?  This seems
like an insane amount of code just to call memstress_set_execute().

>  .../testing/selftests/kvm/include/memstress.h |   4 +
>  tools/testing/selftests/kvm/lib/memstress.c   |  25 ++-
>  4 files changed, 227 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/execute_perf_test.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index 38b95998e1e6b..0dc435e944632 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -137,6 +137,7 @@ TEST_GEN_PROGS_x86 += x86/recalc_apic_map_test
>  TEST_GEN_PROGS_x86 += access_tracking_perf_test
>  TEST_GEN_PROGS_x86 += coalesced_io_test
>  TEST_GEN_PROGS_x86 += dirty_log_perf_test
> +TEST_GEN_PROGS_x86 += execute_perf_test

How about call_ret_perf_test instead of execute_perf_test?  I like that "execute"
aligns with "read" and "write", but as a test name it ends up being quite ambiguous.

