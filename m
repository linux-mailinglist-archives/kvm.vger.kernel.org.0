Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F56D1D62D3
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 19:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgEPRBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 13:01:40 -0400
Received: from mga06.intel.com ([134.134.136.31]:5013 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbgEPRBk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 13:01:40 -0400
IronPort-SDR: 3R0GY7Ze4iqp/6NmU5mjLqECPKWs38S+Cflsk1BRWOkQ42pxJP74/JBuHScGj/VI1L4bkeggr+
 T5993KR8QtOg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2020 10:01:39 -0700
IronPort-SDR: ve/ZTKjuFvhHsBKLHLy0J/K8DF10/HTRmXUYr7mgAP3JLz/LdE0ZzPOA3Lw3Z07LB97Ts82gY7
 pDQc9duoxtyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,398,1583222400"; 
   d="scan'208";a="299357254"
Received: from matedfor-mobl.amr.corp.intel.com (HELO [10.251.2.113]) ([10.251.2.113])
  by orsmga008.jf.intel.com with ESMTP; 16 May 2020 10:01:38 -0700
Subject: Re: [Sound-open-firmware] [PATCH RFC] vhost: add an SOF Audio DSP
 driver
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        kvm@vger.kernel.org
Cc:     Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        sound-open-firmware@alsa-project.org,
        linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <20200516101609.2845-1-guennadi.liakhovetski@linux.intel.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <6e2b5c62-f688-5bf7-9324-1abace87f70f@linux.intel.com>
Date:   Sat, 16 May 2020 11:50:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200516101609.2845-1-guennadi.liakhovetski@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org




> +config VHOST_SOF
> +	tristate "Vhost SOF driver"
> +	depends on SND_SOC_SOF

you probably want to make sure VHOST_SOF and SND_SOC_SOF are both 
built-in or module. Without constraints you are likely to trigger errors 
with randconfig. It's a classic.

> +	select VHOST
> +	select VHOST_RPMSG
> +	default n

not needed, default is always no.

> +	---help---
> +	  SOF vhost VirtIO driver. It exports the same IPC interface, as the
> +	  one, used for Audio DSP communication, to Linux VirtIO guests.

[...]

> +struct vhost_dsp {
> +	struct vhost_rpmsg vrdev;
> +
> +	struct sof_vhost_client *snd;
> +
> +	bool active;

I am struggling with this definition, it seems to be a local flag but 
how is it aligned to the actual DSP status?
In other words, can you have cases where the dsp is considered 'active' 
here but might be pm_runtime suspended?
I am sure you've thought of it based on previous threads, it'd be worth 
adding comments.

> +
> +	/* RPMsg address of the position update endpoint */
> +	u32 posn_addr;
> +	/* position update buffer and work */
> +	struct vhost_work posn_work;
> +	struct sof_ipc_stream_posn posn;
> +
> +	/* IPC request buffer */
> +	struct sof_rpmsg_ipc_req ipc_buf;
> +	/* IPC response buffer */
> +	u8 reply_buf[SOF_IPC_MSG_MAX_SIZE];
> +	/*
> +	 * data response header, captured audio data is copied directly from the
> +	 * DMA buffer

so zero-copy is not supported for now, right?

> +	 */
> +	struct sof_rpmsg_data_resp data_resp;
> +};
> +
> +/* A guest is booting */
> +static int vhost_dsp_activate(struct vhost_dsp *dsp)
> +{
> +	unsigned int i;
> +	int ret = 0;
> +
> +	mutex_lock(&dsp->vrdev.dev.mutex);
> +
> +	/* Wait until all the VirtQueues have been initialised */
> +	if (!dsp->active) {
> +		struct vhost_virtqueue *vq;
> +
> +		for (i = 0, vq = dsp->vrdev.vq;
> +		     i < ARRAY_SIZE(dsp->vrdev.vq);
> +		     i++, vq++) {
> +			/* .private_data is required != NULL */
> +			vq->private_data = vq;
> +			/* needed for re-initialisation upon guest reboot */
> +			ret = vhost_vq_init_access(vq);
> +			if (ret)
> +				vq_err(vq,
> +				       "%s(): error %d initialising vq #%d\n",
> +				       __func__, ret, i);
> +		}
> +
> +		/* Send an RPMsg namespace announcement */
> +		if (!ret && !vhost_rpmsg_ns_announce(&dsp->vrdev, "sof_rpmsg",
> +						     SOF_RPMSG_ADDR_IPC))
> +			dsp->active = true;
> +	}
> +
> +	mutex_unlock(&dsp->vrdev.dev.mutex);
> +
> +	return ret;
> +}
> +
> +/* A guest is powered off or reset */
> +static void vhost_dsp_deactivate(struct vhost_dsp *dsp)
> +{
> +	unsigned int i;
> +
> +	mutex_lock(&dsp->vrdev.dev.mutex);
> +
> +	if (dsp->active) {
> +		struct vhost_virtqueue *vq;
> +
> +		dsp->active = false;

can you explain why this is not symmetrical with _activate above: there 
is no rmpsg communication here?

> +
> +		/* If a VM reboots sof_vhost_client_release() isn't called */
> +		sof_vhost_topology_purge(dsp->snd);
> +
> +		/* signal, that we're inactive */
> +		for (i = 0, vq = dsp->vrdev.vq;
> +		     i < ARRAY_SIZE(dsp->vrdev.vq);
> +		     i++, vq++) {
> +			mutex_lock(&vq->mutex);
> +			vq->private_data = NULL;
> +			mutex_unlock(&vq->mutex);
> +		}
> +	}
> +
> +	mutex_unlock(&dsp->vrdev.dev.mutex);
> +}
> +

[...]

> +/* .ioctl(): we only use VHOST_SET_RUNNING in a non-default way */
> +static long vhost_dsp_ioctl(struct file *filp, unsigned int ioctl,
> +			    unsigned long arg)
> +{
> +	struct vhost_dsp *dsp = filp->private_data;
> +	void __user *argp = (void __user *)arg;
> +	struct vhost_adsp_topology tplg;
> +	u64 __user *featurep = argp;
> +	u64 features;
> +	int start;
> +	long ret;
> +
> +	switch (ioctl) {
> +	case VHOST_GET_FEATURES:
> +		features = VHOST_DSP_FEATURES;
> +		if (copy_to_user(featurep, &features, sizeof(features)))
> +			return -EFAULT;
> +		return 0;
> +	case VHOST_SET_FEATURES:
> +		if (copy_from_user(&features, featurep, sizeof(features)))
> +			return -EFAULT;
> +		return vhost_dsp_set_features(dsp, features);
> +	case VHOST_GET_BACKEND_FEATURES:
> +		features = 0;
> +		if (copy_to_user(featurep, &features, sizeof(features)))
> +			return -EFAULT;
> +		return 0;
> +	case VHOST_SET_BACKEND_FEATURES:
> +		if (copy_from_user(&features, featurep, sizeof(features)))
> +			return -EFAULT;
> +		if (features)
> +			return -EOPNOTSUPP;
> +		return 0;
> +	case VHOST_RESET_OWNER:
> +		mutex_lock(&dsp->vrdev.dev.mutex);
> +		ret = vhost_dev_check_owner(&dsp->vrdev.dev);
> +		if (!ret) {
> +			struct vhost_umem *umem =
> +				vhost_dev_reset_owner_prepare();
> +			if (!umem) {
> +				ret = -ENOMEM;
> +			} else {
> +				vhost_dev_stop(&dsp->vrdev.dev);
> +				vhost_dev_reset_owner(&dsp->vrdev.dev, umem);
> +			}
> +		}
> +		mutex_unlock(&dsp->vrdev.dev.mutex);
> +		return ret;
> +	case VHOST_SET_OWNER:
> +		mutex_lock(&dsp->vrdev.dev.mutex);
> +		ret = vhost_dev_set_owner(&dsp->vrdev.dev);
> +		mutex_unlock(&dsp->vrdev.dev.mutex);
> +		return ret;
> +	case VHOST_SET_RUNNING:
> +		if (copy_from_user(&start, argp, sizeof(start)))
> +			return -EFAULT;
> +
> +		if (start)
> +			return vhost_dsp_activate(dsp);
> +
> +		vhost_dsp_deactivate(dsp);
> +		return 0;
> +	case VHOST_ADSP_SET_GUEST_TPLG:
> +		if (copy_from_user(&tplg, argp, sizeof(tplg)))
> +			return -EFAULT;
> +		return sof_vhost_set_tplg(dsp->snd, &tplg);
> +	}

All cases seem to use return, so the the code below seems to be the 
default: case?

> +	mutex_lock(&dsp->vrdev.dev.mutex);
> +	ret = vhost_dev_ioctl(&dsp->vrdev.dev, ioctl, argp);
> +	if (ret == -ENOIOCTLCMD)
> +		ret = vhost_vring_ioctl(&dsp->vrdev.dev, ioctl, argp);
> +	mutex_unlock(&dsp->vrdev.dev.mutex);
> +
> +	return ret;
> +}

[...]

> +static ssize_t vhost_dsp_ipc_write(struct vhost_rpmsg *vr,
> +				   struct vhost_rpmsg_iter *iter)
> +{
> +	struct vhost_dsp *dsp = container_of(vr, struct vhost_dsp, vrdev);
> +
> +	return vhost_rpmsg_copy(vr, iter, dsp->reply_buf,
> +				vhost_rpmsg_iter_len(iter)) ==
> +		vhost_rpmsg_iter_len(iter) ? 0 : -EIO;
> +}

This is rather convoluted code, with the same function called on both 
sides of a comparison.

> +
> +/* Called only once to get guest's position update endpoint address */
> +static ssize_t vhost_dsp_posn_read(struct vhost_rpmsg *vr,
> +				   struct vhost_rpmsg_iter *iter)
> +{
> +	struct vhost_dsp *dsp = container_of(vr, struct vhost_dsp, vrdev);
> +	struct vhost_virtqueue *vq = &dsp->vrdev.vq[VIRTIO_RPMSG_REQUEST];
> +	size_t len = vhost_rpmsg_iter_len(iter);
> +	size_t nbytes;
> +
> +	if ((int)dsp->posn_addr >= 0) {

posn_addr is defined as a u32, so what are you trying to test here?

> +		vq_err(vq, "%s(): position queue address %u already set\n",
> +		       __func__, dsp->posn_addr);
> +		return -EINVAL;
> +	}
> +
> +	if (len != sizeof(dsp->posn_addr)) {

that also seems suspicious:

+	/* RPMsg address of the position update endpoint */
+	u32 posn_addr;

why would a length which should have different values have anything to 
do with a constant 4 bytes?

> +		vq_err(vq, "%s(): data count %zu invalid\n",
> +		       __func__, len);
> +		return -EINVAL;
> +	}
> +
> +	nbytes = vhost_rpmsg_copy(vr, iter, &dsp->posn_addr,
> +				  sizeof(dsp->posn_addr));
> +	if (nbytes != sizeof(dsp->posn_addr)) {

and again here?

> +		vq_err(vq,
> +		       "%s(): got %zu instead of %zu bytes position update\n",
> +		       __func__, nbytes, sizeof(dsp->posn_addr));
> +		return -EIO;
> +	}
> +
> +	pr_debug("%s(): guest position endpoint address 0x%x\n", __func__,
> +		 dsp->posn_addr);
> +
> +	return 0;
> +}
> +

[...]

> +static int vhost_dsp_open(struct inode *inode, struct file *filp)
> +{
> +	struct miscdevice *misc = filp->private_data;
> +	struct snd_sof_dev *sdev = dev_get_drvdata(misc->parent);
> +	struct vhost_dsp *dsp = kmalloc(sizeof(*dsp), GFP_KERNEL);
> +
> +	if (!dsp)
> +		return -ENOMEM;
> +
> +	dsp->vrdev.dev.mm = NULL;
> +	dsp->snd = sof_vhost_client_add(sdev, dsp);
> +	if (!dsp->snd) {
> +		kfree(dsp);
> +		return -ENOMEM;
> +	}
> +
> +	/*
> +	 * TODO: do we ever want to support multiple guest machines per DSP, if

That is a basic assumption yes.

> +	 * not, we might as well perform all allocations when registering the
> +	 * misc device.
> +	 */
> +	dsp->active = false;
> +	dsp->posn_addr = -EINVAL;
> +	dsp->posn.rhdr.error = -ENODATA;
> +
> +	vhost_rpmsg_init(&dsp->vrdev, vhost_dsp_ept, ARRAY_SIZE(vhost_dsp_ept));
> +	vhost_work_init(&dsp->posn_work, vhost_dsp_send_posn);
> +
> +	/* Overwrite file private data */
> +	filp->private_data = dsp;
> +
> +	return 0;
> +}

[...]

> +/* Always called from an interrupt thread context */
> +static int vhost_dsp_update_posn(struct vhost_dsp *dsp,
> +				 struct sof_ipc_stream_posn *posn)
> +{
> +	struct vhost_virtqueue *vq = &dsp->vrdev.vq[VIRTIO_RPMSG_RESPONSE];
> +	int ret;
> +
> +	if (!dsp->active)
> +		return 0;

is there a case where you can get a position update without the dsp 
being active?
And shouldn't this be an error?
> +
> +	memcpy(&dsp->posn, posn, sizeof(dsp->posn));
> +
> +	mutex_lock(&vq->mutex);
> +
> +	/*
> +	 * VirtQueues can only be processed in the context of the VMM process or
> +	 * a vhost work queue
> +	 */
> +	vhost_work_queue(&dsp->vrdev.dev, &dsp->posn_work);
> +
> +	mutex_unlock(&vq->mutex);
> +
> +	return ret;
