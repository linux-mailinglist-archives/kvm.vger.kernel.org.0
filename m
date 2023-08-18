Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA3C780FC9
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 18:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378296AbjHRQEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 12:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378215AbjHRQEC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 12:04:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4913ABC
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 09:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692374595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZOwivL5hPjf3enggmdWvz+d+kv6iaMBuCWFieMfJPgw=;
        b=fNCV4zB27M5465QzKUPbDoeqT48gwiRdE/4CuRC0P80s+UlrlBfmI4UeICqjxbxuvXVHvn
        B/5UqBsofBemSALqXlrM7O31ZXfU41m/uG+bfyoXlS633REw5au93yEtvOAYMmF7Rz+KTW
        wGl93rpDdmePIf6GiNBysiVS8r7CvJM=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-Ov2eQLbTNdmvSUiZmKGP_g-1; Fri, 18 Aug 2023 12:03:14 -0400
X-MC-Unique: Ov2eQLbTNdmvSUiZmKGP_g-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-187959a901eso1209974fac.0
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 09:03:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692374593; x=1692979393;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZOwivL5hPjf3enggmdWvz+d+kv6iaMBuCWFieMfJPgw=;
        b=OygCqHiLTGC0Ir5nA2av2/UW6Pkcg1VJZ1BN22CPiv2fqXOUUZSGiULFL/PAarCaab
         A5MJgnU0IHpWKYB/ICF70eJllEB4pCZkH/GCfAk/dzhBVxr1DNPRW7QlYeKecD/wKvE2
         IrlNtlaJMM/lwbbMNWgiS1xnSW9eeM+QhW/mQa+yd4l0INl1vU7UJcplNBn/mCisXxwu
         AAsa8oncX9vOlsUeH8b3QyRdHMbvXXzNw0bgMEl03tlTDdaPNA/+tpIy2FFs1VjMbPTb
         6yCABpC8PBwIRCQ968rVG8D18AEPq5llFSS05VdHzgmSvtzYDBvp8e4f6kihQAgDUGXg
         4c6w==
X-Gm-Message-State: AOJu0Yx6HJ2vx1UDqsF7QJKahl5tFuxuK9Kst8/22LskxZc/CjnbgaDW
        AjF67lKrIneWLOv8GFgnIwd7GfvIaUnczkPidczHEgMYbX7WVZKDBqbzg1SelOO1SHYEm0NRB8g
        44b/qXrx7Ww8lMttYo5gE
X-Received: by 2002:a05:6870:968b:b0:1c0:5f7a:896f with SMTP id o11-20020a056870968b00b001c05f7a896fmr3650072oaq.8.1692374593235;
        Fri, 18 Aug 2023 09:03:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFMEr5/8Kjr9l1rfUv7FPHPRFH09lyQM8bg/cbrEPzM9NzoBWYQn+zHKcGFyT/Ylt4jvRYfIw==
X-Received: by 2002:a05:6870:968b:b0:1c0:5f7a:896f with SMTP id o11-20020a056870968b00b001c05f7a896fmr3650036oaq.8.1692374592796;
        Fri, 18 Aug 2023 09:03:12 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id z7-20020a9d65c7000000b006b95e17fcc7sm974660oth.49.2023.08.18.09.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 09:03:12 -0700 (PDT)
Date:   Fri, 18 Aug 2023 10:03:10 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <jgg@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <shannon.nelson@amd.com>
Subject: Re: [PATCH vfio] pds_core: Fix function header descriptions
Message-ID: <20230818100310.71be85f8.alex.williamson@redhat.com>
In-Reply-To: <20230818091705.7e4d7d0e.alex.williamson@redhat.com>
References: <20230817224212.14266-1-brett.creeley@amd.com>
        <20230818091705.7e4d7d0e.alex.williamson@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 18 Aug 2023 09:17:05 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Thu, 17 Aug 2023 15:42:12 -0700
> Brett Creeley <brett.creeley@amd.com> wrote:
> 
> > The pds-vfio-pci series made a small interface change to
> > pds_client_register() and pds_client_unregister(), but forgot to update
> > the function header descriptions. Fix that.
> > 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202308180411.OSqJPtMz-lkp@intel.com/
> > Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> > Signed-off-by: Brett Creeley <brett.creeley@amd.com>  
> 
> I think we also want:
> 
> Fixes: b021d05e106e ("pds_core: Require callers of register/unregister to pass PF drvdata")
> 
> I'll add that on commit.  Thanks,

Applied to vfio next branch for v6.6.  Thanks,

Alex

> > ---
> >  drivers/net/ethernet/amd/pds_core/auxbus.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
> > index 63d28c0a7e08..4ebc8ad87b41 100644
> > --- a/drivers/net/ethernet/amd/pds_core/auxbus.c
> > +++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
> > @@ -8,7 +8,7 @@
> >  
> >  /**
> >   * pds_client_register - Link the client to the firmware
> > - * @pf_pdev:	ptr to the PF driver struct
> > + * @pf:		ptr to the PF driver's private data struct
> >   * @devname:	name that includes service into, e.g. pds_core.vDPA
> >   *
> >   * Return: 0 on success, or
> > @@ -48,7 +48,7 @@ EXPORT_SYMBOL_GPL(pds_client_register);
> >  
> >  /**
> >   * pds_client_unregister - Unlink the client from the firmware
> > - * @pf_pdev:	ptr to the PF driver struct
> > + * @pf:		ptr to the PF driver's private data struct
> >   * @client_id:	id returned from pds_client_register()
> >   *
> >   * Return: 0 on success, or  
> 

