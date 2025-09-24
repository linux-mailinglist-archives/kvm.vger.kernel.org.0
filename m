Return-Path: <kvm+bounces-58627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D72AEB98FE8
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 10:55:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 795ED189A4F7
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 08:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 279112D0619;
	Wed, 24 Sep 2025 08:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LKPQJMFl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEFF285C96
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 08:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758704106; cv=none; b=J8EeYWsJgMMGB0b91AnOuhycVc4GBVrUcxRs9EP4S/UL1d5m4LHYPJm/3WsRw+hhi7BKNU49S0pXw05k4pH/WHgoHKLUycP9EyDUeu+O7gGYaVakELHlYwpcsbFIfuhGOtsobwH70xHP/yNZtKEw6gDgQa2NQjRBNGwCryS+MTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758704106; c=relaxed/simple;
	bh=yC4F9BxKMD2tLjzPZNMkOfB70p02zY5u5wUAbNq4KtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HF8fYlrWbekzMgtLimntfR0gEaXWA6leEvJVP/QcNwCvKp4P/zlRcT3ccQ0aTDCaXH/ydn4a8t6DG0eNWnPrwtVxgQyafSweG6+PiLL1Ag2aLrDQe9lkebMF7mkuQXb2QAamADpTCv5xtH1Q392u7cXq/rvfSYJ0oZ9hByZuk7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LKPQJMFl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758704103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oeF4iLafWqiyYhAJj/z0HEWgGu1flHRP9T+bwNm7VOY=;
	b=LKPQJMFlPtlepooEfDAZhUqpUFS1VJAA3mhfz0yE9QIMcmitxyvLd3qKqqj8xGAb2uYCel
	LWnPCTxVOfWE/yWPx+bypCwf0O3FMKvF7CDW2iwAPYNRvfpp3t2p1Xew1FUVr5x2e2xsJx
	yCoZN8VitByyd4ETILd9MBAaIpFmmpc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-5aGDM6iXPSeDdlr12M_ZEw-1; Wed, 24 Sep 2025 04:55:02 -0400
X-MC-Unique: 5aGDM6iXPSeDdlr12M_ZEw-1
X-Mimecast-MFC-AGG-ID: 5aGDM6iXPSeDdlr12M_ZEw_1758704101
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-632c9a9ceb1so3857054a12.0
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 01:55:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758704101; x=1759308901;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oeF4iLafWqiyYhAJj/z0HEWgGu1flHRP9T+bwNm7VOY=;
        b=PsOQyG50qS1ujy3HBQX5qaNVO86eUnfnzknLZLbHrJqqhQrzn/Hthpk35pr+Lftsrc
         iF5LjytSw0Z46emDdneOElGj72ScQENO6GI1+8aQP6I8tOZyfcYRzfYFlKa6Xhcai6iH
         Gw28cK02FJOdXge9Q0hb1s8RHI+zGdSUb+Ea0xazxeht0mMhvEEKwxwx2TP3Bkr3ohoI
         cb2iapm+Qbg7Q1x8sNbGhqWMee63QL+OVg9ru1z067Awn53Lk5t2pgFSR6f1wLmVsWNX
         nG7JpAwmTSCZvQdEJNQvPGzDeHfiLtG2oMHoCUkh1YYUmfUXiqaHMKRjXZoB3eKHKXYa
         HJ1w==
X-Forwarded-Encrypted: i=1; AJvYcCX7WJyUDib8FS6GXc4bKZBOuCvEAtqE2nll3fzwvxJouKDwpogEhhgewJVcVZ3DzgSl1fQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzR5eb8FWGCOI+KpSb82qpriUjDxLS2rSJ5A+hqkFY8Hdp5GDmq
	EcvmUfTtlBUl0/lMWopjO4HmCjC2onQIj8cKaZex7a1KoPGBYNQ6FO9mfJ3sv28EZ5rtKbLF5oa
	z/YiPjPmbSG1sgv5GtN+/tKigjETsirj+AFccqp+7jLd1ZIlu0E077A==
X-Gm-Gg: ASbGncv+nn9whJHOabojb5vk/waMKgg00NaeMT0KkyCCz2Snrpx1tECSl1btMGWFr2j
	PDW2VSZsmUcJoYTEyP/xa3yHd02K/qRkZ05tbvyBkzqM6TcloP+aI6G/EqDlsZ+/ROzF/sCX6f3
	raSQLTEci8cMvUUA0bHTeY6a92S4Pp3iQO82n0fa8fmIjI6E7me3MAL4vtTB2GAALkqZcRGPLoS
	0MmWDsLbLiZrIaf/bpPRP/BXr2x+L8kMSM1NBpwS8vraezLbQpYt8SgXOPCDS260NCEwQF6DHyx
	ADvL41J+IE4vYNTS7jZ2Y51gDDPA
X-Received: by 2002:a05:6402:42d4:b0:634:66c8:9e6d with SMTP id 4fb4d7f45d1cf-63467a196c6mr5117514a12.35.1758704100840;
        Wed, 24 Sep 2025 01:55:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGsvQzI/barPCHCcY3wmgFpimCqdL8DPZENn3l5dqczZHN9mqSB95iiRU7jvEjFsRYlUtc7jA==
X-Received: by 2002:a05:6402:42d4:b0:634:66c8:9e6d with SMTP id 4fb4d7f45d1cf-63467a196c6mr5117491a12.35.1758704100372;
        Wed, 24 Sep 2025 01:55:00 -0700 (PDT)
Received: from redhat.com ([31.187.78.57])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62fa5d03befsm12964100a12.2.2025.09.24.01.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 01:54:59 -0700 (PDT)
Date: Wed, 24 Sep 2025 04:54:56 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>,
	willemdebruijn.kernel@gmail.com, eperezma@redhat.com,
	stephen@networkplumber.org, leiyang@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v5 0/8] TUN/TAP & vhost_net: netdev queue flow
 control to avoid ptr_ring tail drop
Message-ID: <20250924045430-mutt-send-email-mst@kernel.org>
References: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
 <20250924031105-mutt-send-email-mst@kernel.org>
 <CACGkMEuriTgw4+bFPiPU-1ptipt-WKvHdavM53ANwkr=iSvYYg@mail.gmail.com>
 <20250924034112-mutt-send-email-mst@kernel.org>
 <CACGkMEtdQ8j0AXttjLyPNSKq9-s0tSJPzRtKcWhXTF3M_PkVLQ@mail.gmail.com>
 <20250924040915-mutt-send-email-mst@kernel.org>
 <CACGkMEtfbZv+6BYT-oph1r8HsFTL0dVxcfsEwC6T-OvHOA1Ciw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEtfbZv+6BYT-oph1r8HsFTL0dVxcfsEwC6T-OvHOA1Ciw@mail.gmail.com>

On Wed, Sep 24, 2025 at 04:30:45PM +0800, Jason Wang wrote:
> On Wed, Sep 24, 2025 at 4:10 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Wed, Sep 24, 2025 at 04:08:33PM +0800, Jason Wang wrote:
> > > On Wed, Sep 24, 2025 at 3:42 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Wed, Sep 24, 2025 at 03:33:08PM +0800, Jason Wang wrote:
> > > > > On Wed, Sep 24, 2025 at 3:18 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Tue, Sep 23, 2025 at 12:15:45AM +0200, Simon Schippers wrote:
> > > > > > > This patch series deals with TUN, TAP and vhost_net which drop incoming
> > > > > > > SKBs whenever their internal ptr_ring buffer is full. Instead, with this
> > > > > > > patch series, the associated netdev queue is stopped before this happens.
> > > > > > > This allows the connected qdisc to function correctly as reported by [1]
> > > > > > > and improves application-layer performance, see our paper [2]. Meanwhile
> > > > > > > the theoretical performance differs only slightly:
> > > > > >
> > > > > >
> > > > > > About this whole approach.
> > > > > > What if userspace is not consuming packets?
> > > > > > Won't the watchdog warnings appear?
> > > > > > Is it safe to allow userspace to block a tx queue
> > > > > > indefinitely?
> > > > >
> > > > > I think it's safe as it's a userspace device, there's no way to
> > > > > guarantee the userspace can process the packet in time (so no watchdog
> > > > > for TUN).
> > > > >
> > > > > Thanks
> > > >
> > > > Hmm. Anyway, I guess if we ever want to enable timeout for tun,
> > > > we can worry about it then.
> > >
> > > The problem is that the skb is freed until userspace calls recvmsg(),
> > > so it would be tricky to implement a watchdog. (Or if we can do, we
> > > can do BQL as well).
> >
> > I thought the watchdog generally watches queues not individual skbs?
> 
> Yes, but only if ndo_tx_timeout is implemented.
> 
> I mean it would be tricky if we want to implement ndo_tx_timeout since
> we can't choose a good timeout.
> 
> Thanks

userspace could supply that, thinkably. anyway, we can worry
about that when we need that.

-- 
MST


