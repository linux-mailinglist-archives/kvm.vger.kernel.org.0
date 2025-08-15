Return-Path: <kvm+bounces-54781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B1C8B27EA0
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 12:47:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E771C622F6C
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 10:45:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 323F33002C8;
	Fri, 15 Aug 2025 10:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D3RvSpFi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1BE2FF16D
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 10:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755254697; cv=none; b=ojqPfX5qVWIE5dILcEtdI8M5BUZSIQGf1q0V6e55lwGSO/rldyRdQjXPEmhS8dMWtC1YolBc6RZwC55wlGWR1Y1b7MB8uESV5APYOyLGdMTtqDjaIAF5QJ9eMSHK6ppL6YL0CCWNMOKsSPwm0Bq71LT63rwr4LOafu9McrT825I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755254697; c=relaxed/simple;
	bh=WjR/rbwNJc0Qp2k2aQAdE2Gr22tCrag3f7ATcKE39Uc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ueFpxfB6nu5BNENIzo7Q0MtvLZp44H+Sc1Iw+csW+qOnFRvcAcPCYQxTztDS5iIUB5wXMwFxzJqV734Yg1LGk+bx4PeZTdAxuYlVnzVqbRP+Hxd00dDlTcimG94qaokryALrvY2DkMV9FA7QcqUPvnThaFUD9nS7FMyjxO1u0+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D3RvSpFi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755254694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V5GOAcmmdxLGbEbM9B2YGjZnwu9h8dtTUkFqo/i0QYA=;
	b=D3RvSpFiPsa2FmJK2sfh5ZvZRlyGaew1zKj73nGe2fS1qiPQzYiRg6FIyd+aDiwS8hK6w3
	T+IKNXAPb2MbEv8ZMbejg1gflqnjIqvne/zCNWDPoZJPOmc8w+0Zj099Z98PcHgTFBq/d5
	HHK87JjrXRJ6v00iqcOmSPMpfmJ6b9Q=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-KxvZ1i8aNyicUvDI3i05iA-1; Fri, 15 Aug 2025 06:44:53 -0400
X-MC-Unique: KxvZ1i8aNyicUvDI3i05iA-1
X-Mimecast-MFC-AGG-ID: KxvZ1i8aNyicUvDI3i05iA_1755254692
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b9e41037e6so847665f8f.1
        for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 03:44:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755254692; x=1755859492;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V5GOAcmmdxLGbEbM9B2YGjZnwu9h8dtTUkFqo/i0QYA=;
        b=UiCczzI5YT0CId9GDx6eb/D0ZrH9ydnlfNH1McRXz2xRUS3LOHHk5dPCc/87DCuIb6
         wrgR8sYAkko3lkVJ8szN8uyoY0InQU/jYNsdl8AoW32NmaUfGSYlglksO2uQHrEfEBbj
         Nqqo0B+fS5st+KyjwSyAuxJTBU1iUnFZ6ZmF8YQ8VZ5R+5yaVjaRqp7IaoljREsJ7d3o
         cAPhQwdPAX+GZTlBZS5sr8xeVqGHGjVS6+RxTV9yL0kiSO2wuPNsLxTYcEisBIS3OkWH
         IUo9NYL5/aV8edo7LfNG6zwq3pO9OXov/F4sDuTcmo7DhaQzIuBYCFF7bCZ1K6yKH3qF
         4NNA==
X-Forwarded-Encrypted: i=1; AJvYcCVOf3lH51i5QNslQCSy6e9goiDINdAfzhoOJRpD7lm90fpp7NufCyRCkjlzmCSgqkCZh1Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlTJl2c/+DPtkKaks8tw9K3l6k+iJ7M3al6fTN1dult3I4vCO0
	39UVOjwGaLWAW0fKbL8fyinIxy33cie6LxRMRG4cvp3wHpVu+yG7X2M0BBZrW3dQjTxyH1k02Yy
	aXEY0mjyFp3UEyTezkqbxpAkYe4Q8afY0gfoWAnPKEb1L71UNRyH+nA==
X-Gm-Gg: ASbGnctnn6FHBAR7esQ1L62dKcg6yIIX9zLl+uuWOMTVx0ZErz+BrihQYUDYA3FABtM
	o99Yov6sR/IBVyvcT+w1I/UOmhozrAL9nY6H54f1feY2KRcDfWQ6bxJKvpJgT/RkzAHbWxgjaBy
	9lmdaaSyZQnI3lMHvWVV/QdzYFQEl5X8IA3VbDck5wJA7u+Rqn0AdC23xhYCCZV7QoihwUFhzhD
	zyjNfqX5s5CzDD567HW6VXSmIR6Lwam120rA0Ru1MbKaIcsXoMXivs0fxw+FZSWpcJE2IraVXMn
	92+DeINESMlwS9x0B+e0zDYioV7wbRA6knI=
X-Received: by 2002:a05:6000:1a8d:b0:3b7:9d83:50ef with SMTP id ffacd0b85a97d-3bb694af396mr1111608f8f.55.1755254691697;
        Fri, 15 Aug 2025 03:44:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjxJ9VfnonVDFqga9qmU4sokEZCEtKZYfi4E6SPLLakFaeJSs6iOf6aXLBGPZEAaqLwiSlKQ==
X-Received: by 2002:a05:6000:1a8d:b0:3b7:9d83:50ef with SMTP id ffacd0b85a97d-3bb694af396mr1111588f8f.55.1755254691299;
        Fri, 15 Aug 2025 03:44:51 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73cf:b700:6c5c:d9e7:553f:9f71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9936sm1456218f8f.38.2025.08.15.03.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 03:44:50 -0700 (PDT)
Date: Fri, 15 Aug 2025 06:44:47 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Will Deacon <will@kernel.org>
Cc: syzbot <syzbot+b4d960daf7a3c7c2b7b1@syzkaller.appspotmail.com>,
	davem@davemloft.net, edumazet@google.com, eperezma@redhat.com,
	horms@kernel.org, jasowang@redhat.com, kuba@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, pabeni@redhat.com, sgarzare@redhat.com,
	stefanha@redhat.com, syzkaller-bugs@googlegroups.com,
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com
Subject: Re: [syzbot] [kvm?] [net?] [virt?] WARNING in
 virtio_transport_send_pkt_info
Message-ID: <20250815063140-mutt-send-email-mst@kernel.org>
References: <20250812052645-mutt-send-email-mst@kernel.org>
 <689b1156.050a0220.7f033.011c.GAE@google.com>
 <20250812061425-mutt-send-email-mst@kernel.org>
 <aJ8HVCbE-fIoS1U4@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJ8HVCbE-fIoS1U4@willie-the-truck>

On Fri, Aug 15, 2025 at 11:09:24AM +0100, Will Deacon wrote:
> On Tue, Aug 12, 2025 at 06:15:46AM -0400, Michael S. Tsirkin wrote:
> > On Tue, Aug 12, 2025 at 03:03:02AM -0700, syzbot wrote:
> > > Hello,
> > > 
> > > syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> > > WARNING in virtio_transport_send_pkt_info
> > 
> > OK so the issue triggers on
> > commit 6693731487a8145a9b039bc983d77edc47693855
> > Author: Will Deacon <will@kernel.org>
> > Date:   Thu Jul 17 10:01:16 2025 +0100
> > 
> >     vsock/virtio: Allocate nonlinear SKBs for handling large transmit buffers
> >     
> > 
> > but does not trigger on:
> > 
> > commit 8ca76151d2c8219edea82f1925a2a25907ff6a9d
> > Author: Will Deacon <will@kernel.org>
> > Date:   Thu Jul 17 10:01:15 2025 +0100
> > 
> >     vsock/virtio: Rename virtio_vsock_skb_rx_put()
> >     
> > 
> > 
> > Will, I suspect your patch merely uncovers a latent bug
> > in zero copy handling elsewhere.
> > Want to take a look?
> 
> Sorry for the delay, I was debugging something else!
> 
> I see Hillf already tried some stuff in the other thread, but I can take
> a look as well.
> 
> Will

I will be frank I don't understand how that patch makes sense though.

-- 
MST


