Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E14E255E4A9
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346555AbiF1NcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 09:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346474AbiF1Nbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 09:31:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E22342A706
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 06:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656423063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=u55Q3Jca+qOXXIBqB4TXnLGHs1HcaTUob8yIUpePALU=;
        b=Zyv7BTJmH5FOAYRmfvpcDqpufcwzpGuWhPte3N788NeN4hBmQEZIp3E57JvMt3o1sKdvKp
        uZAn8KgGK7QwixELN+wiinpds6CjJFxjf2GqBNc3ybxdF4b11Rg8+wOuuhyxsmBEEV69Gw
        UsavVhlWjYWTd8zOkXL024YYo40fv1g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-i5Y-yA-hNpycuk-FDu2J_Q-1; Tue, 28 Jun 2022 09:31:00 -0400
X-MC-Unique: i5Y-yA-hNpycuk-FDu2J_Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A4D5811E80;
        Tue, 28 Jun 2022 13:31:00 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1503E2026D07;
        Tue, 28 Jun 2022 13:30:57 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Fully initialize 'struct kvm_lapic_irq' in kvm_pv_kick_cpu_op()
Date:   Tue, 28 Jun 2022 15:30:57 +0200
Message-Id: <20220628133057.107344-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'vector' and 'trig_mode' fields of 'struct kvm_lapic_irq' are left
uninitialized in kvm_pv_kick_cpu_op(). While these fields are normally
not needed for APIC_DM_REMRD, they're still referenced by
__apic_accept_irq() for trace_kvm_apic_accept_irq(). Fully initialize
the structure to avoid consuming random stack memory.

Fixes: a183b638b61c ("KVM: x86: make apic_accept_irq tracepoint more generic")
Reported-by: syzbot+d6caa905917d353f0d07@syzkaller.appspotmail.com
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/x86.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 567d13405445..8a98608dad4f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9340,15 +9340,17 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
  */
 static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
 {
-	struct kvm_lapic_irq lapic_irq;
-
-	lapic_irq.shorthand = APIC_DEST_NOSHORT;
-	lapic_irq.dest_mode = APIC_DEST_PHYSICAL;
-	lapic_irq.level = 0;
-	lapic_irq.dest_id = apicid;
-	lapic_irq.msi_redir_hint = false;
+	struct kvm_lapic_irq lapic_irq = {
+		.vector = 0,
+		.delivery_mode = APIC_DM_REMRD,
+		.dest_mode = APIC_DEST_PHYSICAL,
+		.level = false,
+		.trig_mode = 0,
+		.shorthand = APIC_DEST_NOSHORT,
+		.dest_id = apicid,
+		.msi_redir_hint = false
+	};
 
-	lapic_irq.delivery_mode = APIC_DM_REMRD;
 	kvm_irq_delivery_to_apic(kvm, NULL, &lapic_irq, NULL);
 }
 
-- 
2.35.3

