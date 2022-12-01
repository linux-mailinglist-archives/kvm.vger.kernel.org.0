Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDBF63EF8D
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 12:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiLALfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 06:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiLALfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 06:35:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04855222B2
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 03:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669894480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7b7LC82QpzFXx4/uZlwSm/HfbqSe1/XpfuqoCSC3YYo=;
        b=gcnKErb2pfurh0WRIFPpfncKS1JSEdwYHw3+2FrGdbcYOyQ9IYX8A8bMGgodQ2sfmCGL7S
        lnjtMyL6IoXqigJPUkPsEfjl/fe8MPvcHV+10dL+CCuCvGTzmXoBjoO7f9ViWwDe54PnnD
        JMiX0yNQ6eYadq/pWyRI7HuDXvDpCII=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-65-w72bwug8OBSgIRpJRkLP0g-1; Thu, 01 Dec 2022 06:34:37 -0500
X-MC-Unique: w72bwug8OBSgIRpJRkLP0g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 157F4857D0A;
        Thu,  1 Dec 2022 11:34:37 +0000 (UTC)
Received: from localhost (unknown [10.39.193.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8772B200BA83;
        Thu,  1 Dec 2022 11:34:36 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: Re: [PATCH v4 1/5] vfio/pci: Move all the SPAPR PCI specific logic
 to vfio_pci_core.ko
In-Reply-To: <1-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <1-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 01 Dec 2022 12:34:33 +0100
Message-ID: <87tu2fwe5y.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
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

> The vfio_spapr_pci_eeh_open/release() functions are one line wrappers
> around an arch function. Just call them directly and move them into
> vfio_pci_priv.h. This eliminates some weird exported symbols that don't

Hm, that doesn't seem to match the current patch -- the only change to
vfio_pci_priv.h is removing an empty line :)

> need to exist.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 11 +++++++++--
>  drivers/vfio/pci/vfio_pci_priv.h |  1 -
>  drivers/vfio/vfio_spapr_eeh.c    | 13 -------------
>  include/linux/vfio.h             | 11 -----------
>  4 files changed, 9 insertions(+), 27 deletions(-)

