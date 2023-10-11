Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659DE7C4E10
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 11:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbjJKJEb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 05:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjJKJEa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 05:04:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D4F115
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 02:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697015018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zVGUPY1gdZbHt58HOpCldBJSSWMDzHFkqa4wNT8wG0E=;
        b=ePoyqh+5mxXxwizi+UWTKC9bmDR2HWxwVeO4NpyG9D5/u1N17CTUnZRrmymw1muAOtkaDO
        OFedoQJOx21Qyu9+8mKosg1flEQz3rF/qj8m8JOcty6YqhXiaI+5ErCuxXaP5iyxHWdjI0
        0XD9nbLazcQDQl5VBpfhSQAWMebjoF0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-470-LSOc5cc7MJy6iecRAfVI7w-1; Wed, 11 Oct 2023 05:03:27 -0400
X-MC-Unique: LSOc5cc7MJy6iecRAfVI7w-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3fe1521678fso50488215e9.1
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 02:03:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697015006; x=1697619806;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zVGUPY1gdZbHt58HOpCldBJSSWMDzHFkqa4wNT8wG0E=;
        b=AG36LbcH847sTheiZIlYi3qOUsZ3iOftsYYDJ/gcRNX4J0hblEybUUTEWFWKUuMkuE
         q14HvsWzkr9KT0bM4hK4UvGEBIk2ZoDfpWR7AmHARHfM3WRYPqzsP1JBwTkqHsnEdeeG
         Roe+ClZ3IXRtrnUfdUuNLQOQtZtNccDD2MxYCd3YKu+J9OVpeJT4ymVKrdFh7ISQBNr6
         Cuwb6rR6wtjoMWyO5aFAza2YwMa62QbAbNM9NMa3EuBIhSnbwZ+VymItq3SXbhegE1cM
         nEOtSkkhjxnGUbVefm9S+cfOVfQJviTb03R43zNW7wGmx6fA+OXuGWNltQtvBrwmx2YZ
         VMmw==
X-Gm-Message-State: AOJu0YypwvFwwobIatDqyK82/UXZ4NL0HsjZel5JBIXHskc4EDD/g6VI
        CCCz/DBDi9e2HgrUJaIDIRYZ9BN5PJXKincbs2nuV2b8kf0VDC8ipcnZSZPYBZ1gQWHs5JYco2s
        bvhyTnoHAbtQn
X-Received: by 2002:a05:600c:3657:b0:405:7400:1e3d with SMTP id y23-20020a05600c365700b0040574001e3dmr17513917wmq.32.1697015006463;
        Wed, 11 Oct 2023 02:03:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHX6w6JbeuZyJP/TG/gVskCjwlS/apDbc7CnQOe2yP0D8FXGScPozhJqaEWfKxwSg5MAeMNgw==
X-Received: by 2002:a05:600c:3657:b0:405:7400:1e3d with SMTP id y23-20020a05600c365700b0040574001e3dmr17513892wmq.32.1697015006013;
        Wed, 11 Oct 2023 02:03:26 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73d2:bf00:e379:826:5137:6b23])
        by smtp.gmail.com with ESMTPSA id 4-20020a05600c228400b003fee53feab5sm16239233wmf.10.2023.10.11.02.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 02:03:25 -0700 (PDT)
Date:   Wed, 11 Oct 2023 05:03:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        alex.williamson@redhat.com, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231011050014-mutt-send-email-mst@kernel.org>
References: <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <8ea954ba-e966-0b87-b232-06ffd79db4e3@nvidia.com>
 <20231010115649-mutt-send-email-mst@kernel.org>
 <5d83d18a-0b5a-6221-e70d-32908d967715@nvidia.com>
 <20231010163914-mutt-send-email-mst@kernel.org>
 <f4247e59-19cd-0d6b-7728-dd1175c9d968@nvidia.com>
 <20231011035737-mutt-send-email-mst@kernel.org>
 <0ae3b963-f4fe-19c2-ea79-387a66e142ab@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0ae3b963-f4fe-19c2-ea79-387a66e142ab@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 11:58:11AM +0300, Yishai Hadas wrote:
> On 11/10/2023 11:02, Michael S. Tsirkin wrote:
> > On Wed, Oct 11, 2023 at 10:44:49AM +0300, Yishai Hadas wrote:
> > > On 10/10/2023 23:42, Michael S. Tsirkin wrote:
> > > > On Tue, Oct 10, 2023 at 07:09:08PM +0300, Yishai Hadas wrote:
> > > > > > > Assuming that we'll put each command inside virtio as the generic layer, we
> > > > > > > won't be able to call/use this API internally to get the PF as of cyclic
> > > > > > > dependencies between the modules, link will fail.
> > > > I just mean:
> > > > virtio_admin_legacy_io_write(sruct pci_device *,  ....)
> > > > 
> > > > 
> > > > internally it starts from vf gets the pf (or vf itself or whatever
> > > > the transport is) sends command gets status returns.
> > > > 
> > > > what is cyclic here?
> > > > 
> > > virtio-pci depends on virtio [1].
> > > 
> > > If we put the commands in the generic layer as we expect it to be (i.e.
> > > virtio), then trying to call internally call for virtio_pci_vf_get_pf_dev()
> > > to get the PF from the VF will end-up by a linker cyclic error as of below
> > > [2].
> > > 
> > > As of that, someone can suggest to put the commands in virtio-pci, however
> > > this will fully bypass the generic layer of virtio and future clients won't
> > > be able to use it.
> > virtio_pci would get pci device.
> > virtio pci convers that to virtio device of owner + group member id and calls virtio.
> 
> Do you suggest another set of exported symbols (i.e per command ) in virtio
> which will get the owner device + group member + the extra specific command
> parameters ?
> 
> This will end-up duplicating the number of export symbols per command.

Or make them inline.
Or maybe actually even the specific commands should live inside virtio pci
they are pci specific after all.

> > no cycles and minimal transport specific code, right?
> 
> See my above note, if we may just call virtio without any further work on
> the command's input, than YES.
> 
> If so, virtio will prepare the command by setting the relevant SG lists and
> other data and finally will call:
> 
> vdev->config->exec_admin_cmd(vdev, cmd);
> 
> Was that your plan ?

is vdev the pf? then it won't support the transport where commands
are submitted through bar0 of vf itself.

> > 
> > > In addition, passing in the VF PCI pointer instead of the VF group member ID
> > > + the VIRTIO PF device, will require in the future to duplicate each command
> > > once we'll use SIOV devices.
> > I don't think anyone knows how will SIOV look. But shuffling
> > APIs around is not a big deal. We'll see.
> 
> As you are the maintainer it's up-to-you, just need to consider another
> further duplication here.
> 
> Yishai
> 
> > 
> > > Instead, we suggest the below API for the above example.
> > > 
> > > virtio_admin_legacy_io_write(virtio_device *virtio_dev,  u64
> > > group_member_id,  ....)
> > > 
> > > [1]
> > > [yishaih@reg-l-vrt-209 linux]$ modinfo virtio-pci
> > > filename: /lib/modules/6.6.0-rc2+/kernel/drivers/virtio/virtio_pci.ko
> > > version:        1
> > > license:        GPL
> > > description:    virtio-pci
> > > author:         Anthony Liguori <aliguori@us.ibm.com>
> > > srcversion:     7355EAC9408D38891938391
> > > alias:          pci:v00001AF4d*sv*sd*bc*sc*i*
> > > depends: virtio_pci_modern_dev,virtio,virtio_ring,virtio_pci_legacy_dev
> > > retpoline:      Y
> > > intree:         Y
> > > name:           virtio_pci
> > > vermagic:       6.6.0-rc2+ SMP preempt mod_unload modversions
> > > parm:           force_legacy:Force legacy mode for transitional virtio 1
> > > devices (bool)
> > > 
> > > [2]
> > > 
> > > depmod: ERROR: Cycle detected: virtio -> virtio_pci -> virtio
> > > depmod: ERROR: Found 2 modules in dependency cycles!
> > > make[2]: *** [scripts/Makefile.modinst:128: depmod] Error 1
> > > make[1]: *** [/images/yishaih/src/kernel/linux/Makefile:1821:
> > > modules_install] Error 2
> > > 
> > > Yishai
> > virtio absolutely must not depend on virtio pci, it is used on
> > systems without pci at all.
> > 

