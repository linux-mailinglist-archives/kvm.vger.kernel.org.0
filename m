Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60B6D543792
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 17:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244404AbiFHPiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 11:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244098AbiFHPh6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 11:37:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4CC43144BD1
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 08:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654702675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jxVgCrklswpT7+9OTco4k57y0oY6Ie2TEna3/n27Pv0=;
        b=EfWgQuBJRmd85MPGOna8ERjDS16DgomFKJs3YZWeZw0KYcQnUD22gKQQi6MeZeBBlNaTBc
        fwy9kIG9APSFDUt8/AJbIxOAcLhpasFWIwCOBpabFk9CQ9/yC/jpHTaw9tQR50H6w5+BFe
        uISe3gMyY4+23q5xCys5+dMfYHFKrZE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-1N_yXshMOpCapjyVnQXy2A-1; Wed, 08 Jun 2022 11:37:51 -0400
X-MC-Unique: 1N_yXshMOpCapjyVnQXy2A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7D3A801755;
        Wed,  8 Jun 2022 15:37:49 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.40])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F2111121314;
        Wed,  8 Jun 2022 15:37:49 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 6FB4818003AA; Wed,  8 Jun 2022 17:37:47 +0200 (CEST)
Date:   Wed, 8 Jun 2022 17:37:47 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        airlied@linux.ie, daniel@ffwll.ch, kvm@vger.kernel.org,
        Laszlo Ersek <lersek@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vfio/pci: Remove console drivers
Message-ID: <20220608153747.5d5h446vzbteqzwb@sirius.home.kraxel.org>
References: <165453797543.3592816.6381793341352595461.stgit@omen>
 <165453800875.3592816.12944011921352366695.stgit@omen>
 <0c45183c-cdb8-4578-e346-bc4855be038f@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c45183c-cdb8-4578-e346-bc4855be038f@suse.de>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> You shouldn't have to copy any of the implementation of the aperture
> helpers.

That comes from the aperture helpers being part of drm ...

> For patch 2, the most trivial workaround is to instanciate struct drm_driver
> here and set the name field to 'vdev->vdev.ops->name'. In the longer term,
> the aperture helpers will be moved out of DRM and into a more prominent
> location. That workaround will be cleaned up then.

... but if the long-term plan is to clean that up properly anyway I
don't see the point in bike shedding too much on the details of some
temporary solution.

> Alternatively, drm_aperture_remove_conflicting_pci_framebuffers() could be
> changed to accept the name string as second argument, but that's quite a bit
> of churn within the DRM code.

Also pointless churn because you'll have the very same churn again when
moving the aperture helpers out of drm.

take care,
  Gerd

