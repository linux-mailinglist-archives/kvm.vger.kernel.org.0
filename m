Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159E3442310
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbhKAWMC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:12:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25237 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232274AbhKAWMB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:12:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GGo9WanuJU04tuhhnw4peEWGOBw6c3WDbeGbMBl0UrM=;
        b=CxE49QFwEnLn5ozH0njoOjqV0y/Y9CbD0DHU97jOrCpeiZ73tHyjt2KFCAkRCrotaFm8PT
        IOP4IFxlq+NBRFVWHQC+dynHM0bhn+EQJe3r+cRU1Sr4oouxMZaZK6gT+ZwT4lBt5cvNBf
        w9Cl+GmwmkIY40c9fqDupbx4Sf43htg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-bqdmTDkaNT-hYX3127zj0w-1; Mon, 01 Nov 2021 18:09:26 -0400
X-MC-Unique: bqdmTDkaNT-hYX3127zj0w-1
Received: by mail-wr1-f70.google.com with SMTP id q7-20020adff507000000b0017d160d35a8so3583015wro.4
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:09:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GGo9WanuJU04tuhhnw4peEWGOBw6c3WDbeGbMBl0UrM=;
        b=1fvSLUAEgzFXsMomsuevXLg9q5DjSMPKHLi6TWnRk0TiI3K9Wvv5l/BVOmcksguhZR
         lcHCbpbFqYwbz9PGCeDszaZbcY/PFzIQcZq+9B6eJ7jf4/Rv6CsFgWGEQak0KDXbAsSq
         bkxFApumSNPud1D9VZzcnsn2/Ik6vZPw6vja20MHbSkAwLrFogLGpdeIVxx/BY2W6uU6
         mzu4q5F4fXxJJltjqTSVyFMNECbkYFtggTejZFUGp/35RNl4t7Ga/NXzZrZkySxQwTJz
         LwGTsXaZB6G+jEn4tEYN+tdmIgCbXN29gICygo3R+7xUrhIlNfd/0/s792prLb/gtXQN
         IfaA==
X-Gm-Message-State: AOAM532TXYwfBmrxmSV8McHbvFKdbAkBdoVnb8O9Qsrsw3Yh6gUZ+WRd
        /WGinERpiCzJqWOnaMKBCk6Q9tx0ribZ40OZWdsn9YPXjx8mfR9fd5FHvUzZMdIiVesz6zVSQvQ
        CZvU2QDi2i40+
X-Received: by 2002:a1c:7e41:: with SMTP id z62mr1955940wmc.9.1635804565092;
        Mon, 01 Nov 2021 15:09:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpSY2086+CnGB9WPrHW5bo96aeVOpNDlLfr+WAapyjvAt6zv6pqshWIvxGHLts1sX02fyU2g==
X-Received: by 2002:a1c:7e41:: with SMTP id z62mr1955923wmc.9.1635804564942;
        Mon, 01 Nov 2021 15:09:24 -0700 (PDT)
Received: from localhost (static-233-86-86-188.ipcom.comunitel.net. [188.86.86.233])
        by smtp.gmail.com with ESMTPSA id o17sm685487wmq.11.2021.11.01.15.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:09:24 -0700 (PDT)
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
Subject: [PULL 08/20] migration: Make migration blocker work for snapshots too
Date:   Mon,  1 Nov 2021 23:09:00 +0100
Message-Id: <20211101220912.10039-9-quintela@redhat.com>
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

save_snapshot() checks migration blocker, which looks sane.  At the meantime we
should also teach the blocker add helper to fail if during a snapshot, just
like for migrations.

Reviewed-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/migration.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/migration/migration.c b/migration/migration.c
index 9172686b89..e81e473f5a 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -2058,15 +2058,16 @@ int migrate_add_blocker(Error *reason, Error **errp)
         return -EACCES;
     }
 
-    if (migration_is_idle()) {
-        migration_blockers = g_slist_prepend(migration_blockers, reason);
-        return 0;
+    /* Snapshots are similar to migrations, so check RUN_STATE_SAVE_VM too. */
+    if (runstate_check(RUN_STATE_SAVE_VM) || !migration_is_idle()) {
+        error_propagate_prepend(errp, error_copy(reason),
+                                "disallowing migration blocker "
+                                "(migration/snapshot in progress) for: ");
+        return -EBUSY;
     }
 
-    error_propagate_prepend(errp, error_copy(reason),
-                            "disallowing migration blocker "
-                            "(migration in progress) for: ");
-    return -EBUSY;
+    migration_blockers = g_slist_prepend(migration_blockers, reason);
+    return 0;
 }
 
 void migrate_del_blocker(Error *reason)
-- 
2.33.1

