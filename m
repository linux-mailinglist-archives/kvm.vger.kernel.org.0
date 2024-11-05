Return-Path: <kvm+bounces-30690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D367D9BC5BE
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:41:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02DD11C212BF
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:41:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A692B1FF5FB;
	Tue,  5 Nov 2024 06:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KRdNBOA+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F35C1FDF9B
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788823; cv=none; b=NOa/Jfcricq11xxwYkndru48EulOuL2yZJob8XSXJZzvnu9Sfwq4pcoyKTlq/HfadDJy8yLm4jwD0OJ/XEnrEaNSeyt9rE64Pza2A8/BgotIwL8C0MrhnNOUxgvLtjpd926kwcog6FLT861mWbDGqiiKSU1WWM3clykuSdH5/Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788823; c=relaxed/simple;
	bh=N6wZGF3LbJuiZwh2h+P0qnuOeIsvhZtITe8MucmhR3Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NwZm2LhlSXsNqZbQKIBmJBBGmGxP19/ppyo04pBAH9uszNL4fZcucyHOS2ED+pHPFsLZ8teNw9pCC3BPQDH0hzBMdOR+mIMwP7uoj957sAtsNydx2fsP0IRYIpGeFIqBAh57SawFYuzgmjpi22FAdQPBIbO4pCL0MVCZ1qZo3cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KRdNBOA+; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788822; x=1762324822;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N6wZGF3LbJuiZwh2h+P0qnuOeIsvhZtITe8MucmhR3Y=;
  b=KRdNBOA+jId0z3h/xuhv3xGTPZzgwx8CYvagqpCcbuCFakjmlGnXp9dW
   qL+VSI5QRjA4kSe6fak6faGtC+KY0OKvS1xR0x3j2efWEtpfuvZ3HLPp3
   VZaKjrtHumHPmAKTISn6QA9JG1QO+/yNyZnwU5mqeJjvlOQNi5LEjcQkn
   LGFsiTsKQ2W2alfR0xlMjP6DhPFAA/nJYGA0zEexgqPlmNnF5a/GLniUO
   xJpya1VshM2+XNH0VRh4x/+otVJ74YGpu5KLXH4mEDvlmpZf8GE2DULSw
   vHEmpZ2O0MraTUW3IWP5niUOAgnefqWQLD6iwi7VK34dtBsZQcJEfQ8op
   Q==;
X-CSE-ConnectionGUID: zQtDtrbQT16KEBIP56BcFA==
X-CSE-MsgGUID: pecEVBq2QXOcelc6wqsdIw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689927"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689927"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:40:22 -0800
X-CSE-ConnectionGUID: cui/g9wYSTW/R2q/F+xxag==
X-CSE-MsgGUID: BO/sHFRmRSK/ivSD8JW1yA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83990064"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:40:18 -0800
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
Subject: [PATCH v6 56/60] i386/tdx: Don't treat SYSCALL as unavailable
Date: Tue,  5 Nov 2024 01:24:04 -0500
Message-Id: <20241105062408.3533704-57-xiaoyao.li@intel.com>
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

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 9cb099e160e4..05475edf72bd 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -734,6 +734,13 @@ static int tdx_check_features(X86ConfidentialGuest *cg, CPUState *cs)
 
         requested = env->features[w];
         unavailable = requested & ~actual;
+        /*
+         * Intel enumerates SYSCALL bit as 1 only when processor in 64-bit
+         * mode and before vcpu running it's not in 64-bit mode.
+         */
+        if (w == FEAT_8000_0001_EDX && unavailable & CPUID_EXT2_SYSCALL) {
+            unavailable &= ~CPUID_EXT2_SYSCALL;
+        }
         mark_unavailable_features(cpu, w, unavailable, unav_prefix);
         if (unavailable) {
             mismatch = true;
-- 
2.34.1


