Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003C87BA713
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 18:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjJEQuK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 12:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbjJEQsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 12:48:21 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC74369B
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 09:41:14 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-4063bfc6c03so1365e9.0
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 09:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696524073; x=1697128873; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bVX5b7Ln0UtvczEt8vQG5rg+/Wjzan8kl7gYaY7q8tA=;
        b=evctFE3hjdzmpRRsnQ8wWufAn52O5yGI4WMgdPDKyNIqgU5WxVg6VcSAxqxOilvPGw
         VNYiDvj4wWFUHZoWf7TKANYAPyO1VMbYYm5WgaS7m8kaNCozUSpG8rNxiE5yhOdVZz+R
         HDqojQNIioGLo5pOGiSeXfBaA5dwpGXNRWoojb8+w5b40hrWq+3kXGyFkzdabT40Eeh6
         a7HE3KuQCJJ6CgsMKdItjtusKvtq8Kn7p7dJweRg+h9E4/62Mjp9G0GIT17k7SrpmwnT
         iYPujh4uY98vP9Z184oEO2MFgq6AiMoMKSQolMSzeA/9VwuFQD8W55Xp/0hQU8G2ez5r
         B50A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696524073; x=1697128873;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bVX5b7Ln0UtvczEt8vQG5rg+/Wjzan8kl7gYaY7q8tA=;
        b=UmBQYp8d+9/r74eLyDwyiMOZXG6JjDK5rirMRCPnya2R8lF5g4u9enQDbywh50c9rv
         /wmmRinIJzuZO6kWGAANRePh/2N/j38fqyIChIeAUOkzW0dNO8X8s8UJOX5ubk8S8Vn1
         X+dG+IX6WYdfoMRprQT1eVa7bRzezpb2q4lCHqanjRcPGhIdZo8oMpKZv3JmQyqRTK2q
         45tUIFT79OXbmOln90t8Rqmg/vOdWodjNe/ZVZfwnCaXFXBYBF7/Aa2yRKTaWsQamTSm
         ALoYXrOmG+pLVM6x0qBW56Xi20sgye2w80YFQZr9icDsTlEqDwM0j3YcnaAVguRPR0pc
         cypg==
X-Gm-Message-State: AOJu0YwDZne3u884fur57QfD34W6Jmqp+SA7F8MlmGUmGSUPI8+4LmDC
        yK/4wEOAMoC6Ri3YpK3Ew5ByP2uH/jJwBq+mG7FELw==
X-Google-Smtp-Source: AGHT+IFaFXz7T/HQ2COJrc2QdHeMjUblqHKwQmXYnFQ3QfTU3xQ5qh9OVDCFTBaK0FgOUgsET9DCDCw08hhu5w2VbEA=
X-Received: by 2002:a1c:4b18:0:b0:405:320a:44f9 with SMTP id
 y24-20020a1c4b18000000b00405320a44f9mr69414wma.5.1696524072742; Thu, 05 Oct
 2023 09:41:12 -0700 (PDT)
MIME-Version: 1.0
References: <20231004002038.907778-1-jmattson@google.com> <01009a2a-929e-ce16-6f44-1d314e6bcba5@intel.com>
 <CALMp9eR+Qudg++J_dmY_SGbM_kr=GQcRRcjuUxtm9rfaC_qeXQ@mail.gmail.com>
 <20231004075836.GBZR0bLC/Y09sSSYWw@fat_crate.local> <CALMp9eT2qHSig-ptP461GbLSfg86aCRjoxzK9Q7dc6yXSpPn7A@mail.gmail.com>
 <ef665e55-7604-e167-7c49-739c284c248c@intel.com>
In-Reply-To: <ef665e55-7604-e167-7c49-739c284c248c@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 5 Oct 2023 09:41:00 -0700
Message-ID: <CALMp9eQL4m6PVVhntG9-RbY6w60pxka2tpCvTi01dQXPJ7QEJA@mail.gmail.com>
Subject: Re: [PATCH] x86: KVM: Add feature flag for AMD's FsGsKernelGsBaseNonSerializing
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 5, 2023 at 9:35=E2=80=AFAM Dave Hansen <dave.hansen@intel.com> =
wrote:
>
> On 10/5/23 09:22, Jim Mattson wrote:
> > On Wed, Oct 4, 2023 at 12:59=E2=80=AFAM Borislav Petkov <bp@alien8.de> =
wrote:
> >> On Tue, Oct 03, 2023 at 07:44:51PM -0700, Jim Mattson wrote:
> >>> The business of declaring breaking changes to the architectural
> >>> specification in a CPUID bit has never made much sense to me.
> >> How else should they be expressed then?
> >>
> >> In some flaky PDF which changes URLs whenever the new corporate CMS ge=
ts
> >> installed?
> >>
> >> Or we should do f/m/s matching which doesn't make any sense for VMs?
> >>
> >> When you think about it, CPUID is the best thing we have.
> > Every time a new defeature bit is introduced, it breaks existing
> > hypervisors, because no one can predict ahead of time that these bits
> > have to be passed through.
> >
> > I wonder if we could convince x86 CPU vendors to put all defeature
> > bits under a single leaf, so that we can just set the entire leaf to
> > all 1's in KVM_GET_SUPPORTED_CPUID.
>
> I hope I'm not throwing stones from a glass house here...
>
> But I'm struggling to think of cases where Intel has read-only
> "defeature bits" like this one.  There are certainly things like
> MSR_IA32_MISC_ENABLE_FAST_STRING that can be toggled, but read-only
> indicators of a departure from established architecture seems ...
> suboptimal.
>
> It's arguable that TDX changed a bunch of architecture like causing
> exceptions on CPUID and MSRs that never caused exceptions before and
> _that_ constitutes a defeature.  But that's the least of the problems
> for a TDX VM. :)
>
> (Seriously, I'm not trying to shame Intel's x86 fellow travelers here,
>  just trying to make sure I'm not missing something).

Intel's defeature bits that I know of are:

CPUID.(EAX=3D7,ECX=3D0):EBX[bit 13] (Haswell) - "Deprecates FPU CS and FPU
DS values if 1."
CPUID.(EAX=3D7,ECX=3D0):EBX[bit 6] (Skylake) - "FDP_EXCPTN_ONLY. x87 FPU
Data Pointer updated only on x87 exceptions if 1."
