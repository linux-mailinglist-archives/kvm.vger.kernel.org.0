Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B901425798
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242626AbhJGQTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:19:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30643 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242128AbhJGQTa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:19:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T2ImpqtRm6esWhnoDgzoQLTDZKGPR7WZ/icRmMlGH5o=;
        b=Fo0sdOOcLpO7nqXoseb9+xIKXUtY1sp5KjteTDiIbGUBKi4qdTxOSKiO/gegqgRIWDuCq/
        tQNU20Pdq+UCFMwboWlayzqr5VJ2z5u8ztyIwinYujucaS+4M9j12gWUttaAgL3mZ2v7+c
        KXYXt4+lOCoLmGo7Hd4n5uIF8+GFJE8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-ssN8oO4jNuCDX1iOce13qA-1; Thu, 07 Oct 2021 12:17:29 -0400
X-MC-Unique: ssN8oO4jNuCDX1iOce13qA-1
Received: by mail-wr1-f70.google.com with SMTP id r16-20020adfbb10000000b00160958ed8acso5116096wrg.16
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:17:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T2ImpqtRm6esWhnoDgzoQLTDZKGPR7WZ/icRmMlGH5o=;
        b=EdqWvckvi+9wE9oM1TRBmbnMchixX9E7N20BRGAIeQbUYR85D3FcKR+lZZFVf5nyxw
         bh5L1XpJLsZ6RcK+qnYbpnFv3maiZlpNwtOiL8i/TtRqDMDjSKnQ3f67WoAEANOzRsCJ
         LYEcMClptbUcuslf/M5chfbiLVflBJRE1NzxflM0sFiK40hApkX4Ea6VHjFK5vzmyK3Y
         KKvdbZFlydBUuTEJ+kT+P7OvAHzlmTK/BflC1N0mADbN6RGxiJR3O68V2v+LvV9aNgyh
         DfmEF0EqI+ThCUFovZq5sFnOnfeh/SMHafH9zSw/du937M1PP12QwfYLLLOMwS7L191Y
         kyRg==
X-Gm-Message-State: AOAM530y9ZdeK4QrqwIV0ZN1owDgzC0YsPTHlwaKtBcyUYDjboqIfrHa
        2znphYWhYYZTWUp8TP4901d/mj0iLYbzJLtKlHuu8VLF8PsSvZkPdRoDcUY16iziD3FRV83PnQK
        O7rD+HEF6f7W2
X-Received: by 2002:a05:600c:240a:: with SMTP id 10mr17330244wmp.170.1633623447863;
        Thu, 07 Oct 2021 09:17:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXiHFJgriMo7TGc679FzXDocjunP1esVffm6c4eGKKXk96WSVJZU9pFdlw5+ue8yJioBiocA==
X-Received: by 2002:a05:600c:240a:: with SMTP id 10mr17330219wmp.170.1633623447678;
        Thu, 07 Oct 2021 09:17:27 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id w11sm4476wmc.44.2021.10.07.09.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:17:27 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sergio Lopez <slp@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v4 02/23] qapi/misc-target: Group SEV QAPI definitions
Date:   Thu,  7 Oct 2021 18:16:55 +0200
Message-Id: <20211007161716.453984-3-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is already a section with various SEV commands / types,
so move the SEV guest attestation together.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
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

