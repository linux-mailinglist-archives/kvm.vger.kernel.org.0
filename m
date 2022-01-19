Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59EF2493536
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 08:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351861AbiASHEj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 02:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiASHEi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 02:04:38 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844D0C061574;
        Tue, 18 Jan 2022 23:04:38 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id t32so1562435pgm.7;
        Tue, 18 Jan 2022 23:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wCiIeaOP7iQ1GVdByBpgubBq7flsYPm7+h11Tiuiwpg=;
        b=I/Zq9ZxoUoy7LGYzlgDjcgi95DDZ4Fe0Pb6n5U+cqjcUR0Et5Pr7UDDZTqOCpfLFBp
         nEH7GcdRDoD5xDR/tUlhHBREYwpJfnwA60VtG0JCEqf3nxUVBvv1oTZLTn6K3Yvu+hK+
         MmXCVl0up0iY7uVROgHbQ9pdOWZxbrpVlHN4Y4Q5WewojP3zXhzqsKoPj1tWGcqIRnfu
         BYsCgTw4uvrA4sCh3lOrWg9RLNTrpKIqaFAcoZeM/oZ2RoXpONfMs3QBJMpXrJVgTy3A
         czU/m8edbY7P/SxdshnY9eEJz2nCSwfolO25LTfhQEuygQTg7Jx4dcWWysw4BTWZZz72
         hVlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wCiIeaOP7iQ1GVdByBpgubBq7flsYPm7+h11Tiuiwpg=;
        b=i5ZB0VWPmLsLw0MrdXYisGHSVdVdA7jaTdicyjEifuIQiWGSYPTSORB1Opb3Y0FCaL
         J63pVcEK9R2iKgD3LPlZnVtbKdz4vOtU7m66HVDALq02sLfd11DfZPLZ3s35qdWHthtg
         KC1R4HzlcVmuotGlbvhvG0/vzsWzDYOL7SPsdp8eTfXMmJgf/Mn8Q4Xk5l0eFawsMU8V
         gPgR7frllqhqVZAaSEjOGXFVwRsemBbq0qB3CXMuBwSu5SqqxObE8Hw3R9D0yAD/Khwh
         Nz5kR88T9m2jSlAnrcXqOCSorxnmwaYCsS11KOSruNuH43sFx7tx3cY7KrcGsizxLCWW
         bKcg==
X-Gm-Message-State: AOAM532Ps4pgoB2ULNN8ZVPdk6Dkq7Dx9DPsxU4wh1nPhmt41XTO14fJ
        T+Tqkdg90JtpRy+Z+baOZzY=
X-Google-Smtp-Source: ABdhPJxe3J12qmVF/Tu9pqymxRi/8Bzrvkc5t/ws3HbbSLQmN0Vk87KavUmmzNc1OqaHgFRMaeidfQ==
X-Received: by 2002:a63:7946:: with SMTP id u67mr26261546pgc.83.1642575877947;
        Tue, 18 Jan 2022 23:04:37 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id nl17sm5486973pjb.42.2022.01.18.23.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 23:04:37 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>
Subject: [PATCH] KVM: x86/xcr0: Don't make XFEATURE_MASK_SSE a mandatory bit setting
Date:   Wed, 19 Jan 2022 15:04:27 +0800
Message-Id: <20220119070427.33801-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

If "bits 1 and 2 of XCR0" are cleared and set only "bit 0 of XCR0",
the x86 hardware does work properly and the CPUID leaf of the states
size will be updated as follows:

xsetbv(XCR_XFEATURE_ENABLED_MASK, 0x2e7);
  CPUID[0d, 00]: eax=000002e7 ebx=00000a88 ecx=00000a88 edx=00000000
xsetbv(XCR_XFEATURE_ENABLED_MASK, 0x1);
  CPUID[0d, 00]: eax=000002e7 ebx=00000240 ecx=00000a88 edx=00000000

According to Intel SDM "XSETBV - Set Extended Control Register",
the truth emerges: only the "bit 0 of XCR0 (corresponding to x87 state)
must be set to 1", and in addition, it's necessary to set both bits
(XCR0[1] and XCR0[2]) to use AVX instructions".

Therefore, it's pretty safe for KVM to run a user-defined guest w/o
using AVX instructions and in that case, the kvm_update_cpuid_runtime()
cannot work as expected due to the wrong macro definition.

Remove the XFEATURE_MASK_SSE bit as part of the XFEATURE_MASK_EXTEND
and opportunistically, move it into the context of its unique user KVM.

Fixes: 56c103ec040b ("KVM: x86: Fix xsave cpuid exposing bug")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/fpu/xstate.h | 3 ---
 arch/x86/kvm/cpuid.h              | 8 ++++++++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index cd3dd170e23a..7d331a4aa2e2 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -9,9 +9,6 @@
 #include <asm/fpu/api.h>
 #include <asm/user.h>
 
-/* Bit 63 of XCR0 is reserved for future expansion */
-#define XFEATURE_MASK_EXTEND	(~(XFEATURE_MASK_FPSSE | (1ULL << 63)))
-
 #define XSTATE_CPUID		0x0000000d
 
 #define TILE_CPUID		0x0000001d
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 8a770b481d9d..5e36157febb2 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -8,6 +8,14 @@
 #include <asm/processor.h>
 #include <uapi/asm/kvm_para.h>
 
+/*
+ * Bit 63 of XCR0 is reserved for future expansion,
+ * and will not represent a processor state component.
+ *
+ * Only bit 0 of XCR0 (x87 state) must be set to 1.
+ */
+#define XFEATURE_MASK_EXTEND	(~(XFEATURE_MASK_FP | (1ULL << 63)))
+
 extern u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
 void kvm_set_cpu_caps(void);
 
-- 
2.33.1

