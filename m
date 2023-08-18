Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE9D78095D
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 12:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359585AbjHRKAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 06:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359611AbjHRJ76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 05:59:58 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2F04206
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352765; x=1723888765;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MEi5yolZ0+E3eMUW0iO/V0Km8RclMNSrAVIxdjs8Png=;
  b=ekhJJw66iXLrLf1A0RSurKgTjB5hB+ZBCv84VhXpCQw9/S+gF14rbT1l
   uNX32e51lhyzl0jIkbf+uSYE7vDQzEZ+5l5ups/WJ7E4ZfrXn6Ft9ac3H
   cEXrJ2jg7sbUi+LoWAErPh50360skbYdOtS3keunBBFftLdVo5QPeu0NB
   EgSbHOlteDcAN0q8JLsy3DBv8+9wzHp49sFQDWCcBysiG4lNia+qwlFAx
   ziL/AiE3CX0tEOpSNJ8BK3OZE6iLTv8pACl/Y43hVGXYc+y6gaJyJaRe9
   flIce0gUKlFhQ/TuhNcj2DQdcrri5yBIqPqayPGHbIwWcQVJmGNXoW2tv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371966597"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371966597"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:57:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235441"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235441"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:57:44 -0700
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
Subject: [PATCH v2 39/58] i386/tdx: Finalize TDX VM
Date:   Fri, 18 Aug 2023 05:50:22 -0400
Message-Id: <20230818095041.1973309-40-xiaoyao.li@intel.com>
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

Invoke KVM_TDX_FINALIZE_VM to finalize the TD's measurement and make
the TD vCPUs runnable once machine initialization is complete.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 2d0efca6787b..5eabdafbe95c 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -660,6 +660,13 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
     /* Tdvf image was copied into private region above. It becomes unnecessary. */
     ram_block = tdx_guest->tdvf_region->ram_block;
     ram_block_discard_range(ram_block, 0, ram_block->max_length);
+
+    r = tdx_vm_ioctl(KVM_TDX_FINALIZE_VM, 0, NULL);
+    if (r < 0) {
+        error_report("KVM_TDX_FINALIZE_VM failed %s", strerror(-r));
+        exit(0);
+    }
+    tdx_guest->parent_obj.ready = true;
 }
 
 static Notifier tdx_machine_done_notify = {
-- 
2.34.1

