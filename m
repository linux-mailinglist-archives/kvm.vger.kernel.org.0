Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA98F5760DC
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 13:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbiGOLtl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 07:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234640AbiGOLti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 07:49:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D5A302FFFA
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 04:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657885776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ie8S/4kslSZgdmx6wrSNJRQWWqTbqopyobh+d0XIkq8=;
        b=V0qN73P6ixf8wljF0wrZgdwkyHmrnUpcfn0ADBgT5DtSqeinYmXloMUGdjKSxkfUjEwk83
        Yo/XzLnJtcqzysIrNolwvB8Ag3hXMRTybiVz7WqmdkbVGY5kRKLi5S+a40o+i6/uL9wXMy
        0OIZOqhBgYoxEf2ABZxyV3ffr30VJUY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-seCiYla0MFacY20sMg_2JA-1; Fri, 15 Jul 2022 07:49:27 -0400
X-MC-Unique: seCiYla0MFacY20sMg_2JA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67777801590;
        Fri, 15 Jul 2022 11:49:27 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 397E5140EBE3;
        Fri, 15 Jul 2022 11:49:27 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, peterz@infradead.org, bp@suse.de,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] KVM: emulate: do not adjust size of fastop and setcc subroutines
Date:   Fri, 15 Jul 2022 07:49:27 -0400
Message-Id: <20220715114927.1460356-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of doing complicated calculations to find the size of the subroutines
(which are even more complicated because they need to be stringified into
an asm statement), just hardcode to 16.

It is less dense for a few combinations of IBT/SLS/retbleed, but it has
the advantage of being really simple.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 0a15b0fec6d9..f8382abe22ff 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -189,13 +189,6 @@
 #define X8(x...) X4(x), X4(x)
 #define X16(x...) X8(x), X8(x)
 
-#define NR_FASTOP	(ilog2(sizeof(ulong)) + 1)
-#define RET_LENGTH	(1 + (4 * IS_ENABLED(CONFIG_RETHUNK)) + \
-			 IS_ENABLED(CONFIG_SLS))
-#define FASTOP_LENGTH	(ENDBR_INSN_SIZE + 7 + RET_LENGTH)
-#define FASTOP_SIZE	(8 << ((FASTOP_LENGTH > 8) & 1) << ((FASTOP_LENGTH > 16) & 1))
-static_assert(FASTOP_LENGTH <= FASTOP_SIZE);
-
 struct opcode {
 	u64 flags;
 	u8 intercept;
@@ -310,9 +303,15 @@ static void invalidate_registers(struct x86_emulate_ctxt *ctxt)
  * Moreover, they are all exactly FASTOP_SIZE bytes long, so functions for
  * different operand sizes can be reached by calculation, rather than a jump
  * table (which would be bigger than the code).
+ *
+ * The 16 byte alignment, considering 5 bytes for the RET thunk, 3 for ENDBR
+ * and 1 for the straight line speculation INT3, leaves 7 bytes for the
+ * body of the function.  Currently none is larger than 4.
  */
 static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
 
+#define FASTOP_SIZE	16
+
 #define __FOP_FUNC(name) \
 	".align " __stringify(FASTOP_SIZE) " \n\t" \
 	".type " name ", @function \n\t" \
@@ -446,9 +445,7 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
  * RET | JMP __x86_return_thunk	[1,5 bytes; CONFIG_RETHUNK]
  * INT3				[1 byte; CONFIG_SLS]
  */
-#define SETCC_LENGTH	(ENDBR_INSN_SIZE + 3 + RET_LENGTH)
-#define SETCC_ALIGN	(4 << ((SETCC_LENGTH > 4) & 1) << ((SETCC_LENGTH > 8) & 1))
-static_assert(SETCC_LENGTH <= SETCC_ALIGN);
+#define SETCC_ALIGN	16
 
 #define FOP_SETCC(op) \
 	".align " __stringify(SETCC_ALIGN) " \n\t" \
-- 
2.31.1

