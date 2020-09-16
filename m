Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACF926BA39
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 04:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgIPCaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 22:30:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23727 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726321AbgIPCaV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Sep 2020 22:30:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600223419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YfVcMUyBmpQxAaCdcshCegUbTQs4WmvklIrNMK0GYnk=;
        b=ILMzlZZzI1yt+jNqtD3DCQ85MSNPD9opQOSf0xUWbknT2zXVP+ayjPI0xjBgQc3dgCImSB
        oIMtrQs6pVIy5w6Tt5Kb/1kZhHJCDMPc5Tx7lWQyPP3Rn8oLqjgkSTFAAmK3EPrxy8Lb50
        m6tv/8svsm3gYlDXTwwvKdcSlx5Yffc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-E8Qs7vjiPyKrzDp22o5iCw-1; Tue, 15 Sep 2020 22:30:17 -0400
X-MC-Unique: E8Qs7vjiPyKrzDp22o5iCw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7F8F802B60;
        Wed, 16 Sep 2020 02:30:15 +0000 (UTC)
Received: from [10.72.13.186] (ovpn-13-186.pek2.redhat.com [10.72.13.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD505702E7;
        Wed, 16 Sep 2020 02:29:56 +0000 (UTC)
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        eric.auger@redhat.com, baolu.lu@linux.intel.com, joro@8bytes.org,
        kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        peterx@redhat.com, hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
 <411c81c0-f13c-37cc-6c26-cafb42b46b15@redhat.com>
 <20200914133113.GB1375106@myrica>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5dd95fbf-054c-3bbc-e76b-2d5636214ff2@redhat.com>
Date:   Wed, 16 Sep 2020 10:29:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200914133113.GB1375106@myrica>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/9/14 下午9:31, Jean-Philippe Brucker wrote:
>> If it's possible, I would suggest a generic uAPI instead of a VFIO specific
>> one.
> A large part of this work is already generic uAPI, in
> include/uapi/linux/iommu.h.


This is not what I read from this series, all the following uAPI is VFIO 
specific:

struct vfio_iommu_type1_nesting_op;
struct vfio_iommu_type1_pasid_request;

And include/uapi/linux/iommu.h is not included in 
include/uapi/linux/vfio.h at all.



> This patchset connects that generic interface
> to the pre-existing VFIO uAPI that deals with IOMMU mappings of an
> assigned device. But the bulk of the work is done by the IOMMU subsystem,
> and is available to all device drivers.


So any reason not introducing the uAPI to IOMMU drivers directly?


>
>> Jason suggest something like /dev/sva. There will be a lot of other
>> subsystems that could benefit from this (e.g vDPA).
> Do you have a more precise idea of the interface /dev/sva would provide,
> how it would interact with VFIO and others?


Can we replace the container fd with sva fd like:

sva = open("/dev/sva", O_RDWR);
group = open("/dev/vfio/26", O_RDWR);
ioctl(group, VFIO_GROUP_SET_SVA, &sva);

Then we can do all SVA stuffs through sva fd, and for other subsystems 
(like vDPA) it only need to implement the function that is equivalent to 
VFIO_GROUP_SET_SVA.


>    vDPA could transport the
> generic iommu.h structures via its own uAPI, and call the IOMMU API
> directly without going through an intermediate /dev/sva handle.


Any value for those transporting? I think we have agreed that VFIO is 
not the only user for vSVA ...

It's not hard to forecast that there would be more subsystems that want 
to benefit from vSVA, we don't want to duplicate the similar uAPIs in 
all of those subsystems.

Thanks


>
> Thanks,
> Jean
>

