Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4FBD1ACC5E
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 18:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897248AbgDPP7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 11:59:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44261 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2896263AbgDPP7G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 11:59:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587052744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EN/H+dURYVmdO4EXHtSzJA+fcODs32+NBiRjW8BRIZw=;
        b=Zlr45w+CuG4go0NRRvN4Vf9xqmZh55ctTuS0egCxmfVFU8k7iYt+is5QOyf6ls0QDsSMSN
        oncKAAMPrBCWjZf/KUCkyq22Huemi/wmQxzNJw/TSq34K/G3GNBIAPu8S0ETN5ZAzwgDOe
        bBYrdypxtGOyN31VLZINn/rJwx0YAuQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-mUZs85VYM9a1XAM7kBrTKQ-1; Thu, 16 Apr 2020 11:59:02 -0400
X-MC-Unique: mUZs85VYM9a1XAM7kBrTKQ-1
Received: by mail-qt1-f200.google.com with SMTP id x56so19556925qtc.10
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 08:59:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EN/H+dURYVmdO4EXHtSzJA+fcODs32+NBiRjW8BRIZw=;
        b=SVg4qT5KW8EWZmUn488J0tRs3jXypJsfFKxfKEpEcCXhb5bDkLGyGjk3u63134xTH8
         GEAsg9rKgEnyFezyPWa81YVHHNOWE+8tqCamERnb+/g3QDYm90/W1w6TXYxxRq9aFVFv
         dKEPIGQd9YnZ1ybBvtjfC4/43VCnewbyCx8kz3+AnUIdh5vQB6jn+2wVznjPADnjChK1
         OBWKHi/qDfZugsw9QZyot3UA1DLuoJ0hawxPBX2+HkDjavUi9/4UQ1U/3P39InV4da4d
         hRO/ada2/H3P+dhqmJH6upy6eIAsQlzOrTg9tVpBfXPlf23v2a5xLZ0ZvvdtFvrpMNNS
         fwzg==
X-Gm-Message-State: AGi0PuZ9/xhO6LxvyKP3EJxfG6oSuIzYDAlhkoUGp4m0UFAr1PPsFybN
        UomCwrOP4PPdSKnMOhlpBRsm35QLcHOb6c6NVEQ4a8cZ0xcXhr3SjwBXYs+NWkhHmYU2ZyP0bzy
        56FkM0mcqbAak
X-Received: by 2002:ad4:54c3:: with SMTP id j3mr10822714qvx.241.1587052741879;
        Thu, 16 Apr 2020 08:59:01 -0700 (PDT)
X-Google-Smtp-Source: APiQypLDBUNGHmlOG11XrkWQ/pjAZwIDGioryxCRlW/eA5eQmopOir38iknIpUxnuvqlVuyvruM8dw==
X-Received: by 2002:ad4:54c3:: with SMTP id j3mr10822694qvx.241.1587052741558;
        Thu, 16 Apr 2020 08:59:01 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id h13sm14752239qkj.21.2020.04.16.08.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 08:59:00 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com
Subject: [PATCH] KVM: X86: Force ASYNC_PF_PER_VCPU to be power of two
Date:   Thu, 16 Apr 2020 11:58:59 -0400
Message-Id: <20200416155859.267366-1-peterx@redhat.com>
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

