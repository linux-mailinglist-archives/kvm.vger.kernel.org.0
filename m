Return-Path: <kvm+bounces-32871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B67D9E10A2
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 02:04:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3823280DC0
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 01:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF7A614A627;
	Tue,  3 Dec 2024 01:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YJxu071Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0F84CB36;
	Tue,  3 Dec 2024 01:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733187821; cv=none; b=SaY7BFwVjxwR35wLKqu0Dz1NiLQ1AJJg72sN5YVMoIEIudNsVMZNM/gB3fxA8FUDjnlpySeNo1S5M2AdQ5OVM86KKJIeDllUyMoQlKV6dKT+xfaz7F+L/FEBbL6BuMbefJHeCMvMc9SLevK4VqH91zt92TE6k8lOCE12nlam1I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733187821; c=relaxed/simple;
	bh=18vF0MdjqmpSzyFWhoeQKjGMllvwZB7eG2FZjMSJaCc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MU6ipPNvZTFLx2/4vHXPGEhxD514k7eOAFE4pBIxl3Mtu2tyYzNpfZg66AgRVmZnfbxtx2BE9oiN45Zcus6KD9s5wWFQ5AnUa7Pwdtow8fdBfZhaTSjsmvd8FK7XpMDddLUtk31EoLGh8037IoeYjglT/a8N7QxbRZgC0/hr2SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YJxu071Z; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733187819; x=1764723819;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=18vF0MdjqmpSzyFWhoeQKjGMllvwZB7eG2FZjMSJaCc=;
  b=YJxu071Z2SYIRLgd/YUjK5y/U6EisfD7gi/+TGuFwSvmKayxnLRn1qWb
   en8Z4Syot06v0OzO2oYej+JRbouEA/8NajcixzuM/9h5+mc9HflSZn4IM
   GpuX+jqjw65QIFfFz9Jb+xFpGCLLERN0Aa0khIKWBVQovydS+m5eOYskV
   nCGMA+MJMCLt/Lgov2sRjv1zoClbzGs4rU/+YR4FZxVynmFkcoNM+u4FZ
   /ajM9R1G5mI2z3MXMvryQ+/dbEequ70TI3fH0f/pdiZf8KChtYVdpoFUk
   BBvGFFVGe2deQbuaRG8xqAbXgCSqyFmIGBiSxR4UHwxu05m03KtzrOBzX
   A==;
X-CSE-ConnectionGUID: C7cv3zu9Szq9OFno9L0W7g==
X-CSE-MsgGUID: ysn8+SeASW+oqv1JpZHIkQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11274"; a="36237969"
X-IronPort-AV: E=Sophos;i="6.12,203,1728975600"; 
   d="scan'208";a="36237969"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 17:03:35 -0800
X-CSE-ConnectionGUID: MpdAkyJWSbCHRC9DQKD3uw==
X-CSE-MsgGUID: HzgSpDuNTqGC0BBkuteu7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,203,1728975600"; 
   d="scan'208";a="116535786"
Received: from jairdeje-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.7])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 17:03:24 -0800
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: kvm@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	dave.hansen@intel.com
Cc: isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	yan.y.zhao@intel.com,
	rick.p.edgecombe@intel.com,
	x86@kernel.org,
	adrian.hunter@intel.com
Subject: [RFC PATCH v2 0/6] SEAMCALL Wrappers
Date: Mon,  2 Dec 2024 17:03:10 -0800
Message-ID: <20241203010317.827803-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This is a followup to the "SEAMCALL Wrappers" RFC[0] that spun out of 
Dave’s comments on the SEAMCALL wrappers in the “TDX vCPU/VM creation” 
series [1]. To try to summarize Dave’s comments, he noted that the 
SEAMCALL wrappers were very thin, not even using proper types for things 
where types exist.

The last discussion was to use struct pages instead of u64. It is pretty 
much what Dave suggested with a minor tweak to instead include the tdcx 
page count in the TD struct instead of the vCPU one.

This is because it will not vary between vCPUs. Doing it that way 
basically preserves the existing data duplication, but these counts are 
basically "global metadata". The global metadata patches export them as a 
size, but KVM wants to use them as a page count. So we should not be 
including these counts in each TD scoped structure as is currently done. To
address the duplication we need to change the "global metadata patches"
to export the count instead of size.

Otherwise, in the spirit of looking to find better types for the other raw 
u64's, I played around again with the out params of 
tdh_phymem_page_reclaim(). In the end I opted for better names and a 
comment rather than anything fancier.

Here is the branch with the VM/vCPU caller adjustments as the last commit:
https://github.com/intel/tdx/tree/seamcall-rfc-v2

Thanks,

Rick

[0]
https://lore.kernel.org/kvm/20241115202028.1585487-1-rick.p.edgecombe@intel.com/
[1]
https://lore.kernel.org/kvm/20241030190039.77971-1-rick.p.edgecombe@intel.com/


Rick Edgecombe (6):
  x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID management
  x86/virt/tdx: Add SEAMCALL wrappers for TDX TD creation
  x86/virt/tdx: Add SEAMCALL wrappers for TDX vCPU creation
  x86/virt/tdx: Add SEAMCALL wrappers for TDX page cache management
  x86/virt/tdx: Add SEAMCALL wrappers for TDX VM/vCPU field access
  x86/virt/tdx: Add SEAMCALL wrappers for TDX flush operations

 arch/x86/include/asm/tdx.h  |  38 ++++++
 arch/x86/virt/vmx/tdx/tdx.c | 240 ++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  38 ++++--
 3 files changed, 309 insertions(+), 7 deletions(-)

-- 
2.47.1


