Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4C678096F
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 12:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359574AbjHRKBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 06:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359640AbjHRKAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 06:00:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096884480
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 03:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352823; x=1723888823;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uNo7+NyR81+K5fUdIN/+i7RIlVlk02u9iCispLP0OnQ=;
  b=TM2jSapTWdniS6AvQjbovB8a7RosrEIs7j8BmgrzZ3DvxlsqCELFzIUF
   msCcjVCzcJpHmXQEBdUlUaTolUbD9z6i4qEYZB7kvUQTaO/gQBjglqz+w
   1SYpJXkvXBAX0wHGl1uGn/S8IUjBvfMI4b+qwX8fzUyLFk2/pNSpDgJqm
   Sj0ONwsopoY1E2lKAB1Rd3p2bHBreYA+T4L9Z6ptaujPX4eLYYJjJT71I
   jVaFJL07Zxzh7fv5bW+zmHI7jVS9ApYL1/zPgvG2nZbHs6lcFLyQYhdBh
   f07STMRbUWGl7taxkaVZoj2iWgrBfO5yyFyHbqyMKGKYshcTs7D+n0j/A
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371966812"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371966812"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:58:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235601"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235601"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:58:32 -0700
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
Subject: [PATCH v2 48/58] i386/tdx: Disable SMM for TDX VMs
Date:   Fri, 18 Aug 2023 05:50:31 -0400
Message-Id: <20230818095041.1973309-49-xiaoyao.li@intel.com>
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

TDX doesn't support SMM and VMM cannot emulate SMM for TDX VMs because
VMM cannot manipulate TDX VM's memory.

Disable SMM for TDX VMs and error out if user requests to enable SMM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 7efaa13f59e2..f9d03ab0f461 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -678,9 +678,17 @@ static Notifier tdx_machine_done_notify = {
 
 int tdx_kvm_init(MachineState *ms, Error **errp)
 {
+    X86MachineState *x86ms = X86_MACHINE(ms);
     TdxGuest *tdx = (TdxGuest *)object_dynamic_cast(OBJECT(ms->cgs),
                                                     TYPE_TDX_GUEST);
 
+    if (x86ms->smm == ON_OFF_AUTO_AUTO) {
+        x86ms->smm = ON_OFF_AUTO_OFF;
+    } else if (x86ms->smm == ON_OFF_AUTO_ON) {
+        error_setg(errp, "TDX VM doesn't support SMM");
+        return -EINVAL;
+    }
+
     if (!tdx_caps) {
         get_tdx_capabilities();
     }
-- 
2.34.1

