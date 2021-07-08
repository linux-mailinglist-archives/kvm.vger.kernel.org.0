Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617763BF322
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhGHA7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:59:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:23555 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230314AbhGHA6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="231168456"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="231168456"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:56:00 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770130"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:59 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH v2 43/44] i386/tdx: disallow level interrupt and SMI/INIT/SIPI delivery mode
Date:   Wed,  7 Jul 2021 17:55:13 -0700
Message-Id: <b3d3f090addefaef29d2027024cb6c4056e5996d.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX doesn't allow level interrupt and SMI/INIT/SIPI interrupt delivery
mode.  So disallow them.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 hw/i386/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 24af05c313..c372403b87 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1307,6 +1307,9 @@ static int x86_kvm_type(MachineState *ms, const char *vm_type)
         kvm_type = KVM_X86_LEGACY_VM;
     } else if (!g_ascii_strcasecmp(vm_type, "tdx")) {
         kvm_type = KVM_X86_TDX_VM;
+        X86_MACHINE(ms)->eoi_intercept_unsupported = true;
+        X86_MACHINE(ms)->smi_unsupported = true;
+        X86_MACHINE(ms)->init_sipi_unsupported = true;
     } else {
         error_report("Unknown kvm-type specified '%s'", vm_type);
         exit(1);
-- 
2.25.1

