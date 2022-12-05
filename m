Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0956430FC
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 20:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbiLETEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 14:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiLETEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 14:04:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91C12495F
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 11:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670266988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o0azFWZCvyHG6/mqRmEBIfdNzcnjHC/D0RFzH+mRp5o=;
        b=iS77nyOtq6ZQfXxetoy/y0KPrpW81nZsH0yNwfWSY3seTKmNoIjlUJ7VtTiWLFc+bqftA/
        2A5HpUFHe64APb/wvmJcM27YifmqKbwcaM0m0YKkCpsrhDFz9GldCrDAztWb15oWYpKYuQ
        TTQCVAhkeHuK3/9OWB1jYSXezIdSGdc=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-353-VHBv9CkbMRuA5aH2Wphz1w-1; Mon, 05 Dec 2022 14:03:05 -0500
X-MC-Unique: VHBv9CkbMRuA5aH2Wphz1w-1
Received: by mail-il1-f197.google.com with SMTP id x10-20020a056e021bca00b00302b6c0a683so12968745ilv.23
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 11:03:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o0azFWZCvyHG6/mqRmEBIfdNzcnjHC/D0RFzH+mRp5o=;
        b=Ssvf7cDJRzuEvF4uOAeFKjenRAPxz8pFd32Icel1DEviO1bCN5MM8VuNo1XR0bkWqe
         Rj5eADWp6MRAEjdtoLvRnyV2BmZV4l+GIREdikROTfuz3zJjwdj4YYvjHtG/GJuUnAMk
         DD+/dQ2N7e1BqTrzuCVt/odzd39Hgc/1BPCmyE1R+wptB4qput34DbaCdaMIvnlG9dsd
         7xnB8dSGzU2lH+WVsp1JM1pp40bHggilyfHdAIMq6yLMOJT1dHeLjayWek51eqR7s8Tv
         2sclj1FtuhuKO7dx3/BMuz0RSKdNDgCkLMtGSxdKS8+COI3meFA0p+1/hbXbEdPUk2eL
         MzCg==
X-Gm-Message-State: ANoB5pkPSXH27Z/sFE/D5gHtgW2HhfnhPIQxnj3TJ+8IrmND+zUICcDq
        y3d29evr+7wyWuQ8Bxd0/8gLHj4tfkUZ1kwcoG/t9eq+7NWbkjQ0cnaAsaHlY1wgeorIWJcAR12
        PBwnOvUwY2cZp
X-Received: by 2002:a92:360a:0:b0:303:5d8e:5bca with SMTP id d10-20020a92360a000000b003035d8e5bcamr2748296ila.121.1670266984075;
        Mon, 05 Dec 2022 11:03:04 -0800 (PST)
X-Google-Smtp-Source: AA0mqf47KuGgElwFN9e2Sq0olVZ+/nFKc70/tYqkC8iVI4X478hFmK+njombsodKA8+8aZ4XMvLjzw==
X-Received: by 2002:a92:360a:0:b0:303:5d8e:5bca with SMTP id d10-20020a92360a000000b003035d8e5bcamr2748284ila.121.1670266983817;
        Mon, 05 Dec 2022 11:03:03 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a14-20020a056e020e0e00b003036d1ee5cbsm512379ilk.41.2022.12.05.11.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 11:03:03 -0800 (PST)
Date:   Mon, 5 Dec 2022 12:03:01 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <maorg@nvidia.com>, <avihaih@nvidia.com>,
        <cohuck@redhat.com>, <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH V3 vfio 10/14] vfio/mlx5: Introduce vfio precopy ioctl
 implementation
Message-ID: <20221205120301.58884692.alex.williamson@redhat.com>
In-Reply-To: <20221205144838.245287-11-yishaih@nvidia.com>
References: <20221205144838.245287-1-yishaih@nvidia.com>
        <20221205144838.245287-11-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 5 Dec 2022 16:48:34 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> vfio precopy ioctl returns an estimation of data available for
> transferring from the device.
>=20
> Whenever a user is using VFIO_MIG_GET_PRECOPY_INFO, track the current
> state of the device, and if needed, append the dirty data to the
> transfer FD data. This is done by saving a middle state.
>=20
> As mlx5 runs the SAVE command asynchronously, make sure to query for
> incremental data only once there is no active save command.
> Running both in parallel, might end-up with a failure in the incremental
> query command on un-tracked vhca.
>=20
> Also, a middle state will be saved only after the previous state has
> finished its SAVE command and has been fully transferred, this prevents
> endless use resources.
>=20
> Co-developed-by: Shay Drory <shayd@nvidia.com>
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/mlx5/cmd.c  |  16 +++++
>  drivers/vfio/pci/mlx5/main.c | 111 +++++++++++++++++++++++++++++++++++
>  2 files changed, 127 insertions(+)
>=20
> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
> index 160fa38fc78d..12e74ecebe64 100644
> --- a/drivers/vfio/pci/mlx5/cmd.c
> +++ b/drivers/vfio/pci/mlx5/cmd.c
> @@ -67,12 +67,25 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5=
vf_pci_core_device *mvdev,
>  {
>  	u32 out[MLX5_ST_SZ_DW(query_vhca_migration_state_out)] =3D {};
>  	u32 in[MLX5_ST_SZ_DW(query_vhca_migration_state_in)] =3D {};
> +	bool inc =3D query_flags & MLX5VF_QUERY_INC;
>  	int ret;
> =20
>  	lockdep_assert_held(&mvdev->state_mutex);
>  	if (mvdev->mdev_detach)
>  		return -ENOTCONN;
> =20
> +	/*
> +	 * In case PRE_COPY is used, saving_migf is exposed while device is
> +	 * running. Make sure to run only once there is no active save command.
> +	 * Running both in parallel, might end-up with a failure in the
> +	 * incremental query command on un-tracked vhca.
> +	 */
> +	if (inc) {
> +		ret =3D wait_for_completion_interruptible(&mvdev->saving_migf->save_co=
mp);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	MLX5_SET(query_vhca_migration_state_in, in, opcode,
>  		 MLX5_CMD_OP_QUERY_VHCA_MIGRATION_STATE);
>  	MLX5_SET(query_vhca_migration_state_in, in, vhca_id, mvdev->vhca_id);
> @@ -82,6 +95,9 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf=
_pci_core_device *mvdev,
> =20
>  	ret =3D mlx5_cmd_exec_inout(mvdev->mdev, query_vhca_migration_state, in,
>  				  out);
> +	if (inc)
> +		complete(&mvdev->saving_migf->save_comp);
> +
>  	if (ret)
>  		return ret;
> =20
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index 9a36e36ec33b..08c7d96e92b7 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -294,10 +294,121 @@ static void mlx5vf_mark_err(struct mlx5_vf_migrati=
on_file *migf)
>  	wake_up_interruptible(&migf->poll_wait);
>  }
> =20
> +static ssize_t mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
> +				    unsigned long arg)

ssize_t is incompatible with file_operations.unlocked_ioctl in 32-bit
builds (i386):

drivers/vfio/pci/mlx5/main.c:419:27: error: initialization of =E2=80=98long=
 int (*)(struct file *, unsigned int,  long unsigned int)=E2=80=99 from inc=
ompatible pointer type =E2=80=98ssize_t (*)(struct file *, unsigned int,  l=
ong unsigned int)=E2=80=99 {aka =E2=80=98int (*)(struct file *, unsigned in=
t,  long unsigned int)=E2=80=99} [-Werror=3Dincompatible-pointer-types]
  419 |         .unlocked_ioctl =3D mlx5vf_precopy_ioctl,
      |                           ^~~~~~~~~~~~~~~~~~~~


Thanks,
Alex

>  static const struct file_operations mlx5vf_save_fops =3D {
>  	.owner =3D THIS_MODULE,
>  	.read =3D mlx5vf_save_read,
>  	.poll =3D mlx5vf_save_poll,
> +	.unlocked_ioctl =3D mlx5vf_precopy_ioctl,
> +	.compat_ioctl =3D compat_ptr_ioctl,
>  	.release =3D mlx5vf_release_file,
>  	.llseek =3D no_llseek,
>  };

