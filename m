Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E82E4257AE
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242708AbhJGQUn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:20:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241749AbhJGQUm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:20:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eYG5GFyks0GfeQysE3VKr9sF8B7VadEExh3ZaL/jqtM=;
        b=CHTO9PmlQABW6BLB0A1V68OktaW9gBdsqMeW6H7y9aEZl6zSN4yCMU4cggBeBwB1fQAPNj
        TUe8dxybi8ePWSTEw7jrPEavHKryb5IOZpQCYrkLccp6IpZb4vPdIk71OFZMWqv/FofpST
        hKYRtawTdhu+yjx7o3ls5IPrE4C4FWc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-N7AjH2XMO3-XbkRu3Um8IA-1; Thu, 07 Oct 2021 12:18:46 -0400
X-MC-Unique: N7AjH2XMO3-XbkRu3Um8IA-1
Received: by mail-wr1-f71.google.com with SMTP id f11-20020adfc98b000000b0015fedc2a8d4so5146900wrh.0
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:18:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eYG5GFyks0GfeQysE3VKr9sF8B7VadEExh3ZaL/jqtM=;
        b=USVLliuiZFwYRoAlsV+abGGN/2kPbneo6Lutrj+EDo1oWaD6pq/tuZgLv3U63Nu6N7
         fKzLGGp1UyrqyNqjUFA2YQCLWXTnKWpx8SAbc21VIW+Y76jZYZOU8J+q+HQ/r27aF/ri
         7WypppbzFfGWoQdCOqUVdVTBDEP1sT8/8PI0Hsm3bGQNIb9vTsd8fZdJiR5hSfzhnmXm
         AUgmqOVoedpbsXBKxRMJIb8QeUlHcGLiyaZxH+0xjWhNAIevg72ag7uZiL55C5mKDHx2
         0bZ0Dw3t6RQG/b4TheC1dIBqkztADixOUkXEqozNvLqC7AX2lpu953lFd0LP77FyxsEv
         Kfig==
X-Gm-Message-State: AOAM5307rlPL3GxK/ht2OWrlmeEc/PKkgnRN9jVn297lylL2wsJMFLp+
        Fu7y0b2sz+bzDxlKBfLzAw8Q5R+LEKuUwQSih2SduElvCmBob48IyyXdWWz5H9/rz2ec2ZdUVk2
        tzeSwUUeikcmd
X-Received: by 2002:adf:aa92:: with SMTP id h18mr6442643wrc.372.1633623525127;
        Thu, 07 Oct 2021 09:18:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyHHZKQOjYRnT9+FmsxmDtac4YCe8C0X0vefev5KYvlUQXaIrRgt4AfzCSl6KGgaKbHDRYH0g==
X-Received: by 2002:adf:aa92:: with SMTP id h18mr6442625wrc.372.1633623524973;
        Thu, 07 Oct 2021 09:18:44 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id f9sm85962wrt.11.2021.10.07.09.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:18:44 -0700 (PDT)
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
Subject: [PATCH v4 19/23] target/i386/sev: Move qmp_query_sev_capabilities() to sev.c
Date:   Thu,  7 Oct 2021 18:17:12 +0200
Message-Id: <20211007161716.453984-20-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move qmp_query_sev_capabilities() from monitor.c to sev.c
and make sev_get_capabilities() static. We don't need the
stub anymore, remove it.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/sev.h             | 1 -
 target/i386/monitor.c         | 5 -----
 target/i386/sev-sysemu-stub.c | 2 +-
 target/i386/sev.c             | 8 ++++++--
 4 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/target/i386/sev.h b/target/i386/sev.h
index 2e90c05fc3f..b70b7b56cb8 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -51,7 +51,6 @@ extern SevInfo *sev_get_info(void);
 extern uint32_t sev_get_cbit_position(void);
 extern uint32_t sev_get_reduced_phys_bits(void);
 extern char *sev_get_launch_measurement(void);
-extern SevCapability *sev_get_capabilities(Error **errp);
 extern bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp);
 
 int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index 22883ef2ebb..4c017b59b3a 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -727,11 +727,6 @@ SevLaunchMeasureInfo *qmp_query_sev_launch_measure(Error **errp)
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
index 82c5ebb92fa..3e8cab4c144 100644
--- a/target/i386/sev-sysemu-stub.c
+++ b/target/i386/sev-sysemu-stub.c
@@ -27,7 +27,7 @@ char *sev_get_launch_measurement(void)
     return NULL;
 }
 
-SevCapability *sev_get_capabilities(Error **errp)
+SevCapability *qmp_query_sev_capabilities(Error **errp)
 {
     error_setg(errp, "SEV is not available in this QEMU");
     return NULL;
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 072bb6f0fd7..56e9e03accd 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -466,8 +466,7 @@ e_free:
     return 1;
 }
 
-SevCapability *
-sev_get_capabilities(Error **errp)
+static SevCapability *sev_get_capabilities(Error **errp)
 {
     SevCapability *cap = NULL;
     guchar *pdh_data = NULL;
@@ -517,6 +516,11 @@ out:
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

