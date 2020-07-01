Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AA1210668
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 10:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgGAIiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 04:38:00 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25782 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726670AbgGAIiA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Jul 2020 04:38:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593592679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=QahaNqoJpNuE2oXc7Lbni+jgHUbCC+VzOS4RvDj9bVU=;
        b=D9LSLefOI98MKj02ej8i6tuQ2hulqH44JmY/IcNAy9eMbvVgw9cfQXrJSUQhrXs1DTG4F7
        DrI5NPG975bJd2/qFxY6rFpudI/FuYibKmm4fg8mWxryuuEbsv5gI59TvckS1QFFdTGpD8
        hOSYzb47ev+hpd0fIYt2GAqDEUXQggE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-ybOFw22LP5SCzkSRCEONrA-1; Wed, 01 Jul 2020 04:37:57 -0400
X-MC-Unique: ybOFw22LP5SCzkSRCEONrA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AA341902EA1
        for <kvm@vger.kernel.org>; Wed,  1 Jul 2020 08:37:57 +0000 (UTC)
Received: from thuth.com (ovpn-114-45.ams2.redhat.com [10.36.114.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01CC68ACE9;
        Wed,  1 Jul 2020 08:37:55 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Drew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH] scripts: Fix the check whether testname is in the only_tests list
Date:   Wed,  1 Jul 2020 10:37:53 +0200
Message-Id: <20200701083753.31366-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When you currently run

 ./run_tests.sh ioapic-split

the kvm-unit-tests run scripts do not only execute the "ioapic-split"
test, but also the "ioapic" test, which is quite surprising. This
happens because we use "grep -w" for checking whether a test should
be run or not - and "grep -w" does not consider the "-" character as
part of a word.

To fix the issue, convert the dash into an underscore character before
running "grep -w".

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 scripts/runtime.bash | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 8bfe31c..03fd20a 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -84,7 +84,8 @@ function run()
         return
     fi
 
-    if [ -n "$only_tests" ] && ! grep -qw "$testname" <<<$only_tests; then
+    if [ -n "$only_tests" ] && ! sed s/-/_/ <<<$only_tests \
+                               | grep -qw $(sed s/-/_/ <<< "$testname") ; then
         return
     fi
 
-- 
2.18.1

