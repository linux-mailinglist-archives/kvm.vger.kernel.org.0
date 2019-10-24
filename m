Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 630DAE3373
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502287AbfJXNHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:07:25 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31276 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393550AbfJXNHZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:07:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571922443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WKtAWgOxEavjB22GAtw5S7DQVmQPf7uiXWd5oT2CWYM=;
        b=Z4u4yq5Ovd1JJY/2uLRgScXRQCgbZL+2bHz9IGf8JZ1TvrOp8EzCszQVc6mo/EFYfGQnb1
        OCsZFX8JCwKjT9cf8grbkwuh4eP9B06ZqVwkItgYfbbCTWxeuGJcPlr9DrhFzmNEImy6aS
        DOZrQ8ghaRI31fshPL6ppB4GB3hAcVQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-9veaiJwKM1WCo7BaMch8aQ-1; Thu, 24 Oct 2019 09:07:21 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A6B01800E00;
        Thu, 24 Oct 2019 13:07:19 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E809261F21;
        Thu, 24 Oct 2019 13:07:16 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL 09/10] arm64: Add cache code generation test
Date:   Thu, 24 Oct 2019 15:07:00 +0200
Message-Id: <20191024130701.31238-10-drjones@redhat.com>
In-Reply-To: <20191024130701.31238-1-drjones@redhat.com>
References: <20191024130701.31238-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 9veaiJwKM1WCo7BaMch8aQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

Caches are a misterious creature on arm64, requiring a more hands-on
approach from the programmer than on x86. When generating code, two cache
maintenance operations are generally required: an invalidation for the
stale instruction and a clean to the PoU (Point of Unification) for the new
instruction. Fortunately, the ARM architecture has features to alleviate
some of this overhead, which are advertised via the IDC and DIC bits in
CTR_EL0: if IDC is 1, then the dcache clean is not required, and if DIC is
1, the icache invalidation can be absent. KVM exposes these bits to the
guest.

Until Linux v4.16.1, KVM performed an icache invalidation each time a stage
2 page was mapped. This was then optimized so that the icache invalidation
was performed when the guest tried to execute code from the page for the
first time. And that was optimized again when support for the DIC bit was
added to KVM.

The interactions between a guest that is generating code, the stage 2
tables and the IDC and DIC bits can be subtle, especially when KVM
optimizations come into play. Let's add a test that generates a few
instructions and checks that KVM indeed honors those bits.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/Makefile.arm64 |   1 +
 arm/cache.c        | 122 +++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg  |   6 +++
 3 files changed, 129 insertions(+)
 create mode 100644 arm/cache.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 35de5ea333b4..6d3dc2c4a464 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -25,6 +25,7 @@ OBJDIRS +=3D lib/arm64
 # arm64 specific tests
 tests =3D $(TEST_DIR)/timer.flat
 tests +=3D $(TEST_DIR)/micro-bench.flat
+tests +=3D $(TEST_DIR)/cache.flat
=20
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
=20
diff --git a/arm/cache.c b/arm/cache.c
new file mode 100644
index 000000000000..2939b85a8c9a
--- /dev/null
+++ b/arm/cache.c
@@ -0,0 +1,122 @@
+#include <libcflat.h>
+#include <alloc_page.h>
+#include <asm/mmu.h>
+#include <asm/processor.h>
+
+#define NTIMES=09=09=09(1 << 16)
+
+#define CTR_DIC=09=09=09(1UL << 29)
+#define CTR_IDC=09=09=09(1UL << 28)
+
+#define CLIDR_LOC_SHIFT=09=0924
+#define CLIDR_LOC_MASK=09=09(7UL << CLIDR_LOC_SHIFT)
+#define CLIDR_LOUU_SHIFT=0927
+#define CLIDR_LOUU_MASK=09=09(7UL << CLIDR_LOUU_SHIFT)
+#define CLIDR_LOUIS_SHIFT=0921
+#define CLIDR_LOUIS_MASK=09(7UL << CLIDR_LOUIS_SHIFT)
+
+#define RET=09=09=090xd65f03c0
+#define MOV_X0(x)=09=09(0xd2800000 | (((x) & 0xffff) << 5))
+
+#define clean_dcache_pou(addr)=09=09=09\
+=09asm volatile("dc cvau, %0\n" :: "r" (addr) : "memory")
+#define inval_icache_pou(addr)=09=09=09\
+=09asm volatile("ic ivau, %0\n" :: "r" (addr) : "memory")
+
+typedef int (*fn_t)(void);
+
+static inline void prime_icache(u32 *code, u32 insn)
+{
+=09*code =3D insn;
+=09/* This is the sequence recommended in ARM DDI 0487E.a, page B2-136. */
+=09clean_dcache_pou(code);
+=09dsb(ish);
+=09inval_icache_pou(code);
+=09dsb(ish);
+=09isb();
+
+=09((fn_t)code)();
+}
+
+static void check_code_generation(bool dcache_clean, bool icache_inval)
+{
+=09u32 fn[] =3D {MOV_X0(0x42), RET};
+=09u32 *code =3D alloc_page();
+=09unsigned long sctlr;
+=09int i, ret;
+=09bool success;
+
+=09/* Make sure we can execute from a writable page */
+=09mmu_clear_user((unsigned long)code);
+
+=09sctlr =3D read_sysreg(sctlr_el1);
+=09if (sctlr & SCTLR_EL1_WXN) {
+=09=09sctlr &=3D ~SCTLR_EL1_WXN;
+=09=09write_sysreg(sctlr, sctlr_el1);
+=09=09isb();
+=09=09/* SCTLR_EL1.WXN is permitted to be cached in a TLB. */
+=09=09flush_tlb_all();
+=09}
+
+=09for (i =3D 0; i < ARRAY_SIZE(fn); i++) {
+=09=09*(code + i) =3D fn[i];
+=09=09clean_dcache_pou(code + i);
+=09=09dsb(ish);
+=09=09inval_icache_pou(code + i);
+=09}
+=09dsb(ish);
+=09isb();
+
+=09/* Sanity check */
+=09((fn_t)code)();
+
+=09success =3D true;
+=09for (i =3D 0; i < NTIMES; i++) {
+=09=09prime_icache(code, MOV_X0(0x42));
+=09=09*code =3D MOV_X0(0x66);
+=09=09if (dcache_clean)
+=09=09=09clean_dcache_pou(code);
+=09=09if (icache_inval) {
+=09=09=09if (dcache_clean)
+=09=09=09=09dsb(ish);
+=09=09=09inval_icache_pou(code);
+=09=09}
+=09=09dsb(ish);
+=09=09isb();
+
+=09=09ret =3D ((fn_t)code)();
+=09=09success &=3D (ret =3D=3D 0x66);
+=09}
+
+=09report("code generation", success);
+}
+
+int main(int argc, char **argv)
+{
+=09u64 ctr, clidr;
+=09bool dcache_clean, icache_inval;
+
+=09report_prefix_push("IDC-DIC");
+
+=09ctr =3D read_sysreg(ctr_el0);
+=09dcache_clean =3D !(ctr & CTR_IDC);
+=09icache_inval =3D !(ctr & CTR_DIC);
+
+=09if (dcache_clean) {
+=09=09clidr =3D read_sysreg(clidr_el1);
+=09=09if ((clidr & CLIDR_LOC_MASK) =3D=3D 0)
+=09=09=09dcache_clean =3D false;
+=09=09if ((clidr & CLIDR_LOUU_MASK) =3D=3D 0 &&
+=09=09    (clidr & CLIDR_LOUIS_MASK) =3D=3D 0)
+=09=09=09dcache_clean =3D false;
+=09}
+
+=09if (dcache_clean)
+=09=09report_info("dcache clean to PoU required");
+=09if (icache_inval)
+=09=09report_info("icache invalidation to PoU required");
+
+=09check_code_generation(dcache_clean, icache_inval);
+
+=09return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 6d3df92a4e28..daeb5a09ad39 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -142,3 +142,9 @@ smp =3D 2
 groups =3D nodefault,micro-bench
 accel =3D kvm
 arch =3D arm64
+
+# Cache emulation tests
+[cache]
+file =3D cache.flat
+arch =3D arm64
+groups =3D cache
--=20
2.21.0

