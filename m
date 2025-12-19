Return-Path: <kvm+bounces-66425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D6648CD22A8
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 00:01:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 793E730274C5
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 23:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78A0426E6F0;
	Fri, 19 Dec 2025 23:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2cZUHDRg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A274B21D3F2
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 23:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766185281; cv=none; b=R5B2Fjw26bxOx0rZB6vv4gVGp2GbVy3uaVTkEDfUGl5S2WPzY3V3bKgsefowBD3vW2lih14+/IAT26h+z+1ZRDZIdnVEozICn2uraVXYnzStF8U84rYXsgBbE5gQAPm6uojWsnvHZkMkyQUBpw5r/F8QxUtJryJeZSiWYJbxPc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766185281; c=relaxed/simple;
	bh=qr8ZgaibzW27UEYupWkxN4Nu4N9y9fRiDm3HnqOgMJE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XWu9Ayswvc0XZ1xKAImhLB3mhVvR0DNNncM4HNWGYZZISVeSAWf08FXRHngYDm6JQ1EvhUMd7taM2Xo2ovLQOAcQoyMFYO3gvDGT22+tDY/atYYAPRa5TPL0QaM9H5LhjsXaDz8fiIsTc4UPSznB0lGWyLK82yKFJnVpmikZ+70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2cZUHDRg; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-430f9ffd4e8so1606286f8f.0
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766185278; x=1766790078; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fVYgB8pUrEEVmupugnrBRdwBnQgntyJOqB185H0YUbU=;
        b=2cZUHDRgcmjBu22p4Y9klRCAEJg1czauoLrpQspGatX9RWyA1NS49UoIji8iH2s3Ca
         gzT1Snc9gysMcu9Qk0XXKOjqH3wL6AYvQybYK8pxcwKYX76QdXxXQtmes9Cw6E3EE7tT
         tPHqHxHejbhS9UOzdHMJuCAFqMC9ItMJN0N9hFTPlmvBE9BJZ03F64lKq/FePhXgTJa3
         v1Y+yCMK1rP3ow8VutN6RIFMzpIp11ETTqv0k19sow3UKdqKe+dqRtO5SfGzbadPxlr+
         tJT05guiHJJ7lxphj013RPlGn2kaUGe6+NRJRzmm+THrOPtIDiAWZRukwvRGtK3+ZAXQ
         CbAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766185278; x=1766790078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fVYgB8pUrEEVmupugnrBRdwBnQgntyJOqB185H0YUbU=;
        b=aISBixapZFRbVsTC8JPVqADZldUfAdhxPb7Vv8S+zG/z1Y2APutTVq/+bxt6Y6w9Rp
         U1FgDWOZym7F5FaaWq9ZGqVBLcresKMz+2vHtkHkDHVtvfXxvKRsyRInSRD8Ppyv+Im0
         mIQRibRHLObcRjC0TqmZvCnp1Gicl/cGGyPxr9kDLOQI0+7AEDCfpK3PCxGSTzcKrUjn
         OvQb0YZNHI4cHrFMaN8ZrtTSpMvgGeMEU9pNDCA6P0GnDLMvMZdf/tkhEy/ctQ20MyJE
         iPIQDse7bY+EUnibhB/PfR7MQcCQ4DAhJVOlJArgX30SHW8Gc2FxbaqfszcPGNmoqhGS
         VX5g==
X-Gm-Message-State: AOJu0YyotLrTn6tsV4qr/QRV0PPFSm4H5m6Z9GGP8YFym4vQauws4FmK
	jsfZauWRdSSfyeTnsipAOmAZ6WA9yis+W+YnsORwaDcyt1s8yv1zyW1aRCh6vG264nvItSSH0WE
	Jba8W3K0WoqtczVmSGhxL3vtrNVf6JZZ9oM25iXm5OLnWUIPgUkxvcz8DbOs=
X-Gm-Gg: AY/fxX4CkAZhfPkqN3bxVVxb3hg99znnEVIb1s3tuB1meOuDFIGEb85EiRNCqKv7uiY
	YCbfSqemb2PeEJ4ZMQ97XFna9jFwiWekHjfF5rUZENtG3aWGTDOCacHdYeXM7fBHN2S7JGyWulv
	VpcV4AWrJOhSFs3+0tJnOkygfgNRieKh03ny1qjvNfx3GE6DnMl63bumQU/oeh9K3lJzBibTJBQ
	mAmYMxphoU5HflvZkPW34bke29lmX32j/Oh/TbrLMXq4OhvakObWSMZ+OdEgKrmfRqoj4vxptbG
	CSqhEds3aYX2qEeIo5DowJT7qaAk
X-Google-Smtp-Source: AGHT+IHItse+bpFD2x5R/W35CLbX12ZSUAlaVKZBqJwO5XzhP4X6X2whkfHmdFMTgW5YMLy46LXGTvakh15Yt3WiyAM=
X-Received: by 2002:a05:6000:2c0e:b0:431:f5:c36f with SMTP id
 ffacd0b85a97d-432448ca3e8mr10110226f8f.31.1766185273000; Fri, 19 Dec 2025
 15:01:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250820162926.3498713-1-chengkev@google.com>
In-Reply-To: <20250820162926.3498713-1-chengkev@google.com>
From: Kevin Cheng <chengkev@google.com>
Date: Fri, 19 Dec 2025 18:01:01 -0500
X-Gm-Features: AQt7F2rashZFCWV7FS-g10hnNJb3UXZr0IM7QShRlDuQ27pKmS3PVRYvNJXJfO0
Message-ID: <CAE6NW_bdVz4SZk3ovoCnsSftA6Ar-JBrtaXwU7snHFr4dXd+qw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nSVM: Add tests for instruction interrupts
To: kvm@vger.kernel.org
Cc: jmattson@google.com, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This patch has been superseded by a new series:
https://lore.kernel.org/all/20251219225908.334766-1-chengkev@google.com/

Please disregard this standalone version.

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

