Return-Path: <kvm+bounces-50259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 90421AE3042
	for <lists+kvm@lfdr.de>; Sun, 22 Jun 2025 15:59:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 061D4188F742
	for <lists+kvm@lfdr.de>; Sun, 22 Jun 2025 13:59:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 107021E7C18;
	Sun, 22 Jun 2025 13:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mG26n6uD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04B81DE2BC;
	Sun, 22 Jun 2025 13:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750600766; cv=none; b=DssIO4111wjY18gMm1tTC+bnXb188hbDgqsm4Cj4ZKw9RV2YfiuCHH+ZDfEC7bKUiFqRuJlfov9vUBnHB160HwQ1oR1H/htHlt3me8ok3ItowIKj5ckcIah+k7kgRuBpBsrpWTjAl61Ky0f7aCDNrQyiiWIm6EcUYxrp2nRMyZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750600766; c=relaxed/simple;
	bh=UxKMEiEskUPW9t0F65Rgb1ZCmJRY9zGpr+eirXMl1cs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GHznBIa02laRc0fsgcpRLH+QGt2z99XQxkBU8UwfLRjP9vU0YzEX8Kl9MqYmsqBxs0SmZlJN8jFszKvP/JXsHe6GqE5AvsaWJ+Upu8VLexgaOa3d2aauQe4aoW+R8lMr1geAWylV3y29g0BfJDkhEfedjlhb0rWrpgSIkXtrDO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mG26n6uD; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-748e378ba4fso4175278b3a.1;
        Sun, 22 Jun 2025 06:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750600763; x=1751205563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9CctixpwR27qpFLNeLtbKOjrAbCl9MvTJF19ZD0qLuo=;
        b=mG26n6uDIefgFhQCzqHwSJIPHG03MFnHtZO+RBXvxzeBC/TO6SPt5fbvk+dbHScFcA
         +LNyK9eQDd+ukqnbDQxh/Pb/kTSg353ZhIi51kMmxpOMiuKjgepppOmpR6sllU8mcN04
         wG6/ceJa6FPtTKpodcLRiQ7vGJDiS1OAzgSbufrgJOCg4k37I98yf8PJFUxDf2xLVGFr
         hecgFVfmj68tQttkGMQ6AvSsAEYe4ngg2+P6sfgjaG0rkcwutBVDfgNI4gujP5+az0gT
         VZYFtwIbhlBxrnYH/qEFxmWFGWHppD0wtc/0wAawxgKhd3VBQJOKSvV75p2Y3u3Tf6x1
         E+8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750600763; x=1751205563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9CctixpwR27qpFLNeLtbKOjrAbCl9MvTJF19ZD0qLuo=;
        b=wUq3LEBBNFDjzU+UbWWyl+YjbQm6O7qrLMjYH0SlBWY8humalGCiyS6x6IwFoH9T+4
         fix1b6VtqQnEidcnGroRVfSiAfsF7rr19oyv0tYhbmbIcm2Cnvcxt2EPbs5OKq7fa3/Q
         xLtLEMlHnpISC7OwtYjanQ/ERaGTCVcAf4huxAI8E7s/u5ILzyOf0+W5xdC7TRjB3XIV
         0jh5ZyIUujCv1rxrvKIAwfQ8UQo7IA/EC4y4ELcmrPo2SKWHDTP416GH1biw3RC8q2sx
         LjSCgDmKglcb7g5xkdhvGLyiNSfP1VXl24+Ebfq/zHfbmo5rQr6T3qD/7RPzTJpSlvga
         9r8w==
X-Forwarded-Encrypted: i=1; AJvYcCUXr1IsVonBto5mvpifAA3l/vmNJfEd4qZV1awkpGSN0KXoQb57bQSglPI13nGRow63Bvc=@vger.kernel.org, AJvYcCUqEcLCf2Pnvz+XHz6X79JLbATnuICDbLf2/EukmMEDPyC8dZRKyGPOslX1pDm0a3FeKoDSVzXFOxmji1Fv@vger.kernel.org, AJvYcCV8jmILucFSJwfChJsFs12vqK9BG0mV16Skd3g4f9QbeQcRU6SfUXPJJOUy66Ttg5Rbt8aWrdrQE5dm83kn@vger.kernel.org, AJvYcCX+7aSFhA9IfqHp6PCLqayjsdtpHvnLzMQOr5nrVuiSDaVUs31c91gUqabadzLndQwISbVXvL23@vger.kernel.org
X-Gm-Message-State: AOJu0Yy73Tqz8VG8W8vQG1LW+pt3glE2n86eG4wZBIC8aRo41nIoyYeZ
	iP+va2WUWuSJneagi7dHpF5/VGE+iotWufO3flpesU1CJ1R0GykUE9NP
X-Gm-Gg: ASbGncs4tyH6G08+hxOCShtBpV4aklg5jUYi0TNXlFqIoBH2VEW8iXE/P6HAcDqZnct
	fYneWeSunWF9avYVvafNqwMubJJNSi7mNfBfULkOgAkWTdcaIxO3UbBCmesGrAm6C6IvxSnTW6w
	rK5JKbC5NLgj3uFRUp3hvI3ACDoLT6/ChZWms9NP4x9i/z2PM689YAL1uf2SUnwTeTjoAqaXh3r
	JCXw6i1rX+P1WmTs4AGTTUOrUa4jQkbfU6FQopZo4XBVjMtSMmim8DBJemiFrUrgizuvzsV9euR
	axmk7y4CAsZ114Naf/XH74ocBqWYhLHfICEauaBqfVX5dcwsxGrmRWB8Rdfv/HpRHnRcPIUij16
	vAFWSLEVM
X-Google-Smtp-Source: AGHT+IGGPVZOhGf33+4x/8I48rOosb9DE+Jlj5P0FJFQOP/wdva4gvlvzXjTkAkxs7+rDh5CXvmoLQ==
X-Received: by 2002:a05:6a20:9187:b0:21f:5598:4c2c with SMTP id adf61e73a8af0-22026d8d928mr13077235637.13.1750600762962;
        Sun, 22 Jun 2025 06:59:22 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7490a46b497sm6004931b3a.6.2025.06.22.06.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jun 2025 06:59:22 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com
Cc: davem@davemloft.net,
	decui@microsoft.com,
	fupan.lfp@antgroup.com,
	haiyangz@microsoft.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	kys@microsoft.com,
	leonardi@redhat.com,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	netdev@vger.kernel.org,
	niuxuewei.nxw@antgroup.com,
	niuxuewei97@gmail.com,
	pabeni@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev,
	wei.liu@kernel.org,
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net-next v3 1/3] vsock: Add support for SIOCINQ ioctl
Date: Sun, 22 Jun 2025 21:59:10 +0800
Message-Id: <20250622135910.1555285-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <y465uw5phymt3gbgdxsxlopeyhcbbherjri6b6etl64qhsc4ud@vc2c45mo5zxw>
References: <y465uw5phymt3gbgdxsxlopeyhcbbherjri6b6etl64qhsc4ud@vc2c45mo5zxw>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> ACCin hyper-v maintainers and list since I have a question about hyperv 
> transport.
> 
> On Tue, Jun 17, 2025 at 12:53:44PM +0800, Xuewei Niu wrote:
> >Add support for SIOCINQ ioctl, indicating the length of bytes unread in the
> >socket. The value is obtained from `vsock_stream_has_data()`.
> >
> >Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
> >---
> > net/vmw_vsock/af_vsock.c | 22 ++++++++++++++++++++++
> > 1 file changed, 22 insertions(+)
> >
> >diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> >index 2e7a3034e965..bae6b89bb5fb 100644
> >--- a/net/vmw_vsock/af_vsock.c
> >+++ b/net/vmw_vsock/af_vsock.c
> >@@ -1389,6 +1389,28 @@ static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
> > 	vsk = vsock_sk(sk);
> >
> > 	switch (cmd) {
> >+	case SIOCINQ: {
> >+		ssize_t n_bytes;
> >+
> >+		if (!vsk->transport) {
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
> >+		n_bytes = vsock_stream_has_data(vsk);
> 
> Now looks better to me, I just checked transports: vmci and virtio/vhost 
> returns what we want, but for hyperv we have:
> 
> 	static s64 hvs_stream_has_data(struct vsock_sock *vsk)
> 	{
> 		struct hvsock *hvs = vsk->trans;
> 		s64 ret;
> 
> 		if (hvs->recv_data_len > 0)
> 			return 1;
> 
> @Hyper-v maintainers: do you know why we don't return `recv_data_len`?
> Do you think we can do that to support this new feature?

Hi Hyper-v maintainers, could you please take a look at this?

Hi Stefano, if no response, can I fix this issue in the next version?

Thanks,
Xuewei
 
> Thanks,
> Stefano
> 
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

