Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0627D7B52
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 05:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjJZDlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 23:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjJZDlm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 23:41:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14ECC189
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 20:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698291654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lhkxc6ETah/XZ32WLeYNVGRCbB3KV39jeRBoHfU3kg4=;
        b=Fx2lfsVk7aqA85MY7FRScXkuPrGzpqr6HcP5Y7KhHnWKh6XBNciAQRVKcIIo1xyTs3AJKh
        TvISBXV3feZNPKV2m9UKTKjo4BZF3KvIVEF7YT26zGeVbh4x/XIfL0QtAvFnEdEyDuOFy9
        lspwaUiIWK+dliHpP4LE/BpUvYG1ojE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-J43d35xXNTOFhmOY9ni3Vw-1; Wed, 25 Oct 2023 23:40:48 -0400
X-MC-Unique: J43d35xXNTOFhmOY9ni3Vw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A36B9802891;
        Thu, 26 Oct 2023 03:40:47 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 91EB0502A;
        Thu, 26 Oct 2023 03:40:47 +0000 (UTC)
From:   Shaoqin Huang <shahuang@redhat.com>
To:     andrew.jones@linux.dev, kvmarm@lists.linux.dev
Cc:     Shaoqin Huang <shahuang@redhat.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Ricardo Koller <ricarkol@google.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1] configure: arm64: Add support for dirty-ring in migration
Date:   Wed, 25 Oct 2023 23:40:42 -0400
Message-Id: <20231026034042.812006-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new configure option "--dirty-ring-size" to support dirty-ring
migration on arm64. By default, the dirty-ring is disabled, we can
enable it by:

  # ./configure --dirty-ring-size=65536

This will generate one more entry in config.mak, it will look like:

  # cat config.mak
    :
  ACCEL=kvm,dirty-ring-size=65536

With this configure option, user can easy enable dirty-ring and specify
dirty-ring-size to test the dirty-ring in migration.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 configure | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/configure b/configure
index 6ee9b27..54ce38a 100755
--- a/configure
+++ b/configure
@@ -32,6 +32,7 @@ enable_dump=no
 page_size=
 earlycon=
 efi=
+dirty_ring_size=
 
 # Enable -Werror by default for git repositories only (i.e. developer builds)
 if [ -e "$srcdir"/.git ]; then
@@ -89,6 +90,9 @@ usage() {
 	    --[enable|disable]-efi Boot and run from UEFI (disabled by default, x86_64 and arm64 only)
 	    --[enable|disable]-werror
 	                           Select whether to compile with the -Werror compiler flag
+	    --dirty-ring-size=SIZE
+                             Specify the dirty-ring size and enable dirty-ring for
+                             migration(disable dirty-ring by default, arm64 only)
 EOF
     exit 1
 }
@@ -174,6 +178,9 @@ while [[ "$1" = -* ]]; do
 	--disable-werror)
 	    werror=
 	    ;;
+	--dirty-ring-size)
+	    dirty_ring_size="$arg"
+	    ;;
 	--help)
 	    usage
 	    ;;
@@ -213,6 +220,27 @@ if [ "$efi" ] && [ "$arch" != "x86_64" ] && [ "$arch" != "arm64" ]; then
     usage
 fi
 
+if [ "$dirty_ring_size" ]; then
+    if [ "$arch" != "arm64" ]; then
+        echo "--dirty-ring-size is not supported for $arch"
+        usage
+    fi
+    _size=$dirty_ring_size
+    if [ ! "${_size//[0-9]}" ]; then
+        if (( _size < 1024 )); then
+            echo "--dirty-ring-size suggest minimum value is 1024"
+            usage
+        fi
+        if (( _size & (_size - 1) )); then
+            echo "--dirty-ring-size must be a power of two"
+            usage
+        fi
+    else
+        echo "--dirty-ring-size must be positive number and a power of two"
+        usage
+    fi
+fi
+
 if [ -z "$page_size" ]; then
     if [ "$efi" = 'y' ] && [ "$arch" = "arm64" ]; then
         page_size="4096"
@@ -419,6 +447,9 @@ EOF
 if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     echo "TARGET=$target" >> config.mak
 fi
+if [ "$arch" = "arm64" ] && [ "$dirty_ring_size" ]; then
+    echo "ACCEL=kvm,dirty-ring-size=$dirty_ring_size" >> config.mak
+fi
 
 cat <<EOF > lib/config.h
 #ifndef _CONFIG_H_
-- 
2.40.1

