Return-Path: <kvm+bounces-51283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E3C0BAF10F5
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 11:59:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20754165F6B
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 09:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 204F324466C;
	Wed,  2 Jul 2025 09:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DRtQMh0x"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A01C21B9D6
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 09:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751450357; cv=none; b=Iu8txdvKwD6gwwlYvMMe5s5LYcB9SVf/aq2E1j5y32IsCOLopQnp0HeJVVUNw0eiU7wOIY1qsHulbEK4GaQGhKChSLAIViDvCqAB2Lo/eu+mEruYS+fA8AeVJmfiPIXvZJfJcz10M3K5k7hCrxFV/PMeMNdWrvvaA3bjQNoFqkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751450357; c=relaxed/simple;
	bh=MPkoP+32gi4/DVKPXzxo9wfllMKOaCUc8HF+OAy1R00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A5CgPgrng2f9Fe6z7dww+mOHrbxxSFVDx37gzAwzQMEXoLRZo8aNceXbzcDa5VQ3d167DR0knAYQQDuyzj1QUU5qiEzEyDiyarf9owS1uRclvlHp7WlaiD9Jr6kYVY5AnUYMLGRI8iuHAXjrESZHmvm86NN69D8PI1pz2YDRO3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DRtQMh0x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751450353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2BELDn7cgIkAWV4mR8DE+PJmYwWVN5UbFvf5JUowPPU=;
	b=DRtQMh0xH5kRX6czHo8UYv1BzmuqIILl5eV1n+cPrsKUnRYItpmkDkTjiLfRHr3a50cEQD
	XvukCdU1iMrOv5h04CTdercLesF5gilgqDoLeUlvPFnkdvK8JYogD2iC2N1rLplXiJb1/3
	3vQWCQprYr0EpM6hZv47ukdkT9jLODg=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-LTkSzwuJNSKH2oYMWZy23Q-1; Wed, 02 Jul 2025 05:59:12 -0400
X-MC-Unique: LTkSzwuJNSKH2oYMWZy23Q-1
X-Mimecast-MFC-AGG-ID: LTkSzwuJNSKH2oYMWZy23Q_1751450352
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4a6f6d07bb0so96525041cf.1
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 02:59:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751450352; x=1752055152;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2BELDn7cgIkAWV4mR8DE+PJmYwWVN5UbFvf5JUowPPU=;
        b=PhzpUENVqcMUX5EGMlS1N/NftT2U/ceis7kYVqnUKCEK5I9sZfqgh+bccGTrRlwcv4
         YMamqSryVzBPcLfZ/ar/G71LKt8XwmpWr35CMFqttCNlxAMC2tsvm0HQEkRA/7A9Uswo
         qdR8N3vVNoUL4ER6eS9xt4zmgJo2E4U9ck34/zudU/XDOmEerw4aXgKUbXqzczynoQ/P
         cfnpCRZVIQbZDhE6eS/ojaQDCrzMZLlgVCqRCs+g0v+uzPbIV46SwBT81PD8A7JKP/Vc
         Cp7HRBfSRPGvWU9iCe7g6by6NbwV/vu9k5nS6n25BsMM5JPQpvf29lo5rleweFE+7H/g
         ustw==
X-Forwarded-Encrypted: i=1; AJvYcCW0d3pI63Z3JIzsgXewMA+zCSGv/lvT343Sq3oKApzsI6awTrxA6KgpxdQcB/7pvygXzIk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzN3dZ00C7JMT3aWvcYktGyuVbow/dPc9L5lkUKQHqSQCJb1Ppy
	uWRH8tlRdkDz62cWSNjWMiP+nLPVCgSp+I1NhAiSFkyA3U0RspOGel8E+pqD9/KWxix7cejtkLS
	04sG3ho7r65OM2qEyCnBoKnA2J4k6KqoJ9KcDQo6xvivJCcV7KJOQLA==
X-Gm-Gg: ASbGnctC/dSK45+zDBzw1J9hOVuFa35e3/ljJpUEGRl/qWhYZHNWGp/MzgV9VS71z6L
	1nIxRunPdcHjnK6pCOcuYrmV4GVXUS1BQVwJU2GwAF7o3uacjuuFnziIkPigvDAWGZDbtQE8Ev8
	8AfuD+AH/tAMcC8ubsTAr6+rBntyU3W+aGYPGE5Lfr5o5jUVtqqqSRIpYAyOFWvZ86XpXTCa1fq
	0FJKfu72Hqn7HC24N2cfXOz5imukJfE8yXjjCRt6bWj7M7Y8BAoj71CHo4R69pONUggd10R/rnJ
	xskHHCYc045qK7kKtIRrEgmOFfdw
X-Received: by 2002:a05:622a:156:b0:48c:a62c:756b with SMTP id d75a77b69052e-4a976970385mr35619871cf.25.1751450351743;
        Wed, 02 Jul 2025 02:59:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUSe8FhbuOGev3Og+XILWaBisyuQK6SRMWeCzQJsy/WSDvlGf3UEpPXNUfSztf5p5of2PIog==
X-Received: by 2002:a05:622a:156:b0:48c:a62c:756b with SMTP id d75a77b69052e-4a976970385mr35619611cf.25.1751450351299;
        Wed, 02 Jul 2025 02:59:11 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.164.126])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a7fc57dbe0sm89177611cf.55.2025.07.02.02.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 02:59:10 -0700 (PDT)
Date: Wed, 2 Jul 2025 11:58:55 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: mst@redhat.com, pabeni@redhat.com, jasowang@redhat.com, 
	xuanzhuo@linux.alibaba.com, davem@davemloft.net, netdev@vger.kernel.org, stefanha@redhat.com, 
	leonardi@redhat.com, decui@microsoft.com, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, fupan.lfp@antgroup.com, 
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: Re: [RESEND PATCH net-next v4 2/4] hv_sock: Return the readable
 bytes in hvs_stream_has_data()
Message-ID: <mofyjvpvlrh75sfu7c7pi4ea6p5nkatkqqtnwpwne7uuhhl5ms@gaqcs3m6i6kx>
References: <20250630075727.210462-1-niuxuewei.nxw@antgroup.com>
 <20250630075727.210462-3-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250630075727.210462-3-niuxuewei.nxw@antgroup.com>

On Mon, Jun 30, 2025 at 03:57:25PM +0800, Xuewei Niu wrote:

IMO here you should not reset the author to you, but you should keep
Dexuan as authour of this patch.

>When hv_sock was originally added, __vsock_stream_recvmsg() and
>vsock_stream_has_data() actually only needed to know whether there
>is any readable data or not, so hvs_stream_has_data() was written to
>return 1 or 0 for simplicity.
>
>However, now hvs_stream_has_data() should return the readable bytes
>because vsock_data_ready() -> vsock_stream_has_data() needs to know the
>actual bytes rather than a boolean value of 1 or 0.
>
>The SIOCINQ ioctl support also needs hvs_stream_has_data() to return
>the readable bytes.
>
>Let hvs_stream_has_data() return the readable bytes of the payload in
>the next host-to-guest VMBus hv_sock packet.
>
>Note: there may be multpile incoming hv_sock packets pending in the
>VMBus channel's ringbuffer, but so far there is not a VMBus API that
>allows us to know all the readable bytes in total without reading and
>caching the payload of the multiple packets, so let's just return the
>readable bytes of the next single packet. In the future, we'll either
>add a VMBus API that allows us to know the total readable bytes without
>touching the data in the ringbuffer, or the hv_sock driver needs to
>understand the VMBus packet format and parse the packets directly.
>
>Signed-off-by: Dexuan Cui <decui@microsoft.com>
>Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
>---
> net/vmw_vsock/hyperv_transport.c | 16 +++++++++++++---
> 1 file changed, 13 insertions(+), 3 deletions(-)
>
>diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
>index 31342ab502b4..64f1290a9ae7 100644
>--- a/net/vmw_vsock/hyperv_transport.c
>+++ b/net/vmw_vsock/hyperv_transport.c
>@@ -694,15 +694,25 @@ static ssize_t hvs_stream_enqueue(struct vsock_sock *vsk, struct msghdr *msg,
> static s64 hvs_stream_has_data(struct vsock_sock *vsk)
> {
> 	struct hvsock *hvs = vsk->trans;
>+	bool need_refill = !hvs->recv_desc;

For v5 remember to fix this as Paolo suggested. Dexuan proposed a fix on 
his thread.

Stefano

> 	s64 ret;
>
> 	if (hvs->recv_data_len > 0)
>-		return 1;
>+		return hvs->recv_data_len;
>
> 	switch (hvs_channel_readable_payload(hvs->chan)) {
> 	case 1:
>-		ret = 1;
>-		break;
>+		if (!need_refill)
>+			return -EIO;
>+
>+		hvs->recv_desc = hv_pkt_iter_first(hvs->chan);
>+		if (!hvs->recv_desc)
>+			return -ENOBUFS;
>+
>+		ret = hvs_update_recv_data(hvs);
>+		if (ret)
>+			return ret;
>+		return hvs->recv_data_len;
> 	case 0:
> 		vsk->peer_shutdown |= SEND_SHUTDOWN;
> 		ret = 0;
>-- 
>2.34.1
>


