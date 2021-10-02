Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE2441FBED
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbhJBM4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:56:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44643 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233277AbhJBM4K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:56:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+4z6jUCebNJqEmNFJ/VStW7BTMEQNitBNtR46XouroI=;
        b=Fgg2WK/FoaEoFd1NraXoeMRhu0Ejvk+ZO18gpE195cVEbiWHmARp3Uq8HKHE8OdlUlC57w
        6f3R+TFJOgDiaojdEuLwOWj8r/n4wsZyI3erDBOB4f4EyFTp4zHiIpvMJnjDqsnlxok1kp
        iLtWb7iQ8gdu/2kxEm+AHe5cXpEK0IU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-0-2DjKR7NgiXWb99ksdMcw-1; Sat, 02 Oct 2021 08:54:23 -0400
X-MC-Unique: 0-2DjKR7NgiXWb99ksdMcw-1
Received: by mail-wm1-f72.google.com with SMTP id z137-20020a1c7e8f000000b0030cd1800d86so6075917wmc.2
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:54:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+4z6jUCebNJqEmNFJ/VStW7BTMEQNitBNtR46XouroI=;
        b=8B5UIoxbBcUtRMQgXDHxIOYPMo+5Vzmsme4c3+HhnYOmYUoS8CtHUSmtItPNkkEBv6
         KSsRnG7dT1MMPr3FdgKtyZyo2ms7ZxpQQ8Cuk1RwuUz1CVaMuyJMliiGIa4ezyXiE9E2
         KfrpveNu/pxF0FG8OWZiYas8c18diEXHgR7MKLi8irr2WcvpJqFrm/gEdCow2ULbKDCm
         1GYQwSGQFI8gRTVdloxavwohZs58sZ5ng2v5jQc+Yw6XhIYfPuJbY1MUbSxq7JxttB/M
         qk+A+UktROFx3IO5h6IyzTg/fe4PYKiMnjXrapXWSlc8yKmW96nQ1YjikLWmyHEibs7o
         oR4Q==
X-Gm-Message-State: AOAM53177WIfTkTNye3Fd5jjtT9BzohJbvZER38zdzVliiyCPjpn+g4I
        0NBNjPaNtwwMr359CXId/vZIEKzvaBJouKYfEI8b20Vxzsgb4a13WLDP5CsR2lYiuOalgDboGAg
        Ak0CObZN68WVe
X-Received: by 2002:a05:6000:2c6:: with SMTP id o6mr3376260wry.292.1633179262576;
        Sat, 02 Oct 2021 05:54:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPg2SUP1KRqKQDM976J1UW+bK/dVfMUDIEqkBzFMQ49KQqAlYHTXe/I8QRvH6n2Zfw+A1FBw==
X-Received: by 2002:a05:6000:2c6:: with SMTP id o6mr3376245wry.292.1633179262453;
        Sat, 02 Oct 2021 05:54:22 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id o19sm9025753wrg.60.2021.10.02.05.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:54:22 -0700 (PDT)
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
Subject: [PATCH v3 14/22] target/i386/sev: Move qmp_query_sev_attestation_report() to sev.c
Date:   Sat,  2 Oct 2021 14:53:09 +0200
Message-Id: <20211002125317.3418648-15-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move qmp_query_sev_attestation_report() from monitor.c to sev.c
and make sev_get_attestation_report() static. We don't need the
stub anymore, remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/sev_i386.h        |  2 --
 target/i386/monitor.c         |  6 ------
 target/i386/sev-sysemu-stub.c |  7 ++++---
 target/i386/sev.c             | 12 ++++++++++--
 4 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
index 2d9a1a0112e..5f367f78eb7 100644
--- a/target/i386/sev_i386.h
+++ b/target/i386/sev_i386.h
@@ -27,8 +27,6 @@
 extern SevInfo *sev_get_info(void);
 extern char *sev_get_launch_measurement(void);
 extern SevCapability *sev_get_capabilities(Error **errp);
-extern SevAttestationReport *
-sev_get_attestation_report(const char *mnonce, Error **errp);
 
 int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
 int sev_inject_launch_secret(const char *hdr, const char *secret,
diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index a9f85acd473..c05d70252a2 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -764,12 +764,6 @@ void qmp_sev_inject_launch_secret(const char *packet_hdr,
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
index d556b4f091f..813b9a6a03b 100644
--- a/target/i386/sev-sysemu-stub.c
+++ b/target/i386/sev-sysemu-stub.c
@@ -13,6 +13,7 @@
 
 #include "qemu/osdep.h"
 #include "qapi/qapi-commands-misc-target.h"
+#include "qapi/qmp/qerror.h"
 #include "qapi/error.h"
 #include "sev_i386.h"
 
@@ -52,9 +53,9 @@ int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size)
     g_assert_not_reached();
 }
 
-SevAttestationReport *sev_get_attestation_report(const char *mnonce,
-                                                 Error **errp)
+SevAttestationReport *qmp_query_sev_attestation_report(const char *mnonce,
+                                                       Error **errp)
 {
-    error_setg(errp, "SEV is not available in this QEMU");
+    error_setg(errp, QERR_UNSUPPORTED);
     return NULL;
 }
diff --git a/target/i386/sev.c b/target/i386/sev.c
index aefbef4bb63..91a217bbb85 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -31,6 +31,8 @@
 #include "migration/blocker.h"
 #include "qom/object.h"
 #include "monitor/monitor.h"
+#include "qapi/qapi-commands-misc-target.h"
+#include "qapi/qmp/qerror.h"
 #include "exec/confidential-guest-support.h"
 #include "hw/i386/pc.h"
 
@@ -487,8 +489,8 @@ out:
     return cap;
 }
 
-SevAttestationReport *
-sev_get_attestation_report(const char *mnonce, Error **errp)
+static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
+                                                        Error **errp)
 {
     struct kvm_sev_attestation_report input = {};
     SevAttestationReport *report = NULL;
@@ -549,6 +551,12 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
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

