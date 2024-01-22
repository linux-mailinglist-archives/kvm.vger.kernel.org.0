Return-Path: <kvm+bounces-6629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 791CF8377F7
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:03:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC6F41C23DEB
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:03:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0391061668;
	Mon, 22 Jan 2024 23:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L3FMyFXf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D55060DE1;
	Mon, 22 Jan 2024 23:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967745; cv=none; b=j8FypF60Y2pqqsa5BOWtWVnSELcHYEXHFmuX+nSOXw7+wTUHDUFySaPd0UuvV7VJH0nDNLn7b0JxdxAgMODya1zF4YpQkTaXxujfj38HxuZFSKoBR6vOEVRe1IQ/eWbMVNRisBFVJTEMsITdgOGYQnu1YH+pB40Cq/JNnT0Pxp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967745; c=relaxed/simple;
	bh=4SCW6Dkj/Vj+qX6sWycKS9/fk9MJ8AKVtZUkBL10lrs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FnCys5LO2uEEeCH09QG4yEC1gQ17Ubj4ImQLfyZJh4YjsADUIopCQk56V3q3yAUB1Yocx6iqgrW7PXxwOPRpFpPSw4QdKkkYFVuj3n005ZGgwHL2mEzyqi/wyUWT+kg1bBe9if2WBUKpYSEG8zlBFPXnANSClrJ69lIzRGWMhkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L3FMyFXf; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967744; x=1737503744;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4SCW6Dkj/Vj+qX6sWycKS9/fk9MJ8AKVtZUkBL10lrs=;
  b=L3FMyFXfPXlrxLIYRC0hLqC8qWne4m4Im7ichWfeA0OQxDGq+SU4UL89
   S031kmXc3L/Wrb1H7g9HNd29nM0+7DtyGrwUTQWKaCPtYSATt+2TKYzmw
   NWZWdxwbMLO/6DyMqNlb6RSFgBeruQEMTpBKSptpUrcpxVwS8haKtvK7A
   qk9+eu17GZjtDeBZv2dRhM37sNdXSxaC8xxtgj4s0TwUoMYL9IeHq4rKB
   AXYu5lmD6/v5kdGSoGdy2r/sqMp238XH2G5ow5ddkbXYPI20rjCsebclt
   KERSjNxqNWizkfiD92VBIummSzzkFBu2f51dirNn3ZZEQn5bf8asylK0v
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="8016409"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="8016409"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1468155"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:33 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Yuan Yao <yuan.yao@linux.intel.com>
Subject: [PATCH v18 053/121] KVM: x86/mmu: TDX: Do not enable page track for TD guest
Date: Mon, 22 Jan 2024 15:53:29 -0800
Message-Id: <ba65644eb8327600c393bc3a3dc71c49e872d29f.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yan Zhao <yan.y.zhao@intel.com>

TDX does not support write protection and hence page track.
Though !tdp_enabled and kvm_shadow_root_allocated(kvm) are always false
for TD guest, should also return false when external write tracking is
enabled.

Cc: Yuan Yao <yuan.yao@linux.intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/page_track.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index c87da11f3a04..ce698ab213c1 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -22,6 +22,9 @@
 
 bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
 {
+	if (kvm->arch.vm_type == KVM_X86_TDX_VM)
+		return false;
+
 	return IS_ENABLED(CONFIG_KVM_EXTERNAL_WRITE_TRACKING) ||
 	       !tdp_enabled || kvm_shadow_root_allocated(kvm);
 }
-- 
2.25.1


