Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566607A4CA3
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 17:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjIRPhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 11:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjIRPhm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 11:37:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF42C2D50
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 08:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695050892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uwOvxKK5V+5dUlaNETTwFMhcAk/xyIs4LAekRnKndPE=;
        b=XGuNVopuLHzrJGyAjfx5ISI1E81HF5YbNwtaQkdPkDzv20O4+g3unI4yPQbDEKJSF9Xuej
        3XlZOmZkvC0yAMoPBFj3gTzQZjenb5I5BifsupmmoIYPWE05VtrCtsEPGagEW7nrTwnHdT
        hO0jNCvR69bFSQR4xWMAl3u9xkab5os=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-mWMLmfYIMI6kTGwKR89oTA-1; Mon, 18 Sep 2023 10:27:52 -0400
X-MC-Unique: mWMLmfYIMI6kTGwKR89oTA-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-34f6978052aso37996995ab.3
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 07:27:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695047271; x=1695652071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uwOvxKK5V+5dUlaNETTwFMhcAk/xyIs4LAekRnKndPE=;
        b=In/ixnhEiMlq9tGu3DSUWd20hnjn/CUk31e9B9+LvjD4tYf2AcCmXIB48ESl3vhmsf
         gk/EQRbDhrTPIwJyTmRh8NSCL4pt62nR2kS8GpUstCVRhnUJYb+8Ro7C30Hk64Mn//n3
         IL85izrLyQcWZxZT8P9ArgNcpyLXHGVdDMdhIhMdBFc6U+7oZu1D2jpNLxWZ7NXHzuL1
         pWGQLCx63TE70wjTmO+egyCieSzCXJ8dejeG64F6dqvyE5huUaSna2U9WuCcaneDAIZC
         vCPpXIkIzwrFDkG15Q+zBHXYQM9fa5OFy8sBUF6ivxwkUunrWTbJ+Cs5mIEoegPfOtV6
         4L8g==
X-Gm-Message-State: AOJu0Yxhh3DgcNYRrktvgyVvHp4vEkaH23vNWOT1Zq2MMMaJ+oDpkvS9
        zzJ06efIq3PE8euHFHeOWczSDxWfewX+OuZ8J+/Dza0xv5xEYJnP5fe5jUu0llkSiK1li6sitAQ
        DwQOSF03LQrkH
X-Received: by 2002:a05:6e02:1a4b:b0:34c:a166:9866 with SMTP id u11-20020a056e021a4b00b0034ca1669866mr12969234ilv.4.1695047270843;
        Mon, 18 Sep 2023 07:27:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGTHmr8VlLs//iyGPIG4Vq8auG4SfRhNLO7LTZ34vrsk9xsuOivgMMQEw7TyRmCfyxKCTqx6g==
X-Received: by 2002:a05:6e02:1a4b:b0:34c:a166:9866 with SMTP id u11-20020a056e021a4b00b0034ca1669866mr12969209ilv.4.1695047270482;
        Mon, 18 Sep 2023 07:27:50 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id k3-20020a02c643000000b0043167542399sm2753004jan.99.2023.09.18.07.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 07:27:49 -0700 (PDT)
Date:   Mon, 18 Sep 2023 08:27:48 -0600
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
Message-ID: <20230918082748.631e9fd9.alex.williamson@redhat.com>
In-Reply-To: <20230918130256.GE13733@nvidia.com>
References: <20230915025415.6762-1-ankita@nvidia.com>
        <20230915082430.11096aa3.alex.williamson@redhat.com>
        <20230918130256.GE13733@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 Sep 2023 10:02:56 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Sep 15, 2023 at 08:24:30AM -0600, Alex Williamson wrote:
> > On Thu, 14 Sep 2023 19:54:15 -0700
> > <ankita@nvidia.com> wrote:
> >   
> > > From: Ankit Agrawal <ankita@nvidia.com>
> > > 
> > > NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
> > > for the on-chip GPU that is the logical OS representation of the
> > > internal proprietary cache coherent interconnect.
> > > 
> > > This representation has a number of limitations compared to a real PCI
> > > device, in particular, it does not model the coherent GPU memory
> > > aperture as a PCI config space BAR, and PCI doesn't know anything
> > > about cacheable memory types.
> > > 
> > > Provide a VFIO PCI variant driver that adapts the unique PCI
> > > representation into a more standard PCI representation facing
> > > userspace. The GPU memory aperture is obtained from ACPI using
> > > device_property_read_u64(), according to the FW specification,
> > > and exported to userspace as a separate VFIO_REGION. Since the device
> > > implements only one 64-bit BAR (BAR0), the GPU memory aperture is mapped
> > > to the next available PCI BAR (BAR2). Qemu will then naturally generate a
> > > PCI device in the VM with two 64-bit BARs (where the cacheable aperture
> > > reported in BAR2).
> > > 
> > > Since this memory region is actually cache coherent with the CPU, the
> > > VFIO variant driver will mmap it into VMA using a cacheable mapping. The
> > > mapping is done using remap_pfn_range().
> > > 
> > > PCI BAR are aligned to the power-of-2, but the actual memory on the
> > > device may not. A read or write access to the physical address from the
> > > last device PFN up to the next power-of-2 aligned physical address
> > > results in reading ~0 and dropped writes.
> > > 
> > > Lastly the presence of CPU cache coherent device memory is exposed
> > > through sysfs for use by user space.  
> > 
> > This looks like a giant red flag that this approach of masquerading the
> > coherent memory as a PCI BAR is the wrong way to go.  If the VMM needs
> > to know about this coherent memory, it needs to get that information
> > in-band.   
> 
> The VMM part doesn't need this flag, nor does the VM. The
> orchestration needs to know when to setup the pxm stuff.

Subject: [PATCH v1 1/4] vfio: new command line params for device memory NUMA nodes
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
...
+static bool vfio_pci_read_cohmem_support_sysfs(VFIODevice *vdev)
+{
+    gchar *contents = NULL;
+    gsize length;
+    char *path;
+    bool ret = false;
+    uint32_t supported;
+
+    path = g_strdup_printf("%s/coherent_mem", vdev->sysfsdev);
+    if (g_file_get_contents(path, &contents, &length, NULL) && length > 0) {
+        if ((sscanf(contents, "%u", &supported) == 1) && supported) {
+            ret = true;
+        }
+    }

> I think we should drop the sysfs for now until the qemu thread about
> the pxm stuff settles into an idea.
> 
> When the qemu API is clear we can have a discussion on what component
> should detect this driver and setup the pxm things, then answer the
> how should the detection work from the kernel side.
> 
> > be reaching out to arbitrary sysfs attributes.  Minimally this
> > information should be provided via a capability on the region info
> > chain,   
> 
> That definitely isn't suitable, eg libvirt won't have access to inband
> information if it turns out libvirt is supposed to setup the pxm qemu
> arguments?

Why would libvirt look for a "coherent_mem" attribute in sysfs when it
can just look at the driver used by the device.  Part of the QEMU
series is also trying to invoke the VM configuration based only on this
device being attached to avoid libvirt orchestration changes:

Subject: [PATCH v1 2/4] vfio: assign default values to node params

    It may be desirable for some deployments to have QEMU automatically
    pick a range and create the NUMA nodes. So the admin need not care
    about passing any additional params. Another advantage is that the
    feature is not dependent on newer libvirt that support the new
    parameters pxm-ns and pxm-nc.
 
> > A "coherent_mem" attribute on the device provides a very weak
> > association to the memory region it's trying to describe.  
> 
> That's because it's use has nothing to do with the memory region :)

So we're creating a very generic sysfs attribute, which is meant to be
used by orchestration to invoke device specific configuration, but is
currently only proposed for use by the VMM.  The orchestration problem
doesn't really exist, libvirt could know simply by the driver name that
the device requires this configuration.  And the VMM usage is self
inflicted because we insist on masquerading the coherent memory as a
nondescript PCI BAR rather than providing a device specific region to
enlighten the VMM to this unique feature.  Thanks,

Alex

