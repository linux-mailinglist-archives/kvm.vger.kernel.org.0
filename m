Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38B441FBEF
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbhJBM4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:56:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36528 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233310AbhJBM4U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:56:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h6tz1pzz/4VduuxUJcTVLKl1Lh7BOZFtJinbrllV/PI=;
        b=IlPgud7CN/KA9MvgNbY6QcMz5e2pN72c5L/kh8qcbWC453AzpXyMQz/YYpPKZ6WfGOb/sb
        jjwfXozqaZDqz7CJgL3IZwgxiJmjSBdnAf4nufTNFxrpRWCqo8gFYT+Wn3cjQ4UvIvagtt
        McFag+hot0WtQg8TJY1VKt8MefAgQLM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-gedc6EmJNqyeMe5lJ9HCQg-1; Sat, 02 Oct 2021 08:54:33 -0400
X-MC-Unique: gedc6EmJNqyeMe5lJ9HCQg-1
Received: by mail-wm1-f72.google.com with SMTP id u3-20020a7bcb03000000b0030d5228cbbdso2089056wmj.3
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:54:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h6tz1pzz/4VduuxUJcTVLKl1Lh7BOZFtJinbrllV/PI=;
        b=UNXWJ9DFizVbso1s6bsGdePalXHpJ3NzQD5nEIPa2SA0vK6U4EUlILpk1y89Mi+dFQ
         kzK2r4SRjZ7RtWd7e+6OxXz5ZQRVo/CHh0ilZC2WyQ2Cgh0Je4wCfH/FMi4Fgz+1Zgj/
         dirT2M8k4hXZpORkGAqkZtcB/uegUmOfK+qT++1Zl0mEKPSpDHUfmDW1+/6L6XfeFbPS
         5PIsUMVawpcBE56BKg166/dXxkVajz4qIX26cQ7cIyBmHBcNx7VCHV4qHU2p9pJFiRy+
         vb8xyue18pc1jDMVAup56tYZe2ios9MylAr++JWFl96VRLlf5fQ7qSDEnYCcB5sX0Obo
         h6UA==
X-Gm-Message-State: AOAM533S+V2ogDzT8aZx8k4FPvPsPclrVW1ITTcZCcxwBEtT6rAG2Js7
        XAuaCBi+z2QQ71pWtoUFK/ldEZdIbgVr5HYKIdtsjg9GAE7SAvyY5s5P4R+zRBcyEFHo9J3lsTQ
        EXlqGWZHQG9SJ
X-Received: by 2002:adf:b311:: with SMTP id j17mr3202013wrd.340.1633179271656;
        Sat, 02 Oct 2021 05:54:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyu9v9AoE33m8O4FuueDOzXS5cpHqzVSB1CjLXdyosJZ9VfYPRTPpP3kB+NiZ18zNjZf4Yvsw==
X-Received: by 2002:adf:b311:: with SMTP id j17mr3201997wrd.340.1633179271459;
        Sat, 02 Oct 2021 05:54:31 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id l25sm8457300wmi.29.2021.10.02.05.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:54:31 -0700 (PDT)
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
Subject: [PATCH v3 16/22] target/i386/sev: Move qmp_query_sev_capabilities() to sev.c
Date:   Sat,  2 Oct 2021 14:53:11 +0200
Message-Id: <20211002125317.3418648-17-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move qmp_query_sev_capabilities() from monitor.c to sev.c
and make sev_get_capabilities() static. We don't need the
stub anymore, remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/sev_i386.h        | 1 -
 target/i386/monitor.c         | 5 -----
 target/i386/sev-sysemu-stub.c | 4 ++--
 target/i386/sev.c             | 8 ++++++--
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
index 5f367f78eb7..8d9388d8c5c 100644
--- a/target/i386/sev_i386.h
+++ b/target/i386/sev_i386.h
@@ -26,7 +26,6 @@
 
 extern SevInfo *sev_get_info(void);
 extern char *sev_get_launch_measurement(void);
-extern SevCapability *sev_get_capabilities(Error **errp);
 
 int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
 int sev_inject_launch_secret(const char *hdr, const char *secret,
diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index 188203da6f2..da36522fa15 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -728,11 +728,6 @@ SevLaunchMeasureInfo *qmp_query_sev_launch_measure(Error **errp)
     return info;
 }
 
-SevCapability *qmp_query_sev_capabilities(Error **errp)
-{
-    return sev_get_capabilities(errp);
-}
-
 SGXInfo *qmp_query_sgx(Error **errp)
 {
     return sgx_get_info(errp);
diff --git a/target/i386/sev-sysemu-stub.c b/target/i386/sev-sysemu-stub.c
index 66b69540aa5..cc486a1afbe 100644
--- a/target/i386/sev-sysemu-stub.c
+++ b/target/i386/sev-sysemu-stub.c
@@ -27,9 +27,9 @@ char *sev_get_launch_measurement(void)
     return NULL;
 }
 
-SevCapability *sev_get_capabilities(Error **errp)
+SevCapability *qmp_query_sev_capabilities(Error **errp)
 {
-    error_setg(errp, "SEV is not available in this QEMU");
+    error_setg(errp, QERR_UNSUPPORTED);
     return NULL;
 }
 
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 2198d550be2..fce007d6749 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -438,8 +438,7 @@ e_free:
     return 1;
 }
 
-SevCapability *
-sev_get_capabilities(Error **errp)
+static SevCapability *sev_get_capabilities(Error **errp)
 {
     SevCapability *cap = NULL;
     guchar *pdh_data = NULL;
@@ -489,6 +488,11 @@ out:
     return cap;
 }
 
+SevCapability *qmp_query_sev_capabilities(Error **errp)
+{
+    return sev_get_capabilities(errp);
+}
+
 static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
                                                         Error **errp)
 {
-- 
2.31.1

