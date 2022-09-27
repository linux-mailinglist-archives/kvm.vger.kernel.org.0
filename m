Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9345ECDF0
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 22:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbiI0UJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 16:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbiI0UIp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 16:08:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821F81EC1C9
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 13:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664309264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i9KCspW5QBpvFaoYn48TLwQ3ngMOEiqEbJfDsVhYYhY=;
        b=EkfR1af4JWS3RxX8lRV+N5NdfojelnByNtFcp6nvLQke2DU7A1QHaO5GcywfIOU2MJK6xO
        HSpoOyD2N9mkeI1Yc6hBOXqo4e4o+4akseSRo3qXTE7bsXr6FhnI8epIZsO9RLEWXaJBK2
        9YodHHArglosOJGVc1VI6vvhfqJ3g6s=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-626-iec2XGRfPzOruz6lZs3U-w-1; Tue, 27 Sep 2022 16:07:39 -0400
X-MC-Unique: iec2XGRfPzOruz6lZs3U-w-1
Received: by mail-il1-f199.google.com with SMTP id x3-20020a056e021ca300b002f855cd264cso5495613ill.7
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 13:07:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=i9KCspW5QBpvFaoYn48TLwQ3ngMOEiqEbJfDsVhYYhY=;
        b=FwT7LNxQFar+DN7JntvzvKjQbPCxW1gsMZviJIHghbg/gOq46x2ATc8lXWZp/KXIX4
         ttnVtioZk0e2/M7MPKoE7KkyuR+vvbUCxSZ6KSmhY/N8P9ckxM0yZO5/bLCyMq/wIGIU
         yRh3SMQWhnRqevCe+46aYhiOkeK6ld69TlL3fi5rGoAQVhsFMmZmOo3xg9n9d+r2Otji
         NiAyBgBTn4l3lyB572ynd4kKETqb9Cc6eAUr6+ZOSc9v1TbUd+YYw3YLT8aS4kXnJMMa
         TH7bMohQ3LioB4IWtHI2LfN9OvKiDrtisi3xrdpyJUZLJEL/LQ4/VBXTgA6pg0zFvY97
         iMRQ==
X-Gm-Message-State: ACrzQf046KFaTsp1lUd4Ez0rje7E/1ax5T+CQFfA1wEQgBMa7DAcNdXA
        xcj8FDbj0kb5f9dgtLI+vb+Q1OVDgea/Q6EtSO/ldRCmURfLQiGUatgv+tQUPvV9zsWoAh2wuh6
        8yWt8nd5KrPhO
X-Received: by 2002:a05:6e02:164d:b0:2f1:869c:c45b with SMTP id v13-20020a056e02164d00b002f1869cc45bmr12241786ilu.212.1664309259222;
        Tue, 27 Sep 2022 13:07:39 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5lK3WbPrzD44Iq58D1vNhjr5XwGPbVXBbULBMbNnjK3x4PVL86wB1/1VUMJJsx+kK4SSdmYA==
X-Received: by 2002:a05:6e02:164d:b0:2f1:869c:c45b with SMTP id v13-20020a056e02164d00b002f1869cc45bmr12241776ilu.212.1664309259048;
        Tue, 27 Sep 2022 13:07:39 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m20-20020a02a154000000b00346b96a352bsm963856jah.164.2022.09.27.13.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 13:07:38 -0700 (PDT)
Date:   Tue, 27 Sep 2022 14:07:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org
Subject: Re: simplify the mdev interface v8
Message-ID: <20220927140737.0b4c9a54.alex.williamson@redhat.com>
In-Reply-To: <20220923092652.100656-1-hch@lst.de>
References: <20220923092652.100656-1-hch@lst.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 23 Sep 2022 11:26:38 +0200
Christoph Hellwig <hch@lst.de> wrote:

> Hi all,
> 
> this series significantly simplifies the mdev driver interface by
> following the patterns for device model interaction used elsewhere in
> the kernel.
> 
> Changes since v7:
>  - rebased to the latests vfio/next branch
>  - move the mdev.h include from cio.h to vfio_ccw_private.h
>  - don't free the parent in mdev_type_release
>  - set the pretty_name for vfio_ap
>  - fix the available_instances check in mdev_device_create

Thanks for your persistence, I think all threads are resolved at this
point.  Applied to vfio next branch for v6.1.  Thanks,

Alex

