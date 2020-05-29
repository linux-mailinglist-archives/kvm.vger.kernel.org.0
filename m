Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04C91E76D3
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 09:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgE2Hhf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 03:37:35 -0400
Received: from mga07.intel.com ([134.134.136.100]:50716 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbgE2Hhd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 03:37:33 -0400
IronPort-SDR: ZRmj8u5h4igSTU5VgMgii1lj5vIpItb5KZquJZRZ8C+UOeexEO2cqamE3irzRd1zxs7zDpYzC7
 HMM5OP2WRxOg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 00:37:32 -0700
IronPort-SDR: Yk5hmbix2fMfxV3erm00Pbe4bMGr30WTlAv0mbchHXijwBPUBPT7QG7/jIlqw+cfi+PqXZXl6D
 AzJj4ueYlqyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414890374"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.252.45.157])
  by orsmga004.jf.intel.com with ESMTP; 29 May 2020 00:37:30 -0700
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
Subject: [RFC 02/12] ASoC: SOF: extract firmware-related operation into a function
Date:   Fri, 29 May 2020 09:37:12 +0200
Message-Id: <20200529073722.8184-3-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
References: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the VirtIO guest case the SOF will not be dealing with the
firmware directly. Extract related functionality into a function to
make the separation easier.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
---
 sound/soc/sof/core.c | 85 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 49 insertions(+), 36 deletions(-)

diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index 339c493..17f264f 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -135,6 +135,53 @@ void snd_sof_get_status(struct snd_sof_dev *sdev, u32 panic_code,
  *	(System Suspend/Runtime Suspend)
  */
 
+static int sof_load_and_run_firmware(struct snd_sof_dev *sdev)
+{
+	/* load the firmware */
+	int ret = snd_sof_load_firmware(sdev);
+	if (ret < 0) {
+		dev_err(sdev->dev, "error: failed to load DSP firmware %d\n",
+			ret);
+		return ret;
+	}
+
+	sdev->fw_state = SOF_FW_BOOT_IN_PROGRESS;
+
+	/*
+	 * Boot the firmware. The FW boot status will be modified
+	 * in snd_sof_run_firmware() depending on the outcome.
+	 */
+	ret = snd_sof_run_firmware(sdev);
+	if (ret < 0) {
+		dev_err(sdev->dev, "error: failed to boot DSP firmware %d\n",
+			ret);
+		goto fw_run_err;
+	}
+
+	if (IS_ENABLED(CONFIG_SND_SOC_SOF_DEBUG_ENABLE_FIRMWARE_TRACE) ||
+	    (sof_core_debug & SOF_DBG_ENABLE_TRACE)) {
+		sdev->dtrace_is_supported = true;
+
+		/* init DMA trace */
+		ret = snd_sof_init_trace(sdev);
+		if (ret < 0) {
+			/* non fatal */
+			dev_warn(sdev->dev,
+				 "warning: failed to initialize trace %d\n",
+				 ret);
+		}
+	} else {
+		dev_dbg(sdev->dev, "SOF firmware trace disabled\n");
+	}
+
+	return 0;
+
+fw_run_err:
+	snd_sof_fw_unload(sdev);
+
+	return ret;
+}
+
 static int sof_probe_continue(struct snd_sof_dev *sdev)
 {
 	struct snd_sof_pdata *plat_data = sdev->pdata;
@@ -181,42 +228,9 @@ static int sof_probe_continue(struct snd_sof_dev *sdev)
 		goto ipc_err;
 	}
 
-	/* load the firmware */
-	ret = snd_sof_load_firmware(sdev);
-	if (ret < 0) {
-		dev_err(sdev->dev, "error: failed to load DSP firmware %d\n",
-			ret);
+	ret = sof_load_and_run_firmware(sdev);
+	if (ret < 0)
 		goto fw_load_err;
-	}
-
-	sdev->fw_state = SOF_FW_BOOT_IN_PROGRESS;
-
-	/*
-	 * Boot the firmware. The FW boot status will be modified
-	 * in snd_sof_run_firmware() depending on the outcome.
-	 */
-	ret = snd_sof_run_firmware(sdev);
-	if (ret < 0) {
-		dev_err(sdev->dev, "error: failed to boot DSP firmware %d\n",
-			ret);
-		goto fw_run_err;
-	}
-
-	if (IS_ENABLED(CONFIG_SND_SOC_SOF_DEBUG_ENABLE_FIRMWARE_TRACE) ||
-	    (sof_core_debug & SOF_DBG_ENABLE_TRACE)) {
-		sdev->dtrace_is_supported = true;
-
-		/* init DMA trace */
-		ret = snd_sof_init_trace(sdev);
-		if (ret < 0) {
-			/* non fatal */
-			dev_warn(sdev->dev,
-				 "warning: failed to initialize trace %d\n",
-				 ret);
-		}
-	} else {
-		dev_dbg(sdev->dev, "SOF firmware trace disabled\n");
-	}
 
 	/* hereafter all FW boot flows are for PM reasons */
 	sdev->first_boot = false;
@@ -250,7 +264,6 @@ static int sof_probe_continue(struct snd_sof_dev *sdev)
 
 fw_trace_err:
 	snd_sof_free_trace(sdev);
-fw_run_err:
 	snd_sof_fw_unload(sdev);
 fw_load_err:
 	snd_sof_ipc_free(sdev);
-- 
1.9.3

