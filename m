Return-Path: <kvm+bounces-22633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDB04940BB8
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 10:35:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EE9728B711
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 08:35:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F354E1946D4;
	Tue, 30 Jul 2024 08:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="deGz7HXA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E79A1922DE
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 08:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722328229; cv=none; b=AOBrW2SjgVoP/w/G/sCffSucMFN310fZIKGc4C2brrYVflWHq/fEL5eBACZB0n8O2bEwSHUBHnyZ3poIDP7gHABAMNze8PqZg+pfr4nHD0vNgZdIlmTbS2myynbuLFS7jLchk6rRUi0U1GXDv7jBG9uTH23YRQkDsWQTvWsBg0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722328229; c=relaxed/simple;
	bh=Zu0DkYHZp376mYcxX4BmjxKrhLF7QW+fPRCdyxIIOLI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UoAe3CoOiFXJoylgUPW0BlPa1b9zxISY34CWC56c5/wnAMFLYiTG7dvgICKCIMbSXRtGzNAnztfIIXXQNufC+iFpkL5wWO0k7KmOtGRwbyOFkBaEchSCvnrDV+/krwsfwA5LFNl4mC5cIOz8RlBxDDFppOG8R3msdYVS+1czWZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=deGz7HXA; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722328227; x=1753864227;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Zu0DkYHZp376mYcxX4BmjxKrhLF7QW+fPRCdyxIIOLI=;
  b=deGz7HXAb5rGQ+CfMt4RM9318mmj4p7wSeBorfvxQtopeTe6G7e9QCpt
   dZiuwpqc7jwkkEZnpOydHj0uZTTSF/6Q4uu1vSGrTSkWRcnzBw9azJLoR
   qayUMnOKoddbqBkyyaH7CEzxL04HaH9k1t0HgWoheV4HJV4kkRuH+0f9x
   XvppK9POBdiZ0Aq+RDngNqEw+rA4iuWq4lL3pd245wkgIpRfzU71DKan1
   aluLxFES8NoLbXH3d7l2WMs+oybeDDc7fXJhIZu2ZOzIuTcIoZzJazTfn
   XyZ3NpwaQlZTMyyaiKgzs9clFbfK/sDNgqPPEuUOgNxYnef3U4fUTfgUa
   w==;
X-CSE-ConnectionGUID: ADKjh96aREmyETF3zOeuJw==
X-CSE-MsgGUID: 0hneivKqQFOYtBGDArl1+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11148"; a="12785700"
X-IronPort-AV: E=Sophos;i="6.09,248,1716274800"; 
   d="scan'208";a="12785700"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2024 01:30:26 -0700
X-CSE-ConnectionGUID: OmD7hmV6SZGMXrP/i6kwlg==
X-CSE-MsgGUID: 3Xxa/mA3Tx29UNLUJJ7aFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,248,1716274800"; 
   d="scan'208";a="59338242"
Received: from xiongzha-desk1.bj.intel.com ([10.238.156.112])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2024 01:30:26 -0700
From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
To: pbonzini@redhat.com
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Xiong Zhang <xiong.y.zhang@linux.intel.com>
Subject: [PATCH] target/i386: Change unavail from u32 to u64
Date: Tue, 30 Jul 2024 16:29:27 +0800
Message-ID: <20240730082927.250180-1-xiong.y.zhang@linux.intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The feature word 'r' is a u64, and "unavail" is a u32, the operation
'r &= ~unavail' clears the high 32 bits of 'r'. This causes many vmx cases
in kvm-unit-tests to fail. Changing 'unavail' from u32 to u64 fixes this
issue.

Bugzilla: https://gitlab.com/qemu-project/qemu/-/issues/2442
Fixes: 0b2757412cb1 ("target/i386: drop AMD machine check bits from Intel CPUID")
Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
---
 target/i386/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 4688d140c2..ef06da54c6 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6039,7 +6039,7 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w)
 {
     FeatureWordInfo *wi = &feature_word_info[w];
     uint64_t r = 0;
-    uint32_t unavail = 0;
+    uint64_t unavail = 0;
 
     if (kvm_enabled()) {
         switch (wi->type) {
-- 
2.40.1


