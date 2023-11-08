Return-Path: <kvm+bounces-1167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 990887E5511
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:21:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C99BB1C20DCC
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:21:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1020C15EA8;
	Wed,  8 Nov 2023 11:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="oopPMrgK"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54ACF15E96;
	Wed,  8 Nov 2023 11:21:16 +0000 (UTC)
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBE01BE7;
	Wed,  8 Nov 2023 03:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442476; x=1730978476;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WNkxJnNlKH45HLgy7MuxT0PXy6Pk8Rwqfkx/NFZb78M=;
  b=oopPMrgK3huNH+S58PID/PJGmaZuTodV0aPjByLPAEF84pnf67QPYUyS
   e2U3hibcw/NpOZdGuV6JX4r0FkStxP/wdkDa+cAJsbnsk71MQuiA5Iqhx
   r8+EiaDXiDXcjOWtGkKmnbmHTK7aoGUXnZFEehEMICMccuKFru1ijXDmK
   o=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="618316123"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-b404fda3.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:21:15 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
	by email-inbound-relay-iad-1d-m6i4x-b404fda3.us-east-1.amazon.com (Postfix) with ESMTPS id CC42F80587;
	Wed,  8 Nov 2023 11:21:02 +0000 (UTC)
Received: from EX19MTAEUA002.ant.amazon.com [10.0.17.79:44839]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.22.222:2525] with esmtp (Farcaster)
 id 18ea7cc4-781f-406b-ba74-c06699172525; Wed, 8 Nov 2023 11:21:00 +0000 (UTC)
X-Farcaster-Flow-ID: 18ea7cc4-781f-406b-ba74-c06699172525
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:21:00 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:20:55 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 13/33] KVM: Allow polling vCPUs for events
Date: Wed, 8 Nov 2023 11:17:46 +0000
Message-ID: <20231108111806.92604-14-nsaenz@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231108111806.92604-1-nsaenz@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D040UWA001.ant.amazon.com (10.13.139.22) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

A number of use cases have surfaced where it'd be beneficial to have a
vCPU stop its execution in user-space, as opposed to having it sleep
in-kernel. Be it in order to make better use of the pCPU's time while
the vCPU is halted, or to implement security features like Hyper-V's
VSM.

A problem with this approach is that user-space has no way of knowing
whether the vCPU has pending events (interrupts, timers, etc...), so we
need a new interface to query if they are. poll() turned out to be a
very good fit.

So enable polling vCPUs. The poll() interface considers a vCPU has a
pending event if it didn't enter the guest since being kicked by an
event source (being kicked forces a guest exit). Kicking a vCPU that has
pollers wakes up the polling threads.

NOTES:
 - There is a race between the 'vcpu->kicked' check in the polling
   thread and the vCPU thread re-entering the guest. This hardly affects
   the use-cases stated above, but needs to be fixed.

 - This was tested alongside a WIP Hyper-V Virtual Trust Level
   implementation which makes ample use of the poll() interface.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/kvm/x86.c       |  2 ++
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 30 ++++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 57f9c58e1e32..bf4891bc044e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10788,6 +10788,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		goto cancel_injection;
 	}
 
+	WRITE_ONCE(vcpu->kicked, false);
+
 	if (req_immediate_exit) {
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 		static_call(kvm_x86_request_immediate_exit)(vcpu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 687589ce9f63..71e1e8cf8936 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -336,6 +336,7 @@ struct kvm_vcpu {
 #endif
 	int mode;
 	u64 requests;
+	bool kicked;
 	unsigned long guest_debug;
 
 	struct mutex mutex;
@@ -395,6 +396,7 @@ struct kvm_vcpu {
 	 */
 	struct kvm_memory_slot *last_used_slot;
 	u64 last_used_slot_gen;
+	wait_queue_head_t wqh;
 };
 
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ad9aab898a0c..fde004a0ac46 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -497,12 +497,14 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	kvm_vcpu_set_dy_eligible(vcpu, false);
 	vcpu->preempted = false;
 	vcpu->ready = false;
+	vcpu->kicked = false;
 	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
 	vcpu->last_used_slot = NULL;
 
 	/* Fill the stats id string for the vcpu */
 	snprintf(vcpu->stats_id, sizeof(vcpu->stats_id), "kvm-%d/vcpu-%d",
 		 task_pid_nr(current), id);
+	init_waitqueue_head(&vcpu->wqh);
 }
 
 static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
@@ -3970,6 +3972,10 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 		if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
 			smp_send_reschedule(cpu);
 	}
+
+	if (!cmpxchg(&vcpu->kicked, false, true))
+		wake_up_interruptible(&vcpu->wqh);
+
 out:
 	put_cpu();
 }
@@ -4174,6 +4180,29 @@ static int kvm_vcpu_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+static __poll_t kvm_vcpu_poll(struct file *file, poll_table *wait)
+{
+	struct kvm_vcpu *vcpu = file->private_data;
+
+	poll_wait(file, &vcpu->wqh, wait);
+
+	/*
+	 * Make sure we read vcpu->kicked after adding the vcpu into
+	 * the waitqueue list. Otherwise we might have the following race:
+	 *
+	 *   READ_ONCE(vcpu->kicked)
+	 *					cmpxchg(&vcpu->kicked, false, true))
+	 *					wake_up_interruptible(&vcpu->wqh)
+	 *   list_add_tail(wait, &vcpu->wqh)
+	 */
+	smp_mb();
+	if (READ_ONCE(vcpu->kicked)) {
+		return EPOLLIN;
+	}
+
+	return 0;
+}
+
 static int kvm_vcpu_release(struct inode *inode, struct file *filp)
 {
 	struct kvm_vcpu *vcpu = filp->private_data;
@@ -4186,6 +4215,7 @@ static const struct file_operations kvm_vcpu_fops = {
 	.release        = kvm_vcpu_release,
 	.unlocked_ioctl = kvm_vcpu_ioctl,
 	.mmap           = kvm_vcpu_mmap,
+	.poll		= kvm_vcpu_poll,
 	.llseek		= noop_llseek,
 	KVM_COMPAT(kvm_vcpu_compat_ioctl),
 };
-- 
2.40.1


