Return-Path: <kvm+bounces-73026-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IF3aOV63qml9VgEAu9opvQ
	(envelope-from <kvm+bounces-73026-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 12:15:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6662621F85E
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 12:15:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 646CB3052461
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 11:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4943C37CD25;
	Fri,  6 Mar 2026 11:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O72LTDaP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E2530AAA6;
	Fri,  6 Mar 2026 11:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772795738; cv=none; b=TGcqHDhuGxd1rV3oMMbhPECXVURr6UU/+KieuQewis7Qgoo5JkCGtyc49Nt5PqSbcVSGAWlYlXLONF/Y3uDsomfETdWbwsAkVdlnFLBXaSK4BzkwwCjxq8Df5B7AFTkA4SX6G7IILEEC5yGTpLq33nVRSral7jBUwtozQbYiFUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772795738; c=relaxed/simple;
	bh=r+sBfl8MVNdlEtjLkNN7nCo9AmJOK7rOmh1ZaxZm4ko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gr+aDle0cs8hzmSCSeo4lQk8wlG6bcjoZuiF4N+EKoCoO/DuIwQ6hblMnyipmKIylUfxOgj9PpYHUWO6jPcRGlKZGeLGacwSjoah3l84sgeKF48wQh9GrRPkIjxbgQOEOwWwjYN0BEr7Hfl5tnifnjGgZuXQufBQnST3C4Z0Fzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O72LTDaP; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772795736; x=1804331736;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r+sBfl8MVNdlEtjLkNN7nCo9AmJOK7rOmh1ZaxZm4ko=;
  b=O72LTDaPKPVzWeygkn288KG5EsnpoRuYZ8D9+JdEi+PWsJFe9Mcd0ALo
   0jho6ad2sdOXzSvXaviE6ApMd4QXLrsp/uWDh/rz9p3YB1rRF8uyNTTOb
   PEMUMv1dvq4GhMOBNRHCgOa3OrN/PG8vD8MFC+4TszOvl644PExpr9y5h
   Ie3ZbfrAgwH+RZ/3xgyZVWZLh63AJRwQ3KU4bRiItmFinYH6vvyMQAPAK
   u1vZkn/fpYfdouQnjc4Bp5WVG/TWDXn7eHOW3zwlGju3R4pcPfKcp52+0
   rKRC5E3Z5SnuodwqO/KfXindIMU2PgxjvNsnuqcaa6JXi89HMs/WJ578R
   Q==;
X-CSE-ConnectionGUID: nOngfxhUS9CBIX342jGkFQ==
X-CSE-MsgGUID: yhxPIQwnTQqi6I0nJKUoJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="74090128"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="74090128"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 03:15:36 -0800
X-CSE-ConnectionGUID: beXCk4NAQqmL2jRNrWvjfQ==
X-CSE-MsgGUID: e3O5Vsx1TwSP/RqBQ+F2dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="216754406"
Received: from lkp-server01.sh.intel.com (HELO 058beb05654c) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 06 Mar 2026 03:15:33 -0800
Received: from kbuild by 058beb05654c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vyT9W-000000000mP-0nWe;
	Fri, 06 Mar 2026 11:15:30 +0000
Date: Fri, 6 Mar 2026 19:14:54 +0800
From: kernel test robot <lkp@intel.com>
To: isaku.yamahata@intel.com, kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 16/36] KVM: nVMX: Enable guest deadline and its shadow
 VMCS field
Message-ID: <202603061942.wdSsERnL-lkp@intel.com>
References: <e9d6845e7727f297bd702f5a05c8006f88fc7e8f.1772732517.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9d6845e7727f297bd702f5a05c8006f88fc7e8f.1772732517.git.isaku.yamahata@intel.com>
X-Rspamd-Queue-Id: 6662621F85E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-73026-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[lists.linux.dev,intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 5128b972fb2801ad9aca54d990a75611ab5283a9]

url:    https://github.com/intel-lab-lkp/linux/commits/isaku-yamahata-intel-com/KVM-VMX-Detect-APIC-timer-virtualization-bit/20260306-020026
base:   5128b972fb2801ad9aca54d990a75611ab5283a9
patch link:    https://lore.kernel.org/r/e9d6845e7727f297bd702f5a05c8006f88fc7e8f.1772732517.git.isaku.yamahata%40intel.com
patch subject: [PATCH v2 16/36] KVM: nVMX: Enable guest deadline and its shadow VMCS field
config: i386-randconfig-061-20260306 (https://download.01.org/0day-ci/archive/20260306/202603061942.wdSsERnL-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260306/202603061942.wdSsERnL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603061942.wdSsERnL-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   arch/x86/kvm/vmx/nested.c: note: in included file (through arch/x86/kvm/vmx/vmx_onhyperv.h, arch/x86/kvm/vmx/vmx_ops.h, arch/x86/kvm/vmx/vmx.h, ...):
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100790 becomes 790)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a000a becomes a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (190019 becomes 19)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (190019 becomes 19)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110311 becomes 311)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80a88 becomes a88)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80608 becomes 608)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80108 becomes 108)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80388 becomes 388)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20482 becomes 482)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80b88 becomes b88)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100910 becomes 910)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80188 becomes 188)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80208 becomes 208)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80288 becomes 288)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a000a becomes a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100010 becomes 10)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100710 becomes 710)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100090 becomes 90)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20402 becomes 402)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80b88 becomes b88)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100790 becomes 790)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80d08 becomes d08)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100490 becomes 490)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100310 becomes 310)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100590 becomes 590)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100610 becomes 610)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100690 becomes 690)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120912 becomes 912)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100590 becomes 590)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a0a1a becomes a1a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a0a9a becomes a9a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a0b1a becomes b1a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a0a1a becomes a1a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a0a9a becomes a9a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a0b1a becomes b1a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20002 becomes 2)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20082 becomes 82)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20102 becomes 102)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20182 becomes 182)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20202 becomes 202)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20282 becomes 282)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20302 becomes 302)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20382 becomes 382)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120012 becomes 12)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120092 becomes 92)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120112 becomes 112)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120192 becomes 192)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120212 becomes 212)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120292 becomes 292)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120312 becomes 312)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120392 becomes 392)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120412 becomes 412)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120492 becomes 492)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120592 becomes 592)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120612 becomes 612)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120512 becomes 512)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120692 becomes 692)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120712 becomes 712)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120792 becomes 792)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120812 becomes 812)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120892 becomes 892)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a019a becomes 19a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a021a becomes 21a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a029a becomes 29a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a031a becomes 31a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a039a becomes 39a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a041a becomes 41a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a049a becomes 49a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a051a becomes 51a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a059a becomes 59a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a061a becomes 61a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120a92 becomes a92)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a089a becomes 89a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a091a becomes 91a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a099a becomes 99a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a028a becomes 28a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a030a becomes 30a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a038a becomes 38a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a040a becomes 40a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a048a becomes 48a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80b08 becomes b08)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100190 becomes 190)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100210 becomes 210)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100190 becomes 190)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100210 becomes 210)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80708 becomes 708)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80788 becomes 788)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80808 becomes 808)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80888 becomes 888)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100390 becomes 390)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100390 becomes 390)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100410 becomes 410)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100510 becomes 510)
>> arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a0c0a becomes c0a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (81388 becomes 1388)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a008a becomes 8a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a008a becomes 8a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a048a becomes 48a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (180018 becomes 18)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a010a becomes 10a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a010a becomes 10a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80408 becomes 408)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80c88 becomes c88)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (180118 becomes 118)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (180198 becomes 198)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a009a becomes 9a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a028a becomes 28a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a030a becomes 30a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a038a becomes 38a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a040a becomes 40a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80508 becomes 508)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80488 becomes 488)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100090 becomes 90)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80488 becomes 488)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80588 becomes 588)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100010 becomes 10)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100090 becomes 90)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100090 becomes 90)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a008a becomes 8a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a048a becomes 48a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a009a becomes 9a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20402 becomes 402)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20402 becomes 402)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110311 becomes 311)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a089a becomes 89a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20402 becomes 402)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110311 becomes 311)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110311 becomes 311)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110311 becomes 311)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110311 becomes 311)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110311 becomes 311)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110311 becomes 311)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110311 becomes 311)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110311 becomes 311)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20002 becomes 2)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20082 becomes 82)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20102 becomes 102)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20182 becomes 182)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20202 becomes 202)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20282 becomes 282)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20302 becomes 302)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20382 becomes 382)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120012 becomes 12)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120092 becomes 92)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120112 becomes 112)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120192 becomes 192)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120212 becomes 212)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120292 becomes 292)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120312 becomes 312)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120392 becomes 392)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120412 becomes 412)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120492 becomes 492)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120512 becomes 512)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120692 becomes 692)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120712 becomes 712)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120792 becomes 792)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120812 becomes 812)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120892 becomes 892)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a019a becomes 19a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a021a becomes 21a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a029a becomes 29a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a031a becomes 31a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a039a becomes 39a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a041a becomes 41a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a049a becomes 49a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a051a becomes 51a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a059a becomes 59a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a061a becomes 61a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a089a becomes 89a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (81388 becomes 1388)
>> arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a0c0a becomes c0a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a001a becomes 1a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (180118 becomes 118)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a011a becomes 11a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (180198 becomes 198)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a081a becomes 81a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120592 becomes 592)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120612 becomes 612)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120912 becomes 912)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a009a becomes 9a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a028a becomes 28a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a030a becomes 30a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a038a becomes 38a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a040a becomes 40a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (190299 becomes 299)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (20402 becomes 402)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110391 becomes 391)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (180098 becomes 98)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120a92 becomes a92)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a091a becomes 91a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a099a becomes 99a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a061a becomes 61a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a059a becomes 59a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120492 becomes 492)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (120412 becomes 412)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a048a becomes 48a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a010a becomes 10a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a008a becomes 8a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a010a becomes 10a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a069a becomes 69a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a008a becomes 8a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a008a becomes 8a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a018a becomes 18a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (180118 becomes 118)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (180098 becomes 98)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (180198 becomes 198)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (1a009a becomes 9a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110011 becomes 11)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100390 becomes 390)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100410 becomes 410)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100510 becomes 510)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80408 becomes 408)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80c88 becomes c88)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110311 becomes 311)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (190019 becomes 19)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110391 becomes 391)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (190019 becomes 19)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110391 becomes 391)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (190019 becomes 19)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110391 becomes 391)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (100790 becomes 790)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (a000a becomes a)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (190019 becomes 19)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110391 becomes 391)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110391 becomes 391)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (190019 becomes 19)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110391 becomes 391)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (190019 becomes 19)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110111 becomes 111)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (190019 becomes 19)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110311 becomes 311)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (190019 becomes 19)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (190019 becomes 19)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (190019 becomes 19)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110391 becomes 391)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110111 becomes 111)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110111 becomes 111)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110011 becomes 11)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110111 becomes 111)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110191 becomes 191)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (190019 becomes 19)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110311 becomes 311)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (110311 becomes 311)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80988 becomes 988)
   arch/x86/kvm/vmx/hyperv_evmcs.h:133:30: sparse: sparse: cast truncates bits from constant value (80a08 becomes a08)

vim +133 arch/x86/kvm/vmx/hyperv_evmcs.h

e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  128  
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  129  static __always_inline int evmcs_field_offset(unsigned long field,
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  130  					      u16 *clean_field)
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  131  {
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  132  	const struct evmcs_field *evmcs_field;
c68feb605cc4743 Sean Christopherson 2026-01-15 @133  	unsigned int index = ENC_TO_VMCS12_IDX(field);
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  134  
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  135  	if (unlikely(index >= nr_evmcs_1_fields))
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  136  		return -ENOENT;
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  137  
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  138  	evmcs_field = &vmcs_field_to_evmcs_1[index];
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  139  
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  140  	/*
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  141  	 * Use offset=0 to detect holes in eVMCS. This offset belongs to
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  142  	 * 'revision_id' but this field has no encoding and is supposed to
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  143  	 * be accessed directly.
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  144  	 */
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  145  	if (unlikely(!evmcs_field->offset))
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  146  		return -ENOENT;
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  147  
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  148  	if (clean_field)
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  149  		*clean_field = evmcs_field->clean_field;
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  150  
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  151  	return evmcs_field->offset;
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  152  }
e7ad84db4d718e1 Vitaly Kuznetsov    2023-12-05  153  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

