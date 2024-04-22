Return-Path: <kvm+bounces-15514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A88BF8ACF35
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 16:21:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC4F51C2137E
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 14:21:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A401514D6;
	Mon, 22 Apr 2024 14:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NKIrUlym"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6241509B5
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 14:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713795655; cv=none; b=i8S1BuCG9oYheBj60cexdbLYqjQUJ7SK5PheTalc0klB1DFIxsOYFiWfobkQfG0HYOQD/kiio7krU4Bfa+yVdp19GKeDDbgTFL6gMxM9LWpwrE3d8ZB1O2fyGi9gFvLONQuwmJHJUx5EeVaSX9H2qD3iXQlgSeK6vTK3VS6tfe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713795655; c=relaxed/simple;
	bh=/kXm2iITa7mixbm/BI6s4K3kvavVlcOxT5iq3POX+yA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LWAjoXFVqxbMZJsH0g4mYyIMErE8fVMNH9EJrX36ukGEUTRRPrR5FTjR4fD/YcJ2iPxHghJmsIp8EJHXDP2Qi7+3zpB6iJNc3vkKFrFwDic31I1mD4YYCYQIyNyJQ2PJiiR1QAf2ku4yMkV7clxsOoRBNLQSfE3IGPuOBoNtnRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NKIrUlym; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713795652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E6+FiyOvOBZ7UuUE5Up8WqG0I1zHgf4s1LLzpA3im1U=;
	b=NKIrUlym6nO6c+6LsMDz2j3RLvzPI3bl8cEZEZ8oPcolhhtemYLwymbsC+Y89O8W59NUAh
	bxqWWZcZFYQUwo+ss2DrOCpIP8NKBJo5fnONfBRNlz4VTqpZAA/jQ9oqezXE8RUhjiaiU6
	5r3dCzwgRIPisTp5leM83go4jMLOb/4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-232-vge-znu-Nb-yi3SWCM6fNg-1; Mon, 22 Apr 2024 10:20:51 -0400
X-MC-Unique: vge-znu-Nb-yi3SWCM6fNg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-343ee356227so2947535f8f.2
        for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 07:20:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713795649; x=1714400449;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E6+FiyOvOBZ7UuUE5Up8WqG0I1zHgf4s1LLzpA3im1U=;
        b=segAh1RvUom3byfIMqy6mM6AUjP2AyE29OrRwDQUN7k0KP5HaELjfnxIEswRfIA42Q
         3iaGco/24reX7rlcHfotHB+RlnoW49cSZDz5h2C+z1Qd0Plx9SdlcoBes+oIjEkKvP+w
         K93T+EJckjTAaPcwHzQP9nDNUeIT0b1CDSAzbiqZZSGA1Y1ZqEfI6PBvzCcM0WqdDkak
         LbLxdscmFMkvikazI9+VF6uNZiIg10VA8itg9AImR0ZDVYk341RU+0IYAYdvR4g2m2r3
         I/Akel3THsmevhccRzzRcdeYA5AuWrigkO5EN20A8lS9ElqmWtxLu+SNyVLDuMDJRZlC
         iG4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUSN0jo3gmf9bqenHR0AFFJqg6zArHlNoeD9P68tvB2FetJmEfUtpuoUXphNSa31cGHvH7O6Yi7lxg3EGjxAGwnxofM
X-Gm-Message-State: AOJu0Yzi6DGaveqrmJpJSJdlqsN1L7IHhN8aI508/Ty3iDMM9UYy646H
	uVE6AjhsLtpSvSVAdjXTgRjhM+Flv107H1RGE6NvwpozdonwSFZj3caErLJZGe/8kdYuAmE49UW
	FjfMA+gjkE7+X1LQAgwB+2/7wei2lVaPlQZKglGKSJDhEWrbciQ==
X-Received: by 2002:a5d:63cf:0:b0:343:eb6c:ae80 with SMTP id c15-20020a5d63cf000000b00343eb6cae80mr6747960wrw.28.1713795649150;
        Mon, 22 Apr 2024 07:20:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbTr9mNnSCZAdnGEG64hBhgMW1R+/LrCJEgrrihxGXhKjlIV3VfLADvpLX4fg/B6JyXt4zGg==
X-Received: by 2002:a5d:63cf:0:b0:343:eb6c:ae80 with SMTP id c15-20020a5d63cf000000b00343eb6cae80mr6747923wrw.28.1713795648480;
        Mon, 22 Apr 2024 07:20:48 -0700 (PDT)
Received: from redhat.com ([2a06:c701:7429:3c00:dc4a:cd5:7b1c:f7c2])
        by smtp.gmail.com with ESMTPSA id l18-20020a5d5612000000b0034a62e51429sm9041921wrv.112.2024.04.22.07.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Apr 2024 07:20:48 -0700 (PDT)
Date: Mon, 22 Apr 2024 10:20:43 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Jeongjun Park <aha310510@gmail.com>, jasowang@redhat.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	sgarzare@redhat.com,
	syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev,
	Arseny Krasnov <arseny.krasnov@kaspersky.com>
Subject: Re: [PATCH virt] virt: fix uninit-value in vhost_vsock_dev_open
Message-ID: <20240422100010-mutt-send-email-mst@kernel.org>
References: <20240420060450-mutt-send-email-mst@kernel.org>
 <20240421030606.80385-1-aha310510@gmail.com>
 <20240422130031.GA77895@fedora>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240422130031.GA77895@fedora>

On Mon, Apr 22, 2024 at 09:00:31AM -0400, Stefan Hajnoczi wrote:
> On Sun, Apr 21, 2024 at 12:06:06PM +0900, Jeongjun Park wrote:
> > static bool vhost_transport_seqpacket_allow(u32 remote_cid)
> > {
> > ....
> > 	vsock = vhost_vsock_get(remote_cid);
> > 
> > 	if (vsock)
> > 		seqpacket_allow = vsock->seqpacket_allow;
> > ....
> > }
> > 
> > I think this is due to reading a previously created uninitialized 
> > vsock->seqpacket_allow inside vhost_transport_seqpacket_allow(), 
> > which is executed by the function pointer present in the if statement.
> 
> CCing Arseny, author of commit ced7b713711f ("vhost/vsock: support
> SEQPACKET for transport").
> 
> Looks like a genuine bug in the commit. vhost_vsock_set_features() sets
> seqpacket_allow to true when the feature is negotiated. The assumption
> is that the field defaults to false.
> 
> The rest of the vhost_vsock.ko code is written to initialize the
> vhost_vsock fields, so you could argue seqpacket_allow should just be
> explicitly initialized to false.
> 
> However, eliminating this class of errors by zeroing seems reasonable in
> this code path. vhost_vsock_dev_open() is not performance-critical.
> 
> Acked-by: Stefan Hajnoczi <stefanha@redhat.com>



But now that it's explained, the bugfix as proposed is incomplete:
userspace can set features twice and the second time will leak
old VIRTIO_VSOCK_F_SEQPACKET bit value.

And I am pretty sure the Fixes tag is wrong.

So I wrote this, but I actually don't have a set for
seqpacket to test this. Arseny could you help test maybe?
Thanks!


commit bcc17a060d93b198d8a17a9b87b593f41337ee28
Author: Michael S. Tsirkin <mst@redhat.com>
Date:   Mon Apr 22 10:03:13 2024 -0400

vhost/vsock: always initialize seqpacket_allow

There are two issues around seqpacket_allow:
1. seqpacket_allow is not initialized when socket is
created. Thus if features are never set, it will be
read uninitialized.
2. if VIRTIO_VSOCK_F_SEQPACKET is set and then cleared,
then seqpacket_allow will not be cleared appropriately
(existing apps I know about don't usually do this but
it's legal and there's no way to be sure no one relies
on this).

To fix:
    - initialize seqpacket_allow after allocation
    - set it unconditionally in set_features

Reported-by: syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com
Reported-by: Jeongjun Park <aha310510@gmail.com>
Fixes: ced7b713711f ("vhost/vsock: support SEQPACKET for transport").
Cc: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index ec20ecff85c7..bf664ec9341b 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -667,6 +667,7 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	}
 
 	vsock->guest_cid = 0; /* no CID assigned yet */
+	vsock->seqpacket_allow = false;
 
 	atomic_set(&vsock->queued_replies, 0);
 
@@ -810,8 +811,7 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
 			goto err;
 	}
 
-	if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
-		vsock->seqpacket_allow = true;
+	vsock->seqpacket_allow = features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET);
 
 	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
 		vq = &vsock->vqs[i];


