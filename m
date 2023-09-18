Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4DA7A50D5
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 19:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjIRRUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 13:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjIRRUs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 13:20:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A90DB
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 10:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695057594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vQQC91VltdlMOTpbyQ+i0gY0RiUkw1BySlhN5WRTu2Q=;
        b=fP6JdmvTwArfLWWGaGVX+/ssSLB1YlHGZ0Nv0AF39GDIhbeO9n7SL4grMj4I6W9l8TQG0x
        jv1fY8k3gBYw1AxRtUfgaFxjBI+RuDD9GTrxcAgy3FmHpLCJ5KbZWchE9e+5ZyVDHtQxct
        3AxwN85a/1m2b0oawonbK/KgVL9O2lQ=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-7KAKFoJDM5--mCEt2ZMDYw-1; Mon, 18 Sep 2023 13:19:53 -0400
X-MC-Unique: 7KAKFoJDM5--mCEt2ZMDYw-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7913a5d6546so436654539f.1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 10:19:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695057592; x=1695662392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vQQC91VltdlMOTpbyQ+i0gY0RiUkw1BySlhN5WRTu2Q=;
        b=hLb+ZObOuj0XDaRr4YWIdGAwaULdsuVq1q/vvQdnsx+O0rqUlsI5T04xitcPIv+G3R
         x2wsDt1o5we9/YDHWBGJT545JAiGUWHI8GI8CgQ27iXmFWnMVivEGa+ZYw2sPmx3GMhB
         PvA1i57w+30hxQRFVUo4aT/njtG0gqt+v5HtyNLpHIl4jUPBPMXfyxTFuJnHu31DQR8r
         oeOGRnajctFRw5XaLeqM7b1iCcqY4jCCH8isL29i1SHHdq1ZZ786y4SQVOeW2UuK1CV1
         pq/si2vdkP5qgz5s/SlyV6Ez/gsSvSo9Q9zr2OED403gTPnVsniF4VR5xtL0UHoNNCxM
         2PNA==
X-Gm-Message-State: AOJu0Yx3uGZuGuZ5Vzeb409pO+jd5017j6Jlv7ZO6lcDgULMhgGc5kUQ
        9EhWPLtRAKyCsLSRf+yPCUO2/XDmGTeYqleTLJs315tD3l0WvqVwQMEDhR5LHXbgwYql/mOe1/F
        xrZtzRJUiruzA
X-Received: by 2002:a6b:7214:0:b0:794:da97:d194 with SMTP id n20-20020a6b7214000000b00794da97d194mr11776804ioc.19.1695057592180;
        Mon, 18 Sep 2023 10:19:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOcO3fsbSz5uuh/nTCv/tQHoEWOhVPfMaLNnAcsgD6WfTl98pZSF6PbJCsO+iThmd/EsVZjw==
X-Received: by 2002:a6b:7214:0:b0:794:da97:d194 with SMTP id n20-20020a6b7214000000b00794da97d194mr11776775ioc.19.1695057591886;
        Mon, 18 Sep 2023 10:19:51 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id em10-20020a0566384daa00b0041cd626ea0csm2943087jab.147.2023.09.18.10.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 10:19:51 -0700 (PDT)
Date:   Mon, 18 Sep 2023 11:19:49 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     ankita@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
        apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
        anuaggarwal@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230918111949.1d6c8482.alex.williamson@redhat.com>
In-Reply-To: <20230918144923.GH13733@nvidia.com>
References: <20230915025415.6762-1-ankita@nvidia.com>
        <20230915082430.11096aa3.alex.williamson@redhat.com>
        <20230918130256.GE13733@nvidia.com>
        <20230918082748.631e9fd9.alex.williamson@redhat.com>
        <20230918144923.GH13733@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 Sep 2023 11:49:23 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Sep 18, 2023 at 08:27:48AM -0600, Alex Williamson wrote:
> 
> > > > This looks like a giant red flag that this approach of masquerading the
> > > > coherent memory as a PCI BAR is the wrong way to go.  If the VMM needs
> > > > to know about this coherent memory, it needs to get that information
> > > > in-band.     
> > > 
> > > The VMM part doesn't need this flag, nor does the VM. The
> > > orchestration needs to know when to setup the pxm stuff.  
> > 
> > Subject: [PATCH v1 1/4] vfio: new command line params for device memory NUMA nodes
> > --- a/hw/vfio/pci.c
> > +++ b/hw/vfio/pci.c
> > ...
> > +static bool vfio_pci_read_cohmem_support_sysfs(VFIODevice *vdev)
> > +{
> > +    gchar *contents = NULL;
> > +    gsize length;
> > +    char *path;
> > +    bool ret = false;
> > +    uint32_t supported;
> > +
> > +    path = g_strdup_printf("%s/coherent_mem", vdev->sysfsdev);
> > +    if (g_file_get_contents(path, &contents, &length, NULL) && length > 0) {
> > +        if ((sscanf(contents, "%u", &supported) == 1) && supported) {
> > +            ret = true;
> > +        }
> > +    }  
> 
> Yes, but it drives the ACPI pxm auto configuration stuff, not really
> vfio stuff.
> 
> > > I think we should drop the sysfs for now until the qemu thread about
> > > the pxm stuff settles into an idea.
> > > 
> > > When the qemu API is clear we can have a discussion on what component
> > > should detect this driver and setup the pxm things, then answer the
> > > how should the detection work from the kernel side.
> > >   
> > > > be reaching out to arbitrary sysfs attributes.  Minimally this
> > > > information should be provided via a capability on the region info
> > > > chain,     
> > > 
> > > That definitely isn't suitable, eg libvirt won't have access to inband
> > > information if it turns out libvirt is supposed to setup the pxm qemu
> > > arguments?  
> > 
> > Why would libvirt look for a "coherent_mem" attribute in sysfs when it
> > can just look at the driver used by the device.    
> 
> Sure, if that is consensus. Also I think coherent_mem is a terrible
> sysfs name for this, it should be more like 'num_pxm_nodes' or
> something.
> 
> > Part of the QEMU series is also trying to invoke the VM
> > configuration based only on this
> > device being attached to avoid libvirt orchestration changes:  
> 
> Right, that is where it gets confusing - it mixes the vfio world in
> qemu with the pxm world. That should be cleaned up somehow.
> 
> > > > A "coherent_mem" attribute on the device provides a very weak
> > > > association to the memory region it's trying to describe.    
> > > 
> > > That's because it's use has nothing to do with the memory region :)  
> > 
> > So we're creating a very generic sysfs attribute, which is meant to be
> > used by orchestration to invoke device specific configuration, but is
> > currently only proposed for use by the VMM.  The orchestration problem
> > doesn't really exist, libvirt could know simply by the driver name that
> > the device requires this configuration.    
> 
> Yep
> 
> > And the VMM usage is self inflicted because we insist on
> > masquerading the coherent memory as a nondescript PCI BAR rather
> > than providing a device specific region to enlighten the VMM to this
> > unique feature.  
> 
> I see it as two completely seperate things.
> 
> 1) VFIO and qemu creating a vPCI device. Here we don't need this
>    information.
> 
> 2) This ACPI pxm stuff to emulate the bare metal FW.
>    Including a proposal for auto-detection what kind of bare metal FW
>    is being used.
> 
> This being a poor idea for #2 doesn't jump to problems with #1, it
> just says more work is needed on the ACPI PXM stuff.

But I don't think we've justified why it's a good idea for #1.  Does
the composed vPCI device with coherent memory masqueraded as BAR2 have
a stand alone use case without #2?

My understanding based on these series is that the guest driver somehow
carves up the coherent memory among a set of memory-less NUMA nodes
(how to know how many?) created by the VMM and reported via the _DSD for
the device.  If this sort of configuration is a requirement for making
use of the coherent memory, then what exactly becomes easier by the fact
that it's exposed as a PCI BAR?

In fact, if it weren't a BAR I'd probably suggest that the whole
configuration of this device should be centered around a new
nvidia-gpu-mem object.  That object could reference the ID of a
vfio-pci device providing the coherent memory via a device specific
region and be provided with a range of memory-less nodes created for
its use.  The object would insert the coherent memory range into the VM
address space and provide the device properties to make use of it in
the same way as done on bare metal.

It seems to me that the PCI BAR representation of coherent memory is
largely just a shortcut to getting it into the VM address space, but
it's also leading us down these paths where the "pxm stuff" is invoked
based on the device attached to the VM, which is getting a lot of
resistance.  Thanks,

Alex

