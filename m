Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0797163E35F
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 23:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiK3WXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 17:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiK3WXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 17:23:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51301CB3D
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 14:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669846965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CoHqhEveYiGg5lrInfMEIaWsbrZhjv9/kX2wJql8RsY=;
        b=Vq2xS9sTyZ5OG3eT7jBXeeLdd+KKRqtsZy8yWE6PBHauYmToYD1dLVbc9Nvusgdzfulx2t
        ik7Tjg5Iv68IIo2T/PJcaglTj0YV5vp7k/iefyP0BwOkLlRL1yP22dYiNENiaTrDIcztwc
        37ronJHg2h+UoukcO0V+RyRlPDJciD8=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-138-zQzU9BSwPEi4qxwtHoqCzw-1; Wed, 30 Nov 2022 17:22:44 -0500
X-MC-Unique: zQzU9BSwPEi4qxwtHoqCzw-1
Received: by mail-il1-f199.google.com with SMTP id d2-20020a056e020be200b00300ecc7e0d4so529ilu.5
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 14:22:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CoHqhEveYiGg5lrInfMEIaWsbrZhjv9/kX2wJql8RsY=;
        b=kunQ3Ns7q9atkuSXUXEGCiAycy43MubcszPmP9pMb+JXUDVgURqnI0UjLU50Br/rAI
         nF6dX9B8hB0cQzbKlmM0YQeajbBcQYbvnBThWdctHubj253VjbMxz8w9QBB7bljJzPcI
         SkQj1yPFQRVZvTjGCp/2po1RY0pUhvLI6u0OH/nqL0Fqe+tCyT0bH0nf3n/Cyqsi+YkA
         wG0QPObfGkVsmZz8Is08o/pgSOBA91okbrqUYEMmPSaoLDQb0/aaDHtREZPcMr+bh8N0
         7Mqf+RRDJrKD8wYnxKhlPIVQj6OKxNMHcvgVHonWuEPnuLewVzpM1w2GoiQCsrpFbvfW
         c//A==
X-Gm-Message-State: ANoB5pmfTBoGHs592gVIkNRvPSCwMvYudmPurq5/Vf9ax58WPJWxxeIN
        GNJy9pgEroEjpE9rr9nxS89d2frPH83FNkVq956YCPn9IHLmWND6ZJ3QHfV704vG9UaLXnLOvs4
        sFJiv9N2M7hnW
X-Received: by 2002:a02:62cc:0:b0:375:49ce:39c9 with SMTP id d195-20020a0262cc000000b0037549ce39c9mr30277814jac.99.1669846963469;
        Wed, 30 Nov 2022 14:22:43 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6jL4vx3YeKfxl1C6xcZ97g8WsVOPewM1bzYNCpii16KYB6sJRHryF/MeH5hIqIo1C3nbNg3w==
X-Received: by 2002:a02:62cc:0:b0:375:49ce:39c9 with SMTP id d195-20020a0262cc000000b0037549ce39c9mr30277799jac.99.1669846963236;
        Wed, 30 Nov 2022 14:22:43 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e92-20020a028665000000b00389fe1c8d4csm991455jai.112.2022.11.30.14.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 14:22:42 -0800 (PST)
Date:   Wed, 30 Nov 2022 15:22:40 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <maorg@nvidia.com>, <avihaih@nvidia.com>,
        <cohuck@redhat.com>, Juan Quintela <quintela@redhat.com>
Subject: Re: [PATCH V1 vfio 02/14] vfio: Extend the device migration
 protocol with PRE_COPY
Message-ID: <20221130152240.11a24c4d.alex.williamson@redhat.com>
In-Reply-To: <20221124173932.194654-3-yishaih@nvidia.com>
References: <20221124173932.194654-1-yishaih@nvidia.com>
        <20221124173932.194654-3-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Nov 2022 19:39:20 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:
> +/**
> + * VFIO_MIG_GET_PRECOPY_INFO - _IO(VFIO_TYPE, VFIO_BASE + 21)
> + *
> + * This ioctl is used on the migration data FD in the precopy phase of the
> + * migration data transfer. It returns an estimate of the current data sizes
> + * remaining to be transferred. It allows the user to judge when it is
> + * appropriate to leave PRE_COPY for STOP_COPY.
> + *
> + * This ioctl is valid only in PRE_COPY states and kernel driver should
> + * return -EINVAL from any other migration state.
> + *
> + * The vfio_precopy_info data structure returned by this ioctl provides
> + * estimates of data available from the device during the PRE_COPY states.
> + * This estimate is split into two categories, initial_bytes and
> + * dirty_bytes.
> + *
> + * The initial_bytes field indicates the amount of initial mandatory precopy
> + * data available from the device. This field should have a non-zero initial
> + * value and decrease as migration data is read from the device.
> + * It is a must to leave PRE_COPY for STOP_COPY only after this field reach
> + * zero.


Is this actually a requirement that's compatible with current QEMU
behavior?  It's my impression that a user can force the migration to
move to STOP_COPY at any point in time.  Thanks,

Alex

> + *
> + * The dirty_bytes field tracks device state changes relative to data
> + * previously retrieved.  This field starts at zero and may increase as
> + * the internal device state is modified or decrease as that modified
> + * state is read from the device.
> + *
> + * Userspace may use the combination of these fields to estimate the
> + * potential data size available during the PRE_COPY phases, as well as
> + * trends relative to the rate the device is dirtying its internal
> + * state, but these fields are not required to have any bearing relative
> + * to the data size available during the STOP_COPY phase.
> + *
> + * Drivers have a lot of flexibility in when and what they transfer during the
> + * PRE_COPY phase, and how they report this from VFIO_MIG_GET_PRECOPY_INFO.
> + *
> + * During pre-copy the migration data FD has a temporary "end of stream" that is
> + * reached when both initial_bytes and dirty_byte are zero. For instance, this
> + * may indicate that the device is idle and not currently dirtying any internal
> + * state. When read() is done on this temporary end of stream the kernel driver
> + * should return ENOMSG from read(). Userspace can wait for more data (which may
> + * never come) by using poll.
> + *
> + * Once in STOP_COPY the migration data FD has a permanent end of stream
> + * signaled in the usual way by read() always returning 0 and poll always
> + * returning readable. ENOMSG may not be returned in STOP_COPY. Support
> + * for this ioctl is optional.
> + *
> + * Return: 0 on success, -1 and errno set on failure.
> + */
> +struct vfio_precopy_info {
> +	__u32 argsz;
> +	__u32 flags;
> +	__aligned_u64 initial_bytes;
> +	__aligned_u64 dirty_bytes;
>  };
>  
> +#define VFIO_MIG_GET_PRECOPY_INFO _IO(VFIO_TYPE, VFIO_BASE + 21)
> +
>  /*
>   * Upon VFIO_DEVICE_FEATURE_SET, allow the device to be moved into a low power
>   * state with the platform-based power management.  Device use of lower power

