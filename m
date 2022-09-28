Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7C35EEA29
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 01:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbiI1XhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 19:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiI1Xg7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 19:36:59 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0095AEFA6B
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 16:36:57 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 128-20020a630486000000b00435b18f71b3so8158826pge.19
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 16:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date;
        bh=RqoAVJIu9tqtmpKZNpI/BHt+/7I1Bc9qHQhBKAXmIZs=;
        b=geCwhwKniW4WiaKuNxDRSvK3Jt1s0s48k2OufYpAejo+Vgyt7nRLhFG0ppsAhp8ICq
         wsvFuU6ir82tglTOfSMYPJeUeWkc4ncDaarfc+/J9tseBByTxM4GdWPixtxQwEbW30jN
         08tk6GeOoFGts6ItCSRwFx56gGnFKxtTitOjEOd15kC3H3XezyhvUf27ctEWz5U2uc9R
         3gp2W1HDRBFRKprn8icIeEbAZXWha/W/rD1VBi3QrVHi/zz4TMi9dzs/pRkXAdltTp0O
         FeokPRJ6SjyBfSvjEVedMsQKeLB81y5iqwCKGgU+gdtKo/0dQ6VA4NaoIICN9s2aIGGY
         VB8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date;
        bh=RqoAVJIu9tqtmpKZNpI/BHt+/7I1Bc9qHQhBKAXmIZs=;
        b=LRsubcvwSVXHfx9L3U9yPwQHz+JMtVsMfyvjGPS6vmzX9t7+sXCYad4CEX+uvVqrj/
         bmbROFb5/XfGiYLBOsC468vRRH0ZP2YLTB9o/XWfeMH68Ofkk85B4LIV3NhByhVQ//mB
         v9nGMG1jKzZXJFDekrIoY7CYqdt5lzJJ+mwfX0wT2FPEJI/XKMvyqjKwLiVxWDj76Gmm
         sOPnrUdf5qYNvy/MiPx28nlJdZPIUvgEwgVXAh6aA6S+2mWIXOhWCTJgk9hC+KeHFH3M
         LLrdrIVgYr99xyVfdDM3gppnX7SY+dVYJ3VGadxk4qaGt1f3coqH3YOk9PoNAybnPKl4
         z2ew==
X-Gm-Message-State: ACrzQf0gd8Ah7dkBp6qpU/qe0b2fcMN28KXsv/8Lnj7k+qzZfR6UTWRE
        rGtATLB8dWFQjAesWK2wFltmzkTeo5w=
X-Google-Smtp-Source: AMsMyM5nq0iwbPWe9edgvHcS5uGJB+9kwTTB1rZPj1UIN7KytY48ps67xAOgCuIuxrh3rOd0Cx/PvOTX9PA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:784d:b0:178:6946:3ff7 with SMTP id
 e13-20020a170902784d00b0017869463ff7mr424107pln.133.1664408217592; Wed, 28
 Sep 2022 16:36:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 28 Sep 2022 23:36:47 +0000
In-Reply-To: <20220928233652.783504-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220928233652.783504-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220928233652.783504-3-seanjc@google.com>
Subject: [PATCH v2 2/7] KVM: selftests: Compare insn opcodes directly in fix_hypercall_test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Directly compare the expected versus observed hypercall instructions when
verifying that KVM patched in the native hypercall (FIX_HYPERCALL_INSN
quirk enabled).  gcc rightly complains that doing a 4-byte memcpy() with
an "unsigned char" as the source generates an out-of-bounds accesses.

Alternatively, "exp" and "obs" could be declared as 3-byte arrays, but
there's no known reason to copy locally instead of comparing directly.

In function =E2=80=98assert_hypercall_insn=E2=80=99,
    inlined from =E2=80=98guest_main=E2=80=99 at x86_64/fix_hypercall_test.=
c:91:2:
x86_64/fix_hypercall_test.c:63:9: error: array subscript =E2=80=98unsigned =
int[0]=E2=80=99
 is partly outside array bounds of =E2=80=98unsigned char[1]=E2=80=99 [-Wer=
ror=3Darray-bounds]
   63 |         memcpy(&exp, exp_insn, sizeof(exp));
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
x86_64/fix_hypercall_test.c: In function =E2=80=98guest_main=E2=80=99:
x86_64/fix_hypercall_test.c:42:22: note: object =E2=80=98vmx_hypercall_insn=
=E2=80=99 of size 1
   42 | extern unsigned char vmx_hypercall_insn;
      |                      ^~~~~~~~~~~~~~~~~~
x86_64/fix_hypercall_test.c:25:22: note: object =E2=80=98svm_hypercall_insn=
=E2=80=99 of size 1
   25 | extern unsigned char svm_hypercall_insn;
      |                      ^~~~~~~~~~~~~~~~~~
In function =E2=80=98assert_hypercall_insn=E2=80=99,
    inlined from =E2=80=98guest_main=E2=80=99 at x86_64/fix_hypercall_test.=
c:91:2:
x86_64/fix_hypercall_test.c:64:9: error: array subscript =E2=80=98unsigned =
int[0]=E2=80=99
 is partly outside array bounds of =E2=80=98unsigned char[1]=E2=80=99 [-Wer=
ror=3Darray-bounds]
   64 |         memcpy(&obs, obs_insn, sizeof(obs));
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
x86_64/fix_hypercall_test.c: In function =E2=80=98guest_main=E2=80=99:
x86_64/fix_hypercall_test.c:25:22: note: object =E2=80=98svm_hypercall_insn=
=E2=80=99 of size 1
   25 | extern unsigned char svm_hypercall_insn;
      |                      ^~~~~~~~~~~~~~~~~~
x86_64/fix_hypercall_test.c:42:22: note: object =E2=80=98vmx_hypercall_insn=
=E2=80=99 of size 1
   42 | extern unsigned char vmx_hypercall_insn;
      |                      ^~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors
make: *** [../lib.mk:135: tools/testing/selftests/kvm/x86_64/fix_hypercall_=
test] Error 1

Fixes: 6c2fa8b20d0c ("selftests: KVM: Test KVM_X86_QUIRK_FIX_HYPERCALL_INSN=
")
Cc: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/x86_64/fix_hypercall_test.c | 34 +++++++++----------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c b/tool=
s/testing/selftests/kvm/x86_64/fix_hypercall_test.c
index b1905d280ef5..e0004bd26536 100644
--- a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
@@ -14,6 +14,9 @@
 #include "kvm_util.h"
 #include "processor.h"
=20
+/* VMCALL and VMMCALL are both 3-byte opcodes. */
+#define HYPERCALL_INSN_SIZE	3
+
 static bool ud_expected;
=20
 static void guest_ud_handler(struct ex_regs *regs)
@@ -22,7 +25,7 @@ static void guest_ud_handler(struct ex_regs *regs)
 	GUEST_DONE();
 }
=20
-extern unsigned char svm_hypercall_insn;
+extern uint8_t svm_hypercall_insn[HYPERCALL_INSN_SIZE];
 static uint64_t svm_do_sched_yield(uint8_t apic_id)
 {
 	uint64_t ret;
@@ -39,7 +42,7 @@ static uint64_t svm_do_sched_yield(uint8_t apic_id)
 	return ret;
 }
=20
-extern unsigned char vmx_hypercall_insn;
+extern uint8_t vmx_hypercall_insn[HYPERCALL_INSN_SIZE];
 static uint64_t vmx_do_sched_yield(uint8_t apic_id)
 {
 	uint64_t ret;
@@ -56,30 +59,20 @@ static uint64_t vmx_do_sched_yield(uint8_t apic_id)
 	return ret;
 }
=20
-static void assert_hypercall_insn(unsigned char *exp_insn, unsigned char *=
obs_insn)
-{
-	uint32_t exp =3D 0, obs =3D 0;
-
-	memcpy(&exp, exp_insn, sizeof(exp));
-	memcpy(&obs, obs_insn, sizeof(obs));
-
-	GUEST_ASSERT_EQ(exp, obs);
-}
-
 static void guest_main(void)
 {
-	unsigned char *native_hypercall_insn, *hypercall_insn;
+	uint8_t *native_hypercall_insn, *hypercall_insn;
 	uint8_t apic_id;
=20
 	apic_id =3D GET_APIC_ID_FIELD(xapic_read_reg(APIC_ID));
=20
 	if (is_intel_cpu()) {
-		native_hypercall_insn =3D &vmx_hypercall_insn;
-		hypercall_insn =3D &svm_hypercall_insn;
+		native_hypercall_insn =3D vmx_hypercall_insn;
+		hypercall_insn =3D svm_hypercall_insn;
 		svm_do_sched_yield(apic_id);
 	} else if (is_amd_cpu()) {
-		native_hypercall_insn =3D &svm_hypercall_insn;
-		hypercall_insn =3D &vmx_hypercall_insn;
+		native_hypercall_insn =3D svm_hypercall_insn;
+		hypercall_insn =3D vmx_hypercall_insn;
 		vmx_do_sched_yield(apic_id);
 	} else {
 		GUEST_ASSERT(0);
@@ -87,8 +80,13 @@ static void guest_main(void)
 		return;
 	}
=20
+	/*
+	 * The hypercall didn't #UD (guest_ud_handler() signals "done" if a #UD
+	 * occurs).  Verify that a #UD is NOT expected and that KVM patched in
+	 * the native hypercall.
+	 */
 	GUEST_ASSERT(!ud_expected);
-	assert_hypercall_insn(native_hypercall_insn, hypercall_insn);
+	GUEST_ASSERT(!memcmp(native_hypercall_insn, hypercall_insn, HYPERCALL_INS=
N_SIZE));
 	GUEST_DONE();
 }
=20
--=20
2.37.3.998.g577e59143f-goog

