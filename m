Return-Path: <kvm+bounces-24106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA60B951602
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 10:02:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6568B2847B0
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 08:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED52377F11;
	Wed, 14 Aug 2024 08:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C4sG5+x4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BE313D529
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 08:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723622559; cv=none; b=cwW+vXjxOFUZiaZjfgV2A+RWUW9VjUxOLXNoGcP6pGNEL2TXd48FjJLB8WAhQXkTmV86te8QhTQdBiIq+PkqkifkF9zKhYovTJTU+Tz1onAilNfPIRxWqXxG9/YixfFJogrSxl3Ttoj3rJK6W1051U8O7SH0qOG91yz/bMRGCoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723622559; c=relaxed/simple;
	bh=uep5VC7g3XliyLn1znJEV29ajVLkzpBFUeE1+TBL7QA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LbTN6ZcdyRUHbOGiN4l38dUAKCgFO75m0qm8T4thxa5701cp4iXVesKu1ZmlbDDOStcNr3zaxOqOlETDYcsm36qDwKme3XjXdJ+UabaCXTT7JKmxvdJ0MW8vVYjZKrL7G2E5U/vuSOnmCULAb7WYBRPqoJYN+HUQvMEyoT/+CUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C4sG5+x4; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723622558; x=1755158558;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uep5VC7g3XliyLn1znJEV29ajVLkzpBFUeE1+TBL7QA=;
  b=C4sG5+x4a8JyCGM8t+O5Ui77mnPRY2Gdq62s/XxPeiYsVxdhiZtV+D7N
   mrKC/dWf/s0A4bgat/ckFn5QAtZ5rGRxpw1PXVpgngnPGMd4KQMGkAYP6
   c6aJi6EVBIqPsIShy7m84s9XjljxCzXgSzOJ+YgPAFtG138IHsyR6kwp7
   n4RGZWQjtm1/rrV01WRc60J+WxJJbhD3ni2QHsUQ3fa9Iz4YDryKpaioD
   U/j/7p60y9DdtAnbqMFhTz7xxu9QeKkcfjxcATCZJqLy9woPJo+ObUXuV
   yz9IhH9JwrrUVxd9aY51VWjH6hW51hTHsvZcXbiZW7z9b/hvik9lbWwUx
   g==;
X-CSE-ConnectionGUID: QgrvLFfiS8ewrdlz0eYZ9w==
X-CSE-MsgGUID: ZPMKzhE8RPemCrNOmVCahg==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="25584476"
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="25584476"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 01:02:38 -0700
X-CSE-ConnectionGUID: o7p3KkbsTfO1NtbxCirgxw==
X-CSE-MsgGUID: kqlP9rAJTr688NY7cbVQBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="59048949"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa010.fm.intel.com with ESMTP; 14 Aug 2024 01:02:35 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com
Subject: [PATCH 3/9] i386/cpu: Add support for bits in CPUID.7_2.EDX
Date: Wed, 14 Aug 2024 03:54:25 -0400
Message-Id: <20240814075431.339209-4-xiaoyao.li@intel.com>
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

KVM started to report the support of bit 0-5 since commit eefe5e668209
("Advertise CPUID.(EAX=7,ECX=2):EDX[5:0] to userspace")

Allow them to be exposed to guest in QEMU.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index e60d9dd58b60..03376ccf3e75 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1148,8 +1148,8 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
     [FEAT_7_2_EDX] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
-            NULL, NULL, NULL, NULL,
-            NULL, "mcdt-no", NULL, NULL,
+            "psfd", "ipred-ctrl", "rrsba-ctrl", "ddpd-u",
+            "bhi-ctrl", "mcdt-no", NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
-- 
2.34.1


