Return-Path: <kvm+bounces-21747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EE369335B1
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 05:41:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FAB11C229CC
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 03:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E1B2DDC7;
	Wed, 17 Jul 2024 03:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H2JmuWWR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CB3748A;
	Wed, 17 Jul 2024 03:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721187641; cv=none; b=q4WsxPawCsGsqx6D8TAqyqCGUOui6QQoMY7Xon+DBDPrSrwGRnv+CYbZaJUzgjVcR+yaGoINw5f9NmOUlr8VPAG5OYTvHOate/jXTf8dUCxq+n0kIVHsNve9mEtKmlz4+3GEFgRKylqf24loMw6e0XrJXrwfePksFiiGnVwt/0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721187641; c=relaxed/simple;
	bh=jhvvjas5iv8XJQqpFKAiIxzIfcajgUN9jOtwbSWIbUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErQ7v2Styd1vEXUm1GxrxuciZzMKkFq+um0pEQkDmQhpHbgLxidb43Vp4cdvlsSfK3n2WOVxQ4TZGrWGDmGGgRjoYTCWqN5o9QkEyxUwSNcTIqkxbZj/vPjBYA3wRn8bLO+3zRt4paF/75UnAOeESyVbA7eIaqYvadyykeioFjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H2JmuWWR; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721187640; x=1752723640;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jhvvjas5iv8XJQqpFKAiIxzIfcajgUN9jOtwbSWIbUg=;
  b=H2JmuWWR7PL2qHc+RjLZAPbgdzhTw0zIwzhaW8k+M+mYDq4AMpQlr4be
   NIjfdQpVi3WLM6iARbdG3VT/nCw0VFswiWn/tJkPu5YjaaUQTr1nJmrIc
   fumYzdlgKmICrdwE/Sop2Oy9ydgSYiMa4qGrDHwOv5448xoW7G1vgqIkL
   pRUADGmeUp6LFAJpHxjcURYOPGA3YJfTrC+bNmJbK0hnD6Jrg1c5vNlq0
   YU8jKvVhTcqznZaxH+pI5ZWCwMkLrGetzfxM+/y14nCzUrlicRZTdWR4h
   rvoe/K7QY5U9akL7zjDwwIcXS0rurYXw/sLtvLZzyO43PczdDCSX/VLCk
   A==;
X-CSE-ConnectionGUID: biuuzD+jQ7Kc4Vkn6jlP2A==
X-CSE-MsgGUID: WVxVER1LTjiPoENOp12GVg==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18512341"
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="18512341"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 20:40:40 -0700
X-CSE-ConnectionGUID: 4gy3/WoORn6HuPmEQo6UXA==
X-CSE-MsgGUID: bObMJpj4ToG8CwEajK35GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="54566690"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.184])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 20:40:36 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	dan.j.williams@intel.com
Cc: x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	chao.gao@intel.com,
	binbin.wu@linux.intel.com,
	kai.huang@intel.com
Subject: [PATCH v2 01/10] x86/virt/tdx: Rename _offset to _member for TD_SYSINFO_MAP() macro
Date: Wed, 17 Jul 2024 15:40:08 +1200
Message-ID: <ce378ce8cdcc2b2ab6c8cffd6a6187c2001d138d.1721186590.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1721186590.git.kai.huang@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TD_SYSINFO_MAP() macro actually takes the member of the 'struct
tdx_tdmr_sysinfo' as the second argument and uses the offsetof() to
calculate the offset for that member.

Rename the macro argument _offset to _member to reflect this.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 49a1c6890b55..d8fa9325bf5e 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -296,9 +296,9 @@ struct field_mapping {
 	int offset;
 };
 
-#define TD_SYSINFO_MAP(_field_id, _offset) \
+#define TD_SYSINFO_MAP(_field_id, _member) \
 	{ .field_id = MD_FIELD_ID_##_field_id,	   \
-	  .offset   = offsetof(struct tdx_tdmr_sysinfo, _offset) }
+	  .offset   = offsetof(struct tdx_tdmr_sysinfo, _member) }
 
 /* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
 static const struct field_mapping fields[] = {
-- 
2.45.2


