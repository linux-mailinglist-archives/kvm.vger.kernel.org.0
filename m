Return-Path: <kvm+bounces-24666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F0E8958FDD
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 23:44:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D1652827D5
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 21:44:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E153C1C6897;
	Tue, 20 Aug 2024 21:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XTF0gASx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA55528FA
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 21:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724190284; cv=none; b=cvk5Pv7tv9jXfAIN8C2i4RPffPbL7gTYJp1nbl9vnkJ6BUlXMvCexiiNlu90ubH8pHIHyeIu/xyGWFcF2pnU2scw4sSnz2Rje7DfG7a2kCciU2LxMnZICERHKmIviOvfoSIkcC66NCL4IH8YjgOZ0pW2gvBbBIl8OvBjDeJyy+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724190284; c=relaxed/simple;
	bh=aP4KrM9+4EF5s4h9otl18zWOy3LlUIboD2nN1n0bFZU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aQxLU4a/5UE3y6QQKd/wgx48ZYDqjcTgY11EVb98gXR68aeS6ALQ9zyELFvBei7UY4gkQ86NP8YAX8Fwy5QVaLWEv8ciY+/5kJxNn/jAfpTBPICmQ1jpA0KL3d58cHwMTpqMbPe0eM5MTXgolaFedF2s2qwpj267XjycSjBXZ8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XTF0gASx; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6b2822668c2so81286547b3.1
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 14:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724190282; x=1724795082; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PYv2j75wG3egBtpKLiSD2cmG+xJ2pKuG7naloP57nEE=;
        b=XTF0gASxjhCxYf1uRDZpoJSBWrVm55EbNDyrb9hQnhCj7ClJkcGsRC/wp+6ynQfuEY
         FWxvRaGPGsMXeOztOcK9PXGSHfxwmxXJttgok065f7YU63HVYFrlS52LhLubpcO6gwMM
         kcJuh/PTSOdc+jXAA8KkSyVrhfQUSUMX2VEGTYkGN/sx+tG3dPsXG7Up2nm4Q5qwDQBO
         IXLjruFVnMMRqVJVbyIBB0jdxjYjSv2s/cLrwKUONce6NzB/WDZibcaXQz6+PMyOOT+K
         3jR19vKpNk3dWUhQGouK+HEX48BDruYWyoQW33CcTQQMG3i3W2PrzAfwAM9acsOejfxt
         JAVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724190282; x=1724795082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PYv2j75wG3egBtpKLiSD2cmG+xJ2pKuG7naloP57nEE=;
        b=DH4H+i2AdezON+NqYxMf2cInZOxPZXHfIH1SqqhQbwRihc1AAIRDx/N/7798KvtlVM
         WPG6sbf2lwSjP+Lzjywme0QqhoITpRQIGNQiB3J3cbFerUB47Fab1Ra36+9ke5m4CUMJ
         2PSLyO7OJKZ//f+0WC9fr762bKZRZOAjXRqXdvjo/3XamhXch/vRI6dQok/4IV9f8VxC
         tdKARWjv4ZQT5LSK1jP2h3c9avld5CqI2mVyg0Erhh+jOc4ab3G4NErta9a+5rEtZW4U
         c8dwVqOOm2qC9zDp6ZWkuAZ3ih+KY01q/NGHLFlO7g7rEAZZeW3ShTxHJXHbjGEQDjL2
         JaZw==
X-Forwarded-Encrypted: i=1; AJvYcCVf3dY8eF/jYgBdOWHRZaCv/jrjtmjMKzuSyWU9QlE32s/6ebEF1N3t3kz3MltYbZUnXbI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2pFf5FrHATRDqJWqQpWRCPcrYT+t0eZmcHwVc+7MbHhm70v1K
	m9IbPXE29VYFdy4whVTziDl5Ozn/yJmI1gTH49wNI9ixfx+mKgHZYBOqWJpuAo/J8XAXQ39N8Ur
	BdA==
X-Google-Smtp-Source: AGHT+IE8Dz11Sju/O2FrUFKekfvLToFQnobqaUayU+W72dLOXHHpQ+gULsqnBwp7jbpSJ2+uN+vrE6q3LME=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3510:b0:691:3acc:eb2d with SMTP id
 00721157ae682-6c09f6b0518mr319147b3.4.1724190281641; Tue, 20 Aug 2024
 14:44:41 -0700 (PDT)
Date: Tue, 20 Aug 2024 14:44:39 -0700
In-Reply-To: <04f67b56610fc0122f44468d6c330eede67b54d9.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <04f67b56610fc0122f44468d6c330eede67b54d9.camel@infradead.org>
Message-ID: <ZsUOR2Sf2A07U6ox@google.com>
Subject: Re: [PATCH v2] KVM: Move gfn_to_pfn_cache invalidation to
 invalidate_range_end hook
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Mushahid Hussain <hmushi@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 20, 2024, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The existing retry loop in hva_to_pfn_retry() is extremely pessimistic.
> If there are any concurrent invalidations running, it's effectively just
> a complex busy wait loop because its local mmu_notifier_retry_cache()
> function will always return true.
> 
> Since multiple invalidations can be running in parallel, this can result
> in a situation where hva_to_pfn_retry() just backs off and keep retrying
> for ever, not making any progress.
> 
> Solve this by being a bit more selective about when to retry.
> 
> Introduce a separate 'needs invalidation' flag to the GPC, which allows
> it to be marked invalid even while hva_to_pfn_retry() has dropped the
> lock to map the newly-found PFN. This allows the invalidation to moved
> to the range_end hook, and the retry loop only occurs for a given GPC if
> its particular uHVA is affected.
> 
> However, the contract for invalidate_range_{start,end} is not like a
> simple TLB; the pages may have been freed by the time the end hook is
> called. A "device" may not create new mappings after the _start_ hook is
> called. To meet this requirement, hva_to_pfn_retry() now waits until no
> invalidations are currently running which may affect its uHVA, before
> finally setting the ->valid flag and returning.

Please split this into 3 patches:

 1. Add range-based GPC retry
 2. Add the wait mechanism.
 3. Add the needs_invalidation logic.

#1 and #2 make sense to me, but I'm struggling to understanding why #3 is needed.
KVM absolutely must not touch the memory after .invalidate_range_start(), so I
don't see what is gained by deferring invalidation to invalidate_range_end().

