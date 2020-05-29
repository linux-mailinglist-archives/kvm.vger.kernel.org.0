Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53181E76EB
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 09:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgE2Hi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 03:38:27 -0400
Received: from mga07.intel.com ([134.134.136.100]:50721 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgE2Hhj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 03:37:39 -0400
IronPort-SDR: FgrSWDHJEx4s1++vDqytMO5VbJgDcvDAlP9Mf3B98ZelbQYGRVgxYLOupaIyipkQz53YRWU0/H
 rlQ7a86gaFmQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 00:37:38 -0700
IronPort-SDR: sVlJALEYOKQrn7ES8eYvI9cZAbLO9Jlrs6Oe3sSQcx5DJxbBMm1zkDo0r1l0BSmLoRU/od11YO
 W0yzRA4ktd5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414890389"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.252.45.157])
  by orsmga004.jf.intel.com with ESMTP; 29 May 2020 00:37:35 -0700
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
Subject: [RFC 04/12] ASoC: SOF: add a power status IPC
Date:   Fri, 29 May 2020 09:37:14 +0200
Message-Id: <20200529073722.8184-5-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
References: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In a virtualised configuration the runtime PM of the host and any
guests aren't synchronised. But guests have to be able to tell the
host when they suspend and resume and know, whether the host has been
runtime suspended since that guests's topology had been sent to the
host last time. This is needed to decide whether to re-send the
topology again. To support this we add a new PM IPC message
SOF_IPC_PM_VFE_POWER_STATUS and a reset counter to track the state of
the DSP.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
---
 include/sound/sof/header.h | 1 +
 sound/soc/sof/core.c       | 2 ++
 sound/soc/sof/ipc.c        | 2 ++
 sound/soc/sof/loader.c     | 4 ++++
 sound/soc/sof/sof-priv.h   | 4 ++++
 5 files changed, 13 insertions(+)

diff --git a/include/sound/sof/header.h b/include/sound/sof/header.h
index 2d35997..5ee296c 100644
--- a/include/sound/sof/header.h
+++ b/include/sound/sof/header.h
@@ -77,6 +77,7 @@
 #define SOF_IPC_PM_CLK_REQ			SOF_CMD_TYPE(0x006)
 #define SOF_IPC_PM_CORE_ENABLE			SOF_CMD_TYPE(0x007)
 #define SOF_IPC_PM_GATE				SOF_CMD_TYPE(0x008)
+#define SOF_IPC_PM_VFE_POWER_STATUS		SOF_CMD_TYPE(0x010)
 
 /* component runtime config - multiple different types */
 #define SOF_IPC_COMP_SET_VALUE			SOF_CMD_TYPE(0x001)
diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index 17f264f..61f045c 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -8,6 +8,7 @@
 // Author: Liam Girdwood <liam.r.girdwood@linux.intel.com>
 //
 
+#include <linux/atomic.h>
 #include <linux/firmware.h>
 #include <linux/module.h>
 #include <sound/soc.h>
@@ -312,6 +313,7 @@ int snd_sof_device_probe(struct device *dev, struct snd_sof_pdata *plat_data)
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_DEBUG_PROBES)
 	sdev->extractor_stream_tag = SOF_PROBE_INVALID_NODE_ID;
 #endif
+	atomic_set(&sdev->dsp_reset_count, 0);
 	dev_set_drvdata(dev, sdev);
 
 	/* check all mandatory ops */
diff --git a/sound/soc/sof/ipc.c b/sound/soc/sof/ipc.c
index b3e1587..e9b0347 100644
--- a/sound/soc/sof/ipc.c
+++ b/sound/soc/sof/ipc.c
@@ -105,6 +105,8 @@ static void ipc_log_header(struct device *dev, u8 *text, u32 cmd)
 			str2 = "CLK_REQ"; break;
 		case SOF_IPC_PM_CORE_ENABLE:
 			str2 = "CORE_ENABLE"; break;
+		case SOF_IPC_PM_VFE_POWER_STATUS:
+			str2 = "VFE_POWER_STATUS"; break;
 		default:
 			str2 = "unknown type"; break;
 		}
diff --git a/sound/soc/sof/loader.c b/sound/soc/sof/loader.c
index 4a5b57e..df95bcb 100644
--- a/sound/soc/sof/loader.c
+++ b/sound/soc/sof/loader.c
@@ -10,6 +10,7 @@
 // Generic firmware loader.
 //
 
+#include <linux/atomic.h>
 #include <linux/firmware.h>
 #include <sound/sof.h>
 #include "ops.h"
@@ -620,6 +621,9 @@ int snd_sof_run_firmware(struct snd_sof_dev *sdev)
 	/* fw boot is complete. Update the active cores mask */
 	sdev->enabled_cores_mask = init_core_mask;
 
+	/* increment reset count */
+	atomic_add(1, &sdev->dsp_reset_count);
+
 	return 0;
 }
 EXPORT_SYMBOL(snd_sof_run_firmware);
diff --git a/sound/soc/sof/sof-priv.h b/sound/soc/sof/sof-priv.h
index 3ed39b8..29ab6ad 100644
--- a/sound/soc/sof/sof-priv.h
+++ b/sound/soc/sof/sof-priv.h
@@ -11,6 +11,7 @@
 #ifndef __SOUND_SOC_SOF_PRIV_H
 #define __SOUND_SOC_SOF_PRIV_H
 
+#include <linux/atomic.h>
 #include <linux/device.h>
 #include <sound/hdaudio.h>
 #include <sound/sof.h>
@@ -425,6 +426,9 @@ struct snd_sof_dev {
 	unsigned int extractor_stream_tag;
 #endif
 
+	/* VirtIO fields for host and guest */
+	atomic_t dsp_reset_count;
+
 	/* DMA for Trace */
 	struct snd_dma_buffer dmatb;
 	struct snd_dma_buffer dmatp;
-- 
1.9.3

