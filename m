Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 451C5143703
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 07:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgAUGTy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 01:19:54 -0500
Received: from mga14.intel.com ([192.55.52.115]:33355 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729073AbgAUGTy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 01:19:54 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jan 2020 22:19:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,344,1574150400"; 
   d="scan'208";a="278302177"
Received: from hyperv-sh3.bj.intel.com ([10.240.193.95])
  by fmsmga001.fm.intel.com with ESMTP; 20 Jan 2020 22:19:52 -0800
From:   Jing Liu <jing2.liu@linux.intel.com>
To:     virtio-dev@lists.oasis-open.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, Jing Liu <jing2.liu@linux.intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Liu Jiang <gerry@linux.alibaba.com>,
        Zha Bin <zhabin@linux.alibaba.com>
Subject: [virtio-dev] [PATCH v2 5/5] virtio-mmio: MSI vector and event mapping
Date:   Tue, 21 Jan 2020 21:54:33 +0800
Message-Id: <1579614873-21907-6-git-send-email-jing2.liu@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579614873-21907-1-git-send-email-jing2.liu@linux.intel.com>
References: <1579614873-21907-1-git-send-email-jing2.liu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bit 1 msi_sharing reported in the MsiState register indicates the mapping mode
device uses.

Bit 1 is 0 - device uses MSI non-sharing mode. This indicates vector per event and
fixed static vectors and events relationship. This fits for devices with a high interrupt
rate and best performance;
Bit 1 is 1 - device uses MSI sharing mode. This indicates vectors and events
dynamic mapping and fits for devices not requiring a high interrupt rate.

Co-developed-by: Chao Peng <chao.p.peng@linux.intel.com>
Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
Co-developed-by: Liu Jiang <gerry@linux.alibaba.com>
Signed-off-by: Liu Jiang <gerry@linux.alibaba.com>
Co-developed-by: Zha Bin <zhabin@linux.alibaba.com>
Signed-off-by: Zha Bin <zhabin@linux.alibaba.com>
Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
---
 content.tex | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
 msi-state.c |  3 ++-
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/content.tex b/content.tex
index dcf6c71..2fd1686 100644
--- a/content.tex
+++ b/content.tex
@@ -1770,7 +1770,8 @@ \subsection{MMIO Device Register Layout}\label{sec:Virtio Transport Options / Vi
   \hline
   \mmioreg{MsiState}{MSI state}{0x0c4}{R}{%
     When VIRTIO_F_MMIO_MSI has been negotiated, reading
-    from this register returns the global MSI enable/disable status.
+    from this register returns the global MSI enable/disable status
+    and whether device uses MSI sharing mode.
     \lstinputlisting{msi-state.c}
   }
   \hline
@@ -1926,12 +1927,18 @@ \subsubsection{Device Initialization}\label{sec:Virtio Transport Options / Virti
 mask and unmask the MSI vector applying to the one selected by writing
 to \field{MsiVecSel}.
 
+VIRTIO_MMIO_MSI_CMD_MAP_CONFIG command is to set the configuration event and MSI vector
+mapping. VIRTIO_MMIO_MSI_CMD_MAP_QUEUE is to set the queue event and MSI vector
+mapping. They SHOULD only be used in MSI sharing mode.
+
 \begin{lstlisting}
 #define  VIRTIO_MMIO_MSI_CMD_ENABLE           0x1
 #define  VIRTIO_MMIO_MSI_CMD_DISABLE          0x2
 #define  VIRTIO_MMIO_MSI_CMD_CONFIGURE        0x3
 #define  VIRTIO_MMIO_MSI_CMD_MASK             0x4
 #define  VIRTIO_MMIO_MSI_CMD_UNMASK           0x5
+#define  VIRTIO_MMIO_MSI_CMD_MAP_CONFIG       0x6
+#define  VIRTIO_MMIO_MSI_CMD_MAP_QUEUE        0x7
 \end{lstlisting}
 
 Setting a special NO_VECTOR value means disabling an interrupt for an event type.
@@ -1941,10 +1948,49 @@ \subsubsection{Device Initialization}\label{sec:Virtio Transport Options / Virti
 #define VIRTIO_MMIO_MSI_NO_VECTOR             0xffffffff
 \end{lstlisting}
 
+\subparagraph{MSI Vector and Event Mapping}\label{sec:Virtio Transport Options / Virtio Over MMIO / MMIO-specific Initialization And Device Operation / Device Initialization / MSI Vector Configuration}
+The reported \field{msi_sharing} bit in the \field{MsiState} return value shows
+the MSI sharing mode that device uses.
+
+When \field{msi_sharing} bit is 0, it indicates the device uses non-sharing mode
+and vector per event fixed static relationship is used. The first vector is for device
+configuraiton change event, the second vector is for virtqueue 1, the third vector
+is for virtqueue 2 and so on.
+
+When \field{msi_sharing} bit is 1, it indicates the device uses MSI sharing mode,
+and the vector and event mapping is dynamic. Writing \field{MsiVecSel}
+followed by writing VIRTIO_MMIO_MSI_CMD_MAP_CONFIG/VIRTIO_MMIO_MSI_CMD_MAP_QUEUE command
+maps interrupts triggered by the configuration change/selected queue events respectively
+to the corresponding MSI vector.
+
+\devicenormative{\subparagraph}{MSI Vector Configuration}{Virtio Transport Options / Virtio Over MMIO / MMIO-specific Initialization And Device Operation / MSI Vector Configuration}
+
+When the device reports \field{msi_sharing} bit as 0, it SHOULD support a number of
+vectors that greater than the maximum number of virtqueues.
+Device MUST report the number of vectors supported in \field{MsiVecNum}.
+
+When the device reports \field{msi_sharing} bit as 1, it SHOULD support at least
+2 MSI vectors and MUST report in \field{MsiVecNum}. Device SHOULD support mapping any
+event type to any vector under \field{MsiVecNum}.
+
+Device MUST support unmapping any event type (NO_VECTOR).
+
+The device SHOULD restrict the reported \field{msi_sharing} and \field{MsiVecNum}
+to a value that might benefit system performance.
+
+\begin{note}
+For example, a device which does not expect to send interrupts at a high rate might
+return \field{msi_sharing} bit as 1.
+\end{note}
+
 \drivernormative{\subparagraph}{MSI Vector Configuration}{Virtio Transport Options / Virtio Over MMIO / MMIO-specific Initialization And Device Operation / MSI Vector Configuration}
 When VIRTIO_F_MMIO_MSI has been negotiated, driver should try to configure
 and enable MSI.
 
+To set up the event and vector mapping for MSI sharing mode, driver SHOULD
+write a valid \field{MsiVecSel} followed by VIRTIO_MMIO_MSI_CMD_MAP_CONFIG/VIRTIO_MMIO_MSI_CMD_MAP_QUEUE
+command to map the configuration change/selected queue events respectively.
+
 To configure MSI vector, driver SHOULD firstly specify the MSI vector index by
 writing to \field{MsiVecSel}.
 Then notify the MSI address and data by writing to \field{MsiAddrLow}, \field{MsiAddrHigh},
diff --git a/msi-state.c b/msi-state.c
index b1fa0c1..d470be4 100644
--- a/msi-state.c
+++ b/msi-state.c
@@ -1,4 +1,5 @@
 le32 {
     msi_enabled : 1;
-    reserved : 31;
+    msi_sharing: 1;
+    reserved : 30;
 };
-- 
2.7.4

