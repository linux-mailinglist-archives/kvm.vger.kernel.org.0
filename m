Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B98A647E08
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 07:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiLIGx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 01:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiLIGxR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 01:53:17 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D2626C;
        Thu,  8 Dec 2022 22:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670568796; x=1702104796;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CvOOEOyK2b3ch9pD2o6ehuG6OyGC9zRQ6+5y2KsnA+o=;
  b=noQnsf+vRzgnWLSFBOWDa77igmaP8TXnTLfexxV/Wbx9UYX+rR3Mz3em
   Xew9Bb5WfFhAU3HuldmD/97JmyMtbaqzl52r1kHcwbrZ6u4zz+q57MhZv
   L67hBTQXfS1AD0TkQ2IkqMK1fbW9nHGDn7VdsT7JZ/jkg5ggr+PIt7mZg
   fhPNN+TZf3dPepnCKthpWVvq21fD0lcXzldv+lfLl5R+QTTJ0Ip3OFkKk
   kLdDCFExTJRcL4X09Y5GnC2+dpSyk0+aSNFLZAZCc0HaxZ+h+deWV1LCZ
   1/gbXhtTTJnUorCP3MYnIxXlSjbFPQBm5UbL9SG/IbzUvgQhpE1Nh14fR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318551286"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="318551286"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:53:15 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="679836822"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="679836822"
Received: from omiramon-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.28.82])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:53:11 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v8 03/16] x86/virt/tdx: Make INTEL_TDX_HOST depend on X86_X2APIC
Date:   Fri,  9 Dec 2022 19:52:24 +1300
Message-Id: <514a6c330ef5fc214d32bcbcc7a77dc825e857df.1670566861.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670566861.git.kai.huang@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDX capable platforms are locked to X2APIC mode and cannot fall back to
the legacy xAPIC mode when TDX is enabled by the BIOS.  TDX host support
requires x2APIC.  Make INTEL_TDX_HOST depend on X86_X2APIC.

Link: https://lore.kernel.org/lkml/ba80b303-31bf-d44a-b05d-5c0f83038798@intel.com/
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v7 -> v8: (Dave)
 - Only make INTEL_TDX_HOST depend on X86_X2APIC but removed other code
 - Rewrote the changelog.

v6 -> v7:
 - Changed to use "Link" for the two lore links to get rid of checkpatch
   warning.

---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cced4ef3bfb2..dd333b46fafb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1958,6 +1958,7 @@ config INTEL_TDX_HOST
 	depends on CPU_SUP_INTEL
 	depends on X86_64
 	depends on KVM_INTEL
+	depends on X86_X2APIC
 	help
 	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
 	  host and certain physical attacks.  This option enables necessary TDX
-- 
2.38.1

