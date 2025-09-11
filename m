Return-Path: <kvm+bounces-57357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A5EBB53C1E
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 21:08:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5774B1BC0D56
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 19:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11314254B09;
	Thu, 11 Sep 2025 19:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jd3iS14Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5871FDDC3
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 19:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757617689; cv=none; b=VPbA1yQZULbMcruHbzcboBPhu+P16skwPpD+2rHtsyQiuTBbwH5KOkwtFETKLcOMwHktHm+b2fTbHFx8u18wriFPIamci4/t2clovg1baKXYb/NE4FmlMiQ/wc+whXSc/f9iRhccNq7J8yktr2Hlv/QTx3J0tlrktE+TWvUacXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757617689; c=relaxed/simple;
	bh=Wfj7lIjq3pNfZzFb/P8I2vIpixtvnnEGS+22MfzTLZc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SUG1xpVlWGAY5NlwHAdojRjKpSXPscIYwP6cay0ph3o+ciZEwA2+1/pGBkxb7heLbOdUQ5Rvgupskoxign4gO2ia2dZ30DwUeUqWU6kRllHEZ0rz40kboygqRwSqywT1qTvbCc5L4WTonpQoK1EpXJ3FU+CJQgvdXTTiL0ywVIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jd3iS14Z; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45decc9e83dso6615425e9.0
        for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 12:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757617685; x=1758222485; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aBmqXna/mSQXiT5+4xCTGt+Go4z3IoGusjQXw1U0C3M=;
        b=jd3iS14Zx1t611h7gMZsAoiqUTkW2C/JpytY4GRJeM7q4JnDZawwBBwDGhBRut1wla
         03sufC2UwiTEQc1i3bCHsp+Nx6KQpBp+W9b6kUacqDzlfAV427+dAt2aqdb63ewb6ydN
         xSPZNNhl/l0DwSTieINsyh6Y2F351/x7Nkf2NKz3BI2eSOoFc4ReBmjxBqVZdWDEXRB9
         2x6Ju6zqdyl0whCTjgBfsOoX+rEtaHB/DvVYm/kthu6uD4cdgjom5vHuyr7ea/MoVrMG
         ePBcaNhDp+a5DaS+fjnTRk4swQCXPiskgR/Fko4vV6c2WsGUlprRB8yHozsmd1TOA8Do
         0QmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757617685; x=1758222485;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aBmqXna/mSQXiT5+4xCTGt+Go4z3IoGusjQXw1U0C3M=;
        b=MiGxxeTsAWqEL6PZOnpBm/+OMmMFdzUalN3Ty2/7Dh+DYXAXuPTzzn4bi0rVMa4vlq
         T9o+pLvwwuiE0Y6Ss4EKajyYtWXNbX5+7Cr0VUn7bdJNwHrJIUxRqnJqgmuCKfy/ZD8y
         tZauHOtA41dxoTXHoJm8WTup02mxoZGMBC/fSA4KUqyYgwm9FmCwmk0H8R7gkduHqee3
         ShwBczU2WfsiL0bOn3YEz7p2/hiicEzjbKOZRnU++8YSrayKUkSRBHski8reI7yuH5sc
         b2sHfo94b4Mi+r48sNhztwYzBwwelZUx65hVRcmRrpEDoiSUxEUQzk0lyVyVSv4kipOB
         g8uw==
X-Gm-Message-State: AOJu0YxbXmD/JRu4B0NWMP48w+NrvJfZaT8m7Xuswa+0ZulQ80V++79n
	BF2Ojuhsm7d9EYer9W82fVXBVwTxbaR3Ar4rLgsw+trZCFSbAVYXLOws53pgQHwEC8EvLiU2YR2
	Lkbk0jC4c+xSNoffSDdoMDnr7uz8Ao9m4bmUaSYAclUkjjMksOnKbvojOcOo=
X-Gm-Gg: ASbGncupBS18TlAhVtQWvE9Y1zzfI5MmXjCK51xdexecBt0s7S2WVGZsykq7mM9wTGs
	pRLRfY3twPN2j8XQw2lGO1N2dpMBFzTE8EJCE4f0M2ipKtigJpfGiiUmjN3Pz3uPJelxLOLBc+H
	sauC15hdbPXCIfSBn1vWzUqYSwzZTE6N5lM7dBkzvZY1b084NyMRnkHnT80Vz1oGkg549Yf4Wxq
	/vjjIYpG3iefOpLSW5KkhvONO/Y3/eHBMFk0aHANscz9DEo
X-Google-Smtp-Source: AGHT+IFuROzJeQ33/5dwL/hLrwBPuADqYCZAfqicYRqZo/kj7MwQWCB53f7Kdz1j5uuq24WSf/3TpcZ3A42HWnfCmXo=
X-Received: by 2002:a05:600c:294b:b0:45d:dc66:500c with SMTP id
 5b1f17b1804b1-45f211f2fd4mr3258575e9.19.1757617685067; Thu, 11 Sep 2025
 12:08:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250820162926.3498713-1-chengkev@google.com>
In-Reply-To: <20250820162926.3498713-1-chengkev@google.com>
From: Kevin Cheng <chengkev@google.com>
Date: Thu, 11 Sep 2025 15:07:53 -0400
X-Gm-Features: AS18NWAH1ASWIUWrxNObAWG2CRJWVNBAGEOsSZhEd0iAhPrncutQf_AnJ0PTadI
Message-ID: <CAE6NW_abZ=-GKA7u9sRB36K-t+buL26egTM5N1o8s2vG_-bCCA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nSVM: Add tests for instruction interrupts
To: kvm@vger.kernel.org
Cc: jmattson@google.com, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2025 at 12:29=E2=80=AFPM Kevin Cheng <chengkev@google.com> =
wrote:
>
> The nVMX tests already have coverage for instruction intercepts.
> Add a similar test for nSVM to improve test parity between nSVM and
> nVMX.
>
> Signed-off-by: Kevin Cheng <chengkev@google.com>
> ---
>  x86/svm_tests.c | 120 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 120 insertions(+)
>
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 80d5aeb1..50201683 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -12,6 +12,7 @@
>  #include "util.h"
>  #include "x86/usermode.h"
>  #include "vmalloc.h"
> +#include "pmu.h"
>
>  #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
>
> @@ -2487,6 +2488,124 @@ static void test_dr(void)
>         vmcb->save.dr7 =3D dr_saved;
>  }
>
> +asm(
> +       "insn_sidt: sidt idt_descr;ret\n\t"
> +       "insn_sgdt: sgdt gdt_descr;ret\n\t"
> +       "insn_sldt: sldt %ax;ret\n\t"
> +       "insn_str: str %ax;ret\n\t"
> +       "insn_lidt: lidt idt_descr;ret\n\t"
> +       "insn_lgdt: lgdt gdt_descr;ret\n\t"
> +       "insn_lldt: xor %eax, %eax; lldt %ax;ret\n\t"
> +       "insn_rdpmc: xor %ecx, %ecx; rdpmc;ret\n\t"
> +       "insn_cpuid: mov $10, %eax; cpuid;ret\n\t"
> +       "insn_invd: invd;ret\n\t"
> +       "insn_pause: pause;ret\n\t"
> +       "insn_hlt: hlt;ret\n\t"
> +       "insn_invlpg: invlpg 0x12345678;ret\n\t"
> +       "insn_monitor: xor %eax, %eax; xor %ecx, %ecx; xor %edx, %edx; mo=
nitor;ret\n\t"
> +       "insn_mwait: xor %eax, %eax; xor %ecx, %ecx; mwait;ret\n\t"
> +);
> +
> +extern void insn_sidt(struct svm_test *test);
> +extern void insn_sgdt(struct svm_test *test);
> +extern void insn_sldt(struct svm_test *test);
> +extern void insn_str(struct svm_test *test);
> +extern void insn_lidt(struct svm_test *test);
> +extern void insn_lgdt(struct svm_test *test);
> +extern void insn_lldt(struct svm_test *test);
> +extern void insn_rdpmc(struct svm_test *test);
> +extern void insn_cpuid(struct svm_test *test);
> +extern void insn_invd(struct svm_test *test);
> +extern void insn_pause(struct svm_test *test);
> +extern void insn_hlt(struct svm_test *test);
> +extern void insn_invlpg(struct svm_test *test);
> +extern void insn_monitor(struct svm_test *test);
> +extern void insn_mwait(struct svm_test *test);
> +
> +u32 cur_insn;
> +
> +typedef bool (*supported_fn)(void);
> +
> +static bool this_cpu_has_mwait(void)
> +{
> +       return this_cpu_has(X86_FEATURE_MWAIT);
> +}
> +
> +struct insn_table {
> +       const char *name;
> +       u32 flag;
> +       void (*insn_func)(struct svm_test *test);
> +       u32 reason;
> +       u64 exit_info_1;
> +       u64 exit_info_2;
> +       bool always_traps;
> +       const supported_fn supported_fn;
> +};
> +
> +static struct insn_table insn_table[] =3D {
> +       {"STORE IDTR", INTERCEPT_STORE_IDTR, insn_sidt, SVM_EXIT_IDTR_REA=
D, 0, 0},
> +       {"STORE GDTR", INTERCEPT_STORE_GDTR, insn_sgdt, SVM_EXIT_GDTR_REA=
D, 0, 0},
> +       {"STORE LDTR", INTERCEPT_STORE_LDTR, insn_sldt, SVM_EXIT_LDTR_REA=
D, 0, 0},
> +       {"STORE TR", INTERCEPT_STORE_TR, insn_str, SVM_EXIT_TR_READ, 0, 0=
},
> +       {"LOAD IDTR", INTERCEPT_LOAD_IDTR, insn_lidt, SVM_EXIT_IDTR_WRITE=
, 0, 0},
> +       {"LOAD GDTR", INTERCEPT_LOAD_GDTR, insn_lgdt, SVM_EXIT_GDTR_WRITE=
, 0, 0},
> +       {"LOAD LDTR", INTERCEPT_LOAD_LDTR, insn_lldt, SVM_EXIT_LDTR_WRITE=
, 0, 0},
> +       {"RDPMC", INTERCEPT_RDPMC, insn_rdpmc, SVM_EXIT_RDPMC, 0, 0, fals=
e, this_cpu_has_pmu},
> +       {"CPUID", INTERCEPT_CPUID, insn_cpuid, SVM_EXIT_CPUID, 0, 0, true=
},
> +       {"INVD", INTERCEPT_INVD, insn_invd, SVM_EXIT_INVD, 0, 0, true},
> +       {"PAUSE", INTERCEPT_PAUSE, insn_pause, SVM_EXIT_PAUSE, 0, 0},
> +       {"HLT", INTERCEPT_HLT, insn_hlt, SVM_EXIT_HLT, 0, 0},
> +       {"INVLPG", INTERCEPT_INVLPG, insn_invlpg, SVM_EXIT_INVLPG, 0, 0},
> +       {"MONITOR", INTERCEPT_MONITOR, insn_monitor, SVM_EXIT_MONITOR, 0,=
 0, false, this_cpu_has_mwait},
> +       {"MWAIT", INTERCEPT_MWAIT, insn_mwait, SVM_EXIT_MWAIT, 0, 0, fals=
e, this_cpu_has_mwait},
> +       {NULL},
> +};
> +
> +static void insn_intercept_test(void)
> +{
> +       u32 exit_code;
> +       u64 exit_info_1;
> +       u64 exit_info_2;
> +
> +       for (cur_insn =3D 0; insn_table[cur_insn].name !=3D NULL; ++cur_i=
nsn) {
> +               struct insn_table insn =3D insn_table[cur_insn];
> +
> +               if (insn.supported_fn && !insn.supported_fn()) {
> +                       printf("\tFeature required for %s is not supporte=
d.\n",
> +                              insn_table[cur_insn].name);
> +                       continue;
> +               }
> +
> +               test_set_guest(insn.insn_func);
> +
> +               if (insn.insn_func !=3D insn_hlt && !insn.always_traps)
> +                       report(svm_vmrun() =3D=3D SVM_EXIT_VMMCALL, "exec=
ute %s", insn.name);
> +
> +               vmcb->control.intercept |=3D 1 << insn.flag;
> +
> +               svm_vmrun();
> +
> +               exit_code =3D vmcb->control.exit_code;
> +               exit_info_1 =3D vmcb->control.exit_info_1;
> +               exit_info_2 =3D vmcb->control.exit_info_2;
> +
> +               report(exit_code =3D=3D insn.reason,
> +                       "Expected exit code: 0x%x, received exit code: 0x=
%x",
> +                       exit_code, insn.reason);
> +
> +               if (!exit_info_1)
> +                       report(exit_info_1 =3D=3D insn.exit_info_1,
> +                       "Expected exit_info_1: 0x%lx, received exit_info_=
1: 0x%lx",
> +                       exit_info_1, insn.exit_info_1);
> +               if (!exit_info_2)
> +                       report(exit_info_2 =3D=3D insn.exit_info_2,
> +                       "Expected exit_info_2: 0x%lx, received exit_info_=
2: 0x%lx",
> +                       exit_info_2, insn.exit_info_2);
> +
> +               vmcb->control.intercept &=3D ~(1 << insn.flag);
> +       }
> +}
> +
>  /* TODO: verify if high 32-bits are sign- or zero-extended on bare metal=
 */
>  #define        TEST_BITMAP_ADDR(save_intercept, type, addr, exit_code,  =
       \
>                          msg) {                                         \
> @@ -3564,6 +3683,7 @@ struct svm_test svm_tests[] =3D {
>         TEST(svm_tsc_scale_test),
>         TEST(pause_filter_test),
>         TEST(svm_shutdown_intercept_test),
> +       TEST(insn_intercept_test),
>         { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
>  };
>
> --
> 2.51.0.261.g7ce5a0a67e-goog
>

Just checking in as it's been a couple weeks :) If there is anyone
else who would be better suited to take a look at these please let me
know and I can cc them as well!

