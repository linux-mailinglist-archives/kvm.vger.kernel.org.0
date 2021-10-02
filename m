Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0DB41FBE2
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbhJBMzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:55:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43893 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232823AbhJBMzM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:55:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=77XCyInhhDjafl0gvl8ONZ83GvKuNYK6mpZCL7SUumw=;
        b=ep+GH9K8FmZt02QS3Ybf3xdgx+qrha3NQCy9m5GOhjEL/QPgBewm71xRK9unD+H0fb3rkN
        vXq36OZIUau0HH26zkJaFkCjrkVpIkEdLhGJEDMjReiknCeyHbnuLZk7/ZhU0AobvFAO40
        L9KwQTeLGFT/mNmmtQNnhYHkpzf6vsg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-2v0tDAelPDOa0Vb_MDAh-g-1; Sat, 02 Oct 2021 08:53:25 -0400
X-MC-Unique: 2v0tDAelPDOa0Vb_MDAh-g-1
Received: by mail-wm1-f71.google.com with SMTP id o28-20020a05600c511c00b0030cdce826f9so3791338wms.5
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:53:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=77XCyInhhDjafl0gvl8ONZ83GvKuNYK6mpZCL7SUumw=;
        b=KVhamf/ePLXn0sMptacyZlR47sct2YAARZkj7WRVLicFrUKWYeNihAuRXB6f2P2VO7
         0tmrphU6rqlJl+urc1e3Pax7qHOqA8JegqklJ4bbzkLXfIojMKTkgLruA7nqkBZt4j9A
         vXjklQJi3oL9uJe2ZcY+PFquvpXN6yYJMVgiuDnQdfZIEF2g59CSG3l4KtVOCKpcwcVe
         fdLKO2apwptVR5/E3Sr0dhca2OnRYBnPizPQEU70NPQLZ2k9U8r7G26+ETN1dESCM0hC
         1zsc/T2lKQd939LxPNT9ktDzMBm7yZaD00pPkm9VHWA15HLwmzmGu9Rx1h8ZQtfp7clV
         JWHQ==
X-Gm-Message-State: AOAM532AbOl2bdU3kvnQR9CVIMwadHqdbteC4cbK6RaYubm2Sec5xuxQ
        mwrqdgzauzXXcfPKwGezP956UyitQXwiXxf2uQfpkwWus8jz8DcqlK/Ijg3/CEOWh89aiTbB4p7
        xFL5x1zLoN7ht
X-Received: by 2002:a1c:35c7:: with SMTP id c190mr9340536wma.57.1633179204061;
        Sat, 02 Oct 2021 05:53:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1GirbsivBGcc75qonhC/tP/yFG+dbrQslj/ieJQDwUJOIb3YR9xlNe3qi6SdxOBKkUr/2Og==
X-Received: by 2002:a1c:35c7:: with SMTP id c190mr9340526wma.57.1633179203922;
        Sat, 02 Oct 2021 05:53:23 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id c7sm10953748wmq.13.2021.10.02.05.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:53:23 -0700 (PDT)
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
        "Daniel P . Berrange" <berrange@redhat.com>,
        Markus Armbruster <armbru@redhat.com>
Subject: [PATCH v3 01/22] qapi/misc-target: Wrap long 'SEV Attestation Report' long lines
Date:   Sat,  2 Oct 2021 14:52:56 +0200
Message-Id: <20211002125317.3418648-2-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wrap long lines before 70 characters for legibility.

Suggested-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Markus Armbruster <armbru@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 qapi/misc-target.json | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/qapi/misc-target.json b/qapi/misc-target.json
index 594fbd1577f..ae5577e0390 100644
--- a/qapi/misc-target.json
+++ b/qapi/misc-target.json
@@ -300,8 +300,8 @@
 ##
 # @SevAttestationReport:
 #
-# The struct describes attestation report for a Secure Encrypted Virtualization
-# feature.
+# The struct describes attestation report for a Secure Encrypted
+# Virtualization feature.
 #
 # @data:  guest attestation report (base64 encoded)
 #
@@ -315,10 +315,11 @@
 ##
 # @query-sev-attestation-report:
 #
-# This command is used to get the SEV attestation report, and is supported on AMD
-# X86 platforms only.
+# This command is used to get the SEV attestation report, and is
+# supported on AMD X86 platforms only.
 #
-# @mnonce: a random 16 bytes value encoded in base64 (it will be included in report)
+# @mnonce: a random 16 bytes value encoded in base64 (it will be
+#          included in report)
 #
 # Returns: SevAttestationReport objects.
 #
@@ -326,11 +327,13 @@
 #
 # Example:
 #
-# -> { "execute" : "query-sev-attestation-report", "arguments": { "mnonce": "aaaaaaa" } }
+# -> { "execute" : "query-sev-attestation-report",
+#                  "arguments": { "mnonce": "aaaaaaa" } }
 # <- { "return" : { "data": "aaaaaaaabbbddddd"} }
 #
 ##
-{ 'command': 'query-sev-attestation-report', 'data': { 'mnonce': 'str' },
+{ 'command': 'query-sev-attestation-report',
+  'data': { 'mnonce': 'str' },
   'returns': 'SevAttestationReport',
   'if': 'TARGET_I386' }
 
-- 
2.31.1

