Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4E958785F
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 09:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236327AbiHBHvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 03:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236226AbiHBHuw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 03:50:52 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950634BD3D
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 00:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659426630; x=1690962630;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rj1dZCAXhln2crXrSUkiy4OQPiD7hxtS5+RQUY19t7M=;
  b=iJTgy1Pyfge6h1rHlm3JPrFRYmFDkZw9k1Yo/1QIOM7HNQJ1vzN7emqp
   ZQF2JUa4lolF7CiPLfrv2ko0/Xqocu12dr1NWTdO83jsTNBNU+eptJA2a
   jQrOFRvUshZIy0B3C5N9e+N5z93fjIz+/BIImuRR5ix9+/7ya5vodkbJQ
   I1+q7WJ8QQ9qGeun/iCeB7UJK79FWf8zTO9mygrAHZow6iDXta4Qx7eOf
   OduSmb2/rSqTGskI4CeGmGPkovyRCUiaFbM5ZtUqYNivjdloA5ioFmo5g
   8Uw66EkaZA1HQsXhtAlBpSy6R4vBn3s3IvGPaKBbknhhq5JrsX95VpSJK
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="272393223"
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="272393223"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 00:50:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="630604490"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by orsmga008.jf.intel.com with ESMTP; 02 Aug 2022 00:50:26 -0700
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
Subject: [PATCH v1 36/40] i386/tdx: Don't synchronize guest tsc for TDs
Date:   Tue,  2 Aug 2022 15:47:46 +0800
Message-Id: <20220802074750.2581308-37-xiaoyao.li@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

TSC of TDs is not accessible and KVM doesn't allow access of
MSR_IA32_TSC for TDs. To avoid the assert() in kvm_get_tsc, make
kvm_synchronize_all_tsc() noop for TDs,

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 8c282122ed67..8999f64eeaf1 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -270,7 +270,7 @@ void kvm_synchronize_all_tsc(void)
 {
     CPUState *cpu;
 
-    if (kvm_enabled()) {
+    if (kvm_enabled() && !is_tdx_vm()) {
         CPU_FOREACH(cpu) {
             run_on_cpu(cpu, do_kvm_synchronize_tsc, RUN_ON_CPU_NULL);
         }
-- 
2.27.0

