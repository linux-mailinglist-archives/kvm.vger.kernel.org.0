Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B82532CEE
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 17:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238630AbiEXPGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 11:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238701AbiEXPGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 11:06:33 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39EDDDF3E
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 08:06:23 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 590AE106F;
        Tue, 24 May 2022 08:06:23 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C41F13F70D;
        Tue, 24 May 2022 08:06:21 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Keir Fraser <keirf@google.com>
Subject: [PATCH kvmtool 3/4] include: update virtio UAPI headers
Date:   Tue, 24 May 2022 16:06:10 +0100
Message-Id: <20220524150611.523910-4-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220524150611.523910-1-andre.przywara@arm.com>
References: <20220524150611.523910-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit a08bb43a0c37 ("kvmtool: Copy Linux' up-to-date virtio headers")
copied the kernel's virtio UAPI headers into the kvmtool tree, because
at the time some distros didn't include (all of) them in their kernel
headers package.
Let's update those copies, so that we can use newer features, if needed.

This syncs in the already existing copies of the headers from Linux
v5.18.0.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/linux/virtio_ids.h   |  63 ++++++++---
 include/linux/virtio_net.h   | 200 +++++++++++++++++++++++++++++++----
 include/linux/virtio_scsi.h  | 118 +++++++++++----------
 include/linux/virtio_vsock.h |  16 ++-
 4 files changed, 305 insertions(+), 92 deletions(-)

diff --git a/include/linux/virtio_ids.h b/include/linux/virtio_ids.h
index 7de80eb7..80d76b75 100644
--- a/include/linux/virtio_ids.h
+++ b/include/linux/virtio_ids.h
@@ -29,17 +29,56 @@
  * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  * SUCH DAMAGE. */
 
-#define VIRTIO_ID_NET		1 /* virtio net */
-#define VIRTIO_ID_BLOCK		2 /* virtio block */
-#define VIRTIO_ID_CONSOLE	3 /* virtio console */
-#define VIRTIO_ID_RNG		4 /* virtio rng */
-#define VIRTIO_ID_BALLOON	5 /* virtio balloon */
-#define VIRTIO_ID_RPMSG		7 /* virtio remote processor messaging */
-#define VIRTIO_ID_SCSI		8 /* virtio scsi */
-#define VIRTIO_ID_9P		9 /* 9p virtio console */
-#define VIRTIO_ID_RPROC_SERIAL 11 /* virtio remoteproc serial link */
-#define VIRTIO_ID_CAIF	       12 /* Virtio caif */
-#define VIRTIO_ID_INPUT        18 /* virtio input */
-#define VIRTIO_ID_VSOCK        19 /* virtio vsock transport */
+#define VIRTIO_ID_NET			1 /* virtio net */
+#define VIRTIO_ID_BLOCK			2 /* virtio block */
+#define VIRTIO_ID_CONSOLE		3 /* virtio console */
+#define VIRTIO_ID_RNG			4 /* virtio rng */
+#define VIRTIO_ID_BALLOON		5 /* virtio balloon */
+#define VIRTIO_ID_IOMEM			6 /* virtio ioMemory */
+#define VIRTIO_ID_RPMSG			7 /* virtio remote processor messaging */
+#define VIRTIO_ID_SCSI			8 /* virtio scsi */
+#define VIRTIO_ID_9P			9 /* 9p virtio console */
+#define VIRTIO_ID_MAC80211_WLAN		10 /* virtio WLAN MAC */
+#define VIRTIO_ID_RPROC_SERIAL		11 /* virtio remoteproc serial link */
+#define VIRTIO_ID_CAIF			12 /* Virtio caif */
+#define VIRTIO_ID_MEMORY_BALLOON	13 /* virtio memory balloon */
+#define VIRTIO_ID_GPU			16 /* virtio GPU */
+#define VIRTIO_ID_CLOCK			17 /* virtio clock/timer */
+#define VIRTIO_ID_INPUT			18 /* virtio input */
+#define VIRTIO_ID_VSOCK			19 /* virtio vsock transport */
+#define VIRTIO_ID_CRYPTO		20 /* virtio crypto */
+#define VIRTIO_ID_SIGNAL_DIST		21 /* virtio signal distribution device */
+#define VIRTIO_ID_PSTORE		22 /* virtio pstore device */
+#define VIRTIO_ID_IOMMU			23 /* virtio IOMMU */
+#define VIRTIO_ID_MEM			24 /* virtio mem */
+#define VIRTIO_ID_SOUND			25 /* virtio sound */
+#define VIRTIO_ID_FS			26 /* virtio filesystem */
+#define VIRTIO_ID_PMEM			27 /* virtio pmem */
+#define VIRTIO_ID_RPMB			28 /* virtio rpmb */
+#define VIRTIO_ID_MAC80211_HWSIM	29 /* virtio mac80211-hwsim */
+#define VIRTIO_ID_VIDEO_ENCODER		30 /* virtio video encoder */
+#define VIRTIO_ID_VIDEO_DECODER		31 /* virtio video decoder */
+#define VIRTIO_ID_SCMI			32 /* virtio SCMI */
+#define VIRTIO_ID_NITRO_SEC_MOD		33 /* virtio nitro secure module*/
+#define VIRTIO_ID_I2C_ADAPTER		34 /* virtio i2c adapter */
+#define VIRTIO_ID_WATCHDOG		35 /* virtio watchdog */
+#define VIRTIO_ID_CAN			36 /* virtio can */
+#define VIRTIO_ID_DMABUF		37 /* virtio dmabuf */
+#define VIRTIO_ID_PARAM_SERV		38 /* virtio parameter server */
+#define VIRTIO_ID_AUDIO_POLICY		39 /* virtio audio policy */
+#define VIRTIO_ID_BT			40 /* virtio bluetooth */
+#define VIRTIO_ID_GPIO			41 /* virtio gpio */
+
+/*
+ * Virtio Transitional IDs
+ */
+
+#define VIRTIO_TRANS_ID_NET		1000 /* transitional virtio net */
+#define VIRTIO_TRANS_ID_BLOCK		1001 /* transitional virtio block */
+#define VIRTIO_TRANS_ID_BALLOON		1002 /* transitional virtio balloon */
+#define VIRTIO_TRANS_ID_CONSOLE		1003 /* transitional virtio console */
+#define VIRTIO_TRANS_ID_SCSI		1004 /* transitional virtio SCSI */
+#define VIRTIO_TRANS_ID_RNG		1005 /* transitional virtio rng */
+#define VIRTIO_TRANS_ID_9P		1009 /* transitional virtio 9p console */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 172a7f00..3f55a421 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -1,5 +1,5 @@
-#ifndef _LINUX_VIRTIO_NET_H
-#define _LINUX_VIRTIO_NET_H
+#ifndef _UAPI_LINUX_VIRTIO_NET_H
+#define _UAPI_LINUX_VIRTIO_NET_H
 /* This header is BSD licensed so anyone can use the definitions to implement
  * compatible drivers/servers.
  *
@@ -28,13 +28,15 @@
 #include <linux/types.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
+#include <linux/virtio_types.h>
 #include <linux/if_ether.h>
 
 /* The feature bitmap for virtio net */
 #define VIRTIO_NET_F_CSUM	0	/* Host handles pkts w/ partial csum */
 #define VIRTIO_NET_F_GUEST_CSUM	1	/* Guest handles pkts w/ partial csum */
+#define VIRTIO_NET_F_CTRL_GUEST_OFFLOADS 2 /* Dynamic offload configuration. */
+#define VIRTIO_NET_F_MTU	3	/* Initial MTU advice */
 #define VIRTIO_NET_F_MAC	5	/* Host has given MAC address. */
-#define VIRTIO_NET_F_GSO	6	/* Host handles pkts w/ any GSO type */
 #define VIRTIO_NET_F_GUEST_TSO4	7	/* Guest can handle TSOv4 in. */
 #define VIRTIO_NET_F_GUEST_TSO6	8	/* Guest can handle TSOv6 in. */
 #define VIRTIO_NET_F_GUEST_ECN	9	/* Guest can handle TSO[6] w/ ECN in. */
@@ -55,47 +57,146 @@
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
 
+#define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
+#define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
+#define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
+#define VIRTIO_NET_F_STANDBY	  62	/* Act as standby for another device
+					 * with the same MAC.
+					 */
+#define VIRTIO_NET_F_SPEED_DUPLEX 63	/* Device set linkspeed and duplex */
+
+#ifndef VIRTIO_NET_NO_LEGACY
+#define VIRTIO_NET_F_GSO	6	/* Host handles pkts w/ any GSO type */
+#endif /* VIRTIO_NET_NO_LEGACY */
+
 #define VIRTIO_NET_S_LINK_UP	1	/* Link is up */
 #define VIRTIO_NET_S_ANNOUNCE	2	/* Announcement is needed */
 
+/* supported/enabled hash types */
+#define VIRTIO_NET_RSS_HASH_TYPE_IPv4          (1 << 0)
+#define VIRTIO_NET_RSS_HASH_TYPE_TCPv4         (1 << 1)
+#define VIRTIO_NET_RSS_HASH_TYPE_UDPv4         (1 << 2)
+#define VIRTIO_NET_RSS_HASH_TYPE_IPv6          (1 << 3)
+#define VIRTIO_NET_RSS_HASH_TYPE_TCPv6         (1 << 4)
+#define VIRTIO_NET_RSS_HASH_TYPE_UDPv6         (1 << 5)
+#define VIRTIO_NET_RSS_HASH_TYPE_IP_EX         (1 << 6)
+#define VIRTIO_NET_RSS_HASH_TYPE_TCP_EX        (1 << 7)
+#define VIRTIO_NET_RSS_HASH_TYPE_UDP_EX        (1 << 8)
+
 struct virtio_net_config {
 	/* The config defining mac address (if VIRTIO_NET_F_MAC) */
 	__u8 mac[ETH_ALEN];
 	/* See VIRTIO_NET_F_STATUS and VIRTIO_NET_S_* above */
-	__u16 status;
+	__virtio16 status;
 	/* Maximum number of each of transmit and receive queues;
 	 * see VIRTIO_NET_F_MQ and VIRTIO_NET_CTRL_MQ.
 	 * Legal values are between 1 and 0x8000
 	 */
-	__u16 max_virtqueue_pairs;
+	__virtio16 max_virtqueue_pairs;
+	/* Default maximum transmit unit advice */
+	__virtio16 mtu;
+	/*
+	 * speed, in units of 1Mb. All values 0 to INT_MAX are legal.
+	 * Any other value stands for unknown.
+	 */
+	__le32 speed;
+	/*
+	 * 0x00 - half duplex
+	 * 0x01 - full duplex
+	 * Any other value stands for unknown.
+	 */
+	__u8 duplex;
+	/* maximum size of RSS key */
+	__u8 rss_max_key_size;
+	/* maximum number of indirection table entries */
+	__le16 rss_max_indirection_table_length;
+	/* bitmask of supported VIRTIO_NET_RSS_HASH_ types */
+	__le32 supported_hash_types;
 } __attribute__((packed));
 
+/*
+ * This header comes first in the scatter-gather list.  If you don't
+ * specify GSO or CSUM features, you can simply ignore the header.
+ *
+ * This is bitwise-equivalent to the legacy struct virtio_net_hdr_mrg_rxbuf,
+ * only flattened.
+ */
+struct virtio_net_hdr_v1 {
+#define VIRTIO_NET_HDR_F_NEEDS_CSUM	1	/* Use csum_start, csum_offset */
+#define VIRTIO_NET_HDR_F_DATA_VALID	2	/* Csum is valid */
+#define VIRTIO_NET_HDR_F_RSC_INFO	4	/* rsc info in csum_ fields */
+	__u8 flags;
+#define VIRTIO_NET_HDR_GSO_NONE		0	/* Not a GSO frame */
+#define VIRTIO_NET_HDR_GSO_TCPV4	1	/* GSO frame, IPv4 TCP (TSO) */
+#define VIRTIO_NET_HDR_GSO_UDP		3	/* GSO frame, IPv4 UDP (UFO) */
+#define VIRTIO_NET_HDR_GSO_TCPV6	4	/* GSO frame, IPv6 TCP */
+#define VIRTIO_NET_HDR_GSO_ECN		0x80	/* TCP has ECN set */
+	__u8 gso_type;
+	__virtio16 hdr_len;	/* Ethernet + IP + tcp/udp hdrs */
+	__virtio16 gso_size;	/* Bytes to append to hdr_len per frame */
+	union {
+		struct {
+			__virtio16 csum_start;
+			__virtio16 csum_offset;
+		};
+		/* Checksum calculation */
+		struct {
+			/* Position to start checksumming from */
+			__virtio16 start;
+			/* Offset after that to place checksum */
+			__virtio16 offset;
+		} csum;
+		/* Receive Segment Coalescing */
+		struct {
+			/* Number of coalesced segments */
+			__le16 segments;
+			/* Number of duplicated acks */
+			__le16 dup_acks;
+		} rsc;
+	};
+	__virtio16 num_buffers;	/* Number of merged rx buffers */
+};
+
+struct virtio_net_hdr_v1_hash {
+	struct virtio_net_hdr_v1 hdr;
+	__le32 hash_value;
+#define VIRTIO_NET_HASH_REPORT_NONE            0
+#define VIRTIO_NET_HASH_REPORT_IPv4            1
+#define VIRTIO_NET_HASH_REPORT_TCPv4           2
+#define VIRTIO_NET_HASH_REPORT_UDPv4           3
+#define VIRTIO_NET_HASH_REPORT_IPv6            4
+#define VIRTIO_NET_HASH_REPORT_TCPv6           5
+#define VIRTIO_NET_HASH_REPORT_UDPv6           6
+#define VIRTIO_NET_HASH_REPORT_IPv6_EX         7
+#define VIRTIO_NET_HASH_REPORT_TCPv6_EX        8
+#define VIRTIO_NET_HASH_REPORT_UDPv6_EX        9
+	__le16 hash_report;
+	__le16 padding;
+};
+
+#ifndef VIRTIO_NET_NO_LEGACY
 /* This header comes first in the scatter-gather list.
- * If VIRTIO_F_ANY_LAYOUT is not negotiated, it must
+ * For legacy virtio, if VIRTIO_F_ANY_LAYOUT is not negotiated, it must
  * be the first element of the scatter-gather list.  If you don't
  * specify GSO or CSUM features, you can simply ignore the header. */
 struct virtio_net_hdr {
-#define VIRTIO_NET_HDR_F_NEEDS_CSUM	1	// Use csum_start, csum_offset
-#define VIRTIO_NET_HDR_F_DATA_VALID	2	// Csum is valid
+	/* See VIRTIO_NET_HDR_F_* */
 	__u8 flags;
-#define VIRTIO_NET_HDR_GSO_NONE		0	// Not a GSO frame
-#define VIRTIO_NET_HDR_GSO_TCPV4	1	// GSO frame, IPv4 TCP (TSO)
-#define VIRTIO_NET_HDR_GSO_UDP		3	// GSO frame, IPv4 UDP (UFO)
-#define VIRTIO_NET_HDR_GSO_TCPV6	4	// GSO frame, IPv6 TCP
-#define VIRTIO_NET_HDR_GSO_ECN		0x80	// TCP has ECN set
+	/* See VIRTIO_NET_HDR_GSO_* */
 	__u8 gso_type;
-	__u16 hdr_len;		/* Ethernet + IP + tcp/udp hdrs */
-	__u16 gso_size;		/* Bytes to append to hdr_len per frame */
-	__u16 csum_start;	/* Position to start checksumming from */
-	__u16 csum_offset;	/* Offset after that to place checksum */
+	__virtio16 hdr_len;		/* Ethernet + IP + tcp/udp hdrs */
+	__virtio16 gso_size;		/* Bytes to append to hdr_len per frame */
+	__virtio16 csum_start;	/* Position to start checksumming from */
+	__virtio16 csum_offset;	/* Offset after that to place checksum */
 };
 
 /* This is the version of the header to use when the MRG_RXBUF
  * feature has been negotiated. */
 struct virtio_net_hdr_mrg_rxbuf {
 	struct virtio_net_hdr hdr;
-	__u16 num_buffers;	/* Number of merged rx buffers */
+	__virtio16 num_buffers;	/* Number of merged rx buffers */
 };
+#endif /* ...VIRTIO_NET_NO_LEGACY */
 
 /*
  * Control virtqueue data structures
@@ -149,7 +250,7 @@ typedef __u8 virtio_net_ctrl_ack;
  * VIRTIO_NET_F_CTRL_MAC_ADDR feature is available.
  */
 struct virtio_net_ctrl_mac {
-	__u32 entries;
+	__virtio32 entries;
 	__u8 macs[][ETH_ALEN];
 } __attribute__((packed));
 
@@ -183,7 +284,9 @@ struct virtio_net_ctrl_mac {
 
 /*
  * Control Receive Flow Steering
- *
+ */
+#define VIRTIO_NET_CTRL_MQ   4
+/*
  * The command VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET
  * enables Receive Flow Steering, specifying the number of the transmit and
  * receive queues that will be used. After the command is consumed and acked by
@@ -193,12 +296,63 @@ struct virtio_net_ctrl_mac {
  * specified.
  */
 struct virtio_net_ctrl_mq {
-	__u16 virtqueue_pairs;
+	__virtio16 virtqueue_pairs;
 };
 
-#define VIRTIO_NET_CTRL_MQ   4
  #define VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET        0
  #define VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN        1
  #define VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MAX        0x8000
 
-#endif /* _LINUX_VIRTIO_NET_H */
+/*
+ * The command VIRTIO_NET_CTRL_MQ_RSS_CONFIG has the same effect as
+ * VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET does and additionally configures
+ * the receive steering to use a hash calculated for incoming packet
+ * to decide on receive virtqueue to place the packet. The command
+ * also provides parameters to calculate a hash and receive virtqueue.
+ */
+struct virtio_net_rss_config {
+	__le32 hash_types;
+	__le16 indirection_table_mask;
+	__le16 unclassified_queue;
+	__le16 indirection_table[1/* + indirection_table_mask */];
+	__le16 max_tx_vq;
+	__u8 hash_key_length;
+	__u8 hash_key_data[/* hash_key_length */];
+};
+
+ #define VIRTIO_NET_CTRL_MQ_RSS_CONFIG          1
+
+/*
+ * The command VIRTIO_NET_CTRL_MQ_HASH_CONFIG requests the device
+ * to include in the virtio header of the packet the value of the
+ * calculated hash and the report type of hash. It also provides
+ * parameters for hash calculation. The command requires feature
+ * VIRTIO_NET_F_HASH_REPORT to be negotiated to extend the
+ * layout of virtio header as defined in virtio_net_hdr_v1_hash.
+ */
+struct virtio_net_hash_config {
+	__le32 hash_types;
+	/* for compatibility with virtio_net_rss_config */
+	__le16 reserved[4];
+	__u8 hash_key_length;
+	__u8 hash_key_data[/* hash_key_length */];
+};
+
+ #define VIRTIO_NET_CTRL_MQ_HASH_CONFIG         2
+
+/*
+ * Control network offloads
+ *
+ * Reconfigures the network offloads that Guest can handle.
+ *
+ * Available with the VIRTIO_NET_F_CTRL_GUEST_OFFLOADS feature bit.
+ *
+ * Command data format matches the feature bit mask exactly.
+ *
+ * See VIRTIO_NET_F_GUEST_* for the list of offloads
+ * that can be enabled/disabled.
+ */
+#define VIRTIO_NET_CTRL_GUEST_OFFLOADS   5
+#define VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET        0
+
+#endif /* _UAPI_LINUX_VIRTIO_NET_H */
diff --git a/include/linux/virtio_scsi.h b/include/linux/virtio_scsi.h
index de429d1f..0abaae40 100644
--- a/include/linux/virtio_scsi.h
+++ b/include/linux/virtio_scsi.h
@@ -27,83 +27,93 @@
 #ifndef _LINUX_VIRTIO_SCSI_H
 #define _LINUX_VIRTIO_SCSI_H
 
-#define VIRTIO_SCSI_CDB_SIZE   32
-#define VIRTIO_SCSI_SENSE_SIZE 96
+#include <linux/virtio_types.h>
+
+/* Default values of the CDB and sense data size configuration fields */
+#define VIRTIO_SCSI_CDB_DEFAULT_SIZE   32
+#define VIRTIO_SCSI_SENSE_DEFAULT_SIZE 96
+
+#ifndef VIRTIO_SCSI_CDB_SIZE
+#define VIRTIO_SCSI_CDB_SIZE VIRTIO_SCSI_CDB_DEFAULT_SIZE
+#endif
+#ifndef VIRTIO_SCSI_SENSE_SIZE
+#define VIRTIO_SCSI_SENSE_SIZE VIRTIO_SCSI_SENSE_DEFAULT_SIZE
+#endif
 
 /* SCSI command request, followed by data-out */
 struct virtio_scsi_cmd_req {
-	u8 lun[8];		/* Logical Unit Number */
-	u64 tag;		/* Command identifier */
-	u8 task_attr;		/* Task attribute */
-	u8 prio;		/* SAM command priority field */
-	u8 crn;
-	u8 cdb[VIRTIO_SCSI_CDB_SIZE];
-} __packed;
+	__u8 lun[8];		/* Logical Unit Number */
+	__virtio64 tag;		/* Command identifier */
+	__u8 task_attr;		/* Task attribute */
+	__u8 prio;		/* SAM command priority field */
+	__u8 crn;
+	__u8 cdb[VIRTIO_SCSI_CDB_SIZE];
+} __attribute__((packed));
 
 /* SCSI command request, followed by protection information */
 struct virtio_scsi_cmd_req_pi {
-	u8 lun[8];		/* Logical Unit Number */
-	u64 tag;		/* Command identifier */
-	u8 task_attr;		/* Task attribute */
-	u8 prio;		/* SAM command priority field */
-	u8 crn;
-	u32 pi_bytesout;	/* DataOUT PI Number of bytes */
-	u32 pi_bytesin;		/* DataIN PI Number of bytes */
-	u8 cdb[VIRTIO_SCSI_CDB_SIZE];
-} __packed;
+	__u8 lun[8];		/* Logical Unit Number */
+	__virtio64 tag;		/* Command identifier */
+	__u8 task_attr;		/* Task attribute */
+	__u8 prio;		/* SAM command priority field */
+	__u8 crn;
+	__virtio32 pi_bytesout;	/* DataOUT PI Number of bytes */
+	__virtio32 pi_bytesin;		/* DataIN PI Number of bytes */
+	__u8 cdb[VIRTIO_SCSI_CDB_SIZE];
+} __attribute__((packed));
 
 /* Response, followed by sense data and data-in */
 struct virtio_scsi_cmd_resp {
-	u32 sense_len;		/* Sense data length */
-	u32 resid;		/* Residual bytes in data buffer */
-	u16 status_qualifier;	/* Status qualifier */
-	u8 status;		/* Command completion status */
-	u8 response;		/* Response values */
-	u8 sense[VIRTIO_SCSI_SENSE_SIZE];
-} __packed;
+	__virtio32 sense_len;		/* Sense data length */
+	__virtio32 resid;		/* Residual bytes in data buffer */
+	__virtio16 status_qualifier;	/* Status qualifier */
+	__u8 status;		/* Command completion status */
+	__u8 response;		/* Response values */
+	__u8 sense[VIRTIO_SCSI_SENSE_SIZE];
+} __attribute__((packed));
 
 /* Task Management Request */
 struct virtio_scsi_ctrl_tmf_req {
-	u32 type;
-	u32 subtype;
-	u8 lun[8];
-	u64 tag;
-} __packed;
+	__virtio32 type;
+	__virtio32 subtype;
+	__u8 lun[8];
+	__virtio64 tag;
+} __attribute__((packed));
 
 struct virtio_scsi_ctrl_tmf_resp {
-	u8 response;
-} __packed;
+	__u8 response;
+} __attribute__((packed));
 
 /* Asynchronous notification query/subscription */
 struct virtio_scsi_ctrl_an_req {
-	u32 type;
-	u8 lun[8];
-	u32 event_requested;
-} __packed;
+	__virtio32 type;
+	__u8 lun[8];
+	__virtio32 event_requested;
+} __attribute__((packed));
 
 struct virtio_scsi_ctrl_an_resp {
-	u32 event_actual;
-	u8 response;
-} __packed;
+	__virtio32 event_actual;
+	__u8 response;
+} __attribute__((packed));
 
 struct virtio_scsi_event {
-	u32 event;
-	u8 lun[8];
-	u32 reason;
-} __packed;
+	__virtio32 event;
+	__u8 lun[8];
+	__virtio32 reason;
+} __attribute__((packed));
 
 struct virtio_scsi_config {
-	u32 num_queues;
-	u32 seg_max;
-	u32 max_sectors;
-	u32 cmd_per_lun;
-	u32 event_info_size;
-	u32 sense_size;
-	u32 cdb_size;
-	u16 max_channel;
-	u16 max_target;
-	u32 max_lun;
-} __packed;
+	__virtio32 num_queues;
+	__virtio32 seg_max;
+	__virtio32 max_sectors;
+	__virtio32 cmd_per_lun;
+	__virtio32 event_info_size;
+	__virtio32 sense_size;
+	__virtio32 cdb_size;
+	__virtio16 max_channel;
+	__virtio16 max_target;
+	__virtio32 max_lun;
+} __attribute__((packed));
 
 /* Feature Bits */
 #define VIRTIO_SCSI_F_INOUT                    0
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 20b453e5..64738838 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -31,13 +31,16 @@
  * Copyright (C) Stefan Hajnoczi <stefanha@redhat.com>, 2015
  */
 
-#ifndef _LINUX_VIRTIO_VSOCK_H
-#define _LINUX_VIRTIO_VSOCK_H
+#ifndef _UAPI_LINUX_VIRTIO_VSOCK_H
+#define _UAPI_LINUX_VIRTIO_VSOCK_H
 
 #include <linux/types.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 
+/* The feature bitmap for virtio vsock */
+#define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
+
 struct virtio_vsock_config {
 	__le64 guest_cid;
 } __attribute__((packed));
@@ -65,6 +68,7 @@ struct virtio_vsock_hdr {
 
 enum virtio_vsock_type {
 	VIRTIO_VSOCK_TYPE_STREAM = 1,
+	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
 };
 
 enum virtio_vsock_op {
@@ -91,4 +95,10 @@ enum virtio_vsock_shutdown {
 	VIRTIO_VSOCK_SHUTDOWN_SEND = 2,
 };
 
-#endif /* _LINUX_VIRTIO_VSOCK_H */
+/* VIRTIO_VSOCK_OP_RW flags values */
+enum virtio_vsock_rw {
+	VIRTIO_VSOCK_SEQ_EOM = 1,
+	VIRTIO_VSOCK_SEQ_EOR = 2,
+};
+
+#endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
-- 
2.25.1

