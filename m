Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F646D5CDA
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 12:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbjDDKPc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 06:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233732AbjDDKPb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 06:15:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5E010C7
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 03:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680603282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qoVCcbQNYY3FcSB9Lyr/ZnchZS/D69fQl5IFH8J4fgo=;
        b=MfJCxzKEU9KARqkAXi+7GW5AhICkzaiV2KrA2BxOufYFAzvYMubOHTRrqYkG3VsDczjtbQ
        xEVTeZHwTvvUQWfGx5PSzPW3daxmxQxp7pi58NY/H3LIP0xRcvMHM4XG9Wjh9e2Obf6aCz
        mn2DqMkMc0VDSNs85EeAxfBA0eMEnG4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-CKbJ4-y0PK6cBpeA8vUwaw-1; Tue, 04 Apr 2023 06:14:38 -0400
X-MC-Unique: CKbJ4-y0PK6cBpeA8vUwaw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD329101A553;
        Tue,  4 Apr 2023 10:14:37 +0000 (UTC)
Received: from thuth.com (unknown [10.39.193.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 948D940C6EC4;
        Tue,  4 Apr 2023 10:14:36 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH] s390x/snippets: Fix compilation with Clang 15
Date:   Tue,  4 Apr 2023 12:14:34 +0200
Message-Id: <20230404101434.172721-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clang complains:

 s390x/snippets/c/cstart.S:22:13: error: invalid operand for instruction
  lghi %r15, stackptr
             ^
Let's load the address with "larl" instead, like we already do
it in s390x/cstart64.S. For this we should also switch to 64-bit
mode first, then we also don't have to clear r15 right in front
of this anymore.

Changing the code here triggered another problem: initial_cr0
must be aligned on a double-word boundary, otherwise the lctlg
instruction will fail with an specification exception. This was
just working by accident so far - add an ".align 8" now to avoid
the problem.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 s390x/snippets/c/cstart.S | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
index a7d4cd42..c80ccfed 100644
--- a/s390x/snippets/c/cstart.S
+++ b/s390x/snippets/c/cstart.S
@@ -15,12 +15,12 @@ start:
 	larl	%r1, initial_cr0
 	lctlg	%c0, %c0, 0(%r1)
 	/* XOR all registers with themselves to clear them fully. */
-	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14
 	xgr \i,\i
 	.endr
-	/* 0x3000 is the stack page for now */
-	lghi	%r15, stackptr
 	sam64
+	/* 0x3000 is the stack page for now */
+	larl	%r15, stackptr
 	brasl	%r14, main
 	/*
 	 * If main() returns, we stop the CPU with the code below. We also
@@ -37,6 +37,7 @@ exit:
 	xgr	%r0, %r0
 	sigp    %r2, %r0, SIGP_STOP
 
+	.align 8
 initial_cr0:
 	/* enable AFP-register control, so FP regs (+BFP instr) can be used */
 	.quad	0x0000000000040000
-- 
2.31.1

