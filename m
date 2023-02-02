Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848356888FA
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 22:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbjBBV0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 16:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232819AbjBBV0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 16:26:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB296EADA
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 13:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675373160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iF56rDJZEXr0bJFQfPaAtCQjusrCdXNin563lCz1yUw=;
        b=Uuwbj5pnEIok3WOFB7/9JexjCkPwynLvbb0cwBTP1QRVEw680jPJ5P0sqTi/KzGv4ivg70
        jU2HTHh5mg7v4cGg7/TtQffE5lrroQXsCcj4+RIPid1QU53Z/91K2m6rN6xqS/6lIRI3mm
        GXeb3n3HmwDg9/sB0QOifA+a3xZKme4=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-629-JNq9ZMfrOn2TT4wiDjEazA-1; Thu, 02 Feb 2023 16:25:58 -0500
X-MC-Unique: JNq9ZMfrOn2TT4wiDjEazA-1
Received: by mail-io1-f72.google.com with SMTP id g6-20020a6b7606000000b007297c4996c7so1210832iom.13
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 13:25:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iF56rDJZEXr0bJFQfPaAtCQjusrCdXNin563lCz1yUw=;
        b=aEYMPFKZTLDb4MIrQlsxF2XrYefJJQNZozqdaw7RT8qcy1E7hSJnlMCvO9PtxzTt2o
         8Q1IIC2xtZ3WMP6kzXRZuvDusH6YRCyfI/iuv/qXVd+bqxWX/HitoAxPk/nCFpSTnkKt
         62yygIT6La6xJn3fRgZGORuTLk35XHLG+KG37XncQhcxKcEVY9+XbZwBxVhyfnEVUxZx
         PL5CbQxsAiBNP+iMKoo940Jzvrvb2LIIk5IBQbcn/XW3Nuju6ioiFMrlwGbuNQeEBcQ1
         hpe3XTMfy1/ueiPBZ11FxT7055x0RQ809dJY63a9J+DHsZSBoOocjtMjYHvBt7hyMrlj
         Sr/g==
X-Gm-Message-State: AO0yUKVBommuyrDwACCTEoGcXY2bZ9U2Rd9Pu8xRPKTSkf59TLlgcQS+
        nncJ/U8P0JmczOQPfavSmMU8YEH+M8CMtJNbZM5tRVj3hnFlvUddrvr7TEEVE1lxFugsNxkzyKh
        5W/JKhJwXoVMW
X-Received: by 2002:a6b:3fc1:0:b0:723:8cb5:6707 with SMTP id m184-20020a6b3fc1000000b007238cb56707mr2175235ioa.6.1675373158114;
        Thu, 02 Feb 2023 13:25:58 -0800 (PST)
X-Google-Smtp-Source: AK7set9CeoMJxsxn29uIjfKg3aVYIFeg0F3nKjZu6554n9oRPOcQT5ohRB/vefx/lmzhd95ZrN3uLQ==
X-Received: by 2002:a6b:3fc1:0:b0:723:8cb5:6707 with SMTP id m184-20020a6b3fc1000000b007238cb56707mr2175231ioa.6.1675373157812;
        Thu, 02 Feb 2023 13:25:57 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id az9-20020a056638418900b003a96cc2bbdesm258841jab.85.2023.02.02.13.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 13:25:57 -0800 (PST)
Date:   Thu, 2 Feb 2023 14:25:56 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH V8 0/7] fixes for virtual address update
Message-ID: <20230202142556.79ed42c7.alex.williamson@redhat.com>
In-Reply-To: <1675184289-267876-1-git-send-email-steven.sistare@oracle.com>
References: <1675184289-267876-1-git-send-email-steven.sistare@oracle.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
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

On Tue, 31 Jan 2023 08:58:02 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:
> Changes in v8:
>   * updated group_leader comment in vfio_dma_do_map
>   * delete async arg from mm_lock_acct
>   * pass async=false to vfio_lock_acct in vfio_pin_page_external
>   * locked_vm becomes size_t
>   * improved commit message in "restore locked_vm"
>   * simplified flow in vfio_change_dma_owner
>   * rebase to v6.2-rc6
> 
> Steve Sistare (7):
>   vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
>   vfio/type1: prevent underflow of locked_vm via exec()
>   vfio/type1: track locked_vm per dma
>   vfio/type1: restore locked_vm
>   vfio/type1: revert "block on invalid vaddr"
>   vfio/type1: revert "implement notify callback"
>   vfio: revert "iommu driver notify callback"
> 
>  drivers/vfio/container.c        |   5 -
>  drivers/vfio/vfio.h             |   7 --
>  drivers/vfio/vfio_iommu_type1.c | 248 ++++++++++++++++++----------------------
>  include/uapi/linux/vfio.h       |  15 ++-
>  4 files changed, 120 insertions(+), 155 deletions(-)

LGTM, I'll pause to give Jason a chance to review as well.  Thanks for
working on this!

Alex

