Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C7B5F6E6F
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 21:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbiJFTxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 15:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232089AbiJFTxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 15:53:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79C8A8783
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 12:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665085999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XWb5iI6KfJPYYCwV3xo2+MA/qeiFYvSDUTXEpn/zusY=;
        b=eWjabsEjiMvWRlJPgdUBjBT23tSGXRdwlGNgn8yNQJdC1m+h2vI4MzAiLkzWgKgUNToOzY
        5DX7NdHtGUnUriI2b20WPfGJGAP01Muk53dpk1lnlsQ7bP2AVJ6+dfo8elPO7X92brnUy2
        OtxHU6sunzxdvtDLAlez3HqPOPPuygA=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-554-crnIkWkaMMm71wAqO9ngQQ-1; Thu, 06 Oct 2022 15:53:18 -0400
X-MC-Unique: crnIkWkaMMm71wAqO9ngQQ-1
Received: by mail-il1-f199.google.com with SMTP id c3-20020a056e020bc300b002fa92ba4606so1915920ilu.14
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 12:53:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XWb5iI6KfJPYYCwV3xo2+MA/qeiFYvSDUTXEpn/zusY=;
        b=aIG/fxTdIMPnjekAmqnyDdYvoLy8xlD9c0Zpo06OWh33aKQdGF5UH3Zgt3+0G7yZ2U
         rYGhghTl5szOhmJMqzL2+9OajOjMndssoF4XNNu5jpr7TgfoLg84x4jfnoz3m+cYzJOT
         4m9pC8nw0GytyugogmOdcVxLoUAF1mf0XwqBqiPoFHOferqsa9wa2y412mXMIA0ZRl+F
         oLNsazIjnL6630IDGk3BmMucg7nbSce8/AzuMcOqkL+XxVQTWb/jhxJP4ahSQ5XBl2s+
         YFrPzbLeFgtaowtjankIozQZ/tXbJ+18RfxiHhVSYtZxQ6l0nx+nbAARSgNJE1PC5ELQ
         ZJ0Q==
X-Gm-Message-State: ACrzQf2V1rQQSyywoGbIO18ZsI39a0Lxva2HxJFaz0PI7yxCaGHIUT9s
        xf0YzVZlKCS0jvxfIumi7j7q8jYkdbOqyz3SyPUwGpArAuv1zgPWwj6aUcK4O2jVsuoc9GvQWff
        kDarvMIPBGS0Q
X-Received: by 2002:a02:a00b:0:b0:363:5daa:99b8 with SMTP id a11-20020a02a00b000000b003635daa99b8mr727402jah.276.1665085997874;
        Thu, 06 Oct 2022 12:53:17 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6wtD7BIS7a8GsND7nN97AhhZUE1taPK3BffEuFNxd65PrZ/EErVIRc7cGcZK2eidUKivkjvw==
X-Received: by 2002:a02:a00b:0:b0:363:5daa:99b8 with SMTP id a11-20020a02a00b000000b003635daa99b8mr727394jah.276.1665085997681;
        Thu, 06 Oct 2022 12:53:17 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id 134-20020a6b018c000000b006b69e79282dsm144187iob.49.2022.10.06.12.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 12:53:17 -0700 (PDT)
Date:   Thu, 6 Oct 2022 13:53:15 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Qian Cai <cai@lca.pw>, Eric Farman <farman@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 0/3] Allow the group FD to remain open when unplugging a
 device
Message-ID: <20221006135315.3270b735.alex.williamson@redhat.com>
In-Reply-To: <0-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com>
References: <0-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Oct 2022 09:40:35 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Testing has shown that virtnodedevd will leave the group FD open for long
> periods, even after all the cdevs have been destroyed. This blocks
> destruction of the VFIO device and is undesirable.
> 
> That approach was selected to accomodate SPAPR which has an broken
> lifecyle model for the iommu_group. However, we can accomodate SPAPR by
> realizing that it doesn't use the iommu core at all, so rules about
> iommu_group lifetime do not apply to it.
> 
> Giving the KVM code its own kref on the iommu_group allows the VFIO core
> code to release its iommu_group reference earlier and we can remove the
> sleep that only existed for SPAPR.
> 
> Jason Gunthorpe (3):
>   vfio: Add vfio_file_is_group()
>   vfio: Hold a reference to the iommu_group in kvm for SPAPR
>   vfio: Make the group FD disassociate from the iommu_group
> 
>  drivers/vfio/pci/vfio_pci_core.c |  2 +-
>  drivers/vfio/vfio.h              |  1 -
>  drivers/vfio/vfio_main.c         | 90 +++++++++++++++++++++-----------
>  include/linux/vfio.h             |  1 +
>  virt/kvm/vfio.c                  | 45 +++++++++++-----
>  5 files changed, 94 insertions(+), 45 deletions(-)

Containers aren't getting cleaned up with this series, starting and
shutting down a libvirt managed VM with vfio-pci devices, an mtty mdev
device, and making use of hugepages, /proc/meminfo shows the hugepages
are not released on VM shutdown and I'm unable to subsequently restart
the VM. Thanks,

Alex

