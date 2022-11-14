Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D135F6288E0
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 20:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236823AbiKNTFQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 14:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbiKNTFO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 14:05:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CD760F9
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 11:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668452654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1B6nLTDuPebHJGyEVjgwH031QeW3UBO4n3I89vsx0DI=;
        b=AF3jXeaPyv4mJYfYldbAmG2tn0XdPZLYoq/GYfA/pA9HgZ4ioDgTCoWotLqREaLjEsf1W8
        le1H7q/WiGaDxzFMIjECQhhqlqQGZzhgnaeXF5LU3L9D8UkEVhUlWSXcfFNYGhAEGqRsdZ
        3Y/cX91c07kRqEPG5tF0GhMuXXN3E4g=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-328-HFh3RMFfPLS3KTuZXcrqGQ-1; Mon, 14 Nov 2022 14:04:13 -0500
X-MC-Unique: HFh3RMFfPLS3KTuZXcrqGQ-1
Received: by mail-il1-f200.google.com with SMTP id n8-20020a056e02100800b00300906a2170so9702167ilj.2
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 11:04:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1B6nLTDuPebHJGyEVjgwH031QeW3UBO4n3I89vsx0DI=;
        b=SAsvx3hN0eSDYHkaYkiaIuBGc7l3Z5iCHeLX8yvpRN6TkXjsbbkjXaKzqidp2Juqmj
         u615Llpex02/6kAYV8pQpuhnmj8c49/PI+GkuYgPo9JvtjA1iXcJPFhs/BV7fdfCej1P
         dmESJcfHKoxujBC3zB3Z0OoLoIEBoni8ZYcWun+x9XiGoZ15gcieOrkwtIbR5rmV/PyG
         62pdLqLxSr5o92q0jlYXK6LLLWf753Rlr/n4Vh0QV95+bPH46kmdoHQvPQczOkN2gGq+
         jNPQFNd7fRUCuWwGkHUV9Md5HmJ31gEhZqcm5E3JyuuxvGRlzeeSD94IgyNrxqZ8/4Qs
         2kpw==
X-Gm-Message-State: ANoB5pneqNGyuRcOSCjvX5TRO8GxOuHKCQMrpnqmdq7aofHyNADdpWqU
        UoAaoZHmu80eDuX6iBbYbu11guLUQ/rDUjQKLaX0nR6kcJqZJ7e4/0xjWW1OfZtwWbL0lQKmU7P
        oWypIflnvrZZ1
X-Received: by 2002:a92:cc4a:0:b0:2f9:32c2:a10a with SMTP id t10-20020a92cc4a000000b002f932c2a10amr6751808ilq.47.1668452652245;
        Mon, 14 Nov 2022 11:04:12 -0800 (PST)
X-Google-Smtp-Source: AA0mqf49zkiZ5xNuupHN70MsYb1YtxvgHFAHTdIild0fejwZjcHqQ82yArlb+zfqeOpT0dYfF0UzvA==
X-Received: by 2002:a92:cc4a:0:b0:2f9:32c2:a10a with SMTP id t10-20020a92cc4a000000b002f932c2a10amr6751794ilq.47.1668452652030;
        Mon, 14 Nov 2022 11:04:12 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id o16-20020a02a1d0000000b003751977da74sm3837315jah.102.2022.11.14.11.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 11:04:11 -0800 (PST)
Date:   Mon, 14 Nov 2022 12:04:10 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, <kvm@vger.kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <shayd@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: Re: [PATCH vfio 01/13] vfio: Add an option to get migration data
 size
Message-ID: <20221114120410.5facb7e5.alex.williamson@redhat.com>
In-Reply-To: <dae6bdc2-eee5-daaf-e98f-1ca278310f3d@nvidia.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
        <20221106174630.25909-2-yishaih@nvidia.com>
        <Y2veI4vCSO1xUi/C@nvidia.com>
        <dae6bdc2-eee5-daaf-e98f-1ca278310f3d@nvidia.com>
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

On Sun, 13 Nov 2022 18:58:50 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 09/11/2022 19:06, Jason Gunthorpe wrote:
> > On Sun, Nov 06, 2022 at 07:46:18PM +0200, Yishai Hadas wrote:  
> >> Add an option to get migration data size by introducing a new migration
> >> feature named VFIO_DEVICE_FEATURE_MIG_DATA_SIZE.
> >>
> >> Upon VFIO_DEVICE_FEATURE_GET the estimated data length that will be
> >> required to complete STOP_COPY is returned.
> >>
> >> This option may better enable user space to consider before moving to
> >> STOP_COPY whether it can meet the downtime SLA based on the returned
> >> data.
> >>
> >> The patch also includes the implementation for mlx5 and hisi for this
> >> new option to make it feature complete for the existing drivers in this
> >> area.
> >>
> >> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> >> ---
> >>   .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  9 ++++++
> >>   drivers/vfio/pci/mlx5/main.c                  | 18 +++++++++++
> >>   drivers/vfio/pci/vfio_pci_core.c              |  3 +-
> >>   drivers/vfio/vfio_main.c                      | 32 +++++++++++++++++++
> >>   include/linux/vfio.h                          |  5 +++
> >>   include/uapi/linux/vfio.h                     | 13 ++++++++
> >>   6 files changed, 79 insertions(+), 1 deletion(-)  
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> >
> > Jason  
> 
> Alex,
> 
> Are we fine with taking the first 2 patches from this series ?
> 
> For this one we have reviewed-by from Jason and Longfang Liu, the next 
> patch has also a reviewed-by Jason and is very simple.
> 
> Please let me know if you want me to send them separately outside of 
> this pre_copy series and add the mentioned reviewed-by or that you can 
> just collect them out from the list by yourself.

Applied 1 & 2 to vfio next branch for v6.2.  Thanks,

Alex

