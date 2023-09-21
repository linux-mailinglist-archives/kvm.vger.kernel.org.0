Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B737AA10D
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbjIUU5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbjIUU5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:57:17 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596D8C3321
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:57 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59beb3a8291so20360507b3.1
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695328436; x=1695933236; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=as3Xfcp/JRiOon5PWxqp/0cQrWwxzrg67R/BFsP5EZc=;
        b=wZtpeBeUwfckO0z7bOUNL0F6TUXNNsVTgy0qa4xfTtdUMrK3z/YnmEirYT40YEmX0l
         n6IRO8Bjz/oeONCBm08TY5eEwsCY2BU6x0IZIvfUWnjKGU47ANJfT9yX1zgAqLP3WAI+
         o8WiWBL6PZKpY69El9xLmTaCGMvMTI9pRuEbZMw/yznEvTEqphA3ixdiPOHc4KABiMyt
         1K4eY59/pTZMmJ6F8rLgG8/yrEQBhigRCksVDnisdDKK5OaCS4HY1qOUBbhCig3bFdzj
         7nFG1O7HrX6U4TQZAbcB1xxhUaiPrsp8DVy3yadIXWZcgJcnF4VCTnsolv8pOTR179Cu
         Nx2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695328436; x=1695933236;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=as3Xfcp/JRiOon5PWxqp/0cQrWwxzrg67R/BFsP5EZc=;
        b=diPLc8DlwgLJEzqHYjw1fzdypmErKOcwDCWu9Ky2M9Ht6Lx2mh1ZpLvh7yhnEest1J
         L8M/W682fjt4+j60cT1PovTv9nr6j1Eh2JEb4Q83fjk1P0bQPLEzOejOGxp9rKumnh4O
         CdN3YtYs9PfpkmRpWSk45kjE1i5RPPR6aohUriJp4D6LgHrUWbPVnQT/uyg2+L2jM7yE
         WWecu/cAMIjOj653gwdTf4p82IsiD4BW5/NyXVfCrBXoU7qXrl3I3RXC90ulsXq65Vte
         EYV9HSOjJOJggKUFppxG/MUEn34zpxKlBk3EIZcarGMWoGSCDvNOu4MDYuRT3z7Zcwdq
         gi/w==
X-Gm-Message-State: AOJu0Yzuvh8lPYVeA20r52inHKAlEKdVHn98Dtj7M5DYDADXZMv5KHOw
        EeovZiDbkEXOaDecjYTxj86d8HelaNw=
X-Google-Smtp-Source: AGHT+IHi7mnPSSHuR6uMQ9zB5hC3CAGDfRvOyb039qMm5sT311dR9pe9rzKOxh23Xqpo1jBpi8ZGPYUE+IQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ad4f:0:b0:58c:6ddd:d27c with SMTP id
 l15-20020a81ad4f000000b0058c6dddd27cmr92527ywk.6.1695328436337; Thu, 21 Sep
 2023 13:33:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Sep 2023 13:33:29 -0700
In-Reply-To: <20230921203331.3746712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230921203331.3746712-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230921203331.3746712-13-seanjc@google.com>
Subject: [PATCH 12/13] KVM: selftests: Add a "pure" PUNCH_HOLE on guest_memfd testcase
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Binbin Wu <binbin.wu@linux.intel.com>
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

Add a PUNCH_HOLE testcase to the private memory conversions test that
verifies PUNCH_HOLE actually frees memory.  Directly verifying that KVM
frees memory is impractical, if it's even possible, so instead indirectly
verify memory is freed by asserting that the guest reads zeroes after a
PUNCH_HOLE.  E.g. if KVM zaps SPTEs but doesn't actually punch a hole in
the inode, the subsequent read will still see the previous value.  And
obviously punching a hole shouldn't cause explosions.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86_64/private_mem_conversions_test.c | 61 +++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
index b80cf7342d0d..c04e7d61a585 100644
--- a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
@@ -212,6 +212,60 @@ static void guest_test_explicit_conversion(uint64_t base_gpa, bool do_fallocate)
 	}
 }
 
+static void guest_punch_hole(uint64_t gpa, uint64_t size)
+{
+	/* "Mapping" memory shared via fallocate() is done via PUNCH_HOLE. */
+	uint64_t flags = MAP_GPA_SHARED | MAP_GPA_DO_FALLOCATE;
+
+	kvm_hypercall_map_gpa_range(gpa, size, flags);
+}
+
+/*
+ * Test that PUNCH_HOLE actually frees memory by punching holes without doing a
+ * proper conversion.  Freeing (PUNCH_HOLE) should zap SPTEs, and reallocating
+ * (subsequent fault) should zero memory.
+ */
+static void guest_test_punch_hole(uint64_t base_gpa, bool precise)
+{
+	const uint8_t init_p = 0xcc;
+	int i;
+
+	/*
+	 * Convert the entire range to private, this testcase is all about
+	 * punching holes in guest_memfd, i.e. shared mappings aren't needed.
+	 */
+	guest_map_private(base_gpa, PER_CPU_DATA_SIZE, false);
+
+	for (i = 0; i < ARRAY_SIZE(test_ranges); i++) {
+		uint64_t gpa = base_gpa + test_ranges[i].offset;
+		uint64_t size = test_ranges[i].size;
+
+		/*
+		 * Free all memory before each iteration, even for the !precise
+		 * case where the memory will be faulted back in.  Freeing and
+		 * reallocating should obviously work, and freeing all memory
+		 * minimizes the probability of cross-testcase influence.
+		 */
+		guest_punch_hole(base_gpa, PER_CPU_DATA_SIZE);
+
+		/* Fault-in and initialize memory, and verify the pattern. */
+		if (precise) {
+			memset((void *)gpa, init_p, size);
+			memcmp_g(gpa, init_p, size);
+		} else {
+			memset((void *)base_gpa, init_p, PER_CPU_DATA_SIZE);
+			memcmp_g(base_gpa, init_p, PER_CPU_DATA_SIZE);
+		}
+
+		/*
+		 * Punch a hole at the target range and verify that reads from
+		 * the guest succeed and return zeroes.
+		 */
+		guest_punch_hole(gpa, size);
+		memcmp_g(gpa, 0, size);
+	}
+}
+
 static void guest_code(uint64_t base_gpa)
 {
 	/*
@@ -220,6 +274,13 @@ static void guest_code(uint64_t base_gpa)
 	 */
 	guest_test_explicit_conversion(base_gpa, false);
 	guest_test_explicit_conversion(base_gpa, true);
+
+	/*
+	 * Run the PUNCH_HOLE test twice too, once with the entire guest_memfd
+	 * faulted in, once with only the target range faulted in.
+	 */
+	guest_test_punch_hole(base_gpa, false);
+	guest_test_punch_hole(base_gpa, true);
 	GUEST_DONE();
 }
 
-- 
2.42.0.515.g380fc7ccd1-goog

