Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0432B6C8717
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 21:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbjCXUxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 16:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbjCXUw6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 16:52:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BFC1F930;
        Fri, 24 Mar 2023 13:52:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14474B82609;
        Fri, 24 Mar 2023 20:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B183FC433D2;
        Fri, 24 Mar 2023 20:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679691170;
        bh=d2jjroz/2vjPnTyu4HHq2WBisCZrPVF0VtjGVREnDbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNPbrsN3eT2z8ZsAfZmmI/du4vEX7d2nktCIhUXSmez7GgvgALMwpIDOa79nEWIM5
         rvjV1kGVUh1YiFf/JCSCF0X/oNbxtEoIhiVUed6IwexvDXX4w6Vhpbc5WUni1YKjWI
         ktEyb7uihHpXHFzAjfrhPeDgwiSX2pOeJKbjeXj+ltv+Qj+xGZMwKjb5TciXku3Kq0
         Yusa+sj8O6EXpFZ/sIOj/He7Dpqo6bHiuoufjTCCTxdqTNzA6vv0XCi7876iXQ1atB
         2zaA66aKRt9bV4SlPYbbFS2ocskZzm+vTJGoYptigMPnn0SdYkM9jaNw3OdYEGclyn
         vkKBdz9mE5imA==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 520BC1540434; Fri, 24 Mar 2023 13:52:50 -0700 (PDT)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@meta.com,
        rostedt@goodmis.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        John Ogness <john.ogness@linutronix.de>
Subject: [PATCH rcu v3 2/4] kvm: Remove "select SRCU"
Date:   Fri, 24 Mar 2023 13:52:47 -0700
Message-Id: <20230324205249.3700408-2-paulmck@kernel.org>
X-Mailer: git-send-email 2.40.0.rc2
In-Reply-To: <8ae81b0e-2e03-4f83-aa3d-c7a0b96c8045@paulmck-laptop>
References: <8ae81b0e-2e03-4f83-aa3d-c7a0b96c8045@paulmck-laptop>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the SRCU Kconfig option is unconditionally selected, there is
no longer any point in selecting it.  Therefore, remove the "select SRCU"
Kconfig statements from the various KVM Kconfig files.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <kvm@vger.kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org> (arm64)
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Acked-by: Anup Patel <anup@brainfault.org> (riscv)
Acked-by: Heiko Carstens <hca@linux.ibm.com> (s390)
Reviewed-by: John Ogness <john.ogness@linutronix.de>
---
 arch/arm64/kvm/Kconfig   | 1 -
 arch/mips/kvm/Kconfig    | 1 -
 arch/powerpc/kvm/Kconfig | 1 -
 arch/riscv/kvm/Kconfig   | 1 -
 arch/s390/kvm/Kconfig    | 1 -
 arch/x86/kvm/Kconfig     | 1 -
 6 files changed, 6 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index ca6eadeb7d1a..f531da6b362e 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -29,7 +29,6 @@ menuconfig KVM
 	select KVM_MMIO
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_XFER_TO_GUEST_WORK
-	select SRCU
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index 29e51649203b..a8cdba75f98d 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -26,7 +26,6 @@ config KVM
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_MMIO
 	select MMU_NOTIFIER
-	select SRCU
 	select INTERVAL_TREE
 	select KVM_GENERIC_HARDWARE_ENABLING
 	help
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index a9f57dad6d91..902611954200 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -22,7 +22,6 @@ config KVM
 	select PREEMPT_NOTIFIERS
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
-	select SRCU
 	select KVM_VFIO
 	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index d5a658a047a7..5682d8c017b3 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -28,7 +28,6 @@ config KVM
 	select KVM_XFER_TO_GUEST_WORK
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select HAVE_KVM_EVENTFD
-	select SRCU
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index 33f4ff909476..45fdf2a9b2e3 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -31,7 +31,6 @@ config KVM
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_INVALID_WAKEUPS
 	select HAVE_KVM_NO_POLL
-	select SRCU
 	select KVM_VFIO
 	select INTERVAL_TREE
 	select MMU_NOTIFIER
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 8e578311ca9d..89ca7f4c1464 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -46,7 +46,6 @@ config KVM
 	select KVM_XFER_TO_GUEST_WORK
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_VFIO
-	select SRCU
 	select INTERVAL_TREE
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
-- 
2.40.0.rc2

