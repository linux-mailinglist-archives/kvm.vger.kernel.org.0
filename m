Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B878223D12C
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgHET5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727977AbgHEQny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 12:43:54 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D210C0A893C;
        Wed,  5 Aug 2020 07:12:56 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u185so22789067pfu.1;
        Wed, 05 Aug 2020 07:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Z1dq08rcyRAJKP6YZL/SMfPNJkj3TPNkHN01IYY4yWs=;
        b=XroRQzFhX23GOwnvJ+TMAohKF4jLXddbL2pj4Vw71Fv6+fTlsOQL75TwEX/IfhoZXu
         MbkZ02tnwmXDdaJDdqD4378pi9AHy0egPbJGYx/AQ/Qb8zdVOVi5tJAfYkNmTmqyS3k8
         6pmcLeJx6DSR8ghJB/OopLM6Z5YioxqNN1KVrsvbvD69FeKQ7yMg1V4ifrnk4rhuG5I5
         ATi3LOotF/G5kthGiBTZOa+vWCsr97uArQGw/gBUCBzvp18H5F9IWL9fTy6LrnfGFG7u
         LxwozEMlqFzTIzquuHwh3hHdW+HKviD7rvsng85PoalKziVwuQ9ZIXskHGS1Xj5/LQYz
         /0Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Z1dq08rcyRAJKP6YZL/SMfPNJkj3TPNkHN01IYY4yWs=;
        b=sBQ6KALId60/sBtnDB+n9oMqT+Cka/o3NGrCBxhNyKBV4DZre85LgMeyTASQXBxrEB
         o58TGZ2/2M1PwcaPqW0K468SB8yI+T11zdg2eJ1gcR0/1YvnKruk+pXZXB3AdR9L1rBy
         GnPw6RT3t1DT+TfrvhXazQRpU0W9YDi4pQ6QhkUnargnYiRZ2/WO8a900gM7ixjt/Q8O
         bak957wByQLI23MWUKTwHE33Ff9zEpreynf6vwDcsx3xqmSj7pHM66GZOA4G0ozDJTnx
         Yt7nRygquMci4cyTMO5vai5VVU/qTC3jLMYGMpvQ/479KUhqRYbsEDQriAmCgssG9Uiy
         XxLw==
X-Gm-Message-State: AOAM533oHVRqiytEHj6DzgYMar1wXQ9NDOR+DZHDs+f1P7yveATNE0Wp
        g/XchM9OvZ7EczcCIMg2PNg=
X-Google-Smtp-Source: ABdhPJz1faKwYcoCClSYPrpjo3JT+/DAOCDHY/ELu1FrfqxIH1TxDBCpCnDmYm3YXUnuHrmTGX2ONw==
X-Received: by 2002:a65:5502:: with SMTP id f2mr3017228pgr.375.1596636775668;
        Wed, 05 Aug 2020 07:12:55 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.56])
        by smtp.gmail.com with ESMTPSA id b185sm3726551pfg.71.2020.08.05.07.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 07:12:55 -0700 (PDT)
From:   Yulei Zhang <yulei.kernel@gmail.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, xiaoguangrong.eric@gmail.com,
        kernellwp@gmail.com, lihaiwei.kernel@gmail.com,
        Yulei Zhang <yuleixzhang@tencent.com>
Subject: [RFC 4/9] Add release function for direct build ept when guest VM exit
Date:   Wed,  5 Aug 2020 22:13:43 +0800
Message-Id: <20200805141344.9038-1-yulei.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yulei Zhang <yuleixzhang@tencent.com>

Release the pre-pinned memory in direct build ept when guest VM
exit.

Signed-off-by: Yulei Zhang <yuleixzhang@tencent.com>
---
 arch/x86/kvm/mmu/mmu.c | 39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 539974183653..df703deac928 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4360,8 +4360,11 @@ static void __kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3,
 
 void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3, bool skip_tlb_flush)
 {
-	__kvm_mmu_new_cr3(vcpu, new_cr3, kvm_mmu_calc_root_page_role(vcpu),
-			  skip_tlb_flush);
+	if (!vcpu->arch.direct_build_tdp)
+		__kvm_mmu_new_cr3(vcpu, new_cr3, kvm_mmu_calc_root_page_role(vcpu),
+				  skip_tlb_flush);
+	else
+		vcpu->arch.mmu->root_hpa = INVALID_PAGE;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_new_cr3);
 
@@ -5204,10 +5207,16 @@ EXPORT_SYMBOL_GPL(kvm_mmu_load);
 
 void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 {
-	kvm_mmu_free_roots(vcpu, &vcpu->arch.root_mmu, KVM_MMU_ROOTS_ALL);
-	WARN_ON(VALID_PAGE(vcpu->arch.root_mmu.root_hpa));
-	kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
-	WARN_ON(VALID_PAGE(vcpu->arch.guest_mmu.root_hpa));
+
+	if (!vcpu->arch.direct_build_tdp) {
+		kvm_mmu_free_roots(vcpu, &vcpu->arch.root_mmu, KVM_MMU_ROOTS_ALL);
+		WARN_ON(VALID_PAGE(vcpu->arch.root_mmu.root_hpa));
+		kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
+		WARN_ON(VALID_PAGE(vcpu->arch.guest_mmu.root_hpa));
+	}
+
+	vcpu->arch.direct_build_tdp = false;
+	vcpu->arch.mmu->root_hpa = INVALID_PAGE;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_unload);
 
@@ -6510,6 +6519,14 @@ void kvm_direct_tdp_remove_page_table(struct kvm *kvm, struct kvm_memory_slot *s
 	kvm_flush_remote_tlbs(kvm);
 }
 
+void kvm_direct_tdp_release_global_root(struct kvm *kvm)
+{
+	if (kvm->arch.global_root_hpa)
+		__kvm_walk_global_page(kvm, kvm->arch.global_root_hpa, kvm_x86_ops.get_tdp_level(NULL));
+
+	return;
+}
+
 /*
  * Calculate mmu pages needed for kvm.
  */
@@ -6536,9 +6553,13 @@ unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm)
 
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

