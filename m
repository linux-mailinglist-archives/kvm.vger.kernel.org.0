Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 055645108E8
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 21:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348904AbiDZT1u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 15:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344270AbiDZT1t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 15:27:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A31686AA61
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 12:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651001080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8JQX3e1SHEkXg04Hw14Z/O/2neriC0qHwfrioTaaCGE=;
        b=L3xgnurE541EMjAYDAVbon58nPEpvvUgpTLFdbRKlklTYaYO2tP97gMl/etL90FxRUQXVD
        tlsnWimw/KDjfiBZRm0XbxKENDl4Q4aamWWR7A3n1nMVKkaZvh4o8LYlXiIZzkI/P7iUfC
        hlVQKK4oB0wqwAe7HJP8S26S9hB5D1c=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-T3AGrob5PWeDnvV7FjyO0Q-1; Tue, 26 Apr 2022 15:24:39 -0400
X-MC-Unique: T3AGrob5PWeDnvV7FjyO0Q-1
Received: by mail-io1-f69.google.com with SMTP id q5-20020a0566022f0500b00654a56b1dfbso15109267iow.8
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 12:24:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8JQX3e1SHEkXg04Hw14Z/O/2neriC0qHwfrioTaaCGE=;
        b=X+EIToA5X8OkilBkG7AESuU4crWypugw98I6eTd6spYRNa4OA0NLhO4hdW2wVue2kz
         u2UtXIke7U0a6QRyp/YHuK3ieOGHijtp3K5LQFuLn48dsUDCK7zxx7Az5Xc7q69wj1CA
         zVkdg5xF2HE8D6syIB+kBeD/NBDoym9aFss0Lo7vjg0C4NKHqfPoGdaq21Qdm/JZEDzP
         9O6dVfBXEcDnJXT4FQMUpGHkc7OrQGvbivPTo+3VRo28q7Z/KbYy7hmB+yNjqUVc5tei
         A8vrjWFLtzZPJ04ZfKdCm18MSNDvmdAyDB0z2C4oDKex5wMKcKzsi3B/s2H/nB8I9o5q
         XMTA==
X-Gm-Message-State: AOAM530tmc2ZMzXTakJkIby7SkqnCeJ/NwOpWrqa68os5uYIwzbQ04yn
        h2k6A0Ljgg+oMrLNgVgr/dKnzSo+vLJA/IpOw70JQrq+san0YKxWbNwfuT6tV42NnhBZDFKafLz
        prFCar+AJDrNa
X-Received: by 2002:a05:6638:329b:b0:328:96c9:771d with SMTP id f27-20020a056638329b00b0032896c9771dmr10716294jav.48.1651001078547;
        Tue, 26 Apr 2022 12:24:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8zE5yOmVcACo/dOrg9YfDP/mTfj5ZZwrixzWX8n6YYyIdlMbucE34uD0EiuuwCs8A/CpZoQ==
X-Received: by 2002:a05:6638:329b:b0:328:96c9:771d with SMTP id f27-20020a056638329b00b0032896c9771dmr10716278jav.48.1651001078339;
        Tue, 26 Apr 2022 12:24:38 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id y126-20020a6bc884000000b00657ae00d56bsm1075463iof.48.2022.04.26.12.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 12:24:37 -0700 (PDT)
Date:   Tue, 26 Apr 2022 13:24:35 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Daniel P. =?UTF-8?B?QmVycmFu?= =?UTF-8?B?Z8Op?=" 
        <berrange@redhat.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Laine Stump <laine@redhat.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
Message-ID: <20220426132435.6ecddd1d.alex.williamson@redhat.com>
In-Reply-To: <20220426164217.GR2125828@nvidia.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
        <20220422160943.6ff4f330.alex.williamson@redhat.com>
        <YmZzhohO81z1PVKS@redhat.com>
        <20220425083748.3465c50f.alex.williamson@redhat.com>
        <BN9PR11MB5276F549912E03553411736D8CFB9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20220426102159.5ece8c1f.alex.williamson@redhat.com>
        <20220426164217.GR2125828@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Apr 2022 13:42:17 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Apr 26, 2022 at 10:21:59AM -0600, Alex Williamson wrote:
> > We also need to be able to advise libvirt as to how each iommufd object
> > or user of that object factors into the VM locked memory requirement.
> > When used by vfio-pci, we're only mapping VM RAM, so we'd ask libvirt
> > to set the locked memory limit to the size of VM RAM per iommufd,
> > regardless of the number of devices using a given iommufd.  However, I
> > don't know if all users of iommufd will be exclusively mapping VM RAM.
> > Combinations of devices where some map VM RAM and others map QEMU
> > buffer space could still require some incremental increase per device
> > (I'm not sure if vfio-nvme is such a device).  It seems like heuristics
> > will still be involved even after iommufd solves the per-device
> > vfio-pci locked memory limit issue.  Thanks,  
> 
> If the model is to pass the FD, how about we put a limit on the FD
> itself instead of abusing the locked memory limit?
> 
> We could have a no-way-out ioctl that directly limits the # of PFNs
> covered by iopt_pages inside an iommufd.

FD passing would likely only be the standard for libvirt invoked VMs.
The QEMU vfio-pci device would still parse a host= or sysfsdev= option
when invoked by mortals and associate to use the legacy vfio group
interface or the new vfio device interface based on whether an iommufd
is specified.

Does that rule out your suggestion?  I don't know, please reveal more
about the mechanics of putting a limit on the FD itself and this
no-way-out ioctl.  The latter name suggests to me that I should also
note that we need to support memory hotplug with these devices.  Thanks,

Alex

