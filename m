Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB7F58B07A
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 21:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241571AbiHETl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 15:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241529AbiHETlH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 15:41:07 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0711183A
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 12:41:05 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id z20so4075542ljq.3
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 12:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=4EJyKAMA651b2XcODYAopraeU2a8WMK/LvyMG5AbrCA=;
        b=a+0caHKPzVuG3onuuFuqFN0007+7/sghqkSm3qxnx3rp53REYeqJLY6NdiuFfu28d2
         Kw/bFK9yFXWg1Mfyyy1UtBfsFrG38s25u2DaAQRCThlvLdzo3CzLf/86946XIbC+hjI7
         qFVlvaLDi9CHs8jquTaEzdi/4zfjq1M824ZI4JX1oPfRIlpFEk9u5J/aXth61QRYZb87
         5PpOTYAlSthJ1GExEOhWQ70Li1TglUYdRsxQpFs4W2/+sYWMtJbMLC5KR+Uyi2QI6ldL
         i+zEE7nLn1Bb6X0qdax5wx1ukq7G069alS5CZC956xP/mcPcOQsk43MRUax8UmN8mo1k
         gypA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=4EJyKAMA651b2XcODYAopraeU2a8WMK/LvyMG5AbrCA=;
        b=ebrJyJDkSAA5s9fdpN78tp+eztdoI5mNdr/b9bsCr1crixK5RfIl9qgT/bDhwO8ieM
         h/auG/NB3WzJsqYmMJ183u8Dh8/B97VdSGwRnO9CSck+V2TTZOMVE3aqG4jfbnhNg3hc
         M9y2BATMm8IoP00cdKIvEYpChamtfB+ptiOsgMgcgT5cXG+9gYdMkMjE/bDCi8aJWrtN
         yHoF9zFf9i6YI9MMbYhZMbtBWifFtDY/sFNpKc1xlRLm8kTzz3KO0mj3MgduD1wJ03Is
         PhS9fEDZpMuQYcPFlfA2nuQCXlRUziCIsTXO2b2Ka8DY4IHWHH+Yfvpo0wOqPhpBlJW+
         t92A==
X-Gm-Message-State: ACgBeo2LlizwNopxqHZ/OjIta0/U/T2DBmEnQbpzcrE0VdoteRqqXECs
        khJ8jFlQTjamWGUYG6Qco84cjw==
X-Google-Smtp-Source: AA6agR74BE6pJuac4KoH7KYfDpn5kABc0A1RphRlFVWmRcLJpptyXdW2EWbwCWeE4KlOPIE2K42IrQ==
X-Received: by 2002:a2e:8681:0:b0:25e:7181:ddd8 with SMTP id l1-20020a2e8681000000b0025e7181ddd8mr2594995lji.199.1659728463549;
        Fri, 05 Aug 2022 12:41:03 -0700 (PDT)
Received: from dmaluka.office.semihalf.net ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id o4-20020a056512230400b0048a407f41bbsm560079lfu.238.2022.08.05.12.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 12:41:03 -0700 (PDT)
From:   Dmytro Maluka <dmy@semihalf.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>, upstream@semihalf.com,
        Dmitry Torokhov <dtor@google.com>,
        Dmytro Maluka <dmy@semihalf.com>
Subject: [PATCH v2 5/5] KVM: Rename kvm_irq_has_notifier()
Date:   Fri,  5 Aug 2022 21:39:19 +0200
Message-Id: <20220805193919.1470653-6-dmy@semihalf.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
In-Reply-To: <20220805193919.1470653-1-dmy@semihalf.com>
References: <20220805193919.1470653-1-dmy@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now we have irq mask notifiers available in generic KVM along with irq
ack notifiers, so rename kvm_irq_has_notifier() to
kvm_irq_has_ack_notifier() to make it clear which notifier it is about.

Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
---
 arch/x86/kvm/ioapic.c    | 2 +-
 include/linux/kvm_host.h | 2 +-
 virt/kvm/eventfd.c       | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index fab11de1f885..20d758ac2234 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -291,7 +291,7 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, ulong *ioapic_handled_vectors)
 	for (index = 0; index < IOAPIC_NUM_PINS; index++) {
 		e = &ioapic->redirtbl[index];
 		if (e->fields.trig_mode == IOAPIC_LEVEL_TRIG ||
-		    kvm_irq_has_notifier(ioapic->kvm, KVM_IRQCHIP_IOAPIC, index) ||
+		    kvm_irq_has_ack_notifier(ioapic->kvm, KVM_IRQCHIP_IOAPIC, index) ||
 		    index == RTC_GSI) {
 			u16 dm = kvm_lapic_irq_dest_mode(!!e->fields.dest_mode);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 55233eb18eb4..ba18276691e1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1601,7 +1601,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *irq_entry, struct kvm *kvm,
 int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 			       struct kvm *kvm, int irq_source_id,
 			       int level, bool line_status);
-bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin);
+bool kvm_irq_has_ack_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin);
 void kvm_notify_acked_gsi(struct kvm *kvm, int gsi);
 void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin);
 void kvm_register_irq_ack_notifier(struct kvm *kvm,
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 72de942dbb9c..4dd7b6f2da69 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -502,7 +502,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	return ret;
 }
 
-bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin)
+bool kvm_irq_has_ack_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin)
 {
 	struct kvm_irq_ack_notifier *kian;
 	int gsi, idx;
@@ -521,7 +521,7 @@ bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin)
 
 	return false;
 }
-EXPORT_SYMBOL_GPL(kvm_irq_has_notifier);
+EXPORT_SYMBOL_GPL(kvm_irq_has_ack_notifier);
 
 void kvm_notify_acked_gsi(struct kvm *kvm, int gsi)
 {
-- 
2.37.1.559.g78731f0fdb-goog

