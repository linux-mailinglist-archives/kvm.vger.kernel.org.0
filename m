Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7142565F8F2
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbjAFBRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbjAFBQS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:16:18 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52EB365ADA
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 17:14:20 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id z17-20020a256651000000b007907852ca4dso396885ybm.16
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 17:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=G/xMBTyIGc3/xkevi67fvj8wyXuCW/OQud7CJpQaZ3I=;
        b=d6QlI5kw/H8GG/AjdSQEB/z5oht/Dlvzb9pO6xzHuZuAfEpDPK0ubjoADbbBmfnpip
         lWPSmAFPSaimE6lYMZceH/Dq8aCshL0Uyq6vA0W4P5OLUz3h5Vf5ONtVay7T/m59CFem
         DMJdWK90qXXkUTFbGZuPDdtyzYWxe8hii8trgtihyNeKBPcmz5CtIFQ/23aaAfs94xsl
         Sg4uVP8j8Dy9Mt38n+KhVJN6fk52HJx9m33qQD1GeqhFFIKqoZkU98q5/5BQS5/EonhA
         +b0dawmxW7RqY0D6xUNS6b67hvED4rvw20R73gddAGkTQezXNkdFYleIciX/WQAf7W+I
         ZeYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G/xMBTyIGc3/xkevi67fvj8wyXuCW/OQud7CJpQaZ3I=;
        b=Qdl1SEA+eIOqDCSp3nis3YXsGZzDUmQnJT12YZ8lzATKXDgDVI8ijccP9xhTWFsXGz
         hTAebbEs1qBgWYROnHt/PTPbpEB0LG8FXOe0X6DuQm1rJZ1DRxagEdGr6otwQskmo4lN
         RLW1zutAIGvsD2UjtTXe7hlsVgZyUncs3fX696W4EcYl/tnyp4DOCiT18MUTaNbjfCmn
         8L0HboPDs8gNDdOg8OevW2z1A8jjdqKNSS8skSS/PWO0IiWfEECkWiMi29xfdEFABVgn
         4DDwxEq76wrMSb/Wg6wsO0Ys6Ay7jH6E6gr5GvBp8BpkxXV9StSSSvAp/ogsm67eqtR/
         xIPQ==
X-Gm-Message-State: AFqh2kqOr5c9Xr6Y3Yj0lXwM72KAN56Rtrq6xWkDsTjasUO5yCnsE8a+
        zy7V28yQtJmJdN6KGHze/QTInB4SNwc=
X-Google-Smtp-Source: AMrXdXtJ8A+dklY8RabbB87iQeh3UphH07RFupduopzL4/GE/67V7Z6y5SX3TO8pDN528R2ZOzCaLSqapgs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:bd0a:0:b0:7b3:f488:ea6d with SMTP id
 f10-20020a25bd0a000000b007b3f488ea6dmr674590ybk.311.1672967640100; Thu, 05
 Jan 2023 17:14:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  6 Jan 2023 01:13:00 +0000
In-Reply-To: <20230106011306.85230-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230106011306.85230-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230106011306.85230-28-seanjc@google.com>
Subject: [PATCH v5 27/33] KVM: SVM: Require logical ID to be power-of-2 for
 AVIC entry
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

Do not modify AVIC's logical ID table if the logical ID portion of the
LDR is not a power-of-2, i.e. if the LDR has multiple bits set.  Taking
only the first bit means that KVM will fail to match MDAs that intersect
with "higher" bits in the "ID"

The "ID" acts as a bitmap, but is referred to as an ID because there's an
implicit, unenforced "requirement" that software only set one bit.  This
edge case is arguably out-of-spec behavior, but KVM cleanly handles it
in all other cases, e.g. the optimized logical map (and AVIC!) is also
disabled in this scenario.

Refactor the code to consolidate the checks, and so that the code looks
more like avic_kick_target_vcpus_fast().

Fixes: 18f40c53e10f ("svm: Add VMEXIT handlers for AVIC")
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 5b33f91b701c..eb979695e7d8 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -513,26 +513,26 @@ unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu)
 static u32 *avic_get_logical_id_entry(struct kvm_vcpu *vcpu, u32 ldr, bool flat)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
-	int index;
 	u32 *logical_apic_id_table;
-	int dlid = GET_APIC_LOGICAL_ID(ldr);
+	u32 cluster, index;
 
-	if (!dlid)
-		return NULL;
+	ldr = GET_APIC_LOGICAL_ID(ldr);
 
-	if (flat) { /* flat */
-		index = ffs(dlid) - 1;
-		if (index > 7)
+	if (flat) {
+		cluster = 0;
+	} else {
+		cluster = (ldr >> 4);
+		if (cluster >= 0xf)
 			return NULL;
-	} else { /* cluster */
-		int cluster = (dlid & 0xf0) >> 4;
-		int apic = ffs(dlid & 0x0f) - 1;
-
-		if ((apic < 0) || (apic > 7) ||
-		    (cluster >= 0xf))
-			return NULL;
-		index = (cluster << 2) + apic;
+		ldr &= 0xf;
 	}
+	if (!ldr || !is_power_of_2(ldr))
+		return NULL;
+
+	index = __ffs(ldr);
+	if (WARN_ON_ONCE(index > 7))
+		return NULL;
+	index += (cluster << 2);
 
 	logical_apic_id_table = (u32 *) page_address(kvm_svm->avic_logical_id_table_page);
 
-- 
2.39.0.314.g84b9a713c41-goog

