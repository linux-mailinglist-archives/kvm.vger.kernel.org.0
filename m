Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EABB787FAF
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437133AbfHIQT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:19:57 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53302 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407415AbfHIQTz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:19:55 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 57BB6305D3D8;
        Fri,  9 Aug 2019 19:00:58 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 1301E305B7A4;
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
Subject: [RFC PATCH v6 17/92] kvm: introspection: introduce event actions
Date:   Fri,  9 Aug 2019 18:59:32 +0300
Message-Id: <20190809160047.8319-18-alazar@bitdefender.com>
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

All vCPU event replies contains the action requested by the introspection
tool, which can be one of the following:

  * KVMI_EVENT_ACTION_CONTINUE
  * KVMI_EVENT_ACTION_RETRY
  * KVMI_EVENT_ACTION_CRASH

The CONTINUE action can be seen as "continue with the old KVM code
path", while the RETRY action as "re-enter guest".

Note: KVMI_EVENT_UNHOOK, a VM event, doesn't have/need a reply.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 10 ++++++++
 include/uapi/linux/kvmi.h          |  4 +++
 kernel/signal.c                    |  1 +
 virt/kvm/kvmi.c                    | 40 ++++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index e7d9a3816e00..1ea4be0d5a45 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -482,4 +482,14 @@ with two common structures::
 		__u32 padding2;
 	};
 
+All events accept the KVMI_EVENT_ACTION_CRASH action, which stops the
+guest ungracefully but as soon as possible.
+
+Most of the events accept the KVMI_EVENT_ACTION_CONTINUE action, which
+lets the instruction that caused the event to continue (unless specified
+otherwise).
+
+Some of the events accept the KVMI_EVENT_ACTION_RETRY action, to continue
+by re-entering the guest.
+
 Specific data can follow these common structures.
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index dda2ae352611..ccf2239b5db4 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -66,6 +66,10 @@ enum {
 	KVMI_NUM_EVENTS
 };
 
+#define KVMI_EVENT_ACTION_CONTINUE      0
+#define KVMI_EVENT_ACTION_RETRY         1
+#define KVMI_EVENT_ACTION_CRASH         2
+
 #define KVMI_MSG_SIZE (4096 - sizeof(struct kvmi_msg_hdr))
 
 struct kvmi_msg_hdr {
diff --git a/kernel/signal.c b/kernel/signal.c
index 57b7771e20d7..9befbfaaa710 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1413,6 +1413,7 @@ int kill_pid_info(int sig, struct kernel_siginfo *info, struct pid *pid)
 		 */
 	}
 }
+EXPORT_SYMBOL(kill_pid_info);
 
 static int kill_proc_info(int sig, struct kernel_siginfo *info, pid_t pid)
 {
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index 3cc7bb035796..0d3560b74f2d 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -511,6 +511,46 @@ void kvmi_destroy_vm(struct kvm *kvm)
 	wait_for_completion_killable(&kvm->kvmi_completed);
 }
 
+static int kvmi_vcpu_kill(int sig, struct kvm_vcpu *vcpu)
+{
+	int err = -ESRCH;
+	struct pid *pid;
+	struct kernel_siginfo siginfo[1] = {};
+
+	rcu_read_lock();
+	pid = rcu_dereference(vcpu->pid);
+	if (pid)
+		err = kill_pid_info(sig, siginfo, pid);
+	rcu_read_unlock();
+
+	return err;
+}
+
+static void kvmi_vm_shutdown(struct kvm *kvm)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvmi_vcpu_kill(SIGTERM, vcpu);
+}
+
+void kvmi_handle_common_event_actions(struct kvm_vcpu *vcpu, u32 action,
+				      const char *str)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	switch (action) {
+	case KVMI_EVENT_ACTION_CRASH:
+		kvmi_vm_shutdown(kvm);
+		break;
+
+	default:
+		kvmi_err(IKVM(kvm), "Unsupported action %d for event %s\n",
+			 action, str);
+	}
+}
+
 void kvmi_run_jobs(struct kvm_vcpu *vcpu)
 {
 	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
