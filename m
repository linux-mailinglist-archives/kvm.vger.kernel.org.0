Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493584CD1B9
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239448AbiCDJ4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239430AbiCDJ4B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:56:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3784DA41AE
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 01:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646387712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m/28R4qLiomcMPqm8kqlF7h66zN6UfIf8KZF8W80+TY=;
        b=ECYJTjII5tkGSnTyyKdn/t1kZFO/JiMzrBSNPEM/k4zyvME1bNYTNgSextzzNZ2B/cfiGn
        goamefYS5KUGaLKddN5TkW01iRc1xFyqiSvsUkL1+aalfxOQLJzTd6PM3uMsPpIxBIGTp7
        NxH7nGQR90kztw0biGduivednArKBSI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-QqVpD2h1NQyAW9ATWzxLBw-1; Fri, 04 Mar 2022 04:55:11 -0500
X-MC-Unique: QqVpD2h1NQyAW9ATWzxLBw-1
Received: by mail-lf1-f71.google.com with SMTP id b25-20020a0565120b9900b00445bcbc7cc3so2534985lfv.6
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 01:55:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m/28R4qLiomcMPqm8kqlF7h66zN6UfIf8KZF8W80+TY=;
        b=TFjNzEUWxq4nG9rhO7cNoTfNpf0nHm9+B2zzERPWXO6jFSxmJJENUsNiMzPrqe5Rw5
         SxF97C0Lf8cGz/M924jNS68wYR9FL2oqng6EHvJcdNKeKKDeqbsNa5FSz97jr97iyzMD
         QVi3j4O7VViZJfoTdv/nEGMXrTtkykliWYbWom7nACIb9Se0Qtkcv9JCxaC88kasBbU8
         tY5JQ/xvWWnrNzN6PLZ5cHtAxcdHMnIO/cA9/pZLJEqAtjHRJF96E+eCXsQy8Cpet3oK
         EC0Tfg3mW1mwDrePGieIOYgpgwTUmseemsUzncOLgofZDqV51LrtKEpLB1EoMi9fbNWo
         mobg==
X-Gm-Message-State: AOAM533VebOZWxRHb1B1BEblDBE3kXxiQS1ARdGINlb3DBBlB/+4HWTU
        55D4IeAgrKYfl7MEBCWHoMTKUWH+nCBKLG5XBdOKY5NXM+EC4P1x37q7HABm0It6kpH+f8uboWN
        4QiLCYMMLnI6EJkEfJIQiTm7nTAmN
X-Received: by 2002:a2e:9dcf:0:b0:246:3ff1:d770 with SMTP id x15-20020a2e9dcf000000b002463ff1d770mr25533597ljj.330.1646387709938;
        Fri, 04 Mar 2022 01:55:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzIVUvPTZQTrJF/DAKSScLnIn2uD7l2XJ7Qf89pRTkwDeCrip5XsA/bOwodD7WRlPRyWFKePlZrlUJRKdMeuwk=
X-Received: by 2002:a2e:9dcf:0:b0:246:3ff1:d770 with SMTP id
 x15-20020a2e9dcf000000b002463ff1d770mr25533577ljj.330.1646387709718; Fri, 04
 Mar 2022 01:55:09 -0800 (PST)
MIME-Version: 1.0
References: <20201216064818.48239-1-jasowang@redhat.com> <20220224212314.1326-1-gdawar@xilinx.com>
 <20220224212314.1326-8-gdawar@xilinx.com>
In-Reply-To: <20220224212314.1326-8-gdawar@xilinx.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 4 Mar 2022 10:54:33 +0100
Message-ID: <CAJaqyWcAT05-MtOZkyiyNezSzEEmyyDdps0aWm7PMuyS4jqNdA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 07/19] vdpa: introduce config operations for
 associating ASID to a virtqueue group
To:     Gautam Dawar <gautam.dawar@xilinx.com>
Cc:     Gautam Dawar <gdawar@xilinx.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>, tanujk@xilinx.com,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Eli Cohen <elic@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 24, 2022 at 10:25 PM Gautam Dawar <gautam.dawar@xilinx.com> wrote:
>
> This patch introduces a new bus operation to allow the vDPA bus driver
> to associate an ASID to a virtqueue group.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
> ---
>  include/linux/vdpa.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index de22ca1a8ef3..7386860c3995 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -239,6 +239,12 @@ struct vdpa_map_file {
>   *                             @vdev: vdpa device
>   *                             Returns the iova range supported by
>   *                             the device.
> + * @set_group_asid:            Set address space identifier for a
> + *                             virtqueue group
> + *                             @vdev: vdpa device
> + *                             @group: virtqueue group
> + *                             @asid: address space id for this group
> + *                             Returns integer: success (0) or error (< 0)
>   * @set_map:                   Set device memory mapping (optional)
>   *                             Needed for device that using device
>   *                             specific DMA translation (on-chip IOMMU)
> @@ -321,6 +327,10 @@ struct vdpa_config_ops {
>                        u64 iova, u64 size, u64 pa, u32 perm, void *opaque);
>         int (*dma_unmap)(struct vdpa_device *vdev, unsigned int asid,
>                          u64 iova, u64 size);
> +       int (*set_group_asid)(struct vdpa_device *vdev, unsigned int group,
> +                             unsigned int asid);
> +
> +

Nit again, and Jason's patch already contained these, but I think
these two blank lines are introduced unintentionally.

>
>         /* Free device resources */
>         void (*free)(struct vdpa_device *vdev);
> --
> 2.25.0
>

