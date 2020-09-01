Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE907258DB8
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 13:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgIALzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 07:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727910AbgIALyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 07:54:50 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9833FC061244;
        Tue,  1 Sep 2020 04:54:46 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id gf14so453555pjb.5;
        Tue, 01 Sep 2020 04:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sdnO2t8hyd6szf53M/NoR2MSRbCRlxgUkss4z3MuOMc=;
        b=bEaAHm1D1BxtyLa8bM9yjHZdHLd39ihus0lyKgaRyBs85nksQ+4dU+sz25MwdtKQts
         d2HKQRbZBwLyUf9a6lfYxwuPnXafVh3S7C/BQ7FJCJ2ehldic5UYz24HeZwUN1wP1LB4
         0ZSChwDSMrr8/KR2w33W2oRuEp4K12fDHyBacFgJloBkEzEmruXeWm7NLkjXxM0y44Zg
         j2hPMLM+/eN6NfkmEkONbvt3rYyrAj1ZpKRelqA6CIt1j/9gueXwqR4CBxOiJiTqp0Au
         8KDqtCWvPI5yjTpKE3yPZfbwDjOrM7veJm7VVNkJrXVqVqtgez4yxxxSv3t7v8+URum5
         pOLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sdnO2t8hyd6szf53M/NoR2MSRbCRlxgUkss4z3MuOMc=;
        b=gfE8fF/oXqovVctOB5rXRUTg7Ze5WMq3TD6FnY5GJsi4voRMEE8Pp94DuIYCTdJCib
         v2NToEkqXxDYAIesevgfz4RS3vRCpQcNGrI6FIHEE7Xx/Max0siMqmj8uu/w++DQmKTh
         JQ7zQhfeDIG8QvzWH9Vman5wlL0YDHydB3ocyU7cpgovjUhyDJxzIqPgtQSOzR5V19Kf
         kuaY2FQyQS4Za5T1XF9Yvrig9uB3K97Cwu9w/wu+rJLEKz6grEGeTVW1Wl9uwoxuVDKJ
         AbmG+h5NHieEOeZyUJt9d98igyACRETYN8CNUf7PexWi51drGoWWSDRKyIXDyBtPCszq
         mYrg==
X-Gm-Message-State: AOAM530HQE6v2AtCRNXn6VunWgKMrGBt8EON984AYE4DSjq3KJ8CQ+CU
        cz9tlwEZRVnslWacLhDuFyw=
X-Google-Smtp-Source: ABdhPJyni4c3PgtmyacjDwV12dTFaVS4/RbZSyqkMStZs1OED2/1zfh/a5HSIQdBWXIHrjsO0lpkTw==
X-Received: by 2002:a17:90a:ccd:: with SMTP id 13mr1228049pjt.123.1598961286223;
        Tue, 01 Sep 2020 04:54:46 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.65])
        by smtp.gmail.com with ESMTPSA id q71sm1478964pjq.7.2020.09.01.04.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 04:54:45 -0700 (PDT)
From:   yulei.kernel@gmail.com
X-Google-Original-From: yuleixzhang@tencent.com
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        junaids@google.com, bgardon@google.com, vkuznets@redhat.com,
        xiaoguangrong.eric@gmail.com, kernellwp@gmail.com,
        lihaiwei.kernel@gmail.com, Yulei Zhang <yulei.kernel@gmail.com>,
        Yulei Zhang <yuleixzhang@tencent.com>
Subject: [RFC V2 4/9] Add release function for direct build ept when guest VM exit
Date:   Tue,  1 Sep 2020 19:55:42 +0800
Message-Id: <6023066803ff748b73080fe3bad7aee45ce3f9fa.1598868204.git.yulei.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1598868203.git.yulei.kernel@gmail.com>
References: <cover.1598868203.git.yulei.kernel@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yulei Zhang <yulei.kernel@gmail.com>

Release the pre-pinned memory in direct build ept when guest VM
exit.

Signed-off-by: Yulei Zhang <yuleixzhang@tencent.com>
---
 arch/x86/kvm/mmu/mmu.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 03c5e73b96cb..f2124f52b286 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4309,8 +4309,11 @@ static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd, bool skip_tlb_flush,
 		     bool skip_mmu_sync)
 {
-	__kvm_mmu_new_pgd(vcpu, new_pgd, kvm_mmu_calc_root_page_role(vcpu),
-			  skip_tlb_flush, skip_mmu_sync);
+	if (!vcpu->arch.direct_build_tdp)
+		__kvm_mmu_new_pgd(vcpu, new_pgd, kvm_mmu_calc_root_page_role(vcpu),
+				  skip_tlb_flush, skip_mmu_sync);
+	else
+		vcpu->arch.mmu->root_hpa = INVALID_PAGE;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
 
@@ -5207,10 +5210,14 @@ EXPORT_SYMBOL_GPL(kvm_mmu_load);
 
 void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 {
-	kvm_mmu_free_roots(vcpu, &vcpu->arch.root_mmu, KVM_MMU_ROOTS_ALL);
-	WARN_ON(VALID_PAGE(vcpu->arch.root_mmu.root_hpa));
-	kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
-	WARN_ON(VALID_PAGE(vcpu->arch.guest_mmu.root_hpa));
+	if (!vcpu->arch.direct_build_tdp) {
+		kvm_mmu_free_roots(vcpu, &vcpu->arch.root_mmu, KVM_MMU_ROOTS_ALL);
+		WARN_ON(VALID_PAGE(vcpu->arch.root_mmu.root_hpa));
+		kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
+		WARN_ON(VALID_PAGE(vcpu->arch.guest_mmu.root_hpa));
+	}
+	vcpu->arch.direct_build_tdp = false;
+	vcpu->arch.mmu->root_hpa = INVALID_PAGE;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_unload);
 
@@ -6538,6 +6545,14 @@ void kvm_direct_tdp_remove_page_table(struct kvm *kvm, struct kvm_memory_slot *s
 	kvm_flush_remote_tlbs(kvm);
 }
 
+void kvm_direct_tdp_release_global_root(struct kvm *kvm)
+{
+	if (kvm->arch.global_root_hpa)
+		__kvm_walk_global_page(kvm, kvm->arch.global_root_hpa, max_tdp_level);
+
+	return;
+}
+
 /*
  * Calculate mmu pages needed for kvm.
  */
@@ -6564,9 +6579,13 @@ unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm)
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
-	kvm_mmu_unload(vcpu);
-	free_mmu_pages(&vcpu->arch.root_mmu);
-	free_mmu_pages(&vcpu->arch.guest_mmu);
+	if (vcpu->arch.direct_build_tdp) {
+		vcpu->arch.mmu->root_hpa = INVALID_PAGE;
+	} else {
+		kvm_mmu_unload(vcpu);
+		free_mmu_pages(&vcpu->arch.root_mmu);
+		free_mmu_pages(&vcpu->arch.guest_mmu);
+	}
 	mmu_free_memory_caches(vcpu);
 }
 
-- 
2.17.1

