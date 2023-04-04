Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E56E6D649C
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 16:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235418AbjDDOFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 10:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235936AbjDDOFQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 10:05:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6D74EDA
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 07:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680617002;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ykhmPw67VbhDtXPSpfVmWbPSuu2IMuu2dxGXXWfzz7E=;
        b=Fw2zO58FlaxAwAVPadP3pKaZKrCzlMZVi2xjH5Z4jz1Tekd4eWHKoa/ZRgpx9PJ1kra90U
        S3iw8dd+buOY9/yZQdulaq/NG2C9pvJqjyptOpRT1rRBb3h1VKHHCASNRLdvKSsexAzE/h
        uoVvELUClyCyDMHFhpFLbR4mVEXxvxs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-T9AnclZsObqlTjYa4rpn6A-1; Tue, 04 Apr 2023 10:00:06 -0400
X-MC-Unique: T9AnclZsObqlTjYa4rpn6A-1
Received: by mail-qk1-f199.google.com with SMTP id b142-20020ae9eb94000000b007486a8b9ae9so12098086qkg.11
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 07:00:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680616802;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ykhmPw67VbhDtXPSpfVmWbPSuu2IMuu2dxGXXWfzz7E=;
        b=4oFS6GPWTvZAzkBOSCxEAzr6Cz9yp0g6VxUPLaCLQyQzqnuWm9tn9rqoKc6ZJL93dH
         Yx6rbTZrlje9Z4IJuAbaTxCNRdN3C8M/wEhg/6vdhBriZ4ytYvBiRuawn9OEv9+MhnS8
         raiIY2I3Me0N+BWsNxua6kiJCeDoeD3+GLrOERuoBu6Y7sQo+K9U9XO3vIFQj+ujNvMO
         hGJZPIgLJH5g7jv4sear1FspEWFtXderQgBAZnSCHo9wBhmG0tv+Syar5xfcqefCSWmc
         4yj6jLLL8aLIf8TtMrpolzapK/zI/ixHibYlBBwqHOkLQIYTVDspC61Ki55W/92UE+P7
         o4Mw==
X-Gm-Message-State: AAQBX9dP3trWQeNtI2c2OUe4RzqQ/mtlbMrn3sGN+RqJ4xwiCt8I1f/w
        2qHG+kQ0tVW/EkS8c6MNhxRKfpNUDgN1ditySK3hkXmhJIDe4H1loQYtaF9DsJOGjnXiWY8ktUb
        c+dCTy2+gE7lz
X-Received: by 2002:ad4:5b87:0:b0:5e2:1381:6105 with SMTP id 7-20020ad45b87000000b005e213816105mr3459185qvp.18.1680616802054;
        Tue, 04 Apr 2023 07:00:02 -0700 (PDT)
X-Google-Smtp-Source: AKy350bJCynXCOrEKhxb44G8d+k4Dr+19c9yImUsR/GZAakKp2zi913dOKWU2dCtLWnBy7YVL0UkpQ==
X-Received: by 2002:ad4:5b87:0:b0:5e2:1381:6105 with SMTP id 7-20020ad45b87000000b005e213816105mr3459060qvp.18.1680616801354;
        Tue, 04 Apr 2023 07:00:01 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id jy1-20020a0562142b4100b005dd8b9345ebsm3412112qvb.131.2023.04.04.06.59.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 07:00:00 -0700 (PDT)
Message-ID: <1f8ddafd-6fad-aff6-5dc7-9d67f89eea73@redhat.com>
Date:   Tue, 4 Apr 2023 15:59:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 01/12] vfio/pci: Update comment around group_fd get in
 vfio_pci_ioctl_pci_hot_reset()
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-2-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230401144429.88673-2-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 4/1/23 16:44, Yi Liu wrote:
> this suits more on what the code does.
>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index a5ab416cf476..65bbef562268 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1308,9 +1308,8 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
>  	}
>  
>  	/*
> -	 * For each group_fd, get the group through the vfio external user
> -	 * interface and store the group and iommu ID.  This ensures the group
> -	 * is held across the reset.
> +	 * Get the group file for each fd to ensure the group held across
to ensure the group is held

Besides

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric


> +	 * the reset
>  	 */
>  	for (file_idx = 0; file_idx < hdr.count; file_idx++) {
>  		struct file *file = fget(group_fds[file_idx]);

