Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 240DF10021A
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 11:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfKRKIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 05:08:20 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:47017 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726460AbfKRKIT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Nov 2019 05:08:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574071699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SuEdHgpSfnqJ4t9uIksCSEzHcYIlpI9neglm8kr4jHA=;
        b=Bqq+Z9NiLPsLPNwrknytIeHfENP/6VZkJsIxI+7WV5B3lEmM4HHPmyrfOpOiXuqu2eXLLB
        cym7vWrg2yPLH+gtDGi2IlDNpbYqhEu/ceYXHTXKYJRg7h2iiFR5b1mSfW1eeXu5cMB/gx
        QNgmURhDRKEUddSJxIeDsF0t50j2uto=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-Xz-aM7d-NBObScfusYInwA-1; Mon, 18 Nov 2019 05:08:17 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D61C1802CEA;
        Mon, 18 Nov 2019 10:08:16 +0000 (UTC)
Received: from t460s.redhat.com (unknown [10.36.118.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A168B66856;
        Mon, 18 Nov 2019 10:08:14 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 06/12] s390x: Add CR save area
Date:   Mon, 18 Nov 2019 11:07:13 +0100
Message-Id: <20191118100719.7968-7-david@redhat.com>
In-Reply-To: <20191118100719.7968-1-david@redhat.com>
References: <20191118100719.7968-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: Xz-aM7d-NBObScfusYInwA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

If we run with DAT enabled and do a reset, we need to save the CRs to
backup our ASCEs on a diag308 for example.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20191111153345.22505-3-frankja@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 lib/s390x/asm-offsets.c  |  2 +-
 lib/s390x/asm/arch_def.h |  4 ++--
 lib/s390x/interrupt.c    |  4 ++--
 lib/s390x/smp.c          |  2 +-
 s390x/cstart64.S         | 10 +++++-----
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
index 6e2d259..4b213f8 100644
--- a/lib/s390x/asm-offsets.c
+++ b/lib/s390x/asm-offsets.c
@@ -57,7 +57,7 @@ int main(void)
 =09OFFSET(GEN_LC_SW_INT_GRS, lowcore, sw_int_grs);
 =09OFFSET(GEN_LC_SW_INT_FPRS, lowcore, sw_int_fprs);
 =09OFFSET(GEN_LC_SW_INT_FPC, lowcore, sw_int_fpc);
-=09OFFSET(GEN_LC_SW_INT_CR0, lowcore, sw_int_cr0);
+=09OFFSET(GEN_LC_SW_INT_CRS, lowcore, sw_int_crs);
 =09OFFSET(GEN_LC_MCCK_EXT_SA_ADDR, lowcore, mcck_ext_sa_addr);
 =09OFFSET(GEN_LC_FPRS_SA, lowcore, fprs_sa);
 =09OFFSET(GEN_LC_GRS_SA, lowcore, grs_sa);
diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 96cca2e..07d4e5e 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -78,8 +78,8 @@ struct lowcore {
 =09uint64_t=09sw_int_fprs[16];=09=09/* 0x0280 */
 =09uint32_t=09sw_int_fpc;=09=09=09/* 0x0300 */
 =09uint8_t=09=09pad_0x0304[0x0308 - 0x0304];=09/* 0x0304 */
-=09uint64_t=09sw_int_cr0;=09=09=09/* 0x0308 */
-=09uint8_t=09=09pad_0x0310[0x11b0 - 0x0310];=09/* 0x0310 */
+=09uint64_t=09sw_int_crs[16];=09=09=09/* 0x0308 */
+=09uint8_t=09=09pad_0x0310[0x11b0 - 0x0388];=09/* 0x0388 */
 =09uint64_t=09mcck_ext_sa_addr;=09=09/* 0x11b0 */
 =09uint8_t=09=09pad_0x11b8[0x1200 - 0x11b8];=09/* 0x11b8 */
 =09uint64_t=09fprs_sa[16];=09=09=09/* 0x1200 */
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 1636207..3e07867 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -124,13 +124,13 @@ void handle_ext_int(void)
 =09}
=20
 =09if (lc->ext_int_code =3D=3D EXT_IRQ_SERVICE_SIG) {
-=09=09lc->sw_int_cr0 &=3D ~(1UL << 9);
+=09=09lc->sw_int_crs[0] &=3D ~(1UL << 9);
 =09=09sclp_handle_ext();
 =09} else {
 =09=09ext_int_expected =3D false;
 =09}
=20
-=09if (!(lc->sw_int_cr0 & CR0_EXTM_MASK))
+=09if (!(lc->sw_int_crs[0] & CR0_EXTM_MASK))
 =09=09lc->ext_old_psw.mask &=3D ~PSW_MASK_EXT;
 }
=20
diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 7602886..f57f420 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -189,7 +189,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
 =09cpu->lowcore->sw_int_grs[15] =3D (uint64_t)cpu->stack + (PAGE_SIZE * 4)=
;
 =09lc->restart_new_psw.mask =3D 0x0000000180000000UL;
 =09lc->restart_new_psw.addr =3D (uint64_t)smp_cpu_setup_state;
-=09lc->sw_int_cr0 =3D 0x0000000000040000UL;
+=09lc->sw_int_crs[0] =3D 0x0000000000040000UL;
=20
 =09/* Start processing */
 =09rc =3D sigp_retry(cpu->addr, SIGP_RESTART, 0, NULL);
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 043e34a..4be20fc 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -92,8 +92,8 @@ memsetxc:
 =09.macro SAVE_REGS
 =09/* save grs 0-15 */
 =09stmg=09%r0, %r15, GEN_LC_SW_INT_GRS
-=09/* save cr0 */
-=09stctg=09%c0, %c0, GEN_LC_SW_INT_CR0
+=09/* save crs 0-15 */
+=09stctg=09%c0, %c15, GEN_LC_SW_INT_CRS
 =09/* load a cr0 that has the AFP control bit which enables all FPRs */
 =09larl=09%r1, initial_cr0
 =09lctlg=09%c0, %c0, 0(%r1)
@@ -112,8 +112,8 @@ memsetxc:
 =09ld=09\i, \i * 8(%r1)
 =09.endr
 =09lfpc=09GEN_LC_SW_INT_FPC
-=09/* restore cr0 */
-=09lctlg=09%c0, %c0, GEN_LC_SW_INT_CR0
+=09/* restore crs 0-15 */
+=09lctlg=09%c0, %c15, GEN_LC_SW_INT_CRS
 =09/* restore grs 0-15 */
 =09lmg=09%r0, %r15, GEN_LC_SW_INT_GRS
 =09.endm
@@ -150,7 +150,7 @@ diag308_load_reset:
 smp_cpu_setup_state:
 =09xgr=09%r1, %r1
 =09lmg     %r0, %r15, GEN_LC_SW_INT_GRS
-=09lctlg   %c0, %c0, GEN_LC_SW_INT_CR0
+=09lctlg   %c0, %c0, GEN_LC_SW_INT_CRS
 =09br=09%r14
=20
 pgm_int:
--=20
2.21.0

