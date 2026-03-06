Return-Path: <kvm+bounces-73007-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eGvDF7mkqml6UwEAu9opvQ
	(envelope-from <kvm+bounces-73007-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 10:56:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DBF9521E452
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 10:56:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8D4E83014420
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 09:56:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E0F134D4F7;
	Fri,  6 Mar 2026 09:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iCVuGZWs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C079A34CFC0;
	Fri,  6 Mar 2026 09:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772790959; cv=none; b=EGETNeuD7KjCz+DzyV5Q2mddUyTTzV2nvld4g03NeYOwPJWfFW72vN60E4WxJrEFa1QkJaSSB6rbknUaHUbgyaH9XnLwT+Z/1i/BJsxyRNnZl1KylFGEDFFtNHXlXiGiwpoO6KbF7HDamxLQgY8ubeOQ3VkdtHIH3JxMvoEH+hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772790959; c=relaxed/simple;
	bh=cDZV9LfCWUPqqLU+zejqwkrlt+4RZGI/9jA3pBR+zNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sVIKwsKFuI/oa1QBr/8Mxe0nQp7m3fDOLWIM3oRyIrVTmWNltwGEy/WZNDfCct8oH1Iq+RRTSDUXskO1rylF+zNqF/sGYHiutmUumsWw4XEpTeQ1GlHo4Mo+mTAznPGxbosV0ZymL9KJ8PIMpRjNrqPs+Tx2OwpWuVepb3mGIH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iCVuGZWs; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772790958; x=1804326958;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=cDZV9LfCWUPqqLU+zejqwkrlt+4RZGI/9jA3pBR+zNI=;
  b=iCVuGZWsu7OjUKTUMyq6pQ85IFUUUnSiWUKkeYbPvOJp90n5aiAIqslr
   OeH2XbTcyz1WMGIFsJn/hOynHKdgENCYv5p+aDbgfF7pqbd0AQ2Y1GtBA
   gvkG7RfPx7Sr+pVW665CPKaDFR2I+vd2fTSNWCObLob8oVgNUYwzjt0N0
   g9oYyS1zOGxvkF6jGZgSoyFYHxwIIB+G3NoZ8PDDkxv4MKA5kCjQXvIZk
   j8FJ6fgb3t8X7RTlJmGqmq12GUSw3i3oD3tPaMfBMOEcdLibH3rXUE7iY
   0Hh+ozh78W6ilyOl4yS9admTJmwZvUokWSP7qvpjKOpu3tmM6fTQ1W5Xj
   A==;
X-CSE-ConnectionGUID: N1OfjzFpQ92ZsWPchLRKsw==
X-CSE-MsgGUID: 7XCjx35cTDS3Q5Y3lmcdSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="84980169"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="84980169"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 01:55:57 -0800
X-CSE-ConnectionGUID: mHXGC9QXRbyy6qWTW6J3eA==
X-CSE-MsgGUID: 5Ig/g1V2RpK88YOUDrN7TA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="223942937"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa005.jf.intel.com with ESMTP; 06 Mar 2026 01:55:56 -0800
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vyRuT-000000002EL-2EGh;
	Fri, 06 Mar 2026 09:55:53 +0000
Date: Fri, 6 Mar 2026 10:55:25 +0100
From: kernel test robot <lkp@intel.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: Change [g|h]va_t as u64
Message-ID: <202603061007.7Z2iBYzb-lkp@intel.com>
References: <20260306041125.45643-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260306041125.45643-1-anshuman.khandual@arm.com>
X-Rspamd-Queue-Id: DBF9521E452
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73007-lists,kvm=lfdr.de];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

Hi Anshuman,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on kvm/next kvm/linux-next linus/master v7.0-rc2 next-20260305]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Anshuman-Khandual/KVM-Change-g-h-va_t-as-u64/20260306-123029
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20260306041125.45643-1-anshuman.khandual%40arm.com
patch subject: [PATCH] KVM: Change [g|h]va_t as u64
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260306/202603061007.7Z2iBYzb-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260306/202603061007.7Z2iBYzb-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603061007.7Z2iBYzb-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from arch/x86/kvm/x86.c:89:
   In file included from arch/x86/kvm/trace.h:1976:
   In file included from include/trace/define_trace.h:132:
   In file included from include/trace/trace_events.h:256:
>> arch/x86/kvm/trace.h:973:40: warning: format specifies type 'unsigned long' but the argument has type 'gva_t' (aka 'unsigned long long') [-Wformat]
     954 |                 __field(gpa_t, gpa)
         |                 ~~~~~~~~~~~~~~~~~~~
     955 |                 __field(bool, write)
         |                 ~~~~~~~~~~~~~~~~~~~~
     956 |                 __field(bool, gpa_match)
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~
     957 |                 ),
         |                 ~~
     958 | 
     959 |         TP_fast_assign(
         |         ~~~~~~~~~~~~~~~
     960 |                 __entry->gva = gva;
         |                 ~~~~~~~~~~~~~~~~~~~
     961 |                 __entry->gpa = gpa;
         |                 ~~~~~~~~~~~~~~~~~~~
     962 |                 __entry->write = write;
         |                 ~~~~~~~~~~~~~~~~~~~~~~~
     963 |                 __entry->gpa_match = gpa_match
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     964 |                 ),
         |                 ~~
     965 | 
     966 |         TP_printk("gva %#lx gpa %#llx %s %s", __entry->gva, __entry->gpa,
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                        %#llx
     967 |                   __entry->write ? "Write" : "Read",
         |                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     968 |                   __entry->gpa_match ? "GPA" : "GVA")
         |                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     969 | );
         | ~
   include/trace/stages/stage3_trace_output.h:6:17: note: expanded from macro '__entry'
       6 | #define __entry field
         |                 ^
   include/trace/stages/stage3_trace_output.h:9:43: note: expanded from macro 'TP_printk'
       9 | #define TP_printk(fmt, args...) fmt "\n", args
         |                                 ~~~       ^
   include/trace/trace_events.h:45:16: note: expanded from macro 'TRACE_EVENT'
      40 |         DECLARE_EVENT_CLASS(name,                              \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      41 |                              PARAMS(proto),                    \
         |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      42 |                              PARAMS(args),                     \
         |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      43 |                              PARAMS(tstruct),                  \
         |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      44 |                              PARAMS(assign),                   \
         |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      45 |                              PARAMS(print));                   \
         |                              ~~~~~~~^~~~~~~
   include/linux/tracepoint.h:140:25: note: expanded from macro 'PARAMS'
     140 | #define PARAMS(args...) args
         |                         ^~~~
   include/trace/trace_events.h:219:27: note: expanded from macro 'DECLARE_EVENT_CLASS'
     219 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
>> arch/x86/kvm/x86.c:8897:25: error: incompatible function pointer types initializing 'int (*)(struct x86_emulate_ctxt *, unsigned long, void *, unsigned int, struct x86_exception *, bool)' (aka 'int (*)(struct x86_emulate_ctxt *, unsigned long, void *, unsigned int, struct x86_exception *, _Bool)') with an expression of type 'int (struct x86_emulate_ctxt *, gva_t, void *, unsigned int, struct x86_exception *, bool)' (aka 'int (struct x86_emulate_ctxt *, unsigned long long, void *, unsigned int, struct x86_exception *, _Bool)') [-Wincompatible-function-pointer-types]
    8897 |         .read_std            = emulator_read_std,
         |                                ^~~~~~~~~~~~~~~~~
   arch/x86/kvm/x86.c:8898:25: error: incompatible function pointer types initializing 'int (*)(struct x86_emulate_ctxt *, unsigned long, void *, unsigned int, struct x86_exception *, bool)' (aka 'int (*)(struct x86_emulate_ctxt *, unsigned long, void *, unsigned int, struct x86_exception *, _Bool)') with an expression of type 'int (struct x86_emulate_ctxt *, gva_t, void *, unsigned int, struct x86_exception *, bool)' (aka 'int (struct x86_emulate_ctxt *, unsigned long long, void *, unsigned int, struct x86_exception *, _Bool)') [-Wincompatible-function-pointer-types]
    8898 |         .write_std           = emulator_write_std,
         |                                ^~~~~~~~~~~~~~~~~~
>> arch/x86/kvm/x86.c:8899:25: error: incompatible function pointer types initializing 'int (*)(struct x86_emulate_ctxt *, unsigned long, void *, unsigned int, struct x86_exception *)' with an expression of type 'int (struct x86_emulate_ctxt *, gva_t, void *, unsigned int, struct x86_exception *)' (aka 'int (struct x86_emulate_ctxt *, unsigned long long, void *, unsigned int, struct x86_exception *)') [-Wincompatible-function-pointer-types]
    8899 |         .fetch               = kvm_fetch_guest_virt,
         |                                ^~~~~~~~~~~~~~~~~~~~
   1 warning and 3 errors generated.
--
>> arch/x86/kvm/vmx/vmx.c:574:15: warning: format specifies type 'unsigned long' but the argument has type 'gva_t' (aka 'unsigned long long') [-Wformat]
     573 |         vmx_insn_failed("invvpid failed: ext=0x%lx vpid=%u gva=0x%lx\n",
         |                                                                  ~~~
         |                                                                  %llx
     574 |                         ext, vpid, gva);
         |                                    ^~~
   arch/x86/kvm/vmx/vmx.c:532:22: note: expanded from macro 'vmx_insn_failed'
     532 |         pr_warn_ratelimited(fmt);       \
         |                             ^~~
   include/linux/printk.h:721:49: note: expanded from macro 'pr_warn_ratelimited'
     721 |         printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         |                                                ~~~     ^~~~~~~~~~~
   include/linux/printk.h:705:17: note: expanded from macro 'printk_ratelimited'
     705 |                 printk(fmt, ##__VA_ARGS__);                             \
         |                        ~~~    ^~~~~~~~~~~
   include/linux/printk.h:511:60: note: expanded from macro 'printk'
     511 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   include/linux/printk.h:483:19: note: expanded from macro 'printk_index_wrap'
     483 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
   1 warning generated.


vim +8897 arch/x86/kvm/x86.c

16ccadefa295af arch/x86/kvm/x86.c Maxim Levitsky      2024-09-06  8892  
0225fb509d51fc arch/x86/kvm/x86.c Mathias Krause      2012-08-30  8893  static const struct x86_emulate_ops emulate_ops = {
1cca2f8c501fa0 arch/x86/kvm/x86.c Sean Christopherson 2022-05-26  8894  	.vm_bugged           = emulator_vm_bugged,
dd856efafe6097 arch/x86/kvm/x86.c Avi Kivity          2012-08-27  8895  	.read_gpr            = emulator_read_gpr,
dd856efafe6097 arch/x86/kvm/x86.c Avi Kivity          2012-08-27  8896  	.write_gpr           = emulator_write_gpr,
ce14e868a54ede arch/x86/kvm/x86.c Paolo Bonzini       2018-06-06 @8897  	.read_std            = emulator_read_std,
ce14e868a54ede arch/x86/kvm/x86.c Paolo Bonzini       2018-06-06  8898  	.write_std           = emulator_write_std,
1871c6020d7308 arch/x86/kvm/x86.c Gleb Natapov        2010-02-10 @8899  	.fetch               = kvm_fetch_guest_virt,
bbd9b64e37aff5 drivers/kvm/x86.c  Carsten Otte        2007-10-30  8900  	.read_emulated       = emulator_read_emulated,
bbd9b64e37aff5 drivers/kvm/x86.c  Carsten Otte        2007-10-30  8901  	.write_emulated      = emulator_write_emulated,
bbd9b64e37aff5 drivers/kvm/x86.c  Carsten Otte        2007-10-30  8902  	.cmpxchg_emulated    = emulator_cmpxchg_emulated,
3cb16fe78ce919 arch/x86/kvm/x86.c Avi Kivity          2011-04-20  8903  	.invlpg              = emulator_invlpg,
cf8f70bfe38b32 arch/x86/kvm/x86.c Gleb Natapov        2010-03-18  8904  	.pio_in_emulated     = emulator_pio_in_emulated,
cf8f70bfe38b32 arch/x86/kvm/x86.c Gleb Natapov        2010-03-18  8905  	.pio_out_emulated    = emulator_pio_out_emulated,
1aa366163b8b69 arch/x86/kvm/x86.c Avi Kivity          2011-04-27  8906  	.get_segment         = emulator_get_segment,
1aa366163b8b69 arch/x86/kvm/x86.c Avi Kivity          2011-04-27  8907  	.set_segment         = emulator_set_segment,
5951c442372475 arch/x86/kvm/x86.c Gleb Natapov        2010-04-28  8908  	.get_cached_segment_base = emulator_get_cached_segment_base,
2dafc6c234b606 arch/x86/kvm/x86.c Gleb Natapov        2010-03-18  8909  	.get_gdt             = emulator_get_gdt,
160ce1f1a8fe64 arch/x86/kvm/x86.c Mohammed Gamal      2010-08-04  8910  	.get_idt	     = emulator_get_idt,
1ac9d0cfb07e8a arch/x86/kvm/x86.c Avi Kivity          2011-04-20  8911  	.set_gdt             = emulator_set_gdt,
1ac9d0cfb07e8a arch/x86/kvm/x86.c Avi Kivity          2011-04-20  8912  	.set_idt	     = emulator_set_idt,
52a4661737ecc9 arch/x86/kvm/x86.c Gleb Natapov        2010-03-18  8913  	.get_cr              = emulator_get_cr,
52a4661737ecc9 arch/x86/kvm/x86.c Gleb Natapov        2010-03-18  8914  	.set_cr              = emulator_set_cr,
9c5372445c1ad4 arch/x86/kvm/x86.c Gleb Natapov        2010-03-18  8915  	.cpl                 = emulator_get_cpl,
35aa5375d407ec arch/x86/kvm/x86.c Gleb Natapov        2010-04-28  8916  	.get_dr              = emulator_get_dr,
35aa5375d407ec arch/x86/kvm/x86.c Gleb Natapov        2010-04-28  8917  	.set_dr              = emulator_set_dr,
ac8d6cad3c7b39 arch/x86/kvm/x86.c Hou Wenlong         2022-03-07  8918  	.set_msr_with_filter = emulator_set_msr_with_filter,
ac8d6cad3c7b39 arch/x86/kvm/x86.c Hou Wenlong         2022-03-07  8919  	.get_msr_with_filter = emulator_get_msr_with_filter,
717746e382e58f arch/x86/kvm/x86.c Avi Kivity          2011-04-20  8920  	.get_msr             = emulator_get_msr,
7bb7fce13601d2 arch/x86/kvm/x86.c Sean Christopherson 2024-01-09  8921  	.check_rdpmc_early   = emulator_check_rdpmc_early,
222d21aa070a48 arch/x86/kvm/x86.c Avi Kivity          2011-11-10  8922  	.read_pmc            = emulator_read_pmc,
6c3287f7c50500 arch/x86/kvm/x86.c Avi Kivity          2011-04-20  8923  	.halt                = emulator_halt,
bcaf5cc543bdb8 arch/x86/kvm/x86.c Avi Kivity          2011-04-20  8924  	.wbinvd              = emulator_wbinvd,
d6aa10003b0cde arch/x86/kvm/x86.c Avi Kivity          2011-04-20  8925  	.fix_hypercall       = emulator_fix_hypercall,
c4f035c60dad45 arch/x86/kvm/x86.c Avi Kivity          2011-04-04  8926  	.intercept           = emulator_intercept,
bdb42f5afebe20 arch/x86/kvm/x86.c Stephan Bärwolf     2012-01-12  8927  	.get_cpuid           = emulator_get_cpuid,
5ae78e95ed0c77 arch/x86/kvm/x86.c Sean Christopherson 2019-12-17  8928  	.guest_has_movbe     = emulator_guest_has_movbe,
5ae78e95ed0c77 arch/x86/kvm/x86.c Sean Christopherson 2019-12-17  8929  	.guest_has_fxsr      = emulator_guest_has_fxsr,
a836839cbfe60d arch/x86/kvm/x86.c Hou Wenlong         2022-03-02  8930  	.guest_has_rdpid     = emulator_guest_has_rdpid,
d99e4cb2ae2e02 arch/x86/kvm/x86.c Sean Christopherson 2024-04-05  8931  	.guest_cpuid_is_intel_compatible = emulator_guest_cpuid_is_intel_compatible,
801806d956c2c1 arch/x86/kvm/x86.c Nadav Amit          2015-01-26  8932  	.set_nmi_mask        = emulator_set_nmi_mask,
32e69f232db4ca arch/x86/kvm/x86.c Maxim Levitsky      2022-11-29  8933  	.is_smm              = emulator_is_smm,
ecc513e5bb7ed5 arch/x86/kvm/x86.c Sean Christopherson 2021-06-09  8934  	.leave_smm           = emulator_leave_smm,
25b17226cd9a77 arch/x86/kvm/x86.c Sean Christopherson 2021-06-09  8935  	.triple_fault        = emulator_triple_fault,
f106797f81d633 arch/x86/kvm/x86.c Paolo Bonzini       2025-11-13  8936  	.get_xcr             = emulator_get_xcr,
02d4160fbd7651 arch/x86/kvm/x86.c Vitaly Kuznetsov    2019-08-13  8937  	.set_xcr             = emulator_set_xcr,
37a41847b770c7 arch/x86/kvm/x86.c Binbin Wu           2023-09-13  8938  	.get_untagged_addr   = emulator_get_untagged_addr,
16ccadefa295af arch/x86/kvm/x86.c Maxim Levitsky      2024-09-06  8939  	.is_canonical_addr   = emulator_is_canonical_addr,
bbd9b64e37aff5 drivers/kvm/x86.c  Carsten Otte        2007-10-30  8940  };
bbd9b64e37aff5 drivers/kvm/x86.c  Carsten Otte        2007-10-30  8941  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

