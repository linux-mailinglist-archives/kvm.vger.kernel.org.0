Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30E8B4B23D2
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 12:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349279AbiBKLB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 06:01:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349292AbiBKLBY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 06:01:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D0EEB8D
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 03:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644577282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=26enP3RyEfUVYXxVtyOpkulynQz+0id22F0IbI7Q6zQ=;
        b=GOnpXjkSlx9QKSoboo1XUIfZnwEFKDy9VvKfbygD3queHAjrDXBjdtSbwbYDbJDvRWp1Wq
        ZeY0X7yM6BPyGa0Ceojyhwa8MkYj8aHSXCUud9mcrMHg1HownGwX4a+NqtQHlT6SmFNCts
        7zME3yoOh4cMYqh3KrI/f9ePP5sGbXI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-DzU0gAk0OymCK5gEpMFk9A-1; Fri, 11 Feb 2022 06:01:19 -0500
X-MC-Unique: DzU0gAk0OymCK5gEpMFk9A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 863C8814245;
        Fri, 11 Feb 2022 11:01:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36F4C7BB6A;
        Fri, 11 Feb 2022 11:01:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com
Subject: [PATCH 1/3] KVM: SVM: extract avic_ring_doorbell
Date:   Fri, 11 Feb 2022 06:01:15 -0500
Message-Id: <20220211110117.2764381-2-pbonzini@redhat.com>
In-Reply-To: <20220211110117.2764381-1-pbonzini@redhat.com>
References: <20220211110117.2764381-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

The check on the current CPU adds an extra level of indentation to
svm_deliver_avic_intr and conflates documentation on what happens
if the vCPU exits (of interest to svm_deliver_avic_intr) and migrates
(only of interest to avic_ring_doorbell, which calls get/put_cpu()).
Extract the wrmsr to a separate function and rewrite the
comment in svm_deliver_avic_intr().

Co-developed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 3f9b48732aea..4d1baf5c8f6a 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -269,6 +269,24 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+
+static void avic_ring_doorbell(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Note, the vCPU could get migrated to a different pCPU at any
+	 * point, which could result in signalling the wrong/previous
+	 * pCPU.  But if that happens the vCPU is guaranteed to do a
+	 * VMRUN (after being migrated) and thus will process pending
+	 * interrupts, i.e. a doorbell is not needed (and the spurious
+	 * one is harmless).
+	 */
+	int cpu = READ_ONCE(vcpu->cpu);
+
+	if (cpu != get_cpu())
+		wrmsrl(MSR_AMD64_SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpu));
+	put_cpu();
+}
+
 static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 				   u32 icrl, u32 icrh)
 {
@@ -669,19 +687,12 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 	 * automatically process AVIC interrupts at VMRUN.
 	 */
 	if (vcpu->mode == IN_GUEST_MODE) {
-		int cpu = READ_ONCE(vcpu->cpu);
-
 		/*
-		 * Note, the vCPU could get migrated to a different pCPU at any
-		 * point, which could result in signalling the wrong/previous
-		 * pCPU.  But if that happens the vCPU is guaranteed to do a
-		 * VMRUN (after being migrated) and thus will process pending
-		 * interrupts, i.e. a doorbell is not needed (and the spurious
-		 * one is harmless).
+		 * Signal the doorbell to tell hardware to inject the IRQ if the vCPU
+		 * is in the guest.  If the vCPU is not in the guest, hardware will
+		 * automatically process AVIC interrupts at VMRUN.
 		 */
-		if (cpu != get_cpu())
-			wrmsrl(MSR_AMD64_SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpu));
-		put_cpu();
+		avic_ring_doorbell(vcpu);
 	} else {
 		/*
 		 * Wake the vCPU if it was blocking.  KVM will then detect the
-- 
2.31.1


