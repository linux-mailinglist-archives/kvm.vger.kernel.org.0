Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264F11CF1D8
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 11:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgELJor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 05:44:47 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21344 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726187AbgELJor (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 May 2020 05:44:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589276686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AlBBtiFsBQAYEIktUSByiopncaRspUIywvSAFY/TY4Q=;
        b=LINTnhq6nGu8SLJCHTR9ZubOZ8DSrL1XBNYl9+HaK9VW9/wv9ov53dtgkgD9RvnHfvXVi0
        m7OJ61NwZYLuywrQ9RdhbheUfohiLWQ6nYPnGXK0RRfNkvGaS35mjzYd6Ty4llxKdMqIxo
        Fttz7Y/GHKcENIlQYgG4uc1lo69xyGE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-ZJtHkdEHOg2fPbSVxa7bZg-1; Tue, 12 May 2020 05:44:44 -0400
X-MC-Unique: ZJtHkdEHOg2fPbSVxa7bZg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF051835B46
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 09:44:43 +0000 (UTC)
Received: from thuth.com (ovpn-112-112.ams2.redhat.com [10.36.112.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B6625C1B5;
        Tue, 12 May 2020 09:44:41 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [kvm-unit-tests v3 PATCH] Fixes for the umip test
Date:   Tue, 12 May 2020 11:44:38 +0200
Message-Id: <20200512094438.17998-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When compiling umip.c with -O2 instead of -O1, there are currently
two problems. First, the compiler complains:

 x86/umip.c: In function ‘do_ring3’:
 x86/umip.c:162:37: error: array subscript 4096 is above array bounds of
    ‘unsigned char[4096]’ [-Werror=array-bounds]
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
 v3: Use "sizeof(long)" instead of "2"

 x86/umip.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/x86/umip.c b/x86/umip.c
index 7eee294..37f1ab8 100644
--- a/x86/umip.c
+++ b/x86/umip.c
@@ -22,7 +22,8 @@ static void gp_handler(struct ex_regs *regs)
 
 
 #define GP_ASM(stmt, in, clobber)                  \
-     asm ("mov" W " $1f, %[expected_rip]\n\t"      \
+    asm volatile (                                 \
+          "mov" W " $1f, %[expected_rip]\n\t"      \
           "movl $2f-1f, %[skip_count]\n\t"         \
           "1: " stmt "\n\t"                        \
           "2: "                                    \
@@ -159,7 +160,8 @@ static int do_ring3(void (*fn)(const char *), const char *arg)
 		  : [ret] "=&a" (ret)
 		  : [user_ds] "i" (USER_DS),
 		    [user_cs] "i" (USER_CS),
-		    [user_stack_top]"m"(user_stack[sizeof user_stack]),
+		    [user_stack_top]"m"(user_stack[sizeof(user_stack) -
+						   sizeof(long)]),
 		    [fn]"r"(fn),
 		    [arg]"D"(arg),
 		    [kernel_ds]"i"(KERNEL_DS),
-- 
2.18.1

