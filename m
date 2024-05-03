Return-Path: <kvm+bounces-16532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 363F18BB2B1
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 20:20:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6838F1C21268
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 18:20:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC84F158D9A;
	Fri,  3 May 2024 18:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UTtRwsdT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DE7158D7A
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 18:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714760265; cv=none; b=CUD4GMllZihVx+lcOyPXLcS4i3I+xQF6Noy8AXZCM8I89dkj8keCCXQtTPyym/g9nUv6Q/YFLvuPmExLpHdCCoks3cyj7WC2mMvCd1KdOZ17OsHPhigYPoBrTWVTNavs8vQYkQjae5Cy5apOXWmdRtzswlwx6XdhEj0UI7PiYTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714760265; c=relaxed/simple;
	bh=MnH1Wy/qfGLoK8pqY0vb3YbaD+FyQMej5pfO9Kyf6Bw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p3gz+iSNxofBliVClqGBPieoy92297kjSqwBJaCvvG7MzVVjZCJCF/TNiBdts7MBHqCdlmvcmrfJwuMesqkIgF5f7uNNkT1pS7cW7c9tHKV+2ESznNRAcRHcu5VujUJWtvxh5LzTdF1jyE6ToqUWCTgQIWWSWjjeptpcGjPXyA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UTtRwsdT; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61b028ae5easo175890097b3.3
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 11:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714760263; x=1715365063; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XCWz5AboezUKY+fKcSkwtkc56yFvTydQOL6+C1uV1TA=;
        b=UTtRwsdT8uk2thfIcXtPuU7pHscZJWBYeHv7wvyURQSARTlHnNS47ky1LbBwz0blCB
         0maxojdoE78kFdCLmP+U9j89gf+UzWPkc1HPBMb5cZsLFLlkIAT1RiyfPgycKBIIYN/m
         bf/M8giqwWdJmM9kT+zGgGmUpiMQkg5nrXbpb845/aYrXvGvUJ01nrWIFnbndFtN5oJn
         bZ1/hGtwl7ol849efgECnOaJDPuU6QAZSf96V3SmmqmZ/fNbo4LgAKLRlk8xVZXwaQsc
         F/++iDVJsx3+s+OKWIedek4S7FLqsA+i925Kzi/RPg1WKJvg1yTRl7u5A4hS+ouNrgYu
         1O8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714760263; x=1715365063;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XCWz5AboezUKY+fKcSkwtkc56yFvTydQOL6+C1uV1TA=;
        b=Lnq8meM90T15GIgjopsswRG2/lLG30yYhTBLeRTr0D5WGxjIeXIIjNKIQUDpL0zwi5
         Tt6XnyakF9cIMKG0DG2a7Ka03ZKIE7J69xqW0Weab7VtMXpMO9B3pvqwwVnU3axBH9Xq
         GA16pMYKQsT2x43fHgdQxjTqXu1zQ5ZiUEm9JSCyqFqXjvSz+o/m4Y+UIpp9ttRCbhy/
         8YttgMWDV2PyULSx5HWmvJ3w7kQSL4LbDrak38Lu8AtJdB0GdCfxHVAKcs55dC/RHJ1u
         hQ33Q5kvrc9sVUcCIUOh4QD8kLOAlbal2A/y1Da0GIjd1pK062FaDmTlBK+hBKzhGoom
         TLlA==
X-Forwarded-Encrypted: i=1; AJvYcCXuA6Bd/Shqi4H4CW+dAOPHHUG7apFcVSrgurZST+VJ/73JHLj8/e3+k8iZ18uaGoew0Kz1mL2JRm03t2FFoDPu+CMV
X-Gm-Message-State: AOJu0YwyDTs+NASAAN6JkhpO7MHiAhsT0Yjmgja22GsFXAQnAt+9EPg3
	6QA3jVDTet6mQlOe7FEkjrOjPMDKKXQS6WvFo13M4DUUCtD7Fgd80EoF5RWOGUxsEn11M8yXQmK
	l//8Oz2Jsqg==
X-Google-Smtp-Source: AGHT+IG8z91B85kZw12g8ILejBDce9nCeI6uZrPNjYvj7vQXfcVKq57xpnYqIWHHCJ8gvpfpvg4aSbrDSFG7Mg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a0d:ea05:0:b0:61b:7912:6cad with SMTP id
 t5-20020a0dea05000000b0061b79126cadmr815080ywe.2.1714760263504; Fri, 03 May
 2024 11:17:43 -0700 (PDT)
Date: Fri,  3 May 2024 11:17:34 -0700
In-Reply-To: <20240503181734.1467938-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240503181734.1467938-1-dmatlack@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240503181734.1467938-4-dmatlack@google.com>
Subject: [PATCH v3 3/3] KVM: Mark a vCPU as preempted/ready iff it's scheduled
 out while running
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Mark a vCPU as preempted/ready if-and-only-if it's scheduled out while
running. i.e. Do not mark a vCPU preempted/ready if it's scheduled out
during a non-KVM_RUN ioctl() or when userspace is doing KVM_RUN with
immediate_exit.

Commit 54aa83c90198 ("KVM: x86: do not set st->preempted when going back
to user space") stopped marking a vCPU as preempted when returning to
userspace, but if userspace then invokes a KVM vCPU ioctl() that gets
preempted, the vCPU will be marked preempted/ready. This is arguably
incorrect behavior since the vCPU was not actually preempted while the
guest was running, it was preempted while doing something on behalf of
userspace.

This commit also avoids KVM dirtying guest memory after userspace has
paused vCPUs, e.g. for Live Migration, which allows userspace to collect
the final dirty bitmap before or in parallel with saving vCPU state
without having to worry about saving vCPU state triggering writes to
guest memory.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2b29851a90bd..3973e62acc7c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6302,7 +6302,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
-	if (current->on_rq) {
+	if (current->on_rq && vcpu->wants_to_run) {
 		WRITE_ONCE(vcpu->preempted, true);
 		WRITE_ONCE(vcpu->ready, true);
 	}
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


