Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF2E41FBE9
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbhJBMzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:55:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22397 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233288AbhJBMzy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:55:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tAj3BwaM+hRNB5Zlp17fWtjr58QjWY/+pHTXgMu/M3k=;
        b=Xc5pHhUzkq40srIW+Dh50j/7Eah9eYKTgMxn+lcngBQH/yn/qf0X6tK0fZ10QkGbjc5PEg
        +ajB5iRNq3zSB/zVy6RovzxICEHs/GJsnnJCdP+MnSLjmYgYFGLF9950wB1zo1412AcU/B
        j8aR0e4pbD9N1jkhow4lJsfatglj1Yk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-SpmNsjGxNs6F3DXUGlalwA-1; Sat, 02 Oct 2021 08:54:05 -0400
X-MC-Unique: SpmNsjGxNs6F3DXUGlalwA-1
Received: by mail-wm1-f72.google.com with SMTP id v5-20020a1cac05000000b0030b85d2d479so6060661wme.9
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:54:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tAj3BwaM+hRNB5Zlp17fWtjr58QjWY/+pHTXgMu/M3k=;
        b=NBWoYnvF3a4QfE2VQLZ1qLQUN7XpIIUlvGbbU8zdYJtYW94PY319qc5OzL0qa7KL40
         VPsj+BZVkbe9cKG4V3GwW/sqBtfhAr/2bzThMqoHIOCK3tmUnZruaNwmNUdCGzlFKYI0
         AqY2nMIbnFKE7fnYYQ5782G8hDgYu9Ykd0oNn8txOF9kealDbWmTYc+na6J+NTbs38ti
         pZHSymxukdogRGUFVlql5UL86BjEjcWDl8Y1JbRBm9YZEdW83MIXO8IGE6fin3hyt8A8
         Sonv10aLpl1ajH4mVxQDlN1byE93B9giTfoq0rOM0xicweZXQxVTiwOktCkDD1u4LuFt
         02ag==
X-Gm-Message-State: AOAM531t7uRRpZ5tNF1n+kcauKyymVXojC3WPiA6x9Gx4z3q/wL9DnvI
        S2lAJ8FYljF43d/RYhONnJoqyXwNuHp0ibTH3QxdrWk05m+ABDNmaVfRBkC/Ks5A/lwr7CtL7nf
        uQCd/RULfQbYS
X-Received: by 2002:a5d:64cf:: with SMTP id f15mr3236677wri.284.1633179244573;
        Sat, 02 Oct 2021 05:54:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgDxwlX5HGT9dZoGs+v2dDhfLDMjbUmMV+tcfi8guLt6V72knTXRGXTjkGozRRcnhuV3Vi0Q==
X-Received: by 2002:a5d:64cf:: with SMTP id f15mr3236665wri.284.1633179244437;
        Sat, 02 Oct 2021 05:54:04 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id i7sm8530172wrp.5.2021.10.02.05.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:54:04 -0700 (PDT)
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
        Connor Kuehl <ckuehl@redhat.com>
Subject: [PATCH v3 10/22] target/i386/sev: sev_get_attestation_report use g_autofree
Date:   Sat,  2 Oct 2021 14:53:05 +0200
Message-Id: <20211002125317.3418648-11-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Removes a whole bunch of g_free's and a goto.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Message-Id: <20210603113017.34922-1-dgilbert@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/sev.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index c88cd808410..aefbef4bb63 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -493,8 +493,8 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
     struct kvm_sev_attestation_report input = {};
     SevAttestationReport *report = NULL;
     SevGuestState *sev = sev_guest;
-    guchar *data;
-    guchar *buf;
+    g_autofree guchar *data = NULL;
+    g_autofree guchar *buf = NULL;
     gsize len;
     int err = 0, ret;
 
@@ -514,7 +514,6 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
     if (len != sizeof(input.mnonce)) {
         error_setg(errp, "SEV: mnonce must be %zu bytes (got %" G_GSIZE_FORMAT ")",
                 sizeof(input.mnonce), len);
-        g_free(buf);
         return NULL;
     }
 
@@ -525,7 +524,6 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
         if (err != SEV_RET_INVALID_LEN) {
             error_setg(errp, "failed to query the attestation report length "
                     "ret=%d fw_err=%d (%s)", ret, err, fw_error_to_str(err));
-            g_free(buf);
             return NULL;
         }
     }
@@ -540,7 +538,7 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
     if (ret) {
         error_setg_errno(errp, errno, "Failed to get attestation report"
                 " ret=%d fw_err=%d (%s)", ret, err, fw_error_to_str(err));
-        goto e_free_data;
+        return NULL;
     }
 
     report = g_new0(SevAttestationReport, 1);
@@ -548,9 +546,6 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
 
     trace_kvm_sev_attestation_report(mnonce, report->data);
 
-e_free_data:
-    g_free(data);
-    g_free(buf);
     return report;
 }
 
-- 
2.31.1

