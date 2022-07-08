Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3489556BA13
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 14:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237953AbiGHMwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 08:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237893AbiGHMv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 08:51:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D1C51A3AD
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 05:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657284717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4z5lVkD+jQzqil2s6scsQObiDe7cMFhAFbJRur6ZF58=;
        b=gWD/kgSWPlyJTJ7LA8GpdjhYsgHVmPcDozlb745XGMJEeS+ePNJ0V1DbZFuv7IqBco0PS0
        VgbW0JWAn65b7S0FSbCvLsV2LlFvJv91rSBEvxvr3X9RUQs0qu3VK/eAB808EPQIoaoswt
        ePOHLaDx+5VY7Ah7REpc6oKLID3kyAg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-281-ZDpnN98bN82azesetvG9Vg-1; Fri, 08 Jul 2022 08:51:52 -0400
X-MC-Unique: ZDpnN98bN82azesetvG9Vg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4939E80A0AE;
        Fri,  8 Jul 2022 12:51:52 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1ADC02026D64;
        Fri,  8 Jul 2022 12:51:48 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86: Fully initialize 'struct kvm_lapic_irq' in kvm_pv_kick_cpu_op()
Date:   Fri,  8 Jul 2022 14:51:47 +0200
Message-Id: <20220708125147.593975-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
- Changes since v1:
  Only set fields which matter for APIC_DM_REMRD and defer
  initialization of the rest to the compiler [Sean].
---
 arch/x86/kvm/x86.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 567d13405445..6364da034462 100644
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
+	/*
+	 * All other fields are unused for APIC_DM_REMRD, but may be consumed by
+	 * common code, e.g. for tracing. Defer initialization to the compiler.
+	 */
+	struct kvm_lapic_irq lapic_irq = {
+		.delivery_mode = APIC_DM_REMRD,
+		.dest_mode = APIC_DEST_PHYSICAL,
+		.shorthand = APIC_DEST_NOSHORT,
+		.dest_id = apicid,
+	};
 
-	lapic_irq.delivery_mode = APIC_DM_REMRD;
 	kvm_irq_delivery_to_apic(kvm, NULL, &lapic_irq, NULL);
 }
 
-- 
2.35.3

