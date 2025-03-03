Return-Path: <kvm+bounces-39924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66A6AA4CCFA
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 21:54:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EB1E3AC522
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 20:54:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76448236A63;
	Mon,  3 Mar 2025 20:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="uOFh884x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD55722DFFA
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 20:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741035220; cv=none; b=Q6cVWqqVZgitBX5M6zRVsvH3f5BowWF7U59IJOCmp3TGzhWBrlqlsWJGS3STBUxcHIeoW6SoS6sUDnezBK/pBA9h0CV5QLKd3gKaL35MhlSNAgBNC8K6gc89bgmqsZg2qwDP+0xbYdIq551zW96t+JO8Yl1+1tRU2QscTG1FNbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741035220; c=relaxed/simple;
	bh=OedX+KmRNsSP5qwD3uo/SOxs71msjzcbVQqNZ/HnSqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mfdp8ByHP3HKP9eU1gBu7OAcmSuuRDFlLjpVtJJE+Y27o8Iq2EyWctMX78L4wO0mzguU3IUHMm24ie9LPJ9gTRjQCRCuQCfMwzwrDEzyg1b6avDazMtYZXtANavkbmx+JhKMYjlHnnMPwQO6yjT1OOgZOswCXWt1Tjqzo4EVwzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=uOFh884x; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22359001f1aso109514855ad.3
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 12:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741035218; x=1741640018; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g5AQc/OecpKtLu8kT/3BCu+mfDeh9ylI+xKZIi5ekec=;
        b=uOFh884x43VjW66KHj/ZZO5DIK3e9SL2nYv+FKMa5847kN/GmXmVs+PWlp1QTxfN/G
         KmTY50SsLJmBQbrY73DGWjOKO8Ul+s6xPnd+GOYModSBV5WBm2Kz4WrtgYecaYBOZIoi
         Oq7YfJTCnMZYTRvbxcsGE2WBg0EIkP1mPaGanRCHWLotjO9sZugcDrXTFNZ6tMUbj3cm
         1avLGpHp5VA7h/Zikm2Zn6Mc2+2khEKH5Q5zqMIGldD4oaVmA/+jwxqRTdlVnhAbfWDI
         BDRlZvsLuLuX8gJPxGLZv8ksiIDcSmt4k5Q/jg0nCuHowlOZ6QncZgcoGRhKWC+zvvO0
         JYFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741035218; x=1741640018;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g5AQc/OecpKtLu8kT/3BCu+mfDeh9ylI+xKZIi5ekec=;
        b=E3vTyc02M4Lvg/8D9wGQrRhE1L1bz3hwp/gdMpexSLGGvm0MGbgdxxGhLmsgg285R1
         DH0eNPKv9YdDGwU/9VYE5poEnEc2Da3JCb/9Zh+hqSj6cWiEIx3w51Vb5FHJPxiPhhJB
         dGyo5qch+0bFc/j9GGULmJh7OksNgodgaA0HczaEGjH6DcpDdg+nujC24zFwpfz4KVUU
         5CllsqQYpgde9V/meMTkX/0214xaBIxXIOcaIWTGWq+bOapM3itoHbvM2u/V2epca502
         27i1ESzrvxrrIKqopdHr6I1B+/adtsEW51jqd6uY9lHilL5AnaMyj9ikuzAHxRuHWxBm
         yxkA==
X-Forwarded-Encrypted: i=1; AJvYcCWU50MHGzz7MZwc+VQAMed6opqgmgVrbXIjZPagftlbxGDMTSEgvAK3S4Vx4OjJbUxbtOs=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywd1E0NVDSZfINVEvxvhdYgx2EcV4HrKwEyN3RNz66pOO9F6w7M
	rQEdKD4+25SWEs+94uN2Rg4I94pwXvW+rnrPp+izawwIs2wFcvDYCrN06/rLILJHHVKvyIzU+Ug
	Egl1IL4LOteI4kpt9Hsa6824phDyOiIIHrzinKA==
X-Gm-Gg: ASbGncvgRnp5J0prds6NABKDZtMYLuMf3P8Ji7SSPkRHN4VgFQk2o33Tjmlj86o0k32
	7J0dTxv1CQyr85lQhiy/jPTmEt9iS13L89kabe1SF3AiGTb8Ug6wG8pZtgwMR/2TOtZMz74plKx
	97ZIreMuj5o551PuvMpZ2D0mqs
X-Google-Smtp-Source: AGHT+IFxmaYGsqxuWzE42pNki0QyERt8aeeJIc4FpkFS3fZJz6bTIl+8F5KKzfYsUutrBaR5UQYgO+HCr+aSIeXuR/8=
X-Received: by 2002:a17:902:ec82:b0:21f:89e5:2712 with SMTP id
 d9443c01a7336-22369247861mr199207785ad.39.1741035217946; Mon, 03 Mar 2025
 12:53:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250226-kvm_pmu_improve-v1-0-74c058c2bf6d@rivosinc.com>
 <20250226-kvm_pmu_improve-v1-3-74c058c2bf6d@rivosinc.com> <20250227-eb9e3d8de1de2ff609ac8f64@orel>
In-Reply-To: <20250227-eb9e3d8de1de2ff609ac8f64@orel>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Mon, 3 Mar 2025 12:53:27 -0800
X-Gm-Features: AQ5f1Jrqg0QCQLdb27_ngzuhj87U0gO9gK8_pEhgxfLHs93uJVPCudYkbQ6uAvs
Message-ID: <CAHBxVyF=gteGvQqbCAy88heLzfAWebuUH2PXud=zvMjmxsE0YA@mail.gmail.com>
Subject: Re: [PATCH 3/4] KVM: riscv: selftests: Change command line option
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 27, 2025 at 12:08=E2=80=AFAM Andrew Jones <ajones@ventanamicro.=
com> wrote:
>
> On Wed, Feb 26, 2025 at 12:25:05PM -0800, Atish Patra wrote:
> > The PMU test commandline option takes an argument to disable a
> > certain test. The initial assumption behind this was a common use case
> > is just to run all the test most of the time. However, running a single
> > test seems more useful instead. Especially, the overflow test has been
> > helpful to validate PMU virtualizaiton interrupt changes.
> >
> > Switching the command line option to run a single test instead
> > of disabling a single test also allows to provide additional
> > test specific arguments to the test. The default without any options
> > remains unchanged which continues to run all the tests.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  tools/testing/selftests/kvm/riscv/sbi_pmu_test.c | 40 +++++++++++++++-=
--------
> >  1 file changed, 26 insertions(+), 14 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/t=
esting/selftests/kvm/riscv/sbi_pmu_test.c
> > index 284bc80193bd..533b76d0de82 100644
> > --- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> > +++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> > @@ -39,7 +39,11 @@ static bool illegal_handler_invoked;
> >  #define SBI_PMU_TEST_SNAPSHOT        BIT(2)
> >  #define SBI_PMU_TEST_OVERFLOW        BIT(3)
> >
> > -static int disabled_tests;
> > +struct test_args {
> > +     int disabled_tests;
> > +};
> > +
> > +static struct test_args targs;
> >
> >  unsigned long pmu_csr_read_num(int csr_num)
> >  {
> > @@ -604,7 +608,11 @@ static void test_vm_events_overflow(void *guest_co=
de)
> >       vcpu_init_vector_tables(vcpu);
> >       /* Initialize guest timer frequency. */
> >       timer_freq =3D vcpu_get_reg(vcpu, RISCV_TIMER_REG(frequency));
> > +
> > +     /* Export the shared variables to the guest */
> >       sync_global_to_guest(vm, timer_freq);
> > +     sync_global_to_guest(vm, vcpu_shared_irq_count);
> > +     sync_global_to_guest(vm, targs);
> >
> >       run_vcpu(vcpu);
> >
> > @@ -613,28 +621,30 @@ static void test_vm_events_overflow(void *guest_c=
ode)
> >
> >  static void test_print_help(char *name)
> >  {
> > -     pr_info("Usage: %s [-h] [-d <test name>]\n", name);
> > -     pr_info("\t-d: Test to disable. Available tests are 'basic', 'eve=
nts', 'snapshot', 'overflow'\n");
> > +     pr_info("Usage: %s [-h] [-t <test name>]\n", name);
> > +     pr_info("\t-t: Test to run (default all). Available tests are 'ba=
sic', 'events', 'snapshot', 'overflow'\n");
>
> It's probably fine to drop '-d', since we don't make any claims about
> support, but doing so does risk breaking some CI somewhere. If that
> potential breakage is a concern, then we could keep '-d', since nothing
> stops us from having both.

I don't think we have so much legacy usage with this test that we need
to maintain both options.
Since this was merged only a few cycles ago, I assume that it's not
available in many CI to cause breakage.
If somebody running CI actually shouts that it breaks their setup,
sure. Otherwise, I feel it will be just confusing to the users.

>
> >       pr_info("\t-h: print this help screen\n");
> >  }
> >
> >  static bool parse_args(int argc, char *argv[])
> >  {
> >       int opt;
> > -
> > -     while ((opt =3D getopt(argc, argv, "hd:")) !=3D -1) {
> > +     int temp_disabled_tests =3D SBI_PMU_TEST_BASIC | SBI_PMU_TEST_EVE=
NTS | SBI_PMU_TEST_SNAPSHOT |
> > +                               SBI_PMU_TEST_OVERFLOW;
> > +     while ((opt =3D getopt(argc, argv, "h:t:n:")) !=3D -1) {
>
> '-h' doesn't need an argument and '-n' should be introduced with the next
> patch.
>

Yes. Thanks for catching it. I will fix it in v2.

> >               switch (opt) {
> > -             case 'd':
> > +             case 't':
> >                       if (!strncmp("basic", optarg, 5))
> > -                             disabled_tests |=3D SBI_PMU_TEST_BASIC;
> > +                             temp_disabled_tests &=3D ~SBI_PMU_TEST_BA=
SIC;
> >                       else if (!strncmp("events", optarg, 6))
> > -                             disabled_tests |=3D SBI_PMU_TEST_EVENTS;
> > +                             temp_disabled_tests &=3D ~SBI_PMU_TEST_EV=
ENTS;
> >                       else if (!strncmp("snapshot", optarg, 8))
> > -                             disabled_tests |=3D SBI_PMU_TEST_SNAPSHOT=
;
> > +                             temp_disabled_tests &=3D ~SBI_PMU_TEST_SN=
APSHOT;
> >                       else if (!strncmp("overflow", optarg, 8))
> > -                             disabled_tests |=3D SBI_PMU_TEST_OVERFLOW=
;
> > +                             temp_disabled_tests &=3D ~SBI_PMU_TEST_OV=
ERFLOW;
> >                       else
> >                               goto done;
> > +                     targs.disabled_tests =3D temp_disabled_tests;
> >                       break;
> >               case 'h':
> >               default:
> > @@ -650,25 +660,27 @@ static bool parse_args(int argc, char *argv[])
> >
> >  int main(int argc, char *argv[])
> >  {
> > +     targs.disabled_tests =3D 0;
> > +
> >       if (!parse_args(argc, argv))
> >               exit(KSFT_SKIP);
> >
> > -     if (!(disabled_tests & SBI_PMU_TEST_BASIC)) {
> > +     if (!(targs.disabled_tests & SBI_PMU_TEST_BASIC)) {
> >               test_vm_basic_test(test_pmu_basic_sanity);
> >               pr_info("SBI PMU basic test : PASS\n");
> >       }
> >
> > -     if (!(disabled_tests & SBI_PMU_TEST_EVENTS)) {
> > +     if (!(targs.disabled_tests & SBI_PMU_TEST_EVENTS)) {
> >               test_vm_events_test(test_pmu_events);
> >               pr_info("SBI PMU event verification test : PASS\n");
> >       }
> >
> > -     if (!(disabled_tests & SBI_PMU_TEST_SNAPSHOT)) {
> > +     if (!(targs.disabled_tests & SBI_PMU_TEST_SNAPSHOT)) {
> >               test_vm_events_snapshot_test(test_pmu_events_snaphost);
> >               pr_info("SBI PMU event verification with snapshot test : =
PASS\n");
> >       }
> >
> > -     if (!(disabled_tests & SBI_PMU_TEST_OVERFLOW)) {
> > +     if (!(targs.disabled_tests & SBI_PMU_TEST_OVERFLOW)) {
> >               test_vm_events_overflow(test_pmu_events_overflow);
> >               pr_info("SBI PMU event verification with overflow test : =
PASS\n");
> >       }
> >
> > --
> > 2.43.0
> >
>
> Otherwise,
>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

