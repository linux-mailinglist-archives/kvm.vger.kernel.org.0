Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC06C57A1C6
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 16:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239234AbiGSOhv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 10:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239208AbiGSOhc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 10:37:32 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD7FC39
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 07:31:50 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658241109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Y+TsnEqdea4fx7oRubu4Fn88iDoXdM2Un0sc0IWSD4=;
        b=R5rUBU0I2hOmGECDP1AD2fwSA06w7jPHsloi+9QZg56usCVOLh48cWM2rhWX5D7Ue3OqQf
        nZBk5ktMIU5qAABlj5mBu3FevK4TL3xWO4fW8jQjU+09mdJE+FMV3paG6i94BbtAY1LQzW
        eOlWcDH5XsjUZWKriA3+U5BzH02VoN0=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com,
        Oliver Upton <oupton@google.com>
Subject: [PATCH 3/3] selftests: KVM: Add exponent check for boolean stats
Date:   Tue, 19 Jul 2022 14:31:34 +0000
Message-Id: <20220719143134.3246798-4-oliver.upton@linux.dev>
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

The only sensible exponent for a boolean stat is 0. Add a test assertion
requiring all boolean statistics to have an exponent of 0.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/kvm_binary_stats_test.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 3237c7c94bf0..0b45ac593387 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -96,6 +96,7 @@ static void stats_test(int stats_fd)
 		 * Exponent for unit seconds should be less than or equal to 0
 		 * Exponent for unit clock cycles should be greater than or
 		 * equal to 0
+		 * Exponent for unit boolean should be 0
 		 */
 		switch (pdesc->flags & KVM_STATS_UNIT_MASK) {
 		case KVM_STATS_UNIT_NONE:
@@ -110,6 +111,11 @@ static void stats_test(int stats_fd)
 				    "Unsupported KVM stats (%s) exponent: %i",
 				    pdesc->name, pdesc->exponent);
 			break;
+		case KVM_STATS_UNIT_BOOLEAN:
+			TEST_ASSERT(pdesc->exponent == 0,
+				    "Unsupported KVM stats (%s) exponent: %d",
+				    pdesc->name, pdesc->exponent);
+			break;
 		}
 
 		/* Check size field, which should not be zero */
-- 
2.37.0.170.g444d1eabd0-goog

