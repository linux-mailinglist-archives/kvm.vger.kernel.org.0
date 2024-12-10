Return-Path: <kvm+bounces-33364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 98F3F9EA3E0
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 01:52:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69142188A37F
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E640226164;
	Tue, 10 Dec 2024 00:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cOH3Rj4e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049912248B6;
	Tue, 10 Dec 2024 00:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733791725; cv=none; b=JEfWQ7pDaNIjfqnI4Yf5SemTmDNQbPlWBtBCXd3B9B/MglZRgWRyu3SyYmYVkqBvnZ8A825uEUH5YSXWTBCtutpzRysbSlCC6FmfUVjKTtSPz6NJYjVZUPWXZVeT9EZOVwZeZYYuHhtiDGxMpURtlu/xi7e2tcxIuquRznfp+eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733791725; c=relaxed/simple;
	bh=SSrfpZufJZ+LgQYUKOwSmGT0aapFamc5o1VENM+ecPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdA35FOgiOm30rQ7kIa9/rDyqfqV/JZPh5FGUpM5+KbOGxXiAyoYyHMv0HafRN+STo8jNYbpfv3dpoHoV+vdj4T4ZzpMA5N58EY6kiB3lvFDik3Cjmx5OlrMTs7ekZj74VLOtQ9D4JzUTS6zRilz9Vnept0f84GpdaL6xLp7CxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cOH3Rj4e; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733791724; x=1765327724;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SSrfpZufJZ+LgQYUKOwSmGT0aapFamc5o1VENM+ecPY=;
  b=cOH3Rj4ebPYHE/BAB0xvTmyGl9cO2Kod83AWQ/2DGW/pdGJz4i88RFKZ
   H9qLqX17oBpvrJXcy3pbCAyfzORdXV32b2VKrTN3nrfRcJwfmO7QSs259
   HuYMu+2D8BQcQXaMheM1tvZadgVJCK+RmeOAw+FLhfghb0/3djIL1bJNd
   XyWbHwAPrbjI9w/4WAK035qenOujhiZu3NLNSHnxGCTIj6uYX9DfBlifE
   5USMAHLx+t4ZockwwJvdnJtqFbAvBBaryYsXV3qKlcdkzP+CwnD0ZWZqH
   QBbHWnNY9HEdH2h/E5PknQBTmKCsaow0STHjg3/mxfpjphvUhUC8tWPZ2
   g==;
X-CSE-ConnectionGUID: MVJLqqVfREGRvSJnvBN0cQ==
X-CSE-MsgGUID: x1Bt/tQ5QWGT/AUm/Ati7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="44793780"
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="44793780"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:43 -0800
X-CSE-ConnectionGUID: Bl4QXkcSRySFaOGaszrVXA==
X-CSE-MsgGUID: bRG8LA2dSjC7wOiWQ8rclQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="96033091"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:40 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 15/18] KVM: TDX: Ignore setting up mce
Date: Tue, 10 Dec 2024 08:49:41 +0800
Message-ID: <20241210004946.3718496-16-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
References: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because vmx_set_mce function is VMX specific and it cannot be used for TDX.
Add vt stub to ignore setting up mce for TDX.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/kvm/vmx/main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 81ca5acb9964..01ad3865d54f 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -814,6 +814,14 @@ static void vt_cancel_hv_timer(struct kvm_vcpu *vcpu)
 }
 #endif
 
+static void vt_setup_mce(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_setup_mce(vcpu);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -973,7 +981,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.cancel_hv_timer = vt_cancel_hv_timer,
 #endif
 
-	.setup_mce = vmx_setup_mce,
+	.setup_mce = vt_setup_mce,
 
 #ifdef CONFIG_KVM_SMM
 	.smi_allowed = vt_smi_allowed,
-- 
2.46.0


