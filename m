Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 136A987F68
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437081AbfHIQQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:16:26 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52928 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437069AbfHIQPA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:00 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id C6D4A3031EBB;
        Fri,  9 Aug 2019 19:01:24 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 3E940305B7A1;
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
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v6 57/92] kvm: introspection: add KVMI_GET_XSAVE
Date:   Fri,  9 Aug 2019 19:00:12 +0300
Message-Id: <20190809160047.8319-58-alazar@bitdefender.com>
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

This vCPU command is used to get the XSAVE area.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 31 ++++++++++++++++++++++++++++++
 arch/x86/include/uapi/asm/kvmi.h   |  4 ++++
 arch/x86/kvm/kvmi.c                | 21 ++++++++++++++++++++
 arch/x86/kvm/x86.c                 |  4 ++--
 include/linux/kvm_host.h           |  2 ++
 virt/kvm/kvmi_int.h                |  3 +++
 virt/kvm/kvmi_msg.c                | 17 ++++++++++++++++
 7 files changed, 80 insertions(+), 2 deletions(-)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index c41c3edb0134..c43ea1b33a51 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -1081,6 +1081,37 @@ to control events for any other register will fail with -KVM_EINVAL::
 * -KVM_EINVAL - padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+23. KVMI_GET_XSAVE
+------------------
+
+:Architecture: x86
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
+	struct kvmi_get_xsave_reply {
+		__u32 region[0];
+	};
+
+Returns a buffer containing the XSAVE area. Currently, the size of
+``kvm_xsave`` is used, but it could change. The userspace should get
+the buffer size from the message size.
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_ENOMEM - not enough memory to allocate the reply
+
 Events
 ======
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 08af2eccbdfb..a3fcb1ef8404 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -97,4 +97,8 @@ struct kvmi_event_msr_reply {
 	__u64 new_val;
 };
 
+struct kvmi_get_xsave_reply {
+	__u32 region[0];
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index fc6956b50da2..078d714b59d5 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -790,3 +790,24 @@ int kvmi_arch_cmd_control_spp(struct kvmi *ikvm)
 {
 	return kvm_arch_init_spp(ikvm->kvm);
 }
+
+int kvmi_arch_cmd_get_xsave(struct kvm_vcpu *vcpu,
+			    struct kvmi_get_xsave_reply **dest,
+			    size_t *dest_size)
+{
+	struct kvmi_get_xsave_reply *rpl = NULL;
+	size_t rpl_size = sizeof(*rpl) + sizeof(struct kvm_xsave);
+	struct kvm_xsave *area;
+
+	rpl = kvmi_msg_alloc_check(rpl_size);
+	if (!rpl)
+		return -KVM_ENOMEM;
+
+	area = (struct kvm_xsave *) &rpl->region[0];
+	kvm_vcpu_ioctl_x86_get_xsave(vcpu, area);
+
+	*dest = rpl;
+	*dest_size = rpl_size;
+
+	return 0;
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac027471c4f3..05ff23180355 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3745,8 +3745,8 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
 	}
 }
 
-static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
-					 struct kvm_xsave *guest_xsave)
+void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
+				  struct kvm_xsave *guest_xsave)
 {
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		memset(guest_xsave, 0, sizeof(struct kvm_xsave));
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c8eb1a4d997f..3aad3b96107b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -805,6 +805,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg);
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run);
+void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
+				  struct kvm_xsave *guest_xsave);
 
 int kvm_arch_init(void *opaque);
 void kvm_arch_exit(void);
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 640a78b54947..1a705cba4776 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -255,6 +255,9 @@ void kvmi_arch_trap_event(struct kvm_vcpu *vcpu);
 int kvmi_arch_cmd_get_cpuid(struct kvm_vcpu *vcpu,
 			    const struct kvmi_get_cpuid *req,
 			    struct kvmi_get_cpuid_reply *rpl);
+int kvmi_arch_cmd_get_xsave(struct kvm_vcpu *vcpu,
+			    struct kvmi_get_xsave_reply **dest,
+			    size_t *dest_size);
 int kvmi_arch_cmd_get_vcpu_info(struct kvm_vcpu *vcpu,
 				struct kvmi_get_vcpu_info_reply *rpl);
 int kvmi_arch_cmd_inject_exception(struct kvm_vcpu *vcpu, u8 vector,
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index 8a8951f13f8e..6bc18b7973cf 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -38,6 +38,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_GET_REGISTERS]         = "KVMI_GET_REGISTERS",
 	[KVMI_GET_VCPU_INFO]         = "KVMI_GET_VCPU_INFO",
 	[KVMI_GET_VERSION]           = "KVMI_GET_VERSION",
+	[KVMI_GET_XSAVE]             = "KVMI_GET_XSAVE",
 	[KVMI_INJECT_EXCEPTION]      = "KVMI_INJECT_EXCEPTION",
 	[KVMI_PAUSE_VCPU]            = "KVMI_PAUSE_VCPU",
 	[KVMI_READ_PHYSICAL]         = "KVMI_READ_PHYSICAL",
@@ -700,6 +701,21 @@ static int handle_get_cpuid(struct kvm_vcpu *vcpu,
 	return reply_cb(vcpu, msg, ec, &rpl, sizeof(rpl));
 }
 
+static int handle_get_xsave(struct kvm_vcpu *vcpu,
+			    const struct kvmi_msg_hdr *msg, const void *req,
+			    vcpu_reply_fct reply_cb)
+{
+	struct kvmi_get_xsave_reply *rpl = NULL;
+	size_t rpl_size = 0;
+	int err, ec;
+
+	ec = kvmi_arch_cmd_get_xsave(vcpu, &rpl, &rpl_size);
+
+	err = reply_cb(vcpu, msg, ec, rpl, rpl_size);
+	kvmi_msg_free(rpl);
+	return err;
+}
+
 /*
  * These commands are executed on the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd'
@@ -716,6 +732,7 @@ static int(*const msg_vcpu[])(struct kvm_vcpu *,
 	[KVMI_GET_CPUID]        = handle_get_cpuid,
 	[KVMI_GET_REGISTERS]    = handle_get_registers,
 	[KVMI_GET_VCPU_INFO]    = handle_get_vcpu_info,
+	[KVMI_GET_XSAVE]        = handle_get_xsave,
 	[KVMI_INJECT_EXCEPTION] = handle_inject_exception,
 	[KVMI_SET_REGISTERS]    = handle_set_registers,
 };
