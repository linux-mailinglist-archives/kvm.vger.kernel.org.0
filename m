Return-Path: <kvm+bounces-38659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FC37A3D683
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 11:26:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B669189AF92
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 10:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C8C41F12ED;
	Thu, 20 Feb 2025 10:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f2fcYsjR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17FD1EF080;
	Thu, 20 Feb 2025 10:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740047169; cv=none; b=PSUbwErR4d5tqd34kS10MinqrJ3jTzomyss5/gOMmkcWMOeSfZnFF7eLSoQWM8PnqGr9DGXAMhD3mbHUyPC5aoV1hUft7VHsow2P/5FafB8xIEuGSdRWiGELjOL6QgLbSifvBSCCemjJsW7Beojn//BQArU83iAnNOf42gYvbY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740047169; c=relaxed/simple;
	bh=wdo52PAMmFLPMVI5gq85cT42hoFnmWHUUnIJwJEQGeY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lMSbjT/qMEMyj7c3OuXRx6FHnNcbbgpon8dn2JEouQ1OxQlC1KW4T3xBAnd7M8lcFkxvQKExmAvV1QQICjWIJavz6TA3TsLDCC8LEW5kKwmgVhtn2+XSI+5ViDaFMJgPXtyk5eEU6KTNrL31i+Czxf07dM+1Kllqav5uVZ3BtC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f2fcYsjR; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740047168; x=1771583168;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wdo52PAMmFLPMVI5gq85cT42hoFnmWHUUnIJwJEQGeY=;
  b=f2fcYsjRt2r2LiLutAom1bnQWNSvTbjqeFBljf2uJQ+OjOgMIvv0QeW9
   toQw+cFXnKeaomkIEP3/lDj5eWOWvjKkvLI69ew/lTFV5aCBjn0ty3eEK
   bixdsNh/uvPH4s4mbAe9o2uc498FL1RGqspzoSGrTmvDBI5FvI8lHJrna
   FJ9VqM48RErt869nkNGmPFX/64c0NN0BZ1520T1QSvEYA2ktmM2v9/X38
   qMjBDYIWrZCsav4B/dF6czNdK7L5TugMURAqD/Llr8gb5ljgkiYjB1aqQ
   HlEyKHwgmK1A9bRzF+GbVlj8peS8UAN9w0Yb12+NHlwY2MgiwCmxSi8s3
   g==;
X-CSE-ConnectionGUID: MAHjjVZfTPKKKyCz+Ko7ZA==
X-CSE-MsgGUID: FbQK5lghS3aKOe8cdPX9Zg==
X-IronPort-AV: E=McAfee;i="6700,10204,11350"; a="28415272"
X-IronPort-AV: E=Sophos;i="6.13,301,1732608000"; 
   d="scan'208";a="28415272"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 02:26:07 -0800
X-CSE-ConnectionGUID: ZdM3o7BITy6pIJKc420feA==
X-CSE-MsgGUID: 9+qF8MieSEq1JfuTmggczA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="115897699"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 02:26:05 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 0/2] two KVM MMU fixes for TDX
Date: Thu, 20 Feb 2025 18:24:36 +0800
Message-ID: <20250220102436.24373-1-yan.y.zhao@intel.com>
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

The two errors are not observed in any real workloads yet.
The series is tested by faking the error in the SEAMCALL wrapper while
bypassing the real SEAMCALLs.

v2:
- Use kvm_check_request(KVM_REQ_VM_DEAD) to detect VM dead in patch 2.
  (Sean)

v1: https://lore.kernel.org/all/20250217085535.19614-1-yan.y.zhao@intel.com

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


