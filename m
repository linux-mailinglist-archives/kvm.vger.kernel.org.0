Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0216F70E938
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 00:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234646AbjEWWn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 18:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238691AbjEWWnz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 18:43:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881C8C5
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 15:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684881788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TSzmRiQoN3lxJIxg8kAm83wUwxZmw5XdhOhZwpl0V28=;
        b=Jq+nDfXqcGl8s7/n0BMtHUxJhKMyg/hRI3VQqN3z9nj+QFFHpIw1iypaUiKHfSa8/9LfQ9
        KI/V5EO0SepeXm80yfaepRXx0e36h01Hz7Lb0BYyvbNggA2AOB+R6smk9Okxbcu6cbQMcH
        5FOYClew+XVUig1vFGyQofow9CPBCrE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-wyepOrXQOViNDpq0s_fMkg-1; Tue, 23 May 2023 18:43:07 -0400
X-MC-Unique: wyepOrXQOViNDpq0s_fMkg-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7741ff634beso47392039f.1
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 15:43:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684881786; x=1687473786;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TSzmRiQoN3lxJIxg8kAm83wUwxZmw5XdhOhZwpl0V28=;
        b=NWjVYDhAHDEK46cu0HYdSj/B3I8r3me0ApWLm0LR5HKtETDe89wqbHBCpJ4SZVfhLZ
         EkMP+U2YFnoTTBhGDmyjVFgFmbTDj/A8nAYRXfd5qyt5hyThrdL3G7AjBONkqfKIXQvS
         0/2BFREoSrwnfVo+Rzb0LkBF4TmOa4E7KSlncSBx1IT+NijRCgqN/pAo+luwtFqMZhYp
         mE5gWjZewEb4hfB/n0TbphxMlgmNuqL1yVSqOjvt1rgciXjliokwwDGX6J7NvNiSJkzj
         w+J2tjW/+UgF1+hdZunI3Ux1O3gHLJA+AAlu5unIPA1m9tvGKqIzJ1Hn4xHkEv0PXThf
         /+NA==
X-Gm-Message-State: AC+VfDwvS7Wh5B8wWNIC0PwueTFNIhm1/qwPPAZSGEIzImuNZi3DIjKc
        nvGEQph2+P/uLh1c1nv8PM43Bcw/mTAbkv1prAiPy+32oSuGn4xnNEpzpAWojnQmY8Hgm9dPC+y
        74mKh5BmgGlrb
X-Received: by 2002:a92:dac4:0:b0:33a:1a98:559a with SMTP id o4-20020a92dac4000000b0033a1a98559amr4920800ilq.2.1684881786628;
        Tue, 23 May 2023 15:43:06 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4b+aQzz2DnzFNkR+Bj05IWFUL+8VGC71F0EMNYQEqdQa986EqKzhnUqEEerN1QrD6WVL79Gw==
X-Received: by 2002:a92:dac4:0:b0:33a:1a98:559a with SMTP id o4-20020a92dac4000000b0033a1a98559amr4920794ilq.2.1684881786397;
        Tue, 23 May 2023 15:43:06 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id o4-20020a92c684000000b0033842c3f6b4sm2684497ilg.83.2023.05.23.15.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 15:43:05 -0700 (PDT)
Date:   Tue, 23 May 2023 16:43:04 -0600
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
Message-ID: <20230523164304.6b0fb03b.alex.williamson@redhat.com>
In-Reply-To: <20230504131654.24922-1-oleksandr@natalenko.name>
References: <20230504131654.24922-1-oleksandr@natalenko.name>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

Applied to vfio next branch for v6.5.  Thanks!

Alex

