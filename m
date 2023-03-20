Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6016C24EC
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 23:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjCTWw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 18:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCTWwX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 18:52:23 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD826367DE
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 15:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679352732; x=1710888732;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BkZb1ce0SJkvAMy3Ho2Qd24k85WqKd0BMcy/YaZbtTA=;
  b=AFwkDWrSPEPcKOdh6MGSXTPN05dSIPRrelVQfC+F6N1z8eLQ0N3IGTr1
   yxU28sNqTrafeESmWrtkzLgn5VVUYs0c1blDzw7OuhBs0H0ZEm4QXRuIs
   8c/Zvhu0H21J3W9pmBCeaNIZoXAzfjNkbz4BI7TcenEagi7/uyYb5jxJ7
   A=;
X-IronPort-AV: E=Sophos;i="5.98,277,1673913600"; 
   d="scan'208";a="309258053"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 22:52:05 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com (Postfix) with ESMTPS id A22B280C5E;
        Mon, 20 Mar 2023 22:52:03 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Mon, 20 Mar 2023 22:52:03 +0000
Received: from dev-dsk-graf-1a-5ce218e4.eu-west-1.amazon.com (10.253.83.51) by
 EX19D020UWC004.ant.amazon.com (10.13.138.149) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Mon, 20 Mar 2023 22:52:01 +0000
From:   Alexander Graf <graf@amazon.com>
To:     <kvm@vger.kernel.org>
CC:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        Michael Roth <michael.roth@amd.com>,
        Sabin Rapan <sabrapan@amazon.com>
Subject: [PATCH] KVM: x86: Allow restore of some sregs with protected state
Date:   Mon, 20 Mar 2023 22:51:59 +0000
Message-ID: <20230320225159.92771-1-graf@amazon.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With protected state (like SEV-ES and SEV-SNP), KVM does not have direct
access to guest registers. However, we deflect modifications to CR0,
CR4 and EFER to the host. We also carry the apic_base register and learn
about CR8 directly from a VMCB field.

That means these bits of information do exist in the host's KVM data
structures. If we ever want to resume consumption of an already
initialized VMSA (guest state), we will need to also restore these
additional bits of KVM state.

Prepare ourselves for such a world by allowing set_sregs to set the
relevant fields. This way, it mirrors get_sregs properly that already
exposes them to user space.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 arch/x86/kvm/x86.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7713420abab0..88fa8b657a2f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11370,7 +11370,8 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
 	int idx;
 	struct desc_ptr dt;
 
-	if (!kvm_is_valid_sregs(vcpu, sregs))
+	if (!vcpu->arch.guest_state_protected &&
+	    !kvm_is_valid_sregs(vcpu, sregs))
 		return -EINVAL;
 
 	apic_base_msr.data = sregs->apic_base;
@@ -11378,8 +11379,19 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
 	if (kvm_set_apic_base(vcpu, &apic_base_msr))
 		return -EINVAL;
 
-	if (vcpu->arch.guest_state_protected)
+	if (vcpu->arch.guest_state_protected) {
+		/*
+		 * While most actual guest state is hidden from us,
+		 * CR{0,4,8}, efer and apic_base still hold KVM state
+		 * with protection enabled, so let's allow restoring
+		 */
+		kvm_set_cr8(vcpu, sregs->cr8);
+		kvm_x86_ops.set_efer(vcpu, sregs->efer);
+		kvm_x86_ops.set_cr0(vcpu, sregs->cr0);
+		vcpu->arch.cr0 = sregs->cr0;
+		kvm_x86_ops.set_cr4(vcpu, sregs->cr4);
 		return 0;
+	}
 
 	dt.size = sregs->idt.limit;
 	dt.address = sregs->idt.base;
-- 
2.39.2




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



