Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBEE2524349
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 05:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239999AbiELDV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 23:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344520AbiELDU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 23:20:57 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1C9DF0B
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 20:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652325654; x=1683861654;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NHKGCbrxezr1DtKhhV4XECsgf11so5OSfvqZQGOrcvo=;
  b=iMJEtz00BeuMiiHsZXyAgSo1jqKNag3kp3AeniwSPE/iqddfDIulHjXS
   I+vsYQ4Q1gY8kaFk6jmcwYW1dCtaf3gJlDuHbycoCVsWIZW5F3u8B9LkI
   wxlDOMAxkzYhQ1ERbGwzHSpBvrj9O+1cJcVXPtm3Kt4LN7WI7LXeOd2Qp
   +j2xzhZXDiZ3sqL5XcovNLG5uT5+hdjRyuaOKhIhE9EfxgS+NuvmCneCY
   gYfSCq/oEgExFKEamfEjBVIoFD8PN2KAXjAAklWEcbOWgvQZVjrZTngSh
   z+sW497RwAdbLH8VdtMq+WphnrHucSgMYmJTEJCUGYDK4JVAdWdEWL6xO
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="269815689"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="269815689"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 20:20:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="594456743"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga008.jf.intel.com with ESMTP; 11 May 2022 20:20:49 -0700
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
Subject: [RFC PATCH v4 34/36] i386/tdx: Skip kvm_put_apicbase() for TDs
Date:   Thu, 12 May 2022 11:18:01 +0800
Message-Id: <20220512031803.3315890-35-xiaoyao.li@intel.com>
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

KVM doesn't allow wirting to MSR_IA32_APICBASE for TDs.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 9c5bf075b542..4d520d0e34bd 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2907,6 +2907,11 @@ void kvm_put_apicbase(X86CPU *cpu, uint64_t value)
 {
     int ret;
 
+    /* TODO: Allow accessing guest state for debug TDs. */
+    if (is_tdx_vm()) {
+        return;
+    }
+
     ret = kvm_put_one_msr(cpu, MSR_IA32_APICBASE, value);
     assert(ret == 1);
 }
-- 
2.27.0

