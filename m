Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461527CD586
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 09:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjJRHd2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 03:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjJRHd1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 03:33:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16A7FA
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 00:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697614367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H9ARuw3ocrq2zuIRYqvsxkWkuBZXz4JrIIs6MzQ7cA8=;
        b=jIvKBBG+DUqOUGPdYb+IWa2FKRPT+5jimUUBL5tHid3M1py7IztoGE3e8CTznXrZRwhiJo
        zviNHvzpuRtTiu+0dxq0/hcOKhFinGA464MTsGdAXfrGlYigpq1EwuvY3vxzw0rGen/RJG
        tOBgmK7cWD3rxox3jISAplxzSG/fb74=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-L5-qNisCOJ6y6Y4MwINX4A-1; Wed, 18 Oct 2023 03:32:45 -0400
X-MC-Unique: L5-qNisCOJ6y6Y4MwINX4A-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-66cfd45de06so58292886d6.0
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 00:32:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697614365; x=1698219165;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H9ARuw3ocrq2zuIRYqvsxkWkuBZXz4JrIIs6MzQ7cA8=;
        b=bHyjmTaRhwqQ8ct/4V/HuSiwpCmgssfQdqSRPEP4HlynmEIo6QNhemmus+QExecxfj
         HhrqVWCTaubQz0c48sF34NsqJSaj9jLGXuqUVtWOJvKIuuc9Uonejrb5e7+x/IWkJIaZ
         8K2oj+4a2ubaO6Xk7nlinEqq+1q4SiutiptFleC6/ej0lw/IscmKhrhz/5WK8KvFHaxH
         EWs09Q/NBVjK7hM9Pjt4UKTuq6J2LHzy40AM+thNMUhNjEl+QERlQrrF8/WFarhm1zrO
         noxJOugi4uIQd2dN7UnnGYAofH9OKTMKBFBPXoMvPNXxHB2XSNcurUndTc5I6Zino+bv
         H3KQ==
X-Gm-Message-State: AOJu0YxsDEq+v7HTHV+UsQor+2GUcnBToSt1sLHgA/tcVyQ9HeWaNcVO
        D8tXSM+6SPuYZSOvaowvovaBFJ+YOoCDMWMov2Ezu5Ak5dZ93SDdgQcZn27VBrC6piwx6U3K4TH
        HmOe1ZVGN2Xe5
X-Received: by 2002:a05:6214:1c0b:b0:66d:6845:ea2d with SMTP id u11-20020a0562141c0b00b0066d6845ea2dmr5259203qvc.53.1697614365067;
        Wed, 18 Oct 2023 00:32:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHVEqA4xPTiOaWetvvswhtwmlji+EpyS13eyeJ+VOWUsrcyK46S4glHUKGMSbBqRqY7/INBJw==
X-Received: by 2002:a05:6214:1c0b:b0:66d:6845:ea2d with SMTP id u11-20020a0562141c0b00b0066d6845ea2dmr5259182qvc.53.1697614364748;
        Wed, 18 Oct 2023 00:32:44 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id qh29-20020a0562144c1d00b0066d1b4ce863sm1166386qvb.31.2023.10.18.00.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 00:32:44 -0700 (PDT)
Date:   Wed, 18 Oct 2023 09:32:39 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?B?TWFyYy1BbmRyw6k=?= Lureau <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
Subject: Re: [PATCH 11/12] hw/xen: automatically assign device index to
 block devices
Message-ID: <20231018093239.3d525fd8@imammedo.users.ipa.redhat.com>
In-Reply-To: <20231016151909.22133-12-dwmw2@infradead.org>
References: <20231016151909.22133-1-dwmw2@infradead.org>
        <20231016151909.22133-12-dwmw2@infradead.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Oct 2023 16:19:08 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> From: David Woodhouse <dwmw@amazon.co.uk>
> 

is this index a user (guest) visible?

> There's no need to force the user to assign a vdev. We can automatically
> assign one, starting at xvda and searching until we find the first disk
> name that's unused.
> 
> This means we can now allow '-drive if=xen,file=xxx' to work without an
> explicit separate -driver argument, just like if=virtio.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  blockdev.c           | 15 ++++++++++++---
>  hw/block/xen-block.c | 25 +++++++++++++++++++++++++
>  2 files changed, 37 insertions(+), 3 deletions(-)
> 
> diff --git a/blockdev.c b/blockdev.c
> index 325b7a3bef..9dec4c9c74 100644
> --- a/blockdev.c
> +++ b/blockdev.c
> @@ -255,13 +255,13 @@ void drive_check_orphaned(void)
>           * Ignore default drives, because we create certain default
>           * drives unconditionally, then leave them unclaimed.  Not the
>           * users fault.
> -         * Ignore IF_VIRTIO, because it gets desugared into -device,
> -         * so we can leave failing to -device.
> +         * Ignore IF_VIRTIO or IF_XEN, because it gets desugared into
> +         * -device, so we can leave failing to -device.
>           * Ignore IF_NONE, because leaving unclaimed IF_NONE remains
>           * available for device_add is a feature.
>           */
>          if (dinfo->is_default || dinfo->type == IF_VIRTIO
> -            || dinfo->type == IF_NONE) {
> +            || dinfo->type == IF_XEN || dinfo->type == IF_NONE) {
>              continue;
>          }
>          if (!blk_get_attached_dev(blk)) {
> @@ -977,6 +977,15 @@ DriveInfo *drive_new(QemuOpts *all_opts, BlockInterfaceType block_default_type,
>          qemu_opt_set(devopts, "driver", "virtio-blk", &error_abort);
>          qemu_opt_set(devopts, "drive", qdict_get_str(bs_opts, "id"),
>                       &error_abort);
> +    } else if (type == IF_XEN) {
> +        QemuOpts *devopts;
> +        devopts = qemu_opts_create(qemu_find_opts("device"), NULL, 0,
> +                                   &error_abort);
> +        qemu_opt_set(devopts, "driver",
> +                     (media == MEDIA_CDROM) ? "xen-cdrom" : "xen-disk",
> +                     &error_abort);
> +        qemu_opt_set(devopts, "drive", qdict_get_str(bs_opts, "id"),
> +                     &error_abort);
>      }
>  
>      filename = qemu_opt_get(legacy_opts, "file");
> diff --git a/hw/block/xen-block.c b/hw/block/xen-block.c
> index 9262338535..20fa783cbe 100644
> --- a/hw/block/xen-block.c
> +++ b/hw/block/xen-block.c
> @@ -34,6 +34,31 @@ static char *xen_block_get_name(XenDevice *xendev, Error **errp)
>      XenBlockDevice *blockdev = XEN_BLOCK_DEVICE(xendev);
>      XenBlockVdev *vdev = &blockdev->props.vdev;
>  
> +    if (blockdev->props.vdev.type == XEN_BLOCK_VDEV_TYPE_INVALID) {
> +        char name[11];
> +        int disk = 0;
> +        unsigned long idx;
> +
> +        /* Find an unoccupied device name */
> +        while (disk < (1 << 20)) {
> +            if (disk < (1 << 4)) {
> +                idx = (202 << 8) | (disk << 4);
> +            } else {
> +                idx = (1 << 28) | (disk << 8);
> +            }
> +            snprintf(name, sizeof(name), "%lu", idx);
> +            if (!xen_backend_exists("qdisk", name)) {
> +                vdev->type = XEN_BLOCK_VDEV_TYPE_XVD;
> +                vdev->partition = 0;
> +                vdev->disk = disk;
> +                vdev->number = idx;
> +                return g_strdup(name);
> +            }
> +            disk++;
> +        }
> +        error_setg(errp, "cannot find device vdev for block device");
> +        return NULL;
> +    }
>      return g_strdup_printf("%lu", vdev->number);
>  }
>  

