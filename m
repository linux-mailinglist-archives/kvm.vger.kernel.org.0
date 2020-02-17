Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3DE161B5E
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 20:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbgBQTPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 14:15:49 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:3134 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728467AbgBQTPt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 14:15:49 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e4ae6550000>; Mon, 17 Feb 2020 11:15:33 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 17 Feb 2020 11:15:47 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 17 Feb 2020 11:15:47 -0800
Received: from [10.40.101.150] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 17 Feb
 2020 19:15:39 +0000
Subject: Re: [PATCH v12 Kernel 4/7] vfio iommu: Implementation of ioctl to for
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
References: <1581104554-10704-1-git-send-email-kwankhede@nvidia.com>
 <1581104554-10704-5-git-send-email-kwankhede@nvidia.com>
 <20200210102518.490a0d87@x1.home>
 <7e7356c8-29ed-31fa-5c0b-2545ae69f321@nvidia.com>
 <20200212161320.02d8dfac@w520.home>
 <0244aca6-80f7-1c1d-812e-d53a48b5479d@nvidia.com>
 <20200213162011.40b760a8@w520.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <ea31fb62-4cd3-babb-634d-f69407586c93@nvidia.com>
Date:   Tue, 18 Feb 2020 00:43:48 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200213162011.40b760a8@w520.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1581966934; bh=gPFV0Y0pPxA2TA6/tLp+Eq0+DXXPNACSUKfk29WUrfw=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=bqUUm70vLGG3uWVQKjuAK7CYynUzgiMBQO7IIDhOMUtlip1qgj5oNe2DBZ78FvRxJ
         7DCc8P5gxvQuyjqtdM2b4rvKdqtTdjJ6yo6IKvwMFm2ymdzs/FnIUGxK6l2mb9aBWg
         GxhB81HjxpFZr8x9TZKCTfbLxeGr9BZpmSb9BwRAhm2aM1vuMiCvyt1X/bY89qCtNX
         eP2fyNAlhd80n9D4PDMG7NCnG7UdIdYmpzSX7r33+jnIwjcCrIsa3Ybs3syQYxLHiK
         riZeJCU1SJJ0RrP9W2bgHowGaJvo84STjbmIIXGwYTGYVJPhBel7VIGDHiaCdKLCfK
         tmQuPLRCltKTA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/14/2020 4:50 AM, Alex Williamson wrote:
> On Fri, 14 Feb 2020 01:41:35 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> <snip>
>>
>>>>>>     
>>>>>> +static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
>>>>>> +				  size_t size, uint64_t pgsize,
>>>>>> +				  unsigned char __user *bitmap)
>>>>>> +{
>>>>>> +	struct vfio_dma *dma;
>>>>>> +	dma_addr_t i = iova, iova_limit;
>>>>>> +	unsigned int bsize, nbits = 0, l = 0;
>>>>>> +	unsigned long pgshift = __ffs(pgsize);
>>>>>> +
>>>>>> +	while ((dma = vfio_find_dma(iommu, i, pgsize))) {
>>>>>> +		int ret, j;
>>>>>> +		unsigned int npages = 0, shift = 0;
>>>>>> +		unsigned char temp = 0;
>>>>>> +
>>>>>> +		/* mark all pages dirty if all pages are pinned and mapped. */
>>>>>> +		if (dma->iommu_mapped) {
>>>>>> +			iova_limit = min(dma->iova + dma->size, iova + size);
>>>>>> +			npages = iova_limit/pgsize;
>>>>>> +			bitmap_set(dma->bitmap, 0, npages);
>>>>>
>>>>> npages is derived from iova_limit, which is the number of bits to set
>>>>> dirty relative to the first requested iova, not iova zero, ie. the set
>>>>> of dirty bits is offset from those requested unless iova == dma->iova.
>>>>>       
>>>>
>>>> Right, fixing.
>>>>   
>>>>> Also I hope dma->bitmap was actually allocated.  Not only does the
>>>>> START error path potentially leave dirty tracking enabled without all
>>>>> the bitmap allocated, when does the bitmap get allocated for a new
>>>>> vfio_dma when dirty tracking is enabled?  Seems it only occurs if a
>>>>> vpfn gets marked dirty.
>>>>>       
>>>>
>>>> Right.
>>>>
>>>> Fixing error paths.
>>>>
>>>>   
>>>>>> +		} else if (dma->bitmap) {
>>>>>> +			struct rb_node *n = rb_first(&dma->pfn_list);
>>>>>> +			bool found = false;
>>>>>> +
>>>>>> +			for (; n; n = rb_next(n)) {
>>>>>> +				struct vfio_pfn *vpfn = rb_entry(n,
>>>>>> +						struct vfio_pfn, node);
>>>>>> +				if (vpfn->iova >= i) {
>>>>>> +					found = true;
>>>>>> +					break;
>>>>>> +				}
>>>>>> +			}
>>>>>> +
>>>>>> +			if (!found) {
>>>>>> +				i += dma->size;
>>>>>> +				continue;
>>>>>> +			}
>>>>>> +
>>>>>> +			for (; n; n = rb_next(n)) {
>>>>>> +				unsigned int s;
>>>>>> +				struct vfio_pfn *vpfn = rb_entry(n,
>>>>>> +						struct vfio_pfn, node);
>>>>>> +
>>>>>> +				if (vpfn->iova >= iova + size)
>>>>>> +					break;
>>>>>> +
>>>>>> +				s = (vpfn->iova - dma->iova) >> pgshift;
>>>>>> +				bitmap_set(dma->bitmap, s, 1);
>>>>>> +
>>>>>> +				iova_limit = vpfn->iova + pgsize;
>>>>>> +			}
>>>>>> +			npages = iova_limit/pgsize;
>>>>>
>>>>> Isn't iova_limit potentially uninitialized here?  For example, if our
>>>>> vfio_dma covers {0,8192} and we ask for the bitmap of {0,4096} and
>>>>> there's a vpfn at {4096,8192}.  I think that means vpfn->iova >= i
>>>>> (4096 >= 0), so we break with found = true, then we test 4096 >= 0 +
>>>>> 4096 and break, and npages = ????/pgsize.
>>>>>       
>>>>
>>>> Right, Fixing it.
>>>>   
>>>>>> +		}
>>>>>> +
>>>>>> +		bsize = dirty_bitmap_bytes(npages);
>>>>>> +		shift = nbits % BITS_PER_BYTE;
>>>>>> +
>>>>>> +		if (npages && shift) {
>>>>>> +			l--;
>>>>>> +			if (!access_ok((void __user *)bitmap + l,
>>>>>> +					sizeof(unsigned char)))
>>>>>> +				return -EINVAL;
>>>>>> +
>>>>>> +			ret = __get_user(temp, bitmap + l);
>>>>>
>>>>> I don't understand why we care to get the user's bitmap, are we trying
>>>>> to leave whatever garbage they might have set in it and only also set
>>>>> the dirty bits?  That seems unnecessary.
>>>>>       
>>>>
>>>> Suppose dma mapped ranges are {start, size}:
>>>> {0, 0xa000}, {0xa000, 0x10000}
>>>>
>>>> Bitmap asked from 0 - 0x10000. Say suppose all pages are dirty.
>>>> Then in first iteration for dma {0,0xa000} there are 10 pages, so 10
>>>> bits are set, put_user() happens for 2 bytes, (00000011 11111111b).
>>>> In second iteration for dma {0xa000, 0x10000} there are 6 pages and
>>>> these bits should be appended to previous byte. So get_user() that byte,
>>>> then shift-OR rest of the bitmap, result should be: (11111111 11111111b)
>>>>
>>>> Without get_user() and shift-OR, resulting bitmap would be
>>>> 111111 00000011 11111111b which would be wrong.
>>>
>>> Seems like if we use a put_user() approach then we should look for
>>> adjacent vfio_dmas within the same byte/word/dword before we push it to
>>> the user to avoid this sort of inefficiency.
>>>    
>>
>> Won't that add more complication to logic?
> 
> I'm tempted to think it might be less complicated.
>   
>>>>> Also why do we need these access_ok() checks when we already checked
>>>>> the range at the start of the ioctl?
>>>>
>>>> Since pointer is updated runtime here, better to check that pointer
>>>> before using that pointer.
>>>
>>> Sorry, I still don't understand this, we check access_ok() with a
>>> pointer and a length, therefore as long as we're incrementing the
>>> pointer within that length, why do we need to retest?
>>>    
>>
>> Ideally caller for put_user() and get_user() must check the pointer with
>> access_ok() which is used as argument to these functions before calling
>> this function. That makes sure that pointer is correct after pointer
>> arithematic. May be lets remove previous check of pointer and length,
>> but keep these checks.
> 
> So we don't trust that we can increment a pointer within a range that
> we've already tested with access_ok() and expect it to still be ok?  I
> think the point of having access_ok() and __put_user() is that we can
> batch many __put_user() calls under a single access_ok() check.  I
> don't see any justification here why if we already tested
> access_ok(ptr, 2) that we still need to test access_ok(ptr + 0, 1) and
> access_ok(ptr + 1, 1), and removing the initial test is clearly the
> wrong optimization if we agree there is redundancy here.	
> 

access_ok(ptr + x, 1), where x is variable, then x shouldn't be out of 
range. If we go with initial test, then there should be check for x, 
such that x is within range.

>>>>>> +			if (ret)
>>>>>> +				return ret;
>>>>>> +		}
>>>>>> +
>>>>>> +		for (j = 0; j < bsize; j++, l++) {
>>>>>> +			temp = temp |
>>>>>> +			       (*((unsigned char *)dma->bitmap + j) << shift);
>>>>>
>>>>> |=
>>>>>       
>>>>>> +			if (!access_ok((void __user *)bitmap + l,
>>>>>> +					sizeof(unsigned char)))
>>>>>> +				return -EINVAL;
>>>>>> +
>>>>>> +			ret = __put_user(temp, bitmap + l);
>>>>>> +			if (ret)
>>>>>> +				return ret;
>>>>>> +			if (shift) {
>>>>>> +				temp = *((unsigned char *)dma->bitmap + j) >>
>>>>>> +					(BITS_PER_BYTE - shift);
>>>>>> +			}
>>>>>
>>>>> When shift == 0, temp just seems to accumulate bits that never get
>>>>> cleared.
>>>>>       
>>>>
>>>> Hope example above explains the shift logic.
>>>
>>> But that example is when shift is non-zero.  When shift is zero, each
>>> iteration of the loop just ORs in new bits to temp without ever
>>> clearing the bits for the previous iteration.
>>>
>>>    
>>
>> Oh right, fixing it.
>>
>>>>>> +		}
>>>>>> +
>>>>>> +		nbits += npages;
>>>>>> +
>>>>>> +		i = min(dma->iova + dma->size, iova + size);
>>>>>> +		if (i >= iova + size)
>>>>>> +			break;
>>>>>
>>>>> So whether we error or succeed, we leave cruft in dma->bitmap for the
>>>>> next pass.  It doesn't seem to make any sense why we pre-allocated the
>>>>> bitmap, we might as well just allocate it on demand here.  Actually, if
>>>>> we're not going to do a copy_to_user() for some range of the bitmap,
>>>>> I'm not sure what it's purpose is at all.  I think the big advantages
>>>>> of the bitmap are that we can't amortize the cost across every pinned
>>>>> page or DMA mapping, we don't need the overhead of tracking unmapped
>>>>> vpfns, and we can use copy_to_user() to push the bitmap out.  We're not
>>>>> getting any of those advantages here.
>>>>>       
>>>>
>>>> That would still not work if dma range size is not multiples of 8 pages.
>>>> See example above.
>>>
>>> I don't understand this comment, what about the example above justifies
>>> the bitmap?
>>
>> copy_to_user() could be used if dma range size is not multiple of 8 pages.
> 
> s/is not/is/ ?
> 

My bad, you're right.

> And we expect that to be a far more common case, right?  I don't think
> there are too many ranges for a guest that are only mapped in sub-32KB
> chucks.
>   
>>>   As I understand the above algorithm, we find a vfio_dma
>>> overlapping the request and populate the bitmap for that range.  Then
>>> we go back and put_user() for each byte that we touched.  We could
>>> instead simply work on a one byte buffer as we enumerate the requested
>>> range and do a put_user() ever time we reach the end of it and have bits
>>> set. That would greatly simplify the above example.  But I would expect
>>> that we're a) more likely to get asked for ranges covering a single
>>> vfio_dma
>>
>> QEMU ask for single vfio_dma during each iteration.
>>
>> If we restrict this ABI to cover single vfio_dma only, then it
>> simplifies the logic here. That was my original suggestion. Should we
>> think about that again?
> 
> But we currently allow unmaps that overlap multiple vfio_dmas as long
> as no vfio_dma is bisected, so I think that implies that an unmap while
> asking for the dirty bitmap has even further restricted semantics.  I'm
> also reluctant to design an ABI around what happens to be the current
> QEMU implementation.
> 
> If we take your example above, ranges {0x0000,0xa000} and
> {0xa000,0x10000} ({start,end}), I think you're working with the
> following two bitmaps in this implementation:
> 
> 00000011 11111111b
> 00111111b
> 
> And we need to combine those into:
> 
> 11111111 11111111b
> 
> Right?
> 
> But it seems like that would be easier if the second bitmap was instead:
> 
> 11111100b
> 
> Then we wouldn't need to worry about the entire bitmap being shifted by
> the bit offset within the byte, which limits our fixes to the boundary
> byte and allows us to use copy_to_user() directly for the bulk of the
> copy.  So how do we get there?
> 
> I think we start with allocating the vfio_dma bitmap to account for
> this initial offset, so we calculate bitmap_base_iova as:
>    (iova & ~((PAGE_SIZE << 3) - 1))
> We then use bitmap_base_iova in calculating which bits to set.
> 
> The user needs to follow the same rules, and maybe this adds some value
> to the user providing the bitmap size rather than the kernel
> calculating it.  For example, if the user wanted the dirty bitmap for
> the range {0xa000,0x10000} above, they'd provide at least a 1 byte
> bitmap, but we'd return bit #2 set to indicate 0xa000 is dirty.
> 
> Effectively the user can ask for any iova range, but the buffer will be
> filled relative to the zeroth bit of the bitmap following the above
> bitmap_base_iova formula (and replacing PAGE_SIZE with the user
> requested pgsize).  I'm tempted to make this explicit in the user
> interface (ie. only allow bitmaps starting on aligned pages), but a
> user is able to map and unmap single pages and we need to support
> returning a dirty bitmap with an unmap, so I don't think we can do that.
> 

Sigh, finding adjacent vfio_dmas within the same byte seems simpler than 
this.

> So now are we biting off more than we can chew trying to transpose the
> bitmap between page sizes?  If asked for the previous range with an 8K
> pgsize, we'd somehow need to translate 11111100b into 00001110b.
> What's worse, the user could ask for just the 8K page at 0xa000 and we'd
> need to return back 00000010b while leaving our internal bitmap a
> 11110000b after we mark the bits clean.  Seems like this is really
> only tenable if we do multiples of PAGE_SIZE pages within a byte, so
> for 4K we'd have 32K, 64K, 128K, 256K, etc.  I'm somewhat losing sight
> on what this accomplishes though and whether we need this in the first
> implementation.  Should we simplify by dropping this aspect of it,
> supporting only the minimum iommu page size, and focus on actually
> using the bitmaps effectively?
>   

Sure, this will help to push first implementation, we can add 
optimization later.

>>> and b) we're going to spend far more time operating in the
>>> middle of the range and limiting ourselves to one-byte operations there
>>> seems absurd.  If we want to specify that the user provides 4-byte
>>> aligned buffers and naturally aligned iova ranges to make our lives
>>> easier in the kernel, now would be the time to do that.
>>>    
>>>>>> +	}
>>>>>> +	return 0;
>>>>>> +}
>>>>>> +
>>>>>> +static long verify_bitmap_size(unsigned long npages, unsigned long bitmap_size)
>>>>>> +{
>>>>>> +	long bsize;
>>>>>> +
>>>>>> +	if (!bitmap_size || bitmap_size > SIZE_MAX)
>>>>>> +		return -EINVAL;
>>>>>> +
>>>>>> +	bsize = dirty_bitmap_bytes(npages);
>>>>>> +
>>>>>> +	if (bitmap_size < bsize)
>>>>>> +		return -EINVAL;
>>>>>> +
>>>>>> +	return bsize;
>>>>>> +}
>>>>>
>>>>> Seems like this could simply return int, -errno or zero for success.
>>>>> The returned bsize is not used for anything else.
>>>>>       
>>>>
>>>> ok.
>>>>   
>>>>>> +
>>>>>>     static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>>>>>     			     struct vfio_iommu_type1_dma_unmap *unmap)
>>>>>>     {
>>>>>> @@ -2277,6 +2478,80 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>>>>>>     
>>>>>>     		return copy_to_user((void __user *)arg, &unmap, minsz) ?
>>>>>>     			-EFAULT : 0;
>>>>>> +	} else if (cmd == VFIO_IOMMU_DIRTY_PAGES) {
>>>>>> +		struct vfio_iommu_type1_dirty_bitmap range;
>>>>>> +		uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
>>>>>> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
>>>>>> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
>>>>>> +		int ret;
>>>>>> +
>>>>>> +		if (!iommu->v2)
>>>>>> +			return -EACCES;
>>>>>> +
>>>>>> +		minsz = offsetofend(struct vfio_iommu_type1_dirty_bitmap,
>>>>>> +				    bitmap);
>>>>>
>>>>> We require the user to provide iova, size, pgsize, bitmap_size, and
>>>>> bitmap fields to START/STOP?  Why?
>>>>>      
>>>>
>>>> No. But those are part of structure.
>>>
>>> But we do require it, minsz here includes all those fields, which would
>>> probably make a user scratch their head wondering why they need to pass
>>> irrelevant data for START/STOP.  It almost implies that we support
>>> starting and stopping dirty logging for specific ranges of the IOVA
>>> space.  We could define the structure, for example:
>>>
>>> struct vfio_iommu_type1_dirty_bitmap {
>>> 	__u32	argsz;
>>> 	__u32	flags;
>>> 	__u8	data[];
>>> };
>>>
>>> struct vfio_iommu_type1_dirty_bitmap_get {
>>> 	__u64	iova;
>>> 	__u64	size;
>>> 	__u64	pgsize;
>>> 	__u64	bitmap_size;
>>> 	void __user *bitmap;
>>> };
>>>
>>> Where data[] is defined as the latter structure when FLAG_GET_BITMAP is
>>> specified.
>>
>> Ok. Changing as above.
>>
>>>   BTW, don't we need to specify the trailing void* as __u64?
>>> We could theoretically be talking to an ILP32 user process.  Thanks,
>>>    
>>
>> Even on ILP32, using void* pointer will reserve the size required to
>> save a pointer address. I don't think using void* should be problem.
> 
> I think you're still assuming sizeof(void *) is the same in kernel vs
> userspace whereas I'm thinking about an ILP32 user running on an LP64
> kernel.  Thanks,
> 
Ok. Changing it to __u64

Thanks,
Kirti
