Return-Path: <kvm+bounces-73224-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eBf7ELG6q2nEgAEAu9opvQ
	(envelope-from <kvm+bounces-73224-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 06:42:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 545EA22A523
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 06:42:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EECDD3022691
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 05:41:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AF88364E82;
	Sat,  7 Mar 2026 05:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dXNoPS3M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A635130DD16;
	Sat,  7 Mar 2026 05:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772862112; cv=none; b=tRfalFzgcT8prv7hfG4NIkO0gF1rJjaMPtP2KG/T+cVcSeWiQtrwtyvAMbzhj2XthDNeyIUP7H4Kpj/oIWC/7ka+j5e9Cc0lT3i882lzd4x5QipudE2Z2iAR1zISZegohOfIXwaqymeTUl7x1LsP8mFJEglQQhmQWNVD8NOPWPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772862112; c=relaxed/simple;
	bh=deyyp9Y5jowoiksrMAHTVIvdfns/5eQB3xCUbPOh/CQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Az5qslplw02kj6pDgAFWVvbCnCjaB5xuprMe0nqfHwVEfEcRjwLD4jnIW9oYFzeZE6ZI5YHy+u2638dGr3du8VwSQGCE3P+8csMAQKBY/lbZy4o3YMceeG3dwsncsFbdq33gr6VutOgwMD9D3rNd63Uy+9eskcW5+Feo8a+jcP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dXNoPS3M; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772862111; x=1804398111;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=deyyp9Y5jowoiksrMAHTVIvdfns/5eQB3xCUbPOh/CQ=;
  b=dXNoPS3McabKY1T1eeHY6N0/u/ERy5uKaFplj+LPDGk2WmQmUoOXs3LR
   0d4/Q/Q3woqHcdTwQc/jIXsVIjiDHkkQ1Tf4bIUndcHD0Obmz/ak85agv
   YzAKkajL3VkuHLs4YAn9O6iFBzBB6tAmDr2yUFQG8MzYzmZjkFrQAACSS
   gZmhY2pKkob6rQrF0sshbnQKu5c/naciQnyLxzOYWTnUBI2MNaGQoVmqU
   FM9U8lmAo7+pmw/KGWvEN7zvR8rVfDxuvwp2I7ZpBdpO0XGCLqtx5bEHo
   /G8uFHMrDq7Od7/lqcPJc44cYjYAkSXoVZhTw6qjAn3cswVQtmqhcwFdr
   Q==;
X-CSE-ConnectionGUID: yL8WSYE8Skmw2af/MsHzpw==
X-CSE-MsgGUID: WEDirX40TjOTzmFLl4Ge3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="84679376"
X-IronPort-AV: E=Sophos;i="6.23,106,1770624000"; 
   d="scan'208";a="84679376"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 21:41:50 -0800
X-CSE-ConnectionGUID: tJ9eYY3yQwKdYPtyX1KM+g==
X-CSE-MsgGUID: gQDXg295SUiRyuyHYKy32g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,106,1770624000"; 
   d="scan'208";a="257129668"
Received: from lkp-server01.sh.intel.com (HELO 058beb05654c) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 06 Mar 2026 21:41:45 -0800
Received: from kbuild by 058beb05654c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vykQ1-000000001jN-3b3M;
	Sat, 07 Mar 2026 05:41:41 +0000
Date: Sat, 7 Mar 2026 13:40:56 +0800
From: kernel test robot <lkp@intel.com>
To: Sairaj Kodilkar <sarunkod@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	suravee.suthikulpanit@amd.com, vasant.hegde@amd.com,
	nikunj.dadhania@amd.com, Manali.Shukla@amd.com,
	Sairaj Kodilkar <sarunkod@amd.com>
Subject: Re: [PATCH] KVM: x86: Add support for cmpxchg16b emulation
Message-ID: <202603071358.8bRahq3i-lkp@intel.com>
References: <20260306102047.29760-1-sarunkod@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306102047.29760-1-sarunkod@amd.com>
X-Rspamd-Queue-Id: 545EA22A523
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73224-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.967];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[git-scm.com:url,01.org:url,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid]
X-Rspamd-Action: no action

Hi Sairaj,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on kvm/next tip/master linus/master v7.0-rc2 next-20260306]
[cannot apply to kvm/linux-next tip/auto-latest bp/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sairaj-Kodilkar/KVM-x86-Add-support-for-cmpxchg16b-emulation/20260306-182915
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20260306102047.29760-1-sarunkod%40amd.com
patch subject: [PATCH] KVM: x86: Add support for cmpxchg16b emulation
config: i386-randconfig-012-20260307 (https://download.01.org/0day-ci/archive/20260307/202603071358.8bRahq3i-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260307/202603071358.8bRahq3i-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603071358.8bRahq3i-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/x86/kvm/mmu/page_track.c:19:
   In file included from arch/x86/kvm/mmu.h:7:
   In file included from arch/x86/kvm/x86.h:10:
>> arch/x86/kvm/kvm_emulate.h:271:3: error: unknown type name '__uint128_t'
     271 |                 __uint128_t val128;
         |                 ^
   1 error generated.
--
   In file included from arch/x86/kvm/vmx/vmcs12.c:4:
   In file included from arch/x86/kvm/vmx/vmcs12.h:7:
   In file included from arch/x86/kvm/vmx/vmcs.h:12:
   In file included from arch/x86/kvm/vmx/capabilities.h:7:
   In file included from arch/x86/kvm/vmx/../lapic.h:11:
   In file included from arch/x86/kvm/vmx/../hyperv.h:25:
   In file included from arch/x86/kvm/vmx/../x86.h:10:
>> arch/x86/kvm/vmx/../kvm_emulate.h:271:3: error: unknown type name '__uint128_t'
     271 |                 __uint128_t val128;
         |                 ^
   1 error generated.
--
   In file included from arch/x86/kvm/emulate.c:24:
>> arch/x86/kvm/kvm_emulate.h:271:3: error: unknown type name '__uint128_t'
     271 |                 __uint128_t val128;
         |                 ^
>> arch/x86/kvm/emulate.c:393:12: error: no member named 'val' in 'struct operand'
     393 |         ctxt->dst.val = 0xFF * !!(ctxt->eflags & X86_EFLAGS_CF);
         |         ~~~~~~~~~ ^
>> arch/x86/kvm/emulate.c:423:27: error: no member named 'val64' in 'struct operand'
     423 |                 .src_val    = ctxt->src.val64,
         |                               ~~~~~~~~~ ^
   arch/x86/kvm/emulate.c:424:27: error: no member named 'val64' in 'struct operand'
     424 |                 .dst_val    = ctxt->dst.val64,
         |                               ~~~~~~~~~ ^
   arch/x86/kvm/emulate.c:955:1: error: no member named 'val' in 'struct operand'
     955 | EM_ASM_2(add);
         | ^~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:346:10: note: expanded from macro 'EM_ASM_2'
     346 |         case 1: __EM_ASM_2(op##b, al, dl); break; \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:305:3: note: expanded from macro '__EM_ASM_2'
     305 |                 __EM_ASM(#op " %%" #src ", %%" #dst " \n\t")
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:291:25: note: expanded from macro '__EM_ASM'
     291 |                     : "+a" (ctxt->dst.val), \
         |                             ~~~~~~~~~ ^
   arch/x86/kvm/emulate.c:955:1: error: no member named 'val' in 'struct operand'
     955 | EM_ASM_2(add);
         | ^~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:346:10: note: expanded from macro 'EM_ASM_2'
     346 |         case 1: __EM_ASM_2(op##b, al, dl); break; \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:305:3: note: expanded from macro '__EM_ASM_2'
     305 |                 __EM_ASM(#op " %%" #src ", %%" #dst " \n\t")
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:292:25: note: expanded from macro '__EM_ASM'
     292 |                       "+d" (ctxt->src.val), \
         |                             ~~~~~~~~~ ^
   arch/x86/kvm/emulate.c:955:1: error: no member named 'val' in 'struct operand'
     955 | EM_ASM_2(add);
         | ^~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:346:10: note: expanded from macro 'EM_ASM_2'
     346 |         case 1: __EM_ASM_2(op##b, al, dl); break; \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:305:3: note: expanded from macro '__EM_ASM_2'
     305 |                 __EM_ASM(#op " %%" #src ", %%" #dst " \n\t")
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:295:25: note: expanded from macro '__EM_ASM'
     295 |                     : "c" (ctxt->src2.val))
         |                            ~~~~~~~~~~ ^
   arch/x86/kvm/emulate.c:955:1: error: no member named 'val' in 'struct operand'
     955 | EM_ASM_2(add);
         | ^~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:347:10: note: expanded from macro 'EM_ASM_2'
     347 |         case 2: __EM_ASM_2(op##w, ax, dx); break; \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:305:3: note: expanded from macro '__EM_ASM_2'
     305 |                 __EM_ASM(#op " %%" #src ", %%" #dst " \n\t")
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:291:25: note: expanded from macro '__EM_ASM'
     291 |                     : "+a" (ctxt->dst.val), \
         |                             ~~~~~~~~~ ^
   arch/x86/kvm/emulate.c:955:1: error: no member named 'val' in 'struct operand'
     955 | EM_ASM_2(add);
         | ^~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:347:10: note: expanded from macro 'EM_ASM_2'
     347 |         case 2: __EM_ASM_2(op##w, ax, dx); break; \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:305:3: note: expanded from macro '__EM_ASM_2'
     305 |                 __EM_ASM(#op " %%" #src ", %%" #dst " \n\t")
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:292:25: note: expanded from macro '__EM_ASM'
     292 |                       "+d" (ctxt->src.val), \
         |                             ~~~~~~~~~ ^
   arch/x86/kvm/emulate.c:955:1: error: no member named 'val' in 'struct operand'
     955 | EM_ASM_2(add);
         | ^~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:347:10: note: expanded from macro 'EM_ASM_2'
     347 |         case 2: __EM_ASM_2(op##w, ax, dx); break; \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:305:3: note: expanded from macro '__EM_ASM_2'
     305 |                 __EM_ASM(#op " %%" #src ", %%" #dst " \n\t")
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:295:25: note: expanded from macro '__EM_ASM'
     295 |                     : "c" (ctxt->src2.val))
         |                            ~~~~~~~~~~ ^
   arch/x86/kvm/emulate.c:955:1: error: no member named 'val' in 'struct operand'
     955 | EM_ASM_2(add);
         | ^~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:348:10: note: expanded from macro 'EM_ASM_2'
     348 |         case 4: __EM_ASM_2(op##l, eax, edx); break; \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:305:3: note: expanded from macro '__EM_ASM_2'
     305 |                 __EM_ASM(#op " %%" #src ", %%" #dst " \n\t")
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:291:25: note: expanded from macro '__EM_ASM'
     291 |                     : "+a" (ctxt->dst.val), \
         |                             ~~~~~~~~~ ^
   arch/x86/kvm/emulate.c:955:1: error: no member named 'val' in 'struct operand'
     955 | EM_ASM_2(add);
         | ^~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:348:10: note: expanded from macro 'EM_ASM_2'
     348 |         case 4: __EM_ASM_2(op##l, eax, edx); break; \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:305:3: note: expanded from macro '__EM_ASM_2'
     305 |                 __EM_ASM(#op " %%" #src ", %%" #dst " \n\t")
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/emulate.c:292:25: note: expanded from macro '__EM_ASM'
     292 |                       "+d" (ctxt->src.val), \
--
   In file included from arch/x86/kvm/x86.c:21:
   In file included from arch/x86/kvm/irq.h:19:
   In file included from arch/x86/kvm/lapic.h:11:
   In file included from arch/x86/kvm/hyperv.h:25:
   In file included from arch/x86/kvm/x86.h:10:
>> arch/x86/kvm/kvm_emulate.h:271:3: error: unknown type name '__uint128_t'
     271 |                 __uint128_t val128;
         |                 ^
   In file included from arch/x86/kvm/x86.c:44:
   include/linux/mman.h:157:9: warning: division by zero is undefined [-Wdivision-by-zero]
     157 |                _calc_vm_trans(flags, MAP_SYNC,       VM_SYNC      ) |
         |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/mman.h:135:21: note: expanded from macro '_calc_vm_trans'
     135 |    : ((x) & (bit1)) / ((bit1) / (bit2))))
         |                     ^ ~~~~~~~~~~~~~~~~~
>> arch/x86/kvm/x86.c:9381:30: error: no member named 'val' in 'struct operand'
    9381 |                 return vector == ctxt->src.val;
         |                                  ~~~~~~~~~ ^
   1 warning and 2 errors generated.


vim +/__uint128_t +271 arch/x86/kvm/kvm_emulate.h

   249	
   250	/* Type, address-of, and value of an instruction's operand. */
   251	struct operand {
   252		enum { OP_REG, OP_MEM, OP_MEM_STR, OP_IMM, OP_XMM, OP_YMM, OP_MM, OP_NONE } type;
   253		unsigned int bytes;
   254		unsigned int count;
   255		union {
   256			unsigned long orig_val;
   257			u64 orig_val64;
   258		};
   259		union {
   260			unsigned long *reg;
   261			struct segmented_address {
   262				ulong ea;
   263				unsigned seg;
   264			} mem;
   265			unsigned xmm;
   266			unsigned mm;
   267		} addr;
   268		union {
   269			unsigned long val;
   270			u64 val64;
 > 271			__uint128_t val128;
   272			char valptr[sizeof(avx256_t)];
   273			sse128_t vec_val;
   274			avx256_t vec_val2;
   275			u64 mm_val;
   276			void *data;
   277		} __aligned(32);
   278	};
   279	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

