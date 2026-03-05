Return-Path: <kvm+bounces-72804-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0C6uFnVRqWkj4wAAu9opvQ
	(envelope-from <kvm+bounces-72804-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 10:48:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B491B20EE86
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 10:48:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2221431861B4
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 09:41:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 611AF37BE70;
	Thu,  5 Mar 2026 09:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lWvd8qkQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E6231E823
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 09:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772703650; cv=none; b=bssy5OjuN9Z4Aes5EviAUzixJHsbl4Ea5r7rVQQWJSezBf9EApgEOdGvqi64yS7W9CMqMuuTkmyrFJst4AA2OZ/Fzzc89d6SXjM6pIJtmYXa6PAXGw+VcA83ckGi3DV8lrD0+VoQOmX7UMeayPef7f91TmMpVsKpsoXfDFJ/054=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772703650; c=relaxed/simple;
	bh=LvMtC5Es2zdP2uSfy78WiJ9eCMEa+XDyOii1X1gzxqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=beIkek1GnYnMLvxIdIsrJBb06ZlexipMhm6RPfnBxNr17eovr0AQsFWCumdgx5N1zPKFfYKQHGGG1NX3kCA6kacsNNcnOIhVuD12FptI0F9c03Uh2j2VokgpWjMmLbos/n+2PiR0IdVCidkmOmA68gv1Me4WvV0BjpmdzEuu92c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lWvd8qkQ; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772703648; x=1804239648;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LvMtC5Es2zdP2uSfy78WiJ9eCMEa+XDyOii1X1gzxqg=;
  b=lWvd8qkQfvO2jhsxPo9fyHmnpB0zPVhaN295+jhOYpawvRnReaVRWqtb
   znHWKImioLbdU2tZhdx/DGmmnk4qj5Zyru8Jgdqi/Sr6YmuHJddNY+ivA
   mg1ilKmeusF5W71H42oV+L7+Bxn/1Pk9PbKZ2JyhTVklSwUI9MyZDDO+1
   rsYRhT5JqhPrU1dtNffZoTrMqURHRNzsCmc1fuP++q8NlmazhBAKqf+BH
   KGbayD5dSUGYXTO4sWF1/oCRtNXAMxF4BOunnl1bIqY22bssFdFpVErNh
   FmWjWRQNGHjvZ7c5Ko/cv+E6oUh/c9RWtelUVsLVfxq6hjjlnKFoJotCh
   Q==;
X-CSE-ConnectionGUID: mrDXTz8GSlu/DfEDxXIV4Q==
X-CSE-MsgGUID: 1zchDUuKQzqEtU2z9a2xuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73655006"
X-IronPort-AV: E=Sophos;i="6.23,102,1770624000"; 
   d="scan'208";a="73655006"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 01:40:47 -0800
X-CSE-ConnectionGUID: Jk7zocwMTbSxx9Uwx4I9DA==
X-CSE-MsgGUID: ywdnkGDjTh+TV1ylWGRkSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,102,1770624000"; 
   d="scan'208";a="249091282"
Received: from lkp-server01.sh.intel.com (HELO cadc4577a874) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 05 Mar 2026 01:40:44 -0800
Received: from kbuild by cadc4577a874 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vy5CD-000000000QM-3cVS;
	Thu, 05 Mar 2026 09:40:41 +0000
Date: Thu, 5 Mar 2026 17:39:48 +0800
From: kernel test robot <lkp@intel.com>
To: Thanos Makatos <thanos.makatos@nutanix.com>,
	"seanjc@google.com" <seanjc@google.com>
Cc: oe-kbuild-all@lists.linux.dev,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	John Levon <john.levon@nutanix.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Thanos Makatos <thanos.makatos@nutanix.com>
Subject: Re: [PATCH] KVM: optionally post write on ioeventfd write
Message-ID: <202603051704.nmQyEAnO-lkp@intel.com>
References: <20260302122826.2572-1-thanos.makatos@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302122826.2572-1-thanos.makatos@nutanix.com>
X-Rspamd-Queue-Id: B491B20EE86
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72804-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,git-scm.com:url,intel.com:dkim,intel.com:email,intel.com:mid,01.org:url]
X-Rspamd-Action: no action

Hi Thanos,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on kvm/next linus/master v7.0-rc2 next-20260304]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Thanos-Makatos/KVM-optionally-post-write-on-ioeventfd-write/20260302-204031
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20260302122826.2572-1-thanos.makatos%40nutanix.com
patch subject: [PATCH] KVM: optionally post write on ioeventfd write
config: i386-randconfig-141-20260305 (https://download.01.org/0day-ci/archive/20260305/202603051704.nmQyEAnO-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
smatch: v0.5.0-9004-gb810ac53
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260305/202603051704.nmQyEAnO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603051704.nmQyEAnO-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/x86/events/intel/core.c:17:
   In file included from include/linux/kvm_host.h:40:
>> include/uapi/linux/kvm.h:669:16: error: static assertion failed due to requirement 'sizeof(struct kvm_ioeventfd) == 1 << 6': bad size
     669 | _Static_assert(sizeof(struct kvm_ioeventfd) == 1 << 6, "bad size");
         |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/linux/kvm.h:669:45: note: expression evaluates to '56 == 64'
     669 | _Static_assert(sizeof(struct kvm_ioeventfd) == 1 << 6, "bad size");
         |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~
   1 error generated.


vim +669 include/uapi/linux/kvm.h

   659	
   660	struct kvm_ioeventfd {
   661		__u64 datamatch;
   662		__u64 addr;        /* legal pio/mmio address */
   663		__u32 len;         /* 1, 2, 4, or 8 bytes; or 0 to ignore length */
   664		__s32 fd;
   665		__u32 flags;
   666		void __user *post_addr; /* address to write to if POST_WRITE is set */
   667		__u8  pad[24];
   668	};
 > 669	_Static_assert(sizeof(struct kvm_ioeventfd) == 1 << 6, "bad size");
   670	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

