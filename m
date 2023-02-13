Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A673A6954B0
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 00:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjBMXWn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 18:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBMXWm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 18:22:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7441EFE8
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 15:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676330515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PalnaCa+45zmfRne4PsaOrNHcKeNAHWEUJgujCCpms4=;
        b=fpLnoggxeCuQBlyblQwikOyp1o5A44uqB9/54QFsyVZ9X4FAhXvenzrkz9uQlssUYdAqPR
        fCd2gKHslv1bT9jeTEH0L2azbzfCdoNnQLGB0f+aNtNMvuuDFI7jxfqHAgNEmFxR2qOiFt
        KW5sAIFUoOBlTJj3mqV8lPnK/FxeDZM=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-49-onmpBVYHPc-N8xX8KgMn4A-1; Mon, 13 Feb 2023 18:21:54 -0500
X-MC-Unique: onmpBVYHPc-N8xX8KgMn4A-1
Received: by mail-io1-f71.google.com with SMTP id g6-20020a6b7606000000b007297c4996c7so9295027iom.13
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 15:21:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PalnaCa+45zmfRne4PsaOrNHcKeNAHWEUJgujCCpms4=;
        b=qjDrKTdTl6Lh0UHCgUsHB/cCa2NnR4Pso8v9ryEEf7unQ2O3kHsDVzbv0pJX+4Efc6
         8oW2ivGK5nXgutwE/YMHN2nuuUw3eDohj9xX0DfNPtCqcv9xHogIuqpYXWPjX3OZrbpL
         5e73icxAlphhNbd2nuFv8QpyLBCvy+ZxaiNQfhoGELSkdJN55sv9bBJAQWAJeujrw/Dt
         DQY1Z6+LDb78RlVvIMo6spy/u4whZD16MAFk2vSR2ABx0Mz/IW8RB6vAcjltbmeEYKiT
         wlKWww0RhYhyk47l/mdpstto6PMzNgAZu0+FW6TPIYIMPldZ5JMGYLboii0/kwjjiPnP
         F5IQ==
X-Gm-Message-State: AO0yUKWE1Q6xJ0/xJqAultrZzA1ulRCBrLhhrbA37cZDCiW8B6Zr19D5
        WVI8SBce32nugyvQG7NCFPP6ASV65vTF9AXUw/GtkLT5ZyyArF4RuwUSU7PjqN6ho0XjTEqR3Kz
        w/6Mm9Y161oXc
X-Received: by 2002:a05:6602:424e:b0:707:85b3:5dbb with SMTP id cc14-20020a056602424e00b0070785b35dbbmr247724iob.6.1676330513399;
        Mon, 13 Feb 2023 15:21:53 -0800 (PST)
X-Google-Smtp-Source: AK7set9iQtjrUB3qKlMbOa//wqF8gVTJyU2h1pAAMQbJhVobtNII43EJPHV4Swgm5qp296ZsP/lafg==
X-Received: by 2002:a05:6602:424e:b0:707:85b3:5dbb with SMTP id cc14-20020a056602424e00b0070785b35dbbmr247701iob.6.1676330513164;
        Mon, 13 Feb 2023 15:21:53 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id t66-20020a6bc345000000b00704878474c7sm4626794iof.53.2023.02.13.15.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 15:21:52 -0800 (PST)
Date:   Mon, 13 Feb 2023 16:21:50 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     joro@8bytes.org, jgg@nvidia.com, kevin.tian@intel.com,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 03/15] vfio: Accept vfio device file in the driver
 facing kAPI
Message-ID: <20230213162150.7626055b.alex.williamson@redhat.com>
In-Reply-To: <20230213151348.56451-4-yi.l.liu@intel.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
        <20230213151348.56451-4-yi.l.liu@intel.com>
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

On Mon, 13 Feb 2023 07:13:36 -0800
Yi Liu <yi.l.liu@intel.com> wrote:

> This makes the vfio file kAPIs to accepte vfio device files, also a
> preparation for vfio device cdev support.
> 
> For the kvm set with vfio device file, kvm pointer is stored in struct
> vfio_device_file, and use kvm_ref_lock to protect kvm set and kvm
> pointer usage within VFIO. This kvm pointer will be set to vfio_device
> after device file is bound to iommufd in the cdev path.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  drivers/vfio/vfio.h      |  2 ++
>  drivers/vfio/vfio_main.c | 51 ++++++++++++++++++++++++++++++++++++----
>  2 files changed, 49 insertions(+), 4 deletions(-)

This subtly changes the behavior of the vfio-pci hot reset functions
without updating the uAPI description or implementation to use less
group-centric variables.  The new behavior appears to be that cdev fds
can also be passed to prove ownership of the affected set of devices
for a hot reset, but this probably needs to be examined for gaps.
Thanks,

Alex

