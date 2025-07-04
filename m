Return-Path: <kvm+bounces-51578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CAA9CAF8DA9
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 11:09:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E04FB4571D
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:53:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0041F2F2361;
	Fri,  4 Jul 2025 08:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MnoU+GED"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06BA2ECD11;
	Fri,  4 Jul 2025 08:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751619046; cv=none; b=YVeZ470317nxYq5FRdhwgwy6GOKvp0QwM83GjMJ3CoDh8JN2W6yxVsQyO+kWKssgvR5G13B3F6Vrd8V49Px/8wu6ze2agXD7r33ItO1T10PqzyXVJHTfETVI0tHiN/7oaEpgKgVgrFpwF9+v3FtX84fJzL+J5FzVA/LVdf75TTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751619046; c=relaxed/simple;
	bh=LK0JXrnHke4RzbHch2/4dkmsWHtIyzSt+ppk7zwetkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWGbCZQDqmLT3DUulqbyKcF0SgStZClFiLfwmrSsi+VC2PHH3yZvEds8rKp5oDqTfcWUlq2lmeqiDQvuxBYQseJzL6wS5Y8oHi/uAVbgKW+spULifEnychUJTz/lku0itg8UIIpECZ2+A0jDA6KavbC7KEICaIiWZBEpM0ovqJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MnoU+GED; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751619045; x=1783155045;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LK0JXrnHke4RzbHch2/4dkmsWHtIyzSt+ppk7zwetkQ=;
  b=MnoU+GEDeEAwSinujOGnlIE1Hez0e8Xt4Q2lWW02tvheSem5Q3wWdC0R
   Hute0S4eJB3OQ9ZEJUZZUkC015wb6k1Hh7qOq5ataMjfk8r2GPUaYFpC+
   BWlTagWzJQecP+BtHrbP86uFy9mCBq94SmsNXNPM9WnwIjriw/GbRlsA1
   VUUErkA9wlIFOuSIibsO5gkHMqZf98/x/jnYt8WVNEpEk1pgIl8Q/YdvJ
   ioQ4tCJD+L/HX+R07/j3a+Pw3oQHLid6aCx5J1bGP/7mRRiYhp3U+iPsJ
   HrzY1lgoXJpSu23Ij+FxtHCas3qXQEeQIkVU3PJ3n70pd1Ux6Du9F0CEb
   g==;
X-CSE-ConnectionGUID: loo76ZLASeOMieMnh5Mv/Q==
X-CSE-MsgGUID: eqAqbd10Q6OeZQKtvptAFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="79391658"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="79391658"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:39 -0700
X-CSE-ConnectionGUID: 5ONyx9/lSCu7JHZYa22DcA==
X-CSE-MsgGUID: ZE635ZqnR3COGT1oRcEFaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="154721976"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:39 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com,
	minipli@grsecurity.net,
	xin@zytor.com,
	Chao Gao <chao.gao@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v11 10/23] KVM: x86: Add fault checks for guest CR4.CET setting
Date: Fri,  4 Jul 2025 01:49:41 -0700
Message-ID: <20250704085027.182163-11-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250704085027.182163-1-chao.gao@intel.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
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
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 15169867bc14..260368ba3134 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1169,6 +1169,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	    (is_64_bit_mode(vcpu) || kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE)))
 		return 1;
 
+	if (!(cr0 & X86_CR0_WP) && kvm_is_cr4_bit_set(vcpu, X86_CR4_CET))
+		return 1;
+
 	kvm_x86_call(set_cr0)(vcpu, cr0);
 
 	kvm_post_set_cr0(vcpu, old_cr0, cr0);
@@ -1368,6 +1371,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
+	if ((cr4 & X86_CR4_CET) && !kvm_is_cr0_bit_set(vcpu, X86_CR0_WP))
+		return 1;
+
 	kvm_x86_call(set_cr4)(vcpu, cr4);
 
 	kvm_post_set_cr4(vcpu, old_cr4, cr4);
-- 
2.47.1


