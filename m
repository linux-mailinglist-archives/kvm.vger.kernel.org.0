Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5291E7701
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 09:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgE2Hi3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 03:38:29 -0400
Received: from mga07.intel.com ([134.134.136.100]:50716 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgE2HiY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 03:38:24 -0400
IronPort-SDR: AMKKMSL2AaBHiW071Y1Izfqy+tTba4FKAtAL2lO1Xh2KVpBozH+zoAFiiKYVhuYqtxQD7BQMYD
 jE7nlmhKszBg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 00:37:41 -0700
IronPort-SDR: GiVx0fezq3F1ZKpy7X0JIiDvlSShBTEWP79sC7OOar8qo7CY4pZOKaY4RRx8Xskb0vhqcJGKbv
 acyztLZ/IFaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414890394"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.252.45.157])
  by orsmga004.jf.intel.com with ESMTP; 29 May 2020 00:37:38 -0700
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
Subject: [RFC 05/12] ASoC: SOF: add two helper lookup functions
Date:   Fri, 29 May 2020 09:37:15 +0200
Message-Id: <20200529073722.8184-6-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
References: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add two helper lookup functions for finding a widget by its component
ID and a DAI by a pipeline ID.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
---
 sound/soc/sof/sof-audio.c | 24 ++++++++++++++++++++++++
 sound/soc/sof/sof-audio.h |  5 +++++
 sound/soc/sof/topology.c  |  1 +
 3 files changed, 30 insertions(+)

diff --git a/sound/soc/sof/sof-audio.c b/sound/soc/sof/sof-audio.c
index 1c7698f..92fa6a8 100644
--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -395,6 +395,30 @@ struct snd_sof_dai *snd_sof_find_dai(struct snd_soc_component *scomp,
 	return NULL;
 }
 
+struct snd_sof_widget *snd_sof_find_swidget_id(struct snd_sof_dev *sdev,
+					       unsigned int comp_id)
+{
+	struct snd_sof_widget *swidget;
+
+	list_for_each_entry(swidget, &sdev->widget_list, list)
+		if (swidget->comp_id == comp_id)
+			return swidget;
+
+	return NULL;
+}
+
+struct snd_sof_dai *snd_sof_find_dai_pipe(struct snd_sof_dev *sdev,
+					  unsigned int pipeline_id)
+{
+	struct snd_sof_dai *dai;
+
+	list_for_each_entry(dai, &sdev->dai_list, list)
+		if (dai->pipeline_id == pipeline_id)
+			return dai;
+
+	return NULL;
+}
+
 /*
  * SOF Driver enumeration.
  */
diff --git a/sound/soc/sof/sof-audio.h b/sound/soc/sof/sof-audio.h
index 9629994..8054e48 100644
--- a/sound/soc/sof/sof-audio.h
+++ b/sound/soc/sof/sof-audio.h
@@ -106,6 +106,7 @@ struct snd_sof_dai {
 	struct snd_soc_component *scomp;
 	const char *name;
 	const char *cpu_dai_name;
+	unsigned int pipeline_id;
 
 	struct sof_ipc_comp_dai comp_dai;
 	struct sof_ipc_dai_config *dai_config;
@@ -190,6 +191,10 @@ struct snd_sof_pcm *snd_sof_find_spcm_comp(struct snd_soc_component *scomp,
 					   int *direction);
 struct snd_sof_pcm *snd_sof_find_spcm_pcm_id(struct snd_soc_component *scomp,
 					     unsigned int pcm_id);
+struct snd_sof_widget *snd_sof_find_swidget_id(struct snd_sof_dev *sdev,
+					       unsigned int comp_id);
+struct snd_sof_dai *snd_sof_find_dai_pipe(struct snd_sof_dev *sdev,
+					  unsigned int pipeline_id);
 void snd_sof_pcm_period_elapsed(struct snd_pcm_substream *substream);
 void snd_sof_pcm_period_elapsed_work(struct work_struct *work);
 
diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index 6a9703e..5a65dcf 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -1406,6 +1406,7 @@ static int sof_widget_load_dai(struct snd_soc_component *scomp, int index,
 
 	if (ret == 0 && dai) {
 		dai->scomp = scomp;
+		dai->pipeline_id = swidget->pipeline_id;
 		memcpy(&dai->comp_dai, &comp_dai, sizeof(comp_dai));
 	}
 
-- 
1.9.3

