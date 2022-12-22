Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0D465473F
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 21:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbiLVUhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 15:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbiLVUg4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 15:36:56 -0500
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A4F2127D
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 12:36:53 -0800 (PST)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1p8SJ8-002IE9-HI; Thu, 22 Dec 2022 21:36:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=C4yMV8+Zqwwf16UocBmbBw4dV9YVec7XOkMKXgcKVtc=; b=HZLK9dgNwyBkUPfdqdfZGnrHGV
        S7wZN8Z2o9hi1mK3C9Vz1LNSgyfEKoak9AUefMvWn/kVPPlaXLVZpkvaXeoYLKsS0rm9lTxIwEMNc
        zJ0StLjWr8X5yxZCyzpMXqSmIr+rvtP26ZMg2cE3BxtdL3u7GDm0GzakgG/dNBMtJvR+9avl+HFje
        5DtzQZEzJLux9pNoyHkpqkgmPtazRsGmNM3er2AfQhEdtCf9KfB5f2GxUrfJdy7XMl8OddVYCGTnL
        NstNE3Zio7bAk7pKSv/W1mqvRPHf0B01mejMDzEE1f6RDU5hcsn3HXD/GFYtMdQEnV9z0g8+NJugd
        A0mAL0iw==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1p8SJ7-0005EI-Vi; Thu, 22 Dec 2022 21:36:50 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1p8SJ3-0007g4-Q9; Thu, 22 Dec 2022 21:36:45 +0100
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, paul@xen.org, seanjc@google.com,
        pbonzini@redhat.com, Michal Luczaj <mhal@rbox.co>
Subject: [RFC PATCH 1/2] KVM: x86/xen: Fix use-after-free in kvm_xen_eventfd_update()
Date:   Thu, 22 Dec 2022 21:30:20 +0100
Message-Id: <20221222203021.1944101-2-mhal@rbox.co>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221222203021.1944101-1-mhal@rbox.co>
References: <20221222203021.1944101-1-mhal@rbox.co>
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

Protect `evtchnfd` by entering SRCU critical section.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/xen.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index d7af40240248..8e17629e5665 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1825,20 +1825,26 @@ static int kvm_xen_eventfd_update(struct kvm *kvm,
 {
 	u32 port = data->u.evtchn.send_port;
 	struct evtchnfd *evtchnfd;
+	int ret = -EINVAL;
+	int idx;
 
 	if (!port || port >= max_evtchn_port(kvm))
 		return -EINVAL;
 
+	idx = srcu_read_lock(&kvm->srcu);
+
 	mutex_lock(&kvm->lock);
 	evtchnfd = idr_find(&kvm->arch.xen.evtchn_ports, port);
 	mutex_unlock(&kvm->lock);
 
-	if (!evtchnfd)
-		return -ENOENT;
+	if (!evtchnfd) {
+		ret = -ENOENT;
+		goto out_rcu;
+	}
 
 	/* For an UPDATE, nothing may change except the priority/vcpu */
 	if (evtchnfd->type != data->u.evtchn.type)
-		return -EINVAL;
+		goto out_rcu; /* -EINVAL */
 
 	/*
 	 * Port cannot change, and if it's zero that was an eventfd
@@ -1846,11 +1852,11 @@ static int kvm_xen_eventfd_update(struct kvm *kvm,
 	 */
 	if (!evtchnfd->deliver.port.port ||
 	    evtchnfd->deliver.port.port != data->u.evtchn.deliver.port.port)
-		return -EINVAL;
+		goto out_rcu; /* -EINVAL */
 
 	/* We only support 2 level event channels for now */
 	if (data->u.evtchn.deliver.port.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL)
-		return -EINVAL;
+		goto out_rcu; /* -EINVAL */
 
 	mutex_lock(&kvm->lock);
 	evtchnfd->deliver.port.priority = data->u.evtchn.deliver.port.priority;
@@ -1859,7 +1865,10 @@ static int kvm_xen_eventfd_update(struct kvm *kvm,
 		evtchnfd->deliver.port.vcpu_idx = -1;
 	}
 	mutex_unlock(&kvm->lock);
-	return 0;
+	ret = 0;
+out_rcu:
+	srcu_read_unlock(&kvm->srcu, idx);
+	return ret;
 }
 
 /*
-- 
2.39.0

