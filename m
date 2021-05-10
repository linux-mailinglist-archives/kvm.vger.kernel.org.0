Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CEC379787
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 21:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbhEJTTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 15:19:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41294 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230466AbhEJTTt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 15:19:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620674324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OqHx7QNfZgQq+glDZloCB/6LoS6ZDMpVlsbqx7XT9A8=;
        b=ZoWhl5IhgCseb+Xxoi+kMN20oChr4aylZPyrl8BLRWxK5fC3w6axMid7NurndVOHtLG4tK
        Qw8rf19J+oSjkOFchDKm9WB/I3GhlWEiEN7+cxkGCzQo6pEIFJ/BycOvvrDrJ/IrcVXMZr
        ia+yRa6iFNoitFI8dJ+xdbvQiD11yx8=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-VMt28srHO3OvYy7yXlAj7g-1; Mon, 10 May 2021 15:18:42 -0400
X-MC-Unique: VMt28srHO3OvYy7yXlAj7g-1
Received: by mail-qt1-f198.google.com with SMTP id a15-20020a05622a02cfb02901b5e54ac2e5so11114873qtx.4
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 12:18:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OqHx7QNfZgQq+glDZloCB/6LoS6ZDMpVlsbqx7XT9A8=;
        b=gT1kmlWlFH++006S3T4YVL4cA5BnFDQAw0txRWI/8E3kfGeh4gZgCuTFffJD+Ag7l8
         /4xlewNJil2FcqBmGMneQmiAh8oCKRSrz/dM9dtkgbPI2MlOr7nHln2X74z0LRqhc9ex
         8/yl+LIQMqRbIjkDRJgzfapkx6056TiVoW7L/0qBoxkw1cfel+aFFb7/hzM7iLrQ86d0
         5GyrmJQCTJLTH7n64HDcOxsleB/d9qU5M43c+/nSRms0PKUIglSl4t9cE16Q7vH/xpFR
         W99qKGsNUZzdHf+Qb/Dhvjzwgd8qil+XPOHt+r/uIaEWBGUSgzGN0XybzUqoI7ynCdRk
         XqqQ==
X-Gm-Message-State: AOAM530BrdQu1OMNNWW0k3ZTf1DA8K2YLwhYCWGueMWc8ukIVq7j0Wvg
        u0yFvUAuAypkmC+Rkkfsm6XuPaIzAZGTuAqvKrfZUtQJn0rfV0lNclMl9nhMmbE+J+fRAS81hvt
        R3+nFXozPgAM/
X-Received: by 2002:ad4:4f82:: with SMTP id em2mr25335537qvb.55.1620674322285;
        Mon, 10 May 2021 12:18:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyVz1bqoOWu86zxvzJeSlZBmsEnC8/uv7KpmOFauaisWiEyNKeov7fVUZw2U8Gf6xpQWGa3HA==
X-Received: by 2002:ad4:4f82:: with SMTP id em2mr25335519qvb.55.1620674322025;
        Mon, 10 May 2021 12:18:42 -0700 (PDT)
Received: from horse (pool-173-76-174-238.bstnma.fios.verizon.net. [173.76.174.238])
        by smtp.gmail.com with ESMTPSA id z4sm12146288qtv.7.2021.05.10.12.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 12:18:41 -0700 (PDT)
Date:   Mon, 10 May 2021 15:18:39 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Greg Kurz <groug@kaod.org>
Cc:     qemu-devel@nongnu.org, virtio-fs@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [for-6.1 v3 2/3] virtiofsd: Track mounts
Message-ID: <20210510191839.GB193692@horse>
References: <20210510155539.998747-1-groug@kaod.org>
 <20210510155539.998747-3-groug@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510155539.998747-3-groug@kaod.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021 at 05:55:38PM +0200, Greg Kurz wrote:
> The upcoming implementation of ->sync_fs() needs to know about all
> submounts in order to call syncfs() on all of them.
> 
> Track every inode that comes up with a new mount id in a GHashTable.
> If the mount id isn't available, e.g. no statx() on the host, fallback
> on the device id for the key. This is done during lookup because we
> only care for the submounts that the client knows about. The inode
> is removed from the hash table when ultimately unreferenced. This
> can happen on a per-mount basis when the client posts a FUSE_FORGET
> request or for all submounts at once with FUSE_DESTROY.
> 
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>  tools/virtiofsd/passthrough_ll.c | 42 +++++++++++++++++++++++++++++---
>  1 file changed, 39 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 1553d2ef454f..dc940a1d048b 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -117,6 +117,7 @@ struct lo_inode {
>      GHashTable *posix_locks; /* protected by lo_inode->plock_mutex */
>  
>      mode_t filetype;
> +    bool is_mnt;
>  };
>  
>  struct lo_cred {
> @@ -163,6 +164,7 @@ struct lo_data {
>      bool use_statx;
>      struct lo_inode root;
>      GHashTable *inodes; /* protected by lo->mutex */
> +    GHashTable *mnt_inodes; /* protected by lo->mutex */
>      struct lo_map ino_map; /* protected by lo->mutex */
>      struct lo_map dirp_map; /* protected by lo->mutex */
>      struct lo_map fd_map; /* protected by lo->mutex */
> @@ -968,6 +970,31 @@ static int do_statx(struct lo_data *lo, int dirfd, const char *pathname,
>      return 0;
>  }
>  
> +static uint64_t mnt_inode_key(struct lo_inode *inode)
> +{
> +    /* Prefer mnt_id, fallback on dev */
> +    return inode->key.mnt_id ? inode->key.mnt_id : inode->key.dev;
> +}
> +
> +static void add_mnt_inode(struct lo_data *lo, struct lo_inode *inode)
> +{
> +    uint64_t mnt_key = mnt_inode_key(inode);
> +
> +    if (!g_hash_table_contains(lo->mnt_inodes, &mnt_key)) {
> +        inode->is_mnt = true;
> +        g_hash_table_insert(lo->mnt_inodes, &mnt_key, inode);
> +    }
> +}
> +
> +static void remove_mnt_inode(struct lo_data *lo, struct lo_inode *inode)
> +{
> +    uint64_t mnt_key = mnt_inode_key(inode);
> +
> +    if (inode->is_mnt) {
> +        g_hash_table_remove(lo->mnt_inodes, &mnt_key);
> +    }

What if same filesystem is mounted at two different mount points. Say at
foo/ and bar/. Now when we lookup foo, we will add that inode to 
hash table. But when we lookup bar, we will not add it. Now say foo
is unmounted, and inode is going away, then we will remove super block
of fs from hash table (while it is still mounted at bar/ ?). Do I
understand it right?

If yes, we probably will need another refcounted object to keep track
of all the instances of the same fs?

Thanks
Vivek


> +}
> +

>  /*
>   * Increments nlookup on the inode on success. unref_inode_lolocked() must be
>   * called eventually to decrement nlookup again. If inodep is non-NULL, the
> @@ -1054,10 +1081,14 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>          pthread_mutex_lock(&lo->mutex);
>          inode->fuse_ino = lo_add_inode_mapping(req, inode);
>          g_hash_table_insert(lo->inodes, &inode->key, inode);
> +        add_mnt_inode(lo, inode);
>          pthread_mutex_unlock(&lo->mutex);
>      }
>      e->ino = inode->fuse_ino;
>  
> +    fuse_log(FUSE_LOG_DEBUG, "  %lli/%s -> %lli%s\n", (unsigned long long)parent,
> +             name, (unsigned long long)e->ino, inode->is_mnt ? " (mount)" : "");
> +
>      /* Transfer ownership of inode pointer to caller or drop it */
>      if (inodep) {
>          *inodep = inode;
> @@ -1067,9 +1098,6 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>  
>      lo_inode_put(lo, &dir);
>  
> -    fuse_log(FUSE_LOG_DEBUG, "  %lli/%s -> %lli\n", (unsigned long long)parent,
> -             name, (unsigned long long)e->ino);
> -
>      return 0;
>  
>  out_err:
> @@ -1479,6 +1507,7 @@ static void unref_inode(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
>              g_hash_table_destroy(inode->posix_locks);
>              pthread_mutex_destroy(&inode->plock_mutex);
>          }
> +        remove_mnt_inode(lo, inode);
>          /* Drop our refcount from lo_do_lookup() */
>          lo_inode_put(lo, &inode);
>      }
> @@ -3129,6 +3158,7 @@ static void lo_destroy(void *userdata)
>      struct lo_data *lo = (struct lo_data *)userdata;
>  
>      pthread_mutex_lock(&lo->mutex);
> +    g_hash_table_remove_all(lo->mnt_inodes);
>      while (true) {
>          GHashTableIter iter;
>          gpointer key, value;
> @@ -3659,6 +3689,7 @@ static void setup_root(struct lo_data *lo, struct lo_inode *root)
>          root->posix_locks = g_hash_table_new_full(
>              g_direct_hash, g_direct_equal, NULL, posix_locks_value_destroy);
>      }
> +    add_mnt_inode(lo, root);
>  }
>  
>  static guint lo_key_hash(gconstpointer key)
> @@ -3678,6 +3709,10 @@ static gboolean lo_key_equal(gconstpointer a, gconstpointer b)
>  
>  static void fuse_lo_data_cleanup(struct lo_data *lo)
>  {
> +    if (lo->mnt_inodes) {
> +        g_hash_table_destroy(lo->mnt_inodes);
> +    }
> +
>      if (lo->inodes) {
>          g_hash_table_destroy(lo->inodes);
>      }
> @@ -3739,6 +3774,7 @@ int main(int argc, char *argv[])
>      lo.root.fd = -1;
>      lo.root.fuse_ino = FUSE_ROOT_ID;
>      lo.cache = CACHE_AUTO;
> +    lo.mnt_inodes = g_hash_table_new(g_int64_hash, g_int64_equal);
>  
>      /*
>       * Set up the ino map like this:
> -- 
> 2.26.3
> 

