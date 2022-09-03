Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2C35ABBBC
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 02:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiICAYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 20:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbiICAXj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 20:23:39 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF0510F96A
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 17:23:35 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f3-20020a056902038300b00696588a0e87so2790262ybs.3
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 17:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=Zm90K09ne4e+KMG+4RuK61bWsd6nJ7QXAeTLqBpvVKg=;
        b=mnZUE54Z/G4mfi0uThKROZg2Mw0moevDWMe5bIDSd9ESsoSjRYJM1aW8wEa7arTHZD
         bh/cJ5WCgLS5nz5NfcuiU/XLoPAX52XphItmc9mbD3dtTuOpD92Q1SXSvLVLXiedK/K7
         LkY2CrlD/CKUjM73F0/7xYr7tRbKKHuvtqQqZR42Ot4igwIGRknNqEsf+0SdDz+xMjtf
         iUEaXw7NDc8BdDWbdeXp7WN76qiMGgg6VVHqRFlvxx6M7JJ40zol9lJ8tXr6GY1EiKgB
         y/OehpJK/CNqi3v9vVNX8+zc6rCPWbvwXsvTOaZEY9i+xnNDU+vylkniiVG5bnf+uTLH
         FJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=Zm90K09ne4e+KMG+4RuK61bWsd6nJ7QXAeTLqBpvVKg=;
        b=nc9MTlx+W1/jxGVkYTu5EEOLTey/aCCzeIlhNzIl9kijC2t6ATVeL5osMJmqxjGJp3
         N2mtYBe5n8f5biyl/guZ8ymJlrDJFQKJoxTIbqChBX9yanPtZhF7PydWIq+od3GXGXyO
         pbScdJlc96aJ+UmYlWpBjUa3+Nf53SFYgRPzkPj6lIFA17UadFeJjfQcX/fB3Kv8hbYp
         ZH4SeY6VYFCPCT0P7+PwEsWfTid7Nrevy76Zg5WpPhwFvGqoT2mzznSKloBh2ndX9+Rq
         AXArKao2GfFK1YMVA4KY9ejo16AjEL78wrpbwpD7OXTUdc0Pq/e8IUWBJ4fAbLpUykTb
         o2Kw==
X-Gm-Message-State: ACgBeo08l2vZIjkp97UNZtIfkjOuW5gqoHoXKCjhPuiPglpUr4MIdJgA
        rlvehcYv/igmB3JdC9WFsDoyiVGGUBs=
X-Google-Smtp-Source: AA6agR4JUP9HO/T94ylnDwrrzZGAMzLP2uvpdPfOm6Hmvv1aHumDUXYr27jV8Lcu9iSJ+n8+41gLJtUcJdA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e401:0:b0:66e:280a:98cd with SMTP id
 b1-20020a25e401000000b0066e280a98cdmr24309232ybh.540.1662164614572; Fri, 02
 Sep 2022 17:23:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  3 Sep 2022 00:22:52 +0000
In-Reply-To: <20220903002254.2411750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220903002254.2411750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220903002254.2411750-22-seanjc@google.com>
Subject: [PATCH v2 21/23] KVM: SVM: Handle multiple logical targets in AVIC
 kick fastpath
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
bailing if there is more than one target.  Now that KVM inhibits AVIC if
vCPUs aren't mapped 1:1 with logical IDs, each bit in the destination is
guaranteed to match to at most one vCPU, i.e. iterating over the bitmap
is guaranteed to kick each valid target exactly once.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 112 ++++++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index e34b9baa9ee0..39b367a14a8c 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -354,6 +354,50 @@ static void avic_kick_vcpu(struct kvm_vcpu *vcpu, u32 icrl)
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
+	if (avic_logical_id_table) {
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
 /*
  * A fast-path version of avic_kick_target_vcpus(), which attempts to match
  * destination APIC ID to vCPU without looping through all vCPUs.
@@ -361,11 +405,10 @@ static void avic_kick_vcpu(struct kvm_vcpu *vcpu, u32 icrl)
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
@@ -382,14 +425,14 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
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
@@ -409,50 +452,21 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 		if (unlikely(!bitmap))
 			return 0;
 
-		if (!is_power_of_2(bitmap))
-			/* multiple logical destinations, use slow path */
-			return -EINVAL;
-
-		logid_index = cluster + __ffs(bitmap);
-
-		if (apic_x2apic_mode(source)) {
-			/*
-			 * For x2APIC, the logical APIC ID is a read-only value
-			 * that is derived from the x2APIC ID, thus the x2APIC
-			 * ID can be found by reversing the calculation (done
-			 * above).  Note, bits 31:20 of the x2APIC ID are not
-			 * propagated to the logical ID, but KVM limits the
-			 * x2APIC ID limited to KVM_MAX_VCPU_IDS.
-			 */
-			l1_physical_id = logid_index;
-		} else {
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
-		}
+		if (apic_x2apic_mode(source))
+			avic_logical_id_table = NULL;
+		else
+			avic_logical_id_table = page_address(kvm_svm->avic_logical_id_table_page);
+
+		/*
+		 * AVIC is inhibited if vCPUs aren't mapped 1:1 with logical
+		 * IDs, thus each bit in the destination is guaranteed to map
+		 * to at most one vCPU.
+		 */
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
2.37.2.789.g6183377224-goog

