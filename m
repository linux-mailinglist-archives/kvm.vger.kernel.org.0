Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9443C6CD974
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 14:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjC2MjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 08:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjC2MjD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 08:39:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0ACF4
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 05:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680093498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rYiDi7dQk/2qN23vK8m4PCIM3+xRz1yUfh9RqgRzV1c=;
        b=Cy5hZUAkEsHxnKtTUNvLKAHsaFQjQpFpqf+JfWJ+TwUgucevNyUbD1LrfP7xiMvLXt5ylY
        NqNWtJTRevC9nx/gr8g4vLpTkR25yUfxU81c0WMsFpDyAiXosa66TSf/hMvU4QDkxCBDWq
        rojr4ZFiEhzu628Y8EExfPp5Whoua48=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-WXSjlxt9Pzq06UwtQX0F3Q-1; Wed, 29 Mar 2023 08:38:17 -0400
X-MC-Unique: WXSjlxt9Pzq06UwtQX0F3Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FE2E3C1068D
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 12:38:16 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFEE62027040;
        Wed, 29 Mar 2023 12:38:15 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH] x86/flat.lds: Silence warnings about empty loadable segments
Date:   Wed, 29 Mar 2023 14:38:14 +0200
Message-Id: <20230329123814.76051-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recent versions of objcopy (e.g. from Fedora 37) complain:

 objcopy: x86/vmx.elf: warning: empty loadable segment detected at
  vaddr=0x400000, is this intentional?

Seems like we can silence these warnings by properly specifying
program headers in the linker script.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 x86/flat.lds | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/x86/flat.lds b/x86/flat.lds
index 337bc44f..017a8500 100644
--- a/x86/flat.lds
+++ b/x86/flat.lds
@@ -1,18 +1,24 @@
+PHDRS
+{
+    text PT_LOAD FLAGS(5);
+    data PT_LOAD FLAGS(6);
+}
+
 SECTIONS
 {
     . = 4M + SIZEOF_HEADERS;
     stext = .;
-    .text : { *(.init) *(.text) *(.text.*) }
+    .text : { *(.init) *(.text) *(.text.*) } :text
     etext = .;
     . = ALIGN(4K);
     .data : {
           *(.data)
           exception_table_start = .;
           *(.data.ex)
-	  exception_table_end = .;
-	  }
+          exception_table_end = .;
+    } :data
     . = ALIGN(16);
-    .rodata : { *(.rodata) }
+    .rodata : { *(.rodata) } :data
     . = ALIGN(16);
     .bss : { *(.bss) }
     . = ALIGN(4K);
-- 
2.31.1

