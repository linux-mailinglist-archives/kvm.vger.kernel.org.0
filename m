Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452E8783B23
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 09:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbjHVHuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 03:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjHVHuC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 03:50:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CED198
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 00:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692690553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=c+WJBdEnpU0run0/yOrKvOt+uQ+Pqjk0fTSQ3WRtrkw=;
        b=gdfmbF8Ej+kJq+sGFA1WG6GmbyWF5IInO2gAqzOFTVBKMsq9boslK57f9h+ek8wJN/m5mH
        X5aUqMe96qzZ2gFVk4CHAFGPaJvyyDBcnAsnakS939oe4HwjDtZ2PBFvUn9eLYEfEx9nJI
        wPpRbox1B16YPjTAt4xxkPvqeTD/tgU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-bZRhQ5B8PIOOyK0w2hvxFw-1; Tue, 22 Aug 2023 03:49:09 -0400
X-MC-Unique: bZRhQ5B8PIOOyK0w2hvxFw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6149185CBEC;
        Tue, 22 Aug 2023 07:49:09 +0000 (UTC)
Received: from thuth.com (unknown [10.39.194.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F8A02026D4B;
        Tue, 22 Aug 2023 07:49:08 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Andrew Jones <andrew.jones@linux.dev>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH] Makefile: Move -no-pie from CFLAGS into LDFLAGS
Date:   Tue, 22 Aug 2023 09:49:06 +0200
Message-Id: <20230822074906.7205-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"-no-pie" is an option for linking, not for compiling, so we must put
this into the lDFLAGS, not into CFLAGS. Without this change, the linking
currently fails on Ubuntu 22.04 when compiling on a s390x host.

Reported-by: Janosch Frank <frankja@linux.ibm.com>
Fixes: e489c25e ("Rework the common LDFLAGS to become more useful again")
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 8809a8b6..e7998a40 100644
--- a/Makefile
+++ b/Makefile
@@ -80,7 +80,7 @@ COMMON_CFLAGS += $(if $(U32_LONG_FMT),-D__U32_LONG_FMT__,)
 ifeq ($(CONFIG_EFI),y)
 COMMON_CFLAGS += $(EFI_CFLAGS)
 else
-COMMON_CFLAGS += $(fno_pic) $(no_pie)
+COMMON_CFLAGS += $(fno_pic)
 endif
 COMMON_CFLAGS += $(wclobbered)
 COMMON_CFLAGS += $(wunused_but_set_parameter)
@@ -92,7 +92,7 @@ CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
 
 autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d
 
-LDFLAGS += -nostdlib -z noexecstack
+LDFLAGS += -nostdlib $(no_pie) -z noexecstack
 
 $(libcflat): $(cflatobjs)
 	$(AR) rcs $@ $^
-- 
2.39.3

