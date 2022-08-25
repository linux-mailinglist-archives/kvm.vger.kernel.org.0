Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1DE5A1ABA
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 23:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243539AbiHYVB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 17:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243443AbiHYVBh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 17:01:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155BE255BB
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 14:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661461291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OKHhMLBTBc7z1ahPgLZl8Wpxc7AkNqzPxKKC/XdmrI8=;
        b=OeR6+N3B4mSWKb5YfywLCNfRbPwmixaEP0B0HLqIrK7v+NWzyaueco3CPCYHca9Wj/qMFQ
        h3OfCCuhjlQ6TGlPLIoWo094eZ2fjePoTpVIDAI2xa/ITflJfj7haydto27JhSG3Je8Rzu
        PZWP+LKWdADT42BwzOxtYV7mYcwhsGE=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-543-qAoJOsjHNqaU_1DdywrL1Q-1; Thu, 25 Aug 2022 17:01:29 -0400
X-MC-Unique: qAoJOsjHNqaU_1DdywrL1Q-1
Received: by mail-io1-f71.google.com with SMTP id n23-20020a056602341700b00689fc6dbfd6so7585085ioz.8
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 14:01:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=OKHhMLBTBc7z1ahPgLZl8Wpxc7AkNqzPxKKC/XdmrI8=;
        b=wKt3R1AS2abwZlYkzUqbqVGPRNwDSIGY/JMa2jraX9YJj5g/+JLQtRTaSmY3w+At32
         lNG6g1c6Rpqy8nBeIe1GaeGXMyV9gmYYf8Q4I3O4wxiXtAqADtZkLGK2QdhhX9YTfuyp
         wEqlK73b4frql03QgsuRRa6Djy00lV3kgj/DyZJcPPps6yCiBaEv1NSyNf0HzZRWu3Hy
         /EwaifmZkElrO9j/H4L1Bszu2VZUly50pq0LkWNnRkub7AFS9RgD6dTqxqmDN+DV4VNd
         akPXIsQw2UDp9VtxNVoMkmvcGESuQ8Q6TCfazIFJ0yPGkvLMrUTrSFiIVZYeIMOPH2Bg
         BqVQ==
X-Gm-Message-State: ACgBeo2P8S6fLCDMMHkceF8ALB4Djdbmqf88y5jy1bOKo4jM257EMity
        RAFU++fmX4Reg51npOjv+4y/qr/MKMAx0O30TrgMx2iXtALcLOcvWjEyGl9j8GHg5eL05Jw0wPB
        7fOmfxsYaoP0D
X-Received: by 2002:a05:6e02:19ca:b0:2df:68c:4a6d with SMTP id r10-20020a056e0219ca00b002df068c4a6dmr2807782ill.32.1661461289400;
        Thu, 25 Aug 2022 14:01:29 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7tH05EvuWkAeSRoDzBJje/R1t2yMeiHm8bKWbff2546DI6fNku1uSRwrQ1TK3phaPzVrsdXw==
X-Received: by 2002:a05:6e02:19ca:b0:2df:68c:4a6d with SMTP id r10-20020a056e0219ca00b002df068c4a6dmr2807776ill.32.1661461289143;
        Thu, 25 Aug 2022 14:01:29 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id k34-20020a026622000000b00349bbbdcb95sm167663jac.42.2022.08.25.14.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 14:01:28 -0700 (PDT)
Date:   Thu, 25 Aug 2022 15:01:27 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Diana Craciun <diana.craciun@oss.nxp.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2] vfio/fsl-mc: Fix a typo in a message
Message-ID: <20220825150127.1fd3a8d4.alex.williamson@redhat.com>
In-Reply-To: <87y1vgocsi.fsf@redhat.com>
References: <3d2aa8434393ee8d2aa23a620e59ce1059c9d7ad.1660663440.git.christophe.jaillet@wanadoo.fr>
        <87y1vgocsi.fsf@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Aug 2022 11:19:57 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Tue, Aug 16 2022, Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:
> 
> > L and S are swapped in the message.
> > s/VFIO_FLS_MC/VFIO_FSL_MC/
> >
> > Also use WARN instead of WARN_ON+dev_warn because WARN can already print
> > the message.
> >
> > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > ---
> > Changes in v2:
> >   * s/comment/message/ in the subject   [Cornelia Huck <cohuck@redhat.com>]
> >   * use WARN instead of WARN_ON+dev_warn   [Jason Gunthorpe <jgg@ziepe.ca>]
> >
> > v1:
> >   https://lore.kernel.org/all/2b65bf8d2b4d940cafbafcede07c23c35f042f5a.1659815764.git.christophe.jaillet@wanadoo.fr/
> > ---
> >  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> > index 3feff729f3ce..57774009e0eb 100644
> > --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> > +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> > @@ -108,9 +108,7 @@ static void vfio_fsl_mc_close_device(struct vfio_device *core_vdev)
> >  	/* reset the device before cleaning up the interrupts */
> >  	ret = vfio_fsl_mc_reset_device(vdev);
> >  
> > -	if (WARN_ON(ret))
> > -		dev_warn(&mc_cont->dev,
> > -			 "VFIO_FLS_MC: reset device has failed (%d)\n", ret);
> > +	WARN(ret, "VFIO_FSL_MC: reset device has failed (%d)\n", ret);  
> 
> Hm, but this drops the device information, not such a fan... maybe the
> author can chime in?

Diana, what do you want to do here?  Thanks,

Alex

