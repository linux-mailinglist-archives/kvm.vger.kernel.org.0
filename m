Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEEC23A99
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 16:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391905AbfETOlr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 10:41:47 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35540 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391891AbfETOlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 10:41:46 -0400
Received: by mail-wr1-f68.google.com with SMTP id m3so1952873wrv.2
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 07:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wIkoBjfIwezg37K8GyVLa4Ib4GG1DfXOe0xDWRIHC9c=;
        b=Ou8A0T5aNjnqbPlBgwGcea2Jt9WREkncm2pZ2tzBkRLRUyzdHu/788KR2EoEZb9mkK
         Uc0cJxu+0ZffxR3RKAwpxWA+Pa4RUhS5MdKIHC+QqTBZftrk7zJrl15NN6dttqr5OpMP
         8xroeKkE6/8JUdYcncxaCbltjgHZuJY1yQojg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wIkoBjfIwezg37K8GyVLa4Ib4GG1DfXOe0xDWRIHC9c=;
        b=DXDUM7qRdT6ScWcMbL9Nx5TMONkYafaIkZDUHzOAn5N4MnJBMIiDJmoUb8RyftrCPL
         NLDn19o4v+f8oZZv4UpBReqOP5VTcgB8Rf89VQM2MnVW/APwOLfBd5N1xz+r5kqWUXFi
         TwbOd3XHji8lMbWAOdlkXsx2e40+JaXJ1KCh0GULSFzwTdX/VLhiSR2b70mshoIytZPb
         GC062Pbkcla4arU8UxiY1svcAZxkEayLJpb+kcGkd7a5WvVaxFMsbFnnNCQqxjm0kh0a
         QGMRxXQzuRSmcs8Jp86rUFzFLNJYre+GFFul0iFuCutjD6Ap/9ppYUr37PRRqPdRVKQL
         y1Lw==
X-Gm-Message-State: APjAAAWMvV/5fU6wNKG68Sthv0rkeWT81AkEUSJJf7hdjwisxsVXA3MV
        UC2HwURfZ0mptp6/xVJAQ3ndJw==
X-Google-Smtp-Source: APXvYqyUmEWgtNuNz/KLPkSE1Lwvd2WXTdR3OckfDP8fsKM/AbqeGou/Yo4wcQWm5VhE6j5qlpjEbQ==
X-Received: by 2002:a5d:53c8:: with SMTP id a8mr10213096wrw.152.1558363305299;
        Mon, 20 May 2019 07:41:45 -0700 (PDT)
Received: from localhost.localdomain (catv-212-96-48-140.catv.broadband.hu. [212.96.48.140])
        by smtp.gmail.com with ESMTPSA id n1sm12945556wmc.19.2019.05.20.07.41.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 May 2019 07:41:44 -0700 (PDT)
Date:   Mon, 20 May 2019 16:41:37 +0200
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-nvdimm@lists.01.org,
        stefanha@redhat.com, dgilbert@redhat.com, swhiteho@redhat.com
Subject: Re: [PATCH v2 02/30] fuse: Clear setuid bit even in cache=never path
Message-ID: <20190520144137.GA24093@localhost.localdomain>
References: <20190515192715.18000-1-vgoyal@redhat.com>
 <20190515192715.18000-3-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515192715.18000-3-vgoyal@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 15, 2019 at 03:26:47PM -0400, Vivek Goyal wrote:
> If fuse daemon is started with cache=never, fuse falls back to direct IO.
> In that write path we don't call file_remove_privs() and that means setuid
> bit is not cleared if unpriviliged user writes to a file with setuid bit set.
> 
> pjdfstest chmod test 12.t tests this and fails.

I think better sulution is to tell the server if the suid bit needs to be
removed, so it can do so in a race free way.

Here's the kernel patch, and I'll reply with the libfuse patch.

---
 fs/fuse2/file.c           |    2 ++
 include/uapi/linux/fuse.h |    3 +++
 2 files changed, 5 insertions(+)

--- a/fs/fuse2/file.c
+++ b/fs/fuse2/file.c
@@ -363,6 +363,8 @@ static ssize_t fuse_send_write(struct fu
 		inarg->flags |= O_DSYNC;
 	if (iocb->ki_flags & IOCB_SYNC)
 		inarg->flags |= O_SYNC;
+	if (!capable(CAP_FSETID))
+		inarg->write_flags |= FUSE_WRITE_KILL_PRIV;
 	req->inh.opcode = FUSE_WRITE;
 	req->inh.nodeid = ff->nodeid;
 	req->inh.len = req->inline_inlen + count;
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -125,6 +125,7 @@
  *
  *  7.29
  *  - add FUSE_NO_OPENDIR_SUPPORT flag
+ *  - add FUSE_WRITE_KILL_PRIV flag
  */
 
 #ifndef _LINUX_FUSE_H
@@ -318,9 +319,11 @@ struct fuse_file_lock {
  *
  * FUSE_WRITE_CACHE: delayed write from page cache, file handle is guessed
  * FUSE_WRITE_LOCKOWNER: lock_owner field is valid
+ * FUSE_WRITE_KILL_PRIV: kill suid and sgid bits
  */
 #define FUSE_WRITE_CACHE	(1 << 0)
 #define FUSE_WRITE_LOCKOWNER	(1 << 1)
+#define FUSE_WRITE_KILL_PRIV	(1 << 2)
 
 /**
  * Read flags


