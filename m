Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5B7379330
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 17:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbhEJP5D convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 10 May 2021 11:57:03 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:52650 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230492AbhEJP5B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 11:57:01 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-cfmBLbnrNRe3SC-TApJOzA-1; Mon, 10 May 2021 11:55:51 -0400
X-MC-Unique: cfmBLbnrNRe3SC-TApJOzA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 763616408E;
        Mon, 10 May 2021 15:55:49 +0000 (UTC)
Received: from bahia.redhat.com (ovpn-112-152.ams2.redhat.com [10.36.112.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 271A519C44;
        Mon, 10 May 2021 15:55:46 +0000 (UTC)
From:   Greg Kurz <groug@kaod.org>
To:     qemu-devel@nongnu.org
Cc:     Vivek Goyal <vgoyal@redhat.com>, virtio-fs@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>, Greg Kurz <groug@kaod.org>
Subject: [for-6.1 v3 2/3] virtiofsd: Track mounts
Date:   Mon, 10 May 2021 17:55:38 +0200
Message-Id: <20210510155539.998747-3-groug@kaod.org>
In-Reply-To: <20210510155539.998747-1-groug@kaod.org>
References: <20210510155539.998747-1-groug@kaod.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=groug@kaod.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kaod.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The upcoming implementation of ->sync_fs() needs to know about all
submounts in order to call syncfs() on all of them.

Track every inode that comes up with a new mount id in a GHashTable.
If the mount id isn't available, e.g. no statx() on the host, fallback
on the device id for the key. This is done during lookup because we
only care for the submounts that the client knows about. The inode
is removed from the hash table when ultimately unreferenced. This
can happen on a per-mount basis when the client posts a FUSE_FORGET
request or for all submounts at once with FUSE_DESTROY.

Signed-off-by: Greg Kurz <groug@kaod.org>
---
 tools/virtiofsd/passthrough_ll.c | 42 +++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 1553d2ef454f..dc940a1d048b 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -117,6 +117,7 @@ struct lo_inode {
     GHashTable *posix_locks; /* protected by lo_inode->plock_mutex */
 
     mode_t filetype;
+    bool is_mnt;
 };
 
 struct lo_cred {
@@ -163,6 +164,7 @@ struct lo_data {
     bool use_statx;
     struct lo_inode root;
     GHashTable *inodes; /* protected by lo->mutex */
+    GHashTable *mnt_inodes; /* protected by lo->mutex */
     struct lo_map ino_map; /* protected by lo->mutex */
     struct lo_map dirp_map; /* protected by lo->mutex */
     struct lo_map fd_map; /* protected by lo->mutex */
@@ -968,6 +970,31 @@ static int do_statx(struct lo_data *lo, int dirfd, const char *pathname,
     return 0;
 }
 
+static uint64_t mnt_inode_key(struct lo_inode *inode)
+{
+    /* Prefer mnt_id, fallback on dev */
+    return inode->key.mnt_id ? inode->key.mnt_id : inode->key.dev;
+}
+
+static void add_mnt_inode(struct lo_data *lo, struct lo_inode *inode)
+{
+    uint64_t mnt_key = mnt_inode_key(inode);
+
+    if (!g_hash_table_contains(lo->mnt_inodes, &mnt_key)) {
+        inode->is_mnt = true;
+        g_hash_table_insert(lo->mnt_inodes, &mnt_key, inode);
+    }
+}
+
+static void remove_mnt_inode(struct lo_data *lo, struct lo_inode *inode)
+{
+    uint64_t mnt_key = mnt_inode_key(inode);
+
+    if (inode->is_mnt) {
+        g_hash_table_remove(lo->mnt_inodes, &mnt_key);
+    }
+}
+
 /*
  * Increments nlookup on the inode on success. unref_inode_lolocked() must be
  * called eventually to decrement nlookup again. If inodep is non-NULL, the
@@ -1054,10 +1081,14 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
         pthread_mutex_lock(&lo->mutex);
         inode->fuse_ino = lo_add_inode_mapping(req, inode);
         g_hash_table_insert(lo->inodes, &inode->key, inode);
+        add_mnt_inode(lo, inode);
         pthread_mutex_unlock(&lo->mutex);
     }
     e->ino = inode->fuse_ino;
 
+    fuse_log(FUSE_LOG_DEBUG, "  %lli/%s -> %lli%s\n", (unsigned long long)parent,
+             name, (unsigned long long)e->ino, inode->is_mnt ? " (mount)" : "");
+
     /* Transfer ownership of inode pointer to caller or drop it */
     if (inodep) {
         *inodep = inode;
@@ -1067,9 +1098,6 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
 
     lo_inode_put(lo, &dir);
 
-    fuse_log(FUSE_LOG_DEBUG, "  %lli/%s -> %lli\n", (unsigned long long)parent,
-             name, (unsigned long long)e->ino);
-
     return 0;
 
 out_err:
@@ -1479,6 +1507,7 @@ static void unref_inode(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
             g_hash_table_destroy(inode->posix_locks);
             pthread_mutex_destroy(&inode->plock_mutex);
         }
+        remove_mnt_inode(lo, inode);
         /* Drop our refcount from lo_do_lookup() */
         lo_inode_put(lo, &inode);
     }
@@ -3129,6 +3158,7 @@ static void lo_destroy(void *userdata)
     struct lo_data *lo = (struct lo_data *)userdata;
 
     pthread_mutex_lock(&lo->mutex);
+    g_hash_table_remove_all(lo->mnt_inodes);
     while (true) {
         GHashTableIter iter;
         gpointer key, value;
@@ -3659,6 +3689,7 @@ static void setup_root(struct lo_data *lo, struct lo_inode *root)
         root->posix_locks = g_hash_table_new_full(
             g_direct_hash, g_direct_equal, NULL, posix_locks_value_destroy);
     }
+    add_mnt_inode(lo, root);
 }
 
 static guint lo_key_hash(gconstpointer key)
@@ -3678,6 +3709,10 @@ static gboolean lo_key_equal(gconstpointer a, gconstpointer b)
 
 static void fuse_lo_data_cleanup(struct lo_data *lo)
 {
+    if (lo->mnt_inodes) {
+        g_hash_table_destroy(lo->mnt_inodes);
+    }
+
     if (lo->inodes) {
         g_hash_table_destroy(lo->inodes);
     }
@@ -3739,6 +3774,7 @@ int main(int argc, char *argv[])
     lo.root.fd = -1;
     lo.root.fuse_ino = FUSE_ROOT_ID;
     lo.cache = CACHE_AUTO;
+    lo.mnt_inodes = g_hash_table_new(g_int64_hash, g_int64_equal);
 
     /*
      * Set up the ino map like this:
-- 
2.26.3

