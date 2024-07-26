Return-Path: <kvm+bounces-22277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E45193CCA5
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 04:11:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E64231F22232
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 02:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D5ED1BF2A;
	Fri, 26 Jul 2024 02:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hd2v3+iD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03791BC39;
	Fri, 26 Jul 2024 02:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721959878; cv=none; b=HFA5CHjzxL+qEdH3bmGEUKBqWTc7Dilc9Tz4ZE391R3ZQlL12WxpPQw9WeJTmlhiBoOH4dfAHbLKgvwhlLNI4CTXdrmlKrxuSn4VdeKgiLu3cx40EZl3Aj1C+y77eRA+HfCf+toT4qGgwkQkIZ+UeW9Xp6Yn3sNgdl/G30j9fGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721959878; c=relaxed/simple;
	bh=gRy20oypcmcY9pLlOMVb+0v7lyfRsZhxHwMIO1Xz8H0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P/UbErS+iWBTBDjlsXf/UbU1wRw3sj0z3aDV/9LjSnjAlcWzAMW5dwH0bk/ALneZOLOdqbU33uBDp0jbmW5HBgVj3SZvP2mWdQuk5X68c7xSYDymOsTpLX0plBDfUXTrKLHE2LGSf+RwwwVt3hsZLrN8nxiM89b5JYUZTWRMWbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hd2v3+iD; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721959876; x=1753495876;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gRy20oypcmcY9pLlOMVb+0v7lyfRsZhxHwMIO1Xz8H0=;
  b=hd2v3+iDcxGRKScHa6fQkAp8pK7ZhmkbO7UmNznUMzIygeV4pwxc418M
   AxKiwxqL+MWtPR57TwBtJH4dNlSygUOITsJ0ZExKp9plB1hdfz9nlkDU2
   eyTNohhOr0/sFx3pwdfWlD2F/crVrUtjxECj/jfEvPPa2r3AASbZtxaVu
   am5gPlVLS7RmVLFMiZxGNFKpaiOgDgzc3EzsUcJpO/cXvP2weEt887wtB
   HiTrzQszfsCVURw+QGQQSX2iCkdlYTNyC8jw/wJvUThIcYBWsqkXjbDTk
   nKrYLtxoYLk06/bb1yVWaK5oYZdbPoLDBIz3oPUcvyy2dDKpSRf4jEnhy
   Q==;
X-CSE-ConnectionGUID: qBZ5gOhDSsWBU5J+sSH6aw==
X-CSE-MsgGUID: lvrZtVqiQJqddwVP4YFLXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11144"; a="19429948"
X-IronPort-AV: E=Sophos;i="6.09,237,1716274800"; 
   d="scan'208";a="19429948"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 19:11:16 -0700
X-CSE-ConnectionGUID: y/+l7/ECTTWN9e5BqrumYg==
X-CSE-MsgGUID: 7CHQFkeiT8iV3/JEsyoj+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,237,1716274800"; 
   d="scan'208";a="58234484"
Received: from taofen1x-mobl1.ccr.corp.intel.com (HELO [10.238.11.85]) ([10.238.11.85])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 19:11:14 -0700
Message-ID: <184d90a8-14a0-494a-9112-365417245911@linux.intel.com>
Date: Fri, 26 Jul 2024 10:11:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
 isaku.yamahata@intel.com, michael.roth@amd.com
References: <202407242159.893be500-oliver.sang@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <202407242159.893be500-oliver.sang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 7/24/2024 9:48 PM, kernel test robot wrote:
>
> Hello,
>
> kernel test robot noticed "UBSAN:shift-out-of-bounds_in_arch/x86/kvm#h" on:

Oops, the return value of __kvm_emulate_hypercall() should be checked first.
Also add a warning if the hc_nr out of the range of u32 can accommodate.

Will send a new version with the following fixup.


diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 15d55a5f5755..b0d2407872ac 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10236,7 +10236,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
         cpl = static_call(kvm_x86_get_cpl)(vcpu);

         ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, 
op_64_bit, cpl);
-       if (is_kvm_hc_exit_enabled(vcpu->kvm, nr) && !ret)
+       if (!ret && is_kvm_hc_exit_enabled(vcpu->kvm, nr))
                 /* The hypercall is requested to exit to userspace. */
                 return 0;

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 3bb3c6aaad0e..bd7fe5428741 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -544,6 +544,9 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, 
unsigned int size,

  static inline bool is_kvm_hc_exit_enabled(struct kvm *kvm, unsigned 
long hc_nr)
  {
+       if(WARN_ON_ONCE(hc_nr >= 
sizeof(kvm->arch.hypercall_exit_enabled) * 8))
+               return false;
+
         return kvm->arch.hypercall_exit_enabled & (1 << hc_nr);
  }
  #endif


>
> commit: 1635eb4564804d324e91d78e8e5ed206e006e3a6 ("[PATCH 1/2] KVM: x86: Check hypercall's exit to userspace generically")
> url: https://github.com/intel-lab-lkp/linux/commits/Binbin-Wu/KVM-x86-Check-hypercall-s-exit-to-userspace-generically/20240708-172555
> patch link: https://lore.kernel.org/all/20240708092150.1799371-2-binbin.wu@linux.intel.com/
> patch subject: [PATCH 1/2] KVM: x86: Check hypercall's exit to userspace generically
>
> in testcase: kvm-unit-tests-qemu
> version:
> with following parameters:
>
>
>
>
> compiler: gcc-13
> test machine: 128 threads 2 sockets Intel(R) Xeon(R) Platinum 8358 CPU @ 2.60GHz (Ice Lake) with 128G memory
>
> (please refer to attached dmesg/kmsg for entire log/backtrace)
>
>
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202407242159.893be500-oliver.sang@intel.com
>
>
> [  414.980354][T21255] ------------[ cut here ]------------
> [  414.989024][T21255] UBSAN: shift-out-of-bounds in arch/x86/kvm/x86.h:552:47
> [  415.001167][T21255] shift exponent 4294967295 is too large for 32-bit type 'int'
> [  415.011803][T21255] CPU: 107 PID: 21255 Comm: qemu-system-x86 Not tainted 6.10.0-rc2-00186-g1635eb456480 #1
> [  415.024716][T21255] Call Trace:
> [  415.030982][T21255]  <TASK>
> [415.036836][T21255] dump_stack_lvl (lib/dump_stack.c:117)
> [415.044268][T21255] __ubsan_handle_shift_out_of_bounds (lib/ubsan.c:232 lib/ubsan.c:468)
> [415.053610][T21255] kvm_emulate_hypercall.cold (include/trace/events/kvm.h:213 (discriminator 6)) kvm
> [415.063097][T21255] ? __pfx_kvm_emulate_hypercall (arch/x86/kvm/x86.c:10206) kvm
> [415.073104][T21255] ? __vmx_handle_exit (arch/x86/kvm/vmx/vmx.c:6469) kvm_intel
> [415.082284][T21255] vmx_handle_exit (arch/x86/kvm/vmx/vmx.c:6632 (discriminator 1)) kvm_intel
> [415.090893][T21255] vcpu_enter_guest+0x130f/0x3350 kvm
> [415.100855][T21255] ? vmx_segment_cache_test_set (arch/x86/include/asm/bitops.h:206 (discriminator 1) arch/x86/include/asm/bitops.h:238 (discriminator 1) include/asm-generic/bitops/instrumented-non-atomic.h:142 (discriminator 1) arch/x86/kvm/vmx/../kvm_cache_regs.h:56 (discriminator 1) arch/x86/kvm/vmx/vmx.c:825 (discriminator 1)) kvm_intel
> [415.110593][T21255] ? __pfx_vcpu_enter_guest+0x10/0x10 kvm
> [415.120837][T21255] ? vmx_read_guest_seg_ar (arch/x86/kvm/vmx/vmx.c:865 (discriminator 1)) kvm_intel
> [415.130124][T21255] ? skip_emulated_instruction (arch/x86/kvm/vmx/vmx.c:1775) kvm_intel
> [415.139821][T21255] ? __pfx_skip_emulated_instruction (arch/x86/kvm/vmx/vmx.c:1715) kvm_intel
> [415.149853][T21255] ? __pfx_kvm_get_linear_rip (arch/x86/kvm/x86.c:13256) kvm
> [415.159211][T21255] vcpu_run (arch/x86/kvm/x86.c:11311) kvm
> [415.167028][T21255] kvm_arch_vcpu_ioctl_run (arch/x86/kvm/x86.c:11537) kvm
> [415.176327][T21255] ? __pfx_do_vfs_ioctl (fs/ioctl.c:805)
> [415.184065][T21255] kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4440) kvm
> [415.192450][T21255] ? __pfx_kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4394) kvm
> [415.201351][T21255] ? down_read_trylock (arch/x86/include/asm/atomic64_64.h:20 include/linux/atomic/atomic-arch-fallback.h:2629 include/linux/atomic/atomic-long.h:79 include/linux/atomic/atomic-instrumented.h:3224 kernel/locking/rwsem.c:176 kernel/locking/rwsem.c:181 kernel/locking/rwsem.c:1288 kernel/locking/rwsem.c:1565)
> [415.209117][T21255] ? __fget_light (fs/file.c:1154)
> [415.216411][T21255] ? fput (arch/x86/include/asm/atomic64_64.h:61 (discriminator 1) include/linux/atomic/atomic-arch-fallback.h:4404 (discriminator 1) include/linux/atomic/atomic-long.h:1571 (discriminator 1) include/linux/atomic/atomic-instrumented.h:4540 (discriminator 1) fs/file_table.c:473 (discriminator 1))
> [415.222864][T21255] ? __fget_light (fs/file.c:1154)
> [415.230119][T21255] __x64_sys_ioctl (fs/ioctl.c:51 fs/ioctl.c:907 fs/ioctl.c:893 fs/ioctl.c:893)
> [415.237407][T21255] do_syscall_64 (arch/x86/entry/common.c:52 (discriminator 1) arch/x86/entry/common.c:83 (discriminator 1))
> [415.244400][T21255] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
> [  415.252801][T21255] RIP: 0033:0x7f12912f8c5b
> [ 415.259801][T21255] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
> All code
> ========
>     0:	00 48 89             	add    %cl,-0x77(%rax)
>     3:	44 24 18             	rex.R and $0x18,%al
>     6:	31 c0                	xor    %eax,%eax
>     8:	48 8d 44 24 60       	lea    0x60(%rsp),%rax
>     d:	c7 04 24 10 00 00 00 	movl   $0x10,(%rsp)
>    14:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
>    19:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
>    1e:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
>    23:	b8 10 00 00 00       	mov    $0x10,%eax
>    28:	0f 05                	syscall
>    2a:*	89 c2                	mov    %eax,%edx		<-- trapping instruction
>    2c:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
>    31:	77 1c                	ja     0x4f
>    33:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
>    38:	64                   	fs
>    39:	48                   	rex.W
>    3a:	2b                   	.byte 0x2b
>    3b:	04 25                	add    $0x25,%al
>    3d:	28 00                	sub    %al,(%rax)
> 	...
>
> Code starting with the faulting instruction
> ===========================================
>     0:	89 c2                	mov    %eax,%edx
>     2:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
>     7:	77 1c                	ja     0x25
>     9:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
>     e:	64                   	fs
>     f:	48                   	rex.W
>    10:	2b                   	.byte 0x2b
>    11:	04 25                	add    $0x25,%al
>    13:	28 00                	sub    %al,(%rax)
> 	...
> [  415.282007][T21255] RSP: 002b:00007f128e7ff5e0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [  415.293025][T21255] RAX: ffffffffffffffda RBX: 000055cecae83b00 RCX: 00007f12912f8c5b
> [  415.303708][T21255] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000000000000c
> [  415.314228][T21255] RBP: 000000000000ae80 R08: 0000000000000000 R09: 0000000000000000
> [  415.324787][T21255] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> [  415.335326][T21255] R13: 0000000000000001 R14: 00000000000003f8 R15: 0000000000000000
> [  415.345809][T21255]  </TASK>
> [  415.351386][T21255] ---[ end trace ]---
>
>
>
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20240724/202407242159.893be500-oliver.sang@intel.com
>
>
>


