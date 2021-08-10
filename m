Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDC93E5E04
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 16:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239555AbhHJOc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 10:32:28 -0400
Received: from mail-0201.mail-europe.com ([51.77.79.158]:33863 "EHLO
        mail-0201.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhHJOc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 10:32:27 -0400
Date:   Tue, 10 Aug 2021 14:31:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1628605892;
        bh=jSNmtVK/+b9ExE/A5m50kmYZiQJBzm6PrdEKDryk16A=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=ERl9LSSgARKOJlRk3Wn9cFZ6PuyjFiMYZ1Of3bCNfgYQtJINCcgZpoN1L/RBQlZeh
         YRaOs3r8JiEZFDL2tjUuEbveKPXkrI+nhovokwv1M7c2eZAIjkdlZCQljxD/fGAyXz
         +D4b0NEKVnuBCWkkYirxz3jUbK22/65L88Nt8Z60=
To:     kvm@vger.kernel.org
From:   yqwfh <amdeniulari@protonmail.com>
Cc:     yqwfh <amdeniulari@protonmail.com>,
        Daniele Ahmed <ahmeddan@amazon.com>
Reply-To: yqwfh <amdeniulari@protonmail.com>
Subject: [kvm-unit-tests PATCH] x86/msr.c generalize to any input msr
Message-ID: <20210810143029.2522-1-amdeniulari@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If an MSR description is provided as input by the user,
run the test against that MSR. This allows the user to
run tests on custom MSR's.

Otherwise run all default tests.

Signed-off-by: Daniele Ahmed <ahmeddan@amazon.com>
---
 x86/msr.c | 48 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/x86/msr.c b/x86/msr.c
index 7a551c4..554014e 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -3,6 +3,7 @@
 #include "libcflat.h"
 #include "processor.h"
 #include "msr.h"
+#include <stdlib.h>
=20
 struct msr_info {
 =09int index;
@@ -77,25 +78,44 @@ static void test_rdmsr_fault(struct msr_info *msr)
 =09       "Expected #GP on RDSMR(%s), got vector %d", msr->name, vector);
 }
=20
+static void test_msr(struct msr_info *msr, bool is_64bit_host)
+{
+=09if (is_64bit_host || !msr->is_64bit_only) {
+=09=09test_msr_rw(msr, msr->value);
+
+=09=09/*
+=09=09 * The 64-bit only MSRs that take an address always perform
+=09=09 * canonical checks on both Intel and AMD.
+=09=09 */
+=09=09if (msr->is_64bit_only &&
+=09=09    msr->value =3D=3D addr_64)
+=09=09=09test_wrmsr_fault(msr, NONCANONICAL);
+=09} else {
+=09=09test_wrmsr_fault(msr, msr->value);
+=09=09test_rdmsr_fault(msr);
+=09}
+}
+
 int main(int ac, char **av)
 {
 =09bool is_64bit_host =3D this_cpu_has(X86_FEATURE_LM);
 =09int i;
=20
-=09for (i =3D 0 ; i < ARRAY_SIZE(msr_info); i++) {
-=09=09if (is_64bit_host || !msr_info[i].is_64bit_only) {
-=09=09=09test_msr_rw(&msr_info[i], msr_info[i].value);
-
-=09=09=09/*
-=09=09=09 * The 64-bit only MSRs that take an address always perform
-=09=09=09 * canonical checks on both Intel and AMD.
-=09=09=09 */
-=09=09=09if (msr_info[i].is_64bit_only &&
-=09=09=09    msr_info[i].value =3D=3D addr_64)
-=09=09=09=09test_wrmsr_fault(&msr_info[i], NONCANONICAL);
-=09=09} else {
-=09=09=09test_wrmsr_fault(&msr_info[i], msr_info[i].value);
-=09=09=09test_rdmsr_fault(&msr_info[i]);
+=09if (ac =3D=3D 4) {
+=09=09char msr_name[16];
+=09=09int index =3D strtoul(av[1], NULL, 0x10);
+=09=09snprintf(msr_name, sizeof(msr_name), "MSR:0x%x", index);
+
+=09=09struct msr_info msr =3D {
+=09=09=09.index =3D index,
+=09=09=09.name =3D msr_name,
+=09=09=09.is_64bit_only =3D !strcmp(av[3], "0"),
+=09=09=09.value =3D strtoul(av[2], NULL, 0x10)
+=09=09};
+=09=09test_msr(&msr, is_64bit_host);
+=09} else {
+=09=09for (i =3D 0 ; i < ARRAY_SIZE(msr_info); i++) {
+=09=09=09test_msr(&msr_info[i], is_64bit_host);
 =09=09}
 =09}
=20
--=20
2.20.1


