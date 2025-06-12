Return-Path: <kvm+bounces-49250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AFBEAD6B75
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 10:55:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFDC73AD9DA
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 08:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4220223DD7;
	Thu, 12 Jun 2025 08:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jRagvVIc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E2B1E51EB;
	Thu, 12 Jun 2025 08:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749718535; cv=none; b=ZduPvZdI2/PujJeue4FJ+lOxiTiTQM3QCgVhOx7u/N/JU6th/LB63B4IMjLL0tko/KHqFhKTVStiqlj+21eNX+s6cpk5BwDKBDcljZaG7thgQ34sbj6AWI9hwEe6DdJ7whlAdjd46vpKGGk0T5Fo6XuZqzTljpi+UE+FfRRJFEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749718535; c=relaxed/simple;
	bh=VZXDJzKIiAsBEUC2cmW7v9IAJ9vLIMf0Brbum9EX6hU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lp2eRpETHZOzNIpwOrUZ5hJhrsmuqfUP3tXnJuJ+vMwvQWoQDhim8I5vUwOAOqIQMwMSedHf6V1NnK+xDz5IwvQCd9IUi9DZxyiow65vYIEP74pDh5Yci+FKKUEZz5Qk5n457tVZ7tJMU0MACrMOp6aL4eofs2rZlATtRtV/ZWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jRagvVIc; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b2c41acd479so388137a12.2;
        Thu, 12 Jun 2025 01:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749718534; x=1750323334; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r+jaW01Ram8J0CFjvnmO+DegLpwAOHm96vNJd5ZWYGc=;
        b=jRagvVIcR5+oXJNjT3Oh14EY2N/Mj948PiPqQ7/HV5EsawcxPM1Xwo+duP0K/d6rCp
         BdFgys6oQyI4Xb3B3RDLzaeWHfDheJKDur96TWcR6RNKxG3D1tHRnNDhUeGajZVIKwb1
         XmqA5Ld62TONhF12k+yNI96qBVzDoubmBsg7vKTkgV1YRQ2oa1XjiTWyMhAtpPzFOrb9
         hQ6ZYSRntzq+3hfZb3w3ji5xtuTEh89keT027F6sZIL3nTFgA4cOzusfOyK+mUaU3n+H
         Fb2PzSi/v7pDw3BwG3zVgG6cNYgq0R32/jjecIqJU9emoiOde2eypqU0gCGDtafxLT6R
         pLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749718534; x=1750323334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r+jaW01Ram8J0CFjvnmO+DegLpwAOHm96vNJd5ZWYGc=;
        b=g/IdhZTU0q7V2GhopcBnZPklSLrqLjZvxbzNXfzP2uX5vrj3Re5sKuy73ouhyI+EK8
         DeUPLD3I7HVekuASv9xLDdO9e1p2rmBtakgssA0rDYU5oXWexP05K96iDiloRirzZJOb
         /v1O8+wbZ5SJXedMFvwBNOvorKJAY3K9FZcNIcJJtB1JvYtmGJpGfr2ztdWRU5A4y2qC
         fjeqNUXU8G3dFFro5KNCGLrgRazCt130cUlH8zmZapJOsThKLlVqWTZczfSG9zjJ7mvD
         XTpUwN4nmeTFJ9vvphIxHmx4kbcaliH18gj06ZrsJvu9mdgX9hE5lQQc2WQiD1hLkTQw
         n5Uw==
X-Forwarded-Encrypted: i=1; AJvYcCUidBLNdsPauz786y0q/0Anmi9U9C7cx9Ak/qsKguhGpIE3RURSbgGly3ZpTdraz9gbJT1RUnwRlGviiyFz@vger.kernel.org, AJvYcCWodxONwVXbSKPKBKYh8QFYhAFE31fe8N7yviCfOXvOsG24/a9lRf5WTuQC3SJTCsP4osg=@vger.kernel.org, AJvYcCXG4ZZBQH3RDNCszpK2tDkq5vlyDvEp8f8tE2PD9CtuhfhYIwFB2xqsjvoP64aeVJmv8Z6Ur+Ok@vger.kernel.org
X-Gm-Message-State: AOJu0Yxd1MXuGGlZk60qsHJGRBU9qoZEynwZeW5bJtEqo/qZqeQOYwF5
	yr2bppfGPBYzPQeGcJapNEGkjc2Yr7dnmPNkZeieUtnTfFcJ0Dsteqxu
X-Gm-Gg: ASbGncs3ri3I/3ds/nlbMHiPJTTaSQanX3J08NpF1URTIP27S3tmXyQeP7u2bwo09tP
	m1mhJJxBLyWW9vPFdsa8nIXIGgJZGGtR9NkPVAnI0l4TqA6SQ+731RuCDPCHs5AtipoP2T9+5HO
	8hqhze+GNi3IWDBQSogD8NbSZMsa0M+ThjUez4uEXOZ7jtu570vD0/THq/hWkkY6V4X/bbjN1mj
	OTWPANyK35vs1HRUH8byTIxTQwrESnKwZQN0LgEvUR40lXMIcn+nXiGDzVt7UtR1nZ9u5p7zLNL
	ebpM2f7yVjzm0kcQcx4INoWpAB4JIfO+ZMc4l1472mIiyZbafbJ62yBTUTiNbYpNHMMfncVpU0v
	Z7QLGmVKZ
X-Google-Smtp-Source: AGHT+IGjP2s+60vt5yfxvQLR/980gfc56krWjJoT6dyD3iyrJFgNwpVJkdwAlwAWklxXdUzbHas1Fg==
X-Received: by 2002:a17:90b:2e07:b0:312:1ae9:153a with SMTP id 98e67ed59e1d1-313c08c7f55mr3402555a91.25.1749718533518;
        Thu, 12 Jun 2025 01:55:33 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1c6ab91sm929480a91.48.2025.06.12.01.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 01:55:32 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com
Cc: Oxffffaa@gmail.com,
	avkrasnov@salutedevices.com,
	davem@davemloft.net,
	edumazet@google.com,
	eperezma@redhat.com,
	horms@kernel.org,
	jasowang@redhat.com,
	kuba@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	netdev@vger.kernel.org,
	niuxuewei.nxw@antgroup.com,
	niuxuewei97@gmail.com,
	pabeni@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net] vsock/virtio: fix `rx_bytes` accounting for stream sockets
Date: Thu, 12 Jun 2025 16:55:14 +0800
Message-Id: <20250612085514.996837-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAGxU2F4JkO8zxDZg8nTYmCsg9DaaH58o5L+TBzZxo+3TnXbA9Q@mail.gmail.com>
References: <CAGxU2F4JkO8zxDZg8nTYmCsg9DaaH58o5L+TBzZxo+3TnXbA9Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> On Thu, 12 Jun 2025 at 10:21, Xuewei Niu <niuxuewei97@gmail.com> wrote:
> >
> > > On Thu, 12 Jun 2025 at 08:50, Xuewei Niu <niuxuewei97@gmail.com> wrote:
> > > >
> > > > > On Thu, Jun 12, 2025 at 01:32:01PM +0800, Xuewei Niu wrote:
> > > > > > No comments since last month.
> > > > > >
> > > > > > The patch [1], which adds SIOCINQ ioctl support for vsock, depends on this
> > > > > > patch. Could I get more eyes on this one?
> > > > > >
> > > > > > [1]: https://lore.kernel.org/lkml/bbn4lvdwh42m2zvi3rdyws66y5ulew32rchtz3kxirqlllkr63@7toa4tcepax3/#t
> > > > > >
> > > > > > Thanks,
> > > > > > Xuewei
> > > > >
> > > > > it's been in net for two weeks now, no?
> > > >
> > > > Umm sorry, I didn't check the date carefully, because there are several
> > > > ongoing patches. Next time I'll check it carefully. Sorry again.
> > > >
> > > > It looks like no one is paying attention to this patch. I am requesting
> > > > someone interested in vsock to review this. I'd appreciate that!
> > >
> > > Which patch do you mean?
> > >
> > > Thanks,
> > > Stefano
> >
> > I am saying your patch, "vsock/virtio: fix `rx_bytes` accounting for stream
> > sockets".
> >
> > Once this gets merged, I will send a new version of my patch to support
> > SIOCINQ ioctl. Thus, I can reuse `rx_bytes` to count unread bytes, as we
> > discussed.
> 
> As Michael pointed out, it was merged several weeks ago in net tree,
> see https://lore.kernel.org/netdev/174827942876.985160.7017354014266756923.git-patchwork-notify@kernel.org/
> And it also landed in Linus tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=45ca7e9f0730ae36fc610e675b990e9cc9ca0714

I misunderstood Michael's point. I am new to this, and not familiar with
the process. Sorry about that...

> So, I think you can go head with your patch, right?
>
> Please remember to target net-next, since it will be a new feature IIRC.
> 
> Thanks,
> Stefano

Yes, I'll do it ASAP.

Thanks,
Xuewei

