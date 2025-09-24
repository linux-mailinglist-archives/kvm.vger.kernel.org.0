Return-Path: <kvm+bounces-58622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66319B98C32
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 10:09:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAB414C1C07
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 08:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1334A28153D;
	Wed, 24 Sep 2025 08:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CDOVuFnO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A5327FD64
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 08:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758701331; cv=none; b=hGKwnl17ezAmzE+ePc0ggKzYp2ye5QQtkVj4USgiKxxeBFZGQ7p7txV+EJLAReotpj7kI3R2OzzSWfgtl5932/eobWoR7Yt9Y3CBFh8+UJapDPk+NXFFV8WcInXn70LHtd5RSXkRCf+welUKYldvokCBfGeX2Uz2+J6sywDgnb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758701331; c=relaxed/simple;
	bh=a6oCuIAb870BUM/wLcCKideEO8jeeHZlteSZfzewe0o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p4fGr6hY7rEN1VEaN86PKyp0Fu5GJmwc/M1f3BW7F/xIX0ooKBGW57aVu74NaQLtD3TEOXlGFmYhkdgxW5FQz7nM5rJxmWSf8BorBXcXr9ssIfenfm+NyzDzDkLrdmAs28YE035cDaX99s0Ou0MEuCykuRAXLDG/AC/Y5HZgmf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CDOVuFnO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758701328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a6oCuIAb870BUM/wLcCKideEO8jeeHZlteSZfzewe0o=;
	b=CDOVuFnOCZtdEaflcZ0gXCyYCUu1cyYpIH55MRnBun8Ms6MJshF7RSguhqUxOgh8Rr5dYI
	wBcn5pqYHTyGyefpYjmDPidJGiavSmyJTTecLTF6cPSt279BJ4NEkwnt0KxNn7FuTy7A2D
	mzuoX/9146wLUa6dNJsrTgyGnmF6Kqg=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-172-kpKoxkgfOKS9iOFeX-XwGA-1; Wed, 24 Sep 2025 04:08:47 -0400
X-MC-Unique: kpKoxkgfOKS9iOFeX-XwGA-1
X-Mimecast-MFC-AGG-ID: kpKoxkgfOKS9iOFeX-XwGA_1758701326
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-32ee62ed6beso8965474a91.2
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 01:08:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758701326; x=1759306126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a6oCuIAb870BUM/wLcCKideEO8jeeHZlteSZfzewe0o=;
        b=ROW4Bc9Z6lUUblFmn3STnmkEEHzJaz2mfLKjZ14IEBSELNCmcwJnJyRFJ/TcF3UTJO
         r58rsuxvfOWtYhhUbzqGqGC9GnhnmYh/sKZ9760KzcsHGlgW8c9ta66GxlVcwvWXF0ss
         h371yEeKDjirqNUaWLOSjh/F/JU569aqW2q7894m19Posn83VyvsQ9PlgZUHq8hejQaK
         g9mnoo/HF0ZsFIGcs33LW8ss3hZFONdwU0Nhy5i8eZgT/tw59Fztt9EqgfYUtDT+8JmU
         8pTAzZS0CmeQdbfhQ8TMqE1CX+B2l2Po4VZDzaMV0H3FJS3yZ8dga8tJy5+CCfOBuDg9
         EMWw==
X-Forwarded-Encrypted: i=1; AJvYcCWltRsYGDt+8U/2L/5brTXV3GiO8NBTzzURTh+AZgH7693hB0wUyO6uSI198MloFYPrty4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu9yVpc1BXkd4pWO7ONJAmyxKa4NBmEgjuGLGfgDWH0hx/u/mv
	eIxOyZS4L8oa4s2wawFTsJkupZmE/VGSzQ/VAGpiUMNLA1CBrKhlnrUuvrTg8tp/93I2MfRiPmA
	Hi0Vfka6H/UD1UkZQbKimxNc4YXPLZdF2Ue8U33PRFINxalxOFVZNvnH1tNAROs4jkIxbKXXGTO
	eVeUfS4UweJfFG10AZ80Hl570+fACn
X-Gm-Gg: ASbGncv2T3mXVnp4WXnOou1olEt61oW4J6m0wMC8LmyHcPTD7JChFELw0W7KMxu2sWZ
	Ys+EpvU6ikRJ+4ion5jcru6OgJBuDvyQ5qj0GkGr8P5IlHotcMKfVUzCbu8mii5P1ON5NkRt+QG
	rtEDmsWWVyV/kEkREB8Q==
X-Received: by 2002:a17:90b:4fca:b0:32e:381f:880d with SMTP id 98e67ed59e1d1-332a951400bmr6699297a91.8.1758701326067;
        Wed, 24 Sep 2025 01:08:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2GLbIR2MSlOxRK5RL4gOPgfnLpfnRkVHAyb6+Hg393gRc4iItMUlqLDitFzlb4iawxNuY2oPPUXbPSwFGVqA=
X-Received: by 2002:a17:90b:4fca:b0:32e:381f:880d with SMTP id
 98e67ed59e1d1-332a951400bmr6699276a91.8.1758701325715; Wed, 24 Sep 2025
 01:08:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
 <20250924031105-mutt-send-email-mst@kernel.org> <CACGkMEuriTgw4+bFPiPU-1ptipt-WKvHdavM53ANwkr=iSvYYg@mail.gmail.com>
 <20250924034112-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250924034112-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 24 Sep 2025 16:08:33 +0800
X-Gm-Features: AS18NWA6IoDbRnFJrQROlwKl7JtPi3QrLkppEKjQdynw71Swtwg92BSiXVWInSg
Message-ID: <CACGkMEtdQ8j0AXttjLyPNSKq9-s0tSJPzRtKcWhXTF3M_PkVLQ@mail.gmail.com>
Subject: Re: [PATCH net-next v5 0/8] TUN/TAP & vhost_net: netdev queue flow
 control to avoid ptr_ring tail drop
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>, willemdebruijn.kernel@gmail.com, 
	eperezma@redhat.com, stephen@networkplumber.org, leiyang@redhat.com, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2025 at 3:42=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Wed, Sep 24, 2025 at 03:33:08PM +0800, Jason Wang wrote:
> > On Wed, Sep 24, 2025 at 3:18=E2=80=AFPM Michael S. Tsirkin <mst@redhat.=
com> wrote:
> > >
> > > On Tue, Sep 23, 2025 at 12:15:45AM +0200, Simon Schippers wrote:
> > > > This patch series deals with TUN, TAP and vhost_net which drop inco=
ming
> > > > SKBs whenever their internal ptr_ring buffer is full. Instead, with=
 this
> > > > patch series, the associated netdev queue is stopped before this ha=
ppens.
> > > > This allows the connected qdisc to function correctly as reported b=
y [1]
> > > > and improves application-layer performance, see our paper [2]. Mean=
while
> > > > the theoretical performance differs only slightly:
> > >
> > >
> > > About this whole approach.
> > > What if userspace is not consuming packets?
> > > Won't the watchdog warnings appear?
> > > Is it safe to allow userspace to block a tx queue
> > > indefinitely?
> >
> > I think it's safe as it's a userspace device, there's no way to
> > guarantee the userspace can process the packet in time (so no watchdog
> > for TUN).
> >
> > Thanks
>
> Hmm. Anyway, I guess if we ever want to enable timeout for tun,
> we can worry about it then.

The problem is that the skb is freed until userspace calls recvmsg(),
so it would be tricky to implement a watchdog. (Or if we can do, we
can do BQL as well).

> Does not need to block this patchset.

Yes.

Thanks

>
> > >
> > > --
> > > MST
> > >
>


