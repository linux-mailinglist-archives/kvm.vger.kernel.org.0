Return-Path: <kvm+bounces-72270-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +AJSK5xxomne3AQAu9opvQ
	(envelope-from <kvm+bounces-72270-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 05:39:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D9411C0508
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 05:39:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 347A2305F300
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 04:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F4313603EC;
	Sat, 28 Feb 2026 04:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BHosO+Yt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB56B3290DC;
	Sat, 28 Feb 2026 04:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772253584; cv=none; b=QHxM1yoeqz2PXZ7L2eLJx0X6er0lnAuDpz8UyRRVFslgPoKqlqYVJONzTzWvT3L9NfQQQ6j+iPqAXH+RBuFPaXHHRizVz0Dp3Xcc2312GStpNbM0srGpOXl9OBDqrHAallocRbPNYEoguLXXGbswUy7Va9UUaDD+e58sOmiQdJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772253584; c=relaxed/simple;
	bh=S9F20WCWh4WNQT9heMZVPcCyAc2mdy+zssVY544bAXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tmGWlOiyPRTWCUO1xdBIDYiQNeN1VBqBhQiwRstrAktx9n7JbzFZSGgNUn8NUMnhc4gEGIbAXC7TDLpFzCfPeNXmcNFCS8fZzQEk387ySZwZOtEZhRql3aHmdQRgsXuTNRfrc9DN8s75NcR70EulUrF2Abwn3YOsluiiKZqJfk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BHosO+Yt; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772253583; x=1803789583;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=S9F20WCWh4WNQT9heMZVPcCyAc2mdy+zssVY544bAXg=;
  b=BHosO+YtcDzHFjTDSZBmHTyIgD5Yqzn+HJSw5nbAmrGzpXOvJHblIBbg
   zFol7eaLJja+Q8xXWjV8LfnOAuxp4Wwh0QGMru3+fPlago40TVmpvI5/D
   MrXGAuSNZKhXOBznsNWvZm7vUWuf5T/GemvK2uApBLjbNM/WP8oQNIBpF
   DR3mhnmV3RCxgfGlKhvEcKkQEZn2n5UJaZP/0P3XYihmAPcXwVFMu152c
   GuFvIpeywWG1bY3BpTCnYn7UrSO6gTZVtLD8nwHHtJ6bx5qb9o3uU/fhE
   CgFXgwCL2A2XdnPc7ThmyivP8YLLOnVPYT+N+uZIJroNxeD0+p5pNcbCe
   A==;
X-CSE-ConnectionGUID: iIn3bgAbTQu6jwPHLCv70w==
X-CSE-MsgGUID: 56iZBfNGTKyEDW5lX9d0TQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11714"; a="84044893"
X-IronPort-AV: E=Sophos;i="6.21,315,1763452800"; 
   d="scan'208";a="84044893"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2026 20:39:42 -0800
X-CSE-ConnectionGUID: Dg/4g3fLTWuVI4rhLvzZ1A==
X-CSE-MsgGUID: PZz/gNCrR6+n+zwnOxmA4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,315,1763452800"; 
   d="scan'208";a="216991849"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa009.jf.intel.com with ESMTP; 27 Feb 2026 20:39:38 -0800
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vwC76-000000000hd-1TaT;
	Sat, 28 Feb 2026 04:39:36 +0000
Date: Sat, 28 Feb 2026 05:38:50 +0100
From: kernel test robot <lkp@intel.com>
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Alexandre Ghiti <alex@ghiti.fr>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>
Subject: Re: [PATCH v9 2/3] KVM: selftests: Refactor UAPI tests into
 dedicated function
Message-ID: <202602280523.Y5Q8Pdft-lkp@intel.com>
References: <20260228005355.823048-3-xujiakai2025@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260228005355.823048-3-xujiakai2025@iscas.ac.cn>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72270-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim,intel.com:email,01.org:url]
X-Rspamd-Queue-Id: 6D9411C0508
X-Rspamd-Action: no action

Hi Jiakai,

kernel test robot noticed the following build warnings:

[auto build test WARNING on v6.19]
[cannot apply to kvm/queue kvm/next linus/master kvm/linux-next v7.0-rc1 next-20260227]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiakai-Xu/RISC-V-KVM-Validate-SBI-STA-shmem-alignment-in-kvm_sbi_ext_sta_set_reg/20260228-085648
base:   v6.19
patch link:    https://lore.kernel.org/r/20260228005355.823048-3-xujiakai2025%40iscas.ac.cn
patch subject: [PATCH v9 2/3] KVM: selftests: Refactor UAPI tests into dedicated function
config: arm64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260228/202602280523.Y5Q8Pdft-lkp@intel.com/config)
compiler: aarch64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260228/202602280523.Y5Q8Pdft-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602280523.Y5Q8Pdft-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> steal_time.c:207:13: warning: function declaration isn't a prototype [-Wstrict-prototypes]
     207 | static void check_steal_time_uapi()
         |             ^~~~~~~~~~~~~~~~~~~~~
   cc1: note: unrecognized command-line option '-Wno-gnu-variable-sized-type-not-at-end' may have been intended to silence earlier diagnostics

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

