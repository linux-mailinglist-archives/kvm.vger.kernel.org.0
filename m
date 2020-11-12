Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96BE92B0451
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 12:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgKLLth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 06:49:37 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2061 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728151AbgKLLtb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Nov 2020 06:49:31 -0500
Received: from dggeme753-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4CX0Hn5NMjzVnBN;
        Thu, 12 Nov 2020 19:49:09 +0800 (CST)
Received: from [10.174.184.120] (10.174.184.120) by
 dggeme753-chm.china.huawei.com (10.3.19.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Thu, 12 Nov 2020 19:49:28 +0800
Subject: Re: [PATCH] vfio iommu type1: Improve vfio_iommu_type1_pin_pages
 performance
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <kwankhede@nvidia.com>, <wu.wubin@huawei.com>,
        <maoming.maoming@huawei.com>, <xieyingtai@huawei.com>,
        <lizhengui@huawei.com>, <wubinfeng@huawei.com>
References: <2553f102-de17-b23b-4cd8-fefaf2a04f24@huawei.com>
 <20201111085639.7235fb42@w520.home>
From:   "xuxiaoyang (C)" <xuxiaoyang2@huawei.com>
Message-ID: <928f2c25-6a39-a9c0-64eb-05933fd46ce5@huawei.com>
Date:   Thu, 12 Nov 2020 19:49:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201111085639.7235fb42@w520.home>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.120]
X-ClientProxiedBy: dggeme703-chm.china.huawei.com (10.1.199.99) To
 dggeme753-chm.china.huawei.com (10.3.19.99)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/11/11 23:56, Alex Williamson wrote:
> On Tue, 10 Nov 2020 21:42:33 +0800
> "xuxiaoyang (C)" <xuxiaoyang2@huawei.com> wrote:
> 
>> vfio_iommu_type1_pin_pages is very inefficient because
>> it is processed page by page when calling vfio_pin_page_external.
>> Added contiguous_vaddr_get_pfn to process continuous pages
>> to reduce the number of loops, thereby improving performance.
> 
> vfio_pin_pages() accepts an array of unrelated iova pfns and processes
> each to return the physical pfn.  AFAICT this proposal makes an
> unfounded and unverified assumption that the caller is asking for a
> range of contiguous iova pfns.  That's not the semantics of the call.
> This is wrong.  Thanks,
> 
> Alex
> 
> .
> 
Thank you for your reply.  Sorry that the comment is too simple
and not clear enough.
We did not change the external behavior of the function.  What we
have to do is to divide the iova pfn array into multiple continuous
ranges and optimize them.  For example, when the iova pfn array is
{1,5,6,7,9}, it will be divided into three groups {1}, {5,6,7}, {9}
for processing.  When processing {5,6,7}, the number of calls to
pin_user_pages_remote is reduced from 3 times to once.  The more
continuous the iova pfn array, the greater the performance improvement.
I see that most of the iova pfn arrays processed by callers are
continuous, such as pfn_array_pin, gvt_pin_guest_page.  For them,
performance will be improved.

Regards,
Xu
