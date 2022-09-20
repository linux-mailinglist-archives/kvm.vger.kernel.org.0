Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5285BF137
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbiITXcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiITXcJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:32:09 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081BB4D81C
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:06 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id a33-20020a630b61000000b00429d91cc649so2443266pgl.8
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=BnU9R4OOCMoxOu19YfLjACcEr3TMCmK9pmle1GpcXiY=;
        b=qkXh507ROI+ln1N42ZCLl+6rk1+yF6u0MvgZC8G61grkt4oNHATMOaF87TJHgQB2dt
         OIl/FI2kTZRtXS3ZxXxv/+B0KdqYzMcTjzNyOLaH8vMj3Mpihq63pA5jyp7eOIlpWp7t
         DtzeO4l78LWAX423XHA5+gOKIdrAXe1AlEEHa5oDOSWM6AWBGK/mF/OpyG00g5fnhdej
         IJjpZgzC3Pd+IUn5G7bAAaqfA4cW5W0tWuviP4ly3WhRtPUdm3AmT0qbNZ2EMZei8lRG
         q92ZeW2c7l3Kqpg5FSF4HV9clwc4BbPv7N7Etg2jbgLNy3fRkHXmGM8ctb4CNXa85Spg
         Ic+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=BnU9R4OOCMoxOu19YfLjACcEr3TMCmK9pmle1GpcXiY=;
        b=U4E3lIsAyksq1ow/Q98r+6/LdrRx3SOvZ+IOtMPmswEzdTVraAfKcmKDMjLXQphGVy
         H5TRwHDlFLaZg2gvUrGcRelMDsHBUVYC34wnWKu/7r5WKVrUZ4l0JrynXCbPPwMrWUCq
         CA6NT40ZZSqOqkHRCvvFfmyDIRp2Qag08ZAd9klxiCKnbiaq4Ousl9Vn0hovY/AN4APV
         0Q4LawIpMgCeQHJPacQRH1ab4dWhGKjABWYa7YTagcb5NV/Xml/fk5CGidxRQtd1c9vC
         u+zcyT51+DpLuG+RZiO5G3UuGr0ZIGAQLbQYrnit0Y/X+o26YNvUMSNZa0P3YJDN7vZK
         chcA==
X-Gm-Message-State: ACrzQf0tdODRbPh8Qabd4yEjilGSwyF876afIOtKsJod4M6SHyR70uqm
        kZg+dxZ3cKuJ8WkOzNxen0hrA2y/WsY=
X-Google-Smtp-Source: AMsMyM7neXTpgHwVbxMnJQHoICcB5V232AiZhjbclpKaLMnonVbkV0dJGKRuGnJUgQAZiyotXAXTdFgZP1I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1181:b0:203:ae0e:6a21 with SMTP id
 gk1-20020a17090b118100b00203ae0e6a21mr405202pjb.0.1663716725368; Tue, 20 Sep
 2022 16:32:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:23 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-18-seanjc@google.com>
Subject: [PATCH v3 17/28] KVM: x86: Skip redundant x2APIC logical mode
 optimized cluster setup
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Skip the optimized cluster[] setup for x2APIC logical mode, as KVM reuses
the optimized map's phys_map[] and doesn't actually need to insert the
target apic into the cluster[].  The LDR is derived from the x2APIC ID,
and both are read-only in KVM, thus the vCPU's cluster[ldr] is guaranteed
to be the same entry as the vCPU's phys_map[x2apic_id] entry.

Skipping the unnecessary setup will allow a future fix for aliased xAPIC
logical IDs to simply require that cluster[ldr] is non-NULL, i.e. won't
have to special case x2APIC.

Alternatively, the future check could allow "cluster[ldr] == apic", but
that ends up being terribly confusing because cluster[ldr] is only set
at the very end, i.e. it's only possible due to x2APIC's shenanigans.

Another alternative would be to send x2APIC down a separate path _after_
the calculation and then assert that all of the above, but the resulting
code is rather messy, and it's arguably unnecessary since asserting that
the actual LDR matches the expected LDR means that simply testing that
interrupts are delivered correctly provides the same guarantees.

Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 84b7a1c1834d..7a39d7be4cc9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -166,6 +166,11 @@ static bool kvm_use_posted_timer_interrupt(struct kvm_vcpu *vcpu)
 	return kvm_can_post_timer_interrupt(vcpu) && vcpu->mode == IN_GUEST_MODE;
 }
 
+static inline u32 kvm_apic_calc_x2apic_ldr(u32 id)
+{
+	return ((id >> 4) << 16) | (1 << (id & 0xf));
+}
+
 static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
 		u32 dest_id, struct kvm_lapic ***cluster, u16 *mask) {
 	switch (map->logical_mode) {
@@ -315,6 +320,18 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 		}
 		new->logical_mode = logical_mode;
 
+		/*
+		 * In x2APIC mode, the LDR is read-only and derived directly
+		 * from the x2APIC ID, thus is guaranteed to be addressable.
+		 * KVM reuses kvm_apic_map.phys_map to optimize logical mode
+		 * x2APIC interrupts by reversing the LDR calculation to get
+		 * cluster of APICs, i.e. no additional work is required.
+		 */
+		if (apic_x2apic_mode(apic)) {
+			WARN_ON_ONCE(ldr != kvm_apic_calc_x2apic_ldr(x2apic_id));
+			continue;
+		}
+
 		if (WARN_ON_ONCE(!kvm_apic_map_get_logical_dest(new, ldr,
 								&cluster, &mask))) {
 			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
@@ -381,11 +398,6 @@ static inline void kvm_apic_set_dfr(struct kvm_lapic *apic, u32 val)
 	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 }
 
-static inline u32 kvm_apic_calc_x2apic_ldr(u32 id)
-{
-	return ((id >> 4) << 16) | (1 << (id & 0xf));
-}
-
 static inline void kvm_apic_set_x2apic_id(struct kvm_lapic *apic, u32 id)
 {
 	u32 ldr = kvm_apic_calc_x2apic_ldr(id);
-- 
2.37.3.968.ga6b4b080e4-goog

