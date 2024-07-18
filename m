Return-Path: <kvm+bounces-21884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 714D79352F3
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:13:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19A511F21262
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C32BA146596;
	Thu, 18 Jul 2024 21:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HGFFbJoZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCEF145B39;
	Thu, 18 Jul 2024 21:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337165; cv=none; b=rRV87llL//1E/D/B0pXkLVK3sLIKcVmQ8L48beKoiKD48RM2YZ+aKA2wwpbXqFDXmFbVS/pkBUhUrPOl3xg/UmkItZWPL1sWHcgVP9l1tKPqmcxiWVahesawzmWQHnGMDmaZu+gf+cKHwIcMpRwZ57FnGwcVaP4G1tQOYgDP1Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337165; c=relaxed/simple;
	bh=jlzNRd9yJWKf8+sv7l4/9XzebBJzfl7ldvWG3ZHyncs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iTx1IdFmXWWryWDthkbnFk9ptgpyRCddusTUk7u6b+rLb+DZGz9BQykjl9SFEPXpmfdmO5BsfyMGiQqTutFQVuRiEfzOVuWVx5QVx72Iw6ThOrlvub2tiYf7IekADeyYZRSdgSp081gm903ztBR3xNoFmhoNw2SCdCbukl9BTJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HGFFbJoZ; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337163; x=1752873163;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jlzNRd9yJWKf8+sv7l4/9XzebBJzfl7ldvWG3ZHyncs=;
  b=HGFFbJoZ1BeJ3lkNS55YoV06uI5lc/CiFAMvfTsjIv5sCghp5x5F5KTS
   5/Dj4NmeHqAkuQOi6+Wp8o1HqT4yX5t/nueBlVy/JFqptBev0C5q387D8
   Nh+xFXGUMQ/yzol8M3YC9KE4dGf+7JAI6RDD4zaw/PRXMDtHb3ke7VVLV
   AokItkiGWzXVOAas5RSTIK7ORUStz5gDtAh7bL9Csa4Fw8mRxIX00178P
   kLYtx8Pq2gf6bv56p2LfASRpzmNMiKNzNe4xsPMWWpnfdmscefUyQyEFR
   ArbHxuLTtVkkffJ2vr2lSm1QA2jM/AEOMvUw39/B/L//6C5S9+WkIYh9I
   A==;
X-CSE-ConnectionGUID: 5ocLfUbvREqmMTltYvTzjg==
X-CSE-MsgGUID: 65HtxbJ1Rx+4tFybQMQkwA==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="22697397"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="22697397"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:42 -0700
X-CSE-ConnectionGUID: kCeNH2AdQUGJ2Q2Ki7R7ug==
X-CSE-MsgGUID: 6wyZUJo/TzajtobkjbkSCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55760374"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.76])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:42 -0700
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
Subject: [PATCH v4 03/18] KVM: x86: Add a VM type define for TDX
Date: Thu, 18 Jul 2024 14:12:15 -0700
Message-Id: <20240718211230.1492011-4-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718211230.1492011-1-rick.p.edgecombe@intel.com>
References: <20240718211230.1492011-1-rick.p.edgecombe@intel.com>
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
v1:
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


