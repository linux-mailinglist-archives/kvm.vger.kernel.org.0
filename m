Return-Path: <kvm+bounces-35264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 698B9A0AD59
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 03:14:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFB9E3A73BD
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 02:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1987B13B7B3;
	Mon, 13 Jan 2025 02:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Metkzc//"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8BF13AA31;
	Mon, 13 Jan 2025 02:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736734456; cv=none; b=AKXAwhiIOnSLt9BCPEjBntDbWHH3FZszTgKV2/z/XyfH5eIIDyAJUQlMN0Hgiv5yQ1zTTUBaVWDiL4xYI7tq2l8pO95pg0S9jdHOT3irzg7CBnbDvjZHmyLvE6ruxB8uHaGd05UZ+GULMYotRTWl4z2EAQAiL5JecVt2rOyPbuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736734456; c=relaxed/simple;
	bh=Yo94CZ4CaF1GQd0v5DxVQiaUOfdJ2d8gBEykvkzaxyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBci0cv0CSNDhPbqzoSL1KUGF2fBHYE0nmHO2ClSXOy1zU4wfkFupSO9GKqSL1Z9aTXRdMfLMkIoRN2J2i46zvKkxJlfMzM0Q8xJe/gYS9I1H1ktLOBFkzn+Cqb3E4ZTZ6GjDvHGMcb1qwR7Gl7mVpylg0/ZXdMkUZoyER1C9Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Metkzc//; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736734454; x=1768270454;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Yo94CZ4CaF1GQd0v5DxVQiaUOfdJ2d8gBEykvkzaxyc=;
  b=Metkzc//D837znoamn+8HlxXiK0CtYuMjxbegewnqlsS9Z0U5eEFPLil
   pB3LH0tRqip8sJ4zfaCU/75oZl9e6s02BnyUKSEwehtFqhWVqzbHYnXHT
   lpR1mK0WLrCjtenDWXXP3kB4c8cv4Ub4//u9Y4MVNHqYWGaEtAynJIMrG
   JiwTlx1Rgvf8cPtpe9Shz2SQQrUxKX4KGlbDFMYhsvfqEQ90gHCRLr98d
   zJOEQlcRJXq9qD4hbzhdrO/JpDonAdykecZ7hWduu0txkgH95whZFyoyp
   RIfsp69iIu4FvqYj4ZrBvt4EajLP0xn5dQ5C1cwdFqeIdsf2wBgYXoYj8
   Q==;
X-CSE-ConnectionGUID: 1fqqz6iuT5GzD6qqiu+SUg==
X-CSE-MsgGUID: J3aI7pGVSjaTiEpqJOm2rA==
X-IronPort-AV: E=McAfee;i="6700,10204,11313"; a="36996197"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="36996197"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 18:14:13 -0800
X-CSE-ConnectionGUID: DYPgB1ycQ9qtX02VgTbI5g==
X-CSE-MsgGUID: YVbNIw/ZQS+vhMAQXBpxvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="104896593"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 18:14:10 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com
Subject: [PATCH 7/7] fixup! KVM: TDX: Implement TDX vcpu enter/exit path
Date: Mon, 13 Jan 2025 10:13:22 +0800
Message-ID: <20250113021322.18991-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250113020925.18789-1-yan.y.zhao@intel.com>
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Warn on force_immediate_exit in tdx_vcpu_run().

force_immediate_exit requires vCPU entering for events injection with an
immediately exit followed. But The TDX module doesn't guarantee entry, it's
already possible for KVM to _think_ it completely entry to the guest
without actually having done so.

Since KVM never needs to force an immediate exit for TDX, and can't do
direct injection, there's no need to implement force_immediate_exit, i.e.
carrying out the kicking vCPU and event reinjection. Simply warn on
force_immediate_exit.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index baabae95504b..0e684f4683f2 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -999,6 +999,16 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 		return EXIT_FASTPATH_NONE;
 	}
 
+	/*
+	 * force_immediate_exit requires vCPU entering for events injection with
+	 * an immediately exit followed. But The TDX module doesn't guarantee
+	 * entry, it's already possible for KVM to _think_ it completely entry
+	 * to the guest without actually having done so.
+	 * Since KVM never needs to force an immediate exit for TDX, and can't
+	 * do direct injection, just warn on force_immediate_exit.
+	 */
+	WARN_ON_ONCE(force_immediate_exit);
+
 	/*
 	 * Wait until retry of SEPT-zap-related SEAMCALL completes before
 	 * allowing vCPU entry to avoid contention with tdh_vp_enter() and
-- 
2.43.2


