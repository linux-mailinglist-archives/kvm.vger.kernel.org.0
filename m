Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D03C5BDB3E
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 06:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiITEPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 00:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiITEPU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 00:15:20 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F58D27CCC
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:15:19 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i201-20020a253bd2000000b006b28b887dbaso1095327yba.13
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=tN5R5SopzaHGArjvbV8A2BOgjZV2vImyuFPHiE9aLpQ=;
        b=OD3j4c/XoEVXRO9oLsaY42jyUA2VwddvzESrRdjWxgKGPxEpd2qlVSViY5f6ixALw9
         5ouok9TQns81DIsyKfG1YzqhyLnsHu7V56IQC8CqHw28aDN7IL+n5oeKBoQ7RhAB2Knl
         uFMjKvpl+Fahi3gAJOyKipMxZkWbvAH/znpWa+AnVUjy602GLU/pQ1/aoiwuda6PgnCj
         zP3jMqcXsWFB9aejNKEFkR+V/seL7qIr0Ow9wNIVHUwxd0HhsOInF5iLJlhVXS+goNms
         7TQkqlCECTYjZqKNoTKqm8CbR1Z2VU8PoJDL679W17HQJO10AJmkse3KNqq+xOpowTml
         f8Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=tN5R5SopzaHGArjvbV8A2BOgjZV2vImyuFPHiE9aLpQ=;
        b=mo4Vqq+V6SzO43WgQhcO8n4+SY9KIhyDsMz8XVSTLFOPwJZlk2VzY7Uma5vJfOVQ8u
         4qbqtan3Z6RSvY2DX4OEWhM0Cml8LDBejBzOuCh3XPeHp0CIIgegmlALfpKskEZguNWx
         keCJ4ytNPZsXqrhtw/gLgXsxXik2Jih3sV/UCdFOUg+RLdupn4Kpzvdpn6cfRj6eTVcC
         gsbvHTjYhmXSRp+HzSLoX/A7Zxscl1j07VZ/AJkopq9UaK8GekR5Q1mZ7kce5LCJrAQx
         HIYhhOAb/x3qEQLxg5GVFEEZ34xneWRWc/kc2EJxrMwPZ81C3P1SJK0BkIKtGnHWEnky
         KyaQ==
X-Gm-Message-State: ACrzQf3/5OMobAy9U/ZrATSwJiDTavxzKPBoIrUHkDFLYMj1VWeQSg9w
        b+RTIkRhDGzKfNw5fsrVXLXDBqEA0NTiBh6A/D1Fy/OLi8tkgCqcyBYQWtjm4JVj+yRTgMP/JQi
        skCAKWEOP6bh5tJoy76Xk8XArTF2fXxM4vpg8vBB7Wk3wK1a0wVsq5kRX2O1Lt80=
X-Google-Smtp-Source: AMsMyM4EHHeL483VfBA/mBkUN2XhgWB7wXX9kQQujXR7L0SZ3JPXSogQMzX2W6u3RS05ur7mfikXosglo0XPLg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:b09:0:b0:345:30d:77b7 with SMTP id
 9-20020a810b09000000b00345030d77b7mr17479125ywl.177.1663647318653; Mon, 19
 Sep 2022 21:15:18 -0700 (PDT)
Date:   Tue, 20 Sep 2022 04:15:00 +0000
In-Reply-To: <20220920041509.3131141-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220920041509.3131141-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920041509.3131141-5-ricarkol@google.com>
Subject: [PATCH v6 04/13] KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1
 using sysreg.h macros
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
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

Define macros for memory type indexes and construct DEFAULT_MAIR_EL1
with macros from asm/sysreg.h.  The index macros can then be used when
constructing PTEs (instead of using raw numbers).

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Oliver Upton <oupton@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 25 ++++++++++++++-----
 .../selftests/kvm/lib/aarch64/processor.c     |  2 +-
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index df4bfac69551..c1ddca8db225 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -38,12 +38,25 @@
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
+#define MAIR_ATTR_NORMAL_WT	UL(0xbb)
+
+#define MT_DEVICE_nGnRnE	0
+#define MT_DEVICE_nGnRE		1
+#define MT_DEVICE_GRE		2
+#define MT_NORMAL_NC		3
+#define MT_NORMAL		4
+#define MT_NORMAL_WT		5
+
+#define DEFAULT_MAIR_EL1							\
+	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRnE, MT_DEVICE_nGnRnE) |		\
+	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRE, MT_DEVICE_nGnRE) |		\
+	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_GRE, MT_DEVICE_GRE) |			\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_NC, MT_NORMAL_NC) |			\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |				\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_WT, MT_NORMAL_WT))
 
 #define MPIDR_HWID_BITMASK (0xff00fffffful)
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 63ef3c78e55e..26f0eccff6fe 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -133,7 +133,7 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
-	uint64_t attr_idx = 4; /* NORMAL (See DEFAULT_MAIR_EL1) */
+	uint64_t attr_idx = MT_NORMAL;
 
 	_virt_pg_map(vm, vaddr, paddr, attr_idx);
 }
-- 
2.37.3.968.ga6b4b080e4-goog

