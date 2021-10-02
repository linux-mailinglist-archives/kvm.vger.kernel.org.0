Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E539641FBE7
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbhJBMzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:55:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51138 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233291AbhJBMzs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:55:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KJdW6m0Ma56hwzjCy1teOEHrEH20tchf6AQogJnEfxU=;
        b=IMROb0Jmtcifq0WE06BVpFvlcPZbhXPT0OmZYgYlj4whBtlz4N5yag++utQ0FO4vr1FBYy
        PeCMczK9CbCzOSnXMni4eO4wQ7+b35x87Ov4pnPsDb4oG6069DUETVZq3rtSm6Kod0vg30
        xezFufs0RlYqf6TDnkCgPG0m/lv6caE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-tgpzsy_GPdKu6Cjdht0I9g-1; Sat, 02 Oct 2021 08:54:01 -0400
X-MC-Unique: tgpzsy_GPdKu6Cjdht0I9g-1
Received: by mail-wm1-f70.google.com with SMTP id y23-20020a05600c365700b003015b277f98so3788580wmq.2
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:54:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KJdW6m0Ma56hwzjCy1teOEHrEH20tchf6AQogJnEfxU=;
        b=ZZlFtu5Xtz0aVyU95JHLnNb/oUJnkVj32hidIFM+w8m1VVkNUroIMLXgrO3QiETL0L
         5sF9tm/QCC3A3iLXSmkydSJcBTYLZM1alj9L5PaZ1HRsj0IUid9t0Fnb5xoUQxAShmVL
         xy64WSYSwxEv9QrFCQ+7myfMYUlfQ4cPNDnWmBYWvyk6EvGsSXejdQQHWUHF6XV2VEsX
         mGWBM/AuTnH9BhjGcw60+exH6JW89pOv5nPnxXq03NObcCd+C7/4ptF3MYlkDenFKTNB
         rLZBkPP+IpuEbdF/faQqxaCM+k4QPTtIzeN3PToZ5o06r6WvagTB3QTSW2lHOpS29BMD
         7rCw==
X-Gm-Message-State: AOAM530OuuWefdIzqYbp1Ykxv2XgGYfcefL/2vrwV8HG7LDX0XXlS0m6
        u2Sco6wV1Xc8V+CvDQdbuuzw6m9WaMCn4iKI6A7cFwwIB6Os9Q9fjzHQ2HCIuPSnoDhqDn4Ijf8
        2VZx/rJl74Efh
X-Received: by 2002:a05:6000:2c6:: with SMTP id o6mr3374977wry.292.1633179240039;
        Sat, 02 Oct 2021 05:54:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1kpUWp8JDca6ogxcYyGFA/Lr3YXbhWtYHXiUio3plQycEwa1/nNlCgTVPD8fjk35/bjBa4A==
X-Received: by 2002:a05:6000:2c6:: with SMTP id o6mr3374964wry.292.1633179239910;
        Sat, 02 Oct 2021 05:53:59 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id f1sm9356839wri.43.2021.10.02.05.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:53:59 -0700 (PDT)
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
Subject: [PATCH v3 09/22] target/i386/sev: Mark unreachable code with g_assert_not_reached()
Date:   Sat,  2 Oct 2021 14:53:04 +0200
Message-Id: <20211002125317.3418648-10-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The unique sev_encrypt_flash() invocation (in pc_system_flash_map)
is protected by the "if (sev_enabled())" check, so is not
reacheable.
Replace the abort() call in sev_es_save_reset_vector() by
g_assert_not_reached() which meaning is clearer.

Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/sev-stub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
index eb0c89bf2be..4668365fd3e 100644
--- a/target/i386/sev-stub.c
+++ b/target/i386/sev-stub.c
@@ -54,7 +54,7 @@ int sev_inject_launch_secret(const char *hdr, const char *secret,
 
 int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
 {
-    return 0;
+    g_assert_not_reached();
 }
 
 bool sev_es_enabled(void)
@@ -68,7 +68,7 @@ void sev_es_set_reset_vector(CPUState *cpu)
 
 int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size)
 {
-    abort();
+    g_assert_not_reached();
 }
 
 SevAttestationReport *
-- 
2.31.1

