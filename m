Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC10313918D
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 14:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbgAMNAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 08:00:55 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27379 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726277AbgAMNAy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Jan 2020 08:00:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578920452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wP6Y3rc1foY9/KBm0PlaD6Mr4Cp4jAYaI3HOzXM8Vu8=;
        b=eeC0RLHnvuWntMOZS8vbAeQQ2WBLrpnZnU23gi1vhBdH65JXRlvNVCFmjzUR+4U29yv+uc
        SW2oMew8GKzYVDR+bXVGgi/r7SnUYAOM6xlrHkLyi0zq1rBgbN1WBcKYNF3h/XLzuo3Xah
        EvHx/USH3wbuC3U/DNHhRuUEeWoJyBo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-1Ie-Gl7oMneANM1awoS6AA-1; Mon, 13 Jan 2020 08:00:51 -0500
X-MC-Unique: 1Ie-Gl7oMneANM1awoS6AA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DBA2108BC8F;
        Mon, 13 Jan 2020 13:00:50 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16D64811E1;
        Mon, 13 Jan 2020 13:00:48 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com
Subject: [PATCH kvm-unit-tests 3/3] arm/arm64: selftest: Add prefetch abort test
Date:   Mon, 13 Jan 2020 14:00:43 +0100
Message-Id: <20200113130043.30851-4-drjones@redhat.com>
In-Reply-To: <20200113130043.30851-1-drjones@redhat.com>
References: <20200113130043.30851-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a guest tries to execute code from an invalid physical address
KVM should inject an external abort. This test is based on a test
originally posted by Alexandru Elisei. This version avoids hard
coding the invalid physical address used.

Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/selftest.c      | 94 +++++++++++++++++++++++++++++++++++++++++++++
 lib/arm64/asm/esr.h |  3 ++
 2 files changed, 97 insertions(+)

diff --git a/arm/selftest.c b/arm/selftest.c
index 6d74fa1fa4c4..4495b161cdd5 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -8,6 +8,7 @@
 #include <libcflat.h>
 #include <util.h>
 #include <devicetree.h>
+#include <vmalloc.h>
 #include <asm/setup.h>
 #include <asm/ptrace.h>
 #include <asm/asm-offsets.h>
@@ -15,6 +16,7 @@
 #include <asm/thread_info.h>
 #include <asm/psci.h>
 #include <asm/smp.h>
+#include <asm/mmu.h>
 #include <asm/barrier.h>
=20
 static cpumask_t ready, valid;
@@ -65,9 +67,43 @@ static void check_setup(int argc, char **argv)
 		report_abort("missing input");
 }
=20
+unsigned long check_pabt_invalid_paddr;
+static bool check_pabt_init(void)
+{
+	phys_addr_t highest_end =3D 0;
+	unsigned long vaddr;
+	struct mem_region *r;
+
+	/*
+	 * We need a physical address that isn't backed by anything. Without
+	 * fully parsing the device tree there's no way to be certain of any
+	 * address, but an unknown address immediately following the highest
+	 * memory region has a reasonable chance. This is because we can
+	 * assume that that memory region could have been larger, if the user
+	 * had configured more RAM, and therefore no MMIO region should be
+	 * there.
+	 */
+	for (r =3D mem_regions; r->end; ++r) {
+		if (r->flags & MR_F_IO)
+			continue;
+		if (r->end > highest_end)
+			highest_end =3D PAGE_ALIGN(r->end);
+	}
+
+	if (mem_region_get_flags(highest_end) !=3D MR_F_UNKNOWN)
+		return false;
+
+	vaddr =3D (unsigned long)vmap(highest_end, PAGE_SIZE);
+	mmu_clear_user(current_thread_info()->pgtable, vaddr);
+	check_pabt_invalid_paddr =3D vaddr;
+
+	return true;
+}
+
 static struct pt_regs expected_regs;
 static bool und_works;
 static bool svc_works;
+static bool pabt_works;
 #if defined(__arm__)
 /*
  * Capture the current register state and execute an instruction
@@ -166,6 +202,30 @@ static bool check_svc(void)
 	return svc_works;
 }
=20
+static void pabt_handler(struct pt_regs *regs)
+{
+	expected_regs.ARM_lr =3D expected_regs.ARM_pc;
+	expected_regs.ARM_pc =3D expected_regs.ARM_r9;
+
+	pabt_works =3D check_regs(regs);
+
+	regs->ARM_pc =3D regs->ARM_lr;
+}
+
+static bool check_pabt(void)
+{
+	install_exception_handler(EXCPTN_PABT, pabt_handler);
+
+	test_exception("ldr	r9, =3Dcheck_pabt_invalid_paddr\n"
+		       "ldr	r9, [r9]\n",
+		       "blx	r9\n",
+		       "", "r9", "lr");
+
+	install_exception_handler(EXCPTN_PABT, NULL);
+
+	return pabt_works;
+}
+
 static void user_psci_system_off(struct pt_regs *regs)
 {
 	__user_psci_system_off();
@@ -285,6 +345,35 @@ static bool check_svc(void)
 	return svc_works;
 }
=20
+static void pabt_handler(struct pt_regs *regs, unsigned int esr)
+{
+	bool is_extabt =3D (esr & ESR_EL1_FSC_MASK) =3D=3D ESR_EL1_FSC_EXTABT;
+
+	expected_regs.regs[30] =3D expected_regs.pc + 4;
+	expected_regs.pc =3D expected_regs.regs[9];
+
+	pabt_works =3D check_regs(regs) && is_extabt;
+
+	regs->pc =3D regs->regs[30];
+}
+
+static bool check_pabt(void)
+{
+	enum vector v =3D check_vector_prep();
+
+	install_exception_handler(v, ESR_EL1_EC_IABT_EL1, pabt_handler);
+
+	test_exception("adrp	x9, check_pabt_invalid_paddr\n"
+		       "add	x9, x9, :lo12:check_pabt_invalid_paddr\n"
+		       "ldr	x9, [x9]\n",
+		       "blr	x9\n",
+		       "", "x9", "x30");
+
+	install_exception_handler(v, ESR_EL1_EC_IABT_EL1, NULL);
+
+	return pabt_works;
+}
+
 static void user_psci_system_off(struct pt_regs *regs, unsigned int esr)
 {
 	__user_psci_system_off();
@@ -302,6 +391,11 @@ static void check_vectors(void *arg __unused)
 		install_exception_handler(EL0_SYNC_64, ESR_EL1_EC_UNKNOWN,
 					  user_psci_system_off);
 #endif
+	} else {
+		if (!check_pabt_init())
+			report_skip("Couldn't guess an invalid physical address");
+		else
+			report(check_pabt(), "pabt");
 	}
 	exit(report_summary());
 }
diff --git a/lib/arm64/asm/esr.h b/lib/arm64/asm/esr.h
index 8e5af4d90767..8c351631b0a0 100644
--- a/lib/arm64/asm/esr.h
+++ b/lib/arm64/asm/esr.h
@@ -44,4 +44,7 @@
 #define ESR_EL1_EC_BKPT32	(0x38)
 #define ESR_EL1_EC_BRK64	(0x3C)
=20
+#define ESR_EL1_FSC_MASK	(0x3F)
+#define ESR_EL1_FSC_EXTABT	(0x10)
+
 #endif /* _ASMARM64_ESR_H_ */
--=20
2.21.1

