Return-Path: <kvm+bounces-47371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F24C1AC0D02
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 15:40:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A09F94E0D36
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 13:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FFB028C021;
	Thu, 22 May 2025 13:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I+8a1fqs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C92289360
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 13:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747921229; cv=none; b=qzLOyopr0v2aw+G6LU+QBW6P3C+eqUrIwDnptC4Q4oMz530DA+MVEF83kevDmBEEJCJFIcHvgczYs8QtOp4SznOVj4RfnjcL1OEON88MQUNPWsGcmTRMABn9CoTSdYpt4rmjqoxhTotJjlIoCdb8SjQ9TcXQyyflFv5sXCfLa1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747921229; c=relaxed/simple;
	bh=HIJOUS/SI5zizYzwJsYcPa7qjCgV1iQMnyL/rktJGaM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uzh8xYbqygVx1Zbtg9yxupSpSYr93F717c2+sk7xzkftBh75uhKusIawRzZRCosKlUs9iygr/CjvnQBhuAESPWrvg62vreJuLZoOQj17vIxIyTKKTi8XCRpnUSPQnFa7KXU9r8wTOG8LeOdT/+B+yzZzaCQMfc9O6Zh86v+OoQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I+8a1fqs; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30a29af28d1so6371737a91.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 06:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747921227; x=1748526027; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aqO62Y5pWG1JJqOi/r2q3uFDPeVJg8go7AMfsfoRjEM=;
        b=I+8a1fqseEkpXm17vr8kkFKzpRiMNbiMdPST55FY7IGIZdu0LNdguQabuibySGnO2t
         S1YZ6CNzmgO428sgmKyDq+mLTSb63U43GJr1yta+wNCQsn+ZDzv/0IwP4U9PuG50OwlW
         5HPBWprY22jgL1kVZmSRDRMZubcXWQNSeNqRpeOJjlPchLX0Ke0ge6Ew9INccJutNcG/
         0xd54RLM7Mmh+7y/w4aUO3iM/SqIOprate97CKOUI/oUEiHMgsvdcICGmMSHpIfrIdB2
         IoPeWUBjq7r+DSa7lhMUdutCKHS1LwCKjivlDDCglMOBhsdqmfRDnWDCWNqCjDKsO0H9
         gLFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747921227; x=1748526027;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aqO62Y5pWG1JJqOi/r2q3uFDPeVJg8go7AMfsfoRjEM=;
        b=YvPJk0D1KmTACkLqTLja3ldnI3h0WumJMNtxkYtwGk29s5KMoOVFPNGnQjFOTiKHrn
         4qMBMtuWmrqifdtA+9gGf4TAx3kBz6/yHZTwqXJ7PGCMlTLiBhA1ArRS4RyciQ+G5quF
         0EtgOgqg7sEQ9ScbkRXLXFbzq5/cppwpeUYTer8QEbFu59P2zZsVXG+r4fL5JZuDD6+R
         TQX0tYQzccisWSIPSILtjmbl4+rmfH75Om9rI1tgFA2isJ9c8R18RTLuPkSyhMYnFYiU
         Y6aivm0SAmS/nXsPnFdYKmk221N135YoJbsjm7mTQKxuUyyIBi2y0jHU+04O8DXWW1eX
         GlHA==
X-Gm-Message-State: AOJu0Yymt0fmF9HN910YvQatVG20tFCSR070OetIh3hQLXk5XWNvTjw7
	z01TOryORWkymmpbMWsIy7oSxbNLhyV6cUUUj2obBkVTLxBdeweoFzuKBrExreX1po+lF0plCbJ
	qEKLF9w==
X-Google-Smtp-Source: AGHT+IE64zivoR2emdXwJ1T3MMEGcmnkzNfS2y3g4Vr0ca/KiMD1OOUdmLrhWv278ITvYeVE5xsmeM1Oibc=
X-Received: from pjbee16.prod.google.com ([2002:a17:90a:fc50:b0:2fa:15aa:4d1e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:28c5:b0:2ee:f076:20f1
 with SMTP id 98e67ed59e1d1-30e7d2def4fmr44928647a91.0.1747921227482; Thu, 22
 May 2025 06:40:27 -0700 (PDT)
Date: Thu, 22 May 2025 06:40:25 -0700
In-Reply-To: <918715044bf0aa6fb51ce511667bf7bb4ccbabea.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516215422.2550669-1-seanjc@google.com> <20250516215422.2550669-3-seanjc@google.com>
 <219b6bd5-9afe-4d1c-aaab-03e5c580ce5c@redhat.com> <aCtQlanun-Kaq4NY@google.com>
 <dca247173aace1269ce8512ae2d3797289bb1718.camel@intel.com>
 <aC0MIUOTQbb9-a7k@google.com> <5546ad0e36f667a6b426ef47f1f40aee8d83efc9.camel@intel.com>
 <aC4JZ4ztJiFGVMkB@google.com> <918715044bf0aa6fb51ce511667bf7bb4ccbabea.camel@intel.com>
Message-ID: <aC8pSfEBdHZW9Ze7@google.com>
Subject: Re: [PATCH v3 2/3] KVM: x86: Use kvzalloc() to allocate VM struct
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"vipinsh@google.com" <vipinsh@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 21, 2025, Kai Huang wrote:
> On Wed, 2025-05-21 at 10:12 -0700, Sean Christopherson wrote:
> > > e.g., if we export kvm_x86_ops, we could unwind them.
> > 
> > Maaaybe.  I mean, yes, we could fully unwind kvm_x86_ops, but doing so would make
> > the overall code far more brittle.  E.g. simply updating kvm_x86_ops won't suffice,
> > as the static_calls also need to be patched, and we would have to be very careful
> > not to touch anything in kvm_x86_ops that might have been consumed between here
> > and the call to tdx_bringup().
> 
> Right.  Maybe exporting kvm_ops_update() is better.

A bit, but KVM would still need to be careful not to modify the parts of
vt_x86_ops that have already been consumed.

While I agree that leaving TDX breadcrumbs in kvm_x86_ops when TDX is disabled is
undesirable, the behavior is known, i.e. we know exactly what TDX state is being
left behind.  And failure to load the TDX Module should be very, very rare for
any setup that is actually trying to enable TDX.

Whereas providing a way to modify kvm_x86_ops creates the possibility for "bad"
updates.  KVM's initialization code is a lot like the kernel's boot code (and
probably most bootstrapping code): it's inherently fragile because avoiding
dependencies is practically impossible.

E.g. I ran into a relevant ordering problem[*] just a few days ago, where checking
for VMX capabilities during PMU initialization always failed because the VMCS
config hadn't yet been parsed.  Those types of bugs are especially dangerous
because they're very easy to overlook when modifying existing code, e.g. the
only sign that anything is broken is an optional feature being missing.

[*] https://lore.kernel.org/all/aCU2YEpU0dOk7RTk@google.com

