Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E175A6F7988
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 01:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjEDXCF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 19:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjEDXCD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 19:02:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E978211D80
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 16:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683241277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lkwlQPMGMIxAlMZp1ec5I95UHcrfctVyRuyNlrEK4fQ=;
        b=LXla+pIW4PwV0VeYWzLbfjf6JXM4OlRyR3gTGsJd+ylCv0DC0g75xEwcN3A7OCS+1nQP86
        bSad2wsROYyT0htg3qUc0Qt07cGXr2PKpBN4eBZlxVbiLK8+BfjaJwM3V7MeG8Ypkr45rV
        hgorbI7nwUCOSFBELJlaJ0hW+N77n94=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-AHKeJlluO2W5TuFSt0nqBA-1; Thu, 04 May 2023 19:01:15 -0400
X-MC-Unique: AHKeJlluO2W5TuFSt0nqBA-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-33159dbb32aso15678925ab.2
        for <kvm@vger.kernel.org>; Thu, 04 May 2023 16:01:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683241274; x=1685833274;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lkwlQPMGMIxAlMZp1ec5I95UHcrfctVyRuyNlrEK4fQ=;
        b=konNv6wu1bDMyDqEaiKn4gt0PH1KB9x6qS7WNG3BD24LVEMkMeJ3GdDQ4Lu+BWb6C3
         NtzPkY1dO64f2Y3KUR7iCXvtaLutmlrxzihbq0XWR06HMcA5CRqwjzIDt90O2eSKHOg9
         Q1GVGpsvR4WUDaT2L6qDgoRKf8ELE+EA/2fnvgldU+K2XGr0knVNCevFiveSBGWol4Ik
         JgHTxCq9Roeutcmz8xzYZ9mYFc0RuXq4pvyflxs+Gg0r5rI6BcPePa6hZgclrRI3267O
         9o4DY1eU4ZFIzNwaT41/be1kiAGvucSZQF89BHf+Y+4Ah33+Gzg7+BSJEGncqLnDfgzx
         zduw==
X-Gm-Message-State: AC+VfDwARqQJtxczrRbWxlbVYjWZpDLhoqb7iK+X9fTbSJKwVZ/HCzu3
        KElEZFjgxfYanBP6mkX6Tol4sFN7Cvb5NeMMF1TrMNXD8n94QhGhy3kYLlWU6867A0qHsRGK9pr
        LKPEtjdV2oL80
X-Received: by 2002:a05:6e02:146:b0:331:3564:7834 with SMTP id j6-20020a056e02014600b0033135647834mr315427ilr.18.1683241274344;
        Thu, 04 May 2023 16:01:14 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7joMrRtHf14hwBbCTLXHwHP/1+v9CBqB712KbTwQW+NU3pHYjDHXwtRYc/cTXA3sw36Qzx2Q==
X-Received: by 2002:a05:6e02:146:b0:331:3564:7834 with SMTP id j6-20020a056e02014600b0033135647834mr315410ilr.18.1683241274089;
        Thu, 04 May 2023 16:01:14 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id y9-20020a92c749000000b00325de773339sm68010ilp.64.2023.05.04.16.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 16:01:13 -0700 (PDT)
Date:   Thu, 4 May 2023 17:01:11 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     linux-kernel@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>, Bo Liu <liubo03@inspur.com>,
        "K V P, Satyanarayana" <satyanarayana.k.v.p@intel.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: demote hiding ecap messages to debug level
Message-ID: <20230504170111.70a7f639.alex.williamson@redhat.com>
In-Reply-To: <20230504131654.24922-1-oleksandr@natalenko.name>
References: <20230504131654.24922-1-oleksandr@natalenko.name>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  4 May 2023 15:16:54 +0200
Oleksandr Natalenko <oleksandr@natalenko.name> wrote:

> Seeing a burst of messages like this:
> 
>     vfio-pci 0000:98:00.0: vfio_ecap_init: hiding ecap 0x19@0x1d0
>     vfio-pci 0000:98:00.0: vfio_ecap_init: hiding ecap 0x25@0x200
>     vfio-pci 0000:98:00.0: vfio_ecap_init: hiding ecap 0x26@0x210
>     vfio-pci 0000:98:00.0: vfio_ecap_init: hiding ecap 0x27@0x250
>     vfio-pci 0000:98:00.1: vfio_ecap_init: hiding ecap 0x25@0x200
>     vfio-pci 0000:b1:00.0: vfio_ecap_init: hiding ecap 0x19@0x1d0
>     vfio-pci 0000:b1:00.0: vfio_ecap_init: hiding ecap 0x25@0x200
>     vfio-pci 0000:b1:00.0: vfio_ecap_init: hiding ecap 0x26@0x210
>     vfio-pci 0000:b1:00.0: vfio_ecap_init: hiding ecap 0x27@0x250
>     vfio-pci 0000:b1:00.1: vfio_ecap_init: hiding ecap 0x25@0x200
> 
> is of little to no value for an ordinary user.
> 
> Hence, use pci_dbg() instead of pci_info().
> 
> Signed-off-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 948cdd464f4e..dd8dda14e701 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1643,7 +1643,7 @@ static int vfio_ecap_init(struct vfio_pci_core_device *vdev)
>  		}
>  
>  		if (!len) {
> -			pci_info(pdev, "%s: hiding ecap %#x@%#x\n",
> +			pci_dbg(pdev, "%s: hiding ecap %#x@%#x\n",
>  				 __func__, ecap, epos);
>  
>  			/* If not the first in the chain, we can skip over it */

Looks fine to me, though I might adjust that next line to keep the
previous alignment.  In general this has certainly caused more
confusion than insightful information, so demoting it to debug is a
good idea.  Thanks,

Alex

