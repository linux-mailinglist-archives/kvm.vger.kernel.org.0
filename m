Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C20F546856
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 16:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245156AbiFJOax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 10:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242574AbiFJOau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 10:30:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 678D819C38
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 07:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654871440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g/ATkA29NC2oD/Jp54XfWVa6EbDzgeGcRbqECMdYNQQ=;
        b=jJawV6V17jN+4Baj+0GOF0VlCJiumcDu95kndkYiX/rrkws39ublNHXrES7oj+wQrNZWwc
        7QYYBf7sFL+Zmws62SAUte1YtebfyVhEevZJVsJRhnFgvyGoTz7MNILK6b1KvbeaVqUXTz
        ozZTKUQitij0aaysMrva7JH3Mq9IE3Q=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-KmF2v-TrOuO03lVC9fEHcg-1; Fri, 10 Jun 2022 10:30:38 -0400
X-MC-Unique: KmF2v-TrOuO03lVC9fEHcg-1
Received: by mail-io1-f70.google.com with SMTP id i126-20020a6bb884000000b006691e030971so10896259iof.15
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 07:30:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=g/ATkA29NC2oD/Jp54XfWVa6EbDzgeGcRbqECMdYNQQ=;
        b=5up1oOXt7n+CW2fo3Gg/BqNU3+zQivdUOJG4HOl7h/PYZMWAxnUl+yNwxTTleTheX9
         5xyTEmHx1Eoa9RlMNGEIh/GQxYBGTLVD9PdEJUOzs9/ENYXWn6keDSr4Zma3+GaJa224
         TB2pQfkblzl/NfSacTySLC2a9oL6CPLBS2ljWP2KZcN/S9QF8umiRd9/vprK6p6eQ9EM
         gQR/kiTHQeXn5ThoS0/B0f2oXL3eAQ9+259mQzCyM13n5Ex+0uqnRefhn/NWtjU7zZ/O
         HP/uN2VZ/VzBC5dIkiYUV2XeOjO0AbkSycKotZQp1DePOBakgYdSRUFeLDxiQZkNxn7g
         qXtg==
X-Gm-Message-State: AOAM531Ng9rrIdxatYLcyEpNjPUsYMpwFGzPqiAiHP1bOcB/pPqlzW2b
        jJUoaqFrYl+M78iiI3cDltWYDb1Ue0byNluMOv+JhI6HlCR/38zOQpMW09CW0lEM09nXAaIztwv
        No4HXIr/PsLQc
X-Received: by 2002:a02:9f14:0:b0:331:9195:dd3e with SMTP id z20-20020a029f14000000b003319195dd3emr16642779jal.0.1654871438187;
        Fri, 10 Jun 2022 07:30:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuksuRngDSTwfthGPHYoV3J/PiHhBjlEWnHC4GjZIaz8XTqKR8K8VGTwh5fbuBCpB4djwCgg==
X-Received: by 2002:a02:9f14:0:b0:331:9195:dd3e with SMTP id z20-20020a029f14000000b003319195dd3emr16642758jal.0.1654871437955;
        Fri, 10 Jun 2022 07:30:37 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w15-20020a056e0213ef00b002d65eedd403sm4127189ilj.71.2022.06.10.07.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 07:30:37 -0700 (PDT)
Date:   Fri, 10 Jun 2022 08:30:33 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     kvm@vger.kernel.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>
Subject: Re: [PATCH 2/2] vfio/pci: Remove console drivers
Message-ID: <20220610083033.3f98beae.alex.williamson@redhat.com>
In-Reply-To: <b13d6d73-6290-92b6-d2b3-62af6efef3dc@suse.de>
References: <165453797543.3592816.6381793341352595461.stgit@omen>
        <165453800875.3592816.12944011921352366695.stgit@omen>
        <0c45183c-cdb8-4578-e346-bc4855be038f@suse.de>
        <20220608080432.45282f0b.alex.williamson@redhat.com>
        <01c74525-38b7-1e00-51ba-7cd793439f03@suse.de>
        <20220609154102.5cb1d3ca.alex.williamson@redhat.com>
        <20220609154416.676b1068.alex.williamson@redhat.com>
        <b13d6d73-6290-92b6-d2b3-62af6efef3dc@suse.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Jun 2022 09:03:15 +0200
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> Hi
> 
> Am 09.06.22 um 23:44 schrieb Alex Williamson:
> > On Thu, 9 Jun 2022 15:41:02 -0600
> > Alex Williamson <alex.williamson@redhat.com> wrote:
> >   
> >> On Thu, 9 Jun 2022 11:13:22 +0200
> >> Thomas Zimmermann <tzimmermann@suse.de> wrote:  
> >>>
> >>> Please have a look at the attached patch. It moves the aperture helpers
> >>> to a location common to the various possible users (DRM, fbdev, vfio).
> >>> The DRM interfaces remain untouched for now.  The patch should provide
> >>> what you need in vfio and also serve our future use cases for graphics
> >>> drivers. If possible, please create your patch on top of it.  
> >>
> >> Looks good to me, this of course makes the vfio change quite trivial.
> >> One change I'd request:
> >>
> >> diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
> >> index 40c50fa2dd70..7f3c44e1538b 100644
> >> --- a/drivers/video/console/Kconfig
> >> +++ b/drivers/video/console/Kconfig
> >> @@ -10,6 +10,7 @@ config VGA_CONSOLE
> >>   	depends on !4xx && !PPC_8xx && !SPARC && !M68K && !PARISC &&  !SUPERH && \
> >>   		(!ARM || ARCH_FOOTBRIDGE || ARCH_INTEGRATOR || ARCH_NETWINDER) && \
> >>   		!ARM64 && !ARC && !MICROBLAZE && !OPENRISC && !S390 && !UML
> >> +	select APERTURE_HELPERS if (DRM || FB || VFIO_PCI)
> >>   	default y
> >>   	help
> >>   	  Saying Y here will allow you to use Linux in text mode through a
> >>
> >> This should be VFIO_PCI_CORE.  Thanks,  
> 
> I attached an updated patch to this email.
> 
> > 
> > Also, whatever tree this lands in, I'd appreciate a topic branch being
> > made available so I can more easily get the vfio change in on the same
> > release.  Thanks,  
> 
> You can add my patch to your series and merge it through vfio. You'd 
> only have to cc dri-devel for the patch's review. I guess it's more 
> important for vfio than DRM. We have no hurry on the DRM side, but v5.20 
> would be nice.

Ok, I didn't realize you were offering the patch for me to post and
merge.  I'll do that.  Thanks!

Alex

