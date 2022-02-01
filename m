Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8CDF4A666A
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 21:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbiBAUx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 15:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiBAUxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 15:53:55 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30891C061714;
        Tue,  1 Feb 2022 12:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=CNHlsGNFnhBz+gDjfoGHbEVKdyZwv/HeIui/6+scf6U=; b=iz1g0cmPbRWT37m7j8R4VYnz7t
        nIDBmYPbmOexTUFVcrrA8a6LAIFuyE/Kk+OjQ29he09t2+4sti4k3/xyhCZyBAKjiBW3WtmeD3N/S
        GaABRgzsO7U56MgiTekuqOer1LHr2wgmTfWzbs20PIhn9hAUcjKvIPSRdeS7kYEXkcEu6flxlrr69
        z09ZxHcd2q+0vj5G1vBuamdLi3Q2jTsFitNEgN7QTmwgaKhFllm0RkcbU54y8vmOwHKDM9sleV6gu
        j3rmg9fuHxTNG/vp4Ob86nnLEaISc18URPyj4eaSF9lFuJjCczep8jV84tG8RiuxXS/byj4yhW66G
        /MMT36WQ==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nF09b-00D5Cd-SY; Tue, 01 Feb 2022 20:53:32 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nF09a-001Edl-22; Tue, 01 Feb 2022 20:53:30 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH v4 4/9] x86/smpboot: Reference count on smpboot_setup_warm_reset_vector()
Date:   Tue,  1 Feb 2022 20:53:23 +0000
Message-Id: <20220201205328.123066-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220201205328.123066-1-dwmw2@infradead.org>
References: <20220201205328.123066-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

If we want to do parallel CPU bringup, we're going to need to set this up
and leave it until all CPUs are done. Might as well use the RTC spinlock
to protect the refcount, as we need to take it anyway.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kernel/smpboot.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 617012f4619f..84a6048d7b69 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -127,17 +127,22 @@ int arch_update_cpu_topology(void)
 	return retval;
 }
 
+
+static unsigned int smpboot_warm_reset_vector_count;
+
 static inline void smpboot_setup_warm_reset_vector(unsigned long start_eip)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	CMOS_WRITE(0xa, 0xf);
+	if (!smpboot_warm_reset_vector_count++) {
+		CMOS_WRITE(0xa, 0xf);
+		*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_HIGH)) =
+			start_eip >> 4;
+		*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) =
+			start_eip & 0xf;
+	}
 	spin_unlock_irqrestore(&rtc_lock, flags);
-	*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_HIGH)) =
-							start_eip >> 4;
-	*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) =
-							start_eip & 0xf;
 }
 
 static inline void smpboot_restore_warm_reset_vector(void)
@@ -149,10 +154,12 @@ static inline void smpboot_restore_warm_reset_vector(void)
 	 * to default values.
 	 */
 	spin_lock_irqsave(&rtc_lock, flags);
-	CMOS_WRITE(0, 0xf);
-	spin_unlock_irqrestore(&rtc_lock, flags);
+	if (!--smpboot_warm_reset_vector_count) {
+		CMOS_WRITE(0, 0xf);
 
-	*((volatile u32 *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) = 0;
+		*((volatile u32 *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) = 0;
+	}
+	spin_unlock_irqrestore(&rtc_lock, flags);
 }
 
 static void init_freq_invariance(bool secondary, bool cppc_ready);
-- 
2.33.1

