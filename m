Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2D757A1C7
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 16:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238563AbiGSOhy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 10:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239153AbiGSOhc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 10:37:32 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448831176
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 07:31:48 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658241106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O3n2AO7hJDNpmrDB/OBV6bnT5N4ksN+mLBmsqOqb48I=;
        b=cZ4BDOUps9V6Qv/PI3nsolJxJSAo8PuSobvJLz0aZA7cTmi6K7NF6/vyersEXXsaP3isP6
        odmYUAQ+yJ0mlgp+wJ2+pYNAn/0ebnyTDsXoEFxM0gWZKi7PUAhmQ580Yzscy/l8E7910k
        cTF+gUXFRJEzUZ9mmUKN05+dezazDeU=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com,
        Oliver Upton <oupton@google.com>
Subject: [PATCH 1/3] selftests: KVM: Check stat name before other fields
Date:   Tue, 19 Jul 2022 14:31:32 +0000
Message-Id: <20220719143134.3246798-2-oliver.upton@linux.dev>
In-Reply-To: <20220719143134.3246798-1-oliver.upton@linux.dev>
References: <20220719143134.3246798-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Oliver Upton <oupton@google.com>

In order to provide more useful test assertions that describe the broken
stats descriptor, perform sanity check on the stat name before any other
descriptor field. While at it, avoid dereferencing the name field if the
sanity check fails as it is more likely to contain garbage.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/kvm_binary_stats_test.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index b01e8b0851e7..40227ad9ba0c 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -73,6 +73,10 @@ static void stats_test(int stats_fd)
 	for (i = 0; i < header.num_desc; ++i) {
 		pdesc = get_stats_descriptor(stats_desc, i, &header);
 
+		/* Check name string */
+		TEST_ASSERT(strlen(pdesc->name) < header.name_size,
+			    "KVM stats name (index: %d) too long", i);
+
 		/* Check type,unit,base boundaries */
 		TEST_ASSERT((pdesc->flags & KVM_STATS_TYPE_MASK) <= KVM_STATS_TYPE_MAX,
 			    "Unknown KVM stats type");
@@ -99,9 +103,7 @@ static void stats_test(int stats_fd)
 			TEST_ASSERT(pdesc->exponent <= 0, "Unsupported KVM stats unit");
 			break;
 		}
-		/* Check name string */
-		TEST_ASSERT(strlen(pdesc->name) < header.name_size,
-			    "KVM stats name(%s) too long", pdesc->name);
+
 		/* Check size field, which should not be zero */
 		TEST_ASSERT(pdesc->size,
 			    "KVM descriptor(%s) with size of 0", pdesc->name);
-- 
2.37.0.170.g444d1eabd0-goog

