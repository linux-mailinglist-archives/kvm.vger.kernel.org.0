Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6964F87FAD
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437151AbfHIQT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:19:59 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53322 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437092AbfHIQT6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:19:58 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 9792F305D3D9;
        Fri,  9 Aug 2019 19:00:58 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 51651305B7A0;
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
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v6 18/92] kvm: introspection: add KVMI_EVENT_UNHOOK
Date:   Fri,  9 Aug 2019 18:59:33 +0300
Message-Id: <20190809160047.8319-19-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In certain situations (when the guest has to be paused, suspended,
migrated, etc.), userspace/QEMU will use the KVM_INTROSPECTION_UNHOOK
ioctl in order to trigger the KVMI_EVENT_UNHOOK. If the event is sent
successfully (the VM has an active introspection channel), userspace
should delay the action (pause/suspend/...) to give the introspection
tool the chance to remove its hooks (eg. breakpoints). Once a timeout
is reached or the introspection tool has closed the socket, QEMU should
continue with the planned action.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 20 ++++++++++++++++++
 virt/kvm/kvmi.c                    | 34 +++++++++++++++++++++++++++++-
 virt/kvm/kvmi_int.h                |  1 +
 virt/kvm/kvmi_msg.c                | 20 ++++++++++++++++++
 4 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index 1ea4be0d5a45..28e1a1c80551 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -493,3 +493,23 @@ Some of the events accept the KVMI_EVENT_ACTION_RETRY action, to continue
 by re-entering the guest.
 
 Specific data can follow these common structures.
+
+1. KVMI_EVENT_UNHOOK
+--------------------
+
+:Architecture: all
+:Versions: >= 1
+:Actions: CONTINUE, CRASH
+:Parameters:
+
+::
+
+	struct kvmi_event;
+
+:Returns: none
+
+This event is sent when the device manager (ie. QEMU) has to
+pause/stop/migrate the guest (see **Unhooking**) and the introspection
+has been enabled for this event (see **KVMI_CONTROL_VM_EVENTS**).
+The introspection tool has a chance to unhook and close the KVMI channel
+(signaling that the operation can proceed).
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index 0d3560b74f2d..7eda49bf65c4 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -644,6 +644,9 @@ int kvmi_cmd_control_vm_events(struct kvmi *ikvm, unsigned int event_id,
 
 static void kvmi_job_abort(struct kvm_vcpu *vcpu, void *ctx)
 {
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+
+	ivcpu->reply_waiting = false;
 }
 
 static void kvmi_abort_events(struct kvm *kvm)
@@ -655,6 +658,34 @@ static void kvmi_abort_events(struct kvm *kvm)
 		kvmi_add_job(vcpu, kvmi_job_abort, NULL, NULL);
 }
 
+static bool __kvmi_unhook_event(struct kvmi *ikvm)
+{
+	int err;
+
+	if (!test_bit(KVMI_EVENT_UNHOOK, ikvm->vm_ev_mask))
+		return false;
+
+	err = kvmi_msg_send_unhook(ikvm);
+
+	return !err;
+}
+
+static bool kvmi_unhook_event(struct kvm *kvm)
+{
+	struct kvmi *ikvm;
+	bool ret = true;
+
+	ikvm = kvmi_get(kvm);
+	if (!ikvm)
+		return false;
+
+	ret = __kvmi_unhook_event(ikvm);
+
+	kvmi_put(kvm);
+
+	return ret;
+}
+
 int kvmi_ioctl_unhook(struct kvm *kvm, bool force_reset)
 {
 	struct kvmi *ikvm;
@@ -664,7 +695,8 @@ int kvmi_ioctl_unhook(struct kvm *kvm, bool force_reset)
 	if (!ikvm)
 		return -EFAULT;
 
-	kvm_info("TODO: %s force_reset %d", __func__, force_reset);
+	if (!force_reset && !kvmi_unhook_event(kvm))
+		err = -ENOENT;
 
 	kvmi_put(kvm);
 
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 70c8ca0343a3..9750a9b9902b 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -123,6 +123,7 @@ bool kvmi_sock_get(struct kvmi *ikvm, int fd);
 void kvmi_sock_shutdown(struct kvmi *ikvm);
 void kvmi_sock_put(struct kvmi *ikvm);
 bool kvmi_msg_process(struct kvmi *ikvm);
+int kvmi_msg_send_unhook(struct kvmi *ikvm);
 
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index 536034e1bea7..0c7c1e968007 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -705,3 +705,23 @@ int kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
 	return err;
 }
 
+int kvmi_msg_send_unhook(struct kvmi *ikvm)
+{
+	struct kvmi_msg_hdr hdr;
+	struct kvmi_event common;
+	struct kvec vec[] = {
+		{.iov_base = &hdr,	.iov_len = sizeof(hdr)	 },
+		{.iov_base = &common,	.iov_len = sizeof(common)},
+	};
+	size_t msg_size = sizeof(hdr) + sizeof(common);
+	size_t n = ARRAY_SIZE(vec);
+
+	memset(&hdr, 0, sizeof(hdr));
+	hdr.id = KVMI_EVENT;
+	hdr.seq = new_seq(ikvm);
+	hdr.size = msg_size - sizeof(hdr);
+
+	kvmi_setup_event_common(&common, KVMI_EVENT_UNHOOK, 0);
+
+	return kvmi_sock_write(ikvm, vec, n, msg_size);
+}
