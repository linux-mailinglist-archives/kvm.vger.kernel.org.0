Return-Path: <kvm+bounces-20848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85950923FEA
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 16:08:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA19F1C239DB
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 14:08:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 284C31B5833;
	Tue,  2 Jul 2024 14:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e6ZYHDF7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565A71B580F
	for <kvm@vger.kernel.org>; Tue,  2 Jul 2024 14:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719929321; cv=none; b=O1uhIDlngxTRVhG9PgJUfPfWE7cz3Q4s6u8KCpC8nQgL39nhl8NrTq4kF7vus7O7gkyysY6oXWaXxf648C9DnLsqplGqsn0ONbJ+wfESGqdZ5QRufFRDug6zSkdeO4S8ZxEvcJDM7q5Ob3+iwtORk7uEs076rxUurS22pQxKFtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719929321; c=relaxed/simple;
	bh=lUCEVcmBer70B5oPtuWxYrEYSGZ6922zre3Xx9nh29U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J/nW+gAFSA7pfAArKOP9KU8CnXBWY0gB70CX8akJXctY+Jx3/b4bNQWC5XbcrXwzr+gU505LeQ51xPRI7WuUYyzJQa/r/d5nlouo4nOGO2lNoFV39m0QQQcqJV7iu955W0HuMoJke+Y+DP8jk2Q9BIln/DBAtxqmKzJkaVoKzhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e6ZYHDF7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719929318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6YLYsco4l6cXmk5+8G0baLpqo+8dcgJ41Mj5z/Hl5Ws=;
	b=e6ZYHDF7B0ljvIlO46Bf1AbXIRVI003+nOGeDC1DTfKvaTv1VrL+76+ath6Uj4ePqFK2Q1
	cwT6yTj0OYU2f1j0jgjzP5erSUOTRWzq7Q3GZTLcDhy9bJdxWQ0WYyuHlWeH4tjHh1CEX/
	AU64hDrhzpn9K55RppuMMmw+l6MIv4k=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-PSl292ZnMTKo3lkkWbf_5A-1; Tue, 02 Jul 2024 10:08:36 -0400
X-MC-Unique: PSl292ZnMTKo3lkkWbf_5A-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-52ce8969cf1so4159755e87.1
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2024 07:08:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719929315; x=1720534115;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6YLYsco4l6cXmk5+8G0baLpqo+8dcgJ41Mj5z/Hl5Ws=;
        b=gkKHos4cfSkDynZugGMmDJ9d/mvBMFvNCqIaoI/jxb8VXfpkRws1XUnkAAk0VXwFWE
         A5B4PpPM9w3qj6t0HF/UeF5a7WZFRbCeWYWfjRweoRU/wH+lkNGEyEZ8KdtCIqyELePh
         P3lHJPKU2b3sr7nKxkxF12uvnNRLZF3t95ezcKcyAiuQYr/VB1R5IiBFG0u4hgcg8UwL
         YcjM6l7k0RkkIN9YT4AJ+uzA/ukhJNrxuBDLkpyTXN7C11/K0uW4ZgOhWsqhqrF746df
         F0OXfTRSk+j+OAfIZ4JDfXOHS1v35n5ZbmFE+BKRHlm7S8cdXcznEW/b2TBV2FiM98/0
         XOMA==
X-Forwarded-Encrypted: i=1; AJvYcCUBN5MggutqGCsMdtEFKLZqlB5yBT6mjkOmpbA0NWd5wfT2Fct6eyP44Ggtq+voWJjvl2qgEy0YroS4qM/F2w83e01t
X-Gm-Message-State: AOJu0Yz/R4iWa7BakSlAl1JUZfO2c2vG5hF4JRAvxUzyOFOE6pBLd/0D
	mgf6v2KEcKDmHB2zVqs6MokrFg7Lc6aMdvy2Cm4CJf6NH9PduqGyhj56DD7UwmSkuUkls2+2qUk
	FBTCB4LvSoZlmGDoFlsMv/hE/YkjyjfKU6kXD7bvqRpfZBWBj/w==
X-Received: by 2002:ac2:4c41:0:b0:52b:bee3:dcc6 with SMTP id 2adb3069b0e04-52e826fa995mr6662890e87.51.1719929315119;
        Tue, 02 Jul 2024 07:08:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbwFH33b1Jsqc9w+2I6kpCa3jZj1Z9oJetUyEKCoxMqIZPTzpSBHgco37mFr97NKoCtIobHg==
X-Received: by 2002:ac2:4c41:0:b0:52b:bee3:dcc6 with SMTP id 2adb3069b0e04-52e826fa995mr6662836e87.51.1719929313657;
        Tue, 02 Jul 2024 07:08:33 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1f5:eadd:8c31:db01:9d01:7604])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3675a0d9b12sm13309194f8f.44.2024.07.02.07.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 07:08:33 -0700 (PDT)
Date: Tue, 2 Jul 2024 10:08:31 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>,
	Cornelia Huck <cohuck@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PULL 30/91] linux-headers: update to 6.10-rc1
Message-ID: <c5614ee3f2775534871914c02be4b5a61b71ed40.1719929191.git.mst@redhat.com>
References: <cover.1719929191.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1719929191.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

From: Thomas Weißschuh <thomas@t-8ch.de>

Signed-off-by: Thomas Weißschuh <thomas@t-8ch.de>
Message-Id: <20240527-pvpanic-shutdown-v8-2-5a28ec02558b@t-8ch.de>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/standard-headers/linux/ethtool.h    |  55 ++++++++
 include/standard-headers/linux/pci_regs.h   |   6 +
 include/standard-headers/linux/virtio_bt.h  |   1 -
 include/standard-headers/linux/virtio_mem.h |   2 +
 include/standard-headers/linux/virtio_net.h | 143 ++++++++++++++++++++
 include/standard-headers/misc/pvpanic.h     |   7 +-
 linux-headers/asm-generic/unistd.h          |   5 +-
 linux-headers/asm-mips/unistd_n32.h         |   1 +
 linux-headers/asm-mips/unistd_n64.h         |   1 +
 linux-headers/asm-mips/unistd_o32.h         |   1 +
 linux-headers/asm-powerpc/unistd_32.h       |   1 +
 linux-headers/asm-powerpc/unistd_64.h       |   1 +
 linux-headers/asm-s390/unistd_32.h          |   1 +
 linux-headers/asm-s390/unistd_64.h          |   1 +
 linux-headers/asm-x86/unistd_32.h           |   1 +
 linux-headers/asm-x86/unistd_64.h           |   1 +
 linux-headers/asm-x86/unistd_x32.h          |   2 +
 linux-headers/linux/kvm.h                   |   4 +-
 linux-headers/linux/stddef.h                |   8 ++
 19 files changed, 236 insertions(+), 6 deletions(-)

diff --git a/include/standard-headers/linux/ethtool.h b/include/standard-headers/linux/ethtool.h
index 01503784d2..b0b4b68410 100644
--- a/include/standard-headers/linux/ethtool.h
+++ b/include/standard-headers/linux/ethtool.h
@@ -752,6 +752,61 @@ enum ethtool_module_power_mode {
 	ETHTOOL_MODULE_POWER_MODE_HIGH,
 };
 
+/**
+ * enum ethtool_pse_types - Types of PSE controller.
+ * @ETHTOOL_PSE_UNKNOWN: Type of PSE controller is unknown
+ * @ETHTOOL_PSE_PODL: PSE controller which support PoDL
+ * @ETHTOOL_PSE_C33: PSE controller which support Clause 33 (PoE)
+ */
+enum ethtool_pse_types {
+	ETHTOOL_PSE_UNKNOWN =	1 << 0,
+	ETHTOOL_PSE_PODL =	1 << 1,
+	ETHTOOL_PSE_C33 =	1 << 2,
+};
+
+/**
+ * enum ethtool_c33_pse_admin_state - operational state of the PoDL PSE
+ *	functions. IEEE 802.3-2022 30.9.1.1.2 aPSEAdminState
+ * @ETHTOOL_C33_PSE_ADMIN_STATE_UNKNOWN: state of PSE functions is unknown
+ * @ETHTOOL_C33_PSE_ADMIN_STATE_DISABLED: PSE functions are disabled
+ * @ETHTOOL_C33_PSE_ADMIN_STATE_ENABLED: PSE functions are enabled
+ */
+enum ethtool_c33_pse_admin_state {
+	ETHTOOL_C33_PSE_ADMIN_STATE_UNKNOWN = 1,
+	ETHTOOL_C33_PSE_ADMIN_STATE_DISABLED,
+	ETHTOOL_C33_PSE_ADMIN_STATE_ENABLED,
+};
+
+/**
+ * enum ethtool_c33_pse_pw_d_status - power detection status of the PSE.
+ *	IEEE 802.3-2022 30.9.1.1.3 aPoDLPSEPowerDetectionStatus:
+ * @ETHTOOL_C33_PSE_PW_D_STATUS_UNKNOWN: PSE status is unknown
+ * @ETHTOOL_C33_PSE_PW_D_STATUS_DISABLED: The enumeration "disabled"
+ *	indicates that the PSE State diagram is in the state DISABLED.
+ * @ETHTOOL_C33_PSE_PW_D_STATUS_SEARCHING: The enumeration "searching"
+ *	indicates the PSE State diagram is in a state other than those
+ *	listed.
+ * @ETHTOOL_C33_PSE_PW_D_STATUS_DELIVERING: The enumeration
+ *	"deliveringPower" indicates that the PSE State diagram is in the
+ *	state POWER_ON.
+ * @ETHTOOL_C33_PSE_PW_D_STATUS_TEST: The enumeration "test" indicates that
+ *	the PSE State diagram is in the state TEST_MODE.
+ * @ETHTOOL_C33_PSE_PW_D_STATUS_FAULT: The enumeration "fault" indicates that
+ *	the PSE State diagram is in the state TEST_ERROR.
+ * @ETHTOOL_C33_PSE_PW_D_STATUS_OTHERFAULT: The enumeration "otherFault"
+ *	indicates that the PSE State diagram is in the state IDLE due to
+ *	the variable error_condition = true.
+ */
+enum ethtool_c33_pse_pw_d_status {
+	ETHTOOL_C33_PSE_PW_D_STATUS_UNKNOWN = 1,
+	ETHTOOL_C33_PSE_PW_D_STATUS_DISABLED,
+	ETHTOOL_C33_PSE_PW_D_STATUS_SEARCHING,
+	ETHTOOL_C33_PSE_PW_D_STATUS_DELIVERING,
+	ETHTOOL_C33_PSE_PW_D_STATUS_TEST,
+	ETHTOOL_C33_PSE_PW_D_STATUS_FAULT,
+	ETHTOOL_C33_PSE_PW_D_STATUS_OTHERFAULT,
+};
+
 /**
  * enum ethtool_podl_pse_admin_state - operational state of the PoDL PSE
  *	functions. IEEE 802.3-2018 30.15.1.1.2 aPoDLPSEAdminState
diff --git a/include/standard-headers/linux/pci_regs.h b/include/standard-headers/linux/pci_regs.h
index a39193213f..94c00996e6 100644
--- a/include/standard-headers/linux/pci_regs.h
+++ b/include/standard-headers/linux/pci_regs.h
@@ -1144,8 +1144,14 @@
 #define PCI_DOE_DATA_OBJECT_HEADER_2_LENGTH		0x0003ffff
 
 #define PCI_DOE_DATA_OBJECT_DISC_REQ_3_INDEX		0x000000ff
+#define PCI_DOE_DATA_OBJECT_DISC_REQ_3_VER		0x0000ff00
 #define PCI_DOE_DATA_OBJECT_DISC_RSP_3_VID		0x0000ffff
 #define PCI_DOE_DATA_OBJECT_DISC_RSP_3_PROTOCOL		0x00ff0000
 #define PCI_DOE_DATA_OBJECT_DISC_RSP_3_NEXT_INDEX	0xff000000
 
+/* Compute Express Link (CXL r3.1, sec 8.1.5) */
+#define PCI_DVSEC_CXL_PORT				3
+#define PCI_DVSEC_CXL_PORT_CTL				0x0c
+#define PCI_DVSEC_CXL_PORT_CTL_UNMASK_SBR		0x00000001
+
 #endif /* LINUX_PCI_REGS_H */
diff --git a/include/standard-headers/linux/virtio_bt.h b/include/standard-headers/linux/virtio_bt.h
index a11ecc3f92..6f0dee7e32 100644
--- a/include/standard-headers/linux/virtio_bt.h
+++ b/include/standard-headers/linux/virtio_bt.h
@@ -13,7 +13,6 @@
 
 enum virtio_bt_config_type {
 	VIRTIO_BT_CONFIG_TYPE_PRIMARY	= 0,
-	VIRTIO_BT_CONFIG_TYPE_AMP	= 1,
 };
 
 enum virtio_bt_config_vendor {
diff --git a/include/standard-headers/linux/virtio_mem.h b/include/standard-headers/linux/virtio_mem.h
index 18c74c527c..6bfa41bd8b 100644
--- a/include/standard-headers/linux/virtio_mem.h
+++ b/include/standard-headers/linux/virtio_mem.h
@@ -90,6 +90,8 @@
 #define VIRTIO_MEM_F_ACPI_PXM		0
 /* unplugged memory must not be accessed */
 #define VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE	1
+/* plugged memory will remain plugged when suspending+resuming */
+#define VIRTIO_MEM_F_PERSISTENT_SUSPEND		2
 
 
 /* --- virtio-mem: guest -> host requests --- */
diff --git a/include/standard-headers/linux/virtio_net.h b/include/standard-headers/linux/virtio_net.h
index 0f88417742..fc594fe5fc 100644
--- a/include/standard-headers/linux/virtio_net.h
+++ b/include/standard-headers/linux/virtio_net.h
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
+	uint64_t supported_stats_types[1];
+};
+
+struct virtio_net_ctrl_queue_stats {
+	struct {
+		uint16_t vq_index;
+		uint16_t reserved[3];
+		uint64_t types_bitmap[1];
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
+	uint8_t type;
+	uint8_t reserved;
+	uint16_t vq_index;
+	uint16_t reserved1;
+	uint16_t size;
+};
+
+struct virtio_net_stats_cvq {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	uint64_t command_num;
+	uint64_t ok_num;
+};
+
+struct virtio_net_stats_rx_basic {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	uint64_t rx_notifications;
+
+	uint64_t rx_packets;
+	uint64_t rx_bytes;
+
+	uint64_t rx_interrupts;
+
+	uint64_t rx_drops;
+	uint64_t rx_drop_overruns;
+};
+
+struct virtio_net_stats_tx_basic {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	uint64_t tx_notifications;
+
+	uint64_t tx_packets;
+	uint64_t tx_bytes;
+
+	uint64_t tx_interrupts;
+
+	uint64_t tx_drops;
+	uint64_t tx_drop_malformed;
+};
+
+struct virtio_net_stats_rx_csum {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	uint64_t rx_csum_valid;
+	uint64_t rx_needs_csum;
+	uint64_t rx_csum_none;
+	uint64_t rx_csum_bad;
+};
+
+struct virtio_net_stats_tx_csum {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	uint64_t tx_csum_none;
+	uint64_t tx_needs_csum;
+};
+
+struct virtio_net_stats_rx_gso {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	uint64_t rx_gso_packets;
+	uint64_t rx_gso_bytes;
+	uint64_t rx_gso_packets_coalesced;
+	uint64_t rx_gso_bytes_coalesced;
+};
+
+struct virtio_net_stats_tx_gso {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	uint64_t tx_gso_packets;
+	uint64_t tx_gso_bytes;
+	uint64_t tx_gso_segments;
+	uint64_t tx_gso_segments_bytes;
+	uint64_t tx_gso_packets_noseg;
+	uint64_t tx_gso_bytes_noseg;
+};
+
+struct virtio_net_stats_rx_speed {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	/* rx_{packets,bytes}_allowance_exceeded are too long. So rename to
+	 * short name.
+	 */
+	uint64_t rx_ratelimit_packets;
+	uint64_t rx_ratelimit_bytes;
+};
+
+struct virtio_net_stats_tx_speed {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	/* tx_{packets,bytes}_allowance_exceeded are too long. So rename to
+	 * short name.
+	 */
+	uint64_t tx_ratelimit_packets;
+	uint64_t tx_ratelimit_bytes;
+};
+
 #endif /* _LINUX_VIRTIO_NET_H */
diff --git a/include/standard-headers/misc/pvpanic.h b/include/standard-headers/misc/pvpanic.h
index 54b7485390..b115094431 100644
--- a/include/standard-headers/misc/pvpanic.h
+++ b/include/standard-headers/misc/pvpanic.h
@@ -3,7 +3,10 @@
 #ifndef __PVPANIC_H__
 #define __PVPANIC_H__
 
-#define PVPANIC_PANICKED	(1 << 0)
-#define PVPANIC_CRASH_LOADED	(1 << 1)
+#include "standard-headers/linux/const.h"
+
+#define PVPANIC_PANICKED	_BITUL(0)
+#define PVPANIC_CRASH_LOADED	_BITUL(1)
+#define PVPANIC_SHUTDOWN	_BITUL(2)
 
 #endif /* __PVPANIC_H__ */
diff --git a/linux-headers/asm-generic/unistd.h b/linux-headers/asm-generic/unistd.h
index 75f00965ab..d983c48a3b 100644
--- a/linux-headers/asm-generic/unistd.h
+++ b/linux-headers/asm-generic/unistd.h
@@ -842,8 +842,11 @@ __SYSCALL(__NR_lsm_set_self_attr, sys_lsm_set_self_attr)
 #define __NR_lsm_list_modules 461
 __SYSCALL(__NR_lsm_list_modules, sys_lsm_list_modules)
 
+#define __NR_mseal 462
+__SYSCALL(__NR_mseal, sys_mseal)
+
 #undef __NR_syscalls
-#define __NR_syscalls 462
+#define __NR_syscalls 463
 
 /*
  * 32 bit systems traditionally used different
diff --git a/linux-headers/asm-mips/unistd_n32.h b/linux-headers/asm-mips/unistd_n32.h
index ce2e050a9b..fc93b3be30 100644
--- a/linux-headers/asm-mips/unistd_n32.h
+++ b/linux-headers/asm-mips/unistd_n32.h
@@ -390,5 +390,6 @@
 #define __NR_lsm_get_self_attr (__NR_Linux + 459)
 #define __NR_lsm_set_self_attr (__NR_Linux + 460)
 #define __NR_lsm_list_modules (__NR_Linux + 461)
+#define __NR_mseal (__NR_Linux + 462)
 
 #endif /* _ASM_UNISTD_N32_H */
diff --git a/linux-headers/asm-mips/unistd_n64.h b/linux-headers/asm-mips/unistd_n64.h
index 5bfb3733ff..e72a3eb2c9 100644
--- a/linux-headers/asm-mips/unistd_n64.h
+++ b/linux-headers/asm-mips/unistd_n64.h
@@ -366,5 +366,6 @@
 #define __NR_lsm_get_self_attr (__NR_Linux + 459)
 #define __NR_lsm_set_self_attr (__NR_Linux + 460)
 #define __NR_lsm_list_modules (__NR_Linux + 461)
+#define __NR_mseal (__NR_Linux + 462)
 
 #endif /* _ASM_UNISTD_N64_H */
diff --git a/linux-headers/asm-mips/unistd_o32.h b/linux-headers/asm-mips/unistd_o32.h
index 02eaecd020..b86eb0786c 100644
--- a/linux-headers/asm-mips/unistd_o32.h
+++ b/linux-headers/asm-mips/unistd_o32.h
@@ -436,5 +436,6 @@
 #define __NR_lsm_get_self_attr (__NR_Linux + 459)
 #define __NR_lsm_set_self_attr (__NR_Linux + 460)
 #define __NR_lsm_list_modules (__NR_Linux + 461)
+#define __NR_mseal (__NR_Linux + 462)
 
 #endif /* _ASM_UNISTD_O32_H */
diff --git a/linux-headers/asm-powerpc/unistd_32.h b/linux-headers/asm-powerpc/unistd_32.h
index bbab08d6ec..28627b6546 100644
--- a/linux-headers/asm-powerpc/unistd_32.h
+++ b/linux-headers/asm-powerpc/unistd_32.h
@@ -443,6 +443,7 @@
 #define __NR_lsm_get_self_attr 459
 #define __NR_lsm_set_self_attr 460
 #define __NR_lsm_list_modules 461
+#define __NR_mseal 462
 
 
 #endif /* _ASM_UNISTD_32_H */
diff --git a/linux-headers/asm-powerpc/unistd_64.h b/linux-headers/asm-powerpc/unistd_64.h
index af34cde70f..1fc42a8300 100644
--- a/linux-headers/asm-powerpc/unistd_64.h
+++ b/linux-headers/asm-powerpc/unistd_64.h
@@ -415,6 +415,7 @@
 #define __NR_lsm_get_self_attr 459
 #define __NR_lsm_set_self_attr 460
 #define __NR_lsm_list_modules 461
+#define __NR_mseal 462
 
 
 #endif /* _ASM_UNISTD_64_H */
diff --git a/linux-headers/asm-s390/unistd_32.h b/linux-headers/asm-s390/unistd_32.h
index a3ece69d82..7706c21b87 100644
--- a/linux-headers/asm-s390/unistd_32.h
+++ b/linux-headers/asm-s390/unistd_32.h
@@ -434,5 +434,6 @@
 #define __NR_lsm_get_self_attr 459
 #define __NR_lsm_set_self_attr 460
 #define __NR_lsm_list_modules 461
+#define __NR_mseal 462
 
 #endif /* _ASM_S390_UNISTD_32_H */
diff --git a/linux-headers/asm-s390/unistd_64.h b/linux-headers/asm-s390/unistd_64.h
index 8c5fd93495..62082d592d 100644
--- a/linux-headers/asm-s390/unistd_64.h
+++ b/linux-headers/asm-s390/unistd_64.h
@@ -382,5 +382,6 @@
 #define __NR_lsm_get_self_attr 459
 #define __NR_lsm_set_self_attr 460
 #define __NR_lsm_list_modules 461
+#define __NR_mseal 462
 
 #endif /* _ASM_S390_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/unistd_32.h b/linux-headers/asm-x86/unistd_32.h
index 5c9c329e93..fb7b8b169b 100644
--- a/linux-headers/asm-x86/unistd_32.h
+++ b/linux-headers/asm-x86/unistd_32.h
@@ -452,6 +452,7 @@
 #define __NR_lsm_get_self_attr 459
 #define __NR_lsm_set_self_attr 460
 #define __NR_lsm_list_modules 461
+#define __NR_mseal 462
 
 
 #endif /* _ASM_UNISTD_32_H */
diff --git a/linux-headers/asm-x86/unistd_64.h b/linux-headers/asm-x86/unistd_64.h
index d9aab7ae87..da439afee1 100644
--- a/linux-headers/asm-x86/unistd_64.h
+++ b/linux-headers/asm-x86/unistd_64.h
@@ -374,6 +374,7 @@
 #define __NR_lsm_get_self_attr 459
 #define __NR_lsm_set_self_attr 460
 #define __NR_lsm_list_modules 461
+#define __NR_mseal 462
 
 
 #endif /* _ASM_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/unistd_x32.h b/linux-headers/asm-x86/unistd_x32.h
index 63cdd1ee43..4fcb607c72 100644
--- a/linux-headers/asm-x86/unistd_x32.h
+++ b/linux-headers/asm-x86/unistd_x32.h
@@ -318,6 +318,7 @@
 #define __NR_set_mempolicy_home_node (__X32_SYSCALL_BIT + 450)
 #define __NR_cachestat (__X32_SYSCALL_BIT + 451)
 #define __NR_fchmodat2 (__X32_SYSCALL_BIT + 452)
+#define __NR_map_shadow_stack (__X32_SYSCALL_BIT + 453)
 #define __NR_futex_wake (__X32_SYSCALL_BIT + 454)
 #define __NR_futex_wait (__X32_SYSCALL_BIT + 455)
 #define __NR_futex_requeue (__X32_SYSCALL_BIT + 456)
@@ -326,6 +327,7 @@
 #define __NR_lsm_get_self_attr (__X32_SYSCALL_BIT + 459)
 #define __NR_lsm_set_self_attr (__X32_SYSCALL_BIT + 460)
 #define __NR_lsm_list_modules (__X32_SYSCALL_BIT + 461)
+#define __NR_mseal (__X32_SYSCALL_BIT + 462)
 #define __NR_rt_sigaction (__X32_SYSCALL_BIT + 512)
 #define __NR_rt_sigreturn (__X32_SYSCALL_BIT + 513)
 #define __NR_ioctl (__X32_SYSCALL_BIT + 514)
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 038731cdef..c93876ca0b 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1217,9 +1217,9 @@ struct kvm_vfio_spapr_tce {
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
diff --git a/linux-headers/linux/stddef.h b/linux-headers/linux/stddef.h
index bf9749dd14..96aa341942 100644
--- a/linux-headers/linux/stddef.h
+++ b/linux-headers/linux/stddef.h
@@ -55,4 +55,12 @@
 #define __counted_by(m)
 #endif
 
+#ifndef __counted_by_le
+#define __counted_by_le(m)
+#endif
+
+#ifndef __counted_by_be
+#define __counted_by_be(m)
+#endif
+
 #endif /* _LINUX_STDDEF_H */
-- 
MST


