Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B566914B3
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 00:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbjBIXhZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 18:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjBIXhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 18:37:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8A46E9A6
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 15:35:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675985711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jra5L+q+fwbERxylIBvIFg8T16r+MQ4cEjJ+sgpzLz8=;
        b=UdWMrGeGWZ2cncIqwa8yykzlNC71mHrcuYzyn0U/vUPzE7CKPIHoGQfaDPEdQ6DE7N8ou6
        3YvyinJT4jiR7Vy/WMAOMpFopmox3g+gr3WAHZIm2sBRJV9mlK+Z7+jzQEJ0fPJm6lrwhv
        tV4Pz8evIwlf7+nE5fJ1g+CZZ61M4ck=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-94-y6eFoyzLMkm_nlTNuuOxVg-1; Thu, 09 Feb 2023 18:35:08 -0500
X-MC-Unique: y6eFoyzLMkm_nlTNuuOxVg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4129980D0E2;
        Thu,  9 Feb 2023 23:35:08 +0000 (UTC)
Received: from secure.mitica (unknown [10.39.192.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B1A9440BC;
        Thu,  9 Feb 2023 23:35:06 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PULL 17/17] migration: Postpone postcopy preempt channel to be after main
Date:   Fri, 10 Feb 2023 00:34:26 +0100
Message-Id: <20230209233426.37811-18-quintela@redhat.com>
In-Reply-To: <20230209233426.37811-1-quintela@redhat.com>
References: <20230209233426.37811-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

Postcopy with preempt-mode enabled needs two channels to communicate.  The
order of channel establishment is not guaranteed.  It can happen that the
dest QEMU got the preempt channel connection request before the main
channel is established, then the migration may make no progress even during
precopy due to the wrong order.

To fix it, create the preempt channel only if we know the main channel is
established.

For a general postcopy migration, we delay it until postcopy_start(),
that's where we already went through some part of precopy on the main
channel.  To make sure dest QEMU has already established the channel, we
wait until we got the first PONG received.  That's something we do at the
start of precopy when postcopy enabled so it's guaranteed to happen sooner
or later.

For a postcopy recovery, we delay it to qemu_savevm_state_resume_prepare()
where we'll have round trips of data on bitmap synchronizations, which
means the main channel must have been established.

Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/migration.h    |  6 ++++
 migration/postcopy-ram.h |  2 +-
 migration/migration.c    | 72 ++++++++++++++++++++++++++++++----------
 migration/postcopy-ram.c | 17 ++++++++--
 migration/savevm.c       |  6 +++-
 5 files changed, 82 insertions(+), 21 deletions(-)

diff --git a/migration/migration.h b/migration/migration.h
index 4cb1cb6fa8..2da2f8a164 100644
--- a/migration/migration.h
+++ b/migration/migration.h
@@ -116,6 +116,12 @@ struct MigrationIncomingState {
     unsigned int postcopy_channels;
     /* QEMUFile for postcopy only; it'll be handled by a separate thread */
     QEMUFile *postcopy_qemufile_dst;
+    /*
+     * When postcopy_qemufile_dst is properly setup, this sem is posted.
+     * One can wait on this semaphore to wait until the preempt channel is
+     * properly setup.
+     */
+    QemuSemaphore postcopy_qemufile_dst_done;
     /* Postcopy priority thread is used to receive postcopy requested pages */
     QemuThread postcopy_prio_thread;
     bool postcopy_prio_thread_created;
diff --git a/migration/postcopy-ram.h b/migration/postcopy-ram.h
index d5604cbcf1..b4867a32d5 100644
--- a/migration/postcopy-ram.h
+++ b/migration/postcopy-ram.h
@@ -192,6 +192,6 @@ enum PostcopyChannels {
 
 void postcopy_preempt_new_channel(MigrationIncomingState *mis, QEMUFile *file);
 void postcopy_preempt_setup(MigrationState *s);
-int postcopy_preempt_wait_channel(MigrationState *s);
+int postcopy_preempt_establish_channel(MigrationState *s);
 
 #endif
diff --git a/migration/migration.c b/migration/migration.c
index a2e362541d..a5c22e327d 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -235,6 +235,8 @@ void migration_object_init(void)
     qemu_sem_init(&current_incoming->postcopy_pause_sem_dst, 0);
     qemu_sem_init(&current_incoming->postcopy_pause_sem_fault, 0);
     qemu_sem_init(&current_incoming->postcopy_pause_sem_fast_load, 0);
+    qemu_sem_init(&current_incoming->postcopy_qemufile_dst_done, 0);
+
     qemu_mutex_init(&current_incoming->page_request_mutex);
     current_incoming->page_requested = g_tree_new(page_request_addr_cmp);
 
@@ -737,6 +739,31 @@ void migration_fd_process_incoming(QEMUFile *f, Error **errp)
     migration_incoming_process();
 }
 
+/*
+ * Returns true when we want to start a new incoming migration process,
+ * false otherwise.
+ */
+static bool migration_should_start_incoming(bool main_channel)
+{
+    /* Multifd doesn't start unless all channels are established */
+    if (migrate_use_multifd()) {
+        return migration_has_all_channels();
+    }
+
+    /* Preempt channel only starts when the main channel is created */
+    if (migrate_postcopy_preempt()) {
+        return main_channel;
+    }
+
+    /*
+     * For all the rest types of migration, we should only reach here when
+     * it's the main channel that's being created, and we should always
+     * proceed with this channel.
+     */
+    assert(main_channel);
+    return true;
+}
+
 void migration_ioc_process_incoming(QIOChannel *ioc, Error **errp)
 {
     MigrationIncomingState *mis = migration_incoming_get_current();
@@ -798,7 +825,7 @@ void migration_ioc_process_incoming(QIOChannel *ioc, Error **errp)
         }
     }
 
-    if (migration_has_all_channels()) {
+    if (migration_should_start_incoming(default_channel)) {
         /* If it's a recovery, we're done */
         if (postcopy_try_recover()) {
             return;
@@ -3159,6 +3186,13 @@ static int await_return_path_close_on_source(MigrationState *ms)
     return ms->rp_state.error;
 }
 
+static inline void
+migration_wait_main_channel(MigrationState *ms)
+{
+    /* Wait until one PONG message received */
+    qemu_sem_wait(&ms->rp_state.rp_pong_acks);
+}
+
 /*
  * Switch from normal iteration to postcopy
  * Returns non-0 on error
@@ -3173,9 +3207,12 @@ static int postcopy_start(MigrationState *ms)
     bool restart_block = false;
     int cur_state = MIGRATION_STATUS_ACTIVE;
 
-    if (postcopy_preempt_wait_channel(ms)) {
-        migrate_set_state(&ms->state, ms->state, MIGRATION_STATUS_FAILED);
-        return -1;
+    if (migrate_postcopy_preempt()) {
+        migration_wait_main_channel(ms);
+        if (postcopy_preempt_establish_channel(ms)) {
+            migrate_set_state(&ms->state, ms->state, MIGRATION_STATUS_FAILED);
+            return -1;
+        }
     }
 
     if (!migrate_pause_before_switchover()) {
@@ -3586,6 +3623,20 @@ static int postcopy_do_resume(MigrationState *s)
         return ret;
     }
 
+    /*
+     * If preempt is enabled, re-establish the preempt channel.  Note that
+     * we do it after resume prepare to make sure the main channel will be
+     * created before the preempt channel.  E.g. with weak network, the
+     * dest QEMU may get messed up with the preempt and main channels on
+     * the order of connection setup.  This guarantees the correct order.
+     */
+    ret = postcopy_preempt_establish_channel(s);
+    if (ret) {
+        error_report("%s: postcopy_preempt_establish_channel(): %d",
+                     __func__, ret);
+        return ret;
+    }
+
     /*
      * Last handshake with destination on the resume (destination will
      * switch to postcopy-active afterwards)
@@ -3647,14 +3698,6 @@ static MigThrError postcopy_pause(MigrationState *s)
         if (s->state == MIGRATION_STATUS_POSTCOPY_RECOVER) {
             /* Woken up by a recover procedure. Give it a shot */
 
-            if (postcopy_preempt_wait_channel(s)) {
-                /*
-                 * Preempt enabled, and new channel create failed; loop
-                 * back to wait for another recovery.
-                 */
-                continue;
-            }
-
             /*
              * Firstly, let's wake up the return path now, with a new
              * return path channel.
@@ -4347,11 +4390,6 @@ void migrate_fd_connect(MigrationState *s, Error *error_in)
         }
     }
 
-    /* This needs to be done before resuming a postcopy */
-    if (migrate_postcopy_preempt()) {
-        postcopy_preempt_setup(s);
-    }
-
     if (resume) {
         /* Wakeup the main migration thread to do the recovery */
         migrate_set_state(&s->state, MIGRATION_STATUS_POSTCOPY_PAUSED,
diff --git a/migration/postcopy-ram.c b/migration/postcopy-ram.c
index de6d4a3fd4..f54f44d899 100644
--- a/migration/postcopy-ram.c
+++ b/migration/postcopy-ram.c
@@ -1197,6 +1197,11 @@ int postcopy_ram_incoming_setup(MigrationIncomingState *mis)
     }
 
     if (migrate_postcopy_preempt()) {
+        /*
+         * The preempt channel is established in asynchronous way.  Wait
+         * for its completion.
+         */
+        qemu_sem_wait(&mis->postcopy_qemufile_dst_done);
         /*
          * This thread needs to be created after the temp pages because
          * it'll fetch RAM_CHANNEL_POSTCOPY PostcopyTmpPage immediately.
@@ -1544,6 +1549,7 @@ void postcopy_preempt_new_channel(MigrationIncomingState *mis, QEMUFile *file)
      */
     qemu_file_set_blocking(file, true);
     mis->postcopy_qemufile_dst = file;
+    qemu_sem_post(&mis->postcopy_qemufile_dst_done);
     trace_postcopy_preempt_new_channel();
 }
 
@@ -1612,14 +1618,21 @@ out:
     postcopy_preempt_send_channel_done(s, ioc, local_err);
 }
 
-/* Returns 0 if channel established, -1 for error. */
-int postcopy_preempt_wait_channel(MigrationState *s)
+/*
+ * This function will kick off an async task to establish the preempt
+ * channel, and wait until the connection setup completed.  Returns 0 if
+ * channel established, -1 for error.
+ */
+int postcopy_preempt_establish_channel(MigrationState *s)
 {
     /* If preempt not enabled, no need to wait */
     if (!migrate_postcopy_preempt()) {
         return 0;
     }
 
+    /* Kick off async task to establish preempt channel */
+    postcopy_preempt_setup(s);
+
     /*
      * We need the postcopy preempt channel to be established before
      * starting doing anything.
diff --git a/migration/savevm.c b/migration/savevm.c
index ce181e21e1..b5e6962bb6 100644
--- a/migration/savevm.c
+++ b/migration/savevm.c
@@ -2200,7 +2200,11 @@ static int loadvm_postcopy_handle_resume(MigrationIncomingState *mis)
     qemu_sem_post(&mis->postcopy_pause_sem_fault);
 
     if (migrate_postcopy_preempt()) {
-        /* The channel should already be setup again; make sure of it */
+        /*
+         * The preempt channel will be created in async manner, now let's
+         * wait for it and make sure it's created.
+         */
+        qemu_sem_wait(&mis->postcopy_qemufile_dst_done);
         assert(mis->postcopy_qemufile_dst);
         /* Kick the fast ram load thread too */
         qemu_sem_post(&mis->postcopy_pause_sem_fast_load);
-- 
2.39.1

