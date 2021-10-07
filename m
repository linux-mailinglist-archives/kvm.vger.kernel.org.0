Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717304257A5
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242691AbhJGQUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:20:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41886 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242684AbhJGQUL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:20:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MMQ6iAvCxwnURglpVB4IW0fu5BXcN7B4HeGKo8BxsN0=;
        b=ZOeiXkUGBkEkX/yditrrDNpj+090gGh96ZUkggENJJQZGQhW22du0f6qKEqKds0vyFVDoD
        pFQxM6CI6R2+K3hfcXRU9n+RaX0CYix1+nT7eOOUKvnH3y10NAChW5zvlklcpdrUMidepB
        X4G63hRV9f32N3DtpUGGOJjgwWbcNE4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-NPuazXbbNQCGRoIu-hN2UA-1; Thu, 07 Oct 2021 12:18:14 -0400
X-MC-Unique: NPuazXbbNQCGRoIu-hN2UA-1
Received: by mail-wr1-f71.google.com with SMTP id s18-20020adfbc12000000b00160b2d4d5ebso5151153wrg.7
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:18:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MMQ6iAvCxwnURglpVB4IW0fu5BXcN7B4HeGKo8BxsN0=;
        b=EkVD6iNpWnHQ/dmA5tbNPIaUbMUQ+Eq5RhdckVQtnm4oxIIntN3exbZBBP+CYyV7MK
         +Vjsv2Q76LYIzKEWt0Dy9xSZvh4RW/dYVcTL9Wq6lxqOtAJokAh9ISS/jUZc4NO8odOm
         kWBsRNYiFEJAJxSyGWbu3/oHO/uiaG7pW5ILOtDqk9TUOV2XL4U41QjELK/oKVCShE4s
         LBwHEwiqXN1lG5if0jzRBxim3u4V5ql4EcofsDXzDrBouRcCY2cYSzBgJiVcMHRfz+J0
         bXB5gsEitHZFKTRQ7Uw6wMDz3SHSkvXHMovpKiiQG9GtWcVd2664ZvkDof1vGJdMuDn9
         kEIQ==
X-Gm-Message-State: AOAM531dKDJBwM76oRfdc4crhkXFkT4rzWfnzLNo01Hg55JoJ8b2V+nv
        MgpW33/KT3Ii/8RQb3cWyhm5DbnbGxtf93Sbu9t4rNE0LONR81CYxz9u74gXrHSfbYS5yvV38BU
        AesE+32SCSTK0
X-Received: by 2002:a1c:9857:: with SMTP id a84mr17228552wme.28.1633623493630;
        Thu, 07 Oct 2021 09:18:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8ZfB3bnXzEPGWYDhd6PuaST01yQ2MZwVDhjZw+EgLXq2/Mov1UPnSHQG5FosvLqV9SCfneQ==
X-Received: by 2002:a1c:9857:: with SMTP id a84mr17228508wme.28.1633623493502;
        Thu, 07 Oct 2021 09:18:13 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id 1sm9454040wmb.24.2021.10.07.09.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:18:13 -0700 (PDT)
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
Subject: [PATCH v4 12/23] target/i386/sev: Use g_autofree in sev_launch_get_measure()
Date:   Thu,  7 Oct 2021 18:17:05 +0200
Message-Id: <20211007161716.453984-13-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use g_autofree to remove a pair of g_free/goto.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/sev.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 3a30ba6d94a..5cbbcf0bb93 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -685,8 +685,8 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
 {
     SevGuestState *sev = sev_guest;
     int ret, error;
-    guchar *data;
-    struct kvm_sev_launch_measure *measurement;
+    g_autofree guchar *data = NULL;
+    g_autofree struct kvm_sev_launch_measure *measurement = NULL;
 
     if (!sev_check_state(sev, SEV_STATE_LAUNCH_UPDATE)) {
         return;
@@ -708,7 +708,7 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
     if (!measurement->len) {
         error_report("%s: LAUNCH_MEASURE ret=%d fw_error=%d '%s'",
                      __func__, ret, error, fw_error_to_str(errno));
-        goto free_measurement;
+        return;
     }
 
     data = g_new0(guchar, measurement->len);
@@ -720,7 +720,7 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
     if (ret) {
         error_report("%s: LAUNCH_MEASURE ret=%d fw_error=%d '%s'",
                      __func__, ret, error, fw_error_to_str(errno));
-        goto free_data;
+        return;
     }
 
     sev_set_guest_state(sev, SEV_STATE_LAUNCH_SECRET);
@@ -728,11 +728,6 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
     /* encode the measurement value and emit the event */
     sev->measurement = g_base64_encode(data, measurement->len);
     trace_kvm_sev_launch_measurement(sev->measurement);
-
-free_data:
-    g_free(data);
-free_measurement:
-    g_free(measurement);
 }
 
 char *
-- 
2.31.1

