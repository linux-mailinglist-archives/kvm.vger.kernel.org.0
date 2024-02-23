Return-Path: <kvm+bounces-9468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 107BE860858
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 02:38:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C67D285AB6
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 01:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 979FA125A7;
	Fri, 23 Feb 2024 01:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ftlW0RCO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEAC125A2
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 01:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708652193; cv=none; b=GIBqxAWiGRvYsLg/ln3qJCn0nKVfNgaZNLOYJDHUJHuCYtyE5netNss6ruUgvpZoxUPczhkxwu6pxFKWJ5VCbGlFdWZDYblIlP9NIjcDGR60yfk6MRrrRRE6eFiUP1x3S7ZTCmgvr43Tp9utfvTb5qiaxpQUyHJCCoJaE6uLODM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708652193; c=relaxed/simple;
	bh=BkoxhNv8YGjeOPf3BxX6PpRyfNMqnk1232GU8+2yKW4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=alziZ2xaaDHMqRhaBB0pM6jOg9hVrwcEWKPbUfuxyE8TvNihYHwWYXMqv0rwnsYwPqZSyEo3hil3Fq7EjThlKBtd1u852Pbv4DGupDmhwtksw6Agy4snXPCy+CrUT8dzdJP5pSLaOejeus0PLtKmhRu9Koksv9OGwMLjqMB5bm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ftlW0RCO; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e37db1a3a0so254803b3a.3
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 17:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708652192; x=1709256992; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8OHMj6uK9aYeUBcJN1mkUfVh2fQ8ZHKv8aBZ9H0/QEM=;
        b=ftlW0RCOvT+4apk53JwCWpSFs45M/JEbKHJQBTFML9YknIAbI5i2MADlrFOL8cUnZh
         S0S1vGJJtesUACw08wMIxk2ec2e5JItk0rQliJ5Li/M9EVVOzuvKJT7Rjw+sHuzQCb7H
         RCsLuD7kKjhjngkuAzyegFMAmTxaj+JbOsOcHzRXW7rXRNWx8zy0itlxw5lXxkGdypKT
         FwNiEcoCzOA1gGuuMUmUcf1MXCFGqXDhA/45+RsQMMKiennqpv6Dznu/WeRysMtlErTX
         pSy+vFUMLlnUnD+VI7BsiGZJuwTScY5k1PiQ8chrr40L57JjqcTIpYDsAgNiuHjOur8w
         6sAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708652192; x=1709256992;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8OHMj6uK9aYeUBcJN1mkUfVh2fQ8ZHKv8aBZ9H0/QEM=;
        b=bjtZWeYK2c6NIxDvhS4UeU8vSOwmB/IiSMMxaKJWaM4VyYYkzyz64eRLpgn7fIoRfN
         gMTZ3n+X9/eBAdoBRd2r3bnc742krQj2UOex8kuCq16npT1shEuhZC8mvOAtJE5eePbU
         Y2ZujgslHpkHkyyPR0P/45l8CYcdRhtG2FtAOnmRIJMoYnLiuyjcSK9iuGfCA+rVxOUp
         x8ty+s5vHNWzAqVtfrzwdmF4rsgo5xRcClgQEzpBntbzOi7bAuFC9kN3HgeHQRlYBN1Q
         MQoxMkdDaMtZAut+PdwZT72WPLjpe0k8ETy9fdCoKB3wJWmNU7oKwAIw/KIM67MI1Xmz
         2RoQ==
X-Gm-Message-State: AOJu0YxWFx6Ep7eKg08Lw+MjpzRHkwUkFL1N9oIBnSbqGwjWE8VuJZJk
	8fSuVvgmwnxcLuFH94R1mFvrynMyqhxboK8n5bM5RUGcY/Pdu5+KMkztc0Fd5/hO6o07UwVlLYd
	obw==
X-Google-Smtp-Source: AGHT+IFp1y3YhiJB1B9/itvUBAxg1qSxumSRsptUuQ6R8T3NlISg4Iqh9ewwhLn9e9Pf6b7LKU0u/n6mcUs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:188b:b0:6e4:8b79:f5be with SMTP id
 x11-20020a056a00188b00b006e48b79f5bemr40447pfh.3.1708652191798; Thu, 22 Feb
 2024 17:36:31 -0800 (PST)
Date: Thu, 22 Feb 2024 17:35:44 -0800
In-Reply-To: <20240110012705.506918-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110012705.506918-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <170864777139.3087243.3610536587641565240.b4-ty@google.com>
Subject: Re: [PATCH 0/6] KVM: x86: Clean up "force immediate exit" code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 09 Jan 2024 17:26:59 -0800, Sean Christopherson wrote:
> Plumb "force_immediate_exit" into the kvm_entry() tracepoint, as
> suggested by Maxim, and then follow that up with cleanups that are made
> possible by having force_immediate_exit made available to .vcpu_run(),
> e.g. VMX can use the on-stack param instead of what is effectively a
> temporary field in vcpu_vmx.
> 
> Sean Christopherson (6):
>   KVM: x86: Plumb "force_immediate_exit" into kvm_entry() tracepoint
>   KVM: VMX: Re-enter guest in fastpath for "spurious" preemption timer
>     exits
>   KVM: VMX: Handle forced exit due to preemption timer in fastpath
>   KVM: x86: Move handling of is_guest_mode() into fastpath exit handlers
>   KVM: VMX: Handle KVM-induced preemption timer exits in fastpath for L2
>   KVM: x86: Fully defer to vendor code to decide how to force immediate
>     exit
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/6] KVM: x86: Plumb "force_immediate_exit" into kvm_entry() tracepoint
      https://github.com/kvm-x86/linux/commit/9c9025ea003a
[2/6] KVM: VMX: Re-enter guest in fastpath for "spurious" preemption timer exits
      https://github.com/kvm-x86/linux/commit/e6b5d16bbd2d
[3/6] KVM: VMX: Handle forced exit due to preemption timer in fastpath
      https://github.com/kvm-x86/linux/commit/11776aa0cfa7
[4/6] KVM: x86: Move handling of is_guest_mode() into fastpath exit handlers
      https://github.com/kvm-x86/linux/commit/bf1a49436ea3
[5/6] KVM: VMX: Handle KVM-induced preemption timer exits in fastpath for L2
      https://github.com/kvm-x86/linux/commit/7b3d1bbf8d68
[6/6] KVM: x86: Fully defer to vendor code to decide how to force immediate exit
      https://github.com/kvm-x86/linux/commit/0ec3d6d1f169

--
https://github.com/kvm-x86/linux/tree/next

