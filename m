Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CAE46CA8D
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243627AbhLHB7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243240AbhLHB6p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:58:45 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA723C0698CD
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:55:11 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id bf17-20020a17090b0b1100b001a634dbd737so2710076pjb.9
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3aCuJMfMHs3SWtggi+I9Cs3L2a0EwivzrBeo1W7uLTQ=;
        b=YN6ImAQZaOEXzCZQuswx/CTadBK+2y0AdGEJQtahln1tgbBs1poFnAV8djVGK5n7EO
         jG+ufcxESTPvQb19oLKtRxWkutlq7NE8qy/jzV5RIRmrpVmm/3LHGF+2GB84EWjniv8W
         loQOT3iiaUndNCYXWVVYlhZqgvXOIsHCYzJ+hUQxkhUaoQbtEFEpzfeSsphdLG7hg5P4
         JMrRKbKhkgk5qttoxd1Q5137Aqwk5wAqWlPBJVS2z9279DhubHlE9fTRMqD5L79mQuMw
         E/jv4/Tao9gXqj+e/eOzAR1YwI+J8azjwocOuUZIRvgs8/rg81R4PwkLVZh+QqEr6G2/
         8GQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3aCuJMfMHs3SWtggi+I9Cs3L2a0EwivzrBeo1W7uLTQ=;
        b=0VbWj7cj7fCGRWDMQ88FarBvj4tTQxQRZ95WWLV6iq/5ycvHLmaXNP14utgLycjHl/
         JEagchaE6KOwxwWF6htUNnnaOQvVjMH+1qiToXEr4iHmN+xUrK3XoHdvwSVW/8r/Ln58
         5WinFQZH8xNjq9jjVczqiNMJamtPICZx5AwuijyNGPsFq/asDJ4hf/RGgp8FfDDJ9xdW
         WI1K9GYz70z2OQpt6UYFCkKCHb00Gx43x802SVHt+1JIDDHyKSgutnR34NHnOPqu8t2a
         8bSYzMlhasmcGJgqSegV3uw0y4JGBnrAZTJ0Qz9CI4ziFPkdblfXlOYjwwzTGM+GbzGn
         GmKQ==
X-Gm-Message-State: AOAM533EexnafaEVBLTX4IO+NFP6jeaXSKHcvCvVXkOPm/XS42eh/Jxy
        F59IzaDvrNtQUZss4oAa+ud+o6lDZQk=
X-Google-Smtp-Source: ABdhPJyH9lBa9R496fB+xYtHQMbq+NgJWpFjohfcNU7q50G/OFjItH3xA5+gGAj3jNjGfNUh4zq6Jh7tlfM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1946:b0:492:64f1:61b5 with SMTP id
 s6-20020a056a00194600b0049264f161b5mr2932849pfk.52.1638928511449; Tue, 07 Dec
 2021 17:55:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:25 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-16-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 15/26] iommu/amd: KVM: SVM: Use pCPU to infer IsRun state
 for IRTE
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the one and only caller of amd_iommu_update_ga() passes in
"is_run == (cpu >= 0)" in all paths, infer IRT.vAPIC.IsRun from @cpu
instead of having the caller pass redundant information.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c   | 8 ++++----
 drivers/iommu/amd/iommu.c | 6 ++++--
 include/linux/amd-iommu.h | 6 ++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 0c6dfd85b3bb..88b3c315b34f 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -941,7 +941,7 @@ bool svm_check_apicv_inhibit_reasons(ulong bit)
 
 
 static inline int
-avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
+avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu)
 {
 	int ret = 0;
 	unsigned long flags;
@@ -961,7 +961,7 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 		goto out;
 
 	list_for_each_entry(ir, &svm->ir_list, node) {
-		ret = amd_iommu_update_ga(cpu, r, ir->data);
+		ret = amd_iommu_update_ga(cpu, ir->data);
 		if (ret)
 			break;
 	}
@@ -1002,7 +1002,7 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
-	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
+	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id);
 }
 
 void avic_vcpu_put(struct kvm_vcpu *vcpu)
@@ -1016,7 +1016,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
 		return;
 
-	avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
+	avic_update_iommu_vcpu_affinity(vcpu, -1);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 461f1844ed1f..2affb42fa319 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3522,7 +3522,7 @@ int amd_iommu_create_irq_domain(struct amd_iommu *iommu)
 	return 0;
 }
 
-int amd_iommu_update_ga(int cpu, bool is_run, void *data)
+int amd_iommu_update_ga(int cpu, void *data)
 {
 	unsigned long flags;
 	struct amd_iommu *iommu;
@@ -3552,8 +3552,10 @@ int amd_iommu_update_ga(int cpu, bool is_run, void *data)
 						APICID_TO_IRTE_DEST_LO(cpu);
 			ref->hi.fields.destination =
 						APICID_TO_IRTE_DEST_HI(cpu);
+			ref->lo.fields_vapic.is_run = true;
+		} else {
+			ref->lo.fields_vapic.is_run = false;
 		}
-		ref->lo.fields_vapic.is_run = is_run;
 		barrier();
 	}
 
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index 58e6c3806c09..005aa3ada2e9 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -165,8 +165,7 @@ static inline int amd_iommu_detect(void) { return -ENODEV; }
 /* IOMMU AVIC Function */
 extern int amd_iommu_register_ga_log_notifier(int (*notifier)(u32));
 
-extern int
-amd_iommu_update_ga(int cpu, bool is_run, void *data);
+extern int amd_iommu_update_ga(int cpu, void *data);
 
 extern int amd_iommu_activate_guest_mode(void *data);
 extern int amd_iommu_deactivate_guest_mode(void *data);
@@ -179,8 +178,7 @@ amd_iommu_register_ga_log_notifier(int (*notifier)(u32))
 	return 0;
 }
 
-static inline int
-amd_iommu_update_ga(int cpu, bool is_run, void *data)
+static inline int amd_iommu_update_ga(int cpu, void *data)
 {
 	return 0;
 }
-- 
2.34.1.400.ga245620fadb-goog

