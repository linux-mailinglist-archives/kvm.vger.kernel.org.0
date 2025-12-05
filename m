Return-Path: <kvm+bounces-65336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AB36CA6BBA
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 09:40:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 23C4730274F6
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 08:40:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15C3B307AD3;
	Fri,  5 Dec 2025 08:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a/2InhRG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41712FDC37
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 08:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764922481; cv=none; b=SPBOquB6I2IMRyt8S5KyuymBqUlP4gCxoLXEF9NBVM/YQjLzs2FIGtrplvibasuLog0YmJ5qNxap4d1N6PNpJT0b7J0xBNQlq8L3uvNQ4Ed1CmRDFccjC00IVvF5XavbQ/gIQBW2P6ytSc/NT9nWFN3wciePT77TcrdKELpeWXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764922481; c=relaxed/simple;
	bh=0RHZSt8Rw9QmvIHwdWHzOjQuFOOVbORxFGyFG2AYHXA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e5V+WmM9TO4EmnGUp8OPQysWUxaGZMZWaPp8GTlUwUEsPDkER5Xb9zeI1KRnNC7dYLHp/XhzYSnfJYWuwhRNokT7OdtC8ZCSto8mkvS8mBF6InzbFMwEGEJ8y6U6iHOU4dIOWar5NrGSLBRz8TSldW1hkwGPvnkL9yseMNhp5Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a/2InhRG; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42e2e52cc04so670984f8f.0
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 00:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764922464; x=1765527264; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NzSyLk52oyXBylv+Fjf8LJOfI7vnqUzRhJuVyNT36Pg=;
        b=a/2InhRGy0PD64BGqYhHi4mhPjTYAfMxIyBAwnqQG9/oH/29yQUpQKxxXG2NOl9Olz
         x10YmQHyM1tllFLMTVJYIwE2n/a158NbeopS8iXWBuU5BE9xopEVO39QZxfnjtBMPO1t
         f613SYmlkMEyLGp8U7jb2DUzQsoLjX1nKsRncn3z/Api4tHZB08rCR8S1OF+cN38uV6N
         la602J8ZPo245Df5poq+Ur4B1Bnt3sO5fkB+uQLchJVT39fQsuH5iO9iAR9zh83OspeD
         5OeiZb7a88DyDqAhutA1AuZJq2sLNWa3Z3D1VO/WUU8fG9IAZ1PWkaEO+gZfIFuD/ccS
         vydA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764922464; x=1765527264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NzSyLk52oyXBylv+Fjf8LJOfI7vnqUzRhJuVyNT36Pg=;
        b=OI1vcZYz2OOA0TPDEm3OlrbWC9KO1AMyHmQ1h3drIGXDsTClxTKLI8mEfdwC3cwvKS
         PD4JfRHR/ldfJ0skejUvYYFaza2USChmQpmhO5gZTGULy0f8P8Z7VwZHRAWD8OUKKmgP
         /luRp3Emu0X3iEdM3JLX3X4TcTDRB56JBmeRqcm8nKIRt1FtttgayaNKHyZfqGyku7U7
         Hw4x9CHcfuUOT+X5mz3FHsNmwdyrwpLq7gXVlGXx38xsemUTioM2Br++jP+IhGdZbpxj
         MuZ1KnjKik5MMxLzyy6QQjfOpougvMxl1apzLICJmhLHUYLhAUS1uXLnzDS9LkxwDd5l
         y2XQ==
X-Gm-Message-State: AOJu0Yzk1F/Jppw7lroyoTP8v2NU9mTDj7LrRg23Flun65nAnroNsqoG
	86NeWzwgo4RDNnBxMCZdRJ8TLxKzS4Q88oM/IdUi2nwSzCTAK/SQqXrgfG8aIKBvgrH0BE9Aq6P
	AEUsaCLDqTvhOyPvHM57QfWbDLCjErynsRCupVD07e43/m3CrpAlVAb7iUECOew==
X-Gm-Gg: ASbGnctH1cXBLJYszQ+A+MPqQgge8cJReRE/bLrYDaPvamdZ7Sw7rHJV4dY/MUZpQhD
	pHcGqitgm0D74Bb/0dSjymjxgMWPamPZzukLWW1VYRbnat3w8zwihWR/S48/DtIMGEkquUoOmhg
	6l6RFEZgDP3J6NrsTF5vjMMaIHS4h+zNi8ahNAhAR2NT2kNJBDmwBoDearzTPzN5CYgS/E9qrFC
	w0yWAtYtl+qf1TpLQ53Yn0h+9crF2BmwKbJaX609Bq6jaKwVD1g1woFNC7Jvfo8RDWZGTFPfcMw
	9ghhJTDL+xLIzUzoluWz99se+9GpeQ==
X-Google-Smtp-Source: AGHT+IHCjKcGZWGXigANEDO/j7hYJ+dY/hKXM2djza5XY7QR0i+faO3ee/MJ+fGuo6qNkiynF/9/d2K5Tv7YqCvfltM=
X-Received: by 2002:a05:6000:2310:b0:42b:4177:7136 with SMTP id
 ffacd0b85a97d-42f79853543mr7176336f8f.32.1764922463641; Fri, 05 Dec 2025
 00:14:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251205080228.4055341-1-chengkev@google.com> <20251205080228.4055341-3-chengkev@google.com>
In-Reply-To: <20251205080228.4055341-3-chengkev@google.com>
From: Kevin Cheng <chengkev@google.com>
Date: Fri, 5 Dec 2025 03:14:12 -0500
X-Gm-Features: AQt7F2pR80thOdu2GxtYyNnzwjoJPU8ouQgO21EpMEETPslHlw3Y9IZdsQDNQS8
Message-ID: <CAE6NW_afho9MzKEGWS-jXKvHepz6kzaj-F4bmTKpdJjHE3xX+A@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86/svm: Add unsupported instruction
 intercept test
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry please ignore this!

On Fri, Dec 5, 2025 at 3:02=E2=80=AFAM Kevin Cheng <chengkev@google.com> wr=
ote:
>
> Add tests that expect a nested vm exit, due to an unsupported
> instruction, to be handled by L0 even if L1 intercepts are set for that
> instruction.
>
> The new test exercises bug fixed by:
> https://lore.kernel.org/all/20251205070630.4013452-1-chengkev@google.com/
>
> Signed-off-by: Kevin Cheng <chengkev@google.com>
> ---
>  x86/svm.h         |  5 +++-
>  x86/svm_tests.c   | 75 +++++++++++++++++++++++++++++++++++++++++++++++
>  x86/unittests.cfg |  9 +++++-
>  3 files changed, 87 insertions(+), 2 deletions(-)
>
> diff --git a/x86/svm.h b/x86/svm.h
> index 93ef6f772c6ee..86d58c3100275 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -406,7 +406,10 @@ struct __attribute__ ((__packed__)) vmcb {
>  #define SVM_EXIT_MONITOR       0x08a
>  #define SVM_EXIT_MWAIT         0x08b
>  #define SVM_EXIT_MWAIT_COND    0x08c
> -#define SVM_EXIT_NPF           0x400
> +#define SVM_EXIT_XSETBV                0x08d
> +#define SVM_EXIT_RDPRU         0x08e
> +#define SVM_EXIT_INVPCID       0x0a2
> +#define SVM_EXIT_NPF           0x400
>
>  #define SVM_EXIT_ERR           -1
>
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index ccc89d45d4db9..cea8865787545 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -3572,6 +3572,80 @@ static void svm_shutdown_intercept_test(void)
>         report(vmcb->control.exit_code =3D=3D SVM_EXIT_SHUTDOWN, "shutdow=
n test passed");
>  }
>
> +struct InvpcidDesc {
> +       uint64_t pcid : 12;
> +       uint64_t reserved : 52;
> +       uint64_t addr;
> +};
> +
> +static void insn_invpcid(struct svm_test *test)
> +{
> +       struct InvpcidDesc desc =3D {0};
> +       unsigned long type =3D 0;
> +
> +       __asm__ volatile (
> +               "invpcid %1, %0"
> +               :
> +               : "r" (type), "m" (desc)
> +               : "memory"
> +       );
> +}
> +
> +asm(
> +       "insn_rdtscp: rdtscp;ret\n\t"
> +       "insn_skinit: skinit;ret\n\t"
> +       "insn_xsetbv: xor %eax, %eax; xor %edx, %edx; xor %ecx, %ecx; xse=
tbv;ret\n\t"
> +       "insn_rdpru: xor %ecx, %ecx; rdpru;ret\n\t"
> +);
> +
> +extern void insn_rdtscp(struct svm_test *test);
> +extern void insn_skinit(struct svm_test *test);
> +extern void insn_xsetbv(struct svm_test *test);
> +extern void insn_rdpru(struct svm_test *test);
> +
> +struct insn_table {
> +       const char *name;
> +       u64 intercept;
> +       void (*insn_func)(struct svm_test *test);
> +       u32 reason;
> +};
> +
> +static struct insn_table insn_table[] =3D {
> +       { "RDTSCP", INTERCEPT_RDTSCP, insn_rdtscp, SVM_EXIT_RDTSCP},
> +       { "SKINIT", INTERCEPT_SKINIT, insn_skinit, SVM_EXIT_SKINIT},
> +       { "XSETBV", INTERCEPT_XSETBV, insn_xsetbv, SVM_EXIT_XSETBV},
> +       { "RDPRU", INTERCEPT_RDPRU, insn_rdpru, SVM_EXIT_RDPRU},
> +       { "INVPCID", INTERCEPT_INVPCID, insn_invpcid, SVM_EXIT_INVPCID},
> +       { NULL },
> +};
> +
> +/*
> + * Test that L1 does not intercept instructions that are not advertised =
in
> + * guest CPUID.
> + */
> +static void svm_unsupported_instruction_intercept_test(void)
> +{
> +       u32 cur_insn;
> +       u32 exit_code;
> +
> +       vmcb_set_intercept(INTERCEPT_EXCEPTION_OFFSET + UD_VECTOR);
> +
> +       for (cur_insn =3D 0; insn_table[cur_insn].name !=3D NULL; ++cur_i=
nsn) {
> +               test_set_guest(insn_table[cur_insn].insn_func);
> +               vmcb_set_intercept(insn_table[cur_insn].intercept);
> +               svm_vmrun();
> +               exit_code =3D vmcb->control.exit_code;
> +
> +               if (exit_code =3D=3D SVM_EXIT_EXCP_BASE + UD_VECTOR)
> +                       report_pass("UD Exception injected");
> +               else if (exit_code =3D=3D insn_table[cur_insn].reason)
> +                       report_fail("L1 should not intercept %s when inst=
ruction is not advertised in guest CPUID",
> +                                   insn_table[cur_insn].name);
> +               else
> +                       report_fail("Unknown exit reason, 0x%x", exit_cod=
e);
> +       }
> +}
> +
>  struct svm_test svm_tests[] =3D {
>         { "null", default_supported, default_prepare,
>           default_prepare_gif_clear, null_test,
> @@ -3713,6 +3787,7 @@ struct svm_test svm_tests[] =3D {
>         TEST(svm_tsc_scale_test),
>         TEST(pause_filter_test),
>         TEST(svm_shutdown_intercept_test),
> +       TEST(svm_unsupported_instruction_intercept_test),
>         { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
>  };
>
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 522318d32bf68..ec456d779b35c 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -253,11 +253,18 @@ arch =3D x86_64
>  [svm]
>  file =3D svm.flat
>  smp =3D 2
> -test_args =3D "-pause_filter_test"
> +test_args =3D "-pause_filter_test -svm_unsupported_instruction_intercept=
_test"
>  qemu_params =3D -cpu max,+svm -m 4g
>  arch =3D x86_64
>  groups =3D svm
>
> +[svm_unsupported_instruction_intercept_test]
> +file =3D svm.flat
> +test_args =3D "svm_unsupported_instruction_intercept_test"
> +qemu_params =3D -cpu max,+svm,-rdtscp,-xsave,-invpcid
> +arch =3D x86_64
> +groups =3D svm
> +
>  [svm_pause_filter]
>  file =3D svm.flat
>  test_args =3D pause_filter_test
> --
> 2.52.0.223.gf5cc29aaa4-goog
>

