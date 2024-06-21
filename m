Return-Path: <kvm+bounces-20223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C383C911FDB
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 11:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00B541C23A4D
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 09:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2064316EC1E;
	Fri, 21 Jun 2024 08:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OIx4zbC2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0127D16E860
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 08:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718960316; cv=none; b=fBdbHkaTJ/m1GUHRiMzDbd4/71+YY5b61vR1C59ND3i4c9CMVFw1coMN4rERyesyhrmKsgwql2Hp7sVAUXU0XJKKFAKHYtJEOWd5do7P2YpkvQb7LQE4d496Z+dZlDCwGvBQehH3Wty70H8mqSoQ/RbSiR03sbKcwvpr64A0BmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718960316; c=relaxed/simple;
	bh=AQ+ID0DA1jK4+ZCMX/FnKYe90YTkB/M3+du/l1LQjXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IQynJhb8TQc/Ji0/Wd45R1tEfwsgPPcY0Uy8LT6Hx3uPo+OV3yQk8Ng3WqRiM4ztsoMtoR0/A9Y+++ChpORFmyjnp1uvacm3KjtSBWpCp3R7uTyuwFc4TB/tY04x/H6BHbRnA57Qw7gyYAXmy6N+psQD9T7ly0yZBiYFFnGKb3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OIx4zbC2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718960312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vutxhf8uxFndqug4g0c9F/LG6YE94IcWu9Cp4ajFWgk=;
	b=OIx4zbC2bWvLdN2TeMbyinzD+lq2XDlmkjztRBs2yNUADqx3TEKg1oSPyUMlr4bb9hltkx
	oCGhtuJ8m+fCzrvmLhiMWxlUPzIuIbhK14u1wTWdUbU8CPhgx90vsPypw5O08sCKUJtxCU
	dBpS6hKx5W7YXunikq6Pqyf5ZUZHZdk=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-EiW3Kk6eO6ynFlKrkmM8Aw-1; Fri, 21 Jun 2024 04:58:31 -0400
X-MC-Unique: EiW3Kk6eO6ynFlKrkmM8Aw-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6b05b8663ccso21774476d6.3
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 01:58:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718960311; x=1719565111;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vutxhf8uxFndqug4g0c9F/LG6YE94IcWu9Cp4ajFWgk=;
        b=nxiyv5Du8dj0VWsQZW/4iUxydlATDH65eJTA60pAnE77vnlg4xf3Z0AAU9kY2NLkZe
         BdBhO20REPXi7cCaAU3nHMYtSbhvnCAcfTGSpqyKxEftEo46GTD1v0HoxndgL/AKkauh
         +CzPYikMHPGWDYAhxrQu3FpxJnfp8nqdxcqpdPeJqSeF+gpeqeMFJrSTnViuhD9NkteB
         tpsFOrUJl2l5b5MaRgHwbLnUz44SVl+T8PSwQgVWqzg/uHr5CjmxJDgbzxD6l2KgKq3K
         zu67GwPWgBXncMUpuSZlUqezxpUZxrkG5RMZDj7yKH3SD4Ao3u2QPfGKpY4DSodhM7zC
         GD5A==
X-Forwarded-Encrypted: i=1; AJvYcCUv8QjAWi8LtHJJ+RrFQ4E76nuir1IDdld3t74MLffd90hK6+Yb+9Yp6b6jxUr7kR5w/JXPWtLkX8/a9U3dgzjQCs0j
X-Gm-Message-State: AOJu0YwX17SoLrjlzkGPPHAROiBFeIqOSeNCVREZ+Dg2uxkaM1AFhpPn
	1neS3cnQoiz1UBzhTQF5aZ/5Mq0jLYoUREGy7wAyuHp9mkcAGJjD/palGE5WJROHzxqEzfztpJL
	8896EW9kFlWzLru+tKCMkvROpv0KYqxZ+HBZh3ocY7xwN0PdNkA==
X-Received: by 2002:a0c:ab1b:0:b0:6b5:1f3f:90da with SMTP id 6a1803df08f44-6b51f3f9210mr13211126d6.44.1718960310823;
        Fri, 21 Jun 2024 01:58:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTOBW5XSMFiCt83nOBHrUcn1ad6WztAjAHMy3DXFKpVAAedgDu30BuOShI9qFs3dk2a9FNnQ==
X-Received: by 2002:a0c:ab1b:0:b0:6b5:1f3f:90da with SMTP id 6a1803df08f44-6b51f3f9210mr13210966d6.44.1718960310213;
        Fri, 21 Jun 2024 01:58:30 -0700 (PDT)
Received: from fedora ([2a01:e0a:257:8c60:80f1:cdf8:48d0:b0a1])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b51ed7269asm6466596d6.62.2024.06.21.01.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 01:58:30 -0700 (PDT)
Date: Fri, 21 Jun 2024 10:58:26 +0200
From: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>
To: Luigi Leonardi <luigi.leonardi@outlook.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	kvm@vger.kernel.org, marco.pinn95@gmail.com, netdev@vger.kernel.org,
	pabeni@redhat.com, sgarzare@redhat.com, stefanha@redhat.com,
	virtualization@lists.linux.dev
Subject: Re: [PATCH net-next 2/2] vsock/virtio: avoid enqueue packets when
 work queue is empty
Message-ID: <ZnVAsjkK11cE2fTI@fedora>
References: <jjewa7jiltjnoauat3nnaeezhtcwi6k4xf5mkllykcqw4gyfgi@glwzqxp5r76q>
 <AS2P194MB2170E2A932679C37B87562539ACE2@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AS2P194MB2170E2A932679C37B87562539ACE2@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>

On Tue, Jun 18, 2024 at 07:05:54PM +0200, Luigi Leonardi wrote:
> Hi Stefano and Matias,
> 
> @Stefano Thanks for your review(s)! I'll send a V2 by the end of the week.
> 
> @Matias
> 
> Thanks for your feedback!
> 
> > I think It would be interesting to know what exactly the test does
> 
> It's relatively easy: I used fio's pingpong mode. This mode is specifically
> for measuring the latency, the way it works is by sending packets,
> in my case, from the host to the guest. and waiting for the other side
> to send them back. The latency I wrote in the commit is the "completion
> latency". The total throughput on my system is around 16 Gb/sec.
> 

Thanks for the explanation!

> > if the test is triggering the improvement
> 
> Yes! I did some additional testing and I can confirm you that during this
> test, the worker queue is never used!
> 

Cool.

> > If I understand correctly, this patch focuses on the
> > case in which the worker queue is empty
> 
> Correct!
> 
> > I think the test can always send packets at a frequency so the worker queue
> > is always empty. but maybe, this is a corner case and most of the time the
> > worker queue is not empty in a non-testing environment.
> 
> I'm not sure about this, but IMHO this optimization is free, there is no
> penalty for using it, in the worst case the system will work as usual.
> In any case, I'm more than happy to do some additional testing, do you have
> anything in mind?
> 
Sure!, this is very a interesting improvement and I am in favor for
that! I was only thinking out loud ;) I asked previous questions
because, in my mind, I was thinking that this improvement would trigger
only for the first bunch of packets, i.e., when the worker queue is
empty so its effect would be seen "only at the beginning of the
transmission" until the worker-queue begins to fill. If I understand
correctly, the worker-queue starts to fill just after the virtqueue is
full, am I right?


Matias


