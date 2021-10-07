Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8854257A3
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242405AbhJGQUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:20:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50036 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233603AbhJGQUF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:20:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yEEZxUHWCMFJAaUbuJlVLcx9kbNHe4+tPDUcbMRvNgA=;
        b=ZWQ7+o1lGbSwBWqFWf52qCtfSgT8OT3ouAIOkA9Z9CG7WTKEqJj1iHFr7vVeajDAz1U1ci
        ezmZg1HH+Izah2fyIBaMJg9uxanE31o+x0xfX+C70nO/YAHVsLf6cI12bqyRhnsHQMvXMw
        OLdUAB72XIr1Ue900g6tovvZJ1x966U=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-I4IoJpXdOfq2BRXeUmQU-A-1; Thu, 07 Oct 2021 12:18:10 -0400
X-MC-Unique: I4IoJpXdOfq2BRXeUmQU-A-1
Received: by mail-wr1-f70.google.com with SMTP id k2-20020adfc702000000b0016006b2da9bso5115691wrg.1
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:18:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yEEZxUHWCMFJAaUbuJlVLcx9kbNHe4+tPDUcbMRvNgA=;
        b=kFfvNf73ZJfS19lvgh3j6oI6vovd7k2NefieSp+11cHo9B2zYPdQDYWlwQkqFlFSHw
         4/qfqQWOKbSCx5u2Ahk/9DZ22aJR+0q0iy54e9l6jsN/rxpsap03HxUatu/aZcFukKml
         fbYeIx3l69/XNxqnbgYmvxciyzFB3Bcvjz6l6s4W/mQ0y8+I6j8bGhvXHKBOUUNDAGet
         32+dtXaLmhao9XLgU8MvuzFgOx+sGDsEWbq+ecIVkvfLXWnwt0tnbclvo84YbkAIb5HN
         8dmDhfLI1YCF18DSqN+2FwnVK1ym1ETyrdvQdycDG12EWONipDmEYwLtEnU5h6RqUNPV
         /6SQ==
X-Gm-Message-State: AOAM530RPd4qXde0FSrxXWMNsfMmtMn9/mGrG8Imxh9/dZiFbpHwi15E
        wNpkN0mnlrmu3IGdjg9mx1z3I7LER2F6rpuucYfUdG3GGYHrveO7TmfW7ObuM42SBobA/S5dTXo
        bnFwDhM0lXYRn
X-Received: by 2002:a1c:e90a:: with SMTP id q10mr5781384wmc.108.1633623489196;
        Thu, 07 Oct 2021 09:18:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyp5Icsi0NLMXs/baHrjAWHmxKv/JAM8Pc+VahgSSp1ZOQcJVEBNNgny0Hxow6Cf8o/4Ee8g==
X-Received: by 2002:a1c:e90a:: with SMTP id q10mr5781363wmc.108.1633623489052;
        Thu, 07 Oct 2021 09:18:09 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id y23sm1025623wmj.42.2021.10.07.09.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:18:08 -0700 (PDT)
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
        Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v4 11/23] target/i386/sev: sev_get_attestation_report use g_autofree
Date:   Thu,  7 Oct 2021 18:17:04 +0200
Message-Id: <20211007161716.453984-12-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
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
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/sev.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 9e3f2ec8dd3..3a30ba6d94a 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -521,8 +521,8 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
     struct kvm_sev_attestation_report input = {};
     SevAttestationReport *report = NULL;
     SevGuestState *sev = sev_guest;
-    guchar *data;
-    guchar *buf;
+    g_autofree guchar *data = NULL;
+    g_autofree guchar *buf = NULL;
     gsize len;
     int err = 0, ret;
 
@@ -542,7 +542,6 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
     if (len != sizeof(input.mnonce)) {
         error_setg(errp, "SEV: mnonce must be %zu bytes (got %" G_GSIZE_FORMAT ")",
                 sizeof(input.mnonce), len);
-        g_free(buf);
         return NULL;
     }
 
@@ -554,7 +553,6 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
             error_setg(errp, "SEV: Failed to query the attestation report"
                              " length ret=%d fw_err=%d (%s)",
                        ret, err, fw_error_to_str(err));
-            g_free(buf);
             return NULL;
         }
     }
@@ -569,7 +567,7 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
     if (ret) {
         error_setg_errno(errp, errno, "SEV: Failed to get attestation report"
                 " ret=%d fw_err=%d (%s)", ret, err, fw_error_to_str(err));
-        goto e_free_data;
+        return NULL;
     }
 
     report = g_new0(SevAttestationReport, 1);
@@ -577,9 +575,6 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
 
     trace_kvm_sev_attestation_report(mnonce, report->data);
 
-e_free_data:
-    g_free(data);
-    g_free(buf);
     return report;
 }
 
-- 
2.31.1

