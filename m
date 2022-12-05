Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFC8643839
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 23:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbiLEWgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 17:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233289AbiLEWgO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 17:36:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08E91A23F
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 14:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670279717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ah37WYADr3fvMuVt6pbYD7RvYtN2c2xTZ7gs086EVM4=;
        b=KIvHSfvfcfZKG6QjWWZ2Lrw/LSPW2lwkJs5VF41y2TSSRX1SdMFgRUCtUxo+ZwCOBA4Epc
        gBKhR/xXRcF9HNEeywItFyKdqnzxXB5MKBDx9bcyAiyrlUno2qQzW4RKxTl08jEWRATVKk
        FRc4eQftVN/1x4PgxZduWjXXHN46cbE=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-502-Moim7VSIO3KTPkvoqgIrxQ-1; Mon, 05 Dec 2022 17:35:15 -0500
X-MC-Unique: Moim7VSIO3KTPkvoqgIrxQ-1
Received: by mail-io1-f69.google.com with SMTP id h11-20020a6b7a0b000000b006e0004fc167so4888476iom.5
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 14:35:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ah37WYADr3fvMuVt6pbYD7RvYtN2c2xTZ7gs086EVM4=;
        b=6GLhceJRXQAhSZOR+F2ut6N/o5tMB5lfB2pvs290cWd4ETyaenQu1hN0zxYoNakMn8
         uQ7W3P0A6zY+Lv+fQ00OhG2U0sscTXMNrpyGsnlYmoiLD3plZ1lRdJCEqKpVrLqUWdb7
         N7ko3S280Jx4YEQ9USid7iRQ6LJ1dREzsFzbT4BXXjjJer/p83EtKB+Olz6sGPtgLO5S
         au2E7UkwgHQD3d5epTN/XLWuzwO6akBhy6rTM5YKyNXrUr1Em/60/jj/dChSNp2qZQWx
         Q/4Fjq2rQvWX34PcRAlMRTc4a1RZ+WA0YCc8QlsgdSawKz1IxPdXJSkIeXHDDQJdtED7
         /7YA==
X-Gm-Message-State: ANoB5pnfd7fJ3oyGMQvWO9Z+UsyYUF46n6j0YUV+Ih8lpoEAKFQECKzj
        lSSz57hPUKAyuKhhsG++IwEcLCEmYBCSb/yOgEyUrUJSarP7YwQ/SVIWs3W7V3xFklf6uQ4Ui9y
        91ND6i9ZTLMCq
X-Received: by 2002:a6b:7209:0:b0:6df:bf6:8a with SMTP id n9-20020a6b7209000000b006df0bf6008amr28845448ioc.153.1670279715148;
        Mon, 05 Dec 2022 14:35:15 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6fEFv5tkcJwWDBVuLff04UQ1K9ZJxadR0CY2Z/RGZQ5syeoBSqhzJw9F+/dZxQWsiPT5i3aQ==
X-Received: by 2002:a6b:7209:0:b0:6df:bf6:8a with SMTP id n9-20020a6b7209000000b006df0bf6008amr28845441ioc.153.1670279714900;
        Mon, 05 Dec 2022 14:35:14 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u19-20020a056e02111300b002fc61ac516csm5509200ilk.87.2022.12.05.14.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 14:35:14 -0800 (PST)
Date:   Mon, 5 Dec 2022 15:35:12 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>
Subject: Re: [PATCH v5 0/5] Simplify the module and kconfig structure in
 vfio
Message-ID: <20221205153512.2f3c09c0.alex.williamson@redhat.com>
In-Reply-To: <0-v5-fc5346cacfd4+4c482-vfio_modules_jgg@nvidia.com>
References: <0-v5-fc5346cacfd4+4c482-vfio_modules_jgg@nvidia.com>
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

On Mon,  5 Dec 2022 11:29:15 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This series does a little house cleaning to remove the SPAPR exported
> symbols, presence in the public header file, and reduce the number of
> modules that comprise VFIO.
> 
> v5:
>  - Reword commit messages
>  - Remove whitespace change from drivers/vfio/pci/vfio_pci_priv.h
> v4: https://lore.kernel.org/r/0-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com
>  - Copy IBM copyright header to vfio_iommu_spapr_tce.c
>  - Use "return" not "ret = " in vfio_spapr_ioctl_eeh_pe_op()
>  - Use just "#if IS_ENABLED(CONFIG_EEH)"
> v3: https://lore.kernel.org/r/0-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com
>  - New patch to fold SPAPR VFIO_CHECK_EXTENSION EEH code into the actual ioctl
>  - Remove the 'case VFIO_EEH_PE_OP' indenting level
>  - Just open code the calls and #ifdefs to eeh_dev_open()/release()
>    instead of using inline wrappers
>  - Rebase to v6.1-rc1
> v2: https://lore.kernel.org/r/0-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com
>  - Add stubs for vfio_virqfd_init()/vfio_virqfd_exit() so that linking
>    works even if vfio_pci/etc is not selected
> v1: https://lore.kernel.org/r/0-v1-10a2dba77915+c23-vfio_modules_jgg@nvidia.com
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason Gunthorpe (5):
>   vfio/pci: Move all the SPAPR PCI specific logic to vfio_pci_core.ko
>   vfio/spapr: Move VFIO_CHECK_EXTENSION into tce_iommu_ioctl()
>   vfio: Move vfio_spapr_iommu_eeh_ioctl into vfio_iommu_spapr_tce.c
>   vfio: Remove CONFIG_VFIO_SPAPR_EEH
>   vfio: Fold vfio_virqfd.ko into vfio.ko
> 
>  drivers/vfio/Kconfig                |   7 +-
>  drivers/vfio/Makefile               |   5 +-
>  drivers/vfio/pci/vfio_pci_core.c    |  11 ++-
>  drivers/vfio/vfio.h                 |  13 ++++
>  drivers/vfio/vfio_iommu_spapr_tce.c |  65 ++++++++++++++---
>  drivers/vfio/vfio_main.c            |   7 ++
>  drivers/vfio/vfio_spapr_eeh.c       | 107 ----------------------------
>  drivers/vfio/virqfd.c               |  17 +----
>  include/linux/vfio.h                |  23 ------
>  9 files changed, 91 insertions(+), 164 deletions(-)
>  delete mode 100644 drivers/vfio/vfio_spapr_eeh.c
> 
> 
> base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780

Applied to vfio next branch for v6.2.  Thanks,

Alex

