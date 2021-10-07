Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8354257A7
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242686AbhJGQUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:20:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40170 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242674AbhJGQUT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:20:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NtntxYjzk/c/tBnUjs6wx6H836yPN9/32v9yVgz+JmI=;
        b=FsqE1z/m7PMEfBN255eqYB8KlyiNOl/4D2a9X/BISqxAHLUpCv8Uyl/vKjPuzMEragJi5z
        vr4qZb0g1oEnqxRuyTT8WWhofCJ4UXd81mWE16JCVYB7DMGPIsW+XyWXTIXIquJhsckazJ
        gjg99St7DsxybhtUfxyhtE07/imhh9o=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-DA9W6y3FPaaYz-J378-CgA-1; Thu, 07 Oct 2021 12:18:23 -0400
X-MC-Unique: DA9W6y3FPaaYz-J378-CgA-1
Received: by mail-wr1-f71.google.com with SMTP id l9-20020adfc789000000b00160111fd4e8so5142939wrg.17
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:18:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NtntxYjzk/c/tBnUjs6wx6H836yPN9/32v9yVgz+JmI=;
        b=eAVo5wuvtMCWWBUTiEQ2n2nsVr0oLerCi4//V7ONJaMZ0nSjLWohjASbkL7PBgNKKG
         obHa2vmJqFRF6L0W0qlKf5Xj9VB3qaDFzTLTOoYUmcO0XwNCuXkMZzhJjKzQTB5MQDID
         kVMNPTdXJb2luZBhq6lrXU+newg+5L4NsYqKe2wX5kyb7dugBAFnp/k3LWUYuqEPQeOz
         W/Y6obO9t8ZIC5dEBOuZyNQ4Ybe+3uIaR6+TLLen8VzqhpLq/sWzhO+5DY1AgT9UHCeq
         omE4NPYDYVqIlxCaxfwK09+5AALUrXCG0DMprgHSK4qgareU75KDKBjOqQS9LtUAuRLQ
         UX2w==
X-Gm-Message-State: AOAM5323Fg6uYg26GittRTQHmXC+44RNSsmDP1HrAHSI2/7ibFU2qjHD
        xY0I3MAHMfHFgpIB/OR9CJjYUMDpwEVWB2rU0sRjvjBzTcJRg3bbXqa+vGityEZmRO66GOZO31H
        UHJCgdii7nRWn
X-Received: by 2002:a05:600c:2057:: with SMTP id p23mr5628890wmg.67.1633623502741;
        Thu, 07 Oct 2021 09:18:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbpkjWZoIcEo8CCNOMP08Kf3tAZlemKrKuxafvy6AWFRjok6953SFiC/moJkDRbEWcDARxSQ==
X-Received: by 2002:a05:600c:2057:: with SMTP id p23mr5628876wmg.67.1633623502591;
        Thu, 07 Oct 2021 09:18:22 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id v10sm93782wri.29.2021.10.07.09.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:18:22 -0700 (PDT)
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
Subject: [PATCH v4 14/23] target/i386/sev: Rename sev_i386.h -> sev.h
Date:   Thu,  7 Oct 2021 18:17:07 +0200
Message-Id: <20211007161716.453984-15-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV is a x86 specific feature, and the "sev_i386.h" header
is already in target/i386/. Rename it as "sev.h" to simplify.

Patch created mechanically using:

  $ git mv target/i386/sev_i386.h target/i386/sev.h
  $ sed -i s/sev_i386.h/sev.h/ $(git grep -l sev_i386.h)

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/{sev_i386.h => sev.h} | 0
 hw/i386/x86.c                     | 2 +-
 target/i386/cpu.c                 | 2 +-
 target/i386/kvm/kvm.c             | 2 +-
 target/i386/monitor.c             | 2 +-
 target/i386/sev-stub.c            | 2 +-
 target/i386/sev-sysemu-stub.c     | 2 +-
 target/i386/sev.c                 | 2 +-
 8 files changed, 7 insertions(+), 7 deletions(-)
 rename target/i386/{sev_i386.h => sev.h} (100%)

diff --git a/target/i386/sev_i386.h b/target/i386/sev.h
similarity index 100%
rename from target/i386/sev_i386.h
rename to target/i386/sev.h
diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 0c7c054e3a0..76de7e2265e 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -47,7 +47,7 @@
 #include "hw/i386/fw_cfg.h"
 #include "hw/intc/i8259.h"
 #include "hw/rtc/mc146818rtc.h"
-#include "target/i386/sev_i386.h"
+#include "target/i386/sev.h"
 
 #include "hw/acpi/cpu_hotplug.h"
 #include "hw/irq.h"
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index b54b98551e9..8289dc87bd5 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -26,7 +26,7 @@
 #include "sysemu/reset.h"
 #include "sysemu/hvf.h"
 #include "kvm/kvm_i386.h"
-#include "sev_i386.h"
+#include "sev.h"
 #include "qapi/error.h"
 #include "qapi/qapi-visit-machine.h"
 #include "qapi/qmp/qerror.h"
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index f25837f63f4..a5f6ff63c81 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -28,7 +28,7 @@
 #include "sysemu/kvm_int.h"
 #include "sysemu/runstate.h"
 #include "kvm_i386.h"
-#include "sev_i386.h"
+#include "sev.h"
 #include "hyperv.h"
 #include "hyperv-proto.h"
 
diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index ea836678f51..109e4e61c0a 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -32,7 +32,7 @@
 #include "sysemu/kvm.h"
 #include "sysemu/sev.h"
 #include "qapi/error.h"
-#include "sev_i386.h"
+#include "sev.h"
 #include "qapi/qapi-commands-misc-target.h"
 #include "qapi/qapi-commands-misc.h"
 #include "hw/i386/pc.h"
diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
index 170e9f50fee..7e8b6f9a259 100644
--- a/target/i386/sev-stub.c
+++ b/target/i386/sev-stub.c
@@ -13,7 +13,7 @@
 
 #include "qemu/osdep.h"
 #include "qapi/error.h"
-#include "sev_i386.h"
+#include "sev.h"
 
 bool sev_enabled(void)
 {
diff --git a/target/i386/sev-sysemu-stub.c b/target/i386/sev-sysemu-stub.c
index d556b4f091f..8082781febf 100644
--- a/target/i386/sev-sysemu-stub.c
+++ b/target/i386/sev-sysemu-stub.c
@@ -14,7 +14,7 @@
 #include "qemu/osdep.h"
 #include "qapi/qapi-commands-misc-target.h"
 #include "qapi/error.h"
-#include "sev_i386.h"
+#include "sev.h"
 
 SevInfo *sev_get_info(void)
 {
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 5cbbcf0bb93..e43bbf3a17d 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -25,7 +25,7 @@
 #include "qemu/uuid.h"
 #include "crypto/hash.h"
 #include "sysemu/kvm.h"
-#include "sev_i386.h"
+#include "sev.h"
 #include "sysemu/sysemu.h"
 #include "sysemu/runstate.h"
 #include "trace.h"
-- 
2.31.1

