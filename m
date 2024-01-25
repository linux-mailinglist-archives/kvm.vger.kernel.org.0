Return-Path: <kvm+bounces-6962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92B5C83B847
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:34:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34C431F25D07
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B61A312B72;
	Thu, 25 Jan 2024 03:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G4iKhvxF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3798830
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153479; cv=none; b=Ik+WwtsOe9Den00Iajp8FEh3qX+SiC6JNBmpNcZ56lSUU0j/v4JGKgLexYbexpBzpdM6D7aFdBsFzePWFiZKAJvFrjtd2etRkPfwGUOki01WOynVogvFvddXdfqEk53vsL3OAp2/Aie4O/ry8D0QtKVVV7BTOZ/qp/jYH8NxsUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153479; c=relaxed/simple;
	bh=4/L/zFftOASDg8dMA/HkiVMm8CbnS0xqfd/o4PC3bt4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YfypBPWOLg3SIKaCLR4otjDf/bpQn5iKo4rTCs0dMP6ZCqCCNTKjsSER6ONkcmGYna0r7l8C9cSa45APKEuVyhfMQ3NUpcxed1VzmJbVJm1G0XUehP6KgDzO25U2UCBonxVIDEFo18p+SioVqqvi7a8yFDUoKVq2FnBVvmiZXaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G4iKhvxF; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153478; x=1737689478;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4/L/zFftOASDg8dMA/HkiVMm8CbnS0xqfd/o4PC3bt4=;
  b=G4iKhvxFX+hAY+RGUlh5koI9D2mKCrmNMDibmKM3CRXOoN5W++3lQZGw
   +aJsW3M/lnF+zqttE5kcElSE/eVt3ZhmxGKN4Lq1ExL9PYDeGHAtIPeqK
   F5UiuPB9wrBCnbDGfip4oE0lVPqDtqThv4qhklPrfTdqf9AzeiDZi3+6k
   trVySTs+kkOUb7gZz4/zgvlzLckZQc9W+vs+c1jeLolyw8tLH0cY+vjp/
   RasIBVJxW8mu7Ti7yGiX7s9bm98nbf7CDy8HqCPX8p5g+caO7+7jLdh3a
   nvvW7BahFlcBo0QzTcZf+e4lLuhyB5TpXBDue4gYJmGEto4yNgs2Jf5kG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9430450"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9430450"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:29:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2086516"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:29:00 -0800
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
Subject: [PATCH v4 60/66] hw/i386: add eoi_intercept_unsupported member to X86MachineState
Date: Wed, 24 Jan 2024 22:23:22 -0500
Message-Id: <20240125032328.2522472-61-xiaoyao.li@intel.com>
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

Add a new bool member, eoi_intercept_unsupported, to X86MachineState
with default value false. Set true for TDX VM.

Inability to intercept eoi causes impossibility to emulate level
triggered interrupt to be re-injected when level is still kept active.
which affects interrupt controller emulation.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 hw/i386/x86.c         | 1 +
 include/hw/i386/x86.h | 1 +
 target/i386/kvm/tdx.c | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index f13f49069d40..504575abfa98 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1422,6 +1422,7 @@ static void x86_machine_initfn(Object *obj)
     x86ms->oem_table_id = g_strndup(ACPI_BUILD_APPNAME8, 8);
     x86ms->bus_lock_ratelimit = 0;
     x86ms->above_4g_mem_start = 4 * GiB;
+    x86ms->eoi_intercept_unsupported = false;
 }
 
 static void x86_machine_class_init(ObjectClass *oc, void *data)
diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
index ab1d38569019..b689feb389b3 100644
--- a/include/hw/i386/x86.h
+++ b/include/hw/i386/x86.h
@@ -59,6 +59,7 @@ struct X86MachineState {
 
     /* CPU and apic information: */
     bool apic_xrupt_override;
+    bool eoi_intercept_unsupported;
     unsigned pci_irq_mask;
     unsigned apic_id_limit;
     uint16_t boot_cpus;
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 838b7916278c..c844d753736c 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -715,6 +715,8 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
         return -EINVAL;
     }
 
+    x86ms->eoi_intercept_unsupported = true;
+
     if (!tdx_caps) {
         r = get_tdx_capabilities(errp);
         if (r) {
-- 
2.34.1


