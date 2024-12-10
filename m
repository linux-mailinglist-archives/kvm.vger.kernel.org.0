Return-Path: <kvm+bounces-33355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C71FC9EA3CE
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 01:49:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D1D2284336
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:49:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D7881BC094;
	Tue, 10 Dec 2024 00:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VD+OlRCV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB7919DFA2;
	Tue, 10 Dec 2024 00:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733791692; cv=none; b=QwNRQJ2JWHNUYF/Vbtq8QybHWNmVcK9fwfcW7N2h6m1eQ/S86khYhgMowxcNQiNiCxBaMLMjGXl0/fS+0FiBuyID8kk2w1gkA3L+VnbcnLqUVpM9EP+Ndvby/5PmB2W0ud/ADMWZT3jWkFpdHmdjecrQDKC+CLTTNIMecsogP44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733791692; c=relaxed/simple;
	bh=6qbe1nTxwtwr/1P8atYc9YKT0eYcr+2D+LcplNIsU2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDAoFKExiEmIxV9wFvH9EGhSfgEn9+/oexOiJ/IT5A4HYdmf3WVlBm1IRZ93nx+lSdqjYX+bylUP8ZcjnX3DVTTFEvVW0bMTtQn3El0r8E1eFbukdfrCxKkLfAqvlztT1O7qJiWLfl3aw0YTEP0kfWyDVqllEErBxBjwnMPrYdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VD+OlRCV; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733791690; x=1765327690;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6qbe1nTxwtwr/1P8atYc9YKT0eYcr+2D+LcplNIsU2E=;
  b=VD+OlRCV7NwI8jHtgrxGrI0S/LMQEeicmFqJkbk1tAUi3Hst6eaE7896
   Ne7Ptn3xqsYKW7scn+QyZ/BE/o3CQtcBYtoGswsLsSAD31HxLzR3BOCk7
   8xbr0d6ISYlrN2SLJfqoNZu7FYoWJ2U0a696I92zF3f5sayYqS80Inq8f
   hTwdvsZoXLmfRkoNYS3o8+fCfNdtaV5/gfcBDtvwAod4LdPB6BR75YmK3
   p9wxySPx6ai6E0uVkojJEUzSRjcaL1uTjTAy1v77370BbN1JDdmsHFrDz
   gLP5CWxR82yJ9C4r0Uy8NGjaQGEOqRLPAE5bhkvFeUailxJmQ45vR21tu
   Q==;
X-CSE-ConnectionGUID: 8pbkv7qgSyOlC/Nk+8KcaQ==
X-CSE-MsgGUID: BVqSpzp9RqOyUSS/r4J9Bw==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="44793708"
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="44793708"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:10 -0800
X-CSE-ConnectionGUID: 8XJbrh5uQ/qG/mNoEAGEUw==
X-CSE-MsgGUID: HK1mZo+6QM6tCeW/m2xq/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="96033028"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:07 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 06/18] KVM: x86: Move KVM_MAX_MCE_BANKS to header file
Date: Tue, 10 Dec 2024 08:49:32 +0800
Message-ID: <20241210004946.3718496-7-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
References: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Move KVM_MAX_MCE_BANKS to header file so that it can be used for TDX in
a future patch.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[binbin: split into new patch]
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" breakout:
- New patch. Split from "KVM: TDX: Implement callbacks for MSR operations for TDX". (Sean)
  https://lore.kernel.org/kvm/Zg1yPIV6cVJrwGxX@google.com/
---
 arch/x86/kvm/x86.c | 1 -
 arch/x86/kvm/x86.h | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2b4bd56e9fb4..5eacdb5b9737 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -90,7 +90,6 @@
 #include "trace.h"
 
 #define MAX_IO_MSRS 256
-#define KVM_MAX_MCE_BANKS 32
 
 /*
  * Note, kvm_caps fields should *never* have default values, all fields must be
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index d69074a05779..0a1946368439 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -9,6 +9,8 @@
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
 
+#define KVM_MAX_MCE_BANKS 32
+
 struct kvm_caps {
 	/* control of guest tsc rate supported? */
 	bool has_tsc_control;
-- 
2.46.0


