Return-Path: <kvm+bounces-68930-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UHuCFoBzcmlpkwAAu9opvQ
	(envelope-from <kvm+bounces-68930-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 19:59:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AA8FF6CCF9
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 19:59:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8F750301982C
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B39C385EFB;
	Thu, 22 Jan 2026 18:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sxm2CVDY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1FC33DEE6;
	Thu, 22 Jan 2026 18:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769108213; cv=none; b=K5dQfSboUUq+VSpQrov9GA8Vq82noEERDUpOwWIbiHpj3I0ZhCAC3dNDcN5YmUvApObJXnm4fL1pxmNqKal0xCoUz0R8+y05Ps3XklicxfSGhCSUtqW6IUlxO+mFKP5s5kJt/7Xa7Y0IAHF+5Ow0wbWBYu4UaSKGLYYjXAPRxzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769108213; c=relaxed/simple;
	bh=s9DV0fxK8SmxbYf4WTMRxmUXLu7ztaxzdtZ5Zd3tsO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bWo3jOeL5eSOe+/4cjYssbwecwC41o3seqVFKyS5lHl39LUwlEXE1s0BbbxUSjGQjirKPMVIfG6IQu08DEBdMamau15SODIQyoY9fpn0RH+g1JM3ewFHUJGXfGAZQrpiGwEv265lAAozLY8oxF4ftdQ2cW6vlF1j+wBf2IH1gLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sxm2CVDY; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769108210; x=1800644210;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=s9DV0fxK8SmxbYf4WTMRxmUXLu7ztaxzdtZ5Zd3tsO8=;
  b=Sxm2CVDY9zH0aKO9NUgVQlSaQqycIuMEmsSe173h/ZWXPKB9+G7c/Cjh
   d+P4gWiEMy2A08EbrqURQCDgkH6oktiTM+eb38JPT/GUG+1Gt1w7zOEZ8
   O1MwLXkcuQAX4l5QRS3fGuXoMoCPXiwY59YAP3vou3eof8VsDAYeO1oXT
   jdDal9uh/HMvOiiheMak8rPf2gcXR4Pu+ojj4Z54pP4SWZiVgoG76Wr3N
   G7eckQmLTvTgeofaMsZikJGXtgoKZBnNr9RcMlhgLzAqSRfVxnjdz65oI
   cTVrFPTpxwoi9NoG2rrDCFyGQIwJJ4k6iuun4Hqr7515qgswsg3MnWMyI
   w==;
X-CSE-ConnectionGUID: kjFSrIUsTVuwAPzHTuBBfA==
X-CSE-MsgGUID: fx0+KnNHSfmPnLVv4q1FGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="69378368"
X-IronPort-AV: E=Sophos;i="6.21,246,1763452800"; 
   d="scan'208";a="69378368"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 10:56:42 -0800
X-CSE-ConnectionGUID: 3KI3GOT8Q2yCPMC5jIMy/g==
X-CSE-MsgGUID: IWxaT4EqRZSpavITKQlmgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,246,1763452800"; 
   d="scan'208";a="206860158"
Received: from igk-lkp-server01.igk.intel.com (HELO afc5bfd7f602) ([10.211.93.152])
  by orviesa007.jf.intel.com with ESMTP; 22 Jan 2026 10:56:37 -0800
Received: from kbuild by afc5bfd7f602 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vizr8-000000000Xl-43w1;
	Thu, 22 Jan 2026 18:56:34 +0000
Date: Thu, 22 Jan 2026 19:56:21 +0100
From: kernel test robot <lkp@intel.com>
To: Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Shuah Khan <skhan@linuxfoundation.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 6/6] KVM: selftests: x86: Add svm_pmu_hg_test for HG_ONLY
 bits
Message-ID: <202601221906.D038BKHz-lkp@intel.com>
References: <20260121225438.3908422-7-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121225438.3908422-7-jmattson@google.com>
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
	TAGGED_FROM(0.00)[bounces-68930-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.998];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,git-scm.com:url]
X-Rspamd-Queue-Id: AA8FF6CCF9
X-Rspamd-Action: no action

Hi Jim,

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20260121]
[cannot apply to kvm/queue kvm/next perf-tools-next/perf-tools-next tip/perf/core perf-tools/perf-tools kvm/linux-next acme/perf/core v6.19-rc6 v6.19-rc5 v6.19-rc4 linus/master v6.19-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jim-Mattson/KVM-x86-pmu-Introduce-amd_pmu_set_eventsel_hw/20260122-070031
base:   next-20260121
patch link:    https://lore.kernel.org/r/20260121225438.3908422-7-jmattson%40google.com
patch subject: [PATCH 6/6] KVM: selftests: x86: Add svm_pmu_hg_test for HG_ONLY bits
config: x86_64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260122/202601221906.D038BKHz-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601221906.D038BKHz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601221906.D038BKHz-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> x86/svm_pmu_hg_test.c:37:9: warning: "MSR_F15H_PERF_CTL0" redefined
      37 | #define MSR_F15H_PERF_CTL0      0xc0010200
         |         ^~~~~~~~~~~~~~~~~~
   In file included from include/x86/processor.h:13,
                    from x86/svm_pmu_hg_test.c:31:
   tools/testing/selftests/../../../tools/arch/x86/include/asm/msr-index.h:815:9: note: this is the location of the previous definition
     815 | #define MSR_F15H_PERF_CTL0              MSR_F15H_PERF_CTL
         |         ^~~~~~~~~~~~~~~~~~
>> x86/svm_pmu_hg_test.c:38:9: warning: "MSR_F15H_PERF_CTR0" redefined
      38 | #define MSR_F15H_PERF_CTR0      0xc0010201
         |         ^~~~~~~~~~~~~~~~~~
   tools/testing/selftests/../../../tools/arch/x86/include/asm/msr-index.h:823:9: note: this is the location of the previous definition
     823 | #define MSR_F15H_PERF_CTR0              MSR_F15H_PERF_CTR
         |         ^~~~~~~~~~~~~~~~~~
   cc1: note: unrecognized command-line option '-Wno-gnu-variable-sized-type-not-at-end' may have been intended to silence earlier diagnostics

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

