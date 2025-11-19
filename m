Return-Path: <kvm+bounces-63689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FD70C6D556
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 09:12:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3362F4F5B2F
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 08:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F416332ABCA;
	Wed, 19 Nov 2025 07:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Do9on9N/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qI76pcys"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F06314D21
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 07:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763539130; cv=none; b=QaUt+pIQrXIcq9mCG6QTQMoJygqNOALtGRIv8cyWl4HDz7KC4uaLo1e6Q/ejiz5i+4uPIVAkRCCXjoVMfDwAm1VyBOxihZJ4iymscswNMXGShPfEypVJFWTifxdMpe5xSqk4OY8M3yzA2r6mLIbqJ0q03km2qblzNCaq5LnMljg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763539130; c=relaxed/simple;
	bh=ztPb0Oi9ktxAOJLg1T9PzO/fl6i4U/jNw5A/87EltNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nIMvQNuvnFw52xWtZNF6FCphdIH/vgsn2sfCB5lsMQfrv9gBZVBmgdgJjis+BqtGBwB4/e9ATEFjthuE9/hqkU+paRCluLaREKq/Jl+4yGHSeH5yht8/uqbdfu+mbBuY/32m9kU8Ifnhzth7Dky/qibpDYFdmvFiw+DQZUJAz28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Do9on9N/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qI76pcys; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763539127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h1kdukhMv0e5PS6jWRdXt6KYB0O1bYUGO99kB+sjRgQ=;
	b=Do9on9N/tgTDW9dS1uLDHIsGnt/JYhjOjxrWYxFxzyuRGf0KvfjgALVkK6mhnJgMeUx1uw
	gJLV4ivrmJiMvoWz9OAhG7kxxXke6LaVG0E9WY7rETnRumaaAgrNRKGSM/5pGmZ9F0Zkpn
	zRMKnVL8C8swMrvQchBwiRyJLn9uGqs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-Urzc-YPYNZi0RKKhTUkkdA-1; Wed, 19 Nov 2025 02:58:44 -0500
X-MC-Unique: Urzc-YPYNZi0RKKhTUkkdA-1
X-Mimecast-MFC-AGG-ID: Urzc-YPYNZi0RKKhTUkkdA_1763539123
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-429ca3e7245so2665029f8f.3
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 23:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763539123; x=1764143923; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h1kdukhMv0e5PS6jWRdXt6KYB0O1bYUGO99kB+sjRgQ=;
        b=qI76pcysZic5E21w8D+rsBZdukfMfleNARdiaqrV7bXJeASL/5AZxngwBgC/e66nji
         JeApmZ+jz2XB9/9gvyx0oD7S40LyN3Z4dN2B2HgB99MB279FtfYZ5AC3iUq3RN3BIUeO
         0aDHeU7Pep7NeSuFldlb/owhuy2kRFXt0C/iUXenZl5Yz3lFmlGPYg5QHPCDOQDzIkyR
         CuKrnOzBBUlvbS6hY1okFTrBbEuttTXtisV82bCwJAS3yBRjYsAq6SrEP9pbVE2wqwHz
         FWw+jskkHGKEyHLmdOC0i3CrWFfTAP+hwE8b8c/B6n3lEpbx3yDcnBa337amA7I/GW/B
         t2ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763539123; x=1764143923;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h1kdukhMv0e5PS6jWRdXt6KYB0O1bYUGO99kB+sjRgQ=;
        b=czZxBsnzfiDY66wyGMR1m7onc+Sl50RLpkUWZSLQjp2jmzYq/wCt4OakOFDsnw2zUH
         ou3uJYCOJ9Vz/ezLydwWYgFJEGA8VLxN5v95o5IW4BagstsuBXU+PGNeMCc9CNAaff01
         lW/jCXm1DnNoU8Lw7jd9v/KEuNF/gaYKeBQwNsPZmdlg5HpB3r8yXP9dwew7dBDaUPmT
         oezql0H+fPRTcyIDqo8DKmnpcXAJTVUb5lMmFe6aTReJrtvXuCZOwyeXezBMe9aXa7Pf
         F/Oj5pcgcw8VksErWSgh1QepMeVRyyY7XjhSYsW9HN/WKD3mWK729k83yBN10Wn4tRXM
         YqFg==
X-Forwarded-Encrypted: i=1; AJvYcCXTdS7trTXKYmh5jI49sKnYGhom1c16xtm4rOiaeiwuGv3eWL2S9cPQmf9LjMdrt40Ccb4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuTcCNlry+g97ayucY6edwzDMVmycdGu1M+xjI7TbKrb88IG1F
	aByX+QhIciQfESehEzqv/7GFoiZt5cHXxBuvqWvn+TttANhuBzRkORSG+eUesZnBey3txRRuqOm
	v9MqurHHvnj50EOWToQzsX4HdWkHFm9U2cW5EgezraoAuxZ0oGl4lVw==
X-Gm-Gg: ASbGncvLSuOFR89LryxJzf0dtRwPsx4YWk3UAWuM2ZGDW7N7/DOJB9ZA8s1ikcGPi4G
	zucwNaqecAZGFsKO75hCbeC4Dk4OmFvaCcS8FcnbxXscVqLr08tiw4xrT5DExJzIlYacqLwG6E9
	PzA+coaeyVCJZzCMD02z3k4b2PI/zdKOjt23sSOxVKbivBwDILxByW/2+RaJnIJRu39qCXtSm/r
	LcNLG20iGQjHUKH4jFnV/db52BFgcnKaX6rn62zc/Tj3LW5GNEMMvOSqlLKqdkRaLXZImTHteF4
	gFoP8nn8koloWyceKTOXkgAdb6Xk1VoGa4dhEaR5ZP9wIL+D+Y5ihNVHXYGsKIabh1OPL5/Xccb
	Mk2FrDLC+zWyn+f5Q2Au76f9uvZRQPA==
X-Received: by 2002:a5d:5d01:0:b0:42b:4177:7131 with SMTP id ffacd0b85a97d-42b595add99mr19386658f8f.44.1763539123183;
        Tue, 18 Nov 2025 23:58:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF/d9kIia5C1Rk173uB/q7uMGiJORCrpd/szircj7eTupOsjnjxbBmEFPJg4z/3AWkkns9YXA==
X-Received: by 2002:a5d:5d01:0:b0:42b:4177:7131 with SMTP id ffacd0b85a97d-42b595add99mr19386634f8f.44.1763539122739;
        Tue, 18 Nov 2025 23:58:42 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53f174afsm35614093f8f.33.2025.11.18.23.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 23:58:42 -0800 (PST)
Date: Wed, 19 Nov 2025 02:58:39 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Liming Wu <liming.wu@jaguarmicro.com>
Cc: Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Angus Chen <angus.chen@jaguarmicro.com>
Subject: Re: [PATCH] virtio_net: enhance wake/stop tx queue statistics
 accounting
Message-ID: <20251119025546-mutt-send-email-mst@kernel.org>
References: <20251118090942.1369-1-liming.wu@jaguarmicro.com>
 <CACGkMEvwedzRrMd9hYm7PbDezBu1GM3q-YcUhsvfYJVv=bNSdw@mail.gmail.com>
 <PSAPR06MB39429783A41F42FDD82477A2E1D7A@PSAPR06MB3942.apcprd06.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PSAPR06MB39429783A41F42FDD82477A2E1D7A@PSAPR06MB3942.apcprd06.prod.outlook.com>

On Wed, Nov 19, 2025 at 07:54:07AM +0000, Liming Wu wrote:
> > queue wake/stop events introduced by a previous patch.
> > 
> > It would be better to add commit id here.
> OK, thx.
> 
> > 
> eck. */
> > >                         free_old_xmit(sq, txq, false);
> > >                         if (sq->vq->num_free >= MAX_SKB_FRAGS + 2) {
> > > -                               netif_start_subqueue(dev, qnum);
> > > -
> > u64_stats_update_begin(&sq->stats.syncp);
> > > -                               u64_stats_inc(&sq->stats.wake);
> > > -
> > u64_stats_update_end(&sq->stats.syncp);
> > > +                               virtnet_tx_wake_queue(vi, sq);
> > 
> > This is suspicious, netif_tx_wake_queue() will schedule qdisc, or is this intended?
> Thanks for pointing this out.
> You're right — using netif_tx_wake_queue() here would indeed trigger qdisc scheduling, which is not intended in this specific path.
> My change tried to unify the wake/stop accounting paths, but replacing netif_start_subqueue() was not the right choice semantically.
> 
> I will restore netif_start_subqueue() at this site and keep only the statistic increment, so the behavior stays consistent with the original code while still improving the per-queue metrics.


Please do not send fluff comments like this to the list.

And with em-dashes too, for added flair.

If you can not bother writing email yourself why should
anyone bother reading it?




> > 
> > >                                 virtqueue_disable_cb(sq->vq);
> > >                         }
> > >                 }
> > > @@ -3068,13 +3080,8 @@ static void virtnet_poll_cleantx(struct
> > receive_queue *rq, int budget)
> > >                         free_old_xmit(sq, txq, !!budget);
> > >                 } while
> > > (unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> > >
> > > -               if (sq->vq->num_free >= MAX_SKB_FRAGS + 2 &&
> > > -                   netif_tx_queue_stopped(txq)) {
> > > -                       u64_stats_update_begin(&sq->stats.syncp);
> > > -                       u64_stats_inc(&sq->stats.wake);
> > > -                       u64_stats_update_end(&sq->stats.syncp);
> > > -                       netif_tx_wake_queue(txq);
> > > -               }
> > > +               if (sq->vq->num_free >= MAX_SKB_FRAGS + 2)
> > > +                       virtnet_tx_wake_queue(vi, sq);
> > >
> > >                 __netif_tx_unlock(txq);
> > >         }
> > > @@ -3264,13 +3271,8 @@ static int virtnet_poll_tx(struct napi_struct *napi,
> > int budget)
> > >         else
> > >                 free_old_xmit(sq, txq, !!budget);
> > >
> > > -       if (sq->vq->num_free >= MAX_SKB_FRAGS + 2 &&
> > > -           netif_tx_queue_stopped(txq)) {
> > > -               u64_stats_update_begin(&sq->stats.syncp);
> > > -               u64_stats_inc(&sq->stats.wake);
> > > -               u64_stats_update_end(&sq->stats.syncp);
> > > -               netif_tx_wake_queue(txq);
> > > -       }
> > > +       if (sq->vq->num_free >= MAX_SKB_FRAGS + 2)
> > > +               virtnet_tx_wake_queue(vi, sq);
> > >
> > >         if (xsk_done >= budget) {
> > >                 __netif_tx_unlock(txq); @@ -3521,6 +3523,9 @@ static
> > > void virtnet_tx_pause(struct virtnet_info *vi, struct send_queue *sq)
> > >
> > >         /* Prevent the upper layer from trying to send packets. */
> > >         netif_stop_subqueue(vi->dev, qindex);
> > > +       u64_stats_update_begin(&sq->stats.syncp);
> > > +       u64_stats_inc(&sq->stats.stop);
> > > +       u64_stats_update_end(&sq->stats.syncp);
> > >
> > >         __netif_tx_unlock_bh(txq);
> > >  }
> > > @@ -3537,7 +3542,7 @@ static void virtnet_tx_resume(struct
> > > virtnet_info *vi, struct send_queue *sq)
> > >
> > >         __netif_tx_lock_bh(txq);
> > >         sq->reset = false;
> > > -       netif_tx_wake_queue(txq);
> > > +       virtnet_tx_wake_queue(vi, sq);
> > >         __netif_tx_unlock_bh(txq);
> > >
> > >         if (running)
> > > --
> > > 2.34.1
> > >
> > 
> > Thanks
> 


