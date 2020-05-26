Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CCB1ACBFF
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 17:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896666AbgDPPxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 11:53:32 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59442 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2896636AbgDPPx2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 11:53:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587052407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EN/H+dURYVmdO4EXHtSzJA+fcODs32+NBiRjW8BRIZw=;
        b=EmBTdn7IVbQYFhdvaK/2Lv8m3DLb18LNhjgbq8X4DF+IhLK338wnQnEy+T9/iCqI3BJZ00
        5pG3CJfuxM7pqb3Fu4gOAL4ljT52pYB7UsVbfiTvVX34v/oWRyn1KhvmJJfgmJP5PCfMpC
        +kF8inTxpzxKZgBO7+CSszyMfqF/Srk=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-uDWLXXCBP6yrAfyK2WVB9A-1; Thu, 16 Apr 2020 11:53:25 -0400
X-MC-Unique: uDWLXXCBP6yrAfyK2WVB9A-1
Received: by mail-qt1-f200.google.com with SMTP id g23so19038668qto.0
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 08:53:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EN/H+dURYVmdO4EXHtSzJA+fcODs32+NBiRjW8BRIZw=;
        b=lV3QqdZzawXUa0H02rk1tGaLnl1BSvEglJ0fU9afEaszGUmYeyewGZfFmM2Lj4gjAX
         ODi1LsOGnH7Zkxsy4p73pF5YYoJR70QSEBH9uFrPPWGLQiW0FSV6WBdMZ5RUmGhWnA5K
         crvfPadBV/0kzmumaflu1py9cypB6D+DFYFTwwLMcsIG7MArJqum0VYJDEEHCpi33Drs
         Ypprsd60dME/L2vl4u/z5Rjo/hCSguhbyonlTiJ2dfmRGC0HL0dHjMfgYkrc4Uy83DNm
         bMAaimXtYTjUCJOomgVpVwsqpGNtP7luGeMVU8sQDYfMnkJYYVv7dVV670PnAWbqmrRr
         hHyg==
X-Gm-Message-State: AGi0PuaBTjLCQXClo+el2QF549xwlWAyxFpbt0idB8yTlS2ccZl1RqXj
        VKZ6LhiFevrTxfsu2EPdw/+Jp//pJvTZ37vsj6z4JgOS4BaZ1Gy3/fMiotPsjcXhDqSwQ4yiAYZ
        9GT9NO3SydFai
X-Received: by 2002:a05:620a:5f1:: with SMTP id z17mr27807341qkg.21.1587052404965;
        Thu, 16 Apr 2020 08:53:24 -0700 (PDT)
X-Google-Smtp-Source: APiQypJm5c/jIx1xNo1oON6lK6lrZ3qH3lLjFF0849VMtJ79LLl88AVumVItnDw+zIip+iHJEbsSeg==
X-Received: by 2002:a05:620a:5f1:: with SMTP id z17mr27807317qkg.21.1587052404735;
        Thu, 16 Apr 2020 08:53:24 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id j2sm11449124qtp.5.2020.04.16.08.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 08:53:24 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com
Subject: [PATCH 1/5] KVM: X86: Force ASYNC_PF_PER_VCPU to be power of two
Date:   Thu, 16 Apr 2020 11:53:22 -0400
Message-Id: <20200416155322.266709-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Forcing the ASYNC_PF_PER_VCPU to be power of two is much easier to be
used rather than calling roundup_pow_of_two() from time to time.  Do
this by adding a BUILD_BUG_ON() inside the hash function.

Another point is that generally async pf does not allow concurrency
over ASYNC_PF_PER_VCPU after all (see kvm_setup_async_pf()), so it
does not make much sense either to have it not a power of two or some
of the entries will definitely be wasted.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/x86.c              | 8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 42a2d0d3984a..9f0fdaacdfa5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -761,7 +761,7 @@ struct kvm_vcpu_arch {
 
 	struct {
 		bool halted;
-		gfn_t gfns[roundup_pow_of_two(ASYNC_PF_PER_VCPU)];
+		gfn_t gfns[ASYNC_PF_PER_VCPU];
 		struct gfn_to_hva_cache data;
 		u64 msr_val;
 		u32 id;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b8124b562dea..fc74dafa72ff 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -261,7 +261,7 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt);
 static inline void kvm_async_pf_hash_reset(struct kvm_vcpu *vcpu)
 {
 	int i;
-	for (i = 0; i < roundup_pow_of_two(ASYNC_PF_PER_VCPU); i++)
+	for (i = 0; i < ASYNC_PF_PER_VCPU; i++)
 		vcpu->arch.apf.gfns[i] = ~0;
 }
 
@@ -10265,12 +10265,14 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 
 static inline u32 kvm_async_pf_hash_fn(gfn_t gfn)
 {
+	BUILD_BUG_ON(!is_power_of_2(ASYNC_PF_PER_VCPU));
+
 	return hash_32(gfn & 0xffffffff, order_base_2(ASYNC_PF_PER_VCPU));
 }
 
 static inline u32 kvm_async_pf_next_probe(u32 key)
 {
-	return (key + 1) & (roundup_pow_of_two(ASYNC_PF_PER_VCPU) - 1);
+	return (key + 1) & (ASYNC_PF_PER_VCPU - 1);
 }
 
 static void kvm_add_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
@@ -10288,7 +10290,7 @@ static u32 kvm_async_pf_gfn_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
 	int i;
 	u32 key = kvm_async_pf_hash_fn(gfn);
 
-	for (i = 0; i < roundup_pow_of_two(ASYNC_PF_PER_VCPU) &&
+	for (i = 0; i < ASYNC_PF_PER_VCPU &&
 		     (vcpu->arch.apf.gfns[key] != gfn &&
 		      vcpu->arch.apf.gfns[key] != ~0); i++)
 		key = kvm_async_pf_next_probe(key);
-- 
2.24.1

