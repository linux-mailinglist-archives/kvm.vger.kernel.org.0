Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE55627B3A0
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 19:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgI1RuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 13:50:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50412 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726634AbgI1RuU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 13:50:20 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601315419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=8BnjV1darUb7iNhMu3VTT/BEIzy2CJpD03okKRb3uyY=;
        b=Lek2MRwDuQlr4PW6VuCaK03fyYdIzxSbS5sTiJU695q7WRGFjvc6RI4owoZEVz3nlDlbV1
        Ju5EOkWlJR8fiGnWTvDqfpXAAPKK5ufDLpllBGlj63NNeU+zhnM4KBsaVGX/4q03kLIQc3
        e4yYIocsoaObtqyQjZG7uAvnD9f/dTw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-Ro-a9WNHOnmnWKsUzEYxeA-1; Mon, 28 Sep 2020 13:50:17 -0400
X-MC-Unique: Ro-a9WNHOnmnWKsUzEYxeA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B9A01019629;
        Mon, 28 Sep 2020 17:50:16 +0000 (UTC)
Received: from thuth.com (unknown [10.40.192.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CCF510013C0;
        Mon, 28 Sep 2020 17:50:14 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 07/11] scripts: add support for architecture dependent functions
Date:   Mon, 28 Sep 2020 19:49:54 +0200
Message-Id: <20200928174958.26690-8-thuth@redhat.com>
In-Reply-To: <20200928174958.26690-1-thuth@redhat.com>
References: <20200928174958.26690-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Hartmayer <mhartmay@linux.ibm.com>

This is necessary to keep architecture dependent code separate from
common code.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Message-Id: <20200923134758.19354-3-mhartmay@linux.ibm.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 README.md           | 3 ++-
 scripts/common.bash | 8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/README.md b/README.md
index 48be206..24d4bda 100644
--- a/README.md
+++ b/README.md
@@ -134,7 +134,8 @@ all unit tests.
 ## Directory structure
 
     .:                  configure script, top-level Makefile, and run_tests.sh
-    ./scripts:          helper scripts for building and running tests
+    ./scripts:          general architecture neutral helper scripts for building and running tests
+    ./scripts/<ARCH>:   architecture dependent helper scripts for building and running tests
     ./lib:              general architecture neutral services for the tests
     ./lib/<ARCH>:       architecture dependent services for the tests
     ./<ARCH>:           the sources of the tests and the created objects/images
diff --git a/scripts/common.bash b/scripts/common.bash
index 96655c9..c7acdf1 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -1,3 +1,4 @@
+source config.mak
 
 function for_each_unittest()
 {
@@ -52,3 +53,10 @@ function for_each_unittest()
 	fi
 	exec {fd}<&-
 }
+
+# The current file has to be the only file sourcing the arch helper
+# file
+ARCH_FUNC=scripts/${ARCH}/func.bash
+if [ -f "${ARCH_FUNC}" ]; then
+	source "${ARCH_FUNC}"
+fi
-- 
2.18.2

