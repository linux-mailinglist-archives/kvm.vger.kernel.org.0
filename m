Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2B92BA797
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 11:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgKTKjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 05:39:11 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:41611 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725952AbgKTKjK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 05:39:10 -0500
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud9.xs4all.net with ESMTPA
        id g3odkqci3WTbog3ogkflSv; Fri, 20 Nov 2020 11:39:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s2;
        t=1605868744; bh=UJbsoc+m2DQXtat1J+FSEFEQVZTUCPoXOGzxzQw644s=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=kcuAXQ1B/GTzWwQml12T3GbJXUhrFJRX5LaU3qV0GdLQGzXoDChd8SkjAllwPt3zH
         lub6Gp+k/Kvre6ug0Fa5Abl8/Hrxr0ywrpyek9moKX8pNHcYfPWWCVh4VjaK2tgHsa
         GkgnglWwjplRJEYBPSj2a8s+e4KZ/ySUEeABdvYY9EcNL3hnaU2R9DFQbBX4AvDwYl
         v55zKKQOeWUtg0JTeDGQ/aETRbVDYpz0piVOHQi0i4kFvqiTbOOJRECUUwNxNUeFKx
         yUK2HHoEGu/IzTAWVM6QKCSprtR9qfLYwNS6rKhxbvJQHHGoStiTaI9a0DXd7Pp9sP
         p9N9Sjv3vSUGg==
Subject: Re: [PATCH v6 09/17] media/videbuf1|2: Mark follow_pfn usage as
 unsafe
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>, Tomasz Figa <tfiga@chromium.org>,
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
 <e1f7d30b-2012-0249-66c7-cf9d7d6246ad@xs4all.nl>
 <CAKMK7uEzFAtr9yxjaxi-kiuZhb+hWT3q6E41OegJr+J2-zkT8w@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9035555a-af6b-e2dd-dbad-41ca70235e21@xs4all.nl>
Date:   Fri, 20 Nov 2020 11:38:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAKMK7uEzFAtr9yxjaxi-kiuZhb+hWT3q6E41OegJr+J2-zkT8w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfDss0FwL2fqdI2i/Ld6jk5YpMRTothqQOe/9Yd2P1xeqdCmohX7XXb96LZlza31qpcmNMYJwPa81XchZVa1S7q0JJklTc6tNeVGRAAYdr+AbM+yqKuxh
 HYR4y9BVgxtQf4jgcpuWAISFzS9JO9asb6c6vsbpOUMsoZVmKvX3blng9eCgwzmJEFWVy6RFBjEP+YuywmY0Cbsra6piUdkAnXxA28LQBb4c4pANgMwK3/20
 bqwtn2oqGhmwrstC4HjCP7+ky7n9e+nny11fIZoZXpYud8ngwlCvv3JO5DEhppBBMyU4wzh6wey7nRYMfQcZKL3tBnPLxG084wGKlaIDxqlPIqzON2yPqUtM
 BdjovZp1X9w67sDw2YnPtJI+t5QjtH7wDE8HymLGzpo/iSWefSev4TB6DyT8z5q4VwW3nHLvv+AKe+XDfQUaFLrmIHckyHvzBresJqeVQNqozNuU1qToV+l/
 ErEPsay/ueUS5Hj5b6jRplY77yT/PNOmchZCs7zBkOUY6YONev0nZYJIoJ6WsUMULo52xVhX1Tta1mgMr4SugcE1W1C9YPZPWPqPWe/3L6bhxjXGPcTMvgGG
 EfWAwqzm38P0NR/GybtBl/gWm/ZJOCla09xasqa1HdLeHPFcGIUr2RcK8vk1M1FL+s1q9wqIJ1k+h51TQcL8ss+oalkYZ+Es/zXbGn8CGFesXujAIbbI9SeX
 RbG5KoDDqiF0i/z9VR5/dyz1ChlFanbUWs7vGG6zLRPUB94JMiDLcyq0sgkrQslnPzRt5atIb4ACU1K5prEyGZXzYGJ67wH+5Ote3N/ZKwr9ZzDCJOlZyz1Y
 7NCIKU+LJw+dc7vff5v2/nfaydMU8yk1Sjiw2vMM60fyIjtgLWiysLdmBcHztcTuIRFp2fTCyaD4dNzasFyk6gZzUhJytpwVEiTZ4cIcT8wwnB8yzHSlynCb
 PBnOPcalqnNL1YwgL4G+XJik3k/M6qqSrY43N1O21jk+k7JmerrFuMJh03HUnX+RhONUkg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/11/2020 10:18, Daniel Vetter wrote:
> On Fri, Nov 20, 2020 at 9:28 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> On 20/11/2020 09:06, Hans Verkuil wrote:
>>> On 19/11/2020 15:41, Daniel Vetter wrote:
>>>> The media model assumes that buffers are all preallocated, so that
>>>> when a media pipeline is running we never miss a deadline because the
>>>> buffers aren't allocated or available.
>>>>
>>>> This means we cannot fix the v4l follow_pfn usage through
>>>> mmu_notifier, without breaking how this all works. The only real fix
>>>> is to deprecate userptr support for VM_IO | VM_PFNMAP mappings and
>>>> tell everyone to cut over to dma-buf memory sharing for zerocopy.
>>>>
>>>> userptr for normal memory will keep working as-is, this only affects
>>>> the zerocopy userptr usage enabled in 50ac952d2263 ("[media]
>>>> videobuf2-dma-sg: Support io userptr operations on io memory").
>>>>
>>>> Acked-by: Tomasz Figa <tfiga@chromium.org>
>>>
>>> Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>>
>> Actually, cancel this Acked-by.
>>
>> So let me see if I understand this right: VM_IO | VM_PFNMAP mappings can
>> move around. There is a mmu_notifier that can be used to be notified when
>> that happens, but that can't be used with media buffers since those buffers
>> must always be available and in the same place.
>>
>> So follow_pfn is replaced by unsafe_follow_pfn to signal that what is attempted
>> is unsafe and unreliable.
>>
>> If CONFIG_STRICT_FOLLOW_PFN is set, then unsafe_follow_pfn will fail, if it
>> is unset, then it writes a warning to the kernel log but just continues while
>> still unsafe.
>>
>> I am very much inclined to just drop VM_IO | VM_PFNMAP support in the media
>> subsystem. For vb2 there is a working alternative in the form of dmabuf, and
>> frankly for vb1 I don't care. If someone really needs this for a vb1 driver,
>> then they can do the work to convert that driver to vb2.
>>
>> I've added Mauro to the CC list and I'll ping a few more people to see what
>> they think, but in my opinion support for USERPTR + VM_IO | VM_PFNMAP
>> should just be killed off.
>>
>> If others would like to keep it, then frame_vector.c needs a comment before
>> the 'while' explaining why the unsafe_follow_pfn is there and that using
>> dmabuf is the proper alternative to use. That will make it easier for
>> developers to figure out why they see a kernel warning and what to do to
>> fix it, rather than having to dig through the git history for the reason.
> 
> I'm happy to add a comment, but otherwise if you all want to ditch
> this, can we do this as a follow up on top? There's quite a bit of
> code that can be deleted and I'd like to not hold up this patch set
> here on that - it's already a fairly sprawling pain touching about 7
> different subsystems (ok only 6-ish now since the s390 patch landed).
> For the comment, is the explanation next to unsafe_follow_pfn not good
> enough?

No, because that doesn't mention that you should use dma-buf as a replacement.
That's really the critical piece of information I'd like to see. That doesn't
belong in unsafe_follow_pfn, it needs to be in frame_vector.c since it's
vb2 specific.

> 
> So ... can I get you to un-cancel your ack?

Hmm, I really would like to see support for this to be dropped completely.

How about this: just replace follow_pfn() by -EINVAL instead of unsafe_follow_pfn().

Add a TODO comment that this code now can be cleaned up a lot. Such a clean up patch
can be added on top later, and actually that is something that I can do once this
series has landed.

Regardless, frame_vector.c should mention dma-buf as a replacement in a comment
since I don't want users who hit this issue to have to dig through git logs
to find that dma-buf is the right approach.

BTW, nitpick: the subject line of this patch says 'videbuf' instead of 'videobuf'.

Regards,

	Hans

> 
> Thanks, Daniel
> 
>>
>> Regards,
>>
>>         Hans
>>
>>>
>>> Thanks!
>>>
>>>       Hans
>>>
>>>> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
>>>> Cc: Jason Gunthorpe <jgg@ziepe.ca>
>>>> Cc: Kees Cook <keescook@chromium.org>
>>>> Cc: Dan Williams <dan.j.williams@intel.com>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: John Hubbard <jhubbard@nvidia.com>
>>>> Cc: Jérôme Glisse <jglisse@redhat.com>
>>>> Cc: Jan Kara <jack@suse.cz>
>>>> Cc: Dan Williams <dan.j.williams@intel.com>
>>>> Cc: linux-mm@kvack.org
>>>> Cc: linux-arm-kernel@lists.infradead.org
>>>> Cc: linux-samsung-soc@vger.kernel.org
>>>> Cc: linux-media@vger.kernel.org
>>>> Cc: Pawel Osciak <pawel@osciak.com>
>>>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
>>>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>>>> Cc: Tomasz Figa <tfiga@chromium.org>
>>>> Cc: Laurent Dufour <ldufour@linux.ibm.com>
>>>> Cc: Vlastimil Babka <vbabka@suse.cz>
>>>> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
>>>> Cc: Michel Lespinasse <walken@google.com>
>>>> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>>>> --
>>>> v3:
>>>> - Reference the commit that enabled the zerocopy userptr use case to
>>>>   make it abundandtly clear that this patch only affects that, and not
>>>>   normal memory userptr. The old commit message already explained that
>>>>   normal memory userptr is unaffected, but I guess that was not clear
>>>>   enough.
>>>> ---
>>>>  drivers/media/common/videobuf2/frame_vector.c | 2 +-
>>>>  drivers/media/v4l2-core/videobuf-dma-contig.c | 2 +-
>>>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/media/common/videobuf2/frame_vector.c b/drivers/media/common/videobuf2/frame_vector.c
>>>> index a0e65481a201..1a82ec13ea00 100644
>>>> --- a/drivers/media/common/videobuf2/frame_vector.c
>>>> +++ b/drivers/media/common/videobuf2/frame_vector.c
>>>> @@ -70,7 +70,7 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
>>>>                      break;
>>>>
>>>>              while (ret < nr_frames && start + PAGE_SIZE <= vma->vm_end) {
>>>> -                    err = follow_pfn(vma, start, &nums[ret]);
>>>> +                    err = unsafe_follow_pfn(vma, start, &nums[ret]);
>>>>                      if (err) {
>>>>                              if (ret == 0)
>>>>                                      ret = err;
>>>> diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
>>>> index 52312ce2ba05..821c4a76ab96 100644
>>>> --- a/drivers/media/v4l2-core/videobuf-dma-contig.c
>>>> +++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
>>>> @@ -183,7 +183,7 @@ static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
>>>>      user_address = untagged_baddr;
>>>>
>>>>      while (pages_done < (mem->size >> PAGE_SHIFT)) {
>>>> -            ret = follow_pfn(vma, user_address, &this_pfn);
>>>> +            ret = unsafe_follow_pfn(vma, user_address, &this_pfn);
>>>>              if (ret)
>>>>                      break;
>>>>
>>>>
>>>
>>
> 
> 

