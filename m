Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFD157A1C3
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 16:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239288AbiGSOhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 10:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239203AbiGSOhc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 10:37:32 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B61240
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 07:31:49 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658241108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IAgwA5oED9+OeZsGmvKgcD/KtCqiLCsBPLGVNza1h7g=;
        b=ch7XHr08P0o9h3SS+yUtF1HieNf6oeaqCDnx+1gJiMLRQmKzQ3O7sRvnTJI145kLabq4y4
        a4xZ7eogqx/2c8kO+vDF0QNDg04u4J3Xmwitadb+kG7RSw9hPQ4PJWPd/D35jwA907zzTd
        zRTtnUQ8HVgjKwy5eln+IG2OGq6xUyM=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com,
        Oliver Upton <oupton@google.com>
Subject: [PATCH 2/3] selftests: KVM: Provide descriptive assertions in kvm_binary_stats_test
Date:   Tue, 19 Jul 2022 14:31:33 +0000
Message-Id: <20220719143134.3246798-3-oliver.upton@linux.dev>
In-Reply-To: <20220719143134.3246798-1-oliver.upton@linux.dev>
References: <20220719143134.3246798-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Oliver Upton <oupton@google.com>

As it turns out, tests sometimes fail. When that is the case, packing
the test assertion with as much relevant information helps track down
the problem more quickly.

Sharpen up the stat descriptor assertions in kvm_binary_stats_test to
more precisely describe the reason for the test assertion and which
stat is to blame.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/kvm_binary_stats_test.c     | 24 ++++++++++++-------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 40227ad9ba0c..3237c7c94bf0 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -31,6 +31,7 @@ static void stats_test(int stats_fd)
 	struct kvm_stats_desc *stats_desc;
 	u64 *stats_data;
 	struct kvm_stats_desc *pdesc;
+	u32 type, unit, base;
 
 	/* Read kvm stats header */
 	read_stats_header(stats_fd, &header);
@@ -72,18 +73,21 @@ static void stats_test(int stats_fd)
 	/* Sanity check for fields in descriptors */
 	for (i = 0; i < header.num_desc; ++i) {
 		pdesc = get_stats_descriptor(stats_desc, i, &header);
+		type = pdesc->flags & KVM_STATS_TYPE_MASK;
+		unit = pdesc->flags & KVM_STATS_UNIT_MASK;
+		base = pdesc->flags & KVM_STATS_BASE_MASK;
 
 		/* Check name string */
 		TEST_ASSERT(strlen(pdesc->name) < header.name_size,
 			    "KVM stats name (index: %d) too long", i);
 
 		/* Check type,unit,base boundaries */
-		TEST_ASSERT((pdesc->flags & KVM_STATS_TYPE_MASK) <= KVM_STATS_TYPE_MAX,
-			    "Unknown KVM stats type");
-		TEST_ASSERT((pdesc->flags & KVM_STATS_UNIT_MASK) <= KVM_STATS_UNIT_MAX,
-			    "Unknown KVM stats unit");
-		TEST_ASSERT((pdesc->flags & KVM_STATS_BASE_MASK) <= KVM_STATS_BASE_MAX,
-			    "Unknown KVM stats base");
+		TEST_ASSERT(type <= KVM_STATS_TYPE_MAX,
+			    "Unknown KVM stats (%s) type: %u", pdesc->name, type);
+		TEST_ASSERT(unit <= KVM_STATS_UNIT_MAX,
+			    "Unknown KVM stats (%s) unit: %u", pdesc->name, unit);
+		TEST_ASSERT(base <= KVM_STATS_BASE_MAX,
+			    "Unknown KVM stats (%s) base: %u", pdesc->name, base);
 
 		/*
 		 * Check exponent for stats unit
@@ -97,10 +101,14 @@ static void stats_test(int stats_fd)
 		case KVM_STATS_UNIT_NONE:
 		case KVM_STATS_UNIT_BYTES:
 		case KVM_STATS_UNIT_CYCLES:
-			TEST_ASSERT(pdesc->exponent >= 0, "Unsupported KVM stats unit");
+			TEST_ASSERT(pdesc->exponent >= 0,
+				    "Unsupported KVM stats (%s) exponent: %i",
+				    pdesc->name, pdesc->exponent);
 			break;
 		case KVM_STATS_UNIT_SECONDS:
-			TEST_ASSERT(pdesc->exponent <= 0, "Unsupported KVM stats unit");
+			TEST_ASSERT(pdesc->exponent <= 0,
+				    "Unsupported KVM stats (%s) exponent: %i",
+				    pdesc->name, pdesc->exponent);
 			break;
 		}
 
-- 
2.37.0.170.g444d1eabd0-goog

