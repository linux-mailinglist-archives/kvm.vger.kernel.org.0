Return-Path: <kvm+bounces-67799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A37E4D146D1
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:40:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 883EB3038374
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EBDC37E302;
	Mon, 12 Jan 2026 17:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kHbzdGMl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F1F36B047
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239591; cv=none; b=QmobgsUNe+Im+Y1cJdlIIxA8NDSU5h8bwYZBLrEFXe0fUwNkHnTsoy3SrwXoxPYTZK36C+8hbrzy91YzexMpGYzVcDdxZMeYbo4V98C+xYXBaOy55IwV2Glc81nWgG+sulL7Me0icHNAT40uvwH6NqxOWFVj5ZZSXBDWo0m8T+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239591; c=relaxed/simple;
	bh=5WOjJJi9GshJrzbNszTXOCjQ/WC3CHWW6Rm24QuGEGg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YFWRVkbTDvyoQaKrF5/pcHEcFARqt4R+TDSbuvOrNHFSLmN9R5/tF7eFtSLag1PVUo9at93T7IBCnwaBskYuIFMy5uHdBAYAgiOB6gihv0U+OdQWBAbLhO82UHpnAmwOhP3//wLN10xixLLYN9CTCsJZ81e28xVvV8SKSOPPbvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kHbzdGMl; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c66cb671fso6531342a91.3
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239589; x=1768844389; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+PjBpIA3ZO3sQJJLy61/+UM/sv023xJCPIJTeEkES88=;
        b=kHbzdGMlyTjsX1hA7hobxNse43C70DQ8vJR+f/0PqsaVlk5DjGoZIbvLo9+k9F+jpW
         SNV9o4dyJV7w1jCWy2ZIux+kxfWPsiZ6rmTNSUmLJLd3VBB92jLYAKOGAwQZSOwDpZsw
         DFKbAcdAM0FJsFNhOzNawApO8ds3PaHDr4IVl+71b8S26lzYx83rq6q60rqo7wLpJjrP
         J38A+9VLkQjYzdfJCmhWngXGsPKcky5kB1ehukTnH6Zele/+o2Ewk1IsGG2yFegVEZ8q
         BemeJJBIWwAU5JfOkiPUjMuOeEM+NFbM7np0W2+LyG+LGSwxSPFgM/6SY+0cEOK9QieG
         vSEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239589; x=1768844389;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+PjBpIA3ZO3sQJJLy61/+UM/sv023xJCPIJTeEkES88=;
        b=CXcqnY0CJOTPbaJkDoVhUkP3QqpRvPkspfZ+LH3f92snjfFlRQFSRXwvqsDcM/thp7
         Qj6J3tUD9sJaFY0SWbE90p7R2OuTq7qJfzQRkXH0e6Py/0imwsEIjgMRrR7p5IBwnOMs
         jKOfyHLyIVQc1A+O0Ch3IwBy9m2J+7EdtnFY8RXOLmT16o0oLvcF44qVwqPMKb4pItSf
         9dPtqzc8jkkQwogYhjdRIQ3P1z1UnVajIcHdN9n7xf4XGSMjbn3qOQYl/ubYTL2FxjW8
         +gpuy30KAmd8aZW22Xefojz6cJr38HhPLh9vbfs1n4vSe4nvHce4srJbynuWqp+54ZF9
         1zjA==
X-Forwarded-Encrypted: i=1; AJvYcCWxl6wHObV3n8wrdH4R1/UUz8UWMPmeWbfJ+KErwowNdSTkYAln8GSyjR8UKzTX4FaM4+Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyC6tnLOXLir722c2miuuERG/1oeT/Uicnz3aiZKPeIl6Sb91y
	ftfxuoJT+5FPB2Qx1uqXes+8qjeFJd3J8oIcY5M8GRRi+h25TdYw7kSuQjtHc86O5pyouQiqjqs
	ws9/WuA==
X-Google-Smtp-Source: AGHT+IF668cUxxhKhGHv90tNvsIeTkhAR6ns6JG1hxt5u/yIlrpHwYKq8uhAaCwc/umnpMOixfg8y4oIB3A=
X-Received: from pjbgk17.prod.google.com ([2002:a17:90b:1191:b0:34c:489a:f4c9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2251:b0:33e:30e8:81cb
 with SMTP id 98e67ed59e1d1-34f68b65ff0mr15047069a91.13.1768239588965; Mon, 12
 Jan 2026 09:39:48 -0800 (PST)
Date: Mon, 12 Jan 2026 09:38:38 -0800
In-Reply-To: <20251205232655.445294-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205232655.445294-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176823927133.1374677.16641795988105461817.b4-ty@google.com>
Subject: Re: [PATCH] KVM: Remove subtle "struct kvm_stats_desc" pseudo-overlay
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"Gustavo A . R . Silva" <gustavoars@kernel.org>
Content-Type: text/plain; charset="utf-8"

On Fri, 05 Dec 2025 15:26:55 -0800, Sean Christopherson wrote:
> Remove KVM's internal pseudo-overlay of kvm_stats_desc, which subtly
> aliases the flexible name[] in the uAPI definition with a fixed-size array
> of the same name.  The unusual embedded structure results in compiler
> warnings due to -Wflex-array-member-not-at-end, and also necessitates an
> extra level of dereferencing in KVM.  To avoid the "overlay", define the
> uAPI structure to have a fixed-size name when building for the kernel.
> 
> [...]

Applied to kvm-x86 generic, thanks!

[1/1] KVM: Remove subtle "struct kvm_stats_desc" pseudo-overlay
      https://github.com/kvm-x86/linux/commit/da142f3d373a

--
https://github.com/kvm-x86/linux/tree/next

