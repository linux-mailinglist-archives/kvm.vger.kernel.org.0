Return-Path: <kvm+bounces-21752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE7429335BB
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 05:42:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A599281C18
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 03:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A57181DFCB;
	Wed, 17 Jul 2024 03:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dk6CHko9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583A3AD2C;
	Wed, 17 Jul 2024 03:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721187663; cv=none; b=Ie/BykuTQlrda5qoEmAWaYkBInvJ0LVq99usiS0S0oK5oFApNEFG3/dQIbtKiP8Wa67xTEnFVR0dW7xz6IWwWl/aq/W5Egq0nx/LUNO360z0zUPT3wTmFAtpPel1RXcIMLFUkkDcJIA9JLDxngsWitK2M0SpUKIS6PCL+qn8WxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721187663; c=relaxed/simple;
	bh=124x/MqvBsrRYg0ox7CppLxwII2xa0F+WTjidwG/HJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrNKFDJvQvPh8k3ChzMd8SzsMwyXCpifDnuQsEPfUrqNUBoK3XMYr6N9DMN8HggdxddGSahYEhxUjGBA0Ye5gGg1quEIWLBLLKwdCkWBNsKHUbKRbo8jsdarb/LuV/B5IfVcdJUQPbuoDKNp6MbJWcfL5RxWQke+DHFw16ALoEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dk6CHko9; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721187662; x=1752723662;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=124x/MqvBsrRYg0ox7CppLxwII2xa0F+WTjidwG/HJw=;
  b=Dk6CHko9gIT9e0ew+jYP68NanUO0jJCcq/ORRjoVqJS1tdirAW5vpQIQ
   qgKGy90o3Cw2/iUuSiF0ncFq/A61vLvcdpkLw4SFW356vAzCY9+orsgX7
   ogiuRsM7OSpeO5dZd9msHn93faEdlUpq2T714gesd7fApCU21SC8su0kV
   zY5Q/u8rZnASb+BGO88n9G5XhCTmDhgRh2P/P8XrkdoteXeaH4AYxU7yi
   dOlMXflJ/YOfuSOlEgBIdTkZo0JY+jrNmwCTzM5trQa8MCzdBPe0iIQqE
   jhp5cVJvxplFnkyculQL2/wFaVOm4JyaPeu0WWTsovbUwBggpl6tnFOo1
   g==;
X-CSE-ConnectionGUID: /Ii+FpKGT3Om+hBXuDjkWA==
X-CSE-MsgGUID: 9aP2+Q8WTuyCGaO6qWIDqw==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18512418"
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="18512418"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 20:40:57 -0700
X-CSE-ConnectionGUID: uqEnXocaSNSIY4bCX2Fq6A==
X-CSE-MsgGUID: krRfDGP4RlKqSCjOsaArHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="54566737"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.184])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 20:40:53 -0700
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
Subject: [PATCH v2 06/10] x86/virt/tdx: Refine a comment to reflect the latest TDX spec
Date: Wed, 17 Jul 2024 15:40:13 +1200
Message-ID: <bafe7cfc3c78473aac78499c1eca5abf9bb3ecf5.1721186590.git.kai.huang@intel.com>
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

The old versions of "Intel TDX Module v1.5 ABI Specification" contain
the definitions of all global metadata field IDs directly in a table.

However, the latest spec moves those definitions to a dedicated
'global_metadata.json' file as part of a new (separate) "Intel TDX
Module v1.5 ABI definitions" [1].

Update the comment to reflect this.

[1]: https://cdrdv2.intel.com/v1/dl/getContent/795381

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v1 -> v2:
 - New patch to fix a comment spotted by Nikolay.

---
 arch/x86/virt/vmx/tdx/tdx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index fdb879ef6c45..4e43cec19917 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -29,7 +29,7 @@
 /*
  * Global scope metadata field ID.
  *
- * See Table "Global Scope Metadata", TDX module 1.5 ABI spec.
+ * See the "global_metadata.json" in the "TDX 1.5 ABI definitions".
  */
 #define MD_FIELD_ID_MAX_TDMRS			0x9100000100000008ULL
 #define MD_FIELD_ID_MAX_RESERVED_PER_TDMR	0x9100000100000009ULL
-- 
2.45.2


