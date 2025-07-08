Return-Path: <kvm+bounces-51758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F2C9AFC82F
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 12:20:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C4E8563FE2
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 10:20:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA23126B94F;
	Tue,  8 Jul 2025 10:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cQKdMtJd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBB126A1C1;
	Tue,  8 Jul 2025 10:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751969976; cv=none; b=QMhMx8SzZWeux3FQhW7yOHX9KlBe+UPU/kN+i89lCAQHPpcKzUD/llNlFGP5t2qc2FXOFRGS0zUYab2H74EUhftbKlrC6Bexid1LfH8v76f5lIsXF+KVM8P9mYx9g2zvgSsj+Eu2TcvftlRtwiLX6BPQj75dleTovmYYozW06JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751969976; c=relaxed/simple;
	bh=8ul1RV4tBolZAx/RFBjHZzoaOwiSn78OumHYnn57vxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bx4/GwUNsyxCKXr7cxYhRXVh7ugnQ8LiR8EklPdBlP5YxXlNJ+9/MnOglqKH46FeaZTmxgfQCpYGlcD4TzkwolzY9/Ok7JLQF5RRtxcTe8t9A5mxoag5GukxfnFiKpzPVijXlWDiUTYgeHWZwI1uwEKstabymfbn7QbG75Rf4nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cQKdMtJd; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751969975; x=1783505975;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8ul1RV4tBolZAx/RFBjHZzoaOwiSn78OumHYnn57vxM=;
  b=cQKdMtJdlMLx/mTBHyCFkB5X2owaoLqlh5Pz61sMAgApgXxiw0uWbUIk
   +ud6owzcdAepvLLWQ7WG70TrEx2Zxys28Vfpf6mEg5uVU4VYIpPpIU0Oc
   TmQm2CX1AVX79K4BX/tIUsjKTwCNJY4ioYzaGeD5eNyGoBEQgtiY+1uSI
   VnowAwxVpBa/W02TpyOwacF4nJaP3cTdhef/SG545CeCaBKGEk892xWOw
   M1ukSkuoAwdLVYumtmF508HvleDQ6gFS+c9novynM98NwhA+izRHItE1e
   McE4ddhHHo5xDfNqAYKDb79gV6+RxczmFav2jyQaAEVvU5fd2mxgVXLS7
   Q==;
X-CSE-ConnectionGUID: bxv7W+I0SPuKKKmxk4TVSQ==
X-CSE-MsgGUID: NRx+TMTWR0uqiHKzHYdEuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="79632836"
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="79632836"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 03:19:33 -0700
X-CSE-ConnectionGUID: KMzA/f9XTPidh33tExTg4Q==
X-CSE-MsgGUID: D7YuoiXoS5Om6mzDiRT7Hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="155952282"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa008.jf.intel.com with ESMTP; 08 Jul 2025 03:19:29 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id AD5F91C5; Tue, 08 Jul 2025 13:19:27 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 3/3] MAINTAINERS: Update Kirill Shutemov's email address
Date: Tue,  8 Jul 2025 13:19:22 +0300
Message-ID: <20250708101922.50560-4-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250708101922.50560-1-kirill.shutemov@linux.intel.com>
References: <20250708101922.50560-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update MAINTAINERS to use my @kernel.org email address.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 .mailmap    | 1 +
 MAINTAINERS | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/.mailmap b/.mailmap
index b0ace71968ab..85ad46d20220 100644
--- a/.mailmap
+++ b/.mailmap
@@ -416,6 +416,7 @@ Kenneth W Chen <kenneth.w.chen@intel.com>
 Kenneth Westfield <quic_kwestfie@quicinc.com> <kwestfie@codeaurora.org>
 Kiran Gunda <quic_kgunda@quicinc.com> <kgunda@codeaurora.org>
 Kirill Tkhai <tkhai@ya.ru> <ktkhai@virtuozzo.com>
+Kirill A. Shutemov <kas@kernel.org> <kirill.shutemov@linux.intel.com>
 Kishon Vijay Abraham I <kishon@kernel.org> <kishon@ti.com>
 Konrad Dybcio <konradybcio@kernel.org> <konrad.dybcio@linaro.org>
 Konrad Dybcio <konradybcio@kernel.org> <konrad.dybcio@somainline.org>
diff --git a/MAINTAINERS b/MAINTAINERS
index b0363770450f..d7da3e22f4d9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26945,7 +26945,7 @@ F:	arch/x86/kernel/stacktrace.c
 F:	arch/x86/kernel/unwind_*.c
 
 X86 TRUST DOMAIN EXTENSIONS (TDX)
-M:	Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
+M:	Kirill A. Shutemov <kas@kernel.org>
 R:	Dave Hansen <dave.hansen@linux.intel.com>
 R:	Rick Edgecombe <rick.p.edgecombe@intel.com>
 L:	x86@kernel.org
-- 
2.47.2


