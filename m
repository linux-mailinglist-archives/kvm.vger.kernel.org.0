Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3699F5B2A65
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiIHXeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiIHXeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:34:02 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98577115392
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 16:31:44 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id w14-20020a170902e88e00b00177ab7a12f6so125692plg.16
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 16:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date;
        bh=Z/wAO7o0uv9mRFKbOQwdugyUqT7UTMkhxbmUHk+l8EY=;
        b=IkB3irGFigCl/eI2GfiWUAdk+jp1yryLOuRxeiDAHbAnpTZTZebSNjsIX0WwigGctR
         xldX0JihO0wwuN/pFeGk488tFXqpca88t4ssuW0VWRZVnaIGaRUk78D+BKHFAJP7ZpkT
         2ToShsCdxyy4AfUaD3Dhmitw8eInd7mORNOJqpEr4LKvW6qIr6h8fDq/qxMmzz8M2peu
         BCyVguInJOHXMuHPy7o2Nnt2tSV0rgnKFhiRTjDvB9r2HNSHpEyiPJhSSjbHGkS0Xu2m
         kK1ASu8iJKY60hRESnnyZfvFx4AMd+Q4TP8NOzzIMouKQmTbqZXqoPC/GnotaHJ1pRP8
         wZrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date;
        bh=Z/wAO7o0uv9mRFKbOQwdugyUqT7UTMkhxbmUHk+l8EY=;
        b=0gLoak0e8jy/UvGSlKUrozfe3OnDY+70d8ylp/ttlv0UO3aRnU1GBYFqC4rv31wKu4
         ycMsmqUVqDuHxN/GsOxKqlC7O/BgZsGCoxLV8p8TSceCeQqbvwwv6XLPQMHuBADQOPcP
         DBGnj0D6RLfEhEjCvn2b4E+DIF9qYIKn/o78a7gcEb6k8Uqo7nQowiR5VLn7uxHn1R+H
         j8BBMvvwJ1WbHG9HpilmycmVKc2jfrvfYRYfvBckuhf9EBb3KklZ2WZHZYmigPx+79sW
         MtPe11A3Abj/wyAKvMn4gnUSJLlcpxstkzG0nASqVihv3VctvZ4s0WVjUDPyX5OQOXs3
         32XA==
X-Gm-Message-State: ACgBeo07I/XpD8ED+9v1N2NLkZYteGpNkA7mLVuWQaXKjl4rMums28ty
        sRCsZeRfRY0OKQJ5gKdDDJbhIYclFZ4=
X-Google-Smtp-Source: AA6agR5Df/HcRg0Wq4FafCs9EFBud8rofBtdiX6Xq8TU7TScl/0Guln8a4baCGugW2ag8dwsd/7nQjN7jTs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:b4d:b0:540:cee1:657e with SMTP id
 p13-20020a056a000b4d00b00540cee1657emr2385360pfo.22.1662679903483; Thu, 08
 Sep 2022 16:31:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  8 Sep 2022 23:31:31 +0000
In-Reply-To: <20220908233134.3523339-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220908233134.3523339-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220908233134.3523339-3-seanjc@google.com>
Subject: [PATCH 2/5] KVM: selftests: Compare insn opcodes directly in fix_hypercall_test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
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
---
 .../selftests/kvm/x86_64/fix_hypercall_test.c | 32 +++++++++----------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c b/tool=
s/testing/selftests/kvm/x86_64/fix_hypercall_test.c
index b1905d280ef5..2512df357ab3 100644
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
+extern unsigned char svm_hypercall_insn[HYPERCALL_INSN_SIZE];
 static uint64_t svm_do_sched_yield(uint8_t apic_id)
 {
 	uint64_t ret;
@@ -39,7 +42,7 @@ static uint64_t svm_do_sched_yield(uint8_t apic_id)
 	return ret;
 }
=20
-extern unsigned char vmx_hypercall_insn;
+extern unsigned char vmx_hypercall_insn[HYPERCALL_INSN_SIZE];
 static uint64_t vmx_do_sched_yield(uint8_t apic_id)
 {
 	uint64_t ret;
@@ -56,16 +59,6 @@ static uint64_t vmx_do_sched_yield(uint8_t apic_id)
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
 	unsigned char *native_hypercall_insn, *hypercall_insn;
@@ -74,12 +67,12 @@ static void guest_main(void)
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
2.37.2.789.g6183377224-goog

