Return-Path: <kvm+bounces-48511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 73151ACED24
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 11:54:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0285C1899507
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 09:54:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95CD62144B4;
	Thu,  5 Jun 2025 09:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D58U4HYy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFF82C3242
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 09:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749117228; cv=none; b=YewY/aHv6ShNNxHEWjCZ6RLZ+m7CVZYBNhUkemsg1KD/B1dSsu36ZgbWAacs/nLvxATdi3itkb5O6zg2/XTu/0vNhEd9jIjm5VKygzIi8/kHE9ZUcmNpZDKaMblEj0PFrbqa2qUtfGGth+8qwg1wLIX/kpXauhQMctSoP92AVeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749117228; c=relaxed/simple;
	bh=BZFHm6HNaTgIp7zDsbFi2BfFseHuIIGtcSzrybKHDX0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aaP4hzAYgxl8Jcx5UFa78C9uH5EJii6vmD/wXH9n3QGrLZcREXb9IbgPYnN9N8UiDCI6q0KaPytbrs/LhJUisRkusxaytg92pZOLmUE0C6uPf5LFFNfkf9VstUjhmcGyVvTSh1AHMmVmPKe0BQaGw9tWGptheCUsnmS41An0gBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D58U4HYy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749117225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J43uCKXEn+SG1NBLYbmY/1GhHbXlB9O24zx13cdYIX4=;
	b=D58U4HYy6vuoWBev5BTyh6gX+AgL0XF9MFPgSxLJFzfnUHlFX447l/bvDSl0llF5reeZNg
	yqDkRrJw4aA1WE5Jy2LwgYyZuATAHzrFHsiXpMuzB1etqbpjTalZ3CJ3hogro+f7UCXoM6
	y9jPGuEdameuSoda2XObuhph/7OeieA=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-43HPCefUM8OKV_9frgMq7g-1; Thu, 05 Jun 2025 05:53:44 -0400
X-MC-Unique: 43HPCefUM8OKV_9frgMq7g-1
X-Mimecast-MFC-AGG-ID: 43HPCefUM8OKV_9frgMq7g_1749117223
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-31218e2d5b0so1127486a91.2
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 02:53:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749117223; x=1749722023;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J43uCKXEn+SG1NBLYbmY/1GhHbXlB9O24zx13cdYIX4=;
        b=E4wZXOwCZACRxthIPnKwsbjlRFC/h1paW9rF5DiIBhfpCn5Wpez7PmYweLE7Hww2G9
         CbPX9UaPTKpWj6JgNyQww2NlwpLHVeuG9j/nRXOliH1RVzO6ZtU15bct3xRIUFveWNdk
         a7qX9ROdrSUM5fIpd7kc/4NDsy2n7sFkVUPU0uSfdbvS+RrokTbK1JGH19F13mRqFL6W
         r/wrIfRFlBsPiZI5Fm8bqaBUFQ1ZG8lf5RpPWQU8+EfIHLHOprKLxk4VDqHqNR2O6v46
         qrynQG8dbl46DbatKhRWrqFxhmUUVzW7RycDFHFY3vGyluBD2Y5ylGzAbwF944igaXPk
         6tnA==
X-Gm-Message-State: AOJu0Yz8lfH4XZQDzc/S3VI+hrsJ/9c/rPo5HhmveCwhpysmv/6jxrrV
	RRHmoWd/2yt4Pg41XhZXclomkxijefFFTz5pDJlMz1oVjIXafkQlSlWAfhO75jyyKRf7NUbVrpV
	q1qUa2GEVCWhK+lPVc+OlE042QcH70Fmjx6o49ZSqjkzfN17mSNDqkA==
X-Gm-Gg: ASbGncvjoy7jwFmwl6mU4n0XIEqId1ndVeI0YM+Dh9ma/c+cwoPrCuMklwSxL5R/a4z
	3E+SM9GuafVXxRh+W+6iUxU1DncNPRe1slLHAFkrZpJ2V6VVYQFAZLvOKefzZibFPyTXYAt/pvl
	aGsLsqOnH6PLJ1gKI2PqeX8eUpRt4GK2fxs3m/xvjw5qScRAjkyoBZfUJfI2zLr0trr2n/RiHTh
	tkFmyiLVQw0iDm43LKp4xvghDt41zeMHwEsRHQ2tEEqXFHPVMPsALZlFOhLrfK63sVRKXiyj2eT
	2LksN0ZuwwW+pVvbqzFhvAjOJESqGx3r2FUDyTVMv2s2sw5NsOk=
X-Received: by 2002:a17:90b:54c7:b0:311:fde5:c4b6 with SMTP id 98e67ed59e1d1-3130ccb722emr7811434a91.6.1749117223314;
        Thu, 05 Jun 2025 02:53:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdlXJT92sM472mFb/jjCfzk8rM/+jui3pNum1NFuJV2gyTKw9Y+SxG36R+H02BlReB5Otz1g==
X-Received: by 2002:a17:90b:54c7:b0:311:fde5:c4b6 with SMTP id 98e67ed59e1d1-3130ccb722emr7811320a91.6.1749117222398;
        Thu, 05 Jun 2025 02:53:42 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506cf471asm116521625ad.164.2025.06.05.02.53.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jun 2025 02:53:41 -0700 (PDT)
Message-ID: <9ccf1cbb-6cbc-4af0-97b4-a4e884233851@redhat.com>
Date: Thu, 5 Jun 2025 19:53:20 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 08/16] KVM: guest_memfd: Allow host to map guest_memfd
 pages
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250527180245.1413463-1-tabba@google.com>
 <20250527180245.1413463-9-tabba@google.com>
 <a3d6ff25-236b-4dfd-8a04-6df437ecb4bb@redhat.com>
 <CA+EHjTzFkTJr+gD7ZEbRMXhg9KwQDNjqy0Smss37+13Dz-bnnQ@mail.gmail.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <CA+EHjTzFkTJr+gD7ZEbRMXhg9KwQDNjqy0Smss37+13Dz-bnnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 6/5/25 6:25 PM, Fuad Tabba wrote:
> On Thu, 5 Jun 2025 at 07:41, Gavin Shan <gshan@redhat.com> wrote:
>> On 5/28/25 4:02 AM, Fuad Tabba wrote:
>>> This patch enables support for shared memory in guest_memfd, including
>>> mapping that memory at the host userspace. This support is gated by the
>>> configuration option KVM_GMEM_SHARED_MEM, and toggled by the guest_memfd
>>> flag GUEST_MEMFD_FLAG_SUPPORT_SHARED, which can be set when creating a
>>> guest_memfd instance.
>>>
>>> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>>    arch/x86/include/asm/kvm_host.h | 10 ++++
>>>    arch/x86/kvm/x86.c              |  3 +-
>>>    include/linux/kvm_host.h        | 13 ++++++
>>>    include/uapi/linux/kvm.h        |  1 +
>>>    virt/kvm/Kconfig                |  5 ++
>>>    virt/kvm/guest_memfd.c          | 81 +++++++++++++++++++++++++++++++++
>>>    6 files changed, 112 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>> index 709cc2a7ba66..ce9ad4cd93c5 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -2255,8 +2255,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>>>
>>>    #ifdef CONFIG_KVM_GMEM
>>>    #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
>>> +
>>> +/*
>>> + * CoCo VMs with hardware support that use guest_memfd only for backing private
>>> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
>>> + */
>>> +#define kvm_arch_supports_gmem_shared_mem(kvm)                       \
>>> +     (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&                      \
>>> +      ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||             \
>>> +       (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
>>>    #else
>>>    #define kvm_arch_supports_gmem(kvm) false
>>> +#define kvm_arch_supports_gmem_shared_mem(kvm) false
>>>    #endif
>>>
>>>    #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 035ced06b2dd..2a02f2457c42 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -12718,7 +12718,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>>                return -EINVAL;
>>>
>>>        kvm->arch.vm_type = type;
>>> -     kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
>>> +     kvm->arch.supports_gmem =
>>> +             type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
>>>        /* Decided by the vendor code for other VM types.  */
>>>        kvm->arch.pre_fault_allowed =
>>>                type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>> index 80371475818f..ba83547e62b0 100644
>>> --- a/include/linux/kvm_host.h
>>> +++ b/include/linux/kvm_host.h
>>> @@ -729,6 +729,19 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
>>>    }
>>>    #endif
>>>
>>> +/*
>>> + * Returns true if this VM supports shared mem in guest_memfd.
>>> + *
>>> + * Arch code must define kvm_arch_supports_gmem_shared_mem if support for
>>> + * guest_memfd is enabled.
>>> + */
>>> +#if !defined(kvm_arch_supports_gmem_shared_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
>>> +static inline bool kvm_arch_supports_gmem_shared_mem(struct kvm *kvm)
>>> +{
>>> +     return false;
>>> +}
>>> +#endif
>>> +
>>>    #ifndef kvm_arch_has_readonly_mem
>>>    static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
>>>    {
>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index b6ae8ad8934b..c2714c9d1a0e 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -1566,6 +1566,7 @@ struct kvm_memory_attributes {
>>>    #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>>>
>>>    #define KVM_CREATE_GUEST_MEMFD      _IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
>>> +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED      (1ULL << 0)
>>>
>>>    struct kvm_create_guest_memfd {
>>>        __u64 size;
>>> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
>>> index 559c93ad90be..df225298ab10 100644
>>> --- a/virt/kvm/Kconfig
>>> +++ b/virt/kvm/Kconfig
>>> @@ -128,3 +128,8 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
>>>    config HAVE_KVM_ARCH_GMEM_INVALIDATE
>>>           bool
>>>           depends on KVM_GMEM
>>> +
>>> +config KVM_GMEM_SHARED_MEM
>>> +       select KVM_GMEM
>>> +       bool
>>> +       prompt "Enable support for non-private (shared) memory in guest_memfd"
>>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>>> index 6db515833f61..5d34712f64fc 100644
>>> --- a/virt/kvm/guest_memfd.c
>>> +++ b/virt/kvm/guest_memfd.c
>>> @@ -312,7 +312,81 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>>>        return gfn - slot->base_gfn + slot->gmem.pgoff;
>>>    }
>>>
>>> +static bool kvm_gmem_supports_shared(struct inode *inode)
>>> +{
>>> +     u64 flags;
>>> +
>>> +     if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
>>> +             return false;
>>> +
>>> +     flags = (u64)inode->i_private;
>>> +
>>> +     return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
>>> +}
>>> +
>>> +
>>> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
>>> +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
>>> +{
>>> +     struct inode *inode = file_inode(vmf->vma->vm_file);
>>> +     struct folio *folio;
>>> +     vm_fault_t ret = VM_FAULT_LOCKED;
>>> +
>>> +     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
>>> +     if (IS_ERR(folio)) {
>>> +             int err = PTR_ERR(folio);
>>> +
>>> +             if (err == -EAGAIN)
>>> +                     return VM_FAULT_RETRY;
>>> +
>>> +             return vmf_error(err);
>>> +     }
>>> +
>>> +     if (WARN_ON_ONCE(folio_test_large(folio))) {
>>> +             ret = VM_FAULT_SIGBUS;
>>> +             goto out_folio;
>>> +     }
>>> +
>>> +     if (!folio_test_uptodate(folio)) {
>>> +             clear_highpage(folio_page(folio, 0));
>>> +             kvm_gmem_mark_prepared(folio);
>>> +     }
>>> +
>>> +     vmf->page = folio_file_page(folio, vmf->pgoff);
>>> +
>>> +out_folio:
>>> +     if (ret != VM_FAULT_LOCKED) {
>>> +             folio_unlock(folio);
>>> +             folio_put(folio);
>>> +     }
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static const struct vm_operations_struct kvm_gmem_vm_ops = {
>>> +     .fault = kvm_gmem_fault_shared,
>>> +};
>>> +
>>> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>>> +{
>>> +     if (!kvm_gmem_supports_shared(file_inode(file)))
>>> +             return -ENODEV;
>>> +
>>> +     if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
>>> +         (VM_SHARED | VM_MAYSHARE)) {
>>> +             return -EINVAL;
>>> +     }
>>> +
>>> +     vma->vm_ops = &kvm_gmem_vm_ops;
>>> +
>>> +     return 0;
>>> +}
>>> +#else
>>> +#define kvm_gmem_mmap NULL
>>> +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
>>> +
>>>    static struct file_operations kvm_gmem_fops = {
>>> +     .mmap           = kvm_gmem_mmap,
>>>        .open           = generic_file_open,
>>>        .release        = kvm_gmem_release,
>>>        .fallocate      = kvm_gmem_fallocate,
>>> @@ -463,6 +537,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>>>        u64 flags = args->flags;
>>>        u64 valid_flags = 0;
>>>
>>
>> It seems there is an uncovered corner case, which exists in current code (not directly
>> caused by this patch): After .mmap is hooked, the address space (inode->i_mapping) is
>> exposed to user space for futher requests like madvise().madvise(MADV_COLLAPSE) can
>> potentially collapse the pages to a huge page (folio) with the following assumptions.
>> It's not the expected behavior since huge page isn't supported yet.
>>
>> - CONFIG_READ_ONLY_THP_FOR_FS = y
>> - the folios in the pagecache have been fully populated, it can be done by kvm_gmem_fallocate()
>>     or kvm_gmem_get_pfn().
>> - mmap(0x00000f0100000000, ..., MAP_FIXED_NOREPLACE) on the guest-memfd, and then do
>>     madvise(buf, size, MADV_COLLAPSE).
>>
>> sys_madvise
>>     do_madvise
>>       madvise_do_behavior
>>         madvise_vma_behavior
>>           madvise_collapse
>>             thp_vma_allowable_order
>>               file_thp_enabled             // need to return false to bail from the path earlier at least
>>             hpage_collapse_scan_file
>>             collapse_pte_mapped_thp
>>
>> The fix would be to increase inode->i_writecount using allow_write_access() in
>> __kvm_gmem_create() to break the check done by file_thp_enabled().
> 
> Thanks for catching this. Even though it's not an issue until huge
> page support is added, we might as well handle it now.
> 
> Out of curiosity, how did you spot this?
> 

No worries. Yeah, I think it's better to hide guest-memfd from huge pages at
present since huge page isn't supported yet. I have a kselftest scenario,
something like below. I expected it to fail on madvise(MADV_COLLAPSE), but
it didn't.

static void test_extra(unsigned long vm_type)
{
         struct kvm_vm *vm;
         size_t page_size = getpagesize();
         size_t total_size = page_size * (page_size / 8); /* one huge page */
         int i, fd, ret;
         void *buf;

         /* Create VM and guest-memfd */
         vm = vm_create_barebones_type(vm_type);
         fd = vm_create_guest_memfd(vm, total_size, GUEST_MEMFD_FLAG_SUPPORT_SHARED);
         buf = mmap((void *)0x00000f0100000000, total_size, PROT_READ | PROT_WRITE,
                    MAP_SHARED | MAP_FIXED_NOREPLACE, fd, 0);
         TEST_ASSERT(buf != MAP_FAILED, "mmap() guest memory should pass.");
         fprintf(stdout, "0x%lx mmapped at 0x%lx\n", total_size, (unsigned long)buf);

         /* fault-in without huge pages */
         ret = madvise(buf, total_size, MADV_NOHUGEPAGE);
         TEST_ASSERT(ret == 0, "madvise(NOHUGEPAGE) should pass.");
         ret = madvise(buf, total_size, MADV_POPULATE_READ);
         TEST_ASSERT(ret == 0, "madvise(POPULATE_READ) should pass.");

	/* collapse to a huge page */
	ret = madvise(buf, total_size, MADV_HUGEPAGE);
	TEST_ASSERT(ret == 0, "madvise(HUGEPAGE) should pass.");
	ret = madvise(buf, total_size, MADV_COLLAPSE);
	TEST_ASSERT(ret != 0, "madvise(COLLAPSE) should fail.");
}

int main(int argc, char *argv[])
{
	test_extra(VM_TYPE_DEFAULT);
}

Thanks,
Gavin

>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 0cd12f94958b..fe706c9f21cf 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -502,6 +502,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>>           }
>>
>>           file->f_flags |= O_LARGEFILE;
>> +       allow_write_access(file);
>>
>>
>>> +     if (kvm_arch_supports_gmem_shared_mem(kvm))
>>> +             valid_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED;
>>> +
>>>        if (flags & ~valid_flags)
>>>                return -EINVAL;
>>>
>>> @@ -501,6 +578,10 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>>>            offset + size > i_size_read(inode))
>>>                goto err;
>>>
>>> +     if (kvm_gmem_supports_shared(inode) &&
>>> +         !kvm_arch_supports_gmem_shared_mem(kvm))
>>> +             goto err;
>>> +
>>>        filemap_invalidate_lock(inode->i_mapping);
>>>
>>>        start = offset >> PAGE_SHIFT;
>>
>> Thanks,
>> Gavin
>>
> 


