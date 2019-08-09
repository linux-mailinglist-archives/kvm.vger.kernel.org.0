Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D37387FA6
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437259AbfHIQUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:20:18 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53320 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437092AbfHIQUB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:20:01 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 49B84305D3DC;
        Fri,  9 Aug 2019 19:00:59 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id F37DF305B7A0;
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
Subject: [RFC PATCH v6 20/92] kvm: introspection: add KVMI_GET_VCPU_INFO
Date:   Fri,  9 Aug 2019 18:59:35 +0300
Message-Id: <20190809160047.8319-21-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

For now, this command returns the TSC frequency (in HZ) for the specified
vCPU if available (otherwise it returns zero).

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 29 +++++++++++++++++++++++++++++
 arch/x86/kvm/kvmi.c                | 12 ++++++++++++
 include/uapi/linux/kvmi.h          |  4 ++++
 virt/kvm/kvmi_int.h                |  2 ++
 virt/kvm/kvmi_msg.c                | 14 ++++++++++++++
 5 files changed, 61 insertions(+)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index b29cd1b80b4f..71897338e85a 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -427,6 +427,35 @@ in almost all cases, it must reply with: continue, retry, crash, etc.
 * -KVM_EINVAL - padding is not zero
 * -KVM_EPERM - the access is restricted by the host
 
+7. KVMI_GET_VCPU_INFO
+---------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+	struct kvmi_get_vcpu_info_reply {
+		__u64 tsc_speed;
+	};
+
+Returns the TSC frequency (in HZ) for the specified vCPU if available
+(otherwise it returns zero).
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 9aecca551673..97c72cdc6fb0 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -90,3 +90,15 @@ void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev)
 	ev->arch.mode = kvmi_vcpu_mode(vcpu, &event->sregs);
 	kvmi_get_msrs(vcpu, event);
 }
+
+int kvmi_arch_cmd_get_vcpu_info(struct kvm_vcpu *vcpu,
+				struct kvmi_get_vcpu_info_reply *rpl)
+{
+	if (kvm_has_tsc_control)
+		rpl->tsc_speed = 1000ul * vcpu->arch.virtual_tsc_khz;
+	else
+		rpl->tsc_speed = 0;
+
+	return 0;
+}
+
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index ccf2239b5db4..aa5bc909e278 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -112,6 +112,10 @@ struct kvmi_get_guest_info_reply {
 	__u32 padding[3];
 };
 
+struct kvmi_get_vcpu_info_reply {
+	__u64 tsc_speed;
+};
+
 struct kvmi_control_vm_events {
 	__u16 event_id;
 	__u8 enable;
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index c21f0fd5e16c..7cff91bc1acc 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -139,5 +139,7 @@ int kvmi_add_job(struct kvm_vcpu *vcpu,
 
 /* arch */
 void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev);
+int kvmi_arch_cmd_get_vcpu_info(struct kvm_vcpu *vcpu,
+				struct kvmi_get_vcpu_info_reply *rpl);
 
 #endif
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index 8e8af572a4f4..3372d8c7e74f 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -28,6 +28,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_EVENT]                 = "KVMI_EVENT",
 	[KVMI_EVENT_REPLY]           = "KVMI_EVENT_REPLY",
 	[KVMI_GET_GUEST_INFO]        = "KVMI_GET_GUEST_INFO",
+	[KVMI_GET_VCPU_INFO]         = "KVMI_GET_VCPU_INFO",
 	[KVMI_GET_VERSION]           = "KVMI_GET_VERSION",
 };
 
@@ -390,6 +391,18 @@ static int handle_event_reply(struct kvm_vcpu *vcpu,
 	return expected->error;
 }
 
+static int handle_get_vcpu_info(struct kvm_vcpu *vcpu,
+				const struct kvmi_msg_hdr *msg,
+				const void *req, vcpu_reply_fct reply_cb)
+{
+	struct kvmi_get_vcpu_info_reply rpl;
+
+	memset(&rpl, 0, sizeof(rpl));
+	kvmi_arch_cmd_get_vcpu_info(vcpu, &rpl);
+
+	return reply_cb(vcpu, msg, 0, &rpl, sizeof(rpl));
+}
+
 /*
  * These commands are executed on the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd'
@@ -400,6 +413,7 @@ static int(*const msg_vcpu[])(struct kvm_vcpu *,
 			      const struct kvmi_msg_hdr *, const void *,
 			      vcpu_reply_fct) = {
 	[KVMI_EVENT_REPLY]      = handle_event_reply,
+	[KVMI_GET_VCPU_INFO]    = handle_get_vcpu_info,
 };
 
 static void kvmi_job_vcpu_cmd(struct kvm_vcpu *vcpu, void *_ctx)
