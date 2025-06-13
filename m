Return-Path: <kvm+bounces-49539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46B98AD983B
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 00:29:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0429D16DA0E
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 22:29:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81EE528DEFF;
	Fri, 13 Jun 2025 22:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CrR0hz8m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505A9153BE8
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 22:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749853762; cv=none; b=AwMZ8FxvyDFLIk24ToGhZ3yv/jpfVXBGVLBcgpbbrUI7jhh8XO5n9K5JSWwtUtRiWuEH2jph1oibCIIQuUt+0zWDMo29Prmm9NzuwmB4m5dSNHCgmyKfgP9p1Ca9BjvQ15s644n04mJWsLFfFxK7q9Ok/pTbD9OZfQAScXPffZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749853762; c=relaxed/simple;
	bh=7dCRP5RC5vW665I3kmTd5GcphWE+dNmrueqC0walbck=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jVWu5L2Zz6RwmA6edzkO336wPpsfJxnza0pX9fKV1e/4FBa/tri0+orz9l7qol5yGTRMfQ33wgzS6QyM0ANP4tCEUjV4nKLfw8Iah6n0AMf6z9Y0bVZcwzulyQj3Ed/t6pXFWxa/UvBYjxnPqv4i0G5TxbJn2LARi8qqlK1LHJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CrR0hz8m; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30a59538b17so2471184a91.3
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 15:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749853760; x=1750458560; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ntrF63Vv2zoH9u2B2bhtc6n4yroInyt7sGzPvAgo8Rk=;
        b=CrR0hz8mdmzWNoevcFIiL0BXOwYdobJn9kLJUVj8ID21WkH/byxo6YSFDncLoZZLJu
         5qVAAJHARoCaSw0mq89Iz+5NcYVH9S2TSA0/8bh9+tfA5oxctk4H1VIZqZZgwT71jDVF
         rNnyly+WCB5Yt2/NxxEhNe4PoZpCIRFiP2MgNFuRrySP9c7i3mwAVxEZi/8154/cNSab
         AHwVpOcUCBab3RbytavDuO3r3z2pGtrj/6oK6JYzRsv6CAqwZYqjodCJK+J6QliJCKY1
         UhzFH3mcL4t9H/jY0IN7OgrFb3ziY0Bj940ZDLWu/jR2SDqNsObzs1n4xPMz3fPW+Mw+
         7Tug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749853760; x=1750458560;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ntrF63Vv2zoH9u2B2bhtc6n4yroInyt7sGzPvAgo8Rk=;
        b=da6vhPwHTBXmAPiZlhZ88O+bRqR27hQW76PJmL1lVo4uN1EpO6xmJ7Pse6N9mtnygT
         rN+QDYWjRHmreu4PR4FFNCFMooD7gtygYrP0ghCZ58IeBiU4g9iNBjPLbGfH5dCpJyBl
         6IrTsv5DGRmQOtvRLy1xJG/1rIi8kTalsgLj05QzzcwTSDFB0GhVqfhnaNrTYHW+7X4X
         1sWWXw1kk/Z8TjDwV2C7xlkd+qGOhLBjbnIF0IMBP0op0R15DUyRiff7Y44/EX+LW3PJ
         J6Ra1Uesm3IzQuBa8fdm4y3f0N0IVft1a7IzLk8eetGo1iSjrm8K9bIW7rE8/k7jGrIT
         6RlQ==
X-Forwarded-Encrypted: i=1; AJvYcCU76El40XRjtcCI3mwLHGda8gxcPbTCBd9JnlNuZMIGQ9XLyyiTuH+EvbIE0PA7HbF3c34=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7r68bdAcw52Yx7Of+XSER0xNYcvRe9bSWPiBExJPeswyWiKkd
	JDXWyKqF5VDEuQPpRnNRxOJpNUIpqAIKwM6hPyX+he48hATm4Ib1KyEXgHFkaEru+xTJbItByZC
	bxSlTJg==
X-Google-Smtp-Source: AGHT+IGywTlpl0dHWnufpJSJlj4XpNlHL6UkXqc9RZbcriTQyKRR+zlmrTb17NJPljis76xDw4xc0g5PFgU=
X-Received: from pjbsr4.prod.google.com ([2002:a17:90b:4e84:b0:313:2ad9:17ec])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dd2:b0:312:f88d:25f9
 with SMTP id 98e67ed59e1d1-313f1c7dacfmr2043479a91.7.1749853760694; Fri, 13
 Jun 2025 15:29:20 -0700 (PDT)
Date: Fri, 13 Jun 2025 15:29:19 -0700
In-Reply-To: <20250612-70c2e573983d05c4fbc41102@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <50989f0a02790f9d7dc804c2ade6387c4e7fbdbc.1749634392.git.zhouquan@iscas.ac.cn>
 <20250611-352bef23df9a4ec55fe5cb68@orel> <aEmsIOuz3bLwjBW_@google.com> <20250612-70c2e573983d05c4fbc41102@orel>
Message-ID: <aEymPwNM59fafP04@google.com>
Subject: Re: [PATCH] RISC-V: KVM: Avoid re-acquiring memslot in kvm_riscv_gstage_map()
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: zhouquan@iscas.ac.cn, anup@brainfault.org, atishp@atishpatra.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 12, 2025, Andrew Jones wrote:
> On Wed, Jun 11, 2025 at 09:17:36AM -0700, Sean Christopherson wrote:
> > Looks like y'all also have a bug where an -EEXIST will be returned to userspace,
> > and will generate what's probably a spurious kvm_err() message.
> 
> On 32-bit riscv, due to losing the upper bits of the physical address? Or
> is there yet another thing to fix?

Another bug, I think.  gstage_set_pte() returns -EEXIST if a PTE exists, and I
_assume_ that's supposed to be benign?  But this code returns it blindly:

	if (writable) {
		mark_page_dirty(kvm, gfn);
		ret = gstage_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
				      vma_pagesize, false, true);
	} else {
		ret = gstage_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
				      vma_pagesize, true, true);
	}

	if (ret)
		kvm_err("Failed to map in G-stage\n");

out_unlock:
	kvm_release_faultin_page(kvm, page, ret && ret != -EEXIST, writable);
	spin_unlock(&kvm->mmu_lock);
	return ret;

and gstage_page_fault() forwards negative return codes:

	ret = kvm_riscv_gstage_map(vcpu, memslot, fault_addr, hva,
		(trap->scause == EXC_STORE_GUEST_PAGE_FAULT) ? true : false);
	if (ret < 0)
		return ret;

and so eventually -EEXIST will propagate to userspace.

I haven't looked too closely at the RISC-V MMU, but I would be surprised if
encountering what ends up being a spurious fault is completely impossible.

> The diff looks good to me, should I test and post it for you?

If you test it, I'll happily write changelogs and post patches.

