Return-Path: <kvm+bounces-65788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9678ECB6918
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 17:53:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 49BE830274F4
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 16:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E5C6314D12;
	Thu, 11 Dec 2025 16:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3W1RkVw/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CFB31197E
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 16:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765471319; cv=none; b=sdRYA1IQPqMl0OkZNcEsKmLiKUJUDbbUhTQZuokvo8FXQmeeGxGxJLKWwutkZWtwuUYDniBa05uTVPWlOFn99NJJMszpGRLd3rPlzBa4yGRcotRuq4pDIUQPWhNCEDUU8aHQvProcqpMtP84RZZkym7uZ2CWbGTIXXNzquekm/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765471319; c=relaxed/simple;
	bh=mw/WGoVq8ISXowFzT9LSkYs49ehq9YvxElMsl4GAOOg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=scwiMsjpqELyXZjaLFKfiZr6KAOcxFbZ+JV+2VefuB6MyoW7MwIVxRs/v05vO13e73dVlRF4HcPtFNM/Qw58npVdRyfbYtQWTig+Ivzd3o+GHkqzFUF9bSkcaF7slFPkiyPZskQJFm6zWy76OgtME8kiFjOSuq303sP6XQkEveU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3W1RkVw/; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34a8cdba421so287692a91.2
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 08:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765471317; x=1766076117; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qy2Qvo8bu6qucEmj4ll/FXTKb4tvzqvXrbGxWP8kUj0=;
        b=3W1RkVw/FKrlhE8+FEa81WDwGEabNNXdjTekZDYJPhyXvhyofUL0Ba+Qfq3WBvoTbJ
         Bm1RM24lMEqmE7ypUlxQwam7lKc++BM4El7+Lgs5uEvdPb/8qo6h2Ql1rbJbE17aSVBd
         rynPy/M5o1Q83Sw7rRN4AFZcqKQKPf8EHkuGRxR6OH1XmlQJ+y0CnPfE01u5F3RKhlmM
         52AvZPtnY30qW6kSDX8Ow1hJ2OcUQZtik4kin5RndHPw1hxl9LO7WHfBVyc+06DDdbyS
         bqDduNOZYKD4PWA7FG69yjUCH7OQSEayqp7bKYu5RMcX6+5ortX4m6TP9VFhxlDTxkkR
         aMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765471317; x=1766076117;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qy2Qvo8bu6qucEmj4ll/FXTKb4tvzqvXrbGxWP8kUj0=;
        b=iKUV8Bmpr704y2Loj47CzeO687TiUz+aI+099d1BYA/2HeR8MbdouGpyFQ/sc+tEqb
         /eDjYdfMdz8zhK0RRRhogst/DOGarK6bXrzSGQzTqtbStl2QcBo+Mg6wpSrzxM7aS/hc
         hmghirgCdTzL9MICEmpEDxEe9ozKtkFUSK/d6PgYixx2DzOTIGZH/iaeVGrx1oxJ82N8
         CnoQmXehfdqDnSb//m4wUXsR3jZjFZv3phijy6Qp1YaT40UmgqJoLvO171xMK+fS0sK0
         HrZeC8CsZLhcICg6HjCsGEnjqgKla7C5yV7vdih4TRzs6xOcb/H9vRAM6LASnc7Wn+QR
         K9IQ==
X-Forwarded-Encrypted: i=1; AJvYcCXi1C+g8mTfi/cr8Lv6+kxmMmuCIOn3Qp7/mlS5rPU8O7DCg0e4+lciz+FrA40KyAqL0D8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwR+uZuTh3BapQ7A+cIxacYvi8a8q2qGDNExJGC3tw5OOe+fGH/
	NX26hkv7n64NJQJ5SnAfguPeAAgy8yLdUqRfrtFriq9ROOu6ihLLhXRQK1rhNTHvQ5yM7TmQrqA
	o+DNT2Q==
X-Google-Smtp-Source: AGHT+IG2PG++PRf0d+6rII8a687MJxfFYJvcWBc4EtcYQvnlhnhI3J+lKnwDv5y/Ig9dbyV6XOT5FLA13f0=
X-Received: from pjbnh3.prod.google.com ([2002:a17:90b:3643:b0:340:3e18:b5c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:35cd:b0:343:a631:28a8
 with SMTP id 98e67ed59e1d1-34a728d5754mr6678207a91.37.1765471317385; Thu, 11
 Dec 2025 08:41:57 -0800 (PST)
Date: Thu, 11 Dec 2025 08:41:55 -0800
In-Reply-To: <20251126191736.907963-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251126191736.907963-1-seanjc@google.com>
Message-ID: <aTr0UzqE0tWHBa1g@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/debug: Fix macro definitions for DR7
 local/global enable bits
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 26, 2025, Sean Christopherson wrote:
>  	n = 0;
>  	extern unsigned char hw_bp2;
> -	write_dr0(&hw_bp2);
> +	write_dr2(&hw_bp2);
>  	write_dr6(DR6_BS | DR6_TRAP1);
>  	asm volatile("hw_bp2: nop");
>  	report(n == 1 &&
>  	       db_addr[0] == ((unsigned long)&hw_bp2) &&
> -	       dr6[0] == (DR6_ACTIVE_LOW | DR6_BS | DR6_TRAP0),
> -	       "hw breakpoint (test that dr6.BS is not cleared)");
> +	       dr6[0] == (DR6_ACTIVE_LOW | DR6_BS | DR6_TRAP2),
> +	       "Wanted #DB on 0x%lx w/ DR6 = 0x%lx, got %u #DBs, addr[0] = 0x%lx, DR6 = 0x%lx",
> +	       ((unsigned long)&hw_bp1), DR6_ACTIVE_LOW | DR6_BS | DR6_TRAP2,

Copy+paste fail, this should be hw_bp2.

> +	       n, db_addr[0], dr6[0]);
>  
>  	run_ss_db_test(singlestep_basic);
>  	run_ss_db_test(singlestep_emulated_instructions);
> 
> base-commit: d2dc9294e25a34110feffb497a29c10f7e2a8ceb
> -- 
> 2.52.0.487.g5c8c507ade-goog
> 

