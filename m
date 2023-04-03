Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD4F6D42B1
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 12:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbjDCK4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 06:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbjDCK4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 06:56:39 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F260586B5
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 03:56:35 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h17so28865023wrt.8
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 03:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680519394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a6fwZqXE56drVA6/4ffLVKYgxl6E3+Ct3neznNmShJg=;
        b=i+UyFB8lT/cD+ytOt/bgqqW/kjNxd2rdgYAAd7P4052hxXfkyaAh6TkIerF6C8SE3Y
         mCrOtpjrqlSOkbgHYO23T7pm0Tx1WTTp4CW3YdoabsFLhw98qwUYMB6F1I+FC0jYYHdA
         ylkUj99TQmTKFxijlXEiXoSGnqViapkEdffez28eIFpwDqE32PPxCyDv+KUbWYdGeVtm
         ttePFDBRYzybD2l7jzpnX8wUPNsLlYKPrbZd91Z0vKvcKi1TJj9ptKMnxb9Nj7Mcwqfc
         mxBEMYS8vkcl6MocH58zdrc32gdRYjn1wYHPRgunx2/qeBehG52HIPJ/nt7HNEfje0nR
         HMwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680519394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a6fwZqXE56drVA6/4ffLVKYgxl6E3+Ct3neznNmShJg=;
        b=yLsyIwVl3gwicIj+QjisXIIQSlSz7gk/j62ANrY/to8Uj3dqIsQe/s1VBy6ZjU4FT1
         RelfJDJ50vmLcUKEDvpkCpyolHH5Ui9xta8U8wwEG90Csx+VAQ7YLm7TOjRvNnE/iDL8
         ilec5PNq5STd3nYo3nYQ+5GQWVCYTeSpKOsPVu5EkKUS9Rgm4liwg8UBTPutndQMCThN
         Bs8MPQpZ0Wusv6KKxT2bPrknJiVgqe+ryKnKmxzFD24vJJjwgfg5t1QAnR8EC7wC7fBH
         81PHswDC+Ig18vJfeJneRQ0fGJM0Q/rCqhQRXPxOeGxr/vl+7gp7eqAAi28kC+SJlJ53
         kGNQ==
X-Gm-Message-State: AAQBX9f4hjdC9fRQGsyBA/jCXxY/xgVyvSqziARe0dhFHJVeIyWxT5r/
        yIbYCPOdeP6f8fKHuKwzkfZ42Lx+NyzHGb1qSLKvaw==
X-Google-Smtp-Source: AKy350Zr1H3Owf41ia6tPBdvJy13si0l1F0RAGms+pis2z1qjhkewU+Ag5eU2BO8HKg5kV0f7qD8xg==
X-Received: by 2002:adf:e303:0:b0:2c5:4c9d:2dab with SMTP id b3-20020adfe303000000b002c54c9d2dabmr13036720wrj.10.1680519394093;
        Mon, 03 Apr 2023 03:56:34 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af22160069a3c79c8928b176.dip0.t-ipconnect.de. [2003:f6:af22:1600:69a3:c79c:8928:b176])
        by smtp.gmail.com with ESMTPSA id x6-20020a5d60c6000000b002dfca33ba36sm9483671wrt.8.2023.04.03.03.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 03:56:33 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v3 2/4] x86/access: CR0.WP toggling write to r/o data test
Date:   Mon,  3 Apr 2023 12:56:16 +0200
Message-Id: <20230403105618.41118-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230403105618.41118-1-minipli@grsecurity.net>
References: <20230403105618.41118-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KUT has tests that verify a supervisor write access to an r/o page is
successful when CR0.WP=0, but lacks a test that explicitly verifies that
the same access faults after setting CR0.WP=1 without flushing any
associated TLB entries, either explicitly (INVLPG) or implicitly (write
to CR3). Add such a test.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
For v3 I moved the guts to a helper but omitted the "as expected" part
from the printf() as it not only keeps the generated output below 80
chars but also is kinda superfluous when it triggers.

Here's an example failure run (with the full series applied):

: run
: ....................................................................................................................................................................................................................................................................................................
: test pte.a pte.p pde.a pde.p write fep: FAIL: unexpected fault
: Dump mapping: address: 0xffff923042007000
: ------L4 I292: 2100027
: ------L3 I193: 2101027
: ------L2 I16: 2102021
: ------L1 I7: 2000061
: do_cr0_wp_access: emulated supervisor write with CR0.WP=0 did not SUCCEED
: 
: test pte.a pte.p pde.a pde.p write cr0.wp fep: FAIL: unexpected access
: Dump mapping: address: 0xffff923042007000
: ------L4 I292: 2100027
: ------L3 I193: 2101027
: ------L2 I16: 2102021
: ------L1 I7: 2000061
: do_cr0_wp_access: emulated supervisor write with CR0.WP=1 did not FAULT
: 
: 19169286 tests, 1 failures
: FAIL access

As can be seen, ac_test_check() already prints the failure reason, no
need to mention it again.

 x86/access.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 59 insertions(+), 2 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 203353a3f74f..a01278451b96 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -575,9 +575,10 @@ fault:
 		at->expected_error &= ~PFERR_FETCH_MASK;
 }
 
-static void ac_set_expected_status(ac_test_t *at)
+static void __ac_set_expected_status(ac_test_t *at, bool flush)
 {
-	invlpg(at->virt);
+	if (flush)
+		invlpg(at->virt);
 
 	if (at->ptep)
 		at->expected_pte = *at->ptep;
@@ -599,6 +600,11 @@ static void ac_set_expected_status(ac_test_t *at)
 	ac_emulate_access(at, at->flags);
 }
 
+static void ac_set_expected_status(ac_test_t *at)
+{
+	__ac_set_expected_status(at, true);
+}
+
 static pt_element_t ac_get_pt(ac_test_t *at, int i, pt_element_t *ptep)
 {
 	pt_element_t pte;
@@ -1061,6 +1067,56 @@ err:
 	return 0;
 }
 
+#define TOGGLE_CR0_WP_TEST_BASE_FLAGS \
+	(AC_PDE_PRESENT_MASK | AC_PDE_ACCESSED_MASK | \
+	 AC_PTE_PRESENT_MASK | AC_PTE_ACCESSED_MASK | \
+	 AC_ACCESS_WRITE_MASK)
+
+static int do_cr0_wp_access(ac_test_t *at, int flags)
+{
+	const bool cr0_wp = !!(flags & AC_CPU_CR0_WP_MASK);
+
+	at->flags = TOGGLE_CR0_WP_TEST_BASE_FLAGS | flags;
+	__ac_set_expected_status(at, false);
+
+	/*
+	 * Under VMX the guest might own the CR0.WP bit, requiring KVM to
+	 * manually keep track of it where needed, e.g. in the guest page
+	 * table walker.
+	 *
+	 * Load CR0.WP with the inverse value of what will be used during
+	 * the access test and toggle EFER.NX to coerce KVM into rebuilding
+	 * the current MMU context based on the soon-to-be-stale CR0.WP.
+	 */
+	set_cr0_wp(!cr0_wp);
+	set_efer_nx(1);
+	set_efer_nx(0);
+
+	if (!ac_test_do_access(at)) {
+		printf("%s: supervisor write with CR0.WP=%d did not %s\n",
+		       __FUNCTION__, cr0_wp, cr0_wp ? "FAULT" : "SUCCEED");
+
+		return 1;
+	}
+
+	return 0;
+}
+
+static int check_toggle_cr0_wp(ac_pt_env_t *pt_env)
+{
+	ac_test_t at;
+	int err = 0;
+
+	ac_test_init(&at, 0xffff923042007000ul, pt_env);
+	at.flags = TOGGLE_CR0_WP_TEST_BASE_FLAGS;
+	ac_test_setup_ptes(&at);
+
+	err += do_cr0_wp_access(&at, 0);
+	err += do_cr0_wp_access(&at, AC_CPU_CR0_WP_MASK);
+
+	return err == 0;
+}
+
 static int check_effective_sp_permissions(ac_pt_env_t *pt_env)
 {
 	unsigned long ptr1 = 0xffff923480000000;
@@ -1150,6 +1206,7 @@ const ac_test_fn ac_test_cases[] =
 	check_pfec_on_prefetch_pte,
 	check_large_pte_dirty_for_nowp,
 	check_smep_andnot_wp,
+	check_toggle_cr0_wp,
 	check_effective_sp_permissions,
 };
 
-- 
2.39.2

