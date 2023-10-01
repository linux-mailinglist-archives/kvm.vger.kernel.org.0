Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1DDC7B471C
	for <lists+kvm@lfdr.de>; Sun,  1 Oct 2023 13:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbjJALOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Oct 2023 07:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234821AbjJALOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Oct 2023 07:14:35 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD17BD;
        Sun,  1 Oct 2023 04:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1696158872; x=1727694872;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TFqLWSi2kvc1KkCpAitsL5k7oqgjxh0FilpQa9ZpfGA=;
  b=vwY+LNHpuHK2b9Sg7wCv1hRVCAs7fgsEu7E0IFwzQ7POd0h+g+N3mChl
   vw1r8oX/BZGqbpDl+hURJqVa7SPwtYhZez4jiUHrhPRfDlkpTmN8ra0wm
   EqnRvB6aNIGJIhxC/GkBKTv1QabUV/V7fpHNW78PNFDfKDTFFNG/J5njJ
   Q=;
X-IronPort-AV: E=Sophos;i="6.03,191,1694736000"; 
   d="scan'208";a="306768347"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2023 11:14:26 +0000
Received: from EX19D004EUC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com (Postfix) with ESMTPS id A0B7CC15A6;
        Sun,  1 Oct 2023 11:14:23 +0000 (UTC)
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Sun, 1 Oct 2023 11:14:19 +0000
From:   Nicolas Saenz Julienne <nsaenz@amazon.com>
To:     <kvm@vger.kernel.org>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>,
        <linux-kernel@vger.kernel.org>, <graf@amazon.de>,
        <dwmw2@infradead.org>, <fgriffo@amazon.com>, <anelkz@amazon.de>,
        <peterz@infradead.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC] KVM: Allow polling vCPUs for events
Date:   Sun, 1 Oct 2023 11:13:14 +0000
Message-ID: <20231001111313.77586-1-nsaenz@amazon.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D039UWB002.ant.amazon.com (10.13.138.79) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a follow up RFC to David Woodhouse's proposal[1] to allow
user-space exits on halt/mwait.

A number of use cases have surfaced where it'd be beneficial to have a
vCPU stop its execution in user-space, as opposed to having it sleep
in-kernel. Be it in order to make better use of the pCPU's time while
the vCPU is halted, or to implement security features like Hyper-V's
VSM.

A problem with this approach is that user-space has no way of knowing
whether the vCPU has pending events (interrupts, timers, etc...), so we
need a new interface to query if they are. poll() turned out to be a
very good fit.

vCPUs being polled are now switched into a new mode, POLLING_FOR_EVENTS.
This mode behaves similar to how OUTSIDE_GUEST_MODE does, except in
kvm_vcpu_kick(), which now wakes up the polling vCPU thread to signal
attention is needed. On wake up the polling thread checks if the pending
requests are relevant for the vCPU (the vCPU might be halted, or it
might be a quiesced VTL vCPU, with different wakeup needs), and if so,
exits back to user-space.

This vCPU mode switch also serves as a synchronization point vs
asynchronous sources of interruptions and it's a benefit versus other
approaches to this problem (for ex. using ioeventfd), which requires
extra synchronization to be viable.

Ultimately, it's up to the code triggering the user-space exit to set
the poll request mask. This allows different exits reasons to be woken
up by different type of events. The request mask is reset upon
re-entering KVM_RUN.

This was tested alongside a Hyper-V VSM PoC that implements Virtual
Trust Level (VTL) handling in user-space by using a distinct vCPU per
VTL. Hence the out-of-tree code in 'hyperv.c'. Note that our approach
requires HVCALL_VTL_RETURN to quiesce the vCPU in user-space, until a
HVCALL_VTL_CALL is performed from a lower VTL, or an interrupt is
targeted at that VTL.

[1] https://lore.kernel.org/lkml/1b52b557beb6606007f7ec5672eab0adf1606a34.camel@infradead.org/

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/kvm/hyperv.c    |  5 +++++
 include/linux/kvm_host.h |  3 +++
 virt/kvm/kvm_main.c      | 43 +++++++++++++++++++++++++++++++++++++++-
 3 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 9436dca9903b..7c12d44486e1 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -63,6 +63,10 @@
  */
 #define HV_EXT_CALL_MAX (HV_EXT_CALL_QUERY_CAPABILITIES + 64)
 
+#define HV_VTL_RETURN_POLL_MASK                                 \
+	(BIT_ULL(KVM_REQ_UNBLOCK) | BIT_ULL(KVM_REQ_HV_STIMER) | \
+		BIT_ULL(KVM_REQ_EVENT))
+
 void kvm_tdp_mmu_role_set_hv_bits(struct kvm_vcpu *vcpu, union kvm_mmu_page_role *role)
 {
 	//role->vtl = to_kvm_hv(vcpu->kvm)->hv_enable_vsm ? get_active_vtl(vcpu) : 0;
@@ -3504,6 +3508,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		goto hypercall_userspace_exit;
 	case HVCALL_VTL_RETURN:
 		vcpu->dump_state_on_run = true;
+		vcpu->poll_mask = HV_VTL_RETURN_POLL_MASK;
 		goto hypercall_userspace_exit;
 	case HVCALL_TRANSLATE_VIRTUAL_ADDRESS:
 		if (unlikely(hc.rep_cnt)) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ed6b2039b599..975186f03c01 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -284,6 +284,7 @@ enum {
 	IN_GUEST_MODE,
 	EXITING_GUEST_MODE,
 	READING_SHADOW_PAGE_TABLES,
+	POLLING_FOR_EVENTS,
 };
 
 #define KVM_UNMAPPED_PAGE	((void *) 0x500 + POISON_POINTER_DELTA)
@@ -341,6 +342,7 @@ struct kvm_vcpu {
 #endif
 	int mode;
 	u64 requests;
+	u64 poll_mask;
 	unsigned long guest_debug;
 
 	struct mutex mutex;
@@ -401,6 +403,7 @@ struct kvm_vcpu {
 	struct kvm_memory_slot *last_used_slot;
 	u64 last_used_slot_gen;
 	bool dump_state_on_run;
+	wait_queue_head_t wqh;
 };
 
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index db106f2e16d8..2985e462ef56 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -238,7 +238,7 @@ static bool kvm_request_needs_ipi(struct kvm_vcpu *vcpu, unsigned req)
 	 * READING_SHADOW_PAGE_TABLES mode.
 	 */
 	if (req & KVM_REQUEST_WAIT)
-		return mode != OUTSIDE_GUEST_MODE;
+		return !(mode == OUTSIDE_GUEST_MODE || mode == POLLING_FOR_EVENTS);
 
 	/*
 	 * Need to kick a running VCPU, but otherwise there is nothing to do.
@@ -479,6 +479,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	snprintf(vcpu->stats_id, sizeof(vcpu->stats_id), "kvm-%d/vcpu-%d",
 		 task_pid_nr(current), id);
 	vcpu->dump_state_on_run = true;
+	init_waitqueue_head(&vcpu->wqh);
 }
 
 static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
@@ -3791,7 +3792,12 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 		cpu = READ_ONCE(vcpu->cpu);
 		if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
 			smp_send_reschedule(cpu);
+		goto out;
 	}
+
+	if (READ_ONCE(vcpu->mode) == POLLING_FOR_EVENTS)
+		wake_up_interruptible(&vcpu->wqh);
+
 out:
 	put_cpu();
 }
@@ -3996,6 +4002,39 @@ static int kvm_vcpu_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+static __poll_t kvm_vcpu_poll(struct file *file, poll_table *wait)
+{
+	struct kvm_vcpu *vcpu = file->private_data;
+
+	if (!vcpu->poll_mask)
+		return EPOLLERR;
+
+	switch (READ_ONCE(vcpu->mode)) {
+	case OUTSIDE_GUEST_MODE:
+		/*
+		 * Make sure writes to vcpu->request are visible before the
+		 * mode changes.
+		 */
+		smp_store_mb(vcpu->mode, POLLING_FOR_EVENTS);
+		break;
+	case POLLING_FOR_EVENTS:
+		break;
+	default:
+		WARN_ONCE(true, "Trying to poll vCPU %d in mode %d\n",
+			  vcpu->vcpu_id, vcpu->mode);
+		return EPOLLERR;
+	}
+
+	poll_wait(file, &vcpu->wqh, wait);
+
+	if (READ_ONCE(vcpu->requests) & vcpu->poll_mask) {
+		WRITE_ONCE(vcpu->mode, OUTSIDE_GUEST_MODE);
+		return EPOLLIN;
+	}
+
+	return 0;
+}
+
 static int kvm_vcpu_release(struct inode *inode, struct file *filp)
 {
 	struct kvm_vcpu *vcpu = filp->private_data;
@@ -4008,6 +4047,7 @@ static const struct file_operations kvm_vcpu_fops = {
 	.release        = kvm_vcpu_release,
 	.unlocked_ioctl = kvm_vcpu_ioctl,
 	.mmap           = kvm_vcpu_mmap,
+	.poll		= kvm_vcpu_poll,
 	.llseek		= noop_llseek,
 	KVM_COMPAT(kvm_vcpu_compat_ioctl),
 };
@@ -4275,6 +4315,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 				synchronize_rcu();
 			put_pid(oldpid);
 		}
+		vcpu->poll_mask = 0;
 		r = kvm_arch_vcpu_ioctl_run(vcpu);
 		trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
 		break;
-- 
2.40.1

