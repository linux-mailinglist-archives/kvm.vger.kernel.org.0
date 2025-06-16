Return-Path: <kvm+bounces-49627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D237ADB3D8
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 16:31:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36C15167A7F
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 14:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CA3520012B;
	Mon, 16 Jun 2025 14:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wua/PTRD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80C71E833D
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 14:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750084241; cv=none; b=NEzWLsOCfQweL1rSHkpN2jbs6MfJV+X7SeNqMbw5LroGIhgH6qlMPhpf/bnZ59V7jOsXS7JLPNgaoStyoZ+5Hn8/3P98MDRwKw8LQ06Js4q8u55yPKYP17pWq0Gv6WEaew9VXJeg2TWwIiReumkgzO91zjJvUhEnZ2SX0GjW7GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750084241; c=relaxed/simple;
	bh=cBkQGq+aQh2WGhSROw87npSAa+GCGQe8VqIRgDN9+3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BhdqgK4HKz5j0txpactifOSBQ/555Rmu/WCuiCIU3fZuske/fG6cj3BcUbjIvI6slzaHTU8sfkese8jPJXYh8FEl03hdWnNG1KrXXE3RVpuDSaquLdggUuWI4V9v12CS1e4ItzxkVhKf8MLtbUpACUtUmNJ2UhJ9N2MtJQ4OrJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wua/PTRD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750084238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b122cq18cIxKAeDyocwvAGBr6eAjHnsn2f9gGHRU4ls=;
	b=Wua/PTRDjjuAOORQ40afoLUneOBVk3cIap72nEkS3tbSooRXPCHeHNZ9VR/VaCKMXWGOXv
	3hmAziYQMAOiF3UwS6rmsLlIFmP3HPCg9qhRdxLVZ5y84YwN8Fz6pgH/JSCRA++4vGuqBT
	KI1KGL2M6TB2zNOFmLjkGTrUSR4M/QA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-4Tvh_B77P7Gfzde5XVi-yg-1; Mon, 16 Jun 2025 10:30:37 -0400
X-MC-Unique: 4Tvh_B77P7Gfzde5XVi-yg-1
X-Mimecast-MFC-AGG-ID: 4Tvh_B77P7Gfzde5XVi-yg_1750084236
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4e9252ba0so2335023f8f.0
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 07:30:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750084236; x=1750689036;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b122cq18cIxKAeDyocwvAGBr6eAjHnsn2f9gGHRU4ls=;
        b=iHIKa0KrLUbk47Lcbc7VUYUZ6AtdJqNkd1aFCsi4Bn0anmPLoNz3DCPr+3sSArL23k
         57ZjhZmmickBQxlXjSKAvhPRJEx+FiYZII3m1LE5hC6RyD94u2UpeJD+25H8DBGhc2Vo
         XQQ7KHcz05B1GrbfckqtEYjDF7m7KlQ/+pgtFR4ibSlPi30j2qXGPowkUHa1qsIHhTLL
         JC6w6cez10uiI1eU+jMqh49ou6u6Feo7KRRIROp9A54611LpswwyskkAGd4x736Y0vqu
         DE9hrqqCgwIc/q7XMn0MYQWO+9UqyOEantoo3oPztf90XtSp64Wq1BfFGocRy3HWvvfl
         3xpA==
X-Forwarded-Encrypted: i=1; AJvYcCX4CHJeoJT2LSLqyN3jgbGxLxCgZk9ZkXf0879KjkUtZ7BP8RIV/h6WjVnbXPH5SkiVeww=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfbKCtjO7csdAcT8hNoPj9UO3zfBHurqppxoOlUk7wBY31muoZ
	7Cp/jJeV+uBKryhVZsfTtwscxOU5vJXrMa/yGdZnnUAwl2bDrZ1n/I+lUPCFtkX3lahFa43C2al
	t6NQ9+lj/OgRltmfJcZog9l5xiq6lHDSjqs+6uNXZpC5iR2DkVqA5Lg==
X-Gm-Gg: ASbGncuYmyEGj5Hax9+ETlMHLgJsHA3e37a5Z3oqGVRdJ8O8i+dGSivM3ofksy5wSnT
	SIE9yDot8fEIqW9TAze9irbkgwuRPgeX4V3/UmD8R0pfF4B58fo5SbNTpjzzN9unDnwe73e/3X0
	9FyEsq5vepdYck8euvWZb43EaD6VZ8rpKSt+UDJIc5uuM9kfdV4frI8C/8OFfsd+b0Z0gXHxF1/
	zP+ZLwERcNTBv4HoCDFy/xOfp2C69I5a4XmxGE8CpQimfSDvMEJtUuykpq1OtgfXmvl4Jm2cUtZ
	1UeUXwNVK/IoZfpLn6ZvL1kJIbg=
X-Received: by 2002:a05:6000:4211:b0:3a4:dc42:a0ac with SMTP id ffacd0b85a97d-3a572e4b6eemr8077946f8f.49.1750084235920;
        Mon, 16 Jun 2025 07:30:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGsnkYIGAr+qs47yOUuIjHINelBcn/kxEeTN9OXZQ0z3+Yj1yvrInii/mr9eol6osEokceKog==
X-Received: by 2002:a05:6000:4211:b0:3a4:dc42:a0ac with SMTP id ffacd0b85a97d-3a572e4b6eemr8077892f8f.49.1750084235405;
        Mon, 16 Jun 2025 07:30:35 -0700 (PDT)
Received: from leonardi-redhat ([176.206.17.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b2371bsm11346666f8f.70.2025.06.16.07.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 07:30:35 -0700 (PDT)
Date: Mon, 16 Jun 2025 16:30:32 +0200
From: Luigi Leonardi <leonardi@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: sgarzare@redhat.com, mst@redhat.com, pabeni@redhat.com, 
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com, davem@davemloft.net, 
	netdev@vger.kernel.org, stefanha@redhat.com, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, fupan.lfp@antgroup.com, 
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: Re: [PATCH net-next v2 1/3] vsock: Add support for SIOCINQ ioctl
Message-ID: <mrib74zhrw47v4juifp67phnm6tffb7qgfm3xmtcuw5maminlv@4i7z36hg3554>
References: <20250613031152.1076725-1-niuxuewei.nxw@antgroup.com>
 <20250613031152.1076725-2-niuxuewei.nxw@antgroup.com>
 <2bsvomi4vmkfn3w6ej4x3lafueergftigs32gdn7letgroffsf@huncf2veibjy>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2bsvomi4vmkfn3w6ej4x3lafueergftigs32gdn7letgroffsf@huncf2veibjy>

On Mon, Jun 16, 2025 at 03:42:53PM +0200, Luigi Leonardi wrote:
>On Fri, Jun 13, 2025 at 11:11:50AM +0800, Xuewei Niu wrote:
>>This patch adds support for SIOCINQ ioctl, which returns the number of
>>bytes unread in the socket.
>>
>>Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
>>---
>>include/net/af_vsock.h   |  2 ++
>>net/vmw_vsock/af_vsock.c | 22 ++++++++++++++++++++++
>>2 files changed, 24 insertions(+)
>>
>>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>>index d56e6e135158..723a886253ba 100644
>>--- a/include/net/af_vsock.h
>>+++ b/include/net/af_vsock.h
>>@@ -171,6 +171,8 @@ struct vsock_transport {
>>
>>	/* SIOCOUTQ ioctl */
>>	ssize_t (*unsent_bytes)(struct vsock_sock *vsk);
>>+	/* SIOCINQ ioctl */
>>+	ssize_t (*unread_bytes)(struct vsock_sock *vsk);
>>
>>	/* Shutdown. */
>>	int (*shutdown)(struct vsock_sock *, int);
>>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>index 2e7a3034e965..466b1ebadbbc 100644
>>--- a/net/vmw_vsock/af_vsock.c
>>+++ b/net/vmw_vsock/af_vsock.c
>>@@ -1389,6 +1389,28 @@ static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
>>	vsk = vsock_sk(sk);
>>
>>	switch (cmd) {
>>+	case SIOCINQ: {
>>+		ssize_t n_bytes;
>>+
>>+		if (!vsk->transport || !vsk->transport->unread_bytes) {
>>+			ret = -EOPNOTSUPP;
>>+			break;
>>+		}
>>+
>>+		if (sock_type_connectible(sk->sk_type) &&
>>+		    sk->sk_state == TCP_LISTEN) {
>>+			ret = -EINVAL;
>>+			break;
>>+		}
>>+
>>+		n_bytes = vsk->transport->unread_bytes(vsk);
>>+		if (n_bytes < 0) {
>>+			ret = n_bytes;
>>+			break;
>>+		}
>>+		ret = put_user(n_bytes, arg);
>>+		break;
>>+	}
>>	case SIOCOUTQ: {
>>		ssize_t n_bytes;
>>
>>-- 
>>2.34.1
>>
>
>Reviewed-by: Luigi Leonardi <leonardi@redhat.com>

Stefano is totally right, reusing `virtio_transport_unread_bytes` is a 
good idea.

nit: commit message should use 'imperative' language [1]. "This patch 
adds" should be avoided.

Sorry for the confusion.

Thanks,
Luigi

[1]https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes


