Return-Path: <kvm+bounces-61996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 27D22C326B2
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 18:47:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6700C4ED6AA
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 17:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C06D633C52F;
	Tue,  4 Nov 2025 17:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BrlfU1N1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D41D26562D
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 17:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762278356; cv=none; b=G6AmiTRxRiAnB6rZImRUgc/308+/D3UQsYDVADpuR8eICszNdZejZw7MkQEWca2Bh6teCpqtHeWabsTPvtlJjCP5TiNye74nB1KktoAw0VWu+74C+lub0cvYI5e6x8kmeOpjgf48SyAHw9R52Rxde9qSv1h28YOf1H9M1DzcMcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762278356; c=relaxed/simple;
	bh=ZYOsZxL2IUEUQi9IL/F5rSWxWUDAvv3d/2yLXE/nACE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iAsz7C7kS2DJrfuCAXBgskdHI3XjBOW89ZFdSD6gxxbH3C2Gp+dtVkAYMvHGvs5HjfjvgbG3p6+UyrrMgghFBlAW7wdapPTXbRTdWZBBNKzhHw4YquZs1W6X9lNk8B4Yjjbu5c/u8l5YkGz2xkf/A1MsV7C4/jA3zGja/KRfzFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BrlfU1N1; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340c07119bfso7803958a91.2
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 09:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762278354; x=1762883154; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9/xAx4kN3ROUTUV2Jl/Po33RbfuZxhuxITOjGQyl8+0=;
        b=BrlfU1N11m05sEBwRFxPHPgLNhMb9QpAZL7eTMKOIDu3lmmCR0tXdvGxXgoHDagP1m
         20xXn3Lw2+nnykG3DiOgGYfiIX1D200adPMpU1WhfQpHPtJ8v3mWGjZVvnNaZQA+5Nvm
         6/jz2eUl5I8QVBKhNpkwZpk6fCSR8aQRx/SV4awg9X/CBn2U4MV9uN1Iv1f97//V/e1v
         x4rlv2nLSe4Sj03MDILJ2iPkg/0t7MK2dgtDBDU0qsNoGnxquarJuIOVtYyF2QSKjjMo
         oeBDz6jCA/5iQxDWPEcOElXsX70wIzfUh9rj3VLIHCGNeE8mbr74abHwDD4WLmKFDZsk
         URxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762278354; x=1762883154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9/xAx4kN3ROUTUV2Jl/Po33RbfuZxhuxITOjGQyl8+0=;
        b=ZrD0JSGbaWN90snAwXJrpj8OzN52IisDb566Bft4v6+ZsqHcV7T40GRaMd7r/K3Lk0
         HdXj1AT7oayGaBhIoF8DVsyFqcsA3T4GYsWmDYGTfdDr6LqeLubif4fFmKmc19SUvO5w
         s1GcYqEm03j87mMQKtzXmgahsqwB6zDjFgXLmtNIgkMKK4XUBaWsGAAMI+L9ZSqgaHnn
         2XtnsuN0pNM0DQEwM7/NHpTrw0X8knwEWyqyF/x5WTX+jO+/BgGQSAnw/m6+96ILtt3L
         H+KQ6Ug/3K8ELvlKTATd2Yp6cMk9vLGFRO8srUJNjmI3zQHCOhO3gEcsy5OZG7nh2UoG
         wILw==
X-Forwarded-Encrypted: i=1; AJvYcCURwJCo7XeSbMTyDUrIQ53em0iKMQBKxFAL0+pBBzD5Og01fYdDdEo4MJlKT8ehoFe7EFk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYt6f3Ypa4LUoG3Oa0dQWIEuhXJESEDjl9crbI66LleqbSt9Fe
	/CapgNDQlZVhut1VkUa9W2Y8a9bv30P0Tw/O+tpp0GM9s/bj4e8Yo09k1IPsOGFcaRThwmtU/9F
	i9JTWgA==
X-Google-Smtp-Source: AGHT+IHbbqY213K3DyOfRPQODSW2+ETr6+QF3a9xnk0Mm+lGMKcX25W1Wy4Bq37sp1Hh/GIn/ahciSdHvzY=
X-Received: from pjbnh5.prod.google.com ([2002:a17:90b:3645:b0:330:49f5:c0a7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a81:b0:341:8b42:309e
 with SMTP id 98e67ed59e1d1-341a6e05f1emr17784a91.31.1762278353787; Tue, 04
 Nov 2025 09:45:53 -0800 (PST)
Date: Tue,  4 Nov 2025 09:44:58 -0800
In-Reply-To: <20251030194130.307900-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030194130.307900-1-mlevitsk@redhat.com>
X-Mailer: git-send-email 2.51.2.1006.ga50a493c49-goog
Message-ID: <176227788402.3933803.15173176547209151653.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SVM: switch to raw spinlock for svm->ir_list_lock
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 30 Oct 2025 15:41:30 -0400, Maxim Levitsky wrote:
> svm->ir_list_lock can be taken during __avic_vcpu_put which can be called
> from schedule() via kvm_sched_out.
> 
> Therefore use a raw spinlock instead.
> 
> This fixes the following lockdep warning:
> 
> [...]

Applied to kvm-x86 fixes.  Thanks for doing this, it's been on my todo list for
several months :-)

[1/1] KVM: SVM: switch to raw spinlock for svm->ir_list_lock
      https://github.com/kvm-x86/linux/commit/fd92bd3b4445

--
https://github.com/kvm-x86/linux/tree/next

