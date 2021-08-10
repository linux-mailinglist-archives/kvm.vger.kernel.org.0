Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28B83E84BC
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 22:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbhHJUyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 16:54:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30437 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234201AbhHJUx5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 16:53:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628628814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OzTcjZfHlW39Aas9yZTosyAbxOgz16mh3ir1tTA3rrE=;
        b=gD408CXY2gER42cW3ulqGQv86HFdAoe55qHtRB31gH2RI/NyCA0eWi26f7CqGTxTuQVdC8
        GSYnmyWdYdORWcR3l4WLMKq6f4Y55+fsGddzRv72nAGozFTc4/l/5vmLGeiJnhi9GYvO8L
        pNrqovR/MQj6BxpCa+dzoyjCSfmZlgI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-IenmKrJoOhWpOZ635evpvw-1; Tue, 10 Aug 2021 16:53:32 -0400
X-MC-Unique: IenmKrJoOhWpOZ635evpvw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B556801B3C;
        Tue, 10 Aug 2021 20:53:31 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F398569CBA;
        Tue, 10 Aug 2021 20:53:23 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 07/16] KVM: x86/mmu: allow APICv memslot to be enabled but invisible
Date:   Tue, 10 Aug 2021 23:52:42 +0300
Message-Id: <20210810205251.424103-8-mlevitsk@redhat.com>
In-Reply-To: <20210810205251.424103-1-mlevitsk@redhat.com>
References: <20210810205251.424103-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

on AMD, APIC virtualization needs to dynamicaly inhibit the AVIC in a
response to some events, and this is problematic and not efficient to do by
enabling/disabling the memslot that covers APIC's mmio range.

Plus due to SRCU locking, it makes it more complex to
request AVIC inhibition.

Instead, the APIC memslot will be always enabled, but be invisible
to the guest, such as the MMU code will not install a SPTE for it,
when it is inhibited and instead jump straight to emulating the access.

When inhibiting the AVIC, this SPTE will be zapped.

This code is based on a suggestion from Sean Christopherson:
https://lkml.org/lkml/2021/7/19/2970

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d6ad222f114..bfc94d8bd9f2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3873,11 +3873,24 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 	if (slot && (slot->flags & KVM_MEMSLOT_INVALID))
 		goto out_retry;
 
-	/* Don't expose private memslots to L2. */
-	if (is_guest_mode(vcpu) && !kvm_is_visible_memslot(slot)) {
-		*pfn = KVM_PFN_NOSLOT;
-		*writable = false;
-		return false;
+	if (!kvm_is_visible_memslot(slot)) {
+		/* Don't expose private memslots to L2. */
+		if (is_guest_mode(vcpu)) {
+			*pfn = KVM_PFN_NOSLOT;
+			*writable = false;
+			return false;
+		}
+		/*
+		 * If the APIC access page exists but is disabled, go directly
+		 * to emulation without caching the MMIO access or creating a
+		 * MMIO SPTE.  That way the cache doesn't need to be purged
+		 * when the AVIC is re-enabled.
+		 */
+		if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
+		    !kvm_apicv_activated(vcpu->kvm)) {
+			*r = RET_PF_EMULATE;
+			return true;
+		}
 	}
 
 	async = false;
-- 
2.26.3

