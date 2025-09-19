Return-Path: <kvm+bounces-58249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A902BB8B80E
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:39:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE56317C4F5
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11A342D77E2;
	Fri, 19 Sep 2025 22:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zvazRuNO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B740D2F25E8
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321225; cv=none; b=eXT+vuTrxlVa5U7TQUbyEL0zBW0nCTahqnUoR+W4cowWTkG5pdgKQGiedQh4/gEUx8dab32wl9fACgTyzV+en9A1odqyo4JtP7oewLarZaBHKjA39hAtMui6X9N1zl27n5/thfq+3fmJXe0qL755OC5qtgNjA20/zDbABmbwmbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321225; c=relaxed/simple;
	bh=rpVh75mAWc90Kmd1sQ3vNdQYrlDA6S9Mr25QmozHze0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qLkpUYfkFhAzDg/Shh0w4YjSBgOjm/rN3MeZnYHVYuoBNpZipRu2nJTruZ25AAS7b9t4250lWmDwaAqowt4O0QzXTbhRea64AJWORTbKorxuFrb5Ec7OikYFx8qvyLC9Kx3mlaWPxuSRqPTU8Z5SFw+mTgz2ZVWRhz40Nvf5rC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zvazRuNO; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eaa47c7c8so2578828a91.3
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321223; x=1758926023; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mc4zr64q9I53J/mHWnTuVG/JA2NjeAIyTICHVI5Cnpo=;
        b=zvazRuNOGHo6LAikOd0tQqHr9J0bPVTDSEaa2duifmPuACf0ijxJo7JVgjj0Yg4qaS
         in5+OwYAhZtse0EXbuJ3oh3caoc0KG+8Y2SdXdcifYEe0Z6saCIdUDjAGhFQsCV7BrGw
         EzueDC+I3Tek5KsNA1mE4iZZONYxl9JwfKgSr9YQMgID7K8CZ4ubJvICKPvF8Qma9M2q
         9GA3dDd95TKZmztwd+FXaz3RMfXCDkgGytnnmfOu73ks2O2ZUVi9TZN/XfCgjQDqP/S1
         eJtSvxGb1tMO2zZ2BGqtYk/5Nu+/zbSVhlgE6JHwDoOA9FbflSQzZNJLOcl3QbV6s8PM
         NkUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321223; x=1758926023;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mc4zr64q9I53J/mHWnTuVG/JA2NjeAIyTICHVI5Cnpo=;
        b=Yc33d0uL40UwWP4YamL8LTtZwqCvZ1+LaX8RSX+cNuIpY60etb64e6flo1hxb8tZxs
         VfvV5BsFJmjEsAVnCP6s2AOsp6X5ls7Z/S2MSfyzH7aOsWbFrEz6RWv4rjo1TOLSrJYF
         P0lxoTRi5WlI/05FsjNPfS/Vmn27KBDe3tNnt0IXE/3igOnb0/ULr+nCAl4yX1Lw7i5L
         eKfSIMlP3xp3Ti7s1mq8dnhoPniiM/YfhTmS+Rsd1iqpugz3BpzxnIaO6rlyRyNBpeuu
         pbbyHq+SOgV18G0n2+9XDid2qsnX82rPS+z8dTh+NoVcT5zzGCiD6v42xlHVbxJ2Xs1n
         7KNA==
X-Gm-Message-State: AOJu0Yw1XAlrM7X99RL9yx/tp0pKTreJoacn1FJoGaQLqRpL6NZMEmxj
	nprXcLGgXnRXejnNcyEFdyfSzCMXnOsr667H+LWCccMMPHLj9ov4GCPBHo7tDWfF3mwca9Un7af
	NYI2CkA==
X-Google-Smtp-Source: AGHT+IFZzfIT1j7HXoMnKG/lCB0JXUy1fRMf4Dvka+kZ1wEnhwYNXTXXTxyCpQ0YuRnLk3fG/+zdkO9nUaU=
X-Received: from pjbse5.prod.google.com ([2002:a17:90b:5185:b0:330:852e:2bb6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dce:b0:32e:e186:726d
 with SMTP id 98e67ed59e1d1-3309838e140mr5676352a91.31.1758321223130; Fri, 19
 Sep 2025 15:33:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:28 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-22-seanjc@google.com>
Subject: [PATCH v16 21/51] KVM: x86/mmu: WARN on attempt to check permissions
 for Shadow Stack #PF
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Add PFERR_SS_MASK, a.k.a. Shadow Stack access, and WARN if KVM attempts to
check permissions for a Shadow Stack access as KVM hasn't been taught to
understand the magic Writable=0,Dirty=0 combination that is required for
Shadow Stack accesses, and likely will never learn.  There are no plans to
support Shadow Stacks with the Shadow MMU, and the emulator rejects all
instructions that affect Shadow Stacks, i.e. it should be impossible for
KVM to observe a #PF due to a shadow stack access.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/mmu.h              | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7a7e6356a8dd..554d83ff6135 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -267,6 +267,7 @@ enum x86_intercept_stage;
 #define PFERR_RSVD_MASK		BIT(3)
 #define PFERR_FETCH_MASK	BIT(4)
 #define PFERR_PK_MASK		BIT(5)
+#define PFERR_SS_MASK		BIT(6)
 #define PFERR_SGX_MASK		BIT(15)
 #define PFERR_GUEST_RMP_MASK	BIT_ULL(31)
 #define PFERR_GUEST_FINAL_MASK	BIT_ULL(32)
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index b4b6860ab971..f63074048ec6 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -212,7 +212,7 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 
 	fault = (mmu->permissions[index] >> pte_access) & 1;
 
-	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
+	WARN_ON_ONCE(pfec & (PFERR_PK_MASK | PFERR_SS_MASK | PFERR_RSVD_MASK));
 	if (unlikely(mmu->pkru_mask)) {
 		u32 pkru_bits, offset;
 
-- 
2.51.0.470.ga7dc726c21-goog


