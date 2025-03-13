Return-Path: <kvm+bounces-40948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C91BA5FB88
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:26:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01A563B1B31
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:20:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9749F269D09;
	Thu, 13 Mar 2025 16:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mb9bIIEa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24227269895;
	Thu, 13 Mar 2025 16:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741882819; cv=none; b=f4lJ7s9I6RuPoyv2MWLQrFb7txateojZsrJU2XWFzVupctOyDPUk6lc3xzrEqtS4mjSQLFTDlSeZ+plJFUE0lGfqll1/Gqvoq1jVWRwQPpNV/rFFFaRzMBUtHSyl0NArSFfDx6QzLqTKdz/eFCazogAZNQIUzUhxSs0BRLnrJn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741882819; c=relaxed/simple;
	bh=MeouaPYUY+Y6+m89zPz2q/9mjsxSalWkhr/0fnbRPfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VtT4A5LQ5Y61LdqKSEUx+7ZVJs4Qjk5AMOXGpITwNWc1CPCD4DcqZpgviBnwBRx9ILTUvHAEVEa6wR2PsKM3C82L3dazf8VTA1DTbUBnk4LEEeqKguFIX1DJlY8Wq1AvoIxG07eamUs0WxAND9mL+euOwZd/JFP+kiZHZt/Weqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mb9bIIEa; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-224100e9a5cso25313475ad.2;
        Thu, 13 Mar 2025 09:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741882817; x=1742487617; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+FrtSM5QYV3ZSnhILX79ajDFfaROpVELvpAwwKaRM0o=;
        b=mb9bIIEaGkTqLdecEZZkLnK22Vb/xEmbc8BOugIElBGZhm31JSfnqEFrCMfnrXYpaZ
         nDJ6rAl2rddF7MEKKwx+L8s36YM9r/hxgDjNSdntXHReru1vFVZYgiMWRJwNal8js8ww
         IBpyT5ITEfvuGfVzYSg/46Y4w53Hkaa+0mmbT9tQ7qDvWoI75g6ykrb9kPl5siq9gPdl
         9k1T/IUpUTsMptrZENMXnynBhA8RUko3tG45EPVQo8z0huuL3TVmEEEFyUWNmAUaLnGY
         fBcsx2eTAoGTJvXr5TP7vwdWJmyyBB1N69cm0zRkB9GgiJw+zFDaLgCuDlyJkNzfR0Z4
         wEvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741882817; x=1742487617;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+FrtSM5QYV3ZSnhILX79ajDFfaROpVELvpAwwKaRM0o=;
        b=BwgRb6rZlHyzKHxYqe29h+dzSkei6j1e4vGAeON/mprlCkKKn/f7NCicZVahPB9tRS
         p+vJ4i5xJnwW3fIF0NHzB6p+gc8GSW7XSPlrzhJW1utdkEZLbNeT0ZetVY6FL887SlZL
         NrytPdaqIqNfG7ZVRrAmXJyBgL14cvcDBAz7aUfV/lDmmqyrQNGBwiy/bFrL7DL1ejpI
         cZPas9VotokPNt3rWxrYD4d937Kw/CEv7c2fTCfkGzsN6bWwfb7wIbfFaDr5sZfm7/kY
         G8By477AI21PDD2PN+AHzpln8HhP/gADDS9e//mWKXbazKRfJov4JAwJJ6Oy4N4drTWb
         IPag==
X-Forwarded-Encrypted: i=1; AJvYcCVEY/M0XfNdbdsLXWXo31TQebt9WilMpu2mb+r0bUF/u/E0MnEIUza8UjVfyp8bhKBrjno=@vger.kernel.org, AJvYcCVtEFSXvSmZiJHEcZj4BcxfkQ6TjU3zjwZgAqYdg05cO60qjFzZVM1p/34mLwQrLMedFQ8Wbr1G@vger.kernel.org, AJvYcCXCtoOVxmJ76CTSp8ymppH6L1jjf+Nmf8+X9bmdvFDLVRM73bl2Cpyboe1K5HTxvfWYetx+XfY5JeeHGfOh@vger.kernel.org, AJvYcCXWCPeOgpCboxHDpl/gCGp9DQgXuS3+FU6ORWmSoRdihEPO2Kw4WK3S8KlFSn1Gdd2C/sYAbAFffDdURkcG@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+/f6fhdlYRMQa/soA6ogIpPYKVbBJQj1wnzEfQs8wlP0aMAsG
	fZLfjkqtVSrSdkSy5rG+Lw2sUbWYjF/H1Ix8Mo/crMw4NiByO9i9
X-Gm-Gg: ASbGncualwGcwo+D1UskbU5flsSWZLIRhGUFNPIDxIDN9eZTD8Vw9nt1LKLzPwYrBU4
	TwgcX8HsP1dn+C5/+Eq418S24bzjsh5KMA71cASGuI39jn0QpfQBQOSenNuZS3u0rBVgWKWkL5j
	9Ut22vcQH5R8J/DadNzfH6ifqIMv89rO1rIIESh/c5kzCiHwaKSn09MoZL5ymR9SBxoylF+IVUV
	iv+KzRaeOoYIKnV0z8c6Nk9hIY+/Porytv2yuajJuowCQy+S4JKZwo6i4aVZehOyeVnlCyp7kkm
	NNavgIxJ5y6+aJrxVukYAwOQ5vuuPsbGaslOu4Nl2iS4MqD48FiGNeByTDzQSoykOg==
X-Google-Smtp-Source: AGHT+IEWJGd9h0feAugm799oiQTdsY9teLTJc2OsgE9nTLRDIkiU9dBSoHavuE6qoQrpZvxOwMlLtg==
X-Received: by 2002:a17:902:e748:b0:220:d601:a704 with SMTP id d9443c01a7336-225dd84bc8bmr1960855ad.18.1741882817018;
        Thu, 13 Mar 2025 09:20:17 -0700 (PDT)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:7::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c6ba724asm15226325ad.152.2025.03.13.09.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 09:20:16 -0700 (PDT)
Date: Thu, 13 Mar 2025 09:20:14 -0700
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/3] vsock: add namespace support to vhost-vsock
Message-ID: <Z9MFvkALRY/k3ITG@devvm6277.cco0.facebook.com>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <Z9JC0VoMwAHKjqEX@devvm6277.cco0.facebook.com>
 <zz5fnulfljo6hyxaveseq3dxfgljfs33m7ncsw6uod6wouaqhl@jzdmg6s7g5dw>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zz5fnulfljo6hyxaveseq3dxfgljfs33m7ncsw6uod6wouaqhl@jzdmg6s7g5dw>

On Thu, Mar 13, 2025 at 04:37:16PM +0100, Stefano Garzarella wrote:
> Hi Bobby,
> first of all, thank you for starting this work again!
> 

You're welcome, thank you for your work getting it started!

> On Wed, Mar 12, 2025 at 07:28:33PM -0700, Bobby Eshleman wrote:
> > Hey all,
> > 
> > Apologies for forgetting the 'net-next' prefix on this one. Should I
> > resend or no?
> 
> I'd say let's do a firts review cycle on this, then you can re-post.
> Please check also maintainer cced, it looks like someone is missing:
> https://patchwork.kernel.org/project/netdevbpf/patch/20250312-vsock-netns-v2-1-84bffa1aa97a@gmail.com/
> 

Duly noted, I'll double-check the ccs next time. sgtm on the re-post!

> > On Wed, Mar 12, 2025 at 01:59:34PM -0700, Bobby Eshleman wrote:
> > > Picking up Stefano's v1 [1], this series adds netns support to
> > > vhost-vsock. Unlike v1, this series does not address guest-to-host (g2h)
> > > namespaces, defering that for future implementation and discussion.
> > > 
> > > Any vsock created with /dev/vhost-vsock is a global vsock, accessible
> > > from any namespace. Any vsock created with /dev/vhost-vsock-netns is a
> > > "scoped" vsock, accessible only to sockets in its namespace. If a global
> > > vsock or scoped vsock share the same CID, the scoped vsock takes
> > > precedence.
> 
> This inside the netns, right?
> I mean if we are in a netns, and there is a VM A attached to
> /dev/vhost-vsock-netns witch CID=42 and a VM B attached to /dev/vhost-vsock
> also with CID=42, this means that VM A will not be accessible in the netns,
> but it can be accessible outside of the netns,
> right?
> 

In this scenario, CID=42 goes to VM A (/dev/vhost-vsock-netns) for any
socket in its namespace.  For any other namespace, CID=42 will go to VM
B (/dev/vhost-vsock).

If I understand your setup correctly:

	Namespace 1:
		VM A - /dev/vhost-vsock-netns, CID=42
		Process X
	Namespace 2:
		VM B - /dev/vhost-vsock, CID=42
		Process Y
	Namespace 3:
		Process Z

In this scenario, taking connect() as an example:
	Process X connect(CID=42) goes to VM A
	Process Y connect(CID=42) goes to VM B
	Process Z connect(CID=42) goes to VM B

If VM A goes away (migration, shutdown, etc...):
	Process X connect(CID=42) also goes to VM B

> > > 
> > > If a socket in a namespace connects with a global vsock, the CID becomes
> > > unavailable to any VMM in that namespace when creating new vsocks. If
> > > disconnected, the CID becomes available again.
> 
> IIUC if an application in the host running in a netns, is connected to a
> guest attached to /dev/vhost-vsock (e.g. CID=42), a new guest can't be ask
> for the same CID (42) on /dev/vhost-vsock-netns in the same netns till that
> connection is active. Is that right?
> 

Right. Here is the scenario I am trying to avoid:

Step 1: namespace 1, VM A allocated with CID 42 on /dev/vhost-vsock
Step 2: namespace 2, connect(CID=42) (this is legal, preserves old
behavior)
Step 3: namespace 2, VM B allocated with CID 42 on
/dev/vhost-vsock-netns

After step 3, CID=42 in this current namespace should belong to VM B, but
the connection from step 2 would be with VM A.

I think we have some options:
1. disallow the new VM B because the namespace is already active with VM A
2. try and allow the connection to resume, but just make sure that new
   connections got o VM B
3. close the connection from namespace 2, spin up VM B, hope user
	 manages connection retry
4. auto-retry connect to the new VM B? (seems like doing too much on the
   kernel side to me)

I chose option 1 for this rev mostly for the simplicity but definitely
open to suggestions. I think option 3 is also a simple implementation.
Option 2 would require adding some concept of "vhost-vsock ns at time of
connection" to each socket, so the tranport would know which vhost_vsock
to use for which socket.

> > > 
> > > Testing
> > > 
> > > QEMU with /dev/vhost-vsock-netns support:
> > > 	https://github.com/beshleman/qemu/tree/vsock-netns
> 
> You can also use unmodified QEMU using `vhostfd` parameter of
> `vhost-vsock-pci` device:
> 
> # FD will contain the file descriptor to /dev/vhost-vsock-netns
> exec {FD}<>/dev/vhost-vsock-netns
> 
> # pass FD to the device, this is used for example by libvirt
> qemu-system-x86_64 -smp 2 -M q35,accel=kvm,memory-backend=mem \
>   -drive file=fedora.qcow2,format=qcow2,if=virtio \
>   -object memory-backend-memfd,id=mem,size=512M \
>   -device vhost-vsock-pci,vhostfd=${FD},guest-cid=42 -nographic
> 

Very nice, thanks, I didn't realize that!

> That said, I agree we can extend QEMU with `netns` param too.
> 

I'm open to either. Your solution above is super elegant.

> BTW, I'm traveling, I'll be back next Tuesday and I hope to take a deeper
> look to the patches.
> 
> Thanks,
> Stefano
> 

Thanks Stefano! Enjoy the travel.

Best,
Bobby

