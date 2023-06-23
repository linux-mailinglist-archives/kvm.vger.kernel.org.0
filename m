Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060D073B861
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 15:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbjFWNGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 09:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbjFWNGb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 09:06:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2772105
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 06:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687525544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=El4VroHOllIBmAMq4mcyvIq/rdpFjMS5b4p6zjgT9ik=;
        b=hDgWb05GDxGlbBsmHpI0iv9mP41tyc7bO8u1yFzaCFfv4ElEUavdyqd++7B4ezsb9a+rtz
        6YMc0nrCX//rPnArV5TA2eGsFjIPY3UsMBvFWCvzmpLdhjEkLwrmGA5ZnJuhz1buvd2YV7
        WZjSNwvW6mxcDQoLOdunX+PVE68X6kI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-Uf5bNq_8M_6EQypVaKhmOw-1; Fri, 23 Jun 2023 09:05:40 -0400
X-MC-Unique: Uf5bNq_8M_6EQypVaKhmOw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25D1783505D;
        Fri, 23 Jun 2023 13:05:32 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FB04425357;
        Fri, 23 Jun 2023 13:05:31 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] arm/flat.lds: Specify program headers with flags to avoid linker warnings
Date:   Fri, 23 Jun 2023 15:05:28 +0200
Message-Id: <20230623130528.483909-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With ld from binutils v2.40 I currently get warning messages like this:

 ld: warning: arm/spinlock-test.elf has a LOAD segment with RWX permissions
 ld: warning: arm/selftest.elf has a LOAD segment with RWX permissions
 ld: warning: arm/pci-test.elf has a LOAD segment with RWX permissions
 ld: warning: arm/pmu.elf has a LOAD segment with RWX permissions
 ...

Seems like these can be silenced by explicitly specifying the program
headers with the appropriate flags (like we did in commit 0a06949aafac4a4
on x86 and in commit 5126732d73aa75 on powerpc already).

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arm/flat.lds | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arm/flat.lds b/arm/flat.lds
index 47fcb649..f722c650 100644
--- a/arm/flat.lds
+++ b/arm/flat.lds
@@ -22,10 +22,16 @@
  *    +----------------------+   <-- physical address 0x0
  */
 
+PHDRS
+{
+    text PT_LOAD FLAGS(5);
+    data PT_LOAD FLAGS(6);
+}
+
 SECTIONS
 {
     PROVIDE(_text = .);
-    .text : { *(.init) *(.text) *(.text.*) }
+    .text : { *(.init) *(.text) *(.text.*) } :text
     . = ALIGN(64K);
     PROVIDE(etext = .);
 
@@ -39,8 +45,8 @@ SECTIONS
     .got      : { *(.got) *(.got.plt) }
     .eh_frame : { *(.eh_frame) }
 
-    .rodata   : { *(.rodata*) }
-    .data     : { *(.data) }
+    .rodata   : { *(.rodata*) } :data
+    .data     : { *(.data) } :data
     . = ALIGN(16);
     PROVIDE(bss = .);
     .bss      : { *(.bss) }
-- 
2.39.3

