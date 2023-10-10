Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E0D7C0115
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 18:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbjJJQED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 12:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbjJJQD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 12:03:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA76FCA
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 09:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696953791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=prXnsQoLnnAumc7wrBTC9PXl8VFIdNti/eoAvkFE+lo=;
        b=F9YowIf+aj5mEHdFJ6MU48PrndeUEiv6XDUplBbk0WA945+pYSmtFx1jG3YscEPs7g1Py3
        bL25WjTPFg1ZDbQwQCU3whluodMoTmT9oFH3ac5qJAh39PwsnyFYZYS0GpyYNVlG1lO8P+
        QFVVWVZ6CsRa29v5tmwUIZYMpw3lxhc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-471-yXu5rYv0Nv2HM7RbZkTUHQ-1; Tue, 10 Oct 2023 12:03:03 -0400
X-MC-Unique: yXu5rYv0Nv2HM7RbZkTUHQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56865185A79B;
        Tue, 10 Oct 2023 16:03:03 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 85FAD158;
        Tue, 10 Oct 2023 16:03:02 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH RFC 01/11] KVM: x86: xen: Remove unneeded xen context from struct kvm_arch when !CONFIG_KVM_XEN
Date:   Tue, 10 Oct 2023 18:02:50 +0200
Message-ID: <20231010160300.1136799-2-vkuznets@redhat.com>
In-Reply-To: <20231010160300.1136799-1-vkuznets@redhat.com>
References: <20231010160300.1136799-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Saving a few bytes of memory per KVM VM is certainly great but what's more
important is the ability to see where the code accesses Xen emulation
context while CONFIG_KVM_XEN is not enabled. Currently, kvm_cpu_get_extint()
is the only such place and it is harmless: kvm_xen_has_interrupt() always
returns '0' when !CONFIG_KVM_XEN.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 5 +++++
 arch/x86/kvm/irq.c              | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 17715cb8731d..e5d4b8a44630 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1126,6 +1126,7 @@ struct msr_bitmap_range {
 	unsigned long *bitmap;
 };
 
+#ifdef CONFIG_KVM_XEN
 /* Xen emulation context */
 struct kvm_xen {
 	struct mutex xen_lock;
@@ -1137,6 +1138,7 @@ struct kvm_xen {
 	struct idr evtchn_ports;
 	unsigned long poll_mask[BITS_TO_LONGS(KVM_MAX_VCPUS)];
 };
+#endif
 
 enum kvm_irqchip_mode {
 	KVM_IRQCHIP_NONE,
@@ -1338,7 +1340,10 @@ struct kvm_arch {
 	struct hlist_head mask_notifier_list;
 
 	struct kvm_hv hyperv;
+
+#ifdef CONFIG_KVM_XEN
 	struct kvm_xen xen;
+#endif
 
 	bool backwards_tsc_observed;
 	bool boot_vcpu_runs_old_kvmclock;
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index b2c397dd2bc6..ad9ca8a60144 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -118,8 +118,10 @@ static int kvm_cpu_get_extint(struct kvm_vcpu *v)
 	if (!lapic_in_kernel(v))
 		return v->arch.interrupt.nr;
 
+#ifdef CONFIG_KVM_XEN
 	if (kvm_xen_has_interrupt(v))
 		return v->kvm->arch.xen.upcall_vector;
+#endif
 
 	if (irqchip_split(v->kvm)) {
 		int vector = v->arch.pending_external_vector;
-- 
2.41.0

