Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEDA4266C3
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 11:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhJHJ24 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 05:28:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34251 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237945AbhJHJ24 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Oct 2021 05:28:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633685221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=G4YrEDTsQ3qN474doJ0BiLWciGuINsr3+uch9s8tM/0=;
        b=TVDDiIq8tC3IX5yHd6Uii81aIPQfwoBrZSD+70+5d5FvyZoQCcesOJ1Xl+mUX3l5olC7uF
        cTJ+VsL3U20CocSTdxVNfy+3ttdEGMCQb4CMvnbj4Iy5+u5PWAf7v9lFIfPY9B2ev9P7KR
        KrcFogYoLqWvjl7aLUKWULVzJexS150=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-1oeQPHZaN4CAH0IbPenrDA-1; Fri, 08 Oct 2021 05:26:57 -0400
X-MC-Unique: 1oeQPHZaN4CAH0IbPenrDA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F163010A8E03;
        Fri,  8 Oct 2021 09:26:55 +0000 (UTC)
Received: from thuth.com (dhcp-192-183.str.redhat.com [10.33.192.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 012425F4E7;
        Fri,  8 Oct 2021 09:26:50 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH] s390x/snippets: Define all things that are needed to link the libc
Date:   Fri,  8 Oct 2021 11:26:49 +0200
Message-Id: <20211008092649.959956-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the long run, we want to use parts of the libc like memset() etc.,
too. However, to be able to link it correctly, we have to provide
some stub functions like puts() and exit() to avoid that too much
other stuff from the lib folder gets pulled into the binaries, which
we cannot provide in the snippets (like the sclp support).

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 s390x/Makefile            |  2 +-
 s390x/snippets/c/cstart.S | 11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index ef8041a..b2a7c1f 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -80,7 +80,7 @@ asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
 FLATLIBS = $(libcflat)
 
 SNIPPET_DIR = $(TEST_DIR)/snippets
-snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
+snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o lib/auxinfo.o
 
 # perquisites (=guests) for the snippet hosts.
 # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
index a175480..1862703 100644
--- a/s390x/snippets/c/cstart.S
+++ b/s390x/snippets/c/cstart.S
@@ -20,6 +20,17 @@ start:
 	lghi	%r15, 0x4000 - 160
 	sam64
 	brasl	%r14, main
+	/*
+	 * If main() returns, we stop the CPU with the code below. We also
+	 * route some functions that are required by the libc (but not usable
+	 * from snippets) to the CPU stop code below, so that snippets can
+	 * still be linked against the libc code (to use non-related functions
+	 * like memset() etc.)
+	 */
+.global puts
+.global exit
+puts:
+exit:
 	/* For now let's only use cpu 0 in snippets so this will always work. */
 	xgr	%r0, %r0
 	sigp    %r2, %r0, SIGP_STOP
-- 
2.27.0

