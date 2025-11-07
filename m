Return-Path: <kvm+bounces-62270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B02CC3E73D
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 05:35:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64A9A3AC83A
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 04:34:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48B4F2580F2;
	Fri,  7 Nov 2025 04:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="TJHdhz/x";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="iGPb+o4L"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7326315665C;
	Fri,  7 Nov 2025 04:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762490094; cv=none; b=IUgKqGVdMc8bwLZPluUiOuXPmDgTx7pysmMzmhhtoMjyf6v+Ge6JYsU6VcfYm3RzPiq10XFzdCtnVUKrgf/8qb5pwGhrPkunJUi0eahS9pB7TMoZcK13zU1h5XqFnyF2t0OVaDpZ/heDuVng0AX/BfRkXN5GYhHlP/ahuK5aWDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762490094; c=relaxed/simple;
	bh=LpDjai4q0rYZlNT/t/DaZw1QLei4+SJSHOyYk17Mi6A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KCarhoSvo/PsIyhOrUxxc9J4qtS7y74c8SiZ5ZpQlvwct2YRmcenXSnOscDylRkzqOgSxzFfPxBjlACcZODlxd97K5m4TmrQBTm3Noq1l/7R/9HDYlituP6rhZX/s0nzkLmvZDkf+X0DYI8XOUEXcqWvIifukJD5YFJdN3RrFOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=TJHdhz/x; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=iGPb+o4L; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 7F58B1D00064;
	Thu,  6 Nov 2025 23:34:51 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 06 Nov 2025 23:34:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762490091;
	 x=1762576491; bh=i6NkcmT2cWqYuHN9PAguwWxmbI/1ym/m58KYz13FB2c=; b=
	TJHdhz/xcuPEB5ScY1qi2mohtP/aEeG8Fyazew2tMRG0jdR4U83DvBtcfuMCu55U
	JT+jTJvqydmzcVJOKT1DUe1vN8qfiTL9XJnvtBjhgAbHMqY+TVjTkVbEaX/0DDAZ
	uJXiH3YCbZYcUeo7RHarR2njGVvTMjzUv1nBb9OeNLufoTOOIHtbNE+5lDJfK52+
	e3jfR9b2cvXnZqWW2B+YvY+syT520tXhguTlNNv29RR7IDcppkG1icUnMbVsGBBB
	Lk8ZPbwndSvrSnCwPU2zfxIFJSp+11jXrmMInSitF5eraYNLk0zNgGtIGKYnXiTs
	rHtot9j4bXWEFbHa/onGxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762490091; x=
	1762576491; bh=i6NkcmT2cWqYuHN9PAguwWxmbI/1ym/m58KYz13FB2c=; b=i
	GPb+o4LOdpGV+GQYm7IlR6Pbnx3D1KhkFOmRKLuWq1CmjBHtykVSS3Y5K8qXEfk8
	neFREorv6hRbda9i9NoEfgc4GEcSJP8ERslwD0l+WQf535K+KQl3NBWLuGT/9ETR
	d+yzR27HifYt9UIFOGp6WQUB7PfrshltMMQeudivYw2hOW5ryAQPSMVK8tuUuJzn
	qZO77TDe3fUj0bdq7zUjl7AqGpaus6VBxJGOBSQ/j1+xQe9yOdUdbi3UYdZNkg+B
	MVT0u21nFr4sNjB7hnKlmhqrgNb3ErQxQC/mXFSvcIuKzNI482ICPuXPc9/wu8mJ
	4qNqSYE1cPQAq1aq0Ir7w==
X-ME-Sender: <xms:6XYNaTjajKAVWvNAnAZAZFOcncDU0LAVaSe4WexRzDi7V4LOajeeyw>
    <xme:6XYNaTE7HNRpdUYdaHBqzxMA0ekXdGqpvryPCzBoAEh61Sy2zHfbozRK3fIZmT6kG
    EILRoKzm5Y778TS79N6jfwJhS3XORRHt_WT-nCKZpOtvITZ>
X-ME-Received: <xmr:6XYNadsRfRgyQi-ADM2b9Gda_KpzdHFsTW2qeZaUcOlKyDWDBzGcfV4M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeekjeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeelpdhmohguvgepshhm
    thhpohhuthdprhgtphhtthhopehlihhulhhonhhgfhgrnhhgsehhuhgrfigvihdrtghomh
    dprhgtphhtthhopegrlhgvgidrfihilhhlihgrmhhsohhnsehrvgguhhgrthdrtghomhdp
    rhgtphhtthhopehjghhgsehnvhhiughirgdrtghomhdprhgtphhtthhopehhvghrsggvrh
    htsehgohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpthhtohepshhhrghmvggv
    rhhkohhlohhthhhumhesghhmrghilhdrtghomhdprhgtphhtthhopehjohhnrghthhgrnh
    drtggrmhgvrhhonheshhhurgifvghirdgtohhmpdhrtghpthhtoheplhhinhhugidqtghr
    hihpthhosehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhhvmhesvhhgvg
    hrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhg
    vghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:6XYNacfTMQSWz5GClxrzf36bAr0qbksH68KIRYMN_9a8w_9OZwRGIA>
    <xmx:6XYNablesO7ufJ9URXRr4qD0kTEop4Ny6OtHHw8TvoplTOkIOwXwjg>
    <xmx:6XYNaXCbMJmshMBt7fB1YAHjvH8SGYcMLRq8nqOJ9rtmAng1bvCdiA>
    <xmx:6XYNadOQE9qLuczcc3nfgO2jRpkR62QTVmGqKY_EcTcReWVPvAJdew>
    <xmx:63YNaTKTVqQrUcW2lxGITWsVt4F48hP1Ho0L95dCDvG0GEJUZXAte0ta>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 6 Nov 2025 23:34:48 -0500 (EST)
Date: Thu, 6 Nov 2025 21:34:47 -0700
From: Alex Williamson <alex@shazbot.org>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
 <herbert@gondor.apana.org.au>, <shameerkolothum@gmail.com>,
 <jonathan.cameron@huawei.com>, <linux-crypto@vger.kernel.org>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 0/2] update live migration configuration region
Message-ID: <20251106213447.76dc2e3f.alex@shazbot.org>
In-Reply-To: <20251030015744.131771-1-liulongfang@huawei.com>
References: <20251030015744.131771-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 30 Oct 2025 09:57:42 +0800
Longfang Liu <liulongfang@huawei.com> wrote:

> On the new hardware platform, the configuration register space
> of the live migration function is set on the PF, while on the
> old platform, this part is placed on the VF.
> 
> Change v11 -> v12
> 	Standardize register BIT operations
...
> 
> Longfang Liu (2):
>   crypto: hisilicon - qm updates BAR configuration
>   hisi_acc_vfio_pci: adapt to new migration configuration
> 
>  drivers/crypto/hisilicon/qm.c                 |  27 ++++
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 130 +++++++++++++-----
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  23 +++-
>  include/linux/hisi_acc_qm.h                   |   3 +
>  4 files changed, 144 insertions(+), 39 deletions(-)

Applied to vfio next branch for v6.19 with discussed enum field change.
Thanks,

Alex

