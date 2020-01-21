Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE0E3143701
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 07:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgAUGTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 01:19:51 -0500
Received: from mga14.intel.com ([192.55.52.115]:33355 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728896AbgAUGTt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 01:19:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jan 2020 22:19:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,344,1574150400"; 
   d="scan'208";a="278301959"
Received: from hyperv-sh3.bj.intel.com ([10.240.193.95])
  by fmsmga001.fm.intel.com with ESMTP; 20 Jan 2020 22:19:47 -0800
From:   Jing Liu <jing2.liu@linux.intel.com>
To:     virtio-dev@lists.oasis-open.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, Jing Liu <jing2.liu@linux.intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Liu Jiang <gerry@linux.alibaba.com>,
        Zha Bin <zhabin@linux.alibaba.com>
Subject: [virtio-dev] [PATCH v2 2/5] virtio-mmio: Enhance queue notification support
Date:   Tue, 21 Jan 2020 21:54:30 +0800
Message-Id: <1579614873-21907-3-git-send-email-jing2.liu@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579614873-21907-1-git-send-email-jing2.liu@linux.intel.com>
References: <1579614873-21907-1-git-send-email-jing2.liu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With VIRTIO_F_MMIO_NOTIFICATION feature bit offered, the notification
mechanism is enhanced. Driver reads QueueNotify register to get
notification structure and calculate notification addresses of
each virtqueue.

Co-developed-by: Chao Peng <chao.p.peng@linux.intel.com>
Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
Co-developed-by: Liu Jiang <gerry@linux.alibaba.com>
Signed-off-by: Liu Jiang <gerry@linux.alibaba.com>
Co-developed-by: Zha Bin <zhabin@linux.alibaba.com>
Signed-off-by: Zha Bin <zhabin@linux.alibaba.com>
Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
---
 content.tex | 53 ++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 13 deletions(-)

diff --git a/content.tex b/content.tex
index 826bc7d..5881253 100644
--- a/content.tex
+++ b/content.tex
@@ -1671,20 +1671,18 @@ \subsection{MMIO Device Register Layout}\label{sec:Virtio Transport Options / Vi
     accesses apply to the queue selected by writing to \field{QueueSel}.
   }
   \hline 
-  \mmioreg{QueueNotify}{Queue notifier}{0x050}{W}{%
-    Writing a value to this register notifies the device that
-    there are new buffers to process in a queue.
+  \mmioreg{QueueNotify}{Queue notifier}{0x050}{RW}{%
+    When VIRTIO_F_MMIO_NOTIFICATION has not been negotiated, writing to this
+    register notifies the device that there are new buffers to process in a queue.
 
-    When VIRTIO_F_NOTIFICATION_DATA has not been negotiated,
-    the value written is the queue index.
+    When VIRTIO_F_MMIO_NOTIFICATION has been negotiated, reading this register
+    returns the virtqueue notification structure for calculating notification location.
 
-    When VIRTIO_F_NOTIFICATION_DATA has been negotiated,
-    the \field{Notification data} value has the following format:
+    See \ref{sec:Virtio Transport Options / Virtio Over MMIO / MMIO-specific Initialization And Device Operation / Notification Structure Layout}
+    for the notification structure format.
 
-    \lstinputlisting{notifications-le.c}
-
-    See \ref{sec:Virtqueues / Driver notifications}~\nameref{sec:Virtqueues / Driver notifications}
-    for the definition of the components.
+    See \ref{sec:Virtio Transport Options / Virtio Over MMIO / MMIO-specific Initialization And Device Operation / Available Buffer Notifications}
+    for the notification data format.
   }
   \hline 
   \mmioreg{InterruptStatus}{Interrupt status}{0x60}{R}{%
@@ -1858,6 +1856,31 @@ \subsubsection{Device Initialization}\label{sec:Virtio Transport Options / Virti
 Further initialization MUST follow the procedure described in
 \ref{sec:General Initialization And Device Operation / Device Initialization}~\nameref{sec:General Initialization And Device Operation / Device Initialization}.
 
+\subsubsection{Notification Structure Layout}\label{sec:Virtio Transport Options / Virtio Over MMIO / MMIO-specific Initialization And Device Operation / Notification Structure Layout}
+
+When VIRTIO_F_MMIO_NOTIFICATION has been negotiated, the notification location is calculated
+by notification structure. Driver reads \field{QueueNotify} to get this structure formatted
+as follows.
+
+\begin{lstlisting}
+le32 {
+        notify_base : 16;
+        notify_multiplier : 16;
+};
+\end{lstlisting}
+
+\field{notify_multiplier} is combined with virtqueue index to derive the Queue Notify address
+within a memory mapped control registers for a virtqueue:
+
+\begin{lstlisting}
+        notify_base + queue_index * notify_multiplier
+\end{lstlisting}
+
+\begin{note}
+For example, if notify_multiplier is 0, the device uses the same Queue Notify address for all
+queues.
+\end{note}
+
 \subsubsection{Virtqueue Configuration}\label{sec:Virtio Transport Options / Virtio Over MMIO / MMIO-specific Initialization And Device Operation / Virtqueue Configuration}
 
 The driver will typically initialize the virtual queue in the following way:
@@ -1893,16 +1916,20 @@ \subsubsection{Available Buffer Notifications}\label{sec:Virtio Transport Option
 When VIRTIO_F_NOTIFICATION_DATA has not been negotiated,
 the driver sends an available buffer notification to the device by writing
 the 16-bit virtqueue index
-of the queue to be notified to \field{QueueNotify}.
+of the queue to be notified to Queue Notify address.
 
 When VIRTIO_F_NOTIFICATION_DATA has been negotiated,
 the driver sends an available buffer notification to the device by writing
-the following 32-bit value to \field{QueueNotify}:
+the following 32-bit value to Queue Notify address:
 \lstinputlisting{notifications-le.c}
 
 See \ref{sec:Virtqueues / Driver notifications}~\nameref{sec:Virtqueues / Driver notifications}
 for the definition of the components.
 
+For device not offering VIRTIO_F_MMIO_NOTIFICATION, the Queue Notify address is \field{QueueNotify}.
+For device offering VIRTIO_F_MMIO_NOTIFICATION, see \ref{sec:Virtio Transport Options / Virtio Over MMIO / MMIO-specific Initialization And Device Operation / Notification Structure Layout}
+for how to calculate the Queue Notify address.
+
 \subsubsection{Notifications From The Device}\label{sec:Virtio Transport Options / Virtio Over MMIO / MMIO-specific Initialization And Device Operation / Notifications From The Device}
 
 The memory mapped virtio device is using a single, dedicated
-- 
2.7.4

