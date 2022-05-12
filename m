Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32AF152434D
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 05:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245616AbiELDTH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 23:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245722AbiELDS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 23:18:58 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEC1216842
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 20:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652325533; x=1683861533;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ydi5lNWOOmt6ipSyiWy75CTLt5tdTd2XbXMVzIN8u9c=;
  b=D+WgZK6N2CiN6yCMPn1sur4SA6FOAcjheQ0RDthshMWi7M0aYB81rFaS
   BYovTHr6NyDoAlEBPi7tGwQCK4ZhshECVPeNwzKittAXchGftTCjFUB7g
   vQSEkT5imOeGcdvuK4D+FxYAs3cYQ8SXl4L9bMp5l58ZLgzcsMR6OxtoO
   WtKOIrkGsPaUxIfOXvUQ8fL7JYYdVeYJj+1R0A3GzMJBU2wbXTgiFsTBb
   XitbEeQBL7+eSmW6Lkiu9/Xbhn8Jg2RPQYvNYc2oZEWRBwGzIuUyCOniG
   pILoEwASq7AiwB6zV81W9SY/9VQ5wd98IOEj6NabOfscdl8aNFw6K4DJ/
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="332914761"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="332914761"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 20:18:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="594455575"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga008.jf.intel.com with ESMTP; 11 May 2022 20:18:47 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com,
        xiaoyao.li@intel.com
Subject: [RFC PATCH v4 09/36] KVM: Introduce kvm_arch_pre_create_vcpu()
Date:   Thu, 12 May 2022 11:17:36 +0800
Message-Id: <20220512031803.3315890-10-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220512031803.3315890-1-xiaoyao.li@intel.com>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 accel/kvm/kvm-all.c  | 12 ++++++++++++
 include/sysemu/kvm.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 32e177bd26b4..e6fa9d23207a 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -457,6 +457,11 @@ static int kvm_get_vcpu(KVMState *s, unsigned long vcpu_id)
     return kvm_vm_ioctl(s, KVM_CREATE_VCPU, (void *)vcpu_id);
 }
 
+int __attribute__ ((weak)) kvm_arch_pre_create_vcpu(CPUState *cpu)
+{
+    return 0;
+}
+
 int kvm_init_vcpu(CPUState *cpu, Error **errp)
 {
     KVMState *s = kvm_state;
@@ -465,6 +470,13 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
 
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
 
-- 
2.27.0

