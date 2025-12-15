Return-Path: <kvm+bounces-66036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 79593CBFBF4
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:29:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8067A301FC0A
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE465310764;
	Mon, 15 Dec 2025 20:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dNbR3YSK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470122F0C76
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 20:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765830579; cv=none; b=NHaRJ7P93zNxY6jziHgSMz6mvBpv+ap4FkbpDVo6ZGtxjm81tXnUz+ueuu4XnWenG1kbtIYYxNU6dy4UeFMsQgKAfRgPKjL/lit937BEstv1YCn6lTn4Ru9bxivHprgte+gH1vGJcr0j2Fwyu8GpmGw9rK7yyDMaKg29hoR7bxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765830579; c=relaxed/simple;
	bh=lDqacNha/8JxIuzXVnHM0NxIW2giP9BD+zhfW03pKpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FH7Ww1FrPStQ06qvRR7CUg6/X7FDd1v9hQWGxLXR2apCbfubiO4LeHWLh+YQe3yOcVNOZDfgV0PnftELr53Ytwm5BCpkIRTCfCUJPTn1UEqQrZZsarVmopB0fzuKAwavzhmR6WjZa/msmmZs0wZXl5Xhf7dMGeX7vyC0qX6AXnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dNbR3YSK; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-477632d9326so24142245e9.1
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 12:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765830575; x=1766435375; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oDIDSIdfLgKrJFCyMgNq5TieqPNo9NQedUeGs+YAwKk=;
        b=dNbR3YSKgNJ2/F2arJE21HU0BmS1csoFCmxB3C5TM9fRyh12mk+wAj94/FQBUj8JrX
         j8F67luweI4QqCCQu2lOnXFw2axBcYUnqzV9YWTsSSV9qMylz9w3XMEQthWhhGGuAai3
         M3zha/UxHcbvtg6qYRjkwsM16Ks3hoAi/yvT21hDfQvtaqW6wKHImkYVg5ri47gfUQlL
         fpnUUh7tUtjqG5MZ8VGahuQeHgXbXMBHSsYD9vd5FWtaJfwmT+GG5D8MaljuSnf7hpx3
         4RdPoj/m5S9PrST0pFBSqIuP5BI8bHOf8lHT7F6vjpWJ+WHWDU1EHRuE1U1XjeawvblG
         fQOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765830575; x=1766435375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oDIDSIdfLgKrJFCyMgNq5TieqPNo9NQedUeGs+YAwKk=;
        b=PVUtt0g6tTX+5rh+M1nySjb+5ohhs61l5SsHS3QbCXBgV4XAs7GAfxB8T8ntI7OeuS
         gUocxRakD0vBFEjI7JkdjM1epC/ueYY0iGvRebsgBCyvwGhJi2BzpQH8kCYys7snRL/8
         /qB7L+57F5hN+XIp9ADky80AOQ4YApt/n4bDJTPizpGIH9qW8BY+vz4d1H260IJVVBWZ
         3/oUMDvFfh4HStTn0pERT6w2RfpsKLJqG40D6MOW7+khpz24PmO4nmAL6xQc3oYuH1zc
         VJZTCqQs2RCNvsyfwg5QlcoUoWoWOQO+x6N0cddsW+IFzCW4H6z/hqYPjOstdvlJKjMh
         7wYw==
X-Gm-Message-State: AOJu0Yy/qT/QQ5Jp7fcmg1mXK3Cg7gbyAmpg2+XSjZvl7EjIDozEeUDw
	GU/eePxjRSoB2b3T77BteFe5G2nXi7aNEA/KLRST/cN1kEmOhItVMOiNFohGcq8ELkqBppjwJDt
	i9WtMNSOEYOvH20TU+Agv3OdLnL3VHnChgiy0Ydcj
X-Gm-Gg: AY/fxX4xjKNenGZKaTvOt3trLd5Nqvl2pHKdf+6WRffOMRvHc0QSfuYQF7tZAFbYoEo
	baSXcznvJb5xic2CFfixNtWqhiHgyDTAHiPs68LxsILoYrWgELY3YtdycH6vLIjqV2Q+42mj4D1
	S4P7T2C30R0um22WlS3CxiFWa95XAS+osZ843IJ+qRacZ3zmm9jP7Z71P3rWa5wJxzN+hsucQn0
	yOr08d1BeuHQF5EG3m7VlEIYwo9ncHs8YGp/3cXyJWLuCmDe9Q8NOoklzVA/Nm4xNQdhqq4D0iG
	jh6X0TRWRiJk2by1YeCrJK8iO5rHiA==
X-Google-Smtp-Source: AGHT+IGTluqt/e4PUOM5Im4PVjW2gjC4sgDSwIJQ2S+9Eh2v1uSHOb4ZlzyC7XiD0DaqLEs5SyWD4sFhtCa0AtG3JWk=
X-Received: by 2002:adf:fdce:0:b0:42f:bc61:d1c2 with SMTP id
 ffacd0b85a97d-42fbc61d412mr7545916f8f.34.1765830575378; Mon, 15 Dec 2025
 12:29:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251205081448.4062096-1-chengkev@google.com> <20251205081448.4062096-3-chengkev@google.com>
 <CAJD7tkbiATfUizn8T2+b3=K8KswMWgg3iEvpE6HfHBsCtJmB8A@mail.gmail.com>
In-Reply-To: <CAJD7tkbiATfUizn8T2+b3=K8KswMWgg3iEvpE6HfHBsCtJmB8A@mail.gmail.com>
From: Kevin Cheng <chengkev@google.com>
Date: Mon, 15 Dec 2025 15:29:24 -0500
X-Gm-Features: AQt7F2rNfkBDDsy5mwR9dw22Ho0D97CLStbR3lQb7eSZLQ6ENK_Y67jT8_-Xa-E
Message-ID: <CAE6NW_ZLPfmqmSoop93A0dFfBX4sUXio1mcxWWbOQ4PFGxd2gw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] x86/svm: Add unsupported instruction
 intercept test
To: Yosry Ahmed <yosryahmed@google.com>
Cc: kvm@vger.kernel.org, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 8, 2025 at 8:34=E2=80=AFPM Yosry Ahmed <yosryahmed@google.com> =
wrote:
>
> On Fri, Dec 5, 2025 at 12:14=E2=80=AFAM Kevin Cheng <chengkev@google.com>=
 wrote:
> >
> > Add tests that expect a nested vm exit, due to an unsupported
> > instruction, to be handled by L0 even if L1 intercepts are set for that
> > instruction.
> >
> > The new test exercises bug fixed by:
> > https://lore.kernel.org/all/20251205070630.4013452-1-chengkev@google.co=
m/
> >
> > Signed-off-by: Kevin Cheng <chengkev@google.com>
> [..]
> > @@ -3572,6 +3572,80 @@ static void svm_shutdown_intercept_test(void)
> >         report(vmcb->control.exit_code =3D=3D SVM_EXIT_SHUTDOWN, "shutd=
own test passed");
> >  }
> >
> > +struct InvpcidDesc {
> > +       uint64_t pcid : 12;
> > +       uint64_t reserved : 52;
> > +       uint64_t addr;
> > +};
> > +
> > +static void insn_invpcid(struct svm_test *test)
> > +{
> > +       struct InvpcidDesc desc =3D {0};
> > +       unsigned long type =3D 0;
> > +
> > +       __asm__ volatile (
> > +               "invpcid %1, %0"
> > +               :
> > +               : "r" (type), "m" (desc)
> > +               : "memory"
> > +       );
> > +}
>
> Can we use invpcid_safe() and the descriptor already defined in processor=
.h?
>
> > +
> > +asm(
> > +       "insn_rdtscp: rdtscp;ret\n\t"
> > +       "insn_skinit: skinit;ret\n\t"
> > +       "insn_xsetbv: xor %eax, %eax; xor %edx, %edx; xor %ecx, %ecx; x=
setbv;ret\n\t"
> > +       "insn_rdpru: xor %ecx, %ecx; rdpru;ret\n\t"
> > +);
> > +
> > +extern void insn_rdtscp(struct svm_test *test);
> > +extern void insn_skinit(struct svm_test *test);
> > +extern void insn_xsetbv(struct svm_test *test);
> > +extern void insn_rdpru(struct svm_test *test);
> > +
> > +struct insn_table {
> > +       const char *name;
> > +       u64 intercept;
> > +       void (*insn_func)(struct svm_test *test);
> > +       u32 reason;
> > +};
> > +
> > +static struct insn_table insn_table[] =3D {
> > +       { "RDTSCP", INTERCEPT_RDTSCP, insn_rdtscp, SVM_EXIT_RDTSCP},
> > +       { "SKINIT", INTERCEPT_SKINIT, insn_skinit, SVM_EXIT_SKINIT},
> > +       { "XSETBV", INTERCEPT_XSETBV, insn_xsetbv, SVM_EXIT_XSETBV},
> > +       { "RDPRU", INTERCEPT_RDPRU, insn_rdpru, SVM_EXIT_RDPRU},
> > +       { "INVPCID", INTERCEPT_INVPCID, insn_invpcid, SVM_EXIT_INVPCID}=
,
> > +       { NULL },
> > +};
> > +
> > +/*
> > + * Test that L1 does not intercept instructions that are not advertise=
d in
> > + * guest CPUID.
> > + */
> > +static void svm_unsupported_instruction_intercept_test(void)
> > +{
> > +       u32 cur_insn;
> > +       u32 exit_code;
> > +
> > +       vmcb_set_intercept(INTERCEPT_EXCEPTION_OFFSET + UD_VECTOR);
> > +
> > +       for (cur_insn =3D 0; insn_table[cur_insn].name !=3D NULL; ++cur=
_insn) {
> > +               test_set_guest(insn_table[cur_insn].insn_func);
> > +               vmcb_set_intercept(insn_table[cur_insn].intercept);
> > +               svm_vmrun();
> > +               exit_code =3D vmcb->control.exit_code;
> > +
> > +               if (exit_code =3D=3D SVM_EXIT_EXCP_BASE + UD_VECTOR)
> > +                       report_pass("UD Exception injected");
> > +               else if (exit_code =3D=3D insn_table[cur_insn].reason)
> > +                       report_fail("L1 should not intercept %s when in=
struction is not advertised in guest CPUID",
> > +                                   insn_table[cur_insn].name);
> > +               else
> > +                       report_fail("Unknown exit reason, 0x%x", exit_c=
ode);
> > +       }
> > +}
> > +
> >  struct svm_test svm_tests[] =3D {
> >         { "null", default_supported, default_prepare,
> >           default_prepare_gif_clear, null_test,
> > @@ -3713,6 +3787,7 @@ struct svm_test svm_tests[] =3D {
> >         TEST(svm_tsc_scale_test),
> >         TEST(pause_filter_test),
> >         TEST(svm_shutdown_intercept_test),
> > +       TEST(svm_unsupported_instruction_intercept_test),
> >         { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
> >  };
> >
> > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> > index 522318d32bf68..ec456d779b35c 100644
> > --- a/x86/unittests.cfg
> > +++ b/x86/unittests.cfg
> > @@ -253,11 +253,18 @@ arch =3D x86_64
> >  [svm]
> >  file =3D svm.flat
> >  smp =3D 2
> > -test_args =3D "-pause_filter_test"
> > +test_args =3D "-pause_filter_test -svm_unsupported_instruction_interce=
pt_test"
> >  qemu_params =3D -cpu max,+svm -m 4g
> >  arch =3D x86_64
> >  groups =3D svm
> >
> > +[svm_unsupported_instruction_intercept_test]
> > +file =3D svm.flat
> > +test_args =3D "svm_unsupported_instruction_intercept_test"
> > +qemu_params =3D -cpu max,+svm,-rdtscp,-xsave,-invpcid
>
> Does this cover all 5 instructions being tested?

Sorry I missed SKINIT. rdpru feature name is not defined in Qemu so
can't be excluded (qemu/target/i386/cpu.c under FEAT_8000_0008_EBX).
This should be okay though since KVM does not advertise RDPRU by
default.

>
> > +arch =3D x86_64
> > +groups =3D svm
> > +
> >  [svm_pause_filter]
> >  file =3D svm.flat
> >  test_args =3D pause_filter_test
> > --
> > 2.52.0.223.gf5cc29aaa4-goog
> >

