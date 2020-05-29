Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165431E76E7
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 09:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgE2HiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 03:38:25 -0400
Received: from mga07.intel.com ([134.134.136.100]:50716 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbgE2Hhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 03:37:36 -0400
IronPort-SDR: Eri97hMmkzut/4NIb2qCPSU1vZe4/vPUTXcKVxUgWy8cLzms34JSPV0V/vSVeYE6ex5bBDejr7
 eVS4pGT+ZCNw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 00:37:35 -0700
IronPort-SDR: yXU9IEbkDS3OKReBnCVaMacKdpVei8yJmMxJchZU+cm7nXCudLiumOhf87YDkyAZlS0CzKy9ap
 1EKa7eGXNeRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414890383"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.252.45.157])
  by orsmga004.jf.intel.com with ESMTP; 29 May 2020 00:37:32 -0700
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [RFC 03/12] ASoC: SOF: support IPC with immediate response
Date:   Fri, 29 May 2020 09:37:13 +0200
Message-Id: <20200529073722.8184-4-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
References: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Usually when an IPC message is sent, we have to wait for a reply from
the DSP or from the host in the VirtIO case. However, sometimes in
the VirtIO case a response is available immediately. Skip sleeping in
such cases.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
---
 sound/soc/sof/ipc.c | 11 +++++++----
 sound/soc/sof/ops.h | 10 +++++++++-
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/sound/soc/sof/ipc.c b/sound/soc/sof/ipc.c
index f7a0353..b3e1587 100644
--- a/sound/soc/sof/ipc.c
+++ b/sound/soc/sof/ipc.c
@@ -262,6 +262,12 @@ static int sof_ipc_tx_message_unlocked(struct snd_sof_ipc *ipc, u32 header,
 
 	sdev->msg = msg;
 
+	/*
+	 * If snd_sof_dsp_send_msg() returns a positive number it means, that a
+	 * response is already available, no need to sleep waiting for it. In
+	 * such a case msg->ipc_complete will stay true and tx_wait_done() will
+	 * return immediately.
+	 */
 	ret = snd_sof_dsp_send_msg(sdev, msg);
 	/* Next reply that we receive will be related to this message */
 	if (!ret)
@@ -279,10 +285,7 @@ static int sof_ipc_tx_message_unlocked(struct snd_sof_ipc *ipc, u32 header,
 	ipc_log_header(sdev->dev, "ipc tx", msg->header);
 
 	/* now wait for completion */
-	if (!ret)
-		ret = tx_wait_done(ipc, msg, reply_data);
-
-	return ret;
+	return tx_wait_done(ipc, msg, reply_data);
 }
 
 /* send IPC message from host to DSP */
diff --git a/sound/soc/sof/ops.h b/sound/soc/sof/ops.h
index b21632f..bf91467 100644
--- a/sound/soc/sof/ops.h
+++ b/sound/soc/sof/ops.h
@@ -274,7 +274,15 @@ static inline void snd_sof_dsp_block_write(struct snd_sof_dev *sdev, u32 bar,
 	sof_ops(sdev)->block_write(sdev, bar, offset, src, bytes);
 }
 
-/* ipc */
+/**
+ * snd_sof_dsp_send_msg - call sdev ops to send a message
+ * @sdev:	sdev context
+ * @msg:	message to send
+ *
+ * Returns	< 0 - an error code
+ *		  0 - the message has been sent, wait for a reply
+ *		> 0 - the message has been sent, a reply is already available
+ */
 static inline int snd_sof_dsp_send_msg(struct snd_sof_dev *sdev,
 				       struct snd_sof_ipc_msg *msg)
 {
-- 
1.9.3

