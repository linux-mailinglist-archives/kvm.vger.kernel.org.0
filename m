Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479582687B1
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 10:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgINI5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 04:57:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24696 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726141AbgINI5v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 04:57:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600073869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YIJkrzhUk3QzbTz9NV6zmhe9KdqWnaUCwTM1thADjSg=;
        b=QItLw1yO3jv3th5EIFpQYh9HZsk8pVz/JTXMTHQ97z5z/FsG5dN8Ygdi84He+ELddOqgcT
        N62hUTHUrhJUafR5YBbsH8FeIFR5QJzmrYZjii1y1+8yqcTTrCfn+sNIW/NU5PiwSjiO7w
        3MOPoeVUg9Fr/yTpOLC+8b+Be3zQiPk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-7jUavzc9PpqCt50acZ--Jw-1; Mon, 14 Sep 2020 04:57:46 -0400
X-MC-Unique: 7jUavzc9PpqCt50acZ--Jw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD9E618B9EC1;
        Mon, 14 Sep 2020 08:57:43 +0000 (UTC)
Received: from [10.72.13.25] (ovpn-13-25.pek2.redhat.com [10.72.13.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A66BF60C87;
        Mon, 14 Sep 2020 08:57:26 +0000 (UTC)
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Cc:     "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
 <411c81c0-f13c-37cc-6c26-cafb42b46b15@redhat.com>
 <MWHPR11MB164517F15EF2C4831C191CF28C230@MWHPR11MB1645.namprd11.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c3e07f47-3ce9-caf4-8a01-b68fdaae853d@redhat.com>
Date:   Mon, 14 Sep 2020 16:57:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB164517F15EF2C4831C191CF28C230@MWHPR11MB1645.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/9/14 下午4:01, Tian, Kevin wrote:
>> From: Jason Wang <jasowang@redhat.com>
>> Sent: Monday, September 14, 2020 12:20 PM
>>
>> On 2020/9/10 下午6:45, Liu Yi L wrote:
>>> Shared Virtual Addressing (SVA), a.k.a, Shared Virtual Memory (SVM) on
>>> Intel platforms allows address space sharing between device DMA and
>>> applications. SVA can reduce programming complexity and enhance
>> security.
>>> This VFIO series is intended to expose SVA usage to VMs. i.e. Sharing
>>> guest application address space with passthru devices. This is called
>>> vSVA in this series. The whole vSVA enabling requires QEMU/VFIO/IOMMU
>>> changes. For IOMMU and QEMU changes, they are in separate series (listed
>>> in the "Related series").
>>>
>>> The high-level architecture for SVA virtualization is as below, the key
>>> design of vSVA support is to utilize the dual-stage IOMMU translation (
>>> also known as IOMMU nesting translation) capability in host IOMMU.
>>>
>>>
>>>       .-------------.  .---------------------------.
>>>       |   vIOMMU    |  | Guest process CR3, FL only|
>>>       |             |  '---------------------------'
>>>       .----------------/
>>>       | PASID Entry |--- PASID cache flush -
>>>       '-------------'                       |
>>>       |             |                       V
>>>       |             |                CR3 in GPA
>>>       '-------------'
>>> Guest
>>> ------| Shadow |--------------------------|--------
>>>         v        v                          v
>>> Host
>>>       .-------------.  .----------------------.
>>>       |   pIOMMU    |  | Bind FL for GVA-GPA  |
>>>       |             |  '----------------------'
>>>       .----------------/  |
>>>       | PASID Entry |     V (Nested xlate)
>>>       '----------------\.------------------------------.
>>>       |             ||SL for GPA-HPA, default domain|
>>>       |             |   '------------------------------'
>>>       '-------------'
>>> Where:
>>>    - FL = First level/stage one page tables
>>>    - SL = Second level/stage two page tables
>>>
>>> Patch Overview:
>>>    1. reports IOMMU nesting info to userspace ( patch 0001, 0002, 0003,
>> 0015 , 0016)
>>>    2. vfio support for PASID allocation and free for VMs (patch 0004, 0005,
>> 0007)
>>>    3. a fix to a revisit in intel iommu driver (patch 0006)
>>>    4. vfio support for binding guest page table to host (patch 0008, 0009,
>> 0010)
>>>    5. vfio support for IOMMU cache invalidation from VMs (patch 0011)
>>>    6. vfio support for vSVA usage on IOMMU-backed mdevs (patch 0012)
>>>    7. expose PASID capability to VM (patch 0013)
>>>    8. add doc for VFIO dual stage control (patch 0014)
>>
>> If it's possible, I would suggest a generic uAPI instead of a VFIO
>> specific one.
>>
>> Jason suggest something like /dev/sva. There will be a lot of other
>> subsystems that could benefit from this (e.g vDPA).
>>
> Just be curious. When does vDPA subsystem plan to support vSVA and
> when could one expect a SVA-capable vDPA device in market?
>
> Thanks
> Kevin


vSVA is in the plan but there's no ETA. I think we might start the work 
after control vq support.  It will probably start from SVA first and 
then vSVA (since it might require platform support).

For the device part, it really depends on the chipset and other device 
vendors. We plan to do the prototype in virtio by introducing PASID 
support in the spec.

Thanks


