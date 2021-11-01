Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3F3442312
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbhKAWMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:12:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20554 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232301AbhKAWME (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:12:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eb45pt+rx+z3d/QNqQ0ka/rPHoe06plBoXsL9wFgC3A=;
        b=XtbMSMGTQZvMco2cqRvB6sMNp2kXWpDgubhBSI/o3ct+u0hRuPelBE3jucBTFg1jjr/Why
        kLLoLyLGU6A1J7RIr1r7Aw5eUqFBllDRjog5qJtscdAYk0Pcq6YnQA8umpeYe5Vf8y85l5
        1KXLUFCxkvc4P7/ZD47YRfIPjKRP2l4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-lKL3UztbPJamlnoipeTKpA-1; Mon, 01 Nov 2021 18:09:29 -0400
X-MC-Unique: lKL3UztbPJamlnoipeTKpA-1
Received: by mail-wr1-f70.google.com with SMTP id a2-20020a5d4d42000000b0017b3bcf41b9so4041871wru.23
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:09:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eb45pt+rx+z3d/QNqQ0ka/rPHoe06plBoXsL9wFgC3A=;
        b=zn/3p2qRc6xzE9rQXZrT7C8eIZskzJGpDcYkMMjRN7JsD/ujhbKzgIwF4yVQnzu0K7
         uZDoh+nw3Z5+aiY1GPVAKdGJBiGSlX/q/WVx7Rf9ZIHWigXPMMk5Fhgj5iLSUTSLpKyr
         mPA/pzKA2kL2ZVmROxEfds4K2d9k2EPpD2pIH38/N3HtCOdlz0PHwX1GnRcdL91Rj/u+
         HZIs7RTQedboGqzktCwOBaN4SyYovhoZIUW46CfWhECZd48P7xsESAhzeoVXifK1wtU6
         sXqWMvfniNSmo3XaWb1+4MpDDUczLFEmUgi3bt4e9vU5wrVljaSO3TcHIbgg5EOV0RsR
         +EMg==
X-Gm-Message-State: AOAM531p7v/4Pe8lxLZLeS/xhW1HEiVi/euYg9CLP9Bph5tNmTkVySr4
        muNjIGfidDMXclXyivVdVZgBtYkj/AKi21me8S+Wnv3RSb/0Wu1CfGFGPIB6RlKg7v0u2mdGElO
        K0w+PzVCyi+2S
X-Received: by 2002:adf:e387:: with SMTP id e7mr30508145wrm.412.1635804567992;
        Mon, 01 Nov 2021 15:09:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTDcj674kEGI9dl471cqGKZI5Q3j6okD5bAskecUMcRegbtpEz5VGFYHzxKsv8krfzx5uJsg==
X-Received: by 2002:adf:e387:: with SMTP id e7mr30508114wrm.412.1635804567768;
        Mon, 01 Nov 2021 15:09:27 -0700 (PDT)
Received: from localhost (static-233-86-86-188.ipcom.comunitel.net. [188.86.86.233])
        by smtp.gmail.com with ESMTPSA id o17sm685550wmq.11.2021.11.01.15.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:09:27 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Markus Armbruster <armbru@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        xen-devel@lists.xenproject.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>
Subject: [PULL 10/20] dump-guest-memory: Block live migration
Date:   Mon,  1 Nov 2021 23:09:02 +0100
Message-Id: <20211101220912.10039-11-quintela@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101220912.10039-1-quintela@redhat.com>
References: <20211101220912.10039-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

Both dump-guest-memory and live migration caches vm state at the beginning.
Either of them entering the other one will cause race on the vm state, and even
more severe on that (please refer to the crash report in the bug link).

Let's block live migration in dump-guest-memory, and that'll also block
dump-guest-memory if it detected that we're during a live migration.

Side note: migrate_del_blocker() can be called even if the blocker is not
inserted yet, so it's safe to unconditionally delete that blocker in
dump_cleanup (g_slist_remove allows no-entry-found case).

Suggested-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1996609
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 dump/dump.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/dump/dump.c b/dump/dump.c
index ab625909f3..662d0a62cd 100644
--- a/dump/dump.c
+++ b/dump/dump.c
@@ -29,6 +29,7 @@
 #include "qemu/error-report.h"
 #include "qemu/main-loop.h"
 #include "hw/misc/vmcoreinfo.h"
+#include "migration/blocker.h"
 
 #ifdef TARGET_X86_64
 #include "win_dump.h"
@@ -47,6 +48,8 @@
 
 #define MAX_GUEST_NOTE_SIZE (1 << 20) /* 1MB should be enough */
 
+static Error *dump_migration_blocker;
+
 #define ELF_NOTE_SIZE(hdr_size, name_size, desc_size)   \
     ((DIV_ROUND_UP((hdr_size), 4) +                     \
       DIV_ROUND_UP((name_size), 4) +                    \
@@ -101,6 +104,7 @@ static int dump_cleanup(DumpState *s)
             qemu_mutex_unlock_iothread();
         }
     }
+    migrate_del_blocker(dump_migration_blocker);
 
     return 0;
 }
@@ -2005,6 +2009,21 @@ void qmp_dump_guest_memory(bool paging, const char *file,
         return;
     }
 
+    if (!dump_migration_blocker) {
+        error_setg(&dump_migration_blocker,
+                   "Live migration disabled: dump-guest-memory in progress");
+    }
+
+    /*
+     * Allows even for -only-migratable, but forbid migration during the
+     * process of dump guest memory.
+     */
+    if (migrate_add_blocker_internal(dump_migration_blocker, errp)) {
+        /* Remember to release the fd before passing it over to dump state */
+        close(fd);
+        return;
+    }
+
     s = &dump_state_global;
     dump_state_prepare(s);
 
-- 
2.33.1

