Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8CC87F43
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437180AbfHIQPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:33 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53068 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437142AbfHIQPJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:09 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id D9B4C305D350;
        Fri,  9 Aug 2019 19:01:25 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 81218305B7A1;
        Fri,  9 Aug 2019 19:01:25 +0300 (EEST)
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
Subject: [RFC PATCH v6 59/92] kvm: introspection: add KVMI_EVENT_XSETBV
Date:   Fri,  9 Aug 2019 19:00:14 +0300
Message-Id: <20190809160047.8319-60-alazar@bitdefender.com>
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

This event is sent when the extended control register XCR0 is going to
be changed.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 25 +++++++++++++++++++
 arch/x86/include/asm/kvmi_host.h   |  5 ++++
 arch/x86/kvm/kvmi.c                | 39 ++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                 |  5 ++++
 4 files changed, 74 insertions(+)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index e58f0e22f188..1d2431639770 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -1444,3 +1444,28 @@ register (see **KVMI_CONTROL_EVENTS**).
 
 ``kvmi_event``, the MSR number, the old value and the new value are
 sent to the introspector. The *CONTINUE* action will set the ``new_val``.
+
+8. KVMI_EVENT_XSETBV
+--------------------
+
+:Architectures: x86
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
+This event is sent when the extended control register XCR0 is going
+to be changed and the introspection has been enabled for this event
+(see *KVMI_CONTROL_EVENTS*).
+
+``kvmi_event`` is sent to the introspector.
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 86d90b7bed84..3f066e7feee2 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -15,6 +15,7 @@ bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr);
 bool kvmi_monitored_msr(struct kvm_vcpu *vcpu, u32 msr);
 bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 		   unsigned long old_value, unsigned long *new_value);
+void kvmi_xsetbv_event(struct kvm_vcpu *vcpu);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
@@ -35,6 +36,10 @@ static inline bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 	return true;
 }
 
+static inline void kvmi_xsetbv_event(struct kvm_vcpu *vcpu)
+{
+}
+
 #endif /* CONFIG_KVM_INTROSPECTION */
 
 #endif /* _ASM_X86_KVMI_HOST_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 0114ed66f4f3..0e9c91d2f282 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -389,6 +389,45 @@ bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 	return ret;
 }
 
+static u32 kvmi_send_xsetbv(struct kvm_vcpu *vcpu)
+{
+	int err, action;
+
+	err = kvmi_send_event(vcpu, KVMI_EVENT_XSETBV, NULL, 0,
+			      NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
+
+static void __kvmi_xsetbv_event(struct kvm_vcpu *vcpu)
+{
+	u32 action;
+
+	action = kvmi_send_xsetbv(vcpu);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu, action, "XSETBV");
+	}
+}
+
+void kvmi_xsetbv_event(struct kvm_vcpu *vcpu)
+{
+	struct kvmi *ikvm;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
+		return;
+
+	if (is_event_enabled(vcpu, KVMI_EVENT_XSETBV))
+		__kvmi_xsetbv_event(vcpu);
+
+	kvmi_put(vcpu->kvm);
+}
+
 bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			u8 access)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 05ff23180355..278a286ba262 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -868,6 +868,11 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 
 int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 {
+#ifdef CONFIG_KVM_INTROSPECTION
+	if (xcr != vcpu->arch.xcr0)
+		kvmi_xsetbv_event(vcpu);
+#endif /* CONFIG_KVM_INTROSPECTION */
+
 	if (kvm_x86_ops->get_cpl(vcpu) != 0 ||
 	    __kvm_set_xcr(vcpu, index, xcr)) {
 		kvm_inject_gp(vcpu, 0);
