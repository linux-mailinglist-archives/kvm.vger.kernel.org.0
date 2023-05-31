Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8058471875D
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 18:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjEaQbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 12:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjEaQbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 12:31:00 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CC811F
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 09:30:58 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-556011695d1so105876827b3.1
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 09:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685550657; x=1688142657;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4oMPwuBewXzucRhAy2k91jt6FR1Q3W1PQo5GZNd6lqM=;
        b=ryeCZ321lBNpiYoS40S71CMHh8oGv0krJKIZpmIGsRIe+xGkwcAHYnzd9/aT6BnPjG
         gaiFm7JRSiNpBjcX+wc1xbIiR6Nv5swrk3nawefNF3b/5dbY6OGYqJ+F2BxfxTYUyd6v
         D6mf8CgTUcPhO15w70n9pgY36xb5L2RSXnfymapJLr3enxB9Cwr7TCYP9QAM3Wx4enBT
         cmDWCxlbMpEaj0zNJ5C992qVuWpncecoglFbvm+Hj4HDMi8KYlgoqpBM2QKVwxk6ui15
         qATljkSrWZcTGytOWYTwM9y7jUIFK9JzCGI4og+UAoZP4VUJmQk25c/1HVxPYepTTTIR
         FV/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685550657; x=1688142657;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4oMPwuBewXzucRhAy2k91jt6FR1Q3W1PQo5GZNd6lqM=;
        b=bEcKW8WAd8Zzf011klCDLVfcJhuFjqK3pzI/RKn0hadvXBjTIiKL14+I3ostO28m6V
         nfY1L7ATfQrlLDMVdEfhsIv11OO0uoAAOsmKvjUdQBW96alMTtPB5zClPRhQgf/6NffL
         5mng8/pQqxse5kY63pmXCB4a63hDEcqfi8BUoOnJyS1ZFFLIrLGzHQZ2NBQVX78TtqtQ
         5y6a5flccUgDlQvvGltRbBHaz8LgMQSXhqc3XwlS4ocbomXlCrNAy7CWA2ghSS3ze75R
         n3tMpYzh0OTlyF3MkNEkqGABTxWh7t6Hi+FKARF3RBYuZvwT8+a7Ph39Sip8BC76/fk0
         6V7w==
X-Gm-Message-State: AC+VfDwHWHNRA5GAawsyf9q9FsaSk1BfNrDY1JG0413jX6hQK5/JlbTD
        54HXvUkaNgVGZFxeugTNlxOnbvdZKIc=
X-Google-Smtp-Source: ACHHUZ6X8s1Ux+vAT7l47i65NzVwjyLzkDLJAboaHZnpw10xH1dcOU12nASDui2gP5eCl+mciulXyOP22sY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b70c:0:b0:561:8e86:9818 with SMTP id
 v12-20020a81b70c000000b005618e869818mr3513805ywh.7.1685550657211; Wed, 31 May
 2023 09:30:57 -0700 (PDT)
Date:   Wed, 31 May 2023 09:30:55 -0700
In-Reply-To: <F4AFC5EE-9967-4117-BA85-ED82C106575C@nutanix.com>
Mime-Version: 1.0
References: <20230530200152.18961-1-jon@nutanix.com> <2a6502e3-ba87-0355-af09-825e8467b81f@intel.com>
 <F4AFC5EE-9967-4117-BA85-ED82C106575C@nutanix.com>
Message-ID: <ZHd2P6D142rCByrm@google.com>
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

On Wed, May 31, 2023, Jon Kohler wrote:
>=20
> > On May 30, 2023, at 6:22 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> >=20
> > On 5/30/23 13:01, Jon Kohler wrote:
> > Is that the only problem?  kvm_load_guest_xsave_state() seems to have
> > some #ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS code and I can't
> > imagine that KVM guests can even use PKRU if this code is compiled out.

...

> >> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate=
.c
> >> index 0bab497c9436..211ef82b53e3 100644
> >> --- a/arch/x86/kernel/fpu/xstate.c
> >> +++ b/arch/x86/kernel/fpu/xstate.c
> >> @@ -798,7 +798,8 @@ void __init fpu__init_system_xstate(unsigned int l=
egacy_size)
> >> 		unsigned short cid =3D xsave_cpuid_features[i];
> >>=20
> >> 		/* Careful: X86_FEATURE_FPU is 0! */
> >> -		if ((i !=3D XFEATURE_FP && !cid) || !boot_cpu_has(cid))
> >> +		if ((i !=3D XFEATURE_FP && !cid) || !boot_cpu_has(cid) ||
> >> +		    DISABLED_MASK_BIT_SET(cid))
> >> 			fpu_kernel_cfg.max_features &=3D ~BIT_ULL(i);
> >> 	}
> >=20
> > I _think_ I'd rather this just be cpu_feature_enabled(cid) rather than
> > using DISABLED_MASK_BIT_SET() directly.

+1, xstate.c uses cpu_feature_enabled() all over the place, and IMO effecti=
vely
open coding cpu_feature_enabled() yields less intuitive code.

And on the KVM side, we can and should replace the #ifdef with cpu_feature_=
enabled()
(I'll post a patch), as modern compilers are clever enough to completely op=
timize
out the code when CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=3Dn.  At that poi=
nt, using
cpu_feature_enabled() in both KVM and xstate.c will provide a nice bit of s=
ymmetry.

Caveat #1: cpu_feature_enabled() has a flaw that's relevant to this code: i=
n the
unlikely scenario that the compiler doesn't resolve "cid" to a compile-time
constant value, cpu_feature_enabled() won't query DISABLED_MASK_BIT_SET(). =
 I don't
see any other use of cpu_feature_enabled() without a hardcoded X86_FEATURE_=
*, and
the below compiles with my config, so I think/hope we can just require a co=
mpile-time
constant when using cpu_feature_enabled().

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufe=
ature.h
index ce0c8f7d3218..886200fbf8d9 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -141,8 +141,11 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
  * supporting a possible guest feature where host support for it
  * is not relevant.
  */
-#define cpu_feature_enabled(bit)       \
-       (__builtin_constant_p(bit) && DISABLED_MASK_BIT_SET(bit) ? 0 : stat=
ic_cpu_has(bit))
+#define cpu_feature_enabled(bit)                               \
+({                                                             \
+       BUILD_BUG_ON(!__builtin_constant_p(bit));               \
+       DISABLED_MASK_BIT_SET(bit) ? 0 : static_cpu_has(bit);   \
+})
=20
 #define boot_cpu_has(bit)      cpu_has(&boot_cpu_data, bit)
=20
Caveat #2: Using cpu_feature_enabled() could subtly break KVM, as KVM adver=
tises
support for features based on boot_cpu_data.  E.g. if a feature were disabl=
ed by
Kconfig but present in hardware, KVM would allow the guest to use the featu=
re
without properly context switching the data.  PKU isn't problematic because=
 KVM
explicitly gates PKU on boot_cpu_has(X86_FEATURE_OSPKE), but KVM learned th=
at
lesson the hard way (see commit c469268cd523, "KVM: x86: block guest protec=
tion
keys unless the host has them enabled").  Exposing a feature that's disable=
d in
the host isn't completely absurd, e.g. KVM already effectively does this fo=
r MPX.
The only reason using cpu_feature_enabled() wouldn't be problematic for MPX=
 is
because there's no longer a Kconfig for MPX.

I'm totally ok gating xfeature bits on cpu_feature_enabled(), but there sho=
uld be
a prep patch for KVM to clear features bits in kvm_cpu_caps if the correspo=
nding
XCR0/XSS bit is not set in the host.  If KVM ever wants to expose an xstate=
 feature
(other than MPX) that's disabled in the host, then we can revisit
fpu__init_system_xstate().  But we need to ensure the "failure" mode is tha=
t
KVM doesn't advertise the feature, as opposed to advertising a feature with=
out
without context switching its data.

> > But, I guess this probably also isn't a big deal for _most_ people.  An=
y
> > sane distro kernel will just set CONFIG_X86_INTEL_MEMORY_PROTECTION_KEY=
S
> > since it's pretty widespread on modern CPUs and works across Intel and
> > AMD now.
>=20
> Ack, I=E2=80=99m using PKU as the key example here, but looking forward t=
his is more of a
> correctness thing than anything else. If for any reason, any xsave featur=
e is disabled
> In the way that PKU is disabled, it will slip thru the cracks.

I'd be careful about billing this as a correctness thing.  See above.
