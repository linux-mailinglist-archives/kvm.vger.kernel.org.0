Return-Path: <kvm+bounces-65335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F05ABCA6BB9
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 09:40:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 10F4130BEA44
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 08:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDACB3191D0;
	Fri,  5 Dec 2025 08:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CaZsJjv4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA9030C61F
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 08:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764922475; cv=none; b=mCFYPK6UNsWVtJqz7va+kSce1iV9/drBkVEKxuJLYwaiiU4Ii33V7u/gV4BeUz1GqWw5RvErNEVWXvKDeqeA4RfgwBDgyH5T3CPuLKYsRDbomwTbXqVVLsgiaQ89FbosjHwluOiW6ltT/6+AkWgeddSGE75SuH9+QWJRWqkoxjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764922475; c=relaxed/simple;
	bh=VazsC93Og5gAcdES7x72XUcA8T57AywDWnl2TKilaLQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YzZYKxDJwux0+ueNWLWai2Ml6UuDD+cOfUSLO8A3zOgVCDa3/97XoByTyitt2ETlWF7JS7n39CKoWLYchmiVZApr7xFb9GFGK/Ah5kRa8FQG+2fNYB9uhtPhkf19aQLK/Ev9yqZLYNRXx7+Ed71b5PzN9H20AYRL2wqhmN0/fwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CaZsJjv4; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-42e2e47be25so963806f8f.2
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 00:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764922459; x=1765527259; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cyOvFqw7JOfPSlCB0B3u5JOvr9SxTrR2zlTVdH8YRQA=;
        b=CaZsJjv4MtGe/+1n4HjvDJRWIU+JJ/iomsPrE9ycGVZmjhLjQYDzOkN3uvxLj0LWla
         S/l2HW/7Fk9EpmdSBSH9q7IZ9mBcxGHMMjZxHVtehLMG6pWZ0JjKzHCCJ9NlZKcm332f
         1x+63dG16KktcKablfYU/NcsSB4693xwEiOHW7j9JvIkoAcbwcOypkHqRXj2iT/2pcsV
         TkF4T+xvQ8d5CxVZdfcG6N5hO/dcfzM8aWkfyEj3gAQNqsHi4lUF3hZvFJfRAtKHm6xX
         lzmXjTGXJ/de2DfqE42Sq09+XgKnfjKA0AJSXQ2NfRan0YzfLmbu7lwRCwJ1uH8eTfnc
         FSJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764922459; x=1765527259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cyOvFqw7JOfPSlCB0B3u5JOvr9SxTrR2zlTVdH8YRQA=;
        b=Zbev53QC94ES4fNGOsfeqw4E8Zw+fGpnw7nq/0XVRUWKUPUe9kJ4OSzCRnEeLU99BP
         MoEqU/WwqJXcNxs0wx/Y9UTK5qZihs1jvN/wlNZhYxM8xnFsVzxjpHdkHg6CfV9XlD4G
         mPWJrIjJSBvAdLrqoQzZ+mwXUGhXmn8/PfPjVDhyT/QPsGnCtUWuQLZ0+Bv0ju+X316x
         I9dHwEWCh8R86jHNGmzw4fcIc0wv/hhYjDko31VGstBAtgFg0OtcjWUgRiCEhusMZUDf
         qTwFUb/pyx9vN1MnBocVII/KtiNygbMOxOWOSz3u+fo/TqtBfdiWjad0nVmUm806RlA7
         hivQ==
X-Gm-Message-State: AOJu0YytMhzSb8BlSgWb1H/9yegp8OSUFsehLWoQvj+6/IEwG7HvjUR+
	JvQRSZJl+VRl48rwCDUiyTzmbvTNzMjUuFRRSS2fBASQ6f2X91CALNMfJiKNArhHgy33aK7/5hW
	71gTERpT0TXRHIFcGkxHRahTs6iJCAyQHdbNgz5WSdGgDQFWo5RR2S4u5xLFxmQ==
X-Gm-Gg: ASbGncub3Hs5J7vmJBkRXmgIwYWfbPYiinW9w1pHIPODeXLat7szfbnj7goQhUDNsNK
	/QktjnU3MUdcl0qWKa7fUsHEwIJbuVHXPMDpvbLilFN9R/ZNbScDCzfGLqmbWBX+sCjKZ2oG4ML
	76YR2zc3wPt0zLhDVtwqqrD0485bA24RyvER3H97VIGhgY2Cdk928GB/WtJIddeJeKKPjFrqEcK
	kXf4jx24hz+o2XChPiT1cJKDwqRqjjWn4QefCpr8SZTvlrvzb+l0UxUaSUJFUPhIbwsT4pj7G2a
	mlbssecrLTuerkzQu4wgEFVJLqZyqQ==
X-Google-Smtp-Source: AGHT+IFSc59AjmJqfUH4t20zCi//lqcSXrMWztyk0UFcFF4v3OOWN/OY9eJkLkML8E9pFysqNH6tdu0rKTyMs8eyDEs=
X-Received: by 2002:a05:6000:1a8d:b0:429:c709:7b58 with SMTP id
 ffacd0b85a97d-42f7985c6afmr5521504f8f.50.1764922458610; Fri, 05 Dec 2025
 00:14:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251205080228.4055341-1-chengkev@google.com> <20251205080228.4055341-2-chengkev@google.com>
In-Reply-To: <20251205080228.4055341-2-chengkev@google.com>
From: Kevin Cheng <chengkev@google.com>
Date: Fri, 5 Dec 2025 03:14:07 -0500
X-Gm-Features: AQt7F2o0rQu-dUjmzwPCubhMGtWGbfEUTlCyktlAFpwFAszg6VH7rlYcswIl0sI
Message-ID: <CAE6NW_bWrCJ-FDoJgaFkuULSGXj1eodByCjwS7F93XUH1sUNRQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] x86/svm: Add missing svm intercepts
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry please ignore this!

On Fri, Dec 5, 2025 at 3:02=E2=80=AFAM Kevin Cheng <chengkev@google.com> wr=
ote:
>
> Some intercepts are missing from the KUT svm testing. Add all missing
> intercepts and reorganize the svm intercept definition/setting/clearing.
>
> Signed-off-by: Kevin Cheng <chengkev@google.com>
> ---
>  x86/svm.c       |   6 +--
>  x86/svm.h       |  82 +++++++++++++++++++++++++++++++----
>  x86/svm_tests.c | 111 ++++++++++++++++++++++++------------------------
>  3 files changed, 131 insertions(+), 68 deletions(-)
>
> diff --git a/x86/svm.c b/x86/svm.c
> index de9eb19443caa..9a4c14e368cd4 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -193,9 +193,9 @@ void vmcb_ident(struct vmcb *vmcb)
>         save->cr2 =3D read_cr2();
>         save->g_pat =3D rdmsr(MSR_IA32_CR_PAT);
>         save->dbgctl =3D rdmsr(MSR_IA32_DEBUGCTLMSR);
> -       ctrl->intercept =3D (1ULL << INTERCEPT_VMRUN) |
> -               (1ULL << INTERCEPT_VMMCALL) |
> -               (1ULL << INTERCEPT_SHUTDOWN);
> +       vmcb_set_intercept(INTERCEPT_VMRUN);
> +       vmcb_set_intercept(INTERCEPT_VMMCALL);
> +       vmcb_set_intercept(INTERCEPT_SHUTDOWN);
>         ctrl->iopm_base_pa =3D virt_to_phys(io_bitmap);
>         ctrl->msrpm_base_pa =3D virt_to_phys(msr_bitmap);
>
> diff --git a/x86/svm.h b/x86/svm.h
> index 264583a6547ef..93ef6f772c6ee 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -2,9 +2,49 @@
>  #define X86_SVM_H
>
>  #include "libcflat.h"
> +#include "bitops.h"
> +
> +enum intercept_words {
> +       INTERCEPT_CR =3D 0,
> +       INTERCEPT_DR,
> +       INTERCEPT_EXCEPTION,
> +       INTERCEPT_WORD3,
> +       INTERCEPT_WORD4,
> +       INTERCEPT_WORD5,
> +       MAX_INTERCEPT,
> +};
>
>  enum {
> -       INTERCEPT_INTR,
> +       /* Byte offset 000h (word 0) */
> +       INTERCEPT_CR0_READ =3D 0,
> +       INTERCEPT_CR3_READ =3D 3,
> +       INTERCEPT_CR4_READ =3D 4,
> +       INTERCEPT_CR8_READ =3D 8,
> +       INTERCEPT_CR0_WRITE =3D 16,
> +       INTERCEPT_CR3_WRITE =3D 16 + 3,
> +       INTERCEPT_CR4_WRITE =3D 16 + 4,
> +       INTERCEPT_CR8_WRITE =3D 16 + 8,
> +       /* Byte offset 004h (word 1) */
> +       INTERCEPT_DR0_READ =3D 32,
> +       INTERCEPT_DR1_READ,
> +       INTERCEPT_DR2_READ,
> +       INTERCEPT_DR3_READ,
> +       INTERCEPT_DR4_READ,
> +       INTERCEPT_DR5_READ,
> +       INTERCEPT_DR6_READ,
> +       INTERCEPT_DR7_READ,
> +       INTERCEPT_DR0_WRITE =3D 48,
> +       INTERCEPT_DR1_WRITE,
> +       INTERCEPT_DR2_WRITE,
> +       INTERCEPT_DR3_WRITE,
> +       INTERCEPT_DR4_WRITE,
> +       INTERCEPT_DR5_WRITE,
> +       INTERCEPT_DR6_WRITE,
> +       INTERCEPT_DR7_WRITE,
> +       /* Byte offset 008h (word 2) */
> +       INTERCEPT_EXCEPTION_OFFSET =3D 64,
> +       /* Byte offset 00Ch (word 3) */
> +       INTERCEPT_INTR =3D 96,
>         INTERCEPT_NMI,
>         INTERCEPT_SMI,
>         INTERCEPT_INIT,
> @@ -36,7 +76,8 @@ enum {
>         INTERCEPT_TASK_SWITCH,
>         INTERCEPT_FERR_FREEZE,
>         INTERCEPT_SHUTDOWN,
> -       INTERCEPT_VMRUN,
> +       /* Byte offset 010h (word 4) */
> +       INTERCEPT_VMRUN =3D 128,
>         INTERCEPT_VMMCALL,
>         INTERCEPT_VMLOAD,
>         INTERCEPT_VMSAVE,
> @@ -49,6 +90,24 @@ enum {
>         INTERCEPT_MONITOR,
>         INTERCEPT_MWAIT,
>         INTERCEPT_MWAIT_COND,
> +       INTERCEPT_XSETBV,
> +       INTERCEPT_RDPRU,
> +       TRAP_EFER_WRITE,
> +       TRAP_CR0_WRITE,
> +       TRAP_CR1_WRITE,
> +       TRAP_CR2_WRITE,
> +       TRAP_CR3_WRITE,
> +       TRAP_CR4_WRITE,
> +       TRAP_CR5_WRITE,
> +       TRAP_CR6_WRITE,
> +       TRAP_CR7_WRITE,
> +       TRAP_CR8_WRITE,
> +       /* Byte offset 014h (word 5) */
> +       INTERCEPT_INVLPGB =3D 160,
> +       INTERCEPT_INVLPGB_ILLEGAL,
> +       INTERCEPT_INVPCID,
> +       INTERCEPT_MCOMMIT,
> +       INTERCEPT_TLBSYNC,
>  };
>
>  enum {
> @@ -69,13 +128,8 @@ enum {
>  };
>
>  struct __attribute__ ((__packed__)) vmcb_control_area {
> -       u16 intercept_cr_read;
> -       u16 intercept_cr_write;
> -       u16 intercept_dr_read;
> -       u16 intercept_dr_write;
> -       u32 intercept_exceptions;
> -       u64 intercept;
> -       u8 reserved_1[40];
> +       u32 intercept[MAX_INTERCEPT];
> +       u8 reserved_1[36];
>         u16 pause_filter_thresh;
>         u16 pause_filter_count;
>         u64 iopm_base_pa;
> @@ -441,6 +495,16 @@ void test_set_guest(test_guest_func func);
>
>  extern struct vmcb *vmcb;
>
> +static inline void vmcb_set_intercept(u64 val)
> +{
> +       __set_bit(val, vmcb->control.intercept);
> +}
> +
> +static inline void vmcb_clear_intercept(u64 val)
> +{
> +       __clear_bit(val, vmcb->control.intercept);
> +}
> +
>  static inline void stgi(void)
>  {
>      asm volatile ("stgi");
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 3761647642542..ccc89d45d4db9 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -63,7 +63,7 @@ static bool null_check(struct svm_test *test)
>
>  static void prepare_no_vmrun_int(struct svm_test *test)
>  {
> -       vmcb->control.intercept &=3D ~(1ULL << INTERCEPT_VMRUN);
> +       vmcb_clear_intercept(INTERCEPT_VMRUN);
>  }
>
>  static bool check_no_vmrun_int(struct svm_test *test)
> @@ -84,8 +84,8 @@ static bool check_vmrun(struct svm_test *test)
>  static void prepare_rsm_intercept(struct svm_test *test)
>  {
>         default_prepare(test);
> -       vmcb->control.intercept |=3D 1 << INTERCEPT_RSM;
> -       vmcb->control.intercept_exceptions |=3D (1ULL << UD_VECTOR);
> +       vmcb_set_intercept(INTERCEPT_RSM);
> +       vmcb_set_intercept(INTERCEPT_EXCEPTION_OFFSET + UD_VECTOR);
>  }
>
>  static void test_rsm_intercept(struct svm_test *test)
> @@ -107,7 +107,7 @@ static bool finished_rsm_intercept(struct svm_test *t=
est)
>                                     vmcb->control.exit_code);
>                         return true;
>                 }
> -               vmcb->control.intercept &=3D ~(1 << INTERCEPT_RSM);
> +               vmcb_clear_intercept(INTERCEPT_RSM);
>                 inc_test_stage(test);
>                 break;
>
> @@ -132,7 +132,7 @@ static void prepare_sel_cr0_intercept(struct svm_test=
 *test)
>         /* Clear CR0.MP and CR0.CD as the tests will set either of them *=
/
>         vmcb->save.cr0 &=3D ~X86_CR0_MP;
>         vmcb->save.cr0 &=3D ~X86_CR0_CD;
> -       vmcb->control.intercept |=3D (1ULL << INTERCEPT_SELECTIVE_CR0);
> +       vmcb_set_intercept(INTERCEPT_SELECTIVE_CR0);
>  }
>
>  static void prepare_sel_nonsel_cr0_intercepts(struct svm_test *test)
> @@ -140,8 +140,8 @@ static void prepare_sel_nonsel_cr0_intercepts(struct =
svm_test *test)
>         /* Clear CR0.MP and CR0.CD as the tests will set either of them *=
/
>         vmcb->save.cr0 &=3D ~X86_CR0_MP;
>         vmcb->save.cr0 &=3D ~X86_CR0_CD;
> -       vmcb->control.intercept_cr_write |=3D (1ULL << 0);
> -       vmcb->control.intercept |=3D (1ULL << INTERCEPT_SELECTIVE_CR0);
> +       vmcb_set_intercept(INTERCEPT_CR0_WRITE);
> +       vmcb_set_intercept(INTERCEPT_SELECTIVE_CR0);
>  }
>
>  static void __test_cr0_write_bit(struct svm_test *test, unsigned long bi=
t,
> @@ -218,7 +218,7 @@ static bool check_cr0_nointercept(struct svm_test *te=
st)
>  static void prepare_cr3_intercept(struct svm_test *test)
>  {
>         default_prepare(test);
> -       vmcb->control.intercept_cr_read |=3D 1 << 3;
> +       vmcb_set_intercept(INTERCEPT_CR3_READ);
>  }
>
>  static void test_cr3_intercept(struct svm_test *test)
> @@ -252,7 +252,7 @@ static void corrupt_cr3_intercept_bypass(void *_test)
>  static void prepare_cr3_intercept_bypass(struct svm_test *test)
>  {
>         default_prepare(test);
> -       vmcb->control.intercept_cr_read |=3D 1 << 3;
> +       vmcb_set_intercept(INTERCEPT_CR3_READ);
>         on_cpu_async(1, corrupt_cr3_intercept_bypass, test);
>  }
>
> @@ -272,8 +272,7 @@ static void test_cr3_intercept_bypass(struct svm_test=
 *test)
>  static void prepare_dr_intercept(struct svm_test *test)
>  {
>         default_prepare(test);
> -       vmcb->control.intercept_dr_read =3D 0xff;
> -       vmcb->control.intercept_dr_write =3D 0xff;
> +       vmcb->control.intercept[INTERCEPT_DR] =3D 0xff00ff;
>  }
>
>  static void test_dr_intercept(struct svm_test *test)
> @@ -390,7 +389,7 @@ static bool next_rip_supported(void)
>
>  static void prepare_next_rip(struct svm_test *test)
>  {
> -       vmcb->control.intercept |=3D (1ULL << INTERCEPT_RDTSC);
> +       vmcb_set_intercept(INTERCEPT_RDTSC);
>  }
>
>
> @@ -416,7 +415,7 @@ static bool is_x2apic;
>  static void prepare_msr_intercept(struct svm_test *test)
>  {
>         default_prepare(test);
> -       vmcb->control.intercept |=3D (1ULL << INTERCEPT_MSR_PROT);
> +       vmcb_set_intercept(INTERCEPT_MSR_PROT);
>
>         memset(msr_bitmap, 0, MSR_BITMAP_SIZE);
>
> @@ -663,10 +662,10 @@ static bool check_msr_intercept(struct svm_test *te=
st)
>
>  static void prepare_mode_switch(struct svm_test *test)
>  {
> -       vmcb->control.intercept_exceptions |=3D (1ULL << GP_VECTOR)
> -               |  (1ULL << UD_VECTOR)
> -               |  (1ULL << DF_VECTOR)
> -               |  (1ULL << PF_VECTOR);
> +       vmcb_set_intercept(INTERCEPT_EXCEPTION_OFFSET + GP_VECTOR);
> +       vmcb_set_intercept(INTERCEPT_EXCEPTION_OFFSET + UD_VECTOR);
> +       vmcb_set_intercept(INTERCEPT_EXCEPTION_OFFSET + DF_VECTOR);
> +       vmcb_set_intercept(INTERCEPT_EXCEPTION_OFFSET + DF_VECTOR);
>         test->scratch =3D 0;
>  }
>
> @@ -773,7 +772,7 @@ extern u8 *io_bitmap;
>
>  static void prepare_ioio(struct svm_test *test)
>  {
> -       vmcb->control.intercept |=3D (1ULL << INTERCEPT_IOIO_PROT);
> +       vmcb_set_intercept(INTERCEPT_IOIO_PROT);
>         test->scratch =3D 0;
>         memset(io_bitmap, 0, 8192);
>         io_bitmap[8192] =3D 0xFF;
> @@ -1171,7 +1170,7 @@ static void pending_event_prepare(struct svm_test *=
test)
>
>         pending_event_guest_run =3D false;
>
> -       vmcb->control.intercept |=3D (1ULL << INTERCEPT_INTR);
> +       vmcb_set_intercept(INTERCEPT_INTR);
>         vmcb->control.int_ctl |=3D V_INTR_MASKING_MASK;
>
>         apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
> @@ -1195,7 +1194,7 @@ static bool pending_event_finished(struct svm_test =
*test)
>                         return true;
>                 }
>
> -               vmcb->control.intercept &=3D ~(1ULL << INTERCEPT_INTR);
> +               vmcb_clear_intercept(INTERCEPT_INTR);
>                 vmcb->control.int_ctl &=3D ~V_INTR_MASKING_MASK;
>
>                 if (pending_event_guest_run) {
> @@ -1400,7 +1399,7 @@ static bool interrupt_finished(struct svm_test *tes=
t)
>                 }
>                 vmcb->save.rip +=3D 3;
>
> -               vmcb->control.intercept |=3D (1ULL << INTERCEPT_INTR);
> +               vmcb_set_intercept(INTERCEPT_INTR);
>                 vmcb->control.int_ctl |=3D V_INTR_MASKING_MASK;
>                 break;
>
> @@ -1414,7 +1413,7 @@ static bool interrupt_finished(struct svm_test *tes=
t)
>
>                 sti_nop_cli();
>
> -               vmcb->control.intercept &=3D ~(1ULL << INTERCEPT_INTR);
> +               vmcb_clear_intercept(INTERCEPT_INTR);
>                 vmcb->control.int_ctl &=3D ~V_INTR_MASKING_MASK;
>                 break;
>
> @@ -1476,7 +1475,7 @@ static bool nmi_finished(struct svm_test *test)
>                 }
>                 vmcb->save.rip +=3D 3;
>
> -               vmcb->control.intercept |=3D (1ULL << INTERCEPT_NMI);
> +               vmcb_set_intercept(INTERCEPT_NMI);
>                 break;
>
>         case 1:
> @@ -1569,7 +1568,7 @@ static bool nmi_hlt_finished(struct svm_test *test)
>                 }
>                 vmcb->save.rip +=3D 3;
>
> -               vmcb->control.intercept |=3D (1ULL << INTERCEPT_NMI);
> +               vmcb_set_intercept(INTERCEPT_NMI);
>                 break;
>
>         case 2:
> @@ -1605,7 +1604,7 @@ static void vnmi_prepare(struct svm_test *test)
>          * Disable NMI interception to start.  Enabling vNMI without
>          * intercepting "real" NMIs should result in an ERR VM-Exit.
>          */
> -       vmcb->control.intercept &=3D ~(1ULL << INTERCEPT_NMI);
> +       vmcb_clear_intercept(INTERCEPT_NMI);
>         vmcb->control.int_ctl =3D V_NMI_ENABLE_MASK;
>         vmcb->control.int_vector =3D NMI_VECTOR;
>  }
> @@ -1629,7 +1628,7 @@ static bool vnmi_finished(struct svm_test *test)
>                         return true;
>                 }
>                 report(!nmi_fired, "vNMI enabled but NMI_INTERCEPT unset!=
");
> -               vmcb->control.intercept |=3D (1ULL << INTERCEPT_NMI);
> +               vmcb_set_intercept(INTERCEPT_NMI);
>                 vmcb->save.rip +=3D 3;
>                 break;
>
> @@ -1804,7 +1803,7 @@ static bool virq_inject_finished(struct svm_test *t=
est)
>                         return true;
>                 }
>                 virq_fired =3D false;
> -               vmcb->control.intercept |=3D (1ULL << INTERCEPT_VINTR);
> +               vmcb_set_intercept(INTERCEPT_VINTR);
>                 vmcb->control.int_ctl =3D V_INTR_MASKING_MASK | V_IRQ_MAS=
K |
>                         (0x0f << V_INTR_PRIO_SHIFT);
>                 break;
> @@ -1819,7 +1818,7 @@ static bool virq_inject_finished(struct svm_test *t=
est)
>                         report_fail("V_IRQ fired before SVM_EXIT_VINTR");
>                         return true;
>                 }
> -               vmcb->control.intercept &=3D ~(1ULL << INTERCEPT_VINTR);
> +               vmcb_clear_intercept(INTERCEPT_VINTR);
>                 break;
>
>         case 2:
> @@ -1842,7 +1841,7 @@ static bool virq_inject_finished(struct svm_test *t=
est)
>                                     vmcb->control.exit_code);
>                         return true;
>                 }
> -               vmcb->control.intercept |=3D (1ULL << INTERCEPT_VINTR);
> +               vmcb_set_intercept(INTERCEPT_VINTR);
>                 break;
>
>         case 4:
> @@ -1943,7 +1942,7 @@ static void reg_corruption_prepare(struct svm_test =
*test)
>         set_test_stage(test, 0);
>
>         vmcb->control.int_ctl =3D V_INTR_MASKING_MASK;
> -       vmcb->control.intercept |=3D (1ULL << INTERCEPT_INTR);
> +       vmcb_set_intercept(INTERCEPT_INTR);
>
>         handle_irq(TIMER_VECTOR, reg_corruption_isr);
>
> @@ -2050,7 +2049,7 @@ static volatile bool init_intercept;
>  static void init_intercept_prepare(struct svm_test *test)
>  {
>         init_intercept =3D false;
> -       vmcb->control.intercept |=3D (1ULL << INTERCEPT_INIT);
> +       vmcb_set_intercept(INTERCEPT_INIT);
>  }
>
>  static void init_intercept_test(struct svm_test *test)
> @@ -2547,7 +2546,7 @@ static void test_dr(void)
>  /* TODO: verify if high 32-bits are sign- or zero-extended on bare metal=
 */
>  #define        TEST_BITMAP_ADDR(save_intercept, type, addr, exit_code,  =
       \
>                          msg) {                                         \
> -               vmcb->control.intercept =3D saved_intercept | 1ULL << typ=
e; \
> +               vmcb_set_intercept(type); \
>                 if (type =3D=3D INTERCEPT_MSR_PROT)                      =
   \
>                         vmcb->control.msrpm_base_pa =3D addr;            =
 \
>                 else                                                    \
> @@ -2574,7 +2573,7 @@ static void test_dr(void)
>   */
>  static void test_msrpm_iopm_bitmap_addrs(void)
>  {
> -       u64 saved_intercept =3D vmcb->control.intercept;
> +       u32 saved_intercept =3D vmcb->control.intercept[INTERCEPT_WORD3];
>         u64 addr_beyond_limit =3D 1ull << cpuid_maxphyaddr();
>         u64 addr =3D virt_to_phys(msr_bitmap) & (~((1ull << 12) - 1));
>
> @@ -2615,7 +2614,7 @@ static void test_msrpm_iopm_bitmap_addrs(void)
>         TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT, addr,
>                          SVM_EXIT_VMMCALL, "IOPM");
>
> -       vmcb->control.intercept =3D saved_intercept;
> +       vmcb->control.intercept[INTERCEPT_WORD3] =3D saved_intercept;
>  }
>
>  /*
> @@ -2811,7 +2810,7 @@ static void vmload_vmsave_guest_main(struct svm_tes=
t *test)
>
>  static void svm_vmload_vmsave(void)
>  {
> -       u32 intercept_saved =3D vmcb->control.intercept;
> +       u32 intercept_saved =3D vmcb->control.intercept[INTERCEPT_WORD4];
>
>         test_set_guest(vmload_vmsave_guest_main);
>
> @@ -2819,8 +2818,8 @@ static void svm_vmload_vmsave(void)
>          * Disabling intercept for VMLOAD and VMSAVE doesn't cause
>          * respective #VMEXIT to host
>          */
> -       vmcb->control.intercept &=3D ~(1ULL << INTERCEPT_VMLOAD);
> -       vmcb->control.intercept &=3D ~(1ULL << INTERCEPT_VMSAVE);
> +       vmcb_clear_intercept(INTERCEPT_VMLOAD);
> +       vmcb_clear_intercept(INTERCEPT_VMSAVE);
>         svm_vmrun();
>         report(vmcb->control.exit_code =3D=3D SVM_EXIT_VMMCALL, "Test "
>                "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
> @@ -2829,39 +2828,39 @@ static void svm_vmload_vmsave(void)
>          * Enabling intercept for VMLOAD and VMSAVE causes respective
>          * #VMEXIT to host
>          */
> -       vmcb->control.intercept |=3D (1ULL << INTERCEPT_VMLOAD);
> +       vmcb_set_intercept(INTERCEPT_VMLOAD);
>         svm_vmrun();
>         report(vmcb->control.exit_code =3D=3D SVM_EXIT_VMLOAD, "Test "
>                "VMLOAD/VMSAVE intercept: Expected VMLOAD #VMEXIT");
> -       vmcb->control.intercept &=3D ~(1ULL << INTERCEPT_VMLOAD);
> -       vmcb->control.intercept |=3D (1ULL << INTERCEPT_VMSAVE);
> +       vmcb_clear_intercept(INTERCEPT_VMLOAD);
> +       vmcb_set_intercept(INTERCEPT_VMSAVE);
>         svm_vmrun();
>         report(vmcb->control.exit_code =3D=3D SVM_EXIT_VMSAVE, "Test "
>                "VMLOAD/VMSAVE intercept: Expected VMSAVE #VMEXIT");
> -       vmcb->control.intercept &=3D ~(1ULL << INTERCEPT_VMSAVE);
> +       vmcb_clear_intercept(INTERCEPT_VMSAVE);
>         svm_vmrun();
>         report(vmcb->control.exit_code =3D=3D SVM_EXIT_VMMCALL, "Test "
>                "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
>
> -       vmcb->control.intercept |=3D (1ULL << INTERCEPT_VMLOAD);
> +       vmcb_set_intercept(INTERCEPT_VMLOAD);
>         svm_vmrun();
>         report(vmcb->control.exit_code =3D=3D SVM_EXIT_VMLOAD, "Test "
>                "VMLOAD/VMSAVE intercept: Expected VMLOAD #VMEXIT");
> -       vmcb->control.intercept &=3D ~(1ULL << INTERCEPT_VMLOAD);
> +       vmcb_clear_intercept(INTERCEPT_VMLOAD);
>         svm_vmrun();
>         report(vmcb->control.exit_code =3D=3D SVM_EXIT_VMMCALL, "Test "
>                "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
>
> -       vmcb->control.intercept |=3D (1ULL << INTERCEPT_VMSAVE);
> +       vmcb_set_intercept(INTERCEPT_VMSAVE);
>         svm_vmrun();
>         report(vmcb->control.exit_code =3D=3D SVM_EXIT_VMSAVE, "Test "
>                "VMLOAD/VMSAVE intercept: Expected VMSAVE #VMEXIT");
> -       vmcb->control.intercept &=3D ~(1ULL << INTERCEPT_VMSAVE);
> +       vmcb_clear_intercept(INTERCEPT_VMSAVE);
>         svm_vmrun();
>         report(vmcb->control.exit_code =3D=3D SVM_EXIT_VMMCALL, "Test "
>                "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
>
> -       vmcb->control.intercept =3D intercept_saved;
> +       vmcb->control.intercept[INTERCEPT_WORD4] =3D intercept_saved;
>  }
>
>  static void prepare_vgif_enabled(struct svm_test *test)
> @@ -2974,7 +2973,7 @@ static void pause_filter_test(void)
>                 return;
>         }
>
> -       vmcb->control.intercept |=3D (1 << INTERCEPT_PAUSE);
> +       vmcb_set_intercept(INTERCEPT_PAUSE);
>
>         // filter count more that pause count - no VMexit
>         pause_filter_run_test(10, 9, 0, 0);
> @@ -3356,7 +3355,7 @@ static void svm_intr_intercept_mix_if(void)
>         // make a physical interrupt to be pending
>         handle_irq(0x55, dummy_isr);
>
> -       vmcb->control.intercept |=3D (1 << INTERCEPT_INTR);
> +       vmcb_set_intercept(INTERCEPT_INTR);
>         vmcb->control.int_ctl &=3D ~V_INTR_MASKING_MASK;
>         vmcb->save.rflags &=3D ~X86_EFLAGS_IF;
>
> @@ -3389,7 +3388,7 @@ static void svm_intr_intercept_mix_gif(void)
>  {
>         handle_irq(0x55, dummy_isr);
>
> -       vmcb->control.intercept |=3D (1 << INTERCEPT_INTR);
> +       vmcb_set_intercept(INTERCEPT_INTR);
>         vmcb->control.int_ctl &=3D ~V_INTR_MASKING_MASK;
>         vmcb->save.rflags &=3D ~X86_EFLAGS_IF;
>
> @@ -3419,7 +3418,7 @@ static void svm_intr_intercept_mix_gif2(void)
>  {
>         handle_irq(0x55, dummy_isr);
>
> -       vmcb->control.intercept |=3D (1 << INTERCEPT_INTR);
> +       vmcb_set_intercept(INTERCEPT_INTR);
>         vmcb->control.int_ctl &=3D ~V_INTR_MASKING_MASK;
>         vmcb->save.rflags |=3D X86_EFLAGS_IF;
>
> @@ -3448,7 +3447,7 @@ static void svm_intr_intercept_mix_nmi(void)
>  {
>         handle_exception(2, dummy_nmi_handler);
>
> -       vmcb->control.intercept |=3D (1 << INTERCEPT_NMI);
> +       vmcb_set_intercept(INTERCEPT_NMI);
>         vmcb->control.int_ctl &=3D ~V_INTR_MASKING_MASK;
>         vmcb->save.rflags |=3D X86_EFLAGS_IF;
>
> @@ -3472,7 +3471,7 @@ static void svm_intr_intercept_mix_smi_guest(struct=
 svm_test *test)
>
>  static void svm_intr_intercept_mix_smi(void)
>  {
> -       vmcb->control.intercept |=3D (1 << INTERCEPT_SMI);
> +       vmcb_set_intercept(INTERCEPT_SMI);
>         vmcb->control.int_ctl &=3D ~V_INTR_MASKING_MASK;
>         test_set_guest(svm_intr_intercept_mix_smi_guest);
>         svm_intr_intercept_mix_run_guest(NULL, SVM_EXIT_SMI);
> @@ -3530,14 +3529,14 @@ static void handle_exception_in_l2(u8 vector)
>
>  static void handle_exception_in_l1(u32 vector)
>  {
> -       u32 old_ie =3D vmcb->control.intercept_exceptions;
> +       u32 old_ie =3D vmcb->control.intercept[INTERCEPT_EXCEPTION];
>
> -       vmcb->control.intercept_exceptions |=3D (1ULL << vector);
> +       vmcb_set_intercept(INTERCEPT_EXCEPTION_OFFSET + vector);
>
>         report(svm_vmrun() =3D=3D (SVM_EXIT_EXCP_BASE + vector),
>                 "%s handled by L1",  exception_mnemonic(vector));
>
> -       vmcb->control.intercept_exceptions =3D old_ie;
> +       vmcb->control.intercept[INTERCEPT_EXCEPTION] =3D old_ie;
>  }
>
>  static void svm_exception_test(void)
> @@ -3568,7 +3567,7 @@ static void svm_shutdown_intercept_test(void)
>  {
>         test_set_guest(shutdown_intercept_test_guest);
>         vmcb->save.idtr.base =3D (u64)alloc_vpage();
> -       vmcb->control.intercept |=3D (1ULL << INTERCEPT_SHUTDOWN);
> +       vmcb_set_intercept(INTERCEPT_SHUTDOWN);
>         svm_vmrun();
>         report(vmcb->control.exit_code =3D=3D SVM_EXIT_SHUTDOWN, "shutdow=
n test passed");
>  }
> --
> 2.52.0.223.gf5cc29aaa4-goog
>

