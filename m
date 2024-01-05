Return-Path: <kvm+bounces-5716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C5F9F82511B
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 10:45:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D1BD1F24876
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 09:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA47924B36;
	Fri,  5 Jan 2024 09:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fnuyo02r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FE8249E9;
	Fri,  5 Jan 2024 09:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704447943; x=1735983943;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Ipngyt99PQBot25YTtxsZ8y9PD4Q1alyU7StkGQNfLY=;
  b=fnuyo02rSKwwPWrsZFROs7v/XHn9dr5YDWhie/bbv5+7sNUQx1Kx9e6t
   3pLdO95MBos9DmdsTw9bWomhj2XsM4LXWvOp4ESTBClk0nPmgXyZEmYVB
   WsqbHUHC5qjLzn4RJAjG/+1rFx6kjrqfKp2cafqu797EewAd5/VZQ0bHH
   CdVekDRYa96g6968LeqNeZEdIBIWn9vizSVeuNERsZEECkbH5rNvkhax+
   98yPQ0dNV7CPZe/p9plKBOir7VhYDbSlHeSkll9bjjLr1wChGshvdFwYh
   /t3CV6Oxx1nD7ok1wy4E0WJqIweTnd3o1nmexXLUkHq/89ACpKIAPKsFt
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="10959501"
X-IronPort-AV: E=Sophos;i="6.04,333,1695711600"; 
   d="scan'208";a="10959501"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2024 01:45:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="784158335"
X-IronPort-AV: E=Sophos;i="6.04,333,1695711600"; 
   d="scan'208";a="784158335"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2024 01:45:36 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	olvaffe@gmail.com,
	kevin.tian@intel.com,
	zhiyuan.lv@intel.com,
	zhenyu.z.wang@intel.com,
	yongwei.ma@intel.com,
	vkuznets@redhat.com,
	wanpengli@tencent.com,
	jmattson@google.com,
	joro@8bytes.org,
	gurchetansingh@chromium.org,
	kraxel@redhat.com,
	zzyiwei@google.com,
	ankita@nvidia.com,
	jgg@nvidia.com,
	alex.williamson@redhat.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 4/4] KVM: selftests: Set KVM_MEM_NON_COHERENT_DMA as a supported memslot flag
Date: Fri,  5 Jan 2024 17:16:24 +0800
Message-Id: <20240105091624.24822-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240105091237.24577-1-yan.y.zhao@intel.com>
References: <20240105091237.24577-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Update test_invalid_memory_region_flags() to treat KVM_MEM_NON_COHERENT_DMA
as a supported memslot flag.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 tools/testing/selftests/kvm/set_memory_region_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 075b80dbe237..2d6f961734db 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -335,6 +335,9 @@ static void test_invalid_memory_region_flags(void)
 
 #if defined __aarch64__ || defined __x86_64__
 	supported_flags |= KVM_MEM_READONLY;
+
+	if (kvm_has_cap(KVM_CAP_USER_CONFIGURE_NONCOHERENT_DMA))
+		supported_flags |= KVM_MEM_NON_COHERENT_DMA;
 #endif
 
 #ifdef __x86_64__
-- 
2.17.1


