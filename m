Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B6669FAA1
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 19:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbjBVSAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 13:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbjBVSAc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 13:00:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF12B38EA7
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 09:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677088788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IWyApdiQGDHbUGKS9+Y31lH4Jek/qAyUXTgCGlvrld4=;
        b=imCFr0XcQxdnsbwFKFgNNSMGUZY7lEMBymrdsRNL7OLI8f3Dcine9Ugg5S+x91nQjT45lM
        NwEZv4vw0fiIHx2EMHxnzhgSmG1+ZWueOetdXxPO7hZsWrdaRASqDWIkZhOhM7p0tpkk2x
        NhbaxLs2MsSYIFUga8EdLaSjqwCBovc=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-645-v0gZzuhZOeqfuw7tcmpiGA-1; Wed, 22 Feb 2023 12:59:46 -0500
X-MC-Unique: v0gZzuhZOeqfuw7tcmpiGA-1
Received: by mail-il1-f199.google.com with SMTP id z5-20020a92bf05000000b00313f4759a73so4299706ilh.9
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 09:59:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IWyApdiQGDHbUGKS9+Y31lH4Jek/qAyUXTgCGlvrld4=;
        b=XkvSCVeFhmu0WLkmU9MMI74ebwtXMdd2MbVLK4XfbMCnr1bUt9hU9fOccbPQmls9b3
         6e0DWUeIgxZEurMeJa0onNgCSJcGIxqpjw9bZCF52r2B11ih5TOEFAdQDltDJg3X4A7o
         4u9gKod0vm8v5R7fqAK/vwkrhT4LtSd7R4iflLE607APLNkijydE7w406ksm1FdXkutE
         OrSZ0vgYi1UWqDeQ/eycL3Gs6HTrTE73OV0Gt7lPs8zV6KxrXumyK6680nOSRu5gucN+
         Mqfp2yrkfx9/TUTo1GtLNdC4oCk64OBzhUUDvFxe45KfmkHk65EMkL+QafS7D4iVfF28
         lPvA==
X-Gm-Message-State: AO0yUKWmKZ5H4yhiuyX7soJL8ynllhg+nurL8bG3DWCJHFZzHVfi5vvv
        lvAYTzG8iNcXXc9wf1bsK3L4ZySSVyaXLyVvrQWfBE7DSDTMdaRpLp8aI8baqL9PxUbDPei0u7d
        zeACMM18yz6Km
X-Received: by 2002:a05:6e02:1d99:b0:315:7004:3e69 with SMTP id h25-20020a056e021d9900b0031570043e69mr7546079ila.13.1677088785210;
        Wed, 22 Feb 2023 09:59:45 -0800 (PST)
X-Google-Smtp-Source: AK7set9r6tRu/CNtnXOiqXnQw+dpxBgVCCJ4i5wUmXP6rZKqJ2tGI7YJQa71XArwlBX37VPRQgaYlQ==
X-Received: by 2002:a05:6e02:1d99:b0:315:7004:3e69 with SMTP id h25-20020a056e021d9900b0031570043e69mr7546058ila.13.1677088784970;
        Wed, 22 Feb 2023 09:59:44 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m5-20020a924b05000000b00316ecc80a61sm622829ilg.11.2023.02.22.09.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 09:59:44 -0800 (PST)
Date:   Wed, 22 Feb 2023 10:59:42 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: Fix NULL pointer dereference caused by
 uninitialized group->iommufd
Message-ID: <20230222105942.27ead3de.alex.williamson@redhat.com>
In-Reply-To: <20230222074938.13681-1-yan.y.zhao@intel.com>
References: <20230222074938.13681-1-yan.y.zhao@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 Feb 2023 15:49:38 +0800
Yan Zhao <yan.y.zhao@intel.com> wrote:

> group->iommufd is not initialized for the iommufd_ctx_put()
> 
> [20018.331541] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [20018.377508] RIP: 0010:iommufd_ctx_put+0x5/0x10 [iommufd]
> ...
> [20018.476483] Call Trace:
> [20018.479214]  <TASK>
> [20018.481555]  vfio_group_fops_unl_ioctl+0x506/0x690 [vfio]
> [20018.487586]  __x64_sys_ioctl+0x6a/0xb0
> [20018.491773]  ? trace_hardirqs_on+0xc5/0xe0
> [20018.496347]  do_syscall_64+0x67/0x90
> [20018.500340]  entry_SYSCALL_64_after_hwframe+0x4b/0xb5
> 
> Fixes: 9eefba8002c2 ("vfio: Move vfio group specific code into group.c")
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  drivers/vfio/group.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 57ebe5e1a7e6..8649f85f3be4 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -137,7 +137,7 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
>  
>  		ret = iommufd_vfio_compat_ioas_id(iommufd, &ioas_id);
>  		if (ret) {
> -			iommufd_ctx_put(group->iommufd);
> +			iommufd_ctx_put(iommufd);
>  			goto out_unlock;
>  		}
>  

Applied to vfio next branch for v6.3 and added a stable cc.  Thanks,

Alex

