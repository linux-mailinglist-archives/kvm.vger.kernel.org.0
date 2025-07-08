Return-Path: <kvm+bounces-51786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07A14AFCF28
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 17:26:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42C28581F96
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 15:25:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6EE32E4240;
	Tue,  8 Jul 2025 15:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FSZVQxrj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5397223DE7;
	Tue,  8 Jul 2025 15:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751988246; cv=none; b=U9A/OeQoMO1zRC+VslE+zVNFCnJtKVSAR2OAxQDCJmMINAhKMPkGgFp7zcmygvfqkdGAS7ylhXsOkvULxXiC/xjDL3E8fZ9I6Su3OrB6UaXMrRZ0nPJmkJOnywSgY11Pq1zUOyHI636zngF7khLpZBTWM6atw3iei6nU7m1r4xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751988246; c=relaxed/simple;
	bh=yr3gvMFQgXX8b8aX0CGJXvc/BBawO2jjh3fHXaiX5m8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WYPi2Nnueua8WXH2EzNa3diQG0bUGwyqTJRtQiHZvO23DNkEmfalNf/UnRzShqabC0kfmuy3Lg7yiNtIZ1J2aVjj5E5Z1l1bE3AY3jCSCbBdiBrIXj7LZYdIQwNMta2VxJLDunGP6T6WSSRJcTYx4xjkV09qmeWXqC48t5iIoj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FSZVQxrj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727CAC4CEED;
	Tue,  8 Jul 2025 15:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751988246;
	bh=yr3gvMFQgXX8b8aX0CGJXvc/BBawO2jjh3fHXaiX5m8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FSZVQxrjumbhTPsELLC+VdAX7wVLp3/MDo5lNbcCtXBpdlQgxBKL1DNQ+CsBIMI8O
	 SsEHdcJidLFVaW7J3EyzLXnuv/gwjW2wA/reUuxDDzh4D+BWHk1ViWMkyTHN+5TiIc
	 qzJ1f/S9xcVNmY5UrlJfmOe6f3SaZnB0MJuI7h19e+HoSB6XWt+EtOgfJpveq3F/ga
	 nKlR9gUeYuXAN9ixRxRB4HLn4Byx+zKDOqf6VQthlSEWEsMmd5aRvhV69cGtigTFTf
	 H//en3rOBHi+ngpDo5YUWVO/9SjtDgIRC4k1mxYMnITgyn8uL1+GKUYjmKdpio1t67
	 b5NqUZnLHcMtg==
Date: Tue, 8 Jul 2025 08:24:04 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, Willem de
 Bruijn <willemdebruijn.kernel@gmail.com>, Jason Wang <jasowang@redhat.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Eugenio =?UTF-8?B?UMOpcmV6?=
 <eperezma@redhat.com>, Yuri Benditovich <yuri.benditovich@daynix.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>, Jonathan Corbet <corbet@lwn.net>,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v7 net-next 0/9] virtio: introduce GSO over UDP tunnel
Message-ID: <20250708082404.21d1fe61@kernel.org>
In-Reply-To: <20250708105816-mutt-send-email-mst@kernel.org>
References: <cover.1751874094.git.pabeni@redhat.com>
	<20250708105816-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 8 Jul 2025 11:01:30 -0400 Michael S. Tsirkin wrote:
> > git@github.com:pabeni/linux-devel.git virtio_udp_tunnel_07_07_2025
> > 
> > The first 5 patches in this series, that is, the virtio features
> > extension bits are also available at [2]:
> > 
> > git@github.com:pabeni/linux-devel.git virtio_features_extension_07_07_2025
> > 
> > Ideally the virtio features extension bit should go via the virtio tree
> > and the virtio_net/tun patches via the net-next tree. The latter have
> > a dependency in the first and will cause conflicts if merged via the
> > virtio tree, both when applied and at merge window time - inside Linus
> > tree.
> > 
> > To avoid such conflicts and duplicate commits I think the net-next
> > could pull from [1], while the virtio tree could pull from [2].  
> 
> Or I could just merge all of this in my tree, if that's ok
> with others?

No strong preference here. My first choice would be a branch based
on v6.16-rc5 so we can all pull in and resolve the conflicts that
already exist. But I haven't looked how bad the conflicts would 
be for virtio if we did that. On net-next side they look manageable.

