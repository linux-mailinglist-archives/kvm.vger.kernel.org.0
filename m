Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071DC5F17DA
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbiJABCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232820AbiJABBe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:01:34 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A2CBC901
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:00:06 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id u10-20020a056a00098a00b00543b3eb6416so3629159pfg.15
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=nUyKM2pzOQLrRGLlm654j+76cYaRMmTuDJ0UvD4UD8Q=;
        b=B9W/qzV4dQC/CdcbWv3QfbqzmJcMMkm/9VR3lXIqt/GKJak7moqdjAjWuteO/a5ji7
         iUxoOlyiYS6lKBRx67amtbyddD3VhD8zNnBBLkHFraDW39sD1RVVxfpv1dnTFAOlYUCu
         hN/K5FfrHqMunJ9R2LPo0zEEoYThwJGPCjDnvNas9kkEmjlWlk0IM5NpV4VookejGlzF
         S8qzc063fnhL1DD0wGsUjjG4wCamSAeC2VxPOx1wT56KhOx7HAJ3DT968jDhAyVcjNXc
         W0413T+2MLyO5fOs3yyC8+wDNDSpdhK7fQRH3FClBV2Lew2GbnyL1kLLDBAlqfgt4ArG
         3piw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=nUyKM2pzOQLrRGLlm654j+76cYaRMmTuDJ0UvD4UD8Q=;
        b=VnOanF5hwt033sIsvYckRK36Xsl2iV2HyYi6Ykc+YmJ8uzijTm1pzMrMxVjneTZFuP
         fLoUBn7onbWagILKpeSGRJsKP3pL51gQ820WYXPUiWOwhFNdpuiL8hBljEnOePnhtl6K
         Lulq+PiTOfRRO2PvnzkOeZ/oDqvkroglVGfQtyR4aSkDJCM0V189q1zu1PScYJpePP2P
         IasoKVighEcKk+fUd1p2nP2SLnNybRdimAJsruPS6YaGMqDm2UQLAHS29z/aKlwvJzMc
         qPEPDVck0SmG/QSetsPpPGatsn4ZZxlUyWU2/MCxXbZC6NjwyMOl40MjeXt/dwAUxKuS
         us4Q==
X-Gm-Message-State: ACrzQf3DWT9/w8SghMcXtCkZWHr1JUfBtcHsQ9wz9Bt7TByE4EFfpUga
        rqy9EI/99Sk85u+C05Ilsfn3Djrp0gA=
X-Google-Smtp-Source: AMsMyM5oK8ANajLs1pa1CZ8JDzjsdtDhN8aSNXjuvEw5JOnJP3ccHNu+F11TWKlHW6K4K1Yvvws63BWUjJI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:cd06:b0:203:ae0e:6a21 with SMTP id
 d6-20020a17090acd0600b00203ae0e6a21mr515981pju.0.1664586005501; Fri, 30 Sep
 2022 18:00:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:59:11 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-29-seanjc@google.com>
Subject: [PATCH v4 28/32] KVM: SVM: Require logical ID to be power-of-2 for
 AVIC entry
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

Do not modify AVIC's logical ID table if the logical ID portion of the
LDR is not a power-of-2, i.e. if the LDR has multiple bits set.  Taking
only the first bit means that KVM will fail to match MDAs that intersect
with "higher" bits in the "ID"

The "ID" acts as a bitmap, but is referred to as an ID because theres an
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
index 4b6fc9d64f4d..a9e4e09f83fc 100644
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
+		cluster = (ldr >> 4) << 2;
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
2.38.0.rc1.362.ged0d419d3c-goog

