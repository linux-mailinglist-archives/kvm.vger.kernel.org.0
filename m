Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B19E540867
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 19:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349011AbiFGR6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 13:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348948AbiFGR5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 13:57:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36C8544A0C
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 10:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654623645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8C0NEBO/ea6+vfvU3O1/xfsUBzcZiJoiCFBeBhlMW4s=;
        b=FZQX3RouvbJMgGfzpBflRNhBCfCs7lbrsf25cf/MCDxWONo0H5Ejn/PPM6j88cQd0e+pt7
        0GZ1BQFKu7QGi/dapdE5rIdXZDFht4quwjqsfFE6lYnnOxYe6Iq7wV2SJtofVg82a02GTF
        XOmOMTl8fDeK8RPjK8r039XULw6DiPA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-zPPeViMvN4agSWiu55YeMw-1; Tue, 07 Jun 2022 13:40:43 -0400
X-MC-Unique: zPPeViMvN4agSWiu55YeMw-1
Received: by mail-wm1-f71.google.com with SMTP id u12-20020a05600c19cc00b0038ec265155fso13053157wmq.6
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 10:40:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8C0NEBO/ea6+vfvU3O1/xfsUBzcZiJoiCFBeBhlMW4s=;
        b=txXOfxeFGK6menX/uwhGsGeQn/pLYcTFrS44lAD0NnllPJeFNiaVpHCFm1ZcrxvWJt
         /vcLDVZSbJu3/wQwCLcgYtZIkHynN4q6x8iZZL4PLXq1Rnc1JNJenX9mY++mLx5zBPKA
         M4TkaCmi4JSn5+btPI8pk0HRTn6RXnt4Ik5sZE9OOrAqUzmy4xo7mzLO8GALYzqLC/KG
         afSDxD94t1G1K2pC3Z3cTO4bfMjMPbLzpjb6qlJp6oj0NInRzsyuTqLb68EmJcq08IA4
         Ueo0CgyhJ+cDEffhVpA8XwaYgHg/a3hkVfFop78JFhmrbo6LjGAtwKN85NCmDZFsfMvh
         9p6g==
X-Gm-Message-State: AOAM533q9rjj4d1V5R6BrkUR/547FZdHuWpROAWI8iTjum9KMhrDfBOH
        Qp8qETXPdMZPgkPtPVM8GqoZwfNWY9oy1vU29g+zFYdbsmmdulrG04LLT4y54eog4Q+ysgVFqmw
        bXCVg5/8fcji5
X-Received: by 2002:a5d:6e01:0:b0:210:1a7c:7319 with SMTP id h1-20020a5d6e01000000b002101a7c7319mr28352631wrz.227.1654623642500;
        Tue, 07 Jun 2022 10:40:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5QIu9HFXcvDPWLU03G7ZoVTO2C4kFZ1I91LvWeDKHDznQ8bnGcRSAU8CITtMC8w64B9s67A==
X-Received: by 2002:a5d:6e01:0:b0:210:1a7c:7319 with SMTP id h1-20020a5d6e01000000b002101a7c7319mr28352599wrz.227.1654623642212;
        Tue, 07 Jun 2022 10:40:42 -0700 (PDT)
Received: from [192.168.1.129] (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id v190-20020a1cacc7000000b003975c7058bfsm21166382wme.12.2022.06.07.10.40.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 10:40:41 -0700 (PDT)
Message-ID: <badc8e91-f843-2c96-9c02-4fbb59accdc4@redhat.com>
Date:   Tue, 7 Jun 2022 19:40:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/2] Improve vfio-pci primary GPU assignment behavior
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch
Cc:     kvm@vger.kernel.org, Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <165453797543.3592816.6381793341352595461.stgit@omen>
From:   Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <165453797543.3592816.6381793341352595461.stgit@omen>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Alex,

On 6/6/22 19:53, Alex Williamson wrote:
> Users attempting to enable vfio PCI device assignment with a GPU will
> often block the default PCI driver from the device to avoid conflicts
> with the device initialization or release path.  This means that
> vfio-pci is sometimes the first PCI driver to bind to the device.  In 
> the case of assigning the primary graphics device, low-level console
> drivers may still generate resource conflicts.  Users often employ
> kernel command line arguments to disable conflicting drivers or
> perform unbinding in userspace to avoid this, but the actual solution
> is often distribution/kernel config specific based on the included
> drivers.
> 
> We can instead allow vfio-pci to copy the behavior of
> drm_aperture_remove_conflicting_pci_framebuffers() in order to remove
> these low-level drivers with conflicting resources.  vfio-pci is not
> however a DRM driver, nor does vfio-pci depend on DRM config options,
> thus we split out and export the necessary DRM apterture support and
> mirror the framebuffer and VGA support.
> 
> I'd be happy to pull this series in through the vfio branch if
> approved by the DRM maintainers.  Thanks,
>

I understand your issue but I really don't think that using this helper
is the correct thing to do. We already have some races with the current
aperture infrastructure As an example you can look at [0].

The agreement on the mentioned thread is that we want to unify the fbdev
and DRM drivers apertures into a single list, and ideally moving all to
the Linux device model to handle the removal of conflicting devices.

That's why I don't feel that leaking the DRM aperture helper to another
is desirable since it would make even harder to cleanup this later.

But also, this issue isn't something that only affects graphic devices,
right? AFAIU from [1] and [2], the same issue happens if a PCI device
has to be bound to vfio-pci but already was bound to a host driver.

The fact that DRM happens to have some infrastructure to remove devices
that conflict with an aperture is just a coincidence. Since this is used
to remove devices bound to drivers that make use of the firmware-provided
system framebuffer.

The series [0] mentioned above, adds a sysfb_disable() that disables the
Generic System Framebuffer logic that is what registers the framebuffer
devices that are bound to these generic video drivers. On disable, the
devices registered by sysfb are also unregistered.

Would be enough for your use case to use that helper function if it lands
or do you really need to look at the apertures? That is, do you want to
remove the {vesa,efi,simple}fb and simpledrm drivers or is there a need
to also remove real fbdev and DRM drivers?

[0]: https://lore.kernel.org/lkml/YnvrxICnisXU6I1y@ravnborg.org/T/
[1]: https://www.ibm.com/docs/en/linux-on-systems?topic=through-pci
[2]: https://www.kernel.org/doc/Documentation/vfio.txt

-- 
Best regards,

Javier Martinez Canillas
Linux Engineering
Red Hat

