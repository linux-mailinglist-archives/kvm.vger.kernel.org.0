Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085295F17DD
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbiJABCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbiJABB3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:01:29 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849D3BC46E
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:00:07 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u5-20020a170902e80500b00178944c46aaso4239219plg.4
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=YTbh5SVbnv6xk8cQZQzs+Vw8pUphpzRbEkyNKpFeLvc=;
        b=WDXPv/yH8vlhsGYGSmlQDHHU9S1m265iTQdXcLeqZ7fw/zb4O+oIfuXvU4i1cYX/GT
         1liJNlh0WmRjS85Af6CHQjmXMzdseoelxczqS9i1KY7RbYBpSSNhTu2pAVrcQ1lCxqrP
         O7vXq7x2xznCUkUwtknS2sPHuns2ax3sayQj5DQxIVwLBvI5aBV+FBhBAwOHcIeNMM+v
         Lmo0qNo/NXAC1Jv2dodA/y2xbHmQstOYF2krP3/uirqp4hD25Fdl2kW/bkZZQooGLj4X
         RzMfbwaUvQ3lVnzqBw3XtZ6slZH+XOI6m9Ey8WbDuuyA6v4dwultlNaVaxAnYuBqjfzA
         rM0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=YTbh5SVbnv6xk8cQZQzs+Vw8pUphpzRbEkyNKpFeLvc=;
        b=jOWAiSE+x/xyywJFt+6ytJCAczrw9n6ae5HeAt3h+MOf63POen5GmCf1yS4qLiD4id
         ximdU0gmMbbXqz++IoOk2hhYL2KAOik71rMS6B5PJyZ8IlGvrDNmdCjh2srzZQG8xNLl
         P8ECk9JjmkhLj/gCAGXEyeGfhKuM3E5musY/b2eyxCzw7qKjCuhDB4M49e5FKms3mIu0
         ZWLWNhMD2nuu5ES6wIepGDixQN7is9lSVGu5fadNm5/eTQ+Jt5GwHJCeb0S6idhSZcRB
         kUkn8kGq/ypEAQ+y4tOCe/A6FmO4uzFZBxYp1N3szK60kKl5WGAo4LIrX3DH9PAnkLjA
         Nsmg==
X-Gm-Message-State: ACrzQf1yma0tZbkRKOGEHiWEg5QvUxCnAqM3vxZELTT+dnSFeHHLRQRC
        yEa2F91rmcVLn2rmqZrZa3btgTc6SUA=
X-Google-Smtp-Source: AMsMyM7PI3AQtLJqRP1h/kpfCtVdzUjYOms2t77qz2oeWuTeftcu+fehBnr/rUsNUWyNF4MOP/0diTk6myA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:9851:0:b0:53e:87eb:1ffa with SMTP id
 n17-20020aa79851000000b0053e87eb1ffamr11737536pfq.35.1664586007418; Fri, 30
 Sep 2022 18:00:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:59:12 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-30-seanjc@google.com>
Subject: [PATCH v4 29/32] KVM: SVM: Handle multiple logical targets in AVIC
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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
2.38.0.rc1.362.ged0d419d3c-goog

