Return-Path: <kvm+bounces-7475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A065A842409
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 12:49:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F7701F280FD
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 11:49:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5FD76A33A;
	Tue, 30 Jan 2024 11:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="i/Xdb4g1"
X-Original-To: kvm@vger.kernel.org
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A146773C;
	Tue, 30 Jan 2024 11:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706615159; cv=none; b=CygpY2PUMGJqyMIjjxU51kiWdqi/Kx+QHXrLvObw5JWEfq4/iO9xwAQptux8PeVcPTZaWctIUvl35KLaA4nxBzjL38tBvEYIPAqLnZNQ662piBDJu4RX3mPj/HmQQ0Tl/22mHjYKINGniKuyR52FjXctTi+7l151JtvHqq7VfCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706615159; c=relaxed/simple;
	bh=v6u8urb/t5RppsI2712r4PdAFGHfelN/27Q36RQ/1/M=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To; b=GAL4fOso1WE6un3Oue8fYpTot89zQazt6YjKM8icv3SNuCyOn1we/H8RgjOU3TkgkwKkfPitH13blG5RSBHA4UhtRTk76qPSQEXCS6zVzSQ4R3g/EzP/XtYbnsMMXQRlLhtJfV+Q6rp0iBjwQoUDsprMw7VIXBD/kVE5quuPi04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=i/Xdb4g1; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706615155; h=Message-ID:Subject:Date:From:To;
	bh=68WGLYeT5XGxdBIWX7j3qvfnpmvTuS0nYBOOJmACvE8=;
	b=i/Xdb4g1cubmxx+x9Crfw1Fw3ENsH+wvPtI9vo9hRERrfZyU4lsiWIgzIE5OQAOahC+AO86BNZTmsCeJcBCiedjWPGriadC1cVJxCumrd0sxyNlGPDxJYetl5vJ5exPd913Vor17xtsvkiTlTB0a+ZClDYzGPKekC9xpO4WY0gI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R771e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0W.g5hEv_1706615152;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.g5hEv_1706615152)
          by smtp.aliyun-inc.com;
          Tue, 30 Jan 2024 19:45:53 +0800
Message-ID: <1706615031.7414055-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost 00/14] virtio remove dma info for premapped mode
Date: Tue, 30 Jan 2024 19:43:51 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Hans de Goede <hdegoede@redhat.com>,
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Vadim Pasternak <vadimp@nvidia.com>,
 Bjorn Andersson <andersson@kernel.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>,
 Eric Farman <farman@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 Benjamin Berg <benjamin.berg@intel.com>,
 Yang Li <yang.lee@linux.alibaba.com>,
 linux-um@lists.infradead.org,
 netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org,
 bpf@vger.kernel.org,
 virtualization@lists.linux.dev
References: <20240130030604.108463-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20240130030604.108463-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>


Please ignore this.

The new thread is sent.

	[PATCH vhost 00/17] virtio: drivers maintain dma info for premapped vq

	http://lore.kernel.org/all/20240130114224.86536-1-xuanzhuo@linux.alibaba.com

That includes the refactor of find_vqs().

Thanks.

