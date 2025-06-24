Return-Path: <kvm+bounces-50480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BB42AE624D
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 12:23:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 289383A31CE
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 10:23:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C508B28ECE2;
	Tue, 24 Jun 2025 10:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OZH/e3B8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720A4281356
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 10:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750760533; cv=none; b=HcW2+fnrtCfXvnel9giDOzs4aM5Bqm9dP/V0OBgOIgDcTXFVcIHWmJ7PocuHKQqElptwxuFVlQlBQ73Nh7IVHy7+/MfP+EziuCK6SRAYzIU8f4x3gRJGbmPAu5Fb59WuJDCxO4eIoHcKZwfbTagP5IfPrlWDJ50k7QTlOEksz7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750760533; c=relaxed/simple;
	bh=EAplqW2ugJAkvDa+aOJIODUp0iAnSPiEybzJg50wrII=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=psPzBOoh6SdGcVc++O/QmalbA8ElH4qMmv2QJGxXrwIyFY7m/byGbhH18vpS5yqvQFZDqybi0AnpG91KqYdU7Rwh2WMrBVzDdo5sldU56Nd9vmU2A2WItZAtHX+qEsrJLmyHr0xdoRutyxs1z/1MWPlstvsWAb5gBRXDm2l3uSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OZH/e3B8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750760530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LBSg8EY7sp1BX+AXcNCVD/E1en0mg8rYiqbGQhd2mHE=;
	b=OZH/e3B8jD/NDnWCNQVONEXGbmYO6p9dOnUYwmkmaLJ0XXT7NaGgFbnvxrSpy4FEvweRre
	m+S2qf5mVjy9GTF2mbQNtmfC+c5ttmh1x/bQVkOwWNmWtyVKzrN/WOjeWv8F4e+HR2e0yz
	hDtw4IY3btBv/PIcuvCN8Hd9n49u/lc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-OmRNSvngNPKEgOH4qWMkTA-1; Tue, 24 Jun 2025 06:22:08 -0400
X-MC-Unique: OmRNSvngNPKEgOH4qWMkTA-1
X-Mimecast-MFC-AGG-ID: OmRNSvngNPKEgOH4qWMkTA_1750760527
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ade6db50b9cso30106166b.1
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 03:22:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750760527; x=1751365327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LBSg8EY7sp1BX+AXcNCVD/E1en0mg8rYiqbGQhd2mHE=;
        b=J2oYszkwMjmADr2tWQMMttl7NHH+nbuxR9ODdOuGEgsC/rP9kyBRkP4+Rg92apuQ0v
         cODEzmHtx0bxNakexAxubXpOxjmUvNMjlc97f8yHYZGW62TgyHddwk0+qLvGB3aMvOIZ
         GaG7AarghD4xHuKLNzSfoO5gibIRmR+SIx74mHEJym1zJ5IKp1EH1QBXzCJv+1ZOXjMD
         /0sWs/BFBlqJ8iqt15WYeUolGxbUlMnE48IJijGRiEeBYGAZ7j2ev6Lx9yGThz9Pkjvb
         8gOm27/mQquWha+ZdtI1PiTK8qVuoCwt0Lu5yxl5ruYGNW8Xa7onlUxJudCVnNSvnL/b
         UkZg==
X-Forwarded-Encrypted: i=1; AJvYcCVMyy1eCP84IOvOzQYbLaOerWVJKCP9+4On9n0tZjIsad2+WJ+wZelWdSnlc7tUI94qS6E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBkrsNUwX7C2hgf6R+yG99jlRJ8jFCXGVFPN3fx0JV/U//m+h9
	HBRlYIZp6RIMHyavgJeJyaBJlaBwlq3j7QmQPCCneq0+k3WtvPusGTHtG8a8DJ8knAoYR0QIq4F
	mFyfhi4pVrG5lYJp2m2goggig8GKki2V6i2qKxOUimw9IashrPTH/i8ED1AcuGaJtLTUN6XzmM+
	zeqm9NC0YXxSmcQseHiMOY5R09Aleb
X-Gm-Gg: ASbGncvDgvs5xq4biTrar44D6CQ5g05Hhch5SNS5fX1XKkgpCosKgvLZUszw0s86xav
	HGHBzZxmKyVIc91UmAnachgpLweEK0oPtx8eR/YJROzfC2spN/5ZlV7ub0d1iYFl0auP6r+B+ZO
	EXZRqV
X-Received: by 2002:a17:906:8924:b0:ae0:ad5c:4185 with SMTP id a640c23a62f3a-ae0ad5c4bb6mr127042566b.57.1750760525933;
        Tue, 24 Jun 2025 03:22:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFK7idR9ddwSthjp78IPlVH980PF43V9ofMCipwNRyRw+Vq3cABVYLahb6LovHNST8gpasNwDNrhBfNArPnPZc=
X-Received: by 2002:a17:906:8924:b0:ae0:ad5c:4185 with SMTP id
 a640c23a62f3a-ae0ad5c4bb6mr127039766b.57.1750760525506; Tue, 24 Jun 2025
 03:22:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250617001838.114457-1-linux@treblig.org> <CAJaqyWfD1xy+Y=fn1x8uXTMQuq8ewVV9MsttzCxLACJJZg2A2Q@mail.gmail.com>
In-Reply-To: <CAJaqyWfD1xy+Y=fn1x8uXTMQuq8ewVV9MsttzCxLACJJZg2A2Q@mail.gmail.com>
From: Lei Yang <leiyang@redhat.com>
Date: Tue, 24 Jun 2025 18:21:28 +0800
X-Gm-Features: Ac12FXzfQeWK8ouZps9YTtPNR42ROlRbSB3jIfmuYcflJDxiz6fBrlpSiur_mHY
Message-ID: <CAPpAL=xgBK3qqNdaiR=OwbiMaA_5VpouE4YfaEyYghkHxJ0CtQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] vringh small unused functions
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: linux@treblig.org, mst@redhat.com, horms@kernel.org, jasowang@redhat.com, 
	xuanzhuo@linux.alibaba.com, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested this series of patches with virtio-net regression tests,
everything works fine.

Tested-by: Lei Yang <leiyang@redhat.com>

On Tue, Jun 17, 2025 at 8:31=E2=80=AFPM Eugenio Perez Martin
<eperezma@redhat.com> wrote:
>
> On Tue, Jun 17, 2025 at 2:18=E2=80=AFAM <linux@treblig.org> wrote:
> >
> > From: "Dr. David Alan Gilbert" <linux@treblig.org>
> >
> > Hi,
> >   The following pair of patches remove a bunch of small functions
> > that have been unused for a long time.
> >
>
> Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
>
> Thanks!
>
>


