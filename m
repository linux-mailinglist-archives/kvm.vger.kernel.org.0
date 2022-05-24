Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB15532CEF
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 17:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238659AbiEXPGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 11:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238717AbiEXPGe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 11:06:34 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B3144101EA
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 08:06:25 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4BF5423A;
        Tue, 24 May 2022 08:06:25 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B855E3F70D;
        Tue, 24 May 2022 08:06:23 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Keir Fraser <keirf@google.com>
Subject: [PATCH kvmtool 4/4] include: add new virtio uapi header files
Date:   Tue, 24 May 2022 16:06:11 +0100
Message-Id: <20220524150611.523910-5-andre.przywara@arm.com>
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
copied in some of the virtio UAPI headers from the kernel tree, but
didn't include all of them, as we were relying on some of them being
provided by the distribution.

Now commit bc77bf49df6e ("stat: Add descriptions for new virtio_balloon
stat types") used some newer virtio balloon symbols, that some older
distros (e.g. Ubuntu 18.04) do not carry, which breaks compilation
there:
=======================
  CC       builtin-stat.o
builtin-stat.c: In function 'do_memstat':
builtin-stat.c:86:8: error: 'VIRTIO_BALLOON_S_HTLB_PGALLOC' undeclared (first use in this function); did you mean 'VIRTIO_BALLOON_S_AVAIL'?
   case VIRTIO_BALLOON_S_HTLB_PGALLOC:
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        VIRTIO_BALLOON_S_AVAIL
builtin-stat.c:86:8: note: each undeclared identifier is reported only once for each function it appears in
=======================

To fix this include the remaining virtio headers (those that we actually
need for kvmtool at the moment), from Linux v5.18.0.

Fixes: bc77bf49df6e ("stat: Add descriptions for new virtio_balloon stat types")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/linux/virtio_9p.h      |  44 ++++++
 include/linux/virtio_balloon.h | 119 ++++++++++++++++
 include/linux/virtio_blk.h     | 203 +++++++++++++++++++++++++++
 include/linux/virtio_config.h  | 101 ++++++++++++++
 include/linux/virtio_console.h |  78 +++++++++++
 include/linux/virtio_pci.h     | 208 ++++++++++++++++++++++++++++
 include/linux/virtio_ring.h    | 244 +++++++++++++++++++++++++++++++++
 include/linux/virtio_rng.h     |   8 ++
 8 files changed, 1005 insertions(+)
 create mode 100644 include/linux/virtio_9p.h
 create mode 100644 include/linux/virtio_balloon.h
 create mode 100644 include/linux/virtio_blk.h
 create mode 100644 include/linux/virtio_config.h
 create mode 100644 include/linux/virtio_console.h
 create mode 100644 include/linux/virtio_pci.h
 create mode 100644 include/linux/virtio_ring.h
 create mode 100644 include/linux/virtio_rng.h

diff --git a/include/linux/virtio_9p.h b/include/linux/virtio_9p.h
new file mode 100644
index 00000000..44104743
--- /dev/null
+++ b/include/linux/virtio_9p.h
@@ -0,0 +1,44 @@
+#ifndef _LINUX_VIRTIO_9P_H
+#define _LINUX_VIRTIO_9P_H
+/* This header is BSD licensed so anyone can use the definitions to implement
+ * compatible drivers/servers.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the name of IBM nor the names of its contributors
+ *    may be used to endorse or promote products derived from this software
+ *    without specific prior written permission.
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE. */
+#include <linux/virtio_types.h>
+#include <linux/virtio_ids.h>
+#include <linux/virtio_config.h>
+
+/* The feature bitmap for virtio 9P */
+
+/* The mount point is specified in a config variable */
+#define VIRTIO_9P_MOUNT_TAG 0
+
+struct virtio_9p_config {
+	/* length of the tag name */
+	__virtio16 tag_len;
+	/* non-NULL terminated tag name */
+	__u8 tag[0];
+} __attribute__((packed));
+
+#endif /* _LINUX_VIRTIO_9P_H */
diff --git a/include/linux/virtio_balloon.h b/include/linux/virtio_balloon.h
new file mode 100644
index 00000000..ddaa45e7
--- /dev/null
+++ b/include/linux/virtio_balloon.h
@@ -0,0 +1,119 @@
+#ifndef _LINUX_VIRTIO_BALLOON_H
+#define _LINUX_VIRTIO_BALLOON_H
+/* This header is BSD licensed so anyone can use the definitions to implement
+ * compatible drivers/servers.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the name of IBM nor the names of its contributors
+ *    may be used to endorse or promote products derived from this software
+ *    without specific prior written permission.
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE. */
+#include <linux/types.h>
+#include <linux/virtio_types.h>
+#include <linux/virtio_ids.h>
+#include <linux/virtio_config.h>
+
+/* The feature bitmap for virtio balloon */
+#define VIRTIO_BALLOON_F_MUST_TELL_HOST	0 /* Tell before reclaiming pages */
+#define VIRTIO_BALLOON_F_STATS_VQ	1 /* Memory Stats virtqueue */
+#define VIRTIO_BALLOON_F_DEFLATE_ON_OOM	2 /* Deflate balloon on OOM */
+#define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
+#define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
+#define VIRTIO_BALLOON_F_REPORTING	5 /* Page reporting virtqueue */
+
+/* Size of a PFN in the balloon interface. */
+#define VIRTIO_BALLOON_PFN_SHIFT 12
+
+#define VIRTIO_BALLOON_CMD_ID_STOP	0
+#define VIRTIO_BALLOON_CMD_ID_DONE	1
+struct virtio_balloon_config {
+	/* Number of pages host wants Guest to give up. */
+	__le32 num_pages;
+	/* Number of pages we've actually got in balloon. */
+	__le32 actual;
+	/*
+	 * Free page hint command id, readonly by guest.
+	 * Was previously named free_page_report_cmd_id so we
+	 * need to carry that name for legacy support.
+	 */
+	union {
+		__le32 free_page_hint_cmd_id;
+		__le32 free_page_report_cmd_id;	/* deprecated */
+	};
+	/* Stores PAGE_POISON if page poisoning is in use */
+	__le32 poison_val;
+};
+
+#define VIRTIO_BALLOON_S_SWAP_IN  0   /* Amount of memory swapped in */
+#define VIRTIO_BALLOON_S_SWAP_OUT 1   /* Amount of memory swapped out */
+#define VIRTIO_BALLOON_S_MAJFLT   2   /* Number of major faults */
+#define VIRTIO_BALLOON_S_MINFLT   3   /* Number of minor faults */
+#define VIRTIO_BALLOON_S_MEMFREE  4   /* Total amount of free memory */
+#define VIRTIO_BALLOON_S_MEMTOT   5   /* Total amount of memory */
+#define VIRTIO_BALLOON_S_AVAIL    6   /* Available memory as in /proc */
+#define VIRTIO_BALLOON_S_CACHES   7   /* Disk caches */
+#define VIRTIO_BALLOON_S_HTLB_PGALLOC  8  /* Hugetlb page allocations */
+#define VIRTIO_BALLOON_S_HTLB_PGFAIL   9  /* Hugetlb page allocation failures */
+#define VIRTIO_BALLOON_S_NR       10
+
+#define VIRTIO_BALLOON_S_NAMES_WITH_PREFIX(VIRTIO_BALLOON_S_NAMES_prefix) { \
+	VIRTIO_BALLOON_S_NAMES_prefix "swap-in", \
+	VIRTIO_BALLOON_S_NAMES_prefix "swap-out", \
+	VIRTIO_BALLOON_S_NAMES_prefix "major-faults", \
+	VIRTIO_BALLOON_S_NAMES_prefix "minor-faults", \
+	VIRTIO_BALLOON_S_NAMES_prefix "free-memory", \
+	VIRTIO_BALLOON_S_NAMES_prefix "total-memory", \
+	VIRTIO_BALLOON_S_NAMES_prefix "available-memory", \
+	VIRTIO_BALLOON_S_NAMES_prefix "disk-caches", \
+	VIRTIO_BALLOON_S_NAMES_prefix "hugetlb-allocations", \
+	VIRTIO_BALLOON_S_NAMES_prefix "hugetlb-failures" \
+}
+
+#define VIRTIO_BALLOON_S_NAMES VIRTIO_BALLOON_S_NAMES_WITH_PREFIX("")
+
+/*
+ * Memory statistics structure.
+ * Driver fills an array of these structures and passes to device.
+ *
+ * NOTE: fields are laid out in a way that would make compiler add padding
+ * between and after fields, so we have to use compiler-specific attributes to
+ * pack it, to disable this padding. This also often causes compiler to
+ * generate suboptimal code.
+ *
+ * We maintain this statistics structure format for backwards compatibility,
+ * but don't follow this example.
+ *
+ * If implementing a similar structure, do something like the below instead:
+ *     struct virtio_balloon_stat {
+ *         __virtio16 tag;
+ *         __u8 reserved[6];
+ *         __virtio64 val;
+ *     };
+ *
+ * In other words, add explicit reserved fields to align field and
+ * structure boundaries at field size, avoiding compiler padding
+ * without the packed attribute.
+ */
+struct virtio_balloon_stat {
+	__virtio16 tag;
+	__virtio64 val;
+} __attribute__((packed));
+
+#endif /* _LINUX_VIRTIO_BALLOON_H */
diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h
new file mode 100644
index 00000000..d888f013
--- /dev/null
+++ b/include/linux/virtio_blk.h
@@ -0,0 +1,203 @@
+#ifndef _LINUX_VIRTIO_BLK_H
+#define _LINUX_VIRTIO_BLK_H
+/* This header is BSD licensed so anyone can use the definitions to implement
+ * compatible drivers/servers.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the name of IBM nor the names of its contributors
+ *    may be used to endorse or promote products derived from this software
+ *    without specific prior written permission.
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE. */
+#include <linux/types.h>
+#include <linux/virtio_ids.h>
+#include <linux/virtio_config.h>
+#include <linux/virtio_types.h>
+
+/* Feature bits */
+#define VIRTIO_BLK_F_SIZE_MAX	1	/* Indicates maximum segment size */
+#define VIRTIO_BLK_F_SEG_MAX	2	/* Indicates maximum # of segments */
+#define VIRTIO_BLK_F_GEOMETRY	4	/* Legacy geometry available  */
+#define VIRTIO_BLK_F_RO		5	/* Disk is read-only */
+#define VIRTIO_BLK_F_BLK_SIZE	6	/* Block size of disk is available*/
+#define VIRTIO_BLK_F_TOPOLOGY	10	/* Topology information is available */
+#define VIRTIO_BLK_F_MQ		12	/* support more than one vq */
+#define VIRTIO_BLK_F_DISCARD	13	/* DISCARD is supported */
+#define VIRTIO_BLK_F_WRITE_ZEROES	14	/* WRITE ZEROES is supported */
+
+/* Legacy feature bits */
+#ifndef VIRTIO_BLK_NO_LEGACY
+#define VIRTIO_BLK_F_BARRIER	0	/* Does host support barriers? */
+#define VIRTIO_BLK_F_SCSI	7	/* Supports scsi command passthru */
+#define VIRTIO_BLK_F_FLUSH	9	/* Flush command supported */
+#define VIRTIO_BLK_F_CONFIG_WCE	11	/* Writeback mode available in config */
+#ifndef __KERNEL__
+/* Old (deprecated) name for VIRTIO_BLK_F_FLUSH. */
+#define VIRTIO_BLK_F_WCE VIRTIO_BLK_F_FLUSH
+#endif
+#endif /* !VIRTIO_BLK_NO_LEGACY */
+
+#define VIRTIO_BLK_ID_BYTES	20	/* ID string length */
+
+struct virtio_blk_config {
+	/* The capacity (in 512-byte sectors). */
+	__virtio64 capacity;
+	/* The maximum segment size (if VIRTIO_BLK_F_SIZE_MAX) */
+	__virtio32 size_max;
+	/* The maximum number of segments (if VIRTIO_BLK_F_SEG_MAX) */
+	__virtio32 seg_max;
+	/* geometry of the device (if VIRTIO_BLK_F_GEOMETRY) */
+	struct virtio_blk_geometry {
+		__virtio16 cylinders;
+		__u8 heads;
+		__u8 sectors;
+	} geometry;
+
+	/* block size of device (if VIRTIO_BLK_F_BLK_SIZE) */
+	__virtio32 blk_size;
+
+	/* the next 4 entries are guarded by VIRTIO_BLK_F_TOPOLOGY  */
+	/* exponent for physical block per logical block. */
+	__u8 physical_block_exp;
+	/* alignment offset in logical blocks. */
+	__u8 alignment_offset;
+	/* minimum I/O size without performance penalty in logical blocks. */
+	__virtio16 min_io_size;
+	/* optimal sustained I/O size in logical blocks. */
+	__virtio32 opt_io_size;
+
+	/* writeback mode (if VIRTIO_BLK_F_CONFIG_WCE) */
+	__u8 wce;
+	__u8 unused;
+
+	/* number of vqs, only available when VIRTIO_BLK_F_MQ is set */
+	__virtio16 num_queues;
+
+	/* the next 3 entries are guarded by VIRTIO_BLK_F_DISCARD */
+	/*
+	 * The maximum discard sectors (in 512-byte sectors) for
+	 * one segment.
+	 */
+	__virtio32 max_discard_sectors;
+	/*
+	 * The maximum number of discard segments in a
+	 * discard command.
+	 */
+	__virtio32 max_discard_seg;
+	/* Discard commands must be aligned to this number of sectors. */
+	__virtio32 discard_sector_alignment;
+
+	/* the next 3 entries are guarded by VIRTIO_BLK_F_WRITE_ZEROES */
+	/*
+	 * The maximum number of write zeroes sectors (in 512-byte sectors) in
+	 * one segment.
+	 */
+	__virtio32 max_write_zeroes_sectors;
+	/*
+	 * The maximum number of segments in a write zeroes
+	 * command.
+	 */
+	__virtio32 max_write_zeroes_seg;
+	/*
+	 * Set if a VIRTIO_BLK_T_WRITE_ZEROES request may result in the
+	 * deallocation of one or more of the sectors.
+	 */
+	__u8 write_zeroes_may_unmap;
+
+	__u8 unused1[3];
+} __attribute__((packed));
+
+/*
+ * Command types
+ *
+ * Usage is a bit tricky as some bits are used as flags and some are not.
+ *
+ * Rules:
+ *   VIRTIO_BLK_T_OUT may be combined with VIRTIO_BLK_T_SCSI_CMD or
+ *   VIRTIO_BLK_T_BARRIER.  VIRTIO_BLK_T_FLUSH is a command of its own
+ *   and may not be combined with any of the other flags.
+ */
+
+/* These two define direction. */
+#define VIRTIO_BLK_T_IN		0
+#define VIRTIO_BLK_T_OUT	1
+
+#ifndef VIRTIO_BLK_NO_LEGACY
+/* This bit says it's a scsi command, not an actual read or write. */
+#define VIRTIO_BLK_T_SCSI_CMD	2
+#endif /* VIRTIO_BLK_NO_LEGACY */
+
+/* Cache flush command */
+#define VIRTIO_BLK_T_FLUSH	4
+
+/* Get device ID command */
+#define VIRTIO_BLK_T_GET_ID    8
+
+/* Discard command */
+#define VIRTIO_BLK_T_DISCARD	11
+
+/* Write zeroes command */
+#define VIRTIO_BLK_T_WRITE_ZEROES	13
+
+#ifndef VIRTIO_BLK_NO_LEGACY
+/* Barrier before this op. */
+#define VIRTIO_BLK_T_BARRIER	0x80000000
+#endif /* !VIRTIO_BLK_NO_LEGACY */
+
+/*
+ * This comes first in the read scatter-gather list.
+ * For legacy virtio, if VIRTIO_F_ANY_LAYOUT is not negotiated,
+ * this is the first element of the read scatter-gather list.
+ */
+struct virtio_blk_outhdr {
+	/* VIRTIO_BLK_T* */
+	__virtio32 type;
+	/* io priority. */
+	__virtio32 ioprio;
+	/* Sector (ie. 512 byte offset) */
+	__virtio64 sector;
+};
+
+/* Unmap this range (only valid for write zeroes command) */
+#define VIRTIO_BLK_WRITE_ZEROES_FLAG_UNMAP	0x00000001
+
+/* Discard/write zeroes range for each request. */
+struct virtio_blk_discard_write_zeroes {
+	/* discard/write zeroes start sector */
+	__le64 sector;
+	/* number of discard/write zeroes sectors */
+	__le32 num_sectors;
+	/* flags for this range */
+	__le32 flags;
+};
+
+#ifndef VIRTIO_BLK_NO_LEGACY
+struct virtio_scsi_inhdr {
+	__virtio32 errors;
+	__virtio32 data_len;
+	__virtio32 sense_len;
+	__virtio32 residual;
+};
+#endif /* !VIRTIO_BLK_NO_LEGACY */
+
+/* And this is the final byte of the write scatter-gather list. */
+#define VIRTIO_BLK_S_OK		0
+#define VIRTIO_BLK_S_IOERR	1
+#define VIRTIO_BLK_S_UNSUPP	2
+#endif /* _LINUX_VIRTIO_BLK_H */
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
new file mode 100644
index 00000000..f0fb0ae0
--- /dev/null
+++ b/include/linux/virtio_config.h
@@ -0,0 +1,101 @@
+#ifndef _UAPI_LINUX_VIRTIO_CONFIG_H
+#define _UAPI_LINUX_VIRTIO_CONFIG_H
+/* This header, excluding the #ifdef __KERNEL__ part, is BSD licensed so
+ * anyone can use the definitions to implement compatible drivers/servers.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the name of IBM nor the names of its contributors
+ *    may be used to endorse or promote products derived from this software
+ *    without specific prior written permission.
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE. */
+
+/* Virtio devices use a standardized configuration space to define their
+ * features and pass configuration information, but each implementation can
+ * store and access that space differently. */
+#include <linux/types.h>
+
+/* Status byte for guest to report progress, and synchronize features. */
+/* We have seen device and processed generic fields (VIRTIO_CONFIG_F_VIRTIO) */
+#define VIRTIO_CONFIG_S_ACKNOWLEDGE	1
+/* We have found a driver for the device. */
+#define VIRTIO_CONFIG_S_DRIVER		2
+/* Driver has used its parts of the config, and is happy */
+#define VIRTIO_CONFIG_S_DRIVER_OK	4
+/* Driver has finished configuring features */
+#define VIRTIO_CONFIG_S_FEATURES_OK	8
+/* Device entered invalid state, driver must reset it */
+#define VIRTIO_CONFIG_S_NEEDS_RESET	0x40
+/* We've given up on this device. */
+#define VIRTIO_CONFIG_S_FAILED		0x80
+
+/*
+ * Virtio feature bits VIRTIO_TRANSPORT_F_START through
+ * VIRTIO_TRANSPORT_F_END are reserved for the transport
+ * being used (e.g. virtio_ring, virtio_pci etc.), the
+ * rest are per-device feature bits.
+ */
+#define VIRTIO_TRANSPORT_F_START	28
+#define VIRTIO_TRANSPORT_F_END		38
+
+#ifndef VIRTIO_CONFIG_NO_LEGACY
+/* Do we get callbacks when the ring is completely used, even if we've
+ * suppressed them? */
+#define VIRTIO_F_NOTIFY_ON_EMPTY	24
+
+/* Can the device handle any descriptor layout? */
+#define VIRTIO_F_ANY_LAYOUT		27
+#endif /* VIRTIO_CONFIG_NO_LEGACY */
+
+/* v1.0 compliant. */
+#define VIRTIO_F_VERSION_1		32
+
+/*
+ * If clear - device has the platform DMA (e.g. IOMMU) bypass quirk feature.
+ * If set - use platform DMA tools to access the memory.
+ *
+ * Note the reverse polarity (compared to most other features),
+ * this is for compatibility with legacy systems.
+ */
+#define VIRTIO_F_ACCESS_PLATFORM	33
+#ifndef __KERNEL__
+/* Legacy name for VIRTIO_F_ACCESS_PLATFORM (for compatibility with old userspace) */
+#define VIRTIO_F_IOMMU_PLATFORM		VIRTIO_F_ACCESS_PLATFORM
+#endif /* __KERNEL__ */
+
+/* This feature indicates support for the packed virtqueue layout. */
+#define VIRTIO_F_RING_PACKED		34
+
+/*
+ * Inorder feature indicates that all buffers are used by the device
+ * in the same order in which they have been made available.
+ */
+#define VIRTIO_F_IN_ORDER		35
+
+/*
+ * This feature indicates that memory accesses by the driver and the
+ * device are ordered in a way described by the platform.
+ */
+#define VIRTIO_F_ORDER_PLATFORM		36
+
+/*
+ * Does the device support Single Root I/O Virtualization?
+ */
+#define VIRTIO_F_SR_IOV			37
+#endif /* _UAPI_LINUX_VIRTIO_CONFIG_H */
diff --git a/include/linux/virtio_console.h b/include/linux/virtio_console.h
new file mode 100644
index 00000000..7e6ec2ff
--- /dev/null
+++ b/include/linux/virtio_console.h
@@ -0,0 +1,78 @@
+/*
+ * This header, excluding the #ifdef __KERNEL__ part, is BSD licensed so
+ * anyone can use the definitions to implement compatible drivers/servers:
+ *
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the name of IBM nor the names of its contributors
+ *    may be used to endorse or promote products derived from this software
+ *    without specific prior written permission.
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ *
+ * Copyright (C) Red Hat, Inc., 2009, 2010, 2011
+ * Copyright (C) Amit Shah <amit.shah@redhat.com>, 2009, 2010, 2011
+ */
+#ifndef _UAPI_LINUX_VIRTIO_CONSOLE_H
+#define _UAPI_LINUX_VIRTIO_CONSOLE_H
+#include <linux/types.h>
+#include <linux/virtio_types.h>
+#include <linux/virtio_ids.h>
+#include <linux/virtio_config.h>
+
+/* Feature bits */
+#define VIRTIO_CONSOLE_F_SIZE	0	/* Does host provide console size? */
+#define VIRTIO_CONSOLE_F_MULTIPORT 1	/* Does host provide multiple ports? */
+#define VIRTIO_CONSOLE_F_EMERG_WRITE 2 /* Does host support emergency write? */
+
+#define VIRTIO_CONSOLE_BAD_ID		(~(__u32)0)
+
+struct virtio_console_config {
+	/* colums of the screens */
+	__virtio16 cols;
+	/* rows of the screens */
+	__virtio16 rows;
+	/* max. number of ports this device can hold */
+	__virtio32 max_nr_ports;
+	/* emergency write register */
+	__virtio32 emerg_wr;
+} __attribute__((packed));
+
+/*
+ * A message that's passed between the Host and the Guest for a
+ * particular port.
+ */
+struct virtio_console_control {
+	__virtio32 id;		/* Port number */
+	__virtio16 event;	/* The kind of control event (see below) */
+	__virtio16 value;	/* Extra information for the key */
+};
+
+/* Some events for control messages */
+#define VIRTIO_CONSOLE_DEVICE_READY	0
+#define VIRTIO_CONSOLE_PORT_ADD		1
+#define VIRTIO_CONSOLE_PORT_REMOVE	2
+#define VIRTIO_CONSOLE_PORT_READY	3
+#define VIRTIO_CONSOLE_CONSOLE_PORT	4
+#define VIRTIO_CONSOLE_RESIZE		5
+#define VIRTIO_CONSOLE_PORT_OPEN	6
+#define VIRTIO_CONSOLE_PORT_NAME	7
+
+
+#endif /* _UAPI_LINUX_VIRTIO_CONSOLE_H */
diff --git a/include/linux/virtio_pci.h b/include/linux/virtio_pci.h
new file mode 100644
index 00000000..3a86f36d
--- /dev/null
+++ b/include/linux/virtio_pci.h
@@ -0,0 +1,208 @@
+/*
+ * Virtio PCI driver
+ *
+ * This module allows virtio devices to be used over a virtual PCI device.
+ * This can be used with QEMU based VMMs like KVM or Xen.
+ *
+ * Copyright IBM Corp. 2007
+ *
+ * Authors:
+ *  Anthony Liguori  <aliguori@us.ibm.com>
+ *
+ * This header is BSD licensed so anyone can use the definitions to implement
+ * compatible drivers/servers.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the name of IBM nor the names of its contributors
+ *    may be used to endorse or promote products derived from this software
+ *    without specific prior written permission.
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef _LINUX_VIRTIO_PCI_H
+#define _LINUX_VIRTIO_PCI_H
+
+#include <linux/types.h>
+
+#ifndef VIRTIO_PCI_NO_LEGACY
+
+/* A 32-bit r/o bitmask of the features supported by the host */
+#define VIRTIO_PCI_HOST_FEATURES	0
+
+/* A 32-bit r/w bitmask of features activated by the guest */
+#define VIRTIO_PCI_GUEST_FEATURES	4
+
+/* A 32-bit r/w PFN for the currently selected queue */
+#define VIRTIO_PCI_QUEUE_PFN		8
+
+/* A 16-bit r/o queue size for the currently selected queue */
+#define VIRTIO_PCI_QUEUE_NUM		12
+
+/* A 16-bit r/w queue selector */
+#define VIRTIO_PCI_QUEUE_SEL		14
+
+/* A 16-bit r/w queue notifier */
+#define VIRTIO_PCI_QUEUE_NOTIFY		16
+
+/* An 8-bit device status register.  */
+#define VIRTIO_PCI_STATUS		18
+
+/* An 8-bit r/o interrupt status register.  Reading the value will return the
+ * current contents of the ISR and will also clear it.  This is effectively
+ * a read-and-acknowledge. */
+#define VIRTIO_PCI_ISR			19
+
+/* MSI-X registers: only enabled if MSI-X is enabled. */
+/* A 16-bit vector for configuration changes. */
+#define VIRTIO_MSI_CONFIG_VECTOR        20
+/* A 16-bit vector for selected queue notifications. */
+#define VIRTIO_MSI_QUEUE_VECTOR         22
+
+/* The remaining space is defined by each driver as the per-driver
+ * configuration space */
+#define VIRTIO_PCI_CONFIG_OFF(msix_enabled)	((msix_enabled) ? 24 : 20)
+/* Deprecated: please use VIRTIO_PCI_CONFIG_OFF instead */
+#define VIRTIO_PCI_CONFIG(dev)	VIRTIO_PCI_CONFIG_OFF((dev)->msix_enabled)
+
+/* Virtio ABI version, this must match exactly */
+#define VIRTIO_PCI_ABI_VERSION		0
+
+/* How many bits to shift physical queue address written to QUEUE_PFN.
+ * 12 is historical, and due to x86 page size. */
+#define VIRTIO_PCI_QUEUE_ADDR_SHIFT	12
+
+/* The alignment to use between consumer and producer parts of vring.
+ * x86 pagesize again. */
+#define VIRTIO_PCI_VRING_ALIGN		4096
+
+#endif /* VIRTIO_PCI_NO_LEGACY */
+
+/* The bit of the ISR which indicates a device configuration change. */
+#define VIRTIO_PCI_ISR_CONFIG		0x2
+/* Vector value used to disable MSI for queue */
+#define VIRTIO_MSI_NO_VECTOR            0xffff
+
+#ifndef VIRTIO_PCI_NO_MODERN
+
+/* IDs for different capabilities.  Must all exist. */
+
+/* Common configuration */
+#define VIRTIO_PCI_CAP_COMMON_CFG	1
+/* Notifications */
+#define VIRTIO_PCI_CAP_NOTIFY_CFG	2
+/* ISR access */
+#define VIRTIO_PCI_CAP_ISR_CFG		3
+/* Device specific configuration */
+#define VIRTIO_PCI_CAP_DEVICE_CFG	4
+/* PCI configuration access */
+#define VIRTIO_PCI_CAP_PCI_CFG		5
+/* Additional shared memory capability */
+#define VIRTIO_PCI_CAP_SHARED_MEMORY_CFG 8
+
+/* This is the PCI capability header: */
+struct virtio_pci_cap {
+	__u8 cap_vndr;		/* Generic PCI field: PCI_CAP_ID_VNDR */
+	__u8 cap_next;		/* Generic PCI field: next ptr. */
+	__u8 cap_len;		/* Generic PCI field: capability length */
+	__u8 cfg_type;		/* Identifies the structure. */
+	__u8 bar;		/* Where to find it. */
+	__u8 id;		/* Multiple capabilities of the same type */
+	__u8 padding[2];	/* Pad to full dword. */
+	__le32 offset;		/* Offset within bar. */
+	__le32 length;		/* Length of the structure, in bytes. */
+};
+
+struct virtio_pci_cap64 {
+	struct virtio_pci_cap cap;
+	__le32 offset_hi;             /* Most sig 32 bits of offset */
+	__le32 length_hi;             /* Most sig 32 bits of length */
+};
+
+struct virtio_pci_notify_cap {
+	struct virtio_pci_cap cap;
+	__le32 notify_off_multiplier;	/* Multiplier for queue_notify_off. */
+};
+
+/* Fields in VIRTIO_PCI_CAP_COMMON_CFG: */
+struct virtio_pci_common_cfg {
+	/* About the whole device. */
+	__le32 device_feature_select;	/* read-write */
+	__le32 device_feature;		/* read-only */
+	__le32 guest_feature_select;	/* read-write */
+	__le32 guest_feature;		/* read-write */
+	__le16 msix_config;		/* read-write */
+	__le16 num_queues;		/* read-only */
+	__u8 device_status;		/* read-write */
+	__u8 config_generation;		/* read-only */
+
+	/* About a specific virtqueue. */
+	__le16 queue_select;		/* read-write */
+	__le16 queue_size;		/* read-write, power of 2. */
+	__le16 queue_msix_vector;	/* read-write */
+	__le16 queue_enable;		/* read-write */
+	__le16 queue_notify_off;	/* read-only */
+	__le32 queue_desc_lo;		/* read-write */
+	__le32 queue_desc_hi;		/* read-write */
+	__le32 queue_avail_lo;		/* read-write */
+	__le32 queue_avail_hi;		/* read-write */
+	__le32 queue_used_lo;		/* read-write */
+	__le32 queue_used_hi;		/* read-write */
+};
+
+/* Fields in VIRTIO_PCI_CAP_PCI_CFG: */
+struct virtio_pci_cfg_cap {
+	struct virtio_pci_cap cap;
+	__u8 pci_cfg_data[4]; /* Data for BAR access. */
+};
+
+/* Macro versions of offsets for the Old Timers! */
+#define VIRTIO_PCI_CAP_VNDR		0
+#define VIRTIO_PCI_CAP_NEXT		1
+#define VIRTIO_PCI_CAP_LEN		2
+#define VIRTIO_PCI_CAP_CFG_TYPE		3
+#define VIRTIO_PCI_CAP_BAR		4
+#define VIRTIO_PCI_CAP_OFFSET		8
+#define VIRTIO_PCI_CAP_LENGTH		12
+
+#define VIRTIO_PCI_NOTIFY_CAP_MULT	16
+
+#define VIRTIO_PCI_COMMON_DFSELECT	0
+#define VIRTIO_PCI_COMMON_DF		4
+#define VIRTIO_PCI_COMMON_GFSELECT	8
+#define VIRTIO_PCI_COMMON_GF		12
+#define VIRTIO_PCI_COMMON_MSIX		16
+#define VIRTIO_PCI_COMMON_NUMQ		18
+#define VIRTIO_PCI_COMMON_STATUS	20
+#define VIRTIO_PCI_COMMON_CFGGENERATION	21
+#define VIRTIO_PCI_COMMON_Q_SELECT	22
+#define VIRTIO_PCI_COMMON_Q_SIZE	24
+#define VIRTIO_PCI_COMMON_Q_MSIX	26
+#define VIRTIO_PCI_COMMON_Q_ENABLE	28
+#define VIRTIO_PCI_COMMON_Q_NOFF	30
+#define VIRTIO_PCI_COMMON_Q_DESCLO	32
+#define VIRTIO_PCI_COMMON_Q_DESCHI	36
+#define VIRTIO_PCI_COMMON_Q_AVAILLO	40
+#define VIRTIO_PCI_COMMON_Q_AVAILHI	44
+#define VIRTIO_PCI_COMMON_Q_USEDLO	48
+#define VIRTIO_PCI_COMMON_Q_USEDHI	52
+
+#endif /* VIRTIO_PCI_NO_MODERN */
+
+#endif
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
new file mode 100644
index 00000000..476d3e5c
--- /dev/null
+++ b/include/linux/virtio_ring.h
@@ -0,0 +1,244 @@
+#ifndef _UAPI_LINUX_VIRTIO_RING_H
+#define _UAPI_LINUX_VIRTIO_RING_H
+/* An interface for efficient virtio implementation, currently for use by KVM,
+ * but hopefully others soon.  Do NOT change this since it will
+ * break existing servers and clients.
+ *
+ * This header is BSD licensed so anyone can use the definitions to implement
+ * compatible drivers/servers.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the name of IBM nor the names of its contributors
+ *    may be used to endorse or promote products derived from this software
+ *    without specific prior written permission.
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ *
+ * Copyright Rusty Russell IBM Corporation 2007. */
+#ifndef __KERNEL__
+#include <stdint.h>
+#endif
+#include <linux/types.h>
+#include <linux/virtio_types.h>
+
+/* This marks a buffer as continuing via the next field. */
+#define VRING_DESC_F_NEXT	1
+/* This marks a buffer as write-only (otherwise read-only). */
+#define VRING_DESC_F_WRITE	2
+/* This means the buffer contains a list of buffer descriptors. */
+#define VRING_DESC_F_INDIRECT	4
+
+/*
+ * Mark a descriptor as available or used in packed ring.
+ * Notice: they are defined as shifts instead of shifted values.
+ */
+#define VRING_PACKED_DESC_F_AVAIL	7
+#define VRING_PACKED_DESC_F_USED	15
+
+/* The Host uses this in used->flags to advise the Guest: don't kick me when
+ * you add a buffer.  It's unreliable, so it's simply an optimization.  Guest
+ * will still kick if it's out of buffers. */
+#define VRING_USED_F_NO_NOTIFY	1
+/* The Guest uses this in avail->flags to advise the Host: don't interrupt me
+ * when you consume a buffer.  It's unreliable, so it's simply an
+ * optimization.  */
+#define VRING_AVAIL_F_NO_INTERRUPT	1
+
+/* Enable events in packed ring. */
+#define VRING_PACKED_EVENT_FLAG_ENABLE	0x0
+/* Disable events in packed ring. */
+#define VRING_PACKED_EVENT_FLAG_DISABLE	0x1
+/*
+ * Enable events for a specific descriptor in packed ring.
+ * (as specified by Descriptor Ring Change Event Offset/Wrap Counter).
+ * Only valid if VIRTIO_RING_F_EVENT_IDX has been negotiated.
+ */
+#define VRING_PACKED_EVENT_FLAG_DESC	0x2
+
+/*
+ * Wrap counter bit shift in event suppression structure
+ * of packed ring.
+ */
+#define VRING_PACKED_EVENT_F_WRAP_CTR	15
+
+/* We support indirect buffer descriptors */
+#define VIRTIO_RING_F_INDIRECT_DESC	28
+
+/* The Guest publishes the used index for which it expects an interrupt
+ * at the end of the avail ring. Host should ignore the avail->flags field. */
+/* The Host publishes the avail index for which it expects a kick
+ * at the end of the used ring. Guest should ignore the used->flags field. */
+#define VIRTIO_RING_F_EVENT_IDX		29
+
+/* Alignment requirements for vring elements.
+ * When using pre-virtio 1.0 layout, these fall out naturally.
+ */
+#define VRING_AVAIL_ALIGN_SIZE 2
+#define VRING_USED_ALIGN_SIZE 4
+#define VRING_DESC_ALIGN_SIZE 16
+
+/* Virtio ring descriptors: 16 bytes.  These can chain together via "next". */
+struct vring_desc {
+	/* Address (guest-physical). */
+	__virtio64 addr;
+	/* Length. */
+	__virtio32 len;
+	/* The flags as indicated above. */
+	__virtio16 flags;
+	/* We chain unused descriptors via this, too */
+	__virtio16 next;
+};
+
+struct vring_avail {
+	__virtio16 flags;
+	__virtio16 idx;
+	__virtio16 ring[];
+};
+
+/* u32 is used here for ids for padding reasons. */
+struct vring_used_elem {
+	/* Index of start of used descriptor chain. */
+	__virtio32 id;
+	/* Total length of the descriptor chain which was used (written to) */
+	__virtio32 len;
+};
+
+typedef struct vring_used_elem __attribute__((aligned(VRING_USED_ALIGN_SIZE)))
+	vring_used_elem_t;
+
+struct vring_used {
+	__virtio16 flags;
+	__virtio16 idx;
+	vring_used_elem_t ring[];
+};
+
+/*
+ * The ring element addresses are passed between components with different
+ * alignments assumptions. Thus, we might need to decrease the compiler-selected
+ * alignment, and so must use a typedef to make sure the aligned attribute
+ * actually takes hold:
+ *
+ * https://gcc.gnu.org/onlinedocs//gcc/Common-Type-Attributes.html#Common-Type-Attributes
+ *
+ * When used on a struct, or struct member, the aligned attribute can only
+ * increase the alignment; in order to decrease it, the packed attribute must
+ * be specified as well. When used as part of a typedef, the aligned attribute
+ * can both increase and decrease alignment, and specifying the packed
+ * attribute generates a warning.
+ */
+typedef struct vring_desc __attribute__((aligned(VRING_DESC_ALIGN_SIZE)))
+	vring_desc_t;
+typedef struct vring_avail __attribute__((aligned(VRING_AVAIL_ALIGN_SIZE)))
+	vring_avail_t;
+typedef struct vring_used __attribute__((aligned(VRING_USED_ALIGN_SIZE)))
+	vring_used_t;
+
+struct vring {
+	unsigned int num;
+
+	vring_desc_t *desc;
+
+	vring_avail_t *avail;
+
+	vring_used_t *used;
+};
+
+#ifndef VIRTIO_RING_NO_LEGACY
+
+/* The standard layout for the ring is a continuous chunk of memory which looks
+ * like this.  We assume num is a power of 2.
+ *
+ * struct vring
+ * {
+ *	// The actual descriptors (16 bytes each)
+ *	struct vring_desc desc[num];
+ *
+ *	// A ring of available descriptor heads with free-running index.
+ *	__virtio16 avail_flags;
+ *	__virtio16 avail_idx;
+ *	__virtio16 available[num];
+ *	__virtio16 used_event_idx;
+ *
+ *	// Padding to the next align boundary.
+ *	char pad[];
+ *
+ *	// A ring of used descriptor heads with free-running index.
+ *	__virtio16 used_flags;
+ *	__virtio16 used_idx;
+ *	struct vring_used_elem used[num];
+ *	__virtio16 avail_event_idx;
+ * };
+ */
+/* We publish the used event index at the end of the available ring, and vice
+ * versa. They are at the end for backwards compatibility. */
+#define vring_used_event(vr) ((vr)->avail->ring[(vr)->num])
+#define vring_avail_event(vr) (*(__virtio16 *)&(vr)->used->ring[(vr)->num])
+
+static inline void vring_init(struct vring *vr, unsigned int num, void *p,
+			      unsigned long align)
+{
+	vr->num = num;
+	vr->desc = p;
+	vr->avail = (struct vring_avail *)((char *)p + num * sizeof(struct vring_desc));
+	vr->used = (void *)(((uintptr_t)&vr->avail->ring[num] + sizeof(__virtio16)
+		+ align-1) & ~(align - 1));
+}
+
+static inline unsigned vring_size(unsigned int num, unsigned long align)
+{
+	return ((sizeof(struct vring_desc) * num + sizeof(__virtio16) * (3 + num)
+		 + align - 1) & ~(align - 1))
+		+ sizeof(__virtio16) * 3 + sizeof(struct vring_used_elem) * num;
+}
+
+#endif /* VIRTIO_RING_NO_LEGACY */
+
+/* The following is used with USED_EVENT_IDX and AVAIL_EVENT_IDX */
+/* Assuming a given event_idx value from the other side, if
+ * we have just incremented index from old to new_idx,
+ * should we trigger an event? */
+static inline int vring_need_event(__u16 event_idx, __u16 new_idx, __u16 old)
+{
+	/* Note: Xen has similar logic for notification hold-off
+	 * in include/xen/interface/io/ring.h with req_event and req_prod
+	 * corresponding to event_idx + 1 and new_idx respectively.
+	 * Note also that req_event and req_prod in Xen start at 1,
+	 * event indexes in virtio start at 0. */
+	return (__u16)(new_idx - event_idx - 1) < (__u16)(new_idx - old);
+}
+
+struct vring_packed_desc_event {
+	/* Descriptor Ring Change Event Offset/Wrap Counter. */
+	__le16 off_wrap;
+	/* Descriptor Ring Change Event Flags. */
+	__le16 flags;
+};
+
+struct vring_packed_desc {
+	/* Buffer Address. */
+	__le64 addr;
+	/* Buffer Length. */
+	__le32 len;
+	/* Buffer ID. */
+	__le16 id;
+	/* The flags depending on descriptor type. */
+	__le16 flags;
+};
+
+#endif /* _UAPI_LINUX_VIRTIO_RING_H */
diff --git a/include/linux/virtio_rng.h b/include/linux/virtio_rng.h
new file mode 100644
index 00000000..c4d5de89
--- /dev/null
+++ b/include/linux/virtio_rng.h
@@ -0,0 +1,8 @@
+#ifndef _LINUX_VIRTIO_RNG_H
+#define _LINUX_VIRTIO_RNG_H
+/* This header is BSD licensed so anyone can use the definitions to implement
+ * compatible drivers/servers. */
+#include <linux/virtio_ids.h>
+#include <linux/virtio_config.h>
+
+#endif /* _LINUX_VIRTIO_RNG_H */
-- 
2.25.1

