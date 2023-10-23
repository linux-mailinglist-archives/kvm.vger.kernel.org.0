Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8827D3CD0
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 18:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjJWQqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 12:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjJWQqr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 12:46:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7682BDB
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 09:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698079553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sasvEpHKXFoCs30KM81UDEqwxjrVxOBDKbKNXA3uCdU=;
        b=Jd+Wt/Ddz1Hx8k57U3JEGzdVAP+6dDcZn3VsXadbDsKs9aMGIvwZj56Gz0Y/wFVnZA0uii
        9LxRod3PPNJZlCgfJ4k1CgQTDGrQH8f9w3I7dkadIaFYVQKtKgnHb1fYB8MV3de8YtnUXZ
        OCiGhW8OlRVGtH6KsL6Q4qPTdnmFkOI=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-YmIM3vYZM-usCUqBqNOM9w-1; Mon, 23 Oct 2023 12:45:51 -0400
X-MC-Unique: YmIM3vYZM-usCUqBqNOM9w-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7a67da1c761so426543339f.0
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 09:45:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698079550; x=1698684350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sasvEpHKXFoCs30KM81UDEqwxjrVxOBDKbKNXA3uCdU=;
        b=omS2YblZ+6xiy8BsoXXvIlwk8FtV1NXWr2gSxJLUe5N3lmWSzCc1b+xg+W3HTUuLDH
         KfiY5ul+2fWIz090UejhbMmvPBWHqy5h97sGmNNzDwgh+a6supHyspDkYWoqN+3dNNlD
         KeKU/xy1A6dySTIaHjLquPvrv+WpAS+kiLl3Pnxq0bpZvfFBs52lJTIXba6VDJDroF5x
         gcYJsRcUd+NNbtq4FxJFFiLyaub0iEn5t7Up4mwRde0cGFpAU7My+jdN/5N8ebhuBP8C
         AXEhHUw5VpFOcV9h14+W2tSi3oAWT+iKWyc7EnMcFioVkD3q7dmsCxZK7GaZHrqH0TaF
         tM+Q==
X-Gm-Message-State: AOJu0YyQg8pk+6Lwtn0hKXDhODw/vIIWNMmdKsqnhw7G+148xjiIj5W6
        DpJRDKGS+ipHlbCawjDP/BngVeUvDVyFZtNuFdMVl7NUh8ZgvfkRF5fFOQQkG4ZObcBIqTg95/g
        IiO9ArakId7UF
X-Received: by 2002:a05:6602:2e10:b0:7a9:77ac:5454 with SMTP id o16-20020a0566022e1000b007a977ac5454mr1132001iow.18.1698079550390;
        Mon, 23 Oct 2023 09:45:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlB5w95pzdyyFq/skony0Xw8FWcM6R9TpGxpduAvW6SMAcXEhPV1NPlwaAbHqxy2xPUHjyQg==
X-Received: by 2002:a05:6602:2e10:b0:7a9:77ac:5454 with SMTP id o16-20020a0566022e1000b007a977ac5454mr1131979iow.18.1698079550147;
        Mon, 23 Oct 2023 09:45:50 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id dx20-20020a0566381d1400b0042b3ad1656bsm2396260jab.45.2023.10.23.09.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 09:45:49 -0700 (PDT)
Date:   Mon, 23 Oct 2023 10:45:48 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com,
        si-wei.liu@oracle.com, leonro@nvidia.com, maorg@nvidia.com,
        jasowang@redhat.com
Subject: Re: [PATCH V1 vfio 0/9] Introduce a vfio driver over virtio devices
Message-ID: <20231023104548.07b3aa19.alex.williamson@redhat.com>
In-Reply-To: <20231023162043.GB3952@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
        <6e2c79c2-5d1d-3f3b-163b-29403c669049@nvidia.com>
        <20231023093323.2a20b67c.alex.williamson@redhat.com>
        <20231023154257.GZ3952@nvidia.com>
        <20231023100913.39dcefba.alex.williamson@redhat.com>
        <20231023162043.GB3952@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Oct 2023 13:20:43 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Oct 23, 2023 at 10:09:13AM -0600, Alex Williamson wrote:
> > On Mon, 23 Oct 2023 12:42:57 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Mon, Oct 23, 2023 at 09:33:23AM -0600, Alex Williamson wrote:
> > >   
> > > > > Alex,
> > > > > Are you fine to leave the provisioning of the VF including the control 
> > > > > of its transitional capability in the device hands as was suggested by 
> > > > > Jason ?    
> > > > 
> > > > If this is the standard we're going to follow, ie. profiling of a
> > > > device is expected to occur prior to the probe of the vfio-pci variant
> > > > driver, then we should get the out-of-tree NVIDIA vGPU driver on board
> > > > with this too.    
> > > 
> > > Those GPU drivers are using mdev not vfio-pci..  
> > 
> > The SR-IOV mdev vGPUs rely on the IOMMU backing device support which
> > was removed from upstream.    
> 
> It wasn't, but it changed forms.
> 
> mdev is a sysfs framework for managing lifecycle with GUIDs only.
> 
> The thing using mdev can call vfio_register_emulated_iommu_dev() or
> vfio_register_group_dev(). 
> 
> It doesn't matter to the mdev stuff.
> 
> The thing using mdev is responsible to get the struct device to pass
> to vfio_register_group_dev()

Are we describing what can be done (possibly limited to out-of-tree
drivers) or what should be done and would be accepted upstream?

I'm under the impression that mdev has been redefined to be more
narrowly focused for emulated IOMMU devices and that devices based
around a PCI VF should be making use of a vfio-pci variant driver.

Are you suggesting it's the vendor's choice based on whether they want
the mdev lifecycle support?

We've defined certain aspects of the vfio-mdev interface as only
available for emulated IOMMU devices, ex. page pinning.  Thanks,

Alex

