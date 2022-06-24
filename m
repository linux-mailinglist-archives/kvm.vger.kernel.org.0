Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28CF559D96
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 17:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbiFXPpu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 11:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbiFXPps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 11:45:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2042E49699
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 08:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656085547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=kfgsNNy22sEVTzihUmMAG1X3Wq+qHllqI4M/773EhR4=;
        b=gKZKGflKXfL0DhYiWNWLAq8liPcBRIqWWemSmJjQJQeskx1lRdb7sIqLE6WUWBVHlt0sUH
        PjYXVUzHLFIiZ5IB+ZjAeiDVwlspUWKkF2oGtAUHXUNMj9BBxIAgQsiNqUfUFTklGLw1va
        Hy4izXpKxK5NHU89+wM8VI+rIO2zpiM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-0GwY0PSuNTGSZYt7JtlCDA-1; Fri, 24 Jun 2022 11:45:35 -0400
X-MC-Unique: 0GwY0PSuNTGSZYt7JtlCDA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6425A81D9CE;
        Fri, 24 Jun 2022 15:45:35 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4338E40CFD0A;
        Fri, 24 Jun 2022 15:45:35 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     ubizjak@gmail.com, Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH] KVM: selftests: Enhance handling WRMSR ICR register in x2APIC mode
Date:   Fri, 24 Jun 2022 11:45:35 -0400
Message-Id: <20220624154535.2736289-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zeng Guang <guang.zeng@intel.com>

Hardware would directly write x2APIC ICR register instead of software
emulation in some circumstances, e.g when Intel IPI virtualization is
enabled. This behavior requires normal reserved bits checking to ensure
them input as zero, otherwise it will cause #GP. So we need mask out
those reserved bits from the data written to vICR register.

Remove Delivery Status bit emulation in test case as this flag
is invalid and not needed in x2APIC mode. KVM may ignore clearing
it during interrupt dispatch which will lead to fake test failure.

Opportunistically correct vector number for test sending IPI to
non-existent vCPUs.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
Message-Id: <20220623094511.26066-1-guang.zeng@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../selftests/kvm/x86_64/xapic_state_test.c   | 20 ++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
index 5c5dc7bbb4e2..87531623064f 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
@@ -71,13 +71,27 @@ static void ____test_icr(struct xapic_vcpu *x, uint64_t val)
 	vcpu_ioctl(vcpu, KVM_GET_LAPIC, &xapic);
 	icr = (u64)(*((u32 *)&xapic.regs[APIC_ICR])) |
 	      (u64)(*((u32 *)&xapic.regs[APIC_ICR2])) << 32;
-	if (!x->is_x2apic)
+	if (!x->is_x2apic) {
 		val &= (-1u | (0xffull << (32 + 24)));
-	ASSERT_EQ(icr, val & ~APIC_ICR_BUSY);
+		ASSERT_EQ(icr, val & ~APIC_ICR_BUSY);
+	} else {
+		ASSERT_EQ(icr & ~APIC_ICR_BUSY, val & ~APIC_ICR_BUSY);
+	}
 }
 
+#define X2APIC_RSVED_BITS_MASK  (GENMASK_ULL(31,20) | \
+				 GENMASK_ULL(17,16) | \
+				 GENMASK_ULL(13,13))
+
 static void __test_icr(struct xapic_vcpu *x, uint64_t val)
 {
+	if (x->is_x2apic) {
+		/* Hardware writing vICR register requires reserved bits 31:20,
+		 * 17:16 and 13 kept as zero to avoid #GP exception. Data value
+		 * written to vICR should mask out those bits above.
+		 */
+		val &= ~X2APIC_RSVED_BITS_MASK;
+	}
 	____test_icr(x, val | APIC_ICR_BUSY);
 	____test_icr(x, val & ~(u64)APIC_ICR_BUSY);
 }
@@ -102,7 +116,7 @@ static void test_icr(struct xapic_vcpu *x)
 	icr = APIC_INT_ASSERT | 0xff;
 	for (i = vcpu->id + 1; i < 0xff; i++) {
 		for (j = 0; j < 8; j++)
-			__test_icr(x, i << (32 + 24) | APIC_INT_ASSERT | (j << 8));
+			__test_icr(x, i << (32 + 24) | icr | (j << 8));
 	}
 
 	/* And again with a shorthand destination for all types of IPIs. */
-- 
2.31.1

