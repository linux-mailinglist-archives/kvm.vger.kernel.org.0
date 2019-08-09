Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3D0687F8F
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437144AbfHIQT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:19:58 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53294 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407405AbfHIQTz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:19:55 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id E7272305D3D4;
        Fri,  9 Aug 2019 19:00:56 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 67D83305B7A0;
        Fri,  9 Aug 2019 19:00:56 +0300 (EEST)
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
Subject: [RFC PATCH v6 13/92] kvm: introspection: make the vCPU wait even when its jobs list is empty
Date:   Fri,  9 Aug 2019 18:59:28 +0300
Message-Id: <20190809160047.8319-14-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Usually, the vCPU thread will run the functions from its jobs list
(unless the thread is SIGKILL-ed) and continue to guest when the
list is empty. But, there are cases when it has to wait for something
(e.g. another vCPU runs in single-step mode, or the current vCPU waits
for an event reply from the introspection tool).

In these cases, it will append a "wait job" into its own list, which
will do (a) nothing if the list is not empty or it doesn't have to wait
any longer or (b) wait (in the same wake-queue used by KVM) until it
is kicked. It should be OK if the receiving worker appends a new job in
the same time.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 include/linux/swait.h | 11 ++++++
 virt/kvm/kvmi.c       | 80 +++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvmi_int.h   |  2 ++
 3 files changed, 93 insertions(+)

diff --git a/include/linux/swait.h b/include/linux/swait.h
index 73e06e9986d4..2486625e7fb4 100644
--- a/include/linux/swait.h
+++ b/include/linux/swait.h
@@ -297,4 +297,15 @@ do {									\
 	__ret;								\
 })
 
+#define __swait_event_killable(wq, condition)				\
+	___swait_event(wq, condition, TASK_KILLABLE, 0,	schedule())	\
+
+#define swait_event_killable(wq, condition)				\
+({									\
+	int __ret = 0;							\
+	if (!(condition))						\
+		__ret = __swait_event_killable(wq, condition);		\
+	__ret;								\
+})
+
 #endif /* _LINUX_SWAIT_H */
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index 07ebd1c629b0..3c884dc0e38c 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -135,6 +135,19 @@ static void kvmi_free_job(struct kvmi_job *job)
 	kmem_cache_free(job_cache, job);
 }
 
+static struct kvmi_job *kvmi_pull_job(struct kvmi_vcpu *ivcpu)
+{
+	struct kvmi_job *job = NULL;
+
+	spin_lock(&ivcpu->job_lock);
+	job = list_first_entry_or_null(&ivcpu->job_list, typeof(*job), link);
+	if (job)
+		list_del(&job->link);
+	spin_unlock(&ivcpu->job_lock);
+
+	return job;
+}
+
 static bool alloc_ivcpu(struct kvm_vcpu *vcpu)
 {
 	struct kvmi_vcpu *ivcpu;
@@ -496,6 +509,73 @@ void kvmi_destroy_vm(struct kvm *kvm)
 	wait_for_completion_killable(&kvm->kvmi_completed);
 }
 
+void kvmi_run_jobs(struct kvm_vcpu *vcpu)
+{
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+	struct kvmi_job *job;
+
+	while ((job = kvmi_pull_job(ivcpu))) {
+		job->fct(vcpu, job->ctx);
+		kvmi_free_job(job);
+	}
+}
+
+static bool done_waiting(struct kvm_vcpu *vcpu)
+{
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+
+	return !list_empty(&ivcpu->job_list);
+}
+
+static void kvmi_job_wait(struct kvm_vcpu *vcpu, void *ctx)
+{
+	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+	int err;
+
+	err = swait_event_killable(*wq, done_waiting(vcpu));
+
+	if (err)
+		ivcpu->killed = true;
+}
+
+int kvmi_run_jobs_and_wait(struct kvm_vcpu *vcpu)
+{
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+	int err = 0;
+
+	for (;;) {
+		kvmi_run_jobs(vcpu);
+
+		if (ivcpu->killed) {
+			err = -1;
+			break;
+		}
+
+		kvmi_add_job(vcpu, kvmi_job_wait, NULL, NULL);
+	}
+
+	return err;
+}
+
+void kvmi_handle_requests(struct kvm_vcpu *vcpu)
+{
+	struct kvmi *ikvm;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
+		return;
+
+	for (;;) {
+		int err = kvmi_run_jobs_and_wait(vcpu);
+
+		if (err)
+			break;
+	}
+
+	kvmi_put(vcpu->kvm);
+}
+
 int kvmi_cmd_control_vm_events(struct kvmi *ikvm, unsigned int event_id,
 			       bool enable)
 {
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 97f91a568096..47418e9a86f6 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -85,6 +85,8 @@ struct kvmi_job {
 struct kvmi_vcpu {
 	struct list_head job_list;
 	spinlock_t job_lock;
+
+	bool killed;
 };
 
 #define IKVM(kvm) ((struct kvmi *)((kvm)->kvmi))
