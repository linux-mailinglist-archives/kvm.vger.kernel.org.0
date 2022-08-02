Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB173587858
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 09:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236262AbiHBHux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 03:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236174AbiHBHu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 03:50:29 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B144F189
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 00:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659426606; x=1690962606;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xq2DWPjLy2Y9eGD+PkvghS7cMwBE0EZvQqHMGb0g0VY=;
  b=aZGaRz0bnfynErTbbhgbIUJoGJetLW1Hc7JPjMfHy8xWs0ArxCo4nCKp
   D9Vz+ZXxcTMn8EzlYl4DoYquMOqk1SHNAkTlvhYdZPPr9jIJBkJtqwmPJ
   4ovgci/qjXZ3NkwwYhDmr4cqZfYEbBwSlPL6jI3LqXLSRTEiSgDBwmKHa
   YQfyqMaTyizAoGsvVR4i86lsUgRX2crQ1u12xfpgHuw6duSss67rrtuHz
   048CX9Sx5nh7l1gNfCXl9UthQprFyqepokcm73GbsQIMUFqWaXb9ZicEU
   HmBFkC1NNzlAX1r2xGvgiTlmkwfMwTUF+c8A/Qb6SGKdBCjhxk3K88vEu
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="272393135"
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="272393135"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 00:50:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="630604292"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by orsmga008.jf.intel.com with ESMTP; 02 Aug 2022 00:49:56 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
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
Subject: [PATCH v1 29/40] i386/tdx: Call KVM_TDX_INIT_VCPU to initialize TDX vcpu
Date:   Tue,  2 Aug 2022 15:47:39 +0800
Message-Id: <20220802074750.2581308-30-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220802074750.2581308-1-xiaoyao.li@intel.com>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDX vcpu needs to be initialized by SEAMCALL(TDH.VP.INIT) and KVM
provides vcpu level IOCTL KVM_TDX_INIT_VCPU for it.

KVM_TDX_INIT_VCPU needs the address of the HOB as input. Invoke it for
each vcpu after HOB list is created.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index d0bbe06f5504..2dbe26f2e950 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -571,6 +571,22 @@ static void tdx_init_ram_entries(void)
     tdx_guest->nr_ram_entries = j;
 }
 
+static void tdx_post_init_vcpus(void)
+{
+    TdxFirmwareEntry *hob;
+    CPUState *cpu;
+    int r;
+
+    hob = tdx_get_hob_entry(tdx_guest);
+    CPU_FOREACH(cpu) {
+        r = tdx_vcpu_ioctl(cpu, KVM_TDX_INIT_VCPU, 0, (void *)hob->address);
+        if (r < 0) {
+            error_report("KVM_TDX_INIT_VCPU failed %s", strerror(-r));
+            exit(1);
+        }
+    }
+}
+
 static void tdx_finalize_vm(Notifier *notifier, void *unused)
 {
     TdxFirmware *tdvf = &tdx_guest->tdvf;
@@ -602,6 +618,8 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
 
     tdvf_hob_create(tdx_guest, tdx_get_hob_entry(tdx_guest));
 
+    tdx_post_init_vcpus();
+
     for_each_tdx_fw_entry(tdvf, entry) {
         struct kvm_tdx_init_mem_region mem_region = {
             .source_addr = (__u64)entry->mem_ptr,
-- 
2.27.0

