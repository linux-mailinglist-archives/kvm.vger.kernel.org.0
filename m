Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70294655975
	for <lists+kvm@lfdr.de>; Sat, 24 Dec 2022 09:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiLXIx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Dec 2022 03:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiLXIxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Dec 2022 03:53:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BACB7D0
        for <kvm@vger.kernel.org>; Sat, 24 Dec 2022 00:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671871987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=bE7Zv2G1RB6/xbT09U4GJ5lBkbria+fSg3I0JpKpvfY=;
        b=QQsWZUQbbhAAxk9MHhCeYW+uxGEnK7aucUrnMkA0wlK7XH0vfVTVjatSMDZTNyZccKrrfS
        aBzFWx1oY5ona6M+enIoTfAQLZX9nR/g3FUQu7EsTC6Zz6WEgM5wI7cwDZAEM1rHJVA9XJ
        kVCOcJ/iQZ8Ae1BPGntsahWdYAjrz98=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-IhNY73X2NEqzIjJDEiA0Iw-1; Sat, 24 Dec 2022 03:53:05 -0500
X-MC-Unique: IhNY73X2NEqzIjJDEiA0Iw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64B9229AA2C1;
        Sat, 24 Dec 2022 08:53:05 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C990340C2064;
        Sat, 24 Dec 2022 08:53:04 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     paul@xen.org, seanjc@google.com, dwmw2@infradead.org,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH] KVM: x86/xen: Fix SRCU/RCU usage in readers of evtchn_ports
Date:   Sat, 24 Dec 2022 03:53:04 -0500
Message-Id: <20221224085304.1629042-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

evtchnfd must be protected by either kvm->lock or SRCU.  Use
the former in kvm_xen_eventfd_update(), since the lock is being
taken anyway; kvm_xen_hcall_evtchn_send() instead is a reader
and does not need kvm->lock, so extend the SRCU critical section
there.

It is also important to use rcu_read_{lock,unlock}() in
kvm_xen_hcall_evtchn_send(), because idr_remove() will *not*
use synchronize_srcu() to wait for readers to complete.

Co-developed-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/xen.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index d7af40240248..935f845d005c 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1825,20 +1825,23 @@ static int kvm_xen_eventfd_update(struct kvm *kvm,
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
@@ -1846,20 +1849,21 @@ static int kvm_xen_eventfd_update(struct kvm *kvm,
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
@@ -2005,19 +2009,23 @@ static bool kvm_xen_hcall_evtchn_send(struct kvm_vcpu *vcpu, u64 param, u64 *r)
 	gpa_t gpa;
 	int idx;
 
+	/*
+	 * evtchnfd is protected by kvm->srcu; the idr lookup instead
+	 * is protected by RCU.
+	 */
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	gpa = kvm_mmu_gva_to_gpa_system(vcpu, param, NULL);
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
 	if (!gpa || kvm_vcpu_read_guest(vcpu, gpa, &send, sizeof(send))) {
 		*r = -EFAULT;
-		return true;
+		goto out_handled;
 	}
 
-	/* The evtchn_ports idr is protected by vcpu->kvm->srcu */
+	rcu_read_lock();
 	evtchnfd = idr_find(&vcpu->kvm->arch.xen.evtchn_ports, send.port);
+	rcu_read_unlock();
 	if (!evtchnfd)
-		return false;
+		goto out_not_handled;
 
 	if (evtchnfd->deliver.port.port) {
 		int ret = kvm_xen_set_evtchn(&evtchnfd->deliver.port, vcpu->kvm);
@@ -2028,7 +2036,13 @@ static bool kvm_xen_hcall_evtchn_send(struct kvm_vcpu *vcpu, u64 param, u64 *r)
 	}
 
 	*r = 0;
+out_handled:
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	return true;
+
+out_not_handled:
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	return false;
 }
 
 void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
-- 
2.31.1

