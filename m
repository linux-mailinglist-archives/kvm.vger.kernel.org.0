Return-Path: <kvm+bounces-39456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F9CCA470F2
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:24:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 527CB188A5B6
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1C0F1C6FE6;
	Thu, 27 Feb 2025 01:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TZ+oJogq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893951C07DA;
	Thu, 27 Feb 2025 01:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619189; cv=none; b=TMY+Qrm6I3+8CcL/ZCihOiBhIRElN1fxJ/F4+3s1Hh5UfvdptVzgnya6bsvSU7CUqpXqz/R2riq+LeLkbuhJDgMfHphtyOuBwfja8oZZ2Lqpw4BgZEiS3LkAKDXgA21mmq+wNCxvir9R+EYaHr8VF3keunNXbh+4ygiCv7R1+AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619189; c=relaxed/simple;
	bh=XJaBTgpvmUOYXvblbK+evXNJHErt7dbEPe57+h9OFdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egLnN5bH3bwBcXzmxYudYXcFDtsRuGu/WHacEy7ALquBtF4MC+mW4PLgYw+wpih2RGp8DjHq54vlDeoeKqjLICQaX8oOomfcLrliAsaBTV+H8/wC2GmyWDjxxj9nWVo3TlMKif7c7X8HdXpi9PRkIJWTpnBiABT+LRUmZFd/TO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TZ+oJogq; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619189; x=1772155189;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XJaBTgpvmUOYXvblbK+evXNJHErt7dbEPe57+h9OFdA=;
  b=TZ+oJogq8qu4MVLVQPO0wrOSru5DurmAbmTeQs/XhNRV9X9vff/KqDSQ
   XXjTRlLCEEKzfyMiLuwr2tGdLjUvLKVVNcUG7g0IyW1H7ZRMse8P+SGmK
   siG2ycJ7LfmBAtkeFHRoHtR8pBopyokg11pgfr7XkMutjP7dK3zfLZ8z3
   OkPK7FICKCO/c7WxQpCR1V71OxmYn1Botiu8D8Tm2q/NjrxPSA9PcHlVN
   JDvC2jE0Npb6sXpS0on6IMHtA3Ukfl+tgg4C/u6hm6ra3OnQ6/dNUqhmb
   e6Zism2VSbw2nFUguQ/hBGRHONxsBcH/UNuAsQjvsJNJmPNZgKuHHAZmN
   Q==;
X-CSE-ConnectionGUID: BYKBpeBKQTuUWI45+sEEoQ==
X-CSE-MsgGUID: bgYJCz4MRoWzSm6kfllh9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959695"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959695"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:48 -0800
X-CSE-ConnectionGUID: dkpu7eQWTFucAns7gVrD+g==
X-CSE-MsgGUID: Um/k5dJ0TI2X3mXmyP3P0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674931"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:45 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 18/20] KVM: TDX: Enable guest access to MTRR MSRs
Date: Thu, 27 Feb 2025 09:20:19 +0800
Message-ID: <20250227012021.1778144-19-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
References: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow TDX guests to access MTRR MSRs as what KVM does for normal VMs, i.e.,
KVM emulates accesses to MTRR MSRs, but doesn't virtualize guest MTRR
memory types.

TDX module exposes MTRR feature to TDX guests unconditionally.  KVM needs
to support MTRR MSRs accesses for TDX guests to match the architectural
behavior.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" v2:
- Add the MTRR access support back, but drop the special handling for
  TDX guests, just align with what KVM does for normal VMs.
---
 arch/x86/kvm/vmx/tdx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index dbc9fffcbc26..5b957e5e503d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2049,6 +2049,9 @@ bool tdx_has_emulated_msr(u32 index)
 	case MSR_IA32_ARCH_CAPABILITIES:
 	case MSR_IA32_POWER_CTL:
 	case MSR_IA32_CR_PAT:
+	case MSR_MTRRcap:
+	case MTRRphysBase_MSR(0) ... MSR_MTRRfix4K_F8000:
+	case MSR_MTRRdefType:
 	case MSR_IA32_TSC_DEADLINE:
 	case MSR_IA32_MISC_ENABLE:
 	case MSR_PLATFORM_INFO:
-- 
2.46.0


