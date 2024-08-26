Return-Path: <kvm+bounces-25021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6701E95E6AA
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 04:21:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 068A31F215C9
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 02:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F4F5107B6;
	Mon, 26 Aug 2024 02:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XZKfZsJ9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E7AB652;
	Mon, 26 Aug 2024 02:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724638875; cv=none; b=BMZJWjIUgZnU7QQWNAQmi+iVlIMu+di4WeEB5OceFwPA+rHaoHpQ/zf1vXUsRavorovvG76gAseZplRrP0NJ6jZWj+P5B6MA9pw4DF2nGxzp5bOAoTOM1u6I0UuA3dsUoLiLLOxH95gkGqib+iuSCLtv79GTUxxReB6yD0Hv1/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724638875; c=relaxed/simple;
	bh=gDkIYgNA465raiQLMsxlKnOu34b4eN4oTZlq6jeFGMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMz1wgNIiK7YmrEiEWftCZ2mpHenAmdFYi/YcYr+Rk1wq5+j0nYSnbjrNBLr5+nYmuBfhVH7IhfOJB63qByzNUtIHXk+duLIU5X7KBHitVvtjs4PLNkGdO1hJF3iR3HO4pjotZuqznljSIe7e9h0bTtfrlYaT1yl2hnBPkIVNQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XZKfZsJ9; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724638874; x=1756174874;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gDkIYgNA465raiQLMsxlKnOu34b4eN4oTZlq6jeFGMI=;
  b=XZKfZsJ9T8OLO2rPee0h/xaqeOlUSf4gjIh8Ex7n75OwY4G3w2x3zoFg
   phj4If6OpnY4yXC4sYL62UgU/syjJC4V8/KrxYnEwe9nz8TY7DVzWcd3z
   pyMt/zwcGeOJPuMEgdhkZ/VV+KkNAHTHXS6FxQXHNQn1gOVcZIVaLZ46z
   kYjW+zd5Q8NRquAkp/ALf1kSqZofctQmST+fxogmZfSvTZS/J+E+tnFF3
   +Xu0xVCJUV1GZ5ORbo9Isv5SzF06a99sgR4yb1raLQNLXRWWkXlsXv5bL
   g9FssG6KRhgNZ0ICJ5K9oiEqakOnNRhWM297+p9RwmgObo8Kp0hUU8+qE
   Q==;
X-CSE-ConnectionGUID: MfYrrEEXRUiPHqbamV8ZIQ==
X-CSE-MsgGUID: aZPJFlIhRKmgFliypejUeg==
X-IronPort-AV: E=McAfee;i="6700,10204,11175"; a="23207992"
X-IronPort-AV: E=Sophos;i="6.10,176,1719903600"; 
   d="scan'208";a="23207992"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2024 19:21:14 -0700
X-CSE-ConnectionGUID: dd60saCESimENrwD8sCldg==
X-CSE-MsgGUID: tlpBx/czRo2YxGqo6gp2Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,176,1719903600"; 
   d="scan'208";a="62336548"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2024 19:21:11 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	isaku.yamahata@intel.com,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	yuan.yao@linux.intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com
Subject: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace generically
Date: Mon, 26 Aug 2024 10:22:54 +0800
Message-ID: <20240826022255.361406-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240826022255.361406-1-binbin.wu@linux.intel.com>
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check whether a KVM hypercall needs to exit to userspace or not based on
hypercall_exit_enabled field of struct kvm_arch.

Userspace can request a hypercall to exit to userspace for handling by
enable KVM_CAP_EXIT_HYPERCALL and the enabled hypercall will be set in
hypercall_exit_enabled.  Make the check code generic based on it.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/x86.c | 5 +++--
 arch/x86/kvm/x86.h | 4 ++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 966fb301d44b..e521f14ad2b2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10220,8 +10220,9 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	cpl = kvm_x86_call(get_cpl)(vcpu);
 
 	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
-	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
-		/* MAP_GPA tosses the request to the user space. */
+	/* Check !ret first to make sure nr is a valid KVM hypercall. */
+	if (!ret && user_exit_on_hypercall(vcpu->kvm, nr))
+		/* The hypercall is requested to exit to userspace. */
 		return 0;
 
 	if (!op_64_bit)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 6556a43f1915..bc1a9e080acb 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -561,4 +561,8 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in);
 
+static inline bool user_exit_on_hypercall(struct kvm *kvm, unsigned long hc_nr)
+{
+	return kvm->arch.hypercall_exit_enabled & BIT(hc_nr);
+}
 #endif
-- 
2.46.0


