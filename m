Return-Path: <kvm+bounces-7622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 61146844D11
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 00:39:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA0641F2E0FC
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 23:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5192F47F55;
	Wed, 31 Jan 2024 23:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hikUNflj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB633A8D2
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 23:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706743864; cv=none; b=RQzDxXawm++uQBvW2EkvF+j3XCGWE1NC2BdxVqqBBjXoaTwjkLwrIt0P1wVEKGDp++YUwfqxMXjayyj7t1q/Mqe/LXxVlmEcktlM0biJfi8PboGA1CphP2/EZVxMQcH3o6/vBVUjfsjGTZzluWtjCdEVCV9rSwJX0Dy222a3jwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706743864; c=relaxed/simple;
	bh=JwkID9N79L1QgAokosFeYann5cgipOxatoPfP9nRjrg=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pebc2UDS8VeYXwYiYrfVBl6ZW6yH1AphNdv59ryIsolBLtHkjR0jk2AX1tfAINHMR4NLxruPf3Fpdp20A8Gmsk1Ts3qeOVxIXjopdXlNU/Refn+SKMxCoGYwRKNJxeHS9Is1exIZqAQ6RWxAWAgEI4EG/4qPqwsIHBYRpvPBRRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hikUNflj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706743860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xrDyO5cP2bdZg6q/Bg/JCCUbXYd+dqFsJPPetyNzpWo=;
	b=hikUNfljZco5TQwjJy1ilgoizaBV/NBPVeNKSS1q+scY/l2O5oJX6LtNrs3f8g1HNlD6mF
	hwLtz+1EYIGPQdFVnI0M9VHoHEWguF6JbxgmQufO56Y+1hcdvyFXn/Lko8ACRft8cvklaH
	gx6Btg+QL7vZd660fhvaCimD/ur4obg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-icpNIo6NOFKMdGqm10opUQ-1; Wed, 31 Jan 2024 18:30:57 -0500
X-MC-Unique: icpNIo6NOFKMdGqm10opUQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3F3A800074;
	Wed, 31 Jan 2024 23:30:56 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D6DD6C2590D;
	Wed, 31 Jan 2024 23:30:56 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 2/8] KVM: x86: move x86-specific structs to uapi/asm/kvm.h
Date: Wed, 31 Jan 2024 18:30:50 -0500
Message-Id: <20240131233056.10845-3-pbonzini@redhat.com>
In-Reply-To: <20240131233056.10845-1-pbonzini@redhat.com>
References: <20240131233056.10845-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Several capabilities that exist only on x86 nevertheless have their
structs defined in include/uapi/linux/kvm.h.  Move them to
arch/x86/include/uapi/asm/kvm.h for cleanliness.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/uapi/asm/kvm.h | 262 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h        | 265 --------------------------------
 2 files changed, 262 insertions(+), 265 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index bd36d74b593b..bf68e56fd484 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -531,6 +531,268 @@ struct kvm_pmu_event_filter {
 #define KVM_PMU_EVENT_FLAG_MASKED_EVENTS _BITUL(0)
 #define KVM_PMU_EVENT_FLAGS_VALID_MASK (KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
 
+/* for KVM_CAP_MCE */
+struct kvm_x86_mce {
+	__u64 status;
+	__u64 addr;
+	__u64 misc;
+	__u64 mcg_status;
+	__u8 bank;
+	__u8 pad1[7];
+	__u64 pad2[3];
+};
+
+/* for KVM_CAP_XEN_HVM */
+#define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
+#define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
+#define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
+#define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
+#define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
+#define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
+#define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
+#define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
+
+struct kvm_xen_hvm_config {
+	__u32 flags;
+	__u32 msr;
+	__u64 blob_addr_32;
+	__u64 blob_addr_64;
+	__u8 blob_size_32;
+	__u8 blob_size_64;
+	__u8 pad2[30];
+};
+
+struct kvm_xen_hvm_attr {
+	__u16 type;
+	__u16 pad[3];
+	union {
+		__u8 long_mode;
+		__u8 vector;
+		__u8 runstate_update_flag;
+		struct {
+			__u64 gfn;
+#define KVM_XEN_INVALID_GFN ((__u64)-1)
+		} shared_info;
+		struct {
+			__u32 send_port;
+			__u32 type; /* EVTCHNSTAT_ipi / EVTCHNSTAT_interdomain */
+			__u32 flags;
+#define KVM_XEN_EVTCHN_DEASSIGN		(1 << 0)
+#define KVM_XEN_EVTCHN_UPDATE		(1 << 1)
+#define KVM_XEN_EVTCHN_RESET		(1 << 2)
+			/*
+			 * Events sent by the guest are either looped back to
+			 * the guest itself (potentially on a different port#)
+			 * or signalled via an eventfd.
+			 */
+			union {
+				struct {
+					__u32 port;
+					__u32 vcpu;
+					__u32 priority;
+				} port;
+				struct {
+					__u32 port; /* Zero for eventfd */
+					__s32 fd;
+				} eventfd;
+				__u32 padding[4];
+			} deliver;
+		} evtchn;
+		__u32 xen_version;
+		__u64 pad[8];
+	} u;
+};
+
+
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
+#define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
+#define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
+#define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x2
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
+#define KVM_XEN_ATTR_TYPE_EVTCHN		0x3
+#define KVM_XEN_ATTR_TYPE_XEN_VERSION		0x4
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG */
+#define KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG	0x5
+
+struct kvm_xen_vcpu_attr {
+	__u16 type;
+	__u16 pad[3];
+	union {
+		__u64 gpa;
+#define KVM_XEN_INVALID_GPA ((__u64)-1)
+		__u64 pad[8];
+		struct {
+			__u64 state;
+			__u64 state_entry_time;
+			__u64 time_running;
+			__u64 time_runnable;
+			__u64 time_blocked;
+			__u64 time_offline;
+		} runstate;
+		__u32 vcpu_id;
+		struct {
+			__u32 port;
+			__u32 priority;
+			__u64 expires_ns;
+		} timer;
+		__u8 vector;
+	} u;
+};
+
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO	0x0
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO	0x1
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR	0x2
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT	0x3
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA	0x4
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST	0x5
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID		0x6
+#define KVM_XEN_VCPU_ATTR_TYPE_TIMER		0x7
+#define KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR	0x8
+
+/* Secure Encrypted Virtualization command */
+enum sev_cmd_id {
+	/* Guest initialization commands */
+	KVM_SEV_INIT = 0,
+	KVM_SEV_ES_INIT,
+	/* Guest launch commands */
+	KVM_SEV_LAUNCH_START,
+	KVM_SEV_LAUNCH_UPDATE_DATA,
+	KVM_SEV_LAUNCH_UPDATE_VMSA,
+	KVM_SEV_LAUNCH_SECRET,
+	KVM_SEV_LAUNCH_MEASURE,
+	KVM_SEV_LAUNCH_FINISH,
+	/* Guest migration commands (outgoing) */
+	KVM_SEV_SEND_START,
+	KVM_SEV_SEND_UPDATE_DATA,
+	KVM_SEV_SEND_UPDATE_VMSA,
+	KVM_SEV_SEND_FINISH,
+	/* Guest migration commands (incoming) */
+	KVM_SEV_RECEIVE_START,
+	KVM_SEV_RECEIVE_UPDATE_DATA,
+	KVM_SEV_RECEIVE_UPDATE_VMSA,
+	KVM_SEV_RECEIVE_FINISH,
+	/* Guest status and debug commands */
+	KVM_SEV_GUEST_STATUS,
+	KVM_SEV_DBG_DECRYPT,
+	KVM_SEV_DBG_ENCRYPT,
+	/* Guest certificates commands */
+	KVM_SEV_CERT_EXPORT,
+	/* Attestation report */
+	KVM_SEV_GET_ATTESTATION_REPORT,
+	/* Guest Migration Extension */
+	KVM_SEV_SEND_CANCEL,
+
+	KVM_SEV_NR_MAX,
+};
+
+struct kvm_sev_cmd {
+	__u32 id;
+	__u64 data;
+	__u32 error;
+	__u32 sev_fd;
+};
+
+struct kvm_sev_launch_start {
+	__u32 handle;
+	__u32 policy;
+	__u64 dh_uaddr;
+	__u32 dh_len;
+	__u64 session_uaddr;
+	__u32 session_len;
+};
+
+struct kvm_sev_launch_update_data {
+	__u64 uaddr;
+	__u32 len;
+};
+
+
+struct kvm_sev_launch_secret {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+};
+
+struct kvm_sev_launch_measure {
+	__u64 uaddr;
+	__u32 len;
+};
+
+struct kvm_sev_guest_status {
+	__u32 handle;
+	__u32 policy;
+	__u32 state;
+};
+
+struct kvm_sev_dbg {
+	__u64 src_uaddr;
+	__u64 dst_uaddr;
+	__u32 len;
+};
+
+struct kvm_sev_attestation_report {
+	__u8 mnonce[16];
+	__u64 uaddr;
+	__u32 len;
+};
+
+struct kvm_sev_send_start {
+	__u32 policy;
+	__u64 pdh_cert_uaddr;
+	__u32 pdh_cert_len;
+	__u64 plat_certs_uaddr;
+	__u32 plat_certs_len;
+	__u64 amd_certs_uaddr;
+	__u32 amd_certs_len;
+	__u64 session_uaddr;
+	__u32 session_len;
+};
+
+struct kvm_sev_send_update_data {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+};
+
+struct kvm_sev_receive_start {
+	__u32 handle;
+	__u32 policy;
+	__u64 pdh_uaddr;
+	__u32 pdh_len;
+	__u64 session_uaddr;
+	__u32 session_len;
+};
+
+struct kvm_sev_receive_update_data {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+};
+
+#define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
+#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
+
+struct kvm_hyperv_eventfd {
+	__u32 conn_id;
+	__s32 fd;
+	__u32 flags;
+	__u32 padding[3];
+};
+
+#define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
+#define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
+
 /*
  * Masked event layout.
  * Bits   Description
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e107ea953585..9744e1891c16 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1224,40 +1224,6 @@ struct kvm_irq_routing {
 
 #endif
 
-#ifdef KVM_CAP_MCE
-/* x86 MCE */
-struct kvm_x86_mce {
-	__u64 status;
-	__u64 addr;
-	__u64 misc;
-	__u64 mcg_status;
-	__u8 bank;
-	__u8 pad1[7];
-	__u64 pad2[3];
-};
-#endif
-
-#ifdef KVM_CAP_XEN_HVM
-#define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
-#define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
-#define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
-#define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
-#define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
-#define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
-#define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
-#define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
-
-struct kvm_xen_hvm_config {
-	__u32 flags;
-	__u32 msr;
-	__u64 blob_addr_32;
-	__u64 blob_addr_64;
-	__u8 blob_size_32;
-	__u8 blob_size_64;
-	__u8 pad2[30];
-};
-#endif
-
 #define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
 /*
  * Available with KVM_CAP_IRQFD_RESAMPLE
@@ -1737,58 +1703,6 @@ struct kvm_pv_cmd {
 #define KVM_XEN_HVM_GET_ATTR	_IOWR(KVMIO, 0xc8, struct kvm_xen_hvm_attr)
 #define KVM_XEN_HVM_SET_ATTR	_IOW(KVMIO,  0xc9, struct kvm_xen_hvm_attr)
 
-struct kvm_xen_hvm_attr {
-	__u16 type;
-	__u16 pad[3];
-	union {
-		__u8 long_mode;
-		__u8 vector;
-		__u8 runstate_update_flag;
-		struct {
-			__u64 gfn;
-#define KVM_XEN_INVALID_GFN ((__u64)-1)
-		} shared_info;
-		struct {
-			__u32 send_port;
-			__u32 type; /* EVTCHNSTAT_ipi / EVTCHNSTAT_interdomain */
-			__u32 flags;
-#define KVM_XEN_EVTCHN_DEASSIGN		(1 << 0)
-#define KVM_XEN_EVTCHN_UPDATE		(1 << 1)
-#define KVM_XEN_EVTCHN_RESET		(1 << 2)
-			/*
-			 * Events sent by the guest are either looped back to
-			 * the guest itself (potentially on a different port#)
-			 * or signalled via an eventfd.
-			 */
-			union {
-				struct {
-					__u32 port;
-					__u32 vcpu;
-					__u32 priority;
-				} port;
-				struct {
-					__u32 port; /* Zero for eventfd */
-					__s32 fd;
-				} eventfd;
-				__u32 padding[4];
-			} deliver;
-		} evtchn;
-		__u32 xen_version;
-		__u64 pad[8];
-	} u;
-};
-
-
-/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
-#define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
-#define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
-#define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x2
-/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
-#define KVM_XEN_ATTR_TYPE_EVTCHN		0x3
-#define KVM_XEN_ATTR_TYPE_XEN_VERSION		0x4
-/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG */
-#define KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG	0x5
-
 /* Per-vCPU Xen attributes */
 #define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
 #define KVM_XEN_VCPU_SET_ATTR	_IOW(KVMIO,  0xcb, struct kvm_xen_vcpu_attr)
@@ -1799,175 +1713,6 @@ struct kvm_xen_hvm_attr {
 #define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
 #define KVM_SET_SREGS2             _IOW(KVMIO,  0xcd, struct kvm_sregs2)
 
-struct kvm_xen_vcpu_attr {
-	__u16 type;
-	__u16 pad[3];
-	union {
-		__u64 gpa;
-#define KVM_XEN_INVALID_GPA ((__u64)-1)
-		__u64 pad[8];
-		struct {
-			__u64 state;
-			__u64 state_entry_time;
-			__u64 time_running;
-			__u64 time_runnable;
-			__u64 time_blocked;
-			__u64 time_offline;
-		} runstate;
-		__u32 vcpu_id;
-		struct {
-			__u32 port;
-			__u32 priority;
-			__u64 expires_ns;
-		} timer;
-		__u8 vector;
-	} u;
-};
-
-/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
-#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO	0x0
-#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO	0x1
-#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR	0x2
-#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT	0x3
-#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA	0x4
-#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST	0x5
-/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
-#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID		0x6
-#define KVM_XEN_VCPU_ATTR_TYPE_TIMER		0x7
-#define KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR	0x8
-
-/* Secure Encrypted Virtualization command */
-enum sev_cmd_id {
-	/* Guest initialization commands */
-	KVM_SEV_INIT = 0,
-	KVM_SEV_ES_INIT,
-	/* Guest launch commands */
-	KVM_SEV_LAUNCH_START,
-	KVM_SEV_LAUNCH_UPDATE_DATA,
-	KVM_SEV_LAUNCH_UPDATE_VMSA,
-	KVM_SEV_LAUNCH_SECRET,
-	KVM_SEV_LAUNCH_MEASURE,
-	KVM_SEV_LAUNCH_FINISH,
-	/* Guest migration commands (outgoing) */
-	KVM_SEV_SEND_START,
-	KVM_SEV_SEND_UPDATE_DATA,
-	KVM_SEV_SEND_UPDATE_VMSA,
-	KVM_SEV_SEND_FINISH,
-	/* Guest migration commands (incoming) */
-	KVM_SEV_RECEIVE_START,
-	KVM_SEV_RECEIVE_UPDATE_DATA,
-	KVM_SEV_RECEIVE_UPDATE_VMSA,
-	KVM_SEV_RECEIVE_FINISH,
-	/* Guest status and debug commands */
-	KVM_SEV_GUEST_STATUS,
-	KVM_SEV_DBG_DECRYPT,
-	KVM_SEV_DBG_ENCRYPT,
-	/* Guest certificates commands */
-	KVM_SEV_CERT_EXPORT,
-	/* Attestation report */
-	KVM_SEV_GET_ATTESTATION_REPORT,
-	/* Guest Migration Extension */
-	KVM_SEV_SEND_CANCEL,
-
-	KVM_SEV_NR_MAX,
-};
-
-struct kvm_sev_cmd {
-	__u32 id;
-	__u64 data;
-	__u32 error;
-	__u32 sev_fd;
-};
-
-struct kvm_sev_launch_start {
-	__u32 handle;
-	__u32 policy;
-	__u64 dh_uaddr;
-	__u32 dh_len;
-	__u64 session_uaddr;
-	__u32 session_len;
-};
-
-struct kvm_sev_launch_update_data {
-	__u64 uaddr;
-	__u32 len;
-};
-
-
-struct kvm_sev_launch_secret {
-	__u64 hdr_uaddr;
-	__u32 hdr_len;
-	__u64 guest_uaddr;
-	__u32 guest_len;
-	__u64 trans_uaddr;
-	__u32 trans_len;
-};
-
-struct kvm_sev_launch_measure {
-	__u64 uaddr;
-	__u32 len;
-};
-
-struct kvm_sev_guest_status {
-	__u32 handle;
-	__u32 policy;
-	__u32 state;
-};
-
-struct kvm_sev_dbg {
-	__u64 src_uaddr;
-	__u64 dst_uaddr;
-	__u32 len;
-};
-
-struct kvm_sev_attestation_report {
-	__u8 mnonce[16];
-	__u64 uaddr;
-	__u32 len;
-};
-
-struct kvm_sev_send_start {
-	__u32 policy;
-	__u64 pdh_cert_uaddr;
-	__u32 pdh_cert_len;
-	__u64 plat_certs_uaddr;
-	__u32 plat_certs_len;
-	__u64 amd_certs_uaddr;
-	__u32 amd_certs_len;
-	__u64 session_uaddr;
-	__u32 session_len;
-};
-
-struct kvm_sev_send_update_data {
-	__u64 hdr_uaddr;
-	__u32 hdr_len;
-	__u64 guest_uaddr;
-	__u32 guest_len;
-	__u64 trans_uaddr;
-	__u32 trans_len;
-};
-
-struct kvm_sev_receive_start {
-	__u32 handle;
-	__u32 policy;
-	__u64 pdh_uaddr;
-	__u32 pdh_len;
-	__u64 session_uaddr;
-	__u32 session_len;
-};
-
-struct kvm_sev_receive_update_data {
-	__u64 hdr_uaddr;
-	__u32 hdr_len;
-	__u64 guest_uaddr;
-	__u32 guest_len;
-	__u64 trans_uaddr;
-	__u32 trans_len;
-};
-
-#define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
-#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
-
 /* Available with KVM_CAP_ARM_USER_IRQ */
 
 /* Bits for run->s.regs.device_irq_level */
@@ -1975,16 +1720,6 @@ struct kvm_sev_receive_update_data {
 #define KVM_ARM_DEV_EL1_PTIMER		(1 << 1)
 #define KVM_ARM_DEV_PMU			(1 << 2)
 
-struct kvm_hyperv_eventfd {
-	__u32 conn_id;
-	__s32 fd;
-	__u32 flags;
-	__u32 padding[3];
-};
-
-#define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
-#define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
-
 #define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
 #define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
 
-- 
2.39.0



