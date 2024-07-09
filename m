Return-Path: <kvm+bounces-21142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E39E92AD02
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 02:13:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28B391F21FF4
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 00:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30EA41FA1;
	Tue,  9 Jul 2024 00:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XkOl4DHU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17914631
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 00:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720483990; cv=none; b=bEQKSPXBy/dE0/nekQEn5hYBoW0kTASf/ThnnQ9+GGgIlHKoPCjELZ/DHZK1BzETUl8IipBL97FDh8Jm1yJY/oWI8sR+ezjJpRctGklXTmV6E/1fYuKobGXSSvkakAIVPNvVDJ1fmCmd9RcSUvObcLrYrNKJe5cnJerPXuK8lRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720483990; c=relaxed/simple;
	bh=o7s7kP3xWOe9f8MorpJlnvVKDIDiP9CLOJFSGGX5mMY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SXVk6qOWXooYJUzUZmqt0j30T5PKK/NaSscwtDmhC+Cl5WzSGD7Zo2YsHD9jP3mkTvr070bFZISzKGfspOL9mUhYg5yEAZ6HznEc+HsqoptnDnOoYnQxa9YqdcK0fuf1gBi5N+ko/Du8F10MMuZ3zB0mVDT0pMh1EymB/cOkOlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XkOl4DHU; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso3566419a12.0
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 17:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720483988; x=1721088788; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zG6ZMKR2ER5CEkjEXyhneSznu6s7Jkh317FrChhPZ4A=;
        b=XkOl4DHUff0GorZQR3rR+qQ5ufi+8p6DIducAJJnGqltxaF07fG7pbyqyfQbOkAtTO
         XRo4sYj+J0u93tjzlBTvrGskpFiE8yaBFJaKQoEmbJbN4da4e9nAjO0+9MqYLJOqf+nW
         n7/AeR1XhsD05TdhirWCggu8dAsRnlDrnSKqa9w+UCag8DYkLX+EUm3grJGCozS/TiTu
         6JbCxxcoRGTtkxTyaoYPh6mGdji/9X32cP2wXTRWraIipPBH2MI6WzAhNBYmvJYqa/vP
         7cb8orZwvewTmSB0yeRiGn9gFko+X8F/pRIUFnVgYukxJWnKexSob36Ow0GL8zTVvngF
         y0Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720483988; x=1721088788;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zG6ZMKR2ER5CEkjEXyhneSznu6s7Jkh317FrChhPZ4A=;
        b=ioiQgdhH5OhxiUlptyX7BuJeU+5rFwsZKVoIYnq9qZVwXUrQXbZFyg7bCy9Q8XJQpQ
         3FGUB2Z4TZqzR4L00D9MSLHsyzWRaxg8oBCn43LNKbM/N7wa34jDRXY8Bm6EnoI3CCgA
         fXVCvfzoa8XvcAGuXKXZW0FGU5yoqWBstqaPbOPED5nZ1vXnbHIV89AS9qHDTVNutnMq
         4GIIjbkrPpjQGRUpqxKvaW93++ZjfXfLUv+PlUQgmfQiRXykAj7vqy750S1FZE+Ujolj
         RPJvBoBvdx1sedPqnDwiTtf1QY5GCDlnXFmKsiyW3UiS8Gr9kjERwM7rqvNPn/tgzUxL
         /VGA==
X-Forwarded-Encrypted: i=1; AJvYcCU28PEzCopscLEXWbO+M5jxAMcaHFJb8infx9/feCjhTRUMG5YR8WueVZGt2GZf65NBPfrQcLvHKWdPvP+wdObA5WTk
X-Gm-Message-State: AOJu0Yw4Z3+GkIU5jyyUJkdR9JxLaZRi3L3kXebVfYgo6lQTqzuXqvK+
	iIGD88eNXcx1R2E82tsGRC+j+8iFlhJjEmZF7mSj4X7wGLm/reNpSaMWIKHS09cd+r5JKJebY3W
	rEw==
X-Google-Smtp-Source: AGHT+IEFGzOwGtA+dJ46COa5sR263gqpyt4UCMdQAj79zHoXHLuF9ZNvWfUjxPfnnXwwjfAp9CjrFIzSkCo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:502:b0:6f6:1f2c:e339 with SMTP id
 41be03b00d2f7-77e004223b2mr2128a12.2.1720483988282; Mon, 08 Jul 2024 17:13:08
 -0700 (PDT)
Date: Mon, 8 Jul 2024 17:13:06 -0700
In-Reply-To: <960ef7f670c264824fe43b87b8177a84640b8b5d.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-40-seanjc@google.com>
 <960ef7f670c264824fe43b87b8177a84640b8b5d.camel@redhat.com>
Message-ID: <ZoyAkkZjnGmwlVCS@google.com>
Subject: Re: [PATCH v2 39/49] KVM: x86: Extract code for generating per-entry
 emulated CPUID information
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> PS: I spoke with Paolo about the meaning of KVM_GET_EMULATED_CPUID, because
> it is not clear from the documentation what it does, or what it supposed to
> do because qemu doesn't use this IOCTL.
> 
> So this ioctl is meant to return a static list of CPU features which *can* be
> emulated by KVM, if the cpu doesn't support them, but there is a cost to it,
> so they should not be enabled by default.
> 
> This means that if you run 'qemu -cpu host', these features (like rdpid) will
> only be enabled if supported by the host cpu, however if you explicitly ask
> qemu for such a feature, like 'qemu -cpu host,+rdpid', qemu should not warn
> if the feature is not supported on host cpu but can be emulated (because kvm
> can emulate the feature, which is stated by KVM_GET_EMULATED_CPUID ioctl).
> 
> Qemu currently doesn't support this but the support can be added.
> 
> So I think that the two ioctls should be redefined as such:
> 
> KVM_GET_SUPPORTED_CPUID - returns all CPU features that are supported by KVM,
> supported by host hardware, or that KVM can efficiently emulate.
> 
> 
> KVM_GET_EMULATED_CPUID - returns all CPU features that KVM *can* emulate if
> the host cpu lacks support, but emulation is not efficient and thus these
> features should be used with care when not supported by the host (e.g only
> when the user explicitly asks for them).

Yep, that aligns with how I view the ioctls (I haven't read the documentaion,
mainly because I have a terrible habit of never reading docs).

> I can post a patch to fix this or you can add something like that to your
> patch series if you prefer.

Go ahead and post a patch, assuming it's just a documentation update.

