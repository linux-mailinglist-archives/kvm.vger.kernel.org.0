Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8920B5BF143
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiITXdY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbiITXce (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:32:34 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5087B786F3
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:12 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id cq15-20020a056a00330f00b005438e527f24so2496797pfb.23
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=g79qUsYaWi35oGsfhRv6mmj8mg5DWdHzyNJhsg4wv1U=;
        b=hK3090xNbEEAnH2ylBAx4vDXE98QTnHl+P7+5k+euLTCeFTJSirCLZhWk9JDzQ9I8Y
         S+FsgUh+YE//NEaNGciDy7xPDaKvtjALTFBaeLcvlbD1Lef1S+5UX40jzItqVf3GlYq5
         ilS9sudcfDC+B7t/Ck/O+5qseLAKjJ4ZzSivJLJYubWpm21tSXHfc4FTpHiVPxLRezLJ
         Tw55NDd4PTuKyZXndJkDXcmk7+r5BUtQs9BczQkNxwoav4SLqmx5It3z8K4b09YN8gPZ
         HhQ7p1CJ/69KF7fm6MT5VfC6hfzet5ZSWc6gldJH2mkWTgyk/ncjTqyaOHFlhyLm3PS9
         vjQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=g79qUsYaWi35oGsfhRv6mmj8mg5DWdHzyNJhsg4wv1U=;
        b=KuBJcTM1ny4ZedxTMs6QtJTb6TQIF4GxApwd9Yd49dZVQ6cerOQpy9UtcVoNZMvXV/
         YoLD3B2m6oiCl3lmHwzM7XUoB2WHeZnvmx5h7nxgT2i3la3Uilb0/0+LJgGSg6qCxw8x
         GrbkCNyMQQr3os9UMj7rM/LqRIeb/Y0nbv0L/q6aLv3WhdhUrA9o4gGPaLo3glRQOhJ/
         V8nPztBRrOQg75jWvNKYja/sdsfhDGRtjF+BfGM++gt/MkJdbBqYoWUBtqOib8n051y9
         C4Pwrik7W5NTP3EXpO56oIAs9dr/VY5R7uGvruU3ecTnvY9WAGyYZr+az9Vff8+UXR70
         zT5A==
X-Gm-Message-State: ACrzQf3VbiD5xLCyGLlAmlcAIWTnOEaT5Nxsch7UBykMi7CZosWi2C6z
        0bpbEXX9Bp9jOUzSvjiN+0hagAeqqi0=
X-Google-Smtp-Source: AMsMyM4T+0uGRWLvUovEbMN3yV1wo9usbWAkNU8jPpUn8DEKDDnv55anNtH7szbeb0HOG1dxEUj7l7LV5jE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3d82:0:b0:43b:d646:1bb5 with SMTP id
 k124-20020a633d82000000b0043bd6461bb5mr3432423pga.620.1663716731774; Tue, 20
 Sep 2022 16:32:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:27 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-22-seanjc@google.com>
Subject: [PATCH v3 21/28] KVM: x86: Inhibit APICv/AVIC if the optimized
 physical map is disabled
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

Inhibit APICv/AVIC if the optimized physical map is disabled so that KVM
KVM provides consistent APIC behavior if xAPIC IDs are aliased due to
vcpu_id being truncated and the x2APIC hotplug hack isn't enabled.  If
the hotplug hack is disabled, events that are emulated by KVM will follow
architectural behavior (all matching vCPUs receive events, even if the
"match" is due to truncation), whereas APICv and AVIC will deliver events
only to the first matching vCPU, i.e. the vCPU that matches without
truncation.

Note, the "extra" inhibit is needed because  KVM deliberately ignores
mismatches due to truncation when applying the APIC_ID_MODIFIED inhibit
so that large VMs (>255 vCPUs) can run with APICv/AVIC.

Fixes: TDB
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/lapic.c            | 13 ++++++++++++-
 arch/x86/kvm/svm/avic.c         |  1 +
 arch/x86/kvm/vmx/vmx.c          |  1 +
 4 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6570b5d728ef..594674eefe59 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1097,6 +1097,12 @@ enum kvm_apicv_inhibit {
 	 */
 	APICV_INHIBIT_REASON_BLOCKIRQ,
 
+	/*
+	 * APICv is disabled because not all vCPUs have a 1:1 mapping between
+	 * APIC ID and vCPU, _and_ KVM is not applying its x2APIC hotplug hack.
+	 */
+	APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED,
+
 	/*
 	 * For simplicity, the APIC acceleration is inhibited
 	 * first time either APIC ID or APIC base are changed by the guest
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b344ab52556e..4db162b1f0b1 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -381,6 +381,16 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 		cluster[ldr] = apic;
 	}
 out:
+	/*
+	 * The optimized map is effectively KVM's internal version of APICv,
+	 * and all unwanted aliasing that results in disabling the optimized
+	 * map also applies to APICv.
+	 */
+	if (!new)
+		kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED);
+	else
+		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED);
+
 	old = rcu_dereference_protected(kvm->arch.apic_map,
 			lockdep_is_held(&kvm->arch.apic_map_lock));
 	rcu_assign_pointer(kvm->arch.apic_map, new);
@@ -2150,7 +2160,8 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
 	/*
 	 * Deliberately truncate the vCPU ID when detecting a modified APIC ID
 	 * to avoid false positives if the vCPU ID, i.e. x2APIC ID, is a 32-bit
-	 * value.
+	 * value.  If the wrap/truncation results in unwatned aliasing, APICv
+	 * will be inhibited as part of updating KVM's optimized APIC maps.
 	 */
 	if (kvm_xapic_id(apic) == (u8)apic->vcpu->vcpu_id)
 		return;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index dd0e41d454a7..2908adc79ea6 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -965,6 +965,7 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
 			  BIT(APICV_INHIBIT_REASON_SEV)      |
+			  BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |
 			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
 			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |
 			  BIT(APICV_INHIBIT_REASON_X2APIC);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b39095ef9bd7..0f9f8ae59f85 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7963,6 +7963,7 @@ static bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 			  BIT(APICV_INHIBIT_REASON_ABSENT) |
 			  BIT(APICV_INHIBIT_REASON_HYPERV) |
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
+			  BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |
 			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
 			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
 
-- 
2.37.3.968.ga6b4b080e4-goog

