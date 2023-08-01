Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CA676BD66
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 21:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjHATLD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 15:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjHATLC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 15:11:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6639270D
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 12:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690917016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D0EHS/9PYKBSPrHqlnfdbtoib24OB7i4qDBjrYiBM1c=;
        b=TrtKNAeycs8rbrom8F7g52QjCfjRx9Fu4FAfUgNBNZQptWYkBH/a9feoBlZbk/aZ19NE9k
        RuPmHMJESPQ7ZWEMthWbv2VijxzaFCp+9WZbGQET3xmskyAYilD1bhDvNHssZ/nXP/ULwt
        z8ZNEOcMqFlp2KH8HtqeY0MfRJ7iopY=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-GDpN1_LPO42YK0hIwLWjWQ-1; Tue, 01 Aug 2023 15:10:15 -0400
X-MC-Unique: GDpN1_LPO42YK0hIwLWjWQ-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7834a155749so574712039f.0
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 12:10:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690917015; x=1691521815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D0EHS/9PYKBSPrHqlnfdbtoib24OB7i4qDBjrYiBM1c=;
        b=REp6VJtwOcKdCKK4jLIu5UFxvG/WD3d96paWDhg9vD601PJIy+g6/j8EDbfLtqfZ3s
         9yeE+oj7Syl4xBdysnQ+aERzfLPnINme1Jo7OcVgjv3N6yUawenJ0YYoXhhQwBTv+seD
         9JOKpuOLUr7eXaXgkcwGREPRC0IX/LTgAQNogRo7kDUNcbeqwcQIJHgLJLWVrxlJxcgw
         M21Ql27ap72LcHQ84cn7kNP1V/fDwtzlymgwVi8oz5SRANV+RDHzuOpPVq79o81ZT1mT
         atBunn0ttLzBRM9XAOOZ10yKQG7/oc6Qdf8ahGcnu4UQIwHlnJROyl0zo/vr2RowbsqN
         BSyA==
X-Gm-Message-State: ABy/qLbjWHeCjZgNrd0TWX80/JQgz4m6HO3d7l/Yk2/yQT8zv83D7vvf
        frjBd06qsLnrzcA7N5+PaX090pbNc1UlQ6iT/asXs/YwsDitHlT59fM+cqtGbCyl5+cAeLvEGHi
        k+0FD5PKd6Z6s
X-Received: by 2002:a6b:d617:0:b0:787:1568:5df7 with SMTP id w23-20020a6bd617000000b0078715685df7mr13589479ioa.9.1690917014828;
        Tue, 01 Aug 2023 12:10:14 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGUynYPdIoMS8kN48J1fJkR5H7NuweqqWwvlYFWwtf/7xd42r68LGBZ8fmARXUsBJcjdQiaBQ==
X-Received: by 2002:a6b:d617:0:b0:787:1568:5df7 with SMTP id w23-20020a6bd617000000b0078715685df7mr13589468ioa.9.1690917014625;
        Tue, 01 Aug 2023 12:10:14 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id cg8-20020a0566381bc800b0041627abe120sm3936071jab.160.2023.08.01.12.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 12:10:14 -0700 (PDT)
Date:   Tue, 1 Aug 2023 13:10:13 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Ruan Jinjie <ruanjinjie@huawei.com>
Cc:     <jgg@ziepe.ca>, <kevin.tian@intel.com>,
        <reinette.chatre@intel.com>, <tglx@linutronix.de>,
        <abhsahu@nvidia.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH -next] vfio/pci: Remove an unnecessary ternary operator
Message-ID: <20230801131013.42f5604c.alex.williamson@redhat.com>
In-Reply-To: <20230801023122.3354175-1-ruanjinjie@huawei.com>
References: <20230801023122.3354175-1-ruanjinjie@huawei.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 1 Aug 2023 10:31:22 +0800
Ruan Jinjie <ruanjinjie@huawei.com> wrote:

> The true or false judgement of the ternary operator is unnecessary
> in C language semantics. So remove it to clean Code.
> 
> Signed-off-by: Ruan Jinjie <ruanjinjie@huawei.com>
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index cbb4bcbfbf83..2fd018e9b039 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -652,7 +652,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
>  {
>  	struct vfio_pci_irq_ctx *ctx;
>  	unsigned int i;
> -	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
> +	bool msix = index == VFIO_PCI_MSIX_IRQ_INDEX;

Perhaps not strictly required, but this really looks like it should keep
the parens around the test.  Thanks,

Alex

>  
>  	if (irq_is(vdev, index) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
>  		vfio_msi_disable(vdev, msix);

