Return-Path: <kvm+bounces-30676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F29389BC5AE
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:40:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B81CE281468
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 598AF1FEFC4;
	Tue,  5 Nov 2024 06:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EoepP8IK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165691FDFBE
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788764; cv=none; b=MdjMVQV32ourKSAI22ydX0mFAtkU+uY2admyrXIGll1Ri9ZL/BqK8Ss2JIRvVfJO5jUYiE+WwnZ3jvP3o7E3UPt/o3N/0L4QrEJyuke0aDaLKAZkXE++3ClhaeoVoJtqMXKQg+WmiA45nc4IJCcxnOMIaVAQ/QyZ2cOX8SATq0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788764; c=relaxed/simple;
	bh=uFxOU0S0tIUsyV9rR7mBF54/Xh/koV03EYrPligZB2A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A22M8/OeHxK1IJcV0UThPVaupj78lPSWV5ZZAlqemeKNjoMDdhgw7KWYePAPEpe0R/rEu0fJSzqmhRh6t5GBzZYdngfhF8lfWrmi0OpUZUFEh38OxD892N9l3h0m6VJ6Z89h0kJNJVt2YGz4q8bzcyIEEo6dXk8hsRjECS2BIPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EoepP8IK; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788763; x=1762324763;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uFxOU0S0tIUsyV9rR7mBF54/Xh/koV03EYrPligZB2A=;
  b=EoepP8IKrpaNd0mLm7GhGUjBCiTeZr1XL9MiaKTqV5D9e8VMDI4m4bYN
   axMHTy6std/apAbLcO33H9IcPhoUsjDlJTmPRLeDP9n2OUiP52S96X3kO
   5QK3ufWE6y6VtpTVaJGH8nSu4nGEtYz69N7cOABZW41qt/QJOCigQ6E69
   aIQ1yKeiChDY0gda2H/EtEL+QoOx4HjffAHDhxBpSMN4p40cHRrzAJHnE
   GJrkqUFW/7hqzElPcz0RM/EdugeCi/YzCjdx9nNkPvi8gdhCEUyQAch/5
   ITQ6kZV7jPJAMUjdF8obg1a4cr3Vv50cgVYnjJEdW50w+tu/+sJvb63F5
   g==;
X-CSE-ConnectionGUID: r2LaZIntQ5S0+3YxlX6CDg==
X-CSE-MsgGUID: KS7CnF4NQdWOuq6RjI2i8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689776"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689776"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:39:23 -0800
X-CSE-ConnectionGUID: fZqnB8jWQYyh3dtw65a9ag==
X-CSE-MsgGUID: UaR6lv4fRS+2sLaYX0hujA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989612"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:39:19 -0800
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
Subject: [PATCH v6 42/60] i386/tdx: Don't synchronize guest tsc for TDs
Date: Tue,  5 Nov 2024 01:23:50 -0500
Message-Id: <20241105062408.3533704-43-xiaoyao.li@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

TSC of TDs is not accessible and KVM doesn't allow access of
MSR_IA32_TSC for TDs. To avoid the assert() in kvm_get_tsc, make
kvm_synchronize_all_tsc() noop for TDs,

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 022809bad36e..595439f4a4d6 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -330,7 +330,7 @@ void kvm_synchronize_all_tsc(void)
 {
     CPUState *cpu;
 
-    if (kvm_enabled()) {
+    if (kvm_enabled() && !is_tdx_vm()) {
         CPU_FOREACH(cpu) {
             run_on_cpu(cpu, do_kvm_synchronize_tsc, RUN_ON_CPU_NULL);
         }
-- 
2.34.1


