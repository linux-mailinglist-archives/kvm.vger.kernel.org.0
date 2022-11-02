Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2495616D15
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 19:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbiKBSrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 14:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbiKBSrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 14:47:18 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C5B2FFE6
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 11:47:13 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-36810cfa61fso164448247b3.6
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 11:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tgC3vVAXJf1HfFnPnIA3qYa9J9PvuIsGWvmyOnENyL8=;
        b=JdPVYbvGmrT6AIY9WsQkOGcffjK6ZQKiB6a7Ftdk9nfu2exh7TOl1eF1c61rq1a1Wv
         2ZPcL3ecWhrhStfF1UCD08OJUh1mMaZGGrdY5UE1CF2Ainbb8xid0bOzU5EWqLV/Vkny
         F9lkfunRcJYMLYvdfmS17oKvKlfu6AAgV2pdi3p3fC1VWMVjw4E9hM+iqC2bcNtaEntE
         AZzlerQBqK3smN9LHqysu1Ma/VAYzLNCpFzbFAI8EAsB++6B9vNU4J+dhiijzJ6xK9u4
         xZ/eWpnrQD/pd5q3df0hDHLJf1JyPBtnBnXI0FavLPHb4XoMinPV9xD8SDGM2fBLNzH+
         lvzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tgC3vVAXJf1HfFnPnIA3qYa9J9PvuIsGWvmyOnENyL8=;
        b=ggQmunwnSC26MNF85VZzau40b0doCsFRA9CbtUzZv+lCFovMeMVfEq5XCIcuPwZn5p
         BQmVCQLvXnCI6HlCdHauNGXveKawzpHC/qWcnax4Ht71KB3YofMyUUGmuNRJaUv3XMMV
         lAzfNPSDcVHa+VBqOlWsuvy6VpnVfl5ONG+LgR0WNnqfYN4aSJv+XXlg3dLrhndWQe8e
         oXHpKvJjKW8jR+wqg2fUh+d3LoKpUrQDSzvyOdPFfBnaZT0b6Kz6U+JIObnr1ISbRwea
         +kIqYFSbE0hdgdUQeDXbxeiCKxKtE76Y1OuhCsAClu4PuoiLgLZZtnlVzFcB9oO5p2Jt
         rJdg==
X-Gm-Message-State: ACrzQf19OZuoS6f+P5ny3JYrT9eX9sAWlsUgHC1d5A6DrQQluK/Q1RD7
        7UjmJYlRoTfJdMP0niUrLRgBOH1VNXhhgg==
X-Google-Smtp-Source: AMsMyM6Cadio/K70nPcxiUijaio/rnmWE5a7GQmQudQfr2KyPu4sSVnym27O7cmyzagmc3xS6gGC1sOlzECJyA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:8089:0:b0:6c9:b209:d922 with SMTP id
 n9-20020a258089000000b006c9b209d922mr25375362ybk.396.1667414832588; Wed, 02
 Nov 2022 11:47:12 -0700 (PDT)
Date:   Wed,  2 Nov 2022 11:46:53 -0700
In-Reply-To: <20221102184654.282799-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221102184654.282799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102184654.282799-10-dmatlack@google.com>
Subject: [PATCH v4 09/10] KVM: selftests: Expect #PF(RSVD) when TDP is disabled
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
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
 .../smaller_maxphyaddr_emulation_test.c       | 51 +++++++++++++++++--
 1 file changed, 46 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
index 9d0e555ea630..ea1e7ae37e85 100644
--- a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
@@ -21,9 +21,28 @@
 #define MEM_REGION_SLOT	10
 #define MEM_REGION_SIZE PAGE_SIZE
 
-static void guest_code(void)
+static void guest_code(bool tdp_enabled)
 {
-	flds(MEM_REGION_GVA);
+	uint64_t error_code;
+	uint64_t vector;
+
+	vector = kvm_asm_safe_ec(FLDS_MEM_EAX, error_code, "a"(MEM_REGION_GVA));
+
+	/*
+	 * When TDP is enabled, the flds instruction will trigger an emulation
+	 * failure, exit to userspace, and then the selftest skips the
+	 * instruction.
+	 *
+	 * When TDP is disabled, no instruction emulation is required so flds
+	 * should generate #PF(RSVD).
+	 */
+	if (tdp_enabled) {
+		GUEST_ASSERT(!vector);
+	} else {
+		GUEST_ASSERT_EQ(vector, PF_VECTOR);
+		GUEST_ASSERT(error_code & PFERR_RSVD_MASK);
+	}
+
 	GUEST_DONE();
 }
 
@@ -32,6 +51,7 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	uint64_t gpa, pte;
+	struct ucall uc;
 	uint64_t *hva;
 	int rc;
 
@@ -41,6 +61,10 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_SMALLER_MAXPHYADDR));
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	vcpu_args_set(vcpu, 1, kvm_is_tdp_enabled());
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
 
 	vcpu_set_cpuid_maxphyaddr(vcpu, MAXPHYADDR);
 
@@ -61,9 +85,26 @@ int main(int argc, char *argv[])
 	vm_set_page_table_entry(vm, vcpu, MEM_REGION_GVA, pte | (1ull << 36));
 
 	vcpu_run(vcpu);
-	handle_flds_emulation_failure_exit(vcpu);
-	vcpu_run(vcpu);
-	ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+
+	/*
+	 * When TDP is enabled, KVM must emulate the flds instruction, which
+	 * results in an emulation failure out to userspace since KVM does not
+	 * know how to emulate flds.
+	 */
+	if (kvm_is_tdp_enabled()) {
+		handle_flds_emulation_failure_exit(vcpu);
+		vcpu_run(vcpu);
+	}
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	case UCALL_DONE:
+		break;
+	default:
+		TEST_FAIL("Unrecognized ucall: %lu\n", uc.cmd);
+	}
 
 	kvm_vm_free(vm);
 
-- 
2.38.1.273.g43a17bfeac-goog

