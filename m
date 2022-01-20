Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8C549541C
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 19:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235878AbiATSW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 13:22:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33587 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235665AbiATSW0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 13:22:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642702946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7y6NJoGtooqcN8g/u7U6usfx9aAyW9hJYPPAJu44O+Q=;
        b=A2e5VW5fx7KNEGzCCSk000Y0Kno+tRPbyiU95tk1H3Spl9sP811cKHvUyuiyoECRzE6MKQ
        A3vG+5gRNnmM4s3+ecv65mNStaRYZ+aZlHT+EBubuH8zG1CZol/jQpWbsvy9uyTsLc8MXq
        1x/n4mbrrCeJtCrMgvqvHRn+rV9Db7g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-pNO9dXRaN3-KUyqm0g68eg-1; Thu, 20 Jan 2022 13:22:22 -0500
X-MC-Unique: pNO9dXRaN3-KUyqm0g68eg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF62E8145E3;
        Thu, 20 Jan 2022 18:22:21 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD2637DE4D;
        Thu, 20 Jan 2022 18:22:19 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH] Use a prefix for the STANDALONE environment variable
Date:   Thu, 20 Jan 2022 19:22:00 +0100
Message-Id: <20220120182200.152835-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Seems like "STANDALONE" is too generic and causes a conflict in
certain environments (see bug link below). Add a prefix here to
decrease the possibility of a conflict here.

Resolves: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/issues/3
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arm/run                 | 2 +-
 powerpc/run             | 2 +-
 s390x/run               | 2 +-
 scripts/mkstandalone.sh | 2 +-
 scripts/runtime.bash    | 4 ++--
 x86/run                 | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arm/run b/arm/run
index a390ca5..a94e1c7 100755
--- a/arm/run
+++ b/arm/run
@@ -1,6 +1,6 @@
 #!/usr/bin/env bash
 
-if [ -z "$STANDALONE" ]; then
+if [ -z "$KUT_STANDALONE" ]; then
 	if [ ! -f config.mak ]; then
 		echo "run ./configure && make first. See ./configure -h"
 		exit 2
diff --git a/powerpc/run b/powerpc/run
index 597ab96..ee38e07 100755
--- a/powerpc/run
+++ b/powerpc/run
@@ -1,6 +1,6 @@
 #!/usr/bin/env bash
 
-if [ -z "$STANDALONE" ]; then
+if [ -z "$KUT_STANDALONE" ]; then
 	if [ ! -f config.mak ]; then
 		echo "run ./configure && make first. See ./configure -h"
 		exit 2
diff --git a/s390x/run b/s390x/run
index c615caa..064ecd1 100755
--- a/s390x/run
+++ b/s390x/run
@@ -1,6 +1,6 @@
 #!/usr/bin/env bash
 
-if [ -z "$STANDALONE" ]; then
+if [ -z "$KUT_STANDALONE" ]; then
 	if [ ! -f config.mak ]; then
 		echo "run ./configure && make first. See ./configure -h"
 		exit 2
diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index cefdec3..86c7e54 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -35,7 +35,7 @@ generate_test ()
 	done
 
 	echo "#!/usr/bin/env bash"
-	echo "export STANDALONE=yes"
+	echo "export KUT_STANDALONE=yes"
 	echo "export ENVIRON_DEFAULT=$ENVIRON_DEFAULT"
 	echo "export HOST=\$(uname -m | sed -e 's/i.86/i386/;s/arm.*/arm/;s/ppc64.*/ppc64/')"
 	echo "export PRETTY_PRINT_STACKS=no"
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index c513761..6d5fced 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -36,7 +36,7 @@ get_cmdline()
 skip_nodefault()
 {
     [ "$run_all_tests" = "yes" ] && return 1
-    [ "$STANDALONE" != "yes" ] && return 0
+    [ "$KUT_STANDALONE" != "yes" ] && return 0
 
     while true; do
         read -r -p "Test marked not to be run by default, are you sure (y/N)? " yn
@@ -155,7 +155,7 @@ function run()
     summary=$(eval $cmdline 2> >(RUNTIME_log_stderr $testname) \
                              > >(tee >(RUNTIME_log_stdout $testname $kernel) | extract_summary))
     ret=$?
-    [ "$STANDALONE" != "yes" ] && echo > >(RUNTIME_log_stdout $testname $kernel)
+    [ "$KUT_STANDALONE" != "yes" ] && echo > >(RUNTIME_log_stdout $testname $kernel)
 
     if [ $ret -eq 0 ]; then
         print_result "PASS" $testname "$summary"
diff --git a/x86/run b/x86/run
index ab91753..582d1ed 100755
--- a/x86/run
+++ b/x86/run
@@ -1,6 +1,6 @@
 #!/usr/bin/env bash
 
-if [ -z "$STANDALONE" ]; then
+if [ -z "$KUT_STANDALONE" ]; then
 	if [ ! -f config.mak ]; then
 		echo "run ./configure && make first. See ./configure -h"
 		exit 2
-- 
2.27.0

