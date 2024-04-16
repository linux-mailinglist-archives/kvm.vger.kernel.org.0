Return-Path: <kvm+bounces-14877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AD838A7521
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 21:53:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 09205B21D1F
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:53:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 804B113958B;
	Tue, 16 Apr 2024 19:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gJ+dvupa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D7D1386AC
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 19:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713297218; cv=none; b=cWhoqEbRvvknnN9oubMXpAglF8d+ZFiUNXq0+gvJ/9BVBixNcAbEH5S7d1mwTAFTsPfC9zckX5LUyxiZqLqr+zLmIUrS15lOCro2s4H9OYzFUJ2DVs+aVzIW1giHfyvx7BmTWI1VIYGEUXO4KwUy4d674vtRZhmkc5taJl8aJ7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713297218; c=relaxed/simple;
	bh=9gUD5M/iXssTO5Xh8NSAH7//1Cb8mDtB2KtSbMHD000=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=krWx5PSsUNlYgkjkr7m1q2yT28NptQo8O/4jtbhe+eUAtdiIl1oGID0fH1L+fc97aN8oyT2GVzBZXPQdmUTZpnxoUyCuoMdUFKAj3/7+B0f36HnaISkZ13gxXATjTj0xe9szDDLbNCqmgpkbnLamkdyTmBtuqp5NcrIuJ16isjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gJ+dvupa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713297216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lw/7y0/GFS1bW+8o2hjWhoijSh0n+IXQOkuIPY73oXI=;
	b=gJ+dvupaeGNqG3CbNfNZQst4VgGxwoZJVPauMT2mKlTpmdsi+mhEab8Gr9MOEkT0Q2EHY/
	kqMyqZi5iFlpGu6JHvGSBG77NIjEX2fVEbuSyqaYdtIyiXExBSdEEaZiRIPAopLZX7CsWE
	/Ba1LMBqnrAeHB6N9XzCgvgSOEGVZks=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-rxrwbFdVOLiUYoo8UMktnQ-1; Tue, 16 Apr 2024 15:53:35 -0400
X-MC-Unique: rxrwbFdVOLiUYoo8UMktnQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-343ee8b13aeso3869303f8f.2
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 12:53:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713297213; x=1713902013;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lw/7y0/GFS1bW+8o2hjWhoijSh0n+IXQOkuIPY73oXI=;
        b=PNv5uFNvYbSG5ADqthFNevgwkQXe2iNWJVd9EWZLC3iaYExynTFsZQK0N0qkKLm4Ta
         DZR39fI0BAAUaFUk7y9cfKdkiePpgcZ7Kcx5tIlet2YqFwHZ81CqU5w8YWf+VSZtl+fN
         hRgsKuMz8IJkWapWVUmcVLqhEn9EQ5b8QnUuOApMWTmAhRfmLSSvGihhEXp3+4vHNSg/
         YuQSccJKbsBRACQtN0i634kJRKO7zUzUa94gZEMoUwm1UkRjgaG9wfnWvKLhrz00SST2
         ShXbeI/9W5CVThBEvqzPOvu1zvreDj5M1rUeGW2oTJ6qlIkm+EikOukBTp20d1z91Gr5
         oyPQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5agFPHZCQzkP1Y4Gz0ym4YcRxPuWPF4aFU8QDT1McGxO0L1dWcuig7fbptl3t5ELr4JTO5wWdoWN5FBanqcBpIonf
X-Gm-Message-State: AOJu0YwX2I2SrsuNevBZspVwm5Zh++vsSBul3Q6V+84S6o2YWCVrMqYG
	jwOl0pwp3QjxOSeSS1Tcj7mc8sPp/nIarZsSV5a6EbZ1so3Lm5Wn6TtIMEa2ZJTzpM6lKt0IFVq
	vxDKavcLpQllOhnuhUDmfShgLD47Nnr0h2toTUCgHdc/xnczyw8Cx70wYXaSy51qenoOVtJVO7Q
	Lsr66/Uq4rSwtnJf/CxPRGybwayzzhZUWYjWc=
X-Received: by 2002:a5d:614d:0:b0:341:865b:65c9 with SMTP id y13-20020a5d614d000000b00341865b65c9mr11372510wrt.22.1713297213489;
        Tue, 16 Apr 2024 12:53:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEsM9yRS/5L8y+d9XdCzLHbdP+imRkztXX3qhOnE5sUeovqvYfaKrjqA6bcmlyakZyurXtSoMzmWaWzV7L3s/M=
X-Received: by 2002:a5d:614d:0:b0:341:865b:65c9 with SMTP id
 y13-20020a5d614d000000b00341865b65c9mr11372494wrt.22.1713297213153; Tue, 16
 Apr 2024 12:53:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
 <20240215160136.1256084-2-alejandro.j.jimenez@oracle.com> <Zh7BOkOf0i_KZVNO@google.com>
In-Reply-To: <Zh7BOkOf0i_KZVNO@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 16 Apr 2024 21:53:21 +0200
Message-ID: <CABgObfZ6Q0t+J7=-BfZz4y9fDUtmJzt_RSyQ43LCg0KMpYC3+g@mail.gmail.com>
Subject: Re: [RFC 1/3] x86: KVM: stats: Add a stat to report status of APICv inhibition
To: Sean Christopherson <seanjc@google.com>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, joao.m.martins@oracle.com, 
	boris.ostrovsky@oracle.com, mark.kanda@oracle.com, 
	suravee.suthikulpanit@amd.com, mlevitsk@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 16, 2024 at 8:19=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> > +     u64 apicv_inhibited;
>
> Tracking the negative is odd, i.e. if we add a stat, KVM should probably =
track
> if APICv is fully enabled, not if it's inhibited.
>
> This also should be a boolean, not a u64.  Precisely enumerating _why_ AP=
ICv is
> inhibited is firmly in debug territory, i.e. not in scope for "official" =
stats.

It is a boolean, but stats are all u64 in the file and the contents of
the file map the stats struct directly. See for example the existing
'u64 guest_mode".

Paolo


