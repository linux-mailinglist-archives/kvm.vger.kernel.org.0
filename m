Return-Path: <kvm+bounces-43420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 204B8A8B94B
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 14:37:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC1E23AB45B
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 12:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 112BA1459F7;
	Wed, 16 Apr 2025 12:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="kn46jmGc"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E053E61FF2
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 12:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744807034; cv=none; b=RCsp+am3Dxsjjz5of8RSVwJgMclKp7bEdYA/CiDD6ZPCqEQeJceQMPx5O49Y3o+HfR9l2Q5TDe1IoVbCOBgP6zP8WjcKZtoiszAywGW0luiSe1n+NfVr4GQwMd1M4TZU45+KAEB6/UndkwPYm9M//kCFAU2A6lVagMsR8wm8hf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744807034; c=relaxed/simple;
	bh=nVrH3mtSZEP8fIRoFl5ZEEX1SX/ppwAenWERY9UyFlw=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=YfFnPlzCDF7ee9cuUtbnarbjP21wyibJglcLT/C3E19aiSf/pZ8aPGvdGmcjEkc2uHwEwPa31KnRbbkgYDhSi9sxdXcuG8/GuqMiTFcP9MWG75409TBKxknHqfJ5IsAlUyOcwQRS2L0+C7HSR0RCtLq6Dd9wXfY3vQvwschdrOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=kn46jmGc; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1u520g-002des-U4; Wed, 16 Apr 2025 14:36:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
	Cc:To:Subject:From:MIME-Version:Date:Message-ID;
	bh=Cfur1eQywpvIitbgUboBvGAu60qJRizrYqb091rvp3w=; b=kn46jmGc0XyVG007rY/V3em+Mv
	mxOfwHGL4AgAjniU4bLR/KI264VE/uaVYrfN3bPDSs3MNUqiyLGCz20Aqb+G9VIa/C4roqdfIeaFa
	3pxy0ZuyEtQ3Ar6vcPd1o4ROWiv0ucdMFsU4Gts4xl3sTF01MwZeKvLQ0ZA9VE4g6rACZlTGv4V/6
	HoW/qR1veXcgyjcP1njnJ8mI71zRSLqIdsFdA8y+n45xYNh6vQPraKqJNQpFCuJ41KXNrvvY9wxn3
	jdtVsGLm5KcY4p0yIgYgU1b4pyQoKBX5f8ZTW3UjCmZPfdiXVwfSCoqMpC972EEXUVzBL6E52sNvv
	H6scHFqw==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1u520f-0005UK-GS; Wed, 16 Apr 2025 14:36:57 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1u520b-008oyA-NX; Wed, 16 Apr 2025 14:36:53 +0200
Message-ID: <a3ed036f-5153-4d4c-bf71-70b060dd5b2f@rbox.co>
Date: Wed, 16 Apr 2025 14:36:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Michal Luczaj <mhal@rbox.co>
Subject: Re: [PATCH net-next 1/2] vsock: Linger on unsent data
To: Stefano Garzarella <sgarzare@redhat.com>, Paolo Abeni <pabeni@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250407-vsock-linger-v1-0-1458038e3492@rbox.co>
 <20250407-vsock-linger-v1-1-1458038e3492@rbox.co>
 <22ad09e7-f2b3-48c3-9a6b-8a7b9fd935fe@redhat.com>
 <hu4kfdobwdhrvlm5egbbfzxjiyi6q32666hpdinywi2fd5kl5j@36dvktqp753a>
Content-Language: pl-PL, en-GB
In-Reply-To: <hu4kfdobwdhrvlm5egbbfzxjiyi6q32666hpdinywi2fd5kl5j@36dvktqp753a>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/11/25 12:32, Stefano Garzarella wrote:
> On Thu, Apr 10, 2025 at 12:51:48PM +0200, Paolo Abeni wrote:
>> On 4/7/25 8:41 PM, Michal Luczaj wrote:
>>> Change the behaviour of a lingering close(): instead of waiting for all
>>> data to be consumed, block until data is considered sent, i.e. until worker
>>> picks the packets and decrements virtio_vsock_sock::bytes_unsent down to 0.
>>
>> I think it should be better to expand the commit message explaining the
>> rationale.

Sure, will do.

>>> Do linger on shutdown() just as well.
>>
>> Why? Generally speaking shutdown() is not supposed to block. I think you
>> should omit this part.
> 
> I thought the same, but discussing with Michal we discovered this on
> socket(7) man page:
> 
>    SO_LINGER
>           Sets or gets the SO_LINGER option.  The argument is a
>           linger structure.
> 
>               struct linger {
>                   int l_onoff;    /* linger active */
>                   int l_linger;   /* how many seconds to linger for */
>               };
> 
>           When enabled, a close(2) or shutdown(2) will not return
>           until all queued messages for the socket have been
>           successfully sent or the linger timeout has been reached.
>           Otherwise, the call returns immediately and the closing is
>           done in the background.  When the socket is closed as part
>           of exit(2), it always lingers in the background.
> 
> In AF_VSOCK we supported SO_LINGER only on close(), but it seems that 
> shutdown must also do it from the manpage.

Even though shutdown() lingering isn't universally implemented :/

If I'm reading the code correctly, TCP lingers only on close(). So,
following the man page on the one hand, mimicking TCP on the other?

