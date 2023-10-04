Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8250C7B76AC
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 04:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbjJDCpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 22:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjJDCpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 22:45:11 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF22AF
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 19:45:08 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-4053f24c900so27745e9.1
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 19:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696387506; x=1696992306; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EeV5iV69+//+fPJFnagr3baxBb3XJLwL61SwLH3HuUo=;
        b=yFOa6ti39dPLEQVxB/3QhAWjBNiOEry04+AkFfNevvBGCWBBP+uPlBY5xP9CLjesdk
         lozgt4CDrf/SwsQfVd/EHWu3eoO0Dv7qRujv5od2aFW3YNbFXeD/v7691QJFxtBNH13Z
         fsy3PPMuDg6LgfmZ+B9I5vP40QH/WiELaW/ubxyQCJRxD/gQ3Cp5wZOkVZ67wS2+JBYj
         YY5cEjgRza7QJ9WYSpMmBnGznDP12gZpmR9cjv8EPQv+3hqYniky2aRhYil6GM817hSh
         oidbWVGSOWr7YRfVSAxu2zFF5T0JoU0GlMwZTsUm4+44zo3LLe+MNgv6jEMgu54eenjp
         Vrxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696387506; x=1696992306;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EeV5iV69+//+fPJFnagr3baxBb3XJLwL61SwLH3HuUo=;
        b=ISuB+aIeGMCS1GXrQlKzgPGjx0orJCBsXat+9TyPYEsVlyP4Eb0wTTCVdsqxeh6z9w
         esJRd5CDcTslEZ361cNyIc2I5N5HKEid+/S+hDPR4ISLj1f7LJE4OJ18EtERcoEFd4jr
         S9RHQWwUPa9Rnp/CDXPDC2IYT9q44zPFMOG3ZrLLPre1Sc9ZzAAw1UIFB4Dvrmjst0eO
         dk42fsOrde6K1TEpPuzbWsAYYQ1WZBkXBIUSzqFB0qKKnDJrGm/UcQ6pW2STBEGu9HdG
         96gpY/lWJTuUdZdwwH0j16TEnISclmcGRC2ycuUcvl2XgiRDZJwhQ/rgFRx330hzB9Sf
         HRVQ==
X-Gm-Message-State: AOJu0YwtnuxT73bxEPL5nW6aD460694YOTAUQAnpFkKCdYt8TDkZTumH
        AIXsjIPaAEcsQyv5x+8lesytBKtRvPZU0Je0UPWhlA==
X-Google-Smtp-Source: AGHT+IHjpENF/1FEE6fNGHTpRqXL8TNb/EQhBmbdtpfCiFAWfS5PEZkbx9yMl5+vH3fc2XuehqY50dUhMkI15GdbbOo=
X-Received: by 2002:a05:600c:1c89:b0:404:74f8:f47c with SMTP id
 k9-20020a05600c1c8900b0040474f8f47cmr32277wms.5.1696387506513; Tue, 03 Oct
 2023 19:45:06 -0700 (PDT)
MIME-Version: 1.0
References: <20231004002038.907778-1-jmattson@google.com> <01009a2a-929e-ce16-6f44-1d314e6bcba5@intel.com>
In-Reply-To: <01009a2a-929e-ce16-6f44-1d314e6bcba5@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 3 Oct 2023 19:44:51 -0700
Message-ID: <CALMp9eR+Qudg++J_dmY_SGbM_kr=GQcRRcjuUxtm9rfaC_qeXQ@mail.gmail.com>
Subject: Re: [PATCH] x86: KVM: Add feature flag for AMD's FsGsKernelGsBaseNonSerializing
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 3, 2023 at 5:57=E2=80=AFPM Dave Hansen <dave.hansen@intel.com> =
wrote:
>
> On 10/3/23 17:20, Jim Mattson wrote:
> > Define an X86_FEATURE_* flag for
> > CPUID.80000021H:EAX.FsGsKernelGsBaseNonSerializing[bit 1], and
> > advertise the feature to userspace via KVM_GET_SUPPORTED_CPUID.
> ...
> > +#define X86_FEATURE_BASES_NON_SERIAL (20*32+ 1) /* "" FSBASE, GSBASE, =
and KERNELGSBASE are non-serializing */
>
> This is failing to differentiate two *VERY* different things.
>
> FSBASE, GSBASE, and KERNELGSBASE themselves are registers.  They have
> *NOTHING* to do with serialization.  WRFSBASE, for instance is not
> serializing.  Reading (with RDMSR) or using any of those three registers
> is not serializing.
>
> The *ONLY* thing that relates them to serialization is the WRMSR
> instruction which itself is (mostly) architecturally serializing and the
> fact that WRMSR has historically been the main way to write those three
> registers.
>
> The AMD docs call this out, which helps.  But the changelog, comments
> and probably the feature naming need some work.

You're right; I was overly terse. I'll elucidate in v2.

> Why does this matter, btw?  Why do guests need this bit passed through?

The business of declaring breaking changes to the architectural
specification in a CPUID bit has never made much sense to me. Legacy
software that depends on the original architectural specification
isn't going to query the CPUID bit, because the CPUID bit didn't exist
when it was written. New software probably isn't going to query the
CPUID bit, either, because it has to have an implementation that works
on newer processors regardless. Why, then, would a developer bother to
provide an implementation that only works on older processors *and*
the code to select an implementation based on a CPUID bit?

Take, for example, CPUID.(EAX=3D7,ECX=3D0):EBX[bit 13], which, IIRC, was
the first CPUID bit of the "Ha ha; we're changing the architectural
specification" category. When Intel introduced this new behavior in
Haswell, they broke WIN87EM.DLL in Windows XP (see
https://communities.vmware.com/t5/Legacy-User-Blogs/General-Protection-Faul=
t-in-module-WIN87EM-DLL-at-0001-02C6/ta-p/2770422).
I know of at least three software packages commonly running in VMs
that were broken as a result. The CPUID bit didn't solve any problems,
and I doubt that any software queries that bit today.

As a hypervisor developer, however, it's not up to me to make value
judgments on individual CPUID bits. If a bit indicates an innate
characteristic of the hardware, it should be passed through.

No one is likely to query CPUID.80000021H.EAX[bit 21] today, but if
someone does query the bit in the future, they can reasonably expect
that WRMSR({FS,GS,KERNELGS}_BASE) is a serializing operation whenever
this bit is clear. Therefore, any hypervisor that doesn't pass the bit
through is broken. Sadly, this also means that for a heterogenous
migration pool, the hypervisor must set this bit in the guest CPUID if
it is set on any host in the pool. Yes, that means that the legacy
behavior may sometimes be present in a VM that enumerates the CPUID
bit, but that's the best we can do.

I'm a little surprised at the pushback, TBH. Are you implying that
there is some advantage to *not* passing this bit through?
