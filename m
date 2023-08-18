Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3929578091A
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 11:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359450AbjHRJ4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 05:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359541AbjHRJzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 05:55:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC49358A
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352545; x=1723888545;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6cFkrPNCb17CCssjC/bgO3WXZqeaHPqPUR2vaMW3tvg=;
  b=cMe51Ws+4F0h0hWe+cE6GPzM2qsChBw/GQHYfp/r6AzPGBu8IE6Ha+E+
   dfgfJPTxt3FGRmtrtOaT/vxj9dmYl1nfHJog+ITPu7JpnpzDKNfvaHkT8
   t92BSN07yd15zIzUA/ldaU6NTYDFhQnaPRjyvbARLXGl9du6YC0tCTpTi
   YuVGfFKwjmtORANmihkUe+viRzMa+OzZqowWEAzBYp2TeUKW6xQRdrsWm
   1Ng4T88q3ZYBnRorZE1a/Drq/aUFr7rsK9vjWdwaBQM/PUz9VaaGf8pov
   N4P+jK2QLrrQ5x1MTfWUC+cNxnqPVl+sY9jBSnSxKLQmRgd5oKi2llMAi
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371965827"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371965827"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:55:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849234906"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849234906"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:55:30 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>, xiaoyao.li@intel.com,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v2 13/58] kvm: Introduce kvm_arch_pre_create_vcpu()
Date:   Fri, 18 Aug 2023 05:49:56 -0400
Message-Id: <20230818095041.1973309-14-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230818095041.1973309-1-xiaoyao.li@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce kvm_arch_pre_create_vcpu(), to perform arch-dependent
work prior to create any vcpu. This is for i386 TDX because it needs
call TDX_INIT_VM before creating any vcpu.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 accel/kvm/kvm-all.c  | 12 ++++++++++++
 include/sysemu/kvm.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index c9f3aab5e587..5071af917ae0 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -422,6 +422,11 @@ static int kvm_get_vcpu(KVMState *s, unsigned long vcpu_id)
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
@@ -430,6 +435,13 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
 
     trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
 
+    ret = kvm_arch_pre_create_vcpu(cpu);
+    if (ret < 0) {
+        error_setg_errno(errp, -ret, "%s: kvm_arch_pre_create_vcpu() failed",
+                        __func__);
+        goto err;
+    }
+
     ret = kvm_get_vcpu(s, kvm_arch_vcpu_id(cpu));
     if (ret < 0) {
         error_setg_errno(errp, -ret, "kvm_init_vcpu: kvm_get_vcpu failed (%lu)",
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 49c896d8a512..d89ec87072d7 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -371,6 +371,7 @@ int kvm_arch_put_registers(CPUState *cpu, int level);
 
 int kvm_arch_init(MachineState *ms, KVMState *s);
 
+int kvm_arch_pre_create_vcpu(CPUState *cpu);
 int kvm_arch_init_vcpu(CPUState *cpu);
 int kvm_arch_destroy_vcpu(CPUState *cpu);
 
-- 
2.34.1

