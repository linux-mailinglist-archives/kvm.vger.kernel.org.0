Return-Path: <kvm+bounces-48384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED4D9ACDBA2
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 12:06:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 862443A4368
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 10:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C7628DB51;
	Wed,  4 Jun 2025 10:05:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A4728C03A
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 10:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749031543; cv=none; b=UeJnihV2+vH36K6Q9aKJiXNhuuN2PFTJY42bydydNTdZ1jUbuayEHwMpIVCq7OQDcbeRigddS0/ZgeGcVZmWCa+G3S5VS0tC6b52w9obEGUMDLFOo93BGZ0J5yLR1RPkXd7jSw1RoUa6zp4lEyxnMN4Gq1Ch5ROYaM2xczc59Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749031543; c=relaxed/simple;
	bh=u+9kEUjH0KvHKezoG6uGQ2DEjCoQn+WqoPn2BqkiHxs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=grf4O7iMpzA4aIxZFYYLSw6XOg7SSkL3o8okciaHSaLqdyamHU8k1efQXAbuqJnifv+XiJIQ8fE++hFbmXEAKpv1jGyO3BcvAs1muxZFdb0BgZ7zpH6rdSW+Vg1qlOwRSnRhtXMgIkBxzC8gEgbzEg/8RXQhtS3Big8dj8pQLgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-i3_r46bENeCNKo8vsPGxEg-1; Wed, 04 Jun 2025 06:05:38 -0400
X-MC-Unique: i3_r46bENeCNKo8vsPGxEg-1
X-Mimecast-MFC-AGG-ID: i3_r46bENeCNKo8vsPGxEg_1749031538
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-7480c9bcfdbso620356b3a.0
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 03:05:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749031537; x=1749636337;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VMLhcnC9+JU6hatTCJVRZoN8Wtj4l/l+ETn1f3lqm+I=;
        b=sKlZP4ou0/S/hP71HPXcJ5yDU86kpZK6EZ1r7dkU3cycrkGdRxHXnTFi0n0fPznjP3
         G/MXNYOPtrRZTibgWHM3gbJk575JzGzA+lHlzdCJfWk/erseI/u5aPSi2FiK5J46HoeE
         Xl8WubJyDYfCQaXrIE3nxQkKY/ZAGhujX8faU5OuNM5HPMHhZkvLj/r5zuu4edWM4+8P
         UngyL4KFIIKgKD8/PRpWXdiCm8QxaBEzue7lUmw0lEPhDZAHzcSlp8U/jQcwZkVSEufj
         M9SMwPbn6MGNfliseP/Zy1nU+2EYdhvpsdY/+arr3nis6SNM0PTj8D5FB+ZYGUyeJ2ft
         rw1Q==
X-Gm-Message-State: AOJu0YxIvN0id6t37ixMaJkDS9Q0n9b4hfUMGl7NM4VjSAaXGpfBES7s
	PObBqgUKWz+9t1vULkIH3KRNw9YGTkotfjmHGa/4rOjMh5Mgx3WQHMMKb5u8U4dc/RrioHEHR3y
	fc0/BTWrX9Oj5ib/DlcWSwmqoOkw9T8QoBFpLxvYzcMB//tNIMcs8LA==
X-Gm-Gg: ASbGnctHlfp7pHwtpP6niiGpTJj/g9c3fFrIBPje1HoEWkjOdY4xADebonLfZTD1Soo
	kUzlvJJSltbFNzFsE9fUCRosxIWOYddLrvzY5YEZMugvM31wdq/22xRC4DcXz0+qeFx558H2QcV
	BBhlJO6jWtPR5LV4nVIBvFgUf05zP9RjmaiKk+ZslKv+ieIsSbdtY46wl17srrXaed1Q86lIQ2a
	Pw6QD6Tuw7HdjppEFdAPcAdQ+eZfay0g9FfaYdqZssaQigzRcMA4LWSIYDGL9OTtGI+qQ7QhSax
	TvfRVXhb2/ugs1bLrI7vAmaXT7pN0VW47gC0I3btZy/o33WDDNU=
X-Received: by 2002:a05:6a00:99c:b0:73e:23be:11fc with SMTP id d2e1a72fcca58-7480b48a226mr3509406b3a.22.1749031537465;
        Wed, 04 Jun 2025 03:05:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHZgFIeDTmpajCrDTaiqLjqZLgt6AKssR/SSnosipe7f4k0EhNhKGhtxyA9HSXTQicG/JvBEg==
X-Received: by 2002:a05:6a00:99c:b0:73e:23be:11fc with SMTP id d2e1a72fcca58-7480b48a226mr3509343b3a.22.1749031536953;
        Wed, 04 Jun 2025 03:05:36 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-747affd55adsm10761776b3a.156.2025.06.04.03.05.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 03:05:36 -0700 (PDT)
Message-ID: <c4516f68-3451-4bae-ae0e-c69aaa4ad939@redhat.com>
Date: Wed, 4 Jun 2025 20:05:15 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 16/16] KVM: selftests: guest_memfd mmap() test when
 mapping is allowed
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
 <20250527180245.1413463-17-tabba@google.com>
 <025ae4ea-822b-44a1-8f78-38afc0e4b07e@redhat.com>
 <CA+EHjTyfrPw0FEfaiAkmDhyE1N9hm1fXoFwKrbxv3kiPiyZQaA@mail.gmail.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <CA+EHjTyfrPw0FEfaiAkmDhyE1N9hm1fXoFwKrbxv3kiPiyZQaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 6/4/25 7:48 PM, Fuad Tabba wrote:
> On Wed, 4 Jun 2025 at 10:20, Gavin Shan <gshan@redhat.com> wrote:
>>
>> On 5/28/25 4:02 AM, Fuad Tabba wrote:
>>> Expand the guest_memfd selftests to include testing mapping guest
>>> memory for VM types that support it.
>>>
>>> Also, build the guest_memfd selftest for arm64.
>>>
>>> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>>    tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>>>    .../testing/selftests/kvm/guest_memfd_test.c  | 162 +++++++++++++++---
>>>    2 files changed, 142 insertions(+), 21 deletions(-)
>>>
>>
>> The test case fails on 64KB host, and the file size in test_create_guest_memfd_multiple()
>> would be page_size and (2 * page_size). The fixed size 4096 and 8192 aren't aligned to 64KB.
> 
> Yes, however, this patch didn't introduce or modify this test. I think
> it's better to fix it in a separate patch independent of this series.
> 

Yeah, it can be separate patch or a preparatory patch before PATCH[16/16]
of this series because x86 hasn't 64KB page size. The currently fixed sizes
(4096 and 8192) are aligned to page size on x86. and 'guest-memfd-test' is
enabled on arm64 by this series.

>> # ./guest_memfd_test
>> Random seed: 0x6b8b4567
>> ==== Test Assertion Failure ====
>>     guest_memfd_test.c:178: fd1 != -1
>>     pid=7565 tid=7565 errno=22 - Invalid argument
>>        1 0x000000000040252f: test_create_guest_memfd_multiple at guest_memfd_test.c:178
>>        2  (inlined by) test_with_type at guest_memfd_test.c:231
>>        3 0x00000000004020c7: main at guest_memfd_test.c:306
>>        4 0x0000ffff8cec733f: ?? ??:0
>>        5 0x0000ffff8cec7417: ?? ??:0
>>        6 0x00000000004021ef: _start at ??:?
>>     memfd creation should succeed
>>
>>> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
>>> index f62b0a5aba35..ccf95ed037c3 100644
>>> --- a/tools/testing/selftests/kvm/Makefile.kvm
>>> +++ b/tools/testing/selftests/kvm/Makefile.kvm
>>> @@ -163,6 +163,7 @@ TEST_GEN_PROGS_arm64 += access_tracking_perf_test
>>>    TEST_GEN_PROGS_arm64 += arch_timer
>>>    TEST_GEN_PROGS_arm64 += coalesced_io_test
>>>    TEST_GEN_PROGS_arm64 += dirty_log_perf_test
>>> +TEST_GEN_PROGS_arm64 += guest_memfd_test
>>>    TEST_GEN_PROGS_arm64 += get-reg-list
>>>    TEST_GEN_PROGS_arm64 += memslot_modification_stress_test
>>>    TEST_GEN_PROGS_arm64 += memslot_perf_test
>>> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
>>> index ce687f8d248f..3d6765bc1f28 100644
>>> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
>>> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
>>> @@ -34,12 +34,46 @@ static void test_file_read_write(int fd)
>>>                    "pwrite on a guest_mem fd should fail");
>>>    }
>>>
>>> -static void test_mmap(int fd, size_t page_size)
>>> +static void test_mmap_allowed(int fd, size_t page_size, size_t total_size)
>>> +{
>>> +     const char val = 0xaa;
>>> +     char *mem;
>>> +     size_t i;
>>> +     int ret;
>>> +
>>> +     mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
>>> +     TEST_ASSERT(mem != MAP_FAILED, "mmaping() guest memory should pass.");
>>> +
>>
>> If you agree, I think it would be nice to ensure guest-memfd doesn't support
>> copy-on-write, more details are provided below.
> 
> Good idea. I think we can do this without adding much more code. I'll
> add a check in test_mmap_allowed(), since the idea is, even if mmap()
> is supported, we still can't COW. I'll rename the functions to make
> this a bit clearer (i.e., supported instead of allowed).
> 
> Thank you for this and thank you for the reviews!
> 

Sounds good to me  :)

> 
>>> +     memset(mem, val, total_size);
>>> +     for (i = 0; i < total_size; i++)
>>> +             TEST_ASSERT_EQ(mem[i], val);
>>> +
>>> +     ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
>>> +                     page_size);
>>> +     TEST_ASSERT(!ret, "fallocate the first page should succeed");
>>> +
>>> +     for (i = 0; i < page_size; i++)
>>> +             TEST_ASSERT_EQ(mem[i], 0x00);
>>> +     for (; i < total_size; i++)
>>> +             TEST_ASSERT_EQ(mem[i], val);
>>> +
>>> +     memset(mem, val, page_size);
>>> +     for (i = 0; i < total_size; i++)
>>> +             TEST_ASSERT_EQ(mem[i], val);
>>> +
>>> +     ret = munmap(mem, total_size);
>>> +     TEST_ASSERT(!ret, "munmap should succeed");
>>> +}
>>> +
>>> +static void test_mmap_denied(int fd, size_t page_size, size_t total_size)
>>>    {
>>>        char *mem;
>>>
>>>        mem = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
>>>        TEST_ASSERT_EQ(mem, MAP_FAILED);
>>> +
>>> +     mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
>>> +     TEST_ASSERT_EQ(mem, MAP_FAILED);
>>>    }
>>
>> Add one more argument to test_mmap_denied as the flags passed to mmap().
>>
>> static void test_mmap_denied(int fd, size_t page_size, size_t total_size, int mmap_flags)
>> {
>>          mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, mmap_flags, fd, 0);
>> }
>>
>>>
>>>    static void test_file_size(int fd, size_t page_size, size_t total_size)
>>> @@ -120,26 +154,19 @@ static void test_invalid_punch_hole(int fd, size_t page_size, size_t total_size)
>>>        }
>>>    }
>>>
>>> -static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
>>> +static void test_create_guest_memfd_invalid_sizes(struct kvm_vm *vm,
>>> +                                               uint64_t guest_memfd_flags,
>>> +                                               size_t page_size)
>>>    {
>>> -     size_t page_size = getpagesize();
>>> -     uint64_t flag;
>>>        size_t size;
>>>        int fd;
>>>
>>>        for (size = 1; size < page_size; size++) {
>>> -             fd = __vm_create_guest_memfd(vm, size, 0);
>>> -             TEST_ASSERT(fd == -1 && errno == EINVAL,
>>> +             fd = __vm_create_guest_memfd(vm, size, guest_memfd_flags);
>>> +             TEST_ASSERT(fd < 0 && errno == EINVAL,
>>>                            "guest_memfd() with non-page-aligned page size '0x%lx' should fail with EINVAL",
>>>                            size);
>>>        }
>>> -
>>> -     for (flag = BIT(0); flag; flag <<= 1) {
>>> -             fd = __vm_create_guest_memfd(vm, page_size, flag);
>>> -             TEST_ASSERT(fd == -1 && errno == EINVAL,
>>> -                         "guest_memfd() with flag '0x%lx' should fail with EINVAL",
>>> -                         flag);
>>> -     }
>>>    }
>>>
>>>    static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
>>> @@ -170,30 +197,123 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
>>>        close(fd1);
>>>    }
>>>
>>> -int main(int argc, char *argv[])
>>> +#define GUEST_MEMFD_TEST_SLOT 10
>>> +#define GUEST_MEMFD_TEST_GPA 0x100000000
>>> +
>>> +static bool check_vm_type(unsigned long vm_type)
>>>    {
>>> -     size_t page_size;
>>> +     /*
>>> +      * Not all architectures support KVM_CAP_VM_TYPES. However, those that
>>> +      * support guest_memfd have that support for the default VM type.
>>> +      */
>>> +     if (vm_type == VM_TYPE_DEFAULT)
>>> +             return true;
>>> +
>>> +     return kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type);
>>> +}
>>> +
>>> +static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags,
>>> +                        bool expect_mmap_allowed)
>>> +{
>>> +     struct kvm_vm *vm;
>>>        size_t total_size;
>>> +     size_t page_size;
>>>        int fd;
>>> -     struct kvm_vm *vm;
>>>
>>> -     TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
>>> +     if (!check_vm_type(vm_type))
>>> +             return;
>>>
>>>        page_size = getpagesize();
>>>        total_size = page_size * 4;
>>>
>>> -     vm = vm_create_barebones();
>>> +     vm = vm_create_barebones_type(vm_type);
>>>
>>> -     test_create_guest_memfd_invalid(vm);
>>>        test_create_guest_memfd_multiple(vm);
>>> +     test_create_guest_memfd_invalid_sizes(vm, guest_memfd_flags, page_size);
>>>
>>> -     fd = vm_create_guest_memfd(vm, total_size, 0);
>>> +     fd = vm_create_guest_memfd(vm, total_size, guest_memfd_flags);
>>>
>>>        test_file_read_write(fd);
>>> -     test_mmap(fd, page_size);
>>> +
>>> +     if (expect_mmap_allowed)
>>> +             test_mmap_allowed(fd, page_size, total_size);
>>> +     else
>>> +             test_mmap_denied(fd, page_size, total_size);
>>> +
>>
>>          if (expect_mmap_allowed) {
>>                  test_mmap_denied(fd, page_size, total_size, MAP_PRIVATE);
>>                  test_mmap_allowed(fd, page_size, total_size);
>>          } else {
>>                  test_mmap_denied(fd, page_size, total_size, MAP_SHARED);
>>          }
>>
>>>        test_file_size(fd, page_size, total_size);
>>>        test_fallocate(fd, page_size, total_size);
>>>        test_invalid_punch_hole(fd, page_size, total_size);
>>>
>>>        close(fd);
>>> +     kvm_vm_release(vm);
>>> +}
>>> +
>>> +static void test_vm_type_gmem_flag_validity(unsigned long vm_type,
>>> +                                         uint64_t expected_valid_flags)
>>> +{
>>> +     size_t page_size = getpagesize();
>>> +     struct kvm_vm *vm;
>>> +     uint64_t flag = 0;
>>> +     int fd;
>>> +
>>> +     if (!check_vm_type(vm_type))
>>> +             return;
>>> +
>>> +     vm = vm_create_barebones_type(vm_type);
>>> +
>>> +     for (flag = BIT(0); flag; flag <<= 1) {
>>> +             fd = __vm_create_guest_memfd(vm, page_size, flag);
>>> +
>>> +             if (flag & expected_valid_flags) {
>>> +                     TEST_ASSERT(fd >= 0,
>>> +                                 "guest_memfd() with flag '0x%lx' should be valid",
>>> +                                 flag);
>>> +                     close(fd);
>>> +             } else {
>>> +                     TEST_ASSERT(fd < 0 && errno == EINVAL,
>>> +                                 "guest_memfd() with flag '0x%lx' should fail with EINVAL",
>>> +                                 flag);
>>> +             }
>>> +     }
>>> +
>>> +     kvm_vm_release(vm);
>>> +}
>>> +
>>> +static void test_gmem_flag_validity(void)
>>> +{
>>> +     uint64_t non_coco_vm_valid_flags = 0;
>>> +
>>> +     if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM))
>>> +             non_coco_vm_valid_flags = GUEST_MEMFD_FLAG_SUPPORT_SHARED;
>>> +
>>> +     test_vm_type_gmem_flag_validity(VM_TYPE_DEFAULT, non_coco_vm_valid_flags);
>>> +
>>> +#ifdef __x86_64__
>>> +     test_vm_type_gmem_flag_validity(KVM_X86_SW_PROTECTED_VM, non_coco_vm_valid_flags);
>>> +     test_vm_type_gmem_flag_validity(KVM_X86_SEV_VM, 0);
>>> +     test_vm_type_gmem_flag_validity(KVM_X86_SEV_ES_VM, 0);
>>> +     test_vm_type_gmem_flag_validity(KVM_X86_SNP_VM, 0);
>>> +     test_vm_type_gmem_flag_validity(KVM_X86_TDX_VM, 0);
>>> +#endif
>>> +}
>>> +
>>> +int main(int argc, char *argv[])
>>> +{
>>> +     TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
>>> +
>>> +     test_gmem_flag_validity();
>>> +
>>> +     test_with_type(VM_TYPE_DEFAULT, 0, false);
>>> +     if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM)) {
>>> +             test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_SUPPORT_SHARED,
>>> +                            true);
>>> +     }
>>> +
>>> +#ifdef __x86_64__
>>> +     test_with_type(KVM_X86_SW_PROTECTED_VM, 0, false);
>>> +     if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM)) {
>>> +             test_with_type(KVM_X86_SW_PROTECTED_VM,
>>> +                            GUEST_MEMFD_FLAG_SUPPORT_SHARED, true);
>>> +     }
>>> +#endif
>>>    }
>>

Thanks,
Gavin


