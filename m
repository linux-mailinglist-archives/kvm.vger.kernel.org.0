Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA1665921F
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 22:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbiL2VSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 16:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbiL2VSF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 16:18:05 -0500
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7955D10B7C
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 13:18:02 -0800 (PST)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pB0Ho-001u33-Ji; Thu, 29 Dec 2022 22:18:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=/UXyHDQ9hua584uPMH9D0zzV36LNJt+AsnZpJaS8ELE=; b=MXtF3rIva6/PNr0/8lr7Vf23q/
        73yn2OyU8kbne5poNxbyY+B8oeGngIhIoTOzlHgAThKVWyoGTpjcECijAeBnSQKms7Azwh9oPIR2e
        FMCJE2n9tVWGWUVH0RSPRZaFuPmP+e2z8jvQZ6Fy6/PJu1xyjDQcmTWs0b1WEWrwM9kjJ87SgB66N
        PHt0M8ZZJz529sCwFdxL3HRnKg4VB8u4qXAdxLigXP6K2v8vYMkLhpEyMRZbWPz0ZETs1HN3Ddxzn
        trsZ2lB+H4o+UAdpBu7S2AgflH8aCYCPXrK6DMIScFFHzhtYDaSt82cG8frocGV6AvmfSKf9TJudX
        tyoxTFoQ==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pB0Ho-00078x-9a; Thu, 29 Dec 2022 22:18:00 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pB0Hg-0003k1-7f; Thu, 29 Dec 2022 22:17:52 +0100
From:   Michal Luczaj <mhal@rbox.co>
To:     pbonzini@redhat.com
Cc:     dwmw2@infradead.org, kvm@vger.kernel.org, paul@xen.org,
        seanjc@google.com, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 2/2] KVM: x86: Fix deadlock in kvm_vm_ioctl_set_pmu_event_filter()
Date:   Thu, 29 Dec 2022 22:17:37 +0100
Message-Id: <20221229211737.138861-3-mhal@rbox.co>
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

Move synchronize_srcu_expedited(&kvm->srcu) out of kvm->lock critical
section.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index eb594620dd75..ea445af5b0ed 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -633,7 +633,6 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	mutex_lock(&kvm->lock);
 	filter = rcu_replace_pointer(kvm->arch.pmu_event_filter, filter,
 				     mutex_is_locked(&kvm->lock));
-	synchronize_srcu_expedited(&kvm->srcu);
 
 	BUILD_BUG_ON(sizeof(((struct kvm_pmu *)0)->reprogram_pmi) >
 		     sizeof(((struct kvm_pmu *)0)->__reprogram_pmi));
@@ -644,6 +643,7 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_PMU);
 
 	mutex_unlock(&kvm->lock);
+	synchronize_srcu_expedited(&kvm->srcu);
 
 	r = 0;
 cleanup:
-- 
2.39.0

