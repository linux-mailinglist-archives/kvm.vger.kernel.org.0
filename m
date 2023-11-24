Return-Path: <kvm+bounces-2411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9558B7F6D79
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 09:00:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51985280EEC
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 08:00:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C9CD18041;
	Fri, 24 Nov 2023 07:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fXRbtmq9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3603B1711;
	Thu, 23 Nov 2023 23:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700812728; x=1732348728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dKuF/arCze+lNWNbIVwbb5cqE0y+kfgXSzDJUMBR+Nk=;
  b=fXRbtmq9iS0k//0VwvngbE1bXQuEEuOfmv6YR07Sq+eZGBs23qgjeUun
   xvsW+CSMvLMEU71TzAMxMopuDOI3lM/D8TpaiUa6aslVzaTV70nO4Td0e
   L7kqM+RY6qLwsAMZzr2WRU9bK5LZlDtHnfq5Kk31wfWC74EwFLNjqKXke
   wweqHftBIjJe16xWmiSQCojNbni/6bI7au8ubrAWct9cifRopcXki3DxA
   rbduMqjvGtaht04JrGrdKUhkLr5QhER6PlQZBkVfx682zMu+18wuYROWl
   SAXhEbaPt8CMlvA3K8DKVqATi6WzDZCiZWwtqOcmHusfMIB0AyDRn5fAc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="458872380"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="458872380"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="833629850"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="833629850"
Received: from unknown (HELO embargo.jf.intel.com) ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:41 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v7 19/26] KVM: x86: Use KVM-governed feature framework to track "SHSTK/IBT enabled"
Date: Fri, 24 Nov 2023 00:53:23 -0500
Message-Id: <20231124055330.138870-20-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231124055330.138870-1-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the governed feature framework to track whether X86_FEATURE_SHSTK
and X86_FEATURE_IBT features can be used by userspace and guest, i.e.,
the features can be used iff both KVM and guest CPUID can support them.

TODO: remove this patch once Sean's refactor to "KVM-governed" framework
is upstreamed. See the work here [*].

[*]: https://lore.kernel.org/all/20231110235528.1561679-1-seanjc@google.com/

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/governed_features.h | 2 ++
 arch/x86/kvm/vmx/vmx.c           | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index 423a73395c10..db7e21c5ecc2 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -16,6 +16,8 @@ KVM_GOVERNED_X86_FEATURE(PAUSEFILTER)
 KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
 KVM_GOVERNED_X86_FEATURE(VGIF)
 KVM_GOVERNED_X86_FEATURE(VNMI)
+KVM_GOVERNED_X86_FEATURE(SHSTK)
+KVM_GOVERNED_X86_FEATURE(IBT)
 
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d3d0d74fef70..f6ad5ba5d518 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7762,6 +7762,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_XSAVES);
 
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VMX);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_SHSTK);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_IBT);
 
 	vmx_setup_uret_msrs(vmx);
 
-- 
2.27.0


