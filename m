Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA7456ADAE
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 23:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236842AbiGGVdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 17:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236830AbiGGVdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 17:33:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 86F6033E0F
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 14:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657229578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cV1j2ZcOZ2ukDQseRE+2/CeOpXmD1CKdU7i9wQDZBys=;
        b=CAFW68+2uJk9UE69lbm6cSLFXX8MV4Yo+JNAymgTqcySNutXW/bYkBNcbCfdfsQvn5lIH2
        OEtg7CEDlg43qDFECK3pzWw2F69zYeApoWGIhJGQFdIXnmRVFlVf6JeWW578QgLVlJNJ7Q
        4mKOQXa/wINFHmNrGMmqi8iGj8cFMEk=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-UvNE0TjaNyubMEKQLCBoHA-1; Thu, 07 Jul 2022 17:32:56 -0400
X-MC-Unique: UvNE0TjaNyubMEKQLCBoHA-1
Received: by mail-io1-f70.google.com with SMTP id b5-20020a05660214c500b0067530b15cc1so10349152iow.9
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 14:32:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=cV1j2ZcOZ2ukDQseRE+2/CeOpXmD1CKdU7i9wQDZBys=;
        b=07seBh/VhT4BCnBv98NMHqABXFu5DQA1RZ2H2upl0vIaX6wX95ib2uJam9sdQj5bYi
         Me0MesEcFUDe7lAOlZZLB8Gu0kczofKgAolDcXpTwrZQHr5sKLCGu6OWU9HiQ3X0zGLz
         8VaaFFnT+8JhGL3gV1aq/5FvUCoXFXayB/po1IGEkPhCC2kpW5YhRGctfE9obHqqi3EB
         LDsFuPvaNgfZ7n//ZtXkkQ3kmp6OnwEgYow3Yst402ur12JIpRaPR7Q4PQqTHnt7mS/T
         skCRBYA7g03JMJ4Ln02NfVr5HUFm4jjokDgVopDu9smEdyn7qikT7PJTADrJmrmcKd5m
         RNGw==
X-Gm-Message-State: AJIora+WbmUHKME754BJYeX6++LN4X7VhHbl1jcoq0+9m4DEtl/0URDB
        yrCpm7NEBjc6iFfENktqh75G3xsDsrMwYzk1pZ6WfdT6TvBTsIm908VKQep5hQhdxb+F25c72P9
        ugWcOzBgnrAvC
X-Received: by 2002:a05:6602:3799:b0:675:6a5f:7862 with SMTP id be25-20020a056602379900b006756a5f7862mr69627iob.145.1657229575473;
        Thu, 07 Jul 2022 14:32:55 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sAdM81uL8IRdNPDxNMth+ZRU9oKnRMb2HyV5qi+7gZzQ01BPw4Z2eS/KO7GFhisJ0965XFTg==
X-Received: by 2002:a05:6602:3799:b0:675:6a5f:7862 with SMTP id be25-20020a056602379900b006756a5f7862mr69617iob.145.1657229575253;
        Thu, 07 Jul 2022 14:32:55 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z18-20020a056638215200b0033f16e84688sm1426558jaj.8.2022.07.07.14.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 14:32:54 -0700 (PDT)
Date:   Thu, 7 Jul 2022 15:32:53 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH v4 00/11] s390/vfio-ccw rework
Message-ID: <20220707153253.13deffe3.alex.williamson@redhat.com>
In-Reply-To: <20220707135737.720765-1-farman@linux.ibm.com>
References: <20220707135737.720765-1-farman@linux.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  7 Jul 2022 15:57:26 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Alex,
> 
> Here's a final pass through some of the vfio-ccw rework.
> I'm hoping that because of the intersection with the extern
> removal, you could grab this directly? [1]

Done.  Applied to vfio next branch for v5.20.  Thanks,

Alex

> There were no code changes since v3, I simply rebased this
> onto your linux-vfio/next tree, currently on commit 7654a8881a54
> ("Merge branches
>  'v5.20/vfio/migration-enhancements-v3',
>  'v5.20/vfio/simplify-bus_type-determination-v3',
>  'v5.20/vfio/check-vfio_register_iommu_driver-return-v2',
>  'v5.20/vfio/check-iommu_group_set_name_return-v1',
>  'v5.20/vfio/clear-caps-buf-v3',
>  'v5.20/vfio/remove-useless-judgement-v1' and
>  'v5.20/vfio/move-device_open-count-v2'
>  into
>  v5.20/vfio/next")
> 
> v3->v4:
>  - Rebased to vfio/next tree
>    - Tweak patch 6 to fit with extern removal
>    - The rest applied directly
>  - [MR] Added r-b's (Thank you!)
>  - [EF] Add a comment about cp_free() call in fsm_notoper()
> v3: https://lore.kernel.org/r/20220630203647.2529815-1-farman@linux.ibm.com/
> v2: https://lore.kernel.org/r/20220615203318.3830778-1-farman@linux.ibm.com/
> v1: https://lore.kernel.org/r/20220602171948.2790690-1-farman@linux.ibm.com/
> 
> Footnotes:
> [1] https://lore.kernel.org/r/e1ead3e4-9e7d-f026-485b-157d7dc004d3@linux.ibm.com/
> 
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> 
> Eric Farman (10):
>   vfio/ccw: Fix FSM state if mdev probe fails
>   vfio/ccw: Do not change FSM state in subchannel event
>   vfio/ccw: Remove private->mdev
>   vfio/ccw: Pass enum to FSM event jumptable
>   vfio/ccw: Flatten MDEV device (un)register
>   vfio/ccw: Update trace data for not operational event
>   vfio/ccw: Create an OPEN FSM Event
>   vfio/ccw: Create a CLOSE FSM event
>   vfio/ccw: Refactor vfio_ccw_mdev_reset
>   vfio/ccw: Move FSM open/close to MDEV open/close
> 
> Michael Kawano (1):
>   vfio/ccw: Remove UUID from s390 debug log
> 
>  drivers/s390/cio/vfio_ccw_async.c   |  1 -
>  drivers/s390/cio/vfio_ccw_drv.c     | 59 +++++------------
>  drivers/s390/cio/vfio_ccw_fsm.c     | 99 ++++++++++++++++++++++++-----
>  drivers/s390/cio/vfio_ccw_ops.c     | 77 +++++++---------------
>  drivers/s390/cio/vfio_ccw_private.h |  9 +--
>  include/linux/mdev.h                |  5 --
>  6 files changed, 125 insertions(+), 125 deletions(-)
> 

