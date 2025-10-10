Return-Path: <kvm+bounces-59768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FEA2BCC737
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 11:58:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C80B64030EB
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 09:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9682C2ED17A;
	Fri, 10 Oct 2025 09:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YvfFGZzQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2510020A5EA
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 09:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760090330; cv=none; b=tEquy+UVwTS7easq+HPSMIIgSgufxZOGpZ5aMRG8CDqZIbi+DXlrv4Hk80D+OhUWZigF0mqhx1y1I0JHmbRh/Cdo9ewPYIIWKCuPqBtWlwSS/5jqHeB1lZWGhSeSzc3G3whsuL1C2b79hQsFdXCGYDPBKf/YIPgqNlCd8frk05E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760090330; c=relaxed/simple;
	bh=mh6zOEGaP4Urq2/R26m36fxu8TENj6LiLLSaMCjHpIE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uZBPefd4R/DhygvDcXuHMF7NAUKkNUueM8UfYLK/4avb1SrhWlUTpUmCjanAtcZDo3DxHZ3krgfTFyhUjIHtir+8LXcw4zVqq6iffDJqhPOyvvf7AsWp2PKboiNiaCIY9zkrK3UuZP8Qsi9ZP9+226cJE375JtiPg516fUBktDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YvfFGZzQ; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46b303f6c9cso15197575e9.2
        for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 02:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760090327; x=1760695127; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zj/uK/0xnB0ZmAgqvqZKJ167+Wzz4WpLCK/iSob8rPE=;
        b=YvfFGZzQaLj9xcMMA1LnSX9iOnc3Zb1AtGP4Ey8Ndk3h1ZsCtDGsqoUvdJPI8/t2K/
         bm2GO2GZfOECn377P63gTMFhOQnLaRJ20ejCqCp7uqgJjFixdAVAY4jBS5e+3HVmLyzn
         97soeGHVjmGMr3l0C49KBkvFYvXu53LHKN3I+80H4cfmyNbsnE4PbC58HeG4hzJuGdfd
         h70UfdL1JygTo422grHjNlfZwjUdnO4j9IjhH3g2C/Osvtxo9/biLPj3yb/ry3j1txzx
         poG1UsNto5U5vqmaGx+Ra4DBatzKx5H3dpziZ/45xpWL8JzX5gYlDeqE+2o8ct17Wci2
         w7GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760090327; x=1760695127;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zj/uK/0xnB0ZmAgqvqZKJ167+Wzz4WpLCK/iSob8rPE=;
        b=ZJncE8fRVuaEsF7lLI4ZY5ziV6NKt39upsxz4XS3oW+5ZT+qPIbq5Q9MtAtYgjBQYj
         7CC70PNJEKQmRw4ch68hKXGHFZYkRzKVujEubc+lMjScx391a2kaeSx80i8SfBoL7X4A
         2wHYRMEVFzkw1MWqSBPGcXCIkoDPwoLPLVjuyHZPd/Gn/fb33s3KTLRYFCyYwjBH8SRs
         enItqhHtzFdIjDh24fzoztD4H0HEsSdAM/9IsocC4w2UMtcp/4JVKy4xbq5Q4W7AajGo
         Tob10Nno03gPO1UKTHtqbjbJEb1oNPtz3KixcsKlipdMEu15Ldcb52r/o3KxqaADgQZp
         7C6w==
X-Forwarded-Encrypted: i=1; AJvYcCVq5O9Qk6hcBTJte00YG4ZAl/cEckgcRKZFFhrNGTBorD9kZHy33FQn5n5p8Gx8YKMNgDc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2pmVEdfX90YTIZlYgZmXLAMFLWvSrjoTxXKOl0elMp/5jqMYz
	TsKzj7jrUmbGGIBQKijvG94hNz8a82hBQbDUMyVoDntfrM/v0IU11FkGzQj6VVFLm5uQr26mIF9
	VQHnpJa3mruG9KA==
X-Google-Smtp-Source: AGHT+IE9u+S1m4RvSQpcC4dhxfuWaCPOQKXUOfLx4fze56fNXcannsh6o7Uhc8MhG1M6iartSBP/RZWrRlO7LA==
X-Received: from wmco8.prod.google.com ([2002:a05:600c:a308:b0:45f:28be:a3aa])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:34c5:b0:46e:4ac4:b7b8 with SMTP id 5b1f17b1804b1-46fa9b05361mr68861915e9.25.1760090327657;
 Fri, 10 Oct 2025 02:58:47 -0700 (PDT)
Date: Fri, 10 Oct 2025 09:58:46 +0000
In-Reply-To: <20250930163635.4035866-10-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com> <20250930163635.4035866-10-vipinsh@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDEJY5ON407O.2O7CMOY9311NV@google.com>
Subject: Re: [PATCH v3 9/9] KVM: selftests: Provide README.rst for KVM
 selftests runner
From: Brendan Jackman <jackmanb@google.com>
To: Vipin Sharma <vipinsh@google.com>, <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>, 
	<kvm-riscv@lists.infradead.org>
Cc: <seanjc@google.com>, <pbonzini@redhat.com>, <borntraeger@linux.ibm.com>, 
	<frankja@linux.ibm.com>, <imbrenda@linux.ibm.com>, <anup@brainfault.org>, 
	<atish.patra@linux.dev>, <zhaotianrui@loongson.cn>, <maobibo@loongson.cn>, 
	<chenhuacai@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>, 
	<ajones@ventanamicro.com>, 
	kvm-riscv <kvm-riscv-bounces@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Tue Sep 30, 2025 at 4:36 PM UTC, Vipin Sharma wrote:
> Add README.rst for KVM selftest runner and explain how to use the
> runner.
>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |  1 +
>  tools/testing/selftests/kvm/runner/README.rst | 54 +++++++++++++++++++
>  2 files changed, 55 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/runner/README.rst
>
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 548d435bde2f..83aa2fe01bac 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -4,6 +4,7 @@
>  !*.c
>  !*.h
>  !*.py
> +!*.rst
>  !*.S
>  !*.sh
>  !*.test
> diff --git a/tools/testing/selftests/kvm/runner/README.rst b/tools/testing/selftests/kvm/runner/README.rst
> new file mode 100644
> index 000000000000..83b071c0a0e6
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/runner/README.rst
> @@ -0,0 +1,54 @@
> +KVM Selftest Runner
> +===================
> +
> +KVM selftest runner is highly configurable test executor that allows to run
> +tests with different configurations (not just the default), parallely, save
> +output to disk hierarchically, control what gets printed on console, provide
> +execution status.
> +
> +To generate default tests use::
> +
> +  # make tests_install
> +
> +This will create ``testcases_default_gen`` directory which will have testcases
> +in `default.test` files. Each KVM selftest will have a directory in  which
> +`default.test` file will be created with executable path relative to KVM
> +selftest root directory i.e. `/tools/testing/selftests/kvm`. For example, the
> +`dirty_log_perf_test` will have::
> +
> +  # cat testcase_default_gen/dirty_log_perf_test/default.test
> +  dirty_log_perf_test
> +
> +Runner will execute `dirty_log_perf_test`. Testcases files can also provide
> +extra arguments to the test::
> +
> +  # cat tests/dirty_log_perf_test/2slot_5vcpu_10iter.test
> +  dirty_log_perf_test -x 2 -v 5 -i 10
> +
> +In this case runner will execute the `dirty_log_perf_test` with the options.
> +
> +Example
> +=======
> +
> +To see all of the options::
> +
> +  # python3 runner -h
> +
> +To run all of the default tests::
> +
> +  # python3 runner -d testcases_default_gen
> +
> +To run tests parallely::
> +
> +  # python3 runner -d testcases_default_gen -j 40
> +
> +To print only passed test status and failed test stderr::
> +
> +  # python3 runner -d testcases_default_gen --print-passed status \
> +  --print-failed stderr
> +
> +To run tests binary which are in some other directory (out of tree builds)::
> +
> +  # python3 runner -d testcases_default_gen -p /path/to/binaries

I understand that for reasons of velocity it might make sense to do this
as a KVM-specific thing, but IIUC very little of this has anything to do
with KVM in particular, right? Is there an expectation to evolve in a
more KVM-specific direction?

(One thing that might be KVM-specific is the concurrency. I assume there
are a bunch of KVM tests that are pretty isolated from one another and
reasonable to run in parallel. Testing _the_ mm like that just isn't
gonna work most of the time. I still think this is really specific to
individual sets of tests though, in a more mature system there would be
a metadata mechanism for marking tests as parallelisable wrt each other.
I guess this patchset is part of an effort to have a more mature system
that enables that kind of thing.).

To avoid confusing people and potentially leave the door open to a
cleaner integration, please can you add some bits here about how this
relates to the rest of the kselftest infrastructure? Some questions I
think are worth answering:

- As someone who runs KVM selftests, but doesn't work specifically on
  KVM, to what extent do I need to know about this tool? Can I still run
  the selftests "the old fashioned way" and if so what do I lose as
  compared to using the KVM runner?

- Does this system change the "data model" of the selftests at all, and
  if so how? I.e. I think (but honestly I'm not sure) that kselftests
  are a 2-tier hierarchy of $suite:$test without any further
  parameterisation or nesting (where there is more detail, it's hidden
  as implementation details of individual $tests). Do the KVM selftests
  have this structure? If it differs, how does that effect the view from
  run_kselftest.sh?

- I think (again, not very sure) that in kselftest that each $test is a
  command executing a process. And this process communicates its status
  by printing KTAP and returning an exit code. Is that stuff the same
  for this runner?

