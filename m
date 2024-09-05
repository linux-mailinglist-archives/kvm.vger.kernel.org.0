Return-Path: <kvm+bounces-25939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3243E96D7E8
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 14:09:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6412D1C23202
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 12:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C982419ABAE;
	Thu,  5 Sep 2024 12:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AvmuUhWj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1D01991B1;
	Thu,  5 Sep 2024 12:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725538133; cv=none; b=lUlsdqFWpoy5evLrTZOegxAyY/TA/wfTzdTIbriTYAP59QyOXBZdAB6AHIL2qQ+dN3GhDobC2HtPoJEG9dHfQhyVUUyUMtfkoyOcSeG7033k3C3WFNQb1jItNF4ohATeH/hvamLAbL69g36uBHPjejwOtwxOIBZHoJApnVau2AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725538133; c=relaxed/simple;
	bh=S9Pu+2jNljdpyfjBv9/hdw6x1S6N/3qTCi0O5cd9F8A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PoQCvup9OMPEV9hHrKl71uL/mmIXYFmwjlhFtCiuSK2ffMA+wPKimJ3Eu3Yvn7wVsMirYUGMqiWyPnpT2DlUxA0gwJjIr+596uTD/YLRYP1mnEl9NdVNObdfwf6wcVulWnIO84etbWAnm/o/Hu6F742mOuipldJYYO1owKgXeqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AvmuUhWj; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725538131; x=1757074131;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=S9Pu+2jNljdpyfjBv9/hdw6x1S6N/3qTCi0O5cd9F8A=;
  b=AvmuUhWjKsay6nylvqrvaDvev96c+2Gt9tUfqSCi5KhljWrTFzyP9GiZ
   wjIqW+xfHX82r+fy2kF6bWwBNlbvx6ZO01r82rsDdVuEpvfqoT327FjMT
   wJ44yGv6Wyqmr2tSZvN+pRmsPBaFlvReYYWmY7G2H5d+Im8O3QZAbIFPc
   StLSab9NKO1drjmy8ADUfxivBnC/SIgqQf+Hf6XOOKc92SoFcvmiIBGP5
   TfKY4TEa5le41w5pZ28MBCQdtOT6aVgmG62KyYbiHDwOlRu6t2rU7smsP
   wYMhG906htbW48ztLbtVTIJtnvcJndJ0GLq+ScDXPO2c0zCRlYFiCtfB9
   Q==;
X-CSE-ConnectionGUID: GhFpK75dQRuF8qAT5aw0jA==
X-CSE-MsgGUID: OrHkaXCJTpawkCfzbo0pIQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="27170649"
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="27170649"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 05:08:50 -0700
X-CSE-ConnectionGUID: vMn+0FUlRrqSZANUCFhj5w==
X-CSE-MsgGUID: yPPKl3kLQZGeDlybQgb+pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="70198459"
Received: from hcaldwel-desk1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.43])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 05:08:49 -0700
From: Kai Huang <kai.huang@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH] KVM: VMX: Also clear SGX EDECCSSA in KVM CPU caps when SGX is disabled
Date: Fri,  6 Sep 2024 00:08:37 +1200
Message-ID: <20240905120837.579102-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When SGX EDECCSSA support was added to KVM in commit 16a7fe3728a8
("KVM/VMX: Allow exposing EDECCSSA user leaf function to KVM guest"), it
forgot to clear the X86_FEATURE_SGX_EDECCSSA bit in KVM CPU caps when
KVM SGX is disabled.  Fix it.

Fixes: 16a7fe3728a8 ("KVM/VMX: Allow exposing EDECCSSA user leaf function to KVM guest")
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 594db9afbc0f..98d737e0d416 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7963,6 +7963,7 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_SGX_LC);
 		kvm_cpu_cap_clear(X86_FEATURE_SGX1);
 		kvm_cpu_cap_clear(X86_FEATURE_SGX2);
+		kvm_cpu_cap_clear(X86_FEATURE_SGX_EDECCSSA);
 	}
 
 	if (vmx_umip_emulated())

base-commit: 44518120c4ca569cfb9c6199e94c312458dc1c07
-- 
2.46.0


