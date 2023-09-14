Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C5579FF9B
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237148AbjINJHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237147AbjINJHb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:07:31 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DB61FD8;
        Thu, 14 Sep 2023 02:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=oynQFx0otpLWpBva3wvVisOGWIw7kSbKH068QhWuZHg=; b=0SyaZmIYZEWLIMJhI4fFFRNZwP
        thgb8VZt7BuPHIFH+3CZSAd/SRB1oDDjz+lD1pYbFLhBUzm+MwXm7XtRa1QG9KvvFtLqJfzDkk02q
        Jrsi1U5rfTL+D5URpzu5ZxGQlt4eNYmzI0o0jeqnRwxR4Izz0gDQXZqNui0ieFf8qZPg=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qgi3L-0001kP-Ns; Thu, 14 Sep 2023 08:50:23 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qgi3L-0002T9-GN; Thu, 14 Sep 2023 08:50:23 +0000
From:   Paul Durrant <paul@xen.org>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Subject: [PATCH 6/8] KVM: xen: allow shared_info to be mapped by fixed HVA
Date:   Thu, 14 Sep 2023 08:49:44 +0000
Message-Id: <20230914084946.200043-7-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230914084946.200043-1-paul@xen.org>
References: <20230914084946.200043-1-paul@xen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

The shared_info page is not guest memory as such. It is a dedicated page
allocated by the VMM and overlaid onto guest memory in a GFN chosen by the
guest. The guest may even request that shared_info be moved from one GFN
to another, but the HVA is never going to change. Thus it makes much more
sense to map the shared_info page in kernel once using this fixed HVA.
Hence add a new KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA attribute type for this
purpose and a KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA flag to advertize its
availability.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: x86@kernel.org
---
 arch/x86/kvm/x86.c       |  3 ++-
 arch/x86/kvm/xen.c       | 28 ++++++++++++++++++++++------
 include/uapi/linux/kvm.h |  6 +++++-
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d669a8801265..0df06f47801c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4531,7 +4531,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		    KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL |
 		    KVM_XEN_HVM_CONFIG_SHARED_INFO |
 		    KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL |
-		    KVM_XEN_HVM_CONFIG_EVTCHN_SEND;
+		    KVM_XEN_HVM_CONFIG_EVTCHN_SEND |
+		    KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA;
 		if (sched_info_on())
 			r |= KVM_XEN_HVM_CONFIG_RUNSTATE |
 			     KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 8e6fdcd7bb6e..1abb4547642a 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -34,24 +34,27 @@ static bool kvm_xen_hcall_evtchn_send(struct kvm_vcpu *vcpu, u64 param, u64 *r);
 
 DEFINE_STATIC_KEY_DEFERRED_FALSE(kvm_xen_enabled, HZ);
 
-static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
+static int kvm_xen_shared_info_init(struct kvm *kvm, u64 addr, bool addr_is_gfn)
 {
 	struct gfn_to_pfn_cache *gpc = &kvm->arch.xen.shinfo_cache;
 	struct pvclock_wall_clock *wc;
-	gpa_t gpa = gfn_to_gpa(gfn);
 	u32 *wc_sec_hi;
 	u32 wc_version;
 	u64 wall_nsec;
 	int ret = 0;
 	int idx = srcu_read_lock(&kvm->srcu);
 
-	if (gfn == KVM_XEN_INVALID_GFN) {
+	if ((addr_is_gfn && addr == KVM_XEN_INVALID_GFN) ||
+	    (!addr_is_gfn && addr == 0)) {
 		kvm_gpc_deactivate(gpc);
 		goto out;
 	}
 
 	do {
-		ret = kvm_gpc_activate(gpc, gpa, PAGE_SIZE);
+		if (addr_is_gfn)
+			ret = kvm_gpc_activate(gpc, gfn_to_gpa(addr), PAGE_SIZE);
+		else
+			ret = kvm_gpc_activate_hva(gpc, addr, PAGE_SIZE);
 		if (ret)
 			goto out;
 
@@ -604,7 +607,6 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 {
 	int r = -ENOENT;
 
-
 	switch (data->type) {
 	case KVM_XEN_ATTR_TYPE_LONG_MODE:
 		if (!IS_ENABLED(CONFIG_64BIT) && data->u.long_mode) {
@@ -619,7 +621,13 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 
 	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
 		mutex_lock(&kvm->arch.xen.xen_lock);
-		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn);
+		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn, true);
+		mutex_unlock(&kvm->arch.xen.xen_lock);
+		break;
+
+	case KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA:
+		mutex_lock(&kvm->arch.xen.xen_lock);
+		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.hva, false);
 		mutex_unlock(&kvm->arch.xen.xen_lock);
 		break;
 
@@ -684,6 +692,14 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		r = 0;
 		break;
 
+	case KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA:
+		if (kvm->arch.xen.shinfo_cache.active)
+			data->u.shared_info.hva = kvm_gpc_hva(&kvm->arch.xen.shinfo_cache);
+		else
+			data->u.shared_info.hva = 0;
+		r = 0;
+		break;
+
 	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
 		data->u.vector = kvm->arch.xen.upcall_vector;
 		r = 0;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f089ab290978..d3f371bafad8 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1282,6 +1282,7 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
 #define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
 #define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
+#define KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA	(1 << 7)
 
 struct kvm_xen_hvm_config {
 	__u32 flags;
@@ -1786,9 +1787,10 @@ struct kvm_xen_hvm_attr {
 		__u8 long_mode;
 		__u8 vector;
 		__u8 runstate_update_flag;
-		struct {
+		union {
 			__u64 gfn;
 #define KVM_XEN_INVALID_GFN ((__u64)-1)
+			__u64 hva;
 		} shared_info;
 		struct {
 			__u32 send_port;
@@ -1830,6 +1832,8 @@ struct kvm_xen_hvm_attr {
 #define KVM_XEN_ATTR_TYPE_XEN_VERSION		0x4
 /* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG */
 #define KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG	0x5
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA */
+#define KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA	0x6
 
 /* Per-vCPU Xen attributes */
 #define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
-- 
2.39.2

