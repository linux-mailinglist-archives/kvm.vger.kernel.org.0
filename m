Return-Path: <kvm+bounces-18980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 618038FDAA2
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 01:36:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 125B1286BFD
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 23:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D330167274;
	Wed,  5 Jun 2024 23:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RfhDFO6O"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0B7167268
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 23:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717630610; cv=none; b=ccGXrhsuLfM+0556y26JC9WdU/eEPlQzYhjtWjtpOCEj4XEH1+BopIoEPROa+7yG9rviA3d2RFMb6UMDKLqBj6Ydh6O3D+btd6HfClU28+AvzYNMJ1HIlQqeFCW5c+8cms2oTsPR2c0+kDfKu9dfCbO3/l5jqhkQry0LICUFnCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717630610; c=relaxed/simple;
	bh=8ltoVXTCGhF4C90coKnbxrq6d4REUXcpmpwMWqvpDXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PMQH1/h9LCl7AGGRC74I3XCYYturc0qyoen9VTrWsgKr50lLul+ttCC/GrIbB0Yt9frmlGmCfcfSzOroFU2c1n9ASz4GGsfus0yThLg8C163Txx0asozJTPiD70YFMe4pY4PZwTYMUaLx4NyOYjero+C1VORBttHOUUJlo8CGhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RfhDFO6O; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717630607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=htiGewZQePeDM6wJgWhT3oGJySGerAHDxg1IujevkYQ=;
	b=RfhDFO6OciE9knFci3nk6s0ytaqdQIqkkPXtfCpCsP/PlkAKYbGe/9clHyBMPKV3tOv1XO
	ssMnmir2PK5csJdqmZJTiRcziurGCIdtVJRRxrKUfooNdcGQcnVI5+UmjGxwnUQGPvd9Ar
	QdAjW+kLBx1RCfTnidjCpjaBO1LBEPw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-498-heYUMEKVMWirM8LQjCivSA-1; Wed, 05 Jun 2024 19:36:46 -0400
X-MC-Unique: heYUMEKVMWirM8LQjCivSA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a68cc214ac7so10617766b.2
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 16:36:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717630605; x=1718235405;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=htiGewZQePeDM6wJgWhT3oGJySGerAHDxg1IujevkYQ=;
        b=eRFZs3yjUuHrayIkUChGjyCPuS7mkfnJg1sdU9QiHN8mjf5PfOadEhWhY71EQS28W8
         JmkCPKN/VhIRlLQpOf447rV5OwnDKQzyPD4mGF+kJsrsY4KPijdYhY3bDDT0zO5Hjffo
         0FNGgHPJ2dDfi7Tz5oMRGZXDN8Z4DtKvfiqFVmJkqEbxLCexd8pv+gY04Yt5mDP/peAq
         IqnjXdog4RH3LYasFrmUqeglhHVOs/92ZCuwY+OxB8qPqKi6gblZJSqoejeb/eaVpR+z
         6U2tsbyGx3p3KB1X3XdzAmDb63m1mNouMVcaM5clsKv+FdIfN+U4oL/s+EnAzu/qO1Ck
         Hygg==
X-Forwarded-Encrypted: i=1; AJvYcCX09JkIno4v8DO5BDXHe0V5Ts/bBP5aQDs/Nqgx4TiOZ7QgPTfJTU6xopqcXIiowMZRtRORe3MKKw7erg4VLMMfPRD5
X-Gm-Message-State: AOJu0YzpcwdDkz7Itsut1bg7MUUT7104vrBCXXrOchuikc4byMZs94In
	MYNKDHg71xoSs8rBTYW+Axp122W/xIQ/oy4gBhLRtdoUk7Q30qGYGOfv0/w2BMumZIeegyjJhuL
	gsaW1eV0Hrvi8FDbABZg7ltWDp0LCMHrQPwhlvRfzVlkaSxNvew==
X-Received: by 2002:a17:906:c44d:b0:a6b:c993:7ede with SMTP id a640c23a62f3a-a6bc9938015mr169634766b.11.1717630604933;
        Wed, 05 Jun 2024 16:36:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+zgkPZz3vc+Dw7Xd1Pg1Nztsc44ooOcRtuFwwOa7eQ+vg7I9UVfbzCMN0ultwPlZ6NiPx7g==
X-Received: by 2002:a17:906:c44d:b0:a6b:c993:7ede with SMTP id a640c23a62f3a-a6bc9938015mr169634066b.11.1717630604397;
        Wed, 05 Jun 2024 16:36:44 -0700 (PDT)
Received: from redhat.com ([2.55.56.67])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6c806ebd21sm6620166b.100.2024.06.05.16.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 16:36:43 -0700 (PDT)
Date: Wed, 5 Jun 2024 19:36:40 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>,
	Cornelia Huck <cohuck@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PULL v3 33/41] linux-headers: update to 6.10-rc1
Message-ID: <40876c584a7f355963b81b32e81d623b353c3cb8.1717630437.git.mst@redhat.com>
References: <cover.1717630437.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1717630437.git.mst@redhat.com>
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
 include/standard-headers/linux/pvpanic.h    |   7 +-
 include/standard-headers/linux/virtio_bt.h  |   1 -
 include/standard-headers/linux/virtio_mem.h |   2 +
 include/standard-headers/linux/virtio_net.h | 143 ++++++++++++++++++++
 linux-headers/asm-generic/unistd.h          |   5 +-
 linux-headers/asm-loongarch/kvm.h           |   4 +
 linux-headers/asm-mips/unistd_n32.h         |   1 +
 linux-headers/asm-mips/unistd_n64.h         |   1 +
 linux-headers/asm-mips/unistd_o32.h         |   1 +
 linux-headers/asm-powerpc/unistd_32.h       |   1 +
 linux-headers/asm-powerpc/unistd_64.h       |   1 +
 linux-headers/asm-riscv/kvm.h               |   1 +
 linux-headers/asm-s390/unistd_32.h          |   1 +
 linux-headers/asm-s390/unistd_64.h          |   1 +
 linux-headers/asm-x86/kvm.h                 |   4 +-
 linux-headers/asm-x86/unistd_32.h           |   1 +
 linux-headers/asm-x86/unistd_64.h           |   1 +
 linux-headers/asm-x86/unistd_x32.h          |   2 +
 linux-headers/linux/kvm.h                   |   4 +-
 linux-headers/linux/stddef.h                |   8 ++
 linux-headers/linux/vhost.h                 |  15 +-
 23 files changed, 252 insertions(+), 14 deletions(-)

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
diff --git a/include/standard-headers/linux/pvpanic.h b/include/standard-headers/linux/pvpanic.h
index 54b7485390..b115094431 100644
--- a/include/standard-headers/linux/pvpanic.h
+++ b/include/standard-headers/linux/pvpanic.h
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
diff --git a/linux-headers/asm-loongarch/kvm.h b/linux-headers/asm-loongarch/kvm.h
index 109785922c..f9abef3823 100644
--- a/linux-headers/asm-loongarch/kvm.h
+++ b/linux-headers/asm-loongarch/kvm.h
@@ -17,6 +17,8 @@
 #define KVM_COALESCED_MMIO_PAGE_OFFSET	1
 #define KVM_DIRTY_LOG_PAGE_OFFSET	64
 
+#define KVM_GUESTDBG_USE_SW_BP		0x00010000
+
 /*
  * for KVM_GET_REGS and KVM_SET_REGS
  */
@@ -72,6 +74,8 @@ struct kvm_fpu {
 
 #define KVM_REG_LOONGARCH_COUNTER	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 1)
 #define KVM_REG_LOONGARCH_VCPU_RESET	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 2)
+/* Debugging: Special instruction for software breakpoint */
+#define KVM_REG_LOONGARCH_DEBUG_INST	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 3)
 
 #define LOONGARCH_REG_SHIFT		3
 #define LOONGARCH_REG_64(TYPE, REG)	(TYPE | KVM_REG_SIZE_U64 | (REG << LOONGARCH_REG_SHIFT))
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
diff --git a/linux-headers/asm-riscv/kvm.h b/linux-headers/asm-riscv/kvm.h
index b1c503c295..e878e7cc39 100644
--- a/linux-headers/asm-riscv/kvm.h
+++ b/linux-headers/asm-riscv/kvm.h
@@ -167,6 +167,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZFA,
 	KVM_RISCV_ISA_EXT_ZTSO,
 	KVM_RISCV_ISA_EXT_ZACAS,
+	KVM_RISCV_ISA_EXT_SSCOFPMF,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
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
diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 31c95c2dfe..b4e2e8d220 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -709,7 +709,9 @@ struct kvm_sev_cmd {
 struct kvm_sev_init {
 	__u64 vmsa_features;
 	__u32 flags;
-	__u32 pad[9];
+	__u16 ghcb_version;
+	__u16 pad1;
+	__u32 pad2[8];
 };
 
 struct kvm_sev_launch_start {
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
diff --git a/linux-headers/linux/vhost.h b/linux-headers/linux/vhost.h
index bea6973906..b95dd84eef 100644
--- a/linux-headers/linux/vhost.h
+++ b/linux-headers/linux/vhost.h
@@ -179,12 +179,6 @@
 /* Get the config size */
 #define VHOST_VDPA_GET_CONFIG_SIZE	_IOR(VHOST_VIRTIO, 0x79, __u32)
 
-/* Get the count of all virtqueues */
-#define VHOST_VDPA_GET_VQS_COUNT	_IOR(VHOST_VIRTIO, 0x80, __u32)
-
-/* Get the number of virtqueue groups. */
-#define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x81, __u32)
-
 /* Get the number of address spaces. */
 #define VHOST_VDPA_GET_AS_NUM		_IOR(VHOST_VIRTIO, 0x7A, unsigned int)
 
@@ -228,10 +222,17 @@
 #define VHOST_VDPA_GET_VRING_DESC_GROUP	_IOWR(VHOST_VIRTIO, 0x7F,	\
 					      struct vhost_vring_state)
 
+
+/* Get the count of all virtqueues */
+#define VHOST_VDPA_GET_VQS_COUNT	_IOR(VHOST_VIRTIO, 0x80, __u32)
+
+/* Get the number of virtqueue groups. */
+#define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x81, __u32)
+
 /* Get the queue size of a specific virtqueue.
  * userspace set the vring index in vhost_vring_state.index
  * kernel set the queue size in vhost_vring_state.num
  */
-#define VHOST_VDPA_GET_VRING_SIZE	_IOWR(VHOST_VIRTIO, 0x80,	\
+#define VHOST_VDPA_GET_VRING_SIZE	_IOWR(VHOST_VIRTIO, 0x82,	\
 					      struct vhost_vring_state)
 #endif
-- 
MST


