Return-Path: <kvm+bounces-4442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 071888128E5
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 08:15:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFAB01F21B19
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 07:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4284E10A14;
	Thu, 14 Dec 2023 07:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b1ISzpPV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069B2100
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 23:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702538107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vRaJaBGglr58sTQWQMVIiejNzndVXiVSrMNWKcapZYU=;
	b=b1ISzpPVDfN8HBVeRnXludRbdLuybfmt7npNef2mz17XLC+sIpDOLu0peqmXyd1fHMtx7t
	lMWQLT/bPJLKn2Ssfl/jTVqOHkVaaPGXinzOfKSkHd+idd9QzLuDtGnRgBjVIpt5reqZ3S
	0nQUqXpN/PtOcZUwL9zqxtE3POsQtqo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-369-BhytYVe6PpagVRfPSYRH5g-1; Thu, 14 Dec 2023 02:15:05 -0500
X-MC-Unique: BhytYVe6PpagVRfPSYRH5g-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a19d1aace7cso423489266b.2
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 23:15:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702538104; x=1703142904;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vRaJaBGglr58sTQWQMVIiejNzndVXiVSrMNWKcapZYU=;
        b=nC0BXxqKp4z0wdb0rib98XBG9yoOma3HA73GowsLNp7hmkVV87aWBU83EJZjs+7C8h
         mNzHSVUzkYCtvwdP6K2v/75tcLAaptailbOg5R4g9NPywK75/sLtIOEASAmtVVS6c19T
         Q/jdxg7ipKYGm5FLTlR69nidFsEq2Sm1aAASSQRuNPW51b4xHdyJR3HJohZkNZWxPr5X
         zGWyTvv89BC3T9FMjkMr/gn4+ZNJzgICOOeIlXEVIBRpa4yxKOmdMr904YC/gu+QdLaE
         YxD9vlp61yvmErGZ55X/7o9MhnjiDLUdhmPsMS3Zrvjfp9ws3LWm1jowZMEO3d10V4kQ
         r5bg==
X-Gm-Message-State: AOJu0YyOw8Oi+M1lKSXXjs5s9iTfCT7T+2o/YknG3LvwTHkdgyksyzya
	PlLRERnofVIzX6yFBayHXRgNVMO9b8XSpz2X3afLz+wPtUuPlQ/zDMJqu8h9Se0ay4PGzEhJXYm
	97JNuXShgiql2
X-Received: by 2002:a17:907:9150:b0:a1d:5864:9471 with SMTP id l16-20020a170907915000b00a1d58649471mr3654528ejs.131.1702538104439;
        Wed, 13 Dec 2023 23:15:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEWMkmj5x4pGRiF3eBg98WEH/O85pbvq4edeImvdFfJoL9RengQ8lWWzDOAG01wA77QaoZCrA==
X-Received: by 2002:a17:907:9150:b0:a1d:5864:9471 with SMTP id l16-20020a170907915000b00a1d58649471mr3654523ejs.131.1702538104099;
        Wed, 13 Dec 2023 23:15:04 -0800 (PST)
Received: from redhat.com ([2.52.132.243])
        by smtp.gmail.com with ESMTPSA id li14-20020a170907198e00b00a1f738318a5sm8388046ejc.155.2023.12.13.23.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 23:15:03 -0800 (PST)
Date: Thu, 14 Dec 2023 02:14:59 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tobias Huschle <huschle@linux.ibm.com>
Cc: Jason Wang <jasowang@redhat.com>, Abel Wu <wuyun.abel@bytedance.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
Message-ID: <20231214021328-mutt-send-email-mst@kernel.org>
References: <53044.123120806415900549@us-mta-342.us.mimecast.lan>
 <20231209053443-mutt-send-email-mst@kernel.org>
 <CACGkMEuSGT-e-i-8U7hum-N_xEnsEKL+_07Mipf6gMLFFhj2Aw@mail.gmail.com>
 <20231211115329-mutt-send-email-mst@kernel.org>
 <CACGkMEudZnF7hUajgt0wtNPCxH8j6A3L1DgJj2ayJWhv9Bh1WA@mail.gmail.com>
 <20231212111433-mutt-send-email-mst@kernel.org>
 <42870.123121305373200110@us-mta-641.us.mimecast.lan>
 <20231213061719-mutt-send-email-mst@kernel.org>
 <25485.123121307454100283@us-mta-18.us.mimecast.lan>
 <20231213094854-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231213094854-mutt-send-email-mst@kernel.org>

On Wed, Dec 13, 2023 at 09:55:23AM -0500, Michael S. Tsirkin wrote:
> On Wed, Dec 13, 2023 at 01:45:35PM +0100, Tobias Huschle wrote:
> > On Wed, Dec 13, 2023 at 07:00:53AM -0500, Michael S. Tsirkin wrote:
> > > On Wed, Dec 13, 2023 at 11:37:23AM +0100, Tobias Huschle wrote:
> > > > On Tue, Dec 12, 2023 at 11:15:01AM -0500, Michael S. Tsirkin wrote:
> > > > > On Tue, Dec 12, 2023 at 11:00:12AM +0800, Jason Wang wrote:
> > > > > > On Tue, Dec 12, 2023 at 12:54 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > 
> > [...]
> > > 
> > > Apparently schedule is already called?
> > > 
> > 
> > What about this: 
> > 
> > static int vhost_task_fn(void *data)
> > {
> > 	<...>
> > 	did_work = vtsk->fn(vtsk->data);  --> this calls vhost_worker if I'm not mistaken
> > 	if (!did_work)
> > 		schedule();
> > 	<...>
> > }
> > 
> > static bool vhost_worker(void *data)
> > {
> > 	struct vhost_worker *worker = data;
> > 	struct vhost_work *work, *work_next;
> > 	struct llist_node *node;
> > 
> > 	node = llist_del_all(&worker->work_list);
> > 	if (node) {
> > 		<...>
> > 		llist_for_each_entry_safe(work, work_next, node, node) {
> > 			<...>
> > 		}
> > 	}
> > 
> > 	return !!node;
> > }
> > 
> > The llist_for_each_entry_safe does not actually change the node value, doesn't it?
> > 
> > If it does not change it, !!node would return 1.
> > Thereby skipping the schedule.
> > 
> > This was changed recently with:
> > f9010dbdce91 fork, vhost: Use CLONE_THREAD to fix freezer/ps regression
> > 
> > It returned a hardcoded 0 before. The commit message explicitly mentions this
> > change to make vhost_worker return 1 if it did something.
> > 
> > Seems indeed like a nasty little side effect caused by EEVDF not scheduling
> > the woken up kworker right away.
> 
> 
> So we are actually making an effort to be nice.
> Documentation/kernel-hacking/hacking.rst says:
> 
> If you're doing longer computations: first think userspace. If you
> **really** want to do it in kernel you should regularly check if you need
> to give up the CPU (remember there is cooperative multitasking per CPU).
> Idiom::
> 
>     cond_resched(); /* Will sleep */
> 
> 
> and this is what vhost.c does.
> 
> At this point I'm not sure why it's appropriate to call schedule() as opposed to
> cond_resched(). Ideas?
> 

Peter, would appreciate feedback on this. When is cond_resched()
insufficient to give up the CPU? Should Documentation/kernel-hacking/hacking.rst
be updated to require schedule() instead?


> -- 
> MST


