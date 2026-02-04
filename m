Return-Path: <kvm+bounces-70269-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YAKWJQezg2k0tAMAu9opvQ
	(envelope-from <kvm+bounces-70269-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 21:58:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D1D1EC9D2
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 21:58:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7633E30146BC
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 20:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6402C43C07B;
	Wed,  4 Feb 2026 20:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oo4R8HDp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF2837F8BD;
	Wed,  4 Feb 2026 20:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770238722; cv=none; b=bJ2ZSKXLqF+psij40ByfQ8pv1EgOQkYhjQHUbUNedSboud5wXZs1o/xkQ3URdZk4el0CeR/FZUyW/H59NdaFCAJetmEOcYNmXBEErJF9LTu5KEG93ZGJH4trFxl7HvR57rxXRqKPfmxtwTrp17iGsc+Sp1c3PaVsXdfv7RnBdOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770238722; c=relaxed/simple;
	bh=CN9YO0PgY9VI+ArnyPEylWMxEb/sOXmyT3jzqAtcOVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h25YiSI3gRUVeu4x/KZ3lpqagDD9YK3opwLtdebjbJVVaOcrqHZcf7LfgmV1OporJyuTN4ANW4ZYuDCKmGUgI81x+iXEpyyPBNUolUbm3a+HcLzqiXg/Ce2QN79v/SfxpwBV4j3GHLqQag9cW9mreAM//LmccBRkCxqqYS9kpzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oo4R8HDp; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770238722; x=1801774722;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CN9YO0PgY9VI+ArnyPEylWMxEb/sOXmyT3jzqAtcOVc=;
  b=Oo4R8HDpnzOqF2fOwRtYOdF3IYlAhpb7LUoRF+ntQCQt7iCQ+HWauF7S
   Csam/lHS60M9vrY4M1MYF3rFU4nRS6UD/KgUlLZ1Yjyn5HMqipChznMRo
   PonMuvEMdngUgdXxcsKDhjWnAj51YmKNq0WvqmBoCTkmntXwOpF3j4NAB
   xhHd6atjy4rsxXbJseWeD/DUUJHEk3u6y2ODCHn6LkgQgZt1Tvj6Amsbz
   6uZt0x8Z4EtromBVZYUzGbuhYgMoNF80w2IF9eIo1jmP2SklMcdA9uZfr
   f49dQlgCa1GVCsGkohI+sEFkXDdK43bGqm81uTCth8xkAa6+HOBnmalan
   w==;
X-CSE-ConnectionGUID: 7eRuyv1CS32nmqCBzLyQJw==
X-CSE-MsgGUID: Gj+o2rdaRxSZmc7bIz6P6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="59010626"
X-IronPort-AV: E=Sophos;i="6.21,273,1763452800"; 
   d="scan'208";a="59010626"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 12:58:41 -0800
X-CSE-ConnectionGUID: Gm0rRqvATbeCSULMVTyJrw==
X-CSE-MsgGUID: CsULfVJxTu2u8gi1KxvG6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,273,1763452800"; 
   d="scan'208";a="210058685"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 04 Feb 2026 12:58:36 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vnjxJ-00000000jAa-24qd;
	Wed, 04 Feb 2026 20:58:33 +0000
Date: Thu, 5 Feb 2026 04:57:33 +0800
From: kernel test robot <lkp@intel.com>
To: Zixing Liu <liushuyu@aosc.io>, WANG Xuerui <kernel@xen0n.name>,
	Huacai Chen <chenhuacai@kernel.org>, Bibo Mao <maobibo@loongson.cn>
Cc: oe-kbuild-all@lists.linux.dev, Kexy Biscuit <kexybiscuit@aosc.io>,
	Mingcong Bai <jeffbai@aosc.io>, Zixing Liu <liushuyu@aosc.io>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH v4] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
Message-ID: <202602050419.lwzj2i73-lkp@intel.com>
References: <20260204113601.912413-1-liushuyu@aosc.io>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204113601.912413-1-liushuyu@aosc.io>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70269-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0D1D1EC9D2
X-Rspamd-Action: no action

Hi Zixing,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on kvm/next linus/master v6.19-rc8]
[cannot apply to kvm/linux-next next-20260204]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Zixing-Liu/KVM-Add-KVM_GET_REG_LIST-ioctl-for-LoongArch/20260204-193844
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20260204113601.912413-1-liushuyu%40aosc.io
patch subject: [PATCH v4] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
config: loongarch-randconfig-002-20260204 (https://download.01.org/0day-ci/archive/20260205/202602050419.lwzj2i73-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260205/202602050419.lwzj2i73-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602050419.lwzj2i73-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from arch/loongarch/include/asm/kvm_mmu.h:9,
                    from arch/loongarch/include/asm/kvm_host.h:21,
                    from arch/loongarch/kvm/vcpu.c:6:
>> include/linux/kvm_host.h:389:30: error: field 'arch' has incomplete type
     389 |         struct kvm_vcpu_arch arch;
         |                              ^~~~
>> include/linux/kvm_host.h:390:30: error: field 'stat' has incomplete type
     390 |         struct kvm_vcpu_stat stat;
         |                              ^~~~
   include/linux/kvm_host.h:601:37: error: field 'arch' has incomplete type
     601 |         struct kvm_arch_memory_slot arch;
         |                                     ^~~~
   include/linux/kvm_host.h:831:28: error: field 'stat' has incomplete type
     831 |         struct kvm_vm_stat stat;
         |                            ^~~~
   include/linux/kvm_host.h:832:25: error: field 'arch' has incomplete type
     832 |         struct kvm_arch arch;
         |                         ^~~~
   include/linux/kvm_host.h: In function 'kvm_get_vcpu_by_id':
>> include/linux/kvm_host.h:1023:18: error: 'KVM_MAX_VCPUS' undeclared (first use in this function); did you mean 'KVM_MAX_VCPU_IDS'?
    1023 |         if (id < KVM_MAX_VCPUS)
         |                  ^~~~~~~~~~~~~
         |                  KVM_MAX_VCPU_IDS
   include/linux/kvm_host.h:1023:18: note: each undeclared identifier is reported only once for each function it appears in
   arch/loongarch/include/asm/kvm_host.h: At top level:
>> arch/loongarch/include/asm/kvm_host.h:46:9: warning: 'KVM_DIRTY_LOG_MANUAL_CAPS' redefined
      46 | #define KVM_DIRTY_LOG_MANUAL_CAPS       \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/kvm_host.h:643:9: note: this is the location of the previous definition
     643 | #define KVM_DIRTY_LOG_MANUAL_CAPS KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/loongarch/include/asm/kvm_host.h:337:20: error: static declaration of 'kvm_arch_memslots_updated' follows non-static declaration
     337 | static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/kvm_host.h:1237:6: note: previous declaration of 'kvm_arch_memslots_updated' with type 'void(struct kvm *, u64)' {aka 'void(struct kvm *, long long unsigned int)'}
    1237 | void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen);
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/loongarch/include/asm/kvm_host.h:338:20: error: static declaration of 'kvm_arch_vcpu_blocking' follows non-static declaration
     338 | static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
         |                    ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/kvm_host.h:1522:6: note: previous declaration of 'kvm_arch_vcpu_blocking' with type 'void(struct kvm_vcpu *)'
    1522 | void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
         |      ^~~~~~~~~~~~~~~~~~~~~~
>> arch/loongarch/include/asm/kvm_host.h:339:20: error: static declaration of 'kvm_arch_vcpu_unblocking' follows non-static declaration
     339 | static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/kvm_host.h:1523:6: note: previous declaration of 'kvm_arch_vcpu_unblocking' with type 'void(struct kvm_vcpu *)'
    1523 | void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
         |      ^~~~~~~~~~~~~~~~~~~~~~~~
>> arch/loongarch/include/asm/kvm_host.h:341:20: error: static declaration of 'kvm_arch_free_memslot' follows non-static declaration
     341 | static inline void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot) {}
         |                    ^~~~~~~~~~~~~~~~~~~~~
   include/linux/kvm_host.h:1236:6: note: previous declaration of 'kvm_arch_free_memslot' with type 'void(struct kvm *, struct kvm_memory_slot *)'
    1236 | void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
         |      ^~~~~~~~~~~~~~~~~~~~~
   In file included from arch/loongarch/include/asm/kvm_csr.h:12,
                    from arch/loongarch/kvm/trace.h:10,
                    from arch/loongarch/kvm/vcpu.c:16:
   arch/loongarch/include/asm/kvm_vcpu.h: In function 'kvm_read_reg':
>> arch/loongarch/include/asm/kvm_vcpu.h:120:69: warning: parameter 'num' set but not used [-Wunused-but-set-parameter]
     120 | static inline unsigned long kvm_read_reg(struct kvm_vcpu *vcpu, int num)
         |                                                                 ~~~~^~~
   arch/loongarch/include/asm/kvm_vcpu.h: In function 'kvm_write_reg':
   arch/loongarch/include/asm/kvm_vcpu.h:125:61: warning: parameter 'num' set but not used [-Wunused-but-set-parameter]
     125 | static inline void kvm_write_reg(struct kvm_vcpu *vcpu, int num, unsigned long val)
         |                                                         ~~~~^~~
   In file included from include/linux/string.h:386,
                    from include/linux/bitmap.h:13,
                    from include/linux/cpumask.h:11,
                    from arch/loongarch/include/asm/kvm_host.h:9:
   arch/loongarch/kvm/vcpu.c: In function 'kvm_set_one_reg':
   include/linux/fortify-string.h:503:65: warning: left-hand operand of comma expression has no effect [-Wunused-value]
     503 |         fortify_memset_chk(__fortify_size, p_size, p_size_field),       \
         |                                                                 ^
   include/linux/fortify-string.h:512:25: note: in expansion of macro '__fortify_memset_chk'
     512 | #define memset(p, c, s) __fortify_memset_chk(p, c, s,                   \
         |                         ^~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/vcpu.c:920:25: note: in expansion of macro 'memset'
     920 |                         memset(&vcpu->arch.irq_pending, 0, sizeof(vcpu->arch.irq_pending));
         |                         ^~~~~~
   include/linux/fortify-string.h:503:65: warning: left-hand operand of comma expression has no effect [-Wunused-value]
     503 |         fortify_memset_chk(__fortify_size, p_size, p_size_field),       \
         |                                                                 ^
   include/linux/fortify-string.h:512:25: note: in expansion of macro '__fortify_memset_chk'
     512 | #define memset(p, c, s) __fortify_memset_chk(p, c, s,                   \
         |                         ^~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/vcpu.c:921:25: note: in expansion of macro 'memset'
     921 |                         memset(&vcpu->arch.irq_clear, 0, sizeof(vcpu->arch.irq_clear));
         |                         ^~~~~~
   In file included from include/asm-generic/barrier.h:16,
                    from arch/loongarch/include/asm/barrier.h:137,
                    from arch/loongarch/include/asm/atomic.h:11,
                    from include/linux/atomic.h:7,
                    from include/linux/cpumask.h:10:
   arch/loongarch/kvm/vcpu.c: In function 'kvm_arch_vcpu_ioctl_get_regs':
>> include/linux/compiler.h:201:82: error: expression in static assertion is not an integer
     201 | #define __BUILD_BUG_ON_ZERO_MSG(e, msg, ...) ((int)sizeof(struct {_Static_assert(!(e), msg);}))
         |                                                                                  ^
   include/linux/compiler.h:206:33: note: in expansion of macro '__BUILD_BUG_ON_ZERO_MSG'
     206 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/array_size.h:11:59: note: in expansion of macro '__must_be_array'
      11 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
         |                                                           ^~~~~~~~~~~~~~~
   arch/loongarch/kvm/vcpu.c:975:25: note: in expansion of macro 'ARRAY_SIZE'
     975 |         for (i = 0; i < ARRAY_SIZE(vcpu->arch.gprs); i++)
         |                         ^~~~~~~~~~
   arch/loongarch/kvm/vcpu.c: In function 'kvm_arch_vcpu_ioctl_set_regs':
>> include/linux/compiler.h:201:82: error: expression in static assertion is not an integer
     201 | #define __BUILD_BUG_ON_ZERO_MSG(e, msg, ...) ((int)sizeof(struct {_Static_assert(!(e), msg);}))
         |                                                                                  ^
   include/linux/compiler.h:206:33: note: in expansion of macro '__BUILD_BUG_ON_ZERO_MSG'
     206 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/array_size.h:11:59: note: in expansion of macro '__must_be_array'
      11 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
         |                                                           ^~~~~~~~~~~~~~~
   arch/loongarch/kvm/vcpu.c:987:25: note: in expansion of macro 'ARRAY_SIZE'
     987 |         for (i = 1; i < ARRAY_SIZE(vcpu->arch.gprs); i++)
         |                         ^~~~~~~~~~
--
   In file included from arch/loongarch/include/asm/kvm_mmu.h:9,
                    from arch/loongarch/include/asm/kvm_host.h:21,
                    from vcpu.c:6:
>> include/linux/kvm_host.h:389:30: error: field 'arch' has incomplete type
     389 |         struct kvm_vcpu_arch arch;
         |                              ^~~~
>> include/linux/kvm_host.h:390:30: error: field 'stat' has incomplete type
     390 |         struct kvm_vcpu_stat stat;
         |                              ^~~~
   include/linux/kvm_host.h:601:37: error: field 'arch' has incomplete type
     601 |         struct kvm_arch_memory_slot arch;
         |                                     ^~~~
   include/linux/kvm_host.h:831:28: error: field 'stat' has incomplete type
     831 |         struct kvm_vm_stat stat;
         |                            ^~~~
   include/linux/kvm_host.h:832:25: error: field 'arch' has incomplete type
     832 |         struct kvm_arch arch;
         |                         ^~~~
   include/linux/kvm_host.h: In function 'kvm_get_vcpu_by_id':
>> include/linux/kvm_host.h:1023:18: error: 'KVM_MAX_VCPUS' undeclared (first use in this function); did you mean 'KVM_MAX_VCPU_IDS'?
    1023 |         if (id < KVM_MAX_VCPUS)
         |                  ^~~~~~~~~~~~~
         |                  KVM_MAX_VCPU_IDS
   include/linux/kvm_host.h:1023:18: note: each undeclared identifier is reported only once for each function it appears in
   arch/loongarch/include/asm/kvm_host.h: At top level:
>> arch/loongarch/include/asm/kvm_host.h:46:9: warning: 'KVM_DIRTY_LOG_MANUAL_CAPS' redefined
      46 | #define KVM_DIRTY_LOG_MANUAL_CAPS       \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/kvm_host.h:643:9: note: this is the location of the previous definition
     643 | #define KVM_DIRTY_LOG_MANUAL_CAPS KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/loongarch/include/asm/kvm_host.h:337:20: error: static declaration of 'kvm_arch_memslots_updated' follows non-static declaration
     337 | static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/kvm_host.h:1237:6: note: previous declaration of 'kvm_arch_memslots_updated' with type 'void(struct kvm *, u64)' {aka 'void(struct kvm *, long long unsigned int)'}
    1237 | void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen);
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/loongarch/include/asm/kvm_host.h:338:20: error: static declaration of 'kvm_arch_vcpu_blocking' follows non-static declaration
     338 | static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
         |                    ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/kvm_host.h:1522:6: note: previous declaration of 'kvm_arch_vcpu_blocking' with type 'void(struct kvm_vcpu *)'
    1522 | void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
         |      ^~~~~~~~~~~~~~~~~~~~~~
>> arch/loongarch/include/asm/kvm_host.h:339:20: error: static declaration of 'kvm_arch_vcpu_unblocking' follows non-static declaration
     339 | static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/kvm_host.h:1523:6: note: previous declaration of 'kvm_arch_vcpu_unblocking' with type 'void(struct kvm_vcpu *)'
    1523 | void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
         |      ^~~~~~~~~~~~~~~~~~~~~~~~
>> arch/loongarch/include/asm/kvm_host.h:341:20: error: static declaration of 'kvm_arch_free_memslot' follows non-static declaration
     341 | static inline void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot) {}
         |                    ^~~~~~~~~~~~~~~~~~~~~
   include/linux/kvm_host.h:1236:6: note: previous declaration of 'kvm_arch_free_memslot' with type 'void(struct kvm *, struct kvm_memory_slot *)'
    1236 | void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
         |      ^~~~~~~~~~~~~~~~~~~~~
   In file included from arch/loongarch/include/asm/kvm_csr.h:12,
                    from trace.h:10,
                    from vcpu.c:16:
   arch/loongarch/include/asm/kvm_vcpu.h: In function 'kvm_read_reg':
>> arch/loongarch/include/asm/kvm_vcpu.h:120:69: warning: parameter 'num' set but not used [-Wunused-but-set-parameter]
     120 | static inline unsigned long kvm_read_reg(struct kvm_vcpu *vcpu, int num)
         |                                                                 ~~~~^~~
   arch/loongarch/include/asm/kvm_vcpu.h: In function 'kvm_write_reg':
   arch/loongarch/include/asm/kvm_vcpu.h:125:61: warning: parameter 'num' set but not used [-Wunused-but-set-parameter]
     125 | static inline void kvm_write_reg(struct kvm_vcpu *vcpu, int num, unsigned long val)
         |                                                         ~~~~^~~
   In file included from include/linux/string.h:386,
                    from include/linux/bitmap.h:13,
                    from include/linux/cpumask.h:11,
                    from arch/loongarch/include/asm/kvm_host.h:9:
   vcpu.c: In function 'kvm_set_one_reg':
   include/linux/fortify-string.h:503:65: warning: left-hand operand of comma expression has no effect [-Wunused-value]
     503 |         fortify_memset_chk(__fortify_size, p_size, p_size_field),       \
         |                                                                 ^
   include/linux/fortify-string.h:512:25: note: in expansion of macro '__fortify_memset_chk'
     512 | #define memset(p, c, s) __fortify_memset_chk(p, c, s,                   \
         |                         ^~~~~~~~~~~~~~~~~~~~
   vcpu.c:920:25: note: in expansion of macro 'memset'
     920 |                         memset(&vcpu->arch.irq_pending, 0, sizeof(vcpu->arch.irq_pending));
         |                         ^~~~~~
   include/linux/fortify-string.h:503:65: warning: left-hand operand of comma expression has no effect [-Wunused-value]
     503 |         fortify_memset_chk(__fortify_size, p_size, p_size_field),       \
         |                                                                 ^
   include/linux/fortify-string.h:512:25: note: in expansion of macro '__fortify_memset_chk'
     512 | #define memset(p, c, s) __fortify_memset_chk(p, c, s,                   \
         |                         ^~~~~~~~~~~~~~~~~~~~
   vcpu.c:921:25: note: in expansion of macro 'memset'
     921 |                         memset(&vcpu->arch.irq_clear, 0, sizeof(vcpu->arch.irq_clear));
         |                         ^~~~~~
   In file included from include/asm-generic/barrier.h:16,
                    from arch/loongarch/include/asm/barrier.h:137,
                    from arch/loongarch/include/asm/atomic.h:11,
                    from include/linux/atomic.h:7,
                    from include/linux/cpumask.h:10:
   vcpu.c: In function 'kvm_arch_vcpu_ioctl_get_regs':
>> include/linux/compiler.h:201:82: error: expression in static assertion is not an integer
     201 | #define __BUILD_BUG_ON_ZERO_MSG(e, msg, ...) ((int)sizeof(struct {_Static_assert(!(e), msg);}))
         |                                                                                  ^
   include/linux/compiler.h:206:33: note: in expansion of macro '__BUILD_BUG_ON_ZERO_MSG'
     206 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/array_size.h:11:59: note: in expansion of macro '__must_be_array'
      11 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
         |                                                           ^~~~~~~~~~~~~~~
   vcpu.c:975:25: note: in expansion of macro 'ARRAY_SIZE'
     975 |         for (i = 0; i < ARRAY_SIZE(vcpu->arch.gprs); i++)
         |                         ^~~~~~~~~~
   vcpu.c: In function 'kvm_arch_vcpu_ioctl_set_regs':
>> include/linux/compiler.h:201:82: error: expression in static assertion is not an integer
     201 | #define __BUILD_BUG_ON_ZERO_MSG(e, msg, ...) ((int)sizeof(struct {_Static_assert(!(e), msg);}))
         |                                                                                  ^
   include/linux/compiler.h:206:33: note: in expansion of macro '__BUILD_BUG_ON_ZERO_MSG'
     206 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/array_size.h:11:59: note: in expansion of macro '__must_be_array'
      11 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
         |                                                           ^~~~~~~~~~~~~~~
   vcpu.c:987:25: note: in expansion of macro 'ARRAY_SIZE'
     987 |         for (i = 1; i < ARRAY_SIZE(vcpu->arch.gprs); i++)
         |                         ^~~~~~~~~~


vim +/arch +389 include/linux/kvm_host.h

af585b921e5d1e9 include/linux/kvm_host.h Gleb Natapov        2010-10-14  372  
4c088493c8d07e4 include/linux/kvm_host.h Raghavendra K T     2012-07-18  373  #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
4c088493c8d07e4 include/linux/kvm_host.h Raghavendra K T     2012-07-18  374  	/*
4c088493c8d07e4 include/linux/kvm_host.h Raghavendra K T     2012-07-18  375  	 * Cpu relax intercept or pause loop exit optimization
4c088493c8d07e4 include/linux/kvm_host.h Raghavendra K T     2012-07-18  376  	 * in_spin_loop: set when a vcpu does a pause loop exit
4c088493c8d07e4 include/linux/kvm_host.h Raghavendra K T     2012-07-18  377  	 *  or cpu relax intercepted.
4c088493c8d07e4 include/linux/kvm_host.h Raghavendra K T     2012-07-18  378  	 * dy_eligible: indicates whether vcpu is eligible for directed yield.
4c088493c8d07e4 include/linux/kvm_host.h Raghavendra K T     2012-07-18  379  	 */
4c088493c8d07e4 include/linux/kvm_host.h Raghavendra K T     2012-07-18  380  	struct {
4c088493c8d07e4 include/linux/kvm_host.h Raghavendra K T     2012-07-18  381  		bool in_spin_loop;
4c088493c8d07e4 include/linux/kvm_host.h Raghavendra K T     2012-07-18  382  		bool dy_eligible;
4c088493c8d07e4 include/linux/kvm_host.h Raghavendra K T     2012-07-18  383  	} spin_loop;
4c088493c8d07e4 include/linux/kvm_host.h Raghavendra K T     2012-07-18  384  #endif
a6816314af5749c include/linux/kvm_host.h David Matlack       2024-05-03  385  	bool wants_to_run;
3a08a8f9f0936e1 include/linux/kvm_host.h Raghavendra K T     2013-03-04  386  	bool preempted;
d73eb57b80b98ae include/linux/kvm_host.h Wanpeng Li          2019-07-18  387  	bool ready;
d1ae567fb8b5594 include/linux/kvm_host.h Sean Christopherson 2024-05-21  388  	bool scheduled_out;
d657a98e3c20537 drivers/kvm/kvm.h        Zhang Xiantao       2007-12-14 @389  	struct kvm_vcpu_arch arch;
ce55c049459cff0 include/linux/kvm_host.h Jing Zhang          2021-06-18 @390  	struct kvm_vcpu_stat stat;
ce55c049459cff0 include/linux/kvm_host.h Jing Zhang          2021-06-18  391  	char stats_id[KVM_STATS_NAME_SIZE];
fb04a1eddb1a65b include/linux/kvm_host.h Peter Xu            2020-09-30  392  	struct kvm_dirty_ring dirty_ring;
fe22ed827c5b60b include/linux/kvm_host.h David Matlack       2021-08-04  393  
fe22ed827c5b60b include/linux/kvm_host.h David Matlack       2021-08-04  394  	/*
a54d806688fe1e4 include/linux/kvm_host.h Maciej S. Szmigiero 2021-12-06  395  	 * The most recently used memslot by this vCPU and the slots generation
a54d806688fe1e4 include/linux/kvm_host.h Maciej S. Szmigiero 2021-12-06  396  	 * for which it is valid.
a54d806688fe1e4 include/linux/kvm_host.h Maciej S. Szmigiero 2021-12-06  397  	 * No wraparound protection is needed since generations won't overflow in
a54d806688fe1e4 include/linux/kvm_host.h Maciej S. Szmigiero 2021-12-06  398  	 * thousands of years, even assuming 1M memslot operations per second.
fe22ed827c5b60b include/linux/kvm_host.h David Matlack       2021-08-04  399  	 */
a54d806688fe1e4 include/linux/kvm_host.h Maciej S. Szmigiero 2021-12-06  400  	struct kvm_memory_slot *last_used_slot;
a54d806688fe1e4 include/linux/kvm_host.h Maciej S. Szmigiero 2021-12-06  401  	u64 last_used_slot_gen;
d657a98e3c20537 drivers/kvm/kvm.h        Zhang Xiantao       2007-12-14  402  };
d657a98e3c20537 drivers/kvm/kvm.h        Zhang Xiantao       2007-12-14  403  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

