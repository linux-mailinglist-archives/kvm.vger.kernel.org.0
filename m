Return-Path: <kvm+bounces-6967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DE7983B850
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:35:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06D82281CA0
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EDFA17582;
	Thu, 25 Jan 2024 03:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H3bZMxmm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B5013FF1
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153490; cv=none; b=ewRfYR7mCGi7wVZr7rEL94GFVH88bBKQXyQ94trVM5VseSNhldGzEWvU6IVJ3VeZ0Ri/Yjci7EBu79tWLA9/LhCIVah4n+cL55WQkiOwH2rZ1rDpa53AgAZc0ZNWXFRoQ1e5Cg2dMIdsnWn7Jw258VgjXVU9CSqnadv1hUG7rUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153490; c=relaxed/simple;
	bh=Y8SQ8Ah0BdJ1ThTtaPC4uzGNggWYMxYnQvmPK1jMV/o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FR8t4LwnOZ07rDf2U+mp2xH/yWC/HYb6z1+rJv/BAyb0Cde7TXLri3TSORFb6GvJergR446VItXGKJMx5ZEV1g0W0dczdKCqKqVvJmgTHX7ooROTK+a+RRmsK+Eqqb5l1QbbzbwrykIuKlFteIEnLLgHEyNbbootWrazdSR/7vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H3bZMxmm; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153489; x=1737689489;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y8SQ8Ah0BdJ1ThTtaPC4uzGNggWYMxYnQvmPK1jMV/o=;
  b=H3bZMxmm/hkkvSeVecy0xg476RCtzJ/s8OzUAj3b/L6KOHF0a5+hZ/RY
   hIveSRkhPUmevkgjTsxUDjSBjOEdapYxatI+cN8jBtYNgJuLLNp+AO44f
   Za8vNyLhOeFGueaZHn1JB4WLYM+CEQXxloQDz+6jKXFZskivEIkEa5Ax1
   9yjQjsmOpeg3KeHPAzHoFdUHVCjzCIkkrXrDGwu68LOc7ioOfbQmtusdI
   lg3CY3ADZgrkd3mYazYYge05mnh/RwUA7+shfclkn9g/xGkzZkDK9yq9+
   RR8Dxs71Nj07+877i0WAm7V6OS3h5g1s+xT9ev/uLwoZWg9kadAovCoiY
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9430569"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9430569"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:29:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2086774"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:29:27 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v4 65/66] i386/tdx: Don't get/put guest state for TDX VMs
Date: Wed, 24 Jan 2024 22:23:27 -0500
Message-Id: <20240125032328.2522472-66-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <sean.j.christopherson@intel.com>

Don't get/put state of TDX VMs since accessing/mutating guest state of
production TDs is not supported.

Note, it will be allowed for a debug TD. Corresponding support will be
introduced when debug TD support is implemented in the future.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/kvm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 109f778ba14d..bad00da37c2f 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4633,6 +4633,11 @@ int kvm_arch_put_registers(CPUState *cpu, int level)
 
     assert(cpu_is_stopped(cpu) || qemu_cpu_is_self(cpu));
 
+    /* TODO: Allow accessing guest state for debug TDs. */
+    if (is_tdx_vm()) {
+        return 0;
+    }
+
     /*
      * Put MSR_IA32_FEATURE_CONTROL first, this ensures the VM gets out of VMX
      * root operation upon vCPU reset. kvm_put_msr_feature_control() should also
@@ -4733,6 +4738,12 @@ int kvm_arch_get_registers(CPUState *cs)
     if (ret < 0) {
         goto out;
     }
+
+    /* TODO: Allow accessing guest state for debug TDs. */
+    if (is_tdx_vm()) {
+        return 0;
+    }
+
     ret = kvm_getput_regs(cpu, 0);
     if (ret < 0) {
         goto out;
-- 
2.34.1


