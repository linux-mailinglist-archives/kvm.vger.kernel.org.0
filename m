Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A50E645D43
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 16:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiLGPJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 10:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLGPJI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 10:09:08 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 543865B5BF
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 07:09:06 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A075823A;
        Wed,  7 Dec 2022 07:09:12 -0800 (PST)
Received: from [10.57.7.204] (unknown [10.57.7.204])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 738C93F73B;
        Wed,  7 Dec 2022 07:09:04 -0800 (PST)
Message-ID: <612f4925-7a69-2d21-50f8-091a2295a2ff@arm.com>
Date:   Wed, 7 Dec 2022 15:09:02 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC PATCH kvmtool v1 25/32] Allocate guest memory as restricted
 if needed
Content-Language: en-GB
To:     Fuad Tabba <tabba@google.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, alexandru.elisei@arm.com,
        alex.bennee@linaro.org, will@kernel.org
References: <20221202174417.1310826-1-tabba@google.com>
 <20221202174417.1310826-26-tabba@google.com>
 <94872199-2466-756b-df4a-bbf699e40a0b@arm.com>
 <CA+EHjTwpmGtme1MoZFR-n86YMGmQoH8T8KkmAt9u3E2O2K9A8Q@mail.gmail.com>
From:   Steven Price <steven.price@arm.com>
In-Reply-To: <CA+EHjTwpmGtme1MoZFR-n86YMGmQoH8T8KkmAt9u3E2O2K9A8Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/12/2022 14:52, Fuad Tabba wrote:
> Hi,
> 
> On Wed, Dec 7, 2022 at 2:25 PM Steven Price <steven.price@arm.com> wrote:
>>
>> On 02/12/2022 17:44, Fuad Tabba wrote:
>>> If specified by the option and supported by KVM, allocate guest
>>> memory as restricted with the new system call.
>>>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>>  arm/aarch64/pvtime.c |  2 +-
>>>  hw/vesa.c            |  2 +-
>>>  include/kvm/util.h   |  2 +-
>>>  util/util.c          | 12 ++++++++----
>>>  4 files changed, 11 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
>>> index a452938..8247c52 100644
>>> --- a/arm/aarch64/pvtime.c
>>> +++ b/arm/aarch64/pvtime.c
>>> @@ -16,7 +16,7 @@ static int pvtime__alloc_region(struct kvm *kvm)
>>>       int mem_fd;
>>>       int ret = 0;
>>>
>>> -     mem_fd = memfd_alloc(ARM_PVTIME_SIZE, false, 0);
>>> +     mem_fd = memfd_alloc(kvm, ARM_PVTIME_SIZE, false, 0);
>>>       if (mem_fd < 0)
>>>               return -errno;
>>>
>>> diff --git a/hw/vesa.c b/hw/vesa.c
>>> index 3233794..6c5287a 100644
>>> --- a/hw/vesa.c
>>> +++ b/hw/vesa.c
>>> @@ -90,7 +90,7 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>>>       if (r < 0)
>>>               goto unregister_ioport;
>>>
>>> -     mem_fd = memfd_alloc(ARM_PVTIME_SIZE, false, 0, 0);
>>> +     mem_fd = memfd_alloc(kvm, ARM_PVTIME_SIZE, false, 0, 0);
>>>       if (mem_fd < 0) {
>>>               r = -errno;
>>>               goto unregister_device;
>>> diff --git a/include/kvm/util.h b/include/kvm/util.h
>>> index 79275ed..5a98d4a 100644
>>> --- a/include/kvm/util.h
>>> +++ b/include/kvm/util.h
>>> @@ -139,7 +139,7 @@ static inline int pow2_size(unsigned long x)
>>>  }
>>>
>>>  struct kvm;
>>> -int memfd_alloc(u64 size, bool hugetlb, u64 blk_size);
>>> +int memfd_alloc(struct kvm *kvm, size_t size, bool hugetlb, u64 hugepage_size);
>>>  void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const char *hugetlbfs_path,
>>>                                  u64 size, u64 align);
>>>  void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
>>> diff --git a/util/util.c b/util/util.c
>>> index 107f34d..13b3e82 100644
>>> --- a/util/util.c
>>> +++ b/util/util.c
>>> @@ -17,7 +17,7 @@
>>>  __SYSCALL(__NR_memfd_restricted, sys_memfd_restricted)
>>>  #endif
>>>
>>> -static inline int memfd_restricted(unsigned int flags)
>>> +static int memfd_restricted(unsigned int flags)
>>>  {
>>>       return syscall(__NR_memfd_restricted, flags);
>>>  }
>>> @@ -106,7 +106,7 @@ static u64 get_hugepage_blk_size(const char *hugetlbfs_path)
>>>       return sfs.f_bsize;
>>>  }
>>>
>>> -int memfd_alloc(u64 size, bool hugetlb, u64 blk_size)
>>> +int memfd_alloc(struct kvm *kvm, size_t size, bool hugetlb, u64 blk_size)
>>>  {
>>>       const char *name = "kvmtool";
>>>       unsigned int flags = 0;
>>> @@ -120,7 +120,11 @@ int memfd_alloc(u64 size, bool hugetlb, u64 blk_size)
>>>               flags |= blk_size << MFD_HUGE_SHIFT;
>>>       }
>>>
>>> -     fd = memfd_create(name, flags);
>>> +     if (kvm->cfg.restricted_mem)
>>> +             fd = memfd_restricted(flags);
>>> +     else
>>> +             fd = memfd_create(name, flags);
>>> +
>>>       if (fd < 0)
>>>               die_perror("Can't memfd_create for memory map");
>>>
>>> @@ -167,7 +171,7 @@ void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const char *hugetlbfs_path,
>>>       if (addr_map == MAP_FAILED)
>>>               return MAP_FAILED;
>>>
>>> -     fd = memfd_alloc(size, hugetlbfs_path, blk_size);
>>> +     fd = memfd_alloc(kvm, size, hugetlbfs_path, blk_size);
>>>       if (fd < 0)
>>>               return MAP_FAILED;
>>>
>> Extra context:
>>>       /* Map the allocated memory in the fd to the specified alignment. */
>>>       addr_align = (void *)ALIGN((u64)addr_map, align_sz);
>>>       if (mmap(addr_align, size, PROT_RW, MAP_SHARED | MAP_FIXED, fd, 0) ==
>>>           MAP_FAILED) {
>>>               close(fd);
>>>               return MAP_FAILED;
>>>       }
>>
>> So I don't understand how this works. My understanding is that
>> memfd_restricted() returns a file descriptor that cannot be mapped in
>> user space. So surely this mmap() will always fail (when
>> kvm->cfg.restricted_mem)?
>>
>> What am I missing?
> 
> You're right for the current memfd_restricted() proposal as it is now.
> However, in our discussions with the folks working on it (e.g., [1,
> 2]), we pointed out that for pkvm/arm64 and for Android we need to be
> able to mmap shared memory for a couple of reasons (e.g., sharing in
> place without copying, guest initialization). So in the pkvm/arm64
> port of the memfd_restricted (which we haven't yet sent out since
> everything is still in flux, but you can have a look at it here [3]), we
> add the ability to mmap restricted memory but with a few restrictions,
> one of them being that the memory must be shared.

Ah, ok. I'm not sure if that works for TDX or not, my understanding was
they couldn't have a user space mapping, but I'll let others familiar
with TDX comment on that.

For Arm CCA we need to ensure that the kernel doesn't create mappings:
your tree seems to include changes to block GUP so that should work.
Accesses from the VMM are not permitted but can be handled 'gracefully'
by killing off the VMM - so the mappings are not necessarily a problem,
although they do provide a significant "foot gun" to the VMM.

We still have open questions about our UABI so it would be good to have
a discussion about how to align pKVM and Arm CCA.

> Of course, we plan on submitting these patches as soon as the
> memfd_restricted is in.
> 
> I hope this answers your question.

Yes thanks, I hadn't realised from your cover letter you had changes to
memfd_restricted() on top of Chao's series.

Thanks,

Steve

> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/20220310140911.50924-1-chao.p.peng@linux.intel.com/
> [2] https://lore.kernel.org/all/20220915142913.2213336-1-chao.p.peng@linux.intel.com/
> [3] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/fdmem-v9-core
>> Thanks,
>>
>> Steve
>>

