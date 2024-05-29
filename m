Return-Path: <kvm+bounces-18338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95B288D4093
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 23:56:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 078981F23044
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 21:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58BCD1C9ECE;
	Wed, 29 May 2024 21:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N6Xc6pJG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0FE1C9EB2
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 21:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717019750; cv=none; b=GAgFRARvGmU217q3laDHaDEJgQTBt8CYRSdmt630ywhslML+r/w0qEP9z1gxGCqfnxpS1rIDsQGWIvRTuLFE5k4nDeA661BANADpymSnQw/VkCtJ9dnk3tDy+g5Mu/bdJfEGeF+AUZ6p7w/0EMQ+DroNENeyRxczrcivI2wyVZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717019750; c=relaxed/simple;
	bh=UNxJLMGZl1gnRZO6sW+znZ/L8AD9EkiPEE3WJ3MdUgk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Spz1CJMydRLAbREuG8QYLGXF5EBASqSmF8HKi3A65cKp2VSbWhkajb2xGDZPmLCvl0mubv7+jsnGVttoKwkXzLvWO0Zx6AhcBiVzh7Nu9ZU5IuTwLl8htJa/a+jpLU3QW0hYtmazGe8cIHEcbvVtVehkKDo+d/VtPv+xCLlNuL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N6Xc6pJG; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-65e7c88cb40so210853a12.0
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 14:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717019748; x=1717624548; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R0O8RdWVLc2UjPDSDGViR160MauFo82inRxl7GpP6bk=;
        b=N6Xc6pJGN1hqE/dwPJc3oL7khtcgtwG8CekaQBYpOSfhIVrEoD5//mWBne6P4l9zGj
         yFvgwqtmNpDmqHDcTjhmFFSYx1N9Ac4MjCssjpjFeWy+rg9niHrd5CWlcCRJe50tsJKR
         FY11d2Ts0dD17e5hk5uP+zXDm0DfjsstZMDpV7SYNURwn2ZW4/KvfxGyUldY1k8N2aIY
         ZkTzkgjPaKHdmsqadLso8J9IbdsrnspWdFlD3LGuOva2hhrS1VDn8pkEE7/BMqVoj1sU
         bKWPExdgD0cAUTuxn3UlQhfmfwJP/Gwx4+8YQgZzREajKCMPpkZwzbc6sMm0+OcPrjyv
         SaYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717019748; x=1717624548;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R0O8RdWVLc2UjPDSDGViR160MauFo82inRxl7GpP6bk=;
        b=fu/HMnxUtNAKKQgZcvk2nF+0MuLHCNnCiu8B/GMkYP8ESOC7gxbslW4cNfbpv6Pa/V
         wawNV9tfDIkk0zJn64hVIvyFpbSc+RCxt4zC1GmyCrfmH6rV0nW3hEEnbGhyfFNiSKfQ
         1oWV2+zUeC25wRHqe3SNQZkQ4Lj//rE2BO8Q+KNbT/kFG99uoYTLEqiYuyQSd0yMhKkV
         nuLk7zJwQvYusVHYnOjPCR6yhQ2f3qr//WkbuVouKMTLdT+Awa6ipvCoZ4ctcQUHi6pL
         ZlN4Z5dvluyxsbZWTB46pUhvJeRnrEZ8iktJwLfq/JaXyS58VVMcGZgZPXqSnmJsxVwN
         crDA==
X-Forwarded-Encrypted: i=1; AJvYcCUxjPFXLlJzaQSZXZ/3hjjKyPDygWMBH+VMTQwYW93by2zszwj5okwnA7nQnagiM8UpRfBvC0ypIat0BBc1V7VJ8v+7
X-Gm-Message-State: AOJu0YwEHsB+P8njCf2BPz0q5MbBN88vAJ07WLCfzBtnmLXyLqQarub0
	boL8G/K9bZb6mWvrX5kdU/wP/9shTz32fQdaTach+etOEjTcRYgeC5Aah7RdJjWVqWjDwVZGdD0
	/YA==
X-Google-Smtp-Source: AGHT+IGx3SrykKCWRo4963j21qgI5u7l1D5l4vFz5cSTor42JO4rQICXW/WPSO9JICYG6TRZvTrpM8pyR8k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:308:b0:65c:f515:1590 with SMTP id
 41be03b00d2f7-6bfdaf2b2f6mr480a12.11.1717019747924; Wed, 29 May 2024 14:55:47
 -0700 (PDT)
Date: Wed, 29 May 2024 14:55:46 -0700
In-Reply-To: <20240529180510.2295118-5-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240529180510.2295118-1-jthoughton@google.com> <20240529180510.2295118-5-jthoughton@google.com>
Message-ID: <ZlekYljG7KJwblUj@google.com>
Subject: Re: [PATCH v4 4/7] KVM: Move MMU lock acquisition for
 test/clear_young to architecture
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Ankit Agrawal <ankita@nvidia.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Bibo Mao <maobibo@loongson.cn>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Huacai Chen <chenhuacai@kernel.org>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, May 29, 2024, James Houghton wrote:
> For implementation mmu_notifier_{test,clear}_young, the KVM memslot
> walker used to take the MMU lock for us. Now make the architectures
> take it themselves.

Hmm, *forcing* architectures to take mmu_lock is a step backwards.  Rather than
add all of this churn, what about adding CONFIG_KVM_MMU_NOTIFIER_LOCKLESS, e.g.

static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn,
							 unsigned long start,
							 unsigned long end,
							 gfn_handler_t handler)
{
	struct kvm *kvm = mmu_notifier_to_kvm(mn);
	const struct kvm_mmu_notifier_range range = {
		.start		= start,
		.end		= end,
		.handler	= handler,
		.on_lock	= (void *)kvm_null_fn,
		.flush_on_ret	= false,
		.may_block	= false,
		.lockless	= IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_LOCKLESS),
	};

	return __kvm_handle_hva_range(kvm, &range).ret;
}

