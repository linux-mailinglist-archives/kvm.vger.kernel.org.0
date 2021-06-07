Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183FA39D819
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 11:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhFGJEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 05:04:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230320AbhFGJEK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 05:04:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623056539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RFvXIxYex7L7BTPL6RujzTgA4ognaCL/Fmf1PDhW6bQ=;
        b=iiwtGoqKIfy7dhizAMOX2u3oMU/Cj9Xotu91GgAzgfVEEnOjHJ1VaLrNqk44Nh/+9saD1n
        q3/hSyfXl5WnU1Vqwl4wiW4oeuJZ0uFvDyFeCAQU9o4NQNvZHxdE2TCuGW72GrR4K5O/3F
        kvWPoo1eZ8CaVVPS59DNMkS2SIyixG4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-CTm1a-LcN8eDvMggvBm5sw-1; Mon, 07 Jun 2021 05:02:17 -0400
X-MC-Unique: CTm1a-LcN8eDvMggvBm5sw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62826193578C;
        Mon,  7 Jun 2021 09:02:15 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 020101037EA4;
        Mon,  7 Jun 2021 09:02:10 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 1/8] KVM: nVMX: Drop obsolete (and pointless) pdptrs_changed() check
Date:   Mon,  7 Jun 2021 12:01:56 +0300
Message-Id: <20210607090203.133058-2-mlevitsk@redhat.com>
In-Reply-To: <20210607090203.133058-1-mlevitsk@redhat.com>
References: <20210607090203.133058-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Remove the pdptrs_changed() check when loading L2's CR3.  The set of
available registers is always reset when switching VMCSes (see commit
e5d03de5937e, "KVM: nVMX: Reset register cache (available and dirty
masks) on VMCS switch"), thus the "are PDPTRs available" check will
always fail.  And even if it didn't fail, reading guest memory to check
the PDPTRs is just as expensive as reading guest memory to load 'em.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6058a65a6ede..c45189898a64 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1118,11 +1118,9 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 	 * must not be dereferenced.
 	 */
 	if (!nested_ept && is_pae_paging(vcpu) &&
-	    (cr3 != kvm_read_cr3(vcpu) || pdptrs_changed(vcpu))) {
-		if (CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))) {
-			*entry_failure_code = ENTRY_FAIL_PDPTE;
-			return -EINVAL;
-		}
+	    CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))) {
+		*entry_failure_code = ENTRY_FAIL_PDPTE;
+		return -EINVAL;
 	}
 
 	/*
-- 
2.26.3

