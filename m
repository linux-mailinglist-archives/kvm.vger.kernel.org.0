Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87022603529
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 23:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJRVqk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 17:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiJRVq2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 17:46:28 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC4BC58A1
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:46:28 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id f18-20020a170902ce9200b0017f9ac4cfb5so10565292plg.22
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GvhtGfFxm+rsEds9rZdFp4GgpBQe+Q4wuoPZu0+CC8M=;
        b=SKh7dJq7PYHjULSNJYpDRJ1XSV7cJl8xeLqAYRgiGR1RANuoAC/CETZu6TZyJFGS5L
         rnn9mbO4a3TqH3wx41sR+cR52f2HVwbwkfT7lcZbyi6+xCpuxN/PpLimPlktFW0V0uNc
         0rRMelsSQ3XaMr7hy/6O2lTpTnqmjnT6kn39vql1rqYQEUgzktuf9VgGS4wZxlyYL/pw
         WrI3cgUxCKoUMM4isIjL+aDkm2ODpiJwvYccx7oqBBm55zCpXKM3doVQSnWOamRMvmTE
         DoP4G3roOCsdwmg7vsTUyPLkG5M7aMHni2nIDsHC/7PtfPzzIIy0oPX9xUUhUPMQaNas
         CaTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GvhtGfFxm+rsEds9rZdFp4GgpBQe+Q4wuoPZu0+CC8M=;
        b=ekXIVXdXgZRO8Zvqk1Ir6t3Fk2lI2qK24cKnM+g5lhpR6eb7N+2JKs4HbMTgHfYyL6
         70na0Y+tQ5whMz1BVT9XiqlTzJ/oKfsluF8spgduyAoV+aJVE4cgwsbaRKzyxu7MhREl
         ABIhamQr/G2o8P9iXcmPMdzld4Fqz6yUcv4uJkYHPT/7100RS9ZyqlE8Lw6iWlr1DveY
         mEqcewSioE/eYJh+zgteWa35IKUOZLo7PurN1DIPi1uTPVnK0cmZB9bYmerr/JrUMZzy
         tlEnMQmNbeLH/qVL9GdEmSH7EsRQoc+1bshINjcIhVM5yyNxHAtzPIA1jT+I2X7Jdwmt
         NOfw==
X-Gm-Message-State: ACrzQf2FMesZIxVh4tmc6AQEFdJqmPfwQXo6pdKXm+MzYTn6ne+mBfb/
        XYQbHRbvRcIbsBPiBjRx/TsX/iQkrN3KSQ==
X-Google-Smtp-Source: AMsMyM6A52ss9lihnf1n1QSWKmamcIT2+iFT79ZD41SzVfwRyvRP43o742Tz5fkCrNDl0vO/XPJ9O1rNjLNWTg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:5408:b0:20a:d6b1:a2a7 with SMTP
 id z8-20020a17090a540800b0020ad6b1a2a7mr1873463pjh.2.1666129587322; Tue, 18
 Oct 2022 14:46:27 -0700 (PDT)
Date:   Tue, 18 Oct 2022 14:46:11 -0700
In-Reply-To: <20221018214612.3445074-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221018214612.3445074-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221018214612.3445074-8-dmatlack@google.com>
Subject: [PATCH v2 7/8] KVM: selftests: Expect #PF(RSVD) when TDP is disabled
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change smaller_maxphyaddr_emulation_test to expect a #PF(RSVD), rather
than an emulation failure, when TDP is disabled. KVM only needs to
emulate instructions to emulate a smaller guest.MAXPHYADDR when TDP is
enabled.

Fixes: 39bbcc3a4e39 ("selftests: kvm: Allows userspace to handle emulation errors.")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../smaller_maxphyaddr_emulation_test.c       | 45 +++++++++++++++++--
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
index 91a85a00b692..afa9e0b3dd8a 100644
--- a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
@@ -21,6 +21,12 @@
 #define MEM_REGION_SLOT	10
 #define MEM_REGION_SIZE PAGE_SIZE
 
+static void guest_page_fault_handler(struct ex_regs *regs)
+{
+	GUEST_ASSERT(regs->error_code & PFERR_RSVD_MASK);
+	GUEST_SYNC(PF_VECTOR);
+}
+
 static void guest_code(void)
 {
 	flds(MEM_REGION_GVA);
@@ -36,6 +42,23 @@ static void assert_ucall_done(struct kvm_vcpu *vcpu)
 		    uc.cmd, UCALL_DONE);
 }
 
+static void assert_reserved_page_fault(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	case UCALL_SYNC:
+		TEST_ASSERT(uc.args[1] == PF_VECTOR,
+			    "Unexpected UCALL_SYNC: %lu", uc.args[1]);
+		break;
+	default:
+		TEST_FAIL("Unrecognized ucall: %lu\n", uc.cmd);
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
@@ -50,6 +73,9 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_SMALLER_MAXPHYADDR));
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+	vm_install_exception_handler(vm, PF_VECTOR, guest_page_fault_handler);
 
 	vcpu_set_cpuid_maxphyaddr(vcpu, MAXPHYADDR);
 
@@ -70,10 +96,21 @@ int main(int argc, char *argv[])
 	vm_set_page_table_entry(vm, vcpu, MEM_REGION_GVA, pte | (1ull << 36));
 
 	vcpu_run(vcpu);
-	assert_exit_for_flds_emulation_failure(vcpu);
-	skip_flds_instruction(vcpu);
-	vcpu_run(vcpu);
-	assert_ucall_done(vcpu);
+
+	/*
+	 * When TDP is enabled, KVM must emulate the flds instruction, which
+	 * results in an emulation failure out to userspace. Otherwise, no
+	 * instruction emulation is required so check that the instruction
+	 * generates #PF(RSVD).
+	 */
+	if (kvm_is_tdp_enabled()) {
+		assert_exit_for_flds_emulation_failure(vcpu);
+		skip_flds_instruction(vcpu);
+		vcpu_run(vcpu);
+		assert_ucall_done(vcpu);
+	} else {
+		assert_reserved_page_fault(vcpu);
+	}
 
 	kvm_vm_free(vm);
 
-- 
2.38.0.413.g74048e4d9e-goog

