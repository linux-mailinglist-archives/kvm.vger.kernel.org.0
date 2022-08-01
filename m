Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9338458728E
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 22:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiHAUzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 16:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234620AbiHAUzf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 16:55:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CE4FFDFDE
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 13:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659387333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QKq8HVGZQpe4cr2LqvofdEB83s1X3DS/h6MN4idsnvs=;
        b=ENbdOiB4JmuOAEm7WFCOrfYzUpKsDiE6u+FUZD+DLIw6jHVnP56CU64gI1QGPgfl2R5exg
        sMQR8F1MzC+/frVVj4mxh8lA7kGaEKd+TSJYkUnc/bPzgQ3qvJpzeTks81oV6IRUbcUShz
        EwX7zi58LhyG6qW853UIbvnYsxkI4GE=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-216-Rkq1e5sfM360LLVjoSJ0SQ-1; Mon, 01 Aug 2022 16:55:32 -0400
X-MC-Unique: Rkq1e5sfM360LLVjoSJ0SQ-1
Received: by mail-il1-f199.google.com with SMTP id z17-20020a921a51000000b002ddff313ab2so6899540ill.12
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 13:55:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=QKq8HVGZQpe4cr2LqvofdEB83s1X3DS/h6MN4idsnvs=;
        b=cF12Zbb7C/RCUafHY9oxQe7yP+V4q86ntOiU59gqckJCZuJhCogjhDhh78D4iL2tBR
         PTkSzcA+wc4zMmiqKns3FNCNGt6ISZt/bffKvJpFmWSe6CXLP9RVya8wuMRuKCXoV9eo
         vAiiHXXrShaILFXyIhlKP5jA5k8Liq16O3vNVcs9oZO9Z5AomaxFiEtQFPyWq4yhc76w
         HhxtZEE6nlpMe8KVWskxglOlCM2bLNdPRFRTepaopLlKq3juJYnyNQBKZL30rVIMUJFK
         a7zFeBM8UoCFqNuLRjdb28uHoN09HWvVjC9J6XAocMzrr5yBdC8Eam5z1RLWLe8POYuw
         cijA==
X-Gm-Message-State: ACgBeo3Yl4p6rk1ughGaT9aey32SJWvxYTXjkJNY9du+VMe58p+Vqs49
        9aVcsmWLgJnZUADeejTIY7nHeWEp15REmiJz8zoKB6YWlnOk9ZQ4zFdAATfSglH0KgluQDUhZ6S
        mcNYPzA8dNxu3
X-Received: by 2002:a05:6e02:1d81:b0:2de:e4d2:787d with SMTP id h1-20020a056e021d8100b002dee4d2787dmr155045ila.126.1659387331633;
        Mon, 01 Aug 2022 13:55:31 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4QImEUtJqO/CgVMXMKqIjE3TY0B7QN+vBWj7uS022EYUdT4narfpq+W80jOwZoLjvTO3ZYKA==
X-Received: by 2002:a05:6e02:1d81:b0:2de:e4d2:787d with SMTP id h1-20020a056e021d8100b002dee4d2787dmr155036ila.126.1659387331455;
        Mon, 01 Aug 2022 13:55:31 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id v7-20020a05663812c700b0032e49fcc241sm5685731jas.176.2022.08.01.13.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 13:55:31 -0700 (PDT)
Date:   Mon, 1 Aug 2022 14:55:28 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/3] vfio-ccw fixes for 5.20
Message-ID: <20220801145528.4b7ec8c7.alex.williamson@redhat.com>
In-Reply-To: <20220728204914.2420989-1-farman@linux.ibm.com>
References: <20220728204914.2420989-1-farman@linux.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Jul 2022 22:49:11 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Matt, Alex,
> 
> Here are the (hopefully last) patches for the DMA UNMAP thing.
> 
> Changelog:
> v2->v3:
>  - [MR] Add r-b to Patch 1, 3 (Thank you!)
>  - [MR] s/unsigned long/u64/
>  - [EF] Add brackets to for(i) loop
> v2: https://lore.kernel.org/r/20220728160550.2119289-1-farman@linux.ibm.com/
> v1: https://lore.kernel.org/r/20220726150123.2567761-1-farman@linux.ibm.com/
> 
> Eric Farman (3):
>   vfio/ccw: Add length to DMA_UNMAP checks
>   vfio/ccw: Remove FSM Close from remove handlers
>   vfio/ccw: Check return code from subchannel quiesce
> 
>  drivers/s390/cio/vfio_ccw_cp.c  | 16 +++++++++++-----
>  drivers/s390/cio/vfio_ccw_cp.h  |  2 +-
>  drivers/s390/cio/vfio_ccw_drv.c |  1 -
>  drivers/s390/cio/vfio_ccw_fsm.c |  2 +-
>  drivers/s390/cio/vfio_ccw_ops.c |  4 +---
>  5 files changed, 14 insertions(+), 11 deletions(-)
> 

Applied to vfio next branch for v5.20/v6.0.  Thanks,

Alex

