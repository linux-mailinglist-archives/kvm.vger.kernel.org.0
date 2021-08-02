Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76AB3DDF44
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 20:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbhHBSeH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 14:34:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48173 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230369AbhHBSeH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 14:34:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627929237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ve94S67hgMBvO85m8e37Yshn8SH9uzguaWXbkg9LtFo=;
        b=ItssCNVH14zb3yFWZuPErZJ+TUR7oM4dwQuGOvCFDrcMr8eyUYF6o1slF0YL62Leu6Wfr0
        XYQgfOWNrgZB5bJBuJ1XXWQZ8+E0UQXS4hWZMsAsNQZF++tcjLVFw6LXprNz+jX3zTOfel
        G6bTfy5hzqF1lh2oYpdMQEbIp3goo0g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-b7hc_s_nOiylcJKkXSqBVA-1; Mon, 02 Aug 2021 14:33:55 -0400
X-MC-Unique: b7hc_s_nOiylcJKkXSqBVA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1774801AE7;
        Mon,  2 Aug 2021 18:33:53 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6342C3AE1;
        Mon,  2 Aug 2021 18:33:50 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 05/12] KVM: x86/mmu: allow APICv memslot to be partially enabled
Date:   Mon,  2 Aug 2021 21:33:22 +0300
Message-Id: <20210802183329.2309921-6-mlevitsk@redhat.com>
In-Reply-To: <20210802183329.2309921-1-mlevitsk@redhat.com>
References: <20210802183329.2309921-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

on AMD, APIC virtualization needs to dynamicaly inhibit the AVIC in a
response to some events, and this is problematic and not efficient to do by
enabling/disabling the memslot that covers APIC's mmio range.
Plus due to SRCU locking, it makes it more complex to request AVIC inhibition.

Instead, the APIC memslot will be always enabled, but the MMU code
will not install a SPTE for it, when arch.apic_access_memslot_enabled == false
and instead jump straight to emulating the access.

When inhibiting the AVIC, this SPTE will be zapped.

This code is based on a suggestion from Sean Christopherson:
https://lkml.org/lkml/2021/7/19/2970

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f77f6efd43c..965b562da893 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3857,11 +3857,24 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
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
+		    !vcpu->kvm->arch.apic_access_memslot_enabled) {
+			*r = RET_PF_EMULATE;
+			return true;
+		}
 	}
 
 	async = false;
-- 
2.26.3

