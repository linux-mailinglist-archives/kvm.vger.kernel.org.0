Return-Path: <kvm+bounces-51281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAB60AF10BD
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 11:56:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A02983B3A8B
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 09:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D207924C09E;
	Wed,  2 Jul 2025 09:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GXwtQR05"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647A51DC9BB
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 09:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751450191; cv=none; b=KGyUAXk9/9FxEjsKep7OEfMAX48A5aCop3UH2zJphAox5ac/jQ4PtL6jbXeUyKeGo5oJvE5OJl50+627kweCAlbX8yQM2sexToU557KuHBifV3VHUwOjjndRxVO89sig8sfpC4+BD6qN+ITY3PoPt+A8EvqnGWKoEsdB3UPAy30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751450191; c=relaxed/simple;
	bh=R/vqF8mtqR3Q5cYK/qFuLfD77vbI1Wt5cmIml3gcsWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oflpV+y58oA9jbiTEbWaNX5WZA04As+Mea3aI2GqmsIYwRX92FVupUewsHcHkLRIc+7f9uPViyCszm6xbRt5lOTaGIn5fkH2RCNwWFlwIjbLQ6gJqVDz4A4JPq6SUSBRsyJwHDhjatUEFMS88cu2LHrCvPHGlWwDDvqi28Qe+9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GXwtQR05; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751450188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vNl7Ngt3KhiRiuYDlu3AWhmnMill6bJNFUWa6YlfZWo=;
	b=GXwtQR05pERJ4pTj5yZLrDcWZiavDIor+yGTECTxi3pCuLteBxgKk21Xhb8/peb6aVDoon
	RHZRTfGVvkCmusc6d7DtYH+mDEUIallmWbzaTU3bFREldZJuPkuhbX3ZOCcSCniFCxM9NE
	03MXgvGq/2xxpw3YVC4CnqywTsAqCPQ=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-QFVHjC9nPnGMjpT3alktyQ-1; Wed, 02 Jul 2025 05:56:27 -0400
X-MC-Unique: QFVHjC9nPnGMjpT3alktyQ-1
X-Mimecast-MFC-AGG-ID: QFVHjC9nPnGMjpT3alktyQ_1751450186
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-2f3b9f042a6so2388659fac.3
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 02:56:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751450186; x=1752054986;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vNl7Ngt3KhiRiuYDlu3AWhmnMill6bJNFUWa6YlfZWo=;
        b=ri6dx96HrfgDV9Uog9/NcDwhScZriskKbP2PyAcPXDqZ+FXZFeEf+2akXZ4aZWEN+L
         DPm4Yu8iHAgsDd2x5NwSG5ok4MMGvsRnJqES215gZLc0JUFFwh4kkpUBnR1JYamOUPKg
         qODiofxZeUNPQcrN7w/SvG5z0IouEivTCzfJ7ZmrBs4ChXItdkJa9NvDpzwBmIhDqnwF
         YxoUPKDFu4IOVSkFi5CHtOrV8lZ7ML5XDe0kWUxct1/0GDJ1jkbPHn508UnZ7naUjV2z
         b2qaECebEe1+ssgyLhIxcvshzqv6rm1e4SwJw8bnSRLLky/Ct1wXHmyXES2P8mWIq94E
         tNRg==
X-Forwarded-Encrypted: i=1; AJvYcCVgHHTO0iHWtgiYnsFw+Cb0i+6fq/oE32yfZTa/XS17JMuap9r197oaWJQFMbUKitJOsSg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTgDJOTsIFO7Idr8nJhbpSCy2XCIn+JUf+TkZ8Sf7Aw73UgA7d
	lXaz1E9+b16q2CFKNPHQRKivqPweNW3U+TvOXVdxaGuzo8gXAFaTl8cksB2VXtat8sdjLK+uWzj
	viixMEj2pbqcSncN9tBOeeDPdR6n4yNkx28jAQs/jAFnKJdcsCMc0UQ==
X-Gm-Gg: ASbGncsRbHYom+vCQCIjBZtxHaHvD4I0BK/dBAoMrmhqyk8QOHwmpG/R2rvXWHjkj1H
	4gq0wdLT6H2nPwKPNqh97/I8ApKD+li6Bgc9l8d2bbpL7rxBXhdKf3Fw0XEzB+vKC/cgF8be9gL
	PRZcEMfb1VI9v7B/xpbOM7aEj89LH64OqlcHFO5UVJsnTNt1r8PlRDHx1JYX4Nc5GK5+/viTfx/
	Fro2ZY9yEEHbRIKcGhbMWwixpM6eOzgR31CSI7rOGabPttD1MXXas9H5cy7eoWHVrSZrCrb+azN
	QmitNoI9fbHsBvTnYz8K0MMdcgo4
X-Received: by 2002:a05:6870:ac20:b0:2e9:735:91ba with SMTP id 586e51a60fabf-2f5c7c334d1mr1422470fac.25.1751450186323;
        Wed, 02 Jul 2025 02:56:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpqQrlTLKRF3KccZ2PdIYCRT6eIHGjwWaj9AB/7CS8NfzugBebe1UFmRYpDGfYy6NDhWabBg==
X-Received: by 2002:a05:6870:ac20:b0:2e9:735:91ba with SMTP id 586e51a60fabf-2f5c7c334d1mr1422456fac.25.1751450185945;
        Wed, 02 Jul 2025 02:56:25 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.164.126])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73b29fd918fsm1247562a34.36.2025.07.02.02.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 02:56:25 -0700 (PDT)
Date: Wed, 2 Jul 2025 11:56:06 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: mst@redhat.com, pabeni@redhat.com, jasowang@redhat.com, 
	xuanzhuo@linux.alibaba.com, davem@davemloft.net, netdev@vger.kernel.org, stefanha@redhat.com, 
	leonardi@redhat.com, decui@microsoft.com, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, fupan.lfp@antgroup.com, 
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: Re: [RESEND PATCH net-next v4 1/4] vsock: Add support for SIOCINQ
 ioctl
Message-ID: <gqjvhl6rftfygatheyto27kpbqsfc4hixcv7g52nle6grjkrkq@f5ey4iyu7swl>
References: <20250630075727.210462-1-niuxuewei.nxw@antgroup.com>
 <20250630075727.210462-2-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250630075727.210462-2-niuxuewei.nxw@antgroup.com>

On Mon, Jun 30, 2025 at 03:57:24PM +0800, Xuewei Niu wrote:
>Add support for SIOCINQ ioctl, indicating the length of bytes unread in the
>socket. The value is obtained from `vsock_stream_has_data()`.
>
>Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
>---
> net/vmw_vsock/af_vsock.c | 22 ++++++++++++++++++++++
> 1 file changed, 22 insertions(+)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 2e7a3034e965..bae6b89bb5fb 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1389,6 +1389,28 @@ static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
> 	vsk = vsock_sk(sk);
>
> 	switch (cmd) {
>+	case SIOCINQ: {
>+		ssize_t n_bytes;
>+
>+		if (!vsk->transport) {
>+			ret = -EOPNOTSUPP;
>+			break;
>+		}
>+
>+		if (sock_type_connectible(sk->sk_type) &&
>+		    sk->sk_state == TCP_LISTEN) {
>+			ret = -EINVAL;
>+			break;
>+		}
>+
>+		n_bytes = vsock_stream_has_data(vsk);

This patch should go after we fixed vsock_stream_has_data() for hyper-v.

The rest LGTM!

Thanks,
Stefano

>+		if (n_bytes < 0) {
>+			ret = n_bytes;
>+			break;
>+		}
>+		ret = put_user(n_bytes, arg);
>+		break;
>+	}
> 	case SIOCOUTQ: {
> 		ssize_t n_bytes;
>
>-- 
>2.34.1
>


