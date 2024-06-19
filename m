Return-Path: <kvm+bounces-20018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78BE290F912
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 00:37:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F1971C21ACC
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 22:37:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA7C15CD40;
	Wed, 19 Jun 2024 22:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ixGXKro9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3A31586C2;
	Wed, 19 Jun 2024 22:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718836586; cv=none; b=d2vfZXZKKphG7mYkB9f2Lq2i/YDwfCPMLv4YC6gIlkTxKDSSr0p8RoAQJAK8/uxdpEtDvZ2ahRx9S4SpyrjpfPkgz4muPcGx3t1agKYM/fmR80J/PIWJeyKeOoi1sj/Ny/g+c0js31n37FVwey5x1PzGT7QRc5K6QG89s0c39Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718836586; c=relaxed/simple;
	bh=VX7MgdwvWo75LHOu/OQNQG0ISrnE2BQomr6o4j/J3Gs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nP5o2LLdeYeNuLhPKMokqJ8T2Xh0VFyGw+/Tj4DNkevdPOmeWQhg4l0eEQq9TkW0c+vV6mAXkBOvNPRlgrJDRvjzPh0+9t/VR1jTDx2U0bvsnUkY52k9hcb5eOzuhWnqmUIhyL92n2t7nZKVYbpi6TEe2cTstnZm0ar1legPuTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ixGXKro9; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718836585; x=1750372585;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VX7MgdwvWo75LHOu/OQNQG0ISrnE2BQomr6o4j/J3Gs=;
  b=ixGXKro9kqtJaSR1lwDAq8LLHktjvxZ/yEVV/yGZjUikC/p0yUNIi6CT
   3w5BKBS8lo1I/BI0qxINBKY0HMWWJKoLyGtuu8AkdUrdzA2NwF44VcVXq
   /ZCERcUWOU3rbXvQWlFmgVdli9wnxW2g3anUMupqBI/0Gumq/zMHjbZ9I
   YXiSzFV4NLk20MV5SUFJ5cyUA8y33gMA4cYHSHmzZnh+jDChB32ilVIgx
   d6iONGbl64u7LUcQlhVyh0jupdcb3I+ESJ6gIUe3BZGDV2NZ8U2DjkNDK
   ZLuoqQ2yWQVSiGZjzVK18rcXmDMNP64BqjFWuwclrs/oXz4JrCtBv+pUB
   g==;
X-CSE-ConnectionGUID: exx6xEuRSXC27ZObQI6cgA==
X-CSE-MsgGUID: H8yA1iixRRyE+8HdPwk32g==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15931932"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="15931932"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:21 -0700
X-CSE-ConnectionGUID: vbBWgEatSFGdz9NPCK4rqw==
X-CSE-MsgGUID: gm9ah9tOQOGlqM1akfEqiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="72793325"
Received: from ivsilic-mobl2.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.54.39])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:20 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	erdemaktas@google.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	sagis@google.com,
	yan.y.zhao@intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v3 03/17] KVM: x86: Add a VM type define for TDX
Date: Wed, 19 Jun 2024 15:36:00 -0700
Message-Id: <20240619223614.290657-4-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a VM type define for TDX.

Future changes will need to lay the ground work for TDX support by
making some behavior conditional on the VM being a TDX guest.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep:
 - New patch, split from main series
---
 arch/x86/include/uapi/asm/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 988b5204d636..4dea0cfeee51 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -922,5 +922,6 @@ struct kvm_hyperv_eventfd {
 #define KVM_X86_SEV_VM		2
 #define KVM_X86_SEV_ES_VM	3
 #define KVM_X86_SNP_VM		4
+#define KVM_X86_TDX_VM		5
 
 #endif /* _ASM_X86_KVM_H */
-- 
2.34.1


