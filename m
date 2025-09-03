Return-Path: <kvm+bounces-56653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 592FFB412CF
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 05:13:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FF6017CA75
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 03:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4DF72C3253;
	Wed,  3 Sep 2025 03:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VqcRht0u"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A71265631
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 03:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756869205; cv=none; b=tI4mySu0eGuoWr4DtCdpKhOiPGK7ei35Mq2t+SicwcIYOlb2So2CN0HmSf3tfXXKSaxj8FFeoyWfUS9BcvljkT14kWfOh+wCsuSVRYlYR8AVvRvH+8Df/Oo71L8T33o66a1Pa5Bh/VhiEj22mFUQuzSO1WV0ivfkJ5Ex40Iz7Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756869205; c=relaxed/simple;
	bh=XMHugQRV8upAY2qAFOtTHC5h06Ia39RID/0cXKLd44M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CtA3pn59F+lDy4nhKOZ/2bgj9CrsARt5dDlVv8B/9VpHuEJ35+FzZjR1++OsPygtOcx7PmQRxxR7p3sje07La8DCw7D8CNEYwaVumSvjR2KFmIKdDz1jsaXiEIgQICpF4YoWPYYi2jXwiJ7WKlgBIfSKQ3FPvqoDFQKZj7oI8Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VqcRht0u; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756869203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xol+alIBvLCv0kDjUEFNYzYfWJLZoeFZJYHsWzrrfsI=;
	b=VqcRht0uShy+KAdFJropD2bhO1EIMTIPiVRCsZ2QUgANksYIoY5uw95Z3/4tTB7iwLako7
	HTStvgt+OGv+5vloQh4dsIJLu4v+UZQAoNdwui0p1LJYISr+7joSLVR38sJS5LIMrjnorA
	syzXoI1U5N7BYwZscLq2J3tOKLbe88I=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-OkC1oSdRMyqm4ABjAqwXxQ-1; Tue, 02 Sep 2025 23:13:21 -0400
X-MC-Unique: OkC1oSdRMyqm4ABjAqwXxQ-1
X-Mimecast-MFC-AGG-ID: OkC1oSdRMyqm4ABjAqwXxQ_1756869200
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-329745d6960so3821252a91.0
        for <kvm@vger.kernel.org>; Tue, 02 Sep 2025 20:13:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756869200; x=1757474000;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xol+alIBvLCv0kDjUEFNYzYfWJLZoeFZJYHsWzrrfsI=;
        b=bdfzjGVt6YTB78bfDHwk+ffkpt9HkJvsRTkV1ZIGeklprrtJwxuGHgXLSphE108YYY
         vSNMh5M1IsI48ro0G6tjdxLlGyGf5G5TcdZv3+SJc0pb3JZWExXlFdUlekKgL1ew/W16
         ey5qZw2ptFG0K9/3OP9o1gBcXITYzp+gv7iu9ZW1MCtodGf6YVi96kqZFV7fEX8Zsd8W
         9D4i+i4NMnelYypasEyqFe3zDMYwMjo8nwMANLD6XwQElv6vmDPuWsWlkQGZ2dZBclLz
         G/z8Mn1lfie6zGaaj8i1xgrVsvz/nijVzTXWhM6t82JIJ8ZdO652k8H6mEM2d7qj6QMs
         TtHA==
X-Forwarded-Encrypted: i=1; AJvYcCUQ4FeEiVMP15c7EBxJWIL41Rls175V7UP3NB8lvrZYpop1oNGArHCdyNX99QJ2uiCOank=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6K0B3Z/UIOK2GEZgUcNGkmhaT4d7LYG8/8d/10skBOFMhI/mH
	rm51G8AskYt9k7hAlb3iCeUdQtTYnFlL1BeE2zc8h5ZLyEzeE4En7xWXmNermbW4cRW004beIiP
	4NuYA80S7ZZJxGjlWs7l93AJTBnrxojIdT5PN0TE5trfon9xtMkU/CSCL7/J7s0Q49Au2D/MP6S
	4Usfr/7VRrAOanFrgriM2xl6ftU10p
X-Gm-Gg: ASbGncs+T/rmue2wJ+ISmwl/BgsCfN0dokaVv0x7NKUy2YwZvcTSnCAtfOHZHbjjQU6
	Mpz1kKhxahu4jZu+h70Mzmx0dIAgeelmycFIGqb4wRbPqN2cFzUHuodEz/XRj88wpFDASzpzhK1
	zVYLEWQdXKK1o4Uz+YJ6YRUg==
X-Received: by 2002:a17:90b:5867:b0:327:fd85:6cd2 with SMTP id 98e67ed59e1d1-328156c623emr18214882a91.24.1756869200504;
        Tue, 02 Sep 2025 20:13:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGTcvOJVfQMP9AtXeCfqc3GqOtFGl+2YHKFjgvAyMuI4oaGeseIgP7UAQtunJbi2+5RUMMF8o50W85VET7Ldak=
X-Received: by 2002:a17:90b:5867:b0:327:fd85:6cd2 with SMTP id
 98e67ed59e1d1-328156c623emr18214850a91.24.1756869200081; Tue, 02 Sep 2025
 20:13:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
 <20250902080957.47265-2-simon.schippers@tu-dortmund.de> <willemdebruijn.kernel.6b96c721c235@gmail.com>
In-Reply-To: <willemdebruijn.kernel.6b96c721c235@gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 3 Sep 2025 11:13:07 +0800
X-Gm-Features: Ac12FXyivnmUX4HGcNjFfQl5uUVCs0KxooT46aj1-W0YWPU72YBI_ajqRuEAnwE
Message-ID: <CACGkMEuE-j0mwHUvDg9uocGCG78HAX4oCXVbt-YS7t5G1LTPfQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] ptr_ring_spare: Helper to check if spare capacity of
 size cnt is available
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>, mst@redhat.com, eperezma@redhat.com, 
	stephen@networkplumber.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org, Tim Gebauer <tim.gebauer@tu-dortmund.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 3, 2025 at 5:13=E2=80=AFAM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Simon Schippers wrote:
> > The implementation is inspired by ptr_ring_empty.
> >
> > Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> > Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> > Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> > ---
> >  include/linux/ptr_ring.h | 71 ++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 71 insertions(+)
> >
> > diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
> > index 551329220e4f..6b8cfaecf478 100644
> > --- a/include/linux/ptr_ring.h
> > +++ b/include/linux/ptr_ring.h
> > @@ -243,6 +243,77 @@ static inline bool ptr_ring_empty_bh(struct ptr_ri=
ng *r)
> >       return ret;
> >  }
> >
> > +/*
> > + * Check if a spare capacity of cnt is available without taking any lo=
cks.
> > + *
> > + * If cnt=3D=3D0 or cnt > r->size it acts the same as __ptr_ring_empty=
.
>
> cnt >=3D r->size?
>
> > + *
> > + * The same requirements apply as described for __ptr_ring_empty.
> > + */
> > +static inline bool __ptr_ring_spare(struct ptr_ring *r, int cnt)
> > +{
> > +     int size =3D r->size;
> > +     int to_check;
> > +
> > +     if (unlikely(!size || cnt < 0))
> > +             return true;
>
> Does !size ever happen.

Yes, see 982fb490c298 ("ptr_ring: support zero length ring"). The
reason is tun reuse dev->tx_queue_len for ptr_ring size.

> Also no need for preconditions for trivial
> errors that never happen, like passing negative values. Or prefer
> an unsigned type.

+1.

Thanks


