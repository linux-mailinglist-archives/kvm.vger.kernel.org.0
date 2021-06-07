Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565AA39D81C
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 11:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhFGJEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 05:04:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27578 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230378AbhFGJEW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 05:04:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623056551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fmrIcGLs7DyMsD0MtJVPsZQmrmAQW6jU1PhZZbdgL9w=;
        b=AtHMuDKJQXxv6aSi5hWl1cxnsXfkA9qMQrLb0b1kfe6YElalxykBWhiTM7XR0+DEzemtO5
        zI8YyihEALfEWPhbKRy3HvIl4QpljsL5+TN2e3F6NkLhYCIYqStEa5o5M5n3gB+aGDW94W
        +B+S6+eFrFO9eyWiQLEtUnAl4w63JfI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-eQRzzmb4POK9jp13obnUmQ-1; Mon, 07 Jun 2021 05:02:29 -0400
X-MC-Unique: eQRzzmb4POK9jp13obnUmQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80C391020C2E;
        Mon,  7 Jun 2021 09:02:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D15AA1037EA5;
        Mon,  7 Jun 2021 09:02:15 +0000 (UTC)
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
Subject: [PATCH v3 2/8] KVM: nSVM: Drop pointless pdptrs_changed() check on nested transition
Date:   Mon,  7 Jun 2021 12:01:57 +0300
Message-Id: <20210607090203.133058-3-mlevitsk@redhat.com>
In-Reply-To: <20210607090203.133058-1-mlevitsk@redhat.com>
References: <20210607090203.133058-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Remove the "PDPTRs unchanged" check to skip PDPTR loading during nested
SVM transitions as it's not at all an optimization.  Reading guest memory
to get the PDPTRs isn't magically cheaper by doing it in pdptrs_changed(),
and if the PDPTRs did change, KVM will end up doing the read twice.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5e8d8443154e..8f5dbc80f57f 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -391,10 +391,8 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 		return -EINVAL;
 
 	if (!nested_npt && is_pae_paging(vcpu) &&
-	    (cr3 != kvm_read_cr3(vcpu) || pdptrs_changed(vcpu))) {
-		if (CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3)))
-			return -EINVAL;
-	}
+	    CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3)))
+		return -EINVAL;
 
 	/*
 	 * TODO: optimize unconditional TLB flush/MMU sync here and in
-- 
2.26.3

