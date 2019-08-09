Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B48C987F29
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437104AbfHIQPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:02 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52908 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437013AbfHIQPB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:01 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 5F04F305D34D;
        Fri,  9 Aug 2019 19:01:21 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 188D8305B7A0;
        Fri,  9 Aug 2019 19:01:21 +0300 (EEST)
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
        Marian Rotariu <marian.c.rotariu@gmail.com>
Subject: [RFC PATCH v6 52/92] kvm: introspection: add KVMI_GET_CPUID
Date:   Fri,  9 Aug 2019 19:00:07 +0300
Message-Id: <20190809160047.8319-53-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marian Rotariu <marian.c.rotariu@gmail.com>

This command returns a CPUID leaf (as seen by the guest OS).

Signed-off-by: Marian Rotariu <marian.c.rotariu@gmail.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 36 ++++++++++++++++++++++++++++++
 arch/x86/include/uapi/asm/kvmi.h   | 12 ++++++++++
 arch/x86/kvm/kvmi.c                | 19 ++++++++++++++++
 include/uapi/linux/kvm_para.h      |  1 +
 virt/kvm/kvmi_int.h                |  3 +++
 virt/kvm/kvmi_msg.c                | 16 +++++++++++++
 6 files changed, 87 insertions(+)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index b6722d071ab7..9e15132ed976 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -933,6 +933,42 @@ currently being handled is replied to.
 * -KVM_EINVAL - padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+19. KVMI_GET_CPUID
+------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_get_cpuid {
+		__u32 function;
+		__u32 index;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+	struct kvmi_get_cpuid_reply {
+		__u32 eax;
+		__u32 ebx;
+		__u32 ecx;
+		__u32 edx;
+	};
+
+Returns a CPUID leaf (as seen by the guest OS).
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_ENOENT - the selected leaf is not present or is invalid
+
 Events
 ======
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 98fb27e1273c..fa2719226198 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -41,4 +41,16 @@ struct kvmi_get_registers_reply {
 	struct kvm_msrs msrs;
 };
 
+struct kvmi_get_cpuid {
+	__u32 function;
+	__u32 index;
+};
+
+struct kvmi_get_cpuid_reply {
+	__u32 eax;
+	__u32 ebx;
+	__u32 ecx;
+	__u32 edx;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index a78771b21d2f..4615bbe9c0db 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2019 Bitdefender S.R.L.
  */
 #include "x86.h"
+#include "cpuid.h"
 #include "../../../virt/kvm/kvmi_int.h"
 
 static void *alloc_get_registers_reply(const struct kvmi_msg_hdr *msg,
@@ -211,6 +212,24 @@ bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 	return ret;
 }
 
+int kvmi_arch_cmd_get_cpuid(struct kvm_vcpu *vcpu,
+			    const struct kvmi_get_cpuid *req,
+			    struct kvmi_get_cpuid_reply *rpl)
+{
+	struct kvm_cpuid_entry2 *e;
+
+	e = kvm_find_cpuid_entry(vcpu, req->function, req->index);
+	if (!e)
+		return -KVM_ENOENT;
+
+	rpl->eax = e->eax;
+	rpl->ebx = e->ebx;
+	rpl->ecx = e->ecx;
+	rpl->edx = e->edx;
+
+	return 0;
+}
+
 int kvmi_arch_cmd_get_vcpu_info(struct kvm_vcpu *vcpu,
 				struct kvmi_get_vcpu_info_reply *rpl)
 {
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 07e3f2662b36..553f168331a4 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -19,6 +19,7 @@
 #define KVM_EOPNOTSUPP		95
 #define KVM_EAGAIN		11
 #define KVM_EBUSY		EBUSY
+#define KVM_ENOENT		ENOENT
 #define KVM_ENOMEM		ENOMEM
 
 #define KVM_HC_VAPIC_POLL_IRQ		1
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 7bc3dd1f2298..22508d147495 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -230,6 +230,9 @@ int kvmi_arch_cmd_set_page_write_bitmap(struct kvmi *ikvm,
 void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev);
 bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			u8 access);
+int kvmi_arch_cmd_get_cpuid(struct kvm_vcpu *vcpu,
+			    const struct kvmi_get_cpuid *req,
+			    struct kvmi_get_cpuid_reply *rpl);
 int kvmi_arch_cmd_get_vcpu_info(struct kvm_vcpu *vcpu,
 				struct kvmi_get_vcpu_info_reply *rpl);
 
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index 355cec70a28d..9548042de618 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -29,6 +29,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_CONTROL_VM_EVENTS]     = "KVMI_CONTROL_VM_EVENTS",
 	[KVMI_EVENT]                 = "KVMI_EVENT",
 	[KVMI_EVENT_REPLY]           = "KVMI_EVENT_REPLY",
+	[KVMI_GET_CPUID]             = "KVMI_GET_CPUID",
 	[KVMI_GET_GUEST_INFO]        = "KVMI_GET_GUEST_INFO",
 	[KVMI_GET_PAGE_ACCESS]       = "KVMI_GET_PAGE_ACCESS",
 	[KVMI_GET_PAGE_WRITE_BITMAP] = "KVMI_GET_PAGE_WRITE_BITMAP",
@@ -641,6 +642,20 @@ static int handle_control_events(struct kvm_vcpu *vcpu,
 	return reply_cb(vcpu, msg, ec, NULL, 0);
 }
 
+static int handle_get_cpuid(struct kvm_vcpu *vcpu,
+			    const struct kvmi_msg_hdr *msg,
+			    const void *req, vcpu_reply_fct reply_cb)
+{
+	struct kvmi_get_cpuid_reply rpl;
+	int ec;
+
+	memset(&rpl, 0, sizeof(rpl));
+
+	ec = kvmi_arch_cmd_get_cpuid(vcpu, req, &rpl);
+
+	return reply_cb(vcpu, msg, ec, &rpl, sizeof(rpl));
+}
+
 /*
  * These commands are executed on the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd'
@@ -652,6 +667,7 @@ static int(*const msg_vcpu[])(struct kvm_vcpu *,
 			      vcpu_reply_fct) = {
 	[KVMI_CONTROL_EVENTS]   = handle_control_events,
 	[KVMI_EVENT_REPLY]      = handle_event_reply,
+	[KVMI_GET_CPUID]        = handle_get_cpuid,
 	[KVMI_GET_REGISTERS]    = handle_get_registers,
 	[KVMI_GET_VCPU_INFO]    = handle_get_vcpu_info,
 	[KVMI_SET_REGISTERS]    = handle_set_registers,
