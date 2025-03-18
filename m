Return-Path: <kvm+bounces-41332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 06498A66430
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 01:50:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85D151895DAA
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 00:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE4313D891;
	Tue, 18 Mar 2025 00:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S6GmjMOC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0814335950
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 00:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742258940; cv=none; b=c7Dde2azMECF1UhPRjw5UATzPti/Z6WR2ZnxgW4DfcCO0tZ3vk9LyUgruuKPoIpeWIYrE4AhTDQT70Eh2bZqGGZd5OpTIKu7mJptcHWFH0ENmB3rmA0BqcMCEREjyddna5XcgcrH7y7N27C/ICHxQrOS2KHjLo1Ce5WOjn5zJhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742258940; c=relaxed/simple;
	bh=747T9jLSqH8bFgDb72pde2D+kt0cpKYYu/2oRmA4qo8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c99dyLHepnzSsxui/9yQ7n/M2zJVRSC++p5zaaJaeW4hgsPQaWBaU2MUC7QCEylwBHWi6dXwFbXkC+gEOI/lOFUhHeEx9cSaPmGtpV9rejr0rD7/kwBYhXHhZ3pcBohi8+rwLG0Q/6P6uy5EugiqoTa2cvFef7tQkcyUiGW33CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S6GmjMOC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742258938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nlAq9ja2RSbJ2WExbn5JQkIBqDsE/3iSsVzG9YVP7BE=;
	b=S6GmjMOCYUXb41wbLeGx2xDR20unaiSm6PBbeYwoYWmZKGDzUa6xAIkHjGlzfD7K/vMxbo
	Fsyb7PxDbpTCVfLUPIt0uzxQXrmyBQBA1jR/8u8fBVwlHTlbD04LcIMxK39Kb/xrOh3lfa
	e9d32M/zkUOvqVhqh6KGl5Yvm8R3+RA=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-k-nbZTLKMbixjfdiTPY69g-1; Mon, 17 Mar 2025 20:48:56 -0400
X-MC-Unique: k-nbZTLKMbixjfdiTPY69g-1
X-Mimecast-MFC-AGG-ID: k-nbZTLKMbixjfdiTPY69g_1742258935
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3011cfa31f6so4147024a91.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 17:48:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742258935; x=1742863735;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nlAq9ja2RSbJ2WExbn5JQkIBqDsE/3iSsVzG9YVP7BE=;
        b=Z3ecaa5WU5b7ElmvLSI93xTUCYYshPJCWP9v7Dlrz3e4WLPFpv8Csu2cFr8cQZPdDT
         32B/ppDDdKF2Wojh5S8r28FkVyIWlcNlTDlJgUCyU4VuKaHaiYvW8m2TdGP1Lo38Jxhf
         h5AIBJAz8GF1MNKgcE7PtVQ9fglxJHFn/8mWe5LxBT95WiTOMxF1ECBQWVIQcpBWHf4s
         ytUYYgdIC035EcOxD2W58VLCIa859c+o0MgMBBC7btZKFUCoyXUm3M5V085yWP0TIaOv
         n5qY9nT0UIZh153CWel+mJ+Te+qaELUq6ccHbZYQXw84be0gfQXGxT/reL/Ypc23/cx5
         Hunw==
X-Forwarded-Encrypted: i=1; AJvYcCVWi7u8AKkmX/aNtm10x6cMACl48rLtcwOJrxdCmOP49M8mPGC2Zu1B8GjxwUfF1G+P7b8=@vger.kernel.org
X-Gm-Message-State: AOJu0YywQUKWHlbRXBWNhztJtwQf8ohtLB81D4CU+hJcVASn6bSxB8KP
	uYLm3EA+LxfqXAmCwbEfk21DlK1jbZmjMsgSf041Tq74mpdMqontBtDSzF0Pg1vpaneSoAqcKNl
	VrWn8APZ5LNPpzIZtbhMhC/SnRxri4lrsjmWR3UpNNg0VLqkEzxofMnRZLYAu/82MiLdiZ4BAG6
	W/azGl3A9MXKlE0yyLo6mRG/4b
X-Gm-Gg: ASbGncv3QdEg4vpODXgOUE0EeKZ8mDqtKOqQhhkYDiP5tEh174wk/oefMRlYVib4ran
	d4BKY1vjhl3RTLga4HnCzce/D0qwEWIYb45zwcM/IILMcgHGYVWXlS81rIdkzxi7Ho3bDHw==
X-Received: by 2002:a17:90b:4b10:b0:2ee:741c:e9f4 with SMTP id 98e67ed59e1d1-301a5b1313fmr486188a91.11.1742258935178;
        Mon, 17 Mar 2025 17:48:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjSE8bZtH24Q4k70pqmCF3Pl5ZG79aTMFklPXXWxS7VadnbTFOusaQmH8Wzxx/kb4T1iFplzJMw+APpySRBkg=
X-Received: by 2002:a17:90b:4b10:b0:2ee:741c:e9f4 with SMTP id
 98e67ed59e1d1-301a5b1313fmr486162a91.11.1742258934866; Mon, 17 Mar 2025
 17:48:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250317235546.4546-1-dongli.zhang@oracle.com> <20250317235546.4546-3-dongli.zhang@oracle.com>
In-Reply-To: <20250317235546.4546-3-dongli.zhang@oracle.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 18 Mar 2025 08:48:42 +0800
X-Gm-Features: AQ5f1JrAlxtKtwUtKRrW-cmJuRCs9VYdUge7DAbLNhWk3XLXSW2HZUWTJOSqcLg
Message-ID: <CACGkMEuhqbxr-20Jghn10fWH+pCAVih_KvWU6Mj+FXgE6TOTVA@mail.gmail.com>
Subject: Re: [PATCH v2 02/10] vhost-scsi: Fix vhost_scsi_send_bad_target()
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	netdev@vger.kernel.org, mst@redhat.com, michael.christie@oracle.com, 
	pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com, 
	joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 18, 2025 at 7:52=E2=80=AFAM Dongli Zhang <dongli.zhang@oracle.c=
om> wrote:
>
> Although the support of VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 was
> signaled by the commit 664ed90e621c ("vhost/scsi: Set
> VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits"),
> vhost_scsi_send_bad_target() still assumes the response in a single
> descriptor.
>
> In addition, although vhost_scsi_send_bad_target() is used by both I/O
> queue and control queue, the response header is always
> virtio_scsi_cmd_resp. It is required to use virtio_scsi_ctrl_tmf_resp or
> virtio_scsi_ctrl_an_resp for control queue.
>
> Fixes: 664ed90e621c ("vhost/scsi: Set VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERS=
ION_1 feature bits")
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>   - Move this bugfix patch to before dirty log tracking patches.
>
>  drivers/vhost/scsi.c | 48 ++++++++++++++++++++++++++++++++++----------
>  1 file changed, 37 insertions(+), 11 deletions(-)
>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


