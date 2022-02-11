Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1414B23D5
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 12:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349297AbiBKLBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 06:01:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349272AbiBKLBW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 06:01:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E221B8D
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 03:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644577281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x35t6x5Xs0BqBb/0YruR1apRzUMOOFziRRMmNU+ZGMQ=;
        b=dzBnMd8NTn/cKDr8nA5imJvzlq5IhWXa0NK1nsgqRCz4Hs710blRaWJ//CsXuDT+U+OGZ+
        mZPVuZ0UWE351MicggJqt319NMpKKbiwyzft4JM4elR+hMltSVqdMJG6sXGgAmNN/XIlXz
        cjCREClSbEoyI4HrN3ttW0ulORVwQ+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-_wKSy994PV-T8CVIpQWGwQ-1; Fri, 11 Feb 2022 06:01:20 -0500
X-MC-Unique: _wKSy994PV-T8CVIpQWGwQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFFD684B9AA;
        Fri, 11 Feb 2022 11:01:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0FF17BB6A;
        Fri, 11 Feb 2022 11:01:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com
Subject: [PATCH 2/3] KVM: SVM: set IRR in svm_deliver_interrupt
Date:   Fri, 11 Feb 2022 06:01:16 -0500
Message-Id: <20220211110117.2764381-3-pbonzini@redhat.com>
In-Reply-To: <20220211110117.2764381-1-pbonzini@redhat.com>
References: <20220211110117.2764381-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SVM has to set IRR for both the AVIC and the software-LAPIC case,
so pull it up to the common function that handles both configurations.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 2 --
 arch/x86/kvm/svm/svm.c  | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4d1baf5c8f6a..1e1890721634 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -670,8 +670,6 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 	if (!vcpu->arch.apicv_active)
 		return -1;
 
-	kvm_lapic_set_irr(vec, vcpu->arch.apic);
-
 	/*
 	 * Pairs with the smp_mb_*() after setting vcpu->guest_mode in
 	 * vcpu_enter_guest() to ensure the write to the vIRR is ordered before
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 52e4130110f3..cd769ff8af16 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3304,8 +3304,8 @@ static void svm_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 {
 	struct kvm_vcpu *vcpu = apic->vcpu;
 
+	kvm_lapic_set_irr(vector, apic);
 	if (svm_deliver_avic_intr(vcpu, vector)) {
-		kvm_lapic_set_irr(vector, apic);
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 		kvm_vcpu_kick(vcpu);
 	} else {
-- 
2.31.1


