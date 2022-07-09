Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 829A156C6A7
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 06:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiGIEVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 00:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiGIEVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 00:21:22 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334074B0E2;
        Fri,  8 Jul 2022 21:21:21 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id p16so397751plo.0;
        Fri, 08 Jul 2022 21:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zWrpjAec6xqPgolIekjuMJs7WhTq4gJR+BYNxVJxFmQ=;
        b=Wnp2xdnGn5KBGRzZleKNjfV9hrAVQhe8/tnLookizUDENK3CVs8jj6Hw6RlbC7VKP+
         ZmgLZLucVtidp0cjAxivvCWvxIJc1CBifHam7baktIKnX1qNXmEXd4FdxePVpiBNYyhc
         FXreZaRgR/0dUHkATci5Q2VL5Ku3jB5eMheI2ybKWJkfZarX0+wtWBQW0/g874MA1thQ
         OOFmIcUiXzFLp79vG1eHBr1eubhDk/ElfwufGLFq9Wa7QtP6KDZF6gFKCmE4xiJUszxM
         upUUwWfzQP/2+bi7yrjLczN0rmXIbIX2+bXeCwSQYQa/f18SJUbdUUNhvy0H6Uo8n3IE
         4xIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zWrpjAec6xqPgolIekjuMJs7WhTq4gJR+BYNxVJxFmQ=;
        b=lyNd8taCEoOYp3RfHGy2K8PcG9ZI9tmBS54KEWlxao8fqqvPfLejwkrGjA5+ken8cd
         piYrOLQfzvnNNBK6GK6mucgsdkiavDiBhg5wRE3W2ngsq8nQIgZQMnGL/7cI0AnRkQ5C
         YYQhOLx0GsKwawlWBA7oYoKR1ilWWAYu9HjsTZBSuaO877Fc7xpidYXWLE0frQ4FpEJE
         gaGl6LEa1MVwTm9+yonuvFAbqXdBrbiiDre8BOnPmxtKH3ZDawOY6nRmLsq2wAnUntoS
         Yw2YA5g0FeSLkYdwdb/fV2T+fonsz/63LbRmcMAqKXrkqRlcgELZGIcX+Bv6NF9HQq+Q
         L9ug==
X-Gm-Message-State: AJIora/ElbLjkhAFc2NGO1qKFA+F+kjiF/meA+7xwd/K6BulEFEZLclC
        ljW8tZZDsW1Y/ZXtPAWvO3o=
X-Google-Smtp-Source: AGRyM1v8voTKNedhWqldcO9l9/LMMOcD8g8wMf4+SDsvod/9edy9wfPOtcDdhqpXny+DWJU9Ax/8Gw==
X-Received: by 2002:a17:902:8b8a:b0:16b:b560:da62 with SMTP id ay10-20020a1709028b8a00b0016bb560da62mr7193984plb.20.1657340480918;
        Fri, 08 Jul 2022 21:21:20 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-88.three.co.id. [180.214.232.88])
        by smtp.gmail.com with ESMTPSA id p64-20020a62d043000000b0052a297324cbsm418687pfg.41.2022.07.08.21.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 21:21:19 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id C23851039D5; Sat,  9 Jul 2022 11:21:11 +0700 (WIB)
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
Subject: [PATCH 08/12] Documentation: kvm: tdx-tdp-mmu: Properly format nested list for EPT state machine
Date:   Sat,  9 Jul 2022 11:20:34 +0700
Message-Id: <20220709042037.21903-9-bagasdotme@gmail.com>
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

The state machine list for EPT entry state machine basically use nested
bullet lists to describe all possible results. However, the list is
badly formatted, hence triggers many indentation warnings.

Fix the nested list formatting.

Fixes: 7af4efe3263854 ("KVM: x86: design documentation on TDX support of x86 KVM TDP MMU")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/kvm/tdx-tdp-mmu.rst | 134 ++++++++++++++-----------
 1 file changed, 76 insertions(+), 58 deletions(-)

diff --git a/Documentation/virt/kvm/tdx-tdp-mmu.rst b/Documentation/virt/kvm/tdx-tdp-mmu.rst
index f43ebb08f5cdad..c403e14fb223aa 100644
--- a/Documentation/virt/kvm/tdx-tdp-mmu.rst
+++ b/Documentation/virt/kvm/tdx-tdp-mmu.rst
@@ -306,76 +306,94 @@ for EPT violation path by penalizing MapGPA hypercall.
 
 The state machine of EPT entry
 ------------------------------
-(private EPT entry, shared EPT entry) =
-        (non-present, non-present):             private mapping is allowed
-        (present, non-present):                 private mapping is mapped
-        (non-present | SPTE_SHARED_MASK, non-present | SPTE_SHARED_MASK):
-                                                shared mapping is allowed
-        (non-present | SPTE_SHARED_MASK, present | SPTE_SHARED_MASK):
-                                                shared mapping is mapped
-        (present | SPTE_SHARED_MASK, any)       invalid combination
+* (private EPT entry, shared EPT entry)
 
-* map_gpa(private GPA): Mark the region that private GPA is allowed(NEW)
-        private EPT entry: clear SPTE_SHARED_MASK
-          present: nop
-          non-present: nop
-          non-present | SPTE_SHARED_MASK -> non-present (clear SPTE_SHARED_MASK)
+  * (non-present, non-present):
+       private mapping is allowed
+  * (present, non-present):
+       private mapping is mapped
+  * (non-present | SPTE_SHARED_MASK, non-present | SPTE_SHARED_MASK):
+       shared mapping is allowed
+  * (non-present | SPTE_SHARED_MASK, present | SPTE_SHARED_MASK):
+       shared mapping is mapped
+  * (present | SPTE_SHARED_MASK, any):
+       invalid combination
 
-        shared EPT entry: zap the entry, clear SPTE_SHARED_MASK
-          present: invalid
-          non-present -> non-present: nop
-          present | SPTE_SHARED_MASK -> non-present
-          non-present | SPTE_SHARED_MASK -> non-present
+* map_gpa (private GPA): Mark the region that private GPA is allowed(NEW)
 
-* map_gpa(shared GPA): Mark the region that shared GPA is allowed(NEW)
-        private EPT entry: zap and set SPTE_SHARED_MASK
-          present     -> non-present | SPTE_SHARED_MASK
-          non-present -> non-present | SPTE_SHARED_MASK
-          non-present | SPTE_SHARED_MASK: nop
+  * private EPT entry: clear SPTE_SHARED_MASK
 
-        shared EPT entry: set SPTE_SHARED_MASK
-          present: invalid
-          non-present -> non-present | SPTE_SHARED_MASK
-          present | SPTE_SHARED_MASK -> present | SPTE_SHARED_MASK: nop
-          non-present | SPTE_SHARED_MASK -> non-present | SPTE_SHARED_MASK: nop
+    * present: nop
+    * non-present: nop
+    * non-present | SPTE_SHARED_MASK -> non-present (clear SPTE_SHARED_MASK)
 
-* map(private GPA)
-        private EPT entry
-          present: nop
-          non-present -> present
-          non-present | SPTE_SHARED_MASK: nop. looping on EPT violation(NEW)
+  * shared EPT entry: zap the entry, clear SPTE_SHARED_MASK
 
-        shared EPT entry: nop
+    * present: invalid
+    * non-present -> non-present: nop
+    * present | SPTE_SHARED_MASK -> non-present
+    * non-present | SPTE_SHARED_MASK -> non-present
 
-* map(shared GPA)
-        private EPT entry: nop
+* map_gpa (shared GPA): Mark the region that shared GPA is allowed(NEW)
 
-        shared EPT entry
-          present: invalid
-          present | SPTE_SHARED_MASK: nop
-          non-present | SPTE_SHARED_MASK -> present | SPTE_SHARED_MASK
-          non-present: nop. looping on EPT violation(NEW)
+  * private EPT entry: zap and set SPTE_SHARED_MASK
 
-* zap(private GPA)
-        private EPT entry: zap the entry with keeping SPTE_SHARED_MASK
-          present -> non-present
-          present | SPTE_SHARED_MASK: invalid
-          non-present: nop as is_shadow_present_pte() is checked
-          non-present | SPTE_SHARED_MASK: nop as is_shadow_present_pte() is
-                                          checked
+    * present     -> non-present | SPTE_SHARED_MASK
+    * non-present -> non-present | SPTE_SHARED_MASK
+    * non-present | SPTE_SHARED_MASK: nop
 
-        shared EPT entry: nop
+  * shared EPT entry: set SPTE_SHARED_MASK
 
-* zap(shared GPA)
-        private EPT entry: nop
+    * present: invalid
+    * non-present -> non-present | SPTE_SHARED_MASK
+    * present | SPTE_SHARED_MASK -> present | SPTE_SHARED_MASK: nop
+    * non-present | SPTE_SHARED_MASK -> non-present | SPTE_SHARED_MASK: nop
 
-        shared EPT entry: zap
-          any -> non-present
-          present: invalid
-          present | SPTE_SHARED_MASK -> non-present | SPTE_SHARED_MASK
-          non-present: nop as is_shadow_present_pte() is checked
-          non-present | SPTE_SHARED_MASK: nop as is_shadow_present_pte() is
-                                          checked
+* map (private GPA)
+
+  * private EPT entry
+
+    * present: nop
+    * non-present -> present
+    * non-present | SPTE_SHARED_MASK: nop. looping on EPT violation(NEW)
+
+  * shared EPT entry: nop
+
+* map (shared GPA)
+
+  * private EPT entry: nop
+
+  * shared EPT entry:
+
+    * present: invalid
+    * present | SPTE_SHARED_MASK: nop
+    * non-present | SPTE_SHARED_MASK -> present | SPTE_SHARED_MASK
+    * non-present: nop. looping on EPT violation(NEW)
+
+* zap (private GPA)
+
+  * private EPT entry: zap the entry with keeping SPTE_SHARED_MASK
+
+    * present -> non-present
+    * present | SPTE_SHARED_MASK: invalid
+    * non-present: nop as is_shadow_present_pte() is checked
+    * non-present | SPTE_SHARED_MASK: nop as is_shadow_present_pte() is
+      checked
+
+  * shared EPT entry: nop
+
+* zap (shared GPA)
+
+  * private EPT entry: nop
+
+  * shared EPT entry: zap
+
+    * any -> non-present
+    * present: invalid
+    * present | SPTE_SHARED_MASK -> non-present | SPTE_SHARED_MASK
+    * non-present: nop as is_shadow_present_pte() is checked
+    * non-present | SPTE_SHARED_MASK: nop as is_shadow_present_pte() is
+      checked
 
 
 The original TDP MMU and race condition
-- 
An old man doll... just what I always wanted! - Clara

