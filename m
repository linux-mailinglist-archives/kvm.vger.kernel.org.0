Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92AB644E32
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 22:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiLFVuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 16:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiLFVuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 16:50:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAF13E0A4
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 13:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670363352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DGTEAbRK9dRUHgahifTbv1blBdUPytXFhdS0+7GmylE=;
        b=jPWY3nYOkBvVytSgK9qCZ9Hc//zhuui43MlQdp+TFiGvwCQ+gvORFGeqIxPx27fYbrwjBf
        PpCOExfSFS75hTxJJO4gtMHDD7vG9JOsxH5bWEV7q0xO7yZb17jXjxcDCLRUNzewnGs326
        F4jNeHQSZVl453xYK0OvBxLSfdMR3Yg=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-336-sEy88xnmNiqbZhsBd-fOIg-1; Tue, 06 Dec 2022 16:49:11 -0500
X-MC-Unique: sEy88xnmNiqbZhsBd-fOIg-1
Received: by mail-io1-f71.google.com with SMTP id f23-20020a5d8157000000b006dfb209094fso12637033ioo.18
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 13:49:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DGTEAbRK9dRUHgahifTbv1blBdUPytXFhdS0+7GmylE=;
        b=yfh6T+q65E75RMscVEXIiUtysC61HOnCE0gaISkWSSAB3+T9KQxnCodDePjzCgfGcP
         H58kpqYw/rHSiY/IwoVxU50XVuRDqSCv5Xkg92Ebe3E2j1JFjauNIOFhroXEeXoibjF3
         ZpSGHsbKzn+BLtFlIr+81MECY9iiUkDAjbIBr5H60Y0DiEPO6v6N8UKe5PP1DLMbLOF/
         mXFVCHtsrhHnrw1uGjDEv3lH7XIbKnbelMsIQ42a+M+tcXgi8ZKhWG1Kj6c7e2uxs0o+
         cEBjdSKl07w4n82RCBxQkoUWDf0mL68T7In4nAmuDGJqtpdN5RqiX3kVuP/KgjFOQGnT
         A+yA==
X-Gm-Message-State: ANoB5pkD34+Sv2fzopq9gdrj3uc5qFFPCt0NkMy5IabsBG3EyJYrdoRD
        LjTHOKTHcKGiIJel/rtpGjEJp+B+KdRFGkcdc82cIko83/7AGhdE9idipAqwJIemhLCZGqVGQM2
        Z9aquIf0xCU2+
X-Received: by 2002:a02:6d6f:0:b0:375:c16b:7776 with SMTP id e47-20020a026d6f000000b00375c16b7776mr32596925jaf.54.1670363350456;
        Tue, 06 Dec 2022 13:49:10 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4h8+gxaQRC9EfEEygqF4FQf03+JQR30Wq7HCz+CPqgvfMC5UJgpzZWSvmMg6mvSHoVMHs6Qw==
X-Received: by 2002:a02:6d6f:0:b0:375:c16b:7776 with SMTP id e47-20020a026d6f000000b00375c16b7776mr32596909jaf.54.1670363350131;
        Tue, 06 Dec 2022 13:49:10 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z17-20020a056602081100b006ddd15ca0absm2631626iow.25.2022.12.06.13.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 13:49:09 -0800 (PST)
Date:   Tue, 6 Dec 2022 14:49:07 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <maorg@nvidia.com>, <avihaih@nvidia.com>,
        <cohuck@redhat.com>, <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH V4 vfio 00/14] Add migration PRE_COPY support for mlx5
 driver
Message-ID: <20221206144907.25a08b52.alex.williamson@redhat.com>
In-Reply-To: <20221206083438.37807-1-yishaih@nvidia.com>
References: <20221206083438.37807-1-yishaih@nvidia.com>
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

On Tue, 6 Dec 2022 10:34:24 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> This series adds migration PRE_COPY uAPIs and their implementation as part of
> mlx5 driver.
> 
> The uAPIs follow some discussion that was done in the mailing list [1] in this
> area.
> 
> By the time the patches were sent, there was no driver implementation for the
> uAPIs, now we have it for mlx5 driver.
> 
> The optional PRE_COPY state opens the saving data transfer FD before reaching
> STOP_COPY and allows the device to dirty track the internal state changes with
> the general idea to reduce the volume of data transferred in the STOP_COPY
> stage.
> 
> While in PRE_COPY the device remains RUNNING, but the saving FD is open.
> 
> A new ioctl VFIO_MIG_GET_PRECOPY_INFO is provided to allow userspace to query
> the progress of the precopy operation in the driver with the idea it will judge
> to move to STOP_COPY once the initial data set is transferred, and possibly
> after the dirty size has shrunk appropriately.
> 
> User space can detect whether PRE_COPY is supported for a given device by
> checking the VFIO_MIGRATION_PRE_COPY flag once using the
> VFIO_DEVICE_FEATURE_MIGRATION ioctl.
> 
> Extra details exist as part of the specific uAPI patch from the series.
> 
> Finally, we come with mlx5 implementation based on its device specification for
> PRE_COPY.
> 
> To support PRE_COPY, mlx5 driver is transferring multiple states (images) of
> the device. e.g.: the source VF can save and transfer multiple states, and the
> target VF will load them by that order.
> 
> The device is saving three kinds of states:
> 1) Initial state - when the device moves to PRE_COPY state.
> 2) Middle state - during PRE_COPY phase via VFIO_MIG_GET_PRECOPY_INFO,
>                   can be multiple such states.
> 3) Final state - when the device moves to STOP_COPY state.
> 
> After moving to PRE_COPY state, the user is holding the saving FD and should
> use it for transferring the data from the source to the target while the VM is
> still running. From user point of view, it's a stream of data, however, from
> mlx5 driver point of view it includes multiple images/states. For that, it sets
> some headers with metadata on the source to be parsed on the target.
> 
> At some point, user may switch the device state from PRE_COPY to STOP_COPY,
> this will invoke saving of the final state.
> 
> As discussed earlier in the mailing list, the data that is returned as part of
> PRE_COPY is not required to have any bearing relative to the data size
> available during the STOP_COPY phase.
> 
> For this, we have the VFIO_DEVICE_FEATURE_MIG_DATA_SIZE option.
> 
> In mlx5 driver we could gain with this series about 20-30 percent improvement
> in the downtime compared to the previous code when PRE_COPY wasn't supported.
> 
> The series includes some pre-patches to be ready for managing multiple images
> then it comes with the PRE_COPY implementation itself.
> 
> The matching qemu changes can be previewed here [2].
> 
> They come on top of the v2 migration protocol patches that were sent already to
> the mailing list.
> 
> [1] https://lore.kernel.org/kvm/20220302172903.1995-8-shameerali.kolothum.thodi@huawei.com/
> [2] https://github.com/avihai1122/qemu/commits/mig_v2_precopy
> 
> Changes from V3: https://www.spinics.net/lists/kvm/msg297449.html
> Patch #1:
> - Add Acked-by: Leon Romanovsky.
> Patch #10:
> - Fix mlx5vf_precopy_ioctl() signature to return long instead of ssize_t
>   as Alex pointed out.
> 
> Changes from V2: https://www.spinics.net/lists/kvm/msg297112.html
> 
> Patch #2:
> - Add a note that the VFIO_MIG_GET_PRECOPY_INFO ioctl is mandatory when
>   a driver claims to support VFIO_MIGRATION_PRE_COPY as was raised by
>   Shameer Kolothum.
> - Add Reviewed-by: Shameer Kolothum and Kevin Tian.
> Patch #3:
> - Add a comment in the code as suggested by Jason.
> All:
> - Add Reviewed-by: Jason Gunthorpe for the series.
> 
> Note:
> As pointed out by Leon in the mailing list, no need for a PR for the
> first patch of net/mlx5.
> 
> Changes from V1: https://www.spinics.net/lists/kvm/msg296475.html
> 
> Patch #2: Rephrase the 'initial_bytes' meaning as was suggested by Jason.
> Patch #9: Fix to send header based on PRE_COPY support.
> Patch #13: Fix some unwind flow to call complete().
> 
> Changes from V0: https://www.spinics.net/lists/kvm/msg294247.html
> 
> Drop the first 2 patches that Alex merged already.
> Refactor mlx5 implementation based on Jason's comments on V0, it includes
> the below:
> * Refactor the PD usage to be aligned with the migration file life cycle.
> * Refactor the MKEY usage to be aligned with the migration file life cycle.
> * Refactor the migration file state.
> * Use queue based data chunks to simplify the driver code.
> * Use the FSM model on the target to simplify the driver code.
> * Extend the driver pre_copy header for future use.
> 
> Yishai
> 
> Jason Gunthorpe (1):
>   vfio: Extend the device migration protocol with PRE_COPY
> 
> Shay Drory (3):
>   net/mlx5: Introduce ifc bits for pre_copy
>   vfio/mlx5: Fallback to STOP_COPY upon specific PRE_COPY error
>   vfio/mlx5: Enable MIGRATION_PRE_COPY flag
> 
> Yishai Hadas (10):
>   vfio/mlx5: Enforce a single SAVE command at a time
>   vfio/mlx5: Refactor PD usage
>   vfio/mlx5: Refactor MKEY usage
>   vfio/mlx5: Refactor migration file state
>   vfio/mlx5: Refactor to use queue based data chunks
>   vfio/mlx5: Introduce device transitions of PRE_COPY
>   vfio/mlx5: Introduce SW headers for migration states
>   vfio/mlx5: Introduce vfio precopy ioctl implementation
>   vfio/mlx5: Consider temporary end of stream as part of PRE_COPY
>   vfio/mlx5: Introduce multiple loads
> 
>  drivers/vfio/pci/mlx5/cmd.c   | 409 ++++++++++++++----
>  drivers/vfio/pci/mlx5/cmd.h   |  96 ++++-
>  drivers/vfio/pci/mlx5/main.c  | 752 ++++++++++++++++++++++++++++------
>  drivers/vfio/vfio_main.c      |  74 +++-
>  include/linux/mlx5/mlx5_ifc.h |  14 +-
>  include/uapi/linux/vfio.h     | 123 +++++-
>  6 files changed, 1248 insertions(+), 220 deletions(-)

Applied to vfio next branch for v6.2.  Thanks,

Alex

