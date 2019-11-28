Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D530010CA6B
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 15:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfK1Oe3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 09:34:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49225 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726401AbfK1Oe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 09:34:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574951668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3ypLLmy7uIRdZ2ESXpMXZa2LOjKZgb/771ocPNYrRmk=;
        b=T4nxUxGdmeZqEKr/WBy1u5BaCqRhkYj4fpI+LRHKaWYwEJLNvRUXlPA+1PC6CfFNAu6Rgb
        aOP+7rlGjflGsFbRx+4w6mGWOxtNjW7xwfixGt0LvXFfCdUW1uN556j10yXS2hrGtC2Qvp
        PIahxO6N6oyOOXqUaXedp1vp104lQb8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-rEEgGoYSMsaDEemHK1Gl6w-1; Thu, 28 Nov 2019 09:34:25 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EFFC1800D52;
        Thu, 28 Nov 2019 14:34:24 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2991E5C1B0;
        Thu, 28 Nov 2019 14:34:23 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     thuth@redhat.com, pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests] arm: Enable the VFP
Date:   Thu, 28 Nov 2019 15:34:21 +0100
Message-Id: <20191128143421.13815-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: rEEgGoYSMsaDEemHK1Gl6w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Variable argument macros frequently depend on floating point
registers. Indeed we needed to enable the VFP for arm64 since its
introduction in order to use printf and the like. Somehow we
didn't need to do that for arm32 until recently when compiling
with GCC 9.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---

CC'ing Thomas because I think he had to workaround travis tests
failing due to this issue once. Maybe travis can now be
un-worked-around?


 arm/cstart.S | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 114726feab82..bc6219d8a3ee 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -50,10 +50,11 @@ start:
 =09mov=09r0, r2
 =09push=09{r0-r1}
=20
-=09/* set up vector table and mode stacks */
+=09/* set up vector table, mode stacks, and enable the VFP */
 =09mov=09r0, lr=09=09=09@ lr is stack top (see above),
 =09=09=09=09=09@ which is the exception stacks base
 =09bl=09exceptions_init
+=09bl=09enable_vfp
=20
 =09/* complete setup */
 =09pop=09{r0-r1}
@@ -100,6 +101,16 @@ exceptions_init:
 =09isb
 =09mov=09pc, lr
=20
+enable_vfp:
+=09/* Enable full access to CP10 and CP11: */
+=09mov=09r0, #(3 << 22 | 3 << 20)
+=09mcr=09p15, 0, r0, c1, c0, 2
+=09isb
+=09/* Set the FPEXC.EN bit to enable Advanced SIMD and VFP: */
+=09mov=09r0, #(1 << 30)
+=09vmsr=09fpexc, r0
+=09mov=09pc, lr
+
 .text
=20
 .global get_mmu_off
@@ -130,6 +141,7 @@ secondary_entry:
 =09ldr=09r0, [r1]
 =09mov=09sp, r0
 =09bl=09exceptions_init
+=09bl=09enable_vfp
=20
 =09/* finish init in C code */
 =09bl=09secondary_cinit
--=20
2.21.0

