Return-Path: <kvm+bounces-6900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A7E383B73A
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:40:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA793B228F3
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 02:40:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B018B6FA7;
	Thu, 25 Jan 2024 02:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jUXv4Dvw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591B97475
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 02:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706150427; cv=none; b=nSv1HvwdWlPhs3WHurMz1xC4yXD9mBjNXnea0D8w5QtRJvD0AJX+hC0Dn3MjNH/1PUdK+MlNIqNC6pUqubBcfWTnV4efqUwHZ8CZJmDj4hsJ/YGcM/kSDPvMD5EIYNweyIqwabH3gZgfCRAUKlOYSzHgs/YwnlWaaaBgNjLi+u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706150427; c=relaxed/simple;
	bh=zCSUWz6x4CYmJnL/NhcGx17babqI2D0aVpH7noNHZvM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NXukeOUqGEPZ4yOGS+1X4dpXsXwipLOqLqlrC2+Gjr938fZ0EFCl/4tDgYuR9lx08ospiYV/r5CfxCrs3x9pqrGJ3Ssq2Yigkii/gG4cYSGoh6Q69aU48D3RU9LUZcB7GSAr2CvRGH2ESgcVovJagFxIp0VnIPk9U5TlcSHirzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jUXv4Dvw; arc=none smtp.client-ip=192.55.52.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706150426; x=1737686426;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zCSUWz6x4CYmJnL/NhcGx17babqI2D0aVpH7noNHZvM=;
  b=jUXv4DvwtJeKz5hRdSEPGWNSm/RszoAnEj8U/ulSCWfgqgZWPwriwziY
   oKJFMheyKzXGh1dl6MAvgzshj4YWSblN3zgM6iiI3m0fBuy0IqZll7HDJ
   1AdpOgHbyDa0SinW9jrsN0MGY7pd0rbGpslk885JU5j7TPwhexz1RtduY
   MPHDoJ/Z1QJdfyIqYd/3eY2z6Z2GkCaBR7HnrJn+1XqeXLaLgXCskryuL
   0XLOKXYbbunA8+XEiIfvIjPlhsDZumHrNNFyIslhKZB0s9F7L9zBavaQq
   QHpstOMmKk0w/Ts/hLqEppR0c1xCQSs/5ImXQZI1ZZ+wpMpcU0e4y2cqy
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="401687462"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="401687462"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 18:40:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2120537"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa003.jf.intel.com with ESMTP; 24 Jan 2024 18:40:24 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com
Subject: [PATCH v3 3/3] i386/cpuid: Move leaf 7 to correct group
Date: Wed, 24 Jan 2024 21:40:16 -0500
Message-Id: <20240125024016.2521244-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125024016.2521244-1-xiaoyao.li@intel.com>
References: <20240125024016.2521244-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CPUID leaf 7 was grouped together with SGX leaf 0x12 by commit
b9edbadefb9e ("i386: Propagate SGX CPUID sub-leafs to KVM") by mistake.

SGX leaf 0x12 has its specific logic to check if subleaf (starting from 2)
is valid or not by checking the bit 0:3 of corresponding EAX is 1 or
not.

Leaf 7 follows the logic that EAX of subleaf 0 enumerates the maximum
valid subleaf.

Fixes: b9edbadefb9e ("i386: Propagate SGX CPUID sub-leafs to KVM")
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 9758c83693ec..42970ab046fa 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1951,7 +1951,6 @@ int kvm_arch_init_vcpu(CPUState *cs)
                 c = &cpuid_data.entries[cpuid_i++];
             }
             break;
-        case 0x7:
         case 0x12:
             for (j = 0; ; j++) {
                 c->function = i;
@@ -1971,6 +1970,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
                 c = &cpuid_data.entries[cpuid_i++];
             }
             break;
+        case 0x7:
         case 0x14:
         case 0x1d:
         case 0x1e: {
-- 
2.34.1


