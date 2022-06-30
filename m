Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17E0E562391
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 21:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236974AbiF3Twp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 15:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236931AbiF3Twm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 15:52:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A66E344753
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 12:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656618760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oijUa/doj+rHJYQ7agDv94IkOqnu9hT+3btxZ5EWLOU=;
        b=X1x9zNq9NJVJR0pR64Lz79I6Y9xWPLiZTUOWqbNozP2BQdpASBx7OBxj/yI0xBWKQUHfmE
        QibetILkvmV0owCd7BOX1akQxLEisGd2hzfuYvXGyvwa6undMWlJkXJ7O64/Un63FeE7ty
        BdV8J5Vk6BnOc8gmehYfwiBI/F3TqjM=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-330-v4FvfVgqNCO5F2-pk4Fdwg-1; Thu, 30 Jun 2022 15:52:39 -0400
X-MC-Unique: v4FvfVgqNCO5F2-pk4Fdwg-1
Received: by mail-io1-f69.google.com with SMTP id o11-20020a6bcf0b000000b0067328c4275bso106064ioa.8
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 12:52:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=oijUa/doj+rHJYQ7agDv94IkOqnu9hT+3btxZ5EWLOU=;
        b=wSZsWjdBPtH7WM6n2X5KmroapwoeCN2Nu+Sa5EuYdbI9EqDiPKo/seEW/WgYfajZvx
         nPhlUz8hYLJx/IVyVvGkNnn2zlLhYh7EtRaygj8iRKdwAVD5nwaJVMAjAp/yg3mI7e88
         0R0UEn9MQrrqliQJZDVZlwO2CWqhB/KTKzsPabrJ8usYnvIa3fj/j4KuDxxQQ7jSn9jM
         uHZG8vALh/6KGwvrw0kjMM3+5TK572taaeX43DCB/UtLB/Ma6c6Q0oQnA12TOXk2mdqj
         wz8zB79zi1NzA4KpdOeaSMt2Sydg8uyp8mQFxtxiwnaI/QKy3KwYagL2L6T29aaFrFgN
         oJ8Q==
X-Gm-Message-State: AJIora/xzgQi3HtwVNbEZRfJdTLhp2Bisf56AQdKujhBCWw0eaf3khGG
        snFLWQS7/FZYqZ4tvx7jkSLh0+iKuNW7YTj9bOPUuxrCVG2gAcq/dlG0rAWzNRuuD6NCbBIwfam
        +k3SXR4hvSq9/
X-Received: by 2002:a05:6638:460e:b0:33b:12ee:21dd with SMTP id bw14-20020a056638460e00b0033b12ee21ddmr6682160jab.78.1656618758657;
        Thu, 30 Jun 2022 12:52:38 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s040rInVr/4GAKeW9JmeAzlx2T2zBRDB/znZYCLldJKIifBMCRPFbn28+EC9Wj1gm43q4KOA==
X-Received: by 2002:a05:6638:460e:b0:33b:12ee:21dd with SMTP id bw14-20020a056638460e00b0033b12ee21ddmr6682145jab.78.1656618758457;
        Thu, 30 Jun 2022 12:52:38 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x42-20020a0294ad000000b00330c5581c03sm8880286jah.1.2022.06.30.12.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 12:52:37 -0700 (PDT)
Date:   Thu, 30 Jun 2022 13:51:42 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <kvm@vger.kernel.org>, <maorg@nvidia.com>,
        <cohuck@redhat.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>
Subject: Re: [PATCH V3 vfio 0/2] Migration few enhancements
Message-ID: <20220630135142.1f90a3ee.alex.williamson@redhat.com>
In-Reply-To: <20220628155910.171454-1-yishaih@nvidia.com>
References: <20220628155910.171454-1-yishaih@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Jun 2022 18:59:08 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> This series includes few enhancements in the migration area and some
> fixes in mlx5 driver as of below.
> 
> It splits migration ops from the main device ops, this enables a driver
> to safely set its migration's ops only when migration is supported and
> leave the other code around (e.g., core, driver) clean.
> 
> Registering different structs based on the device capabilities might
> start to hit combinatorial explosion when we'll introduce ops for dirty
> logging that may be optional too.
> 
> As part of that, adapt mlx5 to this scheme and fix some issues around
> its migration capable usage.
> 
> V3:
> - Fix a typo in vfio_pci_core_register_device(), to check for both set & get 'mig_ops'.
> 
> V2: https://lore.kernel.org/all/20220616170118.497620ba.alex.williamson@redhat.com/T/
> - Validate ops construction and migration mandatory flags on
>   registration as was asked by Kevin and Jason.
> - As of the above move to use a single 'mig_ops' check in vfio before
>   calling the driver.
> 
> V1: https://lore.kernel.org/all/20220626083958.54175-1-yishaih@nvidia.com/
> - Add a comment about the required usage of 'mig_ops' as was suggested
>   by Alex.
> - Add Kevin's Reviewed-by tag.
> 
> V0:
> https://lore.kernel.org/all/20220616170118.497620ba.alex.williamson@redhat.com/T/
> 
> Yishai
> Yishai Hadas (2):
>   vfio/mlx5: Protect mlx5vf_disable_fds() upon close device
>   vfio: Split migration ops from main device ops
> 
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 11 +++++--
>  drivers/vfio/pci/mlx5/cmd.c                   | 14 ++++++++-
>  drivers/vfio/pci/mlx5/cmd.h                   |  4 ++-
>  drivers/vfio/pci/mlx5/main.c                  | 11 ++++---
>  drivers/vfio/pci/vfio_pci_core.c              |  7 +++++
>  drivers/vfio/vfio.c                           | 11 ++++---
>  include/linux/vfio.h                          | 30 ++++++++++++-------
>  7 files changed, 63 insertions(+), 25 deletions(-)
> 

I see these are included in your new longer series, where the only
change was my suggested removal of parentheses, so I went ahead and
merged this to my next branch for v5.20 and we can drop them from the
other series.  Thanks,

Alex

