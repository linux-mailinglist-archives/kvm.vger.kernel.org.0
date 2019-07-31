Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D557C5C5
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388335AbfGaPJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:09:49 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42283 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388544AbfGaPI1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:08:27 -0400
Received: by mail-ed1-f67.google.com with SMTP id v15so66044045eds.9
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D3iLJ7KF8Vm9odDmu+BTFZ/KOQRQtwHyPsHUVXUW2iI=;
        b=kM1i0F40FYXfEMcdQiR9VUZLV2aBUr0DIlco9iB3hlWgYlqGoH3YhFqThyiuG3GlhU
         MICJOrT8oqR+53hRqgv3cF8csRqL1xVpyX6tD/ZJaUBHXHN9slodEDUAQFc2ndeYmsWR
         WW3A0qapPQ7CP1xULEMwz3e4zS5z/Rmun6q/0nEmdJiaXIJHY6yN81AnytapRernvBrE
         raTbz2gJS/FTTNoeLLnIs+MXpv+7iucyiiIu1zFPo09iRbaEfSGAfhH+M11KFAhMEC6e
         NwTMUxuK0IGQ7DtfynJRVOV/piQIKxKjIlGe+MhgETY+7kSa+fXty72q0sWznKXB/EmX
         L2Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D3iLJ7KF8Vm9odDmu+BTFZ/KOQRQtwHyPsHUVXUW2iI=;
        b=cENcpnH0/vNWyRkB7u9oKKGW5qGe4ie6NdlnbHCMSqmxOaccEnMnv/Y6BHSMMlXhqH
         G4ht3SEjm6bGdf1r2vbzdhkLC1gEdO+cKmEeucf+PbSiTCVfSkTKNVoufHUsee6/ZHV3
         mIiq6ROG1vGgxglJ2ktQuCzd/uBmekcyIzLn+MthiZwmPuEshzCujq3jvP2xc3nSyfjG
         BzfHjD4n0WNFpmbxUx8pcPezdHnOxWm/lsJYbLm4UB9rpFGYhAQHjpk6r9ICF3lvabgO
         l7iZnt0D+ty0046LaD7Uc+DF8UMMgx+dprvpMpXjU4QJbU/NeJJTPNJV81CmZnZDAptB
         Rl/Q==
X-Gm-Message-State: APjAAAXwYJF7214eAlHizFuIQJe1E7babTngEv7UNWCasCr1Rf6FB7n5
        t6cssv7Rx0wEaSGGEsf7g7w=
X-Google-Smtp-Source: APXvYqzHXFkffBxAenDjJHEoVzdmjQiN5+u8mCxxAUf8k5rkMpqzlIwg7G5dir5Kcyl0q83T3wGkPw==
X-Received: by 2002:a17:906:1496:: with SMTP id x22mr96005472ejc.191.1564585705643;
        Wed, 31 Jul 2019 08:08:25 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id u7sm12521820ejm.48.2019.07.31.08.08.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:08:22 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 3A8CF101322; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
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
Subject: [PATCHv2 11/59] x86/mm: Detect MKTME early
Date:   Wed, 31 Jul 2019 18:07:25 +0300
Message-Id: <20190731150813.26289-12-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We need to know the number of KeyIDs before page_ext is initialized.
We are going to use page_ext to store KeyID and it would be handly to
avoid page_ext allocation if there's no MKMTE in the system.

page_ext initialization happens before full CPU initizliation is complete.
Move detect_tme() call to early_init_intel().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/kernel/cpu/intel.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 991bdcb2a55a..4c2d70287eb4 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -187,6 +187,8 @@ static bool bad_spectre_microcode(struct cpuinfo_x86 *c)
 	return false;
 }
 
+static void detect_tme(struct cpuinfo_x86 *c);
+
 static void early_init_intel(struct cpuinfo_x86 *c)
 {
 	u64 misc_enable;
@@ -338,6 +340,9 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 	 */
 	if (detect_extended_topology_early(c) < 0)
 		detect_ht_early(c);
+
+	if (cpu_has(c, X86_FEATURE_TME))
+		detect_tme(c);
 }
 
 #ifdef CONFIG_X86_32
@@ -793,9 +798,6 @@ static void init_intel(struct cpuinfo_x86 *c)
 	if (cpu_has(c, X86_FEATURE_VMX))
 		detect_vmx_virtcap(c);
 
-	if (cpu_has(c, X86_FEATURE_TME))
-		detect_tme(c);
-
 	init_intel_misc_features(c);
 }
 
-- 
2.21.0

