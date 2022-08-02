Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A611F58784C
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 09:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236271AbiHBHtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 03:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236277AbiHBHt1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 03:49:27 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F984D4E6
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 00:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659426561; x=1690962561;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uul3YJcjjpvTL+VJ3IbPV04Rp1hlUCqsdWMK1rBL9NQ=;
  b=AhvjKcoe+ee7Xmd1C4uYHub9Q9U99A8WpRKFbWsa7aJs0dwrohKXSiF5
   lRUSxOHfUPAoFvX14H/W1Jv8YFio6ze0f+FHR1Ps+eoHDt/GKO3mfKXpj
   2G30u7NndHFadBZtK/xIckxv/VNCRYDoGZAyH2sUFZB9E/enFSEgTO25G
   YffR6oxZSvL5eJXgE+ecLrJfELA8KRxB4F9izQFCpyZudYMj0Bcvnsp+x
   ovryfIJV2pfZ5EMQcj+eOL6mMqv+AHXvUoqOuZf7GD5XWxXm9PPdFt0Z1
   v55bp6EQuTzKpywQsnElVYGDemg2AAHstCsFVy8rv0IAGbHIsIgnsqA14
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="272393035"
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="272393035"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 00:49:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="630604076"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by orsmga008.jf.intel.com with ESMTP; 02 Aug 2022 00:49:13 -0700
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
Subject: [PATCH v1 19/40] i386/tdx: Set kvm_readonly_mem_enabled to false for TDX VM
Date:   Tue,  2 Aug 2022 15:47:29 +0800
Message-Id: <20220802074750.2581308-20-xiaoyao.li@intel.com>
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

TDX only supports readonly for shared memory but not for private memory.

In the view of QEMU, it has no idea whether a memslot is used as shared
memory of private. Thus just mark kvm_readonly_mem_enabled to false to
TDX VM for simplicity.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 0162d7cc9df4..3aa0e374a514 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -461,6 +461,15 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
 
     update_tdx_cpuid_lookup_by_tdx_caps();
 
+    /*
+     * Set kvm_readonly_mem_allowed to false, because TDX only supports readonly
+     * memory for shared memory but not for private memory. Besides, whether a
+     * memslot is private or shared is not determined by QEMU.
+     *
+     * Thus, just mark readonly memory not supported for simplicity.
+     */
+    kvm_readonly_mem_allowed = false;
+
     tdx_guest = tdx;
 
     return 0;
-- 
2.27.0

