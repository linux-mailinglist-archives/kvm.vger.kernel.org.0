Return-Path: <kvm+bounces-41344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4A45A66612
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 03:10:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BFE2172F2F
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 02:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1571718FC67;
	Tue, 18 Mar 2025 02:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L0k64aBK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C3B155753
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 02:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742263833; cv=none; b=CF8XDIamIrX40yaUeWyT+gHEY22+jt43ezg1CEOy/J4MfOSKzQy5fuTup+vjjdWPPzdHRZKcsxFosyvHeQxt1o3QSHh3X2M8YtyRt3p/veTumOKxhF7zA5RkHBtDH+RTbDk++ScPSkEg5uBwfx4g39IzGBdOQbbbTZw2Ekz5w8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742263833; c=relaxed/simple;
	bh=QR2+CQhFtF3wiXNVfMMn04N/Zgc7E9vWUP/WZyEzsE4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SPt+4ZauJU0DQI4Rj0RW28k3cs0q+kwtK3QMzmZEuKiVfoxEYgMlDALEkYxeT3A5+9nrshdm5Z3U0GvjkgwW7rPibsZRlnq840ou5Pv+09V6jmxIP/G/yoOw/DpqXjgd1OYvh61fFIdVqJ+EdjgGjv1frzfSzY6SiIyBYwLoTcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L0k64aBK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742263830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bocJ4xY+cvLvF8Z2x24tl3LRmmXAsvkZEGxfx5yQFuM=;
	b=L0k64aBKhp6EbDzupLaFCy+aPU5PrxFhExHhz/+PM1VwUpxn0oFPKX+3zTvabHatSTYEvL
	eczio3BysO3SeOPgC5KWjqCSVJz2U6IwRwx4GVa+vCs/EguTBT0WbQ6mOx5mr3y/vdxd0y
	nyGMqBmL4vikhmDdUUOhj5OJZDwCL1g=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-JbOHVoNAPS-tPPlvdb1jcg-1; Mon, 17 Mar 2025 22:10:28 -0400
X-MC-Unique: JbOHVoNAPS-tPPlvdb1jcg-1
X-Mimecast-MFC-AGG-ID: JbOHVoNAPS-tPPlvdb1jcg_1742263828
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5e68e9d9270so4124150a12.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 19:10:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742263827; x=1742868627;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bocJ4xY+cvLvF8Z2x24tl3LRmmXAsvkZEGxfx5yQFuM=;
        b=lFV6JU6/i8uEBuC8Eo1GuyX/FhIiYLrCo0Mqw0RY5/z0T2PT+liZ1rXbzzJXf25GkM
         xe5RnKzB0deynN3IPDCNhZTpIsZC+kZED5tvHqU3oghak7P3ENp4kSoqVGXuM/NPPlc2
         0b9e8Bo0R9bCgo9VsbJOVsMlATGGtUN9aev2DGvMhUDl+5HAaNj2Je46NbZnVsdfiqv6
         YYKYqXTZYHTiCnQOlurHz7WwbGaAsoABwVdLRVHMjBXxiyHhppo6WbO+tNeoBSTNw++1
         khj1Xv11ti9Hvcu3VJ2ompmuHAw0nx+HWwzw8q8Z2/xj46AJayvU6xTSmzJMiBAOtnR3
         EGbQ==
X-Forwarded-Encrypted: i=1; AJvYcCW28/mTe2NGZSDjSsP64QcJ2cOivUlCVLMLBoBdAZeiw/o3VbLM1INOQ2/KjW2r3v6dN7U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/192CDHJtJRkNS3s7pSr1H+xCVIPnYxyqppyJH6LrJtxgVchT
	OH+6GuomzTt6q5EYxWZ0xDdv8BmbuCIoqUvb6Y8XT92qWVTkugqRuXKEZ8ygET6tiqY6QmnqiMX
	Pl+paPbEG/uIaiK2lEUdf0EkM4bWcD3xK5/BnnY74cthbxcKZTCXWaNDK21T411bvrbPYpR5EGO
	XYRggkRJ0i49uA7TLn7h5hUcO5
X-Gm-Gg: ASbGncuSOgrNDqYhS9fdPyySmAEtd8RjZt3C/QpaEUKsSJLYX/aQsJ7Y5IF74zpPCFt
	1s8l6Wg8IUv2yVeK7WopTDWuYRnCctBrGhffzRQFUJPY63JS7RGPxIbXxKUs5AjTY2hZ9NGEf5A
	==
X-Received: by 2002:a05:6402:348d:b0:5de:cbed:c955 with SMTP id 4fb4d7f45d1cf-5e89fa5252bmr15904545a12.17.1742263827512;
        Mon, 17 Mar 2025 19:10:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCvFJRxiUrK3Hl8RQJ4gACrb1PAEIxR0Zqht6rIjp/tdZBCVDepPjzyLxDhCMISfCanvYlkZjNzb4UQTjWFWQ=
X-Received: by 2002:a05:6402:348d:b0:5de:cbed:c955 with SMTP id
 4fb4d7f45d1cf-5e89fa5252bmr15904525a12.17.1742263827103; Mon, 17 Mar 2025
 19:10:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250317-rss-v11-0-4cacca92f31f@daynix.com> <CACGkMEu=pPTd-QHKRDw7noRCTu-18c7JLJNKZCEu5=BHAE0aJQ@mail.gmail.com>
In-Reply-To: <CACGkMEu=pPTd-QHKRDw7noRCTu-18c7JLJNKZCEu5=BHAE0aJQ@mail.gmail.com>
From: Lei Yang <leiyang@redhat.com>
Date: Tue, 18 Mar 2025 10:09:50 +0800
X-Gm-Features: AQ5f1Jpjunc8xib_cyTewZlm6iAFgRKVvfy1UVZQ0lyOQH2XWEffoxUQGNr9u5c
Message-ID: <CAPpAL=yfgiuFA-SyrCe0Ud8Wm9tJMcMm9L4Q-AnnuRzN+Q9M=A@mail.gmail.com>
Subject: Re: [PATCH net-next v11 00/10] tun: Introduce virtio-net hashing feature
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
	Yuri Benditovich <yuri.benditovich@daynix.com>, Andrew Melnychenko <andrew@daynix.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com, 
	Simon Horman <horms@kernel.org>, Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

QE tested this series of patches v11 under linux-next repo with
virtio-net regression tests, everything works fine.

Tested-by: Lei Yang <leiyang@redhat.com>

On Tue, Mar 18, 2025 at 8:29=E2=80=AFAM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Mon, Mar 17, 2025 at 6:58=E2=80=AFPM Akihiko Odaki <akihiko.odaki@dayn=
ix.com> wrote:
> >
> > virtio-net have two usage of hashes: one is RSS and another is hash
> > reporting. Conventionally the hash calculation was done by the VMM.
> > However, computing the hash after the queue was chosen defeats the
> > purpose of RSS.
> >
> > Another approach is to use eBPF steering program. This approach has
> > another downside: it cannot report the calculated hash due to the
> > restrictive nature of eBPF.
> >
> > Introduce the code to compute hashes to the kernel in order to overcome
> > thse challenges.
> >
> > An alternative solution is to extend the eBPF steering program so that =
it
> > will be able to report to the userspace, but it is based on context
> > rewrites, which is in feature freeze. We can adopt kfuncs, but they wil=
l
> > not be UAPIs. We opt to ioctl to align with other relevant UAPIs (KVM
> > and vhost_net).
> >
> > The patches for QEMU to use this new feature was submitted as RFC and
> > is available at:
> > https://patchew.org/QEMU/20250313-hash-v4-0-c75c494b495e@daynix.com/
> >
> > This work was presented at LPC 2024:
> > https://lpc.events/event/18/contributions/1963/
> >
> > V1 -> V2:
> >   Changed to introduce a new BPF program type.
> >
> > Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> > ---
> > Changes in v11:
> > - Added the missing code to free vnet_hash in patch
> >   "tap: Introduce virtio-net hash feature".
> > - Link to v10: https://lore.kernel.org/r/20250313-rss-v10-0-3185d73a9af=
0@daynix.com
> >
>
> We only have 2 or 3 points that need to be sorted out. Let's hold on
> to the iteration until we had an agreement.
>
> Thanks
>


