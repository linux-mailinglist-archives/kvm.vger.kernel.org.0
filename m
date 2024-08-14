Return-Path: <kvm+bounces-24104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19C3A951600
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 10:02:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CCD71C20982
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 08:02:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634BF13D518;
	Wed, 14 Aug 2024 08:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tj5TCMNV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8263713AA3F
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 08:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723622556; cv=none; b=IQ+F5l1ejUo7NLwsN/UCNJhhxNLJYdeeKyl2JBeWWXTKEZRBsw/uXA33Jbp7+AMRLNNF0vXnBTSkc8n74YLKB0Cngq/h2plkzy2iTLHbe7nDFRf3lj+RhckaVb07F+AhnvnL+SVGpmCSqGRjPBs5kmb2TfVlvWSUq+RpOvW7X60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723622556; c=relaxed/simple;
	bh=95lVEX5CsBG7kTAIi2nQlw8g78ZvNp99dsAYOY0HpDo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z1ZRhKc/uidw8Ti5qyu7EUuXDSiw11j41qtw0Lman4ltx+UZYrchEiALXh3K16X1sdhwTL5NIp2+HelQnfk2MoQHPSglvZgulI1pDTHzlzq2ALyZFJc8Ig4Y1EyGmJF92aGODoDhsSWrQyZv7N7l07eL7DsbDDgFicxcPO6sb4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tj5TCMNV; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723622555; x=1755158555;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=95lVEX5CsBG7kTAIi2nQlw8g78ZvNp99dsAYOY0HpDo=;
  b=Tj5TCMNV2lRVL+uJB1LpS6aiYZeG4VXLTAmgv+Lpv56+6tcXSvwwJMby
   5t+8/6TwCwqSM4Q1jF0+4CAdtxSXXB23JlQwSCSNjfSCWcRG3j0fTWf1+
   S2gmWrQWK7uFpx0xwigACKVYXlTsBrurERGnUg0AXegklHOLQo3m7hCrB
   ifCwDoyaDgLMGpH5Nt1XRgj4kwqPvYvlKEb+acvF9fLKn1vZULu8mKWrt
   5wnLKr6xVgnJcdkwruO2WoR03ACjn5IAzvyFw62a9td0QZZKd3TX7fwdw
   B6146ASVYqrHyxhuaPCHaNv3TMlP8aEu8591Ihl6/QkvAuT/vexINIZ2n
   Q==;
X-CSE-ConnectionGUID: N6nVcZn1RQGB4sxLA2Z+tg==
X-CSE-MsgGUID: lixag4HpSgGuktnzDnreDA==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="25584458"
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="25584458"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 01:02:35 -0700
X-CSE-ConnectionGUID: 8wOW06pLTcCnYg13vPkjNw==
X-CSE-MsgGUID: NbBLo//tQNKuSM0CFGdwiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="59048943"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa010.fm.intel.com with ESMTP; 14 Aug 2024 01:02:32 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com
Subject: [PATCH 1/9] i386/cpu: Don't construct a all-zero entry for CPUID[0xD 0x3f]
Date: Wed, 14 Aug 2024 03:54:23 -0400
Message-Id: <20240814075431.339209-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240814075431.339209-1-xiaoyao.li@intel.com>
References: <20240814075431.339209-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, QEMU always constructs a all-zero CPUID entry for
CPUID[0xD 0x3f].

It's meaningless to construct such a leaf as the end of leaf 0xD. Rework
the logic of how subleaves of 0xD are constructed to get rid of such
all-zero value of subleaf 0x3f.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 31f149c9902c..c168ff5691df 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1844,10 +1844,6 @@ static uint32_t kvm_x86_build_cpuid(CPUX86State *env,
         case 0xb:
         case 0xd:
             for (j = 0; ; j++) {
-                if (i == 0xd && j == 64) {
-                    break;
-                }
-
                 c->function = i;
                 c->flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
                 c->index = j;
@@ -1863,7 +1859,12 @@ static uint32_t kvm_x86_build_cpuid(CPUX86State *env,
                     break;
                 }
                 if (i == 0xd && c->eax == 0) {
-                    continue;
+                    if (j < 63) {
+                        continue;
+                    } else {
+                        cpuid_i--;
+                        break;
+                    }
                 }
                 if (cpuid_i == KVM_MAX_CPUID_ENTRIES) {
                     goto full;
-- 
2.34.1


