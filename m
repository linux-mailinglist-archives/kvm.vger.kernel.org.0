Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7B952E5F4
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 09:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346348AbiETHLr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 03:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346425AbiETHLm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 03:11:42 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8881D1C111
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 00:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653030700; x=1684566700;
  h=from:to:cc:subject:date:message-id;
  bh=uf7bQKdvNgjIJ75NdNzkRfUPgeKm6dafbA5aTQIT7TA=;
  b=OZszUx00o6s6+2ocO8y4HNVwRkJI2x8+RiTpnCtFNahjjZhrsN+byxL+
   SJ3UsZaaCXi11pGu9KkJRCkLDeV4dS6UI0OAEILMAdE5JKdMP+awRM4oj
   58ceD4bRkuc4X78rN6bUTDGT45r0Sjw0IlFFscztyqEpdTki18iDYYUW9
   PBtGFC6hKoMcgVXZ/kJ+YBQ/3hwvCyPQotAc5b58xE9W81OHnDWTiPLVO
   ueMDMMnrvXUhYn91ycWi3xRp5cNMkz1JbAAoEFUvWGBhAU7SY6hRwJuW5
   nJVUuAYALcsUtnyex2d9jvDRFRMySHXGlsp2QlcoO67Kv3tqi7+GrbLXv
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="272490052"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="272490052"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 00:11:35 -0700
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="599062888"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 00:11:32 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [QEMU PATCH] x86: Set maximum APIC ID to KVM prior to vCPU creation
Date:   Fri, 20 May 2022 14:39:28 +0800
Message-Id: <20220520063928.23645-1-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Specify maximum possible APIC ID assigned for current VM session prior to
the creation of vCPUs. KVM need set up VM-scoped data structure indexed by
the APIC ID, e.g. Posted-Interrupt Descriptor table to support Intel IPI
virtualization.

It can be achieved by calling KVM_ENABLE_CAP for KVM_CAP_MAX_VCPU_ID
capability once KVM has already enabled it. Otherwise, simply prompts
that KVM doesn't support this capability yet.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 hw/i386/x86.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 4cf107baea..ff74492325 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -106,7 +106,7 @@ out:
 
 void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
 {
-    int i;
+    int i, ret;
     const CPUArchIdList *possible_cpus;
     MachineState *ms = MACHINE(x86ms);
     MachineClass *mc = MACHINE_GET_CLASS(x86ms);
@@ -123,6 +123,13 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
      */
     x86ms->apic_id_limit = x86_cpu_apic_id_from_index(x86ms,
                                                       ms->smp.max_cpus - 1) + 1;
+
+    ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_MAX_VCPU_ID,
+                            0, x86ms->apic_id_limit);
+    if (ret < 0) {
+        error_report("kvm: Set max vcpu id not supported: %s", strerror(-ret));
+    }
+
     possible_cpus = mc->possible_cpu_arch_ids(ms);
     for (i = 0; i < ms->smp.cpus; i++) {
         x86_cpu_new(x86ms, possible_cpus->cpus[i].arch_id, &error_fatal);
-- 
2.27.0

