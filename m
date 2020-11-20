Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1A82BA49F
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 09:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgKTI2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 03:28:41 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:38229 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725858AbgKTI2k (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 03:28:40 -0500
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud7.xs4all.net with ESMTPA
        id g1mSk0duZlmd2g1mVkPUTx; Fri, 20 Nov 2020 09:28:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s2;
        t=1605860917; bh=DcELGYlhxaro30UZ20c6fQBWIf0M1lNcMxmp95cUUJ4=;
        h=Subject:From:To:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=HRWawErqqUunyEPr+iUOWOxf9j9aZ4SMzYu6uVe18G1XNJkjgJsIn+181gsSRmz57
         NHcU6HQB6G0x/TG/vImNAe9wsTqwf3UlgTFJwC9C5KcbSeTlH2X08z9xkFIIN56QAH
         R5XaGNbetcBXf9Fo3NIUxFDCexxB4Mlwc3NB/sDFl8gdnKF7z15Vf6s8kknbVbu/Qv
         0d/XGi/rAPLUwLnoTI5dABoGKRYjDDdf91G2NtSNHeN+jisPIPo0X+twEfh3nh0EUa
         82cJLU/4t1tvuC9+AWKZQZAkKyoGQIs80W/3fFCiXxsqaRA8gvrgc0/dwA9DJPMpaZ
         P4jGjovIKZquQ==
Subject: Re: [PATCH v6 09/17] media/videbuf1|2: Mark follow_pfn usage as
 unsafe
From:   Hans Verkuil <hverkuil@xs4all.nl>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Tomasz Figa <tfiga@chromium.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Michel Lespinasse <walken@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20201119144146.1045202-1-daniel.vetter@ffwll.ch>
 <20201119144146.1045202-10-daniel.vetter@ffwll.ch>
 <f1f3a1d8-d62a-6e93-afc1-87a8e51081e9@xs4all.nl>
Message-ID: <e1f7d30b-2012-0249-66c7-cf9d7d6246ad@xs4all.nl>
Date:   Fri, 20 Nov 2020 09:28:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <f1f3a1d8-d62a-6e93-afc1-87a8e51081e9@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfKJe3pdseOGoPmUF+moMd4kN4FZ2xAvYBXMYjRkZT3iU9Vg3ajyNtJwJFb0q2cUm3gAK1ctXY2oEOsiYBNG71aHda4Gp4ddYPMg/VldO3Qi5lHBYelxw
 6YLDaHrxG8vIPoxkmFj9IM2Uj09t0kl+EcCPKQYO/b+wtsixypImSdlzuX6ZvH4zzQ0ZAxPe47gDW65y8bYPpzZs7VZctFpTz/8nd9BhUAxhOwL61qHANWGA
 9ZXGHS2xYSYjMkgRzGXze/DJ8oW2+XVxIv9puTWscNF+2IHMu4NJaXSGm5/2UYkn3nmOc/5cmgQg1VGNrazEYFjDK6ddOnhTUtRJTf0p6u3tOi2wIVFCbu+p
 VpUReLTQCVy+Sdgf54Hj/gPJvMjeze2onp2dZehOZ3xvn1w7DpE6I1m7zZWRNF039QLBinB53wF77wQX5dh8SvrybcZy6kZAC4N8Oj6InVnsUPasjGDIFh75
 EmginXdT45g6btGUmmnaYhHqHYnfmsx6Bfo0LkwWtveJMbMXfZOV4SX3CyTDbniDDMpCy2znjs1DqyLUwMSEZrnLO3WTTYxTkzDOTvLlrj0xbXLSR2E4EGKb
 A/RQ0F2uP8A7n23s8fAJTnaKzoq1WWAGdhA9QW2k6F8horB1AmiErN5FUcn8SQWiJc3XVB0LxwJoEnx0MjgTaoSAyvqtPtH2oO0XNvh8y3jK74YVhDjiNIzf
 eZ7ng7g4gfHjtKabePK/N9KRZdIRs7DzXhmTuBh1bfozD/Dt51hVhDfv5UoH3JUUmOUPjZpUUpJJjLsfkQgJY5Htcezce9nFVuvMx9athk8sANbbLHWpr7GA
 dffJRocQzCrklh1BpIBOkXDV2gzbpx8luDHEj4FFBHA9LFvrv6zBjX+fn7nu9CQpMQxfTFHnOfPe2QvhWAKUmwYCjmYfhQZH5GVHqETod34zXriHmLIO9afa
 qpRz+cKIb3DlBYolXAffgi2POvhNL6N2X5MiD7cJjHNGBFl0fxDTebdis2R5rxKNtj4CBw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/11/2020 09:06, Hans Verkuil wrote:
> On 19/11/2020 15:41, Daniel Vetter wrote:
>> The media model assumes that buffers are all preallocated, so that
>> when a media pipeline is running we never miss a deadline because the
>> buffers aren't allocated or available.
>>
>> This means we cannot fix the v4l follow_pfn usage through
>> mmu_notifier, without breaking how this all works. The only real fix
>> is to deprecate userptr support for VM_IO | VM_PFNMAP mappings and
>> tell everyone to cut over to dma-buf memory sharing for zerocopy.
>>
>> userptr for normal memory will keep working as-is, this only affects
>> the zerocopy userptr usage enabled in 50ac952d2263 ("[media]
>> videobuf2-dma-sg: Support io userptr operations on io memory").
>>
>> Acked-by: Tomasz Figa <tfiga@chromium.org>
> 
> Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Actually, cancel this Acked-by.

So let me see if I understand this right: VM_IO | VM_PFNMAP mappings can
move around. There is a mmu_notifier that can be used to be notified when
that happens, but that can't be used with media buffers since those buffers
must always be available and in the same place.

So follow_pfn is replaced by unsafe_follow_pfn to signal that what is attempted
is unsafe and unreliable.

If CONFIG_STRICT_FOLLOW_PFN is set, then unsafe_follow_pfn will fail, if it
is unset, then it writes a warning to the kernel log but just continues while
still unsafe.

I am very much inclined to just drop VM_IO | VM_PFNMAP support in the media
subsystem. For vb2 there is a working alternative in the form of dmabuf, and
frankly for vb1 I don't care. If someone really needs this for a vb1 driver,
then they can do the work to convert that driver to vb2.

I've added Mauro to the CC list and I'll ping a few more people to see what
they think, but in my opinion support for USERPTR + VM_IO | VM_PFNMAP
should just be killed off.

If others would like to keep it, then frame_vector.c needs a comment before
the 'while' explaining why the unsafe_follow_pfn is there and that using
dmabuf is the proper alternative to use. That will make it easier for
developers to figure out why they see a kernel warning and what to do to
fix it, rather than having to dig through the git history for the reason.

Regards,

	Hans

> 
> Thanks!
> 
> 	Hans
> 
>> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
>> Cc: Jason Gunthorpe <jgg@ziepe.ca>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: John Hubbard <jhubbard@nvidia.com>
>> Cc: Jérôme Glisse <jglisse@redhat.com>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: linux-mm@kvack.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-samsung-soc@vger.kernel.org
>> Cc: linux-media@vger.kernel.org
>> Cc: Pawel Osciak <pawel@osciak.com>
>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Tomasz Figa <tfiga@chromium.org>
>> Cc: Laurent Dufour <ldufour@linux.ibm.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
>> Cc: Michel Lespinasse <walken@google.com>
>> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>> --
>> v3:
>> - Reference the commit that enabled the zerocopy userptr use case to
>>   make it abundandtly clear that this patch only affects that, and not
>>   normal memory userptr. The old commit message already explained that
>>   normal memory userptr is unaffected, but I guess that was not clear
>>   enough.
>> ---
>>  drivers/media/common/videobuf2/frame_vector.c | 2 +-
>>  drivers/media/v4l2-core/videobuf-dma-contig.c | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/common/videobuf2/frame_vector.c b/drivers/media/common/videobuf2/frame_vector.c
>> index a0e65481a201..1a82ec13ea00 100644
>> --- a/drivers/media/common/videobuf2/frame_vector.c
>> +++ b/drivers/media/common/videobuf2/frame_vector.c
>> @@ -70,7 +70,7 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
>>  			break;
>>  
>>  		while (ret < nr_frames && start + PAGE_SIZE <= vma->vm_end) {
>> -			err = follow_pfn(vma, start, &nums[ret]);
>> +			err = unsafe_follow_pfn(vma, start, &nums[ret]);
>>  			if (err) {
>>  				if (ret == 0)
>>  					ret = err;
>> diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
>> index 52312ce2ba05..821c4a76ab96 100644
>> --- a/drivers/media/v4l2-core/videobuf-dma-contig.c
>> +++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
>> @@ -183,7 +183,7 @@ static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
>>  	user_address = untagged_baddr;
>>  
>>  	while (pages_done < (mem->size >> PAGE_SHIFT)) {
>> -		ret = follow_pfn(vma, user_address, &this_pfn);
>> +		ret = unsafe_follow_pfn(vma, user_address, &this_pfn);
>>  		if (ret)
>>  			break;
>>  
>>
> 

