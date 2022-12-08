Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2E66478B4
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 23:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiLHWQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 17:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiLHWQn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 17:16:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EA313D38
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 14:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670537748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FFucKqZ5g4RYQZgbVFZF1v5fxQZ2+gEQUrOtWvEcYuA=;
        b=SmFGnAW3FEMbX18jPm4j2wn7xk0DlXq59JY6CS5if7KLUUHw4HyHDs/TZWFomTvppw/QVP
        z4ZXsNbgNMnKopL3EoOV/BzoACwJLdTy/nsWyvPrDxH+aChPdeUdvYy9fJCZZcDr57MOPw
        E81bb+JuGDnGP0oaRL6yrlvLPBQ4+Rg=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-377-7bijfKxuOr6KksRDRPO1Vg-1; Thu, 08 Dec 2022 17:15:47 -0500
X-MC-Unique: 7bijfKxuOr6KksRDRPO1Vg-1
Received: by mail-il1-f198.google.com with SMTP id o10-20020a056e02102a00b003006328df7bso2472554ilj.17
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 14:15:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FFucKqZ5g4RYQZgbVFZF1v5fxQZ2+gEQUrOtWvEcYuA=;
        b=8MpO2xNdiMwVmrSIG8kIyVYEOjdIw0Ca3z6zRp3+ClKszOsi8DxYif8pi7Cti32C/D
         rBcQnNnbupZDLGDNJNp8oIe2L/fsWIDVi4fCulGmzYuyGEWqLaYKq8+n4/MGAXK8lHXh
         2453np6VfVDenr3HIJmKbY8KaxnaJOLoywu/dWrf17Yy9B4iqkRma9WNj75OHT4JJ0rj
         hsTGTneTvQs8fMsfhW0SVaMZeri9n795X9XloHs57LBu+8ps30KHpP3XyUxMtNofGy2s
         UK2Ut+W2bnqK0lqhmFNrm+VDGO3Teg99sVrzE0lgw0Hg4LouYc7suXw7XQprKBGZdBaM
         MTMQ==
X-Gm-Message-State: ANoB5pmTmiJjd5Ff0kj/UvzOBCTiJsbEXHGb5bm/NSZddgWbGPWvu8Ws
        v6r6DvcUs11Mc0x9kL6avZ1rz4q2So3GzAh+2mFNNPUVJbSP1w2jk2h6u+u/1H0F/KHVaRp+gnv
        hGEMD33Pakz6v
X-Received: by 2002:a05:6e02:542:b0:303:7c99:eb78 with SMTP id i2-20020a056e02054200b003037c99eb78mr4210626ils.88.1670537746664;
        Thu, 08 Dec 2022 14:15:46 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7fGLYEQgxoER97yecG8lw8y51v2EHG1rR/2NisBDARU6wasAHEg9IAkNOG+qXw7WJABOfSuQ==
X-Received: by 2002:a05:6e02:542:b0:303:7c99:eb78 with SMTP id i2-20020a056e02054200b003037c99eb78mr4210621ils.88.1670537746464;
        Thu, 08 Dec 2022 14:15:46 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id y10-20020a056638228a00b00363781b6bccsm1686691jas.49.2022.12.08.14.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 14:15:45 -0800 (PST)
Date:   Thu, 8 Dec 2022 15:15:44 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Dan Carpenter <error27@gmail.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Shay Drory <shayd@nvidia.com>, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] vfio/mlx5: fix error code in mlx5vf_precopy_ioctl()
Message-ID: <20221208151544.488c575d.alex.williamson@redhat.com>
In-Reply-To: <Y5IKVknlf5Z5NPtU@kili>
References: <Y5IKVknlf5Z5NPtU@kili>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
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

On Thu, 8 Dec 2022 19:01:26 +0300
Dan Carpenter <error27@gmail.com> wrote:

> The copy_to_user() function returns the number of bytes remaining to
> be copied but we want to return a negative error code here.
> 
> Fixes: 0dce165b1adf ("vfio/mlx5: Introduce vfio precopy ioctl implementation")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
>  drivers/vfio/pci/mlx5/main.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Applied both to vfio next branch for v6.2.  Thanks,

Alex

