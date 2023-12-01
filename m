Return-Path: <kvm+bounces-3038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6373800121
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 02:39:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70AE128174C
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 01:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15F7117D9;
	Fri,  1 Dec 2023 01:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eWEj2ptk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDC210FD
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:39:39 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-54744e66d27so5367a12.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701394777; x=1701999577; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0W7uBrHgrZxccbgeiWrjico6sL2HB9xoyfVd95MNJBY=;
        b=eWEj2ptkoEn3rIBufL3ozyoxd/J/UvpCPVJrvq4vfgdrFqbBe9cIin0nlSLUxReZVG
         wX04IxkbxkNkE/5J0zxeOYYjU89KfKd47xHH1qh/NCT43kmWlhjzz6AkAYVFmHmQq6cj
         z6Lv6scyYaI5R/xGMrdjdwwkmRBEHZddtCLSXu9eXCjN41p9VV6NpqmEQn5oI0oFRWRx
         cAI234H2XUN0IqKpffoBhGBxrNA9eRL9j98DrSOlIHHDrtdh6/w7PWMbQdb+7N8q8bvz
         9DBmypIYdHDNkBZlrPVmB8Ra9gbZkWgjYHjszYbacjYrj4frgauSgAObcNFljBCzCBvL
         eOuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701394777; x=1701999577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0W7uBrHgrZxccbgeiWrjico6sL2HB9xoyfVd95MNJBY=;
        b=E6Xa96eBFmq3O/wquN8lUEU2jzOSRtmHe3gIHj0DRQf+Bp5e++/05f7Uzm/m2oQ27f
         bQh7oCT09bX+N9D+uPbt8QETNzrgOrBowx32KyUmbnTWLMPTzLNAywCITGyoVRGEobWF
         ZHTI28mJNpkSwvpy2AJmVRhNHJ26mUcb9QWgFbDamPlyCXc8rTdUrWWF8P6wjs3ZbKtI
         VfubO9M+QOhNdw7DWAZxoxeKR9WRX3fAfT2p7aeHBwxtCUcIqgi/RITDuV4nC3yYkGwo
         f3NkpOJoL1MZ1LrfhNdVM337wB+MB4hxtR5WkkFESH3izNnxsgLncdjKvvOSzfGFuNA0
         a4Ng==
X-Gm-Message-State: AOJu0YzMS6jrdCPsugunzj2fTPa4OZ2SyDQud1bWK95SxugrLL7Z/qMA
	xyOPGJEBg/3IP1WFEYfBnZrJS1d9xnRrXmttc23XV+qKLzm0ZUhsRz0=
X-Google-Smtp-Source: AGHT+IGeXU7GAMJTsdrcW0yrpXIG0rhuk5F8vQawv8+o8Y6yWx/tvGHuw/iYtiwKsTSmlgkbZmxa+qaWiYn3l+Cwe44=
X-Received: by 2002:a50:d547:0:b0:54c:384b:e423 with SMTP id
 f7-20020a50d547000000b0054c384be423mr19703edj.5.1701394777495; Thu, 30 Nov
 2023 17:39:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231024001636.890236-1-jmattson@google.com> <20231024001636.890236-2-jmattson@google.com>
 <ZTcO8M3T9DGYrN2M@google.com> <ZWjwV7rQ9i2NCf5A@google.com>
In-Reply-To: <ZWjwV7rQ9i2NCf5A@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 30 Nov 2023 17:39:25 -0800
Message-ID: <CALMp9eSwtVZQ_aeQ0itT7O5fDNznA2vQ0zT32VkyZS2-Q6eYZQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86: Use a switch statement in __feature_translate()
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 30, 2023 at 12:28=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Mon, Oct 23, 2023, Sean Christopherson wrote:
> > On Mon, Oct 23, 2023, Jim Mattson wrote:
> > > The compiler will probably do better than linear search.
> >
> > It shouldn't matter, KVM relies on the compiler to resolve the translat=
ion at
> > compile time, e.g. the result is fed into reverse_cpuid_check().
> >
> > I.e. we should pick whatever is least ugly.
>
> What if we add a macro to generate each case statement?  It's arguably a =
wee bit
> more readable, and also eliminates the possibility of returning the wrong=
 feature
> due to copy+paste errors, e.g. nothing would break at compile time if we =
goofed
> and did:
>
>         case X86_FEATURE_SGX1:
>                 return KVM_X86_FEATURE_SGX1;
>         case X86_FEATURE_SGX2:
>                 return KVM_X86_FEATURE_SGX1;
>
> If you've no objection, I'll push this:

:barf:

Um, okay.

> --
> Author: Jim Mattson <jmattson@google.com>
> Date:   Mon Oct 23 17:16:36 2023 -0700
>
>     KVM: x86: Use a switch statement and macros in __feature_translate()
>
>     Use a switch statement with macro-generated case statements to handle
>     translating feature flags in order to reduce the probability of runti=
me
>     errors due to copy+paste goofs, to make compile-time errors easier to
>     debug, and to make the code more readable.
>
>     E.g. the compiler won't directly generate an error for duplicate if
>     statements
>
>             if (x86_feature =3D=3D X86_FEATURE_SGX1)
>                     return KVM_X86_FEATURE_SGX1;
>             else if (x86_feature =3D=3D X86_FEATURE_SGX2)
>                     return KVM_X86_FEATURE_SGX1;
>
>     and so instead reverse_cpuid_check() will fail due to the untranslate=
d
>     entry pointing at a Linux-defined leaf, which provides practically no
>     hint as to what is broken
>
>       arch/x86/kvm/reverse_cpuid.h:108:2: error: call to __compiletime_as=
sert_450 declared with 'error' attribute:
>                                           BUILD_BUG_ON failed: x86_leaf =
=3D=3D CPUID_LNX_4
>               BUILD_BUG_ON(x86_leaf =3D=3D CPUID_LNX_4);
>               ^
>     whereas duplicate case statements very explicitly point at the offend=
ing
>     code:
>
>       arch/x86/kvm/reverse_cpuid.h:125:2: error: duplicate case value '36=
1'
>               KVM_X86_TRANSLATE_FEATURE(SGX2);
>               ^
>       arch/x86/kvm/reverse_cpuid.h:124:2: error: duplicate case value '36=
0'
>               KVM_X86_TRANSLATE_FEATURE(SGX1);
>               ^
>
>     And without macros, the opposite type of copy+paste goof doesn't gene=
rate
>     any error at compile-time, e.g. this yields no complaints:
>
>             case X86_FEATURE_SGX1:
>                     return KVM_X86_FEATURE_SGX1;
>             case X86_FEATURE_SGX2:
>                     return KVM_X86_FEATURE_SGX1;
>
>     Note, __feature_translate() is forcibly inlined and the feature is kn=
own
>     at compile-time, so the code generation between an if-elif sequence a=
nd a
>     switch statement should be identical.
>
>     Signed-off-by: Jim Mattson <jmattson@google.com>
>     Link: https://lore.kernel.org/r/20231024001636.890236-2-jmattson@goog=
le.com
>     [sean: use a macro, rewrite changelog]
>     Signed-off-by: Sean Christopherson <seanjc@google.com>
>
> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
> index 17007016d8b5..aadefcaa9561 100644
> --- a/arch/x86/kvm/reverse_cpuid.h
> +++ b/arch/x86/kvm/reverse_cpuid.h
> @@ -116,20 +116,19 @@ static __always_inline void reverse_cpuid_check(uns=
igned int x86_leaf)
>   */
>  static __always_inline u32 __feature_translate(int x86_feature)
>  {
> -       if (x86_feature =3D=3D X86_FEATURE_SGX1)
> -               return KVM_X86_FEATURE_SGX1;
> -       else if (x86_feature =3D=3D X86_FEATURE_SGX2)
> -               return KVM_X86_FEATURE_SGX2;
> -       else if (x86_feature =3D=3D X86_FEATURE_SGX_EDECCSSA)
> -               return KVM_X86_FEATURE_SGX_EDECCSSA;
> -       else if (x86_feature =3D=3D X86_FEATURE_CONSTANT_TSC)
> -               return KVM_X86_FEATURE_CONSTANT_TSC;
> -       else if (x86_feature =3D=3D X86_FEATURE_PERFMON_V2)
> -               return KVM_X86_FEATURE_PERFMON_V2;
> -       else if (x86_feature =3D=3D X86_FEATURE_RRSBA_CTRL)
> -               return KVM_X86_FEATURE_RRSBA_CTRL;
> +#define KVM_X86_TRANSLATE_FEATURE(f)   \
> +       case X86_FEATURE_##f: return KVM_X86_FEATURE_##f
>
> -       return x86_feature;
> +       switch (x86_feature) {
> +       KVM_X86_TRANSLATE_FEATURE(SGX1);
> +       KVM_X86_TRANSLATE_FEATURE(SGX2);
> +       KVM_X86_TRANSLATE_FEATURE(SGX_EDECCSSA);
> +       KVM_X86_TRANSLATE_FEATURE(CONSTANT_TSC);
> +       KVM_X86_TRANSLATE_FEATURE(PERFMON_V2);
> +       KVM_X86_TRANSLATE_FEATURE(RRSBA_CTRL);
> +       default:
> +               return x86_feature;
> +       }
>  }
>
>  static __always_inline u32 __feature_leaf(int x86_feature)
>

