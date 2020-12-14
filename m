Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB3D2D9448
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 09:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439449AbgLNIky (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 03:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439372AbgLNIkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 03:40:53 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78507C0611CB
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 00:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=n9m+EwKlPloxbcmI3ZjKCvKQ95r5x6+x6EM3saIWXcQ=; b=1mx0/TApotM/LGtxS+oEzxw2qS
        Szmo/TwUdFUK3WS9UrhQOrZn600mbstunYWbduA6Ym1iQfe3mBFF29jXkRZmY1c4G4z7eRR8yHeSj
        KRql4uu9SuR41gBaWAshhvMSj3U9iUy+4kciOU/WaPLbxZk0AV59fMoQr4ZguZ/I+TZ1rZ7CeljP+
        qzWthLU2QHx5aZaSKqqUQvXXKwUU310RO4DOO/q1ftXtvSw86N48u5hUCqP0XL+EKTpUHg21zWGo9
        xpqnEPjgitjoyAToHhXM9GG5yqMFWRU6MoZ8jV/e0CBSSf76mjNT3lECNXnoVY7e+95SQnhwFIg77
        V9+QgEmg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kojNs-0006lQ-Pl; Mon, 14 Dec 2020 08:39:08 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kojNr-008Sxu-OD; Mon, 14 Dec 2020 08:39:07 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
Subject: [PATCH v3 09/17] xen: add wc_sec_hi to struct shared_info
Date:   Mon, 14 Dec 2020 08:38:57 +0000
Message-Id: <20201214083905.2017260-10-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214083905.2017260-1-dwmw2@infradead.org>
References: <20201214083905.2017260-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
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
2.26.2

