Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7438D7CC61D
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 16:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbjJQOpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 10:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344094AbjJQOpg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 10:45:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCBDF1
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 07:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697553883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vWgnD0LoPLLR3wBGXxE/FYKfIng4FodU93H6sSGXmg0=;
        b=Tp54+1RlX3aCZs+5CYXNs2sz6lbNgkQ6sWR+U702nuHZKUEQfuC3SFW3e5+zCHKbfl6+q/
        gyMxurqGyVZEW4dq76TyHpkyUniZP9nXCjnYPgd/W9qxT5mrT6XLUYT7YhjA2fkpAbZgNW
        FafKmTH6/m3lO/OhmCzf0b0A38Sdhu8=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-RjdfB3r6O62Qq_JLhaeZhA-1; Tue, 17 Oct 2023 10:44:42 -0400
X-MC-Unique: RjdfB3r6O62Qq_JLhaeZhA-1
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-d9a3954f6dcso7088023276.2
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 07:44:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697553881; x=1698158681;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vWgnD0LoPLLR3wBGXxE/FYKfIng4FodU93H6sSGXmg0=;
        b=cBZqSBgGBJE7lvL6RyLXGrY7UtdbQTFq1xHESjJL5LCfPf4guBbefPApxdm0Iz/KDD
         iPXtyW16h8zNIlmLylU0PHNz1KZkLFDt9qdHnjFMDjpwXQgoZrj+cBDk9ahzSL37fbgV
         30twtsbK0LX5tuDT+wNlap7kBwcqmb/Fub2VOPa2qXa2957UM2rIHyW1Wq92ePeR/uja
         u6tVCeAikfcr8MPKJqkNrl0z/8H/4LdU+r8FfdZhqSyoTx6vPjP2SLmJBjE1OOhDt3Pp
         DOsxRvuOAiekqoPbLOpTztc5BksPZ7GrTTKriRiaTSn31qV65v9opAp5G1VbX3kO2Yo7
         4Z5g==
X-Gm-Message-State: AOJu0Ywb9ChR51g+HhqVz0yduT0diPcIJHyg1zn7IE+AHpnIYQncjhJp
        NcFTfdW1zhM4GUgrvPRcJAWVgM1DAWdaldBvFLPoh0jm5BGwIFYvM0DibTmuZ/egwqjE4CYkd/J
        lFtInawNUl0p+k7Dmoz+z
X-Received: by 2002:a5b:44:0:b0:d89:469a:536d with SMTP id e4-20020a5b0044000000b00d89469a536dmr2267386ybp.47.1697553881119;
        Tue, 17 Oct 2023 07:44:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEuvKQRKG56tW+0jph5Y3g0Ptt+3gkYtsUo6lR1jHWTXuW8zKJRd08emzBm0ryaqAFaw9SQ8A==
X-Received: by 2002:a5b:44:0:b0:d89:469a:536d with SMTP id e4-20020a5b0044000000b00d89469a536dmr2267363ybp.47.1697553880738;
        Tue, 17 Oct 2023 07:44:40 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id es16-20020a056214193000b0064f53943626sm602068qvb.89.2023.10.17.07.44.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Oct 2023 07:44:40 -0700 (PDT)
Message-ID: <24a237f2-b9ac-41d8-9488-0056da34425e@redhat.com>
Date:   Tue, 17 Oct 2023 16:44:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] vfio/mtty: Enable migration support
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20231016224736.2575718-1-alex.williamson@redhat.com>
 <20231016224736.2575718-3-alex.williamson@redhat.com>
From:   =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
In-Reply-To: <20231016224736.2575718-3-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/17/23 00:47, Alex Williamson wrote:
> The mtty driver exposes a PCI serial device to userspace and therefore
> makes an easy target for a sample device supporting migration.  The device
> does not make use of DMA, therefore we can easily claim support for the
> migration P2P states, as well as dirty logging.  This implementation also
> makes use of PRE_COPY support in order to provide migration stream
> compatibility testing, which should generally be considered good practice.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>


Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> ---
>   samples/vfio-mdev/mtty.c | 590 +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 590 insertions(+)
> 
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 245db52bedf2..69ba0281f9e0 100644
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
> +	enum vfio_device_mig_state state;
> +	struct mutex state_mutex;
> +	struct mutex reset_mutex;
> +	struct mtty_migration_file *saving_migf;
> +	struct mtty_migration_file *resuming_migf;
> +	u8 deferred_reset:1;
>   	u8 intx_mask:1;
>   };
>   
> @@ -743,6 +774,543 @@ static ssize_t mdev_access(struct mdev_state *mdev_state, u8 *buf, size_t count,
>   	return ret;
>   }
>   
> +static size_t mtty_data_size(struct mdev_state *mdev_state)
> +{
> +	return offsetof(struct mtty_data, ports) +
> +		(mdev_state->nr_ports * sizeof(struct serial_port));
> +}
> +
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
> +static void mtty_save_state(struct mdev_state *mdev_state)
> +{
> +	struct mtty_migration_file *migf = mdev_state->saving_migf;
> +	int i;
> +
> +	mutex_lock(&migf->lock);
> +	for (i = 0; i < mdev_state->nr_ports; i++) {
> +		memcpy(&migf->data.ports[i],
> +			&mdev_state->s[i], sizeof(struct serial_port));
> +		migf->filled_size += sizeof(struct serial_port);
> +	}
> +	dev_dbg(mdev_state->vdev.dev,
> +		"%s filled to %zu\n", __func__, migf->filled_size);
> +	mutex_unlock(&migf->lock);
> +}
> +
> +static int mtty_load_state(struct mdev_state *mdev_state)
> +{
> +	struct mtty_migration_file *migf = mdev_state->resuming_migf;
> +	int i;
> +
> +	mutex_lock(&migf->lock);
> +	/* magic and version already tested by resume write fn */
> +	if (migf->filled_size < mtty_data_size(mdev_state)) {
> +		dev_dbg(mdev_state->vdev.dev, "%s expected %zu, got %zu\n",
> +			__func__, mtty_data_size(mdev_state),
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
> +	if (state == VFIO_DEVICE_STATE_STOP_COPY)
> +		mtty_save_state(mdev_state);
> +
> +	return ret;
> +}
> +
> +static ssize_t mtty_resume_write(struct file *filp, const char __user *buf,
> +				 size_t len, loff_t *pos)
> +{
> +	struct mtty_migration_file *migf = filp->private_data;
> +	struct mdev_state *mdev_state = migf->mdev_state;
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
> +	if (requested_length > mtty_data_size(mdev_state))
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
> +
> +	dev_dbg(migf->mdev_state->vdev.dev, "%s received %zu, total %zu\n",
> +		__func__, len, migf->filled_size + len);
> +
> +	if (migf->filled_size < offsetof(struct mtty_data, ports) &&
> +	    migf->filled_size + len >= offsetof(struct mtty_data, ports)) {
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
> +	migf->filled_size += len;
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
> +	*stop_copy_length = mtty_data_size(mdev_state);
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
> @@ -775,6 +1343,16 @@ static int mtty_init_dev(struct vfio_device *vdev)
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
> @@ -808,6 +1386,8 @@ static void mtty_release_dev(struct vfio_device *vdev)
>   	struct mdev_state *mdev_state =
>   		container_of(vdev, struct mdev_state, vdev);
>   
> +	mutex_destroy(&mdev_state->reset_mutex);
> +	mutex_destroy(&mdev_state->state_mutex);
>   	atomic_add(mdev_state->nr_ports, &mdev_avail_ports);
>   	kfree(mdev_state->vconfig);
>   }
> @@ -824,6 +1404,15 @@ static int mtty_reset(struct mdev_state *mdev_state)
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
> @@ -1350,6 +1939,7 @@ static void mtty_close(struct vfio_device *vdev)
>   	struct mdev_state *mdev_state =
>   				container_of(vdev, struct mdev_state, vdev);
>   
> +	mtty_disable_files(mdev_state);
>   	mtty_disable_intx(mdev_state);
>   	mtty_disable_msi(mdev_state);
>   }

