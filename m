Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE451CD236
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 09:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgEKHGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 03:06:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57114 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725790AbgEKHGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 03:06:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589180806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+0nK95Gol8cOO8JjWXBWUs+keMg9tHm7nh5wZygjNM4=;
        b=Ckul+kG8BcYwHwzXXJ72IcJxGH+S9pO21pmjXIGJ2ewP0rUOGm1tSjDqICQMTgAqak0Pv4
        +rZfMOLXaMAM3fcur4zaXheaprlTRf0np3IvpDaZzUkxPapQKSErdAkiCf+hbr/TelVjWp
        7hKUJL0/UY6V25+bPsH9bgZyezCc0d4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-yIVPVYrXMm2OrkuQANLqvg-1; Mon, 11 May 2020 03:06:45 -0400
X-MC-Unique: yIVPVYrXMm2OrkuQANLqvg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 342B81895A41
        for <kvm@vger.kernel.org>; Mon, 11 May 2020 07:06:44 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1425D60635;
        Mon, 11 May 2020 07:06:42 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Thomas Huth <thuth@redhat.com>
Subject: [PATCH kvm-unit-tests] Fix out-of-tree builds
Date:   Mon, 11 May 2020 09:06:41 +0200
Message-Id: <20200511070641.23492-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since b16df9ee5f3b out-of-tree builds have been broken because we
started validating the newly user-configurable $erratatxt file
before linking it into the build dir. We fix this not by moving
the validation, but by removing the linking and instead using the
full path of the $erratatxt file. This allows one to keep that file
separate from the src and build dirs.

Fixes: b16df9ee5f3b ("arch-run: Add reserved variables to the default environ")
Reported-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 configure | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/configure b/configure
index 5d2cd90cd180..f9d030fd2f03 100755
--- a/configure
+++ b/configure
@@ -17,7 +17,7 @@ environ_default=yes
 u32_long=
 vmm="qemu"
 errata_force=0
-erratatxt="errata.txt"
+erratatxt="$srcdir/errata.txt"
 
 usage() {
     cat <<-EOF
@@ -89,7 +89,8 @@ while [[ "$1" = -* ]]; do
 	    environ_default=no
 	    ;;
 	--erratatxt)
-	    erratatxt="$arg"
+	    erratatxt=
+	    [ "$arg" ] && erratatxt=$(eval realpath "$arg")
 	    ;;
 	--help)
 	    usage
@@ -169,9 +170,6 @@ if test ! -e Makefile; then
 
     echo "linking scripts..."
     ln -sf "$srcdir/scripts"
-
-    echo "linking errata.txt..."
-    ln -sf "$srcdir/errata.txt"
 fi
 
 # link lib/asm for the architecture
-- 
2.25.4

