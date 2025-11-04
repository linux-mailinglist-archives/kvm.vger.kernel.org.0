Return-Path: <kvm+bounces-61987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6771FC321D0
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 17:43:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F1C204ECCD4
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 16:42:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D75D335556;
	Tue,  4 Nov 2025 16:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z+nVKkoC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="e4qbjBXr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343A0334C25
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 16:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762274535; cv=none; b=tsVn06a0AXd+Dvm1wDCzZERh+m8Y1nE4TlGOMh0UJfFMmCKZ5lyhQ8LhvbTG3sZqHStWbJFo3sVtm7Vwe9cgMFrrq5ayawHmbSpCyMGTJSKzZ9LZeMqQdqnxQbw60shERjoqxNsJUX6nTndWs7ObgAcpiebKRnUi2S+8WR9blAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762274535; c=relaxed/simple;
	bh=mo1b9l4bY6uG/Bg+NP+YlpbJo8eMD96kvJ+XbXF6mCA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lSzru4N2HsLAtRX7MLF84XOvxIxrANfPNwMRof90vXOPVZ2ZF9AIjbLtOiKMrShiXIIrtonQgyDWmumQiFmoiQChW5UJTc+0FC3vhXFUvjkxVbqWu07vPcFYZ0d/8etTwMiBod6A+KmNfzBx3kB0LZiST9pCv2JaRVedIp+Kv0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z+nVKkoC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=e4qbjBXr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762274531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iz6G9rKDATEjuxgyrnRx8l5fumymzofPum53hGum0Bw=;
	b=Z+nVKkoCkY+4jOaluQ/1odZs1Vje0nDJ9BlC+I6PG1+MEeyD9dphJJLFoFCRUJgISVZ7PN
	nVxOd6VdCaRftc5u7cO8xg5tYcEkQjDcPUyuoB86Rr1Iya4sHJON21z1f6vu+Xo3StHYk4
	Ua4ds8nvVRqafSlX481b1InTW3vWgHQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-9iWHfPLRPRm50GkvfCD_Uw-1; Tue, 04 Nov 2025 11:42:10 -0500
X-MC-Unique: 9iWHfPLRPRm50GkvfCD_Uw-1
X-Mimecast-MFC-AGG-ID: 9iWHfPLRPRm50GkvfCD_Uw_1762274529
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b7178ad1a7dso191036566b.1
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 08:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762274529; x=1762879329; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iz6G9rKDATEjuxgyrnRx8l5fumymzofPum53hGum0Bw=;
        b=e4qbjBXrjQRgtqNOkrSgFw0ZndzW2yJJRuAgt53155FRniNDdjdmmPRDYfAvWI/ZXc
         5aQuz6ytZKqdP3/4nVv98+h0Odmpv3p8zB/x8Mm8ytaVnLhjgmAZ9mO4aPruPtgWvMqP
         AsV11cJekVzdsJwx1tkpvtJGhH9kurP3qrjtd80xgY7RmyK0imEAxy3Mkdqihsn931li
         esc7iFglqZo6LhmGtGs23seAm3vbt6kIN52Z3atR/REir+1Ge7o6VbNT/UQ+NnoGFROV
         6lDsoPeoJtPvCldBSo+3QaeyBmoUsJfuY2Zbq0zr/BrVBv5ibImrOSN+VJo6zKZ31MD3
         nkEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762274529; x=1762879329;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iz6G9rKDATEjuxgyrnRx8l5fumymzofPum53hGum0Bw=;
        b=HaSTzsaUBLeee9FmzB0NMVBVYaKWa4TzcChnzL09eDbHGCQxMdhQT+7g8T8KVEPM6y
         E/wvvWPcKZucqCJnsmsLPCLeD16v3WFQYDker8SBCCgx6K+Mfi3P1vwZfjnPyFd8Iac0
         STWDvgCdZ1sgslZOJxrHS5NTxYB4SufdEvPte8pUM5i1GIr9RIhDlO+uT0qFPT0mKHFQ
         9Fvz0p0zN7qHpiFRbZ6An3+mdNqtBc/CKJagy7wQvv4phSWlUqPOr4BZjBv1JigyZWTd
         2nXfR3uNvnmXo3Yy7+4m6xQPC0D38bo6O4YJRWYb30DP8LdUOxa6WndeaCG0j0ttqDrC
         mRBw==
X-Forwarded-Encrypted: i=1; AJvYcCUF9e6p345YbRL5RUldyvRdwq/nb53FAcRr1ZNcNofRhKqN+cnZqu2pTblO4oEsbrDbKxA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyrg35gD8rBu4eXynx+pQ9s7ZNAHcx0N/39g8lJB19Ptk5DFE0i
	kRST72bw9sam5JoUpQiV3g+U/F5Rg9CSpLmpVx6xg8iDOoLcL0Cyrwhz0FyEfRpcQAYwARns7VB
	1iuKCXe1EsZxSk2/aCtCRoVxLJjIta3X1aKCljonxvgy+Xdb7v4ulJcxL7iEgrktoEVbgmFEJYK
	Zi36VBnRv+nE2f+w/YtW7xWsVLWfN0
X-Gm-Gg: ASbGncuZvWxHcymR2D0rrPylnzVQovUy9YPHX7X3uNIJ+vfvsrU2/yQtNtNhHCnKl/0
	FKe/nkfoH4rbobX1Xl4kCzL1120CeI8ZHt32NbwPQQKEAlg7c5cr3KJ9LRGSubxI7vr6ViEQtuo
	IjYECTQ+z1TRp0lM9q+TN53h58jfdpbPyg4Z+Mxpb5SbvigXJk0axd8ZRH
X-Received: by 2002:a17:907:a45:b0:b6d:6026:58da with SMTP id a640c23a62f3a-b70704c3da9mr1767561466b.34.1762274529057;
        Tue, 04 Nov 2025 08:42:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF0vPTxs1SeWugV7im7EcI5VaBj9++S0r/jr40HykURiiY/bmOyrm8AGx0cUEymhUuvAEaV34kFForbL9L24ac=
X-Received: by 2002:a17:907:a45:b0:b6d:6026:58da with SMTP id
 a640c23a62f3a-b70704c3da9mr1767558866b.34.1762274528715; Tue, 04 Nov 2025
 08:42:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251028152856.1554948-1-nhudson@akamai.com> <881d2462-895c-4ee6-a530-957a8dbac072@lunn.ch>
In-Reply-To: <881d2462-895c-4ee6-a530-957a8dbac072@lunn.ch>
From: Lei Yang <leiyang@redhat.com>
Date: Wed, 5 Nov 2025 00:41:31 +0800
X-Gm-Features: AWmQ_bnmCkT7IJlhGjvwSkQoWY9AS8Yu1GUbwnZJ0xPFuRrPC-rjjG0NUx8Xc98
Message-ID: <CAPpAL=yN9QLc2svWrtWutvjzXOCgKWLc9smh9RNPS1=hK_Ug8Q@mail.gmail.com>
Subject: Re: [PATCH v2] vhost: add a new ioctl VHOST_GET_VRING_WORKER_INFO and
 use in net.c
To: Nick Hudson <nhudson@akamai.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Max Tottenham <mtottenh@akamai.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested this patch with virtio-net regression tests, everything works fine.

Tested-by: Lei Yang <leiyang@redhat.com>

On Wed, Oct 29, 2025 at 5:14=E2=80=AFAM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Oct 28, 2025 at 03:28:54PM +0000, Nick Hudson wrote:
> > The vhost_net (and vhost_sock) drivers create worker tasks to handle
> > the virtual queues. Provide a new ioctl VHOST_GET_VRING_WORKER_INFO tha=
t
> > can be used to determine the PID of these tasks so that, for example,
> > they can be pinned to specific CPU(s).
>
> Could you add something about the lifetime of the PID. How do you know
> the PID still belongs to the worker by the time you come to use it?
>
>         Andrew
>


