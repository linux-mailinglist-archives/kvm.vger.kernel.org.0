Return-Path: <kvm+bounces-4021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8984C80C1E0
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 08:27:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B00D1F20FF3
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 07:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EE532031D;
	Mon, 11 Dec 2023 07:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TCs/ceZN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA45E4
	for <kvm@vger.kernel.org>; Sun, 10 Dec 2023 23:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702279620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yzl/uXMUGCBrEhgpFoMPCiMftRl1HpCdIgUDcqQab60=;
	b=TCs/ceZNlUmBJnaQ+aFgAjYutP5EfaS/DBUVVF8MtyTtsNgUPkQwoCDvOe3xjnOPRwKq/P
	pnn0cqBTHybSw9gZiErd+uwSKBcnbu86Igq6J49XsRvVSDnFsNAMJp/Mk2Xrw3GWlE+4VR
	bdqPSQm9GBBgasUvtGBdtdjGza2jGpQ=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-bhXO3ljiMw6tUCeNR-yErA-1; Mon, 11 Dec 2023 02:26:58 -0500
X-MC-Unique: bhXO3ljiMw6tUCeNR-yErA-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-5c659339436so2157049a12.2
        for <kvm@vger.kernel.org>; Sun, 10 Dec 2023 23:26:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702279617; x=1702884417;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yzl/uXMUGCBrEhgpFoMPCiMftRl1HpCdIgUDcqQab60=;
        b=nXlIjlU83GL5u/ZIZemxzdhW4H2N9RYBNXeJ5swSaRyney0Ll3uNABpRyR1puVrHx4
         nsel5V/xTncrJpOnPQNJFgDCwsElQlJbKQH+vMkiIFLDF7lv/m+LnAs9OXi//nBLP99m
         OziRN3yxObL/57iQEBscfvBIadmlueJVnhRq1DpzsfUZ6c4/W2OrcB5PtwMp3+90+p1f
         W5wEunWEqLGwtApBcy7CoCT7FVpR77d/q54c8PLfU5wLBzBjiPuSYWyRoQ99ktM7aiFo
         JWECB2R++yP/6WqdWgO3Ob9LImtfVUKSCJRCIlPlR1+Y4v9RoIRdKUiC+sB6sNZ7RDHS
         BLIg==
X-Gm-Message-State: AOJu0YwEcszJVZc2TnTV45Re1N8xpBUnymkRbjF4mkHQmbC9KnsUFh6I
	8D+cyCqeufiByVK3VH8ZoD5O89fQk8aiS+fb+bIgXudTQIg//08pPX4gIDOxQZBOYXyCpcv5+L9
	NefuIRx+SQzDJ89X2DhSI4vfBIieH
X-Received: by 2002:a05:6a20:2448:b0:18f:97c:ba1a with SMTP id t8-20020a056a20244800b0018f097cba1amr1702198pzc.116.1702279617590;
        Sun, 10 Dec 2023 23:26:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFtMCW4/nYLJbNDFq92ZIWWhnreabLLEHm6wAXBKkoi7VBSJcNSpG3StpjW99D/ZfXuO/jDlH3z/lbO+PhUoEo=
X-Received: by 2002:a05:6a20:2448:b0:18f:97c:ba1a with SMTP id
 t8-20020a056a20244800b0018f097cba1amr1702190pzc.116.1702279617283; Sun, 10
 Dec 2023 23:26:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <46a997c2-5a38-4b60-b589-6073b1fac677@bytedance.com>
 <ZVyt4UU9+XxunIP7@DESKTOP-2CCOB1S.> <20231122100016.GO8262@noisy.programming.kicks-ass.net>
 <6564a012.c80a0220.adb78.f0e4SMTPIN_ADDED_BROKEN@mx.google.com>
 <d4110c79-d64f-49bd-9f69-0a94369b5e86@bytedance.com> <07513.123120701265800278@us-mta-474.us.mimecast.lan>
 <20231207014626-mutt-send-email-mst@kernel.org> <56082.123120804242300177@us-mta-137.us.mimecast.lan>
 <20231208052150-mutt-send-email-mst@kernel.org> <53044.123120806415900549@us-mta-342.us.mimecast.lan>
 <20231209053443-mutt-send-email-mst@kernel.org>
In-Reply-To: <20231209053443-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 11 Dec 2023 15:26:46 +0800
Message-ID: <CACGkMEuSGT-e-i-8U7hum-N_xEnsEKL+_07Mipf6gMLFFhj2Aw@mail.gmail.com>
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Tobias Huschle <huschle@linux.ibm.com>, Abel Wu <wuyun.abel@bytedance.com>, 
	Peter Zijlstra <peterz@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 9, 2023 at 6:42=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com> =
wrote:
>
> On Fri, Dec 08, 2023 at 12:41:38PM +0100, Tobias Huschle wrote:
> > On Fri, Dec 08, 2023 at 05:31:18AM -0500, Michael S. Tsirkin wrote:
> > > On Fri, Dec 08, 2023 at 10:24:16AM +0100, Tobias Huschle wrote:
> > > > On Thu, Dec 07, 2023 at 01:48:40AM -0500, Michael S. Tsirkin wrote:
> > > > > On Thu, Dec 07, 2023 at 07:22:12AM +0100, Tobias Huschle wrote:
> > > > > > 3. vhost looping endlessly, waiting for kworker to be scheduled
> > > > > >
> > > > > > I dug a little deeper on what the vhost is doing. I'm not an ex=
pert on
> > > > > > virtio whatsoever, so these are just educated guesses that mayb=
e
> > > > > > someone can verify/correct. Please bear with me probably messin=
g up
> > > > > > the terminology.
> > > > > >
> > > > > > - vhost is looping through available queues.
> > > > > > - vhost wants to wake up a kworker to process a found queue.
> > > > > > - kworker does something with that queue and terminates quickly=
.
> > > > > >
> > > > > > What I found by throwing in some very noisy trace statements wa=
s that,
> > > > > > if the kworker is not woken up, the vhost just keeps looping ac=
cross
> > > > > > all available queues (and seems to repeat itself). So it essent=
ially
> > > > > > relies on the scheduler to schedule the kworker fast enough. Ot=
herwise
> > > > > > it will just keep on looping until it is migrated off the CPU.
> > > > >
> > > > >
> > > > > Normally it takes the buffers off the queue and is done with it.
> > > > > I am guessing that at the same time guest is running on some othe=
r
> > > > > CPU and keeps adding available buffers?
> > > > >
> > > >
> > > > It seems to do just that, there are multiple other vhost instances
> > > > involved which might keep filling up thoses queues.
> > > >
> > >
> > > No vhost is ever only draining queues. Guest is filling them.
> > >
> > > > Unfortunately, this makes the problematic vhost instance to stay on
> > > > the CPU and prevents said kworker to get scheduled. The kworker is
> > > > explicitly woken up by vhost, so it wants it to do something.

It looks to me vhost doesn't use workqueue but the worker by itself.

> > > >
> > > > At this point it seems that there is an assumption about the schedu=
ler
> > > > in place which is no longer fulfilled by EEVDF. From the discussion=
 so
> > > > far, it seems like EEVDF does what is intended to do.
> > > >
> > > > Shouldn't there be a more explicit mechanism in use that allows the
> > > > kworker to be scheduled in favor of the vhost?

Vhost did a brunch of copy_from_user() which should trigger
__might_fault() so a __might_sleep() most of the case.

> > > >
> > > > It is also concerning that the vhost seems cannot be preempted by t=
he
> > > > scheduler while executing that loop.
> > >
> > >
> > > Which loop is that, exactly?
> >
> > The loop continously passes translate_desc in drivers/vhost/vhost.c
> > That's where I put the trace statements.
> >
> > The overall sequence seems to be (top to bottom):
> >
> > handle_rx
> > get_rx_bufs
> > vhost_get_vq_desc
> > vhost_get_avail_head
> > vhost_get_avail
> > __vhost_get_user_slow
> > translate_desc               << trace statement in here
> > vhost_iotlb_itree_first
>
> I wonder why do you keep missing cache and re-translating.
> Is pr_debug enabled for you? If not could you check if it
> outputs anything?
> Or you can tweak:
>
> #define vq_err(vq, fmt, ...) do {                                  \
>                 pr_debug(pr_fmt(fmt), ##__VA_ARGS__);       \
>                 if ((vq)->error_ctx)                               \
>                                 eventfd_signal((vq)->error_ctx, 1);\
>         } while (0)
>
> to do pr_err if you prefer.
>
> > These functions show up as having increased overhead in perf.
> >
> > There are multiple loops going on in there.
> > Again the disclaimer though, I'm not familiar with that code at all.
>
>
> So there's a limit there: vhost_exceeds_weight should requeue work:
>
>         } while (likely(!vhost_exceeds_weight(vq, ++recv_pkts, total_len)=
));
>
> then we invoke scheduler each time before re-executing it:
>
>
> {
>         struct vhost_worker *worker =3D data;
>         struct vhost_work *work, *work_next;
>         struct llist_node *node;
>
>         node =3D llist_del_all(&worker->work_list);
>         if (node) {
>                 __set_current_state(TASK_RUNNING);
>
>                 node =3D llist_reverse_order(node);
>                 /* make sure flag is seen after deletion */
>                 smp_wmb();
>                 llist_for_each_entry_safe(work, work_next, node, node) {
>                         clear_bit(VHOST_WORK_QUEUED, &work->flags);
>                         kcov_remote_start_common(worker->kcov_handle);
>                         work->fn(work);
>                         kcov_remote_stop();
>                         cond_resched();
>                 }
>         }
>
>         return !!node;
> }
>
> These are the byte and packet limits:
>
> /* Max number of bytes transferred before requeueing the job.
>  * Using this limit prevents one virtqueue from starving others. */
> #define VHOST_NET_WEIGHT 0x80000
>
> /* Max number of packets transferred before requeueing the job.
>  * Using this limit prevents one virtqueue from starving others with smal=
l
>  * pkts.
>  */
> #define VHOST_NET_PKT_WEIGHT 256
>
>
> Try reducing the VHOST_NET_WEIGHT limit and see if that improves things a=
ny?

Or a dirty hack like cond_resched() in translate_desc().

Thanks


>
> --
> MST
>


