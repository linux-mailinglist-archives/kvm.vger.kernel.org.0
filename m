Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2857D41EB4F
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 13:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353755AbhJALDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 07:03:34 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:44008
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353712AbhJALCw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 Oct 2021 07:02:52 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id E430F41979;
        Fri,  1 Oct 2021 11:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633086066;
        bh=dn4OGJN7yHitmsR+lQU1cTUP+QKK1iKnmxAV8VlJ3E4=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=B0bJbg34EwDnjlaPhWwcmqQPjpQfOWCJL/Rj23RKnP3CGG6aHsnYTwQXi0intnf+j
         oz+XONCYLcWbXq3r0eqCeWdkb0qo+YgK9JeurUYiQChx7Rkxn0Of1/eKe0RIS6aV8V
         +NH8/3LdkPkdjuFTPyCjGy/7tqbeNPH/AIVwTGi9Bee0NPO0pM0p5PWL7rizR1pKzZ
         1TVQqrSsmFVhgb94K6PrQNX7CrBmy3YxbbFoHgepiU+VvjFWauQOUJbG6P9EnYw14l
         okFVBzQ1nQHMJoUub95njDBo0XgEqXVYLF46jLTYJ3g5zzFbJywjYsZm/jsU8pq84L
         SHRp+fuZC1s3w==
From:   Colin King <colin.king@canonical.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        David Stevens <stevensd@chromium.org>, kvm@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] KVM: x86: Fix allocation sizeof argument
Date:   Fri,  1 Oct 2021 12:01:06 +0100
Message-Id: <20211001110106.15056-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The allocation for *gfn_track should be for a slot->npages lot of
short integers, however the current allocation is using sizeof(*gfn_track)
and that is the size of a pointer, which is too large. Fix this by
using sizeof(**gfn_track) instead.

Addresses-Coverity: ("Wrong sizeof argument")
Fixes: 35b330bba6a7 ("KVM: x86: only allocate gfn_track when necessary")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 arch/x86/kvm/mmu/page_track.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index bb5d60bd4dbf..5b785a5f7dc9 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -92,7 +92,7 @@ int kvm_page_track_enable_mmu_write_tracking(struct kvm *kvm)
 		slots = __kvm_memslots(kvm, i);
 		kvm_for_each_memslot(slot, slots) {
 			gfn_track = slot->arch.gfn_track + KVM_PAGE_TRACK_WRITE;
-			*gfn_track = kvcalloc(slot->npages, sizeof(*gfn_track),
+			*gfn_track = kvcalloc(slot->npages, sizeof(**gfn_track),
 					      GFP_KERNEL_ACCOUNT);
 			if (*gfn_track == NULL) {
 				mutex_unlock(&kvm->slots_arch_lock);
-- 
2.32.0

