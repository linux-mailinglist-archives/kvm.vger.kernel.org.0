Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26E4419E63C
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 17:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgDDPr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 11:47:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57767 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726329AbgDDPr5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 11:47:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586015276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hc0ATzQRfDGrFB2aZgQVM0YGCpEn5ly4cdQsXubFPbM=;
        b=TspuViTHBuQTJqccGJM7Dk55yc37HGEpG14DNWiigunJ7pONZ2ge51JlWEY1D4+pKEX8QD
        PSLMkrnfCXq0n7V+/aiiziQJzEg6A5l0aegNVAYBUDlxuMUtGh78dgDzznYxjdYZxsKeZT
        GtwzN0e1b/CYrNCLoZ7UtnlZ/gUPMuI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-FnusDUZNN1K7ay1n51bIrA-1; Sat, 04 Apr 2020 11:47:54 -0400
X-MC-Unique: FnusDUZNN1K7ay1n51bIrA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24C6018A6EC8;
        Sat,  4 Apr 2020 15:47:53 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA0645E000;
        Sat,  4 Apr 2020 15:47:50 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     lvivier@redhat.com, thuth@redhat.com, david@redhat.com,
        frankja@linux.ibm.com, pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests 2/2] runtime: Always honor the unittests.cfg accel requirement
Date:   Sat,  4 Apr 2020 17:47:39 +0200
Message-Id: <20200404154739.217584-3-drjones@redhat.com>
In-Reply-To: <20200404154739.217584-1-drjones@redhat.com>
References: <20200404154739.217584-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the unittests.cfg file specifies an accel parameter then don't
let the user override it.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 scripts/runtime.bash | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index eb6089091e23..8bfe31cb9f66 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -77,7 +77,7 @@ function run()
     local opts=3D"$5"
     local arch=3D"$6"
     local check=3D"${CHECK:-$7}"
-    local accel=3D"${ACCEL:-$8}"
+    local accel=3D"$8"
     local timeout=3D"${9:-$TIMEOUT}" # unittests.cfg overrides the defau=
lt
=20
     if [ -z "$testname" ]; then
@@ -103,6 +103,13 @@ function run()
         return 2
     fi
=20
+    if [ -n "$accel" ] && [ -n "$ACCEL" ] && [ "$accel" !=3D "$ACCEL" ];=
 then
+        print_result "SKIP" $testname "" "$accel only, but ACCEL=3D$ACCE=
L"
+        return 2
+    elif [ -n "$ACCEL" ]; then
+        accel=3D"$ACCEL"
+    fi
+
     # check a file for a particular value before running a test
     # the check line can contain multiple files to check separated by a =
space
     # but each check parameter needs to be of the form <path>=3D<value>
--=20
2.25.1

