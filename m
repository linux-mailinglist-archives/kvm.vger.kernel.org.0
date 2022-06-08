Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DE0544021
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 01:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbiFHXu4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 19:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234857AbiFHXuw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 19:50:52 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3D4A3C2F
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 16:52:43 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id i16-20020a170902cf1000b001540b6a09e3so11905299plg.0
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 16:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8k5iIfe9lfe/NYxVl/oRsR7i2IWzn8sfwQQH1dtyKN8=;
        b=IO8NFMVcpKfDTSVxf7izxGrcurOheZSya0hQsyoqdKbpAFXhXMpv56yfaHziilHknd
         0T6Na0vb9pbLiz1iH+Ckz6urhkbzqe/xVwiH6EoHEiUk5Hyvh++01X3F3NgIOKfBGBVg
         ncKs+sOr0UbTUJfu1Cil4RGpQ0loUXn+5uJ0NhEehNPngqIoqgLvC+yJ/To1fgtQQgPB
         UEuzevudKvmVkcjbzjbF1m9yAYrXA5bLXsTzijdHyzr0YPb5B1OQDrNsen7Mf/cv06ap
         wNMQUHiJuqAA3dULZCmYJDlJ5itvrMEzbyH72lkWh2iP+QSXiZp+BiWCbbXiNiS0PXx8
         RvIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8k5iIfe9lfe/NYxVl/oRsR7i2IWzn8sfwQQH1dtyKN8=;
        b=rYmB0fIwQQpBUFc0VrCp3oQ/J7O9qIcI/DYDTafeM3xQToHzJI+KALq7aCMJh70aQY
         iBQ37VOrPNnPhB3dvLrC9P+yvApUVa8tIv4LajfQVXXDtfRsbNGiT5jYB07ZKmOzLLiP
         dhUHKZH3ntx3QlyS0PSQesjeh8MpqUKLsHThUIVWKxvA7eruh8CBVxhENR1NEKwg+K3C
         1kySvyDfc9UrPhxmExmU/tyIpdsAQzT9DSC4sDPuVVKYhF9oYTORVjMKoveA74Ur+mC2
         VwbGOYzTI8JtDjpkysVJ85hgw4Bo0KEatac0W9yJX5NVpHRvxrHcWDCo+0jX/ZJ2ysq6
         N5Zw==
X-Gm-Message-State: AOAM530rKLOqm7VJeYUndatrjm31kl7OT4PCMBKUg5c5O4m8u8dR82sO
        ocFf3pW+4hW+PsA+NGvH/Em3ign8+D8=
X-Google-Smtp-Source: ABdhPJx6UAYIeN05NNl7z29mvMLG/z+1X7a4yH4LkFNgSrzU1L1CBUykQikGCcActTqU0GgKScdr1u79Hd8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:148f:b0:51c:70f9:b62e with SMTP id
 v15-20020a056a00148f00b0051c70f9b62emr4020648pfu.84.1654732362930; Wed, 08
 Jun 2022 16:52:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Jun 2022 23:52:29 +0000
In-Reply-To: <20220608235238.3881916-1-seanjc@google.com>
Message-Id: <20220608235238.3881916-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220608235238.3881916-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [kvm-unit-tests PATCH 01/10] x86: Use BIT() to define architectural bits
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use BIT() to define bits in EFLAGS, CR0, and CR4.  Intel's SDM and AMD's
APM reference flags/features by the bit number, not by their mask, making
it absurdly difficult to audit and/or add definitions.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 103 ++++++++++++++++++++++++++------------------
 x86/xsave.c         |   1 -
 2 files changed, 61 insertions(+), 43 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 9a0dad67..1dfd5285 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -4,6 +4,7 @@
 #include "libcflat.h"
 #include "desc.h"
 #include "msr.h"
+#include <bitops.h>
 #include <stdint.h>
 
 #define NONCANONICAL            0xaaaaaaaaaaaaaaaaull
@@ -30,49 +31,67 @@
 #define AC_VECTOR 17
 #define CP_VECTOR 21
 
-#define X86_CR0_PE	0x00000001
-#define X86_CR0_MP	0x00000002
-#define X86_CR0_EM	0x00000004
-#define X86_CR0_TS	0x00000008
-#define X86_CR0_WP	0x00010000
-#define X86_CR0_AM	0x00040000
-#define X86_CR0_NW	0x20000000
-#define X86_CR0_CD	0x40000000
-#define X86_CR0_PG	0x80000000
-#define X86_CR3_PCID_MASK 0x00000fff
-#define X86_CR4_TSD	0x00000004
-#define X86_CR4_DE	0x00000008
-#define X86_CR4_PSE	0x00000010
-#define X86_CR4_PAE	0x00000020
-#define X86_CR4_MCE	0x00000040
-#define X86_CR4_PGE	0x00000080
-#define X86_CR4_PCE	0x00000100
-#define X86_CR4_UMIP	0x00000800
-#define X86_CR4_LA57	0x00001000
-#define X86_CR4_VMXE	0x00002000
-#define X86_CR4_PCIDE	0x00020000
-#define X86_CR4_OSXSAVE	0x00040000
-#define X86_CR4_SMEP	0x00100000
-#define X86_CR4_SMAP	0x00200000
-#define X86_CR4_PKE	0x00400000
-#define X86_CR4_CET	0x00800000
-#define X86_CR4_PKS	0x01000000
+#define X86_CR0_PE	BIT(0)
+#define X86_CR0_MP	BIT(1)
+#define X86_CR0_EM	BIT(2)
+#define X86_CR0_TS	BIT(3)
+#define X86_CR0_ET	BIT(4)
+#define X86_CR0_NE	BIT(5)
+#define X86_CR0_WP	BIT(16)
+#define X86_CR0_AM	BIT(18)
+#define X86_CR0_NW	BIT(29)
+#define X86_CR0_CD	BIT(30)
+#define X86_CR0_PG	BIT(31)
 
-#define X86_EFLAGS_CF    0x00000001
-#define X86_EFLAGS_FIXED 0x00000002
-#define X86_EFLAGS_PF    0x00000004
-#define X86_EFLAGS_AF    0x00000010
-#define X86_EFLAGS_ZF    0x00000040
-#define X86_EFLAGS_SF    0x00000080
-#define X86_EFLAGS_TF    0x00000100
-#define X86_EFLAGS_IF    0x00000200
-#define X86_EFLAGS_DF    0x00000400
-#define X86_EFLAGS_OF    0x00000800
-#define X86_EFLAGS_IOPL  0x00003000
-#define X86_EFLAGS_NT    0x00004000
-#define X86_EFLAGS_RF    0x00010000
-#define X86_EFLAGS_VM    0x00020000
-#define X86_EFLAGS_AC    0x00040000
+#define X86_CR3_PCID_MASK	GENMASK(11, 0)
+
+#define X86_CR4_VME		BIT(0)
+#define X86_CR4_PVI		BIT(1)
+#define X86_CR4_TSD		BIT(2)
+#define X86_CR4_DE		BIT(3)
+#define X86_CR4_PSE		BIT(4)
+#define X86_CR4_PAE		BIT(5)
+#define X86_CR4_MCE		BIT(6)
+#define X86_CR4_PGE		BIT(7)
+#define X86_CR4_PCE		BIT(8)
+#define X86_CR4_OSFXSR		BIT(9)
+#define X86_CR4_OSXMMEXCPT	BIT(10)
+#define X86_CR4_UMIP		BIT(11)
+#define X86_CR4_LA57		BIT(12)
+#define X86_CR4_VMXE		BIT(13)
+#define X86_CR4_SMXE		BIT(14)
+/* UNUSED			BIT(15) */
+#define X86_CR4_FSGSBASE	BIT(16)
+#define X86_CR4_PCIDE		BIT(17)
+#define X86_CR4_OSXSAVE		BIT(18)
+#define X86_CR4_KL		BIT(19)
+#define X86_CR4_SMEP		BIT(20)
+#define X86_CR4_SMAP		BIT(21)
+#define X86_CR4_PKE		BIT(22)
+#define X86_CR4_CET		BIT(23)
+#define X86_CR4_PKS		BIT(24)
+
+#define X86_EFLAGS_CF		BIT(0)
+#define X86_EFLAGS_FIXED	BIT(1)
+#define X86_EFLAGS_PF		BIT(2)
+/* RESERVED 0			BIT(3) */
+#define X86_EFLAGS_AF		BIT(4)
+/* RESERVED 0			BIT(5) */
+#define X86_EFLAGS_ZF		BIT(6)
+#define X86_EFLAGS_SF		BIT(7)
+#define X86_EFLAGS_TF		BIT(8)
+#define X86_EFLAGS_IF		BIT(9)
+#define X86_EFLAGS_DF		BIT(10)
+#define X86_EFLAGS_OF		BIT(11)
+#define X86_EFLAGS_IOPL		GENMASK(13, 12)
+#define X86_EFLAGS_NT		BIT(14)
+/* RESERVED 0			BIT(15) */
+#define X86_EFLAGS_RF		BIT(16)
+#define X86_EFLAGS_VM		BIT(17)
+#define X86_EFLAGS_AC		BIT(18)
+#define X86_EFLAGS_VIF		BIT(19)
+#define X86_EFLAGS_VIP		BIT(20)
+#define X86_EFLAGS_ID		BIT(21)
 
 #define X86_EFLAGS_ALU (X86_EFLAGS_CF | X86_EFLAGS_PF | X86_EFLAGS_AF | \
 			X86_EFLAGS_ZF | X86_EFLAGS_SF | X86_EFLAGS_OF)
diff --git a/x86/xsave.c b/x86/xsave.c
index 892bf561..84170033 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -42,7 +42,6 @@ static uint64_t get_supported_xcr0(void)
     return r.a + ((u64)r.d << 32);
 }
 
-#define X86_CR4_OSXSAVE			0x00040000
 #define XCR_XFEATURE_ENABLED_MASK       0x00000000
 #define XCR_XFEATURE_ILLEGAL_MASK       0x00000010
 
-- 
2.36.1.255.ge46751e96f-goog

