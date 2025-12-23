Return-Path: <kvm+bounces-66529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AF496CD77C1
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 01:21:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 607FF301F8DC
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 00:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889FF1D5CD9;
	Tue, 23 Dec 2025 00:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2VqSPjav"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B0518EFD1
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 00:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766449261; cv=none; b=jxbt1v8FJFOj0gwyGgTJ/fZDP1H0nA8LWsqrAvGNvn0vZsH7fVSpNoaNkl8CXbG+9XwGdetEsZifhDUWVpapIKtVhKHiNPTFn60ArA3mWUr5vdLpxUpAxrsX4fK/v/7zVceLysAyLtLZo9XTauj8mnu7gbBKM0pumk9p9nxKnJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766449261; c=relaxed/simple;
	bh=uqYqKRHeXpTddhMxbshxwAW45YGPsOoicz+wOyJA7R4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EQdmpc8SHNd9EhTEoX1aLuqypKgimoAh6jhVEB+6RcCpTgoGMLVe7L3GuS3ccrZYb5245DhZYQ5nZvhIYSuZ8MYk6+VpCwEJkqfIYD/4WE3Sj7APaP8tOPcMrnag4LmcmYo87je2G8+15BhYdFKIbWBjgxT6c9l7JLDRXBmQoXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2VqSPjav; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42e2d02a3c9so3003313f8f.3
        for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 16:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766449258; x=1767054058; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SZsx7cJ9Ye312xBCkpV4L6PWob6CKPjB4S21GGQ7LzI=;
        b=2VqSPjav9YuGlPo987SZWoZY+qR5HTJN5el16KUAMagt9bsRITQVBvOCLAM5Y9Yp1F
         l+W5e90DIQqSABBPhR/C0EyQ6eud1eOhwtE01yNsTloe0HGZLPDLBzIQiwIT1+N1Ggxp
         A65ZsizDUqaro9thaSIIhDyGkwewFgP4Uq/0BCn7f2SfavFFesHmlFJsPUrSiM39zb40
         5YMdXJk1aJ25w95eOTgPOexr/vUrBE9bWy10aHFPYZuN4nRSx+frH9dBT1cmw6nhsLhx
         Xu6OSoVSKV8Ck3ky9vJT2tCBCUT6s7/47zOaVb7oYHfeaNJS57F4rcrbQSDuKF7fx2uu
         cHNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766449258; x=1767054058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SZsx7cJ9Ye312xBCkpV4L6PWob6CKPjB4S21GGQ7LzI=;
        b=ZUsSu8OcW5BKIv4TyIlTXWTkTbsQh85KpNKRp0NtsyxrFWnxG4hrzC9Voq6zc+iSwH
         iE5g3VqicAazoMcnNU3qp+WG3IqUplHLNmuPmELwa8X7MGE1hY3qvj/QtFMeAtMY/EH3
         e4MYAkTIbUZIn7iiVT9fLUvsJdl804JvsUI9r/Y+ofAS8PXgg74mW+MadxrryQutFORF
         /bXbDUybS6szUHVHtx3x6UWqMWa92BEoJX6FKAvr9oMT/TJ4PcEEpOvnW5VEcdTh5yvs
         GsTWFvXgsRyYzeZwvem0NH+4iFJoeImo4qzSca9V+ZojijsG8GkKvfpeVjISyN/lOnHW
         3svw==
X-Gm-Message-State: AOJu0YzeCgY7WZbiyxB/hvfHgEZp6HStleBFDo/m1hCIDStSXQycr8YO
	GMSwFqOOw75B+q2D+b/6+nCx5/j0jLwvdYyHs5NjH53Rd6TaAOzgBaNl+EVzRSoz3ZwDTALztKz
	OhLPPa9WWDWDQiZE1mk8IbDWwP4DZ6OHTbm5sHBYR2AwJ58wu2Tt5YEyUw90=
X-Gm-Gg: AY/fxX4ITCwdeErohGvgm/t+NPdjY4tUUdFRbO4BiAgrofJrLJx6fcd6BpqSzZwKtmI
	6oSkoMqQFEcwcIh8+Cx1F8OzDWmNskH1lqXSLWJIHYN+TnrKfutO29YhrQi3xR6BadsBjGLHuLC
	nHwMHx7Z26NuoYuinbI0rlIJRazrGmLWwZWDUNkBIgWw7gJ4yAUeG+tPttTg2BeZjNVkV92dxxo
	n+IKlyDoixcTrS/bfyGI9u9rszXvXcxB1iG/cNRPbtulOeuGz5mULBh4vyf/S7W6GZv1ksLiOnd
	7r4K/RlqhlcLCTWBE8LymREjGoYriA==
X-Google-Smtp-Source: AGHT+IGJSmqKHj9E+6BA4yUKZ7nTnIY/bAXjExA7PVMDOTazcUb0ngxKCuC3YYVorq/owP6s3mIVgMvdZOhc0MJJvAA=
X-Received: by 2002:a5d:58e5:0:b0:431:771:a51f with SMTP id
 ffacd0b85a97d-4324e50ada8mr11424144f8f.49.1766449257719; Mon, 22 Dec 2025
 16:20:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251219225908.334766-1-chengkev@google.com> <20251219225908.334766-10-chengkev@google.com>
In-Reply-To: <20251219225908.334766-10-chengkev@google.com>
From: Kevin Cheng <chengkev@google.com>
Date: Mon, 22 Dec 2025 19:20:46 -0500
X-Gm-Features: AQt7F2pepFhXDRDfJXilqXG3U-Gc1Lj_dLb-WfaYVw3oBG74ve9k-cC-DlWC9Tc
Message-ID: <CAE6NW_ZhyV8gN_2WC95swK4inceoqszAzprJQ2DUfha8xYHrCA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 9/9] x86/svm: Add event injection check tests
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 19, 2025 at 5:59=E2=80=AFPM Kevin Cheng <chengkev@google.com> w=
rote:
>
> The APM Vol #2 - 15.20 lists illegal combinations related to event
> injection. Add testing to verify that these illegal combinations cause
> an invalid VM exit.
>
> Also add testing to verify that legal combinations for event injection
> work as intended. This includes testing all valid injection types and
> injecting all exceptions when the exception type is specified.
>
> Signed-off-by: Kevin Cheng <chengkev@google.com>
> ---
>  x86/svm_tests.c | 192 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 121 insertions(+), 71 deletions(-)
>
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index a40468693b396..a069add43d078 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -1674,74 +1674,6 @@ static bool vnmi_check(struct svm_test *test)
>         return get_test_stage(test) =3D=3D 3;
>  }
>
> -static volatile int count_exc =3D 0;
> -
> -static void my_isr(struct ex_regs *r)
> -{
> -       count_exc++;
> -}
> -
> -static void exc_inject_prepare(struct svm_test *test)
> -{
> -       default_prepare(test);
> -       handle_exception(DE_VECTOR, my_isr);
> -       handle_exception(NMI_VECTOR, my_isr);
> -}
> -
> -
> -static void exc_inject_test(struct svm_test *test)
> -{
> -       asm volatile ("vmmcall\n\tvmmcall\n\t");
> -}
> -
> -static bool exc_inject_finished(struct svm_test *test)
> -{
> -       switch (get_test_stage(test)) {
> -       case 0:
> -               if (vmcb->control.exit_code !=3D SVM_EXIT_VMMCALL) {
> -                       report_fail("VMEXIT not due to vmmcall. Exit reas=
on 0x%x",
> -                                   vmcb->control.exit_code);
> -                       return true;
> -               }
> -               vmcb->save.rip +=3D 3;
> -               vmcb->control.event_inj =3D NMI_VECTOR | SVM_EVTINJ_TYPE_=
EXEPT | SVM_EVTINJ_VALID;
> -               break;
> -
> -       case 1:
> -               if (vmcb->control.exit_code !=3D SVM_EXIT_ERR) {
> -                       report_fail("VMEXIT not due to error. Exit reason=
 0x%x",
> -                                   vmcb->control.exit_code);
> -                       return true;
> -               }
> -               report(count_exc =3D=3D 0, "exception with vector 2 not i=
njected");
> -               vmcb->control.event_inj =3D DE_VECTOR | SVM_EVTINJ_TYPE_E=
XEPT | SVM_EVTINJ_VALID;
> -               break;
> -
> -       case 2:
> -               if (vmcb->control.exit_code !=3D SVM_EXIT_VMMCALL) {
> -                       report_fail("VMEXIT not due to vmmcall. Exit reas=
on 0x%x",
> -                                   vmcb->control.exit_code);
> -                       return true;
> -               }
> -               vmcb->save.rip +=3D 3;
> -               report(count_exc =3D=3D 1, "divide overflow exception inj=
ected");
> -               report(!(vmcb->control.event_inj & SVM_EVTINJ_VALID), "ev=
entinj.VALID cleared");
> -               break;
> -
> -       default:
> -               return true;
> -       }
> -
> -       inc_test_stage(test);
> -
> -       return get_test_stage(test) =3D=3D 3;
> -}
> -
> -static bool exc_inject_check(struct svm_test *test)
> -{
> -       return count_exc =3D=3D 1 && get_test_stage(test) =3D=3D 3;
> -}
> -
>  static volatile bool virq_fired;
>  static volatile unsigned long virq_rip;
>
> @@ -2548,6 +2480,126 @@ static void test_dr(void)
>         vmcb->save.dr7 =3D dr_saved;
>  }
>
> +/* Returns true if exception can be injected via the SVM_EVTINJ_TYPE_EXE=
PT type */
> +static bool is_injectable_exception(int vec)
> +{
> +       /*
> +        * Vectors that do not correspond to an exception are excluded. N=
MI is
> +        * not an exception so it is excluded. BR and OF are excluded bec=
ause
> +        * BOUND and INTO are not legal in 64-bit mode.
> +        *
> +        * The VE vector is excluded because it is Intel only.
> +        *
> +        * The HV and VC vectors are excluded because they are only relev=
ant
> +        * within secure guest VMs.
> +        */
> +       static u8 exception_vectors[32] =3D {
> +               [DE_VECTOR] =3D 1, [DB_VECTOR] =3D 1, [BP_VECTOR] =3D 1,
> +               [UD_VECTOR] =3D 1, [NM_VECTOR] =3D 1, [DF_VECTOR] =3D 1,
> +               [TS_VECTOR] =3D 1, [NP_VECTOR] =3D 1, [SS_VECTOR] =3D 1,
> +               [GP_VECTOR] =3D 1, [PF_VECTOR] =3D 1, [MF_VECTOR] =3D 1,
> +               [AC_VECTOR] =3D 1, [MC_VECTOR] =3D 1, [XF_VECTOR] =3D 1,
> +               [CP_VECTOR] =3D 1, [SX_VECTOR] =3D 1,

Injecting CP exception relies on shadow stack enablement.

This will need to be added to processor.h
static inline bool this_cpu_has_shstk(void)
{
       return this_cpu_has(X86_FEATURE_SHSTK);
}

and [CP_VECTOR] should be set to this_cpu_has_shstk().

> +       };
> +
> +       return exception_vectors[vec];
> +}
> +
> +static bool is_valid_injection_type_mask(int type_mask)
> +{
> +       return type_mask =3D=3D SVM_EVTINJ_TYPE_INTR ||
> +              type_mask =3D=3D SVM_EVTINJ_TYPE_NMI ||
> +              type_mask =3D=3D SVM_EVTINJ_TYPE_EXEPT ||
> +              type_mask =3D=3D SVM_EVTINJ_TYPE_SOFT;
> +}
> +
> +static volatile bool event_injection_handled;
> +static void event_injection_irq_handler(isr_regs_t *regs)
> +{
> +       event_injection_handled =3D true;
> +       vmmcall();
> +}
> +
> +static void event_injection_exception_handler(struct ex_regs *r)
> +{
> +       event_injection_handled =3D true;
> +       vmmcall();
> +}
> +
> +static void test_event_injection(void)
> +{
> +       u32 event_inj_saved =3D vmcb->control.event_inj, vector =3D 0x22,=
 event_inj;
> +       int type, type_mask;
> +       bool reserved;
> +
> +       handle_exception(DE_VECTOR, event_injection_exception_handler);
> +       handle_irq(vector, event_injection_irq_handler);
> +
> +       /* Setting reserved values of TYPE is illegal */
> +       for (type =3D 0; type < 8; type++) {
> +               type_mask =3D type << SVM_EVTINJ_TYPE_SHIFT;
> +               reserved =3D !is_valid_injection_type_mask(type_mask);
> +               event_injection_handled =3D false;
> +               event_inj =3D SVM_EVTINJ_VALID;
> +
> +               switch (type_mask) {
> +               case SVM_EVTINJ_TYPE_EXEPT:
> +                       event_inj |=3D DE_VECTOR;
> +                       break;
> +               default:
> +                       event_inj |=3D vector;
> +               }
> +
> +               vmcb->control.event_inj =3D event_inj |
> +                                         (type << SVM_EVTINJ_TYPE_SHIFT)=
;
> +               if (reserved) {
> +                       report(svm_vmrun() =3D=3D SVM_EXIT_ERR,
> +                              "Test EVENTINJ error code with type %d", t=
ype);
> +                       report(!event_injection_handled,
> +                              "Reserved type %d ignores EVENTINJ vector =
field", type);
> +               } else {
> +                       report(svm_vmrun() =3D=3D SVM_EXIT_VMMCALL,
> +                              "Test EVENTINJ delivers with type %d", typ=
e);
> +               }
> +
> +               if (type_mask =3D=3D SVM_EVTINJ_TYPE_NMI)
> +                       report(!event_injection_handled,
> +                              "Injected NMI ignores EVENTINJ vector fiel=
d");
> +               else if (!reserved)
> +                       report(event_injection_handled,
> +                              "Test EVENTINJ IRQ handler invoked with ty=
pe %d", type);
> +
> +               vmcb->control.event_inj =3D event_inj_saved;
> +       }
> +
> +       /*
> +        * It is illegal to specify event injection type 3 (Exception) wi=
th a
> +        * vector that does not correspond to an exception.
> +        */
> +       event_inj =3D SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_EXEPT;
> +       for (vector =3D 0; vector < 256; vector++) {
> +               vmcb->control.event_inj =3D event_inj | vector;
> +               event_injection_handled =3D false;
> +
> +               if (vector >=3D 32 || !is_injectable_exception(vector)) {
> +                       report(svm_vmrun() =3D=3D SVM_EXIT_ERR,
> +                              "Test EVENTINJ exception type error code w=
ith vector %d",
> +                              vector);
> +               } else {
> +                       handle_exception(vector, event_injection_exceptio=
n_handler);
> +                       report(svm_vmrun() =3D=3D SVM_EXIT_VMMCALL,
> +                              "Test EVENTINJ exception type delivers wit=
h vector %d",
> +                              vector);
> +                       report(event_injection_handled,
> +                              "Test EVENTINJ exception handler invoked w=
ith vector %d",
> +                              vector);
> +               }
> +
> +               vmcb->control.event_inj =3D event_inj_saved;
> +       }
> +}
> +
> +
>  asm(
>         "insn_sidt: sidt idt_descr;ret\n\t"
>         "insn_sgdt: sgdt gdt_descr;ret\n\t"
> @@ -2893,6 +2945,7 @@ static void svm_guest_state_test(void)
>         test_dr();
>         test_msrpm_iopm_bitmap_addrs();
>         test_canonicalization();
> +       test_event_injection();
>  }
>
>  extern void guest_rflags_test_guest(struct svm_test *test);
> @@ -4074,9 +4127,6 @@ struct svm_test svm_tests[] =3D {
>         { "latency_svm_insn", default_supported, lat_svm_insn_prepare,
>           default_prepare_gif_clear, null_test,
>           lat_svm_insn_finished, lat_svm_insn_check },
> -       { "exc_inject", default_supported, exc_inject_prepare,
> -         default_prepare_gif_clear, exc_inject_test,
> -         exc_inject_finished, exc_inject_check },
>         { "pending_event", default_supported, pending_event_prepare,
>           default_prepare_gif_clear,
>           pending_event_test, pending_event_finished, pending_event_check=
 },
> --
> 2.52.0.322.g1dd061c0dc-goog
>

