Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92E0644E33
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 22:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiLFVu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 16:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiLFVu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 16:50:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107693E0A7
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 13:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670363373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VwYFbIK5NKjIGJlsebUpW1BNz/gE9WfBBNHuPbBwQ6k=;
        b=gx65zH/0FAxJmxMuRFe1qt2/vkZinnRimZBAryLOErvm1g5TFG91tfxX+rQeISjdyGIbJS
        pGuYDsPMJeK5JJO5IQST1DbIFIdBCjcPrlO65JwAfj6VIS1yJgtrb+RgfbyHV0IiFGqX7O
        GpUtSLlG5tbE/9JOPkMY5Dhzn8jox2I=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-295-nN3LxSXwM4u5xdMWlcxMaw-1; Tue, 06 Dec 2022 16:49:32 -0500
X-MC-Unique: nN3LxSXwM4u5xdMWlcxMaw-1
Received: by mail-il1-f199.google.com with SMTP id h9-20020a92c269000000b00303494c4f3eso9362241ild.15
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 13:49:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VwYFbIK5NKjIGJlsebUpW1BNz/gE9WfBBNHuPbBwQ6k=;
        b=5yzINJrBM9qhf48wF89+yFISqb8XpPePeh/XNz3EBCfFOsMwgOe7bvtdjIvVd79Un5
         zynMxprojgnGPkHqH+eIoJohOGuk0xxxC9aV8DdHQIbjAichyU9UWzvdTAF7+ne6xTq8
         zKNvtp3sNQQ4X25Fw9ft2fkfSkyxXPjNz19YUY2BH4vXAbty864KGEAoIy8LfHTTooUN
         bC58sbI14TvF0SfCWwNek3up9OQ7K3jx7oqaZVnpmKYXLA4zQeUCwAX559PMoIycjyN4
         UvzQzBPWLG4lrI7WBD/xLoQr8o5NAXpgNeZ6rc1EQtpwRZeFNWislD2kAi00JJLoBI1u
         4y3w==
X-Gm-Message-State: ANoB5plE3Pro2AvQjmYomGU3UbHJO0CicHw/QHtQIIcl6DP8GazcL2Te
        Qp5ne9LOpuGwF+yZbdi38jO0udp6q3/YTShpUABsPvvBUhhEwi2U9ahIl4pvqlkPOtJOLBLfxRx
        IZ9OLIuUafY3Q
X-Received: by 2002:a92:c5c5:0:b0:303:1215:ea9d with SMTP id s5-20020a92c5c5000000b003031215ea9dmr19977702ilt.242.1670363371619;
        Tue, 06 Dec 2022 13:49:31 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6tA7RQJR+ofc16ntTth306NDR5i5Y03jmd2VcQK2IK1dSlgBuGViAhP18SEJ9lDTj3EoQNFw==
X-Received: by 2002:a92:c5c5:0:b0:303:1215:ea9d with SMTP id s5-20020a92c5c5000000b003031215ea9dmr19977694ilt.242.1670363371419;
        Tue, 06 Dec 2022 13:49:31 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r6-20020a92c506000000b002fc323a2902sm6478816ilg.62.2022.12.06.13.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 13:49:30 -0800 (PST)
Date:   Tue, 6 Dec 2022 14:49:29 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>, <kevin.tian@intel.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>
Subject: Re: [PATCH 0/4] hisi_acc_vfio_pci: Add PRE_COPY migration feature
 support
Message-ID: <20221206144929.17c64235.alex.williamson@redhat.com>
In-Reply-To: <20221123113236.896-1-shameerali.kolothum.thodi@huawei.com>
References: <20221123113236.896-1-shameerali.kolothum.thodi@huawei.com>
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

On Wed, 23 Nov 2022 11:32:32 +0000
Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> Hi,
> 
> The optional PRE_COPY state support for migration feature is introduced
> by this series here[1](Thanks for that!). This is something HiSilicon
> ACC driver can make use for early dev compatibility checks and have
> made an attempt in the past here[2].
> 
> Adding this will speed up reporting the compatibility error early in
> the migration process without the need to wait for complete data
> transfer. This is sanity tested on a HiSilicon Platform.
> 
> Please take a look.
> 
> Regards,
> Shameer
> 
> 1.https://lore.kernel.org/all/20221106174630.25909-1-yishaih@nvidia.com/
> 2.https://lore.kernel.org/kvm/20220302172903.1995-8-shameerali.kolothum.thodi@huawei.com/
> 
> Shameer Kolothum (4):
>   hisi_acc_vfio_pci: Add support for precopy IOCTL
>   hisi_acc_vfio_pci: Introduce support for PRE_COPY state transitions
>   hisi_acc_vfio_pci: Move the dev compatibility tests for early check
>   hisi_acc_vfio_pci: Enable PRE_COPY flag
> 
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 147 ++++++++++++++++--
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   2 +
>  2 files changed, 133 insertions(+), 16 deletions(-)

Applied to vfio next branch for v6.2.  Thanks,

Alex 

