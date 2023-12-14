Return-Path: <kvm+bounces-4421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3170981257A
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 03:48:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9EF6A1F21C10
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 02:48:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA5BE6122;
	Thu, 14 Dec 2023 02:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="G0av+TRk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D1412F
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 18:47:42 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id d75a77b69052e-425e63955f6so15396551cf.3
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 18:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1702522061; x=1703126861; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/yPwhVHo1DnvaRqBLpgUpHgGMwpWU0ZdsFg9YzpMxKE=;
        b=G0av+TRk7vqrktMbBnEyBeSKHR0i23wA6bmzOG1y5voP8FQm0jAtFvdNFEUHUUrVY8
         bmLY/9fa9YRZG8nCe7sVMAAOW7iakZkuLGgysI7LIQDRmDHv0h3DereWTeSuL8MgFL69
         M4AJyASVVKcRwd4m/+XoLJuSEQ/PYOmZmT+RcbogmQuFhQj7pWMGhxP4/OjpkG7AEKDq
         5MwnCbcHP9DyB2WX7Tdp/s8TYaMUcUArmppqlf40tswIK8CV31zsJIYpM4x+EIR7p36O
         Uq03QIg6d51dmgIGeIcvHHJoUpIdtkddFOc3CjN37YyaNteTvGCsLvbKf49M58z/wbmq
         +20g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702522061; x=1703126861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/yPwhVHo1DnvaRqBLpgUpHgGMwpWU0ZdsFg9YzpMxKE=;
        b=jOb60r1M0IpfRShR6wXiNTHOceZ4zn7Z5unFavgCw3todNQcgVkt84xEET+ETh3/IN
         P1IGpBU76561TBcf6aQG10EPnP+em32XrZVt4TcVtI1YXRXjdPLnBnvBYpDhsPC/RaoP
         a7CaeTJfneq98AaYlJ5DKFyJOUkmchKoEjbw4vjmcMjEt+qqspvwj5tolTZ7Q9ELgKWq
         +fUAxVa+L0mBo7pGX1+YwIFrw4T20DUow9RI5Qa8umO+70qtqBdLVRN/QmQ8gmLBBg3G
         fi03wTU3BxbFax4se75GnLZ1gBNKwQYeHUqX+ydNS81WjQK3qLTD+jsRay8zF9ZCVJAn
         cu7w==
X-Gm-Message-State: AOJu0YwEOsuDgWp1itonu2slO92MCYJ5miChKL8aX/f3sZ2ZPHXooO2G
	gXBKCZSOBTo2VxG3+0DuEDg+Hg==
X-Google-Smtp-Source: AGHT+IF+ZeEjRT/5mEYxEeQ/x6jk/1CzxRDZwt23B9wDPg2/4qz07MH2B4H09rOeeBg0SGLeYN9dFg==
X-Received: by 2002:ac8:59d3:0:b0:425:4043:50eb with SMTP id f19-20020ac859d3000000b00425404350ebmr12277865qtf.122.1702522061663;
        Wed, 13 Dec 2023 18:47:41 -0800 (PST)
Received: from vinp3lin.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id fh3-20020a05622a588300b00425b356b919sm4240208qtb.55.2023.12.13.18.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 18:47:41 -0800 (PST)
From: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To: Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Joel Fernandes <joel@joelfernandes.org>
Subject: [RFC PATCH 6/8] kvm: x86: enable/disable global/per-guest vcpu boost feature
Date: Wed, 13 Dec 2023 21:47:23 -0500
Message-ID: <20231214024727.3503870-7-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231214024727.3503870-1-vineeth@bitbyteword.org>
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement the module parameter for enable/disable of the feature
globally. Also implement the ioctls for enable/disable of the feature
per guest.

TODO: Documentation for the ioctls and kvm module parameters.

Co-developed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
---
 arch/x86/kvm/x86.c       |  8 +++--
 include/linux/kvm_host.h | 34 +++++++++++++++++-
 include/uapi/linux/kvm.h |  5 +++
 virt/kvm/kvm_main.c      | 76 +++++++++++++++++++++++++++++++++++++---
 4 files changed, 116 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8c15c6ff352e..4fb73833fc68 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9949,8 +9949,12 @@ static void record_vcpu_boost_status(struct kvm_vcpu *vcpu)
 
 void kvm_set_vcpu_boosted(struct kvm_vcpu *vcpu, bool boosted)
 {
-	kvm_arch_vcpu_set_boost_status(&vcpu->arch,
-			boosted ? VCPU_BOOST_BOOSTED : VCPU_BOOST_NORMAL);
+	enum kvm_vcpu_boost_state boost_status = VCPU_BOOST_DISABLED;
+
+	if (kvm_pv_sched_enabled(vcpu->kvm))
+		boost_status = boosted ? VCPU_BOOST_BOOSTED : VCPU_BOOST_NORMAL;
+
+	kvm_arch_vcpu_set_boost_status(&vcpu->arch, boost_status);
 
 	kvm_make_request(KVM_REQ_VCPU_BOOST_UPDATE, vcpu);
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f76680fbc60d..07f60a27025c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -807,6 +807,9 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+	bool pv_sched_enabled;
+#endif
 };
 
 #define kvm_err(fmt, ...) \
@@ -2292,9 +2295,38 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
 void kvm_set_vcpu_boosted(struct kvm_vcpu *vcpu, bool boosted);
 int kvm_vcpu_set_sched(struct kvm_vcpu *vcpu, bool boost);
 
+DECLARE_STATIC_KEY_FALSE(kvm_pv_sched);
+
+static inline bool kvm_pv_sched_enabled(struct kvm *kvm)
+{
+	if (static_branch_unlikely(&kvm_pv_sched))
+		return kvm->pv_sched_enabled;
+
+	return false;
+}
+
+static inline void kvm_set_pv_sched_enabled(struct kvm *kvm, bool enabled)
+{
+	unsigned long i;
+	struct kvm_vcpu *vcpu;
+
+	kvm->pv_sched_enabled = enabled;
+	/*
+	 * After setting vcpu_sched_enabled, we need to update each vcpu's
+	 * state(VCPU_BOOST_{DISABLED,NORMAL}) so that guest knows about the
+	 * update.
+	 * When disabling, we would also need to unboost vcpu threads
+	 * if already boosted.
+	 * XXX: this can race, needs locking!
+	 */
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_vcpu_set_sched(vcpu, false);
+}
+
 static inline bool kvm_vcpu_sched_enabled(struct kvm_vcpu *vcpu)
 {
-	return kvm_arch_vcpu_pv_sched_enabled(&vcpu->arch);
+	return kvm_pv_sched_enabled(vcpu->kvm) &&
+		kvm_arch_vcpu_pv_sched_enabled(&vcpu->arch);
 }
 
 static inline void kvm_vcpu_kick_boost(struct kvm_vcpu *vcpu)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f089ab290978..4beaeaa3e78f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1192,6 +1192,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_COUNTER_OFFSET 227
 #define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
 #define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
+#define KVM_CAP_PV_SCHED	600
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -2249,4 +2250,8 @@ struct kvm_s390_zpci_op {
 /* flags for kvm_s390_zpci_op->u.reg_aen.flags */
 #define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
 
+/* Available with KVM_CAP_PV_SCHED */
+#define KVM_SET_PV_SCHED_ENABLED	_IOW(KVMIO, 0xe0, int)
+#define KVM_GET_PV_SCHED_ENABLED	_IOR(KVMIO, 0xe1, int)
+
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0dd8b84ed073..d17cd28d5a92 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -99,6 +99,52 @@ unsigned int halt_poll_ns_shrink;
 module_param(halt_poll_ns_shrink, uint, 0644);
 EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
 
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+__read_mostly DEFINE_STATIC_KEY_FALSE(kvm_pv_sched);
+EXPORT_SYMBOL_GPL(kvm_pv_sched);
+
+static int set_kvm_pv_sched(const char *val, const struct kernel_param *cp)
+{
+	struct kvm *kvm;
+	char *s = strstrip((char *)val);
+	bool new_val, old_val = static_key_enabled(&kvm_pv_sched);
+
+	if (!strcmp(s, "0"))
+		new_val = 0;
+	else if (!strcmp(s, "1"))
+		new_val = 1;
+	else
+		return -EINVAL;
+
+	if (old_val != new_val) {
+		if (new_val)
+			static_branch_enable(&kvm_pv_sched);
+		else
+			static_branch_disable(&kvm_pv_sched);
+
+		mutex_lock(&kvm_lock);
+		list_for_each_entry(kvm, &vm_list, vm_list)
+			kvm_set_pv_sched_enabled(kvm, !old_val);
+		mutex_unlock(&kvm_lock);
+	}
+
+	return 0;
+}
+
+static int get_kvm_pv_sched(char *buf, const struct kernel_param *cp)
+{
+	return sprintf(buf, "%s\n",
+			static_key_enabled(&kvm_pv_sched) ? "1" : "0");
+}
+
+static const struct kernel_param_ops kvm_pv_sched_ops = {
+	.set = set_kvm_pv_sched,
+	.get = get_kvm_pv_sched
+};
+
+module_param_cb(kvm_pv_sched, &kvm_pv_sched_ops, NULL, 0644);
+#endif
+
 /*
  * Ordering of locks:
  *
@@ -1157,6 +1203,9 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
 
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+	kvm->pv_sched_enabled = true;
+#endif
 	/*
 	 * Force subsequent debugfs file creations to fail if the VM directory
 	 * is not created (by kvm_create_vm_debugfs()).
@@ -3635,11 +3684,15 @@ int kvm_vcpu_set_sched(struct kvm_vcpu *vcpu, bool boost)
 	struct task_struct *vcpu_task = NULL;
 
 	/*
-	 * We can ignore the request if a boost request comes
-	 * when we are already boosted or an unboost request
-	 * when we are already unboosted.
+	 * If the feature is disabled and we receive a boost request,
+	 * we can ignore the request and set VCPU_BOOST_DISABLED for the
+	 * guest to see(kvm_set_vcpu_boosted).
+	 * Similarly, we can ignore the request if a boost request comes
+	 * when we are already boosted or an unboost request when we are
+	 * already unboosted.
 	 */
-	if (__can_ignore_set_sched(vcpu, boost))
+	if ((!kvm_vcpu_sched_enabled(vcpu) && boost) ||
+			__can_ignore_set_sched(vcpu, boost))
 		goto set_boost_status;
 
 	if (boost) {
@@ -4591,6 +4644,9 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_CHECK_EXTENSION_VM:
 	case KVM_CAP_ENABLE_CAP_VM:
 	case KVM_CAP_HALT_POLL:
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+	case KVM_CAP_PV_SCHED:
+#endif
 		return 1;
 #ifdef CONFIG_KVM_MMIO
 	case KVM_CAP_COALESCED_MMIO:
@@ -5018,6 +5074,18 @@ static long kvm_vm_ioctl(struct file *filp,
 	case KVM_GET_STATS_FD:
 		r = kvm_vm_ioctl_get_stats_fd(kvm);
 		break;
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+	case KVM_SET_PV_SCHED_ENABLED:
+		r = -EINVAL;
+		if (arg == 0 || arg == 1) {
+			kvm_set_pv_sched_enabled(kvm, arg);
+			r = 0;
+		}
+		break;
+	case KVM_GET_PV_SCHED_ENABLED:
+		r = kvm->pv_sched_enabled;
+		break;
+#endif
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 	}
-- 
2.43.0


