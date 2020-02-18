Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBB55161E6C
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 02:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgBRBMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 20:12:17 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46041 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgBRBMR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 20:12:17 -0500
Received: by mail-pl1-f194.google.com with SMTP id b22so7380381pls.12;
        Mon, 17 Feb 2020 17:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ZxKP5V2Mq8nq1NJT8kCExycpnJ7xXGIEe62BmBC6pgo=;
        b=SgnErVfo7B0izjblZdA7Xjs+KoiIHz/UwsemL9I+V5sI8Tnr8cHyqoLbYLkmJFBJy4
         5nbmHMJpaHep+xoxexfAbnCpnLXgE8flUzIKz2viz/FWFiSlBVuFskCxoo9H9Y60CwQJ
         acNe1VUdIpPRPamEDEkTyllDVGSXre11aHOpSF13dbhLRzpqaxmjEREmt5kAZnh1cFzk
         N47zcEDYxVpMEsAAg29OK5hkNncjuDzvGZKO2sQyS92MW/H9Vmt7/IiUKSlEBfRjlB3q
         VpA32+S67p8kmm/PavGgILWqVeg7xr2t7Hw0SZgOLuAZu5LEUHR15C9k6jmC4HmnmAQo
         fkUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZxKP5V2Mq8nq1NJT8kCExycpnJ7xXGIEe62BmBC6pgo=;
        b=iI0+UtxWccX7phl8UMbd84fwT+iyAqy/dE9ZvaupdwaY9Znlj5z0TqYJv0OW10WRiW
         tBJ+PbObZSjUJdK/R08iVA2lINt3cmyiciKrnIbanx1Qh/wknoSkUQKJ30kQwbuClA8w
         qN8M2CWPX8FSjAK0tX5yQMIbmqaKGH9vLlZ8qg/JcSPrt/QtePf5wwrRs0vuXSQMUpd5
         7MpMYBniPuhWlVxckXQb79mcQA05uDWSUmdYN6Thdk7MFaXOaBfSRVGqz5EOuYk0S6qu
         X/0qlFqR8n6vXTuJcItfIfJI2ph40ENrtXrF0e/cKRGVGjqdFLfAYPPZem2WK+Zkwjrn
         CFxA==
X-Gm-Message-State: APjAAAVWryNJCJolhV/JU0ysUGtwIgszwPPyxLa6eJZwzZHPBizIJG4+
        Is+NK3jQfadXy2SmT6XGoQPfNNMGtshHpg==
X-Google-Smtp-Source: APXvYqwHq705bhIBaKvXNiyqjqNYqnBThSAuV9Rof4MWuNkr6sKJSMR5/LOIEjIYURud6plj7bvurA==
X-Received: by 2002:a17:90a:a88d:: with SMTP id h13mr2085017pjq.48.1581988336244;
        Mon, 17 Feb 2020 17:12:16 -0800 (PST)
Received: from kernel.DHCP ([120.244.140.205])
        by smtp.googlemail.com with ESMTPSA id x23sm2074774pge.89.2020.02.17.17.11.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 17 Feb 2020 17:12:15 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH RESEND v2 1/2] KVM: Introduce pv check helpers
Date:   Tue, 18 Feb 2020 09:08:23 +0800
Message-Id: <1581988104-16628-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Introduce some pv check helpers for consistency.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kernel/kvm.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d817f25..76ea8c4 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -425,7 +425,27 @@ static void __init sev_map_percpu_data(void)
 	}
 }
 
+static bool pv_tlb_flush_supported(void)
+{
+	return (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
+		!kvm_para_has_hint(KVM_HINTS_REALTIME) &&
+		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
+}
+
 #ifdef CONFIG_SMP
+
+static bool pv_ipi_supported(void)
+{
+	return kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI);
+}
+
+static bool pv_sched_yield_supported(void)
+{
+	return (kvm_para_has_feature(KVM_FEATURE_PV_SCHED_YIELD) &&
+		!kvm_para_has_hint(KVM_HINTS_REALTIME) &&
+	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
+}
+
 #define KVM_IPI_CLUSTER_SIZE	(2 * BITS_PER_LONG)
 
 static void __send_ipi_mask(const struct cpumask *mask, int vector)
@@ -619,9 +639,7 @@ static void __init kvm_guest_init(void)
 		pv_ops.time.steal_clock = kvm_steal_clock;
 	}
 
-	if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
-	    !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
-	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
+	if (pv_tlb_flush_supported()) {
 		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
 		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
 	}
@@ -632,9 +650,7 @@ static void __init kvm_guest_init(void)
 #ifdef CONFIG_SMP
 	smp_ops.smp_prepare_cpus = kvm_smp_prepare_cpus;
 	smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
-	if (kvm_para_has_feature(KVM_FEATURE_PV_SCHED_YIELD) &&
-	    !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
-	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
+	if (pv_sched_yield_supported()) {
 		smp_ops.send_call_func_ipi = kvm_smp_send_call_func_ipi;
 		pr_info("KVM setup pv sched yield\n");
 	}
@@ -700,7 +716,7 @@ static uint32_t __init kvm_detect(void)
 static void __init kvm_apic_init(void)
 {
 #if defined(CONFIG_SMP)
-	if (kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI))
+	if (pv_ipi_supported())
 		kvm_setup_pv_ipi();
 #endif
 }
@@ -739,9 +755,7 @@ static __init int kvm_setup_pv_tlb_flush(void)
 	if (!kvm_para_available() || nopv)
 		return 0;
 
-	if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
-	    !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
-	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
+	if (pv_tlb_flush_supported()) {
 		for_each_possible_cpu(cpu) {
 			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_tlb_mask, cpu),
 				GFP_KERNEL, cpu_to_node(cpu));
-- 
2.7.4

