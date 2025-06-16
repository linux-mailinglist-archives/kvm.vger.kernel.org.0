Return-Path: <kvm+bounces-49626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 388E1ADB3CF
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 16:30:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 160B916846F
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 14:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC0CD1F7060;
	Mon, 16 Jun 2025 14:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dAfM83/z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694F41ACEDC;
	Mon, 16 Jun 2025 14:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750084121; cv=none; b=RL2hgn6nEcXSf+uyObUtZfoOOPh8WgLXronFEkedXABXMTGxOFxpYmGQRLw9KlUZpxqlNRXGUjQNW7HeXldjZSEhbaWWrkblOAo1C8Vyv1f1vOz8rD8A7ISH3UJy2/JUFuldfPjlL8Ig43aXJVgFx6pPRcoRb/w+t5SnfPCLddM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750084121; c=relaxed/simple;
	bh=D51oDNoeO5PvOntYeAXdoXiXYLEN+Mk2DDfBb1UO+3Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uoSnDoB3g4z9VMWvTUAjfJtFQPIOY7KdU7LS4Z1a76+vWLPqFABouOqPzZJbvR1p4+qY1eV1jLNmNFvRDWD2HsTa4xu0N2hyMAbBi3Z/uVyooWjL0qTTwwN9TtjlenuXqaKV3ExsrLkALMKzJw8aMuAp0M83c90utwvn0qOV/do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dAfM83/z; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-235e1d4cba0so39640745ad.2;
        Mon, 16 Jun 2025 07:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750084119; x=1750688919; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xX+bi5Hgmn9NrTEaY/oPghRXm3i2VfhEfvJkderRFkA=;
        b=dAfM83/zxwB01boM5INbTgx9SwrFnyU9YuwV3gIJgKm6e5vvB9pmWNYH+K8NwedB3E
         MkRkJkwMpxx+EfXYFA3FT8YhFmkZDkACU5HV7UuNkFbzpQQUggR0TMaNIysKfYTkmpN7
         YQGLp0XIH9H+kWkk4T3YtOBEPGxZ1G+U5eZpML9ZCiYOonHbvrJg2L8lkLuK9Rv2R2Qd
         hyQPnePGwoJot8u6kPrhfEYrI1TFPE0M5qmaXONtAToGgsYGVBtdXmT53PZJm+kUO4x9
         WuO1aF2eXIpDQRd/CK8Lh+9J5UU0ckQTZqYzndR+g3C4MUS/Hj6dyy+74qNpZgv4RR+C
         cd/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750084119; x=1750688919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xX+bi5Hgmn9NrTEaY/oPghRXm3i2VfhEfvJkderRFkA=;
        b=EMy8EfJmQr2lv/pWnYdCBa01wh5hjxf9yGDPYjNZ0dOGMevDjjyBHtY6S8OfygcSyQ
         cQwtkPJSbzkykQQA03QSONxMkew0/y5Q+fNo/LMvZFDxd4d0zkoiWWQ6T5GXO9lcaBvk
         0Z/0elUUeSRDVdeFdqYhLDAN184gXGnD/bZK2lDpBNHW96aStLZ+1ZbfKueDUvQsNrkc
         RIQl1EuxvXlhtrMsl7cO7kPDZvIZz7r/GoufCNwTqmhwbe3ell56oKNKDFlgIFNwZ4Rc
         fgpKN9WePpfKhBdxEfgtDDNYjVJf/rw0+scZehZLkFSvtlwh1gZTWVsFY8p0eqRPeZAM
         uKow==
X-Forwarded-Encrypted: i=1; AJvYcCVMhPeW3qYHLVjWX21uQy0QtHGoWR0WNQFmGxfkp8gUaXmOKGwsNKH+cth7GFrfvMZhDawSCWFN@vger.kernel.org, AJvYcCVSlxHquQdpAXBfwRo596hXLU6ums0uyrz6g3InjxbqDFS9gBX9xKghVhMUAaDifJRTGiKvp7xVTiEMeTtM@vger.kernel.org, AJvYcCVZBQkRI5jXagC51pzwjofTqSj7+NRRQbTOc3DV/O9U7n1uJiqc7Zz+1Am/04rJIdQYva0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWhfzmLZoOSojIyHVafrAdQZ44Wk925/s70cRHmlLNDS6PU9UT
	jNDxvAELe3wKrLfVl0CtL5FXIrks762dT4rbpDizRa8SFLfILdCK/ufI
X-Gm-Gg: ASbGnctHE8eA38Q3rO+e1Vlgw3uToZ7fEUzHfsrCtHVtiGCpxvIlpjBp1/okPUSiYcp
	ENTMZoqPjAyo7iyfO35j/ayQ8p+quQ8jNYfz/2TxMj74lWflVzMY9WyTm83OwU+nKMD5bZ2Nk6T
	MAFZ6HdXXHSgpGIGtYJrV5xhw0yczTBjkGhNyNi46kQqK4OxTkIU+KJTrZO5Bg8kaUR1MRyaM+h
	Mug0Ud1uI/GBsB3NPjSDy4ZQNypPfCuYq6PYCihZVJuvpgalcYQSDrRMQoczOOVDg9bpK5d1ALs
	GX55JUgeT24t6gbQ2Hq7PrITuTjd8hmqhGLMiEYacoh1T3qO/7H9TogVSMV0IhHBXKFZ07WPkV2
	2yuDlKseo
X-Google-Smtp-Source: AGHT+IEiUlcugSM6imRNfKRXtWTfhUz3HfPDFOqCZEki+4pDVZ1e5ScBdgWJBhYp+4nuJn/5v4VLWg==
X-Received: by 2002:a17:903:32c5:b0:234:adce:3ece with SMTP id d9443c01a7336-2366afe9924mr140921925ad.11.1750084118202;
        Mon, 16 Jun 2025 07:28:38 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365deaa9f7sm61494905ad.168.2025.06.16.07.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 07:28:37 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com
Cc: davem@davemloft.net,
	fupan.lfp@antgroup.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	netdev@vger.kernel.org,
	niuxuewei.nxw@antgroup.com,
	niuxuewei97@gmail.com,
	pabeni@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net-next v2 1/3] vsock: Add support for SIOCINQ ioctl
Date: Mon, 16 Jun 2025 22:28:22 +0800
Message-Id: <20250616142822.1183736-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <xshb6hrotqilacvkemcraz3xdqcdhuxp3co6u3jz3heea3sxfi@eeys5zdpcfxb>
References: <xshb6hrotqilacvkemcraz3xdqcdhuxp3co6u3jz3heea3sxfi@eeys5zdpcfxb>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> On Fri, Jun 13, 2025 at 11:11:50AM +0800, Xuewei Niu wrote:
> >This patch adds support for SIOCINQ ioctl, which returns the number of
> >bytes unread in the socket.
> >
> >Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
> >---
> > include/net/af_vsock.h   |  2 ++
> > net/vmw_vsock/af_vsock.c | 22 ++++++++++++++++++++++
> > 2 files changed, 24 insertions(+)
> >
> >diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> >index d56e6e135158..723a886253ba 100644
> >--- a/include/net/af_vsock.h
> >+++ b/include/net/af_vsock.h
> >@@ -171,6 +171,8 @@ struct vsock_transport {
> >
> > 	/* SIOCOUTQ ioctl */
> > 	ssize_t (*unsent_bytes)(struct vsock_sock *vsk);
> >+	/* SIOCINQ ioctl */
> >+	ssize_t (*unread_bytes)(struct vsock_sock *vsk);
> 
> Instead of adding a new callback, can we just use 
> `vsock_stream_has_data()` ?
>
> Maybe adjusting it or changing something in the transports, but for 
> virtio-vsock, it seems to me it does exactly what the new 
> `virtio_transport_unread_bytes()` does, right?

Sorry, I forgot to update this.

I am curious that is there a plan to implement dgram support in
virtio-vsock? If yes, adding a new callback is the right way to go. I
deadly hope to see that feature. If no, will do in the next.

Thanks,
Xuewei

> Thanks,
> Stefano
> 
> >
> > 	/* Shutdown. */
> > 	int (*shutdown)(struct vsock_sock *, int);
> >diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> >index 2e7a3034e965..466b1ebadbbc 100644
> >--- a/net/vmw_vsock/af_vsock.c
> >+++ b/net/vmw_vsock/af_vsock.c
> >@@ -1389,6 +1389,28 @@ static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
> > 	vsk = vsock_sk(sk);
> >
> > 	switch (cmd) {
> >+	case SIOCINQ: {
> >+		ssize_t n_bytes;
> >+
> >+		if (!vsk->transport || !vsk->transport->unread_bytes) {
> >+			ret = -EOPNOTSUPP;
> >+			break;
> >+		}
> >+
> >+		if (sock_type_connectible(sk->sk_type) &&
> >+		    sk->sk_state == TCP_LISTEN) {
> >+			ret = -EINVAL;
> >+			break;
> >+		}
> >+
> >+		n_bytes = vsk->transport->unread_bytes(vsk);
> >+		if (n_bytes < 0) {
> >+			ret = n_bytes;
> >+			break;
> >+		}
> >+		ret = put_user(n_bytes, arg);
> >+		break;
> >+	}
> > 	case SIOCOUTQ: {
> > 		ssize_t n_bytes;
> >
> >-- 
> >2.34.1
> >

