Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9E44F8B32
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 02:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbiDHAnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 20:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbiDHAng (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 20:43:36 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53971786B3
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 17:41:34 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id n11-20020a170902d2cb00b00156c1fd01c2so3611509plc.12
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 17:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tRGVvoht62Wm0zdeImIalZjSLMP6mzAfCTWi8BhGbl8=;
        b=n4CEYM1D4z3Giyg+eCtkiEPPA3r+PIMHJVXRYwvPp7clxkEoLN6B6kqft8A7MJji+k
         iU8SOTNYfL4+d2PP5p2Vr0VZawQI+r6N14yhgAMXQ3z1V2Tx7DV1g3/ubk+U3oeTt7zh
         WDKha5AI4T8BUlhzIeEEfcfEBk1YhYRvuxgQe76KY2LtnMsAtLdhV8kYGXiLQBg3MwY2
         DDInFL5IOU7mjynjxSSCwyfUY4YRd3xJblLcvRLp2Rm2llgnV8j4Adpq+hBh9U23S35b
         1da6uAkxawWDJQVvptnrSvI5refAD77/Yit/Wzu3iA2UXDrZSnGXfnI025QofF+Z83/B
         e7cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tRGVvoht62Wm0zdeImIalZjSLMP6mzAfCTWi8BhGbl8=;
        b=Ssz3fuwLeFjsTzQkK7Su839YC0lUrAnBE5BRRUfftQUsqi+rhlQYl0YZKlgwZa1y7F
         wrNaNrVktzOzBFJklgAPQ5MrRLX9MfOZSXAhO00rYHy46F6p2L/HRpXVV8zVIBtwj9RJ
         8MilwWS371HCL/9cB4KtrOodUmczbFFQgbMv1s+5o4h68XTrcXhF7s64l8auTo/BRfyJ
         a8z95RQEFbVcJWeQgIbm62+zDkdP9GBCK13Cj8u6A5aDiKaBbXvbOy9/6ST0kZAFg6ZG
         g43UipzV1B68Kl8TGLY5eOE+36HBL1Z4mL0WAdA9Gey10MDnm/QDB8sfv2Ohhx7t+cES
         s9SQ==
X-Gm-Message-State: AOAM531g1RktrBGHx0CoxAziGGs73kKydQPgxeXX/MKnYCnutCgwhVsv
        WP5QocUm41g2cKeQohsuec7SgzqGC5XhWjo+TBq/yFb39pNNCvwXCUhzdGYO8KAGHWOlF5Cqu7c
        Taz9rjXz1WJspdBwYjSdSvMjzvM/JCoPEFlqEpT8mTJsECmXNutyuBKB+lTf0Dyk=
X-Google-Smtp-Source: ABdhPJz6ca9o7Zb2UxcHfmiWYOMgxfK+ATlfbD5jLUnRA5ipNhqqxQmJEMTBA9bnY7kk9pmVoibA7Pf0fmkrug==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:6901:b0:156:4aad:fad7 with SMTP
 id j1-20020a170902690100b001564aadfad7mr16809280plk.33.1649378494200; Thu, 07
 Apr 2022 17:41:34 -0700 (PDT)
Date:   Thu,  7 Apr 2022 17:41:14 -0700
In-Reply-To: <20220408004120.1969099-1-ricarkol@google.com>
Message-Id: <20220408004120.1969099-8-ricarkol@google.com>
Mime-Version: 1.0
References: <20220408004120.1969099-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 07/13] KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1
 using sysreg.h macros
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define macros for memory type indexes and construct DEFAULT_MAIR_EL1
with macros from asm/sysreg.h.  The index macros can then be used when
constructing PTEs (instead of using raw numbers).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 24 ++++++++++++++-----
 .../selftests/kvm/lib/aarch64/processor.c     |  2 +-
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 3965a5ac778e..16753a1f28e3 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -38,12 +38,24 @@
  * NORMAL             4     1111:1111
  * NORMAL_WT          5     1011:1011
  */
-#define DEFAULT_MAIR_EL1 ((0x00ul << (0 * 8)) | \
-			  (0x04ul << (1 * 8)) | \
-			  (0x0cul << (2 * 8)) | \
-			  (0x44ul << (3 * 8)) | \
-			  (0xfful << (4 * 8)) | \
-			  (0xbbul << (5 * 8)))
+
+/* Linux doesn't use these memory types, so let's define them. */
+#define MAIR_ATTR_DEVICE_GRE	UL(0x0c)
+#define MAIR_NORMAL_WT		UL(0xbb)
+
+#define MT_DEVICE_nGnRnE	0
+#define MT_DEVICE_nGnRE		1
+#define MT_DEVICE_GRE		2
+#define MT_NORMAL_NC		3
+#define MT_NORMAL		4
+#define MT_NORMAL_WT		5
+
+#define DEFAULT_MAIR_EL1							\
+	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRE, MT_DEVICE_nGnRE) |		\
+	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_GRE, MT_DEVICE_GRE) |			\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_NC, MT_NORMAL_NC) |			\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |				\
+	 MAIR_ATTRIDX(MAIR_NORMAL_WT, MT_NORMAL_WT))
 
 #define MPIDR_HWID_BITMASK (0xff00fffffful)
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 8f4ec1be4364..c7b899ba3e38 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -134,7 +134,7 @@ void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
-	uint64_t attr_idx = 4; /* NORMAL (See DEFAULT_MAIR_EL1) */
+	uint64_t attr_idx = MT_NORMAL;
 
 	_virt_pg_map(vm, vaddr, paddr, attr_idx, 0);
 }
-- 
2.35.1.1178.g4f1659d476-goog

