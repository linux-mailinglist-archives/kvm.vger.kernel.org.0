Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB30283B49
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 17:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728785AbgJEPkz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 11:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbgJEP3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 11:29:00 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2782FC0613A9;
        Mon,  5 Oct 2020 08:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=dED8vHaXb6tu8ZuPD0ZmCjPUI1h1W+XMTR/qU+F/+qA=; b=WIhf+2hPDPoXekPiE44xibj2Ky
        7et55tmHoeyyRNG0QSMj0O5uiSAe7fH8lIWeImmTUWXJdhFyoRUJXB2NwNoZbbeAloKEWiJMfHQqU
        AIMKGPslEj3EXYaAXJ2efV312g30akfbxdd94NCVvesfA+lM3kq3zvNdtxsqxF9/Ry24PGNy3DOnN
        M0+UoYi1eMNSQdhx3u8ONVLlE1M7LFwvKo8ohvojFdzPB5eUE1YvtgtK5YVUhKX3rmTRYhy9wvQc9
        lXsEnfgJEGO8zkIVdh2NviZGBnRsVPLQRABJmLuL/ywyUUQSbce+l4UxG8e4Lo1hjy8jkYOVj63gN
        W+5SSyrw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPSQ5-0004MH-8v; Mon, 05 Oct 2020 15:28:57 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kPSQ4-0045QD-7l; Mon, 05 Oct 2020 16:28:56 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 01/13] x86/apic: Use x2apic in guest kernels even with unusable CPUs.
Date:   Mon,  5 Oct 2020 16:28:44 +0100
Message-Id: <20201005152856.974112-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

If the BIOS has enabled x2apic mode, then leave it enabled and don't
fall back to xapic just because some CPUs can't be targeted.

Previously, if there are CPUs with APIC IDs > 255, the kernel will
disable x2apic and fall back to xapic. And then not use the additional
CPUs anyway, since xapic can't target them either.

In fact, xapic mode can target even *fewer* CPUs, since it can't use
the one with APIC ID 255 either. Using x2apic instead gives us at least
one more CPU without needing interrupt remapping in the guest.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/apic.h        |  1 +
 arch/x86/kernel/apic/apic.c        | 18 ++++++++++++++----
 arch/x86/kernel/apic/x2apic_phys.c |  9 +++++++++
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 1c129abb7f09..b0fd204e0023 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -259,6 +259,7 @@ static inline u64 native_x2apic_icr_read(void)
 
 extern int x2apic_mode;
 extern int x2apic_phys;
+extern void __init x2apic_set_max_apicid(u32 apicid);
 extern void __init check_x2apic(void);
 extern void x2apic_setup(void);
 static inline int x2apic_enabled(void)
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b3eef1d5c903..a75767052a92 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1841,14 +1841,24 @@ static __init void try_to_enable_x2apic(int remap_mode)
 		return;
 
 	if (remap_mode != IRQ_REMAP_X2APIC_MODE) {
-		/* IR is required if there is APIC ID > 255 even when running
-		 * under KVM
+		/*
+		 * If there are APIC IDs above 255, they cannot be used
+		 * without interrupt remapping. In a virtual machine, but
+		 * not on bare metal, X2APIC can be used anyway. In the
+		 * case where BIOS has enabled X2APIC, don't disable it
+		 * just because there are APIC IDs that can't be used.
+		 * They couldn't be used if the kernel falls back to XAPIC
+		 * anyway.
 		 */
 		if (max_physical_apicid > 255 ||
 		    !x86_init.hyper.x2apic_available()) {
 			pr_info("x2apic: IRQ remapping doesn't support X2APIC mode\n");
-			x2apic_disable();
-			return;
+			if (!x2apic_mode) {
+				x2apic_disable();
+				return;
+			}
+
+			x2apic_set_max_apicid(255);
 		}
 
 		/*
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index bc9693841353..b4b4e89c1118 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -8,6 +8,12 @@
 int x2apic_phys;
 
 static struct apic apic_x2apic_phys;
+static u32 x2apic_max_apicid;
+
+void __init x2apic_set_max_apicid(u32 apicid)
+{
+	x2apic_max_apicid = apicid;
+}
 
 static int __init set_x2apic_phys_mode(char *arg)
 {
@@ -98,6 +104,9 @@ static int x2apic_phys_probe(void)
 /* Common x2apic functions, also used by x2apic_cluster */
 int x2apic_apic_id_valid(u32 apicid)
 {
+	if (x2apic_max_apicid && apicid > x2apic_max_apicid)
+		return 0;
+
 	return 1;
 }
 
-- 
2.26.2

