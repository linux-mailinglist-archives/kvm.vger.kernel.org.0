Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F98523CEFE
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgHETLI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729246AbgHESaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:30:20 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8518422E01;
        Wed,  5 Aug 2020 18:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596652018;
        bh=qWbqjPlIPwkyEPb+J2ieeFiKJ1fw2t8X5TuAlqMXn4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vMLT1zygplaGzq1ry484nkOe49QbNtJysFnQnA0VGRPDz5QKI9WoHaBh6OIvAKxZC
         ZSlMV1dLmyWCOjtZl/foqv2sJBoKSjYZTwiw1+hqY+63NS3fSREa+GpzxQ+CrXZKwe
         2c1EXdR1vs50js27ni2fL2Vl3jAngS9wSIs4xUOA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3Ng0-0004w9-5p; Wed, 05 Aug 2020 18:58:08 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 51/56] KVM: arm64: Ensure that all nVHE hyp code is in .hyp.text
Date:   Wed,  5 Aug 2020 18:56:55 +0100
Message-Id: <20200805175700.62775-52-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com, alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, richard.peng@oppo.com, qperret@google.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Brazdil <dbrazdil@google.com>

Some compilers may put a subset of generated functions into '.text.*'
ELF sections and the linker may leverage this division to optimize ELF
layout. Unfortunately, the recently introduced HYPCOPY command assumes
that all executable code (with the exception of specialized sections
such as '.hyp.idmap.text') is in the '.text' section. If this
assumption is broken, code in '.text.*' will be merged into kernel
proper '.text' instead of the '.hyp.text' that is mapped in EL2.

To ensure that this cannot happen, insert an OBJDUMP assertion into
HYPCOPY. The command dumps a list of ELF sections in the input object
file and greps for '.text.'. If found, compilation fails. Tested with
both binutils' and LLVM's objdump (the output format is different).

GCC offers '-fno-reorder-functions' to disable this behaviour. Select
the flag if it is available. From inspection of GCC source (latest
Git in July 2020), this flag does force all code into '.text'.
By default, GCC uses profile data, heuristics and attributes to select
a subsection.

LLVM/Clang currently does not have a similar optimization pass. It can
place static constructors into '.text.startup' and it's optimizer can
be provided with profile data to reorder hot/cold functions. Neither
of these is applicable to nVHE hyp code. If this changes in the future,
the OBJDUMP assertion should alert users to the problem.

Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200730132519.48787-1-dbrazdil@google.com
---
 arch/arm64/kvm/hyp/nvhe/Makefile | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 0b34414557d6..aef76487edc2 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -20,10 +20,30 @@ $(obj)/%.hyp.tmp.o: $(src)/%.S FORCE
 $(obj)/%.hyp.o: $(obj)/%.hyp.tmp.o FORCE
 	$(call if_changed,hypcopy)
 
+# Disable reordering functions by GCC (enabled at -O2).
+# This pass puts functions into '.text.*' sections to aid the linker
+# in optimizing ELF layout. See HYPCOPY comment below for more info.
+ccflags-y += $(call cc-option,-fno-reorder-functions)
+
+# The HYPCOPY command uses `objcopy` to prefix all ELF symbol names
+# and relevant ELF section names to avoid clashes with VHE code/data.
+#
+# Hyp code is assumed to be in the '.text' section of the input object
+# files (with the exception of specialized sections such as
+# '.hyp.idmap.text'). This assumption may be broken by a compiler that
+# divides code into sections like '.text.unlikely' so as to optimize
+# ELF layout. HYPCOPY checks that no such sections exist in the input
+# using `objdump`, otherwise they would be linked together with other
+# kernel code and not memory-mapped correctly at runtime.
 quiet_cmd_hypcopy = HYPCOPY $@
-      cmd_hypcopy = $(OBJCOPY)	--prefix-symbols=__kvm_nvhe_		\
-				--rename-section=.text=.hyp.text	\
-				$< $@
+      cmd_hypcopy =							\
+	if $(OBJDUMP) -h $< | grep -F '.text.'; then			\
+		echo "$@: function reordering not supported in nVHE hyp code" >&2; \
+		/bin/false;						\
+	fi;								\
+	$(OBJCOPY) --prefix-symbols=__kvm_nvhe_				\
+		   --rename-section=.text=.hyp.text			\
+		   $< $@
 
 # Remove ftrace and Shadow Call Stack CFLAGS.
 # This is equivalent to the 'notrace' and '__noscs' annotations.
-- 
2.27.0

