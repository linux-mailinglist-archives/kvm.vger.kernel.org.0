Return-Path: <kvm+bounces-50023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BEEADAE13C1
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 08:23:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6EC9171817
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 06:23:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26D09221544;
	Fri, 20 Jun 2025 06:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eQOiohJ7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CD31BE86E;
	Fri, 20 Jun 2025 06:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750400585; cv=none; b=Y8teh9Q+qCW7glDug3l57gZu9y/WidocQVzGdVS7DxyP6yrAnA+W48UMtQ9Pig6Ac6EO4D+PSQPAHVaQG6WhZCx22kczVsuV+9ymxWYMpsooQdRVg2yeSBy9CxbLagJej39h/nWSc8+onv+vqakNjqAB/3lPrEdU/lcPrjTGshs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750400585; c=relaxed/simple;
	bh=BKzgWLiSnVkSnztu+6QWiSSx2eUFe40sPzurewxO+1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UEV1nOGiyrOovgi381eaVAKZjCQwt+d13ESeD3H4hKYK7NigOKaXEKE7Xa6bBevB+V6XIK8zKq9lDObabmj3jMe1WTg44WyyGu7bjp1suw4ZgXciqp8uTDuZjaxCI7KGbpmjaeSPQTSTXoQekPkPO6tWeZrlCSSyDOoVDIikLfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eQOiohJ7; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750400583; x=1781936583;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BKzgWLiSnVkSnztu+6QWiSSx2eUFe40sPzurewxO+1Y=;
  b=eQOiohJ7WzhXSJxw02wLKvqYsY+8MdzrBMcmQAD/1L+sdnKWT8d1u5tk
   uvWOmQZLt6K+nrfBpK1Avad3eVIdOxKPrQTY5/+GANzMpdCzbSIxsC5Pw
   w82wgSJ4pqgrTyGUk4LXSv38qU4tg/SCn7arlKlxhBJV143ojLYQbV6/z
   GP+b8dqbqAYhP/SHIuwrCiSz23OqLrx6mLQ0WFzmQOVpmIvVGsiThi8ne
   LYTSryfEx1CC1FlzzZkom0VWrfrWa9mDA2DFwLU3Y/BfQGCoJOT9Pv2cq
   dvchKIQF0pzR/au/W1HuT0EIAnSk0KKR9GYLG67QiX6VXOOOGd+naorsn
   g==;
X-CSE-ConnectionGUID: TDt3R79yQ6OXgvdFG3gm1w==
X-CSE-MsgGUID: O5q44YwLQ5anYed3wpA68w==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="51882204"
X-IronPort-AV: E=Sophos;i="6.16,250,1744095600"; 
   d="scan'208";a="51882204"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 23:23:02 -0700
X-CSE-ConnectionGUID: zHvPMjEvQhWPLSgBssdQ9w==
X-CSE-MsgGUID: 3B3SeY8tTju2cgyUofolLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,250,1744095600"; 
   d="scan'208";a="181849497"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 23:23:01 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zide Chen <zide.chen@intel.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xuelian Guo <xuelian.guo@intel.com>
Subject: [PATCH] KVM: selftests: Add back the missing check of MONITOR/MWAIT availability
Date: Fri, 20 Jun 2025 14:22:18 +0800
Message-ID: <20250620062219.342930-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The revamp of monitor/mwait test missed the original check of feature
availability [*]. If MONITOR/MWAIT is not supported or is disabled by
IA32_MISC_ENABLE on the host, executing MONITOR or MWAIT instruction
from guest doesn't cause monitor/mwait VM exits, but a #UD.

[*] https://lore.kernel.org/all/20240411210237.34646-1-zide.chen@intel.com/

Reported-by: Xuelian Guo <xuelian.guo@intel.com>
Fixes: 80fd663590cf ("selftests: kvm: revamp MONITOR/MWAIT tests")
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 tools/testing/selftests/kvm/x86/monitor_mwait_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/x86/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
index 390ae2d87493..0eb371c62ab8 100644
--- a/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
+++ b/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
@@ -74,6 +74,7 @@ int main(int argc, char *argv[])
 	int testcase;
 	char test[80];
 
+	TEST_REQUIRE(this_cpu_has(X86_FEATURE_MWAIT));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_DISABLE_QUIRKS2));
 
 	ksft_print_header();
-- 
2.43.5


