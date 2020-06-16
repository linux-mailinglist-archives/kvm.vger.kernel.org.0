Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B63E1FBE94
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 20:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730396AbgFPS4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 14:56:37 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35609 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730082AbgFPS4c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 14:56:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592333791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lz8dTB+N9OTpHHu5R1TNOSXQkrZEQyo4bOoaenoe9gw=;
        b=O14niA+mYDF52kOHOpwllelb/tm97FtJ9Lhwhh4IbsRY9zPbitd63xBM3Jykrxzrs8cbxY
        1fNoTvumfBzbNnU/DH9diX8HPbRMRlsa/mugM/CC0Pp6z0H0U39/om88szTGoEl4abcTcA
        Ec/gmgr1Y7sghJauN9WbhUbKy8/XrZ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-jj49tza1OD2JfO83uQt0Nw-1; Tue, 16 Jun 2020 14:56:30 -0400
X-MC-Unique: jj49tza1OD2JfO83uQt0Nw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 513E410059BA
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 18:56:29 +0000 (UTC)
Received: from thuth.com (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7898A7CAA8;
        Tue, 16 Jun 2020 18:56:28 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PULL 03/12] Fixes for the umip test
Date:   Tue, 16 Jun 2020 20:56:13 +0200
Message-Id: <20200616185622.8644-4-thuth@redhat.com>
In-Reply-To: <20200616185622.8644-1-thuth@redhat.com>
References: <20200616185622.8644-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

Message-Id: <20200122160944.29750-1-thuth@redhat.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 x86/umip.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/x86/umip.c b/x86/umip.c
index afb373d..c5700b3 100644
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

