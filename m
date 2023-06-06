Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19327250E4
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 01:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239862AbjFFXkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 19:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239658AbjFFXko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 19:40:44 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C580A170B
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 16:40:42 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5693861875fso101740087b3.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 16:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686094842; x=1688686842;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ub7lhejOg/lDdTY+htbdM3tFIdBZH/I/WvN3Xdx1uV0=;
        b=x3+7d7dOxbuMsgi4YuWRxiMypQc2TrTU2D9YB3UiXYC+EUc7Y9pseC434rQBLcpXAL
         GdebpzGU+Ppi+3pg/sPm2opKG0AIj3TpKgdafc0t7y19pnJwnX6lnXEW0+OoUhdwqDwE
         Z4ysfR37q5DV4NBHLSUb535QOnfJ37VpXUT0s/YKbyEmYt6p3WurjeOIxM5TXMaanlts
         Dbq1Z9rC6GiKn/Ofl3HttKVh+kDIVJTeUF0OknTzUCQHCr+pmySor7NykqACcPQcQ0xy
         DY4ddSj00fmaOy6VUmaFhckuswO05xoX5292LnCzhz9+pCxJfgV+HS3Cr0N3cRaGlaIo
         JIXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686094842; x=1688686842;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ub7lhejOg/lDdTY+htbdM3tFIdBZH/I/WvN3Xdx1uV0=;
        b=CbYDyY0PLu4+dvHR2/mxt1DbhSVJv53et5jO7bPQYNgQmGMVN8YDrzUJYM/vVmUgIe
         +OoKhH6qX7x5cE36m3GwM+63Y7qORWuDhMsNuSgfpZJxGEbF3Rq7GxojJbooT9fqqKUk
         4lhW0EClwl049p9LLbVEg32hj0dMObhk9AS2LooirRoYaLgP+OqQPSeMhL6l+eS2ICoc
         zUMtzOU+o5FSgDkhr4HoKTNx/xFuc4v/KQx8Unr+U27sjLVoq8MCO5vOVdsjngnHMD2z
         8C02g9ECM/JKWMU9Utilln6HzShsCutRV6fWo4XzKr1AjR+bM09dP69aEpts90tbSj+q
         7g/w==
X-Gm-Message-State: AC+VfDw2sPA00STX1OHxu1NTVaJc67ayo4tImQOEKUAYMi1M56grA56W
        aBBWRr47jnetXPmAqL1g9y+k95M+EMM=
X-Google-Smtp-Source: ACHHUZ4t4b8ZaKk9b7bDtFeK18uGx3qsOG0WbmPPzW7N60k5P+UvNaqfyxvCrb9uJeLbM2s4DI7dL+WqIoo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:d007:0:b0:568:a244:d8e5 with SMTP id
 v7-20020a81d007000000b00568a244d8e5mr1898740ywi.9.1686094841928; Tue, 06 Jun
 2023 16:40:41 -0700 (PDT)
Date:   Tue, 6 Jun 2023 16:40:40 -0700
In-Reply-To: <8AE71A62-1BE3-4D6F-B57C-B5FCEA93169F@nutanix.com>
Mime-Version: 1.0
References: <20230530200152.18961-1-jon@nutanix.com> <2a6502e3-ba87-0355-af09-825e8467b81f@intel.com>
 <F4AFC5EE-9967-4117-BA85-ED82C106575C@nutanix.com> <ZHd2P6D142rCByrm@google.com>
 <E17EFDD7-C54A-4532-B1D3-D567557FC54B@nutanix.com> <ZHermsSGQBcDD07R@google.com>
 <CBFC095A-10D1-4925-9F28-DEDEBBB38EF8@nutanix.com> <8AE71A62-1BE3-4D6F-B57C-B5FCEA93169F@nutanix.com>
Message-ID: <ZH/D+JP2OGFtCUBy@google.com>
Subject: Re: [PATCH] x86/fpu/xstate: clear XSAVE features if DISABLED_MASK set
From:   Sean Christopherson <seanjc@google.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Kyle Huey <me@kylehuey.com>,
        "neelnatu@google.com" <neelnatu@google.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023, Jon Kohler wrote:
> > On May 31, 2023, at 5:09 PM, Jon Kohler <jon@nutanix.com> wrote:
> >> The CPUID bits that enumerate support for a feature are independent fr=
om the CPUID
> >> bits that enumerate what XCR0 bits are supported, i.e. what features c=
an be saved
> >> and restored via XSAVE/XRSTOR.
> >>=20
> >> KVM does mostly account for host XCR0, but in a very ad hoc way.  E.g.=
 MPX is
> >> handled by manually checking host XCR0.
> >>=20
> >> 	if (kvm_mpx_supported())
> >> 		kvm_cpu_cap_check_and_set(X86_FEATURE_MPX);
> >>=20
> >> PKU manually checks too, but indirectly by looking at whether or not t=
he kernel
> >> has enabled CR4.OSPKE.
> >>=20
> >> 	if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
> >> 		kvm_cpu_cap_clear(X86_FEATURE_PKU);
> >>=20
> >> But unless I'm missing something, the various AVX and AMX bits rely so=
lely on
> >> boot_cpu_data, i.e. would break if someone added CONFIG_X86_AVX or CON=
FIG_X86_AMX.
> >=20
> > What if we simply moved static unsigned short xsave_cpuid_features[] =
=E2=80=A6 into
> > xstate.h, which is already included in arch/x86/kvm/cpuid.c, and do
> > something similar to what I=E2=80=99m proposing in this patch already
> >=20
> > This would future proof such breakages I=E2=80=99d imagine?
> >=20
> > void kvm_set_cpu_caps(void)
> > {
> > ...
> >    /*
> >     * Clear CPUID for XSAVE features that are disabled.
> >     */
> >    for (i =3D 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
> >        unsigned short cid =3D xsave_cpuid_features[i];
> >=20
> >        /* Careful: X86_FEATURE_FPU is 0! */
> >        if ((i !=3D XFEATURE_FP && !cid) || !boot_cpu_has(cid) ||
> >            !cpu_feature_enabled(cid))
> >            kvm_cpu_cap_clear(cid);
> >    }
> > =E2=80=A6
> > }
> >=20
>=20
> Sean - following up on this rough idea code above, wanted to validate tha=
t
> this was the direction you were thinking of having kvm_set_cpu_caps() cle=
ar
> caps when a particular xsave feature was disabled?

Ya, more or or less.  But for KVM, that should be kvm_cpu_cap_has(), not bo=
ot_cpu_has().
And then I think KVM could actually WARN on a feature being disabled, i.e. =
put up
a tripwire to detect if things change in the future and the kernel lets the=
 user
disable a feature that KVM wants to expose to a guest.

Side topic, I find the "cid" nomenclature super confusing, and the establis=
hed
name in KVM is x86_feature.

Something like this?

	for (i =3D 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
		unsigned int x86_feature =3D xsave_cpuid_features[i];

		if (i !=3D XFEATURE_FP && !x86_feature)
			continue;

		if (!kvm_cpu_cap_has(x86_feature))
			continue;

		if (WARN_ON_ONCE(!cpu_feature_enabled(x86_feature)))
			kvm_cpu_cap_clear(x86_feature);
	}
