Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3C8100212
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 11:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfKRKHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 05:07:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29534 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726490AbfKRKHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 05:07:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574071670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ycY2H6t9OzJIOigDNMwvvZn5InpDjzanbHdcM8sdl9k=;
        b=C8s91vIo0nFh2UHdFzBQ1lHsDUFjMVs4Wodc2kxpX3DUDc9/S9MqB4jJkBg3d+YBSbCS2/
        qolztN2fev/FDQS3WNHT0kNPaZ5JQO1KAv9IZGEUunRQJNgqoT/awY+R5dGo9x7W9NVCKt
        apo4uVo/jzq9wH3uYYdP+JFJZJumBAk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-FYiHeIxqMvSai-K4wDRg5g-1; Mon, 18 Nov 2019 05:07:46 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E2FD107ACE4;
        Mon, 18 Nov 2019 10:07:45 +0000 (UTC)
Received: from t460s.redhat.com (unknown [10.36.118.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF65C75E30;
        Mon, 18 Nov 2019 10:07:32 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 01/12] s390x: Use loop to save and restore fprs
Date:   Mon, 18 Nov 2019 11:07:08 +0100
Message-Id: <20191118100719.7968-2-david@redhat.com>
In-Reply-To: <20191118100719.7968-1-david@redhat.com>
References: <20191118100719.7968-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: FYiHeIxqMvSai-K4wDRg5g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Let's save some lines in the assembly by using a loop to save and
restore the fprs.

Tested-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20191104085533.2892-1-frankja@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 s390x/cstart64.S | 38 ++++++--------------------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 5dc1577..8e2b21e 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -99,44 +99,18 @@ memsetxc:
 =09lctlg=09%c0, %c0, 0(%r1)
 =09/* save fprs 0-15 + fpc */
 =09la=09%r1, GEN_LC_SW_INT_FPRS
-=09std=09%f0, 0(%r1)
-=09std=09%f1, 8(%r1)
-=09std=09%f2, 16(%r1)
-=09std=09%f3, 24(%r1)
-=09std=09%f4, 32(%r1)
-=09std=09%f5, 40(%r1)
-=09std=09%f6, 48(%r1)
-=09std=09%f7, 56(%r1)
-=09std=09%f8, 64(%r1)
-=09std=09%f9, 72(%r1)
-=09std=09%f10, 80(%r1)
-=09std=09%f11, 88(%r1)
-=09std=09%f12, 96(%r1)
-=09std=09%f13, 104(%r1)
-=09std=09%f14, 112(%r1)
-=09std=09%f15, 120(%r1)
+=09.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+=09std=09\i, \i * 8(%r1)
+=09.endr
 =09stfpc=09GEN_LC_SW_INT_FPC
 =09.endm
=20
 =09.macro RESTORE_REGS
 =09/* restore fprs 0-15 + fpc */
 =09la=09%r1, GEN_LC_SW_INT_FPRS
-=09ld=09%f0, 0(%r1)
-=09ld=09%f1, 8(%r1)
-=09ld=09%f2, 16(%r1)
-=09ld=09%f3, 24(%r1)
-=09ld=09%f4, 32(%r1)
-=09ld=09%f5, 40(%r1)
-=09ld=09%f6, 48(%r1)
-=09ld=09%f7, 56(%r1)
-=09ld=09%f8, 64(%r1)
-=09ld=09%f9, 72(%r1)
-=09ld=09%f10, 80(%r1)
-=09ld=09%f11, 88(%r1)
-=09ld=09%f12, 96(%r1)
-=09ld=09%f13, 104(%r1)
-=09ld=09%f14, 112(%r1)
-=09ld=09%f15, 120(%r1)
+=09.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+=09ld=09\i, \i * 8(%r1)
+=09.endr
 =09lfpc=09GEN_LC_SW_INT_FPC
 =09/* restore cr0 */
 =09lctlg=09%c0, %c0, GEN_LC_SW_INT_CR0
--=20
2.21.0

