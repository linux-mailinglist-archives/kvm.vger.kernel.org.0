Return-Path: <kvm+bounces-22046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 56592938ED5
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 14:07:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE269B213D7
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 12:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98CEA16D4D6;
	Mon, 22 Jul 2024 12:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="bxg4O2I9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5BD17C69
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 12:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721650048; cv=none; b=fgeXPxcSDj+vESjpvrDwO/zwwyDYL3FrfMShZMbehpvwelyFHYF1cZaZfTGXYYwbhXXmN1gtgkM83eTXiYefgpZeDHcpMrXxYIdt896NXLoKVs0F94pzugh7fBpxzAK3b5YKkrGhq0vwSG5PM1nRntFH2wqkOfYCmASpdEArtx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721650048; c=relaxed/simple;
	bh=PWtc5aldsHtv2h7Ede3x534t98EKCHMOqmWv9fq7rK8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BKV+c7jjSVN3jdedM0vxn2E3g9buff+qWf6ZTyr3VXXXA65+jR6JA9OyNFErVk6rPDfMJTZpypt7Cr0bxx4AIO8GZ4JXPZynCWkCFFNOq31N8R5UjUTCUHFRzc9GOontDce6wuSZ25+xQ2aYPUKvH1CWcdslpF/9nqZQXwKGSOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=bxg4O2I9; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-70448cae1e0so2251026a34.3
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 05:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1721650046; x=1722254846; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pc3oH83451CeWS4VKLJb3/MW3Irx8Ealej33KWVBpwI=;
        b=bxg4O2I91CTa8MbSF+kPp7gIReyi0LwIqcJfcykJHs3oFWTAf3PFA0HCpK9p3bz9Aw
         Wp2ZxS3AmibcTyn8AgD8Mp6Lll5ZABeJPYAWcbbV7ox0blW36mZdbFXHdj+p3XwoQbjF
         va7OIazUqkHZYBcAUtx1xni1+hbSVbF2afmFQL1L95gTS22GYtpr2wgT9EmuFHK8xcUu
         TcpfXdTSMnKVbqEqDcmo3t22/PKDpcJlEqNe25qYRvU81i9GYXtQqr8XsRmOW9waUK5Q
         u6ZlIbOY6FvjRWf8N+wyyWj/mJicAOMVqz8UTXWbul9PzOzVzyqmXKyACLMyDZ8db+z2
         GBpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721650046; x=1722254846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pc3oH83451CeWS4VKLJb3/MW3Irx8Ealej33KWVBpwI=;
        b=VOnpPAp9kpxzDjmQLPzQ83JeF/wNRBQ5gbuXXmjiEmKt4G5Bict0zhHXkoEyNqHdpu
         4tla84DmKPoC42r+sHEF5ebVUKBmKbXiH1dxufOY93PvBURmhps5lgGp9BtxOJMcGg8T
         nobMFGWHk5Cc5VcZDi8YxUqM7ZB41aYM1Z9SkyZ92jEf6qA+ljOEUUKTFQkRE6sCH6zw
         5chEAGnRDZgzymU5QtS/mfPQK9K/6OP7rlc04V5s7JNRHHKU4Z+7S4Z/jfNmytW2ua2v
         rZ/N5nS+jwRczWHClsIzi2wMOiLDnArfbG49R6lJA7lHdZklRCNriTdS45IGV8tAa+HB
         KDhw==
X-Forwarded-Encrypted: i=1; AJvYcCXs0lYzpNOLRR4ojyC0zIlLQsknwCsxUMcnWOjE2rSJFNFfMQy0CsRuPDWFI3jNjClBCli2OBBhR3uMReKTr15n1No2
X-Gm-Message-State: AOJu0YwxvuUc49Pf/lTita1Yddth1ddoucf3P5yaszMqA6pUxEuimjxK
	lA3ufY/IZTfcJlj0rHDAxTtliz1rCxCp8Q+atE8UC7Y/vHxGc/GHJBb6pxMi2GAxdZ9OxSd39PW
	b
X-Google-Smtp-Source: AGHT+IHkhQNZRas9Qwlpy57ngx+hVcVi1WrrqCMeumUU2P111hbOVtEutJ+buu4AVP32D/0iwHRqEg==
X-Received: by 2002:a05:6870:3906:b0:260:f50e:923c with SMTP id 586e51a60fabf-2638dfb0105mr5842105fac.10.1721650046044;
        Mon, 22 Jul 2024 05:07:26 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2610ca48ca7sm1637855fac.42.2024.07.22.05.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jul 2024 05:07:25 -0700 (PDT)
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
Subject: [PATCH 1/2] Sync-up headers with Linux-6.10 kernel
Date: Mon, 22 Jul 2024 17:37:09 +0530
Message-Id: <20240722120710.417705-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240722120710.417705-1-apatel@ventanamicro.com>
References: <20240722120710.417705-1-apatel@ventanamicro.com>
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


