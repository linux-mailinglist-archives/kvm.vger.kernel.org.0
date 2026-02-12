Return-Path: <kvm+bounces-71002-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gN7xBJAVjmmZ/AAAu9opvQ
	(envelope-from <kvm+bounces-71002-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 19:01:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 84886130206
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 19:01:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7077430AAED7
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 18:01:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE79C23E23C;
	Thu, 12 Feb 2026 18:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YBQ1ngq9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277481DFF7;
	Thu, 12 Feb 2026 18:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770919279; cv=none; b=hxQ5gINnuYokdWKzDNzFGRdxbUYZ1CMTzdJHzWZgQrsyAk7x/ONzfZo7qms1AzAVdFbtFywjw/wrNTWxcS5yHkVrM1iRhFhOqFT0bmJPJgHrXnpmfy1xOZ0+s0jUCJQrYQLJSiqsvsxvJ5BT/KmTeVkNvlgk2a/43U2JfxfSTaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770919279; c=relaxed/simple;
	bh=2VceDgzAcNAbcWMGe/daLfC3MZ2oRKR+bvMespEvaLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OshmfXwZPpar5XSV8e8ZMMLRhKhx/kACFdJISnMVTIYSN6S9j0KG3ybmU7qWiRp8DHwkv+9PvDLB/3fPyO5BnAKk7O328E4O5jkIPziacDLelGCzEonvQpojGZ3N5FIYcL7d6afs7jBMdN4b2bJifWiVdUzrazs7MFXkwlVHK+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YBQ1ngq9; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770919277; x=1802455277;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2VceDgzAcNAbcWMGe/daLfC3MZ2oRKR+bvMespEvaLQ=;
  b=YBQ1ngq9XNyBYLi3MLp/kxVxflAo3x2YXloHsL8JGY1DHHN5cbl+xE8a
   pY7hQdy/39CAA1BQAM0gwuNOrmTOAyJ830tjuv2jnJqo5Q5pEYA9ZHN0R
   8RGh10dOy7T1aNjiujyFzHrSpy1gkAYFpdHrCz+teDJnB4UKEQII9Fuc1
   eP3+M1DUxAsbLbsENPlM2SFQeEvQzXwqaEjQz9IUw/Fc6LOWl2yGQWuHQ
   5Gj8JJFWYT2AKTO5fjDMWiTxtaIKAJ8ZDcjsslyUicF5UbGOvdmWy5Pq0
   NIn9E/XcpX62SMGH3QTvSTrSX8w2MKn7w+wzEg1H4JW9hkuhGLdAIyVug
   Q==;
X-CSE-ConnectionGUID: 1e98yIxNS5mPReDsGzzgNw==
X-CSE-MsgGUID: 4DEj/gi6Sxal7bdCK8/lqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="72199053"
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="72199053"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 10:01:17 -0800
X-CSE-ConnectionGUID: rdinfRarRReea0eUHw6cmw==
X-CSE-MsgGUID: qKrb+KCxSqmlemg5SrIz1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="235659425"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 12 Feb 2026 10:01:15 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vqb05-00000000sB6-1JRP;
	Thu, 12 Feb 2026 18:01:13 +0000
Date: Fri, 13 Feb 2026 02:00:48 +0800
From: kernel test robot <lkp@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 1/2] KVM: remove CONFIG_KVM_GENERIC_MMU_NOTIFIER
Message-ID: <202602130100.UiJclptY-lkp@intel.com>
References: <20260212105211.1555876-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212105211.1555876-2-pbonzini@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-71002-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[01.org:url,intel.com:mid,intel.com:dkim,intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 84886130206
X-Rspamd-Action: no action

Hi Paolo,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on kvm/next kvms390/next next-20260212]
[cannot apply to powerpc/topic/ppc-kvm kvmarm/next linus/master kvm/linux-next v6.19]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Paolo-Bonzini/KVM-remove-CONFIG_KVM_GENERIC_MMU_NOTIFIER/20260212-185546
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20260212105211.1555876-2-pbonzini%40redhat.com
patch subject: [PATCH 1/2] KVM: remove CONFIG_KVM_GENERIC_MMU_NOTIFIER
config: i386-buildonly-randconfig-002-20260212 (https://download.01.org/0day-ci/archive/20260213/202602130100.UiJclptY-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260213/202602130100.UiJclptY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602130100.UiJclptY-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_init_mmu_notifier':
>> arch/x86/kvm/../../../virt/kvm/kvm_main.c:900:16: error: implicit declaration of function 'mmu_notifier_register'; did you mean 'mmu_notifier_release'? [-Wimplicit-function-declaration]
     900 |         return mmu_notifier_register(&kvm->mmu_notifier, current->mm);
         |                ^~~~~~~~~~~~~~~~~~~~~
         |                mmu_notifier_release
   arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_create_vm':
>> arch/x86/kvm/../../../virt/kvm/kvm_main.c:1220:17: error: implicit declaration of function 'mmu_notifier_unregister'; did you mean 'preempt_notifier_unregister'? [-Wimplicit-function-declaration]
    1220 |                 mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~
         |                 preempt_notifier_unregister


vim +900 arch/x86/kvm/../../../virt/kvm/kvm_main.c

4c07b0a4b6df45 Avi Kivity 2009-12-20  896  
4c07b0a4b6df45 Avi Kivity 2009-12-20  897  static int kvm_init_mmu_notifier(struct kvm *kvm)
4c07b0a4b6df45 Avi Kivity 2009-12-20  898  {
4c07b0a4b6df45 Avi Kivity 2009-12-20  899  	kvm->mmu_notifier.ops = &kvm_mmu_notifier_ops;
4c07b0a4b6df45 Avi Kivity 2009-12-20 @900  	return mmu_notifier_register(&kvm->mmu_notifier, current->mm);
4c07b0a4b6df45 Avi Kivity 2009-12-20  901  }
4c07b0a4b6df45 Avi Kivity 2009-12-20  902  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

