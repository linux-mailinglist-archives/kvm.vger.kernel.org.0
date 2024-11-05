Return-Path: <kvm+bounces-30678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A97879BC5B0
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:40:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB2D21C21329
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 477F71FE0F9;
	Tue,  5 Nov 2024 06:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mQ+AH8qE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF071714A0
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788772; cv=none; b=Omz1Ddya5qWrdefnhpk6/Aqe9gbqeuUvkwr03HldZoggbVkUNf8EtK6mvQDLcLLLotBJHnzvd7NFOm3peWKwnE7gnEh9uE/2OtFIw6uUsIwLtSVxtOT08sNqIsEqZSEZEe+1Lx/+j+lAHS/gHIF/w4oCgBJbD1ryQOIwrSRvDnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788772; c=relaxed/simple;
	bh=+XE3AzklwMx8qhJJ+4Ok+j4KRAHEYu5njiiWc5OMr0s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NMEyCY/7Ecmv9F3fSA6cDmBIX82kFdrtQU6o+sm3Bq0TaL13GqHNgQcfOC3y4A398hUcF0xdHFAj/Q9qPS515o++1unUzRsIjMxnenJw8yoGkrnjUKD7U/jYawMYirMdYqAKjXO2oHaed1m2dwgauL2nbrqjn5XAGWmAfBcGPuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mQ+AH8qE; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788771; x=1762324771;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+XE3AzklwMx8qhJJ+4Ok+j4KRAHEYu5njiiWc5OMr0s=;
  b=mQ+AH8qEAmnP6VhPUWRHKD0/i8zQcIbkQyM2NMTRFln9OO7TXQAIXS95
   a4KYj5LAmEnvV11tIP9loTb+JK95OwTKSF2iDsd8DlE2/5aC0Ljhh9e/S
   q0iN7LUD5ZZEQxLS6VaMMdMVRnKQzsC7McgOh6Npar5nq7Wp0CZPhGDl2
   xaSO7/WeR2GOw1deQYj5UXxKrsVpn6tCr/lz3mWdImOw4L2sFavBI0Vbk
   Px3p20g/xfITlOvdxBLFFjVBZca/WRUqhzrN6tYRcMrBzDJ7xzVgVMMFX
   BEG5J2fJ/rU+FfakpHYU7M8go4qB7/mTOiQWLzZDbz058I7VitEUgvBFE
   Q==;
X-CSE-ConnectionGUID: su2NBJtDRyeKmkk1y+j3cA==
X-CSE-MsgGUID: 6PbwBzueRQmTxqAGh9uiRQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689803"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689803"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:39:31 -0800
X-CSE-ConnectionGUID: /q6YE+zjQ2S+qPxXDNLUQw==
X-CSE-MsgGUID: 8D/bpe6kSS61Uxuq3srC+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989664"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:39:27 -0800
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
Subject: [PATCH v6 44/60] i386/tdx: Skip kvm_put_apicbase() for TDs
Date: Tue,  5 Nov 2024 01:23:52 -0500
Message-Id: <20241105062408.3533704-45-xiaoyao.li@intel.com>
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

KVM doesn't allow wirting to MSR_IA32_APICBASE for TDs.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/kvm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 8909fce14909..c39e879a77e9 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3627,6 +3627,11 @@ void kvm_put_apicbase(X86CPU *cpu, uint64_t value)
 {
     int ret;
 
+    /* TODO: Allow accessing guest state for debug TDs. */
+    if (is_tdx_vm()) {
+        return;
+    }
+
     ret = kvm_put_one_msr(cpu, MSR_IA32_APICBASE, value);
     assert(ret == 1);
 }
-- 
2.34.1


