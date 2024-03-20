Return-Path: <kvm+bounces-12274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16358880EAA
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 10:34:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6DD4285019
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:34:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516FE3BB23;
	Wed, 20 Mar 2024 09:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kx31ALfh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1571F383A1
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 09:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710927230; cv=none; b=biyyzNhwTf6zllzPSH3pZxB+zWuPO3mjWyRPzRPortZkYk4YG8FuyXKcSD+rBjz13imI3szkHCZCpLNW3TT7QRMD+rVFj//PfTSuCl/hFzSQQG6Dmz0078tYm0+yPUt5FuEnwBbp8+FF8R6gaQxwRoTTC/gAJoo6BQEVwpMTsRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710927230; c=relaxed/simple;
	bh=rIvSI2QztdyNfnCwDgEYDf6HC5lzN4Ss9otJr05cGgM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cjqQs6gQNsoG1mqYGM8IQjmOsF9LwdDKI0ICSeZ4VrJAET6sQ82RLJiBAwrX/h7mcL/4IUHoIGp7xn9ZNp8z4bDEvQOVDbjRpwfiHT5eyp6GwzXrHP36HgzvB4ijHAD4CHAOGQQxtkM8MuF6NgM+Tzq2KmpSpeiuYJ0v0AuaOiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kx31ALfh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710927228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t0kBDUeIU2tU7V7hAw2d2cR8ZW6aMG/rZwr9VASxfRY=;
	b=Kx31ALfhJXawLVeYRZd6QZLTruTjjj6Ov+qgrv/OYyltHSEnyMpim9ejJ3NDNec+1boeeG
	15cOf3tGr9/BmHGMqjYRRDNQOXJM9JrjkUVtq+aUsZxFYeaPzjIzgklUEsvcKFLGYRMcCW
	fYV+tV1yHeuZTPAaDYR6LRZAuPaKYlk=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-491-yCxNf1RHMiavTgp9LVg4wg-1; Wed, 20 Mar 2024 05:33:45 -0400
X-MC-Unique: yCxNf1RHMiavTgp9LVg4wg-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-29de3646c56so4360542a91.2
        for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 02:33:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710927225; x=1711532025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t0kBDUeIU2tU7V7hAw2d2cR8ZW6aMG/rZwr9VASxfRY=;
        b=WhOzrusojMia6YxGWLnc3makgwtFMAzXym2wGnMo9zoB/6Z3RFUjLvexLILU7ELT6f
         N+/+0NCt5pwVvTx3fEvZw36ptgF/TawDSHACZWhfneaieLQ6druSXEsChDAWg0NneCTJ
         8QST+6N9QuTv1QBGMM5q+k3FSomY+hpx4aXwjJsd1AQkBVIpKkDD6ZHX9Y+KqdisqbFT
         Fv7iuvXzOIZcTbm8cwRqPbKhia6oDryxA7iWbV14PrPXjB8RhXnVzZ3deJdDvM/Ntm85
         C8mFRwkpDVIpzXrdVot+vR47y6Vwd+2d90OasxTy28YoKBOxlzG8sxabWokl9PsgzWYA
         hgAw==
X-Forwarded-Encrypted: i=1; AJvYcCWv0aEqJrv08N46p6vZ31l/NRq0slmAIs153EMyUV4JSFXr1+nYrGOOGHsE10JFckwOEm/hkhEF+EsVDgkywOvyvkW+
X-Gm-Message-State: AOJu0YzXJsHRrVMeqp1x4yaF8V2urtGk6LRNhp822hquh/YntDdj7G4V
	+LnS3BY06WaE5V5PEwf2Ua95E5eUF+AYXjh1/aW+QwcjpawviqtKvUh3nmoduzTKdAvMRnSuTh/
	WGyGzaNj6pbKpqXF6HjWZ6haods9nTqiLXG30dR04DsnI4n8TuFaxXTsyb0x7PW6kqx1a0X2HiL
	7XNfVkKJo3hSbnZG2UOMZLVv1b
X-Received: by 2002:a17:90a:8c94:b0:29b:22d2:9dd5 with SMTP id b20-20020a17090a8c9400b0029b22d29dd5mr1349905pjo.38.1710927224738;
        Wed, 20 Mar 2024 02:33:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIZm4NI4PcqMeB2pAm+rJi2GQMkk6TxHsP6dGGnFR/lCMDpHSQWV3a2utJ8oOtHZLuA9Xc8El1pKEXKRCf56I=
X-Received: by 2002:a17:90a:8c94:b0:29b:22d2:9dd5 with SMTP id
 b20-20020a17090a8c9400b0029b22d29dd5mr1349896pjo.38.1710927224416; Wed, 20
 Mar 2024 02:33:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+9S74hbTMxckB=HgRiqL6b8ChZMQfJ6-K9y_GQ0ZDiWkev_vA@mail.gmail.com>
 <20240319131207.GB1096131@fedora> <CA+9S74jMBbgrxaH2Nit50uDQsHES+e+VHnOXkxnq2TrUFtAQRA@mail.gmail.com>
In-Reply-To: <CA+9S74jMBbgrxaH2Nit50uDQsHES+e+VHnOXkxnq2TrUFtAQRA@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 20 Mar 2024 17:33:33 +0800
Message-ID: <CACGkMEvX2R+wKcH5V45Yd6CkgGhADVbpvfmWsHducN2zCS=OKw@mail.gmail.com>
Subject: Re: REGRESSION: RIP: 0010:skb_release_data+0xb8/0x1e0 in vhost/tun
To: Igor Raits <igor@gooddata.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	Stefano Garzarella <sgarzare@redhat.com>, Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2024 at 9:15=E2=80=AFPM Igor Raits <igor@gooddata.com> wrot=
e:
>
> Hello Stefan,
>
> On Tue, Mar 19, 2024 at 2:12=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.=
com> wrote:
> >
> > On Tue, Mar 19, 2024 at 10:00:08AM +0100, Igor Raits wrote:
> > > Hello,
> > >
> > > We have started to observe kernel crashes on 6.7.y kernels (atm we
> > > have hit the issue 5 times on 6.7.5 and 6.7.10). On 6.6.9 where we
> > > have nodes of cluster it looks stable. Please see stacktrace below. I=
f
> > > you need more information please let me know.
> > >
> > > We do not have a consistent reproducer but when we put some bigger
> > > network load on a VM, the hypervisor's kernel crashes.
> > >
> > > Help is much appreciated! We are happy to test any patches.
> >
> > CCing Michael Tsirkin and Jason Wang for vhost_net.
> >
> > >
> > > [62254.167584] stack segment: 0000 [#1] PREEMPT SMP NOPTI
> > > [62254.173450] CPU: 63 PID: 11939 Comm: vhost-11890 Tainted: G
> > >    E      6.7.10-1.gdc.el9.x86_64 #1
> >
> > Are there any patches in this kernel?
>
> Only one, unrelated to this part. Removal of pr_err("EEVDF scheduling
> fail, picking leftmost\n"); line (reported somewhere few months ago
> and it was suggested workaround until proper solution comes).

Btw, a bisection would help as well.

Thanks


