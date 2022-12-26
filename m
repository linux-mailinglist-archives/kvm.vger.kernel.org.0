Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D44E656262
	for <lists+kvm@lfdr.de>; Mon, 26 Dec 2022 13:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbiLZMDp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 07:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbiLZMDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 07:03:39 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98A1630F
        for <kvm@vger.kernel.org>; Mon, 26 Dec 2022 04:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=PmBGeZDJIz42IQ50qBEFwBXe6fvk3Bwh4veuXeEI5Iw=; b=PMCBQ4l6g22ROtTiCBPdCUuxd3
        Ojj2SJ93tqjmsbmBJ0DbU1NVe/jyFDL5aeW7BWcjGqM2TulfleZYlYy7KDNTUbXY15KXbbufRSbil
        uR43+iSUu92Mgsn6olWemTPpTnWGnKZX+7RutQdT1s+gajZ1vo8VzpW0YWr9pLAOy1NEL/mMgA59X
        pr0g9rYBBvBannJH9NrZVXRolkYa1dX6lFAMpRt1Ey9ZPEE2ZTSyhnBWJi9x84pP7w5wCOcBGZFiv
        PYX3btOjypfYtIwvYc71qEx3HKJhdM0QOsYop3d3VKg27MMzexHBKo0m36NftoQXHHMGkD4XnCSI4
        SkyPkPMw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1p9mCM-00FJcO-1B;
        Mon, 26 Dec 2022 12:03:18 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p9mCO-004ilp-PU; Mon, 26 Dec 2022 12:03:20 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Michal Luczaj <mhal@rbox.co>,
        Sean Christopherson <seanjc@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>, kvm@vger.kernel.org,
        Paul Durrant <paul@xen.org>
Subject: [PATCH 3/6] KVM: x86/xen: Fix SRCU/RCU usage in readers of evtchn_ports
Date:   Mon, 26 Dec 2022 12:03:17 +0000
Message-Id: <20221226120320.1125390-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221226120320.1125390-1-dwmw2@infradead.org>
References: <b36fa02bc338d6892e63e37768bf47f035339e30.camel@infradead.org>
 <20221226120320.1125390-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

The evtchnfd structure itself must be protected by either kvm->lock or
SRCU. Use the former in kvm_xen_eventfd_update(), since the lock is
being taken anyway; kvm_xen_hcall_evtchn_send() instead is a reader and
does not need kvm->lock, and is called in SRCU critical section from the
kvm_x86_handle_exit function.

It is also important to use rcu_read_{lock,unlock}() in
kvm_xen_hcall_evtchn_send(), because idr_remove() will *not*
use synchronize_srcu() to wait for readers to complete.

Remove a superfluous if (kvm) check before calling synchronize_srcu()
in kvm_xen_eventfd_deassign() where kvm has been dereferenced already.

Co-developed-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 929b887eafd7..9b75457120f7 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1808,20 +1808,23 @@ static int kvm_xen_eventfd_update(struct kvm *kvm,
 {
 	u32 port = data->u.evtchn.send_port;
 	struct evtchnfd *evtchnfd;
+	int ret;
 
 	if (!port || port >= max_evtchn_port(kvm))
 		return -EINVAL;
 
+	/* Protect writes to evtchnfd as well as the idr lookup.  */
 	mutex_lock(&kvm->lock);
 	evtchnfd = idr_find(&kvm->arch.xen.evtchn_ports, port);
-	mutex_unlock(&kvm->lock);
 
+	ret = -ENOENT;
 	if (!evtchnfd)
-		return -ENOENT;
+		goto out_unlock;
 
 	/* For an UPDATE, nothing may change except the priority/vcpu */
+	ret = -EINVAL;
 	if (evtchnfd->type != data->u.evtchn.type)
-		return -EINVAL;
+		goto out_unlock;
 
 	/*
 	 * Port cannot change, and if it's zero that was an eventfd
@@ -1829,20 +1832,21 @@ static int kvm_xen_eventfd_update(struct kvm *kvm,
 	 */
 	if (!evtchnfd->deliver.port.port ||
 	    evtchnfd->deliver.port.port != data->u.evtchn.deliver.port.port)
-		return -EINVAL;
+		goto out_unlock;
 
 	/* We only support 2 level event channels for now */
 	if (data->u.evtchn.deliver.port.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL)
-		return -EINVAL;
+		goto out_unlock;
 
-	mutex_lock(&kvm->lock);
 	evtchnfd->deliver.port.priority = data->u.evtchn.deliver.port.priority;
 	if (evtchnfd->deliver.port.vcpu_id != data->u.evtchn.deliver.port.vcpu) {
 		evtchnfd->deliver.port.vcpu_id = data->u.evtchn.deliver.port.vcpu;
 		evtchnfd->deliver.port.vcpu_idx = -1;
 	}
+	ret = 0;
+out_unlock:
 	mutex_unlock(&kvm->lock);
-	return 0;
+	return ret;
 }
 
 /*
@@ -1935,8 +1939,7 @@ static int kvm_xen_eventfd_deassign(struct kvm *kvm, u32 port)
 	if (!evtchnfd)
 		return -ENOENT;
 
-	if (kvm)
-		synchronize_srcu(&kvm->srcu);
+	synchronize_srcu(&kvm->srcu);
 	if (!evtchnfd->deliver.port.port)
 		eventfd_ctx_put(evtchnfd->deliver.eventfd.ctx);
 	kfree(evtchnfd);
@@ -1989,14 +1992,18 @@ static bool kvm_xen_hcall_evtchn_send(struct kvm_vcpu *vcpu, u64 param, u64 *r)
 
 	/* Sanity check: this structure is the same for 32-bit and 64-bit */
 	BUILD_BUG_ON(sizeof(send) != 4);
-
 	if (kvm_read_guest_virt(vcpu, param, &send, sizeof(send), &e)) {
 		*r = -EFAULT;
 		return true;
 	}
 
-	/* The evtchn_ports idr is protected by vcpu->kvm->srcu */
+	/*
+	 * evtchnfd is protected by kvm->srcu; the idr lookup instead
+	 * is protected by RCU.
+	 */
+	rcu_read_lock();
 	evtchnfd = idr_find(&vcpu->kvm->arch.xen.evtchn_ports, send.port);
+	rcu_read_unlock();
 	if (!evtchnfd)
 		return false;
 
-- 
2.35.3

