Return-Path: <kvm+bounces-54178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3AFDB1CD0E
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:09:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23096176C6C
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B4812DFA5B;
	Wed,  6 Aug 2025 19:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RiTWC4TC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CD22DE715
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 19:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510317; cv=none; b=S5ImgjOvo/Ppk+2t4M2oCigWH1BL7zg19s0Sl6qp090RCAL4A6OtiS43kPoXQ5cgs8vtqjOkqPD9WJyqPVpJ5qDaicmERAeQQszet1bDgzu8d6pKpRI09wWCkbzM9Szc1JCW8617xHtj6TtphcK0TRVIO7VvdTi53xrxdVWEzM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510317; c=relaxed/simple;
	bh=QVIn0+kukbkiW0o85fHutqEBFnL/lbFRNdNnmVngsXM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nfKOcEyMNOAxpWmdaz41ntW6onv5KoFRaDnXR1mFJyY+u26wIPlTHNBUkhuq8NkGBlqRWQlhtdzTlRAoYgiGk3OmWXPJYHAhtSGVkltuSRk4bx6iQD5Pb5WWb4ywmz3EwWHjWLDZnrgvnhQaq25ctqPI45SRmJmJSIfF67Kp70o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RiTWC4TC; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31bc3128fcso329393a12.0
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 12:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510314; x=1755115114; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Pi5hsDnuks7nSFD8RayInQ9oz1eBhk4hTX7Cx/64BFI=;
        b=RiTWC4TCtRE/O8Sj808HlsXbva7/dbqhOWn5kIqyoN6RBax1pExeHUe5uPG6yHZmxX
         eKTC7+9tGMIqoJJrl9zLgUDu53zHWWna8iIrOB1DYm4bLuc6n4v4efo6ggGDvOkE5fwP
         BmGmMD5drl77+rv5Oz2LloWEfxE3xz5ed8Q6NqOnh5yLmZEtbehAiAYdjAyTnIjIZPXY
         2ojQYxSwjkKj4tjJ1d9nwUdjTqNIxXpttRRY1oGwW2wprtgyS41ZgPUHrCs+J9wLvJ1C
         X6jZVGyXcoAwi3+GbOTWFDtrxelsHsn/I/jwNt66fXiAz8C3rLM/RuDtWBslJnAZj4At
         DF2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510314; x=1755115114;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pi5hsDnuks7nSFD8RayInQ9oz1eBhk4hTX7Cx/64BFI=;
        b=D/L9xy0WvFTqTGKQPidzcPGvlvMMUOReN6Btm42ZMuhqfegRHVZDKm6UyZ5s/G4kWv
         AfLQ7qRl4BM2AvH3FPp28nCw0qTV531FRYx3nBVl8pIUdEoWt54b8LIwAJ3kp9OoBxxp
         LRAQjHDPyT/YZmAPFc6kdnQcbMYb1IO1mRREMWNIWgfPw1Fa+8N+8jJ29ZCWaUOCPCLu
         sEzAN/yN19EcRpFH81UmJnBTf5ah2Hs74/t2r2G0ex16BFgeieOO8guDGko4Wv7pH7mA
         3ppNt/Riux52fFX11JJsVmKsoJpUdrJZ5xuFQUGmSTFDeX3+uOSeh5Rgv4CitdKSuLCH
         W7gQ==
X-Forwarded-Encrypted: i=1; AJvYcCWv3Xm8ECo8lRNs4Fr8sg51oUFNhS2n/VeUf8qTQ2QTdPBmme8RhkQmpabvcoqggiDfh0k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5p2GkoB1aEl8Ujj7LCB1G0B4uwp4HfqLc6wEzUhSGWSU3NslB
	ztY1wcDSxuc2Pv0BvwbGqrmNYpT7iCtpgfQhYg/pqi0C5H2o8msRMFNAD/h7ChjQCM02lD9lsB6
	7FPXytg==
X-Google-Smtp-Source: AGHT+IEJD5GH7UI5TAAlffejmtsOUdJu9B+mpPPWAxLwTCJvZJKLbNbFAds3hHNJ28h7v90ap7LjckKJrbQ=
X-Received: from plhl7.prod.google.com ([2002:a17:903:1207:b0:235:f4e3:ba29])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d581:b0:234:d7b2:2ac3
 with SMTP id d9443c01a7336-2429f2eea48mr59065095ad.20.1754510314065; Wed, 06
 Aug 2025 12:58:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:58 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-37-seanjc@google.com>
Subject: [PATCH v5 36/44] KVM: x86/pmu: Always stuff GuestOnly=1,HostOnly=0
 for mediated PMCs on AMD
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Sandipan Das <sandipan.das@amd.com>

On AMD platforms, there is no way to restore PerfCntrGlobalCtl at
VM-Entry or clear it at VM-Exit. Since the register states will be
restored before entering and saved after exiting guest context, the
counters can keep ticking and even overflow leading to chaos while
still in host context.

To avoid this, intecept event selectors, which is already done by mediated
PMU. In addition, always set the GuestOnly bit and clear the HostOnly bit
for PMU selectors on AMD. Doing so allows the counters run only in guest
context even if their enable bits are still set after VM exit and before
host/guest PMU context switch.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
[sean: massage shortlog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/pmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 9641ef5d0dd7..a5e70a4e7647 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -165,7 +165,8 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		data &= ~pmu->reserved_bits;
 		if (data != pmc->eventsel) {
 			pmc->eventsel = data;
-			pmc->eventsel_hw = data;
+			pmc->eventsel_hw = (data & ~AMD64_EVENTSEL_HOSTONLY) |
+					   AMD64_EVENTSEL_GUESTONLY;
 			kvm_pmu_request_counter_reprogram(pmc);
 		}
 		return 0;
-- 
2.50.1.565.gc32cd1483b-goog


