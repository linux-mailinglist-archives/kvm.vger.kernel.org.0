Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC6C1D3D67
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 21:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgENT0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 15:26:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31800 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727896AbgENT0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 15:26:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589484406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=/AapBUmkfNYFHQpcUHDMDfwNqslU3LcRYoaC52cFEgg=;
        b=Jhs9V3FP0eGRH48kVcv+Aklzr+MKgZBvDC9xJDVe3A5hroKVduz6ovjU9K2aRxDDZbtelx
        nSWoveVFZaixt6ZFQVB8MuJVQA/8R9yaJsvD3OQvNw7uIPEsZwCIwTxRmSk83pnjibS+9V
        xY9vaTWppYCBJOeJpv8rkanCWgziqis=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-QOHCUL_8M5GjWoMRo-WsxA-1; Thu, 14 May 2020 15:26:44 -0400
X-MC-Unique: QOHCUL_8M5GjWoMRo-WsxA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BC32474;
        Thu, 14 May 2020 19:26:43 +0000 (UTC)
Received: from thuth.com (ovpn-112-56.ams2.redhat.com [10.36.112.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A5925C1BE;
        Thu, 14 May 2020 19:26:41 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Drew Jones <drjones@redhat.com>,
        Bill Wendling <morbo@google.com>
Subject: [kvm-unit-tests PATCH 02/11] Fix out-of-tree builds
Date:   Thu, 14 May 2020 21:26:17 +0200
Message-Id: <20200514192626.9950-3-thuth@redhat.com>
In-Reply-To: <20200514192626.9950-1-thuth@redhat.com>
References: <20200514192626.9950-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Jones <drjones@redhat.com>

Since b16df9ee5f3b out-of-tree builds have been broken because we
started validating the newly user-configurable $erratatxt file
before linking it into the build dir. We fix this not by moving
the validation, but by removing the linking and instead using the
full path of the $erratatxt file. This allows one to keep that file
separate from the src and build dirs.

Fixes: b16df9ee5f3b ("arch-run: Add reserved variables to the default environ")
Reported-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 configure | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/configure b/configure
index 5d2cd90..f9d030f 100755
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
2.18.1

