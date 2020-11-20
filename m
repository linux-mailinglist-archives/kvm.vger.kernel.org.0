Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43222BA9DD
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 13:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgKTMIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 07:08:32 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:37809 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727070AbgKTMIc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 07:08:32 -0500
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud9.xs4all.net with ESMTPA
        id g5Cxkr2rxWTbog5D9kfzgT; Fri, 20 Nov 2020 13:08:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s2;
        t=1605874108; bh=4jVkUAot4OkLKdxNnM2R7h+vykTpDc6FD3DDb6ZVY7M=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=uHv02Byp+OKNK2sc5/QsU9aZXUOamTly4qmRiKFMhVLHZC9oAdP0t1qLCK4uT32ZL
         JvMmyH9d//M/aVURiloYZTz94DYlOFPdri/RAlPqyib7a8zGMXZ3r+Ukxrihz1KBTA
         pzELFneVfe0anmRAcsKbt3Navg8THjaowUTR5Kt8IYTNoh0UQ78ySx96mpF+OHPNwR
         n9ayftzOJv5En1mfD5u8+e6Da/Cefewo45vtmo457egEzUwGnt0EbBf3AMXaPpgAew
         wqQ1nzK1qxYYn83USCOLPhDlTu44CxWTdhYJ/7jbLw7k/5CKeTbZgI17nWoIwnkwpN
         dmqIcygKAiVFQ==
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
 <9035555a-af6b-e2dd-dbad-41ca70235e21@xs4all.nl>
 <CAKMK7uFrXJh9jc5-v02A=JE8B3aThbYtTxFN-CGQUB=0TGmKgQ@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d44c6518-bd9c-87e0-dce4-2b63890e0f7e@xs4all.nl>
Date:   Fri, 20 Nov 2020 13:08:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAKMK7uFrXJh9jc5-v02A=JE8B3aThbYtTxFN-CGQUB=0TGmKgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfH2GQWtU8AqZJ/UOgmSeeLm02eV8ZsNLUP3VIk9wxP4VrDl9eKEQ/GNR0B/F6KP8LGV9lEB9KsxM/bE7FLkzIW+51QE8QQQChGr6Vd/khqTq/SSBolV+
 5mykW4HLxMsJRt6Y//nsI/14HHVG2nrSl4nSBLfWvyaOZRJMLX0HTPBEnApfvM5ceWWGs4UbRiBakSeRO+dYXEe/M2ogChstqRf4M38KPOYakcOlmLLZ0Gp4
 E4St22I46NNWLKcN1Xnose9kMtLX8nZ4lh0ubBOJFThbsukJyY1SC8vLE3nAms2/MKJTvm74IbQZW8mMPy11+KUo+CsYPNrqavznhaDE4XRJzvtMl7kJo9K5
 Xpf333DG8wTRTX9bUCB6DcfHELtrcjN1+OFUKK15HHdYKP+mdMfpOj9eogAnfzHCLd02Uc/yxg18CJsR6amJQlaNEXE2lQIJoDbcXqkcvCpUGVk4MbvbgUex
 3milY2o/WAY3AW/H6C+guaKpSAzecCaGxSB5cU0gO5AQAWfWam2LjvduQAi7ZnA85gfZrmVd42Ln2D+AlQi8+gInTOfa3auO5Dx40r46uhYg6utrSHqE68c3
 ukjQWK8G7oJFCI/KM3KbjQB5w8BPAEYbQurlQ4PudX1V/iuQkP5zXPlNUzP/C4u6IdQM7N1Ky0NzdvxTeaESidfvyuIwM03RhiZ1Ss8r6CAbTG7NMAHwGK1U
 ZTz74GM+0sB4ZcquzCC2g/PpFeYu99Jvn3mPzvKIvfKjgGOOGR9lCljNc5QOlVIHsIOF+ACAh0rea88kRsb5seV8og+sHQDCGCWG+nNa3ccIFB3ztHOPm8e3
 gjdEiWj3RqwWlERoMkQoIVOBKmHvXLdhuj1bqMd/8svArQjZCiFGDMeAiP2Bqiz8SH2/MxykyApI36FsuQ9pkt/qJYljguMj33uZzK+efbJFEbvDk9NLI6nO
 bIs0TCnWe3TP3tQqjTs2OURi9sI3Uvj3avAE0mcR7ViC8WeR99/gdTtsJXOcGuibgxKaOQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/11/2020 11:51, Daniel Vetter wrote:
> On Fri, Nov 20, 2020 at 11:39 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> On 20/11/2020 10:18, Daniel Vetter wrote:
>>> On Fri, Nov 20, 2020 at 9:28 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>
>>>> On 20/11/2020 09:06, Hans Verkuil wrote:
>>>>> On 19/11/2020 15:41, Daniel Vetter wrote:
>>>>>> The media model assumes that buffers are all preallocated, so that
>>>>>> when a media pipeline is running we never miss a deadline because the
>>>>>> buffers aren't allocated or available.
>>>>>>
>>>>>> This means we cannot fix the v4l follow_pfn usage through
>>>>>> mmu_notifier, without breaking how this all works. The only real fix
>>>>>> is to deprecate userptr support for VM_IO | VM_PFNMAP mappings and
>>>>>> tell everyone to cut over to dma-buf memory sharing for zerocopy.
>>>>>>
>>>>>> userptr for normal memory will keep working as-is, this only affects
>>>>>> the zerocopy userptr usage enabled in 50ac952d2263 ("[media]
>>>>>> videobuf2-dma-sg: Support io userptr operations on io memory").
>>>>>>
>>>>>> Acked-by: Tomasz Figa <tfiga@chromium.org>
>>>>>
>>>>> Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>>>>
>>>> Actually, cancel this Acked-by.
>>>>
>>>> So let me see if I understand this right: VM_IO | VM_PFNMAP mappings can
>>>> move around. There is a mmu_notifier that can be used to be notified when
>>>> that happens, but that can't be used with media buffers since those buffers
>>>> must always be available and in the same place.
>>>>
>>>> So follow_pfn is replaced by unsafe_follow_pfn to signal that what is attempted
>>>> is unsafe and unreliable.
>>>>
>>>> If CONFIG_STRICT_FOLLOW_PFN is set, then unsafe_follow_pfn will fail, if it
>>>> is unset, then it writes a warning to the kernel log but just continues while
>>>> still unsafe.
>>>>
>>>> I am very much inclined to just drop VM_IO | VM_PFNMAP support in the media
>>>> subsystem. For vb2 there is a working alternative in the form of dmabuf, and
>>>> frankly for vb1 I don't care. If someone really needs this for a vb1 driver,
>>>> then they can do the work to convert that driver to vb2.
>>>>
>>>> I've added Mauro to the CC list and I'll ping a few more people to see what
>>>> they think, but in my opinion support for USERPTR + VM_IO | VM_PFNMAP
>>>> should just be killed off.
>>>>
>>>> If others would like to keep it, then frame_vector.c needs a comment before
>>>> the 'while' explaining why the unsafe_follow_pfn is there and that using
>>>> dmabuf is the proper alternative to use. That will make it easier for
>>>> developers to figure out why they see a kernel warning and what to do to
>>>> fix it, rather than having to dig through the git history for the reason.
>>>
>>> I'm happy to add a comment, but otherwise if you all want to ditch
>>> this, can we do this as a follow up on top? There's quite a bit of
>>> code that can be deleted and I'd like to not hold up this patch set
>>> here on that - it's already a fairly sprawling pain touching about 7
>>> different subsystems (ok only 6-ish now since the s390 patch landed).
>>> For the comment, is the explanation next to unsafe_follow_pfn not good
>>> enough?
>>
>> No, because that doesn't mention that you should use dma-buf as a replacement.
>> That's really the critical piece of information I'd like to see. That doesn't
>> belong in unsafe_follow_pfn, it needs to be in frame_vector.c since it's
>> vb2 specific.
> 
> Ah makes sense, I'll add that.
> 
>>>
>>> So ... can I get you to un-cancel your ack?
>>
>> Hmm, I really would like to see support for this to be dropped completely.
>>
>> How about this: just replace follow_pfn() by -EINVAL instead of unsafe_follow_pfn().
>>
>> Add a TODO comment that this code now can be cleaned up a lot. Such a clean up patch
>> can be added on top later, and actually that is something that I can do once this
>> series has landed.
>>
>> Regardless, frame_vector.c should mention dma-buf as a replacement in a comment
>> since I don't want users who hit this issue to have to dig through git logs
>> to find that dma-buf is the right approach.
>>
>> BTW, nitpick: the subject line of this patch says 'videbuf' instead of 'videobuf'.
> 
> Will fix to, and next round will have the additional -EINVAL on top.
> Iirc Mauro was pretty clear that we can't just delete this, so I kinda
> don't want to get stuck in this discussion with my patches :-)

Ah, I found that discussion for the v2 of this series.

Yes, add that on top and we can discuss whether to Ack that -EINVAL patch or
not.

I don't see why we would want to continue supporting a broken model that is
also a security risk, as I understand it.

Tomasz, can you look at the discussion for this old RFC patch of mine:

https://patchwork.linuxtv.org/project/linux-media/patch/20200221084531.576156-9-hverkuil-cisco@xs4all.nl/

Specifically, if we just drop support for follow_pfn(), would that cause
problems for Chromium since that is apparently still using USERPTR for encoders?

Regards,

	Hans

> -Daniel
> 
>>
>> Regards,
>>
>>         Hans
>>
>>>
>>> Thanks, Daniel
>>>
>>>>
>>>> Regards,
>>>>
>>>>         Hans
>>>>
>>>>>
>>>>> Thanks!
>>>>>
>>>>>       Hans
>>>>>
>>>>>> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
>>>>>> Cc: Jason Gunthorpe <jgg@ziepe.ca>
>>>>>> Cc: Kees Cook <keescook@chromium.org>
>>>>>> Cc: Dan Williams <dan.j.williams@intel.com>
>>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>>>> Cc: John Hubbard <jhubbard@nvidia.com>
>>>>>> Cc: Jérôme Glisse <jglisse@redhat.com>
>>>>>> Cc: Jan Kara <jack@suse.cz>
>>>>>> Cc: Dan Williams <dan.j.williams@intel.com>
>>>>>> Cc: linux-mm@kvack.org
>>>>>> Cc: linux-arm-kernel@lists.infradead.org
>>>>>> Cc: linux-samsung-soc@vger.kernel.org
>>>>>> Cc: linux-media@vger.kernel.org
>>>>>> Cc: Pawel Osciak <pawel@osciak.com>
>>>>>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
>>>>>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>>>>>> Cc: Tomasz Figa <tfiga@chromium.org>
>>>>>> Cc: Laurent Dufour <ldufour@linux.ibm.com>
>>>>>> Cc: Vlastimil Babka <vbabka@suse.cz>
>>>>>> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
>>>>>> Cc: Michel Lespinasse <walken@google.com>
>>>>>> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>>>>>> --
>>>>>> v3:
>>>>>> - Reference the commit that enabled the zerocopy userptr use case to
>>>>>>   make it abundandtly clear that this patch only affects that, and not
>>>>>>   normal memory userptr. The old commit message already explained that
>>>>>>   normal memory userptr is unaffected, but I guess that was not clear
>>>>>>   enough.
>>>>>> ---
>>>>>>  drivers/media/common/videobuf2/frame_vector.c | 2 +-
>>>>>>  drivers/media/v4l2-core/videobuf-dma-contig.c | 2 +-
>>>>>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/media/common/videobuf2/frame_vector.c b/drivers/media/common/videobuf2/frame_vector.c
>>>>>> index a0e65481a201..1a82ec13ea00 100644
>>>>>> --- a/drivers/media/common/videobuf2/frame_vector.c
>>>>>> +++ b/drivers/media/common/videobuf2/frame_vector.c
>>>>>> @@ -70,7 +70,7 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
>>>>>>                      break;
>>>>>>
>>>>>>              while (ret < nr_frames && start + PAGE_SIZE <= vma->vm_end) {
>>>>>> -                    err = follow_pfn(vma, start, &nums[ret]);
>>>>>> +                    err = unsafe_follow_pfn(vma, start, &nums[ret]);
>>>>>>                      if (err) {
>>>>>>                              if (ret == 0)
>>>>>>                                      ret = err;
>>>>>> diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
>>>>>> index 52312ce2ba05..821c4a76ab96 100644
>>>>>> --- a/drivers/media/v4l2-core/videobuf-dma-contig.c
>>>>>> +++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
>>>>>> @@ -183,7 +183,7 @@ static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
>>>>>>      user_address = untagged_baddr;
>>>>>>
>>>>>>      while (pages_done < (mem->size >> PAGE_SHIFT)) {
>>>>>> -            ret = follow_pfn(vma, user_address, &this_pfn);
>>>>>> +            ret = unsafe_follow_pfn(vma, user_address, &this_pfn);
>>>>>>              if (ret)
>>>>>>                      break;
>>>>>>
>>>>>>
>>>>>
>>>>
>>>
>>>
>>
> 
> 

