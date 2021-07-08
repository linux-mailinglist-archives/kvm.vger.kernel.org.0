Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C043BF2FB
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhGHA6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:58:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:27077 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230093AbhGHA6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="209381416"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="209381416"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:52 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423769985"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:52 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH v2 02/44] kvm: Switch KVM_CAP_READONLY_MEM to a per-VM ioctl()
Date:   Wed,  7 Jul 2021 17:54:32 -0700
Message-Id: <20f5a78e8c704adcf4e96dac4aa160b9b6a7c17c.1625704980.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Switch to making a VM ioctl() call for KVM_CAP_READONLY_MEM, which may
be conditional on VM type in recent versions of KVM, e.g. when TDX is
supported.

kvm_vm_check_extension() has fallback from kvm_vm_ioctl() to
kvm_check_extension(). fallback from VM ioctl to System ioctl for
compatibility for old kernel.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 accel/kvm/kvm-all.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index e5b10dd129..fdbe24bf59 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2531,7 +2531,7 @@ static int kvm_init(MachineState *ms)
     }
 
     kvm_readonly_mem_allowed =
-        (kvm_check_extension(s, KVM_CAP_READONLY_MEM) > 0);
+        (kvm_vm_check_extension(s, KVM_CAP_READONLY_MEM) > 0);
 
     kvm_eventfds_allowed =
         (kvm_check_extension(s, KVM_CAP_IOEVENTFD) > 0);
-- 
2.25.1

