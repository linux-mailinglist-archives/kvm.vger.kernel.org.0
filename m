Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33BED639A67
	for <lists+kvm@lfdr.de>; Sun, 27 Nov 2022 13:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiK0MW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Nov 2022 07:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiK0MW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Nov 2022 07:22:27 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA19610070
        for <kvm@vger.kernel.org>; Sun, 27 Nov 2022 04:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=xRWuU9HjcMdEzJ74QDdwI4t+wGcQyC4kj4k5xuieNDg=; b=i3dXA0gvyTJ/x/RAZqJmGWDMj5
        NPvg/8+U/sfBy5V9yn8HBwsLiYG6NPu0N99C0JZlco2dh6x17HIH2mmsZlUEIzD0cu84yhlc7SaPE
        uO0JwsTnvc2Y0w1BW3nykMyiBCTqwEe61s/liSNsZwNqtfyfyteRHfAAR1jzxcjAvlNtymOee8N80
        W38MV47Lz7Wpk+7X3WgKvw1xKVe9XaCJ9wAtodSLDuSXoxS4RxhJpC4mEk7CmTHpc8RuuQdV8l0BZ
        hN4hlsUYmsgOXW1596+dvOJ/efVkkkocRbGWJvYOT0cn6tuptnvdr8AWnbQIXl2fTQJfFQI0V87kT
        VEvqnzAQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ozGfm-0059fy-9B; Sun, 27 Nov 2022 12:22:15 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ozGfl-0012dR-Vn; Sun, 27 Nov 2022 12:22:13 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Durrant <paul@xen.org>, Michal Luczaj <mhal@rbox.co>,
        kvm@vger.kernel.org
Subject: [PATCH v1 2/2] KVM: x86/xen: Allow XEN_RUNSTATE_UPDATE flag behaviour to be configured
Date:   Sun, 27 Nov 2022 12:22:10 +0000
Message-Id: <20221127122210.248427-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221127122210.248427-1-dwmw2@infradead.org>
References: <20221127122210.248427-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Closer inspection of the Xen code shows that we aren't supposed to be
using the XEN_RUNSTATE_UPDATE flag unconditionally. It should be
explicitly enabled by guests through the HYPERVISOR_vm_assist hypercall.
If we randomly set the top bit of ->state_entry_time for a guest that
hasn't asked for it and doesn't expect it, that could make the runtimes
fail to add up and confuse the guest. Without the flag it's perfectly
safe for a vCPU to read its own vcpu_runstate_info; just not for one
vCPU to read *another's*.

I briefly pondered adding a word for the whole set of VMASST_TYPE_*
flags but the only one we care about for HVM guests is this, so it
seemed a bit pointless.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst                | 34 +++++++++--
 arch/x86/include/asm/kvm_host.h               |  1 +
 arch/x86/kvm/x86.c                            |  3 +-
 arch/x86/kvm/xen.c                            | 57 ++++++++++++++-----
 include/uapi/linux/kvm.h                      |  4 ++
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 14 +++++
 6 files changed, 93 insertions(+), 20 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index eee9f857a986..615f5b077d39 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5306,6 +5306,7 @@ KVM_PV_DUMP
 	union {
 		__u8 long_mode;
 		__u8 vector;
+		__u8 runstate_update_flag;
 		struct {
 			__u64 gfn;
 		} shared_info;
@@ -5383,6 +5384,14 @@ KVM_XEN_ATTR_TYPE_XEN_VERSION
   event channel delivery, so responding within the kernel without
   exiting to userspace is beneficial.
 
+KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG
+  This attribute is available when the KVM_CAP_XEN_HVM ioctl indicates
+  support for KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG. It enables the
+  XEN_RUNSTATE_UPDATE flag which allows guest vCPUs to safely read
+  other vCPUs' vcpu_runstate_info. Xen guests enable this feature via
+  the VM_ASST_TYPE_runstate_update_flag of the HYPERVISOR_vm_assist
+  hypercall.
+
 4.127 KVM_XEN_HVM_GET_ATTR
 --------------------------
 
@@ -8026,12 +8035,13 @@ to userspace.
 This capability indicates the features that Xen supports for hosting Xen
 PVHVM guests. Valid flags are::
 
-  #define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
-  #define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
-  #define KVM_XEN_HVM_CONFIG_SHARED_INFO	(1 << 2)
-  #define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
-  #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
-  #define KVM_XEN_HVM_CONFIG_EVTCHN_SEND	(1 << 5)
+  #define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR		(1 << 0)
+  #define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL		(1 << 1)
+  #define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
+  #define KVM_XEN_HVM_CONFIG_RUNSTATE			(1 << 3)
+  #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL		(1 << 4)
+  #define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
+  #define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
 
 The KVM_XEN_HVM_CONFIG_HYPERCALL_MSR flag indicates that the KVM_XEN_HVM_CONFIG
 ioctl is available, for the guest to set its hypercall page.
@@ -8063,6 +8073,18 @@ KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID/TIMER/UPCALL_VECTOR vCPU attributes.
 related to event channel delivery, timers, and the XENVER_version
 interception.
 
+The KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG flag indicates that KVM supports
+the KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG attribute in the KVM_XEN_SET_ATTR
+and KVM_XEN_GET_ATTR ioctls. This controls whether KVM will set the
+XEN_RUNSTATE_UPDATE flag in guest memory mapped vcpu_runstate_info during
+updates of the runstate information. Note that versions of KVM which support
+the RUNSTATE feature above, but not thie RUNSTATE_UPDATE_FLAG feature, will
+always set the XEN_RUNSTATE_UPDATE flag when updating the guest structure,
+which is perhaps counterintuitive. When this flag is advertised, KVM will
+behave more correctly, not using the XEN_RUNSTATE_UPDATE flag until/unless
+specifically enabled (by the guest making the hypercall, causing the VMM
+to enable the KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG attribute).
+
 8.31 KVM_CAP_PPC_MULTITCE
 -------------------------
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 70af7240a1d5..283cbb83d6ae 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1113,6 +1113,7 @@ struct msr_bitmap_range {
 struct kvm_xen {
 	u32 xen_version;
 	bool long_mode;
+	bool runstate_update_flag;
 	u8 upcall_vector;
 	struct gfn_to_pfn_cache shinfo_cache;
 	struct idr evtchn_ports;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f18f579ebde8..246bdc9a9154 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4431,7 +4431,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		    KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL |
 		    KVM_XEN_HVM_CONFIG_EVTCHN_SEND;
 		if (sched_info_on())
-			r |= KVM_XEN_HVM_CONFIG_RUNSTATE;
+			r |= KVM_XEN_HVM_CONFIG_RUNSTATE |
+			     KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG;
 		break;
 #endif
 	case KVM_CAP_SYNC_REGS:
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index d1a506986a32..9187d024d006 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -179,7 +179,8 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 	struct vcpu_runstate_info rs;
 	unsigned long flags;
 	size_t times_ofs;
-	uint8_t *update_bit;
+	uint8_t *update_bit = NULL;
+	uint64_t entry_time;
 	uint64_t *rs_times;
 	int *rs_state;
 
@@ -297,7 +298,8 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 		 */
 		rs_state = gpc1->khva;
 		rs_times = gpc1->khva + times_ofs;
-		update_bit = ((void *)(&rs_times[1])) - 1;
+		if (v->kvm->arch.xen.runstate_update_flag)
+			update_bit = ((void *)(&rs_times[1])) - 1;
 	} else {
 		/*
 		 * The guest's runstate_info is split across two pages and we
@@ -351,12 +353,14 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 		 * The update_bit is still directly in the guest memory,
 		 * via one GPC or the other.
 		 */
-		if (user_len1 >= times_ofs + sizeof(uint64_t))
-			update_bit = gpc1->khva + times_ofs +
-				sizeof(uint64_t) - 1;
-		else
-			update_bit = gpc2->khva + times_ofs +
-				sizeof(uint64_t) - 1 - user_len1;
+		if (v->kvm->arch.xen.runstate_update_flag) {
+			if (user_len1 >= times_ofs + sizeof(uint64_t))
+				update_bit = gpc1->khva + times_ofs +
+					sizeof(uint64_t) - 1;
+			else
+				update_bit = gpc2->khva + times_ofs +
+					sizeof(uint64_t) - 1 - user_len1;
+		}
 
 #ifdef CONFIG_X86_64
 		/*
@@ -376,8 +380,12 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 	 * different cache line to the rest of the 64-bit word, due to
 	 * the (lack of) alignment constraints.
 	 */
-	*update_bit = (vx->runstate_entry_time | XEN_RUNSTATE_UPDATE) >> 56;
-	smp_wmb();
+	entry_time = vx->runstate_entry_time;
+	if (update_bit) {
+		entry_time |= XEN_RUNSTATE_UPDATE;
+		*update_bit = (vx->runstate_entry_time | XEN_RUNSTATE_UPDATE) >> 56;
+		smp_wmb();
+	}
 
 	/*
 	 * Now assemble the actual structure, either on our kernel stack
@@ -385,7 +393,7 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 	 * rs_times pointers were set up above.
 	 */
 	*rs_state = vx->current_runstate;
-	rs_times[0] = vx->runstate_entry_time | XEN_RUNSTATE_UPDATE;
+	rs_times[0] = entry_time;
 	memcpy(rs_times + 1, vx->runstate_times, sizeof(vx->runstate_times));
 
 	/* For the split case, we have to then copy it to the guest. */
@@ -396,8 +404,11 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 	smp_wmb();
 
 	/* Finally, clear the XEN_RUNSTATE_UPDATE bit. */
-	*update_bit = vx->runstate_entry_time >> 56;
-	smp_wmb();
+	if (update_bit) {
+		entry_time &= ~XEN_RUNSTATE_UPDATE;
+		*update_bit = entry_time >> 56;
+		smp_wmb();
+	}
 
 	if (user_len2)
 		read_unlock(&gpc2->lock);
@@ -619,6 +630,17 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		r = 0;
 		break;
 
+	case KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG:
+		if (!sched_info_on()) {
+			r = -EOPNOTSUPP;
+			break;
+		}
+		mutex_lock(&kvm->lock);
+		kvm->arch.xen.runstate_update_flag = !!data->u.runstate_update_flag;
+		mutex_unlock(&kvm->lock);
+		r = 0;
+		break;
+
 	default:
 		break;
 	}
@@ -656,6 +678,15 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		r = 0;
 		break;
 
+	case KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG:
+		if (!sched_info_on()) {
+			r = -EOPNOTSUPP;
+			break;
+		}
+		data->u.runstate_update_flag = kvm->arch.xen.runstate_update_flag;
+		r = 0;
+		break;
+
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7fea12369245..c962b8e426c1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1270,6 +1270,7 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
 #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
 #define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
+#define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
 
 struct kvm_xen_hvm_config {
 	__u32 flags;
@@ -1773,6 +1774,7 @@ struct kvm_xen_hvm_attr {
 	union {
 		__u8 long_mode;
 		__u8 vector;
+		__u8 runstate_update_flag;
 		struct {
 			__u64 gfn;
 		} shared_info;
@@ -1813,6 +1815,8 @@ struct kvm_xen_hvm_attr {
 /* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
 #define KVM_XEN_ATTR_TYPE_EVTCHN		0x3
 #define KVM_XEN_ATTR_TYPE_XEN_VERSION		0x4
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG */
+#define KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG	0x5
 
 /* Per-vCPU Xen attributes */
 #define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 1f4fd97db959..721f6a693799 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -446,6 +446,7 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(xen_caps & KVM_XEN_HVM_CONFIG_SHARED_INFO);
 
 	bool do_runstate_tests = !!(xen_caps & KVM_XEN_HVM_CONFIG_RUNSTATE);
+	bool do_runstate_flag = !!(xen_caps & KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG);
 	bool do_eventfd_tests = !!(xen_caps & KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL);
 	bool do_evtchn_tests = do_eventfd_tests && !!(xen_caps & KVM_XEN_HVM_CONFIG_EVTCHN_SEND);
 
@@ -481,6 +482,19 @@ int main(int argc, char *argv[])
 	};
 	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &lm);
 
+	if (do_runstate_flag) {
+		struct kvm_xen_hvm_attr ruf = {
+			.type = KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG,
+			.u.runstate_update_flag = 1,
+		};
+		vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &ruf);
+
+		ruf.u.runstate_update_flag = 0;
+		vm_ioctl(vm, KVM_XEN_HVM_GET_ATTR, &ruf);
+		TEST_ASSERT(ruf.u.runstate_update_flag == 1,
+			    "Failed to read back RUNSTATE_UPDATE_FLAG attr");
+	}
+
 	struct kvm_xen_hvm_attr ha = {
 		.type = KVM_XEN_ATTR_TYPE_SHARED_INFO,
 		.u.shared_info.gfn = SHINFO_REGION_GPA / PAGE_SIZE,
-- 
2.35.3

