Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E59070CF9D
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 02:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234858AbjEWAkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 20:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbjEWAGa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 20:06:30 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D0519B3
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 16:39:59 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-561f201a646so103572627b3.1
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 16:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684798798; x=1687390798;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HZenqV6ENOtdC3IAYPpjXT1tsTf7oZsrQ2divi+KMXw=;
        b=7qIhMZnB7ip/AwQj7RBVQrlgUH2zld3NyBPTfc2ZhknKV+9SKieqPYkhSRXPfrdYNK
         lETIMEUrp7RgmJPtj9WVYbx7I4BXQ278tjcPuiu+FGcRY6xmymzspVAnnKbxE3rKaMn1
         HFO9p6ZjJAKrMn1khMbP9wGgh4OEx72UOWCuEBLz0OAApkL9a3q+uJFZnjbZ6Vw9TzJ9
         c4zFx0kIxFg1vmbFHVHhw+Y26OuEXiZrFU2/yZjCZObMu2ss0FVC50uH0XV/X+RUtWqp
         cVBYea8w1T8ZYaCCY0NDKZMuxNezsnnaTT3+jKpTwgs0NyLZj1OZWJGQgr7w4WsgmuWg
         HBfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684798798; x=1687390798;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HZenqV6ENOtdC3IAYPpjXT1tsTf7oZsrQ2divi+KMXw=;
        b=AetFatE+mlqRtCCoSqj5XUX5DJdY+/H0VXQU2xl9mCPYr4V7MfW43/a+0VNEvTxTFR
         iB3MOSqZ+yXAoFz/rnssoXm8AnBwtwoG1TMHAdsyZKwCRy/cFckDn9XcP/I9tbvKKYfJ
         ZUbkyoTyy0edLJxVTb3IKAJv8HO8D6ywyNamBwPmadQpo1wtP7ISum6Q6XwNrU35X5JM
         dhs8CF+rgoWeuQrEL3A3aYwyCOybRd5m4yelGW17n6H0Awix+uAc/M3tF90QtR8uDHWA
         Kkc7vMBtn+dAbarp92MDbhCoNEVPNemhwNa8tUSEYcu0/hD7SfpE4q9xa+Zw0YcDN/cF
         Wlcg==
X-Gm-Message-State: AC+VfDyhAbrzxIMzVwQW+kHt4ied7KqfyNstcM7BKxNrljHQfhnZC7Op
        4lket7AJwjhp2yNfzrVE5jYlMau4Te0=
X-Google-Smtp-Source: ACHHUZ6K4SYJn9KKrPTSI2xtIW00BVoWY/F51nj6TfhBx+vxPeCHJpWo3DLWtC1uIz5ry0O5Sd2squFPRO8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:d80d:0:b0:561:61e9:ab39 with SMTP id
 d13-20020a81d80d000000b0056161e9ab39mr7595291ywj.8.1684798798454; Mon, 22 May
 2023 16:39:58 -0700 (PDT)
Date:   Mon, 22 May 2023 16:39:57 -0700
In-Reply-To: <20230411125718.2297768-6-aik@amd.com>
Mime-Version: 1.0
References: <20230411125718.2297768-1-aik@amd.com> <20230411125718.2297768-6-aik@amd.com>
Message-ID: <ZGv9Td4p1vtXC0Hy@google.com>
Subject: Re: [PATCH kernel v5 5/6] KVM: SEV: Enable data breakpoints in SEV-ES
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>
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

On Tue, Apr 11, 2023, Alexey Kardashevskiy wrote:
> Prior to SEV-ES, KVM saved/restored host debug registers upon switching
> to/from a VM. Changing those registers inside a running SEV VM
> triggered #VMEXIT to KVM.

Please, please don't make it sound like some behavior is *the* one and only=
 behavior.
*KVM* *chooses* to intercept debug register accesses.  Though I would omit =
this
paragraph (and largely the next) entirely, IMO it's safe to assume the read=
er has
a basic understanding of how KVM deals with DRs and #DBs.=20

> SEV-ES added encrypted state (ES) which uses an encrypted page
> for the VM state (VMSA). The hardware saves/restores certain registers
> on VMRUN/VMEXIT according to a swap type (A, B, C), see
> "Table B-3. Swap Types" in the AMD Architecture Programmer=E2=80=99s Manu=
al
> volume 2.
>=20
> The DR6 and DR7 registers have always been swapped as Type A for SEV-ES

Please rewrite this to just state what the behavior is instead of "Type A" =
vs.
"Type B".  Outside of AMD, the "type a/b/c" stuff isn't anywhere near ubiqu=
itous
enough to justify obfuscating super simple concepts.

Actually, this feature really has nothing to do with Type A vs. Type B, sin=
ce
that's purely about host state.  I assume the switch from Type A to Type B =
is a
side effect, or an opportunistic optimization?

Regardless, something like this is a lot easier for a human to read.  It's =
easy
enough to find DebugSwap in the APM (literally took me longer to find my co=
py of
the PDF).

  Add support for "DebugSwap for SEV-ES guests", which provides support
  for swapping DR[0-3] and DR[0-3]_ADDR_MASK on VMRUN and VMEXIT, i.e.
  allows KVM to expose debug capabilities to SEV-ES guests.  Without
  DebugSwap support, the CPU doesn't save/load _guest_ debug registers,
  and KVM cannot manually context switch guest DRs due the VMSA being
  encrypted.

  Enable DebugSwap if and only if the CPU also supports NoNestedDataBp,
  which causes the CPU to ignore nested #DBs, i.e. #DBs that occur when
  vectoring a #DB.  Without NoNestedDataBp, a malicious guest can DoS
  the host by putting the CPU into an infinite loop of vectoring #DBs
  (see https://bugzilla.redhat.com/show_bug.cgi?id=3D1278496)

  Set the features bit in sev_es_sync_vmsa() which is the last point
  when VMSA is not encrypted yet as sev_(es_)init_vmcb() (where the most
  init happens) is called not only when VCPU is initialized but also on
  intrahost migration when VMSA is encrypted.

> guests, but a new feature is available, identified via
> CPUID Fn8000001F_EAX[14] "DebugSwap for SEV-ES guests", that provides
> support for swapping additional debug registers. DR[0-3] and
> DR[0-3]_ADDR_MASK are swapped as Type B when SEV_FEATURES[5] (DebugSwap)
> is set.
>=20
> Enable DebugSwap for a VMSA but only do so if CPUID Fn80000021_EAX[0]
> ("NoNestedDataBp", "Processor ignores nested data breakpoints") is
> supported by the SOC as otherwise a malicious SEV-ES guest can set up
> data breakpoints on the #DB IDT entry/stack and cause an infinite loop.
> Set the features bit in sev_es_sync_vmsa() which is the last point
> when VMSA is not encrypted yet as sev_(es_)init_vmcb() (where the most
> init happens) is called not only when VCPU is initialized but also on
> intrahost migration when VMSA is encrypted.
>=20
> Eliminate DR7 and #DB intercepts as:
> - they are not needed when DebugSwap is supported;

"not needed" isn't sufficient justification.  KVM doesn't strictly need to =
do a
lot of things, but does them anyways for a variety of reasons.  E.g. #DB in=
tercept
is also not needed when NoNestedDataBp is supported and vcpu->guest_debug=
=3D=3D0, i.e.
this should clarify why KVM doesn't simply disable #DB intercepts for _all_=
 VMs
when NoNestedDataBp is support.  Presumably the answer is "because it's sim=
pler
than toggling #DB interception for guest_debug.

Actually, can't disabling #DB interception for DebugSwap SEV-ES guests be a
separate patch?  KVM can still inject #DBs for SEV-ES guests, no?

As for DR7, the real justification is that, as above, KVM can't modify gues=
t DR7,
and intercepting DR7 would completely defeat the purpose of enabling DebugS=
wap.

> - #VC for these intercepts is most likely not supported anyway and
> kills the VM.

I don't see how this is relevant or helpful.  What the guest may or may not=
 do in
response to a #VC on a DR7 write has no bearing on KVM's behavior.=20

> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---

...

> @@ -3048,6 +3066,18 @@ void sev_es_prepare_switch_to_guest(struct sev_es_=
save_area *hostsa)
> =20
>  	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
>  	hostsa->xss =3D host_xss;
> +
> +	/* The DebugSwap SEV feature does Type B swaps of DR[0-3] */

Since dangling a carrot didn't work[*], I'm going to resort to extortion :-=
)
Can you fold the below somewhere before this patch, and then tweak this com=
ment
to say something like:

	/*
	 * If DebugSwap is enabled, debug registers are loaded but NOT saved by
	 * the CPU (Type-B).  If DebugSwap is disabled/unsupported, the CPU both
	 * saves and loads debug registers (Type-A).
	 */

[*] https://lore.kernel.org/all/YzOTOzUzKPQSqURo@google.com/

--
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 22 May 2023 16:29:52 -0700
Subject: [PATCH] KVM: SVM: Rewrite sev_es_prepare_switch_to_guest()'s comme=
nt
 about swap types

Rewrite the comment(s) in sev_es_prepare_switch_to_guest() to explain the
swap types employed by the CPU for SEV-ES guests, i.e. to explain why KVM
needs to save a seemingly random subset of host state, and to provide a
decoder for the APM's Type-A/B/C terminology.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 69ae5e1b3120..1e0e9b08e491 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3017,19 +3017,24 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
 {
 	/*
-	 * As an SEV-ES guest, hardware will restore the host state on VMEXIT,
-	 * of which one step is to perform a VMLOAD.  KVM performs the
-	 * corresponding VMSAVE in svm_prepare_guest_switch for both
-	 * traditional and SEV-ES guests.
+	 * All host state for SEV-ES guests is categorized into three swap types
+	 * based on how it is handled by hardware during a world switch:
+	 *
+	 * A: VMRUN:   Host state saved in host save area
+	 *    VMEXIT:  Host state loaded from host save area
+	 *
+	 * B: VMRUN:   Host state _NOT_ saved in host save area
+	 *    VMEXIT:  Host state loaded from host save area
+	 *
+	 * C: VMRUN:   Host state _NOT_ saved in host save area
+	 *    VMEXIT:  Host state initialized to default(reset) values
+	 *
+	 * Manually save type-B state, i.e. state that is loaded by VMEXIT but
+	 * isn't saved by VMRUN, that isn't already saved by VMSAVE (performed
+	 * by common SVM code).
 	 */
-
-	/* XCR0 is restored on VMEXIT, save the current host value */
 	hostsa->xcr0 =3D xgetbv(XCR_XFEATURE_ENABLED_MASK);
-
-	/* PKRU is restored on VMEXIT, save the current host value */
 	hostsa->pkru =3D read_pkru();
-
-	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
 	hostsa->xss =3D host_xss;
 }
=20

base-commit: 39428f6ea9eace95011681628717062ff7f5eb5f
--=20
