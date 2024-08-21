Return-Path: <kvm+bounces-24730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 57365959FCF
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 16:28:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1CE21F24527
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 14:28:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9D8D1B2EC0;
	Wed, 21 Aug 2024 14:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="WTStECn9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C96C1B1D50
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 14:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724250404; cv=none; b=QxCRew73WhM4ld/zs6IgVpLCNlZBe371XlBXCgMQJn9zXDdmfkwgBieZRCAAWq50rJJKd176HxiGw/ZKKcuiQ6haNLXnj6HZ4kjF4+m1zSLHemUiC4bT4VZ+E+7ephc9cnV2TV/SWb6xVoMZYI3mYpmcdnUeH4KYOqxjFH1EX4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724250404; c=relaxed/simple;
	bh=PWtc5aldsHtv2h7Ede3x534t98EKCHMOqmWv9fq7rK8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=juCqZ9SuWkFBYJh3M6UJdE1AaVfLowJ2qdJMQgp9gW9WKKfoeqC6Mpvqne+8+WafVqJm7DP6QFEHfHhsWI5dj+C2MYsnhWyekzSTQwmqV+gvlW/p5+5JrIwI3Q6ma/iDWSJa3ARLyrWKZW3BI9eZg50TVspPuZJMRSg9Or0ItyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=WTStECn9; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-42817f1eb1fso54868985e9.1
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 07:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1724250401; x=1724855201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pc3oH83451CeWS4VKLJb3/MW3Irx8Ealej33KWVBpwI=;
        b=WTStECn9OjBACfaxF5bJEjwfQdFkLkx7LJ0Wu6hmlKPSeBOIcAw76CCpaJxZTcZ47S
         LOmfIjogNzQBs5U4xSFvfvUWXaoE4l1bsUx5eu+4Jh0iWbWPu3KSO92NN9Q/yZixeL9b
         hQIIg1+0yUhQSFZtsLSj1mFRYVsGu8NOdAwN1ZnjIAwR9fRrTnyJN2Y5TlD+k56h0WhP
         APkC86GdTUcr1dp5qETvtVTgAx49LeLuNc76qEzgSdL7rP/1TWpdbZPR1lyY2gWWbDvd
         uJ03s8h4NmLRqXtfRS9oLH3rf8KBmdxW7tbvSprNvMGhhebP9fxdvv2UIFltXs4xaukK
         1mVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724250401; x=1724855201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pc3oH83451CeWS4VKLJb3/MW3Irx8Ealej33KWVBpwI=;
        b=E6CMNNWCFFL8KXT4Yzo5QTgSijQ5avYkd6gG/cSCZCyQur5mutNpNfygeI0+uxNp49
         2bpt9ZPIH2bkNx1N4KWP5j+LVmgGQwpMX44AinED9mOJCchBVJKemaXW9Nzoevne/d2W
         pztDgK5R84tidmxTyw/dXm4MVkuBX4fO//4t9MEGUgSiYNDO5RAmzgbW5jI3oIpUid75
         mSzR/ObjZHCovOneqE3dNa51mnRSqgjmfYkalEWHN92lBsZbh1TADYynitAPI2nllzaf
         XfrPlv1FSJ47fLGp3NabefW5pUV2rC6o6Z9NrEg+MELa3En6qOj8cZQcevroShHrlvPS
         z9Ow==
X-Forwarded-Encrypted: i=1; AJvYcCUpqGifVpdPRqW3BCH13AplPbwpilArAfLDc27EOJ3dBhYoAFvqzUSrCncELndnP4/CFiE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYZxHFCKPW/3obfUabZQpyofOuu5+QKdboW4jrquGWCoTt7cwj
	d5UIxaAK85lKWwWS14FLoWKaSObWYiOpPQGnNhZzOry1T/u7qQYxe1nbs2uAo3s=
X-Google-Smtp-Source: AGHT+IGKQ01goe26Qzs3n/MKI58ZfYTLt7lQKleX8xrbKlefkSmkxHuviKTprq/5KohjpfGQ8TtGGg==
X-Received: by 2002:a05:600c:3581:b0:428:e09d:3c with SMTP id 5b1f17b1804b1-42abf0a8d02mr16517105e9.33.1724250400071;
        Wed, 21 Aug 2024 07:26:40 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abebc34ddsm28646765e9.0.2024.08.21.07.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 07:26:39 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v3 1/4] Sync-up headers with Linux-6.10 kernel
Date: Wed, 21 Aug 2024 19:56:07 +0530
Message-Id: <20240821142610.3297483-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240821142610.3297483-1-apatel@ventanamicro.com>
References: <20240821142610.3297483-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We sync-up Linux headers to get latest KVM RISC-V headers having
Sscofpmf support.

Signed-off-by: Anup Patel Anup Patel <apatel@ventanamicro.com>
---
 include/linux/kvm.h        |   4 +-
 include/linux/virtio_net.h | 143 +++++++++++++++++++++++++++++++++++++
 riscv/include/asm/kvm.h    |   1 +
 x86/include/asm/kvm.h      |  22 +++++-
 4 files changed, 166 insertions(+), 4 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 2190adb..d03842a 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -1221,9 +1221,9 @@ struct kvm_vfio_spapr_tce {
 /* Available with KVM_CAP_SPAPR_RESIZE_HPT */
 #define KVM_PPC_RESIZE_HPT_PREPARE _IOR(KVMIO, 0xad, struct kvm_ppc_resize_hpt)
 #define KVM_PPC_RESIZE_HPT_COMMIT  _IOR(KVMIO, 0xae, struct kvm_ppc_resize_hpt)
-/* Available with KVM_CAP_PPC_RADIX_MMU or KVM_CAP_PPC_HASH_MMU_V3 */
+/* Available with KVM_CAP_PPC_MMU_RADIX or KVM_CAP_PPC_MMU_HASH_V3 */
 #define KVM_PPC_CONFIGURE_V3_MMU  _IOW(KVMIO,  0xaf, struct kvm_ppc_mmuv3_cfg)
-/* Available with KVM_CAP_PPC_RADIX_MMU */
+/* Available with KVM_CAP_PPC_MMU_RADIX */
 #define KVM_PPC_GET_RMMU_INFO	  _IOW(KVMIO,  0xb0, struct kvm_ppc_rmmu_info)
 /* Available with KVM_CAP_PPC_GET_CPU_CHAR */
 #define KVM_PPC_GET_CPU_CHAR	  _IOR(KVMIO,  0xb1, struct kvm_ppc_cpu_char)
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index cc65ef0..ac91747 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -56,6 +56,7 @@
 #define VIRTIO_NET_F_MQ	22	/* Device supports Receive Flow
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
+#define VIRTIO_NET_F_DEVICE_STATS 50	/* Device can provide device-level statistics. */
 #define VIRTIO_NET_F_VQ_NOTF_COAL 52	/* Device supports virtqueue notification coalescing */
 #define VIRTIO_NET_F_NOTF_COAL	53	/* Device supports notifications coalescing */
 #define VIRTIO_NET_F_GUEST_USO4	54	/* Guest can handle USOv4 in. */
@@ -406,4 +407,146 @@ struct  virtio_net_ctrl_coal_vq {
 	struct virtio_net_ctrl_coal coal;
 };
 
+/*
+ * Device Statistics
+ */
+#define VIRTIO_NET_CTRL_STATS         8
+#define VIRTIO_NET_CTRL_STATS_QUERY   0
+#define VIRTIO_NET_CTRL_STATS_GET     1
+
+struct virtio_net_stats_capabilities {
+
+#define VIRTIO_NET_STATS_TYPE_CVQ       (1ULL << 32)
+
+#define VIRTIO_NET_STATS_TYPE_RX_BASIC  (1ULL << 0)
+#define VIRTIO_NET_STATS_TYPE_RX_CSUM   (1ULL << 1)
+#define VIRTIO_NET_STATS_TYPE_RX_GSO    (1ULL << 2)
+#define VIRTIO_NET_STATS_TYPE_RX_SPEED  (1ULL << 3)
+
+#define VIRTIO_NET_STATS_TYPE_TX_BASIC  (1ULL << 16)
+#define VIRTIO_NET_STATS_TYPE_TX_CSUM   (1ULL << 17)
+#define VIRTIO_NET_STATS_TYPE_TX_GSO    (1ULL << 18)
+#define VIRTIO_NET_STATS_TYPE_TX_SPEED  (1ULL << 19)
+
+	__le64 supported_stats_types[1];
+};
+
+struct virtio_net_ctrl_queue_stats {
+	struct {
+		__le16 vq_index;
+		__le16 reserved[3];
+		__le64 types_bitmap[1];
+	} stats[1];
+};
+
+struct virtio_net_stats_reply_hdr {
+#define VIRTIO_NET_STATS_TYPE_REPLY_CVQ       32
+
+#define VIRTIO_NET_STATS_TYPE_REPLY_RX_BASIC  0
+#define VIRTIO_NET_STATS_TYPE_REPLY_RX_CSUM   1
+#define VIRTIO_NET_STATS_TYPE_REPLY_RX_GSO    2
+#define VIRTIO_NET_STATS_TYPE_REPLY_RX_SPEED  3
+
+#define VIRTIO_NET_STATS_TYPE_REPLY_TX_BASIC  16
+#define VIRTIO_NET_STATS_TYPE_REPLY_TX_CSUM   17
+#define VIRTIO_NET_STATS_TYPE_REPLY_TX_GSO    18
+#define VIRTIO_NET_STATS_TYPE_REPLY_TX_SPEED  19
+	__u8 type;
+	__u8 reserved;
+	__le16 vq_index;
+	__le16 reserved1;
+	__le16 size;
+};
+
+struct virtio_net_stats_cvq {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	__le64 command_num;
+	__le64 ok_num;
+};
+
+struct virtio_net_stats_rx_basic {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	__le64 rx_notifications;
+
+	__le64 rx_packets;
+	__le64 rx_bytes;
+
+	__le64 rx_interrupts;
+
+	__le64 rx_drops;
+	__le64 rx_drop_overruns;
+};
+
+struct virtio_net_stats_tx_basic {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	__le64 tx_notifications;
+
+	__le64 tx_packets;
+	__le64 tx_bytes;
+
+	__le64 tx_interrupts;
+
+	__le64 tx_drops;
+	__le64 tx_drop_malformed;
+};
+
+struct virtio_net_stats_rx_csum {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	__le64 rx_csum_valid;
+	__le64 rx_needs_csum;
+	__le64 rx_csum_none;
+	__le64 rx_csum_bad;
+};
+
+struct virtio_net_stats_tx_csum {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	__le64 tx_csum_none;
+	__le64 tx_needs_csum;
+};
+
+struct virtio_net_stats_rx_gso {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	__le64 rx_gso_packets;
+	__le64 rx_gso_bytes;
+	__le64 rx_gso_packets_coalesced;
+	__le64 rx_gso_bytes_coalesced;
+};
+
+struct virtio_net_stats_tx_gso {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	__le64 tx_gso_packets;
+	__le64 tx_gso_bytes;
+	__le64 tx_gso_segments;
+	__le64 tx_gso_segments_bytes;
+	__le64 tx_gso_packets_noseg;
+	__le64 tx_gso_bytes_noseg;
+};
+
+struct virtio_net_stats_rx_speed {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	/* rx_{packets,bytes}_allowance_exceeded are too long. So rename to
+	 * short name.
+	 */
+	__le64 rx_ratelimit_packets;
+	__le64 rx_ratelimit_bytes;
+};
+
+struct virtio_net_stats_tx_speed {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	/* tx_{packets,bytes}_allowance_exceeded are too long. So rename to
+	 * short name.
+	 */
+	__le64 tx_ratelimit_packets;
+	__le64 tx_ratelimit_bytes;
+};
+
 #endif /* _UAPI_LINUX_VIRTIO_NET_H */
diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
index b1c503c..e878e7c 100644
--- a/riscv/include/asm/kvm.h
+++ b/riscv/include/asm/kvm.h
@@ -167,6 +167,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZFA,
 	KVM_RISCV_ISA_EXT_ZTSO,
 	KVM_RISCV_ISA_EXT_ZACAS,
+	KVM_RISCV_ISA_EXT_SSCOFPMF,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
index ef11aa4..9fae1b7 100644
--- a/x86/include/asm/kvm.h
+++ b/x86/include/asm/kvm.h
@@ -457,8 +457,13 @@ struct kvm_sync_regs {
 
 #define KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE	0x00000001
 
-/* attributes for system fd (group 0) */
-#define KVM_X86_XCOMP_GUEST_SUPP	0
+/* vendor-independent attributes for system fd (group 0) */
+#define KVM_X86_GRP_SYSTEM		0
+#  define KVM_X86_XCOMP_GUEST_SUPP	0
+
+/* vendor-specific groups and attributes for system fd */
+#define KVM_X86_GRP_SEV			1
+#  define KVM_X86_SEV_VMSA_FEATURES	0
 
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
@@ -689,6 +694,9 @@ enum sev_cmd_id {
 	/* Guest Migration Extension */
 	KVM_SEV_SEND_CANCEL,
 
+	/* Second time is the charm; improved versions of the above ioctls.  */
+	KVM_SEV_INIT2,
+
 	KVM_SEV_NR_MAX,
 };
 
@@ -700,6 +708,14 @@ struct kvm_sev_cmd {
 	__u32 sev_fd;
 };
 
+struct kvm_sev_init {
+	__u64 vmsa_features;
+	__u32 flags;
+	__u16 ghcb_version;
+	__u16 pad1;
+	__u32 pad2[8];
+};
+
 struct kvm_sev_launch_start {
 	__u32 handle;
 	__u32 policy;
@@ -856,5 +872,7 @@ struct kvm_hyperv_eventfd {
 
 #define KVM_X86_DEFAULT_VM	0
 #define KVM_X86_SW_PROTECTED_VM	1
+#define KVM_X86_SEV_VM		2
+#define KVM_X86_SEV_ES_VM	3
 
 #endif /* _ASM_X86_KVM_H */
-- 
2.34.1


