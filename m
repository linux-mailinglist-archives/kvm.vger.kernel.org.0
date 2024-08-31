Return-Path: <kvm+bounces-25617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8E2C966D80
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:25:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F3B81F21A4A
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:25:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01F7C45BEF;
	Sat, 31 Aug 2024 00:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ayDPa94W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67BB79FD
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063752; cv=none; b=AM7TS4My7Rvn0inul2HHSQznVtKcD6D3SFH81uo2REfCm5hNtUEi2SwvkzMtSfaggTamqDlVzGs+ILGmqcNWLFXiqENtxzKqKCAxR3FXGk95iy2KW3Cm94w4upq2lc9bo5gRGL+lVZfWnKKU8P/o8YbfngDu08D4LsU0DaUrgms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063752; c=relaxed/simple;
	bh=fWpWQPA95IPGIQkDKTyjlkmNaVVzA1qb791N30Rg0zk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nm9/q2yfQ1q3oRIC+W/D+D4Ypny+2pxRJwGA9cINSFRbo3K4TTTksnX+758+ftJqQvrTGu0EbRI9ezRdvKQjvj8fUBWLzNrNxBHkdXbmn+f/khSBdB7URim1KQ9w3bgEwS+/UdjCbjudIbv5ArkJ0oKHe+FRnraASJIl7AdOkFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ayDPa94W; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e02a4de4f4eso4563159276.1
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063750; x=1725668550; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=njo7PyLwOnLnfzTk1Lawe2PiQh7NoMsTGiysrxTefNo=;
        b=ayDPa94WrAVNuFHO2O1V6jEoCth+zLVr6kmHvzJ7cTOnyKZFtK8ZTp8Qu4QXLstz3d
         ZcriLscW1gIMvIejl85lf2CSScROXMH8uA1qkLy3AEMUoocAYPMwhfAtQqCGGKKjkobY
         xif0cw+wFdsj6DemgaEiOM/N1C35eQM3l4jzvTXTPMhgggBOiPUOnaLX3PR8Qt4JVcgh
         rzmBGO5Pn0jk369Qp2cRJVDrEJ6bPdr+mQDscAy6QtrOy8p0wgXv1hSER2v/cdZFO+6F
         9IhgGMQ5dud6AgRs1cheucOEhRaHyLPyOg0xj/JjSbmIkKX0jzmKq01lKCNeOLeiFebX
         KbWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063750; x=1725668550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=njo7PyLwOnLnfzTk1Lawe2PiQh7NoMsTGiysrxTefNo=;
        b=cE9lEQfCl9PjSGI4GJAaZak7n4ol7SmWVRi9Cub9S0V3bItnm6c4icvmR3trdlShuA
         dhKfySheYUlyFlWTMCFlUDHiNGjeIi7ltitfCuxZ0lwfatF6E7i82N9gyUAs7fLoSOnr
         n51NjAk2PpcqEJt6LdIDsZxhRx69bH/RxZE9duVI/Ukxr3AG8QbvKidA6c4j6z8FK7ZP
         D0w//jbcNQcs9Xf32FcLdBB3hjg9T/UAv6HvIeCjx8XtZWzEIxUVJeBaMxMnv2x5mkzq
         dtvow3tZnfDlcJp79duX95UWTKyc4IlP9sp3oRd3kgd8jzA1d/T84MmgaCskVkH60a4X
         0QWw==
X-Gm-Message-State: AOJu0YxkXzkwPP+FimzKRiIpKwgoVQKzOlrwRJwhLr+XO2ZMH2hgwJWN
	zdHVnXFbQJO/dWUV/UKjuxCsMWx1/BVAxFrHu3GjpNfiS7oqqv4i1oo4M3OvzPHI7HPtPBVjMz+
	gFg==
X-Google-Smtp-Source: AGHT+IEui7FBiE9u2FThcn1PeAaV0uNxeSn+BFUq/rFJRRo3ixDwIuue6J6qs/Yvqrt8s5shTST1GTWMl14=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b612:0:b0:e03:3cfa:1aa7 with SMTP id
 3f1490d57ef6-e1a79fb5333mr6385276.1.1725063749897; Fri, 30 Aug 2024 17:22:29
 -0700 (PDT)
Date: Fri, 30 Aug 2024 17:21:09 -0700
In-Reply-To: <20240720000138.3027780-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240720000138.3027780-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <172506347147.337933.13850159673543308459.b4-ty@google.com>
Subject: Re: [PATCH 0/6] KVM: nVMX: Fix IPIv vs. nested posted interrupts
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Zeng Guang <guang.zeng@intel.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 19 Jul 2024 17:01:32 -0700, Sean Christopherson wrote:
> Fix a bug where KVM injects L2's nested posted interrupt into L1 as a
> nested VM-Exit instead of triggering PI processing.  The actual bug is
> technically a generic nested posted interrupts problem, but due to the
> way that KVM handles interrupt delivery, I'm 99.9% certain the issue is
> limited to IPI virtualization being enabled.
> 
> Found by the nested posted interrupt KUT test on SPR.
> 
> [...]

Applied to kvm-x86 vmx, with a massaged changelog to clarify that this bug could
be hit even without IPI virtualization.

[1/6] KVM: nVMX: Get to-be-acknowledge IRQ for nested VM-Exit at injection site
      https://github.com/kvm-x86/linux/commit/6f373f4d941b
[2/6] KVM: nVMX: Suppress external interrupt VM-Exit injection if there's no IRQ
      https://github.com/kvm-x86/linux/commit/cb14e454add0
[3/6] KVM: x86: Don't move VMX's nested PI notification vector from IRR to ISR
      https://github.com/kvm-x86/linux/commit/f729851189d5
[4/6] KVM: nVMX: Track nested_vmx.posted_intr_nv as a signed int
      https://github.com/kvm-x86/linux/commit/ab9cbe044f83
[5/6] KVM: nVMX: Explicitly invalidate posted_intr_nv if PI is disabled at VM-Enter
      https://github.com/kvm-x86/linux/commit/be02aa1e52d2
[6/6] KVM: nVMX: Detect nested posted interrupt NV at nested VM-Exit injection
      https://github.com/kvm-x86/linux/commit/44518120c4ca

--
https://github.com/kvm-x86/linux/tree/next

