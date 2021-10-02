Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4001841FBE3
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbhJBMz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:55:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56436 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233221AbhJBMzS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:55:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uxFjxneImH8t+TNgA6RwI5GC/nMw3TKiWJEHDqKeLyw=;
        b=GIsxXQila3coD21BAwndch1qqhN/M0u+nhmt0O57/tu1WDWo5q1FLnWcoHiW124u5X/3ip
        EJvJgowgtrTnDNArxVBMetVuZzXodbE6TVqqcXFbuRxuzxtnWEOJfO26BujravVvVuGSij
        yYDx3KveYxw4LqSjdmi1i8NsgYCgSsw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-DjzxvCjpPzGrjBYVOTsCFA-1; Sat, 02 Oct 2021 08:53:29 -0400
X-MC-Unique: DjzxvCjpPzGrjBYVOTsCFA-1
Received: by mail-wm1-f71.google.com with SMTP id r66-20020a1c4445000000b0030cf0c97157so6084604wma.1
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:53:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uxFjxneImH8t+TNgA6RwI5GC/nMw3TKiWJEHDqKeLyw=;
        b=h2DcSgLh0Y0AgOKzjJqGB17Yfi5pgsg9DRniqqFRAGgjx/QQSvQ+ReC04XqHSvl/Io
         2+1OtrQlYJUlW0xglztG8YUhyDzXOSLDi963l8iOWlbZZBRa4fHUZvSTJV9zXH9MlGDq
         tqVAezxv2lf2yn+mLtE8ATd8ts4X/pkho5Wx6ILeA/bU9XJsk/V2CZXFymiqilihEI4t
         G9ayFl6VJhItXasDOtf+MUR6zNH9hTaY8FX9jQ9RZvT3HbbbJ5lqyOwrbY20tTaDy4eA
         xRgAc39Rs/nGVV4vxGgoNgne5JHKhYRaEnFlkT0iTCSDR7pMM1msmCozqeSkPGu0woRd
         ofpw==
X-Gm-Message-State: AOAM530CcdNKrCgxccCs19A5KlxDrtzzB+ym+IFxynR3S3flf2o/44Oq
        s1JuEZBTOg+6o+W6jeykbwqoZXHm//wDPQBgo/4DB4NN6kukGK/fM9hlc2mPTWfU7gsvSazLwm1
        t7+tKXqyZplOY
X-Received: by 2002:a5d:6da9:: with SMTP id u9mr3290600wrs.58.1633179208583;
        Sat, 02 Oct 2021 05:53:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzDVSNYXZrFwgHN4o6mFCnb6T1FU6BIRdNia2pWh+N6e4sjnaGfMzRIY8qxl27Xi1WFkhgpNw==
X-Received: by 2002:a5d:6da9:: with SMTP id u9mr3290585wrs.58.1633179208431;
        Sat, 02 Oct 2021 05:53:28 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id 61sm8574908wrl.94.2021.10.02.05.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:53:28 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Sergio Lopez <slp@redhat.com>, kvm@vger.kernel.org,
        James Bottomley <jejb@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Daniel P . Berrange" <berrange@redhat.com>
Subject: [PATCH v3 02/22] qapi/misc-target: Group SEV QAPI definitions
Date:   Sat,  2 Oct 2021 14:52:57 +0200
Message-Id: <20211002125317.3418648-3-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is already a section with various SEV commands / types,
so move the SEV guest attestation together.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 qapi/misc-target.json | 80 +++++++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/qapi/misc-target.json b/qapi/misc-target.json
index ae5577e0390..5aa2b95b7d4 100644
--- a/qapi/misc-target.json
+++ b/qapi/misc-target.json
@@ -229,6 +229,46 @@
   'data': { 'packet-header': 'str', 'secret': 'str', '*gpa': 'uint64' },
   'if': 'TARGET_I386' }
 
+##
+# @SevAttestationReport:
+#
+# The struct describes attestation report for a Secure Encrypted
+# Virtualization feature.
+#
+# @data:  guest attestation report (base64 encoded)
+#
+#
+# Since: 6.1
+##
+{ 'struct': 'SevAttestationReport',
+  'data': { 'data': 'str'},
+  'if': 'TARGET_I386' }
+
+##
+# @query-sev-attestation-report:
+#
+# This command is used to get the SEV attestation report, and is
+# supported on AMD X86 platforms only.
+#
+# @mnonce: a random 16 bytes value encoded in base64 (it will be
+#          included in report)
+#
+# Returns: SevAttestationReport objects.
+#
+# Since: 6.1
+#
+# Example:
+#
+# -> { "execute" : "query-sev-attestation-report",
+#                  "arguments": { "mnonce": "aaaaaaa" } }
+# <- { "return" : { "data": "aaaaaaaabbbddddd"} }
+#
+##
+{ 'command': 'query-sev-attestation-report',
+  'data': { 'mnonce': 'str' },
+  'returns': 'SevAttestationReport',
+  'if': 'TARGET_I386' }
+
 ##
 # @dump-skeys:
 #
@@ -297,46 +337,6 @@
   'if': 'TARGET_ARM' }
 
 
-##
-# @SevAttestationReport:
-#
-# The struct describes attestation report for a Secure Encrypted
-# Virtualization feature.
-#
-# @data:  guest attestation report (base64 encoded)
-#
-#
-# Since: 6.1
-##
-{ 'struct': 'SevAttestationReport',
-  'data': { 'data': 'str'},
-  'if': 'TARGET_I386' }
-
-##
-# @query-sev-attestation-report:
-#
-# This command is used to get the SEV attestation report, and is
-# supported on AMD X86 platforms only.
-#
-# @mnonce: a random 16 bytes value encoded in base64 (it will be
-#          included in report)
-#
-# Returns: SevAttestationReport objects.
-#
-# Since: 6.1
-#
-# Example:
-#
-# -> { "execute" : "query-sev-attestation-report",
-#                  "arguments": { "mnonce": "aaaaaaa" } }
-# <- { "return" : { "data": "aaaaaaaabbbddddd"} }
-#
-##
-{ 'command': 'query-sev-attestation-report',
-  'data': { 'mnonce': 'str' },
-  'returns': 'SevAttestationReport',
-  'if': 'TARGET_I386' }
-
 ##
 # @SGXInfo:
 #
-- 
2.31.1

