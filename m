Return-Path: <kvm+bounces-4351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A94F0811557
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 15:56:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5875F281CDF
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 14:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A82E52F85F;
	Wed, 13 Dec 2023 14:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B1YKqLnI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510DBDD
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 06:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702479357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uIFKxiFZihO9GqXmA3HovwJ/rQqe1hgcv8SZULAHlOU=;
	b=B1YKqLnIUR3cDTacgyLgNoDVTwfS3L2fO/vjk/RjTf6HUF0i5ErZLc6d/C3mE3JDTUfEXb
	Y/wGir4ZRpe6Ql14ho2oJz+qf/Cg1NIJX/JUJgcIWyafTRC3TauG1zOMXYKo9WY8Tc4CNR
	9ChoNRDJoDHu0r0w0MnRa9+Skbf5h5g=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-y_KGy23aM_WAU2UJWEnZcQ-1; Wed, 13 Dec 2023 09:55:25 -0500
X-MC-Unique: y_KGy23aM_WAU2UJWEnZcQ-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2c9fa16728aso55281891fa.0
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 06:55:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702479324; x=1703084124;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uIFKxiFZihO9GqXmA3HovwJ/rQqe1hgcv8SZULAHlOU=;
        b=OMF8BtSUSS0T0+W6miyEqr2xC7my9IS+8F3VIMsU6gw8xnFPdRAWkZKOk6fF89g02a
         Hbfc8fjbE84C/vOQ8AuccM/nYoTFmSJxd2HhEOgb5FwrN3b4Iz7US2x7RRDe5PVwF3ag
         GPkh5AzcEiEmLIJqXX7bRMPkm//i78okzNeUq4fM928+OjSvINBCdvK0zDRrD3cCpOLE
         AeKuFGTNrDvQV4+Y5aokeAAXHgDseqQlGGreo4CV/FBC0S5rewTvLxxXg5rHQH/dqDXS
         NuCCCCwK8fP8AYQPktx63x5RxozwT5xIJc/H11PDMjJXRsCxt/vNDh35Bjw4tTZNRqSD
         W2hw==
X-Gm-Message-State: AOJu0YyIyit8hrzOQ0uSqfp1d8NO21EM05QPAR35Aax4TQm1+QVzOPAf
	VsVmp6YEa95HT43svx2rwE2ysgUxu/R6N/XlT82+CB/swa51waZwFh8nhBYWRIOzetciTP3H9fU
	9Rjff8SH/0kTu
X-Received: by 2002:a2e:828f:0:b0:2c9:e9eb:8ccb with SMTP id y15-20020a2e828f000000b002c9e9eb8ccbmr3769066ljg.69.1702479324254;
        Wed, 13 Dec 2023 06:55:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHviyKH7wfcVf+I7xtZv4/UFi1AvA8vImQUb3UJSgTbMIYjDNrX0hdJf2t7gC7r7QeAbgewkg==
X-Received: by 2002:a2e:828f:0:b0:2c9:e9eb:8ccb with SMTP id y15-20020a2e828f000000b002c9e9eb8ccbmr3769060ljg.69.1702479323843;
        Wed, 13 Dec 2023 06:55:23 -0800 (PST)
Received: from redhat.com ([2a02:14f:16d:d414:dc39:9ae8:919b:572d])
        by smtp.gmail.com with ESMTPSA id ck9-20020a0564021c0900b0054f4097fea2sm5763020edb.0.2023.12.13.06.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 06:55:23 -0800 (PST)
Date: Wed, 13 Dec 2023 09:55:18 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tobias Huschle <huschle@linux.ibm.com>
Cc: Jason Wang <jasowang@redhat.com>, Abel Wu <wuyun.abel@bytedance.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
Message-ID: <20231213094854-mutt-send-email-mst@kernel.org>
References: <20231208052150-mutt-send-email-mst@kernel.org>
 <53044.123120806415900549@us-mta-342.us.mimecast.lan>
 <20231209053443-mutt-send-email-mst@kernel.org>
 <CACGkMEuSGT-e-i-8U7hum-N_xEnsEKL+_07Mipf6gMLFFhj2Aw@mail.gmail.com>
 <20231211115329-mutt-send-email-mst@kernel.org>
 <CACGkMEudZnF7hUajgt0wtNPCxH8j6A3L1DgJj2ayJWhv9Bh1WA@mail.gmail.com>
 <20231212111433-mutt-send-email-mst@kernel.org>
 <42870.123121305373200110@us-mta-641.us.mimecast.lan>
 <20231213061719-mutt-send-email-mst@kernel.org>
 <25485.123121307454100283@us-mta-18.us.mimecast.lan>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <25485.123121307454100283@us-mta-18.us.mimecast.lan>

On Wed, Dec 13, 2023 at 01:45:35PM +0100, Tobias Huschle wrote:
> On Wed, Dec 13, 2023 at 07:00:53AM -0500, Michael S. Tsirkin wrote:
> > On Wed, Dec 13, 2023 at 11:37:23AM +0100, Tobias Huschle wrote:
> > > On Tue, Dec 12, 2023 at 11:15:01AM -0500, Michael S. Tsirkin wrote:
> > > > On Tue, Dec 12, 2023 at 11:00:12AM +0800, Jason Wang wrote:
> > > > > On Tue, Dec 12, 2023 at 12:54 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> 
> [...]
> > 
> > Apparently schedule is already called?
> > 
> 
> What about this: 
> 
> static int vhost_task_fn(void *data)
> {
> 	<...>
> 	did_work = vtsk->fn(vtsk->data);  --> this calls vhost_worker if I'm not mistaken
> 	if (!did_work)
> 		schedule();
> 	<...>
> }
> 
> static bool vhost_worker(void *data)
> {
> 	struct vhost_worker *worker = data;
> 	struct vhost_work *work, *work_next;
> 	struct llist_node *node;
> 
> 	node = llist_del_all(&worker->work_list);
> 	if (node) {
> 		<...>
> 		llist_for_each_entry_safe(work, work_next, node, node) {
> 			<...>
> 		}
> 	}
> 
> 	return !!node;
> }
> 
> The llist_for_each_entry_safe does not actually change the node value, doesn't it?
> 
> If it does not change it, !!node would return 1.
> Thereby skipping the schedule.
> 
> This was changed recently with:
> f9010dbdce91 fork, vhost: Use CLONE_THREAD to fix freezer/ps regression
> 
> It returned a hardcoded 0 before. The commit message explicitly mentions this
> change to make vhost_worker return 1 if it did something.
> 
> Seems indeed like a nasty little side effect caused by EEVDF not scheduling
> the woken up kworker right away.


So we are actually making an effort to be nice.
Documentation/kernel-hacking/hacking.rst says:

If you're doing longer computations: first think userspace. If you
**really** want to do it in kernel you should regularly check if you need
to give up the CPU (remember there is cooperative multitasking per CPU).
Idiom::

    cond_resched(); /* Will sleep */


and this is what vhost.c does.

At this point I'm not sure why it's appropriate to call schedule() as opposed to
cond_resched(). Ideas?


-- 
MST


