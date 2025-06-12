Return-Path: <kvm+bounces-49251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B9C4AD6C37
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 11:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAF80189BE2E
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 09:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C073322B8A1;
	Thu, 12 Jun 2025 09:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BtA1Y01P"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7135D223707
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 09:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749720625; cv=none; b=UE3ksmbAAT+esmUbrNtNTHJ5yuzPz+Aa3P0RM30EMU1Qd8w7s9863wBOGLv+q10n71NmX1t2x87ZsMBUCewo52cQAJhIuk02x1BdcK4DXVnjXkPVv6JUfP93mpk4tRwkVkyq4wg5vUZdU3L6r/7QKDXNT9OHKCZa2Xwwkz2VRxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749720625; c=relaxed/simple;
	bh=4ygq9Ksz0EzPSaZG9OKYAVE1YdwDPmeAsjiGh8gvFqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gys8p6qSkZ73Qpr6Q7VrPsVED6854Eu8vMsuo2Mna/rBdV4M+/ad6qfiTfLudREBEftj8NhJ8JNC9kAHG7Fg7hI4eU0yqMC73t4rE2QaH5Shpl5pfhzCGcyTCOTMmcWeVEirkowdmDovuztdpUp+kCwKjjPs8bepkljHioAG4IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BtA1Y01P; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749720622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4ygq9Ksz0EzPSaZG9OKYAVE1YdwDPmeAsjiGh8gvFqo=;
	b=BtA1Y01PE7MeB1UAU535WWh6fBVD13Ahwyi3/LS1WyNb/oV6F4wj/fNNTl6QDt21JDuSDn
	JcoXsFbPZLAHCcPAHbb//4iA1KZexgQ4BcDSzKkTCsJn5GcGrsXK0u2+VCDr7rqnFvT/lk
	eSEctaAdvOURFXisq3WzzJyz0xrZdmg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-DZWkvN_mP9mrE_JGOQnPyQ-1; Thu, 12 Jun 2025 05:30:21 -0400
X-MC-Unique: DZWkvN_mP9mrE_JGOQnPyQ-1
X-Mimecast-MFC-AGG-ID: DZWkvN_mP9mrE_JGOQnPyQ_1749720620
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-addcea380fcso51757666b.0
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 02:30:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749720620; x=1750325420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ygq9Ksz0EzPSaZG9OKYAVE1YdwDPmeAsjiGh8gvFqo=;
        b=aV8mV5VdF9e+zkrU2uV1ewWcIfETu+GE76uYvOw7NGBqRVZqs9ew1Ze5uIP2nDiHWo
         gujRSNiDKRdoLUhcLzE0phySNexMNDEbyE/CfRgPzyJCgJNZ9Zh1ku39jVtPLYiAw5gi
         KxY6dLdoENQ+kM8ZvfatxklBamNc7l1h58I9iAVMmLNV7POvjUKV3IKfSohebZbvEglk
         avuWybgDQ27ZqIo1oVMV400VBkaq10dwy4SYOum9UX8b4z9iNRb0qDGysRfhl40DEuba
         nxz5ePgAH/eNkql05FzpikXWnGdssmIsP8tR/Xcp8LXOIu5wFMa0Dd2vxU/VrUTfKxWe
         Pd1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWhCfkiimhUbVUVstoWnq02Tbf2dHieFWOvh46HRVxpvJUdxF7za+SkRssNR/GME3nq+h4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yztibj5riG7GejhoDrb4Sl5+79/idvy9KUgb/icJOEbro+tCaiy
	AlMEva8easAMhT8m1oogV4DTBL4u+3Rzf18j/42zbvLfb/rzwfEa16dwjmtftegQtFWtyOAE6Ih
	3BaVF9t+49S71Jp3XZVS9KJ5FG0K4vACRpUhERpxcZLNvAmKSyDDdMw==
X-Gm-Gg: ASbGncsTUHViGCjvI2VrQwLDdkF5q+HTKRho//LF+rPqHMtofrMFQ2bhb5d11VPx4xg
	wcsB+hGNEmy52BVZ1Q8oUZ79egYPJlTjssPtnnWhY+0tdCPn2/4rXGbdcW80bdo88MpB4Zzb0sf
	5T+E+A0PZrGbtp3FxJzgNUNzv5reoClsIWO22tifxL8+pvZmbG2QASMJZc6+j1Vbw3dXqcd9GNI
	6Yp0gxJo43+0ER6/GUE7cVbS4zfsUgz6Vclo6RN/gkRDQeF3v0ofaAdA4Azg5APZT02tG6i6fPx
	d3oXyR/doDhfDMx8GjUSfvZEFPBT
X-Received: by 2002:a17:907:9404:b0:adb:14f3:234 with SMTP id a640c23a62f3a-adea8d2a7femr202986266b.8.1749720619726;
        Thu, 12 Jun 2025 02:30:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFW/Lug4eBXscrw4Su9HuFYOFwJuHPtuXS+7rbCJ7Q+kF4SSqVkab1vunsa/YWLwUrWOIkfLw==
X-Received: by 2002:a17:907:9404:b0:adb:14f3:234 with SMTP id a640c23a62f3a-adea8d2a7femr202981966b.8.1749720619118;
        Thu, 12 Jun 2025 02:30:19 -0700 (PDT)
Received: from sgarzare-redhat ([2001:67c:1220:8b4:edf4:d580:147e:ea8e])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adead4cde8asm102655966b.7.2025.06.12.02.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 02:30:18 -0700 (PDT)
Date: Thu, 12 Jun 2025 11:30:16 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: Oxffffaa@gmail.com, avkrasnov@salutedevices.com, davem@davemloft.net, 
	edumazet@google.com, eperezma@redhat.com, horms@kernel.org, jasowang@redhat.com, 
	kuba@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mst@redhat.com, netdev@vger.kernel.org, niuxuewei.nxw@antgroup.com, 
	pabeni@redhat.com, stefanha@redhat.com, virtualization@lists.linux.dev, 
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net] vsock/virtio: fix `rx_bytes` accounting for stream
 sockets
Message-ID: <gqwp3mkdx3uaedmxx4kqvhvbgfvp3dtabm5ciejitk4x573oww@ek4agftt56np>
References: <CAGxU2F4JkO8zxDZg8nTYmCsg9DaaH58o5L+TBzZxo+3TnXbA9Q@mail.gmail.com>
 <20250612085514.996837-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250612085514.996837-1-niuxuewei.nxw@antgroup.com>

On Thu, Jun 12, 2025 at 04:55:14PM +0800, Xuewei Niu wrote:
>> On Thu, 12 Jun 2025 at 10:21, Xuewei Niu <niuxuewei97@gmail.com> wrote:
>> >
>> > > On Thu, 12 Jun 2025 at 08:50, Xuewei Niu <niuxuewei97@gmail.com> wrote:
>> > > >
>> > > > > On Thu, Jun 12, 2025 at 01:32:01PM +0800, Xuewei Niu wrote:
>> > > > > > No comments since last month.
>> > > > > >
>> > > > > > The patch [1], which adds SIOCINQ ioctl support for vsock, depends on this
>> > > > > > patch. Could I get more eyes on this one?
>> > > > > >
>> > > > > > [1]: https://lore.kernel.org/lkml/bbn4lvdwh42m2zvi3rdyws66y5ulew32rchtz3kxirqlllkr63@7toa4tcepax3/#t
>> > > > > >
>> > > > > > Thanks,
>> > > > > > Xuewei
>> > > > >
>> > > > > it's been in net for two weeks now, no?
>> > > >
>> > > > Umm sorry, I didn't check the date carefully, because there are several
>> > > > ongoing patches. Next time I'll check it carefully. Sorry again.
>> > > >
>> > > > It looks like no one is paying attention to this patch. I am requesting
>> > > > someone interested in vsock to review this. I'd appreciate that!
>> > >
>> > > Which patch do you mean?
>> > >
>> > > Thanks,
>> > > Stefano
>> >
>> > I am saying your patch, "vsock/virtio: fix `rx_bytes` accounting for stream
>> > sockets".
>> >
>> > Once this gets merged, I will send a new version of my patch to support
>> > SIOCINQ ioctl. Thus, I can reuse `rx_bytes` to count unread bytes, as we
>> > discussed.
>>
>> As Michael pointed out, it was merged several weeks ago in net tree,
>> see https://lore.kernel.org/netdev/174827942876.985160.7017354014266756923.git-patchwork-notify@kernel.org/
>> And it also landed in Linus tree:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=45ca7e9f0730ae36fc610e675b990e9cc9ca0714
>
>I misunderstood Michael's point. I am new to this, and not familiar with
>the process. Sorry about that...

Don't worry ;-)

Hope now it's clear!

Thanks,
Stefano


