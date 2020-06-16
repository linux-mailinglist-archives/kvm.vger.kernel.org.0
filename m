Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143291FBE93
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 20:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbgFPS4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 14:56:33 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20072 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729994AbgFPS4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 14:56:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592333790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=QG4GcvBqyaMGQs6iL8I7UP/KbYkVhSk8WJz8geiWD8w=;
        b=Wn8VUZkRFImC8nVawRnoHcsIbEG8eKAIHOaCYF5Y7YGq+TjkupwrOPShnJEJzdmsrkfYO0
        kA4VRp0fhd2EFC2n0kilqv2jspVCsdXGQ3CBvRa2pzzLhej7dD4zfp2Vdq8CyBTNi/ENOj
        CFtinjcypHtPSpRpF0wdyrMSr2ywRlg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-YCtvSGvoOJyIIn9s_dqwXQ-1; Tue, 16 Jun 2020 14:56:28 -0400
X-MC-Unique: YCtvSGvoOJyIIn9s_dqwXQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D55CB80F5EA
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 18:56:26 +0000 (UTC)
Received: from thuth.com (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CAB207CAA8;
        Tue, 16 Jun 2020 18:56:25 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PULL 01/12] Fix out-of-tree builds
Date:   Tue, 16 Jun 2020 20:56:11 +0200
Message-Id: <20200616185622.8644-2-thuth@redhat.com>
In-Reply-To: <20200616185622.8644-1-thuth@redhat.com>
References: <20200616185622.8644-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
Message-Id: <20200511070641.23492-1-drjones@redhat.com>
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

