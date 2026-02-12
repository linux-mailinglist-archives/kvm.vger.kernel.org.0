Return-Path: <kvm+bounces-71000-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qBtTAv0KjmmS+wAAu9opvQ
	(envelope-from <kvm+bounces-71000-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 18:16:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DD3412FD5B
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 18:16:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 007F130101E4
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 17:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DBA9223DFF;
	Thu, 12 Feb 2026 17:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ildDXyVQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAD012CDBE;
	Thu, 12 Feb 2026 17:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770916601; cv=none; b=Of7tr9VfVw9tqlBOZQAX14yk072k/ctLmMHwzD/OPNgpcJ3brxVgazg3ErJHSLDft4TqjuOjbsT1247oh2RR0Ug56w4jKEhV6bWJe2MY5XnLnAXxL4X4Z/5WTnRqEIn5PTpTkuJeNS+tAjRNFl7Wk+vTmxRE5e3vPwi141HHc1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770916601; c=relaxed/simple;
	bh=ukfbKIYaWioA88MWF8i1AnL7FUSI/OI7WtGr1Ojbg/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EDniWgMfNI5ppG/u7XPb3io1pDsDY8Z56D8gDFwi0R1Q8dJx/xsHVT3Z3IYOe0r77IMsdZYtkrkl3YLYBPI6VV0Rn7KFoLEQS3//Iam76IGWUTMA9U7cWq0hhdVFupyALdH+NRIiwxU2UXXHaSGx6yK46Om8ZvEtA8HakKiFVr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ildDXyVQ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770916600; x=1802452600;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ukfbKIYaWioA88MWF8i1AnL7FUSI/OI7WtGr1Ojbg/A=;
  b=ildDXyVQYwF0BZHuBmJYG3cmsqW+/Nw8zjGHKEwshGxoRlgAVklqhokk
   5OlkZNcEyvyQAjr5V+1w8ug4JeviZT5GIROj/ZbEU3PSjTLagL2XDXeCH
   FaekfApv+31hGzk0WsJ45iJFtXjK9Ev6a9ThBB4yexGT3IruY6Vi9tkuX
   4ZEywkzfmSERcTv80bztLH/KqiJVloCcflLnZC7M8smnJ1w4GdFHN/do2
   927LqtgA6i+5ozKbdDg9Sek8TPuMAlkuKyA2zaJp1td7/dHdRMlKL+Fbh
   ZINIsHBz/lQ6ZlBNuTVT1cqZAAgbKF8RJSEcHmoSA0yg6ZIZblz9LTfBX
   A==;
X-CSE-ConnectionGUID: dgzlP90mSi2aTQNPcpAyaA==
X-CSE-MsgGUID: Wm7OZyMiRVaLXnZkym+97w==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="89506901"
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="89506901"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 09:16:39 -0800
X-CSE-ConnectionGUID: qkVbthVaRvaAUlpur4Lc4Q==
X-CSE-MsgGUID: jk6/WEgnSiCrYlGhxCYKkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="235647975"
Received: from igk-lkp-server01.igk.intel.com (HELO e5404a91d123) ([10.211.93.152])
  by fmviesa002.fm.intel.com with ESMTP; 12 Feb 2026 09:16:38 -0800
Received: from kbuild by e5404a91d123 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vqaIt-000000001ML-330b;
	Thu, 12 Feb 2026 17:16:35 +0000
Date: Thu, 12 Feb 2026 18:16:12 +0100
From: kernel test robot <lkp@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 1/2] KVM: remove CONFIG_KVM_GENERIC_MMU_NOTIFIER
Message-ID: <202602121838.3VZCFFcb-lkp@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71000-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,intel.com:email,01.org:url,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8DD3412FD5B
X-Rspamd-Action: no action

Hi Paolo,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on kvm/next kvms390/next next-20260212]
[cannot apply to powerpc/topic/ppc-kvm kvmarm/next linus/master kvm/linux-next v6.16-rc1]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Paolo-Bonzini/KVM-remove-CONFIG_KVM_GENERIC_MMU_NOTIFIER/20260212-185546
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20260212105211.1555876-2-pbonzini%40redhat.com
patch subject: [PATCH 1/2] KVM: remove CONFIG_KVM_GENERIC_MMU_NOTIFIER
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260212/202602121838.3VZCFFcb-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260212/202602121838.3VZCFFcb-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602121838.3VZCFFcb-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/x86/kvm/../../../virt/kvm/kvm_main.c:900:9: error: call to undeclared function 'mmu_notifier_register'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     900 |         return mmu_notifier_register(&kvm->mmu_notifier, current->mm);
         |                ^
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:900:9: note: did you mean 'mmu_notifier_release'?
   include/linux/mmu_notifier.h:598:20: note: 'mmu_notifier_release' declared here
     598 | static inline void mmu_notifier_release(struct mm_struct *mm)
         |                    ^
>> arch/x86/kvm/../../../virt/kvm/kvm_main.c:1220:3: error: call to undeclared function 'mmu_notifier_unregister'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1220 |                 mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
         |                 ^
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:1220:3: note: did you mean 'preempt_notifier_unregister'?
   include/linux/preempt.h:357:6: note: 'preempt_notifier_unregister' declared here
     357 | void preempt_notifier_unregister(struct preempt_notifier *notifier);
         |      ^
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:1283:2: error: call to undeclared function 'mmu_notifier_unregister'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1283 |         mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
         |         ^
   3 errors generated.


vim +/mmu_notifier_register +900 arch/x86/kvm/../../../virt/kvm/kvm_main.c

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

