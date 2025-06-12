Return-Path: <kvm+bounces-49249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C67F5AD6B3B
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 10:45:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61F263A295C
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 08:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FF6D22172E;
	Thu, 12 Jun 2025 08:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EM6ptQYw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494F322126E
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 08:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749717890; cv=none; b=QjBi7nLKBAdd2XosfhGMairbXNEUuh3WibjilgrfaQ0beseBYD7ZrOeTfCL+XbCP6aBsRAycGgh87wWU0vbLugI3SCUaLAmMQW47tWsnUC7a5Mv0DSzgRBO+wfuCF17aGJNgANp2aYpI+VxLnq++9Bf/8X9GF0U6GkQ81eKxWms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749717890; c=relaxed/simple;
	bh=rNTbSvQjmtm36dJjYb+8KYjVtBDjiIzJsQLY4I9jU7k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ETdU/nBgHEMOysdtUm6uLZrn/78wqJAfhORoTDOk14jFT8Dw6rrxa9mbppVPd3E6nQ4RjaD7MAHKkIRfQmAEzkWXqK0ighhsCykksO1XNru++agy8SHIqgrb4VlWA63IeRFz1ngtLLCRJXEFW8VoZ5uoN43Ti7o2wXQm1mUS+6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EM6ptQYw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749717888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rNTbSvQjmtm36dJjYb+8KYjVtBDjiIzJsQLY4I9jU7k=;
	b=EM6ptQYwg4gUF//fntFrYJGlMRGSVRTXYCgZhe/tcCyYS+1jSOSpZKfYRklSOXLplibMkm
	syC6NF+z4iV24E9zq0sHRBalOWSnm5Kdy3ObhQqEOcREnc+YPjQ0fxT/F9Wnb99CZgaYLS
	7BJ7/qnakzp5WVHcexGsfbtTN0Wh0Jc=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-BD-FfYluM4uETSuC6dv4jg-1; Thu, 12 Jun 2025 04:44:45 -0400
X-MC-Unique: BD-FfYluM4uETSuC6dv4jg-1
X-Mimecast-MFC-AGG-ID: BD-FfYluM4uETSuC6dv4jg_1749717885
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-e81733e4701so1088511276.0
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 01:44:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749717885; x=1750322685;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rNTbSvQjmtm36dJjYb+8KYjVtBDjiIzJsQLY4I9jU7k=;
        b=MhplvREgJaqx4tK1qKbJe21huz5sb5UFj3i6b8IzuqKDSJ4iSBBGwzyQ5c80bQPF5u
         r4n6GYq6+lxWJNpWdcch8sPOr+m0IWGJvycJd5khN83rSWw+spSqfV81aqz2x6lGBZsF
         9m/YQTUa41+n6kjQCtbHwd6hHVBIigCg7MfP15Mk8u5pvEGl4lPAh1GKtjqB1yUR6s54
         is2oFxVsePxZaKb3hXr639bkhr4jSOkVkPYfQtQQN3QIM+Fru6kFYi/xWSm0lZIPqYvh
         uM1vLNUQEVtRiIuyNt69zueJ8PWRBXLwcmu9n8Gd7Efo71/G7WGT53ChwxapMdhfE1bT
         z+uA==
X-Forwarded-Encrypted: i=1; AJvYcCWSjhJP9Xq7R+ZZNivwDtdrVxk6DNDDOnpGrzsLBlBOAnpMfyVeNW6skeDIJomalaKDZy8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiAqsSkYNWS6fJdsuZLEwGG6dBj856FwgXBMb/IjVAQuxNIxaj
	vJmF1Pl90dB/ufM3v+ILLYJ0vqEr+eIc+KhydnG4NCg0FnyQ12OYm2Sywm0sgAccDkdVdNu6bNh
	vL82cdWBVHXQJiqaQ4XGcOiEqDR4Ast6vpdy0FEJ8PMuWmszgv2Tw/rNBAjYMiflLSG6hHUKDZ1
	0EAkHwNt2xiNhiQGZHecYjje2Zabx8
X-Gm-Gg: ASbGncsA5otxz0OPUpym0McN4aVGMMLoC0Q1xUJIiOLjUEzSqSuzdG5fGJOHc9+R8oj
	sOLWltwNF8VDAnKLd5esCAWSh0/2AkKg1c1ISFO2sFnjclVkhOE7udX71bS8HQYEsQ60oM2Sa87
	AgnQMW
X-Received: by 2002:a05:6902:2611:b0:e81:4e9d:9e79 with SMTP id 3f1490d57ef6-e81fe6b8b7amr9216266276.40.1749717885011;
        Thu, 12 Jun 2025 01:44:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHpO7imw7/y6hUBA3+X+9+644bvWl/2xN24NgD0/xASJ+Z1iQt0UZZ7qIi1/vJ8aGKQCfn0PwMZVX01PvmLRPE=
X-Received: by 2002:a05:6902:2611:b0:e81:4e9d:9e79 with SMTP id
 3f1490d57ef6-e81fe6b8b7amr9216251276.40.1749717884673; Thu, 12 Jun 2025
 01:44:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGxU2F6c7=M-jbBRXkU-iUfzNbUYAr9QApDvRVOAU6Q0zDsFGQ@mail.gmail.com>
 <20250612082102.995225-1-niuxuewei.nxw@antgroup.com>
In-Reply-To: <20250612082102.995225-1-niuxuewei.nxw@antgroup.com>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Thu, 12 Jun 2025 10:44:33 +0200
X-Gm-Features: AX0GCFs5PNoVhHhHZsKNXS6ADWJpjexmyZKqj4oyHShXjy9f_WC9YKjQLjFGOUk
Message-ID: <CAGxU2F4JkO8zxDZg8nTYmCsg9DaaH58o5L+TBzZxo+3TnXbA9Q@mail.gmail.com>
Subject: Re: [PATCH net] vsock/virtio: fix `rx_bytes` accounting for stream sockets
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: Oxffffaa@gmail.com, avkrasnov@salutedevices.com, davem@davemloft.net, 
	edumazet@google.com, eperezma@redhat.com, horms@kernel.org, 
	jasowang@redhat.com, kuba@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org, 
	niuxuewei.nxw@antgroup.com, pabeni@redhat.com, stefanha@redhat.com, 
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Jun 2025 at 10:21, Xuewei Niu <niuxuewei97@gmail.com> wrote:
>
> > On Thu, 12 Jun 2025 at 08:50, Xuewei Niu <niuxuewei97@gmail.com> wrote:
> > >
> > > > On Thu, Jun 12, 2025 at 01:32:01PM +0800, Xuewei Niu wrote:
> > > > > No comments since last month.
> > > > >
> > > > > The patch [1], which adds SIOCINQ ioctl support for vsock, depends on this
> > > > > patch. Could I get more eyes on this one?
> > > > >
> > > > > [1]: https://lore.kernel.org/lkml/bbn4lvdwh42m2zvi3rdyws66y5ulew32rchtz3kxirqlllkr63@7toa4tcepax3/#t
> > > > >
> > > > > Thanks,
> > > > > Xuewei
> > > >
> > > > it's been in net for two weeks now, no?
> > >
> > > Umm sorry, I didn't check the date carefully, because there are several
> > > ongoing patches. Next time I'll check it carefully. Sorry again.
> > >
> > > It looks like no one is paying attention to this patch. I am requesting
> > > someone interested in vsock to review this. I'd appreciate that!
> >
> > Which patch do you mean?
> >
> > Thanks,
> > Stefano
>
> I am saying your patch, "vsock/virtio: fix `rx_bytes` accounting for stream
> sockets".
>
> Once this gets merged, I will send a new version of my patch to support
> SIOCINQ ioctl. Thus, I can reuse `rx_bytes` to count unread bytes, as we
> discussed.

As Michael pointed out, it was merged several weeks ago in net tree,
see https://lore.kernel.org/netdev/174827942876.985160.7017354014266756923.git-patchwork-notify@kernel.org/
And it also landed in Linus tree:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=45ca7e9f0730ae36fc610e675b990e9cc9ca0714

So, I think you can go head with your patch, right?

Please remember to target net-next, since it will be a new feature IIRC.

Thanks,
Stefano


