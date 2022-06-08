Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA74543232
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 16:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241163AbiFHOEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 10:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237864AbiFHOEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 10:04:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4F1522C497
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 07:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654697076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1BWR1iPg67/76Jhn7RzCgMANX3cJBPsC3uFhzpZxFQg=;
        b=JQ/dMCteKBrwS22569/BX/1BQLkWkjny7cUInfgXplaKksPSomi5JKsAy8p46cXJT4KnDj
        QPp9szW9GcwdMdQEcNwic0oNkWPevlbCRSBNMJttFR7faHHXFB5XoMGGlHAOa8H+G+VUeH
        w9LujxpiUyA0uw92I3vX16R4BISAWXU=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-x8XSgqp9MnGinlKUyAEFQw-1; Wed, 08 Jun 2022 10:04:35 -0400
X-MC-Unique: x8XSgqp9MnGinlKUyAEFQw-1
Received: by mail-il1-f198.google.com with SMTP id i16-20020a056e021d1000b002d3bbe39232so15765942ila.20
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 07:04:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=1BWR1iPg67/76Jhn7RzCgMANX3cJBPsC3uFhzpZxFQg=;
        b=p/KmQGFr3ADWlwTD02wDRuiqeVkd0LVYiktkHcGsRSa53a2sq+SiaMR4rfQpOzkSyh
         +w1KxLtMJxK59U5gBr7NcubGHjbWZR6KPLZhDxshYRH6fBBpopIffOJncExeVk9Jn094
         bOdTP9kzBPVFmGq5oXL45CrxKRHqNq2+20P+UCjMGepJEP/dC0hLcBtKPWDd99KwmIdR
         yrywnCduiDcrMl+DKGul1Vm52XEvzmS6sDPL8e6owkvsFxKwKgf9Ts+Vd77vjvROj52W
         zjwHKF9f3R+dMA5kKZJ6Cp8GvI1J75h8/uWLgwsSSCyC14JqVPMFv4GA9i819cCJuJUk
         BniA==
X-Gm-Message-State: AOAM530mtXfpXNueyRVquAYa7D+V6Lt4npVf/49bXSYOM7MKFrRZWZtR
        L1KyvOoE33hB84e2cslqqGfaKbH5Iuk0iFMS9FT6i/ym0zDlrhCc1j5zqGrRIsLUpEs/r4LRu6S
        cT3NEm0sqxcyb
X-Received: by 2002:a02:1105:0:b0:330:ec01:f04c with SMTP id 5-20020a021105000000b00330ec01f04cmr18109731jaf.87.1654697074888;
        Wed, 08 Jun 2022 07:04:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcbsemhYPtEW2RxxzY4T+70hTn6dNmp2D9+a0WEnP5LfYkb7EKVi/XVLp74c1u9qpmBliF3w==
X-Received: by 2002:a02:1105:0:b0:330:ec01:f04c with SMTP id 5-20020a021105000000b00330ec01f04cmr18109717jaf.87.1654697074610;
        Wed, 08 Jun 2022 07:04:34 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m19-20020a02c893000000b00331b5a2c5d4sm3248455jao.164.2022.06.08.07.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 07:04:34 -0700 (PDT)
Date:   Wed, 8 Jun 2022 08:04:32 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vfio/pci: Remove console drivers
Message-ID: <20220608080432.45282f0b.alex.williamson@redhat.com>
In-Reply-To: <0c45183c-cdb8-4578-e346-bc4855be038f@suse.de>
References: <165453797543.3592816.6381793341352595461.stgit@omen>
        <165453800875.3592816.12944011921352366695.stgit@omen>
        <0c45183c-cdb8-4578-e346-bc4855be038f@suse.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On Wed, 8 Jun 2022 13:11:21 +0200
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> Hi Alex
> 
> Am 06.06.22 um 19:53 schrieb Alex Williamson:
> > Console drivers can create conflicts with PCI resources resulting in
> > userspace getting mmap failures to memory BARs.  This is especially evident
> > when trying to re-use the system primary console for userspace drivers.
> > Attempt to remove all nature of conflicting drivers as part of our VGA
> > initialization.  
> 
> First a dumb question about your use case.  You want to assign a PCI 
> graphics card to a virtual machine and need to remove the generic driver 
> from the framebuffer?

Exactly.
 
> > Reported-by: Laszlo Ersek <lersek@redhat.com>
> > Tested-by: Laszlo Ersek <lersek@redhat.com>
> > Suggested-by: Gerd Hoffmann <kraxel@redhat.com>
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >   drivers/vfio/pci/vfio_pci_core.c |   17 +++++++++++++++++
> >   1 file changed, 17 insertions(+)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> > index a0d69ddaf90d..e0cbcbc2aee1 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -13,6 +13,7 @@
> >   #include <linux/device.h>
> >   #include <linux/eventfd.h>
> >   #include <linux/file.h>
> > +#include <linux/fb.h>
> >   #include <linux/interrupt.h>
> >   #include <linux/iommu.h>
> >   #include <linux/module.h>
> > @@ -29,6 +30,8 @@
> >   
> >   #include <linux/vfio_pci_core.h>
> >   
> > +#include <drm/drm_aperture.h>
> > +
> >   #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
> >   #define DRIVER_DESC "core driver for VFIO based PCI devices"
> >   
> > @@ -1793,6 +1796,20 @@ static int vfio_pci_vga_init(struct vfio_pci_core_device *vdev)
> >   	if (!vfio_pci_is_vga(pdev))
> >   		return 0;
> >   
> > +#if IS_REACHABLE(CONFIG_DRM)
> > +	drm_aperture_detach_platform_drivers(pdev);
> > +#endif
> > +
> > +#if IS_REACHABLE(CONFIG_FB)
> > +	ret = remove_conflicting_pci_framebuffers(pdev, vdev->vdev.ops->name);
> > +	if (ret)
> > +		return ret;
> > +#endif
> > +
> > +	ret = vga_remove_vgacon(pdev);
> > +	if (ret)
> > +		return ret;
> > +  
> 
> You shouldn't have to copy any of the implementation of the aperture 
> helpers.
> 
> If you call drm_aperture_remove_conflicting_pci_framebuffers() it should 
> work correctly. The only reason why it requires a DRM driver structure 
> as second argument is for the driver's name. [1] And that name is only 
> used for printing an info message. [2]

vfio-pci is not dependent on CONFIG_DRM, therefore we need to open code
this regardless.  The only difference if we were to use the existing
function would be something like:

#if IS_REACHABLE(CONFIG_DRM)
	ret = drm_aperture_remove_conflicting_pci_framebuffers(pdev, &dummy_drm_driver);
	if (ret)
		return ret;
#else
#if IS_REACHABLE(CONFIG_FB)
	ret = remove_conflicting_pci_framebuffers(pdev, vdev->vdev.ops->name);
	if (ret)
		return ret;
#endif
	ret = vga_remove_vgacon(pdev);
	if (ret)
		return ret;
#endif

It's also bad practice to create a dummy DRM driver struct with some
assumption which fields are used.  If the usage is later expanded, we'd
only discover it by users getting segfaults.  If DRM wanted to make
such an API guarantee, then we shouldn't have commit 97c9bfe3f660
("drm/aperture: Pass DRM driver structure instead of driver name").

> The plan forward would be to drop patch 1 entirely.
> 
> For patch 2, the most trivial workaround is to instanciate struct 
> drm_driver here and set the name field to 'vdev->vdev.ops->name'. In the 
> longer term, the aperture helpers will be moved out of DRM and into a 
> more prominent location. That workaround will be cleaned up then.

Trivial in execution, but as above, this is poor practice and should be
avoided.

> Alternatively, drm_aperture_remove_conflicting_pci_framebuffers() could 
> be changed to accept the name string as second argument, but that's 
> quite a bit of churn within the DRM code.

The series as presented was exactly meant to provide the most correct
solution with the least churn to the DRM code.  The above referenced
commit precludes us from calling the existing DRM function directly
without resorting to poor practices of assuming the usage of the DRM
driver struct.  Using the existing DRM function also does not prevent
us from open coding the remainder of the function to avoid a CONFIG_DRM
dependency.  Thanks,

Alex

