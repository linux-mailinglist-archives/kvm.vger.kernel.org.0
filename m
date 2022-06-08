Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3593B542917
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 10:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiFHIPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 04:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbiFHIO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 04:14:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 982D33223AD
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 00:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654674194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AH2f+hvLt6o5Ulhr8X9RVVcxLh1vpT+51fFKDTk13/I=;
        b=aN2Z9Satxw//fpC2b1syoYP7euJ/4D9Bynrw0JljKzc+J0SxPs8ov0t7Md1BWS/b5a0I3Y
        AUStd2sx//41502//5G7sDqIOvNSvDHPYYeaWXJ/zDfQ37wEC2Gv3BNVQRzc4lOy9viddk
        F9BhQe5TSJ6pgMEb1hyBXGeOA222g+I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-1GjcdoIZO0eu-TsxarhuMw-1; Wed, 08 Jun 2022 03:43:09 -0400
X-MC-Unique: 1GjcdoIZO0eu-TsxarhuMw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00FB1800971;
        Wed,  8 Jun 2022 07:43:09 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.40])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A2D67400F3FF;
        Wed,  8 Jun 2022 07:43:08 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id C8C3E18003AA; Wed,  8 Jun 2022 09:43:06 +0200 (CEST)
Date:   Wed, 8 Jun 2022 09:43:06 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Javier Martinez Canillas <javierm@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        kvm@vger.kernel.org, Laszlo Ersek <lersek@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Improve vfio-pci primary GPU assignment behavior
Message-ID: <20220608074306.wyav3oerq5crdk6c@sirius.home.kraxel.org>
References: <165453797543.3592816.6381793341352595461.stgit@omen>
 <badc8e91-f843-2c96-9c02-4fbb59accdc4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <badc8e91-f843-2c96-9c02-4fbb59accdc4@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> But also, this issue isn't something that only affects graphic devices,
> right? AFAIU from [1] and [2], the same issue happens if a PCI device
> has to be bound to vfio-pci but already was bound to a host driver.

Nope.  There is a standard procedure to bind and unbind pci drivers via
sysfs, using /sys/bus/pci/drivers/$name/{bind,unbind}.

> The fact that DRM happens to have some infrastructure to remove devices
> that conflict with an aperture is just a coincidence.

No.  It's a consequence of firmware framebuffers not being linked to the
pci device actually backing them, so some other way is needed to find
and solve conflicts.

> The series [0] mentioned above, adds a sysfb_disable() that disables the
> Generic System Framebuffer logic that is what registers the framebuffer
> devices that are bound to these generic video drivers. On disable, the
> devices registered by sysfb are also unregistered.

As Alex already mentioned this might not have the desired effect on
systems with multiple GPUs (I think even without considering vfio-pci).

> That is, do you want to remove the {vesa,efi,simple}fb and simpledrm
> drivers or is there a need to also remove real fbdev and DRM drivers?

Boot framebuffers are the problem because they are neither visible nor
manageable in /sys/bus/pci.  For real fbdev/drm drivers the standard pci
unbind can be used.

take care,
  Gerd

