Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A27792ED8
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 21:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239361AbjIET1x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 15:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbjIET1x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 15:27:53 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBBE128
        for <kvm@vger.kernel.org>; Tue,  5 Sep 2023 12:27:28 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58fc7afa4beso32784217b3.2
        for <kvm@vger.kernel.org>; Tue, 05 Sep 2023 12:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693942037; x=1694546837; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TGSq0Ro751IP9VfAZLxrcnAKr41ar1pUZzYgCtoydUA=;
        b=OCK4COw2L7bXk5DhkLJW4YRoC/XFmR68lp6meIDlwZyZh1tQk3erDrvVG+q16O/CA7
         3tT7+MTmy6ngGhaLFNiP1SMxQ1hG8f95GvglqcgI5ir/50HAaO7YHBfOu62xwnT94BlM
         C/AA1dlWK9FtL5o10Sk7jPBWXQuZ7Il4xgjHBX4T1So28VMkbDzjnwL+aew660TMxZQ6
         Igw8jIFBlhCbfJ1dsBQvBIzSK5DscYRqmSKF22AukXvw0nHTaSjnnMu9OZLk7A4+fr8f
         hQ8YmS2uDgXOBkG13iq5SezL4ndLp8TQ/FVxOwU7rArxKO2jauNXFueFJeVgcHAw9LP/
         4Z0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693942037; x=1694546837;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TGSq0Ro751IP9VfAZLxrcnAKr41ar1pUZzYgCtoydUA=;
        b=eOBZbU8Vuu2vM3IwYJWyu0yCcZmUVUrjIHOg1PJ5UphWu6hVzPVuInaWuDKUeWel8E
         HUHTX5TKoxbujtwaujNyP8t5fAI91IYjWu3l7nNXnubmBAJSMwiKdMcdyLCvCRLD/JcQ
         aJXJLc355bXdVf+cK68yFoI/PrhsqKTVXeqidieIPxkiTbmDOmUmw3lnmeHqnFkV7C1p
         5eCRuZfQAImsyTHbvYcZpCHu8xZ/GKBJF4CvFPiStBub/l2tf8tzxzExmR7afSV/BsrJ
         Ac5WhAFBa/vF3V2VgRLjMp4sok/e7cLbtLNSUZv7S9V0zgyldqUMZ+3X43onFXS9W5Yw
         hJsA==
X-Gm-Message-State: AOJu0YyQ4MUcRbgJKN1s5rzet7p+oE1tNDScOylW7Gxlei494VwHV/rT
        7ZQRCS8x0m9bMfw5C9Nnw6ZWaUh1hv0=
X-Google-Smtp-Source: AGHT+IEudJr3ov3CIS6glyQmC/nwUysY2Kx7RcGQbGbojNPLSjkbpb4CfpTrE8RLdcb+yjGw7T6RZQ3ra8o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:24cb:0:b0:d7b:8acc:beb8 with SMTP id
 k194-20020a2524cb000000b00d7b8accbeb8mr321310ybk.2.1693942037491; Tue, 05 Sep
 2023 12:27:17 -0700 (PDT)
Date:   Tue, 5 Sep 2023 19:27:15 +0000
In-Reply-To: <NOTSPohUo5EZSaOrRTX88K-vU9QJqeV2Vqti75bEwTpckXBiudKyWw97EDAbgp9ODnk8-lCVBVNCYdd7YygWY5S2n-Yoz_BiJ13DeNLEItI=@protonmail.com>
Mime-Version: 1.0
References: <NOTSPohUo5EZSaOrRTX88K-vU9QJqeV2Vqti75bEwTpckXBiudKyWw97EDAbgp9ODnk8-lCVBVNCYdd7YygWY5S2n-Yoz_BiJ13DeNLEItI=@protonmail.com>
Message-ID: <ZPeBE5aZqLwdnspl@google.com>
Subject: Re: [PATCH] kvm ignores ignore_msrs=1 VETO for some MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Jari Ruusu <jariruusu@protonmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 05, 2023, Jari Ruusu wrote:
> This problem is old regression. This type of setup worked fine on older
> linux-4.x hosts but fails on linux-5.10.x hosts. I remember seeing this fail
> as early as year 2021. I just haven't had time to look at it earlier.
> 
> Relevant qemu parameters:
>   -machine pc-1.0
>   -cpu Skylake-Server-IBRS,+md-clear,+pcid,+invpcid,+ssbd,+clflushopt
>   -enable-kvm
> If I change CPU model to "Nehalem" then it boots OK.
> 
> KVM stuff is built-in to host kernel and my kernel boot parameters include:
>   kvm-intel.ept=0 l1tf=off kvm.ignore_msrs=1
> so any invalid RDMSR reads should not fail because of ignore_msrs=1 VETO,
> but at least MSR_IA32_PERF_CAPABILITIES RDMSR read does indeed fail.

No, as documented in Documentation/admin-guide/kernel-parameters.txt, ignore_msrs
only applies to _unhandled_ MSRs, i.e. MSRs that KVM knows nothing about.

  kvm.ignore_msrs=[KVM] Ignore guest accesses to unhandled MSRs.

The reason this introduces a failure in your setup is that KVM didn't have any
handling for MSR_IA32_PERF_CAPABILITIES prior to commit 27461da31089 ("KVM: x86/pmu:
Support full width counting"). 

> Full C-language source file can be viewed here:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/arch/x86/kernel/cpu/perf_event_intel.c?h=linux-3.10.y#n2023
> 
> My understanding of this failure is that it is combination of many factors,
> including:
> 
> 1) Qemu version is old
> 2) Qemu guest CPUID flags may be "Frankenstein" 

It's a bit Frankenstein, but architecturally it's completely valid.

> 3) old linux-3.10.108 x86_64 kernel may be doing something questionable

The guest kernel is the real culprit.  It is assuming that an MSR exists based on
the PMU version instead of checking the CPUID feature flag that enumerates the
existence of the MSR.

The bug was fixed almost a decade ago, but that fix obviously didn't make it to
the 3.10 kernel.

commit c9b08884c9c98929ec2d8abafd78e89062d01ee7
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Mon Feb 3 14:29:03 2014 +0100

    perf/x86: Correctly use FEATURE_PDCM
    
    The current code simply assumes Intel Arch PerfMon v2+ to have
    the IA32_PERF_CAPABILITIES MSR; the SDM specifies that we should check
    CPUID[1].ECX[15] (aka, FEATURE_PDCM) instead.
    
    This was found by KVM which implements v2+ but didn't provide the
    capabilities MSR. Change the code to DTRT; KVM will also implement the
    MSR and return 0.


> 4) newer host linux KVM is not always honoring RDMSR ignore_msrs=1 VETO
> 
> My reading linux-5.10.194 kernel source identified following questionable
> handling ignore_msrs=1 VETO. This same problem appears to be present in
> recently released linux-6.5 too, but so far I have not tested this
> with linux-6.5.x host kernels yet.

While this is arguably a regression, this isn't going to be addressed in KVM.

ignore_msrs is off by default, and is explicitly documented as applying only to
unhandled MSRs.  The documentation could certainly do a better job of explaining
the potential pitfalls and long-term consequences of enabling ignore_msrs, but
hack-a-fixing this one MSR to fudge around a guest bug isn't going to happen,
and a broad "ignore all RDMSR/WRMSR faults" knob would likely break other guests,
e.g. would make it impossible to probe for MSR existence, and so such a knob would
be unusable.

As for working around this in your setup, assuming you don't actually need a
virtual PMU in the guest, the simplest workaround would be to turn off vPMU
support in KVM, i.e. boot with kvm.enable_pmu=0.  That _should_ cause QEMU to not
advertise a PMU to the guest.  Alternatively, if supported by QEMU, you could try
enumerating a version 1 vPMU to the guest.
