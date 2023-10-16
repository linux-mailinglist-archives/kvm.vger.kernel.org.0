Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197917CAB7F
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 16:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbjJPOae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 10:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232536AbjJPOac (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 10:30:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F909B
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 07:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697466582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/9DeJrRzQVtFOe1mNsNPjFdgBTi3N3+iWS6VDgRIWYw=;
        b=dajdLDgcgBUIH09/uhlVEX77YoVQMoMf9Jn7CHql4G9u81XMAhMLLqv0yjSux4ccBjBgVZ
        dqS4yknKiQCISvgmvX9Dx8lFnrOYNELErAcqLBK8t4wLWodrsWe4vWbgWLiR5J+VXmTg8T
        45QiP0SawsuGD90AFyy2Q8v/sQfBr0w=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-574-2ZXWkzV_OJqenB5movOikg-1; Mon, 16 Oct 2023 10:29:40 -0400
X-MC-Unique: 2ZXWkzV_OJqenB5movOikg-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-418145b6579so43221201cf.2
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 07:29:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697466580; x=1698071380;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/9DeJrRzQVtFOe1mNsNPjFdgBTi3N3+iWS6VDgRIWYw=;
        b=unZ/3rTeSW7dZhuuNlKwB+I0AR4/OU/DB0LG+8M5htoAJcRwajorTxsNC3S6P0ssd1
         5NwzbJ+COcPPj0YoR3LUcvTK90jy0w/J2J060b0m6id/Rd+NV0Jm9GcaeHMalUxHJsgO
         Cq900xUeklbWdOR2mqTmAl6yYXH+KRb8Wn5Xjjh0SOOqhID3nENq9CgXStFCML8lk9cD
         4XKChoEoxp2x+NtNH68H20c1B44cu9sHjzEh9/G8aubH8YwHxUAEmdjWLw2dpfzNC9FQ
         2tqDEDB4M1B3nC/yQT+j9o7niuBVHT6nehxAFY3ABboOugoBRxDIwdcUpcQc5t4vXZTP
         7a3g==
X-Gm-Message-State: AOJu0Yx3L4KYSDsT3ClKRnESgVuYGrjK+S0SzIQLBP/JnJmrprPCHZkA
        sSCDVj1D7VVy1Swxe11pVgXwmJ9hSa+Ixjk3ESBf0n/uEWMgbwVO7Kcse80qtYu8h9DXNR1J1x6
        ziojtB4wCUUS3
X-Received: by 2002:a05:622a:1708:b0:419:5c79:946b with SMTP id h8-20020a05622a170800b004195c79946bmr40512980qtk.45.1697466579037;
        Mon, 16 Oct 2023 07:29:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEurW++xSwHvgPzM/8PpwC+xlUb1cthkh+Nh0O4I1DjXFp4mEeghkM63G/LbSlmM2YcgJ3kYQ==
X-Received: by 2002:a05:622a:1708:b0:419:5c79:946b with SMTP id h8-20020a05622a170800b004195c79946bmr40512956qtk.45.1697466578620;
        Mon, 16 Oct 2023 07:29:38 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id x26-20020ac84d5a000000b0041520676966sm3075725qtv.47.2023.10.16.07.29.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 07:29:38 -0700 (PDT)
Message-ID: <39773e3f-1fd1-4c0a-ad81-95f5442d4851@redhat.com>
Date:   Mon, 16 Oct 2023 16:29:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] vfio/mtty: Enable migration support
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20231013195653.1222141-1-alex.williamson@redhat.com>
 <20231013195653.1222141-3-alex.williamson@redhat.com>
From:   =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
In-Reply-To: <20231013195653.1222141-3-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/13/23 21:56, Alex Williamson wrote:
> The mtty driver exposes a PCI serial device to userspace and therefore
> makes an easy target for a sample device supporting migration.  The device
> does not make use of DMA, therefore we can easily claim support for the
> migration P2P states, as well as dirty logging.  This implementation also
> makes use of PRE_COPY support in order to provide migration stream
> compatibility testing, which should generally be considered good practice.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> Much of this should look familiar to vfio-pci variant driver developers
> ;)


LGTM, though, I would isolate the part doing the get/set of the device
state in their own routine to avoid extra noise in mtty_save_device_data()
and mtty_resume_write(). The size of the state could also be dynamic and
computed like done in .migration_get_data_size() handler. This is only
a sample, so it might be worth the extra effort.

That said, this driver could be a summary of the best practice to follow
when implementing support for VFIO migration.

Thanks,

C.

> 
>   samples/vfio-mdev/mtty.c | 582 +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 582 insertions(+)
> 
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 0a2760818e46..572f51342fbd 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -29,6 +29,8 @@
>   #include <linux/serial.h>
>   #include <uapi/linux/serial_reg.h>
>   #include <linux/eventfd.h>
> +#include <linux/anon_inodes.h>
> +
>   /*
>    * #defines
>    */
> @@ -124,6 +126,29 @@ struct serial_port {
>   	u8 intr_trigger_level;  /* interrupt trigger level */
>   };
>   
> +struct mtty_data {
> +	u64 magic;
> +#define MTTY_MAGIC 0x7e9d09898c3e2c4e /* Nothing clever, just random */
> +	u32 major_ver;
> +#define MTTY_MAJOR_VER 1
> +	u32 minor_ver;
> +#define MTTY_MINOR_VER 0
> +	u32 nr_ports;
> +	u32 flags;
> +	struct serial_port ports[2];
> +};
> +
> +struct mdev_state;
> +
> +struct mtty_migration_file {
> +	struct file *filp;
> +	struct mutex lock;
> +	struct mdev_state *mdev_state;
> +	struct mtty_data data;
> +	ssize_t filled_size;
> +	u8 disabled:1;
> +};
> +
>   /* State of each mdev device */
>   struct mdev_state {
>   	struct vfio_device vdev;
> @@ -140,6 +165,12 @@ struct mdev_state {
>   	struct mutex rxtx_lock;
>   	struct vfio_device_info dev_info;
>   	int nr_ports;
> +	struct mutex state_mutex;
> +	enum vfio_device_mig_state state;
> +	struct mutex reset_mutex;
> +	struct mtty_migration_file *saving_migf;
> +	struct mtty_migration_file *resuming_migf;
> +	u8 deferred_reset:1;
>   };
>   
>   static struct mtty_type {
> @@ -716,6 +747,534 @@ static ssize_t mdev_access(struct mdev_state *mdev_state, u8 *buf, size_t count,
>   	return ret;
>   }
>   
> +static void mtty_disable_file(struct mtty_migration_file *migf)
> +{
> +	mutex_lock(&migf->lock);
> +	migf->disabled = true;
> +	migf->filled_size = 0;
> +	migf->filp->f_pos = 0;
> +	mutex_unlock(&migf->lock);
> +}
> +
> +static void mtty_disable_files(struct mdev_state *mdev_state)
> +{
> +	if (mdev_state->saving_migf) {
> +		mtty_disable_file(mdev_state->saving_migf);
> +		fput(mdev_state->saving_migf->filp);
> +		mdev_state->saving_migf = NULL;
> +	}
> +
> +	if (mdev_state->resuming_migf) {
> +		mtty_disable_file(mdev_state->resuming_migf);
> +		fput(mdev_state->resuming_migf->filp);
> +		mdev_state->resuming_migf = NULL;
> +	}
> +}
> +
> +static void mtty_state_mutex_unlock(struct mdev_state *mdev_state)
> +{
> +again:
> +	mutex_lock(&mdev_state->reset_mutex);
> +	if (mdev_state->deferred_reset) {
> +		mdev_state->deferred_reset = false;
> +		mutex_unlock(&mdev_state->reset_mutex);
> +		mdev_state->state = VFIO_DEVICE_STATE_RUNNING;
> +		mtty_disable_files(mdev_state);
> +		goto again;
> +	}
> +	mutex_unlock(&mdev_state->state_mutex);
> +	mutex_unlock(&mdev_state->reset_mutex);
> +}
> +
> +static int mtty_release_migf(struct inode *inode, struct file *filp)
> +{
> +	struct mtty_migration_file *migf = filp->private_data;
> +
> +	mtty_disable_file(migf);
> +	mutex_destroy(&migf->lock);
> +	kfree(migf);
> +
> +	return 0;
> +}
> +
> +static long mtty_precopy_ioctl(struct file *filp, unsigned int cmd,
> +			       unsigned long arg)
> +{
> +	struct mtty_migration_file *migf = filp->private_data;
> +	struct mdev_state *mdev_state = migf->mdev_state;
> +	loff_t *pos = &filp->f_pos;
> +	struct vfio_precopy_info info = {};
> +	unsigned long minsz;
> +	int ret;
> +
> +	if (cmd != VFIO_MIG_GET_PRECOPY_INFO)
> +		return -ENOTTY;
> +
> +	minsz = offsetofend(struct vfio_precopy_info, dirty_bytes);
> +
> +	if (copy_from_user(&info, (void __user *)arg, minsz))
> +		return -EFAULT;
> +	if (info.argsz < minsz)
> +		return -EINVAL;
> +
> +	mutex_lock(&mdev_state->state_mutex);
> +	if (mdev_state->state != VFIO_DEVICE_STATE_PRE_COPY &&
> +	    mdev_state->state != VFIO_DEVICE_STATE_PRE_COPY_P2P) {
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	mutex_lock(&migf->lock);
> +
> +	if (migf->disabled) {
> +		mutex_unlock(&migf->lock);
> +		ret = -ENODEV;
> +		goto unlock;
> +	}
> +
> +	if (*pos > migf->filled_size) {
> +		mutex_unlock(&migf->lock);
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	info.dirty_bytes = 0;
> +	info.initial_bytes = migf->filled_size - *pos;
> +	mutex_unlock(&migf->lock);
> +
> +	ret = copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
> +unlock:
> +	mtty_state_mutex_unlock(mdev_state);
> +	return ret;
> +}
> +
> +static ssize_t mtty_save_read(struct file *filp, char __user *buf,
> +			      size_t len, loff_t *pos)
> +{
> +	struct mtty_migration_file *migf = filp->private_data;
> +	ssize_t ret = 0;
> +
> +	if (pos)
> +		return -ESPIPE;
> +
> +	pos = &filp->f_pos;
> +
> +	mutex_lock(&migf->lock);
> +
> +	dev_dbg(migf->mdev_state->vdev.dev, "%s ask %zu\n", __func__, len);
> +
> +	if (migf->disabled) {
> +		ret = -ENODEV;
> +		goto out_unlock;
> +	}
> +
> +	if (*pos > migf->filled_size) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	len = min_t(size_t, migf->filled_size - *pos, len);
> +	if (len) {
> +		if (copy_to_user(buf, (void *)&migf->data + *pos, len)) {
> +			ret = -EFAULT;
> +			goto out_unlock;
> +		}
> +		*pos += len;
> +		ret = len;
> +	}
> +out_unlock:
> +	dev_dbg(migf->mdev_state->vdev.dev, "%s read %zu\n", __func__, ret);
> +	mutex_unlock(&migf->lock);
> +	return ret;
> +}
> +
> +static const struct file_operations mtty_save_fops = {
> +	.owner = THIS_MODULE,
> +	.read = mtty_save_read,
> +	.unlocked_ioctl = mtty_precopy_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
> +	.release = mtty_release_migf,
> +	.llseek = no_llseek,
> +};
> +
> +static struct mtty_migration_file *
> +mtty_save_device_data(struct mdev_state *mdev_state,
> +		      enum vfio_device_mig_state state)
> +{
> +	struct mtty_migration_file *migf = mdev_state->saving_migf;
> +	struct mtty_migration_file *ret = NULL;
> +
> +	if (migf) {
> +		if (state == VFIO_DEVICE_STATE_STOP_COPY)
> +			goto fill_data;
> +		return ret;
> +	}
> +
> +	migf = kzalloc(sizeof(*migf), GFP_KERNEL_ACCOUNT);
> +	if (!migf)
> +		return ERR_PTR(-ENOMEM);
> +
> +	migf->filp = anon_inode_getfile("mtty_mig", &mtty_save_fops,
> +					migf, O_RDONLY);
> +	if (IS_ERR(migf->filp)) {
> +		int rc = PTR_ERR(migf->filp);
> +
> +		kfree(migf);
> +		return ERR_PTR(rc);
> +	}
> +
> +	stream_open(migf->filp->f_inode, migf->filp);
> +	mutex_init(&migf->lock);
> +	migf->mdev_state = mdev_state;
> +
> +	migf->data.magic = MTTY_MAGIC;
> +	migf->data.major_ver = MTTY_MAJOR_VER;
> +	migf->data.minor_ver = MTTY_MINOR_VER;
> +	migf->data.nr_ports = mdev_state->nr_ports;
> +
> +	migf->filled_size = offsetof(struct mtty_data, ports);
> +
> +	dev_dbg(mdev_state->vdev.dev, "%s filled header to %zu\n",
> +		__func__, migf->filled_size);
> +
> +	ret = mdev_state->saving_migf = migf;
> +
> +fill_data:
> +	if (state == VFIO_DEVICE_STATE_STOP_COPY) {
> +		int i;
> +
> +		mutex_lock(&migf->lock);
> +		for (i = 0; i < mdev_state->nr_ports; i++) {
> +			memcpy(&migf->data.ports[i],
> +			       &mdev_state->s[i], sizeof(struct serial_port));
> +			migf->filled_size += sizeof(struct serial_port);
> +		}
> +		dev_dbg(mdev_state->vdev.dev, "%s filled to %zu\n",
> +			__func__, migf->filled_size);
> +		mutex_unlock(&migf->lock);
> +	}
> +
> +	return ret;
> +}
> +
> +static ssize_t mtty_resume_write(struct file *filp, const char __user *buf,
> +				 size_t len, loff_t *pos)
> +{
> +	struct mtty_migration_file *migf = filp->private_data;
> +	loff_t requested_length;
> +	ssize_t ret = 0;
> +
> +	if (pos)
> +		return -ESPIPE;
> +
> +	pos = &filp->f_pos;
> +
> +	if (*pos < 0 ||
> +	    check_add_overflow((loff_t)len, *pos, &requested_length))
> +		return -EINVAL;
> +
> +	if (requested_length > sizeof(struct mtty_data))
> +		return -ENOMEM;
> +
> +	mutex_lock(&migf->lock);
> +
> +	if (migf->disabled) {
> +		ret = -ENODEV;
> +		goto out_unlock;
> +	}
> +
> +	if (copy_from_user((void *)&migf->data + *pos, buf, len)) {
> +		ret = -EFAULT;
> +		goto out_unlock;
> +	}
> +
> +	*pos += len;
> +	ret = len;
> +	migf->filled_size += len;
> +
> +	dev_dbg(migf->mdev_state->vdev.dev, "%s received %zu, total %zu\n",
> +		__func__, len, migf->filled_size);
> +
> +	if (migf->filled_size >= offsetof(struct mtty_data, ports)) {
> +		struct mdev_state *mdev_state = migf->mdev_state;
> +
> +		if (migf->data.magic != MTTY_MAGIC || migf->data.flags ||
> +		    migf->data.major_ver != MTTY_MAJOR_VER ||
> +		    migf->data.minor_ver != MTTY_MINOR_VER ||
> +		    migf->data.nr_ports != mdev_state->nr_ports) {
> +			dev_dbg(migf->mdev_state->vdev.dev,
> +				"%s failed validation\n", __func__);
> +			ret = -EFAULT;
> +		} else {
> +			dev_dbg(migf->mdev_state->vdev.dev,
> +				"%s header validated\n", __func__);
> +		}
> +	}
> +
> +out_unlock:
> +	mutex_unlock(&migf->lock);
> +	return ret;
> +}
> +
> +static const struct file_operations mtty_resume_fops = {
> +	.owner = THIS_MODULE,
> +	.write = mtty_resume_write,
> +	.release = mtty_release_migf,
> +	.llseek = no_llseek,
> +};
> +
> +static struct mtty_migration_file *
> +mtty_resume_device_data(struct mdev_state *mdev_state)
> +{
> +	struct mtty_migration_file *migf;
> +	int ret;
> +
> +	migf = kzalloc(sizeof(*migf), GFP_KERNEL_ACCOUNT);
> +	if (!migf)
> +		return ERR_PTR(-ENOMEM);
> +
> +	migf->filp = anon_inode_getfile("mtty_mig", &mtty_resume_fops,
> +					migf, O_WRONLY);
> +	if (IS_ERR(migf->filp)) {
> +		ret = PTR_ERR(migf->filp);
> +		kfree(migf);
> +		return ERR_PTR(ret);
> +	}
> +
> +	stream_open(migf->filp->f_inode, migf->filp);
> +	mutex_init(&migf->lock);
> +	migf->mdev_state = mdev_state;
> +
> +	mdev_state->resuming_migf = migf;
> +
> +	return migf;
> +}
> +
> +static int mtty_load_state(struct mdev_state *mdev_state)
> +{
> +	struct mtty_migration_file *migf = mdev_state->resuming_migf;
> +	int i;
> +
> +	mutex_lock(&migf->lock);
> +	/* magic and version already tested by resume write fn */
> +	if (migf->filled_size < offsetof(struct mtty_data, ports) +
> +			(mdev_state->nr_ports * sizeof(struct serial_port))) {
> +		dev_dbg(mdev_state->vdev.dev, "%s expected %zu, got %zu\n",
> +			__func__, offsetof(struct mtty_data, ports) +
> +			(mdev_state->nr_ports * sizeof(struct serial_port)),
> +			migf->filled_size);
> +		mutex_unlock(&migf->lock);
> +		return -EINVAL;
> +	}
> +
> +	for (i = 0; i < mdev_state->nr_ports; i++)
> +		memcpy(&mdev_state->s[i],
> +		       &migf->data.ports[i], sizeof(struct serial_port));
> +
> +	mutex_unlock(&migf->lock);
> +	return 0;
> +}
> +
> +static struct file *mtty_step_state(struct mdev_state *mdev_state,
> +				     enum vfio_device_mig_state new)
> +{
> +	enum vfio_device_mig_state cur = mdev_state->state;
> +
> +	dev_dbg(mdev_state->vdev.dev, "%s: %d -> %d\n", __func__, cur, new);
> +
> +	/*
> +	 * The following state transitions are no-op considering
> +	 * mtty does not do DMA nor require any explicit start/stop.
> +	 *
> +	 *         RUNNING -> RUNNING_P2P
> +	 *         RUNNING_P2P -> RUNNING
> +	 *         RUNNING_P2P -> STOP
> +	 *         PRE_COPY -> PRE_COPY_P2P
> +	 *         PRE_COPY_P2P -> PRE_COPY
> +	 *         STOP -> RUNNING_P2P
> +	 */
> +	if ((cur == VFIO_DEVICE_STATE_RUNNING &&
> +	     new == VFIO_DEVICE_STATE_RUNNING_P2P) ||
> +	    (cur == VFIO_DEVICE_STATE_RUNNING_P2P &&
> +	     (new == VFIO_DEVICE_STATE_RUNNING ||
> +	      new == VFIO_DEVICE_STATE_STOP)) ||
> +	    (cur == VFIO_DEVICE_STATE_PRE_COPY &&
> +	     new == VFIO_DEVICE_STATE_PRE_COPY_P2P) ||
> +	    (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P &&
> +	     new == VFIO_DEVICE_STATE_PRE_COPY) ||
> +	    (cur == VFIO_DEVICE_STATE_STOP &&
> +	     new == VFIO_DEVICE_STATE_RUNNING_P2P))
> +		return NULL;
> +
> +	/*
> +	 * The following state transitions simply close migration files,
> +	 * with the exception of RESUMING -> STOP, which needs to load
> +	 * the state first.
> +	 *
> +	 *         RESUMING -> STOP
> +	 *         PRE_COPY -> RUNNING
> +	 *         PRE_COPY_P2P -> RUNNING_P2P
> +	 *         STOP_COPY -> STOP
> +	 */
> +	if (cur == VFIO_DEVICE_STATE_RESUMING &&
> +	    new == VFIO_DEVICE_STATE_STOP) {
> +		int ret;
> +
> +		ret = mtty_load_state(mdev_state);
> +		if (ret)
> +			return ERR_PTR(ret);
> +		mtty_disable_files(mdev_state);
> +		return NULL;
> +	}
> +
> +	if ((cur == VFIO_DEVICE_STATE_PRE_COPY &&
> +	     new == VFIO_DEVICE_STATE_RUNNING) ||
> +	    (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P &&
> +	     new == VFIO_DEVICE_STATE_RUNNING_P2P) ||
> +	    (cur == VFIO_DEVICE_STATE_STOP_COPY &&
> +	     new == VFIO_DEVICE_STATE_STOP)) {
> +		mtty_disable_files(mdev_state);
> +		return NULL;
> +	}
> +
> +	/*
> +	 * The following state transitions return migration files.
> +	 *
> +	 *         RUNNING -> PRE_COPY
> +	 *         RUNNING_P2P -> PRE_COPY_P2P
> +	 *         STOP -> STOP_COPY
> +	 *         STOP -> RESUMING
> +	 *         PRE_COPY_P2P -> STOP_COPY
> +	 */
> +	if ((cur == VFIO_DEVICE_STATE_RUNNING &&
> +	     new == VFIO_DEVICE_STATE_PRE_COPY) ||
> +	    (cur == VFIO_DEVICE_STATE_RUNNING_P2P &&
> +	     new == VFIO_DEVICE_STATE_PRE_COPY_P2P) ||
> +	    (cur == VFIO_DEVICE_STATE_STOP &&
> +	     new == VFIO_DEVICE_STATE_STOP_COPY) ||
> +	    (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P &&
> +	     new == VFIO_DEVICE_STATE_STOP_COPY)) {
> +		struct mtty_migration_file *migf;
> +
> +		migf = mtty_save_device_data(mdev_state, new);
> +		if (IS_ERR(migf))
> +			return ERR_CAST(migf);
> +
> +		if (migf) {
> +			get_file(migf->filp);
> +
> +			return migf->filp;
> +		}
> +		return NULL;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP &&
> +	    new == VFIO_DEVICE_STATE_RESUMING) {
> +		struct mtty_migration_file *migf;
> +
> +		migf = mtty_resume_device_data(mdev_state);
> +		if (IS_ERR(migf))
> +			return ERR_CAST(migf);
> +
> +		get_file(migf->filp);
> +
> +		return migf->filp;
> +	}
> +
> +	/* vfio_mig_get_next_state() does not use arcs other than the above */
> +	WARN_ON(true);
> +	return ERR_PTR(-EINVAL);
> +}
> +
> +static struct file *mtty_set_state(struct vfio_device *vdev,
> +				   enum vfio_device_mig_state new_state)
> +{
> +	struct mdev_state *mdev_state =
> +		container_of(vdev, struct mdev_state, vdev);
> +	struct file *ret = NULL;
> +
> +	dev_dbg(vdev->dev, "%s -> %d\n", __func__, new_state);
> +
> +	mutex_lock(&mdev_state->state_mutex);
> +	while (mdev_state->state != new_state) {
> +		enum vfio_device_mig_state next_state;
> +		int rc = vfio_mig_get_next_state(vdev, mdev_state->state,
> +						 new_state, &next_state);
> +		if (rc) {
> +			ret = ERR_PTR(rc);
> +			break;
> +		}
> +
> +		ret = mtty_step_state(mdev_state, next_state);
> +		if (IS_ERR(ret))
> +			break;
> +
> +		mdev_state->state = next_state;
> +
> +		if (WARN_ON(ret && new_state != next_state)) {
> +			fput(ret);
> +			ret = ERR_PTR(-EINVAL);
> +			break;
> +		}
> +	}
> +	mtty_state_mutex_unlock(mdev_state);
> +	return ret;
> +}
> +
> +static int mtty_get_state(struct vfio_device *vdev,
> +			  enum vfio_device_mig_state *current_state)
> +{
> +	struct mdev_state *mdev_state =
> +		container_of(vdev, struct mdev_state, vdev);
> +
> +	mutex_lock(&mdev_state->state_mutex);
> +	*current_state = mdev_state->state;
> +	mtty_state_mutex_unlock(mdev_state);
> +	return 0;
> +}
> +
> +static int mtty_get_data_size(struct vfio_device *vdev,
> +			      unsigned long *stop_copy_length)
> +{
> +	struct mdev_state *mdev_state =
> +		container_of(vdev, struct mdev_state, vdev);
> +
> +	*stop_copy_length = offsetof(struct mtty_data, ports) +
> +			(mdev_state->nr_ports * sizeof(struct serial_port));
> +	return 0;
> +}
> +
> +static const struct vfio_migration_ops mtty_migration_ops = {
> +	.migration_set_state = mtty_set_state,
> +	.migration_get_state = mtty_get_state,
> +	.migration_get_data_size = mtty_get_data_size,
> +};
> +
> +static int mtty_log_start(struct vfio_device *vdev,
> +			  struct rb_root_cached *ranges,
> +			  u32 nnodes, u64 *page_size)
> +{
> +	return 0;
> +}
> +
> +static int mtty_log_stop(struct vfio_device *vdev)
> +{
> +	return 0;
> +}
> +
> +static int mtty_log_read_and_clear(struct vfio_device *vdev,
> +				   unsigned long iova, unsigned long length,
> +				   struct iova_bitmap *dirty)
> +{
> +	return 0;
> +}
> +
> +static const struct vfio_log_ops mtty_log_ops = {
> +	.log_start = mtty_log_start,
> +	.log_stop = mtty_log_stop,
> +	.log_read_and_clear = mtty_log_read_and_clear,
> +};
> +
>   static int mtty_init_dev(struct vfio_device *vdev)
>   {
>   	struct mdev_state *mdev_state =
> @@ -748,6 +1307,16 @@ static int mtty_init_dev(struct vfio_device *vdev)
>   	mutex_init(&mdev_state->ops_lock);
>   	mdev_state->mdev = mdev;
>   	mtty_create_config_space(mdev_state);
> +
> +	mutex_init(&mdev_state->state_mutex);
> +	mutex_init(&mdev_state->reset_mutex);
> +	vdev->migration_flags = VFIO_MIGRATION_STOP_COPY |
> +				VFIO_MIGRATION_P2P |
> +				VFIO_MIGRATION_PRE_COPY;
> +	vdev->mig_ops = &mtty_migration_ops;
> +	vdev->log_ops = &mtty_log_ops;
> +	mdev_state->state = VFIO_DEVICE_STATE_RUNNING;
> +
>   	return 0;
>   
>   err_nr_ports:
> @@ -781,6 +1350,8 @@ static void mtty_release_dev(struct vfio_device *vdev)
>   	struct mdev_state *mdev_state =
>   		container_of(vdev, struct mdev_state, vdev);
>   
> +	mutex_destroy(&mdev_state->reset_mutex);
> +	mutex_destroy(&mdev_state->state_mutex);
>   	atomic_add(mdev_state->nr_ports, &mdev_avail_ports);
>   	kfree(mdev_state->vconfig);
>   }
> @@ -797,6 +1368,15 @@ static int mtty_reset(struct mdev_state *mdev_state)
>   {
>   	pr_info("%s: called\n", __func__);
>   
> +	mutex_lock(&mdev_state->reset_mutex);
> +	mdev_state->deferred_reset = true;
> +	if (!mutex_trylock(&mdev_state->state_mutex)) {
> +		mutex_unlock(&mdev_state->reset_mutex);
> +		return 0;
> +	}
> +	mutex_unlock(&mdev_state->reset_mutex);
> +	mtty_state_mutex_unlock(mdev_state);
> +
>   	return 0;
>   }
>   
> @@ -1268,6 +1848,8 @@ static void mtty_close(struct vfio_device *vdev)
>   	struct mdev_state *mdev_state =
>   		container_of(vdev, struct mdev_state, vdev);
>   
> +	mtty_disable_files(mdev_state);
> +
>   	if (mdev_state->intx_evtfd) {
>   		eventfd_ctx_put(mdev_state->intx_evtfd);
>   		mdev_state->intx_evtfd = NULL;

