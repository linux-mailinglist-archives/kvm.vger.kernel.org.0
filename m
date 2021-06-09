Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B1E3A0E94
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 10:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237445AbhFIIQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 04:16:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34335 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237229AbhFIIQs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 04:16:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623226494;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BJdAIhBhaJHDTxxgy9Ey5Eqpozz7WMzGVnuX/u268J8=;
        b=B4WmiwIXLq2Ut0hykR2DN0UkrBmgsPK5hpC+3poG+rM862icUCA9wstjy9hCS3h2Q54xO1
        QdkRxFl79toWPX4aQGat22StmDt/KTnmNgQsNxTlqCxDEWSdCZ3mC8vmw8RheGybJgIMxx
        bDfwFU6qPJ3YijwXt/h2LULkTCbzamQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-gQ1ZxNFJMZO8o-KTJa3aYg-1; Wed, 09 Jun 2021 04:14:52 -0400
X-MC-Unique: gQ1ZxNFJMZO8o-KTJa3aYg-1
Received: by mail-wm1-f69.google.com with SMTP id j6-20020a05600c1906b029019e9c982271so2305832wmq.0
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 01:14:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=BJdAIhBhaJHDTxxgy9Ey5Eqpozz7WMzGVnuX/u268J8=;
        b=YILtA/5La9OMpaWlz7m3NCK6hlnXpX/39j+BNepvAkParFZkUyHnJr6yLUFdxAyHYW
         MJfvswRMMsrR5a4UHk0rLwFoGzSY6/tmEiVjtyaopHCZOiR63+oRp5QuJQj1y4eQYjP/
         nurbj2pTdyIB0Jo3Dtf1VYa9Ix5Q8q4VUQ0U8TBw2JJQWiTlEijnUV68t8qHG8Ws2VR1
         gXHsLZ+l5EO9A20wGKepRlT+5UWVLJdydnCUB8VJQoPP1rf8WzSJmXczpYM1v56F/P0Y
         exBEJ9lS/LLofxsR6W2Vy5LYxLEU6U39J/jFluAEn/wnyvs2OsgHeQkxvAIEVWr9bnym
         dUlg==
X-Gm-Message-State: AOAM533ioJCJhZUxsJ19R7c6lk9pYUvOsyTa0DuPK1YFGxpUoszvX8Du
        VuV15Om2PaQc5mYa+z1QaJf+ImwoSBqDBb4fQxW8+jdEnyE61ND9/XcIMCZPlBMNBaxSFVik3If
        +KkYmxMgJox2w
X-Received: by 2002:a1c:5452:: with SMTP id p18mr25986468wmi.176.1623226491775;
        Wed, 09 Jun 2021 01:14:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHztkUAyI+BmnE5wcOSMiNwdss3hfpHeT1nOccAa3B1HkID/3sYMZnDdskmY46CLurO/tQVA==
X-Received: by 2002:a1c:5452:: with SMTP id p18mr25986454wmi.176.1623226491547;
        Wed, 09 Jun 2021 01:14:51 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id w13sm24559323wrc.31.2021.06.09.01.14.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 01:14:50 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: Plan for /dev/ioasid RFC v2
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <b1bb72b5-cb98-7739-8788-01e36ec415a8@redhat.com>
Date:   Wed, 9 Jun 2021 10:14:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

On 6/7/21 4:58 AM, Tian, Kevin wrote:
> Hi, all,
>
> We plan to work on v2 now, given many good comments already received
> and substantial changes envisioned. This is a very complex topic with
> many sub-threads being discussed. To ensure that I didn't miss valuable 
> suggestions (and also keep everyone on the same page), here I'd like to 
> provide a list of planned changes in my mind. Please let me know if 
> anything important is lost.  :)
>
> --
>
> (Remaining opens in v1)
>
> -   Protocol between kvm/vfio/ioasid for wbinvd/no-snoop. I'll see how
>     much can be refined based on discussion progress when v2 is out;
>
> -   Device-centric (Jason) vs. group-centric (David) uAPI. David is not fully
>     convinced yet. Based on discussion v2 will continue to have ioasid uAPI
>     being device-centric (but it's fine for vfio to be group-centric). A new
>     section will be added to elaborate this part;
>
> -   PASID virtualization (section 4) has not been thoroughly discussed yet. 
>     Jason gave some suggestion on how to categorize intended usages. 
>     I will rephrase this section and hope more discussions can be held for 
>     it in v2;
>
> (Adopted suggestions)
>
> -   (Jason) Rename /dev/ioasid to /dev/iommu (so does uAPI e.g. IOASID
>     _XXX to IOMMU_XXX). One suggestion (Jason) was to also rename 
>     RID+PASID to SID+SSID. But given the familiarity of the former, I will 
>     still use RID+PASID in v2 to ease the discussoin;
>
> -   (Jason) v1 prevents one device from binding to multiple ioasid_fd's. This 
>     will be fixed in v2;
>
> -   (Jean/Jason) No need to track guest I/O page tables on ARM/AMD. When 
>     a pasid table is bound, it becomes a container for all guest I/O page tables;
while I am totally in line with that change, I guess we need to revisit
the invalidate ioctl
to support PASID table invalidation.
>
> -   (Jean/Jason) Accordingly a device label is required so iotlb invalidation 
>     and fault handling can both support per-device operation. Per Jean's 
>     suggestion, this label will come from userspace (when VFIO_BIND_
>     IOASID_FD);

what is not totally clear to me is the correspondance between this label
and the SID/SSID tuple.
My understanding is it rather maps to the SID because you can attach
several ioasids to the device.
So it is not clear to me how you reconstruct the SSID info

Thanks

Eric
>
> -   (Jason) Addition of device label allows per-device capability/format 
>     check before IOASIDs are created. This leads to another major uAPI 
>     change in v2 - specify format info when creating an IOASID (mapping 
>     protocol, nesting, coherent, etc.). User is expected to check per-device 
>     format and then set proper format for IOASID upon to-be-attached 
>     device;

> -   (Jason/David) No restriction on map/unmap vs. bind/invalidate. They
>     can be used in either parent or child;
>
> -   (David) Change IOASID_GET_INFO to report permitted range instead of
>     reserved IOVA ranges. This works better for PPC;
>
> -   (Jason) For helper functions, expect to have explicit bus-type wrappers
>     e.g. ioasid_pci_device_attach;
>
> (Not adopted)
>
> -   (Parav) Make page pinning a syscall;
> -   (Jason. W/Enrico) one I/O page table per fd;
> -   (David) Replace IOASID_REGISTER_MEMORY through another ioasid
>     nesting (sort of passthrough mode). Need more thinking. v2 will not 
>     change this part;
>
> Thanks
> Kevin
>

