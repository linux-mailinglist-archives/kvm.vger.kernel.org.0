Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0993B63FC6A
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 01:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiLBAAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 19:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiLBAAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 19:00:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C426BFCFF
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 15:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669939158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fROYnwX6LRaaI2HLn4u0qAWwqjy5IPqZUIbZ9VPRP/E=;
        b=gsoPXWt3oUFqsHCMLjrK2RcSjYRDSdSxU1PzkN0slrz6Yf4a0uzDyzTylAzV0uedcu58tj
        mqeFFOLhEKaHPfT2sT6f9tYqcESm+IaHe/esmkdZIOK6Ub2GVvUwN6Dy3fJHrBfIHew93Y
        k1yhy6TQEq5i7iI7N83ebMYArImhQng=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-554-pIeT200YPaK0t11kEPZQjQ-1; Thu, 01 Dec 2022 18:59:11 -0500
X-MC-Unique: pIeT200YPaK0t11kEPZQjQ-1
Received: by mail-il1-f198.google.com with SMTP id 13-20020a056e0216cd00b003023e8b7d03so3651991ilx.7
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 15:59:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fROYnwX6LRaaI2HLn4u0qAWwqjy5IPqZUIbZ9VPRP/E=;
        b=b0RbKYlQtQkX6lyzmQxpGVmRz+PXE3+yAWVT+9y6rMmSoPq48qwekv7+0kw2u1MzuX
         7/Q4Lw2R8w4f86Ph2oQNvbUw4mYkFyOVFmF5HvGaLWpjocThtkrfWBAyBMTQyQx0X2Uc
         +9mLmCEStkVRQdu5Q272DwmHMGXWRV446P2TK3e4VXjbpFXqkd8w1I97mqN0JfQT0U2m
         iVcpslmcpgftb7RQhIDgCnxCXZXT8lGSV7DxmsFcwxCyzEJHImHOEH/qNR2Y3zjBKdbm
         T5x7VC0HpTwTA2MYmFERZOMoT+QO03kbq0BF1iq7UpfXuVfNE5ogS9molR0lQ/4ILREk
         +JOw==
X-Gm-Message-State: ANoB5pnKmRXMvV6pMWWWc7B1BM8jLDCbeeKhENWEXJmbHWLzFq1K5xl3
        dkTvDweqjzRFhuBw4GDcqPVWO+aKoGl1Gh5DkTHj/cHKB2Ik8+Y9wND0DsIC0r/F8eaX7Zk/wsq
        988tE90gm/USp
X-Received: by 2002:a92:d602:0:b0:302:912f:7ac7 with SMTP id w2-20020a92d602000000b00302912f7ac7mr24881718ilm.75.1669939151098;
        Thu, 01 Dec 2022 15:59:11 -0800 (PST)
X-Google-Smtp-Source: AA0mqf78Z0+LLWMvOl1tBkgHWWp5QTzRgl7z2bLuwiUnuClUO9WjeAbnCvESb47LKd5FsFOhIfMWvA==
X-Received: by 2002:a92:d602:0:b0:302:912f:7ac7 with SMTP id w2-20020a92d602000000b00302912f7ac7mr24881711ilm.75.1669939150872;
        Thu, 01 Dec 2022 15:59:10 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z4-20020a05663822a400b003740de9fb65sm2154716jas.46.2022.12.01.15.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 15:59:10 -0800 (PST)
Date:   Thu, 1 Dec 2022 16:59:08 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>
Subject: Re: [PATCH v4 1/5] vfio/pci: Move all the SPAPR PCI specific logic
 to vfio_pci_core.ko
Message-ID: <20221201165908.3a21a1c7.alex.williamson@redhat.com>
In-Reply-To: <87tu2fwe5y.fsf@redhat.com>
References: <1-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
        <87tu2fwe5y.fsf@redhat.com>
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

On Thu, 01 Dec 2022 12:34:33 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Tue, Nov 29 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > The vfio_spapr_pci_eeh_open/release() functions are one line wrappers
> > around an arch function. Just call them directly and move them into
> > vfio_pci_priv.h. This eliminates some weird exported symbols that don't  
> 
> Hm, that doesn't seem to match the current patch -- the only change to
> vfio_pci_priv.h is removing an empty line :)

s/ and move them into vfio_pci_priv.h//?


> > need to exist.
> >
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_core.c | 11 +++++++++--
> >  drivers/vfio/pci/vfio_pci_priv.h |  1 -
> >  drivers/vfio/vfio_spapr_eeh.c    | 13 -------------
> >  include/linux/vfio.h             | 11 -----------
> >  4 files changed, 9 insertions(+), 27 deletions(-)  
> 

