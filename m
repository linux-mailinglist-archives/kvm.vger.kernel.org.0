Return-Path: <kvm+bounces-47552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 772BCAC2055
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:59:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D955D7A69DB
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:57:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24BBE246768;
	Fri, 23 May 2025 09:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jxjOclPj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348CF23F28B;
	Fri, 23 May 2025 09:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747994039; cv=none; b=fHrcnE98pb+vN2WWQ04Wgk1pfwzx1gGUPCZZdnpXX6iM7pWp2HmZvbtArPlgssfWt52I/7UF8dDVY5FOBJE0V4/gS+zyQdcfsklIt/nimZOgLy+Eze277S8rYBKM+6+SMPBQExxamM8fMWfnVZloYDwOX+v0C0FiUhDzBudFihc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747994039; c=relaxed/simple;
	bh=A5/numxrZ8wt+tf/LRq2aHHFDCvIzonkxuDUA8d5rwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3SuHShswLiyE3kFFVDgrJhdUs/PYU+1cG5R+JPbuCWkIiI6MtbDos3HY83vhQrqy1OdtBIOxyeUkQThBlObBlUQfV4TEH3ZaCsvf3hIGaRAgiu5UqbpmH3gOvUEYhm4piED1Tl3eSaHXEd3CFJh0L0u8DTrf1cYvsiqEuqt0Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jxjOclPj; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747994036; x=1779530036;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A5/numxrZ8wt+tf/LRq2aHHFDCvIzonkxuDUA8d5rwA=;
  b=jxjOclPj9/N5xC4qCbKNqlCeklZjwDvz0d0iO0qLRxy19tPAaf6skVU5
   UjqFJPt4aFzatsQ2Xs+yLNryobolJvPJ9Fs//fNvJV3P9lFiXOFOO2v7y
   XxRIXlamNE9E82hssDXp14iLW+dor4XliS8WkI/6uP2wCoX2hZNaobkTB
   +FJBVODSYQvOsN21ve+Jg1j97Y5EU9m135S6l0NKNs5RuBvBhJqzKqeSq
   c8IuEmISf5eiVvJi2biUvU87/TruWAdncsuz1eXFcxkNXzfw28TnjCSrq
   TGrzbSs0lSET5Q6ZkuEmy1tlv7m7Hf4ZabsLNrmIYTHaW2zUii/7fCoSO
   A==;
X-CSE-ConnectionGUID: VWd0yO+8QgqwGxEnorYhzw==
X-CSE-MsgGUID: SzKHO1+jSFi0orNWpPrx0A==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="75444235"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="75444235"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:56 -0700
X-CSE-ConnectionGUID: qp3+oRTeQN+JVqRxKsMrMg==
X-CSE-MsgGUID: BL8ajBhdQ22Ar53QARRFkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="164315088"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:55 -0700
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	x86@kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	eddie.dong@intel.com,
	kirill.shutemov@intel.com,
	dave.hansen@intel.com,
	dan.j.williams@intel.com,
	kai.huang@intel.com,
	isaku.yamahata@intel.com,
	elena.reshetova@intel.com,
	rick.p.edgecombe@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 16/20] x86/virt/seamldr: Do TDX cpu init after updates
Date: Fri, 23 May 2025 02:52:39 -0700
Message-ID: <20250523095322.88774-17-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250523095322.88774-1-chao.gao@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For the newly loaded module, the global initialization and per-CPU
initialization are also needed. Do them on all CPU concurrently.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
 arch/x86/virt/vmx/tdx/seamldr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index a18df08a5528..c4e1b7540a43 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -245,6 +245,7 @@ enum tdp_state {
 	TDP_START,
 	TDP_SHUTDOWN,
 	TDP_CPU_INSTALL,
+	TDP_CPU_INIT,
 	TDP_DONE,
 };
 
@@ -318,6 +319,9 @@ static int do_seamldr_install_module(void *params)
 				scoped_guard(raw_spinlock, &seamldr_lock)
 					ret = seamldr_call(P_SEAMLDR_INSTALL, &args);
 				break;
+			case TDP_CPU_INIT:
+				ret = tdx_cpu_enable();
+				break;
 			default:
 				break;
 			}
-- 
2.47.1


