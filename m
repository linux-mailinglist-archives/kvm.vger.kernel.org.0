Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9126F63EFE6
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 12:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiLALvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 06:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbiLALux (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 06:50:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719719AE07
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 03:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669895390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bHLza1f7RANcFMcrRdgvb8FpGev5AKBW4wrKmzcKUlU=;
        b=dmyEUUszU+l6c8LmtDPFpxBCgLFYdLbei5Knu84VnYHtMJQeM+CLEAPsG4tQgo6qK6QOGZ
        ab1mlY+8JB+rJF46CEi3D+b3njGSx4C5078stSOez4qltDTV6ZLMlRTErEeSTKwgtnDtGX
        h+Q8arXTlr6CVP5U3QbKebq3T3omeM4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-mvy7eCVXO7Kxxqt2u2l6ww-1; Thu, 01 Dec 2022 06:49:47 -0500
X-MC-Unique: mvy7eCVXO7Kxxqt2u2l6ww-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 121CF3804513;
        Thu,  1 Dec 2022 11:49:47 +0000 (UTC)
Received: from localhost (unknown [10.39.193.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B8AEEFD48;
        Thu,  1 Dec 2022 11:49:46 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: Re: [PATCH v4 3/5] vfio: Move vfio_spapr_iommu_eeh_ioctl into
 vfio_iommu_spapr_tce.c
In-Reply-To: <3-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <3-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 01 Dec 2022 12:49:43 +0100
Message-ID: <87o7snwdgo.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

> As with the previous patch EEH is always enabled if SPAPR_TCE_IOMMU, so
> move this last bit of code into the main module.
>
> Now that this function only processes VFIO_EEH_PE_OP remove a level of
> indenting as well, it is only called by a case statement that already
> checked VFIO_EEH_PE_OP.
>
> This eliminates an unnecessary module and SPAPR code in a global header.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/Makefile               |  1 -
>  drivers/vfio/vfio_iommu_spapr_tce.c | 55 +++++++++++++++++-
>  drivers/vfio/vfio_spapr_eeh.c       | 88 -----------------------------
>  include/linux/vfio.h                | 12 ----
>  4 files changed, 53 insertions(+), 103 deletions(-)
>  delete mode 100644 drivers/vfio/vfio_spapr_eeh.c

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

