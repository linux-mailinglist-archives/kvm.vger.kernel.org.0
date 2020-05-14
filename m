Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25E31D3D6E
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 21:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgENT1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 15:27:13 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30790 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728068AbgENT1N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 15:27:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589484432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=/qqSyStXioAG1RadE9dj7UWYWWFSrYAkUMqp6A6ClJs=;
        b=Ji+yoSQCnyNxsMMvMykL/rdKe9AGYtWjZALIRrG6J6Ck/xdoiflw0USvJAOpXBKh2ELkKx
        IZx+gY8Lvyj2JzUbQpxp8EiEoXJEZr8mEPK+LUSM5yXegHJ6Jb1mm8G72oixJk7smFIIvI
        YTk1XlfDGgXlx3wxQd+FOdaGVQXj5pI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-cSVLu9zQNNehiYbmMv5deQ-1; Thu, 14 May 2020 15:27:08 -0400
X-MC-Unique: cSVLu9zQNNehiYbmMv5deQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4FD3100CCC4;
        Thu, 14 May 2020 19:27:07 +0000 (UTC)
Received: from thuth.com (ovpn-112-56.ams2.redhat.com [10.36.112.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B21545C1BE;
        Thu, 14 May 2020 19:27:05 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Drew Jones <drjones@redhat.com>,
        Bill Wendling <morbo@google.com>
Subject: [kvm-unit-tests PATCH 09/11] x86: use inline asm to retrieve stack pointer
Date:   Thu, 14 May 2020 21:26:24 +0200
Message-Id: <20200514192626.9950-10-thuth@redhat.com>
In-Reply-To: <20200514192626.9950-1-thuth@redhat.com>
References: <20200514192626.9950-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bill Wendling <morbo@google.com>

According to GCC's documentation, the only supported use for specifying
registers for local variables is "to specify registers for input and
output operands when calling Extended asm." Using it as a shortcut to
get the value in a register isn't guaranteed to work, and clang
complains that the variable is uninitialized.

Signed-off-by: Bill Wendling <morbo@google.com>
Message-Id: <20191030210419.213407-7-morbo@google.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 x86/vmx_tests.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 0909adb..dbf5375 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -2135,7 +2135,9 @@ static void into_guest_main(void)
 		.offset = (uintptr_t)&&into,
 		.selector = KERNEL_CS32,
 	};
-	register uintptr_t rsp asm("rsp");
+	uintptr_t rsp;
+
+	asm volatile ("mov %%rsp, %0" : "=r"(rsp));
 
 	if (fp.offset != (uintptr_t)&&into) {
 		printf("Code address too high.\n");
@@ -3231,7 +3233,9 @@ static void try_compat_invvpid(void *unused)
 		.offset = (uintptr_t)&&invvpid,
 		.selector = KERNEL_CS32,
 	};
-	register uintptr_t rsp asm("rsp");
+	uintptr_t rsp;
+
+	asm volatile ("mov %%rsp, %0" : "=r"(rsp));
 
 	TEST_ASSERT_MSG(fp.offset == (uintptr_t)&&invvpid,
 			"Code address too high.");
-- 
2.18.1

