Return-Path: <kvm+bounces-51998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D9FAFF451
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 00:01:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB2C21C8255B
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 22:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CE97239597;
	Wed,  9 Jul 2025 22:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QoYJsZEl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C49E13D2B2
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 22:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752098491; cv=none; b=hhLaaf3/qyKyuMWSOmHMomxxfOTB7qn5dkB4AGp/nJ4fDefiRgPBM78pgDdLOG/BCYJqiqA9y4aOZfPgztaGOfGtWTKAwiVsrtIWodBIGewylbzQXt4P+SA+tiH0vTRUmm/jBWjXE0aXnEjoWP6dLS6XuRcYFW7GCqtR6IM3Vig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752098491; c=relaxed/simple;
	bh=RaFKs7NUWtXcrGPuqdMmkXEZpFhssJ/jE72lMQUkE9c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R8XSff7HyLJUv3nl7b2oV3fpgWDGjhnd7BEDdI1WBhP7k+VLmolVTyaIiZIBxA3MieL4/dJ076q55WSwVSBTWvXPCI/Gm0T8TJCCH21CwVbP9JfCw9ucMjPhjjVs0gWBYx/Vt8uLmMIreZvg3S9OCfnETTSOmr0qVupNQ/3Id+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QoYJsZEl; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3122368d82bso592631a91.0
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 15:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752098489; x=1752703289; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qPkxg71a8xKMOk7gRt6YiWOPIe8HfaUrT3StylJgAHI=;
        b=QoYJsZEl8chog57pOcVS17nFUR9MbdkDfJfrVilxzQHtLZdhO3q4FMEy91JwQAlJVS
         FPzprcjhBa8wOYguKTJlZVgfOKsn2VipsJNQzV+scHMpxUwsU33Y4stKcyq95m43TyM/
         nIs57mPW4sB+sDrU7m02obYQBYEB9ccO4q61OfhnAbLEncwHF4+8t1znBxl+WQJt72ot
         ieLS5BX7AUjSGXGSicAirdba/deFo1Zn57D7a5NKBVVjbbQ39ZVQTZQBCrUZCAcXyhgR
         63Xq2iF5mGYWsaPbO3oqwKyRMX7ATZavnWRsSMH7AZPqhX2/VB30hKVIwZwkeJ1DHume
         v5bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752098489; x=1752703289;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qPkxg71a8xKMOk7gRt6YiWOPIe8HfaUrT3StylJgAHI=;
        b=CCc8FgU/VDtn+xwCED7lBOaOfut6B43T/6opxHGhiIc9VTc6fHgTb+Y9YBKvr+qIrs
         arT/KNTwK/nGh1Nx+VchUvyrRPwyhLaulUW0YrzrwtiKUrJkUAGaymqE06b/fQq2YGqB
         PknzYr8TdbZU8ZWRfJPdcBNIZv22MHzgBDpez12CoolJ9tOsmLA3ZKUc6GbQJPkD3NuT
         HI10mKn6zP/MpOOi5gOgvQuGXx1Rm9ultMGxgPAi1axTbjByPuKdLpPAD4wCJCEU8r05
         W5G+Iw83zj4bqEPOtxewUzLdLLswEJIYv9xZ8053R+QJemZe9Ez3S8NRyAHwKa+KaL5Y
         XVIQ==
X-Gm-Message-State: AOJu0Yx8sk0OmUB76MAHe0AN2xq4H7bTB/G9S8Gvn5N3fsn9xhEmeEmY
	wOfOap7qieIqcBeXnAt/bA7YsNGOvWuY59BCp6KQm0yd4gVDFT8HFHC3fxPZTECIczrSQkhpm0F
	wnAHAkg==
X-Google-Smtp-Source: AGHT+IGv5Auh5afur7rrmDtcmRu/ac16McioXeHVJV7IWM1fJ+YSaOB7uGrq5SXWMiQzxRu0kWJqhfgibQ4=
X-Received: from pjblw1.prod.google.com ([2002:a17:90b:1801:b0:31c:2fe4:33b9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2b43:b0:312:e279:9ccf
 with SMTP id 98e67ed59e1d1-31c3ef100acmr359390a91.5.1752098489536; Wed, 09
 Jul 2025 15:01:29 -0700 (PDT)
Date: Wed, 9 Jul 2025 15:01:28 -0700
In-Reply-To: <20250606235619.1841595-8-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com> <20250606235619.1841595-8-vipinsh@google.com>
Message-ID: <aG7muHNldvv8fRyH@google.com>
Subject: Re: [PATCH v2 07/15] KVM: selftests: Add various print flags to KVM
 Selftest Runner
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev, 
	dmatlack@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 06, 2025, Vipin Sharma wrote:
> Add various print flags to selectively print outputs on terminal based
> on test execution status (passed, failed, timed out, skipped, no run).
> 
> Provide further options to print only particular execution status, like
> print only status of failed tests.
> 
> Example: To print status, stdout and stderr for failed tests and only
> print status of passed test:
> 
>    python3 runner --test-dirs tests  --print-failed \
>    --print-passed-status
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  .../testing/selftests/kvm/runner/__main__.py  | 114 ++++++++++++++++++
>  .../selftests/kvm/runner/test_runner.py       |  10 +-
>  2 files changed, 123 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
> index 3f11a20e76a9..4406d8e4847a 100644
> --- a/tools/testing/selftests/kvm/runner/__main__.py
> +++ b/tools/testing/selftests/kvm/runner/__main__.py
> @@ -64,9 +64,115 @@ def cli():
>                          default=False,
>                          help="Print only test's status and avoid printing stdout and stderr of the tests")
>  
> +    parser.add_argument("--print-passed",
> +                        action="store_true",
> +                        default=False,
> +                        help="Print passed test's stdout, stderr and status."
> +                        )
> +
> +    parser.add_argument("--print-passed-status",
> +                        action="store_true",
> +                        default=False,
> +                        help="Print only passed test's status."
> +                        )

Waaay too many booleans :-)

And they don't provide the right granularity.  E.g. I don't want stdout for FAILED,
I just want stderr for the assert.

After some fiddling, I came up with this:

    parser.add_argument("--print-passed", default="full", const="full", nargs='?', choices=["off", "full", "stderr", "stdout", "status"],
                        help="blah"
                        )

    parser.add_argument("--print-failed", default="full", const="full", nargs='?', choices=["off", "full", "stderr", "stdout", "status"],
                        help="Full = print each test's stdout, stderr and status; status = only status."
                        )

    parser.add_argument("--print-skipped", default="full", const="full", nargs='?', choices=["off", "full", "stderr", "stdout", "status"],
                        help="Print skipped test's stdout, stderr and status."
                        )

    parser.add_argument("--print-timed-out", default="full", const="full", nargs='?', choices=["off", "full", "stderr", "stdout", "status"],
                        help="Print timed out test's stdout, stderr and status."
                        )

    parser.add_argument("--print-no-run", default="full", const="full", nargs='?', choices=["off", "full", "stderr", "stdout", "status"],
                        help="Print stdout, stderr and status for tests which didn't run."
                        )

The const+nargs magic makes a bare option equivalent to "full", e.g. --print-timed-out
and --print-timed-out=full are the same.  That gives the user complete control
over the output, with _less_ code in the runner.  E.g. to print stdout and/or stderr:

        print_level = self.print_stds.get(test_result.status);
        if (print_level == "full" or print_level == "stdout"):
            logger.info("*** stdout ***\n" + test_result.stdout)

        if (print_level == "full" or print_level == "stderr"):
            logger.info("*** stderr ***\n" + test_result.stderr)

