Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFED6D6986
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 18:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbjDDQyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 12:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjDDQyE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 12:54:04 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FF11BC9
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 09:53:48 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id e193-20020a6369ca000000b00513f15ffaceso2125200pgc.12
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 09:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680627228;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fUhcRVpJQ0HCe3YwLDTqsDaNlIA311WFBlCWh3ZTG7o=;
        b=VAelZqMo2ezMVaMIyDZlr4TG+LVL1kh1piRCn5gZTUl8SstPPMOOockL3NYPsxS4UU
         GpWh3tj+BojF11LsEO7tDlgxzE3PUfRXqR5u8PVJaWwCAi8PLL7JPDzZec5X5qlhjQ5A
         2cNG3b8+AZ8ESy4+uknpjD9KcMe9/bgR75uGr6tPRcStYgkiv0oJ74Dmb91VwsXz1pT9
         MzFMtnAMHYedNfNWQ3styHUtkLghIPpB84Nb5WkZ7/tYtW1mXtGRr8HZqj+xOUQveEK4
         oXulGQh+Y1oPoyNcM+yzouB4dnw1YOXbBiVVAqpFy4ZH+xK7yjvUzu3STzShzG3kXPv/
         9JsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680627228;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fUhcRVpJQ0HCe3YwLDTqsDaNlIA311WFBlCWh3ZTG7o=;
        b=xZnXHWxe8YNljvE+W5Tkxz2PE1V3xty02RABXN9DEl3oXCFRzUG8iCpyVZMOfzXD0x
         5CCx84zC+uvNGDNM00oQFFw6WUxeHKdIRbGgZQS4GYJdNZrZ0R0DREhYY+xEyKUu5alm
         wF6rR3coYM4c0/LW6T2+RaATYfbtkjCW7Xrx+05YnbFMRrdbCcrQTHoMxgI0ZZastXyS
         8Tydlho3gWMCSAzBMRh6klaCTge7Wrr8xUgTTEt1c5IWGTNkC0+LmITnwXb4UTxOxAe/
         YqZyxwXlzAsfrkMUEuvIEXdiUSsVhBAlAYhXMVYJpo63eXjKCDtR4GKv9uOGi6HKwJ91
         m8iw==
X-Gm-Message-State: AAQBX9deM1a3FtiN64lH3IsJYzcypxNdoO477DA/f32lGjhQnD9Ouk/Y
        zjtuQJgpZA82j+moafJqkHN9Uo/DQp0=
X-Google-Smtp-Source: AKy350YV95SpVqj6RKEJAn9YwvbdPIxd3uIGigSkr+Os5jO7djiiIx0fmGsa5a6DEWfpR4SzXapkIT9JDqE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:5d18:b0:23b:349d:a159 with SMTP id
 s24-20020a17090a5d1800b0023b349da159mr20858pji.3.1680627227911; Tue, 04 Apr
 2023 09:53:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 09:53:33 -0700
In-Reply-To: <20230404165341.163500-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230404165341.163500-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404165341.163500-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 2/9] x86/access: CR0.WP toggling write to
 r/o data test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Mathias Krause <minipli@grsecurity.net>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mathias Krause <minipli@grsecurity.net>

KUT has tests that verify a supervisor write access to an r/o page is
successful when CR0.WP=0, but lacks a test that explicitly verifies that
the same access faults after setting CR0.WP=1 without flushing any
associated TLB entries, either explicitly (INVLPG) or implicitly (write
to CR3). Add such a test.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 2 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 203353a3..2d3d7c7b 100644
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
@@ -1061,6 +1067,55 @@ err:
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
@@ -1150,6 +1205,7 @@ const ac_test_fn ac_test_cases[] =
 	check_pfec_on_prefetch_pte,
 	check_large_pte_dirty_for_nowp,
 	check_smep_andnot_wp,
+	check_toggle_cr0_wp,
 	check_effective_sp_permissions,
 };
 
-- 
2.40.0.348.gf938b09366-goog

