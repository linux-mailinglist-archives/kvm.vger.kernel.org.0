Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91B742579B
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242276AbhJGQTr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:19:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60295 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242137AbhJGQTq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:19:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o9lSbhoBJitVWDueMdjjLMLVkRSyu1rE4Rg4emr9Ei8=;
        b=EgiSN7afQ9YrQfbS8IcCr1jR+5tDaM1y0lhmGBtjg1vkBMns7Yp/hrQJuOUmFG5gU1DHnj
        GHSb5LJ33q8LfVBGL30K81jueHMAq5O+DjdrrR88mY9qTcLsjqqO8VUi1ARr/GqoI5Kwkk
        Lo8iuBDttGiKv4+mOgO13FsNzn2IIWY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-i2YHKKDhPBK8T3Muj8-dmA-1; Thu, 07 Oct 2021 12:17:48 -0400
X-MC-Unique: i2YHKKDhPBK8T3Muj8-dmA-1
Received: by mail-wr1-f69.google.com with SMTP id r16-20020adfb1d0000000b00160bf8972ceso5116153wra.13
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:17:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o9lSbhoBJitVWDueMdjjLMLVkRSyu1rE4Rg4emr9Ei8=;
        b=D0tLcFPb8ml/FaQHzzFi9cqhC5dEngi+8gU19LyYKRo6i6+8BdPuc2pYisc7zq7NYs
         coQqnV7YV+gObyipvdDw2CRwowW4einei6TdFqFIS1Lnk81wNZvXj46Q3mx3XWi3WBJW
         QQPgGnxdMVjPVBoTnx1YmHuifrz075glisN4BaFJS2PONLhvYzCzcBGJsnY9mL9iSmzj
         aTE3FGB0sDjDc8nCpuzcGMco1daYD2w5s2tPt7N3oOpcucrcanhb7zh6Dqt4SeEqQ+JC
         kxzT6ut18NMaIaidWSxuXTEe5DsxkWI/U8bO68QjiGfu7GAywEJpxfNduQDvZbelJCIw
         lggw==
X-Gm-Message-State: AOAM5311ZRAZ0QKr3SJn6+nqGLldPkKUlp7+9dX0wUK3+PmQwSqxjH6P
        +Rj4hVgCTo+vflAfikWjFGb0izSFWfxGQj9s0HbA/tm7IPj9UEBsuyAkT/yFM39q+N/RtdVaL6u
        p3Q/h0CzuUxGG
X-Received: by 2002:a05:6000:550:: with SMTP id b16mr6795173wrf.297.1633623466007;
        Thu, 07 Oct 2021 09:17:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnfMiJdq3t4lKJrJn6gn2ZgOjVVHTpcfnmUwoUkpuTzHD+tLUzVsylqOO/srQz9P+TjP4dcA==
X-Received: by 2002:a05:6000:550:: with SMTP id b16mr6795160wrf.297.1633623465856;
        Thu, 07 Oct 2021 09:17:45 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id x15sm51076wrl.74.2021.10.07.09.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:17:45 -0700 (PDT)
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
Subject: [PATCH v4 06/23] target/i386/monitor: Return QMP error when SEV is not enabled for guest
Date:   Thu,  7 Oct 2021 18:16:59 +0200
Message-Id: <20211007161716.453984-7-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the management layer tries to inject a secret, it gets an empty
response in case the guest doesn't have SEV enabled, or the binary
is built without SEV:

  { "execute": "sev-inject-launch-secret",
    "arguments": { "packet-header": "mypkt", "secret": "mypass", "gpa": 4294959104 }
  }
  {
      "return": {
      }
  }

Make it clearer by returning an error:

  { "execute": "sev-inject-launch-secret",
    "arguments": { "packet-header": "mypkt", "secret": "mypass", "gpa": 4294959104 }
  }
  {
      "error": {
          "class": "GenericError",
          "desc": "SEV not enabled for guest"
      }
  }

Note: we will remove the sev_inject_launch_secret() stub in few commits,
      so we don't bother to add error_setg() there.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/monitor.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index eabbeb9be95..ea836678f51 100644
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
+        error_setg(errp, "SEV not enabled for guest");
+        return;
+    }
     if (!has_gpa) {
         uint8_t *data;
         struct sev_secret_area *area;
-- 
2.31.1

