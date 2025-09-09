Return-Path: <kvm+bounces-57070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D147B4A86E
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:42:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5CA24413D3
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:41:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03B7A2D77F5;
	Tue,  9 Sep 2025 09:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eTweojpi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2B32D2497;
	Tue,  9 Sep 2025 09:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757410801; cv=none; b=cjoKfriD+eTyteLg4mDh29uxMfFkamsvbMXuS6W66rJQ9s9eMwTI8b2V2c3lyo8TL7K6VMVS/vEZ1GAwkZOY8/7ey2Yq+dbcA5gQSM80tM3dOG7kBMldukJ8iYZcgSuIdakvB54YxXaR9YhHLvksHxcKKiJzjhhF/cvkqC4c6Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757410801; c=relaxed/simple;
	bh=2ft90euX3bzvoT6s9AGx3txhkNGWAbWMVK/aTnFoX5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMK2T4a/mfP/uMuLjUaTamCEWTqs5pSGn/5WOXfyC47po2ujD31ITeqZr2YB66oG27A1R6049x22Mql6pbl3gj3KopOd70dG50hzlDNmsS8Hp4Hw281nfkVP4tRAQOJB+Ikt255ZVkClgnNgnO13gN2tQnDR6mX4yMa7oG7aCjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eTweojpi; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757410800; x=1788946800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2ft90euX3bzvoT6s9AGx3txhkNGWAbWMVK/aTnFoX5U=;
  b=eTweojpixyMN/Dnt9uVJGehpQHAy1FOhtGNuPQ33ddGDkGKVzshi2lzJ
   MZ7FMksu2w+MXR6yhEPI+ZFBqM2nF6uz06WXUGMdlPw6clUuBV0u+mS7B
   Qdrt/UlW1hlwjR/p4fYKbA8c18WQJr31p241VcODuiIE5uBT5Kuj1NKoS
   oud2jdZacGYGT6sUPftXr7DWjqpOtazz33IAw4bqICwY/fpW5JpySb4YZ
   ESSqv/+XE7rT7p+lWghB2HoxrtKfWKAABze9SkKXSLYt3UthXwETwVb4u
   xgg4cdoaP4ZuTcuJKqFcNhwuxMfV1UWFEocoBSWRmyijir9YjpkqFdIEq
   Q==;
X-CSE-ConnectionGUID: E2F6t7ZITI+M9tS4d7u20Q==
X-CSE-MsgGUID: GwAFNa5+T/yOrMGBjzacRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="70307233"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="70307233"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:55 -0700
X-CSE-ConnectionGUID: 4G47zf6pSfax5We9diDSOg==
X-CSE-MsgGUID: dsxDFZQUT06ywsFys9vVDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="172207406"
Received: from unknown (HELO CannotLeaveINTEL.jf.intel.com) ([10.165.54.94])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:55 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: acme@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@kernel.org,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	namhyung@kernel.org,
	pbonzini@redhat.com,
	prsampat@amd.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	shuah@kernel.org,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com,
	xiaoyao.li@intel.com
Subject: [PATCH v14 07/22] KVM: x86: Add fault checks for guest CR4.CET setting
Date: Tue,  9 Sep 2025 02:39:38 -0700
Message-ID: <20250909093953.202028-8-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250909093953.202028-1-chao.gao@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Check potential faults for CR4.CET setting per Intel SDM requirements.
CET can be enabled if and only if CR0.WP == 1, i.e. setting CR4.CET ==
1 faults if CR0.WP == 0 and setting CR0.WP == 0 fails if CR4.CET == 1.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7c0a07be6b64..50c192c99a7e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1173,6 +1173,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	    (is_64_bit_mode(vcpu) || kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE)))
 		return 1;
 
+	if (!(cr0 & X86_CR0_WP) && kvm_is_cr4_bit_set(vcpu, X86_CR4_CET))
+		return 1;
+
 	kvm_x86_call(set_cr0)(vcpu, cr0);
 
 	kvm_post_set_cr0(vcpu, old_cr0, cr0);
@@ -1372,6 +1375,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
+	if ((cr4 & X86_CR4_CET) && !kvm_is_cr0_bit_set(vcpu, X86_CR0_WP))
+		return 1;
+
 	kvm_x86_call(set_cr4)(vcpu, cr4);
 
 	kvm_post_set_cr4(vcpu, old_cr4, cr4);
-- 
2.47.3


