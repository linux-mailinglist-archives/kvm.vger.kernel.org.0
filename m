Return-Path: <kvm+bounces-41544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F359A6A0F4
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 09:13:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 856DE7A42AC
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 08:12:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D5F20ADFE;
	Thu, 20 Mar 2025 08:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="RFXG4+b8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9D91CC8B0
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 08:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742458411; cv=none; b=fyl1dZW4np8q3BBU4k4uatvfavTwQQ2+l2Xmo25zTZDrqCFp9Su12asul5lPu4VaTBwgK2eHI9870I33nLeK7Ug/2GxL6SDxzxs8Hn6JdZxM7L1P6Uf4NqNbjhItxlpx2k5NCEDC51nlwA1q5IGXOezPfycstPoffQw1/HvN95c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742458411; c=relaxed/simple;
	bh=z4RUTZdrzgwTn4RNqs5Vpu9NYHXkK99BKDYZIifQnyw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dyupMudO1fQpouaaGZ88etpOBA/+txf8DiOeNJbl+JR8BoSRiJ6RILl3Y1YcvvJynehI8vdlySzEFW7V5a41dnyDVsLlVKE0wKTJavKa1gxYqXBx1fzhwFTAK2wJrpM1sqtGGImKq+Rdtbe9ZDwegQ3B+DuFj4jGTuJHZwUT0TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=RFXG4+b8; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43d04dc73b7so5028225e9.3
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 01:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742458407; x=1743063207; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ekGU7brr4jX+W+iiL6Rma3ooLoZ/Nd591DgGZIFamps=;
        b=RFXG4+b8M6Je1IX3pW6F7SwaTKVQAMw8OYCoghqhSV9gRdPVHPdzgy7EsNHoSjI5zF
         n4rYvFo4jo8qvPG7ZqnuUjGf4oACoaItOjYxUUcFYmQG0Vyxyxik5DBihUT6VvjZJ4RP
         /lnM30retGgokz4zSolhqnpjWKVLjNZm8EzMj0JFUIOtyhntAhKQ88ED7Q9btVpoU/i4
         p+amNthAtbOMnSp2GnW3YKa+G9uTssGBFVZYiWp1QNB6s3BkilS8cMqUrsYxKEkuX8gX
         SKxUm5h4rYmFWWNX5y1TBhBO4jdntlydgyykcgJjRlpadAAlXfP4Ar4c5aCBiKtYwJxq
         itYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742458407; x=1743063207;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ekGU7brr4jX+W+iiL6Rma3ooLoZ/Nd591DgGZIFamps=;
        b=pL+edtw7f/kJd59mXYeBejC6+KsYX8O6hk9DkB/+xbfce+0Y1kI0q/nxQWC4WgAyYG
         dcrazwFRE0ZxpmTT/3aDewL3ZOUfRMjq0gEzbXxtqvULrLdKVoTmjR1Ai+7jjLXHWim7
         nE2jRZWB/3RTPtMSWdhjJSTXIBlvpivp+5arKrXuoMD0mg3q+EFn50aerouK4OP3sB3/
         mpM/C7fGL1IyOdQh8SWQ1pxcMUsKfRPPFhTKJegC0N9K/GWGDnSiH9LoKBEAIO2IVNKh
         yIwqAaSQ/L9qSkZnWtP7RkxJVuwPlwXP2xAaWnk9POT3QEOOpT8lMBv+rIgMDZ+NaKIH
         o3ww==
X-Gm-Message-State: AOJu0YxUGwOAeme6rj55+yrDGToUWDj15t02BCOdxVO0s6Hcdl01PWgs
	HT4vnoEgyWhjdMHZeoVCRt6HNENQZ6k960Sdct/bMM2ps+5ymYgFeD2LHeyv7JA=
X-Gm-Gg: ASbGncslmYU3R7AwFBxVVhk7gS7s80/sItV5jH3KMKG3cLOjvJ3mn97d0mQ8e8bDRDt
	qPvhc/tDaDN4fHBAAmSiex15XB8ogPCnE4zNho4PpioxuVGl5H4tlq/AS9xWeXYEiB/PcbHEUr1
	6iEu192KYWu+4eh24Qm6QtkJgLOjE38VkOZmHR8Kd/Nns2+nTJFPuGUOKJaM2Hpytper4olCnbw
	voAMzEjELNKxiOsu+Jnj2VbXzVyIEj9fIt1bMoY1uUIyHkeH/73weTAxWr4tfi5c5wCvFmn3bdV
	SSnDIxi9gNnlYIGaxRog0C9BSQPyWgYg5pzWJgJVvjIQhKWkaz/8jlXsR6j4rN/1MzHfpqz2HrX
	vemkWy9WfRuk24A==
X-Google-Smtp-Source: AGHT+IEqVIrxETAewQ33aJ8x4K8Bc0fp4bOm8zrU3ts8m2+xufqFenO36BTCNpDFnBGCemrC0JMbdw==
X-Received: by 2002:a05:600c:4fc3:b0:43c:efae:a73 with SMTP id 5b1f17b1804b1-43d4953c78fmr16841665e9.10.1742458406849;
        Thu, 20 Mar 2025 01:13:26 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d4870ee71sm24255095e9.30.2025.03.20.01.13.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 01:13:26 -0700 (PDT)
Message-ID: <db699145-935e-43f3-8305-ff1f3d4cef89@rivosinc.com>
Date: Thu, 20 Mar 2025 09:13:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v11 0/8] riscv: add SBI SSE extension tests
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel
 <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
References: <20250317164655.1120015-1-cleger@rivosinc.com>
 <20250319-ff9d4b4904195050638f77f1@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250319-ff9d4b4904195050638f77f1@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 19/03/2025 19:01, Andrew Jones wrote:
> Hi Clément,
> 
> I'd like to merge this, but we still have 50 failures with the latest
> opensbi and over 30 with the opensbi QEMU provides. Testing with [1]
> and bumping the timeout to 6000 allowed me to avoid failures, however
> we can't count on that for CI.
> 
> [1] https://lists.infradead.org/pipermail/opensbi/2025-March/008190.html
> 
> I'm thinking about just doing the following. What do you think?

Hi Andrew,

Since the spec isn't even ratified, does it even make sense to test a
version that does not implement the ratified SBI V3.0 spec ? IOW, should
we simply test for SBI version to be >= 3.0 ? This will be correct for
all SBI implementation.

However, If you want that series to be integrated ASAP, I'm ok with your
patch , it seems unlikely that the SSE specification will change in the
upcoming weeks.

Reviewed-by: Clément Léger <cleger@rivosinc.com>

Thanks,

Clément

> 
> Thanks,
> drew
> 
> diff --git a/riscv/sbi-sse.c b/riscv/sbi-sse.c
> index a31c84c32303..fb4ee7dd44b2 100644
> --- a/riscv/sbi-sse.c
> +++ b/riscv/sbi-sse.c
> @@ -1217,7 +1217,6 @@ void check_sse(void)
>  {
>         struct sse_event_info *info;
>         unsigned long i, event_id;
> -       bool sbi_skip_inject = false;
>         bool supported;
> 
>         report_prefix_push("sse");
> @@ -1228,6 +1227,13 @@ void check_sse(void)
>                 return;
>         }
> 
> +       if (sbi_get_imp_id() == SBI_IMPL_OPENSBI &&
> +           sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, 7)) {
> +               report_skip("OpenSBI < v1.7 detected, skipping tests");
> +               report_prefix_pop();
> +               return;
> +       }
> +
>         sse_check_mask();
> 
>         /*
> @@ -1237,18 +1243,6 @@ void check_sse(void)
>          */
>         on_cpus(sse_secondary_boot_and_unmask, NULL);
> 
> -       /* Check for OpenSBI to support injection */
> -       if (sbi_get_imp_id() == SBI_IMPL_OPENSBI) {
> -               if (sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, 6)) {
> -                       /*
> -                        * OpenSBI < v1.6 crashes kvm-unit-tests upon injection since injection
> -                        * arguments (a6/a7) were reversed. Skip injection tests.
> -                        */
> -                       report_skip("OpenSBI < v1.6 detected, skipping injection tests");
> -                       sbi_skip_inject = true;
> -               }
> -       }
> -
>         sse_test_invalid_event_id();
> 
>         for (i = 0; i < ARRAY_SIZE(sse_event_infos); i++) {
> @@ -1265,14 +1259,12 @@ void check_sse(void)
>                 sse_test_attrs(event_id);
>                 sse_test_register_error(event_id);
> 
> -               if (!sbi_skip_inject)
> -                       run_inject_test(info);
> +               run_inject_test(info);
> 
>                 report_prefix_pop();
>         }
> 
> -       if (!sbi_skip_inject)
> -               sse_test_injection_priority();
> +       sse_test_injection_priority();
> 
>         report_prefix_pop();
>  }
> 
> On Mon, Mar 17, 2025 at 05:46:45PM +0100, Clément Léger wrote:
>> This series adds tests for SBI SSE extension as well as needed
>> infrastructure for SSE support. It also adds test specific asm-offsets
>> generation to use custom OFFSET and DEFINE from the test directory.
>>
>> These tests can be run using an OpenSBI version that implements latest
>> specifications modification [1]
>>
>> Link: https://github.com/rivosinc/opensbi/tree/dev/cleger/sse [1]
>>
>> ---
>>
>> V11:
>>  - Use mask inside sbi_impl_opensbi_mk_version()
>>  - Mask the SBI version with a new mask
>>  - Use assert inside sbi_get_impl_id/version()
>>  - Remove sbi_check_impl()
>>  - Increase completion timeout as events failed completing under 1000
>>    micros when system is loaded.
>>
>> V10:
>>  - Use && instead of || for timeout handling
>>  - Add SBI patches which introduce function to get implementer ID and
>>    version as well as implementer ID defines.
>>  - Skip injection tests in OpenSBI < v1.6
>>
>> V9:
>>  - Use __ASSEMBLER__ instead of __ASSEMBLY__
>>  - Remove extra spaces
>>  - Use assert to check global event in
>>    sse_global_event_set_current_hart()
>>  - Tabulate SSE events names table
>>  - Use sbi_sse_register() instead of sbi_sse_register_raw() in error
>>    testing
>>  - Move a report_pass() out of error path
>>  - Rework all injection tests with better error handling
>>  - Use an env var for sse event completion timeout
>>  - Add timeout for some potentially infinite while() loops
>>
>> V8:
>>  - Short circuit current event tests if failure happens
>>  - Remove SSE from all report strings
>>  - Indent .prio field
>>  - Add cpu_relax()/smp_rmb() where needed
>>  - Add timeout for global event ENABLED state check
>>  - Added BIT(32) aliases tests for attribute/event_id.
>>
>> V7:
>>  - Test ids/attributes/attributes count > 32 bits
>>  - Rename all SSE function to sbi_sse_*
>>  - Use event_id instead of event/evt
>>  - Factorize read/write test
>>  - Use virt_to_phys() for attributes read/write.
>>  - Extensively use sbiret_report_error()
>>  - Change check function return values to bool.
>>  - Added assert for stack size to be below or equal to PAGE_SIZE
>>  - Use en env variable for the maximum hart ID
>>  - Check that individual read from attributes matches the multiple
>>    attributes read.
>>  - Added multiple attributes write at once
>>  - Used READ_ONCE/WRITE_ONCE
>>  - Inject all local event at once rather than looping fopr each core.
>>  - Split test_arg for local_dispatch test so that all CPUs can run at
>>    once.
>>  - Move SSE entry and generic code to lib/riscv for other tests
>>  - Fix unmask/mask state checking
>>
>> V6:
>>  - Add missing $(generated-file) dependencies for "-deps" objects
>>  - Split SSE entry from sbi-asm.S to sse-asm.S and all SSE core functions
>>    since it will be useful for other tests as well (dbltrp).
>>
>> V5:
>>  - Update event ranges based on latest spec
>>  - Rename asm-offset-test.c to sbi-asm-offset.c
>>
>> V4:
>>  - Fix typo sbi_ext_ss_fid -> sbi_ext_sse_fid
>>  - Add proper asm-offset generation for tests
>>  - Move SSE specific file from lib/riscv to riscv/
>>
>> V3:
>>  - Add -deps variable for test specific dependencies
>>  - Fix formatting errors/typo in sbi.h
>>  - Add missing double trap event
>>  - Alphabetize sbi-sse.c includes
>>  - Fix a6 content after unmasking event
>>  - Add SSE HART_MASK/UNMASK test
>>  - Use mv instead of move
>>  - move sbi_check_sse() definition in sbi.c
>>  - Remove sbi_sse test from unitests.cfg
>>
>> V2:
>>  - Rebased on origin/master and integrate it into sbi.c tests
>>
>> Clément Léger (8):
>>   kbuild: Allow multiple asm-offsets file to be generated
>>   riscv: Set .aux.o files as .PRECIOUS
>>   riscv: Use asm-offsets to generate SBI_EXT_HSM values
>>   lib: riscv: Add functions for version checking
>>   lib: riscv: Add functions to get implementer ID and version
>>   riscv: lib: Add SBI SSE extension definitions
>>   lib: riscv: Add SBI SSE support
>>   riscv: sbi: Add SSE extension tests
>>
>>  scripts/asm-offsets.mak |   22 +-
>>  riscv/Makefile          |    5 +-
>>  lib/riscv/asm/csr.h     |    1 +
>>  lib/riscv/asm/sbi.h     |  177 +++++-
>>  lib/riscv/sbi-sse-asm.S |  102 ++++
>>  lib/riscv/asm-offsets.c |    9 +
>>  lib/riscv/sbi.c         |  105 +++-
>>  riscv/sbi-tests.h       |    1 +
>>  riscv/sbi-asm.S         |    6 +-
>>  riscv/sbi-asm-offsets.c |   11 +
>>  riscv/sbi-sse.c         | 1278 +++++++++++++++++++++++++++++++++++++++
>>  riscv/sbi.c             |    2 +
>>  riscv/.gitignore        |    1 +
>>  13 files changed, 1707 insertions(+), 13 deletions(-)
>>  create mode 100644 lib/riscv/sbi-sse-asm.S
>>  create mode 100644 riscv/sbi-asm-offsets.c
>>  create mode 100644 riscv/sbi-sse.c
>>  create mode 100644 riscv/.gitignore
>>
>> -- 
>> 2.47.2
>>


