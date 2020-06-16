Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195D51FB351
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 16:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729282AbgFPOCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 10:02:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20621 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729003AbgFPOCl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 10:02:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592316161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GUqpCaNzjY1hrjMIqzl3wKstWVQu95CSihxsh9IdoT8=;
        b=GyoiW6us3h729QtOoyNqg83z7PAfAy5ON/COzDWY1sN8nhZYtHUmhewrgWqHzpp7liJRss
        7M2W4sCbJeMqrpoSycNaamFchpFxOvOXwqloef5Kotqycj1UNXcw/jQ/5lTNbtbCp2Nnj1
        Ttnrvx8i06H3pyE+u2PG6x3CXW3BCRk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-qMmBIBchPnCwvNUgoMlwag-1; Tue, 16 Jun 2020 10:02:37 -0400
X-MC-Unique: qMmBIBchPnCwvNUgoMlwag-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58ED31B2C9A5
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 14:02:18 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E05515D9D7;
        Tue, 16 Jun 2020 14:02:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com
Subject: [PATCH kvm-unit-tests] x86: disable SSE on 32-bit hosts
Date:   Tue, 16 Jun 2020 10:02:17 -0400
Message-Id: <20200616140217.104362-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 64-bit hosts we are disabling SSE and SSE2.  Depending on the
compiler however it may use movq instructions for 64-bit transfers
even when targeting 32-bit processors; when CR4.OSFXSR is not set,
this results in an undefined opcode exception, so tell the compiler
to avoid those instructions on 32-bit hosts as well.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/Makefile.i386 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/Makefile.i386 b/x86/Makefile.i386
index d801b80..be9d6bc 100644
--- a/x86/Makefile.i386
+++ b/x86/Makefile.i386
@@ -1,6 +1,7 @@
 cstart.o = $(TEST_DIR)/cstart.o
 bits = 32
 ldarch = elf32-i386
+COMMON_CFLAGS += -mno-sse -mno-sse2
 
 cflatobjs += lib/x86/setjmp32.o
 
-- 
2.26.2

