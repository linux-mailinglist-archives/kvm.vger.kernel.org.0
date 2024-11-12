Return-Path: <kvm+bounces-31583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FC7F9C4FC4
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:46:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3139B28415F
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C4992141C0;
	Tue, 12 Nov 2024 07:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VfpXt4Xg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE14620E01E;
	Tue, 12 Nov 2024 07:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397259; cv=none; b=PS96s7lDRUBNRjWj1IPGbKZ6LPXPguEVkrmPzHTAGLEuAl7R9bm+2Eh+FTJabcOnbRgs/kMaa3eL5saZa6f27DaJhtVYthbF6df4gp62Uews6HZsH6b5hRBcGeSDii1YpLy8POfOeIStK8BhP+RkaBuFCOt38un9H4zpmslfsW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397259; c=relaxed/simple;
	bh=bbr8e4XV5c43aR99S/J74bCRTx8fPaKjjBt9L4PASU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HT/IVhvIU/aMOX3Nkc816HfbmETTeQEcT+pDowXwAffLweOZ9IeMzlSY5ET0TGp1d+/IEBZZbD5Gh3K5Tl7TUKdK8njzP5VQ0fTyLGCBEgZh/cIYuG8UnOmnuaHIScBa7Uz4HECEn/wNr3Qa+mW+468hSvMk5Whn7nCovujfVig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VfpXt4Xg; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397258; x=1762933258;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bbr8e4XV5c43aR99S/J74bCRTx8fPaKjjBt9L4PASU8=;
  b=VfpXt4Xgb1yTaqdGmiXpGMeOc3kSEKPKEZpUtHAeNQwLFUMBR8mZpeWT
   9PpRjKUVY+ygXTzhWUuiMj51liscLLwlDsJQSYXJdtG7l9t6ghuOXSOp3
   HJl9YP3djLwtz6A8CyIcGPprYSDslWn/9118HTaoHMgpOt/OwrEA8/LJq
   mPG4jcmqNi+FOXie4Tmsy+pBOli/3NMjIIOYD0ftoSIfvxzbkxI+B8Cjg
   TawIc9r/JBK4X/2/pqtoO9OEMpRjHdmoUWgDal0G7vL3nyJjf9jNh6oCl
   xmf5bmHqzFiSmNBHLYFBYiR7tkSVlXKrCoaAiru1VjoSFMeJ/v/uf6l6l
   g==;
X-CSE-ConnectionGUID: mxOcKTT4RT2K8DsPdHBQAw==
X-CSE-MsgGUID: 7lNy3ToFSF25WF9pSAlLfw==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="42598925"
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="42598925"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:40:58 -0800
X-CSE-ConnectionGUID: QwE7x1WjQH2Jk6kfd6ht+Q==
X-CSE-MsgGUID: /rOO1/2vRtugSBUhJaMBhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="87427138"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:40:54 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 20/24] KVM: x86/mmu: Export kvm_tdp_map_page()
Date: Tue, 12 Nov 2024 15:38:27 +0800
Message-ID: <20241112073827.22270-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

In future changes coco specific code will need to call kvm_tdp_map_page()
from within their respective gmem_post_populate() callbacks. Export it
so this can be done from vendor specific code. Since kvm_mmu_reload()
will be needed for this operation, export its callee kvm_mmu_load() as
well.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
TDX MMU part 2 v2:
 - Updated patch msg to mention kvm_mmu_load() is kvm_mmu_reload()'s callee
   (Paolo)

TDX MMU part 2 v1:
 - New patch
---
 arch/x86/kvm/mmu/mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e2f75c8145fd..7157e87c5e07 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4782,6 +4782,7 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
 		return -EIO;
 	}
 }
+EXPORT_SYMBOL_GPL(kvm_tdp_map_page);
 
 long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range)
@@ -5805,6 +5806,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 out:
 	return r;
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_load);
 
 void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 {
-- 
2.43.2


