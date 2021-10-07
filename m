Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DBE42579A
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242645AbhJGQTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:19:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24584 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241736AbhJGQTi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:19:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YWQW4qwuIwVFhirEUS8iXAcoBuFkj6ZGIrq5y79ZQBA=;
        b=ZVStX8WQ/vDYglNvj95se+TUlnLiFIScGjBKNl8uX4OL/JrPa15RsV/s7zTlmqH0pXvrwq
        SJqKjwpRVtXpyqrcQO2wN6oo+BuukcnzZU6cpCJfLLpeuwOJKJq2WpB90WQplQCxu1Jelz
        6/1po4Yf0Hg2/9fZBU5w12rY+qdBDGA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-9EbFHwYNM96g665r-oRT6A-1; Thu, 07 Oct 2021 12:17:42 -0400
X-MC-Unique: 9EbFHwYNM96g665r-oRT6A-1
Received: by mail-wr1-f70.google.com with SMTP id 41-20020adf812c000000b00160dfbfe1a2so1450195wrm.3
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:17:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YWQW4qwuIwVFhirEUS8iXAcoBuFkj6ZGIrq5y79ZQBA=;
        b=6F6qyYrUimAkAkaBLkhCLu8dmwJ3mTeOhlZ29X96TfqGdedNZxGQs2DjTOtJ+JnEma
         JgMtMsWgqGtiFkhOkk/XyHHz5gxZ+dZGeayTzS1+1QFP8GlmpItn2k2h9fpJgk53mFvk
         MKhAgfFyPMeVujYN76z/EEEecGBjKvUk60gTpk3AFo8pRZEo+z1RNrdPLRzjvgTgVJMs
         pfj+ofvgx8eZWnFA0SDOSDHTFYzrenVYrPu05pa9/+d3rddzwCehu3j9xT83akyfgmW3
         05t5b6jCs5CP9Fj/TM+Y1uEq2nprmR6wKVhKaVVs1xfKyDYo0HpZHksA5GaPCW/VA8v1
         NZKA==
X-Gm-Message-State: AOAM531xNBp8NU5ROGdTtSlay37MAD6EWcfdtmSCEa5Pomgrnefr/NEe
        biPIU64eea4vHktxmwCsatdrX+UGs1CPySuOYdAU0SgDRuZIHTfxVV/mZUoq7MRDzE/wQC8zAT0
        cUnAReGaUy97y
X-Received: by 2002:a05:600c:190c:: with SMTP id j12mr17723309wmq.122.1633623461591;
        Thu, 07 Oct 2021 09:17:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4KQBsttMSUVTx9ahdzw6VyJFfQYYcVssfVN4N4+Jw4Mj8STX+6QzmCQF2fKgdLkdMPO9omQ==
X-Received: by 2002:a05:600c:190c:: with SMTP id j12mr17723282wmq.122.1633623461414;
        Thu, 07 Oct 2021 09:17:41 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id e5sm88818wrd.1.2021.10.07.09.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:17:41 -0700 (PDT)
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
Subject: [PATCH v4 05/23] target/i386/sev: Prefix QMP errors with 'SEV'
Date:   Thu,  7 Oct 2021 18:16:58 +0200
Message-Id: <20211007161716.453984-6-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Multiple errors might be reported to the monitor,
better to prefix the SEV ones so we can distinct them.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/monitor.c |  2 +-
 target/i386/sev.c     | 20 +++++++++++---------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index 196c1c9e77f..eabbeb9be95 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -717,7 +717,7 @@ SevLaunchMeasureInfo *qmp_query_sev_launch_measure(Error **errp)
 
     data = sev_get_launch_measurement();
     if (!data) {
-        error_setg(errp, "Measurement is not available");
+        error_setg(errp, "SEV launch measurement is not available");
         return NULL;
     }
 
diff --git a/target/i386/sev.c b/target/i386/sev.c
index bcd9260fa46..4f1952cd32f 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -440,7 +440,8 @@ sev_get_pdh_info(int fd, guchar **pdh, size_t *pdh_len, guchar **cert_chain,
     r = sev_platform_ioctl(fd, SEV_PDH_CERT_EXPORT, &export, &err);
     if (r < 0) {
         if (err != SEV_RET_INVALID_LEN) {
-            error_setg(errp, "failed to export PDH cert ret=%d fw_err=%d (%s)",
+            error_setg(errp, "SEV: Failed to export PDH cert"
+                             " ret=%d fw_err=%d (%s)",
                        r, err, fw_error_to_str(err));
             return 1;
         }
@@ -453,7 +454,7 @@ sev_get_pdh_info(int fd, guchar **pdh, size_t *pdh_len, guchar **cert_chain,
 
     r = sev_platform_ioctl(fd, SEV_PDH_CERT_EXPORT, &export, &err);
     if (r < 0) {
-        error_setg(errp, "failed to export PDH cert ret=%d fw_err=%d (%s)",
+        error_setg(errp, "SEV: Failed to export PDH cert ret=%d fw_err=%d (%s)",
                    r, err, fw_error_to_str(err));
         goto e_free;
     }
@@ -491,7 +492,7 @@ sev_get_capabilities(Error **errp)
 
     fd = open(DEFAULT_SEV_DEVICE, O_RDWR);
     if (fd < 0) {
-        error_setg_errno(errp, errno, "Failed to open %s",
+        error_setg_errno(errp, errno, "SEV: Failed to open %s",
                          DEFAULT_SEV_DEVICE);
         return NULL;
     }
@@ -557,8 +558,9 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
             &input, &err);
     if (ret < 0) {
         if (err != SEV_RET_INVALID_LEN) {
-            error_setg(errp, "failed to query the attestation report length "
-                    "ret=%d fw_err=%d (%s)", ret, err, fw_error_to_str(err));
+            error_setg(errp, "SEV: Failed to query the attestation report"
+                             " length ret=%d fw_err=%d (%s)",
+                       ret, err, fw_error_to_str(err));
             g_free(buf);
             return NULL;
         }
@@ -572,7 +574,7 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
     ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
             &input, &err);
     if (ret) {
-        error_setg_errno(errp, errno, "Failed to get attestation report"
+        error_setg_errno(errp, errno, "SEV: Failed to get attestation report"
                 " ret=%d fw_err=%d (%s)", ret, err, fw_error_to_str(err));
         goto e_free_data;
     }
@@ -596,7 +598,7 @@ sev_read_file_base64(const char *filename, guchar **data, gsize *len)
     GError *error = NULL;
 
     if (!g_file_get_contents(filename, &base64, &sz, &error)) {
-        error_report("failed to read '%s' (%s)", filename, error->message);
+        error_report("SEV: Failed to read '%s' (%s)", filename, error->message);
         g_error_free(error);
         return -1;
     }
@@ -911,7 +913,7 @@ sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
     if (sev_check_state(sev_guest, SEV_STATE_LAUNCH_UPDATE)) {
         int ret = sev_launch_update_data(sev_guest, ptr, len);
         if (ret < 0) {
-            error_setg(errp, "failed to encrypt pflash rom");
+            error_setg(errp, "SEV: Failed to encrypt pflash rom");
             return ret;
         }
     }
@@ -930,7 +932,7 @@ int sev_inject_launch_secret(const char *packet_hdr, const char *secret,
     MemoryRegion *mr = NULL;
 
     if (!sev_guest) {
-        error_setg(errp, "SEV: SEV not enabled.");
+        error_setg(errp, "SEV not enabled for guest");
         return 1;
     }
 
-- 
2.31.1

