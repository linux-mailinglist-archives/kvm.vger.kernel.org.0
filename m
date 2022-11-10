Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8DD624B9D
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 21:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbiKJUSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 15:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbiKJUR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 15:17:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6042D4E420
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 12:17:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668111419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6jVthbHjsTliThw/p0W05BCO6UHI57XyGWMI/k60PAs=;
        b=Gz3GXv555USYV0Pz8YjgKCueQn5h9TS5QQuJBAw0laUwVGQ0sBrMXLxpRqLStU/79IMkkl
        SIgtodx5/TtH5Grdw34oDESkHj8Eh/G3h3PR1Gt8FyUbyoN8BWwBvm2Em/menS+yvk4qgu
        9+vPHB7TNzDEHALkJ4Hbih/GX7MVdEU=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-498-whhFlv0gM1-Q3SGs3K3NIQ-1; Thu, 10 Nov 2022 15:16:58 -0500
X-MC-Unique: whhFlv0gM1-Q3SGs3K3NIQ-1
Received: by mail-io1-f72.google.com with SMTP id f25-20020a5d8799000000b006a44e33ddb6so1800001ion.1
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 12:16:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6jVthbHjsTliThw/p0W05BCO6UHI57XyGWMI/k60PAs=;
        b=iBnoli4wgopjSGJb0VKs0bgwENfKFXSFp+4nohrT9pPYQhdLPEdtvVdvMV0I3FItTh
         dSBZX2IQEIXjKkWhdLewsgFUcvuH1RITwnNFM+FCQlzwoGNsw3lRU9S7xVWL5z6Q97UQ
         QBQzW8a/s97nj4nh0+lqSZNEWdC08gho5uxCmmvPprpZGhTQh/ziRtKutuK8k5h1ADPf
         TzRDQTE/RBCRjAMUUqP2zEio6+hGPEromHjXUvRN+w9ysKoV1sgP/R6CII49s7Z/sh0Z
         2gx+9qTZxQw2Gh6bUxnkiFG+eupjzn6MDSZqpG6bMyVitDdHDuC7pNl7X7Q8Lo8D7Qjp
         aU2A==
X-Gm-Message-State: ACrzQf206wq9D7y3sv+BjGJJMxn0OyHoKlJQMgIbDRqboDuRAXNM/dSv
        ZyASGD5XlhPvvyzGEXb9T4V8Q4nw6QVJUH5nVt1LaFvY4z7rT3zNGYD8pfgNs5C6H4F9D8sYZR4
        xa7d3/ziAazKK
X-Received: by 2002:a05:6638:4919:b0:375:4f73:2951 with SMTP id cx25-20020a056638491900b003754f732951mr3657949jab.176.1668111417630;
        Thu, 10 Nov 2022 12:16:57 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5BoAL/Rz3PAEVkeaRyE8GNyh17wSv8Mr+bQu1wUNvGeLEm23D7yAmh5J8mtuN74xZ7ywZn2A==
X-Received: by 2002:a05:6638:4919:b0:375:4f73:2951 with SMTP id cx25-20020a056638491900b003754f732951mr3657943jab.176.1668111417385;
        Thu, 10 Nov 2022 12:16:57 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i7-20020a0566022c8700b006bbea9f45cesm25981iow.38.2022.11.10.12.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 12:16:56 -0800 (PST)
Date:   Thu, 10 Nov 2022 13:16:28 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Anthony DeRossi <ajderossi@gmail.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, jgg@nvidia.com,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Subject: Re: [PATCH v6 0/3] vfio/pci: Check the device set open count on
 reset
Message-ID: <20221110131628.362df0b1.alex.williamson@redhat.com>
In-Reply-To: <20221110014027.28780-1-ajderossi@gmail.com>
References: <20221110014027.28780-1-ajderossi@gmail.com>
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

On Wed,  9 Nov 2022 17:40:24 -0800
Anthony DeRossi <ajderossi@gmail.com> wrote:

> This series fixes an issue where devices bound to vfio-pci are not reset when
> they are released. Skipping the reset has unpredictable results depending on
> the device, and can cause errors when accessing the device later or binding to
> a different driver.
> 
> The first patch in this series fixes a life cycle issue that was discovered in
> an earlier revision of the series.
> 
> Thank you Alex, Jason, and Kevin for your reviews and feedback. This revision
> includes the changes suggested on v5, but without any changes to
> vfio_device_set_open_count().
> 
> Anthony
> 
> v5 -> v6:
> - Added a call to lockdep_assert_held() in patch 3
> - Corrected "vfio_container_device_register()" in the patch 1 commit message
> v5: https://lore.kernel.org/kvm/20221105224458.8180-1-ajderossi@gmail.com/
> 
> v4 -> v5:
> - Replaced patch 2 with a patch that introduces a new function to get the
>   open count of a device set
> - Updated patch 3 to use the new function
> v4: https://lore.kernel.org/kvm/20221104195727.4629-1-ajderossi@gmail.com/
> 
> v3 -> v4:
> - Added a patch to fix device registration life cycle
> - Added a patch to add a public open_count on vfio_device_set
> - Changed the implementation to avoid private open_count usage
> v3: https://lore.kernel.org/kvm/20221102055732.2110-1-ajderossi@gmail.com/
> 
> v2 -> v3:
> - Added WARN_ON()
> - Revised commit message
> v2: https://lore.kernel.org/kvm/20221026194245.1769-1-ajderossi@gmail.com/
> 
> v1 -> v2:
> - Changed reset behavior instead of open_count ordering
> - Retitled from "vfio: Decrement open_count before close_device()"
> v1: https://lore.kernel.org/kvm/20221025193820.4412-1-ajderossi@gmail.com/
> 
> Anthony DeRossi (3):
>   vfio: Fix container device registration life cycle
>   vfio: Export the device set open count
>   vfio/pci: Check the device set open count on reset
> 
>  drivers/vfio/pci/vfio_pci_core.c | 10 +++++-----
>  drivers/vfio/vfio_main.c         | 26 +++++++++++++++++++++-----
>  include/linux/vfio.h             |  1 +
>  3 files changed, 27 insertions(+), 10 deletions(-)
> 

Applied to vfio for-linus branch for v6.1.  Thanks,

Alex

