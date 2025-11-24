Return-Path: <kvm+bounces-64395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BEB4C811C6
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 15:46:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B6E23A6075
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 14:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6122F286D5D;
	Mon, 24 Nov 2025 14:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bi2UGPMz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F1126B942
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 14:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763995528; cv=none; b=JwysDCdFyCiFadHnInU3DEZTktV5AJwm0s8ec7xDHxde8VPppBdL7S+EH5O5bUDcHi5FrogCQQ3lr2luu2XmxiQloJU9LCgEw2PyqrwAfS43kboAivKkdqRL03adZ7pXOC2YqLVNRXooTE3iQ9CISzA+9hLKmXdUZDwvFvBjT3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763995528; c=relaxed/simple;
	bh=Uj44h1HrNeevutUYxz9ybp04EuNUAMx5gjE4N04k2k8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YbIwHXvgsiqRJcsDSriW/X1WnAU8w6USdZOiBitWjC5kBQrN4MK7YLi/KEATRVNyuVz55IleBPL/3P3J4tfHaW8YbHUN2DF64ieTvQpEGLZ9ZBadrn1B6wJUED0d0EQVLNJINprYtxTNVvlzc6A1kSPMHsPZExKwLKDNt31olys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bi2UGPMz; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-341aec498fdso6028093a91.2
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 06:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763995526; x=1764600326; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9fE7+f2OWBnj05HwKN8MoBtaOwH50J/pRBHbgVyU8iw=;
        b=Bi2UGPMzNKPQyosL9nrTyx751Kp+Hyi8A2IZdiE5Npqmz5EOaUOXEq2fEph3vqWt5T
         DGCCia8Ii7+Chir1QHcnC98AJIpuGB9xFUQSFQBq1AtMHIxO9RFkIR0s04b3ep03uewH
         K8/XAc+YPfh0eNgjfZH404OaClALqOtnkVLkS4TPAoVni2nJQOak0qJjcelbOhaavb6q
         E+/ffWD01acFem1HRfUxbTbNaDlP3u1fARgW7FCwpuGDM7xJ8GPRYvESu5O57cusubfH
         an8hebG+oH73STi5e3AK8G3hNSiIvYVcVIaP16iQEMPFH+nCrxB8afxQSeMjiFhUXuY9
         NZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763995526; x=1764600326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9fE7+f2OWBnj05HwKN8MoBtaOwH50J/pRBHbgVyU8iw=;
        b=G5knCDZUAM56upFnqHD9el0vTphBQvoK2cFrPmBMuf64TzKgTGFx22CMRg0n96VnJr
         IrhsG/3FFIzMbmAte8FD3N1eOzowhp+Xdw6hnQ3YmRXVmQCrUn3ZiBuT6D5bmLFNeCqC
         iT6PFQuDL08PWhPbaGfbLp9lq2Bxq2RGvdkTBFeC/5Wu3nXt3grpcctJuXV5ADtw1IfX
         IqSL1gPDwVPp4F2tWdpfPYH9VYwg6xsN4NVIZEAuq2s2rZswEaSjw9Sg5KlyA5uDkN9H
         ncXk+un7XipUVcUBj78wn+Ys6Ithjuuiq0iWruauYSo8PO2zwwPTQKECnbu5HCHwwnG5
         xd2g==
X-Forwarded-Encrypted: i=1; AJvYcCWxh7Wp9f0+55T9561Dqe3ZQWWMnFMxOQdItAMJJ2SU/il009PSrs9yy0Wd9+0bFLSoXgo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOOULk9XoXSNGsNO1WVFDtHiKrp9TafyacIW1XdiTsw06Rp3/y
	gZt+eno7k36DzjYH0FDFH8W70Kczgi3uUluDenlZ37MW9PH6VwISU1GqEzkciVX4Cx4iUKG2gru
	ufMglhQ==
X-Google-Smtp-Source: AGHT+IHC7vs0COC7XQk5p8pgxTdNB88Vgg41x04P+492u7N93D06kfvulbK47vib5dZ65Hy966JYSwOSU/A=
X-Received: from pjup18.prod.google.com ([2002:a17:90a:d312:b0:340:3e18:b5c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d4f:b0:341:c964:126c
 with SMTP id 98e67ed59e1d1-34733f5b790mr10339364a91.34.1763995526293; Mon, 24
 Nov 2025 06:45:26 -0800 (PST)
Date: Mon, 24 Nov 2025 06:45:22 -0800
In-Reply-To: <ycaddg27z4z6xsclzklheriy2cr63v6senv7qxh37kvpb7envs@br7durjgj2ux>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121193204.952988-1-yosry.ahmed@linux.dev>
 <20251121193204.952988-2-yosry.ahmed@linux.dev> <aSDTNDUPyu6LwvhW@google.com> <ycaddg27z4z6xsclzklheriy2cr63v6senv7qxh37kvpb7envs@br7durjgj2ux>
Message-ID: <aSRvguLx26AQB25W@google.com>
Subject: Re: [PATCH 1/3] KVM: x86: Add CR3 to guest debug info
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ken Hofsass <hofsass@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 21, 2025, Yosry Ahmed wrote:
> On Fri, Nov 21, 2025 at 01:01:40PM -0800, Sean Christopherson wrote:
> > On Fri, Nov 21, 2025, Yosry Ahmed wrote:
> > KVM already provides kvm_run.kvm_valid_regs to let userspace grab register state
> > on exit to userspace.  If userspace is debugging, why not simply save all regs on
> > exit?
> > 
> > If the answer is "because it slows down all other exits", then I would much rather
> > give userspace the ability to conditionally save registers based on the exit reason,
> > e.g. something like this (completely untested, no CAP, etc.)
> 
> I like this approach conceptually, but I think it's an overkill for this
> use case tbh. Especially the memory usage, that's 1K per vCPU for the
> bitmap. I know it can be smaller, but probably not small either because
> it will be a problem if we run out of bits.
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 52f6000ab020..452805c1337b 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -494,8 +494,12 @@ struct kvm_run {
> >                 struct kvm_sync_regs regs;
> >                 char padding[SYNC_REGS_SIZE_BYTES];
> >         } s;
> > +
> > +       __u64 kvm_save_regs_on_exit[16];

Heh, check your math.  It's 1024 bits, 128 bytes.  Reserving space for 1024 exits
is likely extreme overkill given that KVM is sitting at 40 exits after ~18 years,
so as you say we could cut that down significantly depending on how willing we are
to risk having to add kvm_save_regs_on_exit2 in the future.

