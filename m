Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECADD4DC81D
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 15:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbiCQOBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 10:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234800AbiCQOBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 10:01:15 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A1D89322
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 06:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647525598; x=1679061598;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a1ryONR5l3FOW34yLvx4vmx62tCL+BziXbr83jqcf20=;
  b=doBfHKoj/3PVI8bs0ARxBr8FV6W4+iUIyyId4p3A1l7C10F8SNx/keaF
   00yFKiPXUrFialHyWCP8wVSEsNVCDBJcrOAdmaDOPJbFOtUuQ0TiVG2r1
   /PddFnl85qCYOLgoGf5KKKICGugT8S6sMUCgg4OLdwX94turANGP8mqos
   NqkJsVzuzMEFYG5AUbE3oH3v94iyFUt3iaSeDjnEYaskm6EAEckgXyVF5
   0mlM1HwepWCm4TCCyvaw7TbDZxmyeTWzmuVdh064n80+/4NCtjYcap8BV
   MGAIMNqbaoDugkC1FborYeM7Ilurnw6UmgbuiztffD55hmxkRiZyLq1vN
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="257058309"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="257058309"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 06:59:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="541377942"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2022 06:59:54 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@intel.com,
        xiaoyao.li@intel.com, erdemaktas@google.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, seanjc@google.com
Subject: [RFC PATCH v3 09/36] KVM: Introduce kvm_arch_pre_create_vcpu()
Date:   Thu, 17 Mar 2022 21:58:46 +0800
Message-Id: <20220317135913.2166202-10-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220317135913.2166202-1-xiaoyao.li@intel.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce kvm_arch_pre_create_vcpu(), to perform arch-dependent
work prior to create any vcpu. This is for i386 TDX because it needs
call TDX_INIT_VM before creating any vcpu.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c    | 7 +++++++
 include/sysemu/kvm.h   | 1 +
 target/arm/kvm64.c     | 5 +++++
 target/i386/kvm/kvm.c  | 5 +++++
 target/mips/kvm.c      | 5 +++++
 target/ppc/kvm.c       | 5 +++++
 target/s390x/kvm/kvm.c | 5 +++++
 7 files changed, 33 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 27864dfaeaaa..a4bb449737a6 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -465,6 +465,13 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
 
     trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
 
+    ret = kvm_arch_pre_create_vcpu(cpu);
+    if (ret < 0) {
+        error_setg_errno(errp, -ret,
+                         "kvm_init_vcpu: kvm_arch_pre_create_vcpu() failed");
+        goto err;
+    }
+
     ret = kvm_get_vcpu(s, kvm_arch_vcpu_id(cpu));
     if (ret < 0) {
         error_setg_errno(errp, -ret, "kvm_init_vcpu: kvm_get_vcpu failed (%lu)",
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index a783c7886811..0e94031ab7c7 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -373,6 +373,7 @@ int kvm_arch_put_registers(CPUState *cpu, int level);
 
 int kvm_arch_init(MachineState *ms, KVMState *s);
 
+int kvm_arch_pre_create_vcpu(CPUState *cpu);
 int kvm_arch_init_vcpu(CPUState *cpu);
 int kvm_arch_destroy_vcpu(CPUState *cpu);
 
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index ccadfbbe72be..ae7336851c62 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -935,6 +935,11 @@ int kvm_arch_init_vcpu(CPUState *cs)
     return kvm_arm_init_cpreg_list(cpu);
 }
 
+int kvm_arch_pre_create_vcpu(CPUState *cpu)
+{
+    return 0;
+}
+
 int kvm_arch_destroy_vcpu(CPUState *cs)
 {
     return 0;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index ddbe8f64fadb..7bd5589e1e6c 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2102,6 +2102,11 @@ int kvm_arch_init_vcpu(CPUState *cs)
     return r;
 }
 
+int kvm_arch_pre_create_vcpu(CPUState *cpu)
+{
+    return 0;
+}
+
 int kvm_arch_destroy_vcpu(CPUState *cs)
 {
     X86CPU *cpu = X86_CPU(cs);
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index 086debd9f013..0647fe7c654a 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -92,6 +92,11 @@ int kvm_arch_init_vcpu(CPUState *cs)
     return ret;
 }
 
+int kvm_arch_pre_create_vcpu(CPUState *cpu)
+{
+    return 0;
+}
+
 int kvm_arch_destroy_vcpu(CPUState *cs)
 {
     return 0;
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index dc93b99189ea..c14a20b80f12 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -507,6 +507,11 @@ int kvm_arch_init_vcpu(CPUState *cs)
     return ret;
 }
 
+int kvm_arch_pre_create_vcpu(CPUState *cpu)
+{
+    return 0;
+}
+
 int kvm_arch_destroy_vcpu(CPUState *cs)
 {
     return 0;
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 6acf14d5ecb4..8170c5fad0b8 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -405,6 +405,11 @@ int kvm_arch_init_vcpu(CPUState *cs)
     return 0;
 }
 
+int kvm_arch_pre_create_vcpu(CPUState *cpu)
+{
+    return 0;
+}
+
 int kvm_arch_destroy_vcpu(CPUState *cs)
 {
     S390CPU *cpu = S390_CPU(cs);
-- 
2.27.0

