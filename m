Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3989D5C4
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 20:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733203AbfHZSXW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 14:23:22 -0400
Received: from mga05.intel.com ([192.55.52.43]:48759 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729274AbfHZSXW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 14:23:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 11:23:22 -0700
X-IronPort-AV: E=Sophos;i="5.64,433,1559545200"; 
   d="scan'208";a="174287956"
Received: from agluck-desk2.sc.intel.com ([10.3.52.68])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 11:23:21 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     kvm@vger.kernel.org
Cc:     Tony Luck <tony.luck@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: x86: Only print persistent reasons for kvm disabled once
Date:   Mon, 26 Aug 2019 11:23:20 -0700
Message-Id: <20190826182320.9089-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When I boot my server I'm treated to a console log with:

[   40.520510] kvm: disabled by bios
[   40.551234] kvm: disabled by bios
[   40.607987] kvm: disabled by bios
[   40.659701] kvm: disabled by bios
[   40.691224] kvm: disabled by bios
[   40.718786] kvm: disabled by bios
[   40.750122] kvm: disabled by bios
[   40.797170] kvm: disabled by bios
[   40.828408] kvm: disabled by bios

 ... many, many more lines, one for every logical CPU

Since it isn't likely that BIOS is going to suddenly enable
KVM between bringing up one CPU and the next, we might as
well just print this once.

Same for a few other unchanging reasons that might keep
kvm from being initialized.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kvm/x86.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 93b0bd45ac73..56d4a43dd2db 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7007,18 +7007,18 @@ int kvm_arch_init(void *opaque)
 	struct kvm_x86_ops *ops = opaque;
 
 	if (kvm_x86_ops) {
-		printk(KERN_ERR "kvm: already loaded the other module\n");
+		pr_err_once("kvm: already loaded the other module\n");
 		r = -EEXIST;
 		goto out;
 	}
 
 	if (!ops->cpu_has_kvm_support()) {
-		printk(KERN_ERR "kvm: no hardware support\n");
+		pr_err_once("kvm: no hardware support\n");
 		r = -EOPNOTSUPP;
 		goto out;
 	}
 	if (ops->disabled_by_bios()) {
-		printk(KERN_ERR "kvm: disabled by bios\n");
+		pr_err_once("kvm: disabled by bios\n");
 		r = -EOPNOTSUPP;
 		goto out;
 	}
@@ -7029,7 +7029,7 @@ int kvm_arch_init(void *opaque)
 	 * vCPU's FPU state as a fxregs_state struct.
 	 */
 	if (!boot_cpu_has(X86_FEATURE_FPU) || !boot_cpu_has(X86_FEATURE_FXSR)) {
-		printk(KERN_ERR "kvm: inadequate fpu\n");
+		pr_err_once("kvm: inadequate fpu\n");
 		r = -EOPNOTSUPP;
 		goto out;
 	}
-- 
2.20.1

