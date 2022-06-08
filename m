Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC718542BC2
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 11:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbiFHJpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 05:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235146AbiFHJoi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 05:44:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20C121C2D47
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 02:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654679475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0mce/AbWJS8N2abWnygb+NCcQbErCMoK/WZZka14SPg=;
        b=iy7d0tI8eb8VuTRieDamzmxEThZ7/PsniON5Y4wgIGuJCXwFkCin9u8wjq/QgYp5mf7R9+
        QabWiwBQBJu8Wi7Dxx09u8BJIyDFhiMZ6WDsp5xO7lQ5kPBCZpbv3HisMfx48NOWyRQKt1
        r6AiW0Nm+15UtrSrF0Kie6mwDN9Ltp8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-ecap_Jd4Puen-NXH4ANqQw-1; Wed, 08 Jun 2022 05:11:14 -0400
X-MC-Unique: ecap_Jd4Puen-NXH4ANqQw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8633685A583;
        Wed,  8 Jun 2022 09:11:13 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.40])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 49AFC40CF8E8;
        Wed,  8 Jun 2022 09:11:13 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id B2E2B18003AA; Wed,  8 Jun 2022 11:11:11 +0200 (CEST)
Date:   Wed, 8 Jun 2022 11:11:11 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Javier Martinez Canillas <javierm@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        kvm@vger.kernel.org, Laszlo Ersek <lersek@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Improve vfio-pci primary GPU assignment behavior
Message-ID: <20220608091111.wx2dbboxg2ntuapw@sirius.home.kraxel.org>
References: <165453797543.3592816.6381793341352595461.stgit@omen>
 <badc8e91-f843-2c96-9c02-4fbb59accdc4@redhat.com>
 <20220608074306.wyav3oerq5crdk6c@sirius.home.kraxel.org>
 <b8eee5a7-7428-fcfd-9266-fa63b9fde5e9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8eee5a7-7428-fcfd-9266-fa63b9fde5e9@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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

> >> But also, this issue isn't something that only affects graphic devices,
> >> right? AFAIU from [1] and [2], the same issue happens if a PCI device
> >> has to be bound to vfio-pci but already was bound to a host driver.
> > 
> > Nope.  There is a standard procedure to bind and unbind pci drivers via
> > sysfs, using /sys/bus/pci/drivers/$name/{bind,unbind}.
> >
> 
> Yes, but the cover letter says:
> 
> "Users often employ kernel command line arguments to disable conflicting
> drivers or perform unbinding in userspace to avoid this"

Thats helpful at times to deal with driver and/or hardware quirks.
Example: Years ago drm drivers used to be horrible when it came to
unbind, leaving oopses and panics left & right when you tried (luckily
it works much better these days).

[ leaving this here for completeness, snipping the remaining reply,
  noting that we are on the same page now ]

thanks & take care,
  Gerd

