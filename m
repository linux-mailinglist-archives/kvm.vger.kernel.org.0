Return-Path: <kvm+bounces-27301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5815797EB31
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 14:02:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E8281F220E0
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 12:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3793195FEF;
	Mon, 23 Sep 2024 12:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xwM3n/Ww"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F1B944E
	for <kvm@vger.kernel.org>; Mon, 23 Sep 2024 12:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727092957; cv=none; b=Tif0tEuYjpZiDMCMrNu541XhBN1Y+5uVizZBBdkI0KNuTbIf8DAmfcTHL1isHtTHFiSB0xAjZIY+xyvj3In7ZwWUeGIopLMa7zEE1ikXYxvudWMf8gDlwM5o5xYa0vtzCFbYsjdp5wRoZKoJVpIDEqHWvG0l9W3SBORKc/HxNdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727092957; c=relaxed/simple;
	bh=IvZUnWEEwtJBrX0C0B8heXZmuNKkdtrz+/xYCRUqA8o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aHkwzaG/kPAbVKQJnSk7XppU1HJ2wca/h2FLiSoyawXFtQPFjBEg4k/LB8OFfXmZyCSas44obuCWf6646RIBXB44I7p2XpRzVf6zK3zgB07DQXJTnm1vtT5InGSaZvDqjKSoHJekxSyiNlE7SwALqv1rOz3peX0t166aTDaIf0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xwM3n/Ww; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2056364914eso37092335ad.3
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2024 05:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727092955; x=1727697755; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GFr6vxdUJL3MJwqVUaF07T8lI8KCh6OBnGa3LNPrPOg=;
        b=xwM3n/WwG2vd7Z4p91w5XZ6x97LQaR31QqLG2lAfMjccgifY/KceQC75M8ESkkdbKh
         szTJK+tPuh00GM/2xCJg1qekjruw9yekBSoRPWA8L9UtGT+kMKLVxG8vjqq9RjpyXvpy
         3IsEUO+BQ1qHWHm2AQO7mblXin6Ml8pEIabP0JwPjPSgjkp+Yf+t9CDYQ9mEZ9f77ONd
         I0xSAVboTBFXXI0gotR0hhxvZMw8KSeaHG+qq75s9pTaTjtBT3z+KlEsT388fpZGKgqy
         5jOsa0TEhVqsoOlP9vLsHflCfvt7i7yLAL284QQ1DwhhPw8r0kEpt8pwvY2uNgQ3d8YL
         g2VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727092955; x=1727697755;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GFr6vxdUJL3MJwqVUaF07T8lI8KCh6OBnGa3LNPrPOg=;
        b=q/JAt5I7+nPWGxd8uJ1ou0HOwhOl7A6cJOgYtl9AsSctDj6GdW9CmkeJzUwQx2Vu0H
         hFN0/tdWm+DnN70zBi1gQ4KubY/vdwYQHBDYMd+qIxu2xtKsT8mVp1+GqKSqA6lJtGPf
         YtBZqcN9ln5jbpiD+kbQ1hpkeXUVLPfn9MZcb5IagzP8VCZ+647I9sYDIeak26ZRULud
         uGhHeio03xK4OzKv+5QTHPY1zTg6S85vKhiO+onQ/v9shfRd+rFNlVdzgItlS0qErSSX
         UwRVBpDvzkQsiQGbGYgScwJimxRZcPOeLvIqQoE2je7W4cxdTMisGeDCwCAGquzMwZp+
         WltA==
X-Gm-Message-State: AOJu0Yy1X9+clkxneJopg6IrMdFBMrM65fMhwszgUtQEOf0g5W1kyQpZ
	bRY5jH+WlLfictvQgJ0F+ad/ZBDoo2GH78LUwVy/atendd6+E+zANWAXfLHOwokYjbeYrfJIaXZ
	OTQ==
X-Google-Smtp-Source: AGHT+IEzIfiOWVAmnllUJ4P4EA/eChnQTcqs5HjwigF762cm3txY3x/6niburLV6pAX5GE7eUr1i6RUXpp4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec8c:b0:205:79b7:b36e with SMTP id
 d9443c01a7336-208d96f5defmr357005ad.0.1727092954784; Mon, 23 Sep 2024
 05:02:34 -0700 (PDT)
Date: Mon, 23 Sep 2024 04:46:30 -0700
In-Reply-To: <0288f7f5-4ae8-4097-b00c-f1b747f80183@yandex-team.ru>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240917112028.278005-1-den-plotnikov@yandex-team.ru>
 <Zu_Pl4QiBsA_yK1g@google.com> <0288f7f5-4ae8-4097-b00c-f1b747f80183@yandex-team.ru>
Message-ID: <ZvFVFulBrzHqj2SE@google.com>
Subject: Re: [PATCH] kvm/debugfs: add file to get vcpu steal time statistics
From: Sean Christopherson <seanjc@google.com>
To: Denis Plotnikov <den-plotnikov@yandex-team.ru>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, yc-core@yandex-team.ru, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 23, 2024, Denis Plotnikov wrote:
> On 9/22/24 11:04, Sean Christopherson wrote:
> > On Tue, Sep 17, 2024, Denis Plotnikov wrote:
> > > It's helpful to know whether some other host activity affects a virtual
> > > machine to estimate virtual machine quality of sevice.
> > > The fact of virtual machine affection from the host side can be obtained
> > > by reading "preemption_reported" counter via kvm entries of sysfs, but
> > > the exact vcpu waiting time isn't reported to the host.
> > > This patch adds this reporting.
> > > 
> > > Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
> > > ---
> > >   arch/x86/include/asm/kvm_host.h |  1 +
> > >   arch/x86/kvm/debugfs.c          | 17 +++++++++++++++++
> > 
> > Using debugfs is undesirable, as it's (a) not ABI and (b) not guaranteed to be
> > present as KVM (correctly) ignores debugfs setup errors.
> > 
> > Using debugfs is also unnecessary.  The total steal time is available in guest
> > memory, and by definition that memory is shared with the host.  To query total
> > steal time from userspace, use MSR filtering to trap writes (and reflect writes
> > back into KVM) so that the GPA of the steal time structure is known, and then
> > simply read the actual steal time from guest memory as needed.
> Thanks for the reply!
> Just to clarify, by reading the actual steal time from guest memory do you
> mean by using some kind of new vcpu ioctl?

No, I mean by using the host userspace VMA to read the memory.

