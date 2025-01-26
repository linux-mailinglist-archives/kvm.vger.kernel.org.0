Return-Path: <kvm+bounces-36610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F6FCA1C860
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 15:21:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDB4E3A6503
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 14:21:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B5B31547E3;
	Sun, 26 Jan 2025 14:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gkZFk8v/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2724136326
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 14:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737901271; cv=none; b=Bu4Zb2gEl3M3ECI2XjdLJy8R9rKw1coF+3JJLoSP2UHfNDIxJ1Sa/BQxm6umVCbVdGk/vNRzFrXUk5Phg8GFPkQuYDXNF+9hS1RPveQgu6pqeBGS1BT8tyScvVUePgQojyd0KCwXuUhrWsNrFw/KPKVQVYwgQDe/qnoyWybefis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737901271; c=relaxed/simple;
	bh=e5uxTfm8Bm7baUh4DjrgZ8lrW7Fjd8cbq7rp2ZazZlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R0gu73KZMDNfgdqJKIt5t05PxM3HXGAAqbk8Z3+lwmLe2f6P0Kvx8M1z75+/6m3RSh3VW46uQ71d7sbzmwIw1gRuZ8FuBrM02KKgpQHtiyE1NS0ZJGSzTWf28zlhP8MlSD5tctgdpU6n1Bo8ek5KVy+9R80WFP1ouKdykP0RrVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gkZFk8v/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737901268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7jVhWAcn2+kPT9IwaNA/FK8utBMCkOtUO+6hQLL0u2s=;
	b=gkZFk8v/xC0TbCgxLTKnJcPS8qwP9bFOkxFo9pIBljNWcvVgM0WOoH0/PIPMrP5VKAumV6
	HGlWi1lNH8DbSnrkGIFagAh0l5WaIMZyMWKhGNsuL9IJNXaVVjoOVxvf9i6OVp8X9daHzs
	KQnpUTqJucJkQ/1UR7kVnQpCIU/o+rM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-226-BIEChJGVMKWH-5un6fYhrg-1; Sun,
 26 Jan 2025 09:21:05 -0500
X-MC-Unique: BIEChJGVMKWH-5un6fYhrg-1
X-Mimecast-MFC-AGG-ID: BIEChJGVMKWH-5un6fYhrg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6CC951800378;
	Sun, 26 Jan 2025 14:21:04 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.224.72])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 7C07A19560AD;
	Sun, 26 Jan 2025 14:21:00 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun, 26 Jan 2025 15:20:39 +0100 (CET)
Date: Sun, 26 Jan 2025 15:20:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
Message-ID: <20250126142034.GA28135@redhat.com>
References: <20250124163741.101568-1-pbonzini@redhat.com>
 <CAHk-=wg4Wm4x9GoUk6M8BhLsrhLj4+n8jA2Kg8XUQF=kxgNL9g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg4Wm4x9GoUk6M8BhLsrhLj4+n8jA2Kg8XUQF=kxgNL9g@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On 01/25, Linus Torvalds wrote:
>
> Keith pinpointed the user space logic to fork_remap():
>
>    https://github.com/google/minijail/blob/main/rust/minijail/src/lib.rs#L987
>
> and honestly, I do think it makes sense for user space to ask "am I
> single-threaded" (which is presumably the thing that breaks), and the
> code for that is pretty simple:
>
>   fn is_single_threaded() -> io::Result<bool> {
>       match count_dir_entries("/proc/self/task") {
>           Ok(1) => Ok(true),
>           Ok(_) => Ok(false),
>           Err(e) => Err(e),
>       }
>   }
>
> and I really don't think user space is "wrong".
>
> So the fact that a kernel helper thread that runs async in the
> background and does random background infrastructure things that do
> not really affect user space should probably simply not break this
> kind of simple (and admittedly simplistic) user space logic.
>
> Should we just add some flag to say "don't show this thread in this
> context"?

Not sure I understand... Looking at is_single_threaded() above I guess
something like below should work (incomplete, in particular we need to
chang first_tid() as well).

But a PF_HIDDEN sub-thread will still be visible via /proc/$pid_of_PF_HIDDEN

> We obviously still want to see it for management purposes,
> so it's not like the thing should be entirely invisible,

Can you explain?

Oleg.


--- x/include/linux/sched.h
+++ x/include/linux/sched.h
@@ -1685,7 +1685,7 @@ extern struct pid *cad_pid;
 #define PF_USED_MATH		0x00002000	/* If unset the fpu must be initialized before use */
 #define PF_USER_WORKER		0x00004000	/* Kernel thread cloned from userspace thread */
 #define PF_NOFREEZE		0x00008000	/* This thread should not be frozen */
-#define PF__HOLE__00010000	0x00010000
+#define PF_HIDDEN		0x00010000
 #define PF_KSWAPD		0x00020000	/* I am kswapd */
 #define PF_MEMALLOC_NOFS	0x00040000	/* All allocations inherit GFP_NOFS. See memalloc_nfs_save() */
 #define PF_MEMALLOC_NOIO	0x00080000	/* All allocations inherit GFP_NOIO. See memalloc_noio_save() */
--- x/include/linux/sched/task.h
+++ x/include/linux/sched/task.h
@@ -31,6 +31,7 @@ struct kernel_clone_args {
 	u32 io_thread:1;
 	u32 user_worker:1;
 	u32 no_files:1;
+	u32 hidden:1;
 	unsigned long stack;
 	unsigned long stack_size;
 	unsigned long tls;
--- x/kernel/fork.c
+++ x/kernel/fork.c
@@ -2237,6 +2237,8 @@ __latent_entropy struct task_struct *cop
 	}
 	if (args->io_thread)
 		p->flags |= PF_IO_WORKER;
+	if (args->hidden)
+		p->flags |= PF_HIDDEN;
 
 	if (args->name)
 		strscpy_pad(p->comm, args->name, sizeof(p->comm));
--- x/kernel/vhost_task.c
+++ x/kernel/vhost_task.c
@@ -117,7 +117,7 @@ EXPORT_SYMBOL_GPL(vhost_task_stop);
  */
 struct vhost_task *vhost_task_create(bool (*fn)(void *),
 				     void (*handle_sigkill)(void *), void *arg,
-				     const char *name)
+				     bool hidden, const char *name)
 {
 	struct kernel_clone_args args = {
 		.flags		= CLONE_FS | CLONE_UNTRACED | CLONE_VM |
@@ -125,6 +125,7 @@ struct vhost_task *vhost_task_create(boo
 		.exit_signal	= 0,
 		.fn		= vhost_task_fn,
 		.name		= name,
+		.hidden		= hidden,
 		.user_worker	= 1,
 		.no_files	= 1,
 	};
--- x/fs/proc/base.c
+++ x/fs/proc/base.c
@@ -3906,9 +3906,12 @@ static struct task_struct *next_tid(stru
 	struct task_struct *pos = NULL;
 	rcu_read_lock();
 	if (pid_alive(start)) {
-		pos = __next_thread(start);
-		if (pos)
-			get_task_struct(pos);
+		for (pos = start; (pos = __next_thread(pos)); ) {
+			if (!(pos->flags & PF_HIDDEN)) {
+				get_task_struct(pos);
+				break;
+			}
+		}
 	}
 	rcu_read_unlock();
 	put_task_struct(start);


