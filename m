Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2447B1B595D
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 12:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgDWKiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 06:38:15 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42282 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725863AbgDWKiP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 06:38:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587638292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jRlFD8abzgYW7WSZulYmGCP4k+d4fqiFs6pApnrcpH4=;
        b=h6NXaYqbfN9ywoTWiSKL8xCZHcnH15NOcR53c01UV7/hF7XcOTUny2H7Z8aknbgQCvbigz
        mJ8jmHjfmLN/CJICmbb6I7lb41lqLwm+aqsfhQtRWjXl07qBR8K74vrM5FboLcuX542iv3
        pXigLjQ7t7TT4gWCvaJvGmaJkAfNKWY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-T32IKAfIPE6mXD3dtKT8hw-1; Thu, 23 Apr 2020 06:38:07 -0400
X-MC-Unique: T32IKAfIPE6mXD3dtKT8hw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85FE5140B
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 10:38:06 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.208.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDD3760C47;
        Thu, 23 Apr 2020 10:37:43 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Mohammed Gamal <mgamal@redhat.com>
Subject: [kvm-unit-test PATCH] x86: access: Add tests for reserved bits of guest physical address
Date:   Thu, 23 Apr 2020 12:36:23 +0200
Message-Id: <20200423103623.431206-1-mgamal@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This extends the access tests to also test for reserved bits
in guest physical addresses.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
---
 x86/access.c      | 34 +++++++++++++++++++++++++++++++---
 x86/unittests.cfg |  2 +-
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 86d8a72..068b4dc 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -16,7 +16,7 @@ typedef unsigned long pt_element_t;
 static int invalid_mask;
 static int page_table_levels;
=20
-#define PT_BASE_ADDR_MASK ((pt_element_t)((((pt_element_t)1 << 40) - 1) =
& PAGE_MASK))
+#define PT_BASE_ADDR_MASK ((pt_element_t)((((pt_element_t)1 << 36) - 1) =
& PAGE_MASK))
 #define PT_PSE_BASE_ADDR_MASK (PT_BASE_ADDR_MASK & ~(1ull << 21))
=20
 #define CR0_WP_MASK (1UL << 16)
@@ -47,6 +47,7 @@ enum {
     AC_PTE_DIRTY_BIT,
     AC_PTE_NX_BIT,
     AC_PTE_BIT51_BIT,
+    AC_PTE_BIT36_BIT,
=20
     AC_PDE_PRESENT_BIT,
     AC_PDE_WRITABLE_BIT,
@@ -56,6 +57,7 @@ enum {
     AC_PDE_PSE_BIT,
     AC_PDE_NX_BIT,
     AC_PDE_BIT51_BIT,
+    AC_PDE_BIT36_BIT,
     AC_PDE_BIT13_BIT,
=20
     AC_PKU_AD_BIT,
@@ -82,6 +84,7 @@ enum {
 #define AC_PTE_DIRTY_MASK     (1 << AC_PTE_DIRTY_BIT)
 #define AC_PTE_NX_MASK        (1 << AC_PTE_NX_BIT)
 #define AC_PTE_BIT51_MASK     (1 << AC_PTE_BIT51_BIT)
+#define AC_PTE_BIT36_MASK     (1 << AC_PTE_BIT36_BIT)
=20
 #define AC_PDE_PRESENT_MASK   (1 << AC_PDE_PRESENT_BIT)
 #define AC_PDE_WRITABLE_MASK  (1 << AC_PDE_WRITABLE_BIT)
@@ -91,6 +94,7 @@ enum {
 #define AC_PDE_PSE_MASK       (1 << AC_PDE_PSE_BIT)
 #define AC_PDE_NX_MASK        (1 << AC_PDE_NX_BIT)
 #define AC_PDE_BIT51_MASK     (1 << AC_PDE_BIT51_BIT)
+#define AC_PDE_BIT36_MASK     (1 << AC_PDE_BIT36_BIT)
 #define AC_PDE_BIT13_MASK     (1 << AC_PDE_BIT13_BIT)
=20
 #define AC_PKU_AD_MASK        (1 << AC_PKU_AD_BIT)
@@ -115,6 +119,7 @@ const char *ac_names[] =3D {
     [AC_PTE_DIRTY_BIT] =3D "pte.d",
     [AC_PTE_NX_BIT] =3D "pte.nx",
     [AC_PTE_BIT51_BIT] =3D "pte.51",
+    [AC_PTE_BIT36_BIT] =3D "pte.36",
     [AC_PDE_PRESENT_BIT] =3D "pde.p",
     [AC_PDE_ACCESSED_BIT] =3D "pde.a",
     [AC_PDE_WRITABLE_BIT] =3D "pde.rw",
@@ -123,6 +128,7 @@ const char *ac_names[] =3D {
     [AC_PDE_PSE_BIT] =3D "pde.pse",
     [AC_PDE_NX_BIT] =3D "pde.nx",
     [AC_PDE_BIT51_BIT] =3D "pde.51",
+    [AC_PDE_BIT36_BIT] =3D "pde.36",
     [AC_PDE_BIT13_BIT] =3D "pde.13",
     [AC_PKU_AD_BIT] =3D "pkru.ad",
     [AC_PKU_WD_BIT] =3D "pkru.wd",
@@ -295,6 +301,14 @@ static _Bool ac_test_legal(ac_test_t *at)
     if (!F(AC_PDE_PSE) && F(AC_PDE_BIT13))
         return false;
=20
+    /*
+     * Shorten the test by avoiding testing too many reserved bit combin=
ations
+     */
+    if ((F(AC_PDE_BIT51) + F(AC_PDE_BIT36) + F(AC_PDE_BIT13)) > 1)
+        return false;
+    if ((F(AC_PTE_BIT51) + F(AC_PTE_BIT36)) > 1)
+        return false;
+
     return true;
 }
=20
@@ -381,7 +395,7 @@ static void ac_emulate_access(ac_test_t *at, unsigned=
 flags)
         at->ignore_pde =3D PT_ACCESSED_MASK;
=20
     pde_valid =3D F(AC_PDE_PRESENT)
-        && !F(AC_PDE_BIT51) && !F(AC_PDE_BIT13)
+        && !F(AC_PDE_BIT51) && !F(AC_PDE_BIT36) && !F(AC_PDE_BIT13)
         && !(F(AC_PDE_NX) && !F(AC_CPU_EFER_NX));
=20
     if (!pde_valid) {
@@ -407,7 +421,7 @@ static void ac_emulate_access(ac_test_t *at, unsigned=
 flags)
     at->expected_pde |=3D PT_ACCESSED_MASK;
=20
     pte_valid =3D F(AC_PTE_PRESENT)
-        && !F(AC_PTE_BIT51)
+        && !F(AC_PTE_BIT51) && !F(AC_PTE_BIT36)
         && !(F(AC_PTE_NX) && !F(AC_CPU_EFER_NX));
=20
     if (!pte_valid) {
@@ -516,6 +530,8 @@ static void __ac_setup_specific_pages(ac_test_t *at, =
ac_pool_t *pool,
 		pte |=3D PT64_NX_MASK;
 	    if (F(AC_PDE_BIT51))
 		pte |=3D 1ull << 51;
+	    if (F(AC_PDE_BIT36))
+                pte |=3D 1ull << 36;
 	    if (F(AC_PDE_BIT13))
 		pte |=3D 1ull << 13;
 	    at->pdep =3D &vroot[index];
@@ -538,6 +554,8 @@ static void __ac_setup_specific_pages(ac_test_t *at, =
ac_pool_t *pool,
 		pte |=3D PT64_NX_MASK;
 	    if (F(AC_PTE_BIT51))
 		pte |=3D 1ull << 51;
+	    if (F(AC_PTE_BIT36))
+                pte |=3D 1ull << 36;
 	    at->ptep =3D &vroot[index];
 	    break;
 	}
@@ -736,6 +754,7 @@ static void ac_test_show(ac_test_t *at)
 	    strcat(line, " ");
 	    strcat(line, ac_names[i]);
 	}
+
     strcat(line, ": ");
     printf("%s", line);
 }
@@ -945,6 +964,15 @@ static int ac_test_run(void)
     shadow_cr4 =3D read_cr4();
     shadow_efer =3D rdmsr(MSR_EFER);
=20
+    if (cpuid_maxphyaddr() >=3D 52) {
+        invalid_mask |=3D AC_PDE_BIT51_MASK;
+        invalid_mask |=3D AC_PTE_BIT51_MASK;
+    }
+    if (cpuid_maxphyaddr() >=3D 37) {
+        invalid_mask |=3D AC_PDE_BIT36_MASK;
+        invalid_mask |=3D AC_PTE_BIT36_MASK;
+    }
+
     if (this_cpu_has(X86_FEATURE_PKU)) {
         set_cr4_pke(1);
         set_cr4_pke(0);
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index d658bc8..bf0d02e 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -116,7 +116,7 @@ extra_params =3D -cpu qemu64,+x2apic,+tsc-deadline -a=
ppend tscdeadline_immed
 [access]
 file =3D access.flat
 arch =3D x86_64
-extra_params =3D -cpu host
+extra_params =3D -cpu host,phys-bits=3D36
=20
 [smap]
 file =3D smap.flat
--=20
2.25.2

