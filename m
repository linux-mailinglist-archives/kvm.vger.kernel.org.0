Return-Path: <kvm+bounces-68206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A5217D26A04
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:41:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A39BF305AD28
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 408873D411F;
	Thu, 15 Jan 2026 17:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FjzTd3z4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D901C3C0090
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 17:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498184; cv=none; b=n9CWXwuI2AA5ZLrOUGPHn/VNVQ24UKPdlAkQP1/olFT5ZezisGfYzy+7AEWux3kb8znYw3M5xSZ4WbxNPUnDBklORyGcPEZGSviQBMk7Is7USAJ2BA1rjkO68ju1ESjHXpf1P2V8vXSp9Lz+wEMku/eeZqtj2Joij2pfhDKYDEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498184; c=relaxed/simple;
	bh=MA28bjpdROGLBGyWpjAe2cE36NptQV21lD6fviztOIU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hlBvXKIDsvK/Dy46gydCWkof1X0ZfLqZ+Q5trbh5i8D8zFjZEEUgGL+128EwM1Ob3sE9WCqURuJALhx+f7epoTBTQSfiIgONDx4sEfCky46IytgJ37NkVon/4H17DIv/DUBFSwgfKqKJkyh7DH+mhd3bOk6Os/tgbanJo6YwET8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FjzTd3z4; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-81f48cec0ccso990392b3a.0
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 09:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768498182; x=1769102982; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0RdgWmeOIRqyt3CX1pAJn26pk8EuG6NaH6VeuOJiiKo=;
        b=FjzTd3z48lhDCxBAiHd2O8kc97F0shVlswe96T5nxkUZg8aGsXmCIq5dszBkMFTuPz
         iDkDVeTOr1ltTV5s8uxO3MTTNU8CGQrt5KROGIO3BxSRDha1AwEg9BsdYHFCgQ9J3S65
         2UOsw6XcCxoPEtXU98qslhgYfmhNdFriD+/TQMqUjSCsK8TvmHG16S//1cUPiYpBChyc
         bLc7FsuAhzGsibu2iXAy6FgC8QUWYdwhCawtqZs6vrGzdqxAQsAbFxXIU1IB6seAE4ZR
         +Jy0E9PBOueLqekxgRrXhgBYHfdRIDSvnqrfu9VlVt1yTcMg2aKdLGuftNMFMXdIDxos
         31sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768498182; x=1769102982;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0RdgWmeOIRqyt3CX1pAJn26pk8EuG6NaH6VeuOJiiKo=;
        b=orGVLB/k69mk9q2CbWw70tWbjXtxDKgbGhtUzeStK5m1rp/7HDZhl7L00ujnd1uKYA
         Feue8nUCRW0Y6BQ+mAwsJnVE1oaXQlEvYWTR67RPAxF9OYa/xtSBKpb1wn2WsPvPixzn
         Ttn1VaRK2cOd4Yna99jCIIa3E+lUyK7phQm0ARZvhxgZ1/o+fqTTHdtxBaibAkr7oXma
         UnHh+81m1NdkkkVp2EH964aqn2bmwx055QRc5wZ/8KhSPQ9BVBQZ84MLgcltuAuLRVy5
         s+zKzTb4ZNQDT7n+VxE7xiujkRQDCJGdJhm/o44VVco7jSyO2U7QuHx7NNFHs/KpFLpp
         jPnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKNVrCi2+LynwsmNPZaI4VvWIOP4BJXeCC80+O4a1t8Z87zYBU20S4s+Ii7Nr6BKHyZys=@vger.kernel.org
X-Gm-Message-State: AOJu0YxX77Wd9EC/kSpkq49XSlschJTHLFufAgYbK45C5lqg4+cMi1N2
	WTqpbyKPxAoAHquXyY8OvvGVm+YZo1ExlYmHQf6PdIKRW1+eeGDM7Zm4kXkS9noci2JBL9LADvF
	gQ+NjYg==
X-Received: from pfbln22.prod.google.com ([2002:a05:6a00:3cd6:b0:7a5:20e6:4185])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3d0d:b0:81f:4164:79b0
 with SMTP id d2e1a72fcca58-81f9f6d5262mr297714b3a.31.1768498182045; Thu, 15
 Jan 2026 09:29:42 -0800 (PST)
Date: Thu, 15 Jan 2026 09:29:40 -0800
In-Reply-To: <ugrjf3qqpeqafg6tnavw6p4l5seapl6mfx6ypypka25shvu6by@pq4qpwn24dyi>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260112174535.3132800-1-chengkev@google.com> <20260112174535.3132800-2-chengkev@google.com>
 <jmacawbcdorwi2y5ulh2l2mdpeulx5sj7qvjehvnhaa5cgdcs3@2tljlprwtl27>
 <aWhFQcNa8SKd679a@google.com> <xndoethnkd2djh5zkemvgmuj6gc4hsnxur2uo5frl57ugxa2ql@c3k7cadxmr4u>
 <aWkdF8gz1IDssQOd@google.com> <ugrjf3qqpeqafg6tnavw6p4l5seapl6mfx6ypypka25shvu6by@pq4qpwn24dyi>
Message-ID: <aWkkBPH3IWn40rVN@google.com>
Subject: Re: [PATCH V2 1/5] KVM: SVM: Move STGI and CLGI intercept handling
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Kevin Cheng <chengkev@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 15, 2026, Yosry Ahmed wrote:
> On Thu, Jan 15, 2026 at 09:00:07AM -0800, Sean Christopherson wrote:
> > On Thu, Jan 15, 2026, Yosry Ahmed wrote:
> > > Or maybe it's clearer if we just put the checks in a helper like
> > > svm_waiting_for_gif() or svm_pending_gif_interrupt().
> > 
> > This was my first idea as well, though I would name it svm_has_pending_gif_event()
> > to better align with kvm_vcpu_has_events().
> 
> svm_has_pending_gif_event() sounds good.
> 
> > 
> > I suggested a single helper because I don't love that how to react to the pending
> > event is duplicated.  But I definitely don't object to open coding the request if
> > the consensus is that it's more readable overall.
> 
> A single helper is nice, but I can't think of a name that would read
> well. My first instinct is svm_check_pending_gif_event(), but we are not
> really checking the event as much as requesting for it to be checked.

Ya, that's the same problem I'm having.  I can't even come up with an absurdly
verbose name to describe the behavior.

> We can do svm_request_gif_event(), perhaps? Not sure if that's better or
> worse than svm_has_pending_gif_event().

Definitely worse in my opinion.  My entire motivation for a single helper would
be to avoid bleeding implementation details (use of KVM_REQ_EVENT) to trigger
the potential re-evaluation STGI/CLGI intercepts.  And then there's the fact that
in most cases, there probably isn't a pending event, i.e. not request will be
made.

Let's just go with svm_has_pending_gif_event().

