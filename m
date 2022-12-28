Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72782657599
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 12:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbiL1LFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 06:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbiL1LEz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 06:04:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88758E2D
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 03:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672225454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1pjwclVxU00ME1HQWci/rX5qpnSJvDd+pioG/KTQXLw=;
        b=XzQb7o8fMO2tlHqF3LBk1NDAFzXF6gskgZay2jyivEIi0yCvo0vyoKZibi6fBHUKKR1kQV
        MA+opQOEyxPESlVzsyGBBoIqRBXMLkwH2bF1GoEsIpiClCqpSnH5iQp7y7PgfH87k/H7cO
        vW/gem/UlnhT10yrJyLjuXe/S1L6EKw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-n5pRSaJPNyWZ_I0WqJTFOQ-1; Wed, 28 Dec 2022 06:04:11 -0500
X-MC-Unique: n5pRSaJPNyWZ_I0WqJTFOQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FDCB3814946;
        Wed, 28 Dec 2022 11:04:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26F5840AE1E9;
        Wed, 28 Dec 2022 11:04:11 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH] KVM: x86: fix deadlock for KVM_XEN_EVTCHN_RESET
Date:   Wed, 28 Dec 2022 06:04:09 -0500
Message-Id: <20221228110410.1682852-1-pbonzini@redhat.com>
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

While KVM_XEN_EVTCHN_RESET is usually called with no vCPUs running,
if that happened it could cause a deadlock.  This is due to
kvm_xen_eventfd_reset() doing a synchronize_srcu() inside
a kvm->lock critical section.

To avoid this, first collect all the evtchnfd objects in an
array and free all of them once the kvm->lock critical section
is over and th SRCU grace period has expired.

Reported-by: Michal Luczaj <mhal@rbox.co>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/xen.c                            | 30 +++++++++++++++++--
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |  6 ++++
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index b178f40bd863..2e29bdc2949c 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1942,18 +1942,42 @@ static int kvm_xen_eventfd_deassign(struct kvm *kvm, u32 port)
 
 static int kvm_xen_eventfd_reset(struct kvm *kvm)
 {
-	struct evtchnfd *evtchnfd;
+	struct evtchnfd *evtchnfd, **all_evtchnfds;
 	int i;
+	int n = 0;
 
 	mutex_lock(&kvm->lock);
+
+	/*
+	 * Because synchronize_srcu() cannot be called inside the
+	 * critical section, first collect all the evtchnfd objects
+	 * in an array as they are removed from evtchn_ports.
+	 */
+	idr_for_each_entry(&kvm->arch.xen.evtchn_ports, evtchnfd, i)
+		n++;
+
+	all_evtchnfds = kmalloc_array(n, sizeof(struct evtchnfd *), GFP_KERNEL);
+	if (!all_evtchnfds) {
+		mutex_unlock(&kvm->lock);
+		return -ENOMEM;
+	}
+
+	n = 0;
 	idr_for_each_entry(&kvm->arch.xen.evtchn_ports, evtchnfd, i) {
+		all_evtchnfds[n++] = evtchnfd;
 		idr_remove(&kvm->arch.xen.evtchn_ports, evtchnfd->send_port);
-		synchronize_srcu(&kvm->srcu);
+	}
+	mutex_unlock(&kvm->lock);
+
+	synchronize_srcu(&kvm->srcu);
+
+	while (n--) {
+		evtchnfd = all_evtchnfds[n];
 		if (!evtchnfd->deliver.port.port)
 			eventfd_ctx_put(evtchnfd->deliver.eventfd.ctx);
 		kfree(evtchnfd);
 	}
-	mutex_unlock(&kvm->lock);
+	kfree(all_evtchnfds);
 
 	return 0;
 }
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 721f6a693799..dae510c263b4 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -962,6 +962,12 @@ int main(int argc, char *argv[])
 	}
 
  done:
+	struct kvm_xen_hvm_attr evt_reset = {
+		.type = KVM_XEN_ATTR_TYPE_EVTCHN,
+		.u.evtchn.flags = KVM_XEN_EVTCHN_RESET,
+	};
+	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &evt_reset);
+
 	alarm(0);
 	clock_gettime(CLOCK_REALTIME, &max_ts);
 
-- 
2.31.1

