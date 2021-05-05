Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0F9374837
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 20:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbhEESx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 14:53:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55006 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229810AbhEESx6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 14:53:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620240781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ezT8mOSwWO06goNK+CmRyw7YAeqCfnbCUWH9/kMObNE=;
        b=NLM6WRKFRtllahrz+UUKevgViQAnmLJw1QMHEsmVoIGOY0Io8B+m8XjNILO0HRf4Kxq7GY
        9JB60Qq/Hy4f/1ncaOx+QiC/XH4lPYhOl8+fFbzSK5iS/8tivNp2jKVVfLSwAkuL+rDZwy
        OFT5wBgrmkyOULpawQbdOFEg10in7vw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-DEo3dZPQNr-JdpazMfhRug-1; Wed, 05 May 2021 14:52:59 -0400
X-MC-Unique: DEo3dZPQNr-JdpazMfhRug-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E18D18B62AD;
        Wed,  5 May 2021 18:52:58 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-239.rdu2.redhat.com [10.10.114.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 029D019C9B;
        Wed,  5 May 2021 18:52:43 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 83A5222054F; Wed,  5 May 2021 14:52:42 -0400 (EDT)
Date:   Wed, 5 May 2021 14:52:42 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Greg Kurz <groug@kaod.org>
Cc:     qemu-devel@nongnu.org, Cornelia Huck <cohuck@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        virtio-fs@redhat.com, Miklos Szeredi <miklos@szeredi.hu>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [for-6.1 v2 2/2] virtiofsd: Add support for FUSE_SYNCFS request
Message-ID: <20210505185242.GC244258@redhat.com>
References: <20210426152135.842037-1-groug@kaod.org>
 <20210426152135.842037-3-groug@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426152135.842037-3-groug@kaod.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 26, 2021 at 05:21:35PM +0200, Greg Kurz wrote:
> Honor the expected behavior of syncfs() to synchronously flush all
> data and metadata on linux systems.
> 
> Flushing is done with syncfs(). This is suboptimal as it will also
> flush writes performed by any other process on the same file system,
> and thus add an unbounded time penalty to syncfs(). This may be
> optimized in the future, but enforce correctness first.
> 
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>  tools/virtiofsd/fuse_lowlevel.c       | 19 ++++++++++++++++++
>  tools/virtiofsd/fuse_lowlevel.h       | 13 ++++++++++++
>  tools/virtiofsd/passthrough_ll.c      | 29 +++++++++++++++++++++++++++
>  tools/virtiofsd/passthrough_seccomp.c |  1 +
>  4 files changed, 62 insertions(+)
> 
> diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
> index 58e32fc96369..918ab11f54c2 100644
> --- a/tools/virtiofsd/fuse_lowlevel.c
> +++ b/tools/virtiofsd/fuse_lowlevel.c
> @@ -1870,6 +1870,24 @@ static void do_lseek(fuse_req_t req, fuse_ino_t nodeid,
>      }
>  }
>  
> +static void do_syncfs(fuse_req_t req, fuse_ino_t nodeid,
> +                      struct fuse_mbuf_iter *iter)
> +{
> +    struct fuse_syncfs_in *arg;
> +
> +    arg = fuse_mbuf_iter_advance(iter, sizeof(*arg));
> +    if (!arg) {
> +        fuse_reply_err(req, EINVAL);
> +        return;
> +    }
> +
> +    if (req->se->op.syncfs) {
> +        req->se->op.syncfs(req, arg->flags);
> +    } else {
> +        fuse_reply_err(req, ENOSYS);
> +    }
> +}
> +
>  static void do_init(fuse_req_t req, fuse_ino_t nodeid,
>                      struct fuse_mbuf_iter *iter)
>  {
> @@ -2267,6 +2285,7 @@ static struct {
>      [FUSE_RENAME2] = { do_rename2, "RENAME2" },
>      [FUSE_COPY_FILE_RANGE] = { do_copy_file_range, "COPY_FILE_RANGE" },
>      [FUSE_LSEEK] = { do_lseek, "LSEEK" },
> +    [FUSE_SYNCFS] = { do_syncfs, "SYNCFS" },
>  };
>  
>  #define FUSE_MAXOP (sizeof(fuse_ll_ops) / sizeof(fuse_ll_ops[0]))
> diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
> index 3bf786b03485..220bb3db4898 100644
> --- a/tools/virtiofsd/fuse_lowlevel.h
> +++ b/tools/virtiofsd/fuse_lowlevel.h
> @@ -1225,6 +1225,19 @@ struct fuse_lowlevel_ops {
>       */
>      void (*lseek)(fuse_req_t req, fuse_ino_t ino, off_t off, int whence,
>                    struct fuse_file_info *fi);
> +
> +    /**
> +     * Synchronize file system content
> +     *
> +     * If this request is answered with an error code of ENOSYS,
> +     * this is treated as success and future calls to syncfs() will
> +     * succeed automatically without being sent to the filesystem
> +     * process.
> +     *
> +     * @param req request handle
> +     * @param flags not used yet
> +     */
> +    void (*syncfs)(fuse_req_t req, uint64_t flags);
>  };
>  
>  /**
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 1553d2ef454f..6790a2f6fe10 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -3124,6 +3124,34 @@ static void lo_lseek(fuse_req_t req, fuse_ino_t ino, off_t off, int whence,
>      }
>  }
>  
> +static void lo_syncfs(fuse_req_t req, uint64_t flags)
> +{
> +    struct lo_data *lo = lo_data(req);
> +    int fd, ret;
> +
> +    /* No flags supported yet */
> +    if (flags) {
> +        fuse_reply_err(req, EINVAL);
> +        return;
> +    }
> +
> +    fd = lo_inode_open(lo, &lo->root, O_RDONLY);
> +    if (fd < 0) {
> +        fuse_reply_err(req, errno);
> +        return;
> +    }
> +
> +    /*
> +     * FIXME: this is suboptimal because it will also flush unrelated
> +     *        writes not coming from the client. This can dramatically
> +     *        increase the time spent in syncfs() if some process is
> +     *        writing lots of data on the same filesystem as virtiofsd.
> +     */
> +    ret = syncfs(fd);

Hi Greg,

As we discussed in the community call that this works only if there are
no other filesystems mounted as submounts under exported directory.

We proably need to find a way to call syncfs() on all the filesystems
which are submounts of exported directory. Might not be easy at all.

Just mentioning it here so that we have a note about the limitation of
current patch.

Vivek

> +    fuse_reply_err(req, ret < 0 ? errno : 0);
> +    close(fd);
> +}
> +
>  static void lo_destroy(void *userdata)
>  {
>      struct lo_data *lo = (struct lo_data *)userdata;
> @@ -3184,6 +3212,7 @@ static struct fuse_lowlevel_ops lo_oper = {
>      .copy_file_range = lo_copy_file_range,
>  #endif
>      .lseek = lo_lseek,
> +    .syncfs = lo_syncfs,
>      .destroy = lo_destroy,
>  };
>  
> diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
> index 62441cfcdb95..343188447901 100644
> --- a/tools/virtiofsd/passthrough_seccomp.c
> +++ b/tools/virtiofsd/passthrough_seccomp.c
> @@ -107,6 +107,7 @@ static const int syscall_allowlist[] = {
>      SCMP_SYS(set_robust_list),
>      SCMP_SYS(setxattr),
>      SCMP_SYS(symlinkat),
> +    SCMP_SYS(syncfs),
>      SCMP_SYS(time), /* Rarely needed, except on static builds */
>      SCMP_SYS(tgkill),
>      SCMP_SYS(unlinkat),
> -- 
> 2.26.3
> 

