Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D6F41FBE8
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbhJBMzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:55:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233291AbhJBMzt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:55:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2JOuakDg9TjNTLsEL31Gb5qf2swMU1YyZ5LrMCCfA9Y=;
        b=atJkaSqSD0IQc1ORNLP5tLwT/yz72MUEJk1o/1f3m7LkYhGdaea15qXRT+PCNYxQ7VltCA
        u4BFLgXUr0XiB3P9H+3jVpKlf2qElOOwyfE9sIt9m/fr6jy+iDaldePzbIajNtkza7pzBV
        jgXReu0EDNFvFAf+/l3vrZskGM7mkOw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-ba8Xnr6uOnKbZZWNhnm6ug-1; Sat, 02 Oct 2021 08:53:56 -0400
X-MC-Unique: ba8Xnr6uOnKbZZWNhnm6ug-1
Received: by mail-wm1-f69.google.com with SMTP id 5-20020a1c00050000b02902e67111d9f0so6079098wma.4
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:53:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2JOuakDg9TjNTLsEL31Gb5qf2swMU1YyZ5LrMCCfA9Y=;
        b=YWpWc4ZuMTyWF+IKUvxIt0LcWdrIk4ku0ot7aLNhirZ2SNWEHxBhpIWp9/2SllOU8j
         2gLsSdjbaWSyxBQu2FpJ5DHMYIYUcwQqtYVNJwg4hQ4Ofutlf3DHenK2ppDAoRLjBLSZ
         8ExDi9yH4DLdVx2vvsmxe3pvZMoVVRm3XA61CNL+28M5ViMRbwYaeK1G6VKL6rtWTt93
         Sc/OlGsqYf/ITy3Gr4U7XDMXW9dvAxrcdhm57F538LyU3piRTjv/jsUdXnrW6tl3NXDl
         5mnzDv6yU5q5YVUdKhqYACLl0KX6kSH1lZ/D4khZzkZ2sur1FIwymS6XKx3aMZljNsAT
         RrDA==
X-Gm-Message-State: AOAM533qPOJSABJJpM6I0xXLsyjIL7gk3MVkv0A9xxCUyJWci8iYKqt5
        a5/9YEyisvqJFGNKtYltknZQhQkfJVJOtirGuNQbhc4BYQnoZ7gVGTCjPn/hhvEMcRYXWa5e1+A
        tmRBeXqk9HCnc
X-Received: by 2002:adf:a18d:: with SMTP id u13mr3366726wru.275.1633179235453;
        Sat, 02 Oct 2021 05:53:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3pw9/64lGQcYsWkhaqchQbJCRGpJ8vrpRflv453uN3gfkMzMibGa3diRsytvz2Ljjr0eAUQ==
X-Received: by 2002:adf:a18d:: with SMTP id u13mr3366709wru.275.1633179235309;
        Sat, 02 Oct 2021 05:53:55 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id o12sm8849678wms.15.2021.10.02.05.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:53:54 -0700 (PDT)
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
Subject: [PATCH v3 08/22] target/i386/sev: Remove sev_get_me_mask()
Date:   Sat,  2 Oct 2021 14:53:03 +0200
Message-Id: <20211002125317.3418648-9-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unused dead code makes review harder, so remove it.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/sev_i386.h | 1 -
 target/i386/sev-stub.c | 5 -----
 target/i386/sev.c      | 9 ---------
 3 files changed, 15 deletions(-)

diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
index f4223f1febf..afa19a0a161 100644
--- a/target/i386/sev_i386.h
+++ b/target/i386/sev_i386.h
@@ -25,7 +25,6 @@
 #define SEV_POLICY_SEV          0x20
 
 extern bool sev_es_enabled(void);
-extern uint64_t sev_get_me_mask(void);
 extern SevInfo *sev_get_info(void);
 extern uint32_t sev_get_cbit_position(void);
 extern uint32_t sev_get_reduced_phys_bits(void);
diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
index d91c2ece784..eb0c89bf2be 100644
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
index fa7210473a6..c88cd808410 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -64,7 +64,6 @@ struct SevGuestState {
     uint8_t api_major;
     uint8_t api_minor;
     uint8_t build_id;
-    uint64_t me_mask;
     int sev_fd;
     SevState state;
     gchar *measurement;
@@ -362,12 +361,6 @@ sev_es_enabled(void)
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
@@ -804,8 +797,6 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         goto err;
     }
 
-    sev->me_mask = ~(1UL << sev->cbitpos);
-
     devname = object_property_get_str(OBJECT(sev), "sev-device", NULL);
     sev->sev_fd = open(devname, O_RDWR);
     if (sev->sev_fd < 0) {
-- 
2.31.1

