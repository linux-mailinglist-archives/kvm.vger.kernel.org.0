Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D5E769C60
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbjGaQ0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233319AbjGaQ0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:26:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5A510CC
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690820750; x=1722356750;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pwuf6o/0F5t0zy4EgnbrfJ4zxZA0+H1hwL82VW6bQ/w=;
  b=mipjTJ1lhwR9C1Mrlp1Ih3C8yKSXE7ubIJoOMlX/N8owPXgqVG+opz4q
   4K7BhwyE1dGEhOF+tM5twrsuIwb0D3LPsPf/NL5ce/QXh4G7erIq+yP3d
   OKTMM56P8qR87JYQ97xgfv+ZJrIL8z5IPFXVn+kOjnP1tweOgRM/PNB3e
   UbU0JkKn81qvl86U/VLjFDVNw3M6n6bmeboUn+BO79xzvaA8tKUb8wiZo
   u5mvMYRoW9fmhRB/62fINib/xv+RJy+x5dH5CG/EOqUTMrJA+mJan1Tuz
   /LlSF68oiuxXO41//LIVkjYOHAs8d3ZSg5Cnozadk+x+20KwTxW6Y07jG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="353993521"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="353993521"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 09:25:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="757984290"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="757984290"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga008.jf.intel.com with ESMTP; 31 Jul 2023 09:25:42 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        xiaoyao.li@intel.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC PATCH 12/19] i386/kvm: Set memory to default private for KVM_X86_SW_PROTECTED_VM
Date:   Mon, 31 Jul 2023 12:21:54 -0400
Message-Id: <20230731162201.271114-13-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230731162201.271114-1-xiaoyao.li@intel.com>
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index df3a5f89396e..a96640512dbc 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2614,6 +2614,7 @@ static void kvm_x86_sw_protected_vm_region_add(MemoryListener *listenr,
             exit(1);
         }
         memory_region_set_gmem_fd(mr, fd);
+        memory_region_set_default_private(mr);
     }
 }
 
-- 
2.34.1

