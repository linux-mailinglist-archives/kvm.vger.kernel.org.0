Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A605354EB4
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 10:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239927AbhDFIcy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 04:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbhDFIcw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 04:32:52 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE0CC06174A;
        Tue,  6 Apr 2021 01:32:41 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso7260320pjb.3;
        Tue, 06 Apr 2021 01:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=IDxkuTbkM54Xm1Acge8AgpMHwOFsJk+F1h7AXGDseX4=;
        b=cSG6YBH2D0dnDpTEOvco0wOUCWTCMZZyT2LESFBnj7V7NcFMOtgyKjphIv4te74/vy
         g53XBfnJp/WLHiwxCgdkthf22Tzk3tVMBH/CMVO/KnCJc/sMziNzw67QWGNRbpjFFRKz
         LZH8TLtqYNJ3vwJP/F8xzg16FpULRYSmANSNIk44dMiDRvs83gGFQkuNcRM+xGgnhpIz
         bnHE7n1eXTWz0u/RhiqRoMlwJAWRz+4v7jSc3XHQERhfTfICABrCWlxLvvXIv/0F8JX+
         4RcgptrSo5glUKkXeWMt3nB+9oiWEbJYHgmpDGXBBOVqHY1fiHFOKjE2Qx42PKaWi0sV
         qg9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IDxkuTbkM54Xm1Acge8AgpMHwOFsJk+F1h7AXGDseX4=;
        b=nB/jwKy/uOlTvK2XUDE7s8WVTqkQY5dKpcu48Lmwe4b2VvwMB+s4uo2iiHqKVonGXW
         gXHbiekSVzwvTvM8nYORtss95CQS5ZzBt9l7AamRqijBMXgA/IlSsXOUcdggbjPFME6v
         DGSSZaWPNnUYZXwAzx1W6fHelMZ2gnaosbgWlybUvKZsmpkQZaQr6SuA6RBv5PgMbv/U
         /h2AdWkTJVoroOOgUFKHs/eRZcCr4h5wepxMnEwydFRzcbgS9apGbGfbiQi53J1Gbdw/
         7AOT+f/X5U75+DSwmgzz5t8Ajc2TOC/pfsbTecOT2eGEQwLlFuhDvIqNfpmPbBWRBjjs
         Ej+Q==
X-Gm-Message-State: AOAM533ioeCn5bms/yPJinPbQoutFAl1gOnP1UMgZ6Bh1bdJB4NBeQF5
        WsTDt0EkuBAsJ27EcwSED7rTL0mknfQ=
X-Google-Smtp-Source: ABdhPJwsrMNhimh7AmIjFD12TWEarPGaBkgfFq8boNstUh+9CL4/MgCmE8I0BfiUI/DUb1PxHS2lTQ==
X-Received: by 2002:a17:902:7c8a:b029:e6:f010:a4f4 with SMTP id y10-20020a1709027c8ab02900e6f010a4f4mr27386180pll.17.1617697960930;
        Tue, 06 Apr 2021 01:32:40 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id u25sm17869165pgk.34.2021.04.06.01.32.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Apr 2021 01:32:39 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: X86: Count success and invalid yields
Date:   Tue,  6 Apr 2021 16:32:15 +0800
Message-Id: <1617697935-4158-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

To analyze some performance issues with lock contention and scheduling,
it is nice to know when directed yield are successful or failing.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/x86.c              | 26 ++++++++++++++++++++------
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 44f8930..157bcaa 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1126,6 +1126,8 @@ struct kvm_vcpu_stat {
 	u64 halt_poll_success_ns;
 	u64 halt_poll_fail_ns;
 	u64 nested_run;
+	u64 yield_directed;
+	u64 yield_directed_ignore;
 };
 
 struct x86_instruction_info;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 16fb395..3b475cd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -246,6 +246,8 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
 	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
 	VCPU_STAT("nested_run", nested_run),
+	VCPU_STAT("yield_directed", yield_directed),
+	VCPU_STAT("yield_directed_ignore", yield_directed_ignore),
 	VM_STAT("mmu_shadow_zapped", mmu_shadow_zapped),
 	VM_STAT("mmu_pte_write", mmu_pte_write),
 	VM_STAT("mmu_pde_zapped", mmu_pde_zapped),
@@ -8211,21 +8213,33 @@ void kvm_apicv_init(struct kvm *kvm, bool enable)
 }
 EXPORT_SYMBOL_GPL(kvm_apicv_init);
 
-static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
+static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 {
 	struct kvm_vcpu *target = NULL;
 	struct kvm_apic_map *map;
 
+	vcpu->stat.yield_directed++;
+
 	rcu_read_lock();
-	map = rcu_dereference(kvm->arch.apic_map);
+	map = rcu_dereference(vcpu->kvm->arch.apic_map);
 
 	if (likely(map) && dest_id <= map->max_apic_id && map->phys_map[dest_id])
 		target = map->phys_map[dest_id]->vcpu;
 
 	rcu_read_unlock();
+	if (!target)
+		goto no_yield;
+
+	if (!READ_ONCE(target->ready))
+		goto no_yield;
 
-	if (target && READ_ONCE(target->ready))
-		kvm_vcpu_yield_to(target);
+	if (kvm_vcpu_yield_to(target) <= 0)
+		goto no_yield;
+	return;
+
+no_yield:
+	vcpu->stat.yield_directed_ignore++;
+	return;
 }
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
@@ -8272,7 +8286,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 			break;
 
 		kvm_pv_kick_cpu_op(vcpu->kvm, a0, a1);
-		kvm_sched_yield(vcpu->kvm, a1);
+		kvm_sched_yield(vcpu, a1);
 		ret = 0;
 		break;
 #ifdef CONFIG_X86_64
@@ -8290,7 +8304,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_SCHED_YIELD))
 			break;
 
-		kvm_sched_yield(vcpu->kvm, a0);
+		kvm_sched_yield(vcpu, a0);
 		ret = 0;
 		break;
 	default:
-- 
2.7.4

