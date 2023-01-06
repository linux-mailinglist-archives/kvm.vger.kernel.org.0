Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD6B65F8F3
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbjAFBRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbjAFBQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:16:28 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D8765AE2
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 17:14:21 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id m5-20020a056a00164500b005825b8d2723so26149pfc.21
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 17:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kgKvdTfQ27wv6seVSF5aAgO210OBrcuZvgQgigmAgek=;
        b=WJv9DzW7OiR5WxhCTMswF2puPwUNWRNLasJ4h3JJ3mwxe13GYAmZ+MCwjs0kXjBg0v
         Mv0JiXikj5UXUyf3Q7VFTI2RxiiDCS1Aq09YHScmHzn6YK2l0qRFB9713Vqmf/At92QU
         VPHkLv78SiClzvEy/3z0eV1D60+5F5LDoiilczrSvFYkD9QMY8xo+LGRGsiTe9hsxoWp
         U2Z8DnSXNNc0TXoqRwMqEuldIle0PtrgK4nbuO8TK4nvH+DBn6o0uAMPPiU4ZIWgCCOe
         0ucXFRf10VCnvSydh5GnIZD2vQJCE6fnMFBK+e5WubcHBAvjx8hJUemWLu/Fwlgdffie
         Qnxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kgKvdTfQ27wv6seVSF5aAgO210OBrcuZvgQgigmAgek=;
        b=pBgZe6l04TPHZxhyOBdOl4CQaBfr8Gmxhhm4zu92LLG3YpzWNCSdA41SiGDn0D72YA
         1D3OpBjYpanzSBNHtEaZUTutIO7GAGqhDi/+AxAODxK+gIpKL+33BY6B1N6TKE9QhI3M
         M9Wj15Ry99FCp1Nm6XnNeXP4tOkgPw1hqSaLD4cw7v78JWn56IrIaG8OV8GTZ6rilB7G
         s/6HAwrMPF06UPrwMNL+XHjf2JicvvdjxN18G3Wo20m167YNq43qspnJyfewBvtLx2gL
         1hVhDxFB6nmVUI3lRw0fInHmFmkE/SPK8pQq/oJs4mAkXbV4xyXaEeptFMJ3M+4E5bvC
         JxOw==
X-Gm-Message-State: AFqh2krDG+WQsS32A1RRAyBkQOPUIh5GIOX5CetZArghzO+pE5vYGFYA
        0zEFutin0eMeaWrMpLYIartorXbPbj0=
X-Google-Smtp-Source: AMrXdXuJbFofIitOc/6xWYIyeZDywhl+ROr6/sAMLkCKVeOGD0jStiz6cC6dnMAksAsxqesy3qXq724fV8w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:bd12:b0:225:b164:8874 with SMTP id
 y18-20020a17090abd1200b00225b1648874mr4020777pjr.87.1672967641623; Thu, 05
 Jan 2023 17:14:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  6 Jan 2023 01:13:01 +0000
In-Reply-To: <20230106011306.85230-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230106011306.85230-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230106011306.85230-29-seanjc@google.com>
Subject: [PATCH v5 28/33] KVM: SVM: Handle multiple logical targets in AVIC
 kick fastpath
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>,
        Greg Edwards <gedwards@ddn.com>
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 112 ++++++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index eb979695e7d8..2c6737f72bd4 100644
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
2.39.0.314.g84b9a713c41-goog

