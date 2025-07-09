Return-Path: <kvm+bounces-51994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ADACBAFF41B
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 23:46:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A0E21C2543F
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 21:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9923E22539E;
	Wed,  9 Jul 2025 21:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nfXbmUyv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A321EA73
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 21:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752097583; cv=none; b=mG1kzUbo8/R/eBe9IhqjOwksNsJUeU+29ZPuM9wXK1o3LhttLY29NXwrmFpLpPEdMeKyqFkuX8DLKSGViLoCsLiq5C1197nYqsp0siqEoO2oMc9cbD5RCLmsIh5KY2/iefnfR6BBWqDbCzmsveAIw+holBaPjMlot5AodJCnZXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752097583; c=relaxed/simple;
	bh=L9LVrS8VhpVhZDH5rGUCmQfvq+9qwn0aD/goPecosqs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dbMzbJLLPiI6iUEM6tNDCaBtOxELfQo6QaYqKdDk2HAtJ9Jj5aKfVlue3QxxjamzmCGvpD8elbYT8BHs26HOVx+358AyH53LwvmEqdiXOcV7OlhsFebYK9yLM0Huz1IJ+9DufZkoehp2iblVTX+QFA2JpIKBUxyACtU6uA5seJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nfXbmUyv; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3139c0001b5so315552a91.2
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 14:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752097582; x=1752702382; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WaqfKSmh/HmFIuS+sSnBu07GpBGE4YrxsliW83zfkFo=;
        b=nfXbmUyvKgjjQhxZ1DMKR9nAU3wnU7b/w8XBBzYyOzzeLjRd3unnRAUF8N3ekQ9xhT
         1Te+0kENlVGLO/E99s10rWnvZ4zptxk2ow4ZaBBGyYg+Tcb82Sdbo1vDEK1Xyi4SRVg/
         GPdcoO9bTafnXVfPiFhnz6n/rLEUa3rXU85yHEzjAMxXxohPXCjT6xF7bZ8Mm8n1wfl0
         jlublq4xq1A5N7oZeunvEH6GDR/xFRayIxJxoBc9fp/UX+rbszG7dahQmxdpqsBSMqjR
         SGKC8UEACTEeCeOcMLD18JW+jobpmJ8e29XVtq4evqtEST8rANiee4ns+Nm2epEA+DfI
         g9fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752097582; x=1752702382;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WaqfKSmh/HmFIuS+sSnBu07GpBGE4YrxsliW83zfkFo=;
        b=jgpf+Fg5obih0rwNogejnHe7y4IivNaZU8nfnaiezc/WtG/k/9GYAOGRfMYR5y4nrX
         AbXeu+aW52WGvqGPH8jkwNu0U9pan+Q1zR39yepBQao2Lmklj+YuTjjDPVSlpyHesjgT
         BYKsTFwuEF0u0+X2V2uAoQPlzkzUSWVEwATmpIcMr4hLgz/mDmjW/pe3TyzTbkaoQDbN
         XlPFpzA4As8SEo4LCIGr2wCt5gcEgT3AJ2YDsOIoh6mOrZbv7j7devAy4IDGHmtozPFA
         s4vm+XmKzfD2nJdPxIpQo/cAuFje72Qfv9pgMm25IYIx22jGZCxh8YS+3CDDlDKInDnB
         21nQ==
X-Gm-Message-State: AOJu0Ywfjq9+eH6bedFkcq4CLw13LKX/LoFRcZRjXA0eElhhI8clIDf4
	OevIJ1yvg2sa8PcA/ZOTYwlKH//RDaW3UOZ/MD9Cyn4IMetMzpI98hCf6kpv1gDRoW7RpwDvF/w
	OsCNAeg==
X-Google-Smtp-Source: AGHT+IGcqFJmd+hfGvHB0iLaIOFTZC36nD5olbTkWzVffAwi5c8bazohN60XOEuv/ND8XITKiAvhLA/8GEg=
X-Received: from pjboh12.prod.google.com ([2002:a17:90b:3a4c:b0:313:230:89ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dcd:b0:311:b0ec:135f
 with SMTP id 98e67ed59e1d1-31c3c2f158emr1976074a91.30.1752097581827; Wed, 09
 Jul 2025 14:46:21 -0700 (PDT)
Date: Wed, 9 Jul 2025 14:46:20 -0700
In-Reply-To: <20250606235619.1841595-4-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com> <20250606235619.1841595-4-vipinsh@google.com>
Message-ID: <aG7jLBAqo1F3SjCl@google.com>
Subject: Re: [PATCH v2 03/15] KVM: selftests: Add timeout option in selftests runner
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev, 
	dmatlack@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 06, 2025, Vipin Sharma wrote:
> diff --git a/tools/testing/selftests/kvm/runner/command.py b/tools/testing/selftests/kvm/runner/command.py
> index a63ff53a92b3..44c8e0875779 100644
> --- a/tools/testing/selftests/kvm/runner/command.py
> +++ b/tools/testing/selftests/kvm/runner/command.py
> @@ -12,14 +12,16 @@ class Command:
>      Returns the exit code, std output and std error of the command.
>      """
>  
> -    def __init__(self, command):
> +    def __init__(self, command, timeout):
>          self.command = command
> +        self.timeout = timeout
>  
>      def run(self):
>          run_args = {
>              "universal_newlines": True,
>              "shell": True,
>              "capture_output": True,
> +            "timeout": self.timeout,
>          }
> @@ -48,10 +50,13 @@ class Selftest:
>              self.stderr = "File doesn't exists."
>              return
>  
> -        ret, self.stdout, self.stderr = self.command.run()
> -        if ret == 0:
> -            self.status = SelftestStatus.PASSED
> -        elif ret == 4:
> -            self.status = SelftestStatus.SKIPPED
> -        else:
> -            self.status = SelftestStatus.FAILED
> +        try:
> +            ret, self.stdout, self.stderr = self.command.run()

I don't see any value in having both command.py and selftest.py.  TimeoutExpired
*really* should be handled by Command, especially with respect to stdout/stderr
(more on that later), but that complicates converting return codes to SelftestStatus.

And even if we do figure out a clean split, one of Command or Selftest would end
but being little more than a wrapper or trampoline, with more boilerplate code
than novel logic.

I don't anticipate turning this into a general execution framework.  The entire
purpose is to run a selftest, so I think it makes sense to scrap Command and just
have Selftest deal with running the executable.

> +            if ret == 0:
> +                self.status = SelftestStatus.PASSED
> +            elif ret == 4:
> +                self.status = SelftestStatus.SKIPPED
> +            else:
> +                self.status = SelftestStatus.FAILED
> +        except subprocess.TimeoutExpired as e:
> +            self.status = SelftestStatus.TIMED_OUT
> diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
> index 104f0b4c2e4e..1409e1cfe7d5 100644
> --- a/tools/testing/selftests/kvm/runner/test_runner.py
> +++ b/tools/testing/selftests/kvm/runner/test_runner.py
> @@ -15,7 +15,7 @@ class TestRunner:
>          self.tests = []
>  
>          for test_file in test_files:
> -            self.tests.append(Selftest(test_file, args.executable))
> +            self.tests.append(Selftest(test_file, args.executable, args.timeout))
>  
>      def _log_result(self, test_result):
>          logger.log(test_result.status,
> -- 
> 2.50.0.rc0.604.gd4ff7b7c86-goog
> 

