Return-Path: <kvm+bounces-13079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C0436891681
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 11:07:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FF56286DAC
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 10:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B2D85B1E7;
	Fri, 29 Mar 2024 10:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PoO6pTnd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D8154BF6
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 10:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711706788; cv=none; b=oziOf/bg5D1PopxnFxIZFzTHZvBu8XCfRiJWdOahrwp65FxdHNZcbVl7veG+1VyGZK4QdjJaYyDVFNVOhcjcnT2isAcmQsV3m/bnUqrZKXJ903bEQPxkvw91F76EWT9MWGdsF5yRhzfNtBvVVUawFNnk/IG6rj7oHWnlyo0Yf/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711706788; c=relaxed/simple;
	bh=EAlsIr9gV/OWidz8nIWqoCkuvpdnZz9VytfSWf5d/ic=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mdtPeGhsC7OYdLi6yWB4FFwTQ7W7Bm8wSBeVYtVKdU00ZHgjBILRc4Z/Roq7kMgHgZ01lWEK/JIjt714ngRbNbjI4bhwXpVlEnIzLISNMjjt6i7igXTbsrYRYykCkm4eLyrN3WZh+W3JMvAg3QwQG3mCNsmok47eb5IdzAmKEmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PoO6pTnd; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711706787; x=1743242787;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EAlsIr9gV/OWidz8nIWqoCkuvpdnZz9VytfSWf5d/ic=;
  b=PoO6pTnd4VuNsTMGlKft80XFRRhTWD0sXFtWQSgA4j2I2eDt6p9Mx2t/
   omVACRxWvWVIiUTw2i9H4X3q/axq2Ju2aYR+XngFoA9Mn//791JNAAfYU
   4r76NNkZ6/ezligjTESaGZZ/P9L3QQlkVv+LsOcXP1463Ma6tWTT4y8R5
   wgEzJGRA1rIyUBiv9TH+5r4S/nREW36zhe6AAtb1G9qDvi6ALyiSc7DeR
   ItsCdTBNrQwljYa93dAMOu3QDiuMRToaYdzivdLJuGMRgIjVVlqifsfBy
   9EORC5hMNiE5LG8lzF0+guhvUooNRYtyzENANJAGm8GaSdAJTDuNbmwDV
   A==;
X-CSE-ConnectionGUID: AyrUCFovQi+ZC7DAghDBrw==
X-CSE-MsgGUID: rhLrSWlSSq2erXMulSf16w==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="17519244"
X-IronPort-AV: E=Sophos;i="6.07,164,1708416000"; 
   d="scan'208";a="17519244"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2024 03:06:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,164,1708416000"; 
   d="scan'208";a="21441989"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa003.fm.intel.com with ESMTP; 29 Mar 2024 03:06:24 -0700
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Tim Wiederhake <twiederh@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH for-9.1 7/7] target/i386/kvm: Update comment in kvm_cpu_realizefn()
Date: Fri, 29 Mar 2024 18:19:54 +0800
Message-Id: <20240329101954.3954987-8-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240329101954.3954987-1-zhao1.liu@linux.intel.com>
References: <20240329101954.3954987-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

With the guest_phys_bits and legacy_kvmclock change, update the comment
about function call flow.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/kvm-cpu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index 753f90c18bd6..5b48b023c33b 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -60,7 +60,10 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
      *  -> x86_cpu_expand_features()
      *  -> cpu_exec_realizefn():
      *            -> accel_cpu_common_realize()
-     *               kvm_cpu_realizefn() -> host_cpu_realizefn()
+     *               kvm_cpu_realizefn()
+     *                       -> update cpu_pm, ucode_rev, kvmclock
+     *                          host_cpu_realizefn()
+     *                          update guest_phys_bits on Host support
      *  -> cpu_common_realizefn()
      *  -> check/update ucode_rev, phys_bits, mwait
      */
-- 
2.34.1


