Return-Path: <kvm+bounces-30670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73B539BC5A8
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:39:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72F371C20DE0
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85DD11FEFA7;
	Tue,  5 Nov 2024 06:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XeCuNuiY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7C81DB551
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788738; cv=none; b=oSd5rJsZZS9u4c0qt6HnbXPWb5lHZegEWi+T2Qje4eQphGwGhfxmuLkeATeEdhl6aaErQPMHiowTDfWOE/15/yfclpCPj+ZAQ6rXjB0out0POEtfrZjj7TvvHDeXhT6z6nV0CkMU896EIPFVTtbKaMStnaWY4LmiJaPt09SERTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788738; c=relaxed/simple;
	bh=dyUD9Nwe8FsbgpcTWs2XG6l6cCFEI7AD/O96ORbLEfg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m7hRVaMKiyuIhMgCWym66j0xTojJZRpF2ttS8FSY15dJEpQDAsQ9gTfFhMvTZHr7bPYC2rcUia28dRTX2bveJngQmqWX/cuye0ZP6SRJ20VNf5DK3BqDkmlZdHY43PAWp0REBtGXUyVsKxF7YMleDnxFLYXmzsz80hRpd/6SC1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XeCuNuiY; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788737; x=1762324737;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dyUD9Nwe8FsbgpcTWs2XG6l6cCFEI7AD/O96ORbLEfg=;
  b=XeCuNuiYL5oNeXJ8cz5gJDTBIZSGYwVcniEABPVdjoT08/DE1mrEiX96
   7M/OPfmS4H1n0RKMrdwp2Tt4K6CenvxI8jcHhKItiGWCDjDkH7uf3ZJKz
   cESBXvxjBe8rQn1BZeugnTcdeijJUo5qKz8Iug+GbeuVGRooQE3tP/xAq
   RokdypCCdBMup429wg8HJkRlKD/k4/AtNfIf6q2d/+EZp0eOx4FbsUCr+
   YRw07ja5oGzGaevNJQn6NObrreRK8tqXaeYzl+KGaKvAPxVPtseaHaDhH
   zPftX7dyzQxXgSHAf69aQglmEXHHz+5Ezw2W7pXSQopavH8EOU9N6vkbx
   Q==;
X-CSE-ConnectionGUID: xkDHaZeiQFWLdzsC46RXyA==
X-CSE-MsgGUID: M0jUYzygTo+6jSkFrZR35w==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689720"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689720"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:38:57 -0800
X-CSE-ConnectionGUID: nBw1klSbQS65rq8tQKhmxQ==
X-CSE-MsgGUID: 0zbx6/jETtKRuCVPbc4Ycg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989408"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:38:53 -0800
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
Subject: [PATCH v6 36/60] i386/tdx: Force exposing CPUID 0x1f
Date: Tue,  5 Nov 2024 01:23:44 -0500
Message-Id: <20241105062408.3533704-37-xiaoyao.li@intel.com>
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

TDX uses CPUID 0x1f to configure TD guest's CPU topology. So set
enable_cpuid_0x1f for TDs.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 289722a129ce..19ce90df4143 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -388,7 +388,11 @@ static int tdx_kvm_type(X86ConfidentialGuest *cg)
 
 static void tdx_cpu_instance_init(X86ConfidentialGuest *cg, CPUState *cpu)
 {
+    X86CPU *x86cpu = X86_CPU(cpu);
+
     object_property_set_bool(OBJECT(cpu), "pmu", false, &error_abort);
+
+    x86cpu->enable_cpuid_0x1f = true;
 }
 
 static void tdx_cpu_realizefn(X86ConfidentialGuest *cg, CPUState *cs,
-- 
2.34.1


