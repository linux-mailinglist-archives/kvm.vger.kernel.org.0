Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A40F7C8EC4
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 23:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbjJMVKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 17:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjJMVKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 17:10:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6BED7
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 14:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697231393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GdAOO2yFE2cJwQjxlMCkUqIXwqY1KJtN1wzUd1l3G64=;
        b=P5kXUp9Z3RohY1sc48EQL7laW0dKAFZ5a6sYdITM+RxcwJK9h4n3d5vA41T8TyDIIfmzTg
        CD2jfqPxCyvFLeOIsN2ey81eMDRMm2LJcJdyaXnGkNOKH+81gxlVfcLK5ODkkYoaAUA9AF
        inscyn5JjHkYZ9Rt2JQDp6tLdfe9AUY=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-410-6btPuoENOIqtb__y7XW7pg-1; Fri, 13 Oct 2023 17:09:42 -0400
X-MC-Unique: 6btPuoENOIqtb__y7XW7pg-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3573edc744cso15434055ab.2
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 14:09:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697231381; x=1697836181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GdAOO2yFE2cJwQjxlMCkUqIXwqY1KJtN1wzUd1l3G64=;
        b=KdZMesNfwg8XrpFWCZPv458o9kHzRrjYYduKlgcHYFpLX/Sy7guLWoe83FjVDl6tOS
         53KhjNJb+UJZQ6Q3jTa01txB60cQelADoA5FU9KuMoJyPAkbOPUU9tkwaJc9xg30fMwQ
         Zwui9K6YNy8ljLaO7rCbP3g6J6bpS+JbkMOUgDOjInHP0E4Ees6YnUlLrg8CWl5VELDX
         gCp3mDkXqPL4rOWVxSEDgm77hdxclVSTXCSzIawMEnife29Uv//wDNKVm/AVcPChquEy
         HyCaS2rO67W5qTYaCgi88DSQ7244eq3E6u9FB0oC6HALevoLYQs7Nt8puW8NkQ+q3IsD
         7dcg==
X-Gm-Message-State: AOJu0YxU2TKr0TBYkyEcLYIBcA9LjJibXpq24zN2YlvCd7kNOyBGebBy
        MqXIouikuCLDJieEFPGXSwsw9t/X6sLHlE8Bmm2JD15qgKlbUqvdAj8ZxiGn2PUGv7++5nFL2HS
        /L+jZf28EXTai
X-Received: by 2002:a05:6e02:1ca6:b0:34c:bc10:2573 with SMTP id x6-20020a056e021ca600b0034cbc102573mr34215547ill.3.1697231381577;
        Fri, 13 Oct 2023 14:09:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG4Tpiwqx7qpgdqVqQyELH26TBmji8DoBVKjQ2UGq8YoxDUwwru20TSAqCp0/uAeckBK0pzWA==
X-Received: by 2002:a05:6e02:1ca6:b0:34c:bc10:2573 with SMTP id x6-20020a056e021ca600b0034cbc102573mr34215536ill.3.1697231381324;
        Fri, 13 Oct 2023 14:09:41 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id t4-20020a02cca4000000b0042b3e2e5ca1sm4914515jap.122.2023.10.13.14.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Oct 2023 14:09:40 -0700 (PDT)
Date:   Fri, 13 Oct 2023 15:09:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     <jgg@ziepe.ca>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <dan.carpenter@linaro.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <shannon.nelson@amd.com>
Subject: Re: [PATCH v2 vfio 0/3] pds/vfio: Fixes for locking bugs
Message-ID: <20231013150940.50804350.alex.williamson@redhat.com>
In-Reply-To: <20231011230115.35719-1-brett.creeley@amd.com>
References: <20231011230115.35719-1-brett.creeley@amd.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 11 Oct 2023 16:01:12 -0700
Brett Creeley <brett.creeley@amd.com> wrote:

> This series contains fixes for locking bugs in the recently introduced
> pds-vfio-pci driver. There was an initial bug reported by Dan Carpenter
> at:
> 
> https://lore.kernel.org/kvm/1f9bc27b-3de9-4891-9687-ba2820c1b390@moroto.mountain/
> 
> However, more locking bugs were found when looking into the previously
> mentioned issue. So, all fixes are included in this series.
> 
> v2:
> https://lore.kernel.org/kvm/20230914191540.54946-1-brett.creeley@amd.com/
> - Trim the OOPs in the patch commit messages
> - Rework patch 3/3 to only unlock the spinlock once

I thought we determined the spinlock, and thus the atomic context, was
an arbitrary choice.  I would have figured we simply convert it to a
mutex.  Why didn't we take that route?  Thanks,

Alex

> - Destroy the state_mutex in the driver specific vfio_device_ops.release
>   callback
> 
> Brett Creeley (3):
>   pds/vfio: Fix spinlock bad magic BUG
>   pds/vfio: Fix mutex lock->magic != lock warning
>   pds/vfio: Fix possible sleep while in atomic context
> 
>  drivers/vfio/pci/pds/vfio_dev.c | 27 ++++++++++++++++++++-------
>  1 file changed, 20 insertions(+), 7 deletions(-)
> 

