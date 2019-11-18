Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F35A10021F
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 11:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfKRKIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 05:08:35 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53837 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726939AbfKRKIe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Nov 2019 05:08:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574071713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AF5kCxnhcY+wtM+5gf1bIk5t+a0ot/QQ0x+BuTjmraA=;
        b=Tot139I2U6Nvr7IlYR3YiF78ymXOXbyjs3M5fcyTPSywVL8ya/4ZKRhV5egFTa29CFs4zg
        jLFhL0Q3VhQhmgJiGIevovy1KNpEiNZx2Pin5MJdTGrG2xGHUcytLn1WOfe3at1mhdZ3Lb
        Yv0xTFR36VyYgxtQQbaIGOnx9hd2yy0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-TIj_l0MVOQG6d5dv4cUlhA-1; Mon, 18 Nov 2019 05:08:23 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E233D477;
        Mon, 18 Nov 2019 10:08:22 +0000 (UTC)
Received: from t460s.redhat.com (unknown [10.36.118.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5FFE75E30;
        Mon, 18 Nov 2019 10:08:16 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 07/12] s390x: Load reset psw on diag308 reset
Date:   Mon, 18 Nov 2019 11:07:14 +0100
Message-Id: <20191118100719.7968-8-david@redhat.com>
In-Reply-To: <20191118100719.7968-1-david@redhat.com>
References: <20191118100719.7968-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: TIj_l0MVOQG6d5dv4cUlhA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

On a diag308 subcode 0 CRs will be reset, so we need a PSW mask
without DAT. Also we need to set the short psw indication to be
compliant with the architecture.

Let's therefore define a reset PSW mask with 64 bit addressing and
short PSW indication that is compliant with architecture and use it.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20191113112403.7664-1-frankja@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 lib/s390x/asm-offsets.c  |  1 +
 lib/s390x/asm/arch_def.h |  4 +++-
 s390x/cstart64.S         | 24 +++++++++++++++++-------
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
index 4b213f8..61d2658 100644
--- a/lib/s390x/asm-offsets.c
+++ b/lib/s390x/asm-offsets.c
@@ -58,6 +58,7 @@ int main(void)
 =09OFFSET(GEN_LC_SW_INT_FPRS, lowcore, sw_int_fprs);
 =09OFFSET(GEN_LC_SW_INT_FPC, lowcore, sw_int_fpc);
 =09OFFSET(GEN_LC_SW_INT_CRS, lowcore, sw_int_crs);
+=09OFFSET(GEN_LC_SW_INT_PSW, lowcore, sw_int_psw);
 =09OFFSET(GEN_LC_MCCK_EXT_SA_ADDR, lowcore, mcck_ext_sa_addr);
 =09OFFSET(GEN_LC_FPRS_SA, lowcore, fprs_sa);
 =09OFFSET(GEN_LC_GRS_SA, lowcore, grs_sa);
diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 07d4e5e..cf6e1ca 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -79,7 +79,8 @@ struct lowcore {
 =09uint32_t=09sw_int_fpc;=09=09=09/* 0x0300 */
 =09uint8_t=09=09pad_0x0304[0x0308 - 0x0304];=09/* 0x0304 */
 =09uint64_t=09sw_int_crs[16];=09=09=09/* 0x0308 */
-=09uint8_t=09=09pad_0x0310[0x11b0 - 0x0388];=09/* 0x0388 */
+=09struct psw=09sw_int_psw;=09=09=09/* 0x0388 */
+=09uint8_t=09=09pad_0x0310[0x11b0 - 0x0398];=09/* 0x0398 */
 =09uint64_t=09mcck_ext_sa_addr;=09=09/* 0x11b0 */
 =09uint8_t=09=09pad_0x11b8[0x1200 - 0x11b8];=09/* 0x11b8 */
 =09uint64_t=09fprs_sa[16];=09=09=09/* 0x1200 */
@@ -98,6 +99,7 @@ struct lowcore {
 =09uint8_t=09=09pad_0x1400[0x1800 - 0x1400];=09/* 0x1400 */
 =09uint8_t=09=09pgm_int_tdb[0x1900 - 0x1800];=09/* 0x1800 */
 } __attribute__ ((__packed__));
+_Static_assert(sizeof(struct lowcore) =3D=3D 0x1900, "Lowcore size");
=20
 #define PGM_INT_CODE_OPERATION=09=09=090x01
 #define PGM_INT_CODE_PRIVILEGED_OPERATION=090x02
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 4be20fc..86dd4c4 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -126,13 +126,18 @@ memsetxc:
 .globl diag308_load_reset
 diag308_load_reset:
 =09SAVE_REGS
-=09/* Save the first PSW word to the IPL PSW */
+=09/* Backup current PSW mask, as we have to restore it on success */
 =09epsw=09%r0, %r1
-=09st=09%r0, 0
-=09/* Store the address and the bit for 31 bit addressing */
-=09larl    %r0, 0f
-=09oilh    %r0, 0x8000
-=09st      %r0, 0x4
+=09st=09%r0, GEN_LC_SW_INT_PSW
+=09st=09%r1, GEN_LC_SW_INT_PSW + 4
+=09/* Load reset psw mask (short psw, 64 bit) */
+=09lg=09%r0, reset_psw
+=09/* Load the success label address */
+=09larl    %r1, 0f
+=09/* Or it to the mask */
+=09ogr=09%r0, %r1
+=09/* Store it at the reset PSW location (real 0x0) */
+=09stg=09%r0, 0
 =09/* Do the reset */
 =09diag    %r0,%r2,0x308
 =09/* Failure path */
@@ -144,7 +149,10 @@ diag308_load_reset:
 =09lctlg=09%c0, %c0, 0(%r1)
 =09RESTORE_REGS
 =09lhi=09%r2, 1
-=09br=09%r14
+=09larl=09%r0, 1f
+=09stg=09%r0, GEN_LC_SW_INT_PSW + 8
+=09lpswe=09GEN_LC_SW_INT_PSW
+1:=09br=09%r14
=20
 .globl smp_cpu_setup_state
 smp_cpu_setup_state:
@@ -184,6 +192,8 @@ svc_int:
 =09lpswe=09GEN_LC_SVC_OLD_PSW
=20
 =09.align=098
+reset_psw:
+=09.quad=090x0008000180000000
 initial_psw:
 =09.quad=090x0000000180000000, clear_bss_start
 pgm_int_psw:
--=20
2.21.0

