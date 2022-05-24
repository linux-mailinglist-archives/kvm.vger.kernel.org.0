Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD04C532E9C
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 18:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239647AbiEXQIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 12:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239703AbiEXQH4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 12:07:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C1266FA05
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 09:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653408467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G+RcAgw+M1XilmXCEZhEnhgsR1psBADO/HJ5IfgJuHA=;
        b=Rm0DgeynggqpNQZ4TYLNmT5ts5xjhQN2j6WVKU8tkBEOHZ9giihnMi3PCy8NfEbiCCH7De
        aHRzsh1xelt6B6hO3qYh+4wMsmszjwoTn29V2nHOSe2c7tNX45eWIcfk0P3eZXIs6BxrGG
        pcxvZO5+RZcjtu1kRUfB2SJoYKNS26w=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-t2qeDRN6OduReYe0ImMdqw-1; Tue, 24 May 2022 12:07:45 -0400
X-MC-Unique: t2qeDRN6OduReYe0ImMdqw-1
Received: by mail-il1-f197.google.com with SMTP id i15-20020a056e0212cf00b002cf3463ed24so11081653ilm.0
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 09:07:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=G+RcAgw+M1XilmXCEZhEnhgsR1psBADO/HJ5IfgJuHA=;
        b=DY9TZFTfKKtZOcYDyt00d0vdViCXXCYpidJVJFytUqskzh3XB2gTTVFT9ZjBDre35V
         +fdfOGTmiR0qGsBnQe1fzSvzw1T9eoulFnXYuklTAZ6BNJctuFaCa+FZ5zZL4SqQAtOl
         ngGkuEs9w7ak+I7s074Niu6CnkpQex4E5w9UmIWkUrnhUOGl1NgSQ+TWQobXoSjpsTiH
         C3FIjhBodvGneckMV8WY/ghlpEkFFq6V7lehWN+mdhe8nhhacBGLPtacvKYZ05U+WX22
         T48Pi4mD9FlpGlmHYz/MLPJYY36fkA9jz+i+jI+xG+KJJy/C1nIiXBVzpCSYZrSCFBg+
         T4MA==
X-Gm-Message-State: AOAM531nsbCaWS8pfGBL6yWdvXsK6RnETbgFv0ykHkHMKvL0R4z+xN6J
        qCtWgPbkOWSfSCjnjQ5ud8DshZfkI0ds/5Q8wHaL6NR/OXp8iGptn24laKZ5Rqjf8P7J7bYHSgn
        r3n6mX/KRujnC
X-Received: by 2002:a5e:d704:0:b0:65e:4b39:242c with SMTP id v4-20020a5ed704000000b0065e4b39242cmr11264291iom.85.1653408464196;
        Tue, 24 May 2022 09:07:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwn1olivekEis0tlSW3xwvPefHBQqsJ7pzuBi+at+rc+iPoH+PcU7B3Mcqjs0dWyasmICt5Tw==
X-Received: by 2002:a5e:d704:0:b0:65e:4b39:242c with SMTP id v4-20020a5ed704000000b0065e4b39242cmr11264275iom.85.1653408464008;
        Tue, 24 May 2022 09:07:44 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u2-20020a02aa82000000b0032b5e4281d3sm3533889jai.62.2022.05.24.09.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 09:07:43 -0700 (PDT)
Date:   Tue, 24 May 2022 10:07:41 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH] vfio/pci: Add driver_managed_dma to the new vfio_pci
 drivers
Message-ID: <20220524100741.7fdd5ba1.alex.williamson@redhat.com>
In-Reply-To: <0-v1-f9dfa642fab0+2b3-vfio_managed_dma_jgg@nvidia.com>
References: <0-v1-f9dfa642fab0+2b3-vfio_managed_dma_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 May 2022 20:14:01 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> When the iommu series adding driver_managed_dma was rebased it missed that
> new VFIO drivers were added and did not update them too.
> 
> Without this vfio will claim the groups are not viable.
> 
> Add driver_managed_dma to mlx5 and hisi.
> 
> Fixes: 70693f470848 ("vfio: Set DMA ownership for VFIO devices")
> Reported-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
>  drivers/vfio/pci/mlx5/main.c                   | 1 +
>  2 files changed, 2 insertions(+)

Applied to vfio next branch for v5.19.  Thanks,

Alex

