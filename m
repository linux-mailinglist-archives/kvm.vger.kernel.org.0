Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA69693C93
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjBMCx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjBMCxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:53:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6D310A81
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676256738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HIGquDGecZVqlPAzTK4Da5XIicRI3uO45jZdci3i9h8=;
        b=QqQXmZMr0P9wX/iN4UCItIpmVo3JhzCve2yTfNus3Ugv7QWseb5/1hgugsIOkh9THhYmjj
        fDnRePf5VyyOKHDeVBFmFpR7nnQU1eiVWJypv4WSiQHUlKgRZ1slWF8veN34HVO57AOD3t
        hJ3DDYJjJoIYO+DUPOhVw0r7l2eFX/I=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-474-bFCxyip8N226JU3XRs_YOg-1; Sun, 12 Feb 2023 21:52:17 -0500
X-MC-Unique: bFCxyip8N226JU3XRs_YOg-1
Received: by mail-wm1-f69.google.com with SMTP id a20-20020a05600c349400b003dfecb98d38so8412600wmq.0
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HIGquDGecZVqlPAzTK4Da5XIicRI3uO45jZdci3i9h8=;
        b=hnRXTb/5QBT7asRZBGbXP+m7T6MTj1rH+1sogKTpmxC1nbIqKhoNln3bApCB9AC8zs
         H1qjo9lXmyOQyuzz2+ixARjLRa206s+UXx4ZlrmEBoEa95fQjEh7KM2rbhmgV+qJerZE
         Uuy7fdM1Bqve/zHqN0RZMe+Bq9JrX4dI1eGlCuuAmqCAmG4hBRpfsi/45lAkhUGE5++c
         sh7sCNPHf8x00BAAkR2Qval8wap0nP5Zr6/0ibjZ1qP2s2mdcRWVk82yiLEo7+oAPtR4
         bGL5nKcrDZOoEF0dxqvmep6zS371e9gvoQoc1kpKyVQyq7yJoG/dZJAzUZ2NgpmWwJ0t
         0Tyg==
X-Gm-Message-State: AO0yUKXQsB5E/v9STA4vyn4vJbw+kfuEoqLNC/He3vCxlopoSgFnY0wG
        dT/AvQi6Y99rubazyoejBzXEXgrJ81tFbmmww8GUUcoIP2w8NtkA8PeanntfF2mipmj24rDD4yk
        ZOMSTlryUUN2p
X-Received: by 2002:a05:600c:4383:b0:3dc:d5b:5f73 with SMTP id e3-20020a05600c438300b003dc0d5b5f73mr17561670wmn.19.1676256736451;
        Sun, 12 Feb 2023 18:52:16 -0800 (PST)
X-Google-Smtp-Source: AK7set9uTYw0YMPjdraB/O/CdQZgZ6qIH3EgR32xo2m4xPkJvDzW8J0Vh/esH1OEvdrhu530+/1gIg==
X-Received: by 2002:a05:600c:4383:b0:3dc:d5b:5f73 with SMTP id e3-20020a05600c438300b003dc0d5b5f73mr17561660wmn.19.1676256736224;
        Sun, 12 Feb 2023 18:52:16 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id o32-20020a05600c512000b003e0238d9101sm13949575wms.31.2023.02.12.18.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:52:15 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PULL 14/22] migration: Rework multi-channel checks on URI
Date:   Mon, 13 Feb 2023 03:51:42 +0100
Message-Id: <20230213025150.71537-15-quintela@redhat.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213025150.71537-1-quintela@redhat.com>
References: <20230213025150.71537-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

The whole idea of multi-channel checks was not properly done, IMHO.

Currently we check multi-channel in a lot of places, but actually that's
not needed because we only need to check it right after we get the URI and
that should be it.

If the URI check succeeded, we should never need to check it again because
we must have it.  If it check fails, we should fail immediately on either
the qmp_migrate or qmp_migrate_incoming, instead of failingg it later after
the connection established.

Neither should we fail any set capabiliities like what we used to do here:

5ad15e8614 ("migration: allow enabling mutilfd for specific protocol only", 2021-10-19)

Because logically the URI will only be set later after the capability is
set, so it doesn't make a lot of sense to check the URI type when setting
the capability, because we're checking the cap with an old URI passed in,
and that may not even be the URI we're going to use later.

This patch mostly reverted all such checks for before, dropping the
variable migrate_allow_multi_channels and helpers.  Instead, add a common
helper to check URI for multi-channels for either qmp_migrate and
qmp_migrate_incoming and that should do all the proper checks.  The failure
will only trigger with the "migrate" or "migrate_incoming" command, or when
user specified "-incoming xxx" where "xxx" is not "defer".

Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/migration.h    |  3 ---
 migration/migration.c    | 49 +++++++++++++++++++++-------------------
 migration/multifd.c      | 12 ++--------
 migration/postcopy-ram.c |  6 -----
 4 files changed, 28 insertions(+), 42 deletions(-)

diff --git a/migration/migration.h b/migration/migration.h
index 66511ce532..c351872360 100644
--- a/migration/migration.h
+++ b/migration/migration.h
@@ -474,7 +474,4 @@ void migration_cancel(const Error *error);
 void populate_vfio_info(MigrationInfo *info);
 void postcopy_temp_page_reset(PostcopyTmpPage *tmp_page);
 
-bool migrate_multi_channels_is_allowed(void);
-void migrate_protocol_allow_multi_channels(bool allow);
-
 #endif
diff --git a/migration/migration.c b/migration/migration.c
index 7a14aa98d8..f242d657e8 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -184,16 +184,27 @@ static int migration_maybe_pause(MigrationState *s,
                                  int new_state);
 static void migrate_fd_cancel(MigrationState *s);
 
-static bool migrate_allow_multi_channels = true;
+static bool migration_needs_multiple_sockets(void)
+{
+    return migrate_use_multifd() || migrate_postcopy_preempt();
+}
 
-void migrate_protocol_allow_multi_channels(bool allow)
+static bool uri_supports_multi_channels(const char *uri)
 {
-    migrate_allow_multi_channels = allow;
+    return strstart(uri, "tcp:", NULL) || strstart(uri, "unix:", NULL) ||
+           strstart(uri, "vsock:", NULL);
 }
 
-bool migrate_multi_channels_is_allowed(void)
+static bool
+migration_channels_and_uri_compatible(const char *uri, Error **errp)
 {
-    return migrate_allow_multi_channels;
+    if (migration_needs_multiple_sockets() &&
+        !uri_supports_multi_channels(uri)) {
+        error_setg(errp, "Migration requires multi-channel URIs (e.g. tcp)");
+        return false;
+    }
+
+    return true;
 }
 
 static gint page_request_addr_cmp(gconstpointer ap, gconstpointer bp)
@@ -493,12 +504,15 @@ static void qemu_start_incoming_migration(const char *uri, Error **errp)
 {
     const char *p = NULL;
 
-    migrate_protocol_allow_multi_channels(false); /* reset it anyway */
+    /* URI is not suitable for migration? */
+    if (!migration_channels_and_uri_compatible(uri, errp)) {
+        return;
+    }
+
     qapi_event_send_migration(MIGRATION_STATUS_SETUP);
     if (strstart(uri, "tcp:", &p) ||
         strstart(uri, "unix:", NULL) ||
         strstart(uri, "vsock:", NULL)) {
-        migrate_protocol_allow_multi_channels(true);
         socket_start_incoming_migration(p ? p : uri, errp);
 #ifdef CONFIG_RDMA
     } else if (strstart(uri, "rdma:", &p)) {
@@ -723,11 +737,6 @@ void migration_fd_process_incoming(QEMUFile *f, Error **errp)
     migration_incoming_process();
 }
 
-static bool migration_needs_multiple_sockets(void)
-{
-    return migrate_use_multifd() || migrate_postcopy_preempt();
-}
-
 void migration_ioc_process_incoming(QIOChannel *ioc, Error **errp)
 {
     MigrationIncomingState *mis = migration_incoming_get_current();
@@ -1378,15 +1387,6 @@ static bool migrate_caps_check(bool *cap_list,
     }
 #endif
 
-
-    /* incoming side only */
-    if (runstate_check(RUN_STATE_INMIGRATE) &&
-        !migrate_multi_channels_is_allowed() &&
-        cap_list[MIGRATION_CAPABILITY_MULTIFD]) {
-        error_setg(errp, "multifd is not supported by current protocol");
-        return false;
-    }
-
     if (cap_list[MIGRATION_CAPABILITY_POSTCOPY_PREEMPT]) {
         if (!cap_list[MIGRATION_CAPABILITY_POSTCOPY_RAM]) {
             error_setg(errp, "Postcopy preempt requires postcopy-ram");
@@ -2471,6 +2471,11 @@ void qmp_migrate(const char *uri, bool has_blk, bool blk,
     MigrationState *s = migrate_get_current();
     const char *p = NULL;
 
+    /* URI is not suitable for migration? */
+    if (!migration_channels_and_uri_compatible(uri, errp)) {
+        return;
+    }
+
     if (!migrate_prepare(s, has_blk && blk, has_inc && inc,
                          has_resume && resume, errp)) {
         /* Error detected, put into errp */
@@ -2483,11 +2488,9 @@ void qmp_migrate(const char *uri, bool has_blk, bool blk,
         }
     }
 
-    migrate_protocol_allow_multi_channels(false);
     if (strstart(uri, "tcp:", &p) ||
         strstart(uri, "unix:", NULL) ||
         strstart(uri, "vsock:", NULL)) {
-        migrate_protocol_allow_multi_channels(true);
         socket_start_outgoing_migration(s, p ? p : uri, &local_err);
 #ifdef CONFIG_RDMA
     } else if (strstart(uri, "rdma:", &p)) {
diff --git a/migration/multifd.c b/migration/multifd.c
index 7aa030fb19..99a59830c8 100644
--- a/migration/multifd.c
+++ b/migration/multifd.c
@@ -516,7 +516,7 @@ void multifd_save_cleanup(void)
 {
     int i;
 
-    if (!migrate_use_multifd() || !migrate_multi_channels_is_allowed()) {
+    if (!migrate_use_multifd()) {
         return;
     }
     multifd_send_terminate_threads(NULL);
@@ -913,10 +913,6 @@ int multifd_save_setup(Error **errp)
     if (!migrate_use_multifd()) {
         return 0;
     }
-    if (!migrate_multi_channels_is_allowed()) {
-        error_setg(errp, "multifd is not supported by current protocol");
-        return -1;
-    }
 
     thread_count = migrate_multifd_channels();
     multifd_send_state = g_malloc0(sizeof(*multifd_send_state));
@@ -1021,7 +1017,7 @@ int multifd_load_cleanup(Error **errp)
 {
     int i;
 
-    if (!migrate_use_multifd() || !migrate_multi_channels_is_allowed()) {
+    if (!migrate_use_multifd()) {
         return 0;
     }
     multifd_recv_terminate_threads(NULL);
@@ -1172,10 +1168,6 @@ int multifd_load_setup(Error **errp)
         return 0;
     }
 
-    if (!migrate_multi_channels_is_allowed()) {
-        error_setg(errp, "multifd is not supported by current protocol");
-        return -1;
-    }
     thread_count = migrate_multifd_channels();
     multifd_recv_state = g_malloc0(sizeof(*multifd_recv_state));
     multifd_recv_state->params = g_new0(MultiFDRecvParams, thread_count);
diff --git a/migration/postcopy-ram.c b/migration/postcopy-ram.c
index 53299b7a5e..9a9d0ecf49 100644
--- a/migration/postcopy-ram.c
+++ b/migration/postcopy-ram.c
@@ -1635,12 +1635,6 @@ int postcopy_preempt_setup(MigrationState *s, Error **errp)
         return 0;
     }
 
-    if (!migrate_multi_channels_is_allowed()) {
-        error_setg(errp, "Postcopy preempt is not supported as current "
-                   "migration stream does not support multi-channels.");
-        return -1;
-    }
-
     /* Kick an async task to connect */
     socket_send_channel_create(postcopy_preempt_send_channel_new, s);
 
-- 
2.39.1

