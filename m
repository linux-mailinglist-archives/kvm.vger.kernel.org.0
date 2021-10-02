Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FCB41FBE4
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbhJBMzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:55:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40314 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233217AbhJBMzc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:55:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l2pfbYxP1f86zn1O+UmnIVR/OdXuADklhW48W/+4agE=;
        b=aqg6YioDSz9T8fdJVEajRj/Bg407r39Yxyhf+f/6WrWD7SeXvgc56YjSY55iCUbbsZUT2d
        +7AXGu+/k3acMPBf+Aeke2BmKbC4XA/mOGksTviPb2TkxLlUEYxBcVo8b04EVg3p1WfTkI
        T4WyEOqDFS5OA+qwAHA6eTkwWPYxniM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-gF2vrlU6PzOodj88UH2LAg-1; Sat, 02 Oct 2021 08:53:43 -0400
X-MC-Unique: gF2vrlU6PzOodj88UH2LAg-1
Received: by mail-wm1-f70.google.com with SMTP id z137-20020a1c7e8f000000b0030cd1800d86so6075368wmc.2
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:53:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l2pfbYxP1f86zn1O+UmnIVR/OdXuADklhW48W/+4agE=;
        b=3kYS/eOPE9IdkKtKXDBG5menKxXPbsWSHnrbT+aAP6A8h5OI1MCBxzmMB3mmin13hv
         DmSjUbwR6c+9zWZJT36iKtVJ4bY2Z1XG1ggn07+YgcvkTgdb/EE7Ex8YCk6zmXokCZ+b
         6IPYDx+Ji3P+fxiH9CoeOLJIgEmWCrowEqRqxJ1qAg4tHZIHKZ3JZUDnbpifJQI2dCHT
         xaqi025WhpIQGUR51cNGY9+2h55ZifYtsHkAv3K3xj96TKZeZIkYKlQqnCsgKGyulVNk
         M+rjo5ah1XdIBOuo7fI2z8n8zDA2xqZyjjiRcbRLuW7Cp3uq+AfwUjjhV59GXBlC9HYr
         /KIg==
X-Gm-Message-State: AOAM532o6HSjU9i5Sz36cI5P8+p1gbtVKYMujSZuw6a3+G2WIi3sAjGk
        D+HP+A8vZ9Kgt0oOBSHyLvP1vmDyVy9oBXDw8wq++7CowB0Cs4imHclTnrjV1CUvNC6Hxk7E9RH
        dqNqA+6djqAgN
X-Received: by 2002:adf:b19b:: with SMTP id q27mr3023131wra.125.1633179222031;
        Sat, 02 Oct 2021 05:53:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0wFJ6jOD1dsu7MobrHxWDwOimiCMUGE3Wc9F0Vh2YBeD1QDrYkdFU3s2oEYQ/eTvQ2tlbQw==
X-Received: by 2002:adf:b19b:: with SMTP id q27mr3023109wra.125.1633179221880;
        Sat, 02 Oct 2021 05:53:41 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id l21sm1643231wmg.18.2021.10.02.05.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:53:41 -0700 (PDT)
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
Subject: [PATCH v3 05/22] target/i386/monitor: Return QMP error when SEV is disabled in build
Date:   Sat,  2 Oct 2021 14:53:00 +0200
Message-Id: <20211002125317.3418648-6-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the management layer tries to inject a secret, it gets an empty
response in case the binary built without SEV:

  { "execute": "sev-inject-launch-secret",
    "arguments": { "packet-header": "mypkt", "secret": "mypass", "gpa": 4294959104 }
  }
  {
      "return": {
      }
  }

Make it clearer by returning an error, mentioning the feature is
disabled:

  { "execute": "sev-inject-launch-secret",
    "arguments": { "packet-header": "mypkt", "secret": "mypass", "gpa": 4294959104 }
  }
  {
      "error": {
          "class": "GenericError",
          "desc": "this feature or command is not currently supported"
      }
  }

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/monitor.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index 196c1c9e77f..a9f85acd473 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -28,6 +28,7 @@
 #include "monitor/hmp-target.h"
 #include "monitor/hmp.h"
 #include "qapi/qmp/qdict.h"
+#include "qapi/qmp/qerror.h"
 #include "sysemu/kvm.h"
 #include "sysemu/sev.h"
 #include "qapi/error.h"
@@ -743,6 +744,10 @@ void qmp_sev_inject_launch_secret(const char *packet_hdr,
                                   bool has_gpa, uint64_t gpa,
                                   Error **errp)
 {
+    if (!sev_enabled()) {
+        error_setg(errp, QERR_UNSUPPORTED);
+        return;
+    }
     if (!has_gpa) {
         uint8_t *data;
         struct sev_secret_area *area;
-- 
2.31.1

