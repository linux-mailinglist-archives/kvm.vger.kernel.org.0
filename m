Return-Path: <kvm+bounces-45933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45348AAFE84
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:11:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8897F3B07B6
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E89D27A477;
	Thu,  8 May 2025 15:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j5G9MOyj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341232853EF
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716789; cv=none; b=XKwz1SExQjMhWAb/vHKcg2dUD2YqjhPUO0UsJtwib0Team3cwHuXevC/0sypvlGBAQptUfbunWURqP8G/Y3x3nZCqa/tDy0XMNJJhYJHSspzKdP6ElFQjpStWILWyoEmCTg3sQhAn+wDr+MUBHe2ChzBXKWl45slO73RIVmIINk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716789; c=relaxed/simple;
	bh=kcNZXKELI150GHQdC8+dN8KzuEUlLn8C0fwinm/hIEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cs14xcuJbi3tijax29w2iWZCYvLzmtVCejVKzilofOQiBRaFbr+/6QEfLjbKZs/Rpjt++hUuv9s0Zwlr1s/eTB8d/mstGerueoiV7PKlgSvRJGaPuIUz76K0Yofz+msr862OkrTyL8uw/1qzOu88M3Fo2GJc0vF2BZ4ItgKuw1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j5G9MOyj; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716788; x=1778252788;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kcNZXKELI150GHQdC8+dN8KzuEUlLn8C0fwinm/hIEo=;
  b=j5G9MOyj4pC18wkMdHFkC/QZlgKMR8J0dywbmkmnBtL0K43tk6sMjFiB
   6srQLnAuwV7EOZnk20DR7G9vOr3txcwppTbCw/yiDI7eEQDqLjjeyoQSJ
   UeCIf4z47Xn3WVA7GLw5F/S4mqsPbGhWoF4RDA0rg7TTnyQCM1XfQi0NO
   N1tcR6Xem4SRHd6vSNnQgeJ0SgLgJncCmAKo/OZY6aiwYKFjD6jA5I9wu
   BegDjMa06wutV5uPnYEf4JXPJHMGdGnZ1cfkyzvraFvzBv0FqGJ/UMk+i
   Ki/yczfvamRQ7Lj/HtSOSDdhOiFntdmaNS0BCSL4hSA2HXW/amqv5TbNo
   Q==;
X-CSE-ConnectionGUID: G+yQ9PNfSbS0/u33N/yvFQ==
X-CSE-MsgGUID: OYanfwUvQLyEVb1vXUi0CQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888268"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888268"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:06:28 -0700
X-CSE-ConnectionGUID: meB6+S9FSNuOXaTjGAxwGQ==
X-CSE-MsgGUID: I+OWwCUzS2WzW8SKiQ5M1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440115"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:06:25 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 30/55] kvm: Check KVM_CAP_MAX_VCPUS at vm level
Date: Thu,  8 May 2025 10:59:36 -0400
Message-ID: <20250508150002.689633-31-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM with TDX support starts to report different KVM_CAP_MAX_VCPUS per
different VM types. So switch to check the KVM_CAP_MAX_VCPUS at vm level.

KVM still returns the global KVM_CAP_MAX_VCPUS when the KVM is old that
doesn't report different value at vm level.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 accel/kvm/kvm-all.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index df9840e53a35..5835d840f3ad 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2425,7 +2425,7 @@ static int kvm_recommended_vcpus(KVMState *s)
 
 static int kvm_max_vcpus(KVMState *s)
 {
-    int ret = kvm_check_extension(s, KVM_CAP_MAX_VCPUS);
+    int ret = kvm_vm_check_extension(s, KVM_CAP_MAX_VCPUS);
     return (ret) ? ret : kvm_recommended_vcpus(s);
 }
 
-- 
2.43.0


