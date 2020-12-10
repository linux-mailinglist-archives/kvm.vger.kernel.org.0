Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335E82D5CB4
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 15:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389761AbgLJOCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 09:02:10 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2089 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389750AbgLJN4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 08:56:44 -0500
Received: from dggeme753-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4CsFm91zPlzVmqm;
        Thu, 10 Dec 2020 21:55:05 +0800 (CST)
Received: from [10.174.184.120] (10.174.184.120) by
 dggeme753-chm.china.huawei.com (10.3.19.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Thu, 10 Dec 2020 21:56:00 +0800
Subject: Re: [PATCH v2] vfio iommu type1: Improve vfio_iommu_type1_pin_pages
 performance
To:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        <kwankhede@nvidia.com>, <wu.wubin@huawei.com>,
        <maoming.maoming@huawei.com>, <xieyingtai@huawei.com>,
        <lizhengui@huawei.com>, <wubinfeng@huawei.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
References: <60d22fc6-88d6-c7c2-90bd-1e8eccb1fdcc@huawei.com>
 <4d58b74d-72bb-6473-9523-aeaa392a470e@huawei.com>
 <20201209125450.3f5834ab.cohuck@redhat.com>
 <9e37b8d9-3654-5b89-e3b4-5e6ede736320@linux.ibm.com>
From:   "xuxiaoyang (C)" <xuxiaoyang2@huawei.com>
Message-ID: <a585357e-6796-7bf4-ef37-185617e2a865@huawei.com>
Date:   Thu, 10 Dec 2020 21:56:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <9e37b8d9-3654-5b89-e3b4-5e6ede736320@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.120]
X-ClientProxiedBy: dggeme710-chm.china.huawei.com (10.1.199.106) To
 dggeme753-chm.china.huawei.com (10.3.19.99)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/12/9 22:42, Eric Farman wrote:
> 
> 
> On 12/9/20 6:54 AM, Cornelia Huck wrote:
>> On Tue, 8 Dec 2020 21:55:53 +0800
>> "xuxiaoyang (C)" <xuxiaoyang2@huawei.com> wrote:
>>
>>> On 2020/11/21 15:58, xuxiaoyang (C) wrote:
>>>> vfio_pin_pages() accepts an array of unrelated iova pfns and processes
>>>> each to return the physical pfn.  When dealing with large arrays of
>>>> contiguous iovas, vfio_iommu_type1_pin_pages is very inefficient because
>>>> it is processed page by page.In this case, we can divide the iova pfn
>>>> array into multiple continuous ranges and optimize them.  For example,
>>>> when the iova pfn array is {1,5,6,7,9}, it will be divided into three
>>>> groups {1}, {5,6,7}, {9} for processing.  When processing {5,6,7}, the
>>>> number of calls to pin_user_pages_remote is reduced from 3 times to once.
>>>> For single page or large array of discontinuous iovas, we still use
>>>> vfio_pin_page_external to deal with it to reduce the performance loss
>>>> caused by refactoring.
>>>>
>>>> Signed-off-by: Xiaoyang Xu <xuxiaoyang2@huawei.com>
>>
>> (...)
>>
>>>
>>> hi Cornelia Huck, Eric Farman, Zhenyu Wang, Zhi Wang
>>>
>>> vfio_pin_pages() accepts an array of unrelated iova pfns and processes
>>> each to return the physical pfn.  When dealing with large arrays of
>>> contiguous iovas, vfio_iommu_type1_pin_pages is very inefficient because
>>> it is processed page by page.  In this case, we can divide the iova pfn
>>> array into multiple continuous ranges and optimize them.  I have a set
>>> of performance test data for reference.
>>>
>>> The patch was not applied
>>>                      1 page           512 pages
>>> no huge pages：     1638ns           223651ns
>>> THP：               1668ns           222330ns
>>> HugeTLB：           1526ns           208151ns
>>>
>>> The patch was applied
>>>                      1 page           512 pages
>>> no huge pages       1735ns           167286ns
>>> THP：               1934ns           126900ns
>>> HugeTLB：           1713ns           102188ns
>>>
>>> As Alex Williamson said, this patch lacks proof that it works in the
>>> real world. I think you will have some valuable opinions.
>>
>> Looking at this from the vfio-ccw angle, I'm not sure how much this
>> would buy us, as we deal with IDAWs, which are designed so that they
>> can be non-contiguous. I guess this depends a lot on what the guest
>> does.
> 
> This would be my concern too, but I don't have data off the top of my head to say one way or another...
> 
>>
>> Eric, any opinion? Do you maybe also happen to have a test setup that
>> mimics workloads actually seen in the real world?
>>
> 
> ...I do have some test setups, which I will try to get some data from in a couple days. At the moment I've broken most of those setups trying to implement some other stuff, and can't revert back at the moment. Will get back to this.
> 
> Eric
> .

Thank you for your reply. Looking forward to your test data.

Regards,
Xu
