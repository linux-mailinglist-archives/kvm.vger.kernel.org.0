Return-Path: <kvm+bounces-48382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 00EF5ACDADE
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 11:21:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4AE31899045
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 09:21:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 968B428D858;
	Wed,  4 Jun 2025 09:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NE2yxIS/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C5B28CF5E
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 09:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749028811; cv=none; b=ZQeEeK4dGyXBcy2QylfC/Cfmuki7dXVPmwf8qmVoYbQr7VcvmyWYayWnlQ5fOPIzJHmqFgEFClZFe/P0Ap/b33fbKArsbAFP1bA1OS6hAf5WcvUciRXN97/mu/297AEdMSAwOO6tE9fL/dzsgEft7DLAXujYs+YcFVkynNwqvGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749028811; c=relaxed/simple;
	bh=ii7eOU6yJLrrMA4qGIULQI/at+jx/dTp+MCRPZgqnBc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dNIkz4Vqfa2GPM/tUtU0hC+dt+NP0K80CUBxODJbdCAo9f6wwbS0Xc/IvOeUcPkUB/AHOL2V8M2dHPwZ36WyU31x8wcG1U1fnlIkXd5k1YI8FRs3qchxOwwmBX+jiJGJiaDt+sUKY0U4iDyf/wTJgOAkg/Dj90M5RZ2rrIxqNcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NE2yxIS/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749028805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fAf/5WesuSdQ2AfSNhid2KPT8XWH52JVjhBbLgpeqgQ=;
	b=NE2yxIS/wfVxci1Si/GO/DjbSuvf98SRSjqzkO8TPqwdrRYzh8RPKwGh/lligfOXrgicK5
	+HHRhLLf+hAi9uXkf7DEfhycK1OdKdD9MFZs+m5bHv6/sh/xGKl14Kozp7VPkXaQ2o5CIl
	qcTZMAKU4Moxklo8KhxhPA+yRDHowoU=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-533-J4Nra9_3M9yypO2yS4MqyA-1; Wed, 04 Jun 2025 05:20:04 -0400
X-MC-Unique: J4Nra9_3M9yypO2yS4MqyA-1
X-Mimecast-MFC-AGG-ID: J4Nra9_3M9yypO2yS4MqyA_1749028804
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4a587a96f0aso92531311cf.3
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 02:20:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749028803; x=1749633603;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fAf/5WesuSdQ2AfSNhid2KPT8XWH52JVjhBbLgpeqgQ=;
        b=nE6IymbmAyeGb/jNPXu7Dx1ovaWNZRYEqoj/GuI5UcpsxU6KYGG7grXVQ0WVyoUmFx
         vjz+I6yGYb7hmLg6i3Wmsf/9Hjb+75itkdgidsOuJM16ya5DKJUqZhqwDTDuMi/M2Aen
         s8DeoJVnbaAyQXRA0qB/1Qn/ywzVrmIy6uzTcmJ9PmV37IQqoMx3BtfyFXXDe9vLyvGl
         wtNv8U752wyrRhpi4Lw2aRXcI8kDmOGP1eF4kA19nJZL/XbN38T4NCMbogHNgXYDjqeO
         roB50vPqNnkYTnPrZ2BibkMbOzHyHTLkuMThkK31LAeBXUhMppV8N4eliwTG6YB/Nk7n
         wrrg==
X-Forwarded-Encrypted: i=1; AJvYcCUMgWh1qYv94mA0vyR0EeCQPXwJ5R7Dnw+reqFtIDDYHS9M7zaPv6N2HouMLX9FybQFxME=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmnjKv7bdvrIcpSpxNz3tF+vIb0gejnia58d0BeUj29WNdDdPH
	LoBjqklTvEDnzIKKx+YoItmwAI9PLZKBeBj9ql4L3pgxhPnfGPj7WT/w2Xrj/BtqMqTByOAH7tY
	IuwDRKWLey3/Rs8HuRXwHm0ym286evex5VuSYYjzvZOeMjNcJNAiwoXn4kYWX+Q==
X-Gm-Gg: ASbGncslQXxk6cAMK9l4k9hmfsPSkhH69K1fDV2p94lSvr3R85bZRfzR3F1TV4ai3kF
	cKy8A3NpCD1zgBFmtJvEz6J9bpooJWxr/3rAClkoNquaXxKugDr4nTN+P1hDgd7of0RGjHZjnk2
	V4R7OvZ/DR+WNfmKGNhjdpk6OmEjSPlX+aDRyiKksIASD/yIBrGORelOLvKhxQYnBSJRR3FipE0
	UM3ETI8Xjj5Gkyb8zBto4wAHsCmp7M2NPF7LkXFPZrtLvmR+Ze2ffrLC8008+sHUqVFJBxu0v0W
	k13xYCdVFGp4kyjhz13rnUIY98bPcnTDgT8ukFfdV81GQe3rmzc=
X-Received: by 2002:a05:622a:59cf:b0:4a4:3a34:ee71 with SMTP id d75a77b69052e-4a5a587c3c0mr32738841cf.29.1749028803424;
        Wed, 04 Jun 2025 02:20:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGDBRfeeUTD5lDCOXVm1nF5HjUiabLsEWlO95RWL3yxzt9gqbJIzyw/rlDI8OPobzdte7kxSw==
X-Received: by 2002:a17:903:230d:b0:234:de0a:b36e with SMTP id d9443c01a7336-235e122944emr29504215ad.49.1749028792877;
        Wed, 04 Jun 2025 02:19:52 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-235caa81c24sm24283185ad.200.2025.06.04.02.19.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 02:19:52 -0700 (PDT)
Message-ID: <025ae4ea-822b-44a1-8f78-38afc0e4b07e@redhat.com>
Date: Wed, 4 Jun 2025 19:19:30 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 16/16] KVM: selftests: guest_memfd mmap() test when
 mapping is allowed
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
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
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250527180245.1413463-17-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 5/28/25 4:02 AM, Fuad Tabba wrote:
> Expand the guest_memfd selftests to include testing mapping guest
> memory for VM types that support it.
> 
> Also, build the guest_memfd selftest for arm64.
> 
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>   .../testing/selftests/kvm/guest_memfd_test.c  | 162 +++++++++++++++---
>   2 files changed, 142 insertions(+), 21 deletions(-)
> 

The test case fails on 64KB host, and the file size in test_create_guest_memfd_multiple()
would be page_size and (2 * page_size). The fixed size 4096 and 8192 aren't aligned to 64KB.

# ./guest_memfd_test
Random seed: 0x6b8b4567
==== Test Assertion Failure ====
   guest_memfd_test.c:178: fd1 != -1
   pid=7565 tid=7565 errno=22 - Invalid argument
      1	0x000000000040252f: test_create_guest_memfd_multiple at guest_memfd_test.c:178
      2	 (inlined by) test_with_type at guest_memfd_test.c:231
      3	0x00000000004020c7: main at guest_memfd_test.c:306
      4	0x0000ffff8cec733f: ?? ??:0
      5	0x0000ffff8cec7417: ?? ??:0
      6	0x00000000004021ef: _start at ??:?
   memfd creation should succeed

> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index f62b0a5aba35..ccf95ed037c3 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -163,6 +163,7 @@ TEST_GEN_PROGS_arm64 += access_tracking_perf_test
>   TEST_GEN_PROGS_arm64 += arch_timer
>   TEST_GEN_PROGS_arm64 += coalesced_io_test
>   TEST_GEN_PROGS_arm64 += dirty_log_perf_test
> +TEST_GEN_PROGS_arm64 += guest_memfd_test
>   TEST_GEN_PROGS_arm64 += get-reg-list
>   TEST_GEN_PROGS_arm64 += memslot_modification_stress_test
>   TEST_GEN_PROGS_arm64 += memslot_perf_test
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index ce687f8d248f..3d6765bc1f28 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -34,12 +34,46 @@ static void test_file_read_write(int fd)
>   		    "pwrite on a guest_mem fd should fail");
>   }
>   
> -static void test_mmap(int fd, size_t page_size)
> +static void test_mmap_allowed(int fd, size_t page_size, size_t total_size)
> +{
> +	const char val = 0xaa;
> +	char *mem;
> +	size_t i;
> +	int ret;
> +
> +	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> +	TEST_ASSERT(mem != MAP_FAILED, "mmaping() guest memory should pass.");
> +

If you agree, I think it would be nice to ensure guest-memfd doesn't support
copy-on-write, more details are provided below.

> +	memset(mem, val, total_size);
> +	for (i = 0; i < total_size; i++)
> +		TEST_ASSERT_EQ(mem[i], val);
> +
> +	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
> +			page_size);
> +	TEST_ASSERT(!ret, "fallocate the first page should succeed");
> +
> +	for (i = 0; i < page_size; i++)
> +		TEST_ASSERT_EQ(mem[i], 0x00);
> +	for (; i < total_size; i++)
> +		TEST_ASSERT_EQ(mem[i], val);
> +
> +	memset(mem, val, page_size);
> +	for (i = 0; i < total_size; i++)
> +		TEST_ASSERT_EQ(mem[i], val);
> +
> +	ret = munmap(mem, total_size);
> +	TEST_ASSERT(!ret, "munmap should succeed");
> +}
> +
> +static void test_mmap_denied(int fd, size_t page_size, size_t total_size)
>   {
>   	char *mem;
>   
>   	mem = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
>   	TEST_ASSERT_EQ(mem, MAP_FAILED);
> +
> +	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> +	TEST_ASSERT_EQ(mem, MAP_FAILED);
>   }

Add one more argument to test_mmap_denied as the flags passed to mmap().

static void test_mmap_denied(int fd, size_t page_size, size_t total_size, int mmap_flags)
{
	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, mmap_flags, fd, 0);
}

>   
>   static void test_file_size(int fd, size_t page_size, size_t total_size)
> @@ -120,26 +154,19 @@ static void test_invalid_punch_hole(int fd, size_t page_size, size_t total_size)
>   	}
>   }
>   
> -static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
> +static void test_create_guest_memfd_invalid_sizes(struct kvm_vm *vm,
> +						  uint64_t guest_memfd_flags,
> +						  size_t page_size)
>   {
> -	size_t page_size = getpagesize();
> -	uint64_t flag;
>   	size_t size;
>   	int fd;
>   
>   	for (size = 1; size < page_size; size++) {
> -		fd = __vm_create_guest_memfd(vm, size, 0);
> -		TEST_ASSERT(fd == -1 && errno == EINVAL,
> +		fd = __vm_create_guest_memfd(vm, size, guest_memfd_flags);
> +		TEST_ASSERT(fd < 0 && errno == EINVAL,
>   			    "guest_memfd() with non-page-aligned page size '0x%lx' should fail with EINVAL",
>   			    size);
>   	}
> -
> -	for (flag = BIT(0); flag; flag <<= 1) {
> -		fd = __vm_create_guest_memfd(vm, page_size, flag);
> -		TEST_ASSERT(fd == -1 && errno == EINVAL,
> -			    "guest_memfd() with flag '0x%lx' should fail with EINVAL",
> -			    flag);
> -	}
>   }
>   
>   static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
> @@ -170,30 +197,123 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
>   	close(fd1);
>   }
>   
> -int main(int argc, char *argv[])
> +#define GUEST_MEMFD_TEST_SLOT 10
> +#define GUEST_MEMFD_TEST_GPA 0x100000000
> +
> +static bool check_vm_type(unsigned long vm_type)
>   {
> -	size_t page_size;
> +	/*
> +	 * Not all architectures support KVM_CAP_VM_TYPES. However, those that
> +	 * support guest_memfd have that support for the default VM type.
> +	 */
> +	if (vm_type == VM_TYPE_DEFAULT)
> +		return true;
> +
> +	return kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type);
> +}
> +
> +static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags,
> +			   bool expect_mmap_allowed)
> +{
> +	struct kvm_vm *vm;
>   	size_t total_size;
> +	size_t page_size;
>   	int fd;
> -	struct kvm_vm *vm;
>   
> -	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> +	if (!check_vm_type(vm_type))
> +		return;
>   
>   	page_size = getpagesize();
>   	total_size = page_size * 4;
>   
> -	vm = vm_create_barebones();
> +	vm = vm_create_barebones_type(vm_type);
>   
> -	test_create_guest_memfd_invalid(vm);
>   	test_create_guest_memfd_multiple(vm);
> +	test_create_guest_memfd_invalid_sizes(vm, guest_memfd_flags, page_size);
>   
> -	fd = vm_create_guest_memfd(vm, total_size, 0);
> +	fd = vm_create_guest_memfd(vm, total_size, guest_memfd_flags);
>   
>   	test_file_read_write(fd);
> -	test_mmap(fd, page_size);
> +
> +	if (expect_mmap_allowed)
> +		test_mmap_allowed(fd, page_size, total_size);
> +	else
> +		test_mmap_denied(fd, page_size, total_size);
> +

	if (expect_mmap_allowed) {
		test_mmap_denied(fd, page_size, total_size, MAP_PRIVATE);
		test_mmap_allowed(fd, page_size, total_size);
	} else {
		test_mmap_denied(fd, page_size, total_size, MAP_SHARED);
	}

>   	test_file_size(fd, page_size, total_size);
>   	test_fallocate(fd, page_size, total_size);
>   	test_invalid_punch_hole(fd, page_size, total_size);
>   
>   	close(fd);
> +	kvm_vm_release(vm);
> +}
> +
> +static void test_vm_type_gmem_flag_validity(unsigned long vm_type,
> +					    uint64_t expected_valid_flags)
> +{
> +	size_t page_size = getpagesize();
> +	struct kvm_vm *vm;
> +	uint64_t flag = 0;
> +	int fd;
> +
> +	if (!check_vm_type(vm_type))
> +		return;
> +
> +	vm = vm_create_barebones_type(vm_type);
> +
> +	for (flag = BIT(0); flag; flag <<= 1) {
> +		fd = __vm_create_guest_memfd(vm, page_size, flag);
> +
> +		if (flag & expected_valid_flags) {
> +			TEST_ASSERT(fd >= 0,
> +				    "guest_memfd() with flag '0x%lx' should be valid",
> +				    flag);
> +			close(fd);
> +		} else {
> +			TEST_ASSERT(fd < 0 && errno == EINVAL,
> +				    "guest_memfd() with flag '0x%lx' should fail with EINVAL",
> +				    flag);
> +		}
> +	}
> +
> +	kvm_vm_release(vm);
> +}
> +
> +static void test_gmem_flag_validity(void)
> +{
> +	uint64_t non_coco_vm_valid_flags = 0;
> +
> +	if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM))
> +		non_coco_vm_valid_flags = GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> +
> +	test_vm_type_gmem_flag_validity(VM_TYPE_DEFAULT, non_coco_vm_valid_flags);
> +
> +#ifdef __x86_64__
> +	test_vm_type_gmem_flag_validity(KVM_X86_SW_PROTECTED_VM, non_coco_vm_valid_flags);
> +	test_vm_type_gmem_flag_validity(KVM_X86_SEV_VM, 0);
> +	test_vm_type_gmem_flag_validity(KVM_X86_SEV_ES_VM, 0);
> +	test_vm_type_gmem_flag_validity(KVM_X86_SNP_VM, 0);
> +	test_vm_type_gmem_flag_validity(KVM_X86_TDX_VM, 0);
> +#endif
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> +
> +	test_gmem_flag_validity();
> +
> +	test_with_type(VM_TYPE_DEFAULT, 0, false);
> +	if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM)) {
> +		test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_SUPPORT_SHARED,
> +			       true);
> +	}
> +
> +#ifdef __x86_64__
> +	test_with_type(KVM_X86_SW_PROTECTED_VM, 0, false);
> +	if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM)) {
> +		test_with_type(KVM_X86_SW_PROTECTED_VM,
> +			       GUEST_MEMFD_FLAG_SUPPORT_SHARED, true);
> +	}
> +#endif
>   }

Thanks,
Gavin


