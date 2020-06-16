Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAB51FBE9C
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 20:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbgFPS4u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 14:56:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45516 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730585AbgFPS4s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 14:56:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592333807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=1sXdCsLD/wNLgcX2hxdbu2F9Htj/d109TbAOyp+XA8Q=;
        b=h9vwgFO0spv6cym0fRdxlxwSa8pVaHC+9NJ44GoGL0BPLcdmCarN+T+oEkfrdTszJNT00i
        aedeAhpHkoG2YzRcg4szdhBxFINcoE+yS8Rj7qOgOzOwSFTcpnW5JLr9Vu6T0h+c3rqlGF
        8468yNpxs1woFl4CXam2Y4qpsiM+wrI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-idPy71MYNWOngTFwnjonpA-1; Tue, 16 Jun 2020 14:56:39 -0400
X-MC-Unique: idPy71MYNWOngTFwnjonpA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8611580F5FA;
        Tue, 16 Jun 2020 18:56:38 +0000 (UTC)
Received: from thuth.com (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD7127CAA8;
        Tue, 16 Jun 2020 18:56:34 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Bill Wendling <morbo@google.com>
Subject: [kvm-unit-tests PULL 08/12] x86: use inline asm to retrieve stack pointer
Date:   Tue, 16 Jun 2020 20:56:18 +0200
Message-Id: <20200616185622.8644-9-thuth@redhat.com>
In-Reply-To: <20200616185622.8644-1-thuth@redhat.com>
References: <20200616185622.8644-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
index 68f93d3..fcd97a1 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -2253,7 +2253,9 @@ static void into_guest_main(void)
 		.offset = (uintptr_t)&&into,
 		.selector = KERNEL_CS32,
 	};
-	register uintptr_t rsp asm("rsp");
+	uintptr_t rsp;
+
+	asm volatile ("mov %%rsp, %0" : "=r"(rsp));
 
 	if (fp.offset != (uintptr_t)&&into) {
 		printf("Code address too high.\n");
@@ -3349,7 +3351,9 @@ static void try_compat_invvpid(void *unused)
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

