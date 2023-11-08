Return-Path: <kvm+bounces-1149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9F7E7E5309
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:06:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D9DE28163A
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 10:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B52AC10A04;
	Wed,  8 Nov 2023 10:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nd3gSf9h"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EA11094F
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 10:06:48 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E81172A;
	Wed,  8 Nov 2023 02:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699438007; x=1730974007;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5m833ab3qSVu/sdk+jLw4K1ZbcbfYPcfhbGlcXhvGCA=;
  b=Nd3gSf9hoi462HroX1EuPpNKSTAvKCFkWLNeQVXuQx+dmD1s7GfZYl9f
   zleIDOF4niWMPqLS2eAMc5RWefzShvotZVixkbkyw0ik5XOuwwCAFmJvf
   cR14cq20gO5RADdrgpm3IPjIdxMvT8vBGGQL/8frT1sQYCTeU97WupYge
   Pqmdfzd0UrguAwynnmHbEHw6aH9K2WGgPEWD63jUoQzSalrZAbT5Uet41
   9VuifoANNeqJ+TW6NxeXKitZgudhJ6BZ6XB/rwi4DnlBSk/43xV/wYvl9
   0gbjeEdGP03Tn7Tq2lrugJ863qOM1k63UAtZMEDOCdNxutuwPbB7O9Tps
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="11286602"
X-IronPort-AV: E=Sophos;i="6.03,285,1694761200"; 
   d="scan'208";a="11286602"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 02:06:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="828921816"
X-IronPort-AV: E=Sophos;i="6.03,285,1694761200"; 
   d="scan'208";a="828921816"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.9.145]) ([10.93.9.145])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 02:06:42 -0800
Message-ID: <0ee32216-e285-406f-b20d-dd193b791d2b@intel.com>
Date: Wed, 8 Nov 2023 18:06:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: selftests: Add logic to detect if ioctl()
 failed because VM was killed
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michal Luczaj <mhal@rbox.co>, Oliver Upton <oliver.upton@linux.dev>,
 Colton Lewis <coltonlewis@google.com>
References: <20231108010953.560824-1-seanjc@google.com>
 <20231108010953.560824-3-seanjc@google.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20231108010953.560824-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/2023 9:09 AM, Sean Christopherson wrote:
> Add yet another macro to the VM/vCPU ioctl() framework to detect when an
> ioctl() failed because KVM killed/bugged the VM, i.e. when there was
> nothing wrong with the ioctl() itself.  If KVM kills a VM, e.g. by way of
> a failed KVM_BUG_ON(), all subsequent VM and vCPU ioctl()s will fail with
> -EIO, which can be quite misleading and ultimately waste user/developer
> time.
> 
> Use KVM_CHECK_EXTENSION on KVM_CAP_USER_MEMORY to detect if the VM is
> dead and/or bug, as KVM doesn't provide a dedicated ioctl().  Using a
> heuristic is obviously less than ideal, but practically speaking the logic
> is bulletproof barring a KVM change, and any such change would arguably
> break userspace, e.g. if KVM returns something other than -EIO.

We hit similar issue when testing TDX VMs. Most failure of SEMCALL is 
handled with a KVM_BUG_ON(), which leads to vm dead. Then the following 
IOCTL from userspace (QEMU) and gets -EIO.

Can we return a new KVM_EXIT_VM_DEAD on KVM_REQ_VM_DEAD? and replace 
-EIO with 0? yes, it's a ABI change. But I'm wondering if any userspace 
relies on -EIO behavior for VM DEAD case.

> Without the detection, tearing down a bugged VM yields a cryptic failure
> when deleting memslots:
> 
>    ==== Test Assertion Failure ====
>    lib/kvm_util.c:689: !ret
>    pid=45131 tid=45131 errno=5 - Input/output error
>       1	0x00000000004036c3: __vm_mem_region_delete at kvm_util.c:689
>       2	0x00000000004042f0: kvm_vm_free at kvm_util.c:724 (discriminator 12)
>       3	0x0000000000402929: race_sync_regs at sync_regs_test.c:193
>       4	0x0000000000401cab: main at sync_regs_test.c:334 (discriminator 6)
>       5	0x0000000000416f13: __libc_start_call_main at libc-start.o:?
>       6	0x000000000041855f: __libc_start_main_impl at ??:?
>       7	0x0000000000401d40: _start at ??:?
>    KVM_SET_USER_MEMORY_REGION failed, rc: -1 errno: 5 (Input/output error)
> 
> Which morphs into a more pointed error message with the detection:
> 
>    ==== Test Assertion Failure ====
>    lib/kvm_util.c:689: false
>    pid=80347 tid=80347 errno=5 - Input/output error
>       1	0x00000000004039ab: __vm_mem_region_delete at kvm_util.c:689 (discriminator 5)
>       2	0x0000000000404660: kvm_vm_free at kvm_util.c:724 (discriminator 12)
>       3	0x0000000000402ac9: race_sync_regs at sync_regs_test.c:193
>       4	0x0000000000401cb7: main at sync_regs_test.c:334 (discriminator 6)
>       5	0x0000000000418263: __libc_start_call_main at libc-start.o:?
>       6	0x00000000004198af: __libc_start_main_impl at ??:?
>       7	0x0000000000401d90: _start at ??:?
>    KVM killed/bugged the VM, check the kernel log for clues
> 
> Suggested-by: Michal Luczaj <mhal@rbox.co>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Colton Lewis <coltonlewis@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   .../selftests/kvm/include/kvm_util_base.h     | 39 ++++++++++++++++---
>   tools/testing/selftests/kvm/lib/kvm_util.c    |  2 +-
>   2 files changed, 35 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 1f6193dc7d3a..c7717942ddbb 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -282,11 +282,40 @@ static __always_inline void static_assert_is_vm(struct kvm_vm *vm) { }
>   	kvm_do_ioctl((vm)->fd, cmd, arg);			\
>   })
>   
> +/*
> + * Assert that a VM or vCPU ioctl() succeeded, with extra magic to detect if
> + * the ioctl() failed because KVM killed/bugged the VM.  To detect a dead VM,
> + * probe KVM_CAP_USER_MEMORY, which (a) has been supported by KVM since before
> + * selftests existed and (b) should never outright fail, i.e. is supposed to
> + * return 0 or 1.  If KVM kills a VM, KVM returns -EIO for all ioctl()s for the
> + * VM and its vCPUs, including KVM_CHECK_EXTENSION.
> + */
> +#define __TEST_ASSERT_VM_VCPU_IOCTL(cond, name, ret, vm)				\
> +do {											\
> +	int __errno = errno;								\
> +											\
> +	static_assert_is_vm(vm);							\
> +											\
> +	if (cond)									\
> +		break;									\
> +											\
> +	if (errno == EIO &&								\
> +	    __vm_ioctl(vm, KVM_CHECK_EXTENSION, (void *)KVM_CAP_USER_MEMORY) < 0) {	\
> +		TEST_ASSERT(errno == EIO, "KVM killed the VM, should return -EIO");	\
> +		TEST_FAIL("KVM killed/bugged the VM, check the kernel log for clues");	\
> +	}										\
> +	errno = __errno;								\
> +	TEST_ASSERT(cond, __KVM_IOCTL_ERROR(name, ret));				\
> +} while (0)
> +
> +#define TEST_ASSERT_VM_VCPU_IOCTL(cond, cmd, ret, vm)		\
> +	__TEST_ASSERT_VM_VCPU_IOCTL(cond, #cmd, ret, vm)
> +
>   #define vm_ioctl(vm, cmd, arg)					\
>   ({								\
>   	int ret = __vm_ioctl(vm, cmd, arg);			\
>   								\
> -	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
> +	__TEST_ASSERT_VM_VCPU_IOCTL(!ret, #cmd, ret, vm);		\
>   })
>   
>   static __always_inline void static_assert_is_vcpu(struct kvm_vcpu *vcpu) { }
> @@ -301,7 +330,7 @@ static __always_inline void static_assert_is_vcpu(struct kvm_vcpu *vcpu) { }
>   ({								\
>   	int ret = __vcpu_ioctl(vcpu, cmd, arg);			\
>   								\
> -	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
> +	__TEST_ASSERT_VM_VCPU_IOCTL(!ret, #cmd, ret, (vcpu)->vm);	\
>   })
>   
>   /*
> @@ -312,7 +341,7 @@ static inline int vm_check_cap(struct kvm_vm *vm, long cap)
>   {
>   	int ret =  __vm_ioctl(vm, KVM_CHECK_EXTENSION, (void *)cap);
>   
> -	TEST_ASSERT(ret >= 0, KVM_IOCTL_ERROR(KVM_CHECK_EXTENSION, ret));
> +	TEST_ASSERT_VM_VCPU_IOCTL(ret >= 0, KVM_CHECK_EXTENSION, ret, vm);
>   	return ret;
>   }
>   
> @@ -371,7 +400,7 @@ static inline int vm_get_stats_fd(struct kvm_vm *vm)
>   {
>   	int fd = __vm_ioctl(vm, KVM_GET_STATS_FD, NULL);
>   
> -	TEST_ASSERT(fd >= 0, KVM_IOCTL_ERROR(KVM_GET_STATS_FD, fd));
> +	TEST_ASSERT_VM_VCPU_IOCTL(fd >= 0, KVM_GET_STATS_FD, fd, vm);
>   	return fd;
>   }
>   
> @@ -583,7 +612,7 @@ static inline int vcpu_get_stats_fd(struct kvm_vcpu *vcpu)
>   {
>   	int fd = __vcpu_ioctl(vcpu, KVM_GET_STATS_FD, NULL);
>   
> -	TEST_ASSERT(fd >= 0, KVM_IOCTL_ERROR(KVM_GET_STATS_FD, fd));
> +	TEST_ASSERT_VM_VCPU_IOCTL(fd >= 0, KVM_CHECK_EXTENSION, fd, vcpu->vm);
>   	return fd;
>   }
>   
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 7a8af1821f5d..c847f942cd38 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1227,7 +1227,7 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
>   	vcpu->vm = vm;
>   	vcpu->id = vcpu_id;
>   	vcpu->fd = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)(unsigned long)vcpu_id);
> -	TEST_ASSERT(vcpu->fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VCPU, vcpu->fd));
> +	TEST_ASSERT_VM_VCPU_IOCTL(vcpu->fd >= 0, KVM_CREATE_VCPU, vcpu->fd, vm);
>   
>   	TEST_ASSERT(vcpu_mmap_sz() >= sizeof(*vcpu->run), "vcpu mmap size "
>   		"smaller than expected, vcpu_mmap_sz: %i expected_min: %zi",


