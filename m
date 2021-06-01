Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B824396C51
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 06:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhFAE3u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 00:29:50 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6101 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhFAE3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 00:29:48 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FvJww3HQczYnKJ;
        Tue,  1 Jun 2021 12:25:20 +0800 (CST)
Received: from dggpemm500022.china.huawei.com (7.185.36.162) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 12:28:03 +0800
Received: from [10.174.185.220] (10.174.185.220) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 12:28:02 +0800
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Jason Wang <jasowang@redhat.com>,
        Liu Yi L <yi.l.liu@linux.intel.com>
CC:     <yi.l.liu@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "Jason Gunthorpe" <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)\"" 
        <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <f510f916-e91c-236d-e938-513a5992d3b5@redhat.com>
 <20210531164118.265789ee@yiliu-dev>
 <78ee2638-1a03-fcc8-50a5-81040f677e69@redhat.com>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <1fedcd93-1a8a-884f-d0c8-3e2c21ed7654@huawei.com>
Date:   Tue, 1 Jun 2021 12:27:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <78ee2638-1a03-fcc8-50a5-81040f677e69@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.185.220]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500022.china.huawei.com (7.185.36.162)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/6/1 10:36, Jason Wang wrote:
> 
> 在 2021/5/31 下午4:41, Liu Yi L 写道:
>>> I guess VFIO_ATTACH_IOASID will fail if the underlayer doesn't support
>>> hardware nesting. Or is there way to detect the capability before?
>> I think it could fail in the IOASID_CREATE_NESTING. If the gpa_ioasid
>> is not able to support nesting, then should fail it.
>>
>>> I think GET_INFO only works after the ATTACH.
>> yes. After attaching to gpa_ioasid, userspace could GET_INFO on the
>> gpa_ioasid and check if nesting is supported or not. right?
> 
> 
> Some more questions:
> 
> 1) Is the handle returned by IOASID_ALLOC an fd?
> 2) If yes, what's the reason for not simply use the fd opened from /dev/ioas. (This is the question that is not answered) and what happens if we call GET_INFO for the ioasid_fd?
> 3) If not, how GET_INFO work?

It seems that the return value from IOASID_ALLOC is an IOASID number in the
ioasid_data struct, then when calling GET_INFO, we should convey this IOASID
number to get the associated I/O address space attributes (depend on the
physical IOMMU, which could be discovered when attaching a device to the
IOASID fd or number), right?

Thanks,
Shenming
