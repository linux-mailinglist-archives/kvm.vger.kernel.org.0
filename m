Return-Path: <kvm+bounces-60045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C7C77BDBDA0
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 01:59:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 792FA4F17EB
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 23:59:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8479D2EC0B2;
	Tue, 14 Oct 2025 23:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZqwDYKuk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EAD2E2846
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 23:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760486385; cv=none; b=HSMQxYvAB34X9JSeiDpK/or15/i0mI3ZTDTtMy7cwInq76s9XPu1V4FIOYlZHF8ZjXyUTLEK4dwOXzIae7Azcm7ERL9huPeYlExUFfTp7pAkD+g6L7u3Bi2xQq7WGG+jSpNyKrMdsTiBswm0MJR2ZyhB9oOb4AiQuE6vSp/c9lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760486385; c=relaxed/simple;
	bh=PZScohF8tudD9f+zO9rGSAWZ8mUMGG9nExolI4eclrM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IErc+aUvXiVihQxn9LRKmlR0TdgWdJ2mzHa3+HMb4uzwy0/WUjmjh8Qax1yw+hrC78elm0XyGBW/1EyBQBQoI9+MPKeNI2i04uoX4Bx+35SSCMtL7jIsNxs3+Tcnb16+3BIGFj6okc0eCk28XbG9qVsNYWcmDccpNG/njWsIgpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZqwDYKuk; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b552f91033cso13124754a12.1
        for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 16:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760486383; x=1761091183; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IaDUFIHlyK8oYHhDqlcGNw1DLz8hjMou12ZxOFyoEoI=;
        b=ZqwDYKukY4t/uCkRtSBl2TalvZxH8e8xUH+N+0WRXH8h+7Ct6R4+zfYXoc42E/blUg
         kAjOceNXeeoquWrElJHKWGXLmwuZXuSSnuviIQuM3zW2nFPv8octqYVz9kAc0Y3eqJg2
         ptlz3CYeQpKdi1P2jIc2RsNwh7pGzyFpC15fiXq16J5MWXVtPtJZIa5pRDxpNs0IGEwP
         5BtL6nGPzfClPx+fmqqZFesGJohZJabrSizVDGgEAee5p/6FG5wh95FEv0INZrFCfTXv
         JYuopgZG4f9SuMSRV11gS/t9bspWPygAK+SHX65OdLIGYDmONHQ64NvmqkUt3FulmK8l
         6WfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760486383; x=1761091183;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IaDUFIHlyK8oYHhDqlcGNw1DLz8hjMou12ZxOFyoEoI=;
        b=UIdOUAJIDmV6wDpbkcuW9V7HJe6AqLMjIITYoBrLSsJIBbQqWEesy/oNVgRMdkBUAv
         cGMcjMW4ymtQosVUpNTDWmrj0SGtUZfSbtv/lmsfBuovinzo/kaf+EQD0WFOPPv9hJSd
         VIEO26QjOqtM0+qtge/CFzH8bdYkYv5e4ZotFNye8JMN4siZ4+qpOKcAX+M76ncUvxrR
         JywYmy1QmCvenN7dfJGeIOS/DvsZUelrew7t/6Dt1vF2tO6cGWDms3OeYxSs94496qdu
         Jds3uUbDZ951iSnEUnqXtQzo1zOrxQ5lFvqXzKi6q2KBeb2saedW5TrQ+ICDZXMM3haS
         YLQA==
X-Forwarded-Encrypted: i=1; AJvYcCUho6D9GTEnTZ31GU5FZnTxa6H4QNqYkiCIxIxU65aHgC7nbmGkzJmhZhPZFLxSuNg1J3k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhEpKGfpMmfcUv4biyi+KnWp5pG9ubPg/vQ2fqoc1G3c0XnXQV
	UCzDanhRJFOfB7QPvg8C8NkkRg3bJG7l4BNa7+h9ndvMSDqYckYpFcL/17MyawSZEzZQor+Q6CF
	6XxQx6A==
X-Google-Smtp-Source: AGHT+IHupnMvdgg7F4xvQA/ZOSwtyV+kZZn6LLBAFH6j1PMVTq9dC6yLTtq/O6EeIeGcLmGol6eOpAXKW6k=
X-Received: from pjbci17.prod.google.com ([2002:a17:90a:fc91:b0:33b:51fe:1a7f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38ce:b0:32e:23fe:fa51
 with SMTP id 98e67ed59e1d1-33b511188e7mr35344102a91.9.1760486383558; Tue, 14
 Oct 2025 16:59:43 -0700 (PDT)
Date: Tue, 14 Oct 2025 16:59:42 -0700
In-Reply-To: <20250819152027.1687487-1-lei.chen@smartx.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250819152027.1687487-1-lei.chen@smartx.com>
Message-ID: <aO7j7lcqmL-n599m@google.com>
Subject: Re: [PATCH v1 0/3] kvm:x86: simplify kvmclock update logic
From: Sean Christopherson <seanjc@google.com>
To: Lei Chen <lei.chen@smartx.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 19, 2025, Lei Chen wrote:
> This patch series simplifies kvmclock updating logic by reverting
> related commits.
> 
> Now we have three requests about time updating:
> 
> 1. KVM_REQ_CLOCK_UPDATE:
> The function kvm_guest_time_update gathers info from  master clock
> or host.rdtsc() and update vcpu->arch.hvclock, and then kvmclock or hyperv
> reference counter.
> 
> 2. KVM_REQ_MASTERCLOCK_UPDATE: 
> The function kvm_update_masterclock updates kvm->arch from
> pvclock_gtod_data(a global var updated by timekeeping subsystem), and
> then make KVM_REQ_CLOCK_UPDATE request for each vcpu.
> 
> 3. KVM_REQ_GLOBAL_CLOCK_UPDATE:
> The function kvm_gen_kvmclock_update makes KVM_REQ_CLOCK_UPDATE
> request for each vcpu.
> 
> In the early implementation, functions mentioned above were
> synchronous. But things got complicated since the following commits.
> 
> 1. Commit 7e44e4495a39 ("x86: kvm: rate-limit global clock updates")
> intends to use kvmclock_update_work to sync ntp corretion
> across all vcpus kvmclock, which is based on commit 0061d53daf26f
> ("KVM: x86: limit difference between kvmclock updates")
> 
> 
> 2. Commit 332967a3eac0 ("x86: kvm: introduce periodic global clock
> updates") introduced a 300s-interval work to periodically sync
> ntp corrections across all vcpus.
> 
> I think those commits could be reverted because:
> 1. Since commit 53fafdbb8b21 ("KVM: x86: switch KVMCLOCK base to
> monotonic raw clock"), kvmclock switched to mono raw clock,
> Those two commits could be reverted.
> 
> 2. the periodic work introduced from commit 332967a3eac0 ("x86:
> kvm: introduce periodic global clock updates") always does 
> nothing for normal scenarios. If some exceptions happen,
> the corresponding logic makes right CLOCK_UPDATE request for right vcpus.
> The following shows what exceptions might happen and how they are
> handled.
> (1). cpu_tsc_khz changed
>    __kvmclock_cpufreq_notifier makes KVM_REQ_CLOCK_UPDATE request
> (2). use/unuse master clock 
>    kvm_track_tsc_matching makes KVM_REQ_MASTERCLOCK_UPDATE, which means
>    KVM_REQ_CLOCK_UPDATE for each vcpu.
> (3). guest writes MSR_IA32_TSC
>    kvm_synchronize_tsc will handle it and finally call
>    kvm_track_tsc_matching to make everything well.
> (4). enable/disable tsc_catchup
>    kvm_arch_vcpu_load and bottom half of vcpu_enter_guest makes
>    KVM_REQ_CLOCK_UPDATE request
> 
> Really happy for your comments, thanks.
> 
> Related links:
> https://lkml.indiana.edu/hypermail/linux/kernel/2310.0/04217.html
> https://patchew.org/linux/20240522001817.619072-1-dwmw2@infradead.org/20240522001817.619072-20-dwmw2@infradead.org/

I would love, love, *love* to kill of this code, and the justification looks sane
to me, but I am genuinely not knowledgeable enough in this area to judge whether
or not this is correct/desirable going forward.

Paolo?

