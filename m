Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667AD3F0307
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 13:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhHRLur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 07:50:47 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:50173 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229889AbhHRLuq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 07:50:46 -0400
Received: from ersatz.molgen.mpg.de (g258.RadioFreeInternet.molgen.mpg.de [141.14.13.3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id DA74661E5FE33;
        Wed, 18 Aug 2021 13:50:09 +0200 (CEST)
From:   Paul Menzel <pmenzel@molgen.mpg.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86: kvm: Demote level of already loaded message from error to info
Date:   Wed, 18 Aug 2021 13:49:56 +0200
Message-Id: <20210818114956.7171-1-pmenzel@molgen.mpg.de>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In scripts, running

    modprobe kvm_amd     2>/dev/null
    modprobe kvm_intel   2>/dev/null

to ensure the modules are loaded causes Linux to log errors.

    $ dmesg --level=err
    [    0.641747] [Firmware Bug]: TSC_DEADLINE disabled due to Errata; please update microcode to version: 0x3a (or later)
    [   40.196868] kvm: already loaded the other module
    [   40.219857] kvm: already loaded the other module
    [   55.501362] kvm [1177]: vcpu0, guest rIP: 0xffffffff96e5b644 disabled perfctr wrmsr: 0xc2 data 0xffff
    [   56.397974] kvm [1418]: vcpu0, guest rIP: 0xffffffff81046158 disabled perfctr wrmsr: 0xc1 data 0xabcd
    [1007981.827781] kvm: already loaded the other module
    [1008000.394089] kvm: already loaded the other module
    [1008030.706999] kvm: already loaded the other module
    [1020396.054470] kvm: already loaded the other module
    [1020405.614774] kvm: already loaded the other module
    [1020410.140069] kvm: already loaded the other module
    [1020704.049231] kvm: already loaded the other module

As one of the two KVM modules is already loaded, KVM is functioning, and
their is no error condition. Therefore, demote the log message level to
informational.

Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5d5c5ed7dd4..411c58ae0c97 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8372,7 +8372,7 @@ int kvm_arch_init(void *opaque)
 	int r;
 
 	if (kvm_x86_ops.hardware_enable) {
-		printk(KERN_ERR "kvm: already loaded the other module\n");
+		printk(KERN_INFO "kvm: already loaded the other module\n");
 		r = -EEXIST;
 		goto out;
 	}
-- 
2.33.0

