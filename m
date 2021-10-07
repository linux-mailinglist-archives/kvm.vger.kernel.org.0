Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69FE42579D
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242660AbhJGQTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:19:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38118 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242327AbhJGQTw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:19:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gGHqQ6nijElfXE8z0EcIVqckplNgbvyU+2uRGsS/qhw=;
        b=IL+ln0KH2PEMj+jebJ+KBK/KGOBo47cZSsH6AKbcizcUp2pQ2ckMGqgTLBt2xDTdI2j9Kx
        lJE+F5ZbJHTw0MN4oMKjiIfWKkGO6o+pfTeWYeZNPwRE+R+pPxnzSUJW/HdKidLoVDpZCH
        6JWMCDOAx13vEcIea27UXoz3CN9XT/s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-9lkq9jljPlmCVlwNX2ErUA-1; Thu, 07 Oct 2021 12:17:57 -0400
X-MC-Unique: 9lkq9jljPlmCVlwNX2ErUA-1
Received: by mail-wr1-f70.google.com with SMTP id f11-20020adfc98b000000b0015fedc2a8d4so5145155wrh.0
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:17:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gGHqQ6nijElfXE8z0EcIVqckplNgbvyU+2uRGsS/qhw=;
        b=gdkhY7LUAczUOGbKng9CRhUkiblQJAqP3qZJ6KqXUD1hl1c5OtDUvkiltqj4I/INlg
         wH9UDp5GeRhJQ4aZNVUL0V8v332LqnQPVV3SnW6go1aiOvj1P/mdN3vwwk6Cc1dsssht
         Ry0HkDM+UDdlJ/sjpUYv1bIg47rwYdNRgNHH7OKLWTkE/zFTMK7pHxcVXIJ4a/rbb9Z2
         sjRrfkv7v8ErRoqSs1H49fprzPy156xwuC67LaDr92ogltZ4/Ewh6eSWLNLCo4LlEpq/
         lvSZrb430tXF7JhF3eT3h6rPkYM6Xa/nWoh3AGOSZxT4kEMzEOrPv2ym0UvEBNZtTpuH
         lxlw==
X-Gm-Message-State: AOAM532bCd+WyQ0oqn80ogunquuIKxNok1vAA6aDgQc9HFmg2ARYe18o
        mnMXs/1pVlCSgWQT143lrlmBB+PakM4soRfnWkCmfjip8HsTm0FDym4kuamDdwNGoh121rMY8Np
        I6oYoW0OKeQ9O
X-Received: by 2002:a7b:cb4f:: with SMTP id v15mr5561599wmj.21.1633623475370;
        Thu, 07 Oct 2021 09:17:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfpdMNhU4CbAVvUdxNmWaSwoJzzerQY5uah7o9Fgx03HmJkEu8zn8P5fwyEHm478TyAhx7tQ==
X-Received: by 2002:a7b:cb4f:: with SMTP id v15mr5561558wmj.21.1633623475187;
        Thu, 07 Oct 2021 09:17:55 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id z5sm12440932wmp.26.2021.10.07.09.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:17:54 -0700 (PDT)
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
Subject: [PATCH v4 08/23] target/i386/sev_i386.h: Remove unused headers
Date:   Thu,  7 Oct 2021 18:17:01 +0200
Message-Id: <20211007161716.453984-9-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Declarations don't require these headers, remove them.

Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/sev_i386.h | 4 ----
 target/i386/sev-stub.c | 1 +
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
index 2afe1080690..9bf6cd18789 100644
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
index d8e65831714..408441768dc 100644
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

