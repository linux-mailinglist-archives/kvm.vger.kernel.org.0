Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEFD34F595
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 02:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbhCaAuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 20:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbhCaAtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 20:49:51 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C23DC061574
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 17:49:50 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id c7so346915qka.6
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 17:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=0pQ01a6Xvm310A3j8LcU50M1ntMFUct1qAGwe2for/I=;
        b=M9zMkM0gUqc7cw+RxOeX9G/PPlsC6SW+jLTCgvz0C/xa3gwqK4tgcFoEzmM3OCdLzr
         N2yPBFu/OH3lDcvhkvTonWi9HpbQshUZ8aUT5DqALEfUAoltXzstN7MDFv5FZmY54PQo
         PImKhz1Y2Tg1FhNQKkn6zSzJl3mU4duB7MiiVpe+w+EHXFBnsEl9khGH61hqa9Cj+L1p
         xmFu0rcuNN18H7VVhKb3/U45OPqOWoYJeaNYI/cWh+CSMpxn19fsUAR4rVS6GofJ+e2L
         6xD13vOZxEHX9yng8jrzP/FNmRThNY/mVtW2LOW/VyJipkZyKYfg4HCJ4H/sHogLOmiy
         yVLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=0pQ01a6Xvm310A3j8LcU50M1ntMFUct1qAGwe2for/I=;
        b=puT4OBssE7Rp+TbkOifxPePMJJ8GpkTef/KY7pxKibHUwW7fnV+B9YHTnjIzRhswLG
         KZsvSEYF6QfEsyJ1bqSK+cEdtXQj+6oq81DfWQssRyULjjBoy3Ne5ZLTlDXFjhjUaKWU
         txu/5/BZ6YcMFRKVsfkgv+4kqX5crT7URjuIrtEUP2MglI5V4ST/MRoAmsDxmLfatQv7
         WGMcbnsrBhjdsSZTsOmX2CcVko2SqkBl3hu/FU4qSuKYI1KRJ+Dy7VujFnGNzWHWSGhg
         r3t3+je5fQJAtMlNf96DxR9Ct0BvNfEZuIVRBbMU4t0vCl1O50Oh5utWx78qkL7AYAnH
         DCMA==
X-Gm-Message-State: AOAM533bU0051LY3nMvVNbT7MLgHjuBFI+LJEl1ZkVZtznwN6/duIdfG
        xP6Z4X0UcBJn6p868Kunv7h/+tGzOtA=
X-Google-Smtp-Source: ABdhPJzrR2EtxZGC1kDYZcmX9KPmGp0qbO2gZiVLBiZ0lyQfYYpAA0wJAgSyOkt4jnihlIT9dxUd0jWr8Tc=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:6c6b:5d63:9b3b:4a77])
 (user=seanjc job=sendgmr) by 2002:a05:6214:8c4:: with SMTP id
 da4mr644183qvb.17.1617151789751; Tue, 30 Mar 2021 17:49:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Mar 2021 17:49:42 -0700
In-Reply-To: <20210331004942.2444916-1-seanjc@google.com>
Message-Id: <20210331004942.2444916-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210331004942.2444916-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 2/2] KVM: x86/mmu: Simplify code for aging SPTEs in TDP MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use a basic NOT+AND sequence to clear the Accessed bit in TDP MMU SPTEs,
as opposed to the fancy ffs()+clear_bit() logic that was copied from the
legacy MMU.  The legacy MMU uses clear_bit() because it is operating on
the SPTE itself, i.e. clearing needs to be atomic.  The TDP MMU operates
on a local variable that it later writes to the SPTE, and so doesn't need
to be atomic or even resident in memory.

Opportunistically drop unnecessary initialization of new_spte, it's
guaranteed to be written before being accessed.

Using NOT+AND instead of ffs()+clear_bit() reduces the sequence from:

   0x0000000000058be6 <+134>:	test   %rax,%rax
   0x0000000000058be9 <+137>:	je     0x58bf4 <age_gfn_range+148>
   0x0000000000058beb <+139>:	test   %rax,%rdi
   0x0000000000058bee <+142>:	je     0x58cdc <age_gfn_range+380>
   0x0000000000058bf4 <+148>:	mov    %rdi,0x8(%rsp)
   0x0000000000058bf9 <+153>:	mov    $0xffffffff,%edx
   0x0000000000058bfe <+158>:	bsf    %eax,%edx
   0x0000000000058c01 <+161>:	movslq %edx,%rdx
   0x0000000000058c04 <+164>:	lock btr %rdx,0x8(%rsp)
   0x0000000000058c0b <+171>:	mov    0x8(%rsp),%r15

to:

   0x0000000000058bdd <+125>:	test   %rax,%rax
   0x0000000000058be0 <+128>:	je     0x58beb <age_gfn_range+139>
   0x0000000000058be2 <+130>:	test   %rax,%r8
   0x0000000000058be5 <+133>:	je     0x58cc0 <age_gfn_range+352>
   0x0000000000058beb <+139>:	not    %rax
   0x0000000000058bee <+142>:	and    %r8,%rax
   0x0000000000058bf1 <+145>:	mov    %rax,%r15

thus eliminating several memory accesses, including a locked access.

Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 724088bea4b0..161b77925a19 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -951,7 +951,7 @@ static int age_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
 {
 	struct tdp_iter iter;
 	int young = 0;
-	u64 new_spte = 0;
+	u64 new_spte;
 
 	rcu_read_lock();
 
@@ -966,8 +966,7 @@ static int age_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
 		new_spte = iter.old_spte;
 
 		if (spte_ad_enabled(new_spte)) {
-			clear_bit((ffs(shadow_accessed_mask) - 1),
-				  (unsigned long *)&new_spte);
+			new_spte &= ~shadow_accessed_mask;
 		} else {
 			/*
 			 * Capture the dirty status of the page, so that it doesn't get
-- 
2.31.0.291.g576ba9dcdaf-goog

