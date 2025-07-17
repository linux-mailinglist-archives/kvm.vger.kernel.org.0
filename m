Return-Path: <kvm+bounces-52695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 560E9B08477
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 08:01:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D0D53ACA1B
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 06:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F41F92063E7;
	Thu, 17 Jul 2025 06:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SAVl38Jp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB91328E7
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 06:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752732083; cv=none; b=bYPVi15OiEphuZbYs5k2B2TtOdWegHmz5B+jx65pxRReZNhWg0kQKeYaadMz2CCzVc/oOfikz5jiSNdkKyBNED+RJiMh3TSOj5hC4ayDeFZaHn90SR4smBiAEjvmhzppYV9bCPOox32g943IS+kfpKzL4Mi31YEGHepRARGKMCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752732083; c=relaxed/simple;
	bh=jxOpZ0mtCseo/bSPj1OyB2eE1E7Wq+zP8rpLdjVZc98=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cqxDmRMckD7Gj6R1vr9fzi7MKrtWzr5xmJaKPRUih+jW6ThGDYLlUe6MmQeJ4Sz8GvZ7hlpreMwJ2p/PJuCXQlfhcAHitMVtYmYaoCaGATBziFiG2pDCCZGTjgQ11WEKFoKhGgwUdH8SpV2y8dxd3bU1q2o+6dVrS7dF5wVXnBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SAVl38Jp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752732080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jxOpZ0mtCseo/bSPj1OyB2eE1E7Wq+zP8rpLdjVZc98=;
	b=SAVl38Jptu9v9WoMVTFte9S9k6gG6mO8OXmoNI+5HEEuoYkeVKfhmcSOM0POwIG/KiqzjO
	aaHhSMwR29ReNnUIIyCLpFniN+ET5Pq3pciog2mE00RTsZsy8mGwDO1bjPti2+Ylplz5IO
	GOLAJSxzISO2mqKtgj3THTcW4kCptY0=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-i_v8KU9jNRic5JmgvxiLbw-1; Thu, 17 Jul 2025 02:01:19 -0400
X-MC-Unique: i_v8KU9jNRic5JmgvxiLbw-1
X-Mimecast-MFC-AGG-ID: i_v8KU9jNRic5JmgvxiLbw_1752732078
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-31366819969so641171a91.0
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 23:01:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752732078; x=1753336878;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jxOpZ0mtCseo/bSPj1OyB2eE1E7Wq+zP8rpLdjVZc98=;
        b=jg+hgM+MRbqzoivxE0gAWEXRFRRfX4/tKId3rtYX082dkaKjLo5B2jMgJhLz42gBsU
         AMJeIfINzAJSilEjCnDmq+FGHe5NFnR6OQ6sHUS+3zQ9lC/TFCRp9afyUMbAWEy0x1Rf
         CNEV1Xs/v0ZG8qddk85saBwvP6yYwfGtS/ddpaAtvJYLivZXwkUWK5DIkg9AVBl+5j10
         FlM9yKNQo0DUD8cJKf6d9/Zrf/sjF317tss4gT2CPM7xjwdjswrBA81wNpKSFZznwsTR
         NU7d/LA+0mEfmonbghKiXKoMbBKIZPdDMfL9QQwzgtCfSNci5Dsgi0FfKSu6Di3UuE+4
         L3Uw==
X-Forwarded-Encrypted: i=1; AJvYcCUfQ3+E6w7Zud6TQqY5UjOwPl6lI6ziEntVqw0qZfnES4917DTEViA46GIqVId3vbceWX0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSTVRvkNNnDlM5sni6oOqlsahfsZecy9XiMUI5pgOXvyKdkPR5
	W8PrcoiIbUsKlq7SdCj5jgUILID6+SjYsP5R25hsfh5PVpREA3qhMFMYNMFdna153NeSgpgUQk3
	stk4Ln/2eiDkRQdtz0ouwz5VhyHLtHZFNrHLHjL1aIAHCOT/wgSUK3KK1F+va51dCd+T9xlKxMo
	O1kpPIu4WK1R9XnKJ+R21Z/qOSREKI
X-Gm-Gg: ASbGnctz6p8HoXF3Az9yPE9DNvIjytzl9FANwWSKbzEEe+w1gA5sMfHPXulvJzRqrVI
	ky2ramX7jjISL24JgQpdIg6klt9vF2dJ2Wc0vsxHvTIYPcT4K+iEUMZ7tAhk4iaU3W3Fs2qwyAA
	0+KhF0I0nttRqCKDXGYBe6
X-Received: by 2002:a17:90b:3d08:b0:311:c93b:3ca2 with SMTP id 98e67ed59e1d1-31c9e6e96fdmr7785018a91.6.1752732078189;
        Wed, 16 Jul 2025 23:01:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwj9WmmYZqqcY9e7xgqKnA/kJN103hoaasmkwFwEeUcw9OvLCJ0a3fMKNsQmV80tmXN1QWinAAhZ7uGEl6g/c=
X-Received: by 2002:a17:90b:3d08:b0:311:c93b:3ca2 with SMTP id
 98e67ed59e1d1-31c9e6e96fdmr7784953a91.6.1752732077622; Wed, 16 Jul 2025
 23:01:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250714084755.11921-1-jasowang@redhat.com> <20250716170406.637e01f5@kernel.org>
 <CACGkMEvj0W98Jc=AB-g8G0J0u5pGAM4mBVCrp3uPLCkc6CK7Ng@mail.gmail.com> <20250717015341-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250717015341-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 17 Jul 2025 14:01:06 +0800
X-Gm-Features: Ac12FXzpdsVwGDtCJSLzaoSwQSJcC8NcxCnl7Zblf_dU7B8OIQV_ThQuhTzi5L0
Message-ID: <CACGkMEvX==TSK=0gH5WaFecMY1E+o7mbQ6EqJF+iaBx6DyMiJg@mail.gmail.com>
Subject: Re: [PATCH net-next V2 0/3] in order support for vhost-net
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>, eperezma@redhat.com, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jonah.palmer@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2025 at 1:55=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Thu, Jul 17, 2025 at 10:03:00AM +0800, Jason Wang wrote:
> > On Thu, Jul 17, 2025 at 8:04=E2=80=AFAM Jakub Kicinski <kuba@kernel.org=
> wrote:
> > >
> > > On Mon, 14 Jul 2025 16:47:52 +0800 Jason Wang wrote:
> > > > This series implements VIRTIO_F_IN_ORDER support for vhost-net. Thi=
s
> > > > feature is designed to improve the performance of the virtio ring b=
y
> > > > optimizing descriptor processing.
> > > >
> > > > Benchmarks show a notable improvement. Please see patch 3 for detai=
ls.
> > >
> > > You tagged these as net-next but just to be clear -- these don't appl=
y
> > > for us in the current form.
> > >
> >
> > Will rebase and send a new version.
> >
> > Thanks
>
> Indeed these look as if they are for my tree (so I put them in
> linux-next, without noticing the tag).

I think that's also fine.

Do you prefer all vhost/vhost-net patches to go via your tree in the future=
?

(Note that the reason for the conflict is because net-next gets UDP
GSO feature merged).

>
> But I also guess guest bits should be merged in the same cycle
> as host bits, less confusion.

Work for me, I will post guest bits.

Thanks

>
> --
> MST
>


