Return-Path: <kvm+bounces-19742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4D84909D37
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 14:03:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89195281662
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 12:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69BE518755A;
	Sun, 16 Jun 2024 12:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l1zBB7Dw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C4218F2F9;
	Sun, 16 Jun 2024 12:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718539322; cv=none; b=NUhzITjfaFxUdWQi4L1CtsG0JZ4cf5zSW31zDHsC9722zufdJsXhgrdGKd9oittMt8QglfhyuuqgsQ2fXYrrizg4cMlWE2za95wi3zkl7Ez45qNxpa6fx35UTCN87YNq2VxVZNB139vWzIFZIUnZZYq6yTqDpDTWRCrOHmidwkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718539322; c=relaxed/simple;
	bh=gEEav5uPFLohYv3SYSnBxkTTuRP6BswSM90fiXmCWmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3wAYq/2yqVh6VMxW5dlf8U7swNJbyb+um0ryzuc0+peXunIENcD8Ht6YY/GX3dpRz8LHZWUJobh5bGXsoQ+xgFc0QIsKZ+2hh7pGDNWrwQVKvE5l6JpcOQ0j8jWRIGS4Lapgtn7b/bCcMh4EGdsOuM72dGL8dSzODW1DB/Z7wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l1zBB7Dw; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718539321; x=1750075321;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gEEav5uPFLohYv3SYSnBxkTTuRP6BswSM90fiXmCWmE=;
  b=l1zBB7DwJcpvSUtUVUzY9L0g9UKUwvilqow5sYTJVc2YDvovxRHzOqRv
   Usb+NP1O1tJGu/kBeflvFj5MNeg2bvUWt5EY1es7ToCcS/FvrjY24UN08
   PU8uuOAMO0oua5FzNu9GT9G/Q9cuSM1GGAcNLgfWKjw8utUFZ6oEiE1Sy
   s5NrJKcs75rl7zHD5y3cMGHl+/q7TKBNCaX10fb+/7eUvpQG37rgfwwK4
   73y27NEmLZuJt3HuaRoKTPKB13/RYGzkXfLxNsKN+GnoqRxdbKlrWrs4W
   xhLFFwfD3ROHgx0v+AJAWyKtm9Qb9beo5xkZbHIUAGgDQ/8TIIi3fdCcw
   w==;
X-CSE-ConnectionGUID: nCm3OGSjSLu1NaSnKFZK+g==
X-CSE-MsgGUID: D5BnNj8WROWr5qmF0HjFvg==
X-IronPort-AV: E=McAfee;i="6700,10204,11104"; a="26800023"
X-IronPort-AV: E=Sophos;i="6.08,242,1712646000"; 
   d="scan'208";a="26800023"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 05:02:01 -0700
X-CSE-ConnectionGUID: JXC2GztURO+NdtZxINfX6g==
X-CSE-MsgGUID: 3yIsSOPNR3KFY/B0A0hOFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,242,1712646000"; 
   d="scan'208";a="46055868"
Received: from mgoodin-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.226])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 05:01:57 -0700
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
Subject: [PATCH 5/9] x86/virt/tdx: Move field mapping table of getting TDMR info to function local
Date: Mon, 17 Jun 2024 00:01:15 +1200
Message-ID: <c7d85f753172f16238b6b3c9cdb4acf8cbd7bfe6.1718538552.git.kai.huang@intel.com>
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

For now the kernel only reads "TD Memory Region" (TDMR) related global
metadata fields to a 'struct tdx_tdmr_sysinfo' for initializing the TDX
module.  The kernel populates the relevant metadata fields into the
structure using a "field mapping table" of metadata field IDs and the
structure members.

Currently the scope of this "field mapping table" is the entire C file.
Future changes will need to read more global metadata fields that will
be organized in other structures and use this kind of field mapping
tables for other structures too.

Move the field mapping table to the function local to limit its scope so
that the same name can also be used by other functions.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c68fbaf4aa15..fad42014ca37 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -322,17 +322,17 @@ static int stbuf_read_sysmd_multi(const struct field_mapping *fields,
 #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
 	TD_SYSINFO_MAP(_field_id, struct tdx_tdmr_sysinfo, _member)
 
-/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
-static const struct field_mapping fields[] = {
-	TD_SYSINFO_MAP_TDMR_INFO(MAX_TDMRS,		max_tdmrs),
-	TD_SYSINFO_MAP_TDMR_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
-	TD_SYSINFO_MAP_TDMR_INFO(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
-	TD_SYSINFO_MAP_TDMR_INFO(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
-	TD_SYSINFO_MAP_TDMR_INFO(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
-};
-
 static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
 {
+	/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
+	static const struct field_mapping fields[] = {
+		TD_SYSINFO_MAP_TDMR_INFO(MAX_TDMRS,		max_tdmrs),
+		TD_SYSINFO_MAP_TDMR_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
+		TD_SYSINFO_MAP_TDMR_INFO(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
+		TD_SYSINFO_MAP_TDMR_INFO(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
+		TD_SYSINFO_MAP_TDMR_INFO(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
+	};
+
 	/* Populate 'tdmr_sysinfo' fields using the mapping structure above: */
 	return stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields), tdmr_sysinfo);
 }
-- 
2.43.2


