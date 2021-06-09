Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9A03A1AA3
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 18:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbhFIQRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 12:17:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47958 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230199AbhFIQRc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 12:17:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623255337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZKvRJP1Qn2FuRIKKae+xpipPvYviXO+rudBhyvwgw04=;
        b=D3Z8TIeJDtrdNYPocssvdItBYl2bCOHvD6pV6hgLwHnYjOmbpuUX0Tr9wCNN5JytEtkcFw
        KZeLefoAoJF7Trr7RpUtktQqJj/1VxPmBiwWoi9mRfI+PqeKGJsiNqSVTd+aNGH1bHnPjD
        nkDx+yA3sScgkjjJ5BPQiom9ZgmiQXc=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-CK_5sPFLNcO0HY4UDpDBUA-1; Wed, 09 Jun 2021 12:15:35 -0400
X-MC-Unique: CK_5sPFLNcO0HY4UDpDBUA-1
Received: by mail-oo1-f70.google.com with SMTP id c25-20020a4ad7990000b029020e67cc1879so15778137oou.18
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 09:15:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ZKvRJP1Qn2FuRIKKae+xpipPvYviXO+rudBhyvwgw04=;
        b=R0J2rcV0kSG5NWE3KhBz3iju5+b70hk7zUrKh/mmUn8jnf6CacH+jFVn4dBT/Zj5BC
         gr0vcQws/vfAfUrskR4GrUp6dSfLGdqGhR6g7rmcy9W7sG/6+J0ea6M4mPbYmvca+e/J
         KotvIErYt3GB0XOBu4AbcwlCdh74jghAoFYlGxZU6ZrdYCN/BjlZQEQ4ZApmqdvg9Tbj
         eMXtzi4NphudMhfZSFizLhivoQB8HZt6gAlB5WuLMHfX+RhWajUGB3cYxuQXsMCMMi4Q
         wXvFvmdnB/45MbfgMLiSnCTK6bcPpUsce1yAYPxDCW4dT0Eo9AnQi5c+O5qbCLfPGzpI
         ryoA==
X-Gm-Message-State: AOAM531k0HjxM5Y7VH8Ojsa6bs3fpzv3rk/2ie4Nrwe/AopOOju0Hruj
        ChI0I24S/4ArceE9mFc8uExmSfdcQ5mOwPat21R+UO31LEw5ovAc5B7agfNUbkPjXMs9H+8V+8d
        rCXBi1F6pXq3h
X-Received: by 2002:a9d:6042:: with SMTP id v2mr179311otj.170.1623255335008;
        Wed, 09 Jun 2021 09:15:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYk1fCbBjXzJvcPumlKeytJWmAtK0sJebJhCUtHFNxQQubDFY1axQko6MBR1VcZ3NidsA9KA==
X-Received: by 2002:a9d:6042:: with SMTP id v2mr179287otj.170.1623255334638;
        Wed, 09 Jun 2021 09:15:34 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id x9sm76559oto.79.2021.06.09.09.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 09:15:34 -0700 (PDT)
Date:   Wed, 9 Jun 2021 10:15:32 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210609101532.452851eb.alex.williamson@redhat.com>
In-Reply-To: <YMDjfmJKUDSrbZbo@8bytes.org>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
        <YMCy48Xnt/aphfh3@8bytes.org>
        <20210609123919.GA1002214@nvidia.com>
        <YMDC8tOMvw4FtSek@8bytes.org>
        <20210609150009.GE1002214@nvidia.com>
        <YMDjfmJKUDSrbZbo@8bytes.org>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 9 Jun 2021 17:51:26 +0200
Joerg Roedel <joro@8bytes.org> wrote:

> On Wed, Jun 09, 2021 at 12:00:09PM -0300, Jason Gunthorpe wrote:
> > Only *drivers* know what the actual device is going to do, devices do
> > not. Since the group doesn't have drivers it is the wrong layer to be
> > making choices about how to configure the IOMMU.  
> 
> Groups don't carry how to configure IOMMUs, that information is
> mostly in the IOMMU domains. And those (or an abstraction of them) is
> configured through /dev/ioasid. So not sure what you wanted to say with
> the above.
> 
> All a group carries is information about which devices are not
> sufficiently isolated from each other and thus need to always be in the
> same domain.
> 
> > The device centric approach is my attempt at this, and it is pretty
> > clean, I think.  
> 
> Clean, but still insecure.
> 
> > All ACS does is prevent P2P operations, if you assign all the group
> > devices into the same /dev/iommu then you may not care about that
> > security isolation property. At the very least it is policy for user
> > to decide, not kernel.  
> 
> It is a kernel decision, because a fundamental task of the kernel is to
> ensure isolation between user-space tasks as good as it can. And if a
> device assigned to one task can interfer with a device of another task
> (e.g. by sending P2P messages), then the promise of isolation is broken.

AIUI, the IOASID model will still enforce IOMMU groups, but it's not an
explicit part of the interface like it is for vfio.  For example the
IOASID model allows attaching individual devices such that we have
granularity to create per device IOASIDs, but all devices within an
IOMMU group are required to be attached to an IOASID before they can be
used.  It's not entirely clear to me yet how that last bit gets
implemented though, ie. what barrier is in place to prevent device
usage prior to reaching this viable state.

> > Groups should be primarily about isolation security, not about IOASID
> > matching.  
> 
> That doesn't make any sense, what do you mean by 'IOASID matching'?

One of the problems with the vfio interface use of groups is that we
conflate the IOMMU group for both isolation and granularity.  I think
what Jason is referring to here is that we still want groups to be the
basis of isolation, but we don't want a uAPI that presumes all devices
within the group must use the same IOASID.  For example, if a user owns
an IOMMU group consisting of non-isolated functions of a multi-function
device, they should be able to create a vIOMMU VM where each of those
functions has its own address space.  That can't be done today, the
entire group would need to be attached to the VM under a PCIe-to-PCI
bridge to reflect the address space limitation imposed by the vfio
group uAPI model.  Thanks,

Alex

