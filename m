Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96922660AA0
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 01:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbjAGAN1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 19:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbjAGANS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 19:13:18 -0500
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ADA460877
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 16:13:16 -0800 (PST)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pDwpm-004nJ2-Lv; Sat, 07 Jan 2023 01:13:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=hg9zooN1O1hQoGZZWTKe6bkOQB4jBDV2d3MgPxz019A=; b=euoh2TwK2ZkTlKLjIql8FScE6X
        myoW8TNVlQ+qdaKkhkJx+rzD8quZ//qZgFHP1Yk1n9rzFcqQFHThkGVBGB4dO6MmFmdDnZhGgMB+K
        5d8h9OAgqwI6UsSXnS1gpzq70ekVyuNOLutNGp9GdBh6FX+HtsQ6RLkrtZwlcPL8fBdi24otcynBW
        LxoiJdIqQNtY7wJ//3PwMenbuPU8kUN7FAPgaKO0Iod7owBt/wryYvLfHgtASQYWyIYBpHYXcqNwn
        iioebjzkY88T3MAaCrzpxItr9OIZEjASbbBZmvx/Ko5qw3ge90pzgFPIIXu/hc6x1+ZplCWq00JVS
        ROp48+CA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pDwpm-0002cY-CT; Sat, 07 Jan 2023 01:13:14 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pDwpi-0002mN-KD; Sat, 07 Jan 2023 01:13:10 +0100
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, paul@xen.org, seanjc@google.com,
        pbonzini@redhat.com, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH v2 1/6] KVM: x86: Optimize kvm->lock and SRCU interaction (KVM_SET_PMU_EVENT_FILTER)
Date:   Sat,  7 Jan 2023 01:12:51 +0100
Message-Id: <20230107001256.2365304-2-mhal@rbox.co>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230107001256.2365304-1-mhal@rbox.co>
References: <20230107001256.2365304-1-mhal@rbox.co>
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

Reduce time spent holding kvm->lock: unlock mutex before calling
synchronize_srcu_expedited().

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/pmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index eb594620dd75..18f709d3d8ba 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -633,6 +633,7 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	mutex_lock(&kvm->lock);
 	filter = rcu_replace_pointer(kvm->arch.pmu_event_filter, filter,
 				     mutex_is_locked(&kvm->lock));
+	mutex_unlock(&kvm->lock);
 	synchronize_srcu_expedited(&kvm->srcu);
 
 	BUILD_BUG_ON(sizeof(((struct kvm_pmu *)0)->reprogram_pmi) >
@@ -643,8 +644,6 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 
 	kvm_make_all_cpus_request(kvm, KVM_REQ_PMU);
 
-	mutex_unlock(&kvm->lock);
-
 	r = 0;
 cleanup:
 	kfree(filter);
-- 
2.39.0

