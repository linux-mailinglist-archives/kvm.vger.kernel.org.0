Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBB841FBF0
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbhJBM42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:56:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38945 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233310AbhJBM4Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:56:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0nKTjzIKPyPIMBpHVM/tD1diKI5Lwbe51EbfE5s5an0=;
        b=D8Qn+KgffYy5o7SjXAfU6hwJce5qS9uGRGHo/Y09Gl20tbCOW32GfGVu9Pp4Ath0RJYGBK
        SF8SoHev4t28BRtLG7MMajx3oeZFPZHeRV/IM03+F9qAu8x7LxkXhKBW/eVH+SjNpzxDtM
        DsFRQU5wbZAlxoS5XKgfLDXi7KqCoqs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-I-8dPZgGMiulp_dzpvWiQA-1; Sat, 02 Oct 2021 08:54:37 -0400
X-MC-Unique: I-8dPZgGMiulp_dzpvWiQA-1
Received: by mail-wm1-f71.google.com with SMTP id 129-20020a1c1987000000b0030cd1616fbfso7350179wmz.3
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:54:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0nKTjzIKPyPIMBpHVM/tD1diKI5Lwbe51EbfE5s5an0=;
        b=po6qOw6CxtLGprKRl1zLF7+6FHhTTOtXT/2c6hKjD+7sRPapNwLYrKNBEC2fBcHAmw
         angRBDdBi1H8bV33yCmsrAfOoExPVco2GJX4erJrgyNz7iHpurCD5mqPnYjXrJZb87ZC
         OZa+v0ZENDx7PcTl8RiwSD8VtsrJBMNlRO+Rg1ozpvMN8FxKiOSpjkGh5SkFhvLw5a4A
         rN9QqlJzkx6IrdnUpv4HE1bxUx+/A9OW6icn04+kFCz5zJl/Zk0E+DY917sT8gEneDFt
         wuYg+P6UPzU6lspdaJqsrNMtbx8mFP2G6RbaPsj6/S+S+RbPWC+sWuoJ0w2AyHVaEeDf
         vvzg==
X-Gm-Message-State: AOAM531b0XW8lgwbSoAR5EIdfpFOe8l9aqJ4LYjVA53mSw2949Oxhs/+
        QnX4BUgj8FXF00HJ8cmOdlXfbsA0wxxA3azcmEXAYcvsFy9nq4h/3OVEV2CFMInmjB7C/qLamhI
        J8O7ni0ETEydD
X-Received: by 2002:adf:a4cf:: with SMTP id h15mr3355712wrb.56.1633179276024;
        Sat, 02 Oct 2021 05:54:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyE7Ld4d7xRxNwNhximLYRSqvfEbRdkNWVwkt+fYHrToiPZNRg70XquUCHdmcVJ53wdpAfvzQ==
X-Received: by 2002:adf:a4cf:: with SMTP id h15mr3355700wrb.56.1633179275866;
        Sat, 02 Oct 2021 05:54:35 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id y15sm1796812wrp.44.2021.10.02.05.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:54:35 -0700 (PDT)
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
Subject: [PATCH v3 17/22] target/i386/sev: Move qmp_query_sev_launch_measure() to sev.c
Date:   Sat,  2 Oct 2021 14:53:12 +0200
Message-Id: <20211002125317.3418648-18-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move qmp_query_sev_launch_measure() from monitor.c to sev.c
and make sev_get_launch_measurement() static. We don't need the
stub anymore, remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/sev_i386.h        |  1 -
 target/i386/monitor.c         | 17 -----------------
 target/i386/sev-sysemu-stub.c |  3 ++-
 target/i386/sev.c             | 20 ++++++++++++++++++--
 4 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
index 8d9388d8c5c..1699376ad87 100644
--- a/target/i386/sev_i386.h
+++ b/target/i386/sev_i386.h
@@ -25,7 +25,6 @@
 #define SEV_POLICY_SEV          0x20
 
 extern SevInfo *sev_get_info(void);
-extern char *sev_get_launch_measurement(void);
 
 int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
 int sev_inject_launch_secret(const char *hdr, const char *secret,
diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index da36522fa15..0b38e970c73 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -711,23 +711,6 @@ void hmp_info_sev(Monitor *mon, const QDict *qdict)
     qapi_free_SevInfo(info);
 }
 
-SevLaunchMeasureInfo *qmp_query_sev_launch_measure(Error **errp)
-{
-    char *data;
-    SevLaunchMeasureInfo *info;
-
-    data = sev_get_launch_measurement();
-    if (!data) {
-        error_setg(errp, "Measurement is not available");
-        return NULL;
-    }
-
-    info = g_malloc0(sizeof(*info));
-    info->data = data;
-
-    return info;
-}
-
 SGXInfo *qmp_query_sgx(Error **errp)
 {
     return sgx_get_info(errp);
diff --git a/target/i386/sev-sysemu-stub.c b/target/i386/sev-sysemu-stub.c
index cc486a1afbe..355391c16c4 100644
--- a/target/i386/sev-sysemu-stub.c
+++ b/target/i386/sev-sysemu-stub.c
@@ -22,8 +22,9 @@ SevInfo *sev_get_info(void)
     return NULL;
 }
 
-char *sev_get_launch_measurement(void)
+SevLaunchMeasureInfo *qmp_query_sev_launch_measure(Error **errp)
 {
+    error_setg(errp, QERR_UNSUPPORTED);
     return NULL;
 }
 
diff --git a/target/i386/sev.c b/target/i386/sev.c
index fce007d6749..8e9cce62196 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -718,8 +718,7 @@ free_measurement:
     g_free(measurement);
 }
 
-char *
-sev_get_launch_measurement(void)
+static char *sev_get_launch_measurement(void)
 {
     if (sev_guest &&
         sev_guest->state >= SEV_STATE_LAUNCH_SECRET) {
@@ -729,6 +728,23 @@ sev_get_launch_measurement(void)
     return NULL;
 }
 
+SevLaunchMeasureInfo *qmp_query_sev_launch_measure(Error **errp)
+{
+    char *data;
+    SevLaunchMeasureInfo *info;
+
+    data = sev_get_launch_measurement();
+    if (!data) {
+        error_setg(errp, "Measurement is not available");
+        return NULL;
+    }
+
+    info = g_malloc0(sizeof(*info));
+    info->data = data;
+
+    return info;
+}
+
 static Notifier sev_machine_done_notify = {
     .notify = sev_launch_get_measure,
 };
-- 
2.31.1

