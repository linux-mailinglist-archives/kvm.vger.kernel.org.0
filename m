Return-Path: <kvm+bounces-19738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BDE9D909D2F
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 14:02:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C857B20E5C
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 12:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71385188CB2;
	Sun, 16 Jun 2024 12:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ibiodJMd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AA818755D;
	Sun, 16 Jun 2024 12:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718539307; cv=none; b=K/NkWEmvLXflpnG3N4BGdYcKU5nD+q1tjyHxTho9t4Y357k3RsrxeuSKUZpBR1JvrxcYDf1lmh5Rpb7WFc2f9pKRsONq6nPJhTY24RqR3zlytngLSLlF+h/gIurVxuuxnAQzX/D/fU7yw5BrPayBYfTG4bJflVFm2cxNbf58R1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718539307; c=relaxed/simple;
	bh=AUrNPcJyqRQvgHQBUEB1pO8rmhlwIqwTYUgZYCPiSsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqAUjqSVykCAmRhaq91zb7YFS8wEMadjcFkc4GAZ8CYwfwMVZZCQNBVxP0cEe5qHYYzMmXZL8Mx8y9nTyIvj+hdaTT2SF5spU5OdRmMxOKCg8bZdlpLnuy1hu43ruBsHcWHmtS0HF/3FU1LmzwXxko7bSs2uiD0+tv22vX5tKfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ibiodJMd; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718539306; x=1750075306;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AUrNPcJyqRQvgHQBUEB1pO8rmhlwIqwTYUgZYCPiSsA=;
  b=ibiodJMdW9KlrYIqYWH8n+flustbuOUiIZKfsVruQy+MlIjeC5v9lPmq
   d+ullKopyULK5H88xX/Ck/o4be0x7tXi4m8Ci/B56inxTsX74S45gXl9S
   u9hlaq0kb7nEn+EG7K0W48jQ1yupNRx2uecdIsk21g/0h8nFxIASuPvMk
   TgFBlTgULqG/geVRow4if9bmOAxx0nhx25PPwUNld0PyWH0tWCn6DMH/w
   kRXr4/4F/QBpepill3EsconS6SSVnGCxv6NigRRfex85Te531qZ4PT56f
   SYRKR0ygqhOUXppeaWPcgK0ACXDs+zRyCVe/nWu5q6HzwZJH7RCoOhhqy
   Q==;
X-CSE-ConnectionGUID: BEpUdVhnRbCH4RiyL6mjlg==
X-CSE-MsgGUID: KuTxJhKDRSSATt9bNfm0zQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11104"; a="26799989"
X-IronPort-AV: E=Sophos;i="6.08,242,1712646000"; 
   d="scan'208";a="26799989"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 05:01:46 -0700
X-CSE-ConnectionGUID: vDKerc2+SnKAnStCWTV9VA==
X-CSE-MsgGUID: Clva5zLgTAeh3xb0tJVV8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,242,1712646000"; 
   d="scan'208";a="46055802"
Received: from mgoodin-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.226])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 05:01:42 -0700
From: Kai Huang <kai.huang@intel.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org,
	dave.hansen@intel.com,
	dan.j.williams@intel.com,
	kirill.shutemov@linux.intel.com,
	rick.p.edgecombe@intel.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	bp@alien8.de,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	kai.huang@intel.com
Subject: [PATCH 1/9] x86/virt/tdx: Rename _offset to _member for TD_SYSINFO_MAP() macro
Date: Mon, 17 Jun 2024 00:01:11 +1200
Message-ID: <8e48327381647068355d43c672b34961f2b88971.1718538552.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <cover.1718538552.git.kai.huang@intel.com>
References: <cover.1718538552.git.kai.huang@intel.com>
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
index 4e2b2e2ac9f9..fbde24ea3b3e 100644
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
2.43.2


