Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB6B63F3C3
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 16:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbiLAPYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 10:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbiLAPYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 10:24:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0578957B5D
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 07:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669908185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zzhfax5vqwOtCKFjMXun2NOkTXtXPQNt2DKwUePEihM=;
        b=WAVmOni2/jJFHuuVJDQrRoROqdnpwFhSxpu9pBzFEqe1zoZIHCGLhZ1wxO0l4ffO2uu6fj
        G2LEcEPihlh2CfF6xd1+UXMQPwg6Saojqx3Z6fB1fJiIZslHf/PofRSADu2IkPBtH7KEUX
        ZtOhAdL8rWjjD7tleghMqYOC7ogm1sM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-e-S7I278OwSbA2d4-N0PiA-1; Thu, 01 Dec 2022 10:22:53 -0500
X-MC-Unique: e-S7I278OwSbA2d4-N0PiA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CA6D858F17;
        Thu,  1 Dec 2022 15:22:51 +0000 (UTC)
Received: from localhost (unknown [10.39.193.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 269E8477F55;
        Thu,  1 Dec 2022 15:22:51 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: Re: [PATCH v4 5/5] vfio: Fold vfio_virqfd.ko into vfio.ko
In-Reply-To: <5-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <5-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 01 Dec 2022 16:22:47 +0100
Message-ID: <87ilivw3lk.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 29 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:

> This is only 1.8k, putting it in its own module is not really
> necessary. The kconfig infrastructure is still there to completely remove
> it for systems that are trying for small footprint.
>
> Put it in the main vfio.ko module now that kbuild can support multiple .c
> files.

The biggest difference is that we now always have the vfio-irqfd-cleanup
wq once the vfio module has been loaded, even if pci or platform have
not been loaded. I guess that only affects a minority of setups (s390x
without pci?), and probably doesn't really matter.

>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/Kconfig     |  2 +-
>  drivers/vfio/Makefile    |  4 +---
>  drivers/vfio/vfio.h      | 13 +++++++++++++
>  drivers/vfio/vfio_main.c |  7 +++++++
>  drivers/vfio/virqfd.c    | 17 +++--------------
>  5 files changed, 25 insertions(+), 18 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

