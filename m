Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DFD5A72B0
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbiHaAhP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbiHaAgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:36:51 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A78425C3
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:38 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h5-20020a636c05000000b00429fa12cb65so6296615pgc.21
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=9lPsDa4uoIpB1TtG0KKHt7fahMUYRjr92cuUCEQolSA=;
        b=LlD9FTSgHb6L5Zv8qjIw+XDeJxa4BQaZ58WNL3BSpHwcUi8O8RkncM1V+t7kiJ106g
         1zUqCPBcnIZfBu90aA8Ckd6Ps3a1cyvDQJCvx6dPlPQAnITZrVcgWaNm8Qg9iRKb2M09
         jNppD5V0BqocNd+wVCeDYAH3e6WtlRhDTcnhmeDcLA2OUfkpIVF9KEGMJ8l16QuGvuZN
         COSSD46FEd5zuLR+LzH/kG5elBK4Rx+jG7GkJ0sAyH0cNnMUgSH2w4PQyLbBM0pyPXO1
         MugeGJI8v+/V5MHQ3s9vQjWbYpfeOmXkMKOTrmh5/OJp0Dkc1rJl+pkzXmirdjWDcTcj
         ARgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=9lPsDa4uoIpB1TtG0KKHt7fahMUYRjr92cuUCEQolSA=;
        b=zuh9CU5UDrZAhhJO2ZGuFKAtQBJAfTVzK8G48yUpzotYczVuRwu1Fz3QPu9eab7nHH
         MuzG2vLYvIMnY4ZESFokM9+Bp+NSiukXG5w/93ALYixVSe1noq4pKCu5bmfm+Xf0g/IR
         BPofZk+2jVBOd2u9M65GZxZ81xSoSH7Ziwx6Y8UbJtUhAZiRq9KSejoxoIDMEduZ687a
         6LbrtfKmL+YCJpjP4O1F93J/jT4ykMs5j8T4fLCsYNMoaXpG0owQmBYgeBUVd4lwmxHF
         AUvDCrYcQQ0TCoKtZwPO9A8i2ZgR2Bh1SqAwBfc4mXZMLi4jZS6QiyCjY6crTJkzxlUM
         V3lw==
X-Gm-Message-State: ACgBeo0SADxpdaP+REVRTsVWao6FOFRi52NnSgVzKbnq33Q880EzCIHw
        PMrn+9tAts5z0zmNS3GhYxGiVeWK0qs=
X-Google-Smtp-Source: AA6agR6O/f1DFJZk6NAJUI6x8V5vzDybX6/EAvFj0v0O/b3Oy9wZI6KKeW14bvX07ZUrqHNogRQE4/P9jEo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:27a0:b0:52f:8766:82ec with SMTP id
 bd32-20020a056a0027a000b0052f876682ecmr23973929pfb.17.1661906137953; Tue, 30
 Aug 2022 17:35:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:35:04 +0000
In-Reply-To: <20220831003506.4117148-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220831003506.4117148-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831003506.4117148-18-seanjc@google.com>
Subject: [PATCH 17/19] KVM: SVM: Handle multiple logical targets in AVIC kick fastpath
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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

Iterate over all target logical IDs in the AVIC kick fastpath instead of
bailing if there is more than one target and KVM's optimized APIC map is
enabled for logical mode.  If the optimized map is enabled, all vCPUs are
guaranteed to be mapped 1:1 to a logical ID or effectively have logical
mode disabled, i.e. iterating over the bitmap is guaranteed to kick each
target exactly once.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 126 +++++++++++++++++++++++++---------------
 1 file changed, 79 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 2095ece70712..dad5affe44c1 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -339,6 +339,62 @@ static void avic_kick_vcpu(struct kvm_vcpu *vcpu, u32 icrl)
 					icrl & APIC_VECTOR_MASK);
 }
 
+static void avic_kick_vcpu_by_physical_id(struct kvm *kvm, u32 physical_id,
+					  u32 icrl)
+{
+	/*
+	 * KVM inhibits AVIC if any vCPU ID diverges from the vCPUs APIC ID,
+	 * i.e. APIC ID == vCPU ID.
+	 */
+	struct kvm_vcpu *target_vcpu = kvm_get_vcpu_by_id(kvm, physical_id);
+
+	/* Once again, nothing to do if the target vCPU doesn't exist. */
+	if (unlikely(!target_vcpu))
+		return;
+
+	avic_kick_vcpu(target_vcpu, icrl);
+}
+
+static void avic_kick_vcpu_by_logical_id(struct kvm *kvm, u32 *avic_logical_id_table,
+					 u32 logid_index, u32 icrl)
+{
+	u32 physical_id;
+
+	if (!avic_logical_id_table) {
+		u32 logid_entry = avic_logical_id_table[logid_index];
+
+		/* Nothing to do if the logical destination is invalid. */
+		if (unlikely(!(logid_entry & AVIC_LOGICAL_ID_ENTRY_VALID_MASK)))
+			return;
+
+		physical_id = logid_entry &
+			      AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK;
+	} else {
+		/*
+		 * For x2APIC, the logical APIC ID is a read-only value that is
+		 * derived from the x2APIC ID, thus the x2APIC ID can be found
+		 * by reversing the calculation (stored in logid_index).  Note,
+		 * bits 31:20 of the x2APIC ID aren't propagated to the logical
+		 * ID, but KVM limits the x2APIC ID limited to KVM_MAX_VCPU_IDS.
+		 */
+		physical_id = logid_index;
+	}
+
+	avic_kick_vcpu_by_physical_id(kvm, physical_id, icrl);
+}
+
+static bool is_optimized_logical_map_enabled(struct kvm *kvm)
+{
+	struct kvm_apic_map *map;
+	bool enabled;
+
+	rcu_read_lock();
+	map = rcu_dereference(kvm->arch.apic_map);
+	enabled = map && map->logical_mode != KVM_APIC_MODE_MAP_DISABLED;
+	rcu_read_unlock();
+	return enabled;
+}
+
 /*
  * A fast-path version of avic_kick_target_vcpus(), which attempts to match
  * destination APIC ID to vCPU without looping through all vCPUs.
@@ -346,11 +402,10 @@ static void avic_kick_vcpu(struct kvm_vcpu *vcpu, u32 icrl)
 static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source,
 				       u32 icrl, u32 icrh, u32 index)
 {
-	u32 l1_physical_id, dest;
-	struct kvm_vcpu *target_vcpu;
 	int dest_mode = icrl & APIC_DEST_MASK;
 	int shorthand = icrl & APIC_SHORT_MASK;
 	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
+	u32 dest;
 
 	if (shorthand != APIC_DEST_NOSHORT)
 		return -EINVAL;
@@ -367,14 +422,14 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 		if (!apic_x2apic_mode(source) && dest == APIC_BROADCAST)
 			return -EINVAL;
 
-		l1_physical_id = dest;
-
-		if (WARN_ON_ONCE(l1_physical_id != index))
+		if (WARN_ON_ONCE(dest != index))
 			return -EINVAL;
 
+		avic_kick_vcpu_by_physical_id(kvm, dest, icrl);
 	} else {
-		u32 bitmap, cluster;
-		int logid_index;
+		u32 *avic_logical_id_table;
+		unsigned long bitmap, i;
+		u32 cluster;
 
 		if (apic_x2apic_mode(source)) {
 			/* 16 bit dest mask, 16 bit cluster id */
@@ -394,50 +449,27 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 		if (unlikely(!bitmap))
 			return 0;
 
-		if (!is_power_of_2(bitmap))
-			/* multiple logical destinations, use slow path */
+		/*
+		 * Use the slow path if more than one bit is set in the bitmap
+		 * and KVM's optimized logical map is disabled to avoid kicking
+		 * a vCPU multiple times.  If the optimized map is disabled, a
+		 * vCPU _may_ have multiple bits set in its logical ID, i.e.
+		 * may have multiple entries in the logical table.
+		 */
+		if (!is_power_of_2(bitmap) &&
+		    !is_optimized_logical_map_enabled(kvm))
 			return -EINVAL;
 
-		logid_index = cluster + __ffs(bitmap);
-
-		if (!apic_x2apic_mode(source)) {
-			u32 *avic_logical_id_table =
-				page_address(kvm_svm->avic_logical_id_table_page);
-
-			u32 logid_entry = avic_logical_id_table[logid_index];
-
-			if (WARN_ON_ONCE(index != logid_index))
-				return -EINVAL;
-
-			/* Nothing to do if the logical destination is invalid. */
-			if (unlikely(!(logid_entry & AVIC_LOGICAL_ID_ENTRY_VALID_MASK)))
-				return 0;
-
-			l1_physical_id = logid_entry &
-					 AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK;
-		} else {
-			/*
-			 * For x2APIC, the logical APIC ID is a read-only value
-			 * that is derived from the x2APIC ID, thus the x2APIC
-			 * ID can be found by reversing the calculation (done
-			 * above).  Note, bits 31:20 of the x2APIC ID are not
-			 * propagated to the logical ID, but KVM limits the
-			 * x2APIC ID limited to KVM_MAX_VCPU_IDS.
-			 */
-			l1_physical_id = logid_index;
-		}
+		if (apic_x2apic_mode(source))
+			avic_logical_id_table = NULL;
+		else
+			avic_logical_id_table = page_address(kvm_svm->avic_logical_id_table_page);
+
+		for_each_set_bit(i, &bitmap, 16)
+			avic_kick_vcpu_by_logical_id(kvm, avic_logical_id_table,
+						     cluster + i, icrl);
 	}
 
-	/*
-	 * KVM inhibits AVIC if any vCPU ID diverges from the vCPUs APIC ID,
-	 * i.e. APIC ID == vCPU ID.  Once again, nothing to do if the target
-	 * vCPU doesn't exist.
-	 */
-	target_vcpu = kvm_get_vcpu_by_id(kvm, l1_physical_id);
-	if (unlikely(!target_vcpu))
-		return 0;
-
-	avic_kick_vcpu(target_vcpu, icrl);
 	return 0;
 }
 
-- 
2.37.2.672.g94769d06f0-goog

