Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9990C618979
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 21:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbiKCUWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 16:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiKCUWR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 16:22:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568141F2D9
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 13:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667506879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FGIBJdm2yCS9NEDkWnJJSUFNF518jcKea4C6GgahvI8=;
        b=a+lWHET90KR87RujeMJNlVVmV8sXosO9jKCvSAKx8wM2nCk1D9+jV3q/hTvARN+ebDD3xq
        8Tz1U2XRuv3Jz1BGw0WSn+keg/trbOFKTsCjrIgP4f+fbi3tGHUbR2Lee6GrPNp9FIl3ez
        u/howJ2yvzIZ4g/rtCHPNk7K7AQPjE8=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-371-l3MVZzquP7So5aHQii2WPA-1; Thu, 03 Nov 2022 16:21:18 -0400
X-MC-Unique: l3MVZzquP7So5aHQii2WPA-1
Received: by mail-il1-f200.google.com with SMTP id s2-20020a056e021a0200b0030087a59cf9so2400652ild.11
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 13:21:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FGIBJdm2yCS9NEDkWnJJSUFNF518jcKea4C6GgahvI8=;
        b=1ZmGW3DOL8blkoseeLi4Xwpps0/TSzwi0LJjMmNox8OJeD3LdwsU+Zu160ZrbVHnpX
         l7aUf+66R3oaiKxLeibr5HhnzoJy8ps0SKvohu31uHA6fQLVqtRD+mV2guLSqce/I7C+
         HGdpM4M7rGW0cDWHvZGMkmQibzeBwAoXg9gNdmKxM053DvDhTluCtWumhBbSIHFiIiuv
         HdsUHvpEEApg3k/RswbIYLIDemFkYS3RD1Dw/kh4DgEofAwVfWCE/THMok5sQMoOgv3s
         oqTyg7DqPNejOWwOFrkiZbTJEbKIn5t6PrJ/fm8t7OCcp58BEwB1a8+fgA+R0lbIhsMJ
         EnFA==
X-Gm-Message-State: ACrzQf1ZMsMw2LOtsnPcB9v37EPSwFiPkl6RRmYWk8L74DPcL3Ne/Abs
        GYk7qk524yIfd3jKMzgDbzAxGKcw6yOiPH90m5QGQ++DPiDIq+nblEKTD0UwbqXLggeNIqI5urI
        jYRgmAh6M7d1u
X-Received: by 2002:a05:6602:134f:b0:6a4:cd04:7842 with SMTP id i15-20020a056602134f00b006a4cd047842mr20681637iov.172.1667506875367;
        Thu, 03 Nov 2022 13:21:15 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6b+n/FQ+jKdy5Y/gq3XtiXbGZwvhFSEJecPxP0aBuxrauHPpYDNesL+Ac+Mh+g/WVFNv91IA==
X-Received: by 2002:a05:6602:134f:b0:6a4:cd04:7842 with SMTP id i15-20020a056602134f00b006a4cd047842mr20681622iov.172.1667506875021;
        Thu, 03 Nov 2022 13:21:15 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z1-20020a027a41000000b003717c1df569sm508493jad.165.2022.11.03.13.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 13:21:14 -0700 (PDT)
Date:   Thu, 3 Nov 2022 14:21:13 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Longfang Liu <liulongfang@huawei.com>
Cc:     <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <john.garry@huawei.com>, <cohuck@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] hisi_acc_vfio_pci: Add debugfs to migration
 driver
Message-ID: <20221103142113.73ceddc9.alex.williamson@redhat.com>
In-Reply-To: <20221019081033.3169-2-liulongfang@huawei.com>
References: <20221019081033.3169-1-liulongfang@huawei.com>
        <20221019081033.3169-2-liulongfang@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Cc +kvm list]

On Wed, 19 Oct 2022 16:10:32 +0800
Longfang Liu <liulongfang@huawei.com> wrote:

> There are multiple devices, software and operational steps involved
> in the process of live migration. An error occurred on any node may
> cause the live migration operation to fail.
> This complex process makes it very difficult to locate and analyze
> the cause when the function fails.
>=20
> In order to quickly locate the cause of the problem when the
> live migration fails, I added a set of debugfs to the accelerator
> live migration driver.
>=20
>  +-----------------------------------+
>  |                                   |
>  |                QEMU               |
>  |                                   |
>  +---+--^--------------------+--^----+
>      |  |                    |  |
>      |  |                    |  |
>  +---v--+----+           +---v--+----+
>  |           |           |           |
>  |   src VF  |           |  dest VF  |
>  |           |           |           |
>  +---+--^----+           +---+--^----+
>      |  |                    |  |
>      |  |                    |  |
>  +---v--+----+           +---v--+----+
>  |  Debugfs  |           |  Debugfs  |
>  +-----+-----+           +-----+-----+
>  |state|debug|           |state|debug|
>  +-----+-----+           +-----+-----+
>=20
> This set of debugfs will create two files for each VF device:
> a state file and a debug file.
>=20
> The migration status of the current VF device can be obtained by
> reading the status file.
>=20
> The live migration function of the current device can be tested by
> operating the debug file, and the functional status of the equipment
> and software at each stage can be tested step by step without
> performing the complete live migration function. And after the live
> migration is performed, the migration device data of the live migration
> can be obtained through the debug file.

This is proposed as an hisi_vfio_acc specific debugfs interface, but
common code could certainly implement much of this as well.  Should we
have generic support for debugfs?

Some further comments and concerns below.  Thanks,

Alex

=20
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 314 +++++++++++++++++-
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  14 +
>  2 files changed, 326 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfi=
o/pci/hisilicon/hisi_acc_vfio_pci.c
> index 39eeca18a0f7..eedf8fdf4403 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -3,6 +3,7 @@
>   * Copyright (c) 2021, HiSilicon Ltd.
>   */
> =20
> +#include <linux/anon_inodes.h>
>  #include <linux/device.h>
>  #include <linux/eventfd.h>
>  #include <linux/file.h>
> @@ -16,6 +17,9 @@
> =20
>  #include "hisi_acc_vfio_pci.h"
> =20
> +static struct dentry *hisi_acc_debugfs_root;
> +static atomic_t hisi_acc_root_ref;

This is unused, causing a compile failure:

drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:21:17: error: =E2=80=98hisi_=
acc_root_ref=E2=80=99 defined but not used [-Werror=3Dunused-variable]
   21 | static atomic_t hisi_acc_root_ref;
      |                 ^~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors


> +
>  /* Return 0 on VM acc device ready, -ETIMEDOUT hardware timeout */
>  static int qm_wait_dev_not_ready(struct hisi_qm *qm)
>  {
> @@ -609,6 +613,18 @@ hisi_acc_check_int_state(struct hisi_acc_vf_core_dev=
ice *hisi_acc_vdev)
>  	}
>  }
> =20
> +static void hisi_acc_vf_migf_save(struct hisi_acc_vf_migration_file *src=
_migf,
> +	struct hisi_acc_vf_migration_file *dst_migf)
> +{
> +	if (!dst_migf)
> +		return;
> +
> +	dst_migf->disabled =3D false;
> +	dst_migf->total_length =3D src_migf->total_length;
> +	memcpy(&dst_migf->vf_data, &src_migf->vf_data,
> +		    sizeof(struct acc_vf_data));
> +}
> +
>  static void hisi_acc_vf_disable_fd(struct hisi_acc_vf_migration_file *mi=
gf)
>  {
>  	mutex_lock(&migf->lock);
> @@ -621,12 +637,16 @@ static void hisi_acc_vf_disable_fd(struct hisi_acc_=
vf_migration_file *migf)
>  static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device *hisi=
_acc_vdev)
>  {
>  	if (hisi_acc_vdev->resuming_migf) {
> +		hisi_acc_vf_migf_save(hisi_acc_vdev->resuming_migf,
> +						hisi_acc_vdev->debug_migf);
>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->resuming_migf);
>  		fput(hisi_acc_vdev->resuming_migf->filp);
>  		hisi_acc_vdev->resuming_migf =3D NULL;
>  	}
> =20
>  	if (hisi_acc_vdev->saving_migf) {
> +		hisi_acc_vf_migf_save(hisi_acc_vdev->saving_migf,
> +						hisi_acc_vdev->debug_migf);
>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->saving_migf);
>  		fput(hisi_acc_vdev->saving_migf->filp);
>  		hisi_acc_vdev->saving_migf =3D NULL;
> @@ -1176,6 +1196,269 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_d=
evice *core_vdev, unsigned int
>  	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
>  }
> =20
> +static int hisi_acc_vf_debug_create(struct hisi_acc_vf_core_device *hisi=
_acc_vdev)
> +{
> +	struct hisi_acc_vf_migration_file *migf;
> +
> +	migf =3D kzalloc(sizeof(*migf), GFP_KERNEL);
> +	if (!migf)
> +		return -ENOMEM;
> +
> +	migf->disabled =3D false;
> +	hisi_acc_vdev->debug_migf =3D migf;
> +	mutex_init(&migf->lock);
> +
> +	return 0;
> +}
> +
> +static void hisi_acc_vf_debug_release(struct hisi_acc_vf_migration_file =
*migf)
> +{
> +	migf->disabled =3D true;
> +	migf->total_length =3D 0;
> +	mutex_destroy(&migf->lock);
> +	kfree(migf);
> +}
> +
> +static int hisi_acc_vf_debug_test(struct hisi_acc_vf_core_device *hisi_a=
cc_vdev)
> +{
> +	struct device *dev =3D &hisi_acc_vdev->vf_dev->dev;
> +	struct hisi_qm *vf_qm =3D &hisi_acc_vdev->vf_qm;
> +	u64 data;
> +	int ret;
> +
> +	data =3D readl(vf_qm->io_base + QM_MB_CMD_SEND_BASE);
> +	dev_info(dev, "debug mailbox val: 0x%llx\n", data);
> +
> +	ret =3D qm_wait_dev_not_ready(vf_qm);
> +	if (ret)
> +		dev_err(dev, "VF device not ready!\n");
> +
> +	return ret;
> +}
> +
> +static ssize_t hisi_acc_vf_debug_read(struct file *filp, char __user *bu=
ffer,
> +			   size_t count, loff_t *pos)
> +{
> +	char buf[VFIO_DEV_DBG_LEN];
> +	int len;
> +
> +	len =3D scnprintf(buf, VFIO_DEV_DBG_LEN, "%s\n",
> +			"echo 0: test vf state save\n"
> +			"echo 1: test vf state resume\n"
> +			"echo 2: test vf send mailbox\n"
> +			"echo 3: dump vf config data\n"
> +			"echo 4: dump vf migration state\n");

%d + enum names should be used here.  Does this match best practices
for debugfs?  Seems crude to assume 'echo' and 'cat' throughout, but
also reading from the file to learn commands in this way.

> +
> +	return simple_read_from_buffer(buffer, count, pos, buf, len);
> +}
> +
> +static void hisi_acc_vf_dev_data_dump(struct hisi_acc_vf_core_device *hi=
si_acc_vdev)
> +{
> +	size_t vf_data_sz =3D offsetofend(struct acc_vf_data, padding);
> +	struct device *dev =3D &hisi_acc_vdev->vf_dev->dev;
> +
> +	if (hisi_acc_vdev->debug_migf &&
> +	    hisi_acc_vdev->debug_migf->total_length) {
> +		print_hex_dump(KERN_INFO, "dev mig data:",
> +				DUMP_PREFIX_OFFSET, 16, 1,
> +				(u8 *)&hisi_acc_vdev->debug_migf->vf_data,
> +				vf_data_sz, false);
> +	} else {
> +		dev_info(dev, "device not migrated!\n");
> +	}
> +}

What are the security implications of an external party being able to
manipulate the device migration state and dump it to the console log?
It seems like a barrier to confidential computing support and we don't
even have this hidden behind a Kconfig option.


> +
> +static void hisi_acc_vf_dev_attr_show(struct hisi_acc_vf_core_device *hi=
si_acc_vdev)
> +{
> +	struct device *dev =3D &hisi_acc_vdev->vf_dev->dev;
> +
> +	if (hisi_acc_vdev->debug_migf &&
> +	    hisi_acc_vdev->debug_migf->total_length) {
> +		dev_info(dev, "acc device:\n"
> +			 "device  state: %d\n"
> +			 "device  ready: %u\n"
> +			 "data    valid: %d\n"
> +			 "data     size: %lu\n",
> +			 hisi_acc_vdev->mig_state,
> +			 hisi_acc_vdev->vf_qm_state,
> +			 hisi_acc_vdev->debug_migf->disabled,
> +			 hisi_acc_vdev->debug_migf->total_length);
> +	}  else {
> +		dev_info(dev, "device not migrated!\n");
> +	}
> +}
> +
> +static int hisi_acc_vf_debug_resume(struct hisi_acc_vf_core_device *hisi=
_acc_vdev)
> +{
> +	struct hisi_acc_vf_migration_file *migf =3D hisi_acc_vdev->debug_migf;
> +	struct device *dev =3D &hisi_acc_vdev->vf_dev->dev;
> +	int ret;
> +
> +	ret =3D vf_qm_state_save(hisi_acc_vdev, migf);
> +	if (ret) {
> +		dev_err(dev, "failed to save device data!\n");
> +		return -EINVAL;
> +	}
> +
> +	ret =3D vf_qm_check_match(hisi_acc_vdev, migf);
> +	if (ret) {
> +		dev_err(dev, "failed to match the VF!\n");
> +		return -EINVAL;
> +	}
> +
> +	ret =3D vf_qm_load_data(hisi_acc_vdev, migf);
> +	if (ret) {
> +		dev_err(dev, "failed to recover the VF!\n");
> +		return -EINVAL;
> +	}
> +
> +	vf_qm_fun_reset(&hisi_acc_vdev->vf_qm);
> +	dev_info(dev, "successful to resume device data!\n");
> +
> +	return 0;
> +}
> +
> +static int hisi_acc_vf_debug_save(struct hisi_acc_vf_core_device *hisi_a=
cc_vdev)
> +{
> +	struct hisi_acc_vf_migration_file *migf =3D hisi_acc_vdev->debug_migf;
> +	struct device *dev =3D &hisi_acc_vdev->vf_dev->dev;
> +	int ret;
> +
> +	ret =3D vf_qm_state_save(hisi_acc_vdev, migf);
> +	if (ret) {
> +		dev_err(dev, "failed to save device data!\n");
> +		return -EINVAL;
> +	}
> +	dev_info(dev, "successful to save device data!\n");
> +
> +	return 0;
> +}
> +
> +static ssize_t hisi_acc_vf_debug_write(struct file *filp, const char __u=
ser *buffer,
> +			    size_t count, loff_t *pos)
> +{
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D filp->private_data;
> +	char tbuf[VFIO_DEV_DBG_LEN];
> +	unsigned long val;
> +	int len, ret;
> +
> +	if (*pos)
> +		return 0;
> +
> +	if (count >=3D VFIO_DEV_DBG_LEN)
> +		return -ENOSPC;
> +
> +	len =3D simple_write_to_buffer(tbuf, VFIO_DEV_DBG_LEN - 1,
> +					pos, buffer, count);
> +	if (len < 0 || len > VFIO_DEV_DBG_LEN - 1)
> +		return -EINVAL;
> +	tbuf[len] =3D '\0';
> +	if (kstrtoul(tbuf, 0, &val))
> +		return -EFAULT;
> +
> +	switch (val) {
> +	case STATE_SAVE:
> +		ret =3D hisi_acc_vf_debug_save(hisi_acc_vdev);
> +		if (ret)
> +			return ret;
> +		break;
> +	case STATE_RESUME:
> +		ret =3D hisi_acc_vf_debug_resume(hisi_acc_vdev);
> +		if (ret)
> +			return ret;
> +		break;
> +	case MB_TEST:
> +		ret =3D hisi_acc_vf_debug_test(hisi_acc_vdev);
> +		if (ret)
> +			return -EINVAL;
> +		break;
> +	case MIG_DATA_DUMP:
> +		hisi_acc_vf_dev_data_dump(hisi_acc_vdev);
> +		break;
> +	case MIG_DEV_SHOW:
> +		hisi_acc_vf_dev_attr_show(hisi_acc_vdev);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return count;
> +}
> +
> +static const struct file_operations hisi_acc_vf_debug_fops =3D {
> +	.owner =3D THIS_MODULE,
> +	.open =3D simple_open,
> +	.read =3D hisi_acc_vf_debug_read,
> +	.write =3D hisi_acc_vf_debug_write,
> +};
> +
> +static ssize_t hisi_acc_vf_state_read(struct file *filp, char __user *bu=
ffer,
> +			   size_t count, loff_t *pos)
> +{
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D filp->private_data;
> +	char buf[VFIO_DEV_DBG_LEN];
> +	u32 state;
> +	int len;
> +
> +	state =3D hisi_acc_vdev->mig_state;
> +	switch (state) {
> +	case VFIO_DEVICE_STATE_RUNNING:
> +		len =3D scnprintf(buf, VFIO_DEV_DBG_LEN, "%s\n",
> +			"RUNNING\n");
> +		break;
> +	case VFIO_DEVICE_STATE_STOP_COPY:
> +		len =3D scnprintf(buf, VFIO_DEV_DBG_LEN, "%s\n",
> +			"STOP and COPYING\n");
> +		break;
> +	case VFIO_DEVICE_STATE_STOP:
> +		len =3D scnprintf(buf, VFIO_DEV_DBG_LEN, "%s\n",
> +			"STOP\n");
> +		break;
> +	case VFIO_DEVICE_STATE_RESUMING:
> +		len =3D scnprintf(buf, VFIO_DEV_DBG_LEN, "%s\n",
> +			"RESUMING\n");
> +		break;
> +	default:
> +		len =3D scnprintf(buf, VFIO_DEV_DBG_LEN, "%s\n",
> +			"Error\n");
> +	}

This looks prone to bit-rot, seems we should specifically test for
ERROR and default should probably print the state value.  Also seems
better if the printed value were to match the enum, ie. STOP_COPY
rather than "STOP and COPYING".

> +
> +	return simple_read_from_buffer(buffer, count, pos, buf, len);
> +}
> +
> +static const struct file_operations hisi_acc_vf_state_fops =3D {
> +	.owner =3D THIS_MODULE,
> +	.open =3D simple_open,
> +	.read =3D hisi_acc_vf_state_read,
> +};
> +
> +static void hisi_acc_vf_debugfs_init(struct hisi_acc_vf_core_device *his=
i_acc_vdev)
> +{
> +	struct pci_dev *vf_pdev =3D hisi_acc_vdev->vf_dev;
> +	struct device *dev =3D &vf_pdev->dev;
> +	int ret;
> +
> +	hisi_acc_vdev->debug_root =3D debugfs_create_dir(dev_name(dev), hisi_ac=
c_debugfs_root);
> +	debugfs_create_file("state", 0444, hisi_acc_vdev->debug_root,
> +			    hisi_acc_vdev, &hisi_acc_vf_state_fops);
> +
> +	ret =3D hisi_acc_vf_debug_create(hisi_acc_vdev);
> +	if (ret) {
> +		dev_err(dev, "failed to alloc migration debug node\n");
> +		return;
> +	}
> +	debugfs_create_file("debug", 0644, hisi_acc_vdev->debug_root,
> +			    hisi_acc_vdev, &hisi_acc_vf_debug_fops);
> +}
> +
> +static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device *his=
i_acc_vdev)
> +{
> +	if (hisi_acc_vdev->debug_migf)
> +		hisi_acc_vf_debug_release(hisi_acc_vdev->debug_migf);
> +
> +	debugfs_remove_recursive(hisi_acc_vdev->debug_root);
> +}
> +
>  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>  {
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D container_of(core_vde=
v,
> @@ -1268,7 +1551,7 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *=
pdev, const struct pci_device
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev;
>  	const struct vfio_device_ops *ops =3D &hisi_acc_vfio_pci_ops;
>  	struct hisi_qm *pf_qm;
> -	int vf_id;
> +	int vf_id =3D -1;
>  	int ret;
> =20
>  	pf_qm =3D hisi_acc_get_pf_qm(pdev);
> @@ -1285,6 +1568,9 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *=
pdev, const struct pci_device
>  	if (IS_ERR(hisi_acc_vdev))
>  		return PTR_ERR(hisi_acc_vdev);
> =20
> +	if (vf_id >=3D 0)

Perhaps test (ops =3D=3D &hisi_acc_vfio_pci_migrn_ops) to make this more
obviously tied to migration support.

> +		hisi_acc_vf_debugfs_init(hisi_acc_vdev);
> +
>  	dev_set_drvdata(&pdev->dev, &hisi_acc_vdev->core_device);
>  	ret =3D vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
>  	if (ret)
> @@ -1300,6 +1586,7 @@ static void hisi_acc_vfio_pci_remove(struct pci_dev=
 *pdev)
>  {
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D hisi_acc_drvdata(pdev=
);
> =20
> +	hisi_acc_vf_debugfs_exit(hisi_acc_vdev);
>  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
>  	vfio_put_device(&hisi_acc_vdev->core_device.vdev);
>  }
> @@ -1327,7 +1614,30 @@ static struct pci_driver hisi_acc_vfio_pci_driver =
=3D {
>  	.driver_managed_dma =3D true,
>  };
> =20
> -module_pci_driver(hisi_acc_vfio_pci_driver);
> +static int __init hisi_acc_vfio_pci_init(void)
> +{
> +	int ret;
> +
> +	hisi_acc_debugfs_root =3D debugfs_create_dir("hisi_vfio_acc", NULL);
> +
> +	ret =3D pci_register_driver(&hisi_acc_vfio_pci_driver);
> +	if (ret < 0) {
> +		debugfs_remove_recursive(hisi_acc_debugfs_root);
> +		pr_err("failed to register pci driver.\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void __exit hisi_acc_vfio_pci_exit(void)
> +{
> +	pci_unregister_driver(&hisi_acc_vfio_pci_driver);
> +	debugfs_remove_recursive(hisi_acc_debugfs_root);
> +}
> +
> +module_init(hisi_acc_vfio_pci_init);
> +module_exit(hisi_acc_vfio_pci_exit);
> =20
>  MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Liu Longfang <liulongfang@huawei.com>");
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfi=
o/pci/hisilicon/hisi_acc_vfio_pci.h
> index 67343325b320..ae2a686c2e4d 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> @@ -4,8 +4,11 @@
>  #ifndef HISI_ACC_VFIO_PCI_H
>  #define HISI_ACC_VFIO_PCI_H
> =20
> +#include <linux/debugfs.h>
>  #include <linux/hisi_acc_qm.h>
> =20
> +#define VFIO_DEV_DBG_LEN		256
> +
>  #define MB_POLL_PERIOD_US		10
>  #define MB_POLL_TIMEOUT_US		1000
>  #define QM_CACHE_WB_START		0x204
> @@ -49,6 +52,14 @@
>  #define QM_EQC_DW0		0X8000
>  #define QM_AEQC_DW0		0X8020
> =20
> +enum mig_debug_cmd {
> +	STATE_SAVE,
> +	STATE_RESUME,
> +	MB_TEST,
> +	MIG_DATA_DUMP,
> +	MIG_DEV_SHOW,
> +};
> +
>  struct acc_vf_data {
>  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
>  	/* QM match information */
> @@ -111,5 +122,8 @@ struct hisi_acc_vf_core_device {
>  	spinlock_t reset_lock;
>  	struct hisi_acc_vf_migration_file *resuming_migf;
>  	struct hisi_acc_vf_migration_file *saving_migf;
> +	/* For debugfs */
> +	struct dentry *debug_root;
> +	struct hisi_acc_vf_migration_file *debug_migf;
>  };
>  #endif /* HISI_ACC_VFIO_PCI_H */

