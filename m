Return-Path: <kvm+bounces-10294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E5DE86B730
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 19:30:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCFB228793F
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 18:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B1171EA9;
	Wed, 28 Feb 2024 18:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pjd.dev header.i=@pjd.dev header.b="OgxTX3qy";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jWn0wqXw"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh8-smtp.messagingengine.com (fhigh8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD224087B;
	Wed, 28 Feb 2024 18:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709144988; cv=none; b=EAj8vKF41bBjkRD3b7EdkHkVdFZTSd0LXSDat8XstSseOTVNWkE8wOIwxdm7/5gEFVsteU1bmb8PZD5amNCRr2uBMivzLe6mLgucepDos1o5tjugMZ47TmsM4al0naM2E8A3gj+EhcGVoyC+m1gAYM392vhs0+m98Hd9EAbT4R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709144988; c=relaxed/simple;
	bh=TsPjkHBJygap37cRuTpCQBI1U2BypmTxAUkUzYlptt8=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc; b=bw69S4sZvdy2hLCU5psRq/g3aL6lO+ZnJ05BRIPcGBFzIvKChevcjspWgblEeWCi3DHxdQtBBs7Akf49Z+0zXRHWiYsfsXPmD4KvrRJ95OftBAdJA9VJukYHsRHVLy4XIb/zLIPOzODd3Byy/H3TBHwopUPjxyKdDxX9KWT9rrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pjd.dev; spf=pass smtp.mailfrom=pjd.dev; dkim=pass (2048-bit key) header.d=pjd.dev header.i=@pjd.dev header.b=OgxTX3qy; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jWn0wqXw; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pjd.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pjd.dev
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id CF9481140084;
	Wed, 28 Feb 2024 13:29:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 28 Feb 2024 13:29:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pjd.dev; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to; s=fm2; t=1709144985; x=1709231385; bh=TsPjkHBJygap3
	7cRuTpCQBI1U2BypmTxAUkUzYlptt8=; b=OgxTX3qyRLfeRejawo+b1Jx1E79Mj
	rpJAYSMK4P+vjxCWRkc06HkM5UdZGsRSAKz/flI583jDolahfrivzWGIZYFjwc/Y
	DI+4zbBm47E/eQNfldO7S8++akk+Rb9AvIMC/O12HAZ1fGyk2T9LOVn6tYupdO/8
	4oXnaL/PmQiN8wlvat3qUBS/3DEooVV7jfaBZQEGfCvSVuv6eAsXcDH+6zgHruJV
	cnFvHcIyIZ1gfSwSBllFpb4/GU+cmqDurKDNPL+LdrCJUt+Rr8Dfef/0DlGER58k
	bqnB7NVyuoEZIxwQGlNxb9Ly3u6U04A6m2q6pSpvgq+APLcZYOFU3hBgA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1709144985; x=1709231385; bh=TsPjkHBJygap3
	7cRuTpCQBI1U2BypmTxAUkUzYlptt8=; b=jWn0wqXwKPRHZCvPhztlSVq+OdzMU
	cdmH8zdtqFASFGM0Ay04zD/HgE1TB7qMCUVn9xcCC3jlf/XC91XnH08Dz2OoZ9W7
	0TQdkD3vmNliSAk0NDQRmofggu6v2164gVg3JCbA8jEYOjwBDGHeZukklYimnJe0
	dWKZzoQhjHaSl2xcywoA/wp8OZBSbUlFRRbgR+BPvshGm2ALQTN9WpID6e7DkJ12
	fHAMyE5pOR2Y4Ahb+ddp1/br+SCY3Z0TVd4Zmg9SBzwNDG6NvR67bAl30sEnaXdR
	dJLX4FqSc6U1SbH8ckkPi171J4kEH4hKAm+UkXIiqljZye9O8HYIrGX3w==
X-ME-Sender: <xms:mXvfZUm7Fd2vwXbSn-tWBoFRrdeE9L7M1XpMbHvJZWehnj0vlcXI9A>
    <xme:mXvfZT1wxuWHLQlRt2Iikqqkr6PrnkNLJ7KSGV6u40bwUwDXXKPEvI5OwJss2qVbR
    XbTI8nQyKSiImLo-SA>
X-ME-Received: <xmr:mXvfZSrw8HOY3JJi_1ufQHrl1P936uxHsDGhlICgxVM1pvnkijgN8LtUaR1T5zs5ykiRrQ7ySeaqFgxIAxB4-Ln5_QtKhMPRwN3AYYwPvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrgeejgddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenuchmihhsshhinhhgucfvqfcufhhivghlugculdeftd
    dmnecujfgurhephfgtgfgguffkffevofesthhqmhdthhdtjeenucfhrhhomheprfgvthgv
    rhcuffgvlhgvvhhorhihrghsuceophgvthgvrhesphhjugdruggvvheqnecuggftrfgrth
    htvghrnhepjeffvdeigfevgfefhfeutdeijeekieehfeefvdefhedtfefhhfdutdefieeh
    geevnecuffhomhgrihhnpehstghhvggurdgtohhmpdhqvghmuhdrohhrghdpghhithhhuh
    gsrdgtohhmpdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehpvghtvghrsehpjhgurdguvghv
X-ME-Proxy: <xmx:mXvfZQlq9-xvJ4sbfiIGfDWaiXp0jkzNdWj_A_-TGveCZbdejRfQ8Q>
    <xmx:mXvfZS0ALPkaZQuibMXDcDwcLMkBKr_EAQlHqKhUUcdgeJdkOZpypg>
    <xmx:mXvfZXsdR1B7YT63VC3sJMJLcnAcSWqK60huyNC5TBZl377_qeMitA>
    <xmx:mXvfZcqEfDZnBoQsxsNqTNowBnj8eqcSB66nfJEtJx6sNW-szSFHjQ>
Feedback-ID: i9e814621:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Feb 2024 13:29:44 -0500 (EST)
From: Peter Delevoryas <peter@pjd.dev>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.400.31\))
Subject: [q&a] Status of IOMMU virtualization for nested virtualization
 (userspace PCI drivers in VMs)
Message-Id: <3D96D76D-85D2-47B5-B4C1-D6F95061D7D6@pjd.dev>
Date: Wed, 28 Feb 2024 10:29:32 -0800
Cc: qemu-devel <qemu-devel@nongnu.org>,
 suravee.suthikulpanit@amd.com,
 iommu@lists.linux.dev,
 alex.williamson@redhat.com,
 kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.3774.400.31)

Hey guys,

I=E2=80=99m having a little trouble reading between the lines on various =
docs, mailing list threads, KVM presentations, github forks, etc, so I =
figured I=E2=80=99d just ask:

What is the status of IOMMU virtualization, like in the case where I =
want a VM guest to have a virtual IOMMU?

I found this great presentation from KVM Forum 2021: [1]

1. I=E2=80=99m using -device intel-iommu right now. This has performance =
implications and large DMA transfers hit the vfio_iommu_type1 =
dma_entry_limit on the host because of how the mappings are made.

2. -device virtio-iommu is an improvement, but it doesn=E2=80=99t seem =
compatible with -device vfio-pci? I was only able to test this with =
cloud-hypervisor, and it has a better vfio mapping pattern (avoids =
hitting dma_entry_limit).

3. -object iommufd [2] I haven=E2=80=99t tried this quite yet, planning =
to: if it=E2=80=99s using iommufd, and I have all the right kernel =
features in the guest and host, I assume it=E2=80=99s implementing the =
passthrough mode that AMD has described in their talk? Because I imagine =
that would be the best solution for me, I=E2=80=99m just having trouble =
understanding if it=E2=80=99s actually related or orthogonal. I see AMD =
has -device amd-viommu here [3], is that ever going to be upstreamed or =
is that what -object iommufd is abstracting? I also found this mailing =
list submission [4], and the context and changes there imply this is all =
about that (exposing iommu virtualization to the guest)

Thanks!
Peter
=20
[1] =
https://static.sched.com/hosted_files/kvmforum2021/da/vIOMMU%20KVM%20Forum=
%202021%20-%20v4.pdf
[2] https://www.qemu.org/docs/master/devel/vfio-iommufd.html
[3] =
https://github.com/AMDESE/qemu/commit/ee056455c411ee3369a47c65ba8a54783b5d=
2814
[4] =
https://lore.kernel.org/lkml/20230621235508.113949-1-suravee.suthikulpanit=
@amd.com/


