Return-Path: <kvm+bounces-51995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A70F3AFF423
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 23:53:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A84F67BCB3C
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 21:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC2A623C8CE;
	Wed,  9 Jul 2025 21:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="14SPpssW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC67238C25
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 21:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752097977; cv=none; b=iR5roZXjToVQV/24+svRztzKEZVKLpeiraAJ54zWj3o7Ve/J9U3uYyHPPNqCgcWEzxMGA0oiIi8zv0kzry344Xxo2nZFYdQQtlNceoKjAu+oa2+Lu2x/6nouyNwVO/gpcJzraTI56Vm525Rdjuu1LrYFgLdETKA+RH4ofqDSMdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752097977; c=relaxed/simple;
	bh=/xPZTCZzCNuaaDNsgHugb6Xu5bYNi2rMFwbd7L507CQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i4U5WoVI9zbYRtLOciQYEB39ye6/R6DtreIkhJR3kHYU6xFdcTJLEb9pekPXlHGSDo6dvJ/M2ZBe1iM/uLQZ+3jyqDlUOj2g2Y34jjTMT1BggDxVJi0ItYbM7yiTLRWLEpJa6qdWhEPm9PjQIhOkj+BVQCIWIlxij0f8vAFKXOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=14SPpssW; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b38fc4d8dbaso394127a12.2
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 14:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752097975; x=1752702775; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XTdASi6OvVTUFFgJuSQBI9XSgCI41XMYqPCdISt4Bfc=;
        b=14SPpssWDNKd1o8ByYyHy26MMNf7cFUs/MkLQG0GFLlj5s0pANKRFYoSYYOUuN2LI+
         VIQAOQXarFv2z2AR6XSKrp4y3YLyldn/q7fHlfPc0tV9qnhmQ68+8+QPXkThTEHKffU2
         obf7k+jc3Zt+GpKT+lSLKF/1TWHm8XC8OdKmGM7/Xk86a0z4yO+Sncf9nCRuE1ARvS/O
         ozZ4meB8pJKDvMYTv3UHPTTaJtLPFO7AtRSCN2AvePEf5x9qgu2PAuvXP4V8RNf/+w8T
         lbiHIvZbMzBQ7xnGfLV/+mgotbEledbO5DIhHY2wdefh7S5EuyuNaDS9Sj2zkvQB+Uw7
         fGRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752097975; x=1752702775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XTdASi6OvVTUFFgJuSQBI9XSgCI41XMYqPCdISt4Bfc=;
        b=a1u8UgIQaArmSsvJ1Qptd11NicN+QsS4Xyxfe9N583Hz6GKLAtY8N6ASlAw7eULjyv
         t9dzYmyVh2ryuO2WvnYQvtfNQ4x4vL2m9VdeOn7hi0Q1dnXBe9y9DQOjhFAkibsGU/9K
         25JAXyNuUqRlvfyDMUh7y2c1M2Ke8RVHfuu7ikUZrWn95dGlLNQOvc8zl0OAavDZv1pX
         EmBCvAO+BBG33FBL+w3fH4KuAaMYc2XuyhkEzXESIZlV1pEyDy8IUYlgTIqZaUDS1oey
         7vjUg4RKfJXNyWNOrpGbz/wLSDbzqIHFTXylE2ALHTsdWnlDRMO97GMDlCWkuWtyKfKv
         xfxQ==
X-Gm-Message-State: AOJu0YyZpokcnE1sfQlNDJuMuzOy270HR2tJTiyFaXcCYIndBRxu4r+A
	yWNSsPvlodw1dT8Y5NsAdAdqq2BULJILVHOxZ5M7OS+CvaEfcZbh6gfy/UoDJKkDHIvtwAMOTmQ
	1LZClWA==
X-Google-Smtp-Source: AGHT+IFmEFlAWWCJkx2sQJoOnRz9L04dVDgiZhvskOboq7Is0Q/s9F5fo+EcgpfALlAli5CGcDY8mYpclV0=
X-Received: from pjbpq7.prod.google.com ([2002:a17:90b:3d87:b0:313:17cf:434f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d8b:b0:312:db8:dbd1
 with SMTP id 98e67ed59e1d1-31c3eeece0cmr314345a91.5.1752097974921; Wed, 09
 Jul 2025 14:52:54 -0700 (PDT)
Date: Wed, 9 Jul 2025 14:52:53 -0700
In-Reply-To: <20250606235619.1841595-5-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com> <20250606235619.1841595-5-vipinsh@google.com>
Message-ID: <aG7ktaz8l4zrwPDX@google.com>
Subject: Re: [PATCH v2 04/15] KVM: selftests: Add option to save selftest
 runner output to a directory
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev, 
	dmatlack@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 06, 2025, Vipin Sharma wrote:
> -    def run(self):
> +    def _run(self, output=None, error=None):
>          run_args = {
>              "universal_newlines": True,
>              "shell": True,
> -            "capture_output": True,
>              "timeout": self.timeout,
>          }
>  
> +        if output is None and error is None:
> +            run_args.update({"capture_output": True})

The runner needs to check that its min version, whatever that ends up being, is
satisfied.

capture_output requires 3.7, but nothing in the runner actually checks that the
min version is met.  If you hadn't mentioned running into a problem with 3.6, I
don't know that I would have figured out what was going wrong all that quickly.

There's also no reason to use capture_output, which appears to be the only
3.7+ dependency.  Just pass subprocess.PIPE for stdout and stderr.

> +        else:
> +            run_args.update({"stdout": output, "stderr": error})
> +
>          proc = subprocess.run(self.command, **run_args)
>          return proc.returncode, proc.stdout, proc.stderr
> +
> +    def run(self):
> +        if self.output_dir is not None:
> +            pathlib.Path(self.output_dir).mkdir(parents=True, exist_ok=True)
> +
> +        output = None
> +        error = None
> +        with contextlib.ExitStack() as stack:
> +            if self.output_dir is not None:
> +                output_path = os.path.join(self.output_dir, "stdout")
> +                output = stack.enter_context(
> +                    open(output_path, encoding="utf-8", mode="w"))
> +
> +                error_path = os.path.join(self.output_dir, "stderr")
> +                error = stack.enter_context(
> +                    open(error_path, encoding="utf-8", mode="w"))
> +            return self._run(output, error)
> diff --git a/tools/testing/selftests/kvm/runner/selftest.py b/tools/testing/selftests/kvm/runner/selftest.py
> index 4c72108c47de..664958c693e5 100644
> --- a/tools/testing/selftests/kvm/runner/selftest.py
> +++ b/tools/testing/selftests/kvm/runner/selftest.py
> @@ -32,7 +32,7 @@ class Selftest:
>      Extract the test execution command from test file and executes it.
>      """
>  
> -    def __init__(self, test_path, executable_dir, timeout):
> +    def __init__(self, test_path, executable_dir, timeout, output_dir):
>          test_command = pathlib.Path(test_path).read_text().strip()
>          if not test_command:
>              raise ValueError("Empty test command in " + test_path)
> @@ -40,7 +40,11 @@ class Selftest:
>          test_command = os.path.join(executable_dir, test_command)
>          self.exists = os.path.isfile(test_command.split(maxsplit=1)[0])
>          self.test_path = test_path
> -        self.command = command.Command(test_command, timeout)
> +
> +        if output_dir is not None:
> +            output_dir = os.path.join(output_dir, test_path.lstrip("/"))
> +        self.command = command.Command(test_command, timeout, output_dir)
> +
>          self.status = SelftestStatus.NO_RUN
>          self.stdout = ""
>          self.stderr = ""
> diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
> index 1409e1cfe7d5..0501d77a9912 100644
> --- a/tools/testing/selftests/kvm/runner/test_runner.py
> +++ b/tools/testing/selftests/kvm/runner/test_runner.py
> @@ -13,19 +13,22 @@ logger = logging.getLogger("runner")
>  class TestRunner:
>      def __init__(self, test_files, args):
>          self.tests = []
> +        self.output_dir = args.output
>  
>          for test_file in test_files:
> -            self.tests.append(Selftest(test_file, args.executable, args.timeout))
> +            self.tests.append(Selftest(test_file, args.executable,
> +                                       args.timeout, args.output))
>  
>      def _log_result(self, test_result):
>          logger.log(test_result.status,
>                     f"[{test_result.status}] {test_result.test_path}")

Previous patch, but I missed it there.  Print the *name* of the result, not the
integer, which is arbitrary magic.  i.e

        logger.log(test_result.status,
                   f"[{test_result.status.name}] {test_result.test_path}")

> -        logger.info("************** STDOUT BEGIN **************")
> -        logger.info(test_result.stdout)
> -        logger.info("************** STDOUT END **************")
> -        logger.info("************** STDERR BEGIN **************")
> -        logger.info(test_result.stderr)
> -        logger.info("************** STDERR END **************")
> +        if (self.output_dir is None):

Ugh.  I want both.  Recording to disk shouldn't prevent the user from seeing
real-time data.

Rather than redirect to a file, always pipe to stdout/stderr, and then simply
write to the appropriate files after the subprocess completes.  That'll also force
the issue on fixing a bug with timeouts, where the runner doesn't capture stdout
or stderr.

> +            logger.info("************** STDOUT BEGIN **************")
> +            logger.info(test_result.stdout)
> +            logger.info("************** STDOUT END **************")
> +            logger.info("************** STDERR BEGIN **************")
> +            logger.info(test_result.stderr)
> +            logger.info("************** STDERR END **************")

This is unnecessarily verbose.  The logger spits out a timestamp, just use that
to demarcate, e.g.

	logger.info("*** stdout ***\n" + test_result.stdout)
	logger.info("*** stderr ***\n" + test_result.stderr)

yields

14:52:29 | *** stdout ***
Random seed: 0x6b8b4567

14:52:29 | *** stderr ***
==== Test Assertion Failure ====
  x86/state_test.c:316: memcmp(&regs1, &regs2, sizeof(regs2))
  pid=168652 tid=168652 errno=4 - Interrupted system call
     1	0x0000000000402300: main at state_test.c:316 (discriminator 1)
     2	0x000000000041e413: __libc_start_call_main at libc-start.o:?
     3	0x00000000004205bc: __libc_start_main_impl at ??:?
     4	0x00000000004027a0: _start at ??:?
  Unexpected register values after vcpu_load_state; rdi: 7ff68b1f3040 rsi: 0

>  
>      def start(self):
>          ret = 0
> -- 
> 2.50.0.rc0.604.gd4ff7b7c86-goog
> 

