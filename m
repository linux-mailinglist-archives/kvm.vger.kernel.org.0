Return-Path: <kvm+bounces-48652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9EFEACFFE1
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 11:58:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EB0B3A8AAD
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 09:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 662752868B2;
	Fri,  6 Jun 2025 09:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XDKFGZnH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7261286413;
	Fri,  6 Jun 2025 09:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749203919; cv=none; b=frIPdbAAvPFDszYfDLZH0hZxT9yRmhimctxvSw6YulHFEOY9y1iNs6+w3999Gub/HwwLrugDhqhnUQEW/CseGx3codT/Jg8hJ7nCXIuCgc9qq3UJhmekd6jYaUIv7dIWgI41Q0UGDHffrs88LyKclm3aBO8AF6aRAwkhNjWofPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749203919; c=relaxed/simple;
	bh=U95hSfjSxKU8Mrr+Q+iu2SL32xjHNdq6Oy0UV7wpoEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UxirZDsRZef3bWtBaAIC848hpoHpMNDCvKiECTnid4v0X0Irt1tgSxKOi3B1z44ZKjpVibgqTCiJcAbYvyy23s21/Sy8DWl6mSmfLVSlYyf3J6BSwBwWdX2GOTKOUb+B1/qCpvcKALtqPHQmxw/Y0Hv+cFOeKaL6RANjUFyOpqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XDKFGZnH; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749203918; x=1780739918;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=U95hSfjSxKU8Mrr+Q+iu2SL32xjHNdq6Oy0UV7wpoEI=;
  b=XDKFGZnHWekomi6BvUkD3Gj89I6j3Ht7JdMG6dLoFMNiVfYDPZmeFpZE
   WwHCr4XO0TW2vwx9cAQbJXKwzCcHaDScc9g6FPV8K4c7Zm+osO+wQdlpH
   Yt3vaK6biLOVFn5ifB5oWGcJc5kkmukFcOFkraP0yzGcZQIBtBmvW6daP
   2+P6Od8sax7pz+CRPbmJhylZLvPUKFz4VZMfQvs9z0LBgpskXdhK7KVBt
   Y8VliAwmINahEmNdJ/FAzegrquVPFEeYoEuiOt3aQ9p+UdikWrMIWlRj+
   ihY31/cgtOhj3b5mRB5+qyW1zwaYix/1j59yfQPNiVKtshO31CAj8jILY
   g==;
X-CSE-ConnectionGUID: LACeQ9bOSOWgIwWLUKZA9Q==
X-CSE-MsgGUID: YFdnrZ54ToSi/V8D/tdWyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11455"; a="55158102"
X-IronPort-AV: E=Sophos;i="6.16,214,1744095600"; 
   d="scan'208";a="55158102"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2025 02:58:37 -0700
X-CSE-ConnectionGUID: ybNLIoauTK6E6oM5rpJACA==
X-CSE-MsgGUID: rB5H5TO0RbSYvHrgesocLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,214,1744095600"; 
   d="scan'208";a="146756643"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 06 Jun 2025 02:58:34 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uNTqJ-0004u5-11;
	Fri, 06 Jun 2025 09:58:31 +0000
Date: Fri, 6 Jun 2025 17:58:21 +0800
From: kernel test robot <lkp@intel.com>
To: Dionna Glaze <dionnaglaze@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-coco@lists.linux.dev, Dionna Glaze <dionnaglaze@google.com>,
	Thomas Lendacky <Thomas.Lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <jroedel@suse.de>,
	Peter Gonda <pgonda@google.com>, Borislav Petkov <bp@alien8.de>,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v6 1/2] kvm: sev: Add SEV-SNP guest request throttling
Message-ID: <202506061922.q7OljdiN-lkp@intel.com>
References: <20250605150236.3775954-2-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605150236.3775954-2-dionnaglaze@google.com>

Hi Dionna,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mst-vhost/linux-next]
[also build test WARNING on linus/master v6.15 next-20250606]
[cannot apply to kvm/queue kvm/next kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Dionna-Glaze/kvm-sev-Add-SEV-SNP-guest-request-throttling/20250605-230536
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
patch link:    https://lore.kernel.org/r/20250605150236.3775954-2-dionnaglaze%40google.com
patch subject: [PATCH v6 1/2] kvm: sev: Add SEV-SNP guest request throttling
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20250606/202506061922.q7OljdiN-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
rustc: rustc 1.78.0 (9b00956e5 2024-04-29)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250606/202506061922.q7OljdiN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506061922.q7OljdiN-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/svm/sev.c:376:6: warning: variable 'throttle_interval' set but not used [-Wunused-but-set-variable]
     376 |         u64 throttle_interval;
         |             ^
   1 warning generated.


vim +/throttle_interval +376 arch/x86/kvm/svm/sev.c

   334	
   335	/*
   336	 * This sets up bounce buffers/firmware pages to handle SNP Guest Request
   337	 * messages (e.g. attestation requests). See "SNP Guest Request" in the GHCB
   338	 * 2.0 specification for more details.
   339	 *
   340	 * Technically, when an SNP Guest Request is issued, the guest will provide its
   341	 * own request/response pages, which could in theory be passed along directly
   342	 * to firmware rather than using bounce pages. However, these pages would need
   343	 * special care:
   344	 *
   345	 *   - Both pages are from shared guest memory, so they need to be protected
   346	 *     from migration/etc. occurring while firmware reads/writes to them. At a
   347	 *     minimum, this requires elevating the ref counts and potentially needing
   348	 *     an explicit pinning of the memory. This places additional restrictions
   349	 *     on what type of memory backends userspace can use for shared guest
   350	 *     memory since there is some reliance on using refcounted pages.
   351	 *
   352	 *   - The response page needs to be switched to Firmware-owned[1] state
   353	 *     before the firmware can write to it, which can lead to potential
   354	 *     host RMP #PFs if the guest is misbehaved and hands the host a
   355	 *     guest page that KVM might write to for other reasons (e.g. virtio
   356	 *     buffers/etc.).
   357	 *
   358	 * Both of these issues can be avoided completely by using separately-allocated
   359	 * bounce pages for both the request/response pages and passing those to
   360	 * firmware instead. So that's what is being set up here.
   361	 *
   362	 * Guest requests rely on message sequence numbers to ensure requests are
   363	 * issued to firmware in the order the guest issues them, so concurrent guest
   364	 * requests generally shouldn't happen. But a misbehaved guest could issue
   365	 * concurrent guest requests in theory, so a mutex is used to serialize
   366	 * access to the bounce buffers.
   367	 *
   368	 * [1] See the "Page States" section of the SEV-SNP Firmware ABI for more
   369	 *     details on Firmware-owned pages, along with "RMP and VMPL Access Checks"
   370	 *     in the APM for details on the related RMP restrictions.
   371	 */
   372	static int snp_guest_req_init(struct kvm *kvm)
   373	{
   374		struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
   375		struct page *req_page;
 > 376		u64 throttle_interval;
   377	
   378		req_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
   379		if (!req_page)
   380			return -ENOMEM;
   381	
   382		sev->guest_resp_buf = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
   383		if (!sev->guest_resp_buf) {
   384			__free_page(req_page);
   385			return -EIO;
   386		}
   387	
   388		sev->guest_req_buf = page_address(req_page);
   389		mutex_init(&sev->guest_req_mutex);
   390	
   391		throttle_interval = ((u64)sev_snp_request_ratelimit_khz * HZ) / HZ_PER_KHZ;
   392		ratelimit_state_init(&sev->snp_guest_msg_rs, sev_snp_request_ratelimit_khz, 1);
   393	
   394		return 0;
   395	}
   396	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

