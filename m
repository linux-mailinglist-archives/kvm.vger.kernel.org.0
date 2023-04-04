Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F35E46D6E96
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 23:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbjDDVCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 17:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235377AbjDDVCG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 17:02:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A8C4EEA
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 14:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680642038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eUlNSkHN+zXMVEgYFwpXLf7eXmZqDjBFuuY+21ymQM8=;
        b=QNXRjxDDVb8WnLfJzpLtcHe9kDPw8/ELQwrFT5e3ilaHTMscvOlkSVw16gcyCI8S21TKrI
        VeWxOX6cqsZOanftzA2xJ2EmhmzbmMm6FAR7SyGNYw4G5ihuzN/W2ez1GUPJTeKTeORA6m
        pRFfIRWDw4HXINHMPHQALeuWUShDVDY=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370--ap5jZJrMzSr9IzD4vDLtw-1; Tue, 04 Apr 2023 17:00:37 -0400
X-MC-Unique: -ap5jZJrMzSr9IzD4vDLtw-1
Received: by mail-il1-f197.google.com with SMTP id d11-20020a056e020c0b00b00326156e3a8bso16562075ile.3
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 14:00:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680642036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eUlNSkHN+zXMVEgYFwpXLf7eXmZqDjBFuuY+21ymQM8=;
        b=t+V7zoi25zK7pC6CHR1A6AMclUG2njSW6Be+7bDt74B8n3ZOTiit9jNM3K6Wd5WrrI
         L6SszeqzRWmYkOQyq1drPiRoUX+qAxwYartyUjDNqpK01C/MnfYsVl9E7WUZHzCh84zi
         fS6PhAu/QFHENthhxv0PDXVrEWvlWPoDSM64QpF3P9988wR1cOk2Ae0jyffxXQSX0oyI
         45yU5vfbOioERQdoBXfkefJnmgcdeh82cP1RPeeuwPKzyMEgo3/P3GXDCdC0pZ30our5
         L7ZM0sdW6ZRjcKOoqfO1YwY0VWO2uckAQ3CLZxWfjd3oomVZvEqJWl4j1H4f5g/owVvu
         8B3g==
X-Gm-Message-State: AAQBX9fTiWU5ddaP7D0uCq6X6tZyEtwYzIClWQ64Kwjs5PpLClwAEjm6
        zX31m82xJYEtLrg/NA2QWa2Uhc1yfmSQDSckDhNWzvn+XTbMWw9EQ4IPM6f6H7ibmD46T+FaO9P
        cX51IFFG/mded
X-Received: by 2002:a05:6602:2e05:b0:759:410c:99b6 with SMTP id o5-20020a0566022e0500b00759410c99b6mr565934iow.2.1680642036466;
        Tue, 04 Apr 2023 14:00:36 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZBxWm4a3+LGUk3NVVLqCociOCxX0vWRo5d6ZJ4vSC6uL/zuJZ3VkObdr8SZMcgBOlbc8NPLw==
X-Received: by 2002:a05:6602:2e05:b0:759:410c:99b6 with SMTP id o5-20020a0566022e0500b00759410c99b6mr565895iow.2.1680642036246;
        Tue, 04 Apr 2023 14:00:36 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m41-20020a026d29000000b003c4d71489aasm3548333jac.6.2023.04.04.14.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 14:00:35 -0700 (PDT)
Date:   Tue, 4 Apr 2023 15:00:34 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: Re: [PATCH v3 11/12] iommufd: Define IOMMUFD_INVALID_ID in uapi
Message-ID: <20230404150034.312fbcac.alex.williamson@redhat.com>
In-Reply-To: <20230401144429.88673-12-yi.l.liu@intel.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-12-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat,  1 Apr 2023 07:44:28 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> as there are IOMMUFD users that want to know check if an ID generated
> by IOMMUFD is valid or not. e.g. vfio-pci optionaly returns invalid
> dev_id to user in the VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl. User
> needs to check if the ID is valid or not.
> 
> IOMMUFD_INVALID_ID is defined as 0 since the IDs generated by IOMMUFD
> starts from 0.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  include/uapi/linux/iommufd.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index 98ebba80cfa1..aeae73a93833 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -9,6 +9,9 @@
>  
>  #define IOMMUFD_TYPE (';')
>  
> +/* IDs allocated by IOMMUFD starts from 0 */
> +#define IOMMUFD_INVALID_ID 0
> +
>  /**
>   * DOC: General ioctl format
>   *

If allocation "starts from 0" then 0 is a valid id, no?  Does allocation
start from 1, ie. skip 0?  Thanks,

Alex

