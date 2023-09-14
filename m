Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8D6579F916
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 05:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbjINDwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 23:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbjINDwN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 23:52:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2483D193
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 20:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694663529; x=1726199529;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WYVBZ6N9BbdY7ZsfmGtk4oyUMldz486IyDgKkpOyBr4=;
  b=DIrb8MNo7A/KZmewECEmS91nUmO8076l4wHO+kD6NlJE/LlXcBdkQOfX
   KOsvnfFeh6OXo/fhep3cdTEgh8a8AbVhdksOcb0iS5XJ+crSAJJ24nDyM
   4xm60I53CXrAJkERj9JdDruP+R8dXlSG1dHKdss9JUKyYkjbiRGx+FaAb
   a0s/8oomMiaREtBIksjlzT7hIfer6ZqMmP3KeoJls1AF7576QKzu5qd4Y
   koOjvlrb41U4J8/hgdQvRD7FQbdhGe7riImyyQDSVXBGZ7dU4sOgk+CXq
   BBduCdaBROmuvLZLXeYFNP5sTXR4NnEThS4YWBwEbTb2aAeVgt8wX/VJP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="381528439"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="381528439"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 20:52:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="814500603"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="814500603"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmsmga004.fm.intel.com with ESMTP; 13 Sep 2023 20:52:04 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, xiaoyao.li@intel.com,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
Subject: [RFC PATCH v2 10/21] i386/kvm: Implement kvm_sw_protected_vm_init() for sw-protcted-vm specific functions
Date:   Wed, 13 Sep 2023 23:51:06 -0400
Message-Id: <20230914035117.3285885-11-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914035117.3285885-1-xiaoyao.li@intel.com>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm.c             |  2 ++
 target/i386/kvm/sw-protected-vm.c | 10 ++++++++++
 target/i386/kvm/sw-protected-vm.h |  2 ++
 3 files changed, 14 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index fb1be16471b4..e126bf4e7ddd 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2587,6 +2587,8 @@ static int kvm_confidential_guest_init(MachineState *ms, Error **errp)
 {
     if (object_dynamic_cast(OBJECT(ms->cgs), TYPE_SEV_GUEST)) {
         return sev_kvm_init(ms->cgs, errp);
+    } else if (object_dynamic_cast(OBJECT(ms->cgs), TYPE_SW_PROTECTED_VM)) {
+        return sw_protected_vm_kvm_init(ms, errp);
     }
 
     return 0;
diff --git a/target/i386/kvm/sw-protected-vm.c b/target/i386/kvm/sw-protected-vm.c
index 62a1d3d5d3fe..3cfcc89202a6 100644
--- a/target/i386/kvm/sw-protected-vm.c
+++ b/target/i386/kvm/sw-protected-vm.c
@@ -10,10 +10,20 @@
  */
 
 #include "qemu/osdep.h"
+#include "qapi/error.h"
 #include "qom/object_interfaces.h"
 
+#include "hw/i386/x86.h"
 #include "sw-protected-vm.h"
 
+int sw_protected_vm_kvm_init(MachineState *ms, Error **errp)
+{
+    SwProtectedVm *spvm = SW_PROTECTED_VM(OBJECT(ms->cgs));
+
+    spvm->parent_obj.ready = true;
+    return 0;
+}
+
 /* x86-sw-protected-vm */
 OBJECT_DEFINE_TYPE_WITH_INTERFACES(SwProtectedVm,
                                    sw_protected_vm,
diff --git a/target/i386/kvm/sw-protected-vm.h b/target/i386/kvm/sw-protected-vm.h
index db192a81c75e..15f63bfc7c60 100644
--- a/target/i386/kvm/sw-protected-vm.h
+++ b/target/i386/kvm/sw-protected-vm.h
@@ -14,4 +14,6 @@ typedef struct SwProtectedVm {
     ConfidentialGuestSupport parent_obj;
 } SwProtectedVm;
 
+int sw_protected_vm_kvm_init(MachineState *ms, Error **errp);
+
 #endif /* QEMU_I386_SW_PROTECTED_VM_H */
-- 
2.34.1

