Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845F865921D
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 22:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbiL2VSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 16:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234153AbiL2VSF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 16:18:05 -0500
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3560762CA
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 13:18:02 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pB0Hm-001cON-TZ; Thu, 29 Dec 2022 22:17:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=8V0C+YN4k8Huv/Wg5j1DYeRaN7YQExDrNQMMfqjEXjQ=; b=M9tetROicwnHpaVIsE5n4qYsxJ
        2uBnAOcoUktHdZwjbqjV/RXSivp3QoEo6GjE15mhftalmZE7xtLUFEIu0oF0q6gNtlb6haKD2VeGQ
        OxUP7/rV3lKBxtbCyHfIzi90Yd2EuXDtXB4tc8PehI7ephetwbZRGXtYKuy9gq1WuLSHYOV6VOOwc
        v2FqKPD9JU1oJEkLJ74eY+bLnRHnIv6ey2zOCAr5F6jdk3w6oSSNMNkYAED3qzjqAEI92Rlb7GP3c
        JOym0QqwtJPIp7UUC2zBHR8pURBt40h+n9s3NyUGtxoNibUxwxGLvgebuHKY9X4f5FvEqSO+z5/Ft
        6gkLew/g==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pB0Hl-0001ua-Uw; Thu, 29 Dec 2022 22:17:58 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pB0Hf-0003k1-R1; Thu, 29 Dec 2022 22:17:51 +0100
From:   Michal Luczaj <mhal@rbox.co>
To:     pbonzini@redhat.com
Cc:     dwmw2@infradead.org, kvm@vger.kernel.org, paul@xen.org,
        seanjc@google.com, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 1/2] KVM: x86: Fix deadlock in kvm_vm_ioctl_set_msr_filter()
Date:   Thu, 29 Dec 2022 22:17:36 +0100
Message-Id: <20221229211737.138861-2-mhal@rbox.co>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221229211737.138861-1-mhal@rbox.co>
References: <a03a298d-dfd0-b1ed-2375-311044054f1a@redhat.com>
 <20221229211737.138861-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move synchronize_srcu(&kvm->srcu) out of kvm->lock critical section.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/x86.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index da4bbd043a7b..16c89f7e98c3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6460,7 +6460,7 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm,
 	struct kvm_x86_msr_filter *new_filter, *old_filter;
 	bool default_allow;
 	bool empty = true;
-	int r = 0;
+	int r;
 	u32 i;
 
 	if (filter->flags & ~KVM_MSR_FILTER_VALID_MASK)
@@ -6488,16 +6488,14 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm,
 	mutex_lock(&kvm->lock);
 
 	/* The per-VM filter is protected by kvm->lock... */
-	old_filter = srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1);
+	old_filter = rcu_replace_pointer(kvm->arch.msr_filter, new_filter, 1);
+	kvm_make_all_cpus_request(kvm, KVM_REQ_MSR_FILTER_CHANGED);
 
-	rcu_assign_pointer(kvm->arch.msr_filter, new_filter);
-	synchronize_srcu(&kvm->srcu);
+	mutex_unlock(&kvm->lock);
 
+	synchronize_srcu(&kvm->srcu);
 	kvm_free_msr_filter(old_filter);
 
-	kvm_make_all_cpus_request(kvm, KVM_REQ_MSR_FILTER_CHANGED);
-	mutex_unlock(&kvm->lock);
-
 	return 0;
 }
 
-- 
2.39.0

