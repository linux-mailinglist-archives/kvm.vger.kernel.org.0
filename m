Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4FD780EEA
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 17:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378082AbjHRPR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 11:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378080AbjHRPR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 11:17:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B5626BB
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 08:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692371830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ymeDjtpK/Bfq1NJqz0HPCsZOdauO6COV4txWMHbTX2Q=;
        b=bL7dlJTtvcUQ+wWJlJTYwoVxPaYJRqkejvwMTg3znGrTLbP3N+hyu0tgR1ZhvAd6G5EPl4
        95c/fduYYFC16HHwqjWSehwfdsH3CQmLLC5I8laENuD3oxppOsf/AoP55g3y/RfVJ/C2i5
        dSjwpklgpy5ivHEIsl+oxSkcgq2g5G0=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-VqAIJ6PtPcqOaju8xyx_Lg-1; Fri, 18 Aug 2023 11:17:08 -0400
X-MC-Unique: VqAIJ6PtPcqOaju8xyx_Lg-1
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-6bb1755ee51so1746479a34.1
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 08:17:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692371828; x=1692976628;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ymeDjtpK/Bfq1NJqz0HPCsZOdauO6COV4txWMHbTX2Q=;
        b=gN69UDOOkwzYUUHl7XbjUjvRyFZ/qj7YCfY9fjnHWoocoWdRY7jda5XOt/kxNh4/j8
         WTELLOw4a5l2oI0zOEXl65zucHUr4obOw1LDQov8RfkX7AiNh40h9ldwIDfZI5hJwye1
         KRIK9m0Y13ujA8zq1qw2H9sNQtyG+iYjiXLxd+xduQcYqceuOXSbDUqJtE34rCILQ7BB
         AJLWjx59FFoEz4dbGBJepdnXZRaO1yuj+4VcaTrJZp2BE6yuaWGBY3/PZWqr/R5IrkB4
         dmDqL+ryeMlK+WOVef9Qk8Qt+jJPKv/rSBqkENvmn+/bb++Kvs1xgp3jTnf4/UEn/d6P
         O3fA==
X-Gm-Message-State: AOJu0YwojGb5fFKhNuJmYR7w/nIfWgPzDg/XlttWFQRMuQ2hKD7DC/yc
        7lQfeZyNqqbhKxjpvPvPiClaB/JAna/qUS2XbohnyDFwv4Avl0GM0BOJr49ummWLlOGuyjB7EcG
        tX8e3XsiXooW3
X-Received: by 2002:a05:6870:e814:b0:1bd:f37b:5e96 with SMTP id o20-20020a056870e81400b001bdf37b5e96mr1668438oan.23.1692371827979;
        Fri, 18 Aug 2023 08:17:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHay8XbyAQAbwd7G2dOy0MUw3oqeL5Wga6U21sC/U0kglgrRNHjCZgSg57WrRpg7pGwu0Gv8Q==
X-Received: by 2002:a05:6870:e814:b0:1bd:f37b:5e96 with SMTP id o20-20020a056870e81400b001bdf37b5e96mr1668426oan.23.1692371827740;
        Fri, 18 Aug 2023 08:17:07 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id n4-20020a056870a44400b001c4b8a9ef88sm1109415oal.24.2023.08.18.08.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 08:17:07 -0700 (PDT)
Date:   Fri, 18 Aug 2023 09:17:05 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <jgg@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <shannon.nelson@amd.com>
Subject: Re: [PATCH vfio] pds_core: Fix function header descriptions
Message-ID: <20230818091705.7e4d7d0e.alex.williamson@redhat.com>
In-Reply-To: <20230817224212.14266-1-brett.creeley@amd.com>
References: <20230817224212.14266-1-brett.creeley@amd.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Aug 2023 15:42:12 -0700
Brett Creeley <brett.creeley@amd.com> wrote:

> The pds-vfio-pci series made a small interface change to
> pds_client_register() and pds_client_unregister(), but forgot to update
> the function header descriptions. Fix that.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202308180411.OSqJPtMz-lkp@intel.com/
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>

I think we also want:

Fixes: b021d05e106e ("pds_core: Require callers of register/unregister to pass PF drvdata")

I'll add that on commit.  Thanks,

Alex

> ---
>  drivers/net/ethernet/amd/pds_core/auxbus.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
> index 63d28c0a7e08..4ebc8ad87b41 100644
> --- a/drivers/net/ethernet/amd/pds_core/auxbus.c
> +++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
> @@ -8,7 +8,7 @@
>  
>  /**
>   * pds_client_register - Link the client to the firmware
> - * @pf_pdev:	ptr to the PF driver struct
> + * @pf:		ptr to the PF driver's private data struct
>   * @devname:	name that includes service into, e.g. pds_core.vDPA
>   *
>   * Return: 0 on success, or
> @@ -48,7 +48,7 @@ EXPORT_SYMBOL_GPL(pds_client_register);
>  
>  /**
>   * pds_client_unregister - Unlink the client from the firmware
> - * @pf_pdev:	ptr to the PF driver struct
> + * @pf:		ptr to the PF driver's private data struct
>   * @client_id:	id returned from pds_client_register()
>   *
>   * Return: 0 on success, or

