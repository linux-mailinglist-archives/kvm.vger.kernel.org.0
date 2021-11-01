Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117A0442311
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhKAWME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:12:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22877 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232286AbhKAWMC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:12:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xgA8Pg4pioYTYcQYYaUz2yN31K5Rcv8HQjmwYm8rweY=;
        b=P3PUolCz4j4ymEn/0u53vtsuTYUJ2crPH6lHWspESqFkkPYiBJ2ZFimpYFTl3CEJfed1b3
        eBQubuPdQ83yo3v71Fs0IpFQi52Qjmd4csSJO0cCyI+Cz6QL9ngRmga2MadZqlwu73xsUP
        DVjT94/OzHHw/2r3QDvTeIbtgrP7Aus=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-WU9L0UdqMl6_oHzTU09nEg-1; Mon, 01 Nov 2021 18:09:27 -0400
X-MC-Unique: WU9L0UdqMl6_oHzTU09nEg-1
Received: by mail-wm1-f71.google.com with SMTP id v10-20020a1cf70a000000b00318203a6bd1so225057wmh.6
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:09:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xgA8Pg4pioYTYcQYYaUz2yN31K5Rcv8HQjmwYm8rweY=;
        b=Kart1uZs+LnVn8mqImMpH4B+twY+kNGpJhSshWA1BZDUHX93gx5n7Tt2COyjMiKfsP
         CGqnzsz0O0rO8ZEeyn1TmC8LqYaaUCy2X9v711+UmL1gVGQYyCaqRX3klcIv5OwTny1w
         tH2AILOSriH8zU99pPn5mHk7VsMGOkk1wCcT8g4LHixvA8IrALGU31kYcpQo7C5PKWqb
         bmfa9ZeP4jwmD8cwlCyjrwgVto9SuZ/xXLwm3+NhUUm3TtQJb0B/qeYxJ0dwaccTB0N6
         cvyW2JyXOyDMQgpn2ezovYUT/TJnmDMKgmtGf1jFYc65xQJNJb0Fceu8Tg0ELHALwiLx
         qyaQ==
X-Gm-Message-State: AOAM5302hHtpTz7U5U7AsdGQ7UZI//P/20Kt05txr7/SXF8aGghBm2Kq
        M9NnxESdrVGvQ9shuG7/xwKv8bYjLXH1nw8b55V5r5WIUuLI01WUcl1yFhV9GsYQdfyckgsnDSH
        9AmV/2EfspKev
X-Received: by 2002:adf:c70b:: with SMTP id k11mr40015416wrg.154.1635804566477;
        Mon, 01 Nov 2021 15:09:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUrxZpRrNYU7lx4z1CYr7OY2cCtGorBz1ob+LkkuKyWgUku8HgKdZfOfBOrsPY7hoBqfW6RQ==
X-Received: by 2002:adf:c70b:: with SMTP id k11mr40015380wrg.154.1635804566314;
        Mon, 01 Nov 2021 15:09:26 -0700 (PDT)
Received: from localhost (static-233-86-86-188.ipcom.comunitel.net. [188.86.86.233])
        by smtp.gmail.com with ESMTPSA id u16sm620998wmc.21.2021.11.01.15.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:09:25 -0700 (PDT)
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
Subject: [PULL 09/20] migration: Add migrate_add_blocker_internal()
Date:   Mon,  1 Nov 2021 23:09:01 +0100
Message-Id: <20211101220912.10039-10-quintela@redhat.com>
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

An internal version that removes -only-migratable implications.  It can be used
for temporary migration blockers like dump-guest-memory.

Reviewed-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 include/migration/blocker.h | 16 ++++++++++++++++
 migration/migration.c       | 21 +++++++++++++--------
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/include/migration/blocker.h b/include/migration/blocker.h
index acd27018e9..9cebe2ba06 100644
--- a/include/migration/blocker.h
+++ b/include/migration/blocker.h
@@ -25,6 +25,22 @@
  */
 int migrate_add_blocker(Error *reason, Error **errp);
 
+/**
+ * @migrate_add_blocker_internal - prevent migration from proceeding without
+ *                                 only-migrate implications
+ *
+ * @reason - an error to be returned whenever migration is attempted
+ *
+ * @errp - [out] The reason (if any) we cannot block migration right now.
+ *
+ * @returns - 0 on success, -EBUSY on failure, with errp set.
+ *
+ * Some of the migration blockers can be temporary (e.g., for a few seconds),
+ * so it shouldn't need to conflict with "-only-migratable".  For those cases,
+ * we can call this function rather than @migrate_add_blocker().
+ */
+int migrate_add_blocker_internal(Error *reason, Error **errp);
+
 /**
  * @migrate_del_blocker - remove a blocking error from migration
  *
diff --git a/migration/migration.c b/migration/migration.c
index e81e473f5a..e1c0082530 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -2049,15 +2049,8 @@ void migrate_init(MigrationState *s)
     s->threshold_size = 0;
 }
 
-int migrate_add_blocker(Error *reason, Error **errp)
+int migrate_add_blocker_internal(Error *reason, Error **errp)
 {
-    if (only_migratable) {
-        error_propagate_prepend(errp, error_copy(reason),
-                                "disallowing migration blocker "
-                                "(--only-migratable) for: ");
-        return -EACCES;
-    }
-
     /* Snapshots are similar to migrations, so check RUN_STATE_SAVE_VM too. */
     if (runstate_check(RUN_STATE_SAVE_VM) || !migration_is_idle()) {
         error_propagate_prepend(errp, error_copy(reason),
@@ -2070,6 +2063,18 @@ int migrate_add_blocker(Error *reason, Error **errp)
     return 0;
 }
 
+int migrate_add_blocker(Error *reason, Error **errp)
+{
+    if (only_migratable) {
+        error_propagate_prepend(errp, error_copy(reason),
+                                "disallowing migration blocker "
+                                "(--only-migratable) for: ");
+        return -EACCES;
+    }
+
+    return migrate_add_blocker_internal(reason, errp);
+}
+
 void migrate_del_blocker(Error *reason)
 {
     migration_blockers = g_slist_remove(migration_blockers, reason);
-- 
2.33.1

