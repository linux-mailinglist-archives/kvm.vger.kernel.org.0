Return-Path: <kvm+bounces-10469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DF1F486C5B9
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 10:41:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 167A41C21EC2
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 09:41:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03C1560EFE;
	Thu, 29 Feb 2024 09:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Mg3X5mZX"
X-Original-To: kvm@vger.kernel.org
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2BE60DDC;
	Thu, 29 Feb 2024 09:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709199683; cv=none; b=YLI/UrvMkOjkdklAFHEd/NpUzMdf13CpOyzH8a8g+S+vH+MySF2unjN+R4ZOuFWqzelYAgAGaZcdlZ+3wxcgrkrSQU/dkMSOVtN+lvy/3dXV0DGHeCwzCQjNt2PXjYhkENmZbpMWMH+SVuFRLKMoiHq7ywGA59sgfJx9WX5U4AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709199683; c=relaxed/simple;
	bh=OO8aoyT7wIiEkulpJ6X9uJBZ8SvU8RhO2TJweGqWu6c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lal2Dn+Pj1FHcaqJi97/pnEZJlXytVsdd6u/NwPE0hkCoV/rScDkjLFQHYE4oyoErAzcQ87xpXxMPrLGYJdUkPO8HgspJOfJs52y6ewSP9tomV42Zcw+WGnF3Luf63LcxpB8xR+vXgiXh9MVRKAXzvzDNrHnkeveTZ7P+njiIJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Mg3X5mZX; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=OO8aoyT7wIiEkulpJ6X9uJBZ8SvU8RhO2TJweGqWu6c=;
	t=1709199679; x=1710409279; b=Mg3X5mZX6GA2ZQHUJR9a0c1RBdPmEFRVKTNo2EbtnZ405YE
	O29E7V1ituQf9PtGtMp0eEsdICq/XCWoZgNPkdysdMhBt+2K+eR+ErN3+bJ8gCgjFrEUQG1gYrmra
	9d+nR5CfXYv1IU2m28wGiynznxoa63MaKkrw017xgPzPVxzi3U4HdA3DqSda9ZrgXIVPZqEpTq4UQ
	ux8EiWxVmSSDPHP6+g69MQyCxWMH3E8+KtGMs6Huyf9cuuAK7EtRWaQeQoLz9N99fljg9xww3QD/q
	rvfm6/J7wmzw7EKTLl3UwO7jtW1S57vLQp+sZdFdCJyQIh0F2NTd2+fN/eVfrSog==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.97)
	(envelope-from <johannes@sipsolutions.net>)
	id 1rfcuf-0000000DTl5-2P62;
	Thu, 29 Feb 2024 10:41:13 +0100
Message-ID: <4825d7812ac06be3322ca4ae74e3650b2b0cd8de.camel@sipsolutions.net>
Subject: Re: [PATCH vhost v3 00/19] virtio: drivers maintain dma info for
 premapped vq
From: Johannes Berg <johannes@sipsolutions.net>
To: "Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo
	 <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Jason Wang
 <jasowang@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Hans de Goede <hdegoede@redhat.com>, Ilpo
 =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>, Vadim
 Pasternak <vadimp@nvidia.com>, Bjorn Andersson <andersson@kernel.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Cornelia Huck
 <cohuck@redhat.com>, Halil Pasic <pasic@linux.ibm.com>, Eric Farman
 <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian
 Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle
 <svens@linux.ibm.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>,  linux-um@lists.infradead.org,
 netdev@vger.kernel.org,  platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,  linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, bpf@vger.kernel.org
Date: Thu, 29 Feb 2024 10:41:11 +0100
In-Reply-To: <20240229043238-mutt-send-email-mst@kernel.org>
References: <20240229072044.77388-1-xuanzhuo@linux.alibaba.com>
	 <20240229031755-mutt-send-email-mst@kernel.org>
	 <1709197357.626784-1-xuanzhuo@linux.alibaba.com>
	 <20240229043238-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 (3.50.4-1.fc39) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Thu, 2024-02-29 at 04:34 -0500, Michael S. Tsirkin wrote:
>=20
> So the patchset is big, I guess it will take a couple of cycles to
> merge gradually.

Could also do patches 7, 8, and maybe 9 separately first (which seem
reasonable even on their own) and get rid of CC'ing so many people and
lists for future iterations of the rest of the patchset :-)

johannes

