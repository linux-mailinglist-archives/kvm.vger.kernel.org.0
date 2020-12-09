Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D5F2D44A4
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 15:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733063AbgLIOpR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 09:45:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23670 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733060AbgLIOpJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 09:45:09 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B9EXfMg167391;
        Wed, 9 Dec 2020 09:42:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9yaToXePl5w30PZNMLzXKenGOVLUECi6fnk4Bwg1kqs=;
 b=egH335cyF4EjWtM14prZHcXm1ncwClP38Bi8eTZcJJ/MxRY9ZhaF6ze5TsExStyD5UnQ
 6C4yxz8rdZ+5iPWAGRC919JIZLKAq/qQlkb7+UOGyR9nLNG4sVSGOX7EwEXmw7IJkm0M
 wjLwDIWexNLZzBIRNsb1wci7MQYCsC0HtlJcIziITUqWKdxAg09uFWv3XOtzvHA6OF6m
 igc3qWZa8BdGD0F6lVt6eoazgejts8wg+Z+WtHPfjtddCjuoW9BKRejPybcX9ijErFUH
 BQzKwDJPRJphYrGTfFrtK6igoWKWKPx2NA0ZOmhcXuLMwxkAXILCa1z1ZIBcEGrCafmm AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35avder39x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 09:42:51 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B9EYpfd178675;
        Wed, 9 Dec 2020 09:42:51 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35avder35a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 09:42:51 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B9Ec9rQ009612;
        Wed, 9 Dec 2020 14:42:41 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 3581ua06gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 14:42:41 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B9Ege1S12059340
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 14:42:40 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94DB428059;
        Wed,  9 Dec 2020 14:42:40 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A28E228058;
        Wed,  9 Dec 2020 14:42:38 +0000 (GMT)
Received: from [9.211.50.183] (unknown [9.211.50.183])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  9 Dec 2020 14:42:38 +0000 (GMT)
Subject: Re: [PATCH v2] vfio iommu type1: Improve vfio_iommu_type1_pin_pages
 performance
To:     Cornelia Huck <cohuck@redhat.com>,
        "xuxiaoyang (C)" <xuxiaoyang2@huawei.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        kwankhede@nvidia.com, wu.wubin@huawei.com,
        maoming.maoming@huawei.com, xieyingtai@huawei.com,
        lizhengui@huawei.com, wubinfeng@huawei.com,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
References: <60d22fc6-88d6-c7c2-90bd-1e8eccb1fdcc@huawei.com>
 <4d58b74d-72bb-6473-9523-aeaa392a470e@huawei.com>
 <20201209125450.3f5834ab.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <9e37b8d9-3654-5b89-e3b4-5e6ede736320@linux.ibm.com>
Date:   Wed, 9 Dec 2020 09:42:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201209125450.3f5834ab.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_13:2020-12-09,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1011 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501
 suspectscore=9 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/9/20 6:54 AM, Cornelia Huck wrote:
> On Tue, 8 Dec 2020 21:55:53 +0800
> "xuxiaoyang (C)" <xuxiaoyang2@huawei.com> wrote:
> 
>> On 2020/11/21 15:58, xuxiaoyang (C) wrote:
>>> vfio_pin_pages() accepts an array of unrelated iova pfns and processes
>>> each to return the physical pfn.  When dealing with large arrays of
>>> contiguous iovas, vfio_iommu_type1_pin_pages is very inefficient because
>>> it is processed page by page.In this case, we can divide the iova pfn
>>> array into multiple continuous ranges and optimize them.  For example,
>>> when the iova pfn array is {1,5,6,7,9}, it will be divided into three
>>> groups {1}, {5,6,7}, {9} for processing.  When processing {5,6,7}, the
>>> number of calls to pin_user_pages_remote is reduced from 3 times to once.
>>> For single page or large array of discontinuous iovas, we still use
>>> vfio_pin_page_external to deal with it to reduce the performance loss
>>> caused by refactoring.
>>>
>>> Signed-off-by: Xiaoyang Xu <xuxiaoyang2@huawei.com>
> 
> (...)
> 
>>
>> hi Cornelia Huck, Eric Farman, Zhenyu Wang, Zhi Wang
>>
>> vfio_pin_pages() accepts an array of unrelated iova pfns and processes
>> each to return the physical pfn.  When dealing with large arrays of
>> contiguous iovas, vfio_iommu_type1_pin_pages is very inefficient because
>> it is processed page by page.  In this case, we can divide the iova pfn
>> array into multiple continuous ranges and optimize them.  I have a set
>> of performance test data for reference.
>>
>> The patch was not applied
>>                      1 page           512 pages
>> no huge pages：     1638ns           223651ns
>> THP：               1668ns           222330ns
>> HugeTLB：           1526ns           208151ns
>>
>> The patch was applied
>>                      1 page           512 pages
>> no huge pages       1735ns           167286ns
>> THP：               1934ns           126900ns
>> HugeTLB：           1713ns           102188ns
>>
>> As Alex Williamson said, this patch lacks proof that it works in the
>> real world. I think you will have some valuable opinions.
> 
> Looking at this from the vfio-ccw angle, I'm not sure how much this
> would buy us, as we deal with IDAWs, which are designed so that they
> can be non-contiguous. I guess this depends a lot on what the guest
> does.

This would be my concern too, but I don't have data off the top of my 
head to say one way or another...

> 
> Eric, any opinion? Do you maybe also happen to have a test setup that
> mimics workloads actually seen in the real world?
> 

...I do have some test setups, which I will try to get some data from in 
a couple days. At the moment I've broken most of those setups trying to 
implement some other stuff, and can't revert back at the moment. Will 
get back to this.

Eric
