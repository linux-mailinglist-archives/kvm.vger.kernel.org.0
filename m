Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D34C77602F
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 15:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbjHINGO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 09:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbjHINGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 09:06:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E93210A;
        Wed,  9 Aug 2023 06:06:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F15BD63A14;
        Wed,  9 Aug 2023 13:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152AAC433C8;
        Wed,  9 Aug 2023 13:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691586372;
        bh=3JOmNkuzooaFOq539u5kCuJhJnFORpHKLeANQVZnpoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q8d+/TGnyv61Y+Miho/vuNy3ywBk8wHayiuLyaNPZ6VEuqfx2Cv66aQPaoGNvJTDt
         fVW1nZnypgqfwHaqdgJOxOfgDpyp/5SNyIDYNq//5+1XAphc/27ibqeZWXJbW6nn5x
         DyIeTd0LPrqHiU3Q9RMnjQowGEKsLJKRmObiEocf737dMupNdl5sWy4ZNsQ55j+8bF
         QZ6Ir1MgLX8ELn5P8balpQJ4+NK88dQZyNrbk1b47ZBF1EwtDcpnrvpM1cagod96CM
         SnhCCyfnTgb8/3cnJBy02um9C9x43UHT2jMQK0HAnDFBWN8Y3Bu76nll9Uwu22+MUz
         8DyGctY4ZcOPg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michal Luczaj <mhal@rbox.co>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 2/2] x86: move gds_ucode_mitigated() declaration to header
Date:   Wed,  9 Aug 2023 15:05:00 +0200
Message-Id: <20230809130530.1913368-2-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230809130530.1913368-1-arnd@kernel.org>
References: <20230809130530.1913368-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The declaration got placed in the .c file of the caller, but that
causes a warning for the definition:

arch/x86/kernel/cpu/bugs.c:682:6: error: no previous prototype for 'gds_ucode_mitigated' [-Werror=missing-prototypes]

Move it to a header where both sides can observe it instead.

Fixes: 81ac7e5d74174 ("KVM: Add GDS_NO support to KVM")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/include/asm/processor.h | 2 ++
 arch/x86/kvm/x86.c               | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index e5b0e23a7a830..01786f3e289cb 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -731,4 +731,6 @@ bool arch_is_platform_page(u64 paddr);
 #define arch_is_platform_page arch_is_platform_page
 #endif
 
+extern bool gds_ucode_mitigated(void);
+
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 17b1ee7f839c3..a7d97cde19678 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -318,8 +318,6 @@ u64 __read_mostly host_xcr0;
 
 static struct kmem_cache *x86_emulator_cache;
 
-extern bool gds_ucode_mitigated(void);
-
 /*
  * When called, it means the previous get/set msr reached an invalid msr.
  * Return true if we want to ignore/silent this failed msr access.
-- 
2.39.2

