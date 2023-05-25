Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3C771144F
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 20:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241946AbjEYSgQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 14:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241810AbjEYSfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 14:35:53 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F1D10C4
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 11:34:27 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1q2Fn0-004iLI-8V; Thu, 25 May 2023 20:34:18 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=SHVweY2CMvk4sKOQvJToUzCaBD8mHXCN5HSp1yN28lA=; b=GQO/qQfr9w6bb/U4m7DkZY6OCX
        GLit98z+mS1vAeW7VI+xjFhfkfo3RAX8+QNw0ZVh8RLEygcHR6q4QoQW6z/uTUsctZGLH+jzMUo/O
        45RuOEybBiUy6UFBV73BB0XeDG1jvl6HOtkqEDuwLnOHZvbGKMgQ4ZHAmParYXb5ISlhxY8fq8xkt
        Ap2HjkgpzctSqMqRjoq8hN+1PyDNUVOWT6YpWxFC8wJi+Q1tfj2PXIwPq9AvbPa808lArLxmiPlxr
        /lYe6mREJD+mo0eSt4sdLlz46F8OlT/0gb45IYvUJH3wEzaJUihXv8WNQXgETS/xsN1U9fxja6I/w
        1NkKcHIg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1q2Fmz-0006XF-EP; Thu, 25 May 2023 20:34:17 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1q2Fms-00047d-KJ; Thu, 25 May 2023 20:34:10 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     seanjc@google.com
Cc:     pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 2/3] KVM: x86: Simplify APIC ID selection in kvm_recalculate_phys_map()
Date:   Thu, 25 May 2023 20:33:46 +0200
Message-Id: <20230525183347.2562472-3-mhal@rbox.co>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230525183347.2562472-1-mhal@rbox.co>
References: <20230525183347.2562472-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the comments and condense the code.
No functional change intended.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
Perhaps, as it was suggested by Maxim in [1], it would be a good moment to
change kvm_recalculate_phys_map() to return bool?

https://lore.kernel.org/kvm/e90e4c4bd558b9e41acea9f8ce84783e7341c9b4.camel@redhat.com/

 arch/x86/kvm/lapic.c | 42 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 39b9a318d04c..7db1c698f6da 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -223,10 +223,10 @@ static int kvm_recalculate_phys_map(struct kvm_apic_map *new,
 				    struct kvm_vcpu *vcpu,
 				    bool *xapic_id_mismatch)
 {
+	bool x2format = vcpu->kvm->arch.x2apic_format;
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u32 x2apic_id = kvm_x2apic_id(apic);
 	u32 xapic_id = kvm_xapic_id(apic);
-	u32 physical_id;
 
 	/*
 	 * Deliberately truncate the vCPU ID when detecting a mismatched APIC
@@ -250,34 +250,24 @@ static int kvm_recalculate_phys_map(struct kvm_apic_map *new,
 	 * effective APIC ID, e.g. due to the x2APIC wrap or because the guest
 	 * manually modified its xAPIC IDs, events targeting that ID are
 	 * supposed to be recognized by all vCPUs with said ID.
+	 *
+	 * For !x2apic_format disable the optimized map if the physical APIC ID
+	 * is already mapped, i.e. is aliased to multiple vCPUs.  The optimized
+	 * map requires a strict 1:1 mapping between IDs and vCPUs.
+	 *
+	 * See also kvm_apic_match_physical_addr().
 	 */
-	if (vcpu->kvm->arch.x2apic_format) {
-		/* See also kvm_apic_match_physical_addr(). */
-		if ((apic_x2apic_mode(apic) || x2apic_id > 0xff) &&
-			x2apic_id <= new->max_apic_id)
-			new->phys_map[x2apic_id] = apic;
-
-		if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
-			new->phys_map[xapic_id] = apic;
-	} else {
-		/*
-		 * Disable the optimized map if the physical APIC ID is already
-		 * mapped, i.e. is aliased to multiple vCPUs.  The optimized
-		 * map requires a strict 1:1 mapping between IDs and vCPUs.
-		 */
-		if (apic_x2apic_mode(apic)) {
-			if (x2apic_id > new->max_apic_id)
-				return -EINVAL;
+	if (apic_x2apic_mode(apic) || (x2format && x2apic_id > 0xff)) {
+		if (x2apic_id > new->max_apic_id ||
+		    (!x2format && new->phys_map[x2apic_id]))
+			return !x2format;
 
-			physical_id = x2apic_id;
-		} else {
-			physical_id = xapic_id;
-		}
-
-		if (new->phys_map[physical_id])
-			return -EINVAL;
+		new->phys_map[x2apic_id] = apic;
+	} else {
+		if (new->phys_map[xapic_id])
+			return !x2format;
 
-		new->phys_map[physical_id] = apic;
+		new->phys_map[xapic_id] = apic;
 	}
 
 	return 0;
-- 
2.40.1

