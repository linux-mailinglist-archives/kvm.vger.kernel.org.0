Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 556EF7C65E
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbfGaPXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:23:52 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:38834 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728737AbfGaPXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:23:51 -0400
Received: by mail-ed1-f68.google.com with SMTP id r12so31268316edo.5
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XA7E5KeaJUbYeM2K2rhZVp4Ezd7kZRGT8yUA9YU5Vno=;
        b=JWeiHziHkn6XUi3iIplmGfT52a/0zxqWGFzXmszrNQRkV2LwyrAs/kin1BCvzl8D2g
         yPo5Vx4EKfuDM4BYN6yW2Wq+cCpZxizYwv7iwcWbuGnSIxyXHRUGoae6uIuCDrK7mVIH
         xzTngkApmdVD8IRLep9RK8d9L9t//qm1rGPEilmeOZ4y8P3K0gF5VP3e4kA4nP4Iu/SI
         H3wU+PfBV2o5YEK4noOFw3jff/xt6DObnFczx9D9SKtfMQvKeaTS3TZeAEnh1z2iouOI
         znt+q/4tcd/EsPVDW/3K93NZpgDh60EwOqhnnuSAuZpsWbtKZkMkfICwoaZYcdqaS/CB
         gGRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XA7E5KeaJUbYeM2K2rhZVp4Ezd7kZRGT8yUA9YU5Vno=;
        b=CFQJRyEezIPktCNMKmx4B2P21TkruMF4IUJt4YXDrdLZdAH+DivAAQRBCyKLNAnxPY
         mJx7vrZMewsNyBdXeY+RhWdG+r8PMF/zRVhwNNSnn47vVQdJkCHRchEEcuLgpNhSUiUD
         iiAnqVXTuQzperH5+bTvKtifdJXyEpNPPWFz49IM6s9P8RqH+vYkf6olE0IR5RrW0pgp
         WqHtlNhk/dmM83f/h20+so3NrCdiM1zFm6JROUlTPj/naxA1eqXe+dbS4awOpUI7G+NZ
         Cpwg2pmJy2+50sBHXpL2xyHF4G1Dkq/ETkoi3QFnKwimT7W2+q4RtNQdFBptuJDdyqZN
         aY/A==
X-Gm-Message-State: APjAAAWXyfYIphSOCmpz/utllgvTvEM/nyAQwvftH6Wi1vHB7aEYW5Vi
        YDbOUtsjyhk2YS3NgY+3dO4=
X-Google-Smtp-Source: APXvYqygZ5MBpQtdpZUq0Kg4NNTneIlpIbVYF7hlIaO8yQtO6FOtK69pmeSCoz1g6SVwfQ5huucSCQ==
X-Received: by 2002:a50:b1db:: with SMTP id n27mr108755394edd.62.1564586630295;
        Wed, 31 Jul 2019 08:23:50 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id j7sm17555887eda.97.2019.07.31.08.23.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:23:49 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 64D3C1028A2; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
To:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 17/59] x86/mm: Allow to disable MKTME after enumeration
Date:   Wed, 31 Jul 2019 18:07:31 +0300
Message-Id: <20190731150813.26289-18-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The new helper mktme_disable() allows to disable MKTME even if it's
enumerated successfully. MKTME initialization may fail and this
functionality allows system to boot regardless of the failure.

MKTME needs per-KeyID direct mapping. It requires a lot more virtual
address space which may be a problem in 4-level paging mode. If the
system has more physical memory than we can handle with MKTME the
feature allows to fail MKTME, but boot the system successfully.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/mktme.h |  5 +++++
 arch/x86/kernel/cpu/intel.c  |  5 +----
 arch/x86/mm/mktme.c          | 10 ++++++++++
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/mktme.h b/arch/x86/include/asm/mktme.h
index a61b45fca4b1..3fc246acc279 100644
--- a/arch/x86/include/asm/mktme.h
+++ b/arch/x86/include/asm/mktme.h
@@ -22,6 +22,8 @@ static inline bool mktme_enabled(void)
 	return static_branch_unlikely(&mktme_enabled_key);
 }
 
+void mktme_disable(void);
+
 extern struct page_ext_operations page_mktme_ops;
 
 #define page_keyid page_keyid
@@ -71,6 +73,9 @@ static inline bool mktme_enabled(void)
 {
 	return false;
 }
+
+static inline void mktme_disable(void) {}
+
 #endif
 
 #endif
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 4c2d70287eb4..9852580340b9 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -650,10 +650,7 @@ static void detect_tme(struct cpuinfo_x86 *c)
 		 * We must not allow onlining secondary CPUs with non-matching
 		 * configuration.
 		 */
-		physical_mask = (1ULL << __PHYSICAL_MASK_SHIFT) - 1;
-		__mktme_keyid_mask = 0;
-		__mktme_keyid_shift = 0;
-		__mktme_nr_keyids = 0;
+		mktme_disable();
 	}
 #endif
 
diff --git a/arch/x86/mm/mktme.c b/arch/x86/mm/mktme.c
index 8015e7822c9b..1e8d662e5bff 100644
--- a/arch/x86/mm/mktme.c
+++ b/arch/x86/mm/mktme.c
@@ -33,6 +33,16 @@ unsigned int mktme_algs;
 DEFINE_STATIC_KEY_FALSE(mktme_enabled_key);
 EXPORT_SYMBOL_GPL(mktme_enabled_key);
 
+void mktme_disable(void)
+{
+	physical_mask = (1ULL << __PHYSICAL_MASK_SHIFT) - 1;
+	__mktme_keyid_mask = 0;
+	__mktme_keyid_shift = 0;
+	__mktme_nr_keyids = 0;
+	if (mktme_enabled())
+		static_branch_disable(&mktme_enabled_key);
+}
+
 static bool need_page_mktme(void)
 {
 	/* Make sure keyid doesn't collide with extended page flags */
-- 
2.21.0

