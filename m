Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56F92552FF
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 04:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgH1CXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 22:23:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:59192 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbgH1CXr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 22:23:47 -0400
IronPort-SDR: pB787b9SVTfxWrgsbQEwCJ5wjotTKH+lqJ/t4Lt8D+qRCX1jGLv0mOmTx6HBTwUw5fBpo8kcz8
 fnfYGDCm8aUQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="155854187"
X-IronPort-AV: E=Sophos;i="5.76,362,1592895600"; 
   d="scan'208";a="155854187"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2020 19:23:46 -0700
IronPort-SDR: 7sl2RJih5fz+4j3xz5Ii1TF2EZ6NoXPDUZNOQ+4Iin7PK/Zme5IsgDZYw322s8keY5IRaGdvYf
 htjG+3THcSlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,362,1592895600"; 
   d="scan'208";a="500863254"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga005.fm.intel.com with ESMTP; 27 Aug 2020 19:23:45 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, kvm@vger.kernel.org
Cc:     robert.hu@intel.com, Robert Hoo <robert.hu@linux.intel.com>
Subject: KVM: x86: emulating RDPID failure shall return #UD rather than #GP
Date:   Fri, 28 Aug 2020 10:23:42 +0800
Message-Id: <1598581422-76264-1-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Per Intel's SDM, RDPID takes a #UD if it is unsupported, which is more or
less what KVM is emulating when MSR_TSC_AUX is not available.  In fact,
there are no scenarios in which RDPID is supposed to #GP.

Fixes: fb6d4d340e (KVM: x86: emulate RDPID)
Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/emulate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index d0e2825..571cb86 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3594,7 +3594,7 @@ static int em_rdpid(struct x86_emulate_ctxt *ctxt)
 	u64 tsc_aux = 0;
 
 	if (ctxt->ops->get_msr(ctxt, MSR_TSC_AUX, &tsc_aux))
-		return emulate_gp(ctxt, 0);
+		return emulate_ud(ctxt);
 	ctxt->dst.val = tsc_aux;
 	return X86EMUL_CONTINUE;
 }
-- 
1.8.3.1

