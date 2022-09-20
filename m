Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7C25BF14F
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiITXee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbiITXd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:33:57 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9947963E
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:32 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d7-20020a170903230700b00177f6dd8472so2622544plh.6
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=Y2mxingAcVD8OpNkNaphL85hmhgxmTn5FoNS+KNkw44=;
        b=VXXXTJ7BYRbG6nlbu1VrzgvdMyEqH7d/1MLymukG0AlmT4n6X+NbTQ2lFJp6AUgihb
         UckV68pN4vFFgBWpSSt/yDj6/ng/oKfte/WZ5xOa8GbxHNBEfVoh8SPINEhER0Ua2xHk
         O0Ms8lYzWhIujGxRPPN2w83e1Q0De5DOxpUtg/vysHiYXbDOBCQaBl48QatM9IakooKt
         GO9+EVhJezFOvESkn4ty5fpDAPYLdBqypAurI/smVBYREQCLwqo0HQktgM8wVw152Lac
         KotVR95bDLBcLpsG70H3qyLzpOB9ZblrhY3MZESQqjW0sovtqQ3UIFGyrWuFC6Cw/49Z
         HTyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=Y2mxingAcVD8OpNkNaphL85hmhgxmTn5FoNS+KNkw44=;
        b=M0P0rrXjAKBojbM8BaImAPMDwgu7ADDjwIW3xUwaWHpJxD+6NvEfg1ANjW7wWcFij1
         R8QxgqkBwD1NE4vVlKQZ/aU6L/7vS+Tk4CMU+6auGuktbn/uPZVF7KK6rrIck8MiGy09
         IIWe9KU2zw/qwRP4DuKkHQxIlHnSP/pPV/TS53szDd69Sy9+Dm1cnMlIpnUiXY0UzYFB
         W+5nYCgISBBccpYrRNoavMhklNTY8YbE2IDNJpn76nLizmm5K2w2K8uvXaqA/RfQfvNi
         htiq0ob30SykJSa76161cNu6KWVLFsiJLwA304RFud7Hgz+8uDxqH7mZEeLF+RyQSTT7
         ydtw==
X-Gm-Message-State: ACrzQf2PTNf1/wtDMr1MSsh0gotT2s2xNZByzLk8Ql6vjX5Zqw38Q/jZ
        QSw2ih3k9KYOMCK+vG+sEB2mGX4gtyw=
X-Google-Smtp-Source: AMsMyM45cFB+sFZ2HPiwgd8z39M26jt6cxDGyOAb+0DvcJ/ne4uMQy089f0gQoOJSHIg70PjLvXy5xmNUME=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2104:b0:176:a9ef:418b with SMTP id
 o4-20020a170903210400b00176a9ef418bmr1946412ple.134.1663716741153; Tue, 20
 Sep 2022 16:32:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:32 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-27-seanjc@google.com>
Subject: [PATCH v3 26/28] KVM: SVM: Handle multiple logical targets in AVIC
 kick fastpath
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
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
index a9e4e09f83fc..17e64b056e4e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -327,6 +327,50 @@ static void avic_kick_vcpu(struct kvm_vcpu *vcpu, u32 icrl)
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
@@ -334,11 +378,10 @@ static void avic_kick_vcpu(struct kvm_vcpu *vcpu, u32 icrl)
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
@@ -355,14 +398,14 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
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
@@ -382,50 +425,21 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
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
2.37.3.968.ga6b4b080e4-goog

