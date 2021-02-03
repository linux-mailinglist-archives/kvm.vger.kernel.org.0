Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0EA30DD83
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 16:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbhBCPDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 10:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233499AbhBCPCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 10:02:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE25C061355
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 07:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=3ElwfAXENPX7CyKGBaZk7F240zhQf8i1c0BS1eDVtMU=; b=roVWjGqfkQ6bfjl+QRtZZmi+uc
        x9r2YVdGuofUq4CgsBJcjzykQMn3rvSFGAFshUP8wFnO7o/K6BmPz7jvpondaOmBzZivANC3lQEZr
        Le5L16Iwaddycj8c/GguBlrBHvoOYKo7R9xmoNQ8LmYtg7ZSPSd4EpUhjGW6dft7OOJSHZuYk7O5M
        ayRECTQ4HwVxT05DqXdNovZPcB4lRA90Yz9Zf5Yf0n43tyz/kiSfOVNDwfjBebZ2grYrq6WLPmP5/
        eVFZSNtv0BZt5pPsN5OUAynJOROv1EPUf1Ya+q+7/tcDDXQvohOo21uynVAqYrN4fn2DoyRIqPJLf
        T3IaqyIQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-00H3zJ-MC; Wed, 03 Feb 2021 15:01:19 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-003ref-9s; Wed, 03 Feb 2021 15:01:17 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v6 11/19] xen: add wc_sec_hi to struct shared_info
Date:   Wed,  3 Feb 2021 15:01:06 +0000
Message-Id: <20210203150114.920335-12-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203150114.920335-1-dwmw2@infradead.org>
References: <20210203150114.920335-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Xen added this in 2015 (Xen 4.6). On x86_64 and Arm it fills what was
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
2.29.2

