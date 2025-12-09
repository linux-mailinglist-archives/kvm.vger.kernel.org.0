Return-Path: <kvm+bounces-65522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 09D13CAEA16
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 02:32:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5C6933005F01
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 01:32:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A7E32ED159;
	Tue,  9 Dec 2025 01:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AnhjOYFF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B650A1917CD
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 01:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765243918; cv=none; b=tZbjz0RPtAUFu9aCAXfRXEhUpilxqnEH9jEn7LvPmoPR33xoW3OHpZ5XsGm/kOdM54JtfxzFlKpEO1DCv4Yf/t8LjsJD90Lsih6EaSB6wzp9jE/iIuAVjnmb4Qc3pQRe0SaTwG/tYAgyIraiTv3VTKQucElbfqLlgHNnA+HTkOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765243918; c=relaxed/simple;
	bh=I5Eo6y9JZCbfnyb5eB/KEXkAHO6973BnaJC902dwVRk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KkmWI7Od1SJatI17d8SoM2HPKepSHHLRWd23KluMenoZTelAnJgR/Ej3IXTbWmuZfcm1ESXDaGUKy2pStjuKZCXmpSqdxxWuyHj1ol7mkH2ZzIcMtcDjHDCaDmGfv8AeUtrn6uAWdQkQv2XfVQBpiGao54pgIjdRl4wuYcg8py8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AnhjOYFF; arc=none smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-9372164d768so4188051241.0
        for <kvm@vger.kernel.org>; Mon, 08 Dec 2025 17:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765243916; x=1765848716; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LKix0qHh96BRpRM/3yIQmMxnNptVZvOEd+SrV6ktyqU=;
        b=AnhjOYFFQX2EkBY6KdyNbf4UTLK2lv2jTQT1mpnqJxx80ZoFdN8xyWtqhTlMiKZcnz
         l9xugInrwEsePzI69HsymU8WMBpNZbC7opZMUSu1Q4P+JvcP3ufDxlulSIrnwirkdiPt
         f9NipS/YZFy8Iy1gnfG51RKaswuWHohqLsXHA0QWWJa3jGZaTzSeoABKrYAOXxDo9x+n
         jITf/oHeI6P/uqOBJyU8g+3VQL9KK/OSWoz9hn89kr6+eMCEFst+ol2OE17uCkFUk35l
         15+U2gU25GDN3XODDrp98+pR5WZ8pSfREdQLZaqvygI5Yb5D1iOLmjcvWT9Ey7I9ndUz
         Ou4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765243916; x=1765848716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LKix0qHh96BRpRM/3yIQmMxnNptVZvOEd+SrV6ktyqU=;
        b=S37b4jmxztf3rMgSoz5845tmcaqIkZ40IOXWgDAvTSscef6vhG2/IlRqrI2w4OHqxS
         9KjQmKc5g2fA4TnschSvx/SQvx8WEwVaVgzv5dSQAyycpBC2Prz9bUs7pQ0MuZLv/vdB
         y4nKQYVFXV2qevnv+kuodHd4WBvY+qBXyMOaHX3G8F1wpXfKko1fW9Mx9PU+AfQBcJuK
         sOck3UvYtMiSE5WOVPpdAIkefVje4vU1Eqeq7zIMaeLVBlkB+6jyCzG+mEmMY7zvpfbT
         c9lXzNyezQ3ILctbN5MvqbRpnpgIfuzq9ugTk34QjlYD+Uuub9Vohzy9NaXFYA7LcEYP
         lj+w==
X-Gm-Message-State: AOJu0Yw8sd2viA5M2VDhEGyYnSPZZki8fAD/y/oJjqAtjFSg9zJGuCvc
	koXKP7M2UtyBlI0zd7QSQ1M+A7WdYZ8Q8bdEZP/Xxc/6FQ2Rm+7TikBHJslxo3Knq/lekPw/fe9
	zCD6pfWSyb8GCq/MWWT+7KGR+PFh5P6F6vvMz3ciI
X-Gm-Gg: ASbGncviLEpATv1jjkuELEGfs0x9ONoXVBoN970M9NkV7P5ypJZf+UK1D6j7i8303OB
	5tewoZbqTSbKwZN6f1WSPXctzcrsyqWsd1fGt3tvpgfnyxD9u+H2tTWBI2ttRbX8+Gtz/bZQq0z
	6bpPvJHeM95YT6Hzfs3aUJdqDQMTX4fJ5oXezxmyReh6PdwgORS6lciB7tlGl0EyV62fF94zwb0
	PbjCMZvEJCDk/52IklfG1kpNBZDCEloIm8cYtgC1Ezbdrq0Qb3MG/egLxSU0MnlxeDUnL2FRQsk
	O4NF
X-Google-Smtp-Source: AGHT+IG1N/n5+TEnM4vQSs/nskduvcB6yY/9WryzD2qHBxgASv9btbU7IRV+4mDFhnZLVnR+up9bdN64Fob0ldtYpFg=
X-Received: by 2002:a05:6102:ccd:b0:5d6:85a:229f with SMTP id
 ada2fe7eead31-5e55e4d15c1mr510084137.15.1765243915415; Mon, 08 Dec 2025
 17:31:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251205081448.4062096-1-chengkev@google.com> <20251205081448.4062096-2-chengkev@google.com>
In-Reply-To: <20251205081448.4062096-2-chengkev@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 8 Dec 2025 17:31:18 -0800
X-Gm-Features: AQt7F2qva2yMReFyXIbJEwwM9uVj5u1py1dQQ3jRcs2p_eURjI3OEgBrGVAJnT4
Message-ID: <CAJD7tkbU1Q0j+kwu8DXHMxSKPNBaN+zm9wCA_tHEg9kkJqiArw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] x86/svm: Add missing svm intercepts
To: Kevin Cheng <chengkev@google.com>
Cc: kvm@vger.kernel.org, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 5, 2025 at 12:14=E2=80=AFAM Kevin Cheng <chengkev@google.com> w=
rote:
>
> Some intercepts are missing from the KUT svm testing. Add all missing
> intercepts and reorganize the svm intercept definition/setting/clearing.
>
> Signed-off-by: Kevin Cheng <chengkev@google.com>

Nice cleanup!

[..]
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

Maybe do "u32 reserved_1[15 - MAX_INTERCEPT];" like the KVM definition?

>         u16 pause_filter_thresh;
>         u16 pause_filter_count;
>         u64 iopm_base_pa;
[..]                            \
> @@ -2574,7 +2573,7 @@ static void test_dr(void)
>   */
>  static void test_msrpm_iopm_bitmap_addrs(void)
>  {
> -       u64 saved_intercept =3D vmcb->control.intercept;
> +       u32 saved_intercept =3D vmcb->control.intercept[INTERCEPT_WORD3];

I think hardcoding save/restore for the relevant intercept word here
is a bit fragile (and leaks the abstraction). If the test is extended
to update more intercepts that are not in INTERCEPT_WORD3, it can
easily be missed.

How about introducing helpers to save/restore all intercepts and using
them here (and in svm_vmload_vmsave() below)? We can define the array
on the stack in the test and pass it to the helpers.

Something like this (untested):

static void test_msrpm_iopm_bitmap_addrs(void)
{
       u32 saved_intercepts[MAX_INTERCEPT];

       save_intercepts(vmcb, saved_intercepts);
       ...
       restore_intercepts(vmcb, saved_intercepts);
}


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
[..]

