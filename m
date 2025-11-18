Return-Path: <kvm+bounces-63603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A8F15C6BDD3
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:28:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8386C4EB0F7
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 22:27:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DB16305948;
	Tue, 18 Nov 2025 22:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QJXZlZF/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5DE1DB125
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 22:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763504813; cv=none; b=iXC6jjeRHJwfaH3DFOXV0Jth8GYd0HJUI1zWH4jgI3rtnezarAEEWV8UwAKLcplcMPA74HceuXFQ45qGzD+ou2G+ZD+mmWIk605B0sQXzHF1iyEyUw9RVxTlI7nt1T+dRxFMpPRKSyTzsN1R6G8IcOW9kg9E5PxNYRsL1NkLcWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763504813; c=relaxed/simple;
	bh=lKC2GzZ2PBqnDDez8aXGGCNPFdRZMnmw/MO9I3xljr4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PtZgFQfK7yWwYW72jWvvbCxT3MjOKb+um1dB5igNIn021e6hxPUO7uZTSI5uUZDAsIipezIVl7qRnBVQ2CQCE+z4Lyt+AfoQsyN/FnTnxnvj/Bpdsc1uLbn9G/QRUKEIvhsUUoFjD1NV2wBmw/4yFd+9e7lhommP8tSWDIY7YZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QJXZlZF/; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b993eb2701bso5906005a12.0
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 14:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763504808; x=1764109608; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ECLkgkA6ZFbrCkvAcYP3/Hhbq/WXBSXZ6LP1DTz8CK0=;
        b=QJXZlZF/h8otFRRvL4VxIJljs+z7hGznVcleASKdTbpot8dvJgHZWHNBZKUOyB1hLt
         fQtQKqKt1XKhSD2y+iG/FPvOlQ83nC7YfG38Xkbcd6BKbeURrkMqldFaAVM97nfnmQ3s
         A+Ocb4yp6ntR1vl1cEbRibBvLGZlB/EKOqZADsvEve2+V+gFqK/8p4tbV9/D1jYDmCnc
         keYgGJ/oHwhqigzVBkWvEUffKSCz+Ey0MOIjZdbH3ox5n6y1uoblzRLP5bewMF4NlAkO
         lP2bDZ84ZFJWJ4M4kI8Wlns0dhhMCDjEsRJtRRT7Mzuo4Bq7LZ+pPi0uect4nF0GyZQw
         dXPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763504808; x=1764109608;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ECLkgkA6ZFbrCkvAcYP3/Hhbq/WXBSXZ6LP1DTz8CK0=;
        b=nFbDAMNt20ywvvi75yL+sBLLxkUJwyfRUAgEz9lvhsEKm4aTLQHxa9YcB4ko0H39q8
         rhKnz3SwhRJQFGvKe1a2jRrY8n8VyiLkvQMzaLAi28RR0MTev4RFvxiKvNen7SW/XvTS
         BwtGHY09y56n87a1m3TaCsQf9p8MZZqoHbjGDx6lyp5hwkNgBE423v08vC/Fy0J5Q2Yv
         AfI4/axaCr9o29hZAw7XIYTOd0yHLawqtfuAzNvKab6N2hZ5aq8PNryRDiiR/z6rt5xV
         +BMEcVfkAi8nNuhFYz+DgG4FmT6eU80WL1rUTKJqowz3cLuDVVm7Rrtee5S0fXyEXlz9
         Lxbw==
X-Gm-Message-State: AOJu0Yw9kVNey3+OXt02rcwrKQ9U8Rm8m/FxPypLKLJZxI3Hha7+vb7c
	yaIlcomzzsLYfp0I5DRMQHOLW3TZu6rj3uYLb85N4/JgDkaeHQJ83qCAFtoq3fU5bmX+kZUDOyn
	fQNLzKA==
X-Google-Smtp-Source: AGHT+IHeA/YUIflGp342fMDOTHJty8s41uItnYK6Z8MFlWYk5AXXNl47OEqX7K8EbroB8cHG9KsxSE28Vp0=
X-Received: from pgbfm19.prod.google.com ([2002:a05:6a02:4993:b0:bc9:5eff:ecab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9190:b0:35f:5fc4:d88c
 with SMTP id adf61e73a8af0-35f5fc4dd3fmr11660259637.13.1763504807909; Tue, 18
 Nov 2025 14:26:47 -0800 (PST)
Date: Tue, 18 Nov 2025 14:26:38 -0800
In-Reply-To: <20251114205100.1873640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114205100.1873640-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <176350468545.2266585.9514536047347168878.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH v4 00/18] x86: Improve CET tests
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="utf-8"

On Fri, 14 Nov 2025 12:50:42 -0800, Sean Christopherson wrote:
> Hopefully the last version of this particular CET series.  Mathias, I owe you
> like five beers for root causing and fixing all the gnarly edge cases.
> 
> v4:
>  - Fixup the argumentes for the vmx_cet_test. [Mathias]
>  - Drop "_test" from the vmx_cet config to match the other VMX testcases.
>  - Enable NOTRACK instead of dodging jmp tables in exception_mnemonic() [Mathias].
>  - Reset IBT state after (intentional) #CP. [Mathias]
>  - Fix a changelog typo. [Mathias]
>  - Document that ljmpq isn't supported on AMD. [Mathias]
>  - Use ljmpl to make the 32-bit JMP FAR more obvious. [Mathias]
> 
> [...]

Applied to kvm-x86 next, with fixups for the goofs reported by Mathias.

[01/18] x86: cet: Pass virtual addresses to invlpg
        https://github.com/kvm-x86/kvm-unit-tests/commit/d50f434d3221
[02/18] x86: cet: Remove unnecessary memory zeroing for shadow stack
        https://github.com/kvm-x86/kvm-unit-tests/commit/648aa2c9b31e
[03/18] x86: cet: Directly check for #CP exception in run_in_user()
        https://github.com/kvm-x86/kvm-unit-tests/commit/3194f87894d7
[04/18] x86: cet: Validate #CP error code
        https://github.com/kvm-x86/kvm-unit-tests/commit/2cafa419137c
[05/18] x86: cet: Use report_skip()
        https://github.com/kvm-x86/kvm-unit-tests/commit/7607229f204e
[06/18] x86: cet: Drop unnecessary casting
        https://github.com/kvm-x86/kvm-unit-tests/commit/9981a3a28ad8
[07/18] x86: cet: Validate writing unaligned values to SSP MSR causes #GP
        https://github.com/kvm-x86/kvm-unit-tests/commit/6133fbee3ef7
[08/18] x86: cet: Validate CET states during VMX transitions
        https://github.com/kvm-x86/kvm-unit-tests/commit/986bd380204f
[09/18] x86: cet: Make shadow stack less fragile
        https://github.com/kvm-x86/kvm-unit-tests/commit/00d5543c241b
[10/18] x86: cet: Simplify IBT test
        https://github.com/kvm-x86/kvm-unit-tests/commit/bc0cc3c28b31
[11/18] x86: cet: Use symbolic values for the #CP error codes
        https://github.com/kvm-x86/kvm-unit-tests/commit/5690621f59d6
[12/18] x86: cet: Test far returns too
        https://github.com/kvm-x86/kvm-unit-tests/commit/f472c43a4b64
[13/18] x86: Avoid top-most page for vmalloc on x86-64
        https://github.com/kvm-x86/kvm-unit-tests/commit/63e5bb9be210
[14/18] x86: cet: Run SHSTK and IBT tests as appropriate if either feature is supported
        https://github.com/kvm-x86/kvm-unit-tests/commit/57793a2090f8
[15/18] x86: cet: Drop the "intel_" prefix from the CET testcase
        https://github.com/kvm-x86/kvm-unit-tests/commit/09124b986c65
[16/18] x86: cet: Enable NOTRACK handling for IBT tests
        https://github.com/kvm-x86/kvm-unit-tests/commit/3ba7b9377a7b
[17/18] x86: cet: Reset IBT tracker state on #CP violations
        https://github.com/kvm-x86/kvm-unit-tests/commit/03722f15f4f5
[18/18] x86: cet: Add testcases to verify KVM rejects emulation of CET instructions
        https://github.com/kvm-x86/kvm-unit-tests/commit/cb2b118200c0

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

