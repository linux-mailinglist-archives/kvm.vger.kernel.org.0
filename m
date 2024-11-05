Return-Path: <kvm+bounces-30684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A1E79BC5B7
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:41:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D9B31C214EB
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4242D1FF03F;
	Tue,  5 Nov 2024 06:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WC4Gcjui"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9C41FA275
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788798; cv=none; b=MvWfReVJ1Bpz4jYdd5ZnWL2cJM5SQGl5jkbGg8t8rjt9+vcF6QHTlEIMINL4WaYt3ntyMlm7j+x/zGfehEXbx5ZpBby1G9+Fv6fHnKdAF6rf5Dluq3AwdFiy7p+b5bNYArrEyTQcN1SBTM0KjdEa2AH32tlg6wYEQGXrrhVH1mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788798; c=relaxed/simple;
	bh=f1vBUeMjW4fPDV+AM3GOU/JcU0MWDw60zLwDbytS/8c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uPZ9Pgkvft5WZ6t2jrw772eLmCXfUvKogN0o/CVCKCKdB4VoefUiav1L0G3HBfBMnJk1AM47vf6tJB5StJOKpTY8z28l3LDrumUj7+/JDUgZMZ0HvDPSlWMzMlK1l3HrZXTtoEUIL9Ic4Rz+UzGe11haT4zuhld83HOWJEQrsvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WC4Gcjui; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788797; x=1762324797;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f1vBUeMjW4fPDV+AM3GOU/JcU0MWDw60zLwDbytS/8c=;
  b=WC4Gcjui4C21xZDTB8z9qX3QfEvOTB6riVEBn6B8n76JT1FyoF9Q0BTM
   UDQ+6R76apUB2BG33kKBNTR8lHXabA9YPB3rlDknyVzSrBpbQgbBwqzUR
   VL1pFE7jrawbjmxg56mGLss/COTfWWBRZH5XIJPZu98Mcft2DGpBDPnoh
   gzT82qnr68uVlwFPP7lZ3ipYJY4sHoFk6qbdbNbh6XRu9cdcpWvV5/2Zz
   xBAyxyAa4cFMvTOS3Ld/2hgqAsNaztopuQODLBj633qeOFGgeO5Or460F
   vDqxAnrEkDxb8qhl1NvY4+hiDdBSzpzBFCZlSGAlguxYeDwOHMdLYLJwV
   g==;
X-CSE-ConnectionGUID: taZ255foSTaQXWMlC6LCgw==
X-CSE-MsgGUID: 9NVXLMWyTXSKHm3FtCCBvg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689865"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689865"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:39:57 -0800
X-CSE-ConnectionGUID: AyZ+kzahRb2rPCJpujgR5g==
X-CSE-MsgGUID: YIvu0W5xTNuM1XUDVf3m0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989850"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:39:53 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 50/60] i386/cpu: Move CPUID_XSTATE_XSS_MASK to header file and introduce CPUID_XSTATE_MASK
Date: Tue,  5 Nov 2024 01:23:58 -0500
Message-Id: <20241105062408.3533704-51-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

They will be used by TDX.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 3 ---
 target/i386/cpu.h | 5 +++++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 119b38bcb0c1..8c507ad406e7 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1827,9 +1827,6 @@ static const X86RegisterInfo32 x86_reg_info_32[CPU_NB_REGS32] = {
 };
 #undef REGISTER
 
-/* CPUID feature bits available in XSS */
-#define CPUID_XSTATE_XSS_MASK    (XSTATE_ARCH_LBR_MASK)
-
 ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
     [XSTATE_FP_BIT] = {
         /* x87 FP state component is always enabled if XSAVE is supported */
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index e02e23d972a0..0cc88c470dfb 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -621,6 +621,11 @@ typedef enum X86Seg {
                                  XSTATE_Hi16_ZMM_MASK | XSTATE_PKRU_MASK | \
                                  XSTATE_XTILE_CFG_MASK | XSTATE_XTILE_DATA_MASK)
 
+/* CPUID feature bits available in XSS */
+#define CPUID_XSTATE_XSS_MASK    (XSTATE_ARCH_LBR_MASK)
+
+#define CPUID_XSTATE_MASK       (CPUID_XSTATE_XCR0_MASK | CPUID_XSTATE_XSS_MASK)
+
 /* CPUID feature words */
 typedef enum FeatureWord {
     FEAT_1_EDX,         /* CPUID[1].EDX */
-- 
2.34.1


