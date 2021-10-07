Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C5A4257AA
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242685AbhJGQUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:20:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28299 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242622AbhJGQUe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:20:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7zEBwyEs4hdAqxlobZpOUbNIVzNsUZbf4HLNIwXUpoo=;
        b=Wivp1fFJn+8S3fqq2uX5M23gbAtZ1WjawqVs1gdNZFkAKLyQScrirVE3xy27lAf1TQrS9A
        XQ4ohvLi4WC5fRlUL24fqQXJ4NC4ZZ/37ZW7g1tEfaq0SlBWFiQvGVYN2horoOIWOxwh02
        qdrBaW1lxSa7h1vDB0FZRpMn2StCO6A=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-XPTBNYhFNneoXARTTxHp_w-1; Thu, 07 Oct 2021 12:18:37 -0400
X-MC-Unique: XPTBNYhFNneoXARTTxHp_w-1
Received: by mail-wr1-f70.google.com with SMTP id c2-20020adfa302000000b0015e4260febdso5100363wrb.20
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:18:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7zEBwyEs4hdAqxlobZpOUbNIVzNsUZbf4HLNIwXUpoo=;
        b=6Knj1yRJPkmIKtZOV0XYpgQtSOUX2ZDVuLD2IIOlbJYowBcsgM8LftFXE9Y3fr2HXT
         a4/GT0j3YPvreLsy/8LIcncrw5yl68RmJd17p4U/C5ylej0XqMYZfjQmKSq/8jXS4JrM
         usvm4TlFH/MnSUkc8gfITtiFLSWWNccnzalSuXzLuGqMEiQdf+CoACKx39G4/R8e3Suo
         8HU9s2FDMI+l6FufSWgyEQ+nbcHa1FwNxryll6oRzXMQnGquX66k3woCsa1PrYs7amhR
         kZ9auDwBCJUbzRQQvWKlFiWcx4MxJNr8duc5BpoYfbNp4GYe/Ih0ghnxpw2S4MnLk8g9
         7/pg==
X-Gm-Message-State: AOAM531wR9GYF4cf1wWV32icEvb4YmJ0ykIKZp/Ol5VUcoexr1RorsvA
        8tlUZzhbVDWR6hhg1QY2ICDPb2xjuB22+26TpBUGtemvlzmveRQKWtuCqbjJnptEzFfNrrBGMxO
        MIsPv15Bkv46R
X-Received: by 2002:a1c:1b4a:: with SMTP id b71mr5629397wmb.33.1633623516166;
        Thu, 07 Oct 2021 09:18:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRFIgrsHBHYJZN3sLOY8LrmO2MjqtYTxSRTA/ArKRINNK0kYWiSnReEM//lqCoEZRskTcw5A==
X-Received: by 2002:a1c:1b4a:: with SMTP id b71mr5629375wmb.33.1633623515998;
        Thu, 07 Oct 2021 09:18:35 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id k18sm48278wrn.81.2021.10.07.09.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:18:35 -0700 (PDT)
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
Subject: [PATCH v4 17/23] target/i386/sev: Move qmp_query_sev_attestation_report() to sev.c
Date:   Thu,  7 Oct 2021 18:17:10 +0200
Message-Id: <20211007161716.453984-18-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move qmp_query_sev_attestation_report() from monitor.c to sev.c
and make sev_get_attestation_report() static. We don't need the
stub anymore, remove it.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/sev.h             |  2 --
 target/i386/monitor.c         |  6 ------
 target/i386/sev-sysemu-stub.c |  5 +++--
 target/i386/sev.c             | 12 ++++++++++--
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/target/i386/sev.h b/target/i386/sev.h
index d9548e3e642..2e90c05fc3f 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -52,8 +52,6 @@ extern uint32_t sev_get_cbit_position(void);
 extern uint32_t sev_get_reduced_phys_bits(void);
 extern char *sev_get_launch_measurement(void);
 extern SevCapability *sev_get_capabilities(Error **errp);
-extern SevAttestationReport *
-sev_get_attestation_report(const char *mnonce, Error **errp);
 extern bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp);
 
 int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index 935a8ee8ca4..cf4a8a61a02 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -763,12 +763,6 @@ void qmp_sev_inject_launch_secret(const char *packet_hdr,
     sev_inject_launch_secret(packet_hdr, secret, gpa, errp);
 }
 
-SevAttestationReport *
-qmp_query_sev_attestation_report(const char *mnonce, Error **errp)
-{
-    return sev_get_attestation_report(mnonce, errp);
-}
-
 SGXInfo *qmp_query_sgx(Error **errp)
 {
     return sgx_get_info(errp);
diff --git a/target/i386/sev-sysemu-stub.c b/target/i386/sev-sysemu-stub.c
index 8082781febf..d5ec6b32e0a 100644
--- a/target/i386/sev-sysemu-stub.c
+++ b/target/i386/sev-sysemu-stub.c
@@ -13,6 +13,7 @@
 
 #include "qemu/osdep.h"
 #include "qapi/qapi-commands-misc-target.h"
+#include "qapi/qmp/qerror.h"
 #include "qapi/error.h"
 #include "sev.h"
 
@@ -52,8 +53,8 @@ int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size)
     g_assert_not_reached();
 }
 
-SevAttestationReport *sev_get_attestation_report(const char *mnonce,
-                                                 Error **errp)
+SevAttestationReport *qmp_query_sev_attestation_report(const char *mnonce,
+                                                       Error **errp)
 {
     error_setg(errp, "SEV is not available in this QEMU");
     return NULL;
diff --git a/target/i386/sev.c b/target/i386/sev.c
index e43bbf3a17d..038fa560588 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -32,6 +32,8 @@
 #include "migration/blocker.h"
 #include "qom/object.h"
 #include "monitor/monitor.h"
+#include "qapi/qapi-commands-misc-target.h"
+#include "qapi/qmp/qerror.h"
 #include "exec/confidential-guest-support.h"
 #include "hw/i386/pc.h"
 
@@ -515,8 +517,8 @@ out:
     return cap;
 }
 
-SevAttestationReport *
-sev_get_attestation_report(const char *mnonce, Error **errp)
+static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
+                                                        Error **errp)
 {
     struct kvm_sev_attestation_report input = {};
     SevAttestationReport *report = NULL;
@@ -578,6 +580,12 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
     return report;
 }
 
+SevAttestationReport *qmp_query_sev_attestation_report(const char *mnonce,
+                                                       Error **errp)
+{
+    return sev_get_attestation_report(mnonce, errp);
+}
+
 static int
 sev_read_file_base64(const char *filename, guchar **data, gsize *len)
 {
-- 
2.31.1

