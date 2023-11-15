Return-Path: <kvm+bounces-1793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F3937EBDF8
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:24:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBE7828146C
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:24:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82E25BA2E;
	Wed, 15 Nov 2023 07:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n8cOZVMm"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248E3525F
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:23:45 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D01D101
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700033023; x=1731569023;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hvMwJXDcUQge67eIhhUdTeDE/Yqg86sFgeotlAtJ8LY=;
  b=n8cOZVMmPfmaPPNMGixkgBS/sz+Vhx/Hbxyno3vHvFgpoVZZ7CWiJXnE
   R4lzI+TcyE5D/6rpmB8GzMEJ8jBdyS3p8Unxx0dkNxGAldKwCeL5YrKaX
   eTIV1OTRP+8VSkqhus0A85OTsAcyQQnecIrNfv8sO3nIUmKCkL69PcTPC
   iQS+j7+NPIOxD0FQASooEQ9P7uxOAjX5VXnI5/HXS1kcq9YhC20YKZdAQ
   8GBTTGE+5VjTaw/82m3v1izFpvEYrSWnts1GE9gnVPE5c0rn3ULcNVF1Q
   NIlqWHvcxW4XJM8GLpZdSYmZ0TtngwIkDnsBYjWKPGAuRgXryLMyL49GD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390623658"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390623658"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:23:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714800406"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714800406"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:23:36 -0800
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
Subject: [PATCH v3 64/70] hw/i386: add eoi_intercept_unsupported member to X86MachineState
Date: Wed, 15 Nov 2023 02:15:13 -0500
Message-Id: <20231115071519.2864957-65-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
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
index 0f69b55c5219..58206396c2da 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1413,6 +1413,7 @@ static void x86_machine_initfn(Object *obj)
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
index 208fe3572839..1e8875f4af34 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -706,6 +706,8 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
         return -EINVAL;
     }
 
+    x86ms->eoi_intercept_unsupported = true;
+
     if (!tdx_caps) {
         r = get_tdx_capabilities(errp);
         if (r) {
-- 
2.34.1


