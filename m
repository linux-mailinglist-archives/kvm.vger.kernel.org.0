Return-Path: <kvm+bounces-21457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0EDB92F27C
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 01:07:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 841FA282E62
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 23:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54FD61A0B16;
	Thu, 11 Jul 2024 23:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N1VQR3/s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206B41DFE3;
	Thu, 11 Jul 2024 23:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720739249; cv=none; b=jhk6BedNO0W9OUMkog8YltVkN5IDWMw5vKAGUc31pFXwEQEeh4KRcxI1JrU+w+hnGOG0NUfe3wC2bK2mgiPif1Xf3W4VlIZ4EvA7WV0TmZ/bz57C5mnajMzivLAJMvhIDJHgLbar2P32wfyCK37QIPHvzcGirdbpZ4Z0wEfqHmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720739249; c=relaxed/simple;
	bh=UcMXaEV7R/bUuyeSozVX/+Hj1QoPeLuD2nEoxOWGzU0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UkxpWzARWiCDnoqtNmlfE+LB7qBteoopMZVqmF/nHK+lyu6kBkDft0rtg6kHrw+dnzzhYEprLWqni8scBaue+q/omS5LqTUUuQNcL2fsrokwfmDHofLGn3V3xbOHeS62BxC24YSaISyE2yKVSBVFfTjl2Ij59zg+2Lodyi6SfUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N1VQR3/s; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e036d1ce4f7so1243581276.0;
        Thu, 11 Jul 2024 16:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720739247; x=1721344047; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i2hBswY+u8xjK1Kzvor9fB+2gLyEPUsUoItxFLjtkvk=;
        b=N1VQR3/sHgT8Q4fjvFmIc7+JeNQXye92vFyP++/JIcMDdZ/KR6lUA8PKnFaDBKsFKl
         7ixBPJuIx9C5TUO2afp36X+16cLIkQPu8t8UGpkpALnrCeJCrW6zMGdbcKgUrWmPVxpZ
         j5TOhNCqe8zbWHTmm1B1rSwjRr0zDeE90ujMRLnMibzg5F4TvdR5hj4Oainazd1Hp1tm
         a+ILER7dZ0Fks8ey2iMTAbONSuqQcT48aozSBO99R4/rRecbQc+jN0o3GDCl23wCce/M
         usxC10Plsdl/3r8My3CKsbv1X7omNR8uY4uP5R+MJxl2dnvZWj82VzVojWJNOq55lyJT
         r6xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720739247; x=1721344047;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i2hBswY+u8xjK1Kzvor9fB+2gLyEPUsUoItxFLjtkvk=;
        b=O+o5Psk5bDiieFzpuUy/2KygDVCHaHiZE0OEgtUhQ65Bx2RmUm3Vi8DZUOTJD98/3j
         RYCCIue/iYGF9LVuOz0v2pR/a4p5K2C9I1C8paVBmB6AZ/wkJ7EgDi1oveIaCF3FD6rg
         +EX+QiLC90tarQ3sNAPWSaMLoEA30/xJUrFzFMOb6tkKWYCnfEPQiLGoiJfaXsmJ6B8k
         Iy8RA+dDhGY0++hbAxgQmkvionreTR9siniBRIKtgLAclDwmlCJcGKaW3yYZcJ/Qm9Aq
         7cdI/Z8XgL9T2Jgh1+9J5+rlmLs4rc7hQV8XevebUR9laQlZyCtwtZ9y0OxoIWyIIBiX
         lfoA==
X-Forwarded-Encrypted: i=1; AJvYcCX5POVrzQMADd0DEy3gTMBCOrXaDTLj+1ZHxeP2ScriAABYJypIextv8qMIS6vQP0eMchJM63eSnP5ykatpdJ/BI7gN7M+fKhr3nlht1tC9DKTqiGGJTxYW0tcXP5V/PBAtNn+yXL2B+i8bz+CUpHIuRJNeR7gPNQ6VcRDrDeY1uhgtlWFJJEeFS19Q3h/NGYT891oiQHzntrENOYPJ8aXRy//tyB90mKIgyfia
X-Gm-Message-State: AOJu0YwD4lPb+WsZrDzOmESUORbrIBA15Dmho6ZxUsiy+nAoAeMBKv3g
	K/4BMwohxxUkRI8srt+4PO4UG3olyjvVJCUioNF+qOXDV3UMrQ13zcTHWEzjeWMeLAO7mxH85QR
	eoJwwKTHZrwB1pD1XajCppi7jHf0=
X-Google-Smtp-Source: AGHT+IESAzgUImuWHbpxSCeLvNle2lAnCtNiymuxM6do/gswGHb65EvzDJ50dh8SH6D3heE0PgCKfCSwNt2zccYk0iI=
X-Received: by 2002:a25:4ac6:0:b0:e02:becd:d5eb with SMTP id
 3f1490d57ef6-e058a4d4875mr967584276.13.1720739246975; Thu, 11 Jul 2024
 16:07:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710212555.1617795-14-amery.hung@bytedance.com> <AS2P194MB21709F0B79D6FB686D373B199AA52@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
In-Reply-To: <AS2P194MB21709F0B79D6FB686D373B199AA52@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
From: Amery Hung <ameryhung@gmail.com>
Date: Thu, 11 Jul 2024 16:07:15 -0700
Message-ID: <CAMB2axMyA2TDZmXaO_BaFHk4Lh3Ri1LgEc7UU7ZoNsBsqANivQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v6 13/14] virtio/vsock: implement datagram support
To: Luigi Leonardi <luigi.leonardi@outlook.com>
Cc: Bobby Eshleman <bobby.eshleman@bytedance.com>, amery.hung@bytedance.com, 
	bpf@vger.kernel.org, bryantan@vmware.com, dan.carpenter@linaro.org, 
	davem@davemloft.net, decui@microsoft.com, edumazet@google.com, 
	haiyangz@microsoft.com, jasowang@redhat.com, jiang.wang@bytedance.com, 
	kuba@kernel.org, kvm@vger.kernel.org, kys@microsoft.com, 
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com, 
	netdev@vger.kernel.org, oxffffaa@gmail.com, pabeni@redhat.com, 
	pv-drivers@vmware.com, sgarzare@redhat.com, simon.horman@corigine.com, 
	stefanha@redhat.com, vdasa@vmware.com, 
	virtualization@lists.linux-foundation.org, wei.liu@kernel.org, 
	xiyou.wangcong@gmail.com, xuanzhuo@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 11, 2024 at 4:03=E2=80=AFPM Luigi Leonardi
<luigi.leonardi@outlook.com> wrote:
>
> Hi Bobby, Amery
>
> Thank you for working on this!
>
> > This commit implements datagram support with a new version of
> > ->dgram_allow().
>
> Commit messages should be imperative "This commit implements X" -> "Imple=
ments X".
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html#de=
scribe-your-changes
> This suggestion applies to many of the commits in this series.

Thanks for pointing this out. I will change the commit message in the
next version.

>
> > +static bool virtio_transport_dgram_allow(u32 cid, u32 port)
> > +{
> > +     struct virtio_vsock *vsock;
> > +     bool dgram_allow;
> > +
> > +     dgram_allow =3D false;
>
> I think you can initialize the variable in the declaration.

Got it.

Thanks,
Amery

>
> > +     rcu_read_lock();
> > +     vsock =3D rcu_dereference(the_virtio_vsock);
> > +     if (vsock)
> > +             dgram_allow =3D vsock->dgram_allow;
> > +     rcu_read_unlock();
> > +
> > +     return dgram_allow;
> > +}
> > +
>
> The rest LGTM.
>
> Thanks,
> Luigi

