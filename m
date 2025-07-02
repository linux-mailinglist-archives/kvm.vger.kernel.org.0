Return-Path: <kvm+bounces-51284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 826DFAF111B
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 12:05:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3092E17ECC6
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 10:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A94EF252917;
	Wed,  2 Jul 2025 10:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R+7T92zz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF862367A2;
	Wed,  2 Jul 2025 10:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751450723; cv=none; b=PoddB8VsGVnvfOhQ0Qlz9cQoqaTuCcSLeW+Si5niVwQkTIcQx5wG/mbb7RrJFpg5v0N1736mvUDZAYd1oS5+mqPgnTTto7n6kWIID0zpQ64dnxPHPxYJ+9DnhsVUo1cF0zsE0acJXkiE0pJBAItBpKq4pa3PR6BRiP6nSY9RyVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751450723; c=relaxed/simple;
	bh=BZYRZ5TFWTzUNC3kGwjRxau2NjTbkYh6g4ciUE81fiA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=rRfPND9ghT88Y+ph547ksGjEpvFNFtCXzIQsbqbS4nrBUQFSR491xRR7xSGgwVd3vKLhbB0+egJf34Xzy7WO3+Z8y3EuXByNupGhNVXtauFg5GM5OC+iX9Er8qZz27IEEjn/CZ5uJbyzR5CtWA3ZtZ1RhOvCmZTUQc5+0SpGjVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R+7T92zz; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7494999de5cso5054466b3a.3;
        Wed, 02 Jul 2025 03:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751450722; x=1752055522; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a1APMQxBHqNTDFKhYsPJPgE3N0Q/GtKtTrkho+3f+8U=;
        b=R+7T92zzBmN0rC2/JzA8cdsRvjhFkQ66Iey249PTy2ulbDNWOBpOLEghj3T1LrQtI0
         baHETR4Luv+Ofm+qOHRhbn6JHhv4dNZJDZs6ZTBiMWy+/koMaoNLVLpPfFg0sDuT93g7
         KFREq9Gyv29xHTFURdNspaCZ9wPo0GYKy/HC+9Q30/7duTgKyZm3xN2ApK4OqYLOcPv3
         mkaRQZKr4B8rzUateJAjyyMvfo+ofoQUZ/RrKDDGsY/E9m4ICZ+UNULExRunZ7+jZxsg
         knHVzXcmXiPupwqJpPr9BncjqODCpIVQqvuroO5C/Ow8a557u8GUhncI/TpX5IdsvVd5
         tbPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751450722; x=1752055522;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a1APMQxBHqNTDFKhYsPJPgE3N0Q/GtKtTrkho+3f+8U=;
        b=RmgBKYsrzDpHqMCBspJB3dTvdLW43eSo7JUzWHvmhE8DGeBj17rJw6S6U9pZ5aQhaH
         Pasyx0w+LEyiY9iIFWmJb2Y4VpcETaaYpZI7UFX+P7eM9yCXeleJed3EjYM3V+exIzRM
         TYntCKV/2F11BbR3r6iaqwsDNDyo550sgZZZMNaiMxKl4o/XM6Zah2k/UejRCQhIVhpC
         1ntULs11p4+J6dKR1isQyXIY5BNugCjKLF0Da8K+JiJT5t/jwsi6kkHouk/kzcWxhDyI
         LMzymMIZjb0AD+YoKdcWe4NJtjhvBxAIxMkV+kxhIonSuP8/1OGtMjmfca146e7ehx+Z
         hIEw==
X-Forwarded-Encrypted: i=1; AJvYcCUHdehDxcdYajcevn6i35750FopPZ2CyZ9PF2m/12NG+8+nGPw4kQXIf/DDtagEUkEBh//Xmwfs@vger.kernel.org, AJvYcCV2zbzFcTd+hjm2jOci8HyUK98bK2SUUsIkiHHs3kxU+x3LvrtzH/rxzVuPEyepDIK/KUi9pDz+6VzAB4ZZ@vger.kernel.org, AJvYcCVRJVqrDpZyYansvtgOmQrJ85oamEXvukRPMH+eDWCwPVATcurn+v1uk0EyOUs74DMIY50=@vger.kernel.org
X-Gm-Message-State: AOJu0YxG8pG850Go3L0BDz/bIO+kvXzemR3D3dHk9WQG1NfN1EcgPf+E
	seN6mir4PMOO4oThKlGrsEozNYClcC8RKbPRp1feDwp9u4iHn9n4C5aQfZjwquv+qFdE6cf5
X-Gm-Gg: ASbGncuV/EzgZmAd0CG44HhLNggTt/9nkqMv4qcMjr31Xg3gsSAqyxIdjc849MVly7/
	/rPkflB6yv9mKHuCTVYRKcyfJJowbRlBO0RQAFZ8l6ejtGRYDFrR/QUqFDd+TM/wSSOE0DPvj0m
	kLSjomPPQSSTLesxrHsIMJnFtCDJbrpB7MpgqxL+4eBwClkZD6Tyhm1VOEDxm5ANiBJJqRw/qt+
	imGHngKgup+VhIN/ZqZ6Uyi6uNeFybDykEPXjdCDJYWU7BlIklmFitE59enFfW9vPFyLzevSoxh
	wL4Gyqq3d4WaKRFmIXZVymOG613jtMoyRp2BuVGwPGQ56C2Z9pQ+bg3DWM7ruDrdQmKQTQQ=
X-Google-Smtp-Source: AGHT+IFWOp01aw0H2f+dLbLSHH5rCRbGt+ICBReE5quNPSyRzZo0OhEWZTb45SRGcAxR8wdlx3Dh8Q==
X-Received: by 2002:a05:6a00:1411:b0:747:b043:41e5 with SMTP id d2e1a72fcca58-74b5126b4f3mr2992134b3a.16.1751450721399;
        Wed, 02 Jul 2025 03:05:21 -0700 (PDT)
Received: from smtpclient.apple ([23.132.124.130])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af57ef4dbsm14257833b3a.160.2025.07.02.03.05.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Jul 2025 03:05:20 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [RESEND PATCH net-next v4 2/4] hv_sock: Return the readable bytes
 in hvs_stream_has_data()
From: Xuewei Niu <niuxuewei97@gmail.com>
In-Reply-To: <mofyjvpvlrh75sfu7c7pi4ea6p5nkatkqqtnwpwne7uuhhl5ms@gaqcs3m6i6kx>
Date: Wed, 2 Jul 2025 18:05:03 +0800
Cc: mst@redhat.com,
 pabeni@redhat.com,
 jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com,
 davem@davemloft.net,
 netdev@vger.kernel.org,
 stefanha@redhat.com,
 leonardi@redhat.com,
 decui@microsoft.com,
 virtualization@lists.linux.dev,
 kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 fupan.lfp@antgroup.com,
 Xuewei Niu <niuxuewei.nxw@antgroup.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FDB4EF2E-60B4-4264-9F7F-3AA14A60F119@gmail.com>
References: <20250630075727.210462-1-niuxuewei.nxw@antgroup.com>
 <20250630075727.210462-3-niuxuewei.nxw@antgroup.com>
 <mofyjvpvlrh75sfu7c7pi4ea6p5nkatkqqtnwpwne7uuhhl5ms@gaqcs3m6i6kx>
To: Stefano Garzarella <sgarzare@redhat.com>
X-Mailer: Apple Mail (2.3826.600.51.1.1)


> On Jul 2, 2025, at 17:58, Stefano Garzarella <sgarzare@redhat.com> =
wrote:
>=20
> On Mon, Jun 30, 2025 at 03:57:25PM +0800, Xuewei Niu wrote:
>=20
> IMO here you should not reset the author to you, but you should keep
> Dexuan as authour of this patch.

Well, I did that. However, `./scripts/checkpatch.pl` is unhappy wihtout =
my SOB.
Perhaps I should ignore it, and will do in the next :) =20

>=20
>> When hv_sock was originally added, __vsock_stream_recvmsg() and
>> vsock_stream_has_data() actually only needed to know whether there
>> is any readable data or not, so hvs_stream_has_data() was written to
>> return 1 or 0 for simplicity.
>>=20
>> However, now hvs_stream_has_data() should return the readable bytes
>> because vsock_data_ready() -> vsock_stream_has_data() needs to know =
the
>> actual bytes rather than a boolean value of 1 or 0.
>>=20
>> The SIOCINQ ioctl support also needs hvs_stream_has_data() to return
>> the readable bytes.
>>=20
>> Let hvs_stream_has_data() return the readable bytes of the payload in
>> the next host-to-guest VMBus hv_sock packet.
>>=20
>> Note: there may be multpile incoming hv_sock packets pending in the
>> VMBus channel's ringbuffer, but so far there is not a VMBus API that
>> allows us to know all the readable bytes in total without reading and
>> caching the payload of the multiple packets, so let's just return the
>> readable bytes of the next single packet. In the future, we'll either
>> add a VMBus API that allows us to know the total readable bytes =
without
>> touching the data in the ringbuffer, or the hv_sock driver needs to
>> understand the VMBus packet format and parse the packets directly.
>>=20
>> Signed-off-by: Dexuan Cui <decui@microsoft.com>
>> Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
>> ---
>> net/vmw_vsock/hyperv_transport.c | 16 +++++++++++++---
>> 1 file changed, 13 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/net/vmw_vsock/hyperv_transport.c =
b/net/vmw_vsock/hyperv_transport.c
>> index 31342ab502b4..64f1290a9ae7 100644
>> --- a/net/vmw_vsock/hyperv_transport.c
>> +++ b/net/vmw_vsock/hyperv_transport.c
>> @@ -694,15 +694,25 @@ static ssize_t hvs_stream_enqueue(struct =
vsock_sock *vsk, struct msghdr *msg,
>> static s64 hvs_stream_has_data(struct vsock_sock *vsk)
>> {
>> 	struct hvsock *hvs =3D vsk->trans;
>> +	bool need_refill =3D !hvs->recv_desc;
>=20
> For v5 remember to fix this as Paolo suggested. Dexuan proposed a fix =
on his thread.

Will do. And big thanks to Dexuan for the great work.

Thanks,
Xuewei

> Stefano
>=20
>> 	s64 ret;
>>=20
>> 	if (hvs->recv_data_len > 0)
>> -		return 1;
>> +		return hvs->recv_data_len;
>>=20
>> 	switch (hvs_channel_readable_payload(hvs->chan)) {
>> 	case 1:
>> -		ret =3D 1;
>> -		break;
>> +		if (!need_refill)
>> +			return -EIO;
>> +
>> +		hvs->recv_desc =3D hv_pkt_iter_first(hvs->chan);
>> +		if (!hvs->recv_desc)
>> +			return -ENOBUFS;
>> +
>> +		ret =3D hvs_update_recv_data(hvs);
>> +		if (ret)
>> +			return ret;
>> +		return hvs->recv_data_len;
>> 	case 0:
>> 		vsk->peer_shutdown |=3D SEND_SHUTDOWN;
>> 		ret =3D 0;
>> --=20
>> 2.34.1
>>=20
>=20


