Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9F9818C153
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 21:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgCSUZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 16:25:24 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9017 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbgCSUZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 16:25:24 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e73d5260000>; Thu, 19 Mar 2020 13:25:10 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 19 Mar 2020 13:25:23 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 19 Mar 2020 13:25:23 -0700
Received: from [10.40.102.54] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 19 Mar
 2020 20:25:14 +0000
Subject: Re: [PATCH v14 Kernel 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cjia@nvidia.com>, <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <1584560474-19946-1-git-send-email-kwankhede@nvidia.com>
 <1584560474-19946-5-git-send-email-kwankhede@nvidia.com>
 <20200318214500.1a0cb985@w520.home>
 <e0070cf4-af58-2906-b427-0888ecb89538@nvidia.com>
 <20200319102238.77686a08@w520.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <8e537411-b60e-cc45-498c-5e516382206e@nvidia.com>
Date:   Fri, 20 Mar 2020 01:55:10 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200319102238.77686a08@w520.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1584649510; bh=x7i8QtLfAseF52v4fyGyBaaNiiKUfP8Yw3d6ILWuXNA=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ceHPQzEf0GB16z5/jaC/mJzemnbL0F6IBcSzY2P/hXjR7AhKY3HAJ/Vju57U7NIqR
         +F0DLxcSASh5BHLKrbj/tr9N5WunMK9/7Ey3SfW7WeAF0RmEz09eLEZPXdkhQIrRkP
         iOZ+pjJvn0WPjWSt+SC1J4thsZNFSA5iPXWe+/DiSU9d32zBJ0iB3EdTXraFObvibN
         bSGqMMHxGtSlTniJaQG8ce6/L0BSPJ6v2U3wyxI953gC2Dr/ixaqGwdPKpLiheY0d3
         n6jYRDRwxwI66ED4vj7jeS0EhzJdTqXl0slf9wS5Gd/If1XkrH/arjaQEpj/nGVJfB
         qv+X9SPuunQ8A==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/19/2020 9:52 PM, Alex Williamson wrote:
> On Thu, 19 Mar 2020 20:22:41 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> On 3/19/2020 9:15 AM, Alex Williamson wrote:
>>> On Thu, 19 Mar 2020 01:11:11 +0530
>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>    

<snip>

>>>> +
>>>> +static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
>>>> +{
>>>> +	uint64_t bsize;
>>>> +
>>>> +	if (!npages || !bitmap_size || bitmap_size > UINT_MAX)
>>>
>>> As commented previously, how do we derive this UINT_MAX limitation?
>>>    
>>
>> Sorry, I missed that earlier
>>
>>   > UINT_MAX seems arbitrary, is this specified in our API?  The size of a
>>   > vfio_dma is limited to what the user is able to pin, and therefore
>>   > their locked memory limit, but do we have an explicit limit elsewhere
>>   > that results in this limit here.  I think a 4GB bitmap would track
>>   > something like 2^47 bytes of memory, that's pretty excessive, but still
>>   > an arbitrary limit.
>>
>> There has to be some upper limit check. In core KVM, in
>> virt/kvm/kvm_main.c there is max number of pages check:
>>
>> if (new.npages > KVM_MEM_MAX_NR_PAGES)
>>
>> Where
>> /*
>>    * Some of the bitops functions do not support too long bitmaps.
>>    * This number must be determined not to exceed such limits.
>>    */
>> #define KVM_MEM_MAX_NR_PAGES ((1UL << 31) - 1)
>>
>> Though I don't know which bitops functions do not support long bitmaps.
>>
>> Something similar as above can be done or same as you also mentioned of
>> 4GB bitmap limit? that is U32_MAX instead of UINT_MAX?
> 
> Let's see, we use bitmap_set():
> 
> void bitmap_set(unsigned long *map, unsigned int start, unsigned int nbits)
> 
> So we're limited to an unsigned int number of bits, but for an
> unaligned, multi-bit operation this will call __bitmap_set():
> 
> void __bitmap_set(unsigned long *map, unsigned int start, int len)
> 
> So we're down to a signed int number of bits (seems like an API bug in
> bitops there), so it makes sense that KVM is testing against MAX_INT
> number of pages, ie. number of bits.  But that still suggests a bitmap
> size of MAX_UINT is off by a factor of 16.  So we can have 2^31 bits
> divided by 2^3 bits/byte yields a maximum bitmap size of 2^28 (ie.
> 256MB), which maps 2^31 * 2^12 = 2^43 (8TB) on a 4K system.
> 
> Let's fix the limit check and put a nice comment explaining it.  Thanks,
> 

Agreed. Adding DIRTY_BITMAP_SIZE_MAX macro and comment as below.

/*
  * Input argument of number of bits to bitmap_set() is unsigned 
integer, which
  * further casts to signed integer for unaligned multi-bit operation,
  * __bitmap_set().
  * Then maximum bitmap size supported is 2^31 bits divided by 2^3 
bits/byte,
  * that is 2^28 (256 MB) which maps to 2^31 * 2^12 = 2^43 (8TB) on 4K page
  * system.
  */
#define DIRTY_BITMAP_PAGES_MAX  ((1UL << 31) - 1)
#define DIRTY_BITMAP_SIZE_MAX 	\
			DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)


Thanks,
Kirti
