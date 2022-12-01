Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4233A63EFD0
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 12:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbiLALp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 06:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbiLALpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 06:45:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C897899F6A
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 03:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669895054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=stqV6mQHi5QEk/y+ovuO03Y8nxb1NerpLwNtmHDSmqU=;
        b=Kt7DrNu98hF0lAThLF4zzn5oq7T+/8aIGi4FPfYTwSQY/puc1U7zguZwqxgsofHq5+XBOG
        ZtHhim/HoKxp/O45YXzyyuX/lDB/LlXgfPHJMK0qATs5aHWpmHy8lQ95dce9Fw4QDscieA
        AyeKkZiNQpOnJStQl4pnBybjZH0M1h0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-aiL1DbgFPV-h6q6o8kdoNQ-1; Thu, 01 Dec 2022 06:44:08 -0500
X-MC-Unique: aiL1DbgFPV-h6q6o8kdoNQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9AD12185A78B;
        Thu,  1 Dec 2022 11:44:08 +0000 (UTC)
Received: from localhost (unknown [10.39.193.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E2A52024CBE;
        Thu,  1 Dec 2022 11:44:08 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: Re: [PATCH v4 2/5] vfio/spapr: Move VFIO_CHECK_EXTENSION into
 tce_iommu_ioctl()
In-Reply-To: <2-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <2-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 01 Dec 2022 12:44:05 +0100
Message-ID: <87r0xjwdq2.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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

> The PPC64 kconfig is a bit of a rats nest, but it turns out that if
> CONFIG_SPAPR_TCE_IOMMU is on then EEH must be too:
>
> config SPAPR_TCE_IOMMU
> 	bool "sPAPR TCE IOMMU Support"
> 	depends on PPC_POWERNV || PPC_PSERIES
> 	select IOMMU_API
> 	help
> 	  Enables bits of IOMMU API required by VFIO. The iommu_ops
> 	  is not implemented as it is not necessary for VFIO.
>
> config PPC_POWERNV
> 	select FORCE_PCI
>
> config PPC_PSERIES
> 	select FORCE_PCI
>
> config EEH
> 	bool
> 	depends on (PPC_POWERNV || PPC_PSERIES) && PCI
> 	default y
>
> So, just open code the call to eeh_enabled() into tce_iommu_ioctl().
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_spapr_tce.c | 10 ++++------
>  drivers/vfio/vfio_spapr_eeh.c       |  6 ------
>  2 files changed, 4 insertions(+), 12 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

