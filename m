Return-Path: <kvm+bounces-65524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id BCC49CAEA1C
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 02:34:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3773A3012EE0
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 01:34:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A75D62FE05B;
	Tue,  9 Dec 2025 01:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b6YC74pL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE092F6909
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 01:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765244080; cv=none; b=Ykk3ajio2gauhQay/IE3PwxqDSSj6B/wkCI/S4jEQB60JjRhNZ3KJrzfWuSGeMbKHDYaXsp3Y6cacIzgwh5i2l2GVrnvhDsyDBOjt8QZ4WXBYngdsaZ7TUQVtTN88OdvMP8y+Jv9IzDj0uqIAMAIodknk1O/VTGyqPhaBnCWqIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765244080; c=relaxed/simple;
	bh=Jr4xd6vxTra+2D4ihKldvhRemopiEEj1gA2UEqKxA+0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VTpEQJ8J4VsNCfrFnvp9KgxpXVmAZ2d82MjlSNmhxbE1qaj7wi8plQKotMQ6Pqs76ixzM1LQD0e9m275F8z+nzTFhsrOJ+2hWvflsR/tf5KIAGfvD7duQEoYecu9YS8iwYXn0mTT5Vfkdn7qaSpDhygAntwmpaovmISSgLQQNmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b6YC74pL; arc=none smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-5e55bd6f5bbso451883137.0
        for <kvm@vger.kernel.org>; Mon, 08 Dec 2025 17:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765244078; x=1765848878; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ohtTORJZXPkEpJ8mzg4TFtgbJz9CY3tidmFprVbSxnw=;
        b=b6YC74pLEi/kRnYIZs8rBwi0pXO6P+ZuXjpL99xbQFVL05oldU9wpyJO2qdqRp7ZwN
         GJEy3D9rShzcCuq2Y0BwPPsIcq6L8fyaSIXn/EXDOHs/i2yFPkKv/uMXreMEbkKADABN
         NWWjpF9HZi6mhOljLhbeBZpufCfpuwuxCUSBSOOC+cNmOO5x8oZvl0L+Dm/GfS3Kty/u
         ygT745xhXaF2TDVDtqhD2YqznCgr6gqGRmJ2VvnTu/vr18tIHAi7tLoQHkjg0xa3GRL3
         63ktGiSdDmTC8fBYBqd2aD8/s7xblCE5SO3VxK05UEH44sXJxa2ub/zguPvTgeNoid+g
         tpGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765244078; x=1765848878;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ohtTORJZXPkEpJ8mzg4TFtgbJz9CY3tidmFprVbSxnw=;
        b=Nr8KIOOQ2CsnIuoj3PLmCm2nHSOwKFTNikRvh8lJGgMG2KtefpfgKlSgGWq5UcN5Wj
         5QYrdyAO0PvB4YptbPP1F6VbEskqJeSb5HwjsfXAoTTsJ7zEdDHcw0F89YBCtW1G7e0d
         qNALEljIc9s5fzHEXhj/lB4JFPOmWJcmrSEC6SE/WHEG5yK1sMsk+Zdc9Kc0KIsfVrxW
         aqgXdskg5BsdeSx9rBufwNA+6D/jX7mjnfPjwZ7TO9NvM6KuP77wn+ciGr/XbzfX4n5X
         2DxYr0kaoR5dWTA3rnjXvlMonfDCFTYiWuj9HIMhLcf2FMVBsiB6XytREr44hfNCMKzf
         i+Fw==
X-Gm-Message-State: AOJu0Yw0pvkJX+GtWndSjWsHvTvwhLeCCA+CZ6GnPybdmjDsJsKil2B2
	NVdfJtAwu5cWAmT2R8XYmFWtJ5SR3Nu4FHHPyP7hLw0ia1YPJScEqxXAnPfqSZwQOUuxJgNR5dO
	iBSBW/ixeRvA7j6ArfCvXNSfhFw74XkZPuVTCXDPD
X-Gm-Gg: ASbGnctQbs8pjNkvEoG9wXuRlWdINAhLJjTTFEOMw5NGYEAFiDOjMBX0SIAA5CHkt4T
	wPSPepx9u6xmbmTuhX1j5SL9K081jVzRktEnjZXQos7C1OI1Oe4xtOdXgD444NW4ZSm+F3IL6Kc
	8fdbyj1jwtLsAtWgGz5bwO6W94ZZIyMfFFUJQkQ0OKyIttdQ0lmpQB+iD9ftZ+HYqpZv8p8PD86
	c2ClMDC6ya5imMwCaKB73tpWg9i5tfREDfgOaz5rchgqnuc6ZlGrJYBvcwvgQut0c05Fw==
X-Google-Smtp-Source: AGHT+IF6sjE/JjXvhn5X51jTZr9/Gmhnl82XWN08n6TP0d9HArHBaAFRVWyel0bOQWry80a/+lFD/BItSCZMzr8nBrA=
X-Received: by 2002:a05:6102:4420:b0:5db:cec7:810b with SMTP id
 ada2fe7eead31-5e52cc20a03mr3209749137.29.1765244077812; Mon, 08 Dec 2025
 17:34:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251205081448.4062096-1-chengkev@google.com> <20251205081448.4062096-3-chengkev@google.com>
In-Reply-To: <20251205081448.4062096-3-chengkev@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 8 Dec 2025 17:34:01 -0800
X-Gm-Features: AQt7F2oqIlcHjVdbAW6BbFZdnW5E8D0CXRqb47bCMdt_NanYUQxr-uLsfVgu6Hk
Message-ID: <CAJD7tkbiATfUizn8T2+b3=K8KswMWgg3iEvpE6HfHBsCtJmB8A@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] x86/svm: Add unsupported instruction
 intercept test
To: Kevin Cheng <chengkev@google.com>
Cc: kvm@vger.kernel.org, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 5, 2025 at 12:14=E2=80=AFAM Kevin Cheng <chengkev@google.com> w=
rote:
>
> Add tests that expect a nested vm exit, due to an unsupported
> instruction, to be handled by L0 even if L1 intercepts are set for that
> instruction.
>
> The new test exercises bug fixed by:
> https://lore.kernel.org/all/20251205070630.4013452-1-chengkev@google.com/
>
> Signed-off-by: Kevin Cheng <chengkev@google.com>
[..]
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

Can we use invpcid_safe() and the descriptor already defined in processor.h=
?

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

Does this cover all 5 instructions being tested?

> +arch =3D x86_64
> +groups =3D svm
> +
>  [svm_pause_filter]
>  file =3D svm.flat
>  test_args =3D pause_filter_test
> --
> 2.52.0.223.gf5cc29aaa4-goog
>

