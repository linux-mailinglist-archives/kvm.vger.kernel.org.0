Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071901FD0C8
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 17:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgFQPVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 11:21:33 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40299 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726491AbgFQPVd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 11:21:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592407291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oLO6rZ7Kgav5d6Xjpk0xbKq2RZwg420FPPXpydpe5Bc=;
        b=NmkTCxE4M3X0vPRrNkpwPwKR4aaABixGgHCX+we5AZQAEkmQGdaJ6K1g+E+3Lv295bpGmu
        ndbrC9UUzT2Aij4rI65GxjOwMIXWIMys2+3HcRMcTnYzVt7RVl9JkDHVdS15r9lzYS1fuT
        DiB0dJflAq3Z1cTyZNEq3yEyjSJnqbw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-93NMQDC8Nr6RVG9W2nZ9-Q-1; Wed, 17 Jun 2020 11:21:29 -0400
X-MC-Unique: 93NMQDC8Nr6RVG9W2nZ9-Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2650C803302
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 15:21:28 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.196.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9DFE7CADF;
        Wed, 17 Jun 2020 15:21:25 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH] x86: fix build with GCC10
Date:   Wed, 17 Jun 2020 17:21:24 +0200
Message-Id: <20200617152124.402765-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm-unit-tests fail to build with GCC10:

/usr/bin/ld: lib/libcflat.a(usermode.o):
  ./kvm-unit-tests/lib/x86/usermode.c:17:  multiple definition of `jmpbuf';
 lib/libcflat.a(fault_test.o):
  ./kvm-unit-tests/lib/x86/fault_test.c:3: first defined here

It seems that 'jmpbuf' doesn't need to be global in either of these files,
make it static in both.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 lib/x86/fault_test.c | 2 +-
 lib/x86/usermode.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/x86/fault_test.c b/lib/x86/fault_test.c
index 078dae3da640..e15a21864562 100644
--- a/lib/x86/fault_test.c
+++ b/lib/x86/fault_test.c
@@ -1,6 +1,6 @@
 #include "fault_test.h"
 
-jmp_buf jmpbuf;
+static jmp_buf jmpbuf;
 
 static void restore_exec_to_jmpbuf(void)
 {
diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index f01ad9be1799..f0325236dd05 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -14,7 +14,7 @@
 #define USERMODE_STACK_SIZE	0x2000
 #define RET_TO_KERNEL_IRQ	0x20
 
-jmp_buf jmpbuf;
+static jmp_buf jmpbuf;
 
 static void restore_exec_to_jmpbuf(void)
 {
-- 
2.25.4

