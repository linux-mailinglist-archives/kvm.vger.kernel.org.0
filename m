Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0140E4E44D3
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 18:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239462AbiCVRQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 13:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239445AbiCVRQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 13:16:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39CD66FA0A
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647969313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+4gS4eQiRh7O4+5KU0qvmKwVd/7+E7U93hKhGWYZUms=;
        b=YvGelb7yHU6R4sq4IIxNGTmIjRewY1wT65wg/jGjOHWe7+FIec+kpeqWZzkkcGLDW35x0p
        P+fSYpCLvjzsmjioExD9ILdr2+HywTlzH4lwWMeZf/zYnnuXz0h7c7ejNLibKITBrbxKVD
        U8oT1gHCAlamOZLVEU73+l4eb4J5PTA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-dbHoRGhqMWuEBMWoXyJ5RA-1; Tue, 22 Mar 2022 13:15:09 -0400
X-MC-Unique: dbHoRGhqMWuEBMWoXyJ5RA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A25CD2999B37;
        Tue, 22 Mar 2022 17:15:08 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20FAA43F048;
        Tue, 22 Mar 2022 17:15:06 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [kvm-unit-tests PATCH] Allow to compile without -Werror
Date:   Tue, 22 Mar 2022 18:15:04 +0100
Message-Id: <20220322171504.941686-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Newer compiler versions sometimes introduce new warnings - and compiling
with -Werror will fail there, of course. Thus users of the kvm-unit-tests
like the buildroot project have to disable the "-Werror" in the Makefile
with an additional patch, which is cumbersome.
Thus let's add a switch to the configure script that allows to explicitly
turn the -Werror switch on or off. And enable it only by default for
developer builds (i.e. in checked-out git repositories) ... and for
tarball releases, it's nicer if it is disabled by default, so that the
end users do not have to worry about this.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 See also the patch from the buildroot project:
 https://git.busybox.net/buildroot/tree/package/kvm-unit-tests/0001-Makefile-remove-Werror-to-avoid-build-failures.patch

 Makefile  |  2 +-
 configure | 16 ++++++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 24686dd..6ed5dea 100644
--- a/Makefile
+++ b/Makefile
@@ -62,7 +62,7 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
 
 COMMON_CFLAGS += -g $(autodepend-flags) -fno-strict-aliasing -fno-common
 COMMON_CFLAGS += -Wall -Wwrite-strings -Wempty-body -Wuninitialized
-COMMON_CFLAGS += -Wignored-qualifiers -Werror -Wno-missing-braces
+COMMON_CFLAGS += -Wignored-qualifiers -Wno-missing-braces $(CONFIG_WERROR)
 
 frame-pointer-flag=-f$(if $(KEEP_FRAME_POINTER),no-,)omit-frame-pointer
 fomit_frame_pointer := $(call cc-option, $(frame-pointer-flag), "")
diff --git a/configure b/configure
index c4fb4a2..86c3095 100755
--- a/configure
+++ b/configure
@@ -31,6 +31,13 @@ page_size=
 earlycon=
 efi=
 
+# Enable -Werror by default for git repositories only (i.e. developer builds)
+if [ -e "$srcdir"/.git ]; then
+    werror=-Werror
+else
+    werror=
+fi
+
 usage() {
     cat <<-EOF
 	Usage: $0 [options]
@@ -75,6 +82,8 @@ usage() {
 	                           Specify a PL011 compatible UART at address ADDR. Supported
 	                           register stride is 32 bit only.
 	    --[enable|disable]-efi Boot and run from UEFI (disabled by default, x86_64 only)
+	    --[enable|disable]-werror
+	                           Select whether to compile with the -Werror compiler flag
 EOF
     exit 1
 }
@@ -148,6 +157,12 @@ while [[ "$1" = -* ]]; do
 	--disable-efi)
 	    efi=n
 	    ;;
+	--enable-werror)
+	    werror=-Werror
+	    ;;
+	--disable-werror)
+	    werror=
+	    ;;
 	--help)
 	    usage
 	    ;;
@@ -371,6 +386,7 @@ WA_DIVIDE=$wa_divide
 GENPROTIMG=${GENPROTIMG-genprotimg}
 HOST_KEY_DOCUMENT=$host_key_document
 CONFIG_EFI=$efi
+CONFIG_WERROR=$werror
 GEN_SE_HEADER=$gen_se_header
 EOF
 if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
-- 
2.27.0

