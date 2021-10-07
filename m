Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA3F4257A1
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242678AbhJGQUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:20:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54763 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242132AbhJGQUA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:20:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sSsWEPfIasNtfedQFCfGwO+jHWqTcMPZG0w8furmgm0=;
        b=KcEEmpgG25lk93ZXIQFYo29xAa0MIMOldTG50F2I6kdzQYPPrcW/arOsBUnQ67CKlCjhBk
        QbePTs6gKHnJOADC182vlQcrTcVrSXWJ1f82paXxEw4F1wDwjW0sjuBqlFb/evWsYXJC7M
        oyBnlFfx5bNZNsG7MaHgd5K+O5Ome0Q=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-NYqU7IrcO_2InDhBcROSfA-1; Thu, 07 Oct 2021 12:18:01 -0400
X-MC-Unique: NYqU7IrcO_2InDhBcROSfA-1
Received: by mail-wr1-f69.google.com with SMTP id f11-20020adfc98b000000b0015fedc2a8d4so5145316wrh.0
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:18:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sSsWEPfIasNtfedQFCfGwO+jHWqTcMPZG0w8furmgm0=;
        b=qrD9F/gf0nQP5Lt1xdORSmtjJPYP0K5WRbfIi7Xh3UhPEB4HYGmYf9A1R3Qe7FigkM
         TaOoYIsKL4HCUkwx5iBrSnVhXPNdyaAkIa2v4hV+F2qmrMGGxhS0BsX6vcoX/5c17Aku
         /Yi5LaT8KA+HzbRJrNNMVEgJmGmcVE9ab7fvXLNbETPoNwQF3qDi+5JAswaEYTotx7Jq
         sdyRGxkrTQQr2LovTmlvfxlSs9d7CfOqqUf0xI4ari1vtCcyT3lojqjgAZEFbMiYUaDX
         jpinUfQDNPaWZdR/aB9Uf2DKN1g+5I3+5ct9eHpexzT+wTvcTNSxyPcnpaqB8LDuPrhL
         7oVw==
X-Gm-Message-State: AOAM533rbF+1nGP4bMmVNZOa4DMEH9Rf/EmewLxxHDF9siKgW/nSEbRZ
        DYb44rRV0QkDDlCCYOSE3lZqpgd+EFIK58jp5mlxEHFWOcC9SMUUFNTESakKEIlyUCV5SGr7E8y
        095qLuNJUlKXX
X-Received: by 2002:a1c:21c3:: with SMTP id h186mr17261145wmh.107.1633623480254;
        Thu, 07 Oct 2021 09:18:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjsy2gU1mGBwP4i99ZbwNtks5RgQrT2oIJ/6iZksWTWx6vPIaxi9q5gezQizl94gxn/Bm+vw==
X-Received: by 2002:a1c:21c3:: with SMTP id h186mr17261120wmh.107.1633623480062;
        Thu, 07 Oct 2021 09:18:00 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id a25sm8734142wmj.34.2021.10.07.09.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:17:59 -0700 (PDT)
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
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>
Subject: [PATCH v4 09/23] target/i386/sev: Remove sev_get_me_mask()
Date:   Thu,  7 Oct 2021 18:17:02 +0200
Message-Id: <20211007161716.453984-10-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unused dead code makes review harder, so remove it.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/sev_i386.h | 1 -
 target/i386/sev-stub.c | 5 -----
 target/i386/sev.c      | 9 ---------
 3 files changed, 15 deletions(-)

diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
index 9bf6cd18789..d83428fa265 100644
--- a/target/i386/sev_i386.h
+++ b/target/i386/sev_i386.h
@@ -36,7 +36,6 @@ typedef struct SevKernelLoaderContext {
 } SevKernelLoaderContext;
 
 extern bool sev_es_enabled(void);
-extern uint64_t sev_get_me_mask(void);
 extern SevInfo *sev_get_info(void);
 extern uint32_t sev_get_cbit_position(void);
 extern uint32_t sev_get_reduced_phys_bits(void);
diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
index 408441768dc..20b1e18ec1b 100644
--- a/target/i386/sev-stub.c
+++ b/target/i386/sev-stub.c
@@ -25,11 +25,6 @@ bool sev_enabled(void)
     return false;
 }
 
-uint64_t sev_get_me_mask(void)
-{
-    return ~0;
-}
-
 uint32_t sev_get_cbit_position(void)
 {
     return 0;
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 4f1952cd32f..9e3f2ec8dd3 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -65,7 +65,6 @@ struct SevGuestState {
     uint8_t api_major;
     uint8_t api_minor;
     uint8_t build_id;
-    uint64_t me_mask;
     int sev_fd;
     SevState state;
     gchar *measurement;
@@ -389,12 +388,6 @@ sev_es_enabled(void)
     return sev_enabled() && (sev_guest->policy & SEV_POLICY_ES);
 }
 
-uint64_t
-sev_get_me_mask(void)
-{
-    return sev_guest ? sev_guest->me_mask : ~0;
-}
-
 uint32_t
 sev_get_cbit_position(void)
 {
@@ -833,8 +826,6 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         goto err;
     }
 
-    sev->me_mask = ~(1UL << sev->cbitpos);
-
     devname = object_property_get_str(OBJECT(sev), "sev-device", NULL);
     sev->sev_fd = open(devname, O_RDWR);
     if (sev->sev_fd < 0) {
-- 
2.31.1

