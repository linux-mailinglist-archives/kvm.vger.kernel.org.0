Return-Path: <kvm+bounces-38344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 278E1A37DAA
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 09:59:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B35D01896FCB
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 08:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D45CC1AA1F6;
	Mon, 17 Feb 2025 08:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KXZaiGyI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0041A4F2F;
	Mon, 17 Feb 2025 08:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739782611; cv=none; b=cX1Wh1DAKqvevLuPBAjqdw9J1BeeAEkFDwDpoBEJDEQfvhUq1nrs9ft108DYQzD08Rir1iwPbkx7eCpUny7hPmtyAcqANxBXyx38Up8crak5/Lae7pjJqlktW+WmvHTP2W+HmJevY2YhJfb1Y9JUrzp1VO2oYhFZ9XgwePHTnic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739782611; c=relaxed/simple;
	bh=cCeJVZnbyCxm3okPfPj18vzOfbqd689/PyAo6ALqKZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SIwY09akfSzWilAZsUAm85hRlPM4fykbs4Yt6qjCHpzEYhEHsMuozRW7qTJshsrsR/qI/FjMPbbocrJfywusTYAUwSIY69HK1M8CSEJxC1h3Jh+SIgHVJdmOusdvxtn8AgKd7RZS9jlEFpShK9UsGVCXCE5/BepNBuVLkHe8iWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KXZaiGyI; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739782607; x=1771318607;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cCeJVZnbyCxm3okPfPj18vzOfbqd689/PyAo6ALqKZ4=;
  b=KXZaiGyISRNjXPv6TazfbR7mMEuBUOINFqCUwfqPWi27bBT+E6f1XVqC
   BL0f4+MvUvfDNAc4/Y7DN7fjUSd+x4hSjWQD5dljPcNQWIxvLK1yZDtQ8
   4JYL/BMe/KG0ODMFKhFoGCG3t/Hy0XXmYoHVlSPHdb+juuxSkJcqpVecb
   AZFpxPnd1fUpc+zKvNTija5/sG3Vk3hsP2dDOhnV8Wfqr//35gS70ly5z
   3UeS/PmKTd1DQAef8klSIfPUqbCN/hHhb4aT2bvVTEWVaB0nCkncI42Ro
   E0+TbaHbB1luWP7PB3KmlK2OHLTL+xIpnT1Ng27wewxHGyYl543RNJdLF
   Q==;
X-CSE-ConnectionGUID: a4/GaCORT/auveGWX25qQA==
X-CSE-MsgGUID: settv8tWQbqZBc+yuVRhnw==
X-IronPort-AV: E=McAfee;i="6700,10204,11347"; a="57986160"
X-IronPort-AV: E=Sophos;i="6.13,292,1732608000"; 
   d="scan'208";a="57986160"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2025 00:56:47 -0800
X-CSE-ConnectionGUID: fkiXbU45RaqtTj2TfbQ9vA==
X-CSE-MsgGUID: 5GDjRd3/R1ixa2KjIFoIFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,292,1732608000"; 
   d="scan'208";a="114691424"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2025 00:56:45 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 0/2] two KVM MMU fixes for TDX
Date: Mon, 17 Feb 2025 16:55:35 +0800
Message-ID: <20250217085535.19614-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi, 

There are two fixes to KVM MMU for TDX in response to two hypothetically
triggered errors:
(1) errors in tdh_mem_page_add(),
(2) fatal errors in tdh_mem_sept_add()/tdh_mem_page_aug().

Patch 1 handles the error in SEPT zap resulting from error (1).
Patch 2 fixes a possible stuck in the kernel loop introduced by error (2).
(A similar fix in SEPT SEAMCALL local retry is also required if the fix in
patch 2 looks good to you).

The two errors are not observed in any real workloads yet.
The series is tested by faking the error in the SEAMCALL wrapper while
bypassing the real SEAMCALLs.

Thanks
Yan

Yan Zhao (2):
  KVM: TDX: Handle SEPT zap error due to page add error in premap
  KVM: x86/mmu: Bail out kvm_tdp_map_page() when VM dead

 arch/x86/kvm/mmu/mmu.c |  4 +++
 arch/x86/kvm/vmx/tdx.c | 64 +++++++++++++++++++++++++++++-------------
 2 files changed, 49 insertions(+), 19 deletions(-)

-- 
2.43.2


