Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8701387F2D
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437158AbfHIQPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:06 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52920 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437083AbfHIQPD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:03 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 3017E3031EBD;
        Fri,  9 Aug 2019 19:01:25 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id C3273305B7A0;
        Fri,  9 Aug 2019 19:01:24 +0300 (EEST)
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
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>
Subject: [RFC PATCH v6 58/92] kvm: introspection: add KVMI_GET_MTRR_TYPE
Date:   Fri,  9 Aug 2019 19:00:13 +0300
Message-Id: <20190809160047.8319-59-alazar@bitdefender.com>
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

This command returns the memory type for a guest physical address.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 32 ++++++++++++++++++++++++++++++
 arch/x86/include/uapi/asm/kvmi.h   |  9 +++++++++
 arch/x86/kvm/kvmi.c                |  7 +++++++
 virt/kvm/kvmi_int.h                |  1 +
 virt/kvm/kvmi_msg.c                | 17 ++++++++++++++++
 5 files changed, 66 insertions(+)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index c43ea1b33a51..e58f0e22f188 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -1112,6 +1112,38 @@ the buffer size from the message size.
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_ENOMEM - not enough memory to allocate the reply
 
+24. KVMI_GET_MTRR_TYPE
+----------------------
+
+:Architecture: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_get_mtrr_type {
+		__u64 gpa;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+	struct kvmi_get_mtrr_type_reply {
+		__u8 type;
+		__u8 padding[7];
+	};
+
+Returns the guest memory type for a specific physical address.
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index a3fcb1ef8404..c3c96e6e2a26 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -101,4 +101,13 @@ struct kvmi_get_xsave_reply {
 	__u32 region[0];
 };
 
+struct kvmi_get_mtrr_type {
+	__u64 gpa;
+};
+
+struct kvmi_get_mtrr_type_reply {
+	__u8 type;
+	__u8 padding[7];
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 078d714b59d5..0114ed66f4f3 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -811,3 +811,10 @@ int kvmi_arch_cmd_get_xsave(struct kvm_vcpu *vcpu,
 
 	return 0;
 }
+
+int kvmi_arch_cmd_get_mtrr_type(struct kvm_vcpu *vcpu, u64 gpa, u8 *type)
+{
+	*type = kvm_mtrr_get_guest_memory_type(vcpu, gpa_to_gfn(gpa));
+
+	return 0;
+}
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 1a705cba4776..ac2e13787f01 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -267,5 +267,6 @@ int kvmi_arch_cmd_control_cr(struct kvm_vcpu *vcpu,
 			     const struct kvmi_control_cr *req);
 int kvmi_arch_cmd_control_msr(struct kvm_vcpu *vcpu,
 			      const struct kvmi_control_msr *req);
+int kvmi_arch_cmd_get_mtrr_type(struct kvm_vcpu *vcpu, u64 gpa, u8 *type);
 
 #endif
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index 6bc18b7973cf..ee54d92b07ec 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -33,6 +33,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_EVENT_REPLY]           = "KVMI_EVENT_REPLY",
 	[KVMI_GET_CPUID]             = "KVMI_GET_CPUID",
 	[KVMI_GET_GUEST_INFO]        = "KVMI_GET_GUEST_INFO",
+	[KVMI_GET_MTRR_TYPE]         = "KVMI_GET_MTRR_TYPE",
 	[KVMI_GET_PAGE_ACCESS]       = "KVMI_GET_PAGE_ACCESS",
 	[KVMI_GET_PAGE_WRITE_BITMAP] = "KVMI_GET_PAGE_WRITE_BITMAP",
 	[KVMI_GET_REGISTERS]         = "KVMI_GET_REGISTERS",
@@ -701,6 +702,21 @@ static int handle_get_cpuid(struct kvm_vcpu *vcpu,
 	return reply_cb(vcpu, msg, ec, &rpl, sizeof(rpl));
 }
 
+static int handle_get_mtrr_type(struct kvm_vcpu *vcpu,
+				const struct kvmi_msg_hdr *msg,
+				const void *_req, vcpu_reply_fct reply_cb)
+{
+	const struct kvmi_get_mtrr_type *req = _req;
+	struct kvmi_get_mtrr_type_reply rpl;
+	int ec;
+
+	memset(&rpl, 0, sizeof(rpl));
+
+	ec = kvmi_arch_cmd_get_mtrr_type(vcpu, req->gpa, &rpl.type);
+
+	return reply_cb(vcpu, msg, ec, &rpl, sizeof(rpl));
+}
+
 static int handle_get_xsave(struct kvm_vcpu *vcpu,
 			    const struct kvmi_msg_hdr *msg, const void *req,
 			    vcpu_reply_fct reply_cb)
@@ -730,6 +746,7 @@ static int(*const msg_vcpu[])(struct kvm_vcpu *,
 	[KVMI_CONTROL_MSR]      = handle_control_msr,
 	[KVMI_EVENT_REPLY]      = handle_event_reply,
 	[KVMI_GET_CPUID]        = handle_get_cpuid,
+	[KVMI_GET_MTRR_TYPE]    = handle_get_mtrr_type,
 	[KVMI_GET_REGISTERS]    = handle_get_registers,
 	[KVMI_GET_VCPU_INFO]    = handle_get_vcpu_info,
 	[KVMI_GET_XSAVE]        = handle_get_xsave,
