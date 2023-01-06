Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8283665F8E8
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjAFBQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbjAFBP5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:15:57 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242CD3E85D
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 17:14:09 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id z10-20020a170902ccca00b001898329db72so102963ple.21
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 17:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZYN39wk6a5NRPTtVgQ2fmBkBZpoYFPy36qtJQgrzBbQ=;
        b=S4tMZcslkr51udzOZhWe5rKJnCQOlvWCj/gy1+r0cmExiw+cnm625YYiIx8qAy+rxD
         WvQgMxjEoJ9RMz74DDzoYV0cEZd9fIWBvu19nxlEKwAH50Xx4FuNpoFVUcgflwQJEmrS
         eJ6h18W2yIpdYB+fSPatYOOy2+0JgVN81vNGq4AmpfL1sQJ+L+DzVIA4kaxrkDdk+Kxs
         yX3KZ6hxCMxxepCxPmR0I5QKTDhwjTUuZ5zXzQk1rkP4kdAB8qBwDUmsRn4cQl61qejp
         GXqhyHZjijzndqJQIuKbqe8zAn+FYcY7F4/TpJ4UFQoxhUpsZcfqCaYEyvGEMbo4XoTB
         8oKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZYN39wk6a5NRPTtVgQ2fmBkBZpoYFPy36qtJQgrzBbQ=;
        b=gXOs9jRwulX7R6L1g6ETq9YrO3/VjxDFYlhew6nj+28crtA9MSPEHE3hMTqo7wiJ/N
         O5hq1tHE048TKivv7otdDCAuMNN92fRj8E6yHXeLfLeIxbHkoHnOD53eMYtZXk0Z+tFE
         MW56RuVyUig+L03+DJS7ChmpCNt5VsFw2erPdfMgZfRGdI6G91ioQR2mDGf2Ig5AHfHf
         S9b26rn7zmJyoXGGHKFGOouLmS8iY137IIpDoLscRaMFKEFgG+aaJasI2/GnaNiEsS4b
         ysr4KQpIebVlJas4mOOFiCicfwNOF1PUL4ADKdrfD6lpuUFcO45GIUHwhuqvfPONAxIN
         gs+A==
X-Gm-Message-State: AFqh2kpazDOld6DQATz9nXaqhnfPqJv0JfQOgWEl2WSIxh0Ay7maAMxU
        /ncNWvDI/rleaPfvPCVEZ4JMV5fSksA=
X-Google-Smtp-Source: AMrXdXtIxuiZo4uQS0TAEd0ESAD1k/+gcNYoYbiUur7Y/bROd25mlKsy0v4oVfmQ6pLGio+ZNRfdiUZO9I0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:a50c:b0:226:744:d464 with SMTP id
 a12-20020a17090aa50c00b002260744d464mr2481575pjq.62.1672967632838; Thu, 05
 Jan 2023 17:13:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  6 Jan 2023 01:12:56 +0000
In-Reply-To: <20230106011306.85230-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230106011306.85230-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230106011306.85230-24-seanjc@google.com>
Subject: [PATCH v5 23/33] KVM: x86: Inhibit APICv/AVIC if the optimized
 physical map is disabled
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>,
        Greg Edwards <gedwards@ddn.com>
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/lapic.c            | 13 ++++++++++++-
 arch/x86/kvm/svm/avic.c         |  1 +
 arch/x86/kvm/vmx/vmx.c          |  1 +
 4 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 732421a0ad02..5865bad08a23 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1174,6 +1174,12 @@ enum kvm_apicv_inhibit {
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
index e9f258de91bd..297da684c25f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -386,6 +386,16 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
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
@@ -2158,7 +2168,8 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
 	/*
 	 * Deliberately truncate the vCPU ID when detecting a modified APIC ID
 	 * to avoid false positives if the vCPU ID, i.e. x2APIC ID, is a 32-bit
-	 * value.
+	 * value.  If the wrap/truncation results in unwanted aliasing, APICv
+	 * will be inhibited as part of updating KVM's optimized APIC maps.
 	 */
 	if (kvm_xapic_id(apic) == (u8)apic->vcpu->vcpu_id)
 		return;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 76da9f19272e..d1ac19f053ce 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -965,6 +965,7 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
 			  BIT(APICV_INHIBIT_REASON_SEV)      |
+			  BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |
 			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
 			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8ed14fcfe870..ef84d11a0fe4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8029,6 +8029,7 @@ static bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 			  BIT(APICV_INHIBIT_REASON_ABSENT) |
 			  BIT(APICV_INHIBIT_REASON_HYPERV) |
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
+			  BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |
 			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
 			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
 
-- 
2.39.0.314.g84b9a713c41-goog

