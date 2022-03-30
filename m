Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889304ECAFD
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 19:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349525AbiC3Rsr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 13:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349634AbiC3RsZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 13:48:25 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEABCEA
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 10:46:39 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id k69-20020a628448000000b004fd8affa86aso2882826pfd.12
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 10:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uGhal7P1JB6IhrBSHUiVBKjKdptSWrnYmKPeEqz/Pvs=;
        b=V/bXiybwP6fjl0zOnLiMboN4XAJPfEDymrD4bRqEEmgWd2ITlcImSPxzS4wlpj42fg
         C+oq2yg4HqlE3nl23ASsjQTFtWoi+xuaKI5CtVkYaOoEuN4CU+m6YpvB9NNPRQwIbtW8
         tw6pjbANyD9fgWWo+4HYmaBacgWrucaW5lSX+YdwSdqYWA5ks/CE9Ro1INooC7vZZlOA
         cjnNTFgR8xHJ7b+k8UfRvSX1hIkFvMXlgjAGXsmvNyOIs/x8yKDx6C+sUBwLeHUCwjek
         ybp3TaC51/+gy8QhlV+RXmQ3T60RmcpMnG3x+DuVKQbWrVGrazy6+gP42mW8ZX5Sn8bl
         Kt2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uGhal7P1JB6IhrBSHUiVBKjKdptSWrnYmKPeEqz/Pvs=;
        b=YWnMu/xM1gBPqfwytImwpO4X846Xr4k986Xg/H4/FQOZWDLug/jUrPVt1WgBT6UmRb
         j/cP5FpuIW7UJMZYIQsmNDZzro4WN87BLpeMOkdjLsQIQYciIyt9caWPVtkPUqWgTFwZ
         tUSkgL32FxyuWZynY5m2L425XONLVLYKx01RqPqZG7SEIf6HvVYUG9nzFylKETXV7EjM
         Gu4Llqlc+Ssoa6/GLnc/coRLUTfExRFxYCZAzuBBruQjbNNqt1zehBa/hdjAdtNuq5Hp
         Lhb0gC/gC46xVqZJCzFEwzmp2OQuNk4g6D/1rk/9EJia5puKPQ6Y2qYzRH3UvYpApBdQ
         EeCQ==
X-Gm-Message-State: AOAM5303nVm/AR5rFULsZf1h7K3Wd0RX4iDJ6RgdyKiYA5ijt4HLvyJQ
        SZKma5yPpNp15W0Vl+i4paNpS2Spgs1Y
X-Google-Smtp-Source: ABdhPJwfYbyQTsxv3s9vl5ArrmgX92Re2pJsZ4V6twNNXyBWFFbRN0UBQaQy+LH/dutluDS6j9ho/P/1/z50
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:7c53:ec2f:bd26:b69c])
 (user=bgardon job=sendgmr) by 2002:a17:902:6901:b0:156:4aad:fad7 with SMTP id
 j1-20020a170902690100b001564aadfad7mr466019plk.33.1648662399311; Wed, 30 Mar
 2022 10:46:39 -0700 (PDT)
Date:   Wed, 30 Mar 2022 10:46:17 -0700
In-Reply-To: <20220330174621.1567317-1-bgardon@google.com>
Message-Id: <20220330174621.1567317-8-bgardon@google.com>
Mime-Version: 1.0
References: <20220330174621.1567317-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v3 07/11] KVM: x86/MMU: Factor out updating NX hugepages state
 for a VM
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factor out the code to update the NX hugepages state for an individual
VM. This will be expanded in future commits to allow per-VM control of
Nx hugepages.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dbf46dd98618..af428cb65b3f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6202,6 +6202,15 @@ static void __set_nx_huge_pages(bool val)
 	nx_huge_pages = itlb_multihit_kvm_mitigation = val;
 }
 
+static void kvm_update_nx_huge_pages(struct kvm *kvm)
+{
+	mutex_lock(&kvm->slots_lock);
+	kvm_mmu_zap_all_fast(kvm);
+	mutex_unlock(&kvm->slots_lock);
+
+	wake_up_process(kvm->arch.nx_lpage_recovery_thread);
+}
+
 static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 {
 	bool old_val = nx_huge_pages;
@@ -6224,13 +6233,9 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 
 		mutex_lock(&kvm_lock);
 
-		list_for_each_entry(kvm, &vm_list, vm_list) {
-			mutex_lock(&kvm->slots_lock);
-			kvm_mmu_zap_all_fast(kvm);
-			mutex_unlock(&kvm->slots_lock);
+		list_for_each_entry(kvm, &vm_list, vm_list)
+			kvm_update_nx_huge_pages(kvm);
 
-			wake_up_process(kvm->arch.nx_lpage_recovery_thread);
-		}
 		mutex_unlock(&kvm_lock);
 	}
 
-- 
2.35.1.1021.g381101b075-goog

