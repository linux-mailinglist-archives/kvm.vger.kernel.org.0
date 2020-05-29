Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6301E76F4
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 09:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgE2Hic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 03:38:32 -0400
Received: from mga07.intel.com ([134.134.136.100]:50721 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726864AbgE2Hi3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 03:38:29 -0400
IronPort-SDR: y+t/vjFPiEkX4qLprGfOQcnvxQCcJ2VpAU8VJzzoeWmmMzQfhQPtXN9SwiK6x2aXP3neJtD0w3
 I3eqL8RQnp2w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 00:37:55 -0700
IronPort-SDR: 4PmB2iCjnTMLCe2J0byz5rgrnpnrTiwqM6HPTLfjtMwMgemI1TlHCNMruwdzORmhfEj+lk7NIr
 mL9lB1zy03pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414890433"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.252.45.157])
  by orsmga004.jf.intel.com with ESMTP; 29 May 2020 00:37:51 -0700
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
Subject: [RFC 09/12] ASoC: SOF: VirtIO: free guest pipelines upon termination
Date:   Fri, 29 May 2020 09:37:19 +0200
Message-Id: <20200529073722.8184-10-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
References: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently the SOF driver switches off the DSP every time runtime or
system-wide suspend is entered. After the DSP is turned off, next
time it's turned on, the firmware and topology have to be re-sent to
it.

When a guest SOF instance restarts it sends its topology to the host,
which then forwards it to the DSP. This is correct if the DSP was
suspended during that time and lost the guest's topology. However, if
the DSP stayed active during that entire time, sending duplicate
components to it produces errors. To prevent this from happening this
patch adds freeing of components during guest shut down.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
---
 include/sound/sof/rpmsg.h |   4 ++
 sound/soc/sof/vhost-vbe.c | 158 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 161 insertions(+), 1 deletion(-)

diff --git a/include/sound/sof/rpmsg.h b/include/sound/sof/rpmsg.h
index ce522c6..7f907e6 100644
--- a/include/sound/sof/rpmsg.h
+++ b/include/sound/sof/rpmsg.h
@@ -137,6 +137,9 @@ struct sof_vhost_client {
 	struct list_head pipe_conn;
 	/* List of vhost instances on a DSP */
 	struct list_head list;
+	/* List of widgets to free for tear-down */
+	struct list_head comp_list;
+	struct list_head pipe_list;
 
 	/* Component ID range index in the bitmap */
 	unsigned int id;
@@ -167,6 +170,7 @@ void *sof_vhost_stream_data(struct sof_vhost_client *client,
 int sof_vhost_ipc_fwd(struct sof_vhost_client *client,
 		      void *ipc_buf, void *reply_buf,
 		      size_t count, size_t reply_sz);
+void sof_vhost_topology_purge(struct sof_vhost_client *client);
 
 /* The below functions are always referenced, they need dummy counterparts */
 int sof_vhost_update_guest_posn(struct snd_sof_dev *sdev,
diff --git a/sound/soc/sof/vhost-vbe.c b/sound/soc/sof/vhost-vbe.c
index 8056e25..3887bba 100644
--- a/sound/soc/sof/vhost-vbe.c
+++ b/sound/soc/sof/vhost-vbe.c
@@ -43,6 +43,18 @@ struct dsp_pipeline_connect {
 	struct list_head list;
 };
 
+struct sof_vhost_comp_list {
+	struct list_head list;
+	uint32_t comp_id;
+	enum sof_comp_type comp_type;
+};
+
+struct sof_vhost_pipe_list {
+	struct list_head list;
+	uint32_t comp_id;
+	uint32_t pipe_id;
+};
+
 static const char dsp_pcm_name[] = "VHost PCM";
 
 /*
@@ -446,6 +458,75 @@ static int sof_vhost_ipc_comp(struct sof_vhost_client *client,
 		cdata->comp_id >= client->comp_id_end ? -EINVAL : 0;
 }
 
+void sof_vhost_topology_purge(struct sof_vhost_client *client)
+{
+	struct snd_sof_dev *sdev = client->sdev;
+	struct sof_ipc_free fcomp = {
+		.hdr = {
+			.size = sizeof(fcomp),
+		},
+	};
+	struct sof_ipc_reply reply;
+	struct sof_vhost_comp_list *citem, *ctmp;
+	struct sof_vhost_pipe_list *pitem, *ptmp;
+	int ret;
+
+	pm_runtime_get_sync(sdev->dev);
+
+	/* First free all pipelines */
+	list_for_each_entry_safe(pitem, ptmp, &client->pipe_list, list) {
+		fcomp.id = pitem->comp_id;
+		fcomp.hdr.cmd = SOF_IPC_GLB_TPLG_MSG |
+			SOF_IPC_TPLG_PIPE_FREE;
+
+		dev_dbg(sdev->dev, "tplg: unload component ID: %d pipe %u\n",
+			fcomp.id, pitem->pipe_id);
+
+		/* send IPC to the DSP */
+		ret = sof_ipc_tx_message(sdev->ipc,
+					 fcomp.hdr.cmd, &fcomp, sizeof(fcomp),
+					 &reply, sizeof(reply));
+		if (ret < 0)
+			dev_err(sdev->dev, "error: %d unloading component %d\n",
+				ret, fcomp.id);
+
+		list_del(&pitem->list);
+		kfree(pitem);
+	}
+
+	/* Then free all individual components */
+	list_for_each_entry_safe(citem, ctmp, &client->comp_list, list) {
+		fcomp.id = citem->comp_id;
+		switch (citem->comp_type) {
+		case SOF_COMP_BUFFER:
+			fcomp.hdr.cmd = SOF_IPC_GLB_TPLG_MSG |
+				SOF_IPC_TPLG_BUFFER_FREE;
+			break;
+		default:
+			fcomp.hdr.cmd = SOF_IPC_GLB_TPLG_MSG |
+				SOF_IPC_TPLG_COMP_FREE;
+		}
+
+		dev_dbg(sdev->dev, "tplg: unload component ID: %d type %u\n",
+			fcomp.id, citem->comp_type);
+
+		/* send IPC to the DSP */
+		ret = sof_ipc_tx_message(sdev->ipc,
+					 fcomp.hdr.cmd, &fcomp, sizeof(fcomp),
+					 &reply, sizeof(reply));
+		if (ret < 0)
+			dev_err(sdev->dev, "error: %d unloading component %d\n",
+				ret, fcomp.id);
+
+		list_del(&citem->list);
+		kfree(citem);
+	}
+
+	pm_runtime_mark_last_busy(sdev->dev);
+	pm_runtime_put_autosuspend(sdev->dev);
+}
+EXPORT_SYMBOL_GPL(sof_vhost_topology_purge);
+
 /* process PM IPC */
 static int sof_vhost_ipc_pm(struct sof_vhost_client *client,
 			    struct sof_ipc_cmd_hdr *hdr,
@@ -527,6 +608,48 @@ int sof_vhost_add_conn(struct snd_sof_dev *sdev,
 	return 0;
 }
 
+static int sof_vhost_tplg_comp_add(struct sof_vhost_client *client,
+				   struct sof_ipc_comp *comp)
+{
+	struct sof_vhost_comp_list *citem = kmalloc(sizeof(*citem), GFP_KERNEL);
+	if (!citem)
+		return -ENOMEM;
+
+	citem->comp_id = comp->id;
+	citem->comp_type = comp->type;
+
+	dev_dbg(client->sdev->dev, "%s(): adding %p ID %d type %x\n",
+		__func__, citem, comp->id, comp->type);
+	list_add_tail(&citem->list, &client->comp_list);
+
+	return 0;
+}
+
+static int sof_vhost_tplg_pipe_add(struct sof_vhost_client *client,
+				   struct sof_ipc_pipe_new *pipe)
+{
+	struct sof_vhost_pipe_list *pitem = kmalloc(sizeof(*pitem), GFP_KERNEL);
+	if (!pitem)
+		return -ENOMEM;
+
+	pitem->comp_id = pipe->comp_id;
+	pitem->pipe_id = pipe->pipeline_id;
+
+	dev_dbg(client->sdev->dev, "%s(): adding %p ID %d pipe %x\n",
+		__func__, pitem, pipe->comp_id, pipe->pipeline_id);
+	list_add_tail(&pitem->list, &client->pipe_list);
+
+	return 0;
+}
+
+static int sof_vhost_ipc_tplg_buf_new(struct sof_vhost_client *client,
+				      struct sof_ipc_cmd_hdr *hdr,
+				      struct sof_ipc_reply *rhdr)
+{
+	struct sof_ipc_comp *comp = container_of(hdr, struct sof_ipc_comp, hdr);
+	return sof_vhost_tplg_comp_add(client, comp);
+}
+
 /* Handle some special cases of the "new component" IPC */
 static int sof_vhost_ipc_tplg_comp_new(struct sof_vhost_client *client,
 				       struct sof_ipc_cmd_hdr *hdr,
@@ -537,6 +660,7 @@ static int sof_vhost_ipc_tplg_comp_new(struct sof_vhost_client *client,
 	struct snd_sof_pcm *spcm, *last;
 	struct sof_ipc_comp_host *host;
 	struct dsp_pipeline_connect *conn;
+	int ret;
 
 	if (comp->id < client->comp_id_begin ||
 	    comp->id >= client->comp_id_end)
@@ -598,6 +722,10 @@ static int sof_vhost_ipc_tplg_comp_new(struct sof_vhost_client *client,
 		break;
 	}
 
+	ret = sof_vhost_tplg_comp_add(client, comp);
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
@@ -609,6 +737,9 @@ static int sof_vhost_ipc_tplg_pipe_new(struct sof_vhost_client *client,
 						struct sof_ipc_pipe_new, hdr);
 	struct snd_sof_dev *sdev = client->sdev;
 	struct dsp_pipeline_connect *conn;
+	int ret = sof_vhost_tplg_pipe_add(client, pipeline);
+	if (ret < 0)
+		return ret;
 
 	list_for_each_entry(conn, &sdev->connector_list, list)
 		if (pipeline->pipeline_id == conn->guest_pipeline_id) {
@@ -730,6 +861,8 @@ static int sof_vhost_ipc_tplg(struct sof_vhost_client *client,
 	switch (cmd) {
 	case SOF_IPC_TPLG_COMP_NEW:
 		return sof_vhost_ipc_tplg_comp_new(client, hdr, reply_buf);
+	case SOF_IPC_TPLG_BUFFER_NEW:
+		return sof_vhost_ipc_tplg_buf_new(client, hdr, reply_buf);
 	case SOF_IPC_TPLG_PIPE_NEW:
 		return sof_vhost_ipc_tplg_pipe_new(client, hdr);
 	case SOF_IPC_TPLG_COMP_CONNECT:
@@ -995,6 +1128,23 @@ int sof_vhost_set_tplg(struct sof_vhost_client *client,
 void sof_vhost_suspend(struct snd_sof_dev *sdev)
 {
 	struct snd_sof_pcm *spcm, *next;
+	struct sof_vhost_client *client;
+
+	/* Upon resume we'll rebuild lists */
+	list_for_each_entry(client, &sdev->vbe_list, list) {
+		struct sof_vhost_comp_list *citem, *ctmp;
+		struct sof_vhost_pipe_list *pitem, *ptmp;
+
+		list_for_each_entry_safe(pitem, ptmp, &client->pipe_list, list) {
+			list_del(&pitem->list);
+			kfree(pitem);
+		}
+
+		list_for_each_entry_safe(citem, ctmp, &client->comp_list, list) {
+			list_del(&citem->list);
+			kfree(citem);
+		}
+	}
 
 	list_for_each_entry_safe(spcm, next, &sdev->pcm_list, list)
 		if (!strcmp(dsp_pcm_name, spcm->pcm.pcm_name)) {
@@ -1008,6 +1158,9 @@ void sof_vhost_suspend(struct snd_sof_dev *sdev)
 /* A VM instance has closed the miscdevice */
 void sof_vhost_client_release(struct sof_vhost_client *client)
 {
+	/* If a VM crashes we don't get ioctl(VHOST_SET_RUNNING, 0) from QEMU */
+	sof_vhost_topology_purge(client);
+
 	bitmap_release_region(client->sdev->vfe_mask, client->id, 0);
 
 	list_del(&client->list);
@@ -1018,7 +1171,7 @@ void sof_vhost_client_release(struct sof_vhost_client *client)
 
 /* A new VM instance has opened the miscdevice */
 struct sof_vhost_client *sof_vhost_client_add(struct snd_sof_dev *sdev,
-					      struct sof_vhost *dsp)
+					      struct vhost_dsp *dsp)
 {
 	int id = bitmap_find_free_region(sdev->vfe_mask, SND_SOF_MAX_VFES, 0);
 	struct sof_vhost_client *client;
@@ -1032,6 +1185,9 @@ struct sof_vhost_client *sof_vhost_client_add(struct snd_sof_dev *sdev,
 		return NULL;
 	}
 
+	INIT_LIST_HEAD(&client->pipe_list);
+	INIT_LIST_HEAD(&client->comp_list);
+
 	client->sdev = sdev;
 	client->id = id;
 	client->vhost = dsp;
-- 
1.9.3

