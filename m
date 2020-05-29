Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3936A1E76FC
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 09:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgE2Hik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 03:38:40 -0400
Received: from mga07.intel.com ([134.134.136.100]:50716 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgE2Hif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 03:38:35 -0400
IronPort-SDR: +so94OuY4K8Jd+qADsQFskBbCcFA8opC09j1ZDZ+1vBySUhiUkPjB8TsqDSSnlo0twRiOzJ049
 2kuKEknsTGtg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 00:37:51 -0700
IronPort-SDR: xCG2xd50PP+gGh5dzGmZBinpkWzl52ujfGF/SdxVYUqfFsPB39tBehJiWEh6X3GucLxDvoLIYF
 o41WvgiCqahA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414890419"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.252.45.157])
  by orsmga004.jf.intel.com with ESMTP; 29 May 2020 00:37:48 -0700
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
Subject: [RFC 08/12] ASoC: SOF: add a vhost driver: sound part
Date:   Fri, 29 May 2020 09:37:18 +0200
Message-Id: <20200529073722.8184-9-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
References: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SOF VirtIO driver uses a vhost RPMsg driver as a counterpart to
communicate with the DSP. This patch adds a sound interface of the
vhost driver.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
---
 include/sound/soc-topology.h     |    3 +
 include/sound/sof/rpmsg.h        |   72 +++
 include/uapi/linux/vhost.h       |    5 +
 include/uapi/linux/vhost_types.h |    7 +
 sound/soc/soc-pcm.c              |   31 +-
 sound/soc/sof/Makefile           |    6 +-
 sound/soc/sof/core.c             |    6 +
 sound/soc/sof/ipc.c              |    5 +
 sound/soc/sof/pcm.c              |    4 +-
 sound/soc/sof/pm.c               |    4 +
 sound/soc/sof/sof-audio.c        |    9 +
 sound/soc/sof/sof-audio.h        |   16 +
 sound/soc/sof/sof-priv.h         |   16 +
 sound/soc/sof/topology.c         |   54 +-
 sound/soc/sof/vhost-vbe.c        | 1102 ++++++++++++++++++++++++++++++++++++++
 15 files changed, 1324 insertions(+), 16 deletions(-)
 create mode 100644 sound/soc/sof/vhost-vbe.c

diff --git a/include/sound/soc-topology.h b/include/sound/soc-topology.h
index 5223896..ea0c2a64 100644
--- a/include/sound/soc-topology.h
+++ b/include/sound/soc-topology.h
@@ -34,6 +34,9 @@
 /* object scan be loaded and unloaded in groups with identfying indexes */
 #define SND_SOC_TPLG_INDEX_ALL	0	/* ID that matches all FW objects */
 
+#define SOC_VIRT_DAI_PLAYBACK "VM FE Playback"
+#define SOC_VIRT_DAI_CAPTURE "VM FE Capture"
+
 /* dynamic object type */
 enum snd_soc_dobj_type {
 	SND_SOC_DOBJ_NONE		= 0,	/* object is not dynamic */
diff --git a/include/sound/sof/rpmsg.h b/include/sound/sof/rpmsg.h
index 73dc34c..ce522c6 100644
--- a/include/sound/sof/rpmsg.h
+++ b/include/sound/sof/rpmsg.h
@@ -11,6 +11,7 @@
 #ifndef _SOF_RPMSG_H
 #define _SOF_RPMSG_H
 
+#include <linux/list.h>
 #include <linux/virtio_rpmsg.h>
 
 #include <sound/sof/header.h>
@@ -117,4 +118,75 @@ struct sof_rpmsg_ipc_req {
 	u8 ipc_msg[SOF_IPC_MSG_MAX_SIZE];
 } __packed;
 
+struct snd_sof_dev;
+struct sof_ipc_stream_posn;
+
+#if IS_ENABLED(CONFIG_VHOST_SOF)
+struct firmware;
+
+struct vhost_dsp;
+struct sof_vhost_ops {
+	int (*update_posn)(struct vhost_dsp *dsp,
+			   struct sof_ipc_stream_posn *posn);
+};
+
+struct sof_vhost_client {
+	const struct firmware *fw;
+	struct snd_sof_dev *sdev;
+	/* List of guest endpoints, connecting to the host mixer or demux */
+	struct list_head pipe_conn;
+	/* List of vhost instances on a DSP */
+	struct list_head list;
+
+	/* Component ID range index in the bitmap */
+	unsigned int id;
+
+	/* the comp_ids for this vm audio */
+	int comp_id_begin;
+	int comp_id_end;
+
+	unsigned int reset_count;
+
+	struct vhost_dsp *vhost;
+};
+
+/* The below functions are only referenced when VHOST_SOF is selected */
+struct device;
+void sof_vhost_client_release(struct sof_vhost_client *client);
+struct sof_vhost_client *sof_vhost_client_add(struct snd_sof_dev *sdev,
+					      struct vhost_dsp *dsp);
+struct device *sof_vhost_dev_init(const struct sof_vhost_ops *ops);
+struct vhost_adsp_topology;
+int sof_vhost_set_tplg(struct sof_vhost_client *client,
+		       const struct vhost_adsp_topology *tplg);
+/* Copy audio data between DMA and VirtQueue */
+void *sof_vhost_stream_data(struct sof_vhost_client *client,
+			    const struct sof_rpmsg_data_req *req,
+			    struct sof_rpmsg_data_resp *resp);
+/* Forward an IPC message from a guest to the DSP */
+int sof_vhost_ipc_fwd(struct sof_vhost_client *client,
+		      void *ipc_buf, void *reply_buf,
+		      size_t count, size_t reply_sz);
+
+/* The below functions are always referenced, they need dummy counterparts */
+int sof_vhost_update_guest_posn(struct snd_sof_dev *sdev,
+				struct sof_ipc_stream_posn *posn);
+void sof_vhost_suspend(struct snd_sof_dev *sdev);
+void sof_vhost_dev_set(struct snd_sof_dev *sdev);
+#else
+static inline int sof_vhost_update_guest_posn(struct snd_sof_dev *sdev,
+					      struct sof_ipc_stream_posn *posn)
+{
+	return 0;
+}
+
+static inline void sof_vhost_suspend(struct snd_sof_dev *sdev)
+{
+}
+
+static inline void sof_vhost_dev_set(struct snd_sof_dev *sdev)
+{
+}
+#endif
+
 #endif
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index b54af9d..aa258e2 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -142,4 +142,9 @@
 /* Get the max ring size. */
 #define VHOST_VDPA_GET_VRING_NUM	_IOR(VHOST_VIRTIO, 0x76, __u16)
 
+/* VHOST_ADSP specific defines */
+
+#define VHOST_ADSP_SET_GUEST_TPLG	_IOW(VHOST_VIRTIO, 0x80,	\
+					struct vhost_adsp_topology)
+
 #endif
diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
index 669457c..6364bc8 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -13,6 +13,7 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/limits.h>
 #include <linux/virtio_config.h>
 #include <linux/virtio_ring.h>
 
@@ -127,6 +128,12 @@ struct vhost_vdpa_config {
 	__u8 buf[0];
 };
 
+/* VHOST_ADSP */
+
+struct vhost_adsp_topology {
+	char name[NAME_MAX + 1];
+};
+
 /* Feature bits */
 /* Log all write descriptors. Can be changed while device is active. */
 #define VHOST_F_LOG_ALL 26
diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index eb19a8e..57165769 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -24,6 +24,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/soc-dpcm.h>
+#include <sound/soc-topology.h>
 #include <sound/initval.h>
 
 #define DPCM_MAX_BE_USERS	8
@@ -1418,10 +1419,15 @@ static bool dpcm_end_walk_at_be(struct snd_soc_dapm_widget *widget,
 	int stream;
 
 	/* adjust dir to stream */
-	if (dir == SND_SOC_DAPM_DIR_OUT)
+	if (dir == SND_SOC_DAPM_DIR_OUT) {
+		if (!strcmp(widget->sname, SOC_VIRT_DAI_PLAYBACK))
+			return false;
 		stream = SNDRV_PCM_STREAM_PLAYBACK;
-	else
+	} else {
+		if (!strcmp(widget->sname, SOC_VIRT_DAI_CAPTURE))
+			return false;
 		stream = SNDRV_PCM_STREAM_CAPTURE;
+	}
 
 	rtd = dpcm_get_be(card, widget, stream);
 	if (rtd)
@@ -2977,14 +2983,6 @@ int soc_new_pcm(struct snd_soc_pcm_runtime *rtd, int num)
 	rtd->pcm = pcm;
 	pcm->private_data = rtd;
 
-	if (rtd->dai_link->no_pcm || rtd->dai_link->params) {
-		if (playback)
-			pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream->private_data = rtd;
-		if (capture)
-			pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream->private_data = rtd;
-		goto out;
-	}
-
 	/* ASoC PCM operations */
 	if (rtd->dai_link->dynamic) {
 		rtd->ops.open		= dpcm_fe_dai_open;
@@ -3004,6 +3002,19 @@ int soc_new_pcm(struct snd_soc_pcm_runtime *rtd, int num)
 		rtd->ops.pointer	= soc_pcm_pointer;
 	}
 
+	if (rtd->dai_link->no_pcm || rtd->dai_link->params) {
+		/*
+		 * Usually in this case we also don't need to assign .ops
+		 * callbacks, but in case of a "no PCM" pipeline, used by a VM
+		 * we use the .prepare() hook to configure the hardware.
+		 */
+		if (playback)
+			pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream->private_data = rtd;
+		if (capture)
+			pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream->private_data = rtd;
+		goto out;
+	}
+
 	for_each_rtd_components(rtd, i, component) {
 		const struct snd_soc_component_driver *drv = component->driver;
 
diff --git a/sound/soc/sof/Makefile b/sound/soc/sof/Makefile
index 34142ba..872457c 100644
--- a/sound/soc/sof/Makefile
+++ b/sound/soc/sof/Makefile
@@ -3,6 +3,8 @@
 snd-sof-objs := core.o ops.o loader.o ipc.o pcm.o pm.o debug.o topology.o\
 		control.o trace.o utils.o sof-audio.o
 snd-sof-$(CONFIG_SND_SOC_SOF_DEBUG_PROBES) += probe.o compress.o
+snd-sof-$(CONFIG_SND_SOC_SOF_RPMSG_FE) += rpmsg-vfe.o
+snd-sof-$(CONFIG_VHOST_SOF) += vhost-vbe.o
 
 snd-sof-pci-objs := sof-pci-dev.o
 snd-sof-acpi-objs := sof-acpi-dev.o
@@ -10,10 +12,6 @@ snd-sof-of-objs := sof-of-dev.o
 
 snd-sof-nocodec-objs := nocodec.o
 
-ifdef CONFIG_SND_SOC_SOF_RPMSG_FE
-snd-sof-objs += rpmsg-vfe.o
-endif
-
 obj-$(CONFIG_SND_SOC_SOF) += snd-sof.o
 obj-$(CONFIG_SND_SOC_SOF_NOCODEC) += snd-sof-nocodec.o
 
diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index 2515b57..c74c6ec 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -13,6 +13,8 @@
 #include <linux/module.h>
 #include <sound/soc.h>
 #include <sound/sof.h>
+#include <sound/sof/rpmsg.h>
+#include "sof-audio.h"
 #include "sof-priv.h"
 #include "ops.h"
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_DEBUG_PROBES)
@@ -222,6 +224,9 @@ static int sof_probe_continue(struct snd_sof_dev *sdev)
 		goto dbg_err;
 	}
 
+	/* enable the vhost driver on this device */
+	sof_vhost_dev_set(sdev);
+
 	/* init the IPC */
 	sdev->ipc = snd_sof_ipc_init(sdev);
 	if (!sdev->ipc) {
@@ -334,6 +339,7 @@ int snd_sof_device_probe(struct device *dev, struct snd_sof_pdata *plat_data)
 	INIT_LIST_HEAD(&sdev->widget_list);
 	INIT_LIST_HEAD(&sdev->dai_list);
 	INIT_LIST_HEAD(&sdev->route_list);
+	INIT_LIST_HEAD(&sdev->vbe_list);
 	spin_lock_init(&sdev->ipc_lock);
 	spin_lock_init(&sdev->hw_lock);
 
diff --git a/sound/soc/sof/ipc.c b/sound/soc/sof/ipc.c
index 3e788d9..d3e54cf 100644
--- a/sound/soc/sof/ipc.c
+++ b/sound/soc/sof/ipc.c
@@ -14,6 +14,8 @@
 #include <linux/mutex.h>
 #include <linux/types.h>
 
+#include <sound/sof/rpmsg.h>
+
 #include "sof-priv.h"
 #include "sof-audio.h"
 #include "ops.h"
@@ -452,6 +454,9 @@ static void ipc_period_elapsed(struct snd_sof_dev *sdev, u32 msg_id)
 
 	memcpy(&stream->posn, &posn, sizeof(posn));
 
+	/* optionally update position for vBE */
+	sof_vhost_update_guest_posn(sdev, &posn);
+
 	/* only inform ALSA for period_wakeup mode */
 	if (!stream->substream->runtime->no_period_wakeup)
 		snd_sof_pcm_period_elapsed(stream->substream);
diff --git a/sound/soc/sof/pcm.c b/sound/soc/sof/pcm.c
index bb8d597..1cd0082 100644
--- a/sound/soc/sof/pcm.c
+++ b/sound/soc/sof/pcm.c
@@ -91,7 +91,8 @@ void snd_sof_pcm_period_elapsed(struct snd_pcm_substream *substream)
 	 * To avoid sending IPC before the previous IPC is handled, we
 	 * schedule delayed work here to call the snd_pcm_period_elapsed().
 	 */
-	schedule_work(&spcm->stream[substream->stream].period_elapsed_work);
+	if (spcm->stream[substream->stream].substream)
+		schedule_work(&spcm->stream[substream->stream].period_elapsed_work);
 }
 EXPORT_SYMBOL(snd_sof_pcm_period_elapsed);
 
@@ -758,6 +759,7 @@ static int sof_pcm_probe(struct snd_soc_component *component)
 
 	/* load the default topology */
 	sdev->component = component;
+	sdev->card = component->card;
 
 	tplg_filename = devm_kasprintf(sdev->dev, GFP_KERNEL,
 				       "%s/%s",
diff --git a/sound/soc/sof/pm.c b/sound/soc/sof/pm.c
index c7aa2cf..3584787 100644
--- a/sound/soc/sof/pm.c
+++ b/sound/soc/sof/pm.c
@@ -8,6 +8,8 @@
 // Author: Liam Girdwood <liam.r.girdwood@linux.intel.com>
 //
 
+#include <sound/sof/rpmsg.h>
+
 #include "ops.h"
 #include "sof-priv.h"
 #include "sof-audio.h"
@@ -253,6 +255,8 @@ static int sof_suspend(struct device *dev, bool runtime_suspend)
 	/* reset FW state */
 	sdev->fw_state = SOF_FW_BOOT_NOT_STARTED;
 
+	sof_vhost_suspend(sdev);
+
 	return ret;
 }
 
diff --git a/sound/soc/sof/sof-audio.c b/sound/soc/sof/sof-audio.c
index 92fa6a8..2a8b8dc 100644
--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -151,6 +151,7 @@ int sof_restore_pipelines(struct device *dev)
 	struct snd_sof_dai *dai;
 	struct sof_ipc_comp_dai *comp_dai;
 	struct sof_ipc_cmd_hdr *hdr;
+	struct sof_ipc_buffer *buffer;
 	int ret;
 
 	/* restore pipeline components */
@@ -182,6 +183,14 @@ int sof_restore_pipelines(struct device *dev)
 			pipeline = swidget->private;
 			ret = sof_load_pipeline_ipc(dev, pipeline, &r);
 			break;
+
+		case snd_soc_dapm_buffer:
+
+			buffer = swidget->private;
+			if (!buffer->size)
+				break;
+
+			/* Fall through */
 		default:
 			hdr = swidget->private;
 			ret = sof_ipc_tx_message(sdev->ipc, hdr->cmd,
diff --git a/sound/soc/sof/sof-audio.h b/sound/soc/sof/sof-audio.h
index 8054e48..5e95a6c 100644
--- a/sound/soc/sof/sof-audio.h
+++ b/sound/soc/sof/sof-audio.h
@@ -41,6 +41,7 @@ struct snd_sof_pcm_stream {
 	 * active or not while suspending the stream
 	 */
 	bool suspend_ignored;
+	size_t guest_offset;
 };
 
 /* ALSA SOF PCM device */
@@ -217,4 +218,19 @@ int snd_sof_ipc_set_get_comp_data(struct snd_sof_control *scontrol,
 int sof_machine_register(struct snd_sof_dev *sdev, void *pdata);
 void sof_machine_unregister(struct snd_sof_dev *sdev, void *pdata);
 
+#if IS_ENABLED(CONFIG_VHOST_SOF)
+int sof_vhost_add_conn(struct snd_sof_dev *sdev,
+		     struct snd_sof_widget *w_host,
+		     struct snd_sof_widget *w_guest,
+		     enum sof_ipc_stream_direction direction);
+#else
+static inline int sof_vhost_add_conn(struct snd_sof_dev *sdev,
+				   struct snd_sof_widget *w_host,
+				   struct snd_sof_widget *w_guest,
+				   enum sof_ipc_stream_direction direction)
+{
+	return 0;
+}
+#endif
+
 #endif
diff --git a/sound/soc/sof/sof-priv.h b/sound/soc/sof/sof-priv.h
index 2da2469..c11ef1a 100644
--- a/sound/soc/sof/sof-priv.h
+++ b/sound/soc/sof/sof-priv.h
@@ -57,6 +57,18 @@
 
 /* The maximum number of components a virtio user vFE driver can use */
 #define SOF_RPMSG_MAX_UOS_COMPS	1000
+#define SOF_RPMSG_COMP_ID_UNASSIGNED	0xffffffff
+
+/*
+ * in virtio iovec array:
+ *  iovec[0]: the ipc message data between vFE and vBE
+ *  iovec[1]: the ipc reply data between vFE and vBE
+ */
+#define SOF_RPMSG_IPC_MSG 0
+#define SOF_RPMSG_IPC_REPLY 1
+
+/* Maximum supported number of VirtIO clients */
+#define SND_SOF_MAX_VFES BITS_PER_LONG
 
 /* DSP power state */
 enum sof_dsp_power_states {
@@ -368,6 +380,7 @@ struct snd_sof_dev {
 	 * can't use const
 	 */
 	struct snd_soc_component_driver plat_drv;
+	struct snd_soc_card *card;
 
 	/* current DSP power state */
 	struct sof_dsp_power_state dsp_power_state;
@@ -435,6 +448,9 @@ struct snd_sof_dev {
 
 	/* VirtIO fields for host and guest */
 	atomic_t dsp_reset_count;
+	struct list_head vbe_list;
+	struct list_head connector_list;
+	unsigned long vfe_mask[DIV_ROUND_UP(SND_SOF_MAX_VFES, BITS_PER_LONG)];
 
 	/* DMA for Trace */
 	struct snd_dma_buffer dmatb;
diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index bb9fcb6..ed05381 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -1454,6 +1454,13 @@ static int sof_widget_load_buffer(struct snd_soc_component *scomp, int index,
 
 	swidget->private = buffer;
 
+	/*
+	 * VirtIO dummy buffers between a dummy "aif_in" / "aif_out" widget and
+	 * a mixer / demux respectively
+	 */
+	if (!buffer->size)
+		return 0;
+
 	ret = sof_ipc_tx_message(sdev->ipc, buffer->comp.hdr.cmd, buffer,
 				 sizeof(*buffer), r, sizeof(*r));
 	if (ret < 0) {
@@ -1499,6 +1506,16 @@ static int sof_widget_load_pcm(struct snd_soc_component *scomp, int index,
 	struct sof_ipc_comp_host *host;
 	int ret;
 
+	/*
+	 * For now just drop any virtual PCMs. Might need to use a more robust
+	 * identification than the name
+	 */
+	if ((dir == SOF_IPC_STREAM_PLAYBACK &&
+	     !strcmp(SOC_VIRT_DAI_PLAYBACK, swidget->widget->sname)) ||
+	    (dir == SOF_IPC_STREAM_CAPTURE &&
+	     !strcmp(SOC_VIRT_DAI_CAPTURE, swidget->widget->sname)))
+		return 0;
+
 	host = kzalloc(sizeof(*host), GFP_KERNEL);
 	if (!host)
 		return -ENOMEM;
@@ -3128,6 +3145,15 @@ static int sof_link_load(struct snd_soc_component *scomp, int index,
 		link->trigger[SNDRV_PCM_STREAM_CAPTURE] =
 					SND_SOC_DPCM_TRIGGER_POST;
 
+		/*
+		 * set .no_pcm on VirtIO hosts for pseudo PCMs, used as anchors
+		 * for guest pipeline linking
+		 */
+		if (link->stream_name &&
+		    (!strcmp(link->stream_name, "vm_fe_playback") ||
+		     !strcmp(link->stream_name, "vm_fe_capture")))
+			link->no_pcm = true;
+
 		/* nothing more to do for FE dai links */
 		return 0;
 	}
@@ -3349,6 +3375,32 @@ static int sof_route_load(struct snd_soc_component *scomp, int index,
 	}
 
 	/*
+	 * In VirtIO case the host topology will contain a dummy PCM and a
+	 * buffer at each location, where a partial guest topology will be
+	 * attached. These dummy widgets shall not be sent to the DSP. We use
+	 * them to identify and store VirtIO guest connection points.
+	 */
+	if (source_swidget->id == snd_soc_dapm_buffer) {
+		struct sof_ipc_buffer *buffer = source_swidget->private;
+		/* Is this a virtual playback buffer? */
+		if (!buffer->size) {
+			ret = sof_vhost_add_conn(sdev, sink_swidget,
+					       source_swidget,
+					       SOF_IPC_STREAM_PLAYBACK);
+			goto err;
+		}
+	} else if (sink_swidget->id == snd_soc_dapm_buffer) {
+		struct sof_ipc_buffer *buffer = sink_swidget->private;
+		/* Is this a virtual capture buffer? */
+		if (!buffer->size) {
+			ret = sof_vhost_add_conn(sdev, source_swidget,
+					       sink_swidget,
+					       SOF_IPC_STREAM_CAPTURE);
+			goto err;
+		}
+	}
+
+	/*
 	 * Don't send routes whose sink widget is of type
 	 * output or out_drv to the DSP
 	 */
@@ -3615,7 +3667,7 @@ int snd_sof_load_topology(struct snd_soc_component *scomp, const char *file)
 	/* VirtIO guests request topology from the host */
 	if (sdev->pdata->vfe) {
 		fw = &vfe_fw;
-		ret = sof_ops(sdev)->request_topology(sdev, file, &vfe_fw);
+		ret = sof_ops(sdev)->request_topology(sdev, &vfe_fw);
 	} else {
 		ret = request_firmware(&fw, file, sdev->dev);
 	}
diff --git a/sound/soc/sof/vhost-vbe.c b/sound/soc/sof/vhost-vbe.c
new file mode 100644
index 00000000..8056e25
--- /dev/null
+++ b/sound/soc/sof/vhost-vbe.c
@@ -0,0 +1,1102 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
+/*
+ * Copyright(c) 2017-2020 Intel Corporation. All rights reserved.
+ *
+ * Author:	Libin Yang <libin.yang@intel.com>
+ *		Luo Xionghu <xionghu.luo@intel.com>
+ *		Liam Girdwood <liam.r.girdwood@linux.intel.com>
+ *		Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
+ */
+
+#include <asm/unaligned.h>
+
+#include <linux/atomic.h>
+#include <linux/device.h>
+#include <linux/file.h>
+#include <linux/firmware.h>
+#include <linux/fs.h>
+#include <linux/hw_random.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/uio.h>
+#include <linux/vhost_types.h>
+#include <linux/vmalloc.h>
+#include <linux/workqueue.h>
+
+#include <sound/pcm_params.h>
+#include <sound/sof.h>
+
+#include <sound/sof/rpmsg.h>
+
+#include "sof-audio.h"
+#include "sof-priv.h"
+#include "ops.h"
+
+/* A connection of a guest pipeline into the host topology */
+struct dsp_pipeline_connect {
+	int host_pipeline_id;
+	int guest_pipeline_id;
+	int host_component_id;
+	int guest_component_id;
+	enum sof_ipc_stream_direction direction;
+	struct list_head list;
+};
+
+static const char dsp_pcm_name[] = "VHost PCM";
+
+/*
+ * This function is used to find a BE substream. It uses the dai_link stream
+ * name for that. The current dai_link stream names are "vm_fe_playback" and
+ * "vm_fe_capture," which means only one Virtual Machine is supported and the VM
+ * only supports one playback pcm and one capture pcm. After we switch to the
+ * new topology, we can support multiple VMs and multiple PCM streams for each
+ * VM. This function may be abandoned after switching to the new topology.
+ *
+ * Note: if this function returns substream != NULL, then *rtd != NULL too (if
+ * rtd != NULL, of course). If it returns NULL, *rtd hasn't been changed.
+ */
+static struct snd_pcm_substream *sof_vhost_get_substream(
+					struct snd_sof_dev *sdev,
+					struct snd_soc_pcm_runtime **rtd,
+					int direction)
+{
+	struct snd_soc_card *card = sdev->card;
+	struct snd_soc_pcm_runtime *r;
+
+	for_each_card_rtds(card, r) {
+		struct snd_pcm_substream *substream;
+		struct snd_pcm *pcm = r->pcm;
+		if (!pcm || !pcm->internal)
+			continue;
+
+		/* Find a substream dedicated to the vFE. */
+		substream = pcm->streams[direction].substream;
+		if (substream) {
+			struct snd_soc_dai_link *dai_link = r->dai_link;
+
+			/* FIXME: replace hard-coded stream name */
+			if (dai_link->stream_name &&
+			    (!strcmp(dai_link->stream_name, "vm_fe_playback") ||
+			     !strcmp(dai_link->stream_name, "vm_fe_capture"))) {
+				if (rtd)
+					*rtd = r;
+				return substream;
+			}
+		}
+	}
+
+	return NULL;
+}
+
+static struct snd_sof_pcm *sof_vhost_find_spcm_comp(struct snd_sof_dev *sdev,
+						    unsigned int comp_id,
+						    int *direction)
+{
+	return snd_sof_find_spcm_comp(sdev->component, comp_id, direction);
+}
+
+/*
+ * Prepare hardware parameters, required for buffer allocation and PCM
+ * configuration
+ */
+static int sof_vhost_assemble_params(struct sof_ipc_pcm_params *pcm,
+				     struct snd_pcm_hw_params *params)
+{
+	struct snd_mask *fmt = hw_param_mask(params, SNDRV_PCM_HW_PARAM_FORMAT);
+
+	hw_param_interval(params, SNDRV_PCM_HW_PARAM_CHANNELS)->min =
+		pcm->params.channels;
+
+	hw_param_interval(params, SNDRV_PCM_HW_PARAM_RATE)->min =
+		pcm->params.rate;
+
+	hw_param_interval(params, SNDRV_PCM_HW_PARAM_PERIOD_BYTES)->min =
+		pcm->params.host_period_bytes;
+
+	hw_param_interval(params, SNDRV_PCM_HW_PARAM_BUFFER_BYTES)->min =
+		pcm->params.buffer.size;
+
+	snd_mask_none(fmt);
+	switch (pcm->params.frame_fmt) {
+	case SOF_IPC_FRAME_S16_LE:
+		snd_mask_set(fmt, SNDRV_PCM_FORMAT_S16);
+		break;
+	case SOF_IPC_FRAME_S24_4LE:
+		snd_mask_set(fmt, SNDRV_PCM_FORMAT_S24);
+		break;
+	case SOF_IPC_FRAME_S32_LE:
+		snd_mask_set(fmt, SNDRV_PCM_FORMAT_S32);
+		break;
+	case SOF_IPC_FRAME_FLOAT:
+		snd_mask_set(fmt, SNDRV_PCM_FORMAT_FLOAT);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/* Handle SOF_IPC_STREAM_PCM_PARAMS IPC */
+static int sof_vhost_stream_hw_params(struct snd_sof_dev *sdev,
+				      struct sof_ipc_pcm_params *pcm)
+{
+	struct snd_pcm_substream *substream;
+	struct snd_pcm_runtime *runtime;
+	struct snd_pcm_hw_params params;
+	int direction = pcm->params.direction;
+	int ret;
+
+	/* find the proper substream */
+	substream = sof_vhost_get_substream(sdev, NULL, direction);
+	if (!substream)
+		return -ENODEV;
+
+	runtime = substream->runtime;
+	if (!runtime) {
+		dev_err(sdev->dev, "no runtime is available for hw_params\n");
+		return -ENODEV;
+	}
+
+	/* TODO: codec hw_params */
+
+	/* Use different stream_tag from FE. This is the real tag */
+	sof_vhost_assemble_params(pcm, &params);
+
+	/* Allocate a duplicate of the guest buffer */
+	ret = snd_pcm_lib_malloc_pages(substream, params_buffer_bytes(&params));
+	if (ret < 0) {
+		dev_err(sdev->dev,
+			"error %d: could not allocate %d bytes for PCM \"%s\"\n",
+			ret, params_buffer_bytes(&params), substream->pcm->name);
+		return ret;
+	}
+
+	return snd_sof_pcm_platform_hw_params(sdev, substream, &params,
+					      &pcm->params);
+}
+
+/* Allocate a runtime object and buffer pages */
+static int sof_vhost_pcm_open(struct snd_sof_dev *sdev, void *ipc_data)
+{
+	struct snd_pcm_substream *substream;
+	struct snd_soc_pcm_runtime *rtd;
+	struct sof_ipc_pcm_params *pcm = ipc_data;
+	struct snd_pcm_runtime *runtime;
+	struct snd_sof_pcm *spcm;
+	u32 comp_id = pcm->comp_id;
+	size_t size;
+	int direction, ret;
+
+	spcm = sof_vhost_find_spcm_comp(sdev, comp_id, &direction);
+	if (!spcm) {
+		dev_err(sdev->dev, "%s(): no SPCM for comp %u\n", __func__, comp_id);
+		return -ENODEV;
+	}
+
+	substream = sof_vhost_get_substream(sdev, &rtd, direction);
+	if (!substream) {
+		dev_err(sdev->dev, "%s(): no substream for comp %u\n",
+			__func__, comp_id);
+		return -ENODEV;
+	}
+	if (substream->ref_count > 0)
+		return -EBUSY;
+	substream->ref_count++;	/* set it used */
+
+	runtime = kzalloc(sizeof(*runtime), GFP_KERNEL);
+	if (!runtime)
+		return -ENOMEM;
+
+	size = PAGE_ALIGN(sizeof(struct snd_pcm_mmap_status));
+	runtime->status = alloc_pages_exact(size, GFP_KERNEL);
+	if (!runtime->status) {
+		ret = -ENOMEM;
+		goto eruntime;
+	}
+	memset((void *)runtime->status, 0, size);
+
+	size = PAGE_ALIGN(sizeof(struct snd_pcm_mmap_control));
+	runtime->control = alloc_pages_exact(size, GFP_KERNEL);
+	if (!runtime->control) {
+		dev_err(sdev->dev, "fail to alloc pages for runtime->control");
+		ret = -ENOMEM;
+		goto estatus;
+	}
+	memset((void *)runtime->control, 0, size);
+
+	init_waitqueue_head(&runtime->sleep);
+	init_waitqueue_head(&runtime->tsleep);
+	runtime->status->state = SNDRV_PCM_STATE_OPEN;
+
+	substream->runtime = runtime;
+	substream->private_data = rtd;
+	rtd->dpcm[direction].runtime = runtime;
+	substream->stream = direction;
+
+	substream->dma_buffer.dev.type = SNDRV_DMA_TYPE_DEV_SG;
+	substream->dma_buffer.dev.dev = sdev->dev;
+
+	/* check with spcm exists or not */
+	spcm->stream[direction].posn.host_posn = 0;
+	spcm->stream[direction].posn.dai_posn = 0;
+	spcm->stream[direction].substream = substream;
+	spcm->stream[direction].guest_offset = 0;
+
+	/* TODO: codec open */
+
+	snd_sof_pcm_platform_open(sdev, substream);
+
+	return 0;
+
+estatus:
+	free_pages_exact(runtime->status,
+			 PAGE_ALIGN(sizeof(struct snd_pcm_mmap_status)));
+eruntime:
+	kfree(runtime);
+	return ret;
+}
+
+static void sof_vhost_stream_close(struct snd_sof_dev *sdev, int direction)
+{
+	struct snd_pcm_substream *substream = sof_vhost_get_substream(sdev,
+							NULL, direction);
+	if (!substream)
+		return;
+
+	/* TODO: codec close */
+
+	substream->ref_count = 0;
+	if (substream->runtime) {
+		snd_sof_pcm_platform_close(sdev, substream);
+
+		free_pages_exact(substream->runtime->status,
+				 PAGE_ALIGN(sizeof(struct snd_pcm_mmap_status)));
+		free_pages_exact(substream->runtime->control,
+				 PAGE_ALIGN(sizeof(struct snd_pcm_mmap_control)));
+		kfree(substream->runtime);
+		substream->runtime = NULL;
+	}
+}
+
+/* Handle the SOF_IPC_STREAM_PCM_FREE IPC */
+static int sof_vhost_pcm_close(struct snd_sof_dev *sdev, void *ipc_data)
+{
+	struct snd_sof_pcm *spcm;
+	struct sof_ipc_stream *stream;
+	int direction;
+
+	stream = (struct sof_ipc_stream *)ipc_data;
+
+	spcm = sof_vhost_find_spcm_comp(sdev, stream->comp_id, &direction);
+	if (!spcm)
+		return 0;
+
+	sof_vhost_stream_close(sdev, direction);
+
+	return 0;
+}
+
+/* Copy audio data from DMA buffers for capture */
+static void *sof_vhost_stream_capture(struct snd_sof_pcm_stream *stream,
+				      struct snd_pcm_runtime *runtime,
+				      const struct sof_rpmsg_data_req *req,
+				      struct sof_rpmsg_data_resp *resp)
+{
+	size_t data_size = req->size;
+
+	stream->guest_offset = req->offset;
+
+	if (req->offset + data_size > runtime->dma_bytes) {
+		resp->size = 0;
+		resp->error = -ENOBUFS;
+		return ERR_PTR(resp->error);
+	}
+
+	stream->guest_offset += data_size;
+
+	resp->size = data_size;
+	resp->error = 0;
+
+	return runtime->dma_area + req->offset;
+}
+
+/* Copy audio data to DMA buffers for playback */
+static void *sof_vhost_stream_playback(struct snd_sof_pcm_stream *stream,
+				       struct snd_pcm_runtime *runtime,
+				       const struct sof_rpmsg_data_req *req,
+				       struct sof_rpmsg_data_resp *resp)
+{
+	size_t data_size = req->size;
+
+	stream->guest_offset = req->offset;
+
+	resp->size = 0;
+
+	if (req->offset + data_size > runtime->dma_bytes) {
+		resp->error = -ENOBUFS;
+		return ERR_PTR(resp->error);
+	}
+
+	stream->guest_offset += data_size;
+
+	resp->error = 0;
+
+	return runtime->dma_area + req->offset;
+}
+
+/* Send or receive audio data */
+void *sof_vhost_stream_data(struct sof_vhost_client *client,
+			    const struct sof_rpmsg_data_req *req,
+			    struct sof_rpmsg_data_resp *resp)
+{
+	int direction;
+	struct snd_sof_dev *sdev = client->sdev;
+	struct snd_sof_pcm *spcm = sof_vhost_find_spcm_comp(sdev,
+						req->comp_id, &direction);
+	struct snd_pcm_substream *substream = sof_vhost_get_substream(sdev,
+							NULL, direction);
+
+	if (!spcm || !substream) {
+		resp->error = -ENODEV;
+		resp->size = 0;
+		return ERR_PTR(resp->error);
+	}
+
+	if (direction == SNDRV_PCM_STREAM_PLAYBACK)
+		return sof_vhost_stream_playback(spcm->stream + direction,
+						 substream->runtime, req, resp);
+
+	return sof_vhost_stream_capture(spcm->stream + direction,
+					substream->runtime, req, resp);
+}
+EXPORT_SYMBOL_GPL(sof_vhost_stream_data);
+
+/* Handle the stream IPC */
+static int sof_vhost_ipc_stream(struct snd_sof_dev *sdev,
+				struct sof_ipc_cmd_hdr *hdr, void *reply_buf)
+{
+	struct sof_ipc_pcm_params *pcm;
+	struct sof_ipc_stream *stream;
+	struct snd_soc_pcm_runtime *rtd;
+	struct snd_pcm_substream *substream;
+	int ret = 0, direction, comp_id;
+	u32 cmd = hdr->cmd & SOF_CMD_TYPE_MASK;
+	struct snd_soc_dpcm *dpcm;
+
+	switch (cmd) {
+	case SOF_IPC_STREAM_PCM_PARAMS:
+		ret = sof_vhost_pcm_open(sdev, hdr);
+		if (ret < 0)
+			break;
+		pcm = container_of(hdr, struct sof_ipc_pcm_params, hdr);
+		ret = sof_vhost_stream_hw_params(sdev, pcm);
+		break;
+	case SOF_IPC_STREAM_TRIG_START:
+		stream = container_of(hdr, struct sof_ipc_stream, hdr);
+		comp_id = stream->comp_id;
+		if (!sof_vhost_find_spcm_comp(sdev, comp_id, &direction)) {
+			ret = -ENODEV;
+			break;
+		}
+		substream = sof_vhost_get_substream(sdev, &rtd, direction);
+		if (!substream) {
+			ret = -ENODEV;
+			break;
+		}
+
+		/* Create an RTD, a CPU DAI when parsing aif_in */
+		snd_soc_runtime_activate(rtd, direction);
+		snd_soc_dpcm_runtime_update(sdev->card,
+					    SND_SOC_DPCM_UPDATE_NEW_ONLY);
+
+		dpcm = list_first_entry(&rtd->dpcm[direction].be_clients,
+					struct snd_soc_dpcm, list_be);
+
+		if (list_empty(&rtd->dpcm[direction].be_clients))
+			dev_warn(rtd->dev, "BE client list empty\n");
+		else if (!dpcm->be)
+			dev_warn(rtd->dev, "No BE\n");
+		else
+			dpcm->be->dpcm[direction].state =
+				SND_SOC_DPCM_STATE_HW_PARAMS;
+
+		ret = rtd->ops.prepare(substream);
+		if (ret < 0)
+			break;
+		snd_sof_pcm_platform_trigger(sdev, substream,
+					     SNDRV_PCM_TRIGGER_START);
+		break;
+	case SOF_IPC_STREAM_PCM_FREE:
+		sof_vhost_pcm_close(sdev, hdr);
+		break;
+	}
+
+	return ret;
+}
+
+/* validate component IPC */
+static int sof_vhost_ipc_comp(struct sof_vhost_client *client,
+			      struct sof_ipc_cmd_hdr *hdr)
+{
+	struct sof_ipc_ctrl_data *cdata = container_of(hdr,
+					struct sof_ipc_ctrl_data, rhdr.hdr);
+
+	return cdata->comp_id < client->comp_id_begin ||
+		cdata->comp_id >= client->comp_id_end ? -EINVAL : 0;
+}
+
+/* process PM IPC */
+static int sof_vhost_ipc_pm(struct sof_vhost_client *client,
+			    struct sof_ipc_cmd_hdr *hdr,
+			    struct sof_rpmsg_ipc_power_resp *resp)
+{
+	struct snd_sof_dev *sdev = client->sdev;
+	u32 cmd = hdr->cmd & SOF_CMD_TYPE_MASK;
+	struct sof_rpmsg_ipc_power_req *rq;
+	unsigned int reset_count;
+	int ret;
+
+	switch (cmd) {
+	case SOF_IPC_PM_VFE_POWER_STATUS:
+		rq = container_of(hdr, struct sof_rpmsg_ipc_power_req, hdr);
+		if (rq->power) {
+			ret = pm_runtime_get_sync(sdev->dev);
+			if (ret < 0)
+				return ret;
+		}
+
+		/*
+		 * The DSP is runtime-PM active now for IPC processing, so
+		 * .reset_count won't change
+		 */
+		reset_count = atomic_read(&sdev->dsp_reset_count);
+		resp->reply.hdr.size = sizeof(*resp);
+		resp->reply.hdr.cmd = SOF_IPC_GLB_PM_MSG |
+			SOF_IPC_PM_VFE_POWER_STATUS;
+		resp->reply.error = 0;
+		resp->reset_status = reset_count == client->reset_count ?
+			SOF_RPMSG_IPC_RESET_NONE : SOF_RPMSG_IPC_RESET_DONE;
+
+		if (!rq->power) {
+			pm_runtime_mark_last_busy(sdev->dev);
+			pm_runtime_put_autosuspend(sdev->dev);
+		}
+		return 1;
+	}
+
+	return 0;
+}
+
+static int sof_vhost_error_reply(struct sof_ipc_reply *rhdr, unsigned int cmd,
+				 int err)
+{
+	rhdr->hdr.size = sizeof(*rhdr);
+	rhdr->hdr.cmd = cmd;
+	rhdr->error = err;
+
+	return err;
+}
+
+int sof_vhost_add_conn(struct snd_sof_dev *sdev,
+		       struct snd_sof_widget *w_host,
+		       struct snd_sof_widget *w_guest,
+		       enum sof_ipc_stream_direction direction)
+{
+	struct dsp_pipeline_connect *conn;
+
+	if (w_host->pipeline_id == w_guest->pipeline_id)
+		return 0;
+
+	conn = devm_kmalloc(sdev->dev, sizeof(*conn), GFP_KERNEL);
+	if (!conn)
+		return -ENOMEM;
+
+	/*
+	 * We'll need this mapping twice: first to overwrite a sink or source ID
+	 * for SOF_IPC_TPLG_COMP_CONNECT, then to overwrite the scheduling
+	 * component ID for SOF_IPC_TPLG_PIPE_NEW
+	 */
+	conn->host_pipeline_id = w_host->pipeline_id;
+	conn->guest_pipeline_id = w_guest->pipeline_id;
+	conn->host_component_id = w_host->comp_id;
+	conn->direction = direction;
+
+	list_add_tail(&conn->list, &sdev->connector_list);
+
+	return 0;
+}
+
+/* Handle some special cases of the "new component" IPC */
+static int sof_vhost_ipc_tplg_comp_new(struct sof_vhost_client *client,
+				       struct sof_ipc_cmd_hdr *hdr,
+				       struct sof_ipc_reply *rhdr)
+{
+	struct sof_ipc_comp *comp = container_of(hdr, struct sof_ipc_comp, hdr);
+	struct snd_sof_dev *sdev = client->sdev;
+	struct snd_sof_pcm *spcm, *last;
+	struct sof_ipc_comp_host *host;
+	struct dsp_pipeline_connect *conn;
+
+	if (comp->id < client->comp_id_begin ||
+	    comp->id >= client->comp_id_end)
+		return -EINVAL;
+
+	switch (comp->type) {
+	case SOF_COMP_VIRT_CON:
+		list_for_each_entry(conn, &sdev->connector_list, list)
+			if (conn->guest_pipeline_id == comp->pipeline_id) {
+				/* This ID will have to be overwritten */
+				conn->guest_component_id = comp->id;
+				break;
+			}
+
+		sof_vhost_error_reply(rhdr, hdr->cmd, 0);
+
+		/* The firmware doesn't need this component */
+		return 1;
+	case SOF_COMP_HOST:
+		/*
+		 * TODO: below is a temporary solution. next step is
+		 * to create a whole pcm stuff incluing substream
+		 * based on Liam's suggestion.
+		 */
+
+		/*
+		 * let's create spcm in HOST ipc
+		 * spcm should be created in pcm load, but there is no such ipc
+		 * so we create it here. It is needed for the "period elapsed"
+		 * IPC from the firmware, which will use the host ID to route
+		 * the IPC back to the PCM.
+		 */
+		host = container_of(comp, struct sof_ipc_comp_host, comp);
+		spcm = kzalloc(sizeof(*spcm), GFP_KERNEL);
+		if (!spcm)
+			return -ENOMEM;
+
+		spcm->stream[SNDRV_PCM_STREAM_PLAYBACK].comp_id =
+			SOF_RPMSG_COMP_ID_UNASSIGNED;
+		spcm->stream[SNDRV_PCM_STREAM_CAPTURE].comp_id =
+			SOF_RPMSG_COMP_ID_UNASSIGNED;
+		spcm->stream[host->direction].comp_id = host->comp.id;
+		spcm->stream[SNDRV_PCM_STREAM_PLAYBACK].posn.comp_id =
+			spcm->stream[SNDRV_PCM_STREAM_PLAYBACK].comp_id;
+		spcm->stream[SNDRV_PCM_STREAM_CAPTURE].posn.comp_id =
+			spcm->stream[SNDRV_PCM_STREAM_CAPTURE].comp_id;
+		INIT_WORK(&spcm->stream[host->direction].period_elapsed_work,
+			  snd_sof_pcm_period_elapsed_work);
+		last = list_last_entry(&sdev->pcm_list, struct snd_sof_pcm,
+				       list);
+		spcm->pcm.dai_id = last->pcm.dai_id + 1;
+		strncpy(spcm->pcm.pcm_name, dsp_pcm_name,
+			sizeof(spcm->pcm.pcm_name));
+		list_add(&spcm->list, &sdev->pcm_list);
+
+		client->reset_count = atomic_read(&sdev->dsp_reset_count);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+/* Handle the "new pipeline" IPC: replace the scheduling sink ID */
+static int sof_vhost_ipc_tplg_pipe_new(struct sof_vhost_client *client,
+				       struct sof_ipc_cmd_hdr *hdr)
+{
+	struct sof_ipc_pipe_new *pipeline = container_of(hdr,
+						struct sof_ipc_pipe_new, hdr);
+	struct snd_sof_dev *sdev = client->sdev;
+	struct dsp_pipeline_connect *conn;
+
+	list_for_each_entry(conn, &sdev->connector_list, list)
+		if (pipeline->pipeline_id == conn->guest_pipeline_id) {
+			struct snd_sof_dai *dai;
+
+			dai = snd_sof_find_dai_pipe(sdev,
+						    conn->host_pipeline_id);
+			if (!dai) {
+				dev_warn(sdev->dev,
+					 "no DAI with pipe %u found\n",
+					 conn->host_pipeline_id);
+				continue;
+			}
+
+			/* Overwrite the scheduling sink ID with the DAI ID */
+			pipeline->sched_id = dai->comp_dai.comp.id;
+			break;
+		}
+
+	return 0;
+}
+
+/* Handle the "connect components" IPC: replace the virtual component ID */
+static int sof_vhost_ipc_tplg_comp_connect(struct sof_vhost_client *client,
+					   struct sof_ipc_cmd_hdr *hdr)
+{
+	struct sof_ipc_pipe_comp_connect *connect = container_of(hdr,
+					struct sof_ipc_pipe_comp_connect, hdr);
+	struct dsp_pipeline_connect *conn;
+
+	list_for_each_entry(conn, &client->sdev->connector_list, list) {
+		if (conn->direction == SOF_IPC_STREAM_PLAYBACK &&
+		    connect->sink_id == conn->guest_component_id) {
+			/*
+			 * Overwrite the sink ID with the actual mixer component
+			 * ID
+			 */
+			connect->sink_id = conn->host_component_id;
+			break;
+		}
+
+		if (conn->direction == SOF_IPC_STREAM_CAPTURE &&
+		    connect->source_id == conn->guest_component_id) {
+			/*
+			 * Overwrite the source ID with the actual demux component
+			 * ID
+			 */
+			connect->source_id = conn->host_component_id;
+			break;
+		}
+	}
+
+	return 0;
+}
+
+/* Read guest's topology file and send it back to the requester */
+static int sof_vhost_ipc_tplg_read(struct sof_vhost_client *client,
+				   struct sof_ipc_cmd_hdr *hdr,
+				   void *reply_buf, size_t reply_sz)
+{
+	struct sof_rpmsg_ipc_tplg_req *tplg = container_of(hdr,
+					struct sof_rpmsg_ipc_tplg_req, hdr);
+	struct sof_rpmsg_ipc_tplg_resp *partdata = reply_buf;
+	const struct firmware *fw = client->fw;
+	size_t to_copy, remainder;
+
+	if (reply_sz <= sizeof(partdata->reply))
+		return -ENOBUFS;
+
+	if (!fw || fw->size <= tplg->offset)
+		return -EINVAL;
+
+	remainder = fw->size - tplg->offset;
+
+	to_copy = min_t(size_t, reply_sz - sizeof(partdata->reply),
+			remainder);
+	partdata->reply.hdr.size = to_copy + sizeof(partdata->reply);
+	partdata->reply.hdr.cmd = hdr->cmd;
+
+	memcpy(partdata->data, fw->data + tplg->offset, to_copy);
+
+	dev_dbg(client->sdev->dev, "%s(): copy %zu, %zu remain\n",
+		__func__, to_copy, remainder);
+
+	if (remainder == to_copy) {
+		release_firmware(fw);
+		client->fw = NULL;
+	}
+
+	return 0;
+}
+
+/* Send the next component ID to the guest */
+static int sof_vhost_ipc_tplg_comp_id(struct sof_vhost_client *client,
+				      struct sof_ipc_cmd_hdr *hdr,
+				      void *reply_buf, size_t reply_sz)
+{
+	struct sof_rpmsg_ipc_tplg_resp *partdata = reply_buf;
+
+	client->comp_id_begin = client->sdev->next_comp_id +
+		client->id * SOF_RPMSG_MAX_UOS_COMPS;
+	client->comp_id_end = client->comp_id_begin + SOF_RPMSG_MAX_UOS_COMPS;
+
+	partdata->reply.hdr.cmd = hdr->cmd;
+	partdata->reply.hdr.size = sizeof(partdata->reply) + sizeof(u32);
+	*(u32 *)partdata->data = client->comp_id_begin;
+
+	return 0;
+}
+
+/* Handle topology IPC */
+static int sof_vhost_ipc_tplg(struct sof_vhost_client *client,
+			      struct sof_ipc_cmd_hdr *hdr,
+			      void *reply_buf, size_t reply_sz)
+{
+	u32 cmd = hdr->cmd & SOF_CMD_TYPE_MASK;
+	int ret;
+
+	switch (cmd) {
+	case SOF_IPC_TPLG_COMP_NEW:
+		return sof_vhost_ipc_tplg_comp_new(client, hdr, reply_buf);
+	case SOF_IPC_TPLG_PIPE_NEW:
+		return sof_vhost_ipc_tplg_pipe_new(client, hdr);
+	case SOF_IPC_TPLG_COMP_CONNECT:
+		return sof_vhost_ipc_tplg_comp_connect(client, hdr);
+	case SOF_IPC_TPLG_VFE_GET:
+		ret = sof_vhost_ipc_tplg_read(client, hdr, reply_buf, reply_sz);
+		return ret < 0 ? ret : 1;
+	case SOF_IPC_TPLG_VFE_COMP_ID:
+		ret = sof_vhost_ipc_tplg_comp_id(client, hdr, reply_buf,
+						 reply_sz);
+		return ret < 0 ? ret : 1;
+	}
+
+	return 0;
+}
+
+/* Call SOF core to send an IPC message to the DSP */
+static void sof_vhost_send_ipc(struct snd_sof_dev *sdev, void *ipc_data,
+			       void *reply_buf, size_t count,
+			       size_t reply_size)
+{
+	struct snd_sof_ipc *ipc = sdev->ipc;
+	struct sof_ipc_cmd_hdr *hdr = ipc_data;
+	struct sof_ipc_reply *rhdr = reply_buf;
+	int ret = sof_ipc_tx_message(ipc, hdr->cmd, ipc_data, count,
+				     reply_buf, reply_size);
+
+	if (ret < 0 && !rhdr->error)
+		rhdr->error = ret;
+}
+
+/* Post-process SOF_IPC_STREAM_PCM_PARAMS */
+static int sof_vhost_ipc_stream_param_post(struct snd_sof_dev *sdev,
+					   void *reply_buf)
+{
+	struct sof_ipc_pcm_params_reply *reply = reply_buf;
+	u32 comp_id = reply->comp_id;
+	int direction, ret;
+	struct snd_sof_pcm *spcm = sof_vhost_find_spcm_comp(sdev, comp_id,
+							    &direction);
+	if (!spcm)
+		return -ENODEV;
+
+	ret = snd_sof_ipc_pcm_params(sdev, spcm->stream[direction].substream,
+				     reply);
+	if (ret < 0)
+		dev_err(sdev->dev, "error: got wrong reply for PCM %d\n",
+			spcm->pcm.pcm_id);
+
+	return ret;
+}
+
+/* Handle the stream start trigger IPC */
+static int sof_vhost_ipc_stream_codec(struct snd_sof_dev *sdev,
+				      struct sof_ipc_cmd_hdr *hdr)
+{
+	struct sof_ipc_stream *stream = container_of(hdr,
+						struct sof_ipc_stream, hdr);
+	struct snd_pcm_substream *substream;
+	struct snd_soc_pcm_runtime *rtd;
+	struct snd_soc_dai *codec_dai;
+	unsigned int i;
+	int direction;
+
+	if (!sof_vhost_find_spcm_comp(sdev, stream->comp_id, &direction))
+		return -ENODEV;
+
+	substream = sof_vhost_get_substream(sdev, &rtd, direction);
+	if (!substream)
+		return -ENODEV;
+
+	for_each_rtd_codec_dais(rtd, i, codec_dai) {
+		const struct snd_soc_dai_ops *ops = codec_dai->driver->ops;
+
+		/*
+		 * Now we are ready to trigger start.
+		 * Let's unmute the codec firstly
+		 */
+		snd_soc_dai_digital_mute(codec_dai, 0, direction);
+		if (ops && ops->trigger) {
+			int ret = ops->trigger(substream,
+					       SNDRV_PCM_TRIGGER_START,
+					       codec_dai);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int sof_vhost_ipc_stream_stop(struct snd_sof_dev *sdev,
+				     struct sof_ipc_cmd_hdr *hdr)
+{
+	struct sof_ipc_stream *stream = container_of(hdr,
+						struct sof_ipc_stream, hdr);
+	struct snd_pcm_substream *substream;
+	struct snd_soc_pcm_runtime *rtd;
+	struct snd_soc_dai *codec_dai;
+	int direction, comp_id = stream->comp_id;
+	unsigned int i;
+
+	if (!sof_vhost_find_spcm_comp(sdev, comp_id, &direction))
+		return -ENODEV;
+
+	substream = sof_vhost_get_substream(sdev, &rtd, direction);
+	if (!substream)
+		return -ENODEV;
+
+	for_each_rtd_codec_dais(rtd, i, codec_dai) {
+		const struct snd_soc_dai_ops *ops = codec_dai->driver->ops;
+
+		if (ops && ops->trigger) {
+			int ret = ops->trigger(substream,
+					       SNDRV_PCM_TRIGGER_STOP,
+					       codec_dai);
+			if (ret < 0) {
+				dev_err(codec_dai->dev,
+					"trigger stop fails\n");
+				return ret;
+			}
+		}
+	}
+
+	snd_sof_pcm_platform_trigger(sdev, substream,
+				     SNDRV_PCM_TRIGGER_STOP);
+	snd_soc_dpcm_runtime_update(sdev->card,
+				    SND_SOC_DPCM_UPDATE_OLD_ONLY);
+	snd_soc_runtime_deactivate(rtd, direction);
+
+	return 0;
+}
+
+/* Handle an IPC reply */
+static int sof_vhost_ipc_post(struct snd_sof_dev *sdev,
+			      struct sof_ipc_cmd_hdr *hdr, void *reply_buf)
+{
+	struct sof_ipc_reply *rhdr = reply_buf;
+	int ret;
+
+	switch (hdr->cmd) {
+	case SOF_IPC_GLB_STREAM_MSG | SOF_IPC_STREAM_PCM_PARAMS:
+		if (rhdr->error < 0)
+			break;
+		return sof_vhost_ipc_stream_param_post(sdev, reply_buf);
+	case SOF_IPC_GLB_STREAM_MSG | SOF_IPC_STREAM_TRIG_START:
+		if (rhdr->error < 0)
+			break;
+		/* setup the codec */
+		return sof_vhost_ipc_stream_codec(sdev, hdr);
+	case SOF_IPC_GLB_STREAM_MSG | SOF_IPC_STREAM_TRIG_STOP:
+		ret = sof_vhost_ipc_stream_stop(sdev, hdr);
+		return rhdr->error < 0 ? rhdr->error : ret;
+	}
+
+	return rhdr->error;
+}
+
+/* Forward an IPC message from a guest to the DSP */
+int sof_vhost_ipc_fwd(struct sof_vhost_client *client,
+		      void *ipc_buf, void *reply_buf,
+		      size_t count, size_t reply_sz)
+{
+	struct snd_sof_dev *sdev = client->sdev;
+	struct sof_ipc_cmd_hdr *hdr = ipc_buf;
+	struct sof_ipc_reply *rhdr = reply_buf;
+	u32 type;
+	int ret;
+
+	/* validate IPC */
+	if (count < sizeof(*hdr) || count > SOF_IPC_MSG_MAX_SIZE) {
+		dev_err(sdev->dev, "error: guest IPC size is 0\n");
+		return -EINVAL;
+	}
+
+	type = hdr->cmd & SOF_GLB_TYPE_MASK;
+	rhdr->error = 0;
+
+	/* validate the ipc */
+	switch (type) {
+	case SOF_IPC_GLB_COMP_MSG:
+		ret = sof_vhost_ipc_comp(client, hdr);
+		if (ret < 0)
+			goto err;
+		break;
+	case SOF_IPC_GLB_STREAM_MSG:
+		ret = sof_vhost_ipc_stream(sdev, hdr, reply_buf);
+		if (ret < 0) {
+			dev_err(sdev->dev, "STREAM IPC 0x%x failed %d!\n",
+				hdr->cmd, ret);
+			goto err;
+		}
+		break;
+	case SOF_IPC_GLB_PM_MSG:
+		ret = sof_vhost_ipc_pm(client, hdr, reply_buf);
+		if (!ret)
+			break;
+		if (ret < 0)
+			goto err;
+		return 0;
+	case SOF_IPC_GLB_DAI_MSG:
+		/*
+		 * After we use the new topology solution for FE,
+		 * we will not touch DAI anymore.
+		 */
+		break;
+	case SOF_IPC_GLB_TPLG_MSG:
+		ret = sof_vhost_ipc_tplg(client, hdr, reply_buf, reply_sz);
+		if (!ret)
+			break;
+		if (ret < 0)
+			goto err;
+		return 0;
+	case SOF_IPC_GLB_TRACE_MSG:
+		/* Trace should be initialized in SOS, skip FE requirement */
+		return 0;
+	default:
+		dev_warn(sdev->dev, "unhandled IPC 0x%x!\n", hdr->cmd);
+		break;
+	}
+
+	/* now send the IPC */
+	sof_vhost_send_ipc(sdev, ipc_buf, reply_buf, count, reply_sz);
+
+	/* For some IPCs, the reply needs to be handled */
+	ret = sof_vhost_ipc_post(sdev, hdr, reply_buf);
+	if (ret < 0)
+		dev_err(sdev->dev,
+			"err: failed to send %u bytes virtio IPC 0x%x: %d\n",
+			hdr->size, hdr->cmd, ret);
+
+	return ret;
+
+err:
+	return sof_vhost_error_reply(rhdr, hdr->cmd, ret);
+}
+EXPORT_SYMBOL_GPL(sof_vhost_ipc_fwd);
+
+int sof_vhost_set_tplg(struct sof_vhost_client *client,
+		       const struct vhost_adsp_topology *tplg)
+{
+	struct snd_sof_dev *sdev = client->sdev;
+	struct snd_sof_pdata *plat_data = sdev->pdata;
+	char *path;
+	int ret;
+
+	path = kasprintf(GFP_KERNEL, "%s/%s", plat_data->tplg_filename_prefix,
+			 tplg->name);
+	if (!path)
+		return -ENOMEM;
+
+	ret = request_firmware(&client->fw, path, sdev->dev);
+	if (ret < 0)
+		dev_err(sdev->dev,
+			"error: request VFE topology %s failed: %d\n",
+			tplg->name, ret);
+	kfree(path);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sof_vhost_set_tplg);
+
+void sof_vhost_suspend(struct snd_sof_dev *sdev)
+{
+	struct snd_sof_pcm *spcm, *next;
+
+	list_for_each_entry_safe(spcm, next, &sdev->pcm_list, list)
+		if (!strcmp(dsp_pcm_name, spcm->pcm.pcm_name)) {
+			list_del(&spcm->list);
+			sof_vhost_stream_close(sdev, SNDRV_PCM_STREAM_PLAYBACK);
+			sof_vhost_stream_close(sdev, SNDRV_PCM_STREAM_CAPTURE);
+			kfree(spcm);
+		}
+}
+
+/* A VM instance has closed the miscdevice */
+void sof_vhost_client_release(struct sof_vhost_client *client)
+{
+	bitmap_release_region(client->sdev->vfe_mask, client->id, 0);
+
+	list_del(&client->list);
+
+	kfree(client);
+}
+EXPORT_SYMBOL_GPL(sof_vhost_client_release);
+
+/* A new VM instance has opened the miscdevice */
+struct sof_vhost_client *sof_vhost_client_add(struct snd_sof_dev *sdev,
+					      struct sof_vhost *dsp)
+{
+	int id = bitmap_find_free_region(sdev->vfe_mask, SND_SOF_MAX_VFES, 0);
+	struct sof_vhost_client *client;
+
+	if (id < 0)
+		return NULL;
+
+	client = kmalloc(sizeof(*client), GFP_KERNEL);
+	if (!client) {
+		bitmap_release_region(sdev->vfe_mask, id, 0);
+		return NULL;
+	}
+
+	client->sdev = sdev;
+	client->id = id;
+	client->vhost = dsp;
+
+	/*
+	 * link to sdev->vbe_list
+	 * Maybe virtio_miscdev managing the list is more reasonable.
+	 * Let's use sdev to manage the FE audios now.
+	 * FIXME: protect the list.
+	 */
+	list_add(&client->list, &sdev->vbe_list);
+
+	return client;
+}
+EXPORT_SYMBOL_GPL(sof_vhost_client_add);
+
+/* The struct snd_sof_dev instance, that VirtIO guests will be using */
+static struct snd_sof_dev *vhost_sof_dev;
+static const struct sof_vhost_ops *vhost_ops;
+
+/* Find a client by component ID */
+static struct sof_vhost_client *sof_vhost_comp_to_client(
+						struct snd_sof_dev *sdev,
+						int comp_id)
+{
+	struct sof_vhost_client *client;
+
+	list_for_each_entry(client, &sdev->vbe_list, list)
+		if (comp_id < client->comp_id_end &&
+		    comp_id >= client->comp_id_begin)
+			return client;
+
+	return NULL;
+}
+
+/* Called from the position update IRQ thread */
+int sof_vhost_update_guest_posn(struct snd_sof_dev *sdev,
+				struct sof_ipc_stream_posn *posn)
+{
+	struct sof_vhost_client *client = sof_vhost_comp_to_client(sdev,
+							posn->comp_id);
+
+	if (!client || !vhost_ops)
+		return -ENODEV;
+
+	return vhost_ops->update_posn(client->vhost, posn);
+}
+
+/* The vhost driver is loaded */
+struct device *sof_vhost_dev_init(const struct sof_vhost_ops *ops)
+{
+	if (!vhost_sof_dev)
+		return NULL;
+
+	bitmap_zero(vhost_sof_dev->vfe_mask, SND_SOF_MAX_VFES);
+
+	vhost_ops = ops;
+
+	return vhost_sof_dev->dev;
+}
+EXPORT_SYMBOL_GPL(sof_vhost_dev_init);
+
+/* This SOF device will be used for VirtIO */
+void sof_vhost_dev_set(struct snd_sof_dev *sdev)
+{
+	INIT_LIST_HEAD(&sdev->connector_list);
+	vhost_sof_dev = sdev;
+}
-- 
1.9.3

