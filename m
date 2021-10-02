Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E65841FBF2
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbhJBM4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:56:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40233 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233310AbhJBM4d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:56:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WyR/eNCtMhabJTiJL4KYPQfagO3ysZNetDQfcxieNmI=;
        b=fVsltZ6HffjC1hd7tmQU6T9GQyrwvL4MAOyBjfoUhvwkNh5jg49dTbrlb6cneTMLejizPX
        6QakBJQu4NqoT+E6lCPMRXN2sSngDGsZYTiZQ/vnvhPKXe6dYfHJcYsDLhEzf9vQsqiDj3
        zLfYKk8B/CZqo2Mqs1Um/m+B+x/6upg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-RANXtHbgOYe-XiBNZmroQw-1; Sat, 02 Oct 2021 08:54:46 -0400
X-MC-Unique: RANXtHbgOYe-XiBNZmroQw-1
Received: by mail-wm1-f70.google.com with SMTP id n3-20020a7bcbc3000000b0030b68c4de38so3791372wmi.8
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:54:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WyR/eNCtMhabJTiJL4KYPQfagO3ysZNetDQfcxieNmI=;
        b=vvVMV8FRlbkdNboESwMrcvWsy7NZbI3XLBfqhnMIlH08W2ZR51l+snQTUxQbrKCAOj
         PU/RY+WgrVLf0kWrwtHQzyXL1WREcFZgnsUm+HY3+x98wbwiOjMxWWkm0D5ayDS9nHru
         /7tmt3k6OLfC9SShKaCOqPPS9TBRI6N1MY3rLQx75LKKBzlzwrsQa/QdOXqnJgD5NCxH
         uKhBT6VtmQFjKZKCjH5pWYwUVu77f3Wh/3ZtGx1bGBSUgS2MVulmqRZhD0hrLYa12OJC
         /j+AzA4XpM+1+R5XLo90jt8jrS6pztJK34ip6I83gYoG3kePLcY5nFq+Q+wmfolNVJWA
         q1dA==
X-Gm-Message-State: AOAM530B/zSxVzyZ4IsaWNnSnvCjcG31d0XGowwAWNggUZxKkyAbjzS/
        F1djOhJ/GgVv4wpf2wcklmIk7OmMhdNaX1MPkyvzG5cvBk9SoIkY9Ur0KK523aHquUnrtnXrYyd
        x0fkNnawOgkR+
X-Received: by 2002:a5d:44d1:: with SMTP id z17mr3370226wrr.187.1633179285065;
        Sat, 02 Oct 2021 05:54:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy67yh1G/4H9iMDyZQOpRZdq+m1Nl/19ODGozR8E+nhB1/ZKWnqdXBw6WrBb4+UnlkFrV3bSA==
X-Received: by 2002:a5d:44d1:: with SMTP id z17mr3370205wrr.187.1633179284860;
        Sat, 02 Oct 2021 05:54:44 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id o12sm8851885wms.15.2021.10.02.05.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:54:44 -0700 (PDT)
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
        "Daniel P . Berrange" <berrange@redhat.com>
Subject: [PATCH v3 19/22] monitor: Restrict 'info sev' to x86 targets
Date:   Sat,  2 Oct 2021 14:53:14 +0200
Message-Id: <20211002125317.3418648-20-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/monitor/hmp-target.h  | 1 +
 include/monitor/hmp.h         | 1 -
 target/i386/sev-sysemu-stub.c | 2 +-
 target/i386/sev.c             | 2 +-
 4 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/monitor/hmp-target.h b/include/monitor/hmp-target.h
index dc53add7eef..96956d0fc41 100644
--- a/include/monitor/hmp-target.h
+++ b/include/monitor/hmp-target.h
@@ -49,6 +49,7 @@ void hmp_info_tlb(Monitor *mon, const QDict *qdict);
 void hmp_mce(Monitor *mon, const QDict *qdict);
 void hmp_info_local_apic(Monitor *mon, const QDict *qdict);
 void hmp_info_io_apic(Monitor *mon, const QDict *qdict);
+void hmp_info_sev(Monitor *mon, const QDict *qdict);
 void hmp_info_sgx(Monitor *mon, const QDict *qdict);
 
 #endif /* MONITOR_HMP_TARGET_H */
diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
index 3baa1058e2c..6bc27639e01 100644
--- a/include/monitor/hmp.h
+++ b/include/monitor/hmp.h
@@ -124,7 +124,6 @@ void hmp_info_ramblock(Monitor *mon, const QDict *qdict);
 void hmp_hotpluggable_cpus(Monitor *mon, const QDict *qdict);
 void hmp_info_vm_generation_id(Monitor *mon, const QDict *qdict);
 void hmp_info_memory_size_summary(Monitor *mon, const QDict *qdict);
-void hmp_info_sev(Monitor *mon, const QDict *qdict);
 void hmp_info_replay(Monitor *mon, const QDict *qdict);
 void hmp_replay_break(Monitor *mon, const QDict *qdict);
 void hmp_replay_delete_break(Monitor *mon, const QDict *qdict);
diff --git a/target/i386/sev-sysemu-stub.c b/target/i386/sev-sysemu-stub.c
index 1836b32e4fc..b2a4033a030 100644
--- a/target/i386/sev-sysemu-stub.c
+++ b/target/i386/sev-sysemu-stub.c
@@ -13,7 +13,7 @@
 
 #include "qemu/osdep.h"
 #include "monitor/monitor.h"
-#include "monitor/hmp.h"
+#include "monitor/hmp-target.h"
 #include "qapi/qapi-commands-misc-target.h"
 #include "qapi/qmp/qerror.h"
 #include "qapi/error.h"
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 7caaa117ff7..c6d8fc52eb2 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -32,7 +32,7 @@
 #include "migration/blocker.h"
 #include "qom/object.h"
 #include "monitor/monitor.h"
-#include "monitor/hmp.h"
+#include "monitor/hmp-target.h"
 #include "qapi/qapi-commands-misc-target.h"
 #include "qapi/qmp/qerror.h"
 #include "exec/confidential-guest-support.h"
-- 
2.31.1

