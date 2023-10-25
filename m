Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138187D70B2
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 17:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbjJYPZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 11:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235012AbjJYPZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 11:25:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DFE131
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 08:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698247457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B9F/O6g5/7Er0I0bK5udgY/gT/zqYUZXI7Hi/W1GXcM=;
        b=hMCmAyUhkLNOqK8JZnIW1kn2l1EyBDRDCPsI8h0c/4p0vnc0Vb00rxvUY/HemJ5vvP11eQ
        bk04cKVwrPCHbMAgcGxd9iRMYfnL26X21YCqAAtvDbxkvzkLFr0kmLiT5RSK1n2uszum4B
        ctrzu1XxLZbQG7Bq5nD2jGDd3hMJ+j0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-awXd05tBOz-N9zPGiit68Q-1; Wed, 25 Oct 2023 11:24:14 -0400
X-MC-Unique: awXd05tBOz-N9zPGiit68Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DEE9D185A782;
        Wed, 25 Oct 2023 15:24:13 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F20892166B26;
        Wed, 25 Oct 2023 15:24:12 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 05/14] KVM: x86: hyper-v: Introduce kvm_hv_synic_has_vector()
Date:   Wed, 25 Oct 2023 17:23:57 +0200
Message-ID: <20231025152406.1879274-6-vkuznets@redhat.com>
In-Reply-To: <20231025152406.1879274-1-vkuznets@redhat.com>
References: <20231025152406.1879274-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a preparation to making Hyper-V emulation optional, create a dedicated
kvm_hv_synic_has_vector() helper to avoid extra ifdefs in lapic.c.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.h | 5 +++++
 arch/x86/kvm/lapic.c  | 3 +--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 1897a219981d..ddb1d0b019e6 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -105,6 +105,11 @@ int kvm_hv_synic_set_irq(struct kvm *kvm, u32 vcpu_id, u32 sint);
 void kvm_hv_synic_send_eoi(struct kvm_vcpu *vcpu, int vector);
 int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages);
 
+static inline bool kvm_hv_synic_has_vector(struct kvm_vcpu *vcpu, int vector)
+{
+	return to_hv_vcpu(vcpu) && test_bit(vector, to_hv_synic(vcpu)->vec_bitmap);
+}
+
 static inline bool kvm_hv_synic_auto_eoi_set(struct kvm_vcpu *vcpu, int vector)
 {
 	return to_hv_vcpu(vcpu) && test_bit(vector, to_hv_synic(vcpu)->auto_eoi_bitmap);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f7abc1008cad..3242f3da2457 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1475,8 +1475,7 @@ static int apic_set_eoi(struct kvm_lapic *apic)
 	apic_clear_isr(vector, apic);
 	apic_update_ppr(apic);
 
-	if (to_hv_vcpu(apic->vcpu) &&
-	    test_bit(vector, to_hv_synic(apic->vcpu)->vec_bitmap))
+	if (kvm_hv_synic_has_vector(apic->vcpu, vector))
 		kvm_hv_synic_send_eoi(apic->vcpu, vector);
 
 	kvm_ioapic_send_eoi(apic, vector);
-- 
2.41.0

