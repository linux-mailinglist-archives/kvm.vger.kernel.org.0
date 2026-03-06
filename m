Return-Path: <kvm+bounces-73016-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IJejCdGsqmlTVQEAu9opvQ
	(envelope-from <kvm+bounces-73016-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 11:30:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D0B921EBE9
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 11:30:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BE5BC309AA4F
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 10:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A93EA37C101;
	Fri,  6 Mar 2026 10:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g+Y24qxd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4288E37BE77;
	Fri,  6 Mar 2026 10:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772792820; cv=none; b=Ped25AAXBPdzpo4KEp4qRP+DSXM7T0fbJOPBFfj5KgcxsuxyuPl664YgdfKQO89I/Ezne7e2V5izZaHgWGYCWs4bgL+2eUKZLGzN4Wd0ScM0nPktKRyBCT9tCvXFb8d+s6x5yxeUcr/IRQt96/K9PT+ypMJhN4V7FnmKcFCBfuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772792820; c=relaxed/simple;
	bh=Oa5GSxVRAyX/+Nw+3DZDviZU2/d1tK6RTc8Kr9xrYmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hsns3ALe2JROTzGm4HUxrs00pqiyXpLMSaCm2RlQTuzS/dlLqYxtPOMPvH63SfcUYh0j5afgrPkqLrjx6aEYdiKLgU6pnk6YV0rni21PzWTcUpE2TccCXaFmSk3kiKclDaORyBH1nDEnj0NhuM0yZDPl2YoybRT+CTaYDAcL94E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g+Y24qxd; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772792818; x=1804328818;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Oa5GSxVRAyX/+Nw+3DZDviZU2/d1tK6RTc8Kr9xrYmk=;
  b=g+Y24qxdQMrCPKzyL9lU1hazRqRBohJoajy9cdsBcILbZMkjAn34Qg4r
   m2LihO2KmLGuBhsV1PadHxZzeP9/d2G3+u5jAcVct8K5KE3wvTaQ39NzM
   n/S6YTZ4onWLq1rJDAEReMWgrGEw09nywHgXi8Mp1psBh+1h4peA6NUFc
   UiK/FeghzOH70WYUYQyVqjUMyNFWoOHm7pKJ7QzzDxb9f79AgttZ7WR8I
   wlWGFg6FakUvGymeCaSU5X/PGM+xIeUcAWiLLmmJYgnHuw3cjE6HuK0z8
   5Uo8gIBIl3q7DCFaS/4LdrVNPYLvS8RZ42oKb1o5eiskLW3FJWZRP0bia
   Q==;
X-CSE-ConnectionGUID: nz/yXLNQQD+Wh4yDawo8bA==
X-CSE-MsgGUID: 3nO+oNaETuqd7h2YaUZ8Xw==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77500104"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="77500104"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 02:26:58 -0800
X-CSE-ConnectionGUID: HE6/6FuVTgexjlkjffmvtA==
X-CSE-MsgGUID: 0IRGHa0bRSqkMF2IuFKrQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="221789006"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by fmviesa004.fm.intel.com with ESMTP; 06 Mar 2026 02:26:56 -0800
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vySOT-000000002Eb-3FCn;
	Fri, 06 Mar 2026 10:26:53 +0000
Date: Fri, 6 Mar 2026 11:26:27 +0100
From: kernel test robot <lkp@intel.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: Change [g|h]va_t as u64
Message-ID: <202603061115.VQTqyi2i-lkp@intel.com>
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
X-Rspamd-Queue-Id: 7D0B921EBE9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73016-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Action: no action

Hi Anshuman,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on kvm/next linus/master v7.0-rc2 next-20260305]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Anshuman-Khandual/KVM-Change-g-h-va_t-as-u64/20260306-123029
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20260306041125.45643-1-anshuman.khandual%40arm.com
patch subject: [PATCH] KVM: Change [g|h]va_t as u64
config: x86_64-rhel-9.4-ltp (https://download.01.org/0day-ci/archive/20260306/202603061115.VQTqyi2i-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260306/202603061115.VQTqyi2i-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603061115.VQTqyi2i-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from include/trace/define_trace.h:132,
                    from arch/x86/kvm/trace.h:1976,
                    from arch/x86/kvm/x86.c:89:
   include/trace/../../arch/x86/kvm/trace.h: In function 'trace_raw_output_vcpu_match_mmio':
>> include/trace/../../arch/x86/kvm/trace.h:973:19: warning: format '%lx' expects argument of type 'long unsigned int', but argument 3 has type 'gva_t' {aka 'long long unsigned int'} [-Wformat=]
     973 |         TP_printk("gva %#lx gpa %#llx %s %s", __entry->gva, __entry->gpa,
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:219:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     219 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   include/trace/../../arch/x86/kvm/trace.h:954:1: note: in expansion of macro 'TRACE_EVENT'
     954 | TRACE_EVENT(
         | ^~~~~~~~~~~
   include/trace/../../arch/x86/kvm/trace.h:973:9: note: in expansion of macro 'TP_printk'
     973 |         TP_printk("gva %#lx gpa %#llx %s %s", __entry->gva, __entry->gpa,
         |         ^~~~~~~~~
   In file included from include/trace/trace_events.h:256:
   include/trace/../../arch/x86/kvm/trace.h:973:27: note: format string is defined here
     973 |         TP_printk("gva %#lx gpa %#llx %s %s", __entry->gva, __entry->gpa,
         |                        ~~~^
         |                           |
         |                           long unsigned int
         |                        %#llx
   arch/x86/kvm/x86.c: At top level:
>> arch/x86/kvm/x86.c:8897:32: error: initialization of 'int (*)(struct x86_emulate_ctxt *, long unsigned int,  void *, unsigned int,  struct x86_exception *, bool)' {aka 'int (*)(struct x86_emulate_ctxt *, long unsigned int,  void *, unsigned int,  struct x86_exception *, _Bool)'} from incompatible pointer type 'int (*)(struct x86_emulate_ctxt *, gva_t,  void *, unsigned int,  struct x86_exception *, bool)' {aka 'int (*)(struct x86_emulate_ctxt *, long long unsigned int,  void *, unsigned int,  struct x86_exception *, _Bool)'} [-Wincompatible-pointer-types]
    8897 |         .read_std            = emulator_read_std,
         |                                ^~~~~~~~~~~~~~~~~
   arch/x86/kvm/x86.c:8897:32: note: (near initialization for 'emulate_ops.read_std')
   arch/x86/kvm/x86.c:8898:32: error: initialization of 'int (*)(struct x86_emulate_ctxt *, long unsigned int,  void *, unsigned int,  struct x86_exception *, bool)' {aka 'int (*)(struct x86_emulate_ctxt *, long unsigned int,  void *, unsigned int,  struct x86_exception *, _Bool)'} from incompatible pointer type 'int (*)(struct x86_emulate_ctxt *, gva_t,  void *, unsigned int,  struct x86_exception *, bool)' {aka 'int (*)(struct x86_emulate_ctxt *, long long unsigned int,  void *, unsigned int,  struct x86_exception *, _Bool)'} [-Wincompatible-pointer-types]
    8898 |         .write_std           = emulator_write_std,
         |                                ^~~~~~~~~~~~~~~~~~
   arch/x86/kvm/x86.c:8898:32: note: (near initialization for 'emulate_ops.write_std')
>> arch/x86/kvm/x86.c:8899:32: error: initialization of 'int (*)(struct x86_emulate_ctxt *, long unsigned int,  void *, unsigned int,  struct x86_exception *)' from incompatible pointer type 'int (*)(struct x86_emulate_ctxt *, gva_t,  void *, unsigned int,  struct x86_exception *)' {aka 'int (*)(struct x86_emulate_ctxt *, long long unsigned int,  void *, unsigned int,  struct x86_exception *)'} [-Wincompatible-pointer-types]
    8899 |         .fetch               = kvm_fetch_guest_virt,
         |                                ^~~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/x86.c:8899:32: note: (near initialization for 'emulate_ops.fetch')
--
   In file included from include/asm-generic/bug.h:31,
                    from arch/x86/include/asm/bug.h:193,
                    from arch/x86/include/asm/alternative.h:9,
                    from arch/x86/include/asm/segment.h:6,
                    from arch/x86/include/asm/ptrace.h:5,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:13,
                    from arch/x86/include/asm/timex.h:5,
                    from include/linux/timex.h:67,
                    from include/linux/time32.h:13,
                    from include/linux/time.h:60,
                    from include/linux/stat.h:19,
                    from include/linux/fs_dirent.h:5,
                    from include/linux/fs/super_types.h:5,
                    from include/linux/fs/super.h:5,
                    from include/linux/fs.h:5,
                    from include/linux/highmem.h:5,
                    from arch/x86/kvm/vmx/vmx.c:17:
   arch/x86/kvm/vmx/vmx.c: In function 'invvpid_error':
>> include/linux/kern_levels.h:5:25: warning: format '%lx' expects argument of type 'long unsigned int', but argument 4 has type 'gva_t' {aka 'long long unsigned int'} [-Wformat=]
       5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
         |                         ^~~~~~
   include/linux/printk.h:483:25: note: in definition of macro 'printk_index_wrap'
     483 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ^~~~
   include/linux/printk.h:705:17: note: in expansion of macro 'printk'
     705 |                 printk(fmt, ##__VA_ARGS__);                             \
         |                 ^~~~~~
   include/linux/printk.h:721:9: note: in expansion of macro 'printk_ratelimited'
     721 |         printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/kern_levels.h:12:25: note: in expansion of macro 'KERN_SOH'
      12 | #define KERN_WARNING    KERN_SOH "4"    /* warning conditions */
         |                         ^~~~~~~~
   include/linux/printk.h:721:28: note: in expansion of macro 'KERN_WARNING'
     721 |         printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         |                            ^~~~~~~~~~~~
   arch/x86/kvm/vmx/vmx.c:532:9: note: in expansion of macro 'pr_warn_ratelimited'
     532 |         pr_warn_ratelimited(fmt);       \
         |         ^~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/vmx/vmx.c:573:9: note: in expansion of macro 'vmx_insn_failed'
     573 |         vmx_insn_failed("invvpid failed: ext=0x%lx vpid=%u gva=0x%lx\n",
         |         ^~~~~~~~~~~~~~~
--
   In file included from include/trace/define_trace.h:132,
                    from kvm/trace.h:1976,
                    from kvm/x86.c:89:
   include/trace/../../arch/x86/kvm/trace.h: In function 'trace_raw_output_vcpu_match_mmio':
>> include/trace/../../arch/x86/kvm/trace.h:973:19: warning: format '%lx' expects argument of type 'long unsigned int', but argument 3 has type 'gva_t' {aka 'long long unsigned int'} [-Wformat=]
     973 |         TP_printk("gva %#lx gpa %#llx %s %s", __entry->gva, __entry->gpa,
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:219:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     219 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   include/trace/../../arch/x86/kvm/trace.h:954:1: note: in expansion of macro 'TRACE_EVENT'
     954 | TRACE_EVENT(
         | ^~~~~~~~~~~
   include/trace/../../arch/x86/kvm/trace.h:973:9: note: in expansion of macro 'TP_printk'
     973 |         TP_printk("gva %#lx gpa %#llx %s %s", __entry->gva, __entry->gpa,
         |         ^~~~~~~~~
   In file included from include/trace/trace_events.h:256:
   include/trace/../../arch/x86/kvm/trace.h:973:27: note: format string is defined here
     973 |         TP_printk("gva %#lx gpa %#llx %s %s", __entry->gva, __entry->gpa,
         |                        ~~~^
         |                           |
         |                           long unsigned int
         |                        %#llx
   kvm/x86.c: At top level:
   kvm/x86.c:8897:32: error: initialization of 'int (*)(struct x86_emulate_ctxt *, long unsigned int,  void *, unsigned int,  struct x86_exception *, bool)' {aka 'int (*)(struct x86_emulate_ctxt *, long unsigned int,  void *, unsigned int,  struct x86_exception *, _Bool)'} from incompatible pointer type 'int (*)(struct x86_emulate_ctxt *, gva_t,  void *, unsigned int,  struct x86_exception *, bool)' {aka 'int (*)(struct x86_emulate_ctxt *, long long unsigned int,  void *, unsigned int,  struct x86_exception *, _Bool)'} [-Wincompatible-pointer-types]
    8897 |         .read_std            = emulator_read_std,
         |                                ^~~~~~~~~~~~~~~~~
   kvm/x86.c:8897:32: note: (near initialization for 'emulate_ops.read_std')
   kvm/x86.c:8898:32: error: initialization of 'int (*)(struct x86_emulate_ctxt *, long unsigned int,  void *, unsigned int,  struct x86_exception *, bool)' {aka 'int (*)(struct x86_emulate_ctxt *, long unsigned int,  void *, unsigned int,  struct x86_exception *, _Bool)'} from incompatible pointer type 'int (*)(struct x86_emulate_ctxt *, gva_t,  void *, unsigned int,  struct x86_exception *, bool)' {aka 'int (*)(struct x86_emulate_ctxt *, long long unsigned int,  void *, unsigned int,  struct x86_exception *, _Bool)'} [-Wincompatible-pointer-types]
    8898 |         .write_std           = emulator_write_std,
         |                                ^~~~~~~~~~~~~~~~~~
   kvm/x86.c:8898:32: note: (near initialization for 'emulate_ops.write_std')
   kvm/x86.c:8899:32: error: initialization of 'int (*)(struct x86_emulate_ctxt *, long unsigned int,  void *, unsigned int,  struct x86_exception *)' from incompatible pointer type 'int (*)(struct x86_emulate_ctxt *, gva_t,  void *, unsigned int,  struct x86_exception *)' {aka 'int (*)(struct x86_emulate_ctxt *, long long unsigned int,  void *, unsigned int,  struct x86_exception *)'} [-Wincompatible-pointer-types]
    8899 |         .fetch               = kvm_fetch_guest_virt,
         |                                ^~~~~~~~~~~~~~~~~~~~
   kvm/x86.c:8899:32: note: (near initialization for 'emulate_ops.fetch')
--
   In file included from include/asm-generic/bug.h:31,
                    from arch/x86/include/asm/bug.h:193,
                    from arch/x86/include/asm/alternative.h:9,
                    from arch/x86/include/asm/segment.h:6,
                    from arch/x86/include/asm/ptrace.h:5,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:13,
                    from arch/x86/include/asm/timex.h:5,
                    from include/linux/timex.h:67,
                    from include/linux/time32.h:13,
                    from include/linux/time.h:60,
                    from include/linux/stat.h:19,
                    from include/linux/fs_dirent.h:5,
                    from include/linux/fs/super_types.h:5,
                    from include/linux/fs/super.h:5,
                    from include/linux/fs.h:5,
                    from include/linux/highmem.h:5,
                    from kvm/vmx/vmx.c:17:
   kvm/vmx/vmx.c: In function 'invvpid_error':
>> include/linux/kern_levels.h:5:25: warning: format '%lx' expects argument of type 'long unsigned int', but argument 4 has type 'gva_t' {aka 'long long unsigned int'} [-Wformat=]
       5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
         |                         ^~~~~~
   include/linux/printk.h:483:25: note: in definition of macro 'printk_index_wrap'
     483 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ^~~~
   include/linux/printk.h:705:17: note: in expansion of macro 'printk'
     705 |                 printk(fmt, ##__VA_ARGS__);                             \
         |                 ^~~~~~
   include/linux/printk.h:721:9: note: in expansion of macro 'printk_ratelimited'
     721 |         printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/kern_levels.h:12:25: note: in expansion of macro 'KERN_SOH'
      12 | #define KERN_WARNING    KERN_SOH "4"    /* warning conditions */
         |                         ^~~~~~~~
   include/linux/printk.h:721:28: note: in expansion of macro 'KERN_WARNING'
     721 |         printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         |                            ^~~~~~~~~~~~
   kvm/vmx/vmx.c:532:9: note: in expansion of macro 'pr_warn_ratelimited'
     532 |         pr_warn_ratelimited(fmt);       \
         |         ^~~~~~~~~~~~~~~~~~~
   kvm/vmx/vmx.c:573:9: note: in expansion of macro 'vmx_insn_failed'
     573 |         vmx_insn_failed("invvpid failed: ext=0x%lx vpid=%u gva=0x%lx\n",
         |         ^~~~~~~~~~~~~~~


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

