Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D7D41FBE6
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbhJBMzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:55:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27051 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233217AbhJBMzj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:55:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J6Nu9xcD/1mLwA45H6T/mwE1HK3rKCkbuT6P4bJEEQ4=;
        b=WOzXIdZrMDUAtoo9o7MEfWUtNCtab60BP9qO4YEiZuIuEK82TskcazDOibkAZ0KkFnByaV
        J/idG34SH18tBH807TrZnHE/0ILZGiJwtFU9EcKQ+is8xja3/lLCKFzcBkP+4jPDxvuBR5
        gbduzBxjASGFsz+DHjdyPHKn/Op9ZMc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-3TkHJxFyOB-7euTa2KKLFw-1; Sat, 02 Oct 2021 08:53:52 -0400
X-MC-Unique: 3TkHJxFyOB-7euTa2KKLFw-1
Received: by mail-wm1-f71.google.com with SMTP id 5-20020a1c00050000b02902e67111d9f0so6079013wma.4
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:53:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J6Nu9xcD/1mLwA45H6T/mwE1HK3rKCkbuT6P4bJEEQ4=;
        b=Jg+2G+92UG44hU8XZIgXbP1qIowQiwwyKJoIh0kZUNn0nSiXDCNd4wxNkpkrpYxxbm
         QF9WUl3VQcit/GDn5evX+Xf4rgWsZPbGBHFnyYVPJzBWzqTmgLLnVuSv5SNgwi2qbpbN
         dQMTShyf4e2zunUsb2ttSJRW4tRVODwQ9hNYdHmWOY/S+lvMSO55tiNRTspMONtbdGWH
         Hho5hjGpxmgZ62uVNXOqVcrkgM+r8NUJ1bpPABKPdVJey1Cu5Wop2IaEaa2eYvTxY+Iu
         RD2fDBh0YhveGvsQCMISBqOmIbXVKweSILPJeScCNm4bOqPLWEdYkq6F+00CMPZb59I7
         daZw==
X-Gm-Message-State: AOAM533/VZI5neCjVPqISwOoNoh0u0uBEV1h0yUUHdpxI2M/CR30Lr55
        lZ8iGOCh/YuYy00OQaOsm2hVN9J0r97ooJbT7qWDwOLZapMxD2xo1rJunM6bUiv9bb+W8Rgyba3
        hK/oufXpK4tmf
X-Received: by 2002:adf:97cc:: with SMTP id t12mr1334720wrb.189.1633179230888;
        Sat, 02 Oct 2021 05:53:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEX2HQVvG0eH4EoV9kXNFJrMMQBJdc9DWwXnuA0OfpprIlXkRMpruuO+nx+/QeCu4EKQakjA==
X-Received: by 2002:adf:97cc:: with SMTP id t12mr1334706wrb.189.1633179230756;
        Sat, 02 Oct 2021 05:53:50 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id f18sm4106229wrj.30.2021.10.02.05.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:53:50 -0700 (PDT)
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
Subject: [PATCH v3 07/22] target/i386/sev_i386.h: Remove unused headers
Date:   Sat,  2 Oct 2021 14:53:02 +0200
Message-Id: <20211002125317.3418648-8-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Declarations don't require these headers, remove them.

Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/sev_i386.h | 4 ----
 target/i386/sev-stub.c | 1 +
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
index ae6d8404787..f4223f1febf 100644
--- a/target/i386/sev_i386.h
+++ b/target/i386/sev_i386.h
@@ -14,11 +14,7 @@
 #ifndef QEMU_SEV_I386_H
 #define QEMU_SEV_I386_H
 
-#include "qom/object.h"
-#include "qapi/error.h"
-#include "sysemu/kvm.h"
 #include "sysemu/sev.h"
-#include "qemu/error-report.h"
 #include "qapi/qapi-types-misc-target.h"
 
 #define SEV_POLICY_NODBG        0x1
diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
index 0227cb51778..d91c2ece784 100644
--- a/target/i386/sev-stub.c
+++ b/target/i386/sev-stub.c
@@ -12,6 +12,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "qapi/error.h"
 #include "sev_i386.h"
 
 SevInfo *sev_get_info(void)
-- 
2.31.1

