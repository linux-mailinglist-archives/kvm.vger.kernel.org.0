Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5691E2DADDB
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 14:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbgLONOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 08:14:03 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:2336 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728653AbgLONNy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 08:13:54 -0500
Received: from dggeme753-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4CwJZG3py7z13R23;
        Tue, 15 Dec 2020 21:12:06 +0800 (CST)
Received: from [10.174.184.120] (10.174.184.120) by
 dggeme753-chm.china.huawei.com (10.3.19.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 15 Dec 2020 21:13:08 +0800
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
 <a585357e-6796-7bf4-ef37-185617e2a865@huawei.com>
 <78a066b2-9b08-accd-77d4-d367b588c114@linux.ibm.com>
From:   "xuxiaoyang (C)" <xuxiaoyang2@huawei.com>
Message-ID: <0ebcc7b0-2984-1b30-2cc7-a569306488a5@huawei.com>
Date:   Tue, 15 Dec 2020 21:13:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <78a066b2-9b08-accd-77d4-d367b588c114@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.120]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggeme753-chm.china.huawei.com (10.3.19.99)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/12/15 2:58, Eric Farman wrote:
> 
> 
> On 12/10/20 8:56 AM, xuxiaoyang (C) wrote:
>>
>>
>> On 2020/12/9 22:42, Eric Farman wrote:
>>>
>>>
>>> On 12/9/20 6:54 AM, Cornelia Huck wrote:
>>>> On Tue, 8 Dec 2020 21:55:53 +0800
>>>> "xuxiaoyang (C)" <xuxiaoyang2@huawei.com> wrote:
>>>>
>>>>> On 2020/11/21 15:58, xuxiaoyang (C) wrote:
>>>>>> vfio_pin_pages() accepts an array of unrelated iova pfns and processes
>>>>>> each to return the physical pfn.  When dealing with large arrays of
>>>>>> contiguous iovas, vfio_iommu_type1_pin_pages is very inefficient because
>>>>>> it is processed page by page.In this case, we can divide the iova pfn
>>>>>> array into multiple continuous ranges and optimize them.  For example,
>>>>>> when the iova pfn array is {1,5,6,7,9}, it will be divided into three
>>>>>> groups {1}, {5,6,7}, {9} for processing.  When processing {5,6,7}, the
>>>>>> number of calls to pin_user_pages_remote is reduced from 3 times to once.
>>>>>> For single page or large array of discontinuous iovas, we still use
>>>>>> vfio_pin_page_external to deal with it to reduce the performance loss
>>>>>> caused by refactoring.
>>>>>>
>>>>>> Signed-off-by: Xiaoyang Xu <xuxiaoyang2@huawei.com>
>>>>
>>>> (...)
>>>>
>>>>>
>>>>> hi Cornelia Huck, Eric Farman, Zhenyu Wang, Zhi Wang
>>>>>
>>>>> vfio_pin_pages() accepts an array of unrelated iova pfns and processes
>>>>> each to return the physical pfn.  When dealing with large arrays of
>>>>> contiguous iovas, vfio_iommu_type1_pin_pages is very inefficient because
>>>>> it is processed page by page.  In this case, we can divide the iova pfn
>>>>> array into multiple continuous ranges and optimize them.  I have a set
>>>>> of performance test data for reference.
>>>>>
>>>>> The patch was not applied
>>>>>                       1 page           512 pages
>>>>> no huge pages：     1638ns           223651ns
>>>>> THP：               1668ns           222330ns
>>>>> HugeTLB：           1526ns           208151ns
>>>>>
>>>>> The patch was applied
>>>>>                       1 page           512 pages
>>>>> no huge pages       1735ns           167286ns
>>>>> THP：               1934ns           126900ns
>>>>> HugeTLB：           1713ns           102188ns
>>>>>
>>>>> As Alex Williamson said, this patch lacks proof that it works in the
>>>>> real world. I think you will have some valuable opinions.
>>>>
>>>> Looking at this from the vfio-ccw angle, I'm not sure how much this
>>>> would buy us, as we deal with IDAWs, which are designed so that they
>>>> can be non-contiguous. I guess this depends a lot on what the guest
>>>> does.
>>>
>>> This would be my concern too, but I don't have data off the top of my head to say one way or another...
>>>
>>>>
>>>> Eric, any opinion? Do you maybe also happen to have a test setup that
>>>> mimics workloads actually seen in the real world?
>>>>
>>>
>>> ...I do have some test setups, which I will try to get some data from in a couple days. At the moment I've broken most of those setups trying to implement some other stuff, and can't revert back at the moment. Will get back to this.
>>>
>>> Eric
>>> .
>>
>> Thank you for your reply. Looking forward to your test data.
> 
> Xu,
> 
> The scenario I ran was a host kernel 5.10.0-rc7 with qemu 5.2.0, with a Fedora 32 guest with 4 VCPU and 4GB memory. I tried this a handful of times across a couple different hosts, so the likelihood that these numbers are outliers are pretty low. The histograms below come from a simple bpftrace, recording the number of pages asked to be pinned, and the length of time (in nanoseconds) it took to pin all those pages. I separated out the length of time for a request of one page versus a request of multiple pages, because as you will see the former far outnumbers the latter.
> 
> The first thing I tried was simply to boot the guest via vfio-ccw, to see how the patch itself behaved:
> 
> @1_page_ns    BASE        +PATCH
> 256, 512    12531    42.50%    12744    42.26%
> 512, 1K        5660    19.20%    5611    18.61%
> 1K, 2K        8416    28.54%    8947    29.67%
> 2K, 4K        2694    9.14%    2669    8.85%
> 4K, 8K        164    0.56%    169    0.56%
> 8K, 16K        14    0.05%    14    0.05%
> 16K, 32K    2    0.01%    3    0.01%
> 32K, 64K    0    0.00%    0    0.00%
> 64K, 128K    0    0.00%    0    0.00%
> 
> @n_pages_ns    BASE        +PATCH
> 256, 512    0    0.00%    0    0.00%
> 512, 1K        67    0.97%    48    0.68%
> 1K, 2K        1598    23.13%    1036    14.71%
> 2K, 4K        2784    40.30%    3112    44.17%
> 4K, 8K        1288    18.64%    1579    22.41%
> 8K, 16K        1011    14.63%    1032    14.65%
> 16K, 32K    159    2.30%    234    3.32%
> 32K, 64K    1    0.01%    2    0.03%
> 64K, 128K    0    0.00%    2    0.03%
> 
> @npage        BASE        +PATCH
> 1        29484    81.02%    30157    81.06%
> 2, 4        3298    9.06%    3385    9.10%
> 4, 8        1011    2.78%    1029    2.77%
> 8, 16        2600    7.14%    2631    7.07%
> 
> 
> The second thing I tried was simply fio, running it for about 10 minutes with a few minutes each for sequential read, sequential write, random read, and random write. (I tried this with both the guest booted off vfio-ccw and virtio-blk, but the difference was negligible.) The results in this space are similar as well:
> 
> @1_page_ns    BASE        +PATCH
> 256, 512    5648104    66.79%    6615878    66.75%
> 512, 1K        1784047    21.10%    2082852    21.01%
> 1K, 2K        648877    7.67%    771964    7.79%
> 2K, 4K        339551    4.01%    396381    4.00%
> 4K, 8K        32513    0.38%    40359    0.41%
> 8K, 16K        2602    0.03%    2884    0.03%
> 16K, 32K    758    0.01%    762    0.01%
> 32K, 64K    434    0.01%    352    0.00%
> 
> @n_pages_ns    BASE        +PATCH
> 256, 512    0    0.00%    0    0.00%
> 512, 1K        470803    12.18%    360524    7.95%
> 1K, 2K        1305166    33.75%    1739183    38.37%
> 2K, 4K        1338277    34.61%    1471161    32.46%
> 4K, 8K        733480    18.97%    937341    20.68%
> 8K, 16K        16954    0.44%    20708    0.46%
> 16K, 32K    1278    0.03%    2197    0.05%
> 32K, 64K    707    0.02%    703    0.02%
> 
> @npage        BASE        +PATCH
> 1        8457107    68.62%    9911624    68.62%
> 2, 4        2066957    16.77%    2446462    16.94%
> 4, 8        359989    2.92%    417188    2.89%
> 8, 16        1440006    11.68%    1668482    11.55%
> 
> 
> I tried a smattering of other tests that might be more realistic, but the results were all pretty similar so there's no point in appending them here. Across the board, the amount of time spent on a multi-page request grows with the supplied patch. It doesn't get me very excited.
> 
> If you are wondering why this might be, Conny's initial take about IDAWs being non-contiguous by design is spot on. Let's observe the page counts given to vfio_iommu_type1_pin_contiguous_pages() in addition to the counts in vfio_iommu_type1_pin_pages(). The following is an example of one guest boot PLUS an fio run:
> 
> vfio_iommu_type1_pin_pages npage:
> 1    9890332        68.64%
> 2, 4    2438213        16.92%
> 4, 8    416278        2.89%
> 8, 16    1663201        11.54%
> Total    14408024   
> 
> vfio_iommu_type1_pin_contiguous_pages npage:
> 1    16384925    86.89%
> 2, 4    1327548        7.04%
> 4, 8    727564        3.86%
> 8, 16    417182        2.21%
> Total    18857219   
> 
> Yup... 87% of the calls to vfio_iommu_type1_pin_contiguous_pages() do so with a length of just a single page.
> 
> Happy to provide more data if desired, but it doesn't look like a benefit to vfio-ccw's use.
> 
> Thanks,
> Eric
> 
> 
Eric, vfio-ccw pin single page accounted for 87%,
and the length of continuous pages is very short.
In my test data, the continuous page length is 512,
which is a huge difference.  It is easy to understand
that this patch does not benefit vfio-ccw.
Finally, thank you very much for your test data.

Regards,
Xu
>>
>> Regards,
>> Xu
>>
> .
