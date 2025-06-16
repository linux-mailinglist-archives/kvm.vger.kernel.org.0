Return-Path: <kvm+bounces-49630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5011FADB43F
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 16:45:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0AAF3B55EF
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 14:42:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB2B820D4E7;
	Mon, 16 Jun 2025 14:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AgbiiSAX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A26917A2F7;
	Mon, 16 Jun 2025 14:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750084933; cv=none; b=OHaTOpH9lqQam2u3h2qdTfLdCsZofGDv+gxZFmNIl3KrnilkJeLPVvp7KCRHimBGPKPVLIrKjLqiZAKMmIEYiWecZ6x8UYcla3T1K95tX5x8A5WOQ+GvG1Ojx+Ub0hMmMQENer+RbkieZstXr8iWszwlqAp5bN2UsX9LoBEj63E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750084933; c=relaxed/simple;
	bh=pK0+u7cNcOH3UoJCPFzMHWZ+PCQvSBPMj8pEU5KTMIU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bIdd4CkTaNz3zdt/Xya3T1cM6NWhHEWHyUZpBR/avM8/dsUPZX8vobeLGKeGtNsv5Zfg5+9E8arUU1W+28SMAmlIh+X+JCi7w5qag8zOSJset5ZJwb/V8OyaOcaIiaL7OfyLx4IPkVhMxXVud+Aw8BxEmyZYjMfdOMcp5/7Oxy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AgbiiSAX; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-748582445cfso2866189b3a.2;
        Mon, 16 Jun 2025 07:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750084932; x=1750689732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tv34W5VjxfJqW+QLhtik14kbds+hW6UbOSuF3KILzuY=;
        b=AgbiiSAXN4kZhR1QGNpS0iZ5fu86dRG+2Vg/rwqJro+qwZFTY1bmDftGFV5qz3vrYP
         A5bJyl0g/JYYLvA5y4FmusDcj21mjy9QX8VJYJYshuqqOvpJpZa/xWie0VVLMHv6J6iu
         YmPxnZUf9Sr61PRy74jlywgrA1TQyIaqIdVGZtYe+ygj2EfMvTDfi02sR1S9jGIJzNeA
         8Fj06X7Z7oPeLmeKJqFf0s9xVHhgdBm7AG407t1pNFGhrjW/Luqsc1TlJBIubJs3syDj
         BktjXzj/jAjspFwEchdi83UIOdbeDBulySIb5UMu42Js34LsqabFs66DUcAl1AcZ8dEQ
         p7Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750084932; x=1750689732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tv34W5VjxfJqW+QLhtik14kbds+hW6UbOSuF3KILzuY=;
        b=in37esPakPjuSgUs6W+qQejQmjRjVd577AY9mGZzVp1KtrYJjcIh8bhs0siwruYkqb
         Uf+/RbCzE130QqfcH00dMC2Ie6xSZl1le5nwBBkMqWJpFVYKrkWWT4HN5Duv+c6/qC0a
         DaxJ7MG/oda6tjpfkU/zf9HkhNAHNBEyKUXDxou1x2ferSs/9J2Um3mYFgJBccevG89O
         IMUp/btsl9nT4RL2MHRLiN9abbXe/smlM7hWwfD/CeziSHMB0y84wcx2N1/qe7zTVwQA
         ibi4OcK4UHvFLjeyLBWFrogdWcibDgfeIkFE7xzvh6DogBp4C1WyapnoVAeVU+Uqv68L
         WfFw==
X-Forwarded-Encrypted: i=1; AJvYcCVOKkxjXvgoup1LAfbx/oDN82D72ulXmMiht7QQXrb/lqSFadFFh5YWutikB8ZrBpgm0pQ=@vger.kernel.org, AJvYcCWXkMwWQvoELCuArbPV69ak2WWhKj4poLPs189vHokOL7rA89YR5dg74uRJMC+sjAwU0+IiSKGS@vger.kernel.org, AJvYcCXmiQyo4CNPP/X5imxycCwzNnp20GobKr2cgwtCur0d2Os6WQ4zX6/9ZBA3cuqHe060QoCK6tV3A+GmquMX@vger.kernel.org
X-Gm-Message-State: AOJu0YzVrUSRHEYkS7utF22Vc9XrZfXDNtADL43dPWHh+NTL1h/XPMhS
	0XYURVqN4KN+ACmcPbhVni/UYyVSfbUwvL3YwwzWoF1qtT9SQWyHVFA2
X-Gm-Gg: ASbGncvZyutJzBgEjykWaItoGhCB0F8177QY6o44KU5Ol9an55unA1cc0NAoIDsfmyA
	XUsqM63DmNKSYgfkCh+MSKgdQ4H5QIBjYbqbOTfUHcv9VjfDVRbpPXw/uSQrcM9JOvsKVR4V0Ij
	xFYBs9sAq534o5szz5s2NrJPgpFDCYbqWfYZWUjdO0WnikflwmddCmnlg3lUQmah0LEPaRVuJEK
	C/tI4z6bk6up7ZfVXUYB30d6iBuXa12ZeEygsh0ANSdjYR/aSig39mMapdfFb1D9wZ2+5/w1ig3
	CyKsOZLQF0+nXo/l6AWTyelRnPEtQbLWb036Is7bUJtzTPSl7HhSz4Toy3lPhhn/05dKJPJc8YW
	d29rqMjP3
X-Google-Smtp-Source: AGHT+IHEPg4+O4ApNZgch6q2sKZcGIKUpH2RyzdU/+t4+DW38f/ZmE8sPSN34Sk/ocqhx4evU3kalg==
X-Received: by 2002:a05:6a00:398b:b0:730:9946:5973 with SMTP id d2e1a72fcca58-7489ce012bdmr12266799b3a.5.1750084931399;
        Mon, 16 Jun 2025 07:42:11 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900b374csm7104331b3a.137.2025.06.16.07.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 07:42:11 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: leonardi@redhat.com
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
	sgarzare@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net-next v2 1/3] vsock: Add support for SIOCINQ ioctl
Date: Mon, 16 Jun 2025 22:42:00 +0800
Message-Id: <20250616144200.1187793-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <mrib74zhrw47v4juifp67phnm6tffb7qgfm3xmtcuw5maminlv@4i7z36hg3554>
References: <mrib74zhrw47v4juifp67phnm6tffb7qgfm3xmtcuw5maminlv@4i7z36hg3554>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> On Mon, Jun 16, 2025 at 03:42:53PM +0200, Luigi Leonardi wrote:
> >On Fri, Jun 13, 2025 at 11:11:50AM +0800, Xuewei Niu wrote:
> >>This patch adds support for SIOCINQ ioctl, which returns the number of
> >>bytes unread in the socket.
> >>
> >>Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
> >>---
> >>include/net/af_vsock.h   |  2 ++
> >>net/vmw_vsock/af_vsock.c | 22 ++++++++++++++++++++++
> >>2 files changed, 24 insertions(+)
> >>
> >>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> >>index d56e6e135158..723a886253ba 100644
> >>--- a/include/net/af_vsock.h
> >>+++ b/include/net/af_vsock.h
> >>@@ -171,6 +171,8 @@ struct vsock_transport {
> >>
> >>	/* SIOCOUTQ ioctl */
> >>	ssize_t (*unsent_bytes)(struct vsock_sock *vsk);
> >>+	/* SIOCINQ ioctl */
> >>+	ssize_t (*unread_bytes)(struct vsock_sock *vsk);
> >>
> >>	/* Shutdown. */
> >>	int (*shutdown)(struct vsock_sock *, int);
> >>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> >>index 2e7a3034e965..466b1ebadbbc 100644
> >>--- a/net/vmw_vsock/af_vsock.c
> >>+++ b/net/vmw_vsock/af_vsock.c
> >>@@ -1389,6 +1389,28 @@ static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
> >>	vsk = vsock_sk(sk);
> >>
> >>	switch (cmd) {
> >>+	case SIOCINQ: {
> >>+		ssize_t n_bytes;
> >>+
> >>+		if (!vsk->transport || !vsk->transport->unread_bytes) {
> >>+			ret = -EOPNOTSUPP;
> >>+			break;
> >>+		}
> >>+
> >>+		if (sock_type_connectible(sk->sk_type) &&
> >>+		    sk->sk_state == TCP_LISTEN) {
> >>+			ret = -EINVAL;
> >>+			break;
> >>+		}
> >>+
> >>+		n_bytes = vsk->transport->unread_bytes(vsk);
> >>+		if (n_bytes < 0) {
> >>+			ret = n_bytes;
> >>+			break;
> >>+		}
> >>+		ret = put_user(n_bytes, arg);
> >>+		break;
> >>+	}
> >>	case SIOCOUTQ: {
> >>		ssize_t n_bytes;
> >>
> >>-- 
> >>2.34.1
> >>
> >
> >Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
> 
> Stefano is totally right, reusing `virtio_transport_unread_bytes` is a 
> good idea.
> 
> nit: commit message should use 'imperative' language [1]. "This patch 
> adds" should be avoided.
> 
> Sorry for the confusion.
> 
> Thanks,
> Luigi
> 
> [1]https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes

Thanks for pointing out. I'll update the commit message following the
guidelines.

Thanks,
Xuewei

