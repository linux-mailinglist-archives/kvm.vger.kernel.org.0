Return-Path: <kvm+bounces-47554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E45AAC2056
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:59:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4F951C03A6B
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:59:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66491248867;
	Fri, 23 May 2025 09:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vv8dh5aK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD4224467D;
	Fri, 23 May 2025 09:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747994040; cv=none; b=omFHOx6BRwDNdWh/T4KpTsJ6DI9FslLv0K4pewX5NoxdahbMHVY97JtWFYeHFTWf/m2FOy1p27P3q0K3ckBWhwbT8Jo/pD0BHutsC4reBZMn1zm7eoJG56+FRjmvE7waX8SKVIcYima+5LNdCfkwlgaQi2axUgwM6aY4zkaHcpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747994040; c=relaxed/simple;
	bh=eSNu+v2D+KaWmQHSJ63w2hZA/nb1bEbeikUu1ijOXvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxImPoKbuKl4W34A+JlJTbh/0Ns/DaOP3V77bAfzVb5P/LyeE1xmzPSLQO/bPDx+FfCarh90eIr7os+9lUXZTpzMCVqnR1S41aOGYi0fB+vPuzIvB1mXvYUogSJ2wrp3eMZ9NmI0G4upQ8USYeOMPRJLDlrpJOfnxcfnIYUdJHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vv8dh5aK; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747994039; x=1779530039;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eSNu+v2D+KaWmQHSJ63w2hZA/nb1bEbeikUu1ijOXvU=;
  b=Vv8dh5aKXu5oQTJcFNZ9DItBeq+qjXdgw0vUPPTmVlQUjwb/A9LuKOTE
   3a4/RltAeGw3u4IQan0Zg01X+G+rhgnjoSvx/GqzdBoFZ+Ii+/ZQPg+IT
   W51x4x0tFVm/fTeAfL7QfhdZ/V95VaC0OlqXPmuihsFMsDP821e9P65Xy
   hzLjgEewSoH+HC9lgkQ97IESASpr07KuyFA57m2xXfo7sMtCSPozPGKsG
   0oPc5sqPkxgtAuswX+f9+oy09jjCb9X67JZ3Q7OY7MiwqieWpUln2qppK
   Y8Bgztv15PtqkxVmOmODHihcz8x2v8NbFCx3OnNFupSHnHZ1id4ABi5Uq
   g==;
X-CSE-ConnectionGUID: zz1KG4YjSca/GCiz1ZfN4g==
X-CSE-MsgGUID: 5LulC0WeRi+w5eYioRil1g==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="75444259"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="75444259"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:58 -0700
X-CSE-ConnectionGUID: hgsxCPppRP21PE4KRjgwyA==
X-CSE-MsgGUID: 0U8B0qiWQL29bXl1nG54zA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="164315097"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:57 -0700
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
Subject: [RFC PATCH 19/20] x86/virt/seamldr: Verify availability of slots for TD-Preserving updates
Date: Fri, 23 May 2025 02:52:42 -0700
Message-ID: <20250523095322.88774-20-chao.gao@intel.com>
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

Before initiating TD-Preserving updates, ensure that the limit on
successive TD-Preserving updates has not been exceeded. This is a cheap
check to prevent update failure.

Refresh SEAMLDR info after each update so that userspace can read the
correct value of remaining updates.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
 arch/x86/virt/vmx/tdx/seamldr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index 93385db56281..fe8f98701429 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -371,6 +371,9 @@ static int seamldr_install_module(const u8 *data, u32 size)
 	if (!info)
 		return -ENOMEM;
 
+	if (!seamldr_info.num_remaining_updates)
+		return -ENOSPC;
+
 	struct seamldr_params *params __free(free_seamldr_params) =
 						init_seamldr_params(data, size);
 	if (IS_ERR(params))
@@ -382,6 +385,8 @@ static int seamldr_install_module(const u8 *data, u32 size)
 	if (ret)
 		return ret;
 
+	WARN_ON_ONCE(get_seamldr_info());
+
 	return tdx_module_post_update(info);
 }
 
-- 
2.47.1


