Return-Path: <kvm+bounces-6768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3530F839F7B
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 03:49:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF1AE1F22285
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 02:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE82D1A726;
	Wed, 24 Jan 2024 02:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J0+cL8v9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44997182A7;
	Wed, 24 Jan 2024 02:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706064166; cv=none; b=rlxPlHzrD4ZwAYcmtjFpqWwCnuCZUYo3wHPObpIprIvd4jvNcnwlqnCZ2h3DXth+h3Yb6efae4loGl7/xS17QRG/f5ASFFS/NAd78NXsum1sHmk4bawhd8dBgWYWzddfUD9vWC3JhgDc/+dflY+wQgh8k7D4hO0KFawC9Va9voA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706064166; c=relaxed/simple;
	bh=F9opDfCZwYUSpXz1rhkoPf6Q6E9dmRJye3dTlxS+ZDs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IebQ9JGEWuStW2tHehNJ9SMqf4ljIO7KKxtAfzgnx0oZVkTT94kG4Edv95usw2iqHPKkAgz6el9JxsjGDA8Tzm+TkDhph0jBU4v5hjY1/VXogFrkN+4KNPQT4XWtEZQUcbO0gpdq0atd/Nku4Rl0J1TwEhTSsKPnPi+QMFABNR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J0+cL8v9; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706064165; x=1737600165;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F9opDfCZwYUSpXz1rhkoPf6Q6E9dmRJye3dTlxS+ZDs=;
  b=J0+cL8v9JTr26Zgfc2bvZRgmcsD2zWIn5Q4bnRewOwbziZv56MFZNfIX
   Pi5swcMhU7NHMlKOdHWoA70aQo3bXNFQbdoML5S0Vgz71T8CjPdzvMYDq
   Pe3Qp8EKEjK5EVzabcQlkwKkuOakqC4tOuW4/wfYxeQrpKHMzl/k7eQqu
   U6nqRVDN4+UIVQaMUo/N2+dA7todLcLRWYLtA+d6WtWKwpOhVEGhpBt6d
   /R1XA1JHPS0QjTwOfHQixpG5SiK/fM9FcCaCX0AZ7hUvZrdJfraLJX7hf
   EdomgjASZyc6/6Qww4y+cLZpjVsK2RK4pmswKq+XMc6cZSU7ws6szQclt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="400586543"
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="400586543"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="1825899"
Received: from 984fee00a5ca.jf.intel.com ([10.165.9.183])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:40 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	yuan.yao@linux.intel.com
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v9 19/27] KVM: x86: Use KVM-governed feature framework to track "SHSTK/IBT enabled"
Date: Tue, 23 Jan 2024 18:41:52 -0800
Message-Id: <20240124024200.102792-20-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240124024200.102792-1-weijiang.yang@intel.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/governed_features.h | 2 ++
 arch/x86/kvm/vmx/vmx.c           | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index ad463b1ed4e4..daf0c0a3e29c 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -17,6 +17,8 @@ KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
 KVM_GOVERNED_X86_FEATURE(VGIF)
 KVM_GOVERNED_X86_FEATURE(VNMI)
 KVM_GOVERNED_X86_FEATURE(LAM)
+KVM_GOVERNED_X86_FEATURE(SHSTK)
+KVM_GOVERNED_X86_FEATURE(IBT)
 
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b2f6bcf3bf9b..29a0fd3e83c5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7764,6 +7764,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VMX);
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_LAM);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_SHSTK);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_IBT);
 
 	vmx_setup_uret_msrs(vmx);
 
-- 
2.39.3


