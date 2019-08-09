Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2555387FB0
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437283AbfHIQUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:20:44 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53298 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407411AbfHIQT5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:19:57 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 075DE305D3DA;
        Fri,  9 Aug 2019 19:00:59 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 92936305B7A5;
        Fri,  9 Aug 2019 19:00:58 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>
Subject: [RFC PATCH v6 19/92] kvm: introspection: add KVMI_EVENT_CREATE_VCPU
Date:   Fri,  9 Aug 2019 18:59:34 +0300
Message-Id: <20190809160047.8319-20-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>

This event is sent when a vCPU is ready to be introspected.

Signed-off-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 23 +++++++++++++++
 virt/kvm/kvmi.c                    | 47 ++++++++++++++++++++++++++++++
 virt/kvm/kvmi_int.h                |  1 +
 virt/kvm/kvmi_msg.c                | 12 ++++++++
 4 files changed, 83 insertions(+)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index 28e1a1c80551..b29cd1b80b4f 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -513,3 +513,26 @@ pause/stop/migrate the guest (see **Unhooking**) and the introspection
 has been enabled for this event (see **KVMI_CONTROL_VM_EVENTS**).
 The introspection tool has a chance to unhook and close the KVMI channel
 (signaling that the operation can proceed).
+
+2. KVMI_EVENT_CREATE_VCPU
+-------------------------
+
+:Architectures: all
+:Versions: >= 1
+:Actions: CONTINUE, CRASH
+:Parameters:
+
+::
+
+	struct kvmi_event;
+
+:Returns:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_event_reply;
+
+This event is sent when a new vCPU is created and the introspection has
+been enabled for this event (see *KVMI_CONTROL_VM_EVENTS*).
+
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index 7eda49bf65c4..d0d9adf5b6ed 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -13,6 +13,7 @@
 static struct kmem_cache *msg_cache;
 static struct kmem_cache *job_cache;
 
+static bool kvmi_create_vcpu_event(struct kvm_vcpu *vcpu);
 static void kvmi_abort_events(struct kvm *kvm);
 
 void *kvmi_msg_alloc(void)
@@ -150,6 +151,11 @@ static struct kvmi_job *kvmi_pull_job(struct kvmi_vcpu *ivcpu)
 	return job;
 }
 
+static void kvmi_job_create_vcpu(struct kvm_vcpu *vcpu, void *ctx)
+{
+	kvmi_create_vcpu_event(vcpu);
+}
+
 static bool alloc_ivcpu(struct kvm_vcpu *vcpu)
 {
 	struct kvmi_vcpu *ivcpu;
@@ -245,6 +251,9 @@ int kvmi_vcpu_init(struct kvm_vcpu *vcpu)
 		goto out;
 	}
 
+	if (kvmi_add_job(vcpu, kvmi_job_create_vcpu, NULL, NULL))
+		ret = -ENOMEM;
+
 out:
 	kvmi_put(vcpu->kvm);
 
@@ -330,6 +339,10 @@ int kvmi_hook(struct kvm *kvm, const struct kvm_introspection *qemu)
 			err = -ENOMEM;
 			goto err_alloc;
 		}
+		if (kvmi_add_job(vcpu, kvmi_job_create_vcpu, NULL, NULL)) {
+			err = -ENOMEM;
+			goto err_alloc;
+		}
 	}
 
 	/* interact with other kernel components after structure allocation */
@@ -551,6 +564,40 @@ void kvmi_handle_common_event_actions(struct kvm_vcpu *vcpu, u32 action,
 	}
 }
 
+static bool __kvmi_create_vcpu_event(struct kvm_vcpu *vcpu)
+{
+	u32 action;
+	bool ret = false;
+
+	action = kvmi_msg_send_create_vcpu(vcpu);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		ret = true;
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu, action, "CREATE");
+	}
+
+	return ret;
+}
+
+static bool kvmi_create_vcpu_event(struct kvm_vcpu *vcpu)
+{
+	struct kvmi *ikvm;
+	bool ret = true;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
+		return true;
+
+	if (test_bit(KVMI_EVENT_CREATE_VCPU, ikvm->vm_ev_mask))
+		ret = __kvmi_create_vcpu_event(vcpu);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+
 void kvmi_run_jobs(struct kvm_vcpu *vcpu)
 {
 	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 9750a9b9902b..c21f0fd5e16c 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -123,6 +123,7 @@ bool kvmi_sock_get(struct kvmi *ikvm, int fd);
 void kvmi_sock_shutdown(struct kvmi *ikvm);
 void kvmi_sock_put(struct kvmi *ikvm);
 bool kvmi_msg_process(struct kvmi *ikvm);
+u32 kvmi_msg_send_create_vcpu(struct kvm_vcpu *vcpu);
 int kvmi_msg_send_unhook(struct kvmi *ikvm);
 
 /* kvmi.c */
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index 0c7c1e968007..8e8af572a4f4 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -725,3 +725,15 @@ int kvmi_msg_send_unhook(struct kvmi *ikvm)
 
 	return kvmi_sock_write(ikvm, vec, n, msg_size);
 }
+
+u32 kvmi_msg_send_create_vcpu(struct kvm_vcpu *vcpu)
+{
+	int err, action;
+
+	err = kvmi_send_event(vcpu, KVMI_EVENT_CREATE_VCPU, NULL, 0,
+			      NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
