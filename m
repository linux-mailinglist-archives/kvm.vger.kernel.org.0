Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872CB40A161
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 01:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349795AbhIMXMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 19:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349464AbhIMXL5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 19:11:57 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE17C0613D9
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 16:10:09 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 124-20020a251182000000b005a027223ed9so14924041ybr.13
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 16:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=z0+JpyYfhLSjBcBB8p9fMALyI9F5+XNuowwy7CcZMnQ=;
        b=Opmmtb2y9hX4UiFubg2umOXf9A8zlstjekSEQUdfcA8pXArF6B10BpHHQR1U4CTYqp
         T6qKN7K5PhB+IXl7mfg7JSvgNWVrtpgMKX2nOWsKd+iRFRISa5Ma5M0Ujh6jqZCLjwY6
         TbSf25Ve7zmM/3k1bsXLuRwK9uzWz2PPFe4LHAVVfYmF2qTwKtz2Fm74ufFPQliQNaJ2
         RLGZs7kA8o6vwcYH8nczAopY2wRRyLakoxnPVi9N3B+9JXEYOjS3feN/+fBpuIF+cReC
         VUjs28vBZfIyE2Ee+3WAOkJ6kQCU3m9+JQOVpHLVOdNz+ZS7T2ZVfuI4zz11z4GHOXxo
         HQww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=z0+JpyYfhLSjBcBB8p9fMALyI9F5+XNuowwy7CcZMnQ=;
        b=YKfWsjkvsXsUk48aaLs6FAsR0BF7UOJo7qNEigCgxRA3uNQlvxpP+y5FO7abFTc+tP
         yWgZUIs0KMMz6NpHSxcdBa4EcjB5iDtVPbLJuSxh1mIvkTpFhbtZAzH6y760k7ZsHSzk
         Vjt29oiDcUQqN2EkXiDKW1bROoaB2yOYQv6FtGxxvnP13kGMNMKJrKzEBHukv2XPMB2e
         kDdPDfknsYjMvEQjI0fikC5a93uOQUnJlNiD6VS/zg7zgqCq+ABz8yuWtQ4uEgCzeJKd
         hpErBsZUeN4g8MCxZcQE9ti1eHxjwxbm/nsb24H7Yf9Sib0eUs52u3InEcF9Rwq2hW1R
         IcEQ==
X-Gm-Message-State: AOAM5317TIwyP+BHKjTe80XlT7dpFgBm/Lc2vPihTfqylioTprCOqOa3
        /9CIPajnxUbfYD76DNODWqWTEOjTEY9N
X-Google-Smtp-Source: ABdhPJwsRkT8MXYUd5iHZC33D0DLCsh/L3mog8bgv50nJDILlM3v/If5q+7XzGOVqQ9BIlqgeWf5H+Dz5lWX
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:d8e:: with SMTP id 136mr18171293ybn.171.1631574608707;
 Mon, 13 Sep 2021 16:10:08 -0700 (PDT)
Date:   Mon, 13 Sep 2021 23:09:44 +0000
In-Reply-To: <20210913230955.156323-1-rananta@google.com>
Message-Id: <20210913230955.156323-4-rananta@google.com>
Mime-Version: 1.0
References: <20210913230955.156323-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v6 03/14] KVM: arm64: selftests: Use read/write definitions
 from sysreg.h
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make use of the register read/write definitions from
sysreg.h, instead of the existing definitions. A syntax
correction is needed for the files that use write_sysreg()
to make it compliant with the new (kernel's) syntax.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 28 +++++++++----------
 .../selftests/kvm/include/aarch64/processor.h | 13 +--------
 2 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index e5e6c92b60da..11fd23e21cb4 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -34,16 +34,16 @@ static void reset_debug_state(void)
 {
 	asm volatile("msr daifset, #8");
 
-	write_sysreg(osdlr_el1, 0);
-	write_sysreg(oslar_el1, 0);
+	write_sysreg(0, osdlr_el1);
+	write_sysreg(0, oslar_el1);
 	isb();
 
-	write_sysreg(mdscr_el1, 0);
+	write_sysreg(0, mdscr_el1);
 	/* This test only uses the first bp and wp slot. */
-	write_sysreg(dbgbvr0_el1, 0);
-	write_sysreg(dbgbcr0_el1, 0);
-	write_sysreg(dbgwcr0_el1, 0);
-	write_sysreg(dbgwvr0_el1, 0);
+	write_sysreg(0, dbgbvr0_el1);
+	write_sysreg(0, dbgbcr0_el1);
+	write_sysreg(0, dbgwcr0_el1);
+	write_sysreg(0, dbgwvr0_el1);
 	isb();
 }
 
@@ -53,14 +53,14 @@ static void install_wp(uint64_t addr)
 	uint32_t mdscr;
 
 	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E;
-	write_sysreg(dbgwcr0_el1, wcr);
-	write_sysreg(dbgwvr0_el1, addr);
+	write_sysreg(wcr, dbgwcr0_el1);
+	write_sysreg(addr, dbgwvr0_el1);
 	isb();
 
 	asm volatile("msr daifclr, #8");
 
 	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
-	write_sysreg(mdscr_el1, mdscr);
+	write_sysreg(mdscr, mdscr_el1);
 	isb();
 }
 
@@ -70,14 +70,14 @@ static void install_hw_bp(uint64_t addr)
 	uint32_t mdscr;
 
 	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
-	write_sysreg(dbgbcr0_el1, bcr);
-	write_sysreg(dbgbvr0_el1, addr);
+	write_sysreg(bcr, dbgbcr0_el1);
+	write_sysreg(addr, dbgbvr0_el1);
 	isb();
 
 	asm volatile("msr daifclr, #8");
 
 	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
-	write_sysreg(mdscr_el1, mdscr);
+	write_sysreg(mdscr, mdscr_el1);
 	isb();
 }
 
@@ -88,7 +88,7 @@ static void install_ss(void)
 	asm volatile("msr daifclr, #8");
 
 	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_SS;
-	write_sysreg(mdscr_el1, mdscr);
+	write_sysreg(mdscr, mdscr_el1);
 	isb();
 }
 
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 96578bd46a85..7989e832cafb 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -10,6 +10,7 @@
 #include "kvm_util.h"
 #include <linux/stringify.h>
 #include <linux/types.h>
+#include <asm/sysreg.h>
 
 
 #define ARM64_CORE_REG(x) (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
@@ -119,18 +120,6 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
-#define write_sysreg(reg, val)						  \
-({									  \
-	u64 __val = (u64)(val);						  \
-	asm volatile("msr " __stringify(reg) ", %x0" : : "rZ" (__val));	  \
-})
-
-#define read_sysreg(reg)						  \
-({	u64 val;							  \
-	asm volatile("mrs %0, "__stringify(reg) : "=r"(val) : : "memory");\
-	val;								  \
-})
-
 #define isb()		asm volatile("isb" : : : "memory")
 #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
 #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
-- 
2.33.0.309.g3052b89438-goog

