Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BA6425A31
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 20:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243420AbhJGSC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 14:02:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57856 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242977AbhJGSCz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 14:02:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633629661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zXfwRbpC9Lbx4LzGOmEzDg8Z5na4+1mXZEo+IH6+b1c=;
        b=N41/85siQ7oTQW6mHPvkzJHmKFZP//YkQkaAWKJVjAJyqdr7QsaZn8TVrwopfiTJeQfl/m
        Mmj4qgQwsmpWh8uq5DMo1exOUnOfaKqVk4yiGlUoeV2AV+OOwlK5HCOIhKZCqj8CxRFmNE
        JJ1ln4DQYoM1tPLAqomaYFmWAsBfMEY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-SRt9qKVaNFyYYc134E-77A-1; Thu, 07 Oct 2021 12:18:50 -0400
X-MC-Unique: SRt9qKVaNFyYYc134E-77A-1
Received: by mail-wr1-f69.google.com with SMTP id r25-20020adfab59000000b001609ddd5579so5119026wrc.21
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:18:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zXfwRbpC9Lbx4LzGOmEzDg8Z5na4+1mXZEo+IH6+b1c=;
        b=OEczn24neYwBQZsKlOhKJ4LYkaMCup/Sidd64BGGObcFFWBAvcnguRAu5LCL1MLG8V
         8Jkj13Q4QJJ1zazk5RiKvxXe0z4K0UGgx1fz9zWzxSKDT92GlOW5VPCIvjxFWp7RQe32
         7DYIiaaY1GicndOMAGFanG495s7PKNIzPkEshQUAhYW2jO3z+sj1yOLbESDKlmKdw3Xo
         cjBJ/R8rGet0bS5Q+VCLHGhujipv2STPa5mRFIKuvaj/vsCxgbLD60t3vND1tcsAOkdr
         FsAwrl/zrRL9PZqKO9MMFasLlRPb1pejMh0TriI1gIB7+lg5+6TIgZcjGsqKhFRFXiwV
         Kaeg==
X-Gm-Message-State: AOAM531+YR1Vu7Eq8Fc9IcfScKxCs0AYpjfkTmH2EU5VNuAaVuenIe2x
        3RIwxWSikBCiKE9SitRhEZw90FIxwu614+eePASRqedcruTBzAQeZGYbFHa2I+q1btPSN+5mv1X
        zcVydgrz2YcWv
X-Received: by 2002:a05:6000:15c9:: with SMTP id y9mr4937131wry.361.1633623529607;
        Thu, 07 Oct 2021 09:18:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVZkZLJExUdIkU8eUXntS+EbMqWJ8pnYgvB7GErpwpgWp6MdaxC3o/caLpYVSADf5LX9m6nw==
X-Received: by 2002:a05:6000:15c9:: with SMTP id y9mr4937095wry.361.1633623529405;
        Thu, 07 Oct 2021 09:18:49 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id w1sm60022wre.79.2021.10.07.09.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:18:49 -0700 (PDT)
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
Subject: [PATCH v4 20/23] target/i386/sev: Move qmp_query_sev_launch_measure() to sev.c
Date:   Thu,  7 Oct 2021 18:17:13 +0200
Message-Id: <20211007161716.453984-21-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move qmp_query_sev_launch_measure() from monitor.c to sev.c
and make sev_get_launch_measurement() static. We don't need the
stub anymore, remove it.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/sev.h             |  1 -
 target/i386/monitor.c         | 17 -----------------
 target/i386/sev-sysemu-stub.c |  3 ++-
 target/i386/sev.c             | 20 ++++++++++++++++++--
 4 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/target/i386/sev.h b/target/i386/sev.h
index b70b7b56cb8..dda350779f9 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -50,7 +50,6 @@ bool sev_es_enabled(void);
 extern SevInfo *sev_get_info(void);
 extern uint32_t sev_get_cbit_position(void);
 extern uint32_t sev_get_reduced_phys_bits(void);
-extern char *sev_get_launch_measurement(void);
 extern bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp);
 
 int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index 4c017b59b3a..bd24d0d4737 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -710,23 +710,6 @@ void hmp_info_sev(Monitor *mon, const QDict *qdict)
     qapi_free_SevInfo(info);
 }
 
-SevLaunchMeasureInfo *qmp_query_sev_launch_measure(Error **errp)
-{
-    char *data;
-    SevLaunchMeasureInfo *info;
-
-    data = sev_get_launch_measurement();
-    if (!data) {
-        error_setg(errp, "SEV launch measurement is not available");
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
index 3e8cab4c144..8d97d7c7e14 100644
--- a/target/i386/sev-sysemu-stub.c
+++ b/target/i386/sev-sysemu-stub.c
@@ -22,8 +22,9 @@ SevInfo *sev_get_info(void)
     return NULL;
 }
 
-char *sev_get_launch_measurement(void)
+SevLaunchMeasureInfo *qmp_query_sev_launch_measure(Error **errp)
 {
+    error_setg(errp, "SEV is not available in this QEMU");
     return NULL;
 }
 
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 56e9e03accd..ec874b3df82 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -742,8 +742,7 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
     trace_kvm_sev_launch_measurement(sev->measurement);
 }
 
-char *
-sev_get_launch_measurement(void)
+static char *sev_get_launch_measurement(void)
 {
     if (sev_guest &&
         sev_guest->state >= SEV_STATE_LAUNCH_SECRET) {
@@ -753,6 +752,23 @@ sev_get_launch_measurement(void)
     return NULL;
 }
 
+SevLaunchMeasureInfo *qmp_query_sev_launch_measure(Error **errp)
+{
+    char *data;
+    SevLaunchMeasureInfo *info;
+
+    data = sev_get_launch_measurement();
+    if (!data) {
+        error_setg(errp, "SEV launch measurement is not available");
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

