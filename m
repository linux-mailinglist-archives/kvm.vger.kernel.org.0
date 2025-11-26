Return-Path: <kvm+bounces-64643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E451C89344
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 11:12:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2DA7F4E3F2C
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 10:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D75CC2FB99D;
	Wed, 26 Nov 2025 10:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TICKB7jl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B223016F6;
	Wed, 26 Nov 2025 10:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764151945; cv=none; b=bICtkifmGGKTFIb9rxyrFytOBnIwiKRh9X69A1TvLOXXFFAaVItPd342REelzSUZXZKjy/2eOTVdTAuq2ZMKavtqAZBwc8sobCKmT9U0nFPUgOqYtRyGbW1phzOBsnsRoPB8zOp/skqN+zI7t/UlT6CXjyZp9szopC9YI8X3W98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764151945; c=relaxed/simple;
	bh=wYfnSJce/d68AkC3D5gkG5TdhGF5sx8GseHqKuyPJ3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KG4TcPeD7wHxhMJp/zHzklF0XjvhYAbL4nGwxcNG1W3wHL2ZkkUXj3dNuj3NhMaxb79JxEDwOUAcEPo6TFOPAuwfqznkzBZXvHtTJgymaUIKsNeMh8JucXfWeHz68I9FSlmF122ufMHq5f6WAhcPNhcb7at8Lz5aRzo2RH/tkr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TICKB7jl; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764151943; x=1795687943;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wYfnSJce/d68AkC3D5gkG5TdhGF5sx8GseHqKuyPJ3k=;
  b=TICKB7jl6Om1ByGYO7cfokx8AF1sA4bUNnPc0CH8bmZqBC9uUn73Ycpz
   qWtcLZ3LTryW3/dDD/UIWJGwCKkV1zDqpDH5WbNKRKmPepibz1Mv9zZBx
   /WrxHKl4MRuiRaCjLCqt4PcMp/lzl5qgDdyXi+W/cOeYXCpe3EpeM5vOh
   A4PLIvubktYqYdAzfLkxVSJN8yTq6OWuakZF9iP1NBrJiZyNahTpMAJob
   RH9sqXAjksNWLEBuv5OjFjLobRr3jaoT3o4JGzmoglak990f0RaspInyx
   akVQAOfa/llbh9OIMWCCz890XOTDMgSgat983wBGH2pY6P+8T4X8R+5OE
   w==;
X-CSE-ConnectionGUID: cbJmFiSXSCCmop3iImraZQ==
X-CSE-MsgGUID: p+kpR0FqRYWIEB8CEkMpgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="70048244"
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="70048244"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 02:12:23 -0800
X-CSE-ConnectionGUID: MinKU0NPQlaZPSL3+hTk9g==
X-CSE-MsgGUID: xvoBGOAyThuJ90AHUjTW0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="223623661"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.22])
  by orviesa002.jf.intel.com with ESMTP; 26 Nov 2025 02:12:20 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Kiryl Shutsemau <kas@kernel.org>
Cc: x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	chao.p.peng@intel.com,
	xiaoyao.li@intel.com
Subject: [PATCH 2/2] x86/split_lock: Describe #AC handling in TDX guest kernel log
Date: Wed, 26 Nov 2025 18:02:04 +0800
Message-ID: <20251126100205.1729391-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251126100205.1729391-1-xiaoyao.li@intel.com>
References: <20251126100205.1729391-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

X86_FEATURE_HYPERVISOR and X86_FEATURE_BUS_LOCK_DETECT are always
enumerated in a TDX guest because the corresponding CPUID values are
fixed to 1 by the TDX module. Similar to a normal guest, a TDX guest
never enumerates X86_FEATURE_SPLIT_LOCK_DETECT.

When "split_lock_detect=off", the TDX guest kernel log shows:

  x86/split lock detection: disabled

and with other settings, it shows:

  x86/split lock detection: #DB: ...

However, if the host enables split lock detection, a TDX guest receives
 #AC regardless of its own "split_lock_detect" configuration. The actual
behavior does not match what the kernel log claims.

Call out the possible #AC behavior on TDX and highlight that this behavior
depends on the host's enabling of split lock detection.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kernel/cpu/bus_lock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/bus_lock.c b/arch/x86/kernel/cpu/bus_lock.c
index f278e4ea3dd4..18695214d214 100644
--- a/arch/x86/kernel/cpu/bus_lock.c
+++ b/arch/x86/kernel/cpu/bus_lock.c
@@ -437,6 +437,9 @@ static void sld_state_show(void)
 			pr_info("#DB: setting system wide bus lock rate limit to %u/sec\n", bld_ratelimit.burst);
 		break;
 	}
+
+	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST))
+		pr_info("tdx: #AC depends on host configuration: crashing the kernel on kernel split_locks and sending SIGBUS on user-space split_locks\n");
 }
 
 void __init sld_setup(struct cpuinfo_x86 *c)
-- 
2.43.0


