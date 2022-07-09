Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1380A56C699
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 06:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiGIEVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 00:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiGIEVY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 00:21:24 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582F04B0E2;
        Fri,  8 Jul 2022 21:21:23 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id f11so375367plr.4;
        Fri, 08 Jul 2022 21:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1RuJQddSvsoGrYfcpLM/x3vIgUa0k5VONeC0Fi8Aj/A=;
        b=S9Q+ruIQIcc5r9ovy/YHDvWRrAWhddNdabcaCXlEWsz2VSvaocKMh4uyP7P+g+/IyE
         NTi3ZC08g/kz2iutkH67cytSdAXrltdUa+CETivcolwx/POyB0pxEfCHcgCcpNbm+1Tz
         3AU73dQOrQZ2vzT1Esoz09U0EynpliGMHmwfLQRBiKSTGMD/bmQYJrUSZ+jkhXrvI9oH
         BSXimMjNbjkCqzMX7iEGQ+shy83eyKxXm20F0RNRxZDAteNlx9ur6/SHQVZ/qKVonNsg
         g3MwGRj8jrtpc1GW9+dRk/T1cXeid1qLiR/Lgfskxh/nF9jNfgx7csj7zE5tYOi9m0p3
         d/og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1RuJQddSvsoGrYfcpLM/x3vIgUa0k5VONeC0Fi8Aj/A=;
        b=K2YLe9+GUtnokDENeINi81Ta6msQoisuhwbmFQWox/D+z8ZPpdOL7g2G1xMYrIetJW
         ECxE4YoXpSBXEvi96usQO3u2CP8GxKBQTagW1jLGxinBlmLeHWASojWP40dPt4KJWWax
         DrFga5S3iT4DHBMWmB64t/Ekzib8SbXhWg283Q1ihoK1C0ctDK97P0gNvMJneiacPYd5
         JAss7ZaPx7RtvP/PE4LZauYjp/SFFMU9zU5L8xNlbFk1+d63e4140+/ynE38dqFkxTdk
         i5X0D2fG+d3A8a+JrCApV/Z3blOamW0NAMzaOlv1Koe1qA4tiDSEdvPSb2EIcGsRMkMN
         LXkg==
X-Gm-Message-State: AJIora+n2Z1Sqr4+M00PUm2Q/3Lb6WpZrTItP/6gdHUNzeSlhvaVsEWk
        rgQ0YeHXE7L8sCZaj2XGHf4=
X-Google-Smtp-Source: AGRyM1sZPLRuUTnbSpWVs0uiHpCvTCPLH0GGNvgQRsL46bFZC1V58IMyUQwKmUeIwbtPIM3/YWeF3A==
X-Received: by 2002:a17:902:ce88:b0:16c:1b1e:71b4 with SMTP id f8-20020a170902ce8800b0016c1b1e71b4mr6908770plg.153.1657340482881;
        Fri, 08 Jul 2022 21:21:22 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-88.three.co.id. [180.214.232.88])
        by smtp.gmail.com with ESMTPSA id b1-20020a170902bd4100b0016be834d544sm318965plx.237.2022.07.08.21.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 21:21:21 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 023FB1039D3; Sat,  9 Jul 2022 11:21:10 +0700 (WIB)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 07/12] Documentation: kvm: tdx-tdp-mmu: Use literal code block for EPT violation diagrams
Date:   Sat,  9 Jul 2022 11:20:33 +0700
Message-Id: <20220709042037.21903-8-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220709042037.21903-1-bagasdotme@gmail.com>
References: <20220709042037.21903-1-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

EPT violation diagrams aren't inside literal code block, which trigger
"line block ends without a blank line" warning. Since these diagrams
aren't meant line blocks, use literal code block instead.

Fixes: 7af4efe3263854 ("KVM: x86: design documentation on TDX support of x86 KVM TDP MMU")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/kvm/tdx-tdp-mmu.rst | 39 +++++++++++++++++---------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/Documentation/virt/kvm/tdx-tdp-mmu.rst b/Documentation/virt/kvm/tdx-tdp-mmu.rst
index c9d5fc43a6ca7a..f43ebb08f5cdad 100644
--- a/Documentation/virt/kvm/tdx-tdp-mmu.rst
+++ b/Documentation/virt/kvm/tdx-tdp-mmu.rst
@@ -169,30 +169,41 @@ hooks to KVM MMU to reuse the existing code.
 EPT violation on shared GPA
 ---------------------------
 (1) EPT violation on shared GPA or zapping shared GPA
-    walk down shared EPT tree (the existing code)
-        |
-        |
-        V
-shared EPT tree (CPU refers.)
+    ::
+
+       walk down shared EPT tree (the existing code)
+           |
+           |
+           V
+       shared EPT tree (CPU refers.)
+
 (2) update the EPT entry. (the existing code)
+
     TLB shootdown in the case of zapping.
 
 
 EPT violation on private GPA
 ----------------------------
 (1) EPT violation on private GPA or zapping private GPA
-    walk down the mirror of secure EPT tree (mostly same as the existing code)
-        |
-        |
-        V
-mirror of secure EPT tree (KVM MMU software only. reuse of the existing code)
+    ::
+
+       walk down the mirror of secure EPT tree (mostly same as the existing code)
+           |
+           |
+           V
+       mirror of secure EPT tree (KVM MMU software only. reuse of the existing code)
+
 (2) update the (mirrored) EPT entry. (mostly same as the existing code)
+
 (3) call the hooks with what EPT entry is changed
-        |
+    ::
+
+           |
         NEW: hooks in KVM MMU
-        |
-        V
-secure EPT root(CPU refers)
+           |
+           V
+        secure EPT root(CPU refers)
+
 (4) the TDX backend calls necessary TDX SEAMCALLs to update real secure EPT.
 
 The major modification is to add hooks for the TDX backend for additional
-- 
An old man doll... just what I always wanted! - Clara

