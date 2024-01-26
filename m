Return-Path: <kvm+bounces-7109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A356283D69B
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:40:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D64241C2A036
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B251A1474B6;
	Fri, 26 Jan 2024 08:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZM/qceai"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973201474A6;
	Fri, 26 Jan 2024 08:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259448; cv=none; b=qRdhPkDS8CPK3RSltdNFh/MkPJf5WjgWwDf0IJoHTmraWKt8dldCn3PG1U8pHJeHqx1u8pwpEXfcMKhBDbY2DxmN/Zjxi3zbrsOcv4NZsLbXi8WfUhDnk6+b/GOaF0DW9NHGTB6R+iVrTDra/iCu6nNgr4gYS6odkKitzmMttcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259448; c=relaxed/simple;
	bh=qKGEmkNzvZAtCrde1qURnNvooz6jAC8AIy0lIH+fTqE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZjpCLtn2waV8zTjxMmWu0Gdh6XZWR1j3uQBH0mBc+ZP/fD0aJ3krYACGIN9HGFfhgeRNtylZ4HZsaUYRFeyaN0vBxL+guPl8rIynQxvNRQws4R/TYPrp3uC+8fwlDePUc46pTgkEK1uvVDzQ3bOtBAcZD09TwHORPXNyIsJ1ofI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZM/qceai; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259448; x=1737795448;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qKGEmkNzvZAtCrde1qURnNvooz6jAC8AIy0lIH+fTqE=;
  b=ZM/qceaimLoIRKI5Fx9XNvSsXu2mDvCG9yE764V6aVUGO4yDpqM6mg6D
   4l2j4VrjKrLTHvU1Wf6+HTxRugOBxElbWawqXCtj28TSBZgyWoiUhE6e/
   e9rMu/S9LVlpASmr36Tkpn+PNg24XLyi6yZSiJICdx5Yub6kZ4MfYyaQq
   kd0OxJrMylOeCOIxQFhv46U0V3i7OD+0rTCkjqEuaj6vllJg4IpjJW77B
   yIB68DfBjYNSlW3nksfI7X4A+5OAyY6PUAWfHic5sKFuIGAlsSIDQ0+mB
   t+1oEzNR4KziPt35btnrKv4ad4B33sKkIZ9szou/R4uuANGm7PJbqJO0Z
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792656"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792656"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310132"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310132"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:22 -0800
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
Subject: [RFC PATCH 22/41] x86: Introduce MSR_CORE_PERF_GLOBAL_STATUS_SET for passthrough PMU
Date: Fri, 26 Jan 2024 16:54:25 +0800
Message-Id: <20240126085444.324918-23-xiong.y.zhang@linux.intel.com>
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

Add additional PMU MSRs MSR_CORE_PERF_GLOBAL_STATUS_SET to allow
passthrough PMU operation on the read-only MSR IA32_PERF_GLOBAL_STATUS.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/msr-index.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1d51e1850ed0..270f4f420801 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1059,6 +1059,7 @@
 #define MSR_CORE_PERF_GLOBAL_STATUS	0x0000038e
 #define MSR_CORE_PERF_GLOBAL_CTRL	0x0000038f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x00000390
+#define MSR_CORE_PERF_GLOBAL_STATUS_SET 0x00000391
 
 #define MSR_PERF_METRICS		0x00000329
 
-- 
2.34.1


