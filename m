Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237AB7A28E7
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 23:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237741AbjIOVDC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 17:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237762AbjIOVCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 17:02:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 55B1C19E
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 14:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694811639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hz2Gr4W8krSahXjUxPdr3jXTt0H0e/3KkApHp87Hn88=;
        b=cVHEeL7WxFeCbvWnE5F3nhzi5X662t5m+gKT9E1JN4J9vj+cgsLDekRowUmxAN8o5p7Qx6
        B9585xcoh2S+PEwSbbrBIWGhri+NyDOAHYYcc9oi0iiVm87JbOxmgfT5k68ce0TzJeY8Ku
        JIkYfYw9+7ZvVCM18aAnnWVxWFoCxiw=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-532-TzoQmc9fPUOMW9frB0I0sA-1; Fri, 15 Sep 2023 17:00:38 -0400
X-MC-Unique: TzoQmc9fPUOMW9frB0I0sA-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7983537d6c1so235970539f.3
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 14:00:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694811637; x=1695416437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hz2Gr4W8krSahXjUxPdr3jXTt0H0e/3KkApHp87Hn88=;
        b=cJU7P40JuGAobMKB920S2mv3Dvp2OHRPZmKPaNbZaWaJNcU0uvbD1NFkdumOeU15mx
         IA9yfNzImrQT/JSFzOQyzF3gVTHE6080cr8hw+xHMO6qS0AvU9lU68G7bYEn2BOkzdI5
         dxa4cMoVt++tUze+GA3sUzt/bxF+oD2SyWVz60MO4YuD/RGKJ5a8h2DG9iStzzGBhvAE
         87nGO9vhPWl738nLU7YlIfT3atP4g8scyAE9PHk490XkK24Jz+edkcdwzd238J6YXxKG
         QelzvlysvucL5NzVSbBB1aTQXcg1BvmhvIXcEB4Rl9knoA9UI4OJps6MvMWPlkg9Qqke
         +05w==
X-Gm-Message-State: AOJu0YwNPqVxDA5vYwmqmVZ3oryjdzZL7/L6B+kOyJlF6omxfjhBWw9i
        ZlWvkWUCwlKvYRGUVjshasJsaei71JowwmqZTPZNdujRku2cO9RlWIXXsHQ2X8HtH2anvt3tSSm
        wysJI0hSJzpYz
X-Received: by 2002:a05:6e02:f93:b0:34c:bc10:2573 with SMTP id v19-20020a056e020f9300b0034cbc102573mr2826211ilo.3.1694811637256;
        Fri, 15 Sep 2023 14:00:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9HCbfJQ/A+CS+mqNbZ0uTH9Ez7eEcwa2DwlwrqMSm/zQsyvnIZbEpIPB3VbM+zyq1iQfSFQ==
X-Received: by 2002:a05:6e02:f93:b0:34c:bc10:2573 with SMTP id v19-20020a056e020f9300b0034cbc102573mr2826200ilo.3.1694811637006;
        Fri, 15 Sep 2023 14:00:37 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id y25-20020a02ce99000000b0042b4e2fc546sm1296952jaq.140.2023.09.15.14.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 14:00:36 -0700 (PDT)
Date:   Fri, 15 Sep 2023 15:00:35 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     liulongfang <liulongfang@huawei.com>
Cc:     <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <jonathan.cameron@huawei.com>, <bcreeley@amd.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>
Subject: Re: [PATCH v15 2/2] Documentation: add debugfs description for vfio
Message-ID: <20230915150035.0311e9be.alex.williamson@redhat.com>
In-Reply-To: <20230901023606.47587-3-liulongfang@huawei.com>
References: <20230901023606.47587-1-liulongfang@huawei.com>
        <20230901023606.47587-3-liulongfang@huawei.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 1 Sep 2023 10:36:06 +0800
liulongfang <liulongfang@huawei.com> wrote:

> From: Longfang Liu <liulongfang@huawei.com>
> 
> 1.Add an debugfs document description file to help users understand
> how to use the accelerator live migration driver's debugfs.
> 2.Update the file paths that need to be maintained in MAINTAINERS
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  Documentation/ABI/testing/debugfs-vfio | 25 +++++++++++++++++++++++++
>  MAINTAINERS                            |  1 +
>  2 files changed, 26 insertions(+)
>  create mode 100644 Documentation/ABI/testing/debugfs-vfio
> 
> diff --git a/Documentation/ABI/testing/debugfs-vfio b/Documentation/ABI/testing/debugfs-vfio
> new file mode 100644
> index 000000000000..086a8c52df35
> --- /dev/null
> +++ b/Documentation/ABI/testing/debugfs-vfio
> @@ -0,0 +1,25 @@
> +What:		/sys/kernel/debug/vfio
> +Date:		Aug 2023
> +KernelVersion:  6.6

This is all 6.7 material now and we might be conservative and mark it
for Oct 2023.

> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	This debugfs file directory is used for debugging
> +		of vfio devices, it's a common directory for all vfio devices.
> +		Each device should create a device subdirectory under this
> +		directory by referencing the public registration interface.

The device sub-directory is already provided by the core.  Thanks,

Alex

> +
> +What:		/sys/kernel/debug/vfio/<device>/migration
> +Date:		Aug 2023
> +KernelVersion:  6.6
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	This debugfs file directory is used for debugging
> +		of vfio devices that support live migration.
> +		The debugfs of each vfio device that supports live migration
> +		could be created under this directory.
> +
> +What:		/sys/kernel/debug/vfio/<device>/migration/state
> +Date:		Aug 2023
> +KernelVersion:  6.6
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	Read the live migration status of the vfio device.
> +		The status of these live migrations includes:
> +		ERROR, RUNNING, STOP, STOP_COPY, RESUMING.
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7b1306615fc0..bd01ca674c60 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22304,6 +22304,7 @@ L:	kvm@vger.kernel.org
>  S:	Maintained
>  T:	git https://github.com/awilliam/linux-vfio.git
>  F:	Documentation/ABI/testing/sysfs-devices-vfio-dev
> +F:	Documentation/ABI/testing/debugfs-vfio
>  F:	Documentation/driver-api/vfio.rst
>  F:	drivers/vfio/
>  F:	include/linux/vfio.h

