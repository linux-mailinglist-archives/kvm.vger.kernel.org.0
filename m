Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 083661A1B78
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 07:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgDHFHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 01:07:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39354 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727331AbgDHFHq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 01:07:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038531WJ179569;
        Wed, 8 Apr 2020 05:07:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=KVN+YCf5xOl2+mEkv4Kw5562VW/mACAX0RWsY+6VPF0=;
 b=O56kEp6CQgL39BRDHove3tAhSFX2lvkADbjJWBm5rDMDLICBVmPc4d2u9AFCkVA4D9DC
 7KcyKyyjfEqQ3Ed+a+i5xCgUVsR4Rtx0vBZ03hEmvRQgvk+ls6Y9CfLfzTtmBGGeZ4s7
 n4TC4mYp78RaJwzlLr/v/XXYr3IKpqAJbHiaU2pIq0cTPiCU4/wndYJK9TCL1Ql918Ve
 WLq+jXywMB3Za0bcGyXnnv+gtAvoAOR/3xn9qZ1TFwLyJ+N9SLQ9As8kJxdezHkkIEnm
 fNjALKL/oE1JPgg/mXLr5Z/2HjqsZQOhD3HzqnuSrVOkO31+wXlUzlKFbCyLN8KUKaEh 0g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3091mnh1b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:07:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03852gtx148283;
        Wed, 8 Apr 2020 05:05:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3091kgj7pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:32 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03855W7k030624;
        Wed, 8 Apr 2020 05:05:32 GMT
Received: from monad.ca.oracle.com (/10.156.75.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 22:05:31 -0700
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     peterz@infradead.org, hpa@zytor.com, jpoimboe@redhat.com,
        namit@vmware.com, mhiramat@kernel.org, jgross@suse.com,
        bp@alien8.de, vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: [RFC PATCH 24/26] x86/kvm: Support dynamic CPUID hints
Date:   Tue,  7 Apr 2020 22:03:21 -0700
Message-Id: <20200408050323.4237-25-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200408050323.4237-1-ankur.a.arora@oracle.com>
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 impostorscore=0 phishscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080037
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change in the state of a KVM hint like KVM_HINTS_REALTIME can lead
to significant performance impact. Given that the hint might not be
stable across the lifetime of a guest, dynamic hints allow the host
to inform the guest if the hint changes.

Do this via KVM CPUID leaf in %ecx.  If the guest has registered a
callback via MSR_KVM_HINT_VECTOR, the hint change is notified to it by
means of a callback triggered via vcpu ioctl KVM_CALLBACK.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
The callback vector is currently tied in with the hint notification
and can (should) be made more generic such that we could deliver
arbitrary callbacks on it.

One use might be for TSC frequency switching notifications support for
emulated Hyper-V guests.

---
 Documentation/virt/kvm/api.rst       | 17 ++++++++++++
 Documentation/virt/kvm/cpuid.rst     |  9 +++++--
 arch/x86/include/asm/kvm_host.h      |  6 +++++
 arch/x86/include/uapi/asm/kvm_para.h |  2 ++
 arch/x86/kvm/cpuid.c                 |  3 ++-
 arch/x86/kvm/x86.c                   | 39 ++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h             |  4 +++
 7 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index efbbe570aa9b..40a9b22d6979 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4690,6 +4690,17 @@ KVM_PV_VM_VERIFY
   Verify the integrity of the unpacked image. Only if this succeeds,
   KVM is allowed to start protected VCPUs.
 
+4.126 KVM_CALLBACK
+------------------
+
+:Capability: KVM_CAP_CALLBACK
+:Architectures: x86
+:Type: vcpu ioctl
+:Parameters: none
+:Returns: 0 on success, -1 on error
+
+Queues a callback on the guess's vcpu if a callback has been regisered.
+
 
 5. The kvm_run structure
 ========================
@@ -6109,3 +6120,9 @@ KVM can therefore start protected VMs.
 This capability governs the KVM_S390_PV_COMMAND ioctl and the
 KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
 guests when the state change is invalid.
+
+8.24 KVM_CAP_CALLBACK
+
+Architectures: x86_64
+
+This capability indicates that the ioctl KVM_CALLBACK is available.
diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index 01b081f6e7ea..5a997c9e74c0 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -86,6 +86,9 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
                                               before using paravirtualized
                                               sched yield.
 
+KVM_FEATURE_DYNAMIC_HINTS	  14	      guest handles feature hints
+					      changing under it.
+
 KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                               per-cpu warps are expeced in
                                               kvmclock
@@ -93,9 +96,11 @@ KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
 
 ::
 
-      edx = an OR'ed group of (1 << flag)
+      ecx, edx = an OR'ed group of (1 << flag)
 
-Where ``flag`` here is defined as below:
+Where the ``flag`` in ecx is currently applicable hints, and ``flag`` in
+edx is the union of all hints ever provided to the guest, both drawn from
+the set listed below:
 
 ================== ============ =================================
 flag               value        meaning
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 42a2d0d3984a..4f061550274d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -723,6 +723,8 @@ struct kvm_vcpu_arch {
 	bool nmi_injected;    /* Trying to inject an NMI this entry */
 	bool smi_pending;    /* SMI queued after currently running handler */
 
+	bool callback_pending;	/* Callback queued after running handler */
+
 	struct kvm_mtrr mtrr_state;
 	u64 pat;
 
@@ -982,6 +984,10 @@ struct kvm_arch {
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
+
+	struct {
+		u8 vector;
+	} callback;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 2a8e0b6b9805..bf016e232f2f 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -31,6 +31,7 @@
 #define KVM_FEATURE_PV_SEND_IPI	11
 #define KVM_FEATURE_POLL_CONTROL	12
 #define KVM_FEATURE_PV_SCHED_YIELD	13
+#define KVM_FEATURE_DYNAMIC_HINTS	14
 
 #define KVM_HINTS_REALTIME      0
 
@@ -50,6 +51,7 @@
 #define MSR_KVM_STEAL_TIME  0x4b564d03
 #define MSR_KVM_PV_EOI_EN      0x4b564d04
 #define MSR_KVM_POLL_CONTROL	0x4b564d05
+#define MSR_KVM_HINT_VECTOR	0x4b564d06
 
 struct kvm_steal_time {
 	__u64 steal;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 901cd1fdecd9..db6a4c4d9430 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -712,7 +712,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
-			     (1 << KVM_FEATURE_PV_SCHED_YIELD);
+			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
+			     (1 << KVM_FEATURE_DYNAMIC_HINTS);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b8124b562dea..838d033bf5ba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1282,6 +1282,7 @@ static const u32 emulated_msrs_all[] = {
 
 	MSR_K7_HWCR,
 	MSR_KVM_POLL_CONTROL,
+	MSR_KVM_HINT_VECTOR,
 };
 
 static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
@@ -2910,7 +2911,15 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		vcpu->arch.msr_kvm_poll_control = data;
 		break;
+	case MSR_KVM_HINT_VECTOR: {
+		u8 vector = (u8)data;
 
+		if ((u64)data > 0xffUL)
+			return 1;
+
+		vcpu->kvm->arch.callback.vector = vector;
+		break;
+	}
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
@@ -3156,6 +3165,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_KVM_POLL_CONTROL:
 		msr_info->data = vcpu->arch.msr_kvm_poll_control;
 		break;
+	case MSR_KVM_HINT_VECTOR:
+		msr_info->data = vcpu->kvm->arch.callback.vector;
+		break;
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MCG_CAP:
@@ -3373,6 +3385,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_GET_MSR_FEATURES:
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
+	case KVM_CAP_CALLBACK:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -3721,6 +3734,20 @@ static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int kvm_vcpu_ioctl_callback(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Has the guest setup a callback?
+	 */
+	if (vcpu->kvm->arch.callback.vector) {
+		vcpu->arch.callback_pending = true;
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+		return 0;
+	} else {
+		return -EINVAL;
+	}
+}
+
 static int kvm_vcpu_ioctl_nmi(struct kvm_vcpu *vcpu)
 {
 	kvm_inject_nmi(vcpu);
@@ -4611,6 +4638,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_CALLBACK: {
+		r = kvm_vcpu_ioctl_callback(vcpu);
+		break;
+	}
 	default:
 		r = -EINVAL;
 	}
@@ -7737,6 +7768,14 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 		--vcpu->arch.nmi_pending;
 		vcpu->arch.nmi_injected = true;
 		kvm_x86_ops.set_nmi(vcpu);
+	} else if (vcpu->arch.callback_pending) {
+		if (kvm_x86_ops.interrupt_allowed(vcpu)) {
+			vcpu->arch.callback_pending = false;
+			kvm_queue_interrupt(vcpu,
+					    vcpu->kvm->arch.callback.vector,
+					    false);
+			kvm_x86_ops.set_irq(vcpu);
+		}
 	} else if (kvm_cpu_has_injectable_intr(vcpu)) {
 		/*
 		 * Because interrupts can be injected asynchronously, we are
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 428c7dde6b4b..5401c056742c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1017,6 +1017,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_VCPU_RESETS 179
 #define KVM_CAP_S390_PROTECTED 180
 #define KVM_CAP_PPC_SECURE_GUEST 181
+#define KVM_CAP_CALLBACK	182
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1518,6 +1519,9 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_S390_PROTECTED */
 #define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
 
+/* Available with  KVM_CAP_CALLBACK */
+#define KVM_CALLBACK		  _IO(KVMIO,  0xc6)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.20.1

