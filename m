Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A695874056A
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 23:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjF0VCR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 17:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjF0VCQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 17:02:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0D92106
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 14:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687899689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uDraqVlYkekFBNJ0Y0EsgDVmCNSx543RHR3agkDg5bA=;
        b=E1teJ03B87ZU790LtKTlycifKPAx0tlJm1CqJlYC/4bOOIfmk/YC0nfxrOt17Aup67G2Iv
        7QXWCNcA9r2Uft9Lty4gJ2B8YEiyFalfzE4lQ3TRLAjjENps4TgOLEMiwhFm8A7YZUyq/8
        PpUR80BftsoPf2xAjiY5W+kjnsR9u6M=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-B4qUFsISMHC-UzD6A1-xbg-1; Tue, 27 Jun 2023 17:01:27 -0400
X-MC-Unique: B4qUFsISMHC-UzD6A1-xbg-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-77e41268d40so308048039f.3
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 14:01:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687899686; x=1690491686;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uDraqVlYkekFBNJ0Y0EsgDVmCNSx543RHR3agkDg5bA=;
        b=dQmk0FhO31inTIygIDRh1+0VeoGnEzgG8olQ4DwTwGKdum7X5p3cqIzpxr76NVjAj9
         UV7jTXQr97FJfSe1Jc0e2G1ZgFvdKZHPmkhRhLyDHZkeEMVgMSNwUnnLN69GVCcMy2S0
         C7dqc+/OpQfxl3CmA+kShN1hYMpLE3CGvqc+gkUe0s7/iAp5jdKoMwLN0OT2uE40G2vq
         Xni+1Ot5KznpBzfALr3gVAjMajhjNnhwoynJ7w7ndC+Mr7E8+UVhVpTIV2KsL+vf9Suf
         k0qSd4auI0n7817OxotypdETmM5sCifQkF5vO1vRtXgUedWLZvWttML289fLRxoFkUL/
         /ExQ==
X-Gm-Message-State: AC+VfDzwW2u9lx66hgS23VrXfFPqmuYXLGfgdntVCaHfOiQVBqWZH2Xk
        41n0VGWkHLeI7aIulXiCgQSeqrKNeLpF3qtnGdIT7yfOb5NiKE+GHeP1748Agq5o2lmHYOUb/nY
        hrJtVHZU4g6Nc
X-Received: by 2002:a05:6602:2483:b0:783:40ef:c9f6 with SMTP id g3-20020a056602248300b0078340efc9f6mr9061143ioe.19.1687899686651;
        Tue, 27 Jun 2023 14:01:26 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7bHylSCU/1eTTD2k4nZYYlm4UvEIXMbFlAEmAlLuLOaoK/IPO/W8W7K51R4M6iKPO2Jj9z8Q==
X-Received: by 2002:a05:6602:2483:b0:783:40ef:c9f6 with SMTP id g3-20020a056602248300b0078340efc9f6mr9061123ioe.19.1687899686401;
        Tue, 27 Jun 2023 14:01:26 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id k7-20020a6bef07000000b007835a305f61sm1695895ioh.36.2023.06.27.14.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 14:01:25 -0700 (PDT)
Date:   Tue, 27 Jun 2023 15:01:24 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>, kvm@vger.kernel.org,
        Alexander Egorenkov <egorenar@linux.ibm.com>
Subject: Re: [PATCH] vfio/mdev: Move the compat_class initialization to
 module init
Message-ID: <20230627150124.07745516.alex.williamson@redhat.com>
In-Reply-To: <20230626133642.2939168-1-farman@linux.ibm.com>
References: <20230626133642.2939168-1-farman@linux.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 26 Jun 2023 15:36:42 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> The pointer to mdev_bus_compat_class is statically defined at the top
> of mdev_core, and was originally (commit 7b96953bc640 ("vfio: Mediated
> device Core driver") serialized by the parent_list_lock. The blamed
> commit removed this mutex, leaving the pointer initialization
> unserialized. As a result, the creation of multiple MDEVs in parallel
> (such as during boot) can encounter errors during the creation of the
> sysfs entries, such as:
> 
>   [    8.337509] sysfs: cannot create duplicate filename '/class/mdev_bus'
>   [    8.337514] vfio_ccw 0.0.01d8: MDEV: Registered
>   [    8.337516] CPU: 13 PID: 946 Comm: driverctl Not tainted 6.4.0-rc7 #20
>   [    8.337522] Hardware name: IBM 3906 M05 780 (LPAR)
>   [    8.337525] Call Trace:
>   [    8.337528]  [<0000000162b0145a>] dump_stack_lvl+0x62/0x80
>   [    8.337540]  [<00000001622aeb30>] sysfs_warn_dup+0x78/0x88
>   [    8.337549]  [<00000001622aeca6>] sysfs_create_dir_ns+0xe6/0xf8
>   [    8.337552]  [<0000000162b04504>] kobject_add_internal+0xf4/0x340
>   [    8.337557]  [<0000000162b04d48>] kobject_add+0x78/0xd0
>   [    8.337561]  [<0000000162b04e0a>] kobject_create_and_add+0x6a/0xb8
>   [    8.337565]  [<00000001627a110e>] class_compat_register+0x5e/0x90
>   [    8.337572]  [<000003ff7fd815da>] mdev_register_parent+0x102/0x130 [mdev]
>   [    8.337581]  [<000003ff7fdc7f2c>] vfio_ccw_sch_probe+0xe4/0x178 [vfio_ccw]
>   [    8.337588]  [<0000000162a7833c>] css_probe+0x44/0x80
>   [    8.337599]  [<000000016279f4da>] really_probe+0xd2/0x460
>   [    8.337603]  [<000000016279fa08>] driver_probe_device+0x40/0xf0
>   [    8.337606]  [<000000016279fb78>] __device_attach_driver+0xc0/0x140
>   [    8.337610]  [<000000016279cbe0>] bus_for_each_drv+0x90/0xd8
>   [    8.337618]  [<00000001627a00b0>] __device_attach+0x110/0x190
>   [    8.337621]  [<000000016279c7c8>] bus_rescan_devices_helper+0x60/0xb0
>   [    8.337626]  [<000000016279cd48>] drivers_probe_store+0x48/0x80
>   [    8.337632]  [<00000001622ac9b0>] kernfs_fop_write_iter+0x138/0x1f0
>   [    8.337635]  [<00000001621e5e14>] vfs_write+0x1ac/0x2f8
>   [    8.337645]  [<00000001621e61d8>] ksys_write+0x70/0x100
>   [    8.337650]  [<0000000162b2bdc4>] __do_syscall+0x1d4/0x200
>   [    8.337656]  [<0000000162b3c828>] system_call+0x70/0x98
>   [    8.337664] kobject: kobject_add_internal failed for mdev_bus with -EEXIST, don't try to register things with the same name in the same directory.
>   [    8.337668] kobject: kobject_create_and_add: kobject_add error: -17
>   [    8.337674] vfio_ccw: probe of 0.0.01d9 failed with error -12
>   [    8.342941] vfio_ccw_mdev aeb9ca91-10c6-42bc-a168-320023570aea: Adding to iommu group 2
> 
> Move the initialization of the mdev_bus_compat_class pointer to the
> init path, to match the cleanup in module exit. This way the code
> in mdev_register_parent() can simply link the new parent to it,
> rather than determining whether initialization is required first.
> 
> Fixes: 89345d5177aa ("vfio/mdev: embedd struct mdev_parent in the parent data structure")
> Reported-by: Alexander Egorenkov <egorenar@linux.ibm.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/vfio/mdev/mdev_core.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)

Applied to vfio next branch for v6.5.  Thanks!

Alex


> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index 58f91b3bd670..ed4737de4528 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -72,12 +72,6 @@ int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
>  	parent->nr_types = nr_types;
>  	atomic_set(&parent->available_instances, mdev_driver->max_instances);
>  
> -	if (!mdev_bus_compat_class) {
> -		mdev_bus_compat_class = class_compat_register("mdev_bus");
> -		if (!mdev_bus_compat_class)
> -			return -ENOMEM;
> -	}
> -
>  	ret = parent_create_sysfs_files(parent);
>  	if (ret)
>  		return ret;
> @@ -251,13 +245,24 @@ int mdev_device_remove(struct mdev_device *mdev)
>  
>  static int __init mdev_init(void)
>  {
> -	return bus_register(&mdev_bus_type);
> +	int ret;
> +
> +	ret = bus_register(&mdev_bus_type);
> +	if (ret)
> +		return ret;
> +
> +	mdev_bus_compat_class = class_compat_register("mdev_bus");
> +	if (!mdev_bus_compat_class) {
> +		bus_unregister(&mdev_bus_type);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
>  }
>  
>  static void __exit mdev_exit(void)
>  {
> -	if (mdev_bus_compat_class)
> -		class_compat_unregister(mdev_bus_compat_class);
> +	class_compat_unregister(mdev_bus_compat_class);
>  	bus_unregister(&mdev_bus_type);
>  }
>  

