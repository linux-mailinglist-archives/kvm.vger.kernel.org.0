Return-Path: <kvm+bounces-7112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DDCD83D6AD
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:42:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BDA27B2BBA2
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4E36148FF0;
	Fri, 26 Jan 2024 08:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hNFNdqg+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF61B148319;
	Fri, 26 Jan 2024 08:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259464; cv=none; b=Qf8VfxcDWResXfhVOpPzsMHvAMTM6QEfn9ULsY5Hc0nhGKgMwIkb3yIspVayd8BUDUQzU5PlR8C8DN8+vWQ70PfcpDiV46+okqt7sFngaXF+FUzuF0tEmnt32rTtQOSzS0F0Z0UoeOq3MaYLWs1MTjURMHqenORowf8yiOXfQkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259464; c=relaxed/simple;
	bh=VmVupQ0f4JlKloBwqRwVJNycDk88RDOb6fGszV69574=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZU20AUg8I2q08xvJPsWUBNoJDYhMc1hAfTVc+nN6DV7YHhuiYOVlx6/mS8q3TWezfr3PaIlr1wcYCvCyLuqbWa3RpA+LRIf3NUx9Hkf1c9MZYY6Bj4D24LCO50ES4/szngFRCH5FuFCeeHSBKctDS7Ur5TzblKzcod31esc8MMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hNFNdqg+; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259463; x=1737795463;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VmVupQ0f4JlKloBwqRwVJNycDk88RDOb6fGszV69574=;
  b=hNFNdqg+EgsVlllK8rvGNe5zfXotTth8rEMLH/j8yJSOuL5DqMajS4+4
   1L7s7CGVptD56H9XwsbIaF0RLVMWS4ahWrp4dr17MnXOLRlUzPXbEdOC6
   mG8N4kh29C5F3/DtEI8B8u298QbKlvwd1NJfvlgYjABhGYG75WaYcsxfZ
   kfeIFtnz96YIi0QMh3Tf6yO6uj7+VHaN8CfM4n5FTeAZ1bD9QJWiIDAqC
   OQbcIBFnEVwlVJt9VgJ4QoSXSMu37JlRySt5X2ERMwDSePrUiim7m5G1O
   rLR3PDzBGZIXOlw2fhTAU+rzZZVY9UT0Dw1ZCarumnorsdrivWCgZbtqu
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792708"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792708"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310216"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310216"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:37 -0800
From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	mizhang@google.com,
	kan.liang@intel.com,
	zhenyuw@linux.intel.com,
	dapeng1.mi@linux.intel.com,
	jmattson@google.com
Cc: kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiyuan.lv@intel.com,
	eranian@google.com,
	irogers@google.com,
	samantha.alt@intel.com,
	like.xu.linux@gmail.com,
	chao.gao@intel.com,
	xiong.y.zhang@linux.intel.com
Subject: [RFC PATCH 25/41] KVM: x86/pmu: Introduce macro PMU_CAP_PERF_METRICS
Date: Fri, 26 Jan 2024 16:54:28 +0800
Message-Id: <20240126085444.324918-26-xiong.y.zhang@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Define macro PMU_CAP_PERF_METRICS to represent bit[15] of
MSR_IA32_PERF_CAPABILITIES MSR. This bit is used to represent whether
perf metrics feature is enabled.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kvm/vmx/capabilities.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 41a4533f9989..d8317552b634 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -22,6 +22,7 @@ extern int __read_mostly pt_mode;
 #define PT_MODE_HOST_GUEST	1
 
 #define PMU_CAP_FW_WRITES	(1ULL << 13)
+#define PMU_CAP_PERF_METRICS	BIT_ULL(15)
 #define PMU_CAP_LBR_FMT		0x3f
 
 struct nested_vmx_msrs {
-- 
2.34.1


