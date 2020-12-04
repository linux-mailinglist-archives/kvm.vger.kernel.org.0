Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C932CE4EE
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 02:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388442AbgLDBUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 20:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388385AbgLDBUQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 20:20:16 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7481BC08E861
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 17:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Ho04uwHAcTuR5hfCn2RRdkuuvp7fiCKtW3niSHITmGQ=; b=MGoeFIgk30IUm0u0E5T+9/cLbM
        xfXwLfsqaVQ+VketouSutMGG8j6ET3PM0toIW1UUe7VmZdrhFaadSFFliyre9sSvpfO1SZ7e3SreY
        ks8yGZP5M2hPuR1/mprOV2A19Kla4MT6hNxDFBAwEgiMbOJU9wgx2AFAzUjOfmW2O/oBxGXVCAmOl
        8eCdaA+1703tG51TLmO11p+NhLsk4hHGb0yURlrNvL/7iJ3gurNgDXbRSPER7CPGAtuHwqew8Ft2K
        dapvrevA8PcFfJ00IoFlL07trhnPAVxhYwAVi1VhOP3sG4AKxRCh6GVpK8NGjLKQt0fmFYnnE8yJx
        9PaCVohQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkzkK-0004Ke-Rj; Fri, 04 Dec 2020 01:18:54 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kkzkK-00CSAB-Cd; Fri, 04 Dec 2020 01:18:52 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 10/15] xen: add wc_sec_hi to struct shared_info
Date:   Fri,  4 Dec 2020 01:18:43 +0000
Message-Id: <20201204011848.2967588-11-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201204011848.2967588-1-dwmw2@infradead.org>
References: <20201204011848.2967588-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Xen added this in 2015 (Xen 4.6). On x86_64 and arm it fills what was
previously a 32-bit hole in the generic shared_info structure; on
i386 it had to go at the end of struct arch_shared_info.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/xen/interface.h | 3 +++
 include/xen/interface/xen.h          | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/xen/interface.h b/arch/x86/include/asm/xen/interface.h
index 9139b3e86316..baca0b00ef76 100644
--- a/arch/x86/include/asm/xen/interface.h
+++ b/arch/x86/include/asm/xen/interface.h
@@ -182,6 +182,9 @@ struct arch_shared_info {
 	unsigned long p2m_cr3;		/* cr3 value of the p2m address space */
 	unsigned long p2m_vaddr;	/* virtual address of the p2m list */
 	unsigned long p2m_generation;	/* generation count of p2m mapping */
+#ifdef CONFIG_X86_32
+	uint32_t wc_sec_hi;
+#endif
 };
 #endif	/* !__ASSEMBLY__ */
 
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index 8bfb242f433e..5ee37a296481 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -598,7 +598,9 @@ struct shared_info {
 	 * their gettimeofday() syscall on this wallclock-base value.
 	 */
 	struct pvclock_wall_clock wc;
-
+#ifndef CONFIG_X86_32
+	uint32_t wc_sec_hi;
+#endif
 	struct arch_shared_info arch;
 
 };
-- 
2.26.2

