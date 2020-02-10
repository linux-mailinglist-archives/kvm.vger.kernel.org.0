Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0AD157D7E
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 15:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgBJOf0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 09:35:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21388 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726961AbgBJOf0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 09:35:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581345325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wxwzfEhD9lbwARMsqltvsS9V4fe5j1xN/yz0t79bhtk=;
        b=ZuKhOp3ofanW/GjapSxcDh4UnINJWFu4lSOi8ORlSmZgcxvAoP4KO47NTc3QuPV55ZX28u
        dSIyt+Doc8MivMt/aITzF/5nrl5yY9CEDAIXT23xYyD2hM8hKclbG51enfuAX1PBSJA+Ml
        70RVa7A90oRy17lExIIA1lxAYj59/pg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-eIlyUFOpOBCarOq_q-uY1w-1; Mon, 10 Feb 2020 09:35:21 -0500
X-MC-Unique: eIlyUFOpOBCarOq_q-uY1w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEC008017CC
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2020 14:35:20 +0000 (UTC)
Received: from thuth.com (ovpn-116-219.ams2.redhat.com [10.36.116.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFCA760BF1;
        Mon, 10 Feb 2020 14:35:19 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [kvm-unit-tests v2 PATCH] Fixes for the umip test
Date:   Mon, 10 Feb 2020 15:35:14 +0100
Message-Id: <20200210143514.5347-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When compiling umip.c with -O2 instead of -O1, there are currently
two problems. First, the compiler complains:

 x86/umip.c: In function =E2=80=98do_ring3=E2=80=99:
 x86/umip.c:162:37: error: array subscript 4096 is above array bounds of
    =E2=80=98unsigned char[4096]=E2=80=99 [-Werror=3Darray-bounds]
       [user_stack_top]"m"(user_stack[sizeof user_stack]),
                           ~~~~~~~~~~^~~~~~~~~~~~~~~~~~~

This can be fixed by initializing the stack to point to one of the last
bytes of the array instead.

The second problem is that some tests are failing - and this is due
to the fact that the GP_ASM macro uses inline asm without the "volatile"
keyword - so that the compiler reorders this code in certain cases
where it should not. Fix it by adding "volatile" here.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 v2: Add parentheses and fix doubled whitespace as requested by Vitaly

 x86/umip.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/x86/umip.c b/x86/umip.c
index 7eee294..339bea4 100644
--- a/x86/umip.c
+++ b/x86/umip.c
@@ -22,7 +22,8 @@ static void gp_handler(struct ex_regs *regs)
=20
=20
 #define GP_ASM(stmt, in, clobber)                  \
-     asm ("mov" W " $1f, %[expected_rip]\n\t"      \
+    asm volatile (                                 \
+          "mov" W " $1f, %[expected_rip]\n\t"      \
           "movl $2f-1f, %[skip_count]\n\t"         \
           "1: " stmt "\n\t"                        \
           "2: "                                    \
@@ -159,7 +160,7 @@ static int do_ring3(void (*fn)(const char *), const c=
har *arg)
 		  : [ret] "=3D&a" (ret)
 		  : [user_ds] "i" (USER_DS),
 		    [user_cs] "i" (USER_CS),
-		    [user_stack_top]"m"(user_stack[sizeof user_stack]),
+		    [user_stack_top]"m"(user_stack[sizeof(user_stack) - 2]),
 		    [fn]"r"(fn),
 		    [arg]"D"(arg),
 		    [kernel_ds]"i"(KERNEL_DS),
--=20
2.18.1

