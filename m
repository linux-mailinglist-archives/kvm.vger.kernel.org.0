Return-Path: <kvm+bounces-41331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 22958A66416
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 01:48:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CBC618965DA
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 00:48:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AA8313D891;
	Tue, 18 Mar 2025 00:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PGnk8Ifp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F00E9460
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 00:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742258879; cv=none; b=Cf5J4NpcXqmsxOG1lQcQoAreburxzYJSuFPKyXUgi24nQw/2y1tQZhYIsNvJN0qZKzNKYgMkOXmup8JFRQbNABbP7+5Y4pDZzf4rQTwbHtUAeYVZuR4TLlYSahoiny6Sx8pfg/EF8fBxPT28h7aMVlzoRdj7B4zhTdGPj3IkJjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742258879; c=relaxed/simple;
	bh=q9cORwpFr2i7u4nU59k5OUVSEIAbi61v48KFlNjBrec=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YW/LB01IecL4Eu9KBzOFO6SlaDhb6QM5XT5E2W4n5fN6CdsHrn1v6wCxRZ63S/85aaOPL2/MC+05zUF9F+VeakGBcjNudkVQ6cvHC6DcgY8q1RYCtdSnJo5RscJPPPVL/xJS2X56zrhibJW/682wJFCWAAFlm+GqlL9FTjmVTe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PGnk8Ifp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742258876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jZfDnbuROQarLxKZz2VKb8iNL/v4tVesJARFvFI6DSM=;
	b=PGnk8IfppLLRxrnQps0ZpncuuIc6iOI9jy0FhuBSlX2jZgeIv7+SeRGYLe2rnQuNVzR3OB
	1YI/UD1Tu1saIb1mIzVWOa48nWn0Iynv/x2SdZ7eUyp2VgiacEvkcKEtuDg0T+Ffgtyfp8
	Bdf8yAJkToVxUmJHUNnySAduDBHVB0A=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-adahx7dZONaHPAbkxpfOAg-1; Mon, 17 Mar 2025 20:47:54 -0400
X-MC-Unique: adahx7dZONaHPAbkxpfOAg-1
X-Mimecast-MFC-AGG-ID: adahx7dZONaHPAbkxpfOAg_1742258873
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2ff7aecba07so4023570a91.2
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 17:47:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742258873; x=1742863673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jZfDnbuROQarLxKZz2VKb8iNL/v4tVesJARFvFI6DSM=;
        b=u1NWn1gjUESqJi/MZ0EQyv0OZ9vqxKP9BlUPUcv7EYY8N3Fm7HPCeXZYv1Zd7RBrvr
         +v7sB95iP7tJ+H5PJH3OpDgZNJ9RXNk5/5yZ+cVBfXxNW2m+cNGGiJ06N5EihuLl/VGM
         SpjmVdx+qmSQOJ01FRYf885xY10Fogjv7x0vJgA71guPGrRkhbzZ3CNxRma3Cg8fyZsP
         c+TwLDx6WY4YX8G/4zkiZ73T3AesqnwLtB3ohZ3o93Pp2uiB0kvr7KaTpBDmAgnc9dh7
         7cDPYWyWamMDUKMueMgC9TXmykrNp0brO9rGLT1fliXhFPt2ropLaFOOL2xh/LZ+Paj5
         Jmkw==
X-Forwarded-Encrypted: i=1; AJvYcCWtb5vhUhnGyZvT012nIz0GqjUuMnPcqII0M2Jz6F7vEgZxTKycy4aPNGbmfH06E2CSVK4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxPQJ2X4kqElaScdk+VZJmIu9X5KCvNtXLAROURa4TTpC8ffUc
	QzQVnq7QMc4z03KBzho7mHWNziLr2jVNF6oX3P2dQu+PCFUAOESmOgp9zi+6kTKaJLznGV90R61
	X07WSJuN6a/nL2GGLQx5TxPaZ4L1D8urbPFVqKnKL0gEPR9qJYgH9sjTK2t9jAlTDdaelR8Cow6
	3sxCYJdtEeopTrZbR+x2MNevvR
X-Gm-Gg: ASbGncvxCUE7vaXs9LpSq6nkNXmviJgA37Ke7kigp9SpYw58fumDX3+2wJq93g2+wf9
	uKip/V1MJP9hMXZz1Tbk2XLuBZKegloxrO/MnR6JKxQIV6aLzmIOIFa9/cxcYiG40fNKZUw==
X-Received: by 2002:a17:90b:4c92:b0:2ff:71ad:e84e with SMTP id 98e67ed59e1d1-301a5b12f2cmr456108a91.10.1742258873519;
        Mon, 17 Mar 2025 17:47:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzHqvPHhOWayxt9nOn+uABgh4pj7w82asDqMrwDQrO6X0w+kGSrD+YsTLhPM5iW1l3zRKfAFj+h8otb7DW0Pk=
X-Received: by 2002:a17:90b:4c92:b0:2ff:71ad:e84e with SMTP id
 98e67ed59e1d1-301a5b12f2cmr456092a91.10.1742258873172; Mon, 17 Mar 2025
 17:47:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250317235546.4546-1-dongli.zhang@oracle.com> <20250317235546.4546-2-dongli.zhang@oracle.com>
In-Reply-To: <20250317235546.4546-2-dongli.zhang@oracle.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 18 Mar 2025 08:47:41 +0800
X-Gm-Features: AQ5f1Jps6JQeDE5rVwNMXQm81xnyDS129cpfEryeka1nOPKDMf2qheCIDs5KSLc
Message-ID: <CACGkMEvDk-GzpVMPJPEJLRSrJjVHFsbXsd7LB9MjNEghbUc5pw@mail.gmail.com>
Subject: Re: [PATCH v2 01/10] vhost-scsi: protect vq->log_used with vq->mutex
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	netdev@vger.kernel.org, mst@redhat.com, michael.christie@oracle.com, 
	pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com, 
	joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 18, 2025 at 7:51=E2=80=AFAM Dongli Zhang <dongli.zhang@oracle.c=
om> wrote:
>
> The vhost-scsi completion path may access vq->log_base when vq->log_used =
is
> already set to false.
>
>     vhost-thread                       QEMU-thread
>
> vhost_scsi_complete_cmd_work()
> -> vhost_add_used()
>    -> vhost_add_used_n()
>       if (unlikely(vq->log_used))
>                                       QEMU disables vq->log_used
>                                       via VHOST_SET_VRING_ADDR.
>                                       mutex_lock(&vq->mutex);
>                                       vq->log_used =3D false now!
>                                       mutex_unlock(&vq->mutex);
>
>                                       QEMU gfree(vq->log_base)
>         log_used()
>         -> log_write(vq->log_base)
>
> Assuming the VMM is QEMU. The vq->log_base is from QEMU userpace and can =
be
> reclaimed via gfree(). As a result, this causes invalid memory writes to
> QEMU userspace.
>
> The control queue path has the same issue.
>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


