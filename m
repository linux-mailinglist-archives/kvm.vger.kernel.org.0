Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC0A9B98EB
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 23:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387431AbfITVZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 17:25:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57976 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729784AbfITVZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 17:25:12 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 80B048980F5;
        Fri, 20 Sep 2019 21:25:12 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0833B10013D9;
        Fri, 20 Sep 2019 21:25:10 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/17] x86: spec_ctrl: fix SPEC_CTRL initialization after kexec
Date:   Fri, 20 Sep 2019 17:24:53 -0400
Message-Id: <20190920212509.2578-2-aarcange@redhat.com>
In-Reply-To: <20190920212509.2578-1-aarcange@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Fri, 20 Sep 2019 21:25:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We can't assume the SPEC_CTRL msr is zero at boot because it could be
left enabled by a previous kernel booted with
spec_store_bypass_disable=on.

Without this fix a boot with spec_store_bypass_disable=on followed by
a kexec boot with spec_store_bypass_disable=off would erroneously and
unexpectedly leave bit 2 set in SPEC_CTRL.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/include/asm/msr-index.h |  2 ++
 arch/x86/kernel/cpu/bugs.c       | 20 +++++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 20ce682a2540..3ba95728a6fe 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -47,6 +47,8 @@
 #define SPEC_CTRL_STIBP			BIT(SPEC_CTRL_STIBP_SHIFT)	/* STIBP mask */
 #define SPEC_CTRL_SSBD_SHIFT		2	   /* Speculative Store Bypass Disable bit */
 #define SPEC_CTRL_SSBD			BIT(SPEC_CTRL_SSBD_SHIFT)	/* Speculative Store Bypass Disable */
+#define SPEC_CTRL_ALL			(SPEC_CTRL_IBRS|SPEC_CTRL_STIBP| \
+					 SPEC_CTRL_SSBD) /* all known bits */
 
 #define MSR_IA32_PRED_CMD		0x00000049 /* Prediction Command */
 #define PRED_CMD_IBPB			BIT(0)	   /* Indirect Branch Prediction Barrier */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 91c2561b905f..e3922dcf252f 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -92,8 +92,26 @@ void __init check_bugs(void)
 	 * have unknown values. AMD64_LS_CFG MSR is cached in the early AMD
 	 * init code as it is not enumerated and depends on the family.
 	 */
-	if (boot_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
+	if (boot_cpu_has(X86_FEATURE_MSR_SPEC_CTRL)) {
 		rdmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+		/*
+		 * Clear the non reserved bits from x86_spec_ctrl_base
+		 * to fix kexec. Otherwise for example SSBD could be
+		 * left enabled despite booting with
+		 * spec_store_bypass_disable=off because SSBD would be
+		 * erroneously mistaken as a reserved bit set by the
+		 * BIOS when in fact it was set by a previous kernel
+		 * booted with spec_store_bypass_disable=on. Careful
+		 * however not to write SPEC_CTRL unnecessarily to
+		 * keep the virt MSR intercept enabled as long as
+		 * possible.
+		 */
+		if (x86_spec_ctrl_base & SPEC_CTRL_ALL) {
+			/* all known bits must not be set at boot, clear it */
+			x86_spec_ctrl_base &= ~SPEC_CTRL_ALL;
+			wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+		}
+	}
 
 	/* Allow STIBP in MSR_SPEC_CTRL if supported */
 	if (boot_cpu_has(X86_FEATURE_STIBP))
