Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05F23BF310
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhGHA6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:58:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:19087 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230228AbhGHA6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="209462004"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="209462004"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:57 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770069"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:57 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 25/44] q35: Move PCIe BAR check above PAM check in mch_write_config()
Date:   Wed,  7 Jul 2021 17:54:55 -0700
Message-Id: <caa101c6aead2deddb67e52dd5a7d22670ca774c.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Process PCIe BAR before PAM so that a future patch can skip all the SMM
related crud with a single check-and-return.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 hw/pci-host/q35.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/hw/pci-host/q35.c b/hw/pci-host/q35.c
index 2eb729dff5..9a2be237d7 100644
--- a/hw/pci-host/q35.c
+++ b/hw/pci-host/q35.c
@@ -468,16 +468,16 @@ static void mch_write_config(PCIDevice *d,
 
     pci_default_write_config(d, address, val, len);
 
-    if (ranges_overlap(address, len, MCH_HOST_BRIDGE_PAM0,
-                       MCH_HOST_BRIDGE_PAM_SIZE)) {
-        mch_update_pam(mch);
-    }
-
     if (ranges_overlap(address, len, MCH_HOST_BRIDGE_PCIEXBAR,
                        MCH_HOST_BRIDGE_PCIEXBAR_SIZE)) {
         mch_update_pciexbar(mch);
     }
 
+    if (ranges_overlap(address, len, MCH_HOST_BRIDGE_PAM0,
+                       MCH_HOST_BRIDGE_PAM_SIZE)) {
+        mch_update_pam(mch);
+    }
+
     if (ranges_overlap(address, len, MCH_HOST_BRIDGE_SMRAM,
                        MCH_HOST_BRIDGE_SMRAM_SIZE)) {
         mch_update_smram(mch);
-- 
2.25.1

