Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBD94AE5BE
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 01:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239179AbiBIAII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 19:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239077AbiBIAID (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 19:08:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5314BC06173B
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 16:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644365281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LJZOrVqWNc55dmdiqtBNTiSqfsk4Aunpye1fa+FT0PU=;
        b=YCOsjziw6xoUGLwlxTL3z5oE1DMTHHVxhqkdZIm35/49BiFXnfuigz2wDJyt4LqXheGB8O
        xbirS7pwFuDWv0CWp4KO4PTr3QxbduvnibrRkVdvh98r0cfkcc/hURBVr+Tq6TmKjnqbae
        DcmPprJWhy9/8ntH2dQ32LIf6VqQnjA=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-UGm8FAJBPvmrU8FitXAXCg-1; Tue, 08 Feb 2022 19:07:58 -0500
X-MC-Unique: UGm8FAJBPvmrU8FitXAXCg-1
Received: by mail-il1-f197.google.com with SMTP id a4-20020a92c704000000b002bdfb6040c3so323443ilp.5
        for <kvm@vger.kernel.org>; Tue, 08 Feb 2022 16:07:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=LJZOrVqWNc55dmdiqtBNTiSqfsk4Aunpye1fa+FT0PU=;
        b=bFZ4TR3jTBOLgKljppDUVctpcPVzcYdlr7GJCvAJgiHiP3HTsknYhOQSIBgpPUD76j
         5OBjwNfaEjkA7GWvCbE8mwy7mz03Soz7YvSugPDtqdCNjEGKLZdo9E4QHBkog9y87rEV
         YMJ32qngEQNz69kyb/AFQzUifCeAuqlnMx/ceH7nF3sD0Eki4+zZG2MN55c/WkPnqEm2
         zINhxhMyzT/HXk95gpaOQYCEpTC1SF3e88KW/VBdzKbUadX4WV3fWMDLUh2BgBKXIlqH
         c7cbyxupb10i8DySsEi7JYIptGlYQQ4HEc6/6NHu65m0j0pvPc44q9Te4XYm4uYh5ZmZ
         9wPA==
X-Gm-Message-State: AOAM530NqGa8nI8ZHLIJILCJOXROMzMPFbOnU1bT9iUwy6aWlyhsBtCo
        sf4dMvOo20GlOBGxj4Fbu8GuQ2lRVAV20VDX1sUl3BPjVra+svmulHm3H99Gdd5lkCJDEc1d1Ko
        kK+Icw4nxM+4b
X-Received: by 2002:a6b:7908:: with SMTP id i8mr3135447iop.168.1644365277467;
        Tue, 08 Feb 2022 16:07:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJytZgQsZPabR4ZtYO1vCzOvaocCOOY2JKPCOUSk9Hbs3xp+0K8JlwDa3ItjNdIxw+0fqmmReg==
X-Received: by 2002:a6b:7908:: with SMTP id i8mr3135426iop.168.1644365277159;
        Tue, 08 Feb 2022 16:07:57 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i15sm9040232iog.14.2022.02.08.16.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 16:07:56 -0800 (PST)
Date:   Tue, 8 Feb 2022 17:07:54 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH V7 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Message-ID: <20220208170754.01d05a1d.alex.williamson@redhat.com>
In-Reply-To: <20220207172216.206415-9-yishaih@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
        <20220207172216.206415-9-yishaih@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 7 Feb 2022 19:22:09 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:
> +static int
> +vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
> +					   u32 flags, void __user *arg,
> +					   size_t argsz)
> +{
> +	size_t minsz =
> +		offsetofend(struct vfio_device_feature_mig_state, data_fd);
> +	struct vfio_device_feature_mig_state mig;

Perhaps set default data_fd here?  ie.

  struct vfio_device_feature_mig_state mig = { .data_fd = -1 };

> +	struct file *filp = NULL;
> +	int ret;
> +
> +	if (!device->ops->migration_set_state ||
> +	    !device->ops->migration_get_state)
> +		return -ENOTTY;
> +
> +	ret = vfio_check_feature(flags, argsz,
> +				 VFIO_DEVICE_FEATURE_SET |
> +				 VFIO_DEVICE_FEATURE_GET,
> +				 sizeof(mig));
> +	if (ret != 1)
> +		return ret;
> +
> +	if (copy_from_user(&mig, arg, minsz))
> +		return -EFAULT;
> +
> +	if (flags & VFIO_DEVICE_FEATURE_GET) {
> +		enum vfio_device_mig_state curr_state;
> +
> +		ret = device->ops->migration_get_state(device, &curr_state);
> +		if (ret)
> +			return ret;
> +		mig.device_state = curr_state;
> +		goto out_copy;
> +	}
> +
> +	/* Handle the VFIO_DEVICE_FEATURE_SET */
> +	filp = device->ops->migration_set_state(device, mig.device_state);
> +	if (IS_ERR(filp) || !filp)
> +		goto out_copy;
> +
> +	return vfio_ioct_mig_return_fd(filp, arg, &mig);
> +out_copy:
> +	mig.data_fd = -1;
> +	if (copy_to_user(arg, &mig, sizeof(mig)))
> +		return -EFAULT;
> +	if (IS_ERR(filp))
> +		return PTR_ERR(filp);
> +	return 0;
> +}
...
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index ca69516f869d..3f4a1a7c2277 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -56,6 +56,13 @@ struct vfio_device {
>   *         match, -errno for abort (ex. match with insufficient or incorrect
>   *         additional args)
>   * @device_feature: Fill in the VFIO_DEVICE_FEATURE ioctl
> + * @migration_set_state: Optional callback to change the migration state for
> + *         devices that support migration. The returned FD is used for data
> + *         transfer according to the FSM definition. The driver is responsible
> + *         to ensure that FD is isolated whenever the migration FSM leaves a
> + *         data transfer state or before close_device() returns.
> + @migration_get_state: Optional callback to get the migration state for

Fix formatting, " * @mig..."

> + *         devices that support migration.
>   */
>  struct vfio_device_ops {
>  	char	*name;
...
> +/*
> + * Indicates the device can support the migration API. See enum
> + * vfio_device_mig_state for details. If present flags must be non-zero and
> + * VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE is supported.
> + *
> + * VFIO_MIGRATION_STOP_COPY means that RUNNING, STOP, STOP_COPY and
> + * RESUMING are supported.
> + */
> +struct vfio_device_feature_migration {
> +	__aligned_u64 flags;
> +#define VFIO_MIGRATION_STOP_COPY	(1 << 0)
> +};
> +#define VFIO_DEVICE_FEATURE_MIGRATION 1
> +
> +/*
> + * Upon VFIO_DEVICE_FEATURE_SET,
> + * Execute a migration state change on the VFIO device.
> + * The new state is supplied in device_state.
> + *
> + * The kernel migration driver must fully transition the device to the new state
> + * value before the write(2) operation returns to the user.

Stale comment, there's no write(2) anymore.

> + *
> + * The kernel migration driver must not generate asynchronous device state
> + * transitions outside of manipulation by the user or the VFIO_DEVICE_RESET
> + * ioctl as described above.
> + *
> + * If this function fails then current device_state may be the original
> + * operating state or some other state along the combination transition path.
> + * The user can then decide if it should execute a VFIO_DEVICE_RESET, attempt
> + * to return to the original state, or attempt to return to some other state
> + * such as RUNNING or STOP.
> + *
> + * If the new_state starts a new data transfer session then the FD associated
> + * with that session is returned in data_fd. The user is responsible to close
> + * this FD when it is finished. The user must consider the migration data
> + * segments carried over the FD to be opaque and non-fungible. During RESUMING,
> + * the data segments must be written in the same order they came out of the
> + * saving side FD.
> + *
> + * Upon VFIO_DEVICE_FEATURE_GET,
> + * Get the current migration state of the VFIO device, data_fd will be -1.
> + */
> +struct vfio_device_feature_mig_state {
> +	__u32 device_state; /* From enum vfio_device_mig_state */
> +	__s32 data_fd;
> +};
> +#define VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE 2
> +
> +/*
> + * The device migration Finite State Machine is described by the enum
> + * vfio_device_mig_state. Some of the FSM arcs will create a migration data
> + * transfer session by returning a FD, in this case the migration data will
> + * flow over the FD using read() and write() as discussed below.
> + *
> + * There are 5 states to support VFIO_MIGRATION_STOP_COPY:
> + *  RUNNING - The device is running normally
> + *  STOP - The device does not change the internal or external state
> + *  STOP_COPY - The device internal state can be read out
> + *  RESUMING - The device is stopped and is loading a new internal state
> + *  ERROR - The device has failed and must be reset
> + *
> + * The FSM takes actions on the arcs between FSM states. The driver implements
> + * the following behavior for the FSM arcs:
> + *
> + * RUNNING -> STOP
> + * STOP_COPY -> STOP
> + *   While in STOP the device must stop the operation of the device. The
> + *   device must not generate interrupts, DMA, or advance its internal
> + *   state. When stopped the device and kernel migration driver must accept
> + *   and respond to interaction to support external subsystems in the STOP
> + *   state, for example PCI MSI-X and PCI config pace. Failure by the user to
> + *   restrict device access while in STOP must not result in error conditions
> + *   outside the user context (ex. host system faults).
> + *
> + *   The STOP_COPY arc will terminate a data transfer session.
> + *
> + * RESUMING -> STOP
> + *   Leaving RESUMING terminates a data transfer session and indicates the
> + *   device should complete processing of the data delivered by write(). The
> + *   kernel migration driver should complete the incorporation of data written
> + *   to the data transfer FD into the device internal state and perform
> + *   final validity and consistency checking of the new device state. If the
> + *   user provided data is found to be incomplete, inconsistent, or otherwise
> + *   invalid, the migration driver must fail the SET_STATE ioctl and
> + *   optionally go to the ERROR state as described below.
> + *
> + *   While in STOP the device has the same behavior as other STOP states
> + *   described above.
> + *
> + *   To abort a RESUMING session the device must be reset.
> + *
> + * STOP -> RUNNING
> + *   While in RUNNING the device is fully operational, the device may generate
> + *   interrupts, DMA, respond to MMIO, all vfio device regions are functional,
> + *   and the device may advance its internal state.
> + *
> + * STOP -> STOP_COPY
> + *   This arc begin the process of saving the device state and will return a
> + *   new data_fd.
> + *
> + *   While in the STOP_COPY state the device has the same behavior as STOP
> + *   with the addition that the data transfers session continues to stream the
> + *   migration state. End of stream on the FD indicates the entire device
> + *   state has been transferred.
> + *
> + *   The user should take steps to restrict access to vfio device regions while
> + *   the device is in STOP_COPY or risk corruption of the device migration data
> + *   stream.
> + *
> + * STOP -> RESUMING
> + *   Entering the RESUMING state starts a process of restoring the device
> + *   state and will return a new data_fd. The data stream fed into the data_fd
> + *   should be taken from the data transfer output of the saving group states
> + *   from a compatible device. The migration driver may alter/reset the
> + *   internal device state for this arc if required to prepare the device to
> + *   receive the migration data.
> + *
> + * any -> ERROR
> + *   ERROR cannot be specified as a device state, however any transition request
> + *   can be failed with an errno return and may then move the device_state into
> + *   ERROR. In this case the device was unable to execute the requested arc and
> + *   was also unable to restore the device to any valid device_state.
> + *   To recover from ERROR VFIO_DEVICE_RESET must be used to return the
> + *   device_state back to RUNNING.
> + *
> + * The remaining possible transitions are interpreted as combinations of the
> + * above FSM arcs. As there are multiple paths through the FSM arcs the path
> + * should be selected based on the following rules:
> + *   - Select the shortest path.
> + * Refer to vfio_mig_get_next_state() for the result of the algorithm.
> + *
> + * The automatic transit through the FSM arcs that make up the combination
> + * transition is invisible to the user. When working with combination arcs the
> + * user may see any step along the path in the device_state if SET_STATE
> + * fails. When handling these types of errors users should anticipate future
> + * revisions of this protocol using new states and those states becoming
> + * visible in this case.
> + */
> +enum vfio_device_mig_state {
> +	VFIO_DEVICE_STATE_ERROR = 0,
> +	VFIO_DEVICE_STATE_STOP = 1,
> +	VFIO_DEVICE_STATE_RUNNING = 2,

I'm a little surprised we're not using RUNNING = 0 given all the
objection in the v1 protocol that the default state was non-zero.

> +	VFIO_DEVICE_STATE_STOP_COPY = 3,
> +	VFIO_DEVICE_STATE_RESUMING = 4,
> +};
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
>  
>  /**

Otherwise, I'm still not sure how userspace handles the fact that it
can't know how much data will be read from the device and how important
that is.  There's no replacement of that feature from the v1 protocol
here.

As you noted, it's not only the size of the migration data, but also
the rate the device can generate it.  However, I also expect that it's
generally the external rate that's the limiting factor.  I've not
previously seen any evidence that the device rate is taken into account.

I also think we're still waiting for confirmation from owners of
devices with extremely large device states (vGPUs) whether they consider
the stream FD sufficient versus their ability to directly mmap regions
of the device in the previous protocol.  Thanks,

Alex

