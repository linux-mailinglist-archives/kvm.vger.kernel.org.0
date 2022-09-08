Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C605B2A6C
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiIHXec (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiIHXeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:34:03 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E671110F8D5
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 16:31:47 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id y17-20020a056a00181100b0053e8868496bso3084947pfa.21
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 16:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=Kq7Ss9OAHHpQQ8yCW1BLkqtyFB//rSEYUTl89YUKn0Q=;
        b=VhldITLk7+bmmPtIWtuWHo+WTW8MShqlxBof+v4NI1fiQ7tYJy9DThm2Wthntum6xd
         OX7WZbYcykUhQV/ZZ4De7i4UGVtBVXZBZuoA21BmEAUJbSKeX0Cu+DzuKjz8KobjGe0y
         SfjiTKYX9It2saLW/Pvcn+qs9Frb/0CxihE7N+6Mz9M3y/JM/MFdS12gF6yQnPpvlhoY
         WQxs1oyr3FGqderPqn/KiJbJocAQUAvGoJGkGyegUZ/fas6swqYPtvx1er3IIz/5nazu
         bVSrswS/KqcFzBiEA2Kpxftq/+vVbGQr018WTPyzCkx7lhKXG7pyhK+VSnflJ+39MGs9
         QojQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=Kq7Ss9OAHHpQQ8yCW1BLkqtyFB//rSEYUTl89YUKn0Q=;
        b=InLuxogvoKw7M3cf4aSgBYc3vLiLEwk8j5qDzO86I95rdJ3133nqjRZZOonHEulZKz
         FpZWLefcVd0asUn+lTWoXVj9djeYoGT6E2r00P0woBMgXife33u4YlWh3J/En9UE8NSZ
         rYdD0fopZRtpM9c9MlOrLsvbKyezD/VXUOlEsDTHxxqZANmqLWPB61dtpFoiaWPSxBJt
         g59fOTfGy/8Zsa9HbwQ4YWpfs/552eW+CphonDSVuGfgTE+OHE6yhafnw/jNiSK4yyIz
         bTNK3mBHKtiTcSZbbdYEylOArFiR9rU4oeAEmkLOv8ynvUpxLn735Sjp4e9Eu/S/ZzzJ
         ETXA==
X-Gm-Message-State: ACgBeo3b8hric5Dgdx0t72VvvLIt3erX90SQ8Mrfp9VHjmEZRkxGBjDm
        k3zpQcGBAfHUZ2T4wVoPvENxGv+6LXc=
X-Google-Smtp-Source: AA6agR4C0togMqSWJ7Nl/286XAZPOB2ZvwN9FkL/sTRhlyIbmFJwUqT44ToPUX3IgcTitRDZZTuhTkJl0Qw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:ed08:0:b0:537:17a6:57aa with SMTP id
 u8-20020a62ed08000000b0053717a657aamr11662126pfh.6.1662679906905; Thu, 08 Sep
 2022 16:31:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  8 Sep 2022 23:31:33 +0000
In-Reply-To: <20220908233134.3523339-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220908233134.3523339-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220908233134.3523339-5-seanjc@google.com>
Subject: [PATCH 4/5] KVM: selftests: Explicitly verify KVM doesn't patch
 hypercall if quirk==off
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
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly verify that KVM doesn't patch in the native hypercall if the
FIX_HYPERCALL_INSN quirk is disabled.  The test currently verifies that
a #UD occurred, but doesn't actually verify that no patching occurred.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/fix_hypercall_test.c | 35 ++++++++++++++-----
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
index dde97be3e719..5925da3b3648 100644
--- a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
@@ -21,8 +21,8 @@ static bool ud_expected;
 
 static void guest_ud_handler(struct ex_regs *regs)
 {
-	GUEST_ASSERT(ud_expected);
-	GUEST_DONE();
+	regs->rax = -EFAULT;
+	regs->rip += HYPERCALL_INSN_SIZE;
 }
 
 extern unsigned char svm_hypercall_insn[HYPERCALL_INSN_SIZE];
@@ -57,17 +57,18 @@ static void guest_main(void)
 {
 	unsigned char *native_hypercall_insn, *hypercall_insn;
 	uint8_t apic_id;
+	uint64_t ret;
 
 	apic_id = GET_APIC_ID_FIELD(xapic_read_reg(APIC_ID));
 
 	if (is_intel_cpu()) {
 		native_hypercall_insn = vmx_hypercall_insn;
 		hypercall_insn = svm_hypercall_insn;
-		svm_do_sched_yield(apic_id);
+		ret = svm_do_sched_yield(apic_id);
 	} else if (is_amd_cpu()) {
 		native_hypercall_insn = svm_hypercall_insn;
 		hypercall_insn = vmx_hypercall_insn;
-		vmx_do_sched_yield(apic_id);
+		ret = vmx_do_sched_yield(apic_id);
 	} else {
 		GUEST_ASSERT(0);
 		/* unreachable */
@@ -75,12 +76,28 @@ static void guest_main(void)
 	}
 
 	/*
-	 * The hypercall didn't #UD (guest_ud_handler() signals "done" if a #UD
-	 * occurs).  Verify that a #UD is NOT expected and that KVM patched in
-	 * the native hypercall.
+	 * If the quirk is disabled, verify that guest_ud_handler() "returned"
+	 * -EFAULT and that KVM did NOT patch the hypercall.  If the quirk is
+	 * enabled, verify that the hypercall succeeded and that KVM patched in
+	 * the "right" hypercall.
 	 */
-	GUEST_ASSERT(!ud_expected);
-	GUEST_ASSERT(!memcmp(native_hypercall_insn, hypercall_insn, HYPERCALL_INSN_SIZE));
+	if (ud_expected) {
+		GUEST_ASSERT(ret == (uint64_t)-EFAULT);
+
+		/*
+		 * Divergence should occur only on the last byte, as the VMCALL
+		 * (0F 01 C1) and VMMCALL (0F 01 D9) share the first two bytes.
+		 */
+		GUEST_ASSERT(!memcmp(native_hypercall_insn, hypercall_insn,
+				     HYPERCALL_INSN_SIZE - 1));
+		GUEST_ASSERT(memcmp(native_hypercall_insn, hypercall_insn,
+				    HYPERCALL_INSN_SIZE));
+	} else {
+		GUEST_ASSERT(!ret);
+		GUEST_ASSERT(!memcmp(native_hypercall_insn, hypercall_insn,
+			     HYPERCALL_INSN_SIZE));
+	}
+
 	GUEST_DONE();
 }
 
-- 
2.37.2.789.g6183377224-goog

