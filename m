Return-Path: <kvm+bounces-24110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CBB41951606
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 10:03:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 844062856D0
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 08:03:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D8C81422D4;
	Wed, 14 Aug 2024 08:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iuTo6xYl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5AF13CABC
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 08:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723622565; cv=none; b=kI/AaSiKQPKxWBTyudLxKh6zsDQcx1fsQ77tWKTo7uS6XaaKW5uiHnf9YqGIvaPpO1COV71xqjpL/M4ACrEKRS/S1yrC4NWJt//vufjlRQ8TDnM01fE4ThBnvpqjq4Nzc0iK/dm80ta7LW6UsU4O0zZfL4Ij3TawnQ7DkVBnXq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723622565; c=relaxed/simple;
	bh=+1CShJKpDmVBjOQNUIrC3GWrHShE0+pF4rvqTJMJim8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qokV/YbuJ5ZJ1RZ8bJsVwy3ycdKysJx4lqp4g4ID8mbPoXbhBzm4My9/T8OIDan8w/qz0s9Ocbh3MmsAxo/pT33oKTu6WhHrHk6YztaRBy/KIce5C8J+czksogGwiJrs45+rodIgEpmuYsqJq+ifuxp+DUqxGCe2ttfhouijk08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iuTo6xYl; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723622563; x=1755158563;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+1CShJKpDmVBjOQNUIrC3GWrHShE0+pF4rvqTJMJim8=;
  b=iuTo6xYlp9NBtFCF9OsQTeUU0fKrxgamH7jv0WfEcc56kRuEardkced9
   QWLjHOXyyLZuthQeRc5+bvfmI0SnkS1T2D/dvxTgkAG7lf9gahIzKdviF
   S24KVLVwThvcUDsVHDjr7H1v2+u7eOCIFFAAUc0VFVcgHn032IhMS0KtR
   TUUvr+HIkGuk231llq3f7V9QF8IvMFc5u4qrA3sdryAJg21c35pqVGwLD
   1PFjKrUR3pcz+whoP3y+SZCQfWQohoJ0AuV4EfwH2jzu/5Sas/4SOQe+y
   2TquhUMRUnSAZRFZZ5G5xrHWK6y455j9kktWSkQ/pyO/3QSZq0GId6Nkl
   Q==;
X-CSE-ConnectionGUID: F7hAn5w8QjeTQgeepYDjnQ==
X-CSE-MsgGUID: HQFXyfAjRmG6XliA4tZNQQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="25584502"
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="25584502"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 01:02:43 -0700
X-CSE-ConnectionGUID: KEfZ5W48QYaoJauvCfm6gQ==
X-CSE-MsgGUID: 0Haszx6eSjqibH/f847CBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="59048963"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa010.fm.intel.com with ESMTP; 14 Aug 2024 01:02:42 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com
Subject: [PATCH 7/9] i386/cpu: Suppress CPUID values not defined by Intel
Date: Wed, 14 Aug 2024 03:54:29 -0400
Message-Id: <20240814075431.339209-8-xiaoyao.li@intel.com>
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

Some CPUID leaves are defined by AMD while it also gets exposed to Intel
VMs by QEMU. It causes no issue with current VMs however it will not work
with Intel TDX because these CPUID leaves are enforced by TDX module as
reserved.

Stop to advertise them to Intel VMs when vendor_cpuid_only is true.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 7a4835289760..fed805e04aeb 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6863,12 +6863,16 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         break;
     case 0x80000000:
         *eax = env->cpuid_xlevel;
-        *ebx = env->cpuid_vendor1;
-        *edx = env->cpuid_vendor2;
-        *ecx = env->cpuid_vendor3;
+        if (cpu->vendor_cpuid_only && IS_INTEL_CPU(env)) {
+            *ebx = *ecx = *edx = 0;
+        } else {
+            *ebx = env->cpuid_vendor1;
+            *edx = env->cpuid_vendor2;
+            *ecx = env->cpuid_vendor3;
+        }
         break;
     case 0x80000001:
-        *eax = env->cpuid_version;
+        *eax = (cpu->vendor_cpuid_only && IS_INTEL_CPU(env)) ? 0 : env->cpuid_version;
         *ebx = 0;
         *ecx = env->features[FEAT_8000_0001_ECX];
         *edx = env->features[FEAT_8000_0001_EDX];
-- 
2.34.1


