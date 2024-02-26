Return-Path: <kvm+bounces-9632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D2D5866C3F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:30:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C19CE1F24341
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E8414CB55;
	Mon, 26 Feb 2024 08:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WGwzpJXw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2A72576D;
	Mon, 26 Feb 2024 08:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936063; cv=none; b=O+AE/ZpQ1xouLjRqgScAyXtpI20QTAl9//cEnfXY8Th+5vplYerD8GqjvQin4HFJ0JMpqKrKCGtv5/yfAt+rwXHs3UfDkMRsi58CMjOATvjwC1gnSDOeG5dRphW/Mc23XfSdWU0RqkC3fC7DyRvUy2mbV8AzReUB5P1GI28pn9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936063; c=relaxed/simple;
	bh=xIS0IEpU4jLV8PiHi+HchMYIeNnm0fFPNPHfNFUxmaM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UEhwOwvOd/UgI7Hs3zJ7AFzlYt/bM+/NJnzqRqJgFx0EiELstCuGiGtGTXNIL6Fn/fpSmDSt9B2SjkOS27lKvyG7etXX5qXR2plQ/R6dPuZZrQDrAj4Yk4FZlYyh65TuUoW0sEPamtiDQq2y4aoMk9eSdzjODDfqcQ5rW6ociD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WGwzpJXw; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936061; x=1740472061;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xIS0IEpU4jLV8PiHi+HchMYIeNnm0fFPNPHfNFUxmaM=;
  b=WGwzpJXwqFrom4jDm3BFVTCqX7uiDXqoq3mIwbVakbW6l008gXz/RNix
   BjCZzENr5zbRYZSarOCuEeMpH2DMa70c66bMVCLEn8xReOwqwqo6xJHAF
   R9NUK9bug+GKGKhcT9xQNyUJZgj6QWQtONP91mCBUyaA9q4WqcP0T4bRq
   CwhXLzMyizBc+12weAZyofPl98hrEDGzrkld3wb2utTQrYbDsWFEXlUXo
   S4fUrNx8zIYnHXDiyJFl19/OJ8dGHuSQWQ8uvruMzWg0yw+/g78iHc0mX
   d4I9nzkgEaULD9vjkPmfnAVAkV151qVeAw3+TPff69H+5M5NejDwLSsU9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="28631456"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="28631456"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6474311"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:39 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 008/130] x86/tdx: Warning with 32bit build shift-count-overflow
Date: Mon, 26 Feb 2024 00:25:10 -0800
Message-Id: <a50918ba3415be4186a91161fe3bbd839153d8b2.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

This patch fixes the following warnings.

   In file included from arch/x86/kernel/asm-offsets.c:22:
   arch/x86/include/asm/tdx.h:92:87: warning: shift count >= width of type [-Wshift-count-overflow]
   arch/x86/include/asm/tdx.h:20:21: note: expanded from macro 'TDX_ERROR'
   #define TDX_ERROR                       _BITUL(63)

                                           ^~~~~~~~~~

Also consistently use ULL for TDX_SEAMCALL_VMFAILINVALID.

Fixes: 527a534c7326 ("x86/tdx: Provide common base for SEAMCALL and TDCALL C wrappers")
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/tdx.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 16be3a1e4916..1e9dcdf9912b 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -17,9 +17,9 @@
  * Bits 47:40 == 0xFF indicate Reserved status code class that never used by
  * TDX module.
  */
-#define TDX_ERROR			_BITUL(63)
+#define TDX_ERROR			_BITULL(63)
 #define TDX_SW_ERROR			(TDX_ERROR | GENMASK_ULL(47, 40))
-#define TDX_SEAMCALL_VMFAILINVALID	(TDX_SW_ERROR | _UL(0xFFFF0000))
+#define TDX_SEAMCALL_VMFAILINVALID	(TDX_SW_ERROR | _ULL(0xFFFF0000))
 
 #define TDX_SEAMCALL_GP			(TDX_SW_ERROR | X86_TRAP_GP)
 #define TDX_SEAMCALL_UD			(TDX_SW_ERROR | X86_TRAP_UD)
-- 
2.25.1


