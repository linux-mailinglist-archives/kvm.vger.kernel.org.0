Return-Path: <kvm+bounces-44877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2EC3AA46C3
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 11:18:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A6B75A105B
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 09:15:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6284A21D3F8;
	Wed, 30 Apr 2025 09:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="FYumJIzv"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E9321B182;
	Wed, 30 Apr 2025 09:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746004448; cv=none; b=jnL5PuvqBAuS/vMq2jtRxu52gHPuGtRqX0l9ISI/+UJ8oD+ORRS2ct0QHlbm1oLUsoNAPSUOq9gtrveEtkjyor4q/zp/OAtwwg0kPY3ErzZNI2RS8ByIo4EwtdtvdteqSzDeENOU6AAp3VRPdnwOVaiXgl/Ad2l22cvW7mGW72c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746004448; c=relaxed/simple;
	bh=UmJ1a9uyxO4qBe0uD05AacX6z8QM6GlJq7FD1s2cOiU=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=PekQTK6lgv2+I+zhkuHN1Wlaig22zr6szoocCPA4PJ6l0QiL9XTht4X8aJO537stZtJZ5blZhCNZOpOwpflQcmCQLD1fj1tmgW/48SJGhuto/0jXCRxnMo0RAZ9201XQ8Ufms7oW58v4Bog02/QO6L3bHmfcTfxauRlkTlso2+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=FYumJIzv; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uA3Vx-006EbZ-52; Wed, 30 Apr 2025 11:14:01 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
	Cc:To:Subject:From:MIME-Version:Date:Message-ID;
	bh=OHDVjJrfezwde0SpfzNn80K64q3m8Fq4JLDQRGdWtNQ=; b=FYumJIzvtRXzZfFYqswGPAUrMf
	IN4NKYFmEjHuY6MAfEvTCOGSfm2urYNLaKt1CgHSdYVt6H84SNtzSG6US//nuE1h9ZgYHKH5UQ90w
	GBMAozAYrOeZjPUrwHSR+jxaulcT23tfKwhc8YyBjgMWU7pNcOiZawIXAf/sKUHOJg2RaMVLQoVVY
	zpEknhdAMccJKDrhInwUwBQdAMrZAJL3v6jJQfYYrQGn+G5xQIRqjdYnvKNXXU0a0x2tOP36iAY8e
	fl8d6Av4+ZaWxztAShl9wPHORJeUVTa4lHKk3sb5kvbBciXTeH+EPT33m6QGbdfdqGxzsByOdtSXy
	dT7kh11A==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uA3Vv-00059H-Qg; Wed, 30 Apr 2025 11:14:00 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uA3Vn-000UCu-TS; Wed, 30 Apr 2025 11:13:51 +0200
Message-ID: <bd1bbdb7-8fc2-4569-8eac-157caded5731@rbox.co>
Date: Wed, 30 Apr 2025 11:13:50 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Michal Luczaj <mhal@rbox.co>
Subject: Re: [PATCH net-next v2 1/3] vsock: Linger on unsent data
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Luigi Leonardi <leonardi@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250421-vsock-linger-v2-0-fe9febd64668@rbox.co>
 <20250421-vsock-linger-v2-1-fe9febd64668@rbox.co>
 <km2nad6hkdi3ngtho2xexyhhosh4aq37scir2hgxkcfiwes2wd@5dyliiq7cpuh>
 <k47d2h7dwn26eti2p6nv2fupuybabvbexwinvxv7jnfbn6o3ep@cqtbaqlqyfrq>
 <ee09df9b-9804-49de-b43b-99ccd4cbe742@rbox.co>
 <wnonuiluxgy6ixoioi57lwlixfgcu27kcewv4ajb3k3hihi773@nv3om2t3tsgo>
 <5a4f8925-0e4d-4e4c-9230-6c69af179d3e@rbox.co>
 <CAGxU2F6YSwrpV4wXH=mWSgK698sjxfQ=zzXS8tVmo3D84-bBqw@mail.gmail.com>
 <81940d67-1a9b-42e1-8594-33af86397df6@rbox.co>
 <wff4t4owsukm2jynm2dhju4rrtegyjjlrhu7o5xppsxfqrcus4@wmsvcwkdtdat>
Content-Language: pl-PL, en-GB
In-Reply-To: <wff4t4owsukm2jynm2dhju4rrtegyjjlrhu7o5xppsxfqrcus4@wmsvcwkdtdat>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/28/25 15:56, Stefano Garzarella wrote:
> On Thu, Apr 24, 2025 at 01:24:59PM +0200, Michal Luczaj wrote:
>> On 4/24/25 10:36, Stefano Garzarella wrote:
>>> On Thu, 24 Apr 2025 at 09:53, Michal Luczaj <mhal@rbox.co> wrote:
>>>> On 4/24/25 09:28, Stefano Garzarella wrote:
> 
> [...]
> 
>>>> You're right, it was me who was confused. VMCI and Hyper-V have their own
>>>> vsock_transport::release callbacks that do not call
>>>> virtio_transport_wait_close().
>>>>
>>>> So VMCI and Hyper-V never lingered anyway?
>>>
>>> I think so.
>>>
>>> Indeed I was happy with v1, since I think this should be supported by
>>> the vsock core and should not depend on the transport.
>>> But we can do also later.
>>
>> OK, for now let me fix this nonsense in comment and commit message.
> 
> Thanks!
> 
>>
>> But I'll wait for your opinion on [1] (drop, squash, change order of
>> patches?) before posting v3.
> 
> I'm fine with a second patch to fix the indentation and the order looks 
> fine.
> 
> BTW I'm thinking if it makes sense to go back on moving the lingering in 
> the core. I mean, if `unsent_bytes` is implemented, support linger, if 
> not, don't support it, like now.
> 
> That said, this should be implemented in another patch (or eventually 
> another series if you prefer), so my idea is the following split:
> - use unsent_bytes() just in virtio
> - move linger support in af_vsock.c (depending on transports 
>    implementing unsent_bytes())
> - implement unsent_bytes() in other transports (in the future)
> 
> WDYT?

Sure, makes sense. Even though I'm not certain I understand "use
unsent_bytes() just in virtio" part. Anyway, we can carry the discussion to
v3:
https://lore.kernel.org/netdev/20250430-vsock-linger-v3-0-ddbe73b53457@rbox.co/

Note that I took the liberty to assume unsent_bytes() is always there for
loopback/virtio transports. Check for NULL is introduced when the code is
moved to core. By the end of the series it changes nothing, but I hope it's
a tiny bit more sensible.

Thanks,
Michal

